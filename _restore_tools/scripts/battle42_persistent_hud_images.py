import argparse
import csv
import json
from pathlib import Path

import cv2
import numpy as np
from PIL import Image, ImageDraw

BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")

UNITY_JSON = UNITY_DATA / "BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES_UNITY.json"
ROWS_CSV = UNITY_DATA / "BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES_COMPONENTS.csv"
B41_JSON = REPORT_DIR / "BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE_RESULT.json"
B29_JSON = REPORT_DIR / "BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05_RESULT.json"
B29_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleHeroListSkillCardBindClip05_1920x1080.png"
B42_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle42PersistentBattleHudImagesFromOriginalSpriteEvidence_1920x1080.png"
B42_SEQUENCE_DIR = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "battle42_sequence"

OUT_MD = REPORT_DIR / "BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES_RESULT.json"
CONTACT = REPORT_DIR / "BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES_CONTACT_SHEET.jpg"
GAP_MD = REPORT_DIR / "BATTLE_42_CHARACTER_SKILL_FORMATION_MANIFEST_GAP.md"
UNITY_LOG = REPORT_DIR / "BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES.log"


def read_json(path, fallback):
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def count_cmds(path):
    return len(list(path.glob("*.cmd"))) if path.exists() else 0


def capture_metrics(path):
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


def hud_visibility_metrics(candidate_path, reference_path):
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
    votes = 0
    for name, sl in zones.items():
        ref_zone = ref[sl]
        cand_zone = cand[sl]
        diff = float(np.mean(np.abs(ref_zone.astype(np.float32) - cand_zone.astype(np.float32))) / 255.0)
        try:
            corr = float(np.corrcoef(ref_zone.reshape(-1).astype(float), cand_zone.reshape(-1).astype(float))[0, 1])
        except Exception:
            corr = 0.0
        visible = corr >= 0.55 and diff <= 0.14
        if visible:
            votes += 1
        out[name] = {
            "meanAbsDiffVsBattle29HudReference": round(diff, 6),
            "pixelCorrelationVsBattle29HudReference": round(corr, 6),
            "zoneVisibleByReferenceSimilarity": visible,
        }
    out["visibleHudZoneVoteCount"] = votes
    out["cameraVisibleBattleHud"] = votes >= 2 and out["bottomCards"]["zoneVisibleByReferenceSimilarity"]
    out["reason"] = "HUD/card regions visible by BATTLE29 reference similarity." if out["cameraVisibleBattleHud"] else "HUD/card regions still do not match BATTLE29/clip05 reference visibility."
    return out


def extract_video_frames():
    times = [485.0, 485.4, 485.8, 486.2, 486.6, 487.0]
    cap = cv2.VideoCapture(str(VIDEO))
    frames = []
    for t in times:
        cap.set(cv2.CAP_PROP_POS_MSEC, t * 1000)
        ok, frame = cap.read()
        if ok:
            frames.append((f"video {t:.1f}s", frame))
    cap.release()
    return frames


def runtime_frames():
    frames = []
    for i in range(6):
        path = B42_SEQUENCE_DIR / f"Battle42PersistentHud_{i:02d}_1920x1080.png"
        img = cv2.imread(str(path))
        if img is not None:
            frames.append((f"B42 runtime {i}", img))
    if not frames:
        img = cv2.imread(str(B42_CAPTURE))
        if img is not None:
            frames.append(("B42 capture", img))
    return frames


