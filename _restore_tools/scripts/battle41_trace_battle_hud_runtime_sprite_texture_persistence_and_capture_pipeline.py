import argparse
import csv
import json
import re
from pathlib import Path

import cv2
import numpy as np
from PIL import Image, ImageDraw

BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")

UNITY_JSON = UNITY_DATA / "BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE_UNITY.json"
COMPONENTS_CSV = UNITY_DATA / "BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE_COMPONENTS.csv"
B29_JSON = UNITY_DATA / "BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05.json"
B29_REPORT_JSON = REPORT_DIR / "BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05_RESULT.json"
B40_JSON = REPORT_DIR / "BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_RESULT.json"
B29_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleHeroListSkillCardBindClip05_1920x1080.png"
B41_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle41HudRuntimeSpriteTexturePersistenceTrace_1920x1080.png"
B41_SEQUENCE_DIR = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "battle41_sequence"
B29_EDITOR = PROJECT / "Assets" / "Editor" / "BattleHeroListSkillCardBindClip05Editor.cs"
B27_EDITOR = PROJECT / "Assets" / "Editor" / "BattleCorrectMapSceneHudPreviewClip05Editor.cs"

OUT_MD = REPORT_DIR / "BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE_RESULT.json"
UNITY_OUT_JSON = UNITY_DATA / "BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE.json"
CONTACT = REPORT_DIR / "BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE_CONTACT_SHEET.jpg"
VIDEO_SEQUENCE = REPORT_DIR / "BATTLE_41_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg"
UNITY_LOG = REPORT_DIR / "BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE.log"


def read_json(path: Path, fallback):
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def count_cmds(path: Path):
    return len(list(path.glob("*.cmd"))) if path.exists() else 0


def extract_video_frames():
    times = [485.0, 485.4, 485.8, 486.2, 486.6, 487.0]
    cap = cv2.VideoCapture(str(VIDEO))
    frames = []
    for t in times:
        cap.set(cv2.CAP_PROP_POS_MSEC, t * 1000)
        ok, frame = cap.read()
        if ok:
            frames.append({"t": t, "bgr": frame})
    cap.release()
    return frames


def load_runtime_frames():
    frames = []
    for i in range(6):
        path = B41_SEQUENCE_DIR / f"Battle41RuntimeContext_{i:02d}_1920x1080.png"
        img = cv2.imread(str(path))
        if img is not None:
            frames.append({"t": 485.0 + i * 0.4, "bgr": img, "path": str(path)})
    if not frames:
        img = cv2.imread(str(B41_CAPTURE))
        if img is not None:
            frames.append({"t": 486.0, "bgr": img, "path": str(B41_CAPTURE)})
    return frames


def code_evidence():
    rows = []
    for path in [B29_EDITOR, B27_EDITOR]:
        if not path.exists():
            continue
        lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
        for i, line in enumerate(lines, 1):
            if any(k in line for k in ["Texture2D", "LoadImage", "Sprite.Create", "image.sprite", "GetComponentsInChildren<Image>", "CanvasRenderer", "SetTexture"]):
                rows.append({"path": str(path.relative_to(BASE)), "line": i, "text": line.strip()[:260]})
    return rows


def fresh_battle29_summary():
    live = read_json(B29_JSON, {})
    report = read_json(B29_REPORT_JSON, {})
    cards = live.get("cards") or report.get("unityLiveSummary", {}).get("cards") or []
    return {
        "status": live.get("status") or report.get("visual_status"),
        "boundHeroCardCount": live.get("boundHeroCardCount") or report.get("unityLiveSummary", {}).get("boundHeroCardCount"),
        "headSpriteBindCount": live.get("headSpriteBindCount") or report.get("unityLiveSummary", {}).get("headSpriteBindCount"),
        "extractedSpriteBindCount": live.get("extractedSpriteBindCount") or report.get("unityLiveSummary", {}).get("extractedSpriteBindCount"),
        "visibleCardImageCount": live.get("visibleCardImageCount") or report.get("unityLiveSummary", {}).get("visibleCardImageCount"),
        "hiddenUnresolvedWhiteDataIconCount": live.get("hiddenUnresolvedWhiteDataIconCount") or report.get("unityLiveSummary", {}).get("hiddenUnresolvedWhiteDataIconCount"),
        "cards": cards,
        "capture": str(B29_CAPTURE),
    }


def capture_metrics(path: Path):
    img = cv2.imread(str(path))
    if img is None:
        return {"captureExists": False}
    total = img.shape[0] * img.shape[1]
    return {
        "captureExists": True,
        "width": int(img.shape[1]),
        "height": int(img.shape[0]),
        "nonBlackPixelRatio": round(float(np.count_nonzero(np.any(img > 20, axis=2))) / total, 6),
    }


