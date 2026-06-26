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
PLAY_VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")

UNITY_JSON = UNITY_DATA / "BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION_UNITY.json"
ROWS_CSV = UNITY_DATA / "BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION_COMPONENTS.csv"
B46_JSON = REPORT_DIR / "BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_RESULT.json"
B46_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle46GraphicRaycasterEventCameraScreenSpaceCandidate_1920x1080.png"
B47_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle47GraphicDepthRaycastCandidateRegistration_1920x1080.png"
B47_SCENE = PROJECT / "Assets" / "Scenes" / "Battle47GraphicDepthRaycastCandidateRegistration.unity"

OUT_MD = REPORT_DIR / "BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION_RESULT.json"
CONTACT = REPORT_DIR / "BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION_CONTACT_SHEET.jpg"
UNITY_LOG = REPORT_DIR / "BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION.log"


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


def boolv(row, key):
    return (row.get(key) or "").lower() == "true"


def intv(row, key):
    try:
        return int(float(row.get(key) or 0))
    except Exception:
        return 0


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


def image_similarity(a, b):
    ia = cv2.imread(str(a))
    ib = cv2.imread(str(b))
    if ia is None or ib is None:
        return {"available": False}
    if ia.shape != ib.shape:
        ib = cv2.resize(ib, (ia.shape[1], ia.shape[0]))
    diff = float(np.mean(np.abs(ia.astype(np.float32) - ib.astype(np.float32))) / 255.0)
    try:
        corr = float(np.corrcoef(ia.reshape(-1).astype(float), ib.reshape(-1).astype(float))[0, 1])
    except Exception:
        corr = 0.0
    return {"available": True, "meanAbsDiff": round(diff, 6), "pixelCorrelation": round(corr, 6)}


def phase_summary():
    rows = read_csv(ROWS_CSV)
    phases = {}
    reason_counts = {}
    samples = []
    for row in rows:
        phase = row.get("phase") or "unknown"
        bucket = phases.setdefault(phase, {
            "probeCount": 0,
            "depthNonNegativeCount": 0,
            "absoluteDepthNonNegativeCount": 0,
            "registryIncludedCount": 0,
            "graphicRaycastCount": 0,
            "rectContainsCount": 0,
            "hitPositiveCount": 0,
            "raycastReadyCount": 0,
            "baselineHitPositiveCount": 0,
            "baselineRaycastReadyCount": 0,
            "depthMinusOneCount": 0,
            "canvasRendererCullCount": 0,
        })
        bucket["probeCount"] += 1
        if intv(row, "targetDepth") >= 0:
            bucket["depthNonNegativeCount"] += 1
        else:
            bucket["depthMinusOneCount"] += 1
        if intv(row, "canvasRendererAbsoluteDepth") >= 0:
            bucket["absoluteDepthNonNegativeCount"] += 1
        if boolv(row, "targetInParentRegistry") or boolv(row, "targetInGraphicCanvasRegistry"):
            bucket["registryIncludedCount"] += 1
        if boolv(row, "targetGraphicRaycast"):
            bucket["graphicRaycastCount"] += 1
        if boolv(row, "rectContains"):
            bucket["rectContainsCount"] += 1
        if intv(row, "hitCount") > 0:
            bucket["hitPositiveCount"] += 1
        if boolv(row, "raycastReady"):
            bucket["raycastReadyCount"] += 1
        if intv(row, "baselineHitCount") > 0:
            bucket["baselineHitPositiveCount"] += 1
        if boolv(row, "baselineRaycastReady"):
            bucket["baselineRaycastReadyCount"] += 1
        if boolv(row, "canvasRendererCull"):
            bucket["canvasRendererCullCount"] += 1
        reason = row.get("raycastReason") or "unknown"
        reason_counts[reason] = reason_counts.get(reason, 0) + 1
        if len(samples) < 16 and phase in ("before_open", "after_camera_render_reset_aspect", "reopen_after_render_reset_aspect"):
            samples.append({
                "phase": phase,
                "button": row.get("buttonName"),
                "targetType": row.get("targetType"),
                "depth": row.get("targetDepth"),
                "absoluteDepth": row.get("canvasRendererAbsoluteDepth"),
                "registryParent": row.get("targetInParentRegistry"),
                "registryGraphicCanvas": row.get("targetInGraphicCanvasRegistry"),
                "graphicRaycast": row.get("targetGraphicRaycast"),
                "rectContains": row.get("rectContains"),
                "hitCount": row.get("hitCount"),
                "raycastReady": row.get("raycastReady"),
                "baselineScreenCenter": row.get("baselineScreenCenter"),
                "baselineHitCount": row.get("baselineHitCount"),
                "baselineRaycastReady": row.get("baselineRaycastReady"),
                "baselineReason": row.get("baselineRaycastReason"),
                "reason": reason,
            })
    return {
        "phaseCount": len(phases),
        "phases": phases,
        "raycastReasonCounts": reason_counts,
        "samples": samples,
    }