def panel(label, bgr, size=(320, 180)):
    img = Image.fromarray(cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB))
    img.thumbnail((size[0], size[1] - 28), Image.Resampling.LANCZOS)
    out = Image.new("RGB", size, (8, 8, 8))
    out.paste(img, ((size[0] - img.width) // 2, 0))
    ImageDraw.Draw(out).text((8, size[1] - 21), label, fill=(235, 235, 235))
    return out


def make_contact(result):
    video = [panel(label, frame) for label, frame in extract_video_frames()]
    runtime = [panel(label, frame) for label, frame in runtime_frames()]
    top = Image.new("RGB", (1920, 180), (0, 0, 0))
    if video:
        for i, p in enumerate(video[:6]):
            top.paste(p, (i * 320, 0))
    else:
        draw = ImageDraw.Draw(top)
        draw.text((20, 72), "play video unavailable: C:\\Users\\godho\\Downloads\\플레이.mp4", fill=(235, 235, 235))
        draw.text((20, 102), f"auxiliary reference present: {AUX_VIDEO.exists()} ({AUX_VIDEO})", fill=(235, 235, 235))
    mid = Image.new("RGB", (1920, 180), (0, 0, 0))
    for i, p in enumerate(runtime[:6]):
        mid.paste(p, (i * 320, 0))
    b29_panel = Image.new("RGB", (960, 500), (8, 8, 8))
    b29 = cv2.imread(str(B29_CAPTURE))
    if b29 is not None:
        b29_panel.paste(panel("BATTLE29 fresh reference", b29, (960, 500)), (0, 0))
    text_panel = Image.new("RGB", (960, 500), (8, 8, 8))
    draw = ImageDraw.Draw(text_panel)
    lines = [
        "BATTLE_42 summary",
        f"visual_status: {result['visual_status']}",
        f"final restored: {result['isFinalRestoredBattleScreen']}",
        f"markers: {result['unitySummary'].get('originalSpriteMarkerCount')}",
        f"rebuilt images: {result['unitySummary'].get('reconstructedImageCount')}",
        f"reopen Image/Graphic: {result['unitySummary'].get('reopenImageCount')} / {result['unitySummary'].get('reopenGraphicCount')}",
        f"reopen active graphics: {result['unitySummary'].get('reopenActiveGraphicCount')}",
        f"camera-visible HUD: {result['cameraVisibleBattleHud']}",
        f"next blocker: {result['nextBlocker']}",
    ]
    y = 20
    for line in lines:
        draw.text((20, y), line, fill=(235, 235, 235))
        y += 30
    sheet = Image.new("RGB", (1920, 860), (0, 0, 0))
    sheet.paste(top, (0, 0))
    sheet.paste(mid, (0, 180))
    sheet.paste(b29_panel, (0, 360))
    sheet.paste(text_panel, (960, 360))
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT, quality=92)


def write_gap_report(rows, unity):
    bound = [r for r in rows if r.get("status") == "persistent_image_sprite_bound"]
    active_bound = [r for r in bound if str(r.get("activeInHierarchy", "")).lower() == "true"]
    hero_head_bound = [r for r in bound if "head" in (r.get("spriteName", "").lower() + r.get("name", "").lower())]
    skill_like = [r for r in bound if any(k in (r.get("path", "") + r.get("spriteName", "")).lower() for k in ["skill", "fury", "anger", "bigskill", "smallskill"])]
    formation_like = [r for r in bound if any(k in (r.get("path", "") + r.get("spriteName", "")).lower() for k in ["formation", "heroitem", "herolist", "pos", "battle29boundherocard"])]
    md = [
        "# BATTLE_42 Character Skill Formation Manifest Gap",
        "",
        "## Current Evidence Filled",
        f"- persistent HUD sprite marker rows bound: `{len(bound)}`",
        f"- active-in-hierarchy bound rows: `{len(active_bound)}`",
        f"- hero/head-like rows: `{len(hero_head_bound)}`",
        f"- skill/fury-like rows: `{len(skill_like)}`",
        f"- formation/card-like rows: `{len(formation_like)}`",
        f"- reopened Image/Graphic rows: `{unity.get('reopenImageCount')}` / `{unity.get('reopenGraphicCount')}`",
        "",
        "## Manifest Gaps To Close Before Playable Battle",
        "- Character roster is still hard-wired to the three BATTLE29 sample heroes (`1036`, `1002`, `1034`) and must be sourced from original formation/battle datatable/Lua runtime state.",
        "- Skill card mapping currently carries BATTLE29 evidence for normal/small/big skill ids only; cooldown, fury/ready state, icon source bundle, and click handler mapping still need datatable + Lua + IL2CPP join.",
        "- Formation positions need original side/team/order evidence, not the BATTLE29 inferred three-card placement.",
        "- Top HP/VS/wave and right auto/skip/speed controls have persistent sprite candidates, but runtime text/TMP values, masks/stencil, and button handler binding are not validated as playable.",
        "- Actor motion/timing and skill/cut-in effect timelines remain outside this HUD persistence patch.",
        "",
        "## Required Next Evidence",
        "- Original battle/formation datatables for actor ids, enemy wave ids, side, slot/order, level, and head/icon refs.",
        "- Decoded Lua call sites that populate `HeroListContainer`, skill cards, HP bars, wave text, auto/skip/speed state, and skill activation.",
        "- IL2CPP method/type evidence for Image/Button/Text/TMP/custom YouYouImage fields where original MonoBehaviour script PPtrs were lost in saved scenes.",
        "- Mask/stencil and Canvas/CanvasScaler verification after persistent Image reconstruction.",
    ]
    GAP_MD.write_text("\n".join(md) + "\n", encoding="utf-8")


def verify(unity_exit):
    unity = read_json(UNITY_JSON, {})
    rows = read_csv(ROWS_CSV)
    b41 = read_json(B41_JSON, {})
    b29 = read_json(B29_JSON, {})
    hud = hud_visibility_metrics(B42_CAPTURE, B29_CAPTURE)
    camera_visible = bool(hud.get("cameraVisibleBattleHud"))
    reopen_images = int(unity.get("reopenImageCount") or 0)
    reopen_graphics = int(unity.get("reopenGraphicCount") or 0)
    rebuilt = int(unity.get("reconstructedImageCount") or 0)
    if unity_exit != 0:
        visual_status = "failed_unity_batch_or_compile"
        blocker = "Unity batch/probe did not complete."
        next_blocker = "BATTLE_43_FIX_BATTLE42_COMPILE_OR_BATCH_ERROR"
    elif rebuilt > 0 and reopen_images > 0:
        visual_status = "failed_persistent_hud_images_survive_scene_reload_but_clip05_playable_context_not_restored"
        blocker = "Persistent Image/Sprite components now survive scene reopen, but capture/contact sheet is not a final playable clip05 match and runtime text/button/mask/actor/skill flow is still incomplete."
        next_blocker = "BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING"
    else:
        visual_status = "failed_persistent_hud_image_reconstruction_did_not_survive_reload"
        blocker = "BATTLE42 did not produce persistent reopened Image/Graphic rows."
        next_blocker = "BATTLE_43_TRACE_UNITY_UI_IMAGE_MONOSCRIPT_SERIALIZATION_GUID_AND_IMPORTER"

    result = {
        "verdict": "persistent HUD Image/Sprite reconstruction advanced, but playable battle screen not restored",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "reference_video_used": VIDEO.exists(),
        "referenceVideoPath": str(VIDEO),
        "referenceVideoAvailable": VIDEO.exists(),
        "auxiliaryReferenceVideoPath": str(AUX_VIDEO),
        "auxiliaryReferenceVideoAvailable": AUX_VIDEO.exists(),
        "videoTimeRangeSeconds": "485.0-487.0" if VIDEO.exists() else "",
        "unityExitCode": unity_exit,
        "cameraVisibleBattleHud": camera_visible,
        "hudVisibilityMetrics": hud,
        "captureMetrics": capture_metrics(B42_CAPTURE),
        "unitySummary": unity,
        "battle41Carryover": {
            "visual_status": b41.get("visual_status"),
            "battle29FreshVisibleCardImageCount": b41.get("battle29FreshSummary", {}).get("visibleCardImageCount"),
            "battle29ReopenImageCount": b41.get("battle29ReopenSummary", {}).get("imageCount"),
            "battle41ReopenImageCount": b41.get("battle41Summary", {}).get("reopenAfterSaveImageCount"),
        },
        "battle29Carryover": {
            "visual_status": b29.get("visual_status"),
            "boundHeroCardCount": b29.get("unityLiveSummary", {}).get("boundHeroCardCount"),
        },
        "blocker": blocker,
        "nextBlocker": next_blocker,
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "unityDataJson": str(UNITY_JSON),
            "componentsCsv": str(ROWS_CSV),
            "capture": str(B42_CAPTURE),
            "contactSheet": str(CONTACT),
            "manifestGap": str(GAP_MD),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "BATTLE42 uses original BattleHudExtractedSpriteBindingMarker25 evidence: sprite name, bundle, pathId, and extracted PNG path.",
            "Extracted PNGs are imported as persistent Unity Sprite assets before Image.sprite assignment.",
            "No fake HUD, screenshot paste, whole-atlas placement, or debug/evidence labels were added to the capture.",
            "This is not a final restored battle screen.",
        ],
    }
    make_contact(result)
    write_gap_report(rows, unity)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    md = [
        "# BATTLE_42 Rebuild Persistent Battle HUD Image Components From Original Prefab PPtr And Sprites Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE42는 BATTLE41 blocker였던 scene reload 후 `Image/Graphic = 0` 문제를 original sprite marker evidence 기반 persistent Unity `Image` + imported `Sprite` asset으로 재구성하는 실험 패치다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- reference video used: `{VIDEO.exists()}` (`{VIDEO}`" + (", 485.0-487.0s)" if VIDEO.exists() else " missing)"),
        f"- auxiliary reference video available: `{AUX_VIDEO.exists()}` (`{AUX_VIDEO}`)",
        f"- camera-visible HUD/cards: `{camera_visible}`",
        f"- Unity exit code: `{unity_exit}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Persistent HUD Rebuild",
        f"- original sprite marker rows: `{unity.get('originalSpriteMarkerCount')}`",
        f"- reconstructed Image components: `{unity.get('reconstructedImageCount')}`",
        f"- imported persistent Sprite assets: `{unity.get('importedSpriteAssetCount')}`",
        f"- before Image/Graphic/active Graphic: `{unity.get('beforeImageCount')}` / `{unity.get('beforeGraphicCount')}` / `{unity.get('beforeActiveGraphicCount')}`",
        f"- after Image/Graphic/active Graphic: `{unity.get('afterImageCount')}` / `{unity.get('afterGraphicCount')}` / `{unity.get('afterActiveGraphicCount')}`",
        f"- reopened Image/Graphic/active Graphic: `{unity.get('reopenImageCount')}` / `{unity.get('reopenGraphicCount')}` / `{unity.get('reopenActiveGraphicCount')}`",
        f"- reopened Image with Sprite/Texture: `{unity.get('reopenImageWithSpriteCount')}` / `{unity.get('reopenImageWithTextureCount')}`",
        f"- missing scripts before/after/reopen: `{unity.get('beforeMissingScriptCount')}` / `{unity.get('afterMissingScriptCount')}` / `{unity.get('reopenMissingScriptCount')}`",
        "",
        "## Evidence Interpretation",
        "- BATTLE41 confirmed BATTLE29 fresh runtime `Image.sprite` state did not survive scene reload.",
        "- BATTLE42 binds from persisted `BattleHudExtractedSpriteBindingMarker25` rows: original sprite name, source bundle, pathId, and extracted PNG path.",
        "- PNGs are imported under `Assets/RestoreData/battle/PersistentHudSprites/BATTLE42` as Unity Sprite assets, then assigned to real `UnityEngine.UI.Image` components.",
        "- Existing missing-script components are not treated as success and remain a separate MonoScript/PPtr gap.",
        "",
        "## Blocker",
        f"- {blocker}",
        "",
        "## Manifest Gap",
        f"- `{GAP_MD}`",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_JSON}`",
        f"- components CSV: `{ROWS_CSV}`",
        f"- capture: `{B42_CAPTURE}`",
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
        "cameraVisibleBattleHud": camera_visible,
        "reconstructedImageCount": unity.get("reconstructedImageCount"),
        "reopenImageCount": unity.get("reopenImageCount"),
        "reopenGraphicCount": unity.get("reopenGraphicCount"),
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
