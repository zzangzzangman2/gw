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

UNITY_JSON = UNITY_DATA / "BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE_UNITY.json"
ROWS_CSV = UNITY_DATA / "BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE_COMPONENTS.csv"
B44_JSON = REPORT_DIR / "BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION_RESULT.json"
B44_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle44OriginalButtonTargetGraphicCandidate_1920x1080.png"
B45_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle45Empty4RaycastRegistryCandidate_1920x1080.png"
B45_SCENE = PROJECT / "Assets" / "Scenes" / "Battle45Empty4RaycastRegistryCandidate.unity"
EMPTY_SCRIPT = PROJECT / "Assets" / "Scripts" / "Empty4Raycast.cs"
EMPTY_SCRIPT_META = PROJECT / "Assets" / "Scripts" / "Empty4Raycast.cs.meta"

OUT_MD = REPORT_DIR / "BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE_RESULT.json"
CONTACT = REPORT_DIR / "BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE_CONTACT_SHEET.jpg"
UNITY_LOG = REPORT_DIR / "BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE.log"


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


def script_guid(path):
    if not path.exists():
        return ""
    for line in path.read_text(encoding="utf-8-sig").splitlines():
        if line.startswith("guid:"):
            return line.split(":", 1)[1].strip()
    return ""


def scene_yaml_summary(guid):
    text = B45_SCENE.read_text(encoding="utf-8-sig", errors="replace") if B45_SCENE.exists() else ""
    return {
        "sceneExists": B45_SCENE.exists(),
        "empty4RaycastIdentifierCount": text.count("UnityEngine.UI.Empty4Raycast"),
        "empty4RaycastScriptGuidCount": text.count(guid) if guid else 0,
        "missingScriptFileId0Count": text.count("m_Script: {fileID: 0}"),
        "oldEditorClassIdentifierPatternCount": text.count("m_EditorClassIdentifier: Assembly-CSharp::UnityEngine.UI.Empty4Raycast"),
    }


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


def row_summary():
    rows = read_csv(ROWS_CSV)
    probes = [r for r in rows if r.get("status") == "registry_and_raycast_probe"]
    reasons = {}
    registry_yes = 0
    ready = 0
    samples = []
    for row in probes:
        reason = row.get("raycastReason") or "unknown"
        reasons[reason] = reasons.get(reason, 0) + 1
        if row.get("targetInRegistry") == "true":
            registry_yes += 1
        if row.get("raycastReady") == "true":
            ready += 1
        if len(samples) < 10:
            samples.append({
                "buttonScenePath": row.get("buttonScenePath"),
                "targetType": row.get("boundTargetGraphicType"),
                "targetInRegistry": row.get("targetInRegistry"),
                "registryCount": row.get("registryCount"),
                "hitCount": row.get("hitCount"),
                "reason": reason,
                "canvas": row.get("canvasPath"),
                "eventCamera": row.get("eventCameraName"),
                "screen": row.get("screen"),
            })
    return {
        "probeCount": len(probes),
        "registryIncludedCount": registry_yes,
        "raycastReadyCount": ready,
        "raycastReasonCounts": reasons,
        "samples": samples,
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
    sheet = Image.new("RGB", (1920, 860), (0, 0, 0))
    sheet.paste(panel("BATTLE44 candidate", B44_CAPTURE), (0, 0))
    sheet.paste(panel("BATTLE45 candidate", B45_CAPTURE), (640, 0))
    text = Image.new("RGB", (640, 360), (8, 8, 8))
    draw = ImageDraw.Draw(text)
    u = result["unitySummary"]
    lines = [
        "BATTLE_45 summary",
        f"visual_status: {result['visual_status']}",
        f"final restored: {result['isFinalRestoredBattleScreen']}",
        f"script guid: {u.get('empty4RaycastMonoScriptGuid')}",
        f"Empty4Raycast before/after/reopen: {u.get('before', {}).get('empty4Raycast')} / {u.get('after', {}).get('empty4Raycast')} / {u.get('reopen', {}).get('empty4Raycast')}",
        f"missing before/reopen: {u.get('before', {}).get('missingScript')} / {u.get('reopen', {}).get('missingScript')}",
        f"registry included reopen: {u.get('reopenRegistryTargetIncludedCount')}",
        f"raycast ready reopen: {u.get('reopenRaycastReadyButtonCount')}",
        f"next blocker: {result['nextBlocker']}",
    ]
    y = 18
    for line in lines:
        draw.text((18, y), line, fill=(235, 235, 235))
        y += 27
    sheet.paste(text, (1280, 0))
    sheet.paste(panel("BATTLE45 candidate detail", B45_CAPTURE, (960, 500)), (0, 360))
    notes = Image.new("RGB", (960, 500), (8, 8, 8))
    draw = ImageDraw.Draw(notes)
    note_lines = [
        "No fake HUD/card/icon, screenshot paste, whole-atlas placement, or fake onClick.",
        "Patch scope: Empty4Raycast MonoScript persistence and GraphicRegistry/raycast probes.",
        f"play video available: {PLAY_VIDEO.exists()} {PLAY_VIDEO}",
        f"aux reference available: {AUX_VIDEO.exists()} {AUX_VIDEO}",
        "Mask/TMP counted only; final playable remains false.",
    ]
    y = 20
    for line in note_lines:
        draw.text((18, y), line, fill=(235, 235, 235))
        y += 30
    sheet.paste(notes, (960, 360))
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT, quality=92)