def hud_visibility_metrics(candidate_path: Path, reference_path: Path):
    cand = cv2.imread(str(candidate_path))
    ref = cv2.imread(str(reference_path))
    if cand is None or ref is None:
        return {"cameraVisibleBattleHud": False, "reason": "candidate_or_reference_capture_missing"}
    zones = {
        "topHpVs": (slice(0, 260), slice(300, 1620)),
        "bottomCards": (slice(650, 930), slice(560, 1360)),
        "rightControls": (slice(180, 910), slice(1600, 1910)),
    }
    out = {}
    visible_votes = 0
    for name, sl in zones.items():
        ref_zone = ref[sl]
        cand_zone = cand[sl]
        diff = float(np.mean(np.abs(ref_zone.astype(np.float32) - cand_zone.astype(np.float32))) / 255.0)
        try:
            corr = float(np.corrcoef(ref_zone.reshape(-1).astype(float), cand_zone.reshape(-1).astype(float))[0, 1])
        except Exception:
            corr = 0.0
        zone_visible = corr >= 0.55 and diff <= 0.14
        if zone_visible:
            visible_votes += 1
        out[name] = {
            "meanAbsDiffVsBattle29HudReference": round(diff, 6),
            "pixelCorrelationVsBattle29HudReference": round(corr, 6),
            "zoneVisibleByReferenceSimilarity": zone_visible,
        }
    out["cameraVisibleBattleHud"] = visible_votes >= 2 and out["bottomCards"]["zoneVisibleByReferenceSimilarity"]
    out["visibleHudZoneVoteCount"] = visible_votes
    out["reason"] = "HUD/card regions visible by BATTLE29 reference similarity." if out["cameraVisibleBattleHud"] else "HUD/card regions still do not match BATTLE29/clip05 reference visibility."
    return out


def scene_summary_lookup(unity, phase):
    for row in unity.get("summaries", []):
        if row.get("phase") == phase:
            return row
    return {}


def component_stats(rows):
    stats = {}
    for phase in sorted(set(r.get("phase", "") for r in rows)):
        phase_rows = [r for r in rows if r.get("phase") == phase]
        stats[phase] = {
            "rows": len(phase_rows),
            "missingScriptRows": sum(1 for r in phase_rows if "MissingScript" in r.get("componentTypes", "")),
            "canvasRendererRows": sum(1 for r in phase_rows if str(r.get("hasCanvasRenderer", "")).lower() == "true"),
            "graphicRows": sum(1 for r in phase_rows if str(r.get("hasGraphic", "")).lower() == "true"),
            "imageRows": sum(1 for r in phase_rows if str(r.get("hasImage", "")).lower() == "true"),
            "imageLikeRows": sum(1 for r in phase_rows if str(r.get("imageLikeName", "")).lower() == "true"),
            "cardRelatedRows": sum(1 for r in phase_rows if str(r.get("cardRelatedPath", "")).lower() == "true"),
        }
    return stats


def panel_from_bgr(frame, title, size=(320, 180)):
    img = Image.fromarray(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
    img.thumbnail((size[0], size[1] - 30), Image.Resampling.LANCZOS)
    panel = Image.new("RGB", size, (8, 8, 8))
    xoff = (size[0] - img.width) // 2
    panel.paste(img, (xoff, 0))
    ImageDraw.Draw(panel).text((8, size[1] - 22), title, fill=(235, 235, 235))
    return panel


def make_contact(video_frames, runtime_frames, b29_capture, summary):
    top_panels = [panel_from_bgr(f["bgr"], f"video {f['t']:.1f}s", (320, 180)) for f in video_frames]
    top = Image.new("RGB", (320 * max(1, len(top_panels)), 180), (0, 0, 0))
    for i, p in enumerate(top_panels):
        top.paste(p, (i * 320, 0))
    top.save(VIDEO_SEQUENCE, quality=92)

    run_panels = [panel_from_bgr(f["bgr"], f"B41 runtime {i}", (320, 180)) for i, f in enumerate(runtime_frames)]
    runtime_row = Image.new("RGB", (320 * max(1, len(run_panels)), 180), (0, 0, 0))
    for i, p in enumerate(run_panels):
        runtime_row.paste(p, (i * 320, 0))

    b29_panel = Image.new("RGB", (960, 500), (8, 8, 8))
    b29 = cv2.imread(str(b29_capture))
    if b29 is not None:
        b29_panel.paste(panel_from_bgr(b29, "BATTLE29 fresh capture reference", (960, 500)), (0, 0))

    text_panel = Image.new("RGB", (960, 500), (8, 8, 8))
    td = ImageDraw.Draw(text_panel)
    lines = [
        "BATTLE_41 summary",
        f"verdict: {summary['verdict']}",
        f"visual_status: {summary['visual_status']}",
        f"camera-visible HUD: {summary['cameraVisibleBattleHud']}",
        f"B29 fresh visible images: {summary['battle29FreshSummary'].get('visibleCardImageCount')}",
        f"B29 reopen images: {summary['battle29ReopenSummary'].get('imageCount')}",
        f"B41 reopen images: {summary['battle41Summary'].get('reopenAfterSaveImageCount')}",
        f"code evidence rows: {len(summary['runtimeTextureCodeEvidence'])}",
        f"next blocker: {summary['nextBlocker']}",
    ]
    y = 20
    for line in lines:
        td.text((20, y), line, fill=(235, 235, 235))
        y += 30

    sheet = Image.new("RGB", (1920, 180 + 180 + 500), (0, 0, 0))
    sheet.paste(top, (0, 0))
    sheet.paste(runtime_row, (0, 180))
    sheet.paste(b29_panel, (0, 360))
    sheet.paste(text_panel, (960, 360))
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT, quality=92)


