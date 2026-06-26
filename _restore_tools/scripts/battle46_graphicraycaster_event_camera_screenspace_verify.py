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

UNITY_JSON = UNITY_DATA / "BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_UNITY.json"
ROWS_CSV = UNITY_DATA / "BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_COMPONENTS.csv"
B45_JSON = REPORT_DIR / "BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE_RESULT.json"
B45_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle45Empty4RaycastRegistryCandidate_1920x1080.png"
B46_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle46GraphicRaycasterEventCameraScreenSpaceCandidate_1920x1080.png"
B46_SCENE = PROJECT / "Assets" / "Scenes" / "Battle46GraphicRaycasterEventCameraScreenSpaceCandidate.unity"

OUT_MD = REPORT_DIR / "BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_RESULT.json"
CONTACT = REPORT_DIR / "BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_CONTACT_SHEET.jpg"
UNITY_LOG = REPORT_DIR / "BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS.log"


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


def boolv(row, key):
    return (row.get(key) or "").lower() == "true"


def intv(row, key):
    try:
        return int(row.get(key) or 0)
    except Exception:
        return 0


def row_summary():
    rows = read_csv(ROWS_CSV)
    probes = [r for r in rows if r.get("status") == "reopen_button_target_probe"]
    reasons = {}
    canvases = {}
    target_types = {}
    samples = []
    for row in probes:
        reason = row.get("raycastReason") or "unknown"
        reasons[reason] = reasons.get(reason, 0) + 1
        canvases[row.get("canvasRenderMode") or ""] = canvases.get(row.get("canvasRenderMode") or "", 0) + 1
        target_types[row.get("boundTargetGraphicType") or ""] = target_types.get(row.get("boundTargetGraphicType") or "", 0) + 1
        if len(samples) < 12:
            samples.append({
                "buttonScenePath": row.get("buttonScenePath"),
                "targetType": row.get("boundTargetGraphicType"),
                "canvas": row.get("canvasPath"),
                "renderMode": row.get("canvasRenderMode"),
                "eventCamera": row.get("eventCameraName"),
                "worldCamera": row.get("worldCameraName"),
                "screenEventCenter": row.get("screenEventCenter"),
                "screenNullCenter": row.get("screenNullCenter"),
                "viewportEventCenter": row.get("viewportEventCenter"),
                "eventCameraInFront": row.get("eventCameraInFront"),
                "rectContainsEvent": row.get("rectContainsEventAtEventCenter"),
                "rectContainsNullAtEventCenter": row.get("rectContainsNullAtEventCenter"),
                "rectContainsNullAtNullCenter": row.get("rectContainsNullAtNullCenter"),
                "graphicRaycastEventCamera": row.get("targetGraphicRaycastEventCamera"),
                "targetInRegistry": row.get("targetInRegistry"),
                "hitCount": row.get("hitCount"),
                "raycastReason": reason,
            })
    return {
        "probeCount": len(probes),
        "registryIncludedCount": sum(1 for r in probes if boolv(r, "targetInRegistry")),
        "raycastReadyCount": sum(1 for r in probes if boolv(r, "raycastReady")),
        "hitPositiveCount": sum(1 for r in probes if intv(r, "hitCount") > 0),
        "rectContainsEventCameraCount": sum(1 for r in probes if boolv(r, "rectContainsEventAtEventCenter")),
        "rectContainsNullAtEventCenterCount": sum(1 for r in probes if boolv(r, "rectContainsNullAtEventCenter")),
        "rectContainsNullAtNullCenterCount": sum(1 for r in probes if boolv(r, "rectContainsNullAtNullCenter")),
        "rectContainsMainCameraCount": sum(1 for r in probes if boolv(r, "rectContainsMainAtMainCenter")),
        "rectContainsCaptureCameraCount": sum(1 for r in probes if boolv(r, "rectContainsCaptureAtCaptureCenter")),
        "graphicRaycastEventCameraCount": sum(1 for r in probes if boolv(r, "targetGraphicRaycastEventCamera")),
        "targetDepthMinusOneCount": sum(1 for r in probes if (r.get("targetDepth") or "") == "-1"),
        "eventCameraBehindCount": sum(1 for r in probes if not boolv(r, "eventCameraInFront") and row_has_camera(r, "eventCameraName")),
        "worldCameraDisabledCount": sum(1 for r in probes if row_has_camera(r, "worldCameraName") and not boolv(r, "worldCameraEnabled")),
        "targetCullCount": sum(1 for r in probes if boolv(r, "targetCull")),
        "canvasGroupBlockedCount": sum(1 for r in probes if not boolv(r, "canvasGroupBlocksRaycasts")),
        "raycastReasonCounts": reasons,
        "canvasRenderModeCounts": canvases,
        "targetTypeCounts": target_types,
        "samples": samples,
    }


def row_has_camera(row, key):
    value = row.get(key) or ""
    return value not in ("", "(overlay/null)")