def verify(unity_exit):
    unity = read_json(UNITY_JSON, {})
    b44 = read_json(B44_JSON, {})
    rows = row_summary()
    guid = script_guid(EMPTY_SCRIPT_META)
    yaml = scene_yaml_summary(guid)
    ready = int(unity.get("reopenRaycastReadyButtonCount") or 0)
    registry = int(unity.get("reopenRegistryTargetIncludedCount") or 0)
    empty_reopen = int(unity.get("reopenEmpty4RaycastCount") or 0)

    if unity_exit != 0:
        visual_status = "failed_unity_batch_or_compile"
        blocker = "Unity batch/probe did not complete."
        next_blocker = "BATTLE_46_FIX_BATTLE45_COMPILE_OR_BATCH_ERROR"
    elif ready > 0:
        visual_status = "empty4raycast_persistence_and_raycast_improved_but_final_playable_false"
        blocker = "Empty4Raycast now persists and at least one target raycasts, but Lua/IL2CPP click handlers, Mask/TMP, actor runtime binding, and reference alignment remain incomplete."
        next_blocker = "BATTLE_46_BIND_RAYCAST_READY_BUTTONS_TO_ORIGINAL_LUA_IL2CPP_HANDLERS_AND_TRACE_MASK_TMP"
    elif registry > 0:
        visual_status = "empty4raycast_persists_and_registry_includes_targets_but_raycast_still_misses"
        blocker = "Targets enter GraphicRegistry after reopen, but GraphicRaycaster still does not hit them at target centers."
        next_blocker = "BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS"
    elif empty_reopen >= 7:
        visual_status = "empty4raycast_persistence_fixed_but_registry_not_ready"
        blocker = "Empty4Raycast persistence improved, but target Graphics are not registered for raycast after reopen."
        next_blocker = "BATTLE_46_TRACE_GRAPHIC_REGISTRY_REGISTRATION_CONDITIONS"
    else:
        visual_status = "failed_empty4raycast_persistence_or_registry_not_ready"
        blocker = "Empty4Raycast still does not persist/register enough targets after reopen."
        next_blocker = "BATTLE_46_TRACE_MONOSCRIPT_SERIALIZATION_AND_CANVAS_ENABLE_ORDER"

    result = {
        "verdict": "BATTLE45 traced Empty4Raycast MonoScript persistence, Canvas/GraphicRaycaster/EventSystem/camera, GraphicRegistry, and raycast readiness; final playable screen remains false",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "unityExitCode": unity_exit,
        "referenceVideoAvailable": PLAY_VIDEO.exists(),
        "referenceVideoPath": str(PLAY_VIDEO),
        "auxiliaryReferenceVideoAvailable": AUX_VIDEO.exists(),
        "auxiliaryReferenceVideoPath": str(AUX_VIDEO),
        "unitySummary": unity,
        "rowSummary": rows,
        "sceneYamlSummary": yaml,
        "empty4RaycastScript": {
            "path": str(EMPTY_SCRIPT),
            "meta": str(EMPTY_SCRIPT_META),
            "guid": guid,
            "exists": EMPTY_SCRIPT.exists(),
        },
        "battle44Carryover": {
            "visual_status": b44.get("visual_status"),
            "reopenEmpty4RaycastCount": b44.get("unitySummary", {}).get("reopen", {}).get("empty4Raycast"),
            "reopenRaycastReadyButtonCount": b44.get("unitySummary", {}).get("reopenRaycastReadyButtonCount"),
            "raycastFailureReasons": b44.get("unitySummary", {}).get("raycastFailureReasons"),
        },
        "captureMetrics": capture_metrics(B45_CAPTURE),
        "battle44ToBattle45CaptureSimilarity": image_similarity(B44_CAPTURE, B45_CAPTURE),
        "blocker": blocker,
        "nextBlocker": next_blocker,
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "unityDataJson": str(UNITY_JSON),
            "rowsCsv": str(ROWS_CSV),
            "capture": str(B45_CAPTURE),
            "contactSheet": str(CONTACT),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "BATTLE45 does not add fake visible art, fake HUD/cards/icons, screenshot paste, whole-atlas placement, or fake onClick handlers.",
            "플레이.mp4 remains missing when referenceVideoAvailable is false; 참고.mp4 is auxiliary only.",
            "Mask/TMP are counted only in BATTLE45.",
        ],
    }
    make_contact(result)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    u = unity
    md = [
        "# BATTLE_45 Trace Canvas GraphicRegistry Camera And Empty4Raycast Runtime Enable Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE45는 `Empty4Raycast` MonoScript persistence를 전용 파일로 분리해 검증하고, Canvas/GraphicRaycaster/EventSystem/eventCamera/GraphicRegistry/raycast 조건을 targetGraphic 중심 좌표 기준으로 추적했다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- Unity exit code: `{unity_exit}`",
        f"- reference video available: `{PLAY_VIDEO.exists()}` (`{PLAY_VIDEO}`)",
        f"- auxiliary reference video available: `{AUX_VIDEO.exists()}` (`{AUX_VIDEO}`)",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Empty4Raycast Persistence",
        f"- MonoScript path: `{u.get('empty4RaycastMonoScriptPath')}`",
        f"- MonoScript guid: `{u.get('empty4RaycastMonoScriptGuid')}`",
        f"- MonoScript class: `{u.get('empty4RaycastMonoScriptClass')}`",
        f"- Empty4Raycast before/after/reopen: `{u.get('before', {}).get('empty4Raycast')}` / `{u.get('after', {}).get('empty4Raycast')}` / `{u.get('reopen', {}).get('empty4Raycast')}`",
        f"- missing scripts before/reopen: `{u.get('before', {}).get('missingScript')}` / `{u.get('reopen', {}).get('missingScript')}`",
        f"- scene YAML summary: `{yaml}`",
        "",
        "## Registry And Raycast",
        f"- Button before/after/reopen: `{u.get('before', {}).get('button')}` / `{u.get('after', {}).get('button')}` / `{u.get('reopen', {}).get('button')}`",
        f"- registry target included after/reopen: `{u.get('registryTargetIncludedCount')}` / `{u.get('reopenRegistryTargetIncludedCount')}`",
        f"- raycast-ready Button after/reopen: `{u.get('raycastReadyButtonCount')}` / `{u.get('reopenRaycastReadyButtonCount')}`",
        f"- row raycast reasons: `{rows.get('raycastReasonCounts')}`",
        f"- Mask/RectMask2D reopen: `{u.get('reopenMaskCount')}` / `{u.get('reopenRectMask2DCount')}`",
        f"- TMP/Text reopen: `{u.get('reopenTmpCount')}` / `{u.get('reopenTextCount')}`",
        f"- BATTLE44→BATTLE45 capture similarity: `{result['battle44ToBattle45CaptureSimilarity']}`",
        "",
        "## Blocker",
        f"- {blocker}",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_JSON}`",
        f"- component CSV: `{ROWS_CSV}`",
        f"- capture: `{B45_CAPTURE}`",
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
        "reopenEmpty4RaycastCount": u.get("reopenEmpty4RaycastCount"),
        "reopenMissingScriptCount": u.get("reopenMissingScriptCount"),
        "reopenRegistryTargetIncludedCount": u.get("reopenRegistryTargetIncludedCount"),
        "reopenRaycastReadyButtonCount": u.get("reopenRaycastReadyButtonCount"),
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