def verify(unity_exit_code):
    unity = read_json(UNITY_JSON, {})
    b40 = read_json(B40_JSON, {})
    rows = read_csv(COMPONENTS_CSV)
    video_frames = extract_video_frames()
    runtime_frames = load_runtime_frames()
    fresh = fresh_battle29_summary()
    evidence = code_evidence()
    hud_visibility = hud_visibility_metrics(B41_CAPTURE, B29_CAPTURE)
    b29_reopen = scene_summary_lookup(unity, "battle29_saved_scene_reopen")
    b40_reopen = scene_summary_lookup(unity, "battle40_saved_scene_reopen_before_copy")
    b41_summary = scene_summary_lookup(unity, "battle41_candidate_reopen_after_copy")
    stats = component_stats(rows)

    fresh_visible = int(fresh.get("visibleCardImageCount") or 0)
    reopen_image = int(b29_reopen.get("imageCount") or 0)
    b41_reopen_image = int(b41_summary.get("reopenAfterSaveImageCount") or 0)
    camera_visible_hud = bool(hud_visibility.get("cameraVisibleBattleHud"))

    if unity_exit_code != 0:
        visual_status = "failed_unity_batch_or_compile"
        blocker = "Unity batch/probe did not complete."
        next_blocker = "BATTLE_42_FIX_BATTLE41_COMPILE_OR_BATCH_ERROR"
    elif fresh_visible > 0 and reopen_image == 0 and b41_reopen_image == 0:
        visual_status = "failed_runtime_ui_graphic_image_components_not_serialized_after_scene_reload"
        blocker = "BATTLE29 fresh build reports visible Image/card sprites, but saved scene reopen has 0 resolved Image/Graphic components; Texture2D.LoadImage/Sprite.Create/Image.sprite state is runtime-only and not persistent."
        next_blocker = "BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES"
    elif not camera_visible_hud:
        visual_status = "failed_hud_context_still_not_camera_visible"
        blocker = "HUD/card regions still do not visually match clip05/BATTLE29 reference."
        next_blocker = "BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES"
    else:
        visual_status = "failed_actor_motion_layout_timing_still_unverified_after_hud_persistence"
        blocker = "HUD persistence improved, but actor motion/layout/timing still is not clip05 verified."
        next_blocker = "BATTLE_42_TRACE_ORIGINAL_FORMATION_CAMERA_RUNTIME_BINDING_FOR_ACTOR_CONTEXT"

    result = {
        "verdict": "clip05 actor motion/layout/timing + map/HUD context not reproduced",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "reference_video_used": True,
        "videoTimeRangeSeconds": "485.0-487.0",
        "unityExitCode": unity_exit_code,
        "cameraVisibleBattleHud": camera_visible_hud,
        "hudVisibilityMetrics": hud_visibility,
        "captureMetrics": capture_metrics(B41_CAPTURE),
        "battle29FreshSummary": fresh,
        "battle29ReopenSummary": b29_reopen,
        "battle40ReopenSummary": b40_reopen,
        "battle41Summary": b41_summary,
        "componentStats": stats,
        "runtimeTextureCodeEvidence": evidence,
        "battle40Carryover": {
            "visual_status": b40.get("visual_status"),
            "componentSummary": b40.get("componentSummary"),
            "unitySummary": b40.get("unitySummary"),
        },
        "blocker": blocker,
        "nextBlocker": next_blocker,
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "unityDataJson": str(UNITY_OUT_JSON),
            "unityProbeJson": str(UNITY_JSON),
            "componentsCsv": str(COMPONENTS_CSV),
            "capture": str(B41_CAPTURE),
            "contactSheet": str(CONTACT),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "No fake HUD or debug/path labels were added to the final capture.",
            "BATTLE41 is a persistence/capture-pipeline trace; it does not claim final visual restoration.",
            "BATTLE29 fresh capture remains useful reference, but its runtime Image/Sprite state is not persisted in reopened scenes.",
        ],
    }
    make_contact(video_frames, runtime_frames, B29_CAPTURE, result)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    UNITY_OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_41 Trace Battle HUD Runtime Sprite Texture Persistence And Capture Pipeline Result",
        "",
        "**원본 clip05 actor motion/layout/timing + map/HUD context는 아직 재현 안 됐다.** BATTLE41은 BATTLE29 생성 직후 HUD/card Image 수치와 저장 scene 재오픈 수치를 비교했고, runtime `Texture2D.LoadImage`/`Sprite.Create`/`Image.sprite` 상태가 scene reload 뒤 persistent UI Graphic으로 남지 않는다는 쪽으로 좁혔다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- reference video used: `True` (`플레이.mp4` 485.0-487.0s)",
        f"- camera-visible HUD/cards: `{camera_visible_hud}`",
        f"- Unity exit code: `{unity_exit_code}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Persistence Trace",
        f"- BATTLE29 fresh bound hero cards: `{fresh.get('boundHeroCardCount')}`",
        f"- BATTLE29 fresh visible card Image count: `{fresh.get('visibleCardImageCount')}`",
        f"- BATTLE29 fresh extracted sprite binds: `{fresh.get('extractedSpriteBindCount')}`",
        f"- BATTLE29 saved scene reopen Graphic/Image: `{b29_reopen.get('graphicCount')}` / `{b29_reopen.get('imageCount')}`",
        f"- BATTLE40 saved scene reopen Graphic/Image: `{b40_reopen.get('graphicCount')}` / `{b40_reopen.get('imageCount')}`",
        f"- BATTLE41 save→reopen Graphic/Image: `{b41_summary.get('reopenAfterSaveGraphicCount')}` / `{b41_summary.get('reopenAfterSaveImageCount')}`",
        f"- image-like/card-related transform rows: `{len(rows)}`",
        f"- runtime texture code evidence rows: `{len(evidence)}`",
        "",
        "## Evidence Interpretation",
        "- BATTLE29 build code uses `Texture2D.LoadImage`, `Sprite.Create`, and assigns `image.sprite` on runtime objects.",
        "- Those created Texture2D/Sprite objects are not imported persistent Unity assets, so reopened scenes have transform/canvas evidence but no resolved Image/Graphic render component.",
        "- The next fix must rebuild persistent, evidence-backed HUD Image components and sprites from original prefab/PPtr/sprite evidence, not paste a captured HUD image.",
        "",
        "## Blocker",
        f"- {blocker}",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_OUT_JSON}`",
        f"- Unity probe JSON: `{UNITY_JSON}`",
        f"- components CSV: `{COMPONENTS_CSV}`",
        f"- capture: `{B41_CAPTURE}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Command Policy Check",
        f"- root CMD count: `{result['rootCmdCount']}`",
        f"- `_restore_tools` direct CMD count: `{result['restoreToolsDirectCmdCount']}`",
        "",
        "## Next Blocker",
        f"- `{next_blocker}`",
    ]
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps({
        "visual_status": visual_status,
        "cameraVisibleBattleHud": camera_visible_hud,
        "battle29FreshVisibleCardImageCount": fresh.get("visibleCardImageCount"),
        "battle29ReopenImageCount": b29_reopen.get("imageCount"),
        "battle41ReopenImageCount": b41_summary.get("reopenAfterSaveImageCount"),
        "nextBlocker": next_blocker,
        "rootCmdCount": result["rootCmdCount"],
        "restoreToolsDirectCmdCount": result["restoreToolsDirectCmdCount"],
    }, ensure_ascii=False, indent=2))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("mode", choices=["verify"])
    parser.add_argument("--unity-exit", type=int, default=0)
    args = parser.parse_args()
    verify(args.unity_exit)


if __name__ == "__main__":
    main()
