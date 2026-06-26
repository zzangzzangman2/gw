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

UNITY_JSON = UNITY_DATA / "BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_UNITY.json"
SUMMARY_CSV = UNITY_DATA / "BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_TARGET_POINTS.csv"
DETAIL_CSV = UNITY_DATA / "BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_REGISTERED_GRAPHICS.csv"
B47_JSON = REPORT_DIR / "BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION_RESULT.json"
B47_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle47GraphicDepthRaycastCandidateRegistration_1920x1080.png"
B48_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle48SortOrderDisplayHitOcclusionTrace_1920x1080.png"
B48_SCENE = PROJECT / "Assets" / "Scenes" / "Battle48SortOrderDisplayHitOcclusionTrace.unity"

OUT_MD = REPORT_DIR / "BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_RESULT.json"
CONTACT = REPORT_DIR / "BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_CONTACT_SHEET.jpg"
UNITY_LOG = REPORT_DIR / "BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD.log"


def read_json(path, fallback):
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def boolv(row, key):
    return (row.get(key) or "").lower() == "true"


def intv(row, key):
    try:
        return int(float(row.get(key) or 0))
    except Exception:
        return 0


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


def summarize_rows():
    summary = read_csv(SUMMARY_CSV)
    details = read_csv(DETAIL_CSV)
    reopen = [r for r in summary if r.get("phase") == "reopen_after_depth_rebuild_render"]
    reasons = {}
    point_counts = {}
    point_ready = {}
    for row in reopen:
        reason = row.get("primaryFailure") or "unknown"
        reasons[reason] = reasons.get(reason, 0) + 1
        point = row.get("pointName") or "unknown"
        point_counts[point] = point_counts.get(point, 0) + 1
        if boolv(row, "raycastReady"):
            point_ready[point] = point_ready.get(point, 0) + 1
    rejection = {}
    target_rejection = {}
    final_candidates = 0
    target_final_candidates = 0
    for row in details:
        if row.get("phase") != "reopen_after_depth_rebuild_render":
            continue
        reason = row.get("rejectionReason") or "unknown"
        rejection[reason] = rejection.get(reason, 0) + 1
        if boolv(row, "finalCandidate"):
            final_candidates += 1
        if boolv(row, "isTargetGraphic"):
            target_rejection[reason] = target_rejection.get(reason, 0) + 1
            if boolv(row, "finalCandidate"):
                target_final_candidates += 1
    samples = []
    for row in reopen[:18]:
        samples.append({
            "point": row.get("pointName"),
            "button": row.get("buttonName"),
            "pointer": row.get("pointerPosition"),
            "pixelRectContains": row.get("pixelRectContains"),
            "targetDepth": row.get("targetDepth"),
            "mirrorTargetFinal": row.get("mirrorTargetFinalCandidate"),
            "mirrorFinalCount": row.get("mirrorFinalCandidateCount"),
            "unityHitCount": row.get("unityHitCount"),
            "ready": row.get("raycastReady"),
            "failure": row.get("primaryFailure"),
        })
    return {
        "summaryRowCount": len(summary),
        "detailRowCount": len(details),
        "reopenRowCount": len(reopen),
        "reopenRaycastReadyCount": sum(1 for r in reopen if boolv(r, "raycastReady")),
        "reopenUnityHitPositiveCount": sum(1 for r in reopen if intv(r, "unityHitCount") > 0),
        "reopenMirrorTargetCandidateCount": sum(1 for r in reopen if boolv(r, "mirrorTargetFinalCandidate")),
        "reopenMirrorAnyCandidateCount": sum(1 for r in reopen if intv(r, "mirrorFinalCandidateCount") > 0),
        "reopenPixelRectContainsCount": sum(1 for r in reopen if boolv(r, "pixelRectContains")),
        "reopenDepthNonNegativeCount": sum(1 for r in reopen if intv(r, "targetDepth") >= 0),
        "primaryFailureCounts": reasons,
        "pointCounts": point_counts,
        "pointReadyCounts": point_ready,
        "detailRejectionCounts": rejection,
        "targetDetailRejectionCounts": target_rejection,
        "detailFinalCandidateCount": final_candidates,
        "targetDetailFinalCandidateCount": target_final_candidates,
        "samples": samples,
    }