def scene_yaml_summary():
    text = B47_SCENE.read_text(encoding="utf-8-sig", errors="replace") if B47_SCENE.exists() else ""
    return {
        "sceneExists": B47_SCENE.exists(),
        "empty4RaycastIdentifierCount": text.count("UnityEngine.UI.Empty4Raycast"),
        "missingScriptFileId0Count": text.count("m_Script: {fileID: 0}"),
    }


def panel(label, path, size=(640, 360)):
    img = cv2.imread(str(path))
    out = Image.new("RGB", size, (8, 8, 8))
    draw = ImageDraw.Draw(out)
    if img is not None:
        pil = Image.fromarray(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
        pil.thumbnail((size[0], size[1] - 28), Image.Resampling.LANCZOS)
        out.paste(pil, ((size[0] - pil.width) // 2, 0))
    else:
        draw.text((20, 140), f"missing: {path}", fill=(235, 235, 235))
    draw.text((8, size[1] - 21), label, fill=(235, 235, 235))
    return out


def make_contact(result):
    sheet = Image.new("RGB", (1920, 900), (0, 0, 0))
    sheet.paste(panel("BATTLE46 candidate", B46_CAPTURE), (0, 0))
    sheet.paste(panel("BATTLE47 candidate", B47_CAPTURE), (640, 0))
    text = Image.new("RGB", (640, 360), (8, 8, 8))
    draw = ImageDraw.Draw(text)
    rows = result["rowSummary"]
    u = result["unitySummary"]
    reopen = rows["phases"].get("reopen_after_render_reset_aspect", {})
    lines = [
        "BATTLE_47 summary",
        f"visual_status: {result['visual_status']}",
        f"final restored: {result['isFinalRestoredBattleScreen']}",
        f"reopen probes/depth/abs/ready: {reopen.get('probeCount')} / {reopen.get('depthNonNegativeCount')} / {reopen.get('absoluteDepthNonNegativeCount')} / {reopen.get('raycastReadyCount')}",
        f"baseline hits/ready: {reopen.get('baselineHitPositiveCount')} / {reopen.get('baselineRaycastReadyCount')}",
        f"patch decision: {u.get('patchDecision')}",
        f"missing scripts: {u.get('reopenAfter', {}).get('missingScript')}",
    ]
    y = 18
    for line in lines:
        draw.text((18, y), line[:96], fill=(235, 235, 235))
        y += 27
    sheet.paste(text, (1280, 0))
    sheet.paste(panel("BATTLE47 detail", B47_CAPTURE, (960, 540)), (0, 360))
    notes = Image.new("RGB", (960, 540), (8, 8, 8))
    draw = ImageDraw.Draw(notes)
    note_lines = [
        "No fake onClick, fake transparent overlay, fake HUD/card/icon, screenshot paste, or whole-atlas patch.",
        "BATTLE47 probes ForceUpdateCanvases, SetDirty/RegisterGraphicRebuild, Graphic.Rebuild(PreRender), and Camera.Render.",
        f"raycast reasons: {rows['raycastReasonCounts']}",
        f"play video available: {PLAY_VIDEO.exists()} {PLAY_VIDEO}",
        f"aux reference available: {AUX_VIDEO.exists()} {AUX_VIDEO}",
    ]
    y = 20
    for line in note_lines:
        draw.text((18, y), line[:135], fill=(235, 235, 235))
        y += 30
    sheet.paste(notes, (960, 360))
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT, quality=92)


def decide_status(unity_exit, unity, rows):
    if unity_exit != 0:
        return (
            "failed_unity_batch_or_compile",
            "Unity batch/probe did not complete.",
            "BATTLE_48_FIX_BATTLE47_COMPILE_OR_BATCH_ERROR",
        )
    reopen = rows["phases"].get("reopen_after_render_reset_aspect", {})
    after = rows["phases"].get("after_camera_render_reset_aspect", {})
    if reopen.get("raycastReadyCount", 0) > 0:
        return (
            "graphic_depth_rebuild_restores_raycast_candidates_after_reopen",
            "Force/dirty/rebuild/render produces raycast-ready original targetGraphic samples after reopen, but real input handler validation and reference alignment remain incomplete.",
            "BATTLE_48_VALIDATE_REAL_INPUT_CLICK_PATH_AND_ORIGINAL_HANDLER_BINDING",
        )
    if reopen.get("baselineRaycastReadyCount", 0) > 0:
        return (
            "graphic_depth_restored_and_baseline_screen_coordinates_hit_targets",
            "After render/rebuild, current generated screen points still miss, but baseline 640x480 screen centers hit original target Graphics; input coordinate/display normalization is now the active blocker.",
            "BATTLE_48_FIX_EVENTDATA_SCREEN_COORDINATE_NORMALIZATION_AND_VALIDATE_CLICK",
        )
    if after.get("raycastReadyCount", 0) > 0:
        return (
            "graphic_depth_rebuild_improves_before_save_but_not_persistent_reopen",
            "Depth/raycast can be restored before save, but the condition does not survive reopen without runtime rebuild timing.",
            "BATTLE_48_ADD_EVIDENCE_BACKED_RUNTIME_CANVAS_REBUILD_BOOTSTRAP_AND_VALIDATE",
        )
    if reopen.get("depthNonNegativeCount", 0) == 0 and reopen.get("probeCount", 0) > 0:
        return (
            "force_rebuild_render_does_not_restore_graphic_depth",
            "Canvas.ForceUpdateCanvases, dirty registration, explicit Graphic.Rebuild(PreRender), and Camera.Render do not make target Graphic.depth non-negative in batch reopen.",
            "BATTLE_48_TRACE_CANVAS_RENDER_ROOT_SORT_BATCH_AND_GRAPHIC_DEPTH_SOURCE",
        )
    if reopen.get("depthNonNegativeCount", 0) > 0:
        return (
            "graphic_depth_restored_but_raycast_still_not_ready",
            "Some target depths are non-negative after rebuild/render, but GraphicRaycaster still does not hit original targets.",
            "BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD",
        )
    return (
        "trace_only_no_safe_patch",
        "BATTLE47 did not produce a safe evidence-backed raycast candidate registration patch.",
        "BATTLE_48_TRACE_CANVAS_RENDER_DEPTH_AND_RUNTIME_EVENT_LOOP",
    )


def verify(unity_exit):
    unity = read_json(UNITY_JSON, {})
    b46 = read_json(B46_JSON, {})
    rows = phase_summary()
    visual_status, blocker, next_blocker = decide_status(unity_exit, unity, rows)
    result = {
        "verdict": "BATTLE47 traced Graphic.depth, CanvasRenderer absoluteDepth, rebuild phases, registry inclusion, and raycast-ready status; final playable screen remains false",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "unityExitCode": unity_exit,
        "referenceVideoAvailable": PLAY_VIDEO.exists(),
        "referenceVideoPath": str(PLAY_VIDEO),
        "auxiliaryReferenceVideoAvailable": AUX_VIDEO.exists(),
        "auxiliaryReferenceVideoPath": str(AUX_VIDEO),
        "unitySummary": unity,
        "rowSummary": rows,
        "sceneYamlSummary": scene_yaml_summary(),
        "battle46Carryover": {
            "visual_status": b46.get("visual_status"),
            "probeCount": b46.get("rowSummary", {}).get("probeCount"),
            "registryIncludedCount": b46.get("rowSummary", {}).get("registryIncludedCount"),
            "raycastReadyCount": b46.get("rowSummary", {}).get("raycastReadyCount"),
            "targetDepthMinusOneCount": b46.get("rowSummary", {}).get("targetDepthMinusOneCount"),
        },
        "captureMetrics": capture_metrics(B47_CAPTURE),
        "battle46ToBattle47CaptureSimilarity": image_similarity(B46_CAPTURE, B47_CAPTURE),
        "blocker": blocker,
        "nextBlocker": next_blocker,
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "unityDataJson": str(UNITY_JSON),
            "rowsCsv": str(ROWS_CSV),
            "capture": str(B47_CAPTURE),
            "contactSheet": str(CONTACT),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "BATTLE47 does not add fake onClick handlers, fake transparent overlays, fake HUD/cards/icons, screenshot paste, or whole-atlas placement.",
            "플레이.mp4 remains missing when referenceVideoAvailable is false; 참고.mp4 is auxiliary only.",
            "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST was not used because input plumbing remains the active blocker.",
        ],
    }
    make_contact(result)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    reopen = rows["phases"].get("reopen_after_render_reset_aspect", {})
    after = rows["phases"].get("after_camera_render_reset_aspect", {})
    md = [
        "# BATTLE_47 Fix Graphic Depth And Raycast Candidate Registration Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE47는 BATTLE46 후보의 original Button targetGraphic 14개를 대상으로 `Graphic.depth`, `CanvasRenderer.absoluteDepth`, registry 포함 여부, `GraphicRaycaster.Raycast`, `Graphic.Raycast`, rect contains를 rebuild phase별로 추적했다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- Unity exit code: `{unity_exit}`",
        f"- reference video available: `{PLAY_VIDEO.exists()}` (`{PLAY_VIDEO}`)",
        f"- auxiliary reference video available: `{AUX_VIDEO.exists()}` (`{AUX_VIDEO}`)",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Phase Summary",
        f"- after camera render probes/depth>=0/absoluteDepth>=0/registry/ready/baselineReady: `{after.get('probeCount')}` / `{after.get('depthNonNegativeCount')}` / `{after.get('absoluteDepthNonNegativeCount')}` / `{after.get('registryIncludedCount')}` / `{after.get('raycastReadyCount')}` / `{after.get('baselineRaycastReadyCount')}`",
        f"- reopen after dirty+rebuild+render+resetAspect probes/depth>=0/absoluteDepth>=0/registry/ready/baselineReady: `{reopen.get('probeCount')}` / `{reopen.get('depthNonNegativeCount')}` / `{reopen.get('absoluteDepthNonNegativeCount')}` / `{reopen.get('registryIncludedCount')}` / `{reopen.get('raycastReadyCount')}` / `{reopen.get('baselineRaycastReadyCount')}`",
        f"- reopen Graphic.Raycast / rect contains / hit-positive / baseline-hit-positive: `{reopen.get('graphicRaycastCount')}` / `{reopen.get('rectContainsCount')}` / `{reopen.get('hitPositiveCount')}` / `{reopen.get('baselineHitPositiveCount')}`",
        f"- raycast reasons: `{rows.get('raycastReasonCounts')}`",
        f"- Unity patch decision: `{unity.get('patchDecision')}`",
        "",
        "## Blocker",
        f"- {blocker}",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_JSON}`",
        f"- component CSV: `{ROWS_CSV}`",
        f"- capture: `{B47_CAPTURE}`",
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
        "afterReady": after.get("raycastReadyCount"),
        "reopenReady": reopen.get("raycastReadyCount"),
        "reopenBaselineReady": reopen.get("baselineRaycastReadyCount"),
        "reopenDepthNonNegative": reopen.get("depthNonNegativeCount"),
        "reopenAbsoluteDepthNonNegative": reopen.get("absoluteDepthNonNegativeCount"),
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