def scene_yaml_summary():
    text = B46_SCENE.read_text(encoding="utf-8-sig", errors="replace") if B46_SCENE.exists() else ""
    return {
        "sceneExists": B46_SCENE.exists(),
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
    sheet.paste(panel("BATTLE45 candidate", B45_CAPTURE), (0, 0))
    sheet.paste(panel("BATTLE46 candidate", B46_CAPTURE), (640, 0))
    text = Image.new("RGB", (640, 360), (8, 8, 8))
    draw = ImageDraw.Draw(text)
    u = result["unitySummary"]
    rows = result["rowSummary"]
    lines = [
        "BATTLE_46 summary",
        f"visual_status: {result['visual_status']}",
        f"final restored: {result['isFinalRestoredBattleScreen']}",
        f"buttons / registry / ready: {rows['probeCount']} / {rows['registryIncludedCount']} / {rows['raycastReadyCount']}",
        f"Rect event/null@event/null@null: {rows['rectContainsEventCameraCount']} / {rows['rectContainsNullAtEventCenterCount']} / {rows['rectContainsNullAtNullCenterCount']}",
        f"Graphic.Raycast eventCamera / depth -1: {rows['graphicRaycastEventCameraCount']} / {rows['targetDepthMinusOneCount']}",
        f"reopen missing: {u.get('reopen', {}).get('missingScript')}",
        f"patch decision: {u.get('patchDecision')}",
    ]
    y = 18
    for line in lines:
        draw.text((18, y), line[:92], fill=(235, 235, 235))
        y += 27
    sheet.paste(text, (1280, 0))
    sheet.paste(panel("BATTLE46 detail", B46_CAPTURE, (960, 540)), (0, 360))
    notes = Image.new("RGB", (960, 540), (8, 8, 8))
    draw = ImageDraw.Draw(notes)
    note_lines = [
        "No fake HUD/card/icon, screenshot paste, whole-atlas placement, or fake onClick.",
        "BATTLE46 traces eventCamera/worldCamera/screen corners/RectTransformUtility/GraphicRaycaster.",
        f"raycast reasons: {rows['raycastReasonCounts']}",
        f"canvas modes: {rows['canvasRenderModeCounts']}",
        f"play video available: {PLAY_VIDEO.exists()} {PLAY_VIDEO}",
        f"aux reference available: {AUX_VIDEO.exists()} {AUX_VIDEO}",
    ]
    y = 20
    for line in note_lines:
        draw.text((18, y), line[:130], fill=(235, 235, 235))
        y += 30
    sheet.paste(notes, (960, 360))
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT, quality=92)


def decide_status(unity_exit, unity, rows):
    if unity_exit != 0:
        return (
            "failed_unity_batch_or_compile",
            "Unity batch/probe did not complete.",
            "BATTLE_47_FIX_BATTLE46_COMPILE_OR_BATCH_ERROR",
        )
    if rows["raycastReadyCount"] > 0:
        return (
            "graphicraycaster_hits_some_original_targets_but_final_playable_false",
            "At least one original targetGraphic now receives GraphicRaycaster hits after reopen, but real input handlers and reference alignment remain unverified.",
            "BATTLE_47_BIND_RAYCAST_READY_BUTTONS_TO_ORIGINAL_LUA_IL2CPP_INPUT_FLOW",
        )
    if rows["probeCount"] > 0 and rows["targetDepthMinusOneCount"] == rows["probeCount"]:
        return (
            "registered_rect_valid_targets_blocked_by_graphic_depth_minus_one",
            "All Button target Graphics have depth -1 after reopen, so Unity GraphicRaycaster excludes them even though registry, RectTransformUtility, CanvasGroup, and many Graphic.Raycast checks pass.",
            "BATTLE_47_TRACE_CANVAS_RENDER_DEPTH_REBUILD_AND_GRAPHICRAYCASTER_SORT_INTERNALS",
        )
    if rows["registryIncludedCount"] > 0 and rows["rectContainsNullAtNullCenterCount"] > rows["rectContainsEventCameraCount"]:
        return (
            "screen_space_camera_coordinate_mismatch_blocks_graphicraycaster_hits",
            "Registry targets survive, but eventCamera-based RectTransformUtility containment fails while null-camera screen space can contain targets.",
            "BATTLE_47_PATCH_EVENT_CAMERA_OR_CANVAS_RENDER_MODE_WITH_ORIGINAL_EVIDENCE",
        )
    if rows["registryIncludedCount"] > 0 and rows["graphicRaycastEventCameraCount"] > 0 and rows["hitPositiveCount"] == 0:
        return (
            "graphic_targets_accept_event_camera_points_but_graphicraycaster_returns_zero",
            "Graphic.Raycast and RectTransformUtility have passing samples, but GraphicRaycaster returns zero hits; display/blocking/sorting internals need deeper trace.",
            "BATTLE_47_TRACE_GRAPHICRAYCASTER_DISPLAY_BLOCKING_AND_SORT_ORDER_INTERNALS",
        )
    if rows["registryIncludedCount"] > 0:
        return (
            "registry_targets_persist_but_event_camera_rect_tests_do_not_support_patch",
            "Targets remain registered after reopen, but BATTLE46 did not produce a safe minimal input-plumbing patch.",
            "BATTLE_47_TRACE_CANVAS_PLANE_CAMERA_MATRIX_AND_ORIGINAL_EVENT_CAMERA_BINDING",
        )
    return (
        "failed_registry_or_scene_reopen_regressed",
        "Registry inclusion regressed or BATTLE46 scene did not reopen as expected.",
        "BATTLE_47_FIX_BATTLE46_REOPEN_OR_REGISTRY_REGRESSION",
    )