def scene_yaml_summary():
    text = B48_SCENE.read_text(encoding="utf-8-sig", errors="replace") if B48_SCENE.exists() else ""
    return {
        "sceneExists": B48_SCENE.exists(),
        "empty4RaycastIdentifierCount": text.count("UnityEngine.UI.Empty4Raycast"),
        "missingScriptFileId0Count": text.count("m_Script: {fileID: 0}"),
    }


def decide_status(unity_exit, rows):
    if unity_exit != 0:
        return (
            "failed_unity_batch_or_compile",
            "Unity batch/probe did not complete.",
            "BATTLE_49_FIX_BATTLE48_COMPILE_OR_BATCH_ERROR",
        )
    if rows["reopenRaycastReadyCount"] > 0:
        return (
            "raycast_ready_candidate_found_after_sort_display_trace",
            "At least one original targetGraphic receives a GraphicRaycaster hit after reopen, but real input/click validation and reference alignment remain incomplete.",
            "BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING",
        )
    if rows["reopenMirrorTargetCandidateCount"] > 0 and rows["reopenUnityHitPositiveCount"] == 0:
        return (
            "mirror_target_candidates_exist_but_unity_graphicraycaster_returns_empty",
            "Mirror filtering finds target candidates, but Unity GraphicRaycaster returns empty results, so an internal display/blocking path still differs from the mirror.",
            "BATTLE_49_TRACE_GRAPHICRAYCASTER_INTERNAL_DISPLAY_BLOCKING_WITH_ENGINE_SOURCE_PARITY",
        )
    if rows["targetDetailRejectionCounts"].get("event_camera_pixelrect_reject", 0) > 0:
        return (
            "event_camera_pixelrect_rejects_many_target_points",
            "Many target point candidates are rejected by eventCamera.pixelRect/display gating before Graphic filtering.",
            "BATTLE_49_PATCH_EVENT_CAMERA_PIXELRECT_OR_POINTER_COORDINATE_NORMALIZATION",
        )
    if rows["targetDetailRejectionCounts"].get("rect_not_contains", 0) > 0:
        return (
            "pointer_coordinate_candidates_do_not_align_with_target_rects",
            "Depth and registry are alive, but candidate pointer coordinates do not pass target RectTransform containment.",
            "BATTLE_49_TRACE_CANVAS_SCALER_CAMERA_PIXEL_RECT_COORDINATE_NORMALIZATION",
        )
    return (
        "sort_display_hit_trace_no_safe_patch",
        "BATTLE48 did not identify a safe minimal input-plumbing patch.",
        "BATTLE_49_TRACE_GRAPHICRAYCASTER_INTERNALS_AND_RUNTIME_POINTER_EVENT",
    )


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
    sheet.paste(panel("BATTLE47 candidate", B47_CAPTURE), (0, 0))
    sheet.paste(panel("BATTLE48 candidate", B48_CAPTURE), (640, 0))
    text = Image.new("RGB", (640, 360), (8, 8, 8))
    draw = ImageDraw.Draw(text)
    rows = result["rowSummary"]
    lines = [
        "BATTLE_48 summary",
        f"visual_status: {result['visual_status']}",
        f"final restored: {result['isFinalRestoredBattleScreen']}",
        f"ready/unityHit/mirrorTarget: {rows['reopenRaycastReadyCount']} / {rows['reopenUnityHitPositiveCount']} / {rows['reopenMirrorTargetCandidateCount']}",
        f"pixelRectContains/depth>=0: {rows['reopenPixelRectContainsCount']} / {rows['reopenDepthNonNegativeCount']}",
        f"primary failures: {rows['primaryFailureCounts']}",
    ]
    y = 18
    for line in lines:
        draw.text((18, y), line[:100], fill=(235, 235, 235))
        y += 27
    sheet.paste(text, (1280, 0))
    sheet.paste(panel("BATTLE48 detail", B48_CAPTURE, (960, 540)), (0, 360))
    notes = Image.new("RGB", (960, 540), (8, 8, 8))
    draw = ImageDraw.Draw(notes)
    note_lines = [
        "No fake transparent overlay, fake onClick, fake HUD/card/icon, screenshot paste, or whole-atlas patch.",
        f"target rejection counts: {rows['targetDetailRejectionCounts']}",
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


def verify(unity_exit):
    unity = read_json(UNITY_JSON, {})
    b47 = read_json(B47_JSON, {})
    rows = summarize_rows()
    visual_status, blocker, next_blocker = decide_status(unity_exit, rows)
    result = {
        "verdict": "BATTLE48 traced GraphicRaycaster sort/display/pixelRect/mirror filtering after depth rebuild; final playable screen remains false",
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
        "battle47Carryover": {
            "visual_status": b47.get("visual_status"),
            "reopenDepthNonNegativeCount": b47.get("rowSummary", {}).get("phases", {}).get("reopen_after_render_reset_aspect", {}).get("depthNonNegativeCount"),
            "reopenRaycastReadyCount": b47.get("rowSummary", {}).get("phases", {}).get("reopen_after_render_reset_aspect", {}).get("raycastReadyCount"),
        },
        "captureMetrics": capture_metrics(B48_CAPTURE),
        "battle47ToBattle48CaptureSimilarity": image_similarity(B47_CAPTURE, B48_CAPTURE),
        "blocker": blocker,
        "nextBlocker": next_blocker,
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "unityDataJson": str(UNITY_JSON),
            "summaryCsv": str(SUMMARY_CSV),
            "detailCsv": str(DETAIL_CSV),
            "capture": str(B48_CAPTURE),
            "contactSheet": str(CONTACT),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "BATTLE48 does not add fake transparent overlays, fake onClick handlers, fake HUD/cards/icons, screenshot paste, or whole-atlas placement.",
            "플레이.mp4 remains missing when referenceVideoAvailable is false; 참고.mp4 is auxiliary only.",
            "Depth rebuild was performed with a 640x480 render matching the eventCamera pixelRect; this preserves 640x480 eventCamera_worldToScreen coordinates for hit validation.",
        ],
    }
    make_contact(result)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_48 Trace Sort Order Display And Hit Occlusion After Depth Rebuild Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE48는 depth가 살아난 BATTLE47 후보에서 Unity `GraphicRaycaster.Raycast` 내부 조건을 mirror trace로 재현하고, 여러 pointer 좌표계를 비교했다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- Unity exit code: `{unity_exit}`",
        f"- reference video available: `{PLAY_VIDEO.exists()}` (`{PLAY_VIDEO}`)",
        f"- auxiliary reference video available: `{AUX_VIDEO.exists()}` (`{AUX_VIDEO}`)",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Reopen Mirror Summary",
        f"- summary/detail rows: `{rows['summaryRowCount']}` / `{rows['detailRowCount']}`",
        f"- reopen raycast-ready / unity-hit-positive / mirror-target-candidate: `{rows['reopenRaycastReadyCount']}` / `{rows['reopenUnityHitPositiveCount']}` / `{rows['reopenMirrorTargetCandidateCount']}`",
        f"- reopen pixelRect contains / target depth>=0: `{rows['reopenPixelRectContainsCount']}` / `{rows['reopenDepthNonNegativeCount']}`",
        f"- primary failures: `{rows['primaryFailureCounts']}`",
        f"- target detail rejection counts: `{rows['targetDetailRejectionCounts']}`",
        f"- point ready counts: `{rows['pointReadyCounts']}`",
        "- depth rebuild render used `640x480`, matching `eventCamera.pixelRect`; 1920/capture-scaled pointer candidates did not hit.",
        "",
        "## Patch Decision",
        f"- Unity patch decision: `{unity.get('patchDecision')}`",
        f"- Report blocker: {blocker}",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_JSON}`",
        f"- target-point CSV: `{SUMMARY_CSV}`",
        f"- registered-graphics CSV: `{DETAIL_CSV}`",
        f"- capture: `{B48_CAPTURE}`",
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
        "ready": rows["reopenRaycastReadyCount"],
        "unityHitPositive": rows["reopenUnityHitPositiveCount"],
        "mirrorTargetCandidate": rows["reopenMirrorTargetCandidateCount"],
        "primaryFailureCounts": rows["primaryFailureCounts"],
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