def verify(unity_exit):
    unity = read_json(UNITY_JSON, {})
    b45 = read_json(B45_JSON, {})
    rows = row_summary()
    visual_status, blocker, next_blocker = decide_status(unity_exit, unity, rows)
    result = {
        "verdict": "BATTLE46 traced GraphicRaycaster eventCamera/screen-space/canvas/camera/blocker conditions; final playable screen remains false",
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
        "battle45Carryover": {
            "visual_status": b45.get("visual_status"),
            "reopenEmpty4RaycastCount": b45.get("unitySummary", {}).get("reopenEmpty4RaycastCount"),
            "reopenRaycastReadyButtonCount": b45.get("unitySummary", {}).get("reopenRaycastReadyButtonCount"),
            "raycastReasonCounts": b45.get("rowSummary", {}).get("raycastReasonCounts"),
        },
        "captureMetrics": capture_metrics(B46_CAPTURE),
        "battle45ToBattle46CaptureSimilarity": image_similarity(B45_CAPTURE, B46_CAPTURE),
        "blocker": blocker,
        "nextBlocker": next_blocker,
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "unityDataJson": str(UNITY_JSON),
            "rowsCsv": str(ROWS_CSV),
            "capture": str(B46_CAPTURE),
            "contactSheet": str(CONTACT),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "BATTLE46 does not add fake visible art, fake HUD/cards/icons, screenshot paste, whole-atlas placement, or fake onClick handlers.",
            "플레이.mp4 remains missing when referenceVideoAvailable is false; 참고.mp4 is auxiliary only.",
            "Patch decision is trace-only unless eventCamera/worldCamera/display evidence safely identifies an input-plumbing fix.",
        ],
    }
    make_contact(result)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_46 Trace GraphicRaycaster EventCamera ScreenSpace And Blockers Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE46는 BATTLE45 후보를 저장 후 reopen 기준으로 열고, original targetGraphic 중심 좌표에서 Canvas/GraphicRaycaster/eventCamera/worldCamera/RectTransformUtility/CanvasGroup/CanvasRenderer 조건을 분리했다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- Unity exit code: `{unity_exit}`",
        f"- reference video available: `{PLAY_VIDEO.exists()}` (`{PLAY_VIDEO}`)",
        f"- auxiliary reference video available: `{AUX_VIDEO.exists()}` (`{AUX_VIDEO}`)",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Reopen Counts",
        f"- Button probes / registry included / raycast-ready: `{rows['probeCount']}` / `{rows['registryIncludedCount']}` / `{rows['raycastReadyCount']}`",
        f"- hit-positive samples: `{rows['hitPositiveCount']}`",
        f"- reopen counts: `{unity.get('reopen')}`",
        f"- raycast reasons: `{rows['raycastReasonCounts']}`",
        "",
        "## Screen-Space And Camera Split",
        f"- RectContains eventCamera at event center: `{rows['rectContainsEventCameraCount']}`",
        f"- RectContains null camera at event center: `{rows['rectContainsNullAtEventCenterCount']}`",
        f"- RectContains null camera at null center: `{rows['rectContainsNullAtNullCenterCount']}`",
        f"- RectContains Camera.main: `{rows['rectContainsMainCameraCount']}`",
        f"- RectContains capture camera: `{rows['rectContainsCaptureCameraCount']}`",
        f"- Graphic.Raycast(eventCamera) passing samples: `{rows['graphicRaycastEventCameraCount']}`",
        f"- target Graphic depth == -1 samples: `{rows['targetDepthMinusOneCount']}`",
        f"- worldCamera disabled / target cull / CanvasGroup blocked: `{rows['worldCameraDisabledCount']}` / `{rows['targetCullCount']}` / `{rows['canvasGroupBlockedCount']}`",
        "",
        "## Patch Decision",
        f"- Unity patch decision: `{unity.get('patchDecision')}`",
        f"- Report blocker: {blocker}",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_JSON}`",
        f"- component CSV: `{ROWS_CSV}`",
        f"- capture: `{B46_CAPTURE}`",
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
        "probeCount": rows["probeCount"],
        "registryIncludedCount": rows["registryIncludedCount"],
        "raycastReadyCount": rows["raycastReadyCount"],
        "rectContainsEventCameraCount": rows["rectContainsEventCameraCount"],
        "rectContainsNullAtNullCenterCount": rows["rectContainsNullAtNullCenterCount"],
        "graphicRaycastEventCameraCount": rows["graphicRaycastEventCameraCount"],
        "targetDepthMinusOneCount": rows["targetDepthMinusOneCount"],
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
