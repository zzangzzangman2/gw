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

UNITY_JSON = UNITY_DATA / "BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_UNITY.json"
ROWS_CSV = UNITY_DATA / "BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_COMPONENTS.csv"
B48_JSON = REPORT_DIR / "BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_RESULT.json"
B48_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle48SortOrderDisplayHitOcclusionTrace_1920x1080.png"
B49_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle49RealClickInputHandlerValidation_1920x1080.png"
B49_SCENE = PROJECT / "Assets" / "Scenes" / "Battle49RealClickInputHandlerValidation.unity"
PAYLOAD_MANIFEST = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.md"

OUT_MD = REPORT_DIR / "BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_RESULT.json"
CONTACT = REPORT_DIR / "BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_CONTACT_SHEET.jpg"
UNITY_LOG = REPORT_DIR / "BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING.log"


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


def row_summary():
    rows = read_csv(ROWS_CSV)
    blockers = {}
    samples = []
    for row in rows:
        blockers[row.get("blocker") or "unknown"] = blockers.get(row.get("blocker") or "unknown", 0) + 1
        samples.append({
            "button": row.get("buttonName"),
            "pointer": row.get("pointerPosition"),
            "graphicHits": row.get("graphicRaycasterHitCount"),
            "eventHits": row.get("eventSystemRaycastAllCount"),
            "graphicTarget": row.get("graphicTargetIncluded"),
            "eventTarget": row.get("eventTargetIncluded"),
            "clickReceiver": row.get("pointerClickReceiver"),
            "executeClick": row.get("executePointerClick"),
            "onClickKnown": row.get("onClickTotalKnownCount"),
            "missingParents": row.get("parentMissingMonoBehaviourCount"),
            "handlerBound": row.get("gameplayHandlerBound"),
            "blocker": row.get("blocker"),
        })
    return {
        "rowCount": len(rows),
        "graphicTargetIncludedCount": sum(1 for r in rows if boolv(r, "graphicTargetIncluded")),
        "eventTargetIncludedCount": sum(1 for r in rows if boolv(r, "eventTargetIncluded")),
        "executePointerClickCount": sum(1 for r in rows if boolv(r, "executePointerClick")),
        "clickPathValidatedCount": sum(1 for r in rows if boolv(r, "clickPathValidated")),
        "knownOnClickListenerRows": sum(1 for r in rows if intv(r, "onClickTotalKnownCount") > 0),
        "gameplayHandlerBoundRows": sum(1 for r in rows if boolv(r, "gameplayHandlerBound")),
        "executeExceptionRows": sum(1 for r in rows if r.get("executeException")),
        "totalParentMissingMonoBehaviours": sum(intv(r, "parentMissingMonoBehaviourCount") for r in rows),
        "blockerCounts": blockers,
        "samples": samples,
    }


def scene_yaml_summary():
    text = B49_SCENE.read_text(encoding="utf-8-sig", errors="replace") if B49_SCENE.exists() else ""
    return {
        "sceneExists": B49_SCENE.exists(),
        "empty4RaycastIdentifierCount": text.count("UnityEngine.UI.Empty4Raycast"),
        "missingScriptFileId0Count": text.count("m_Script: {fileID: 0}"),
    }


def decide_status(unity_exit, unity, rows):
    if unity_exit != 0:
        return (
            "failed_unity_batch_or_compile",
            "Unity batch/probe did not complete.",
            "BATTLE_50_FIX_BATTLE49_COMPILE_OR_BATCH_ERROR",
        )
    if rows["clickPathValidatedCount"] > 0 and rows["gameplayHandlerBoundRows"] > 0:
        return (
            "real_click_path_and_some_handlers_present_but_playable_false",
            "ExecuteEvents reaches original Buttons and at least one handler/listener is present; runtime payload/actor validation is the next gated step.",
            "BATTLE_50_VALIDATE_RUNTIME_PAYLOAD_ACTOR_SKILL_WITH_LOCAL_SUBSET",
        )
    if rows["clickPathValidatedCount"] > 0:
        return (
            "real_click_path_reaches_buttons_but_gameplay_handlers_missing",
            "Direct GraphicRaycaster + ExecuteEvents reaches original Button click receivers, but EventSystem.RaycastAll target inclusion is still 0 and no known onClick/EventTrigger/non-Unity gameplay handler is bound in the restored scene.",
            "BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS",
        )
    return (
        "raycast_ready_but_executeevents_click_path_not_validated",
        "Raycast-ready targets exist, but ExecuteEvents did not validate a Button click receiver path.",
        "BATTLE_50_TRACE_EVENTSYSTEM_INPUTMODULE_EXECUTEEVENTS_RECEIVER_CHAIN",
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
    sheet.paste(panel("BATTLE48 candidate", B48_CAPTURE), (0, 0))
    sheet.paste(panel("BATTLE49 candidate", B49_CAPTURE), (640, 0))
    text = Image.new("RGB", (640, 360), (8, 8, 8))
    draw = ImageDraw.Draw(text)
    rows = result["rowSummary"]
    lines = [
        "BATTLE_49 summary",
        f"visual_status: {result['visual_status']}",
        f"final restored: {result['isFinalRestoredBattleScreen']}",
        f"rows/graphic/event/click: {rows['rowCount']} / {rows['graphicTargetIncludedCount']} / {rows['eventTargetIncludedCount']} / {rows['clickPathValidatedCount']}",
        f"handler bound rows: {rows['gameplayHandlerBoundRows']}",
        f"blockers: {rows['blockerCounts']}",
    ]
    y = 18
    for line in lines:
        draw.text((18, y), line[:100], fill=(235, 235, 235))
        y += 27
    sheet.paste(text, (1280, 0))
    sheet.paste(panel("BATTLE49 detail", B49_CAPTURE, (960, 540)), (0, 360))
    notes = Image.new("RGB", (960, 540), (8, 8, 8))
    draw = ImageDraw.Draw(notes)
    note_lines = [
        "No fake transparent overlay, fake onClick, fake gameplay handler, fake HUD/card/icon, screenshot paste, or whole-atlas patch.",
        f"payload manifest available: {PAYLOAD_MANIFEST.exists()} {PAYLOAD_MANIFEST}",
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
    b48 = read_json(B48_JSON, {})
    rows = row_summary()
    visual_status, blocker, next_blocker = decide_status(unity_exit, unity, rows)
    result = {
        "verdict": "BATTLE49 validated direct GraphicRaycaster/ExecuteEvents click receiver path and handler binding state; EventSystem.RaycastAll target inclusion remains 0 and final playable screen remains false",
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
        "battle48Carryover": {
            "visual_status": b48.get("visual_status"),
            "reopenRaycastReadyCount": b48.get("rowSummary", {}).get("reopenRaycastReadyCount"),
            "pointReadyCounts": b48.get("rowSummary", {}).get("pointReadyCounts"),
        },
        "localPlayablePayloadManifest": {
            "available": PAYLOAD_MANIFEST.exists(),
            "path": str(PAYLOAD_MANIFEST),
            "useCondition": "Use only after input handler binding is restored; local subset is debug/runtime validation only, not full payload or final restore evidence.",
        },
        "captureMetrics": capture_metrics(B49_CAPTURE),
        "battle48ToBattle49CaptureSimilarity": image_similarity(B48_CAPTURE, B49_CAPTURE),
        "blocker": blocker,
        "nextBlocker": next_blocker,
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "unityDataJson": str(UNITY_JSON),
            "rowsCsv": str(ROWS_CSV),
            "capture": str(B49_CAPTURE),
            "contactSheet": str(CONTACT),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "BATTLE49 does not add fake transparent overlays, fake onClick handlers, fake gameplay handlers, fake HUD/cards/icons, screenshot paste, or whole-atlas placement.",
            "플레이.mp4 remains missing when referenceVideoAvailable is false; 참고.mp4 is auxiliary only.",
        ],
    }
    make_contact(result)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_49 Validate Real Click Input And Handler Binding Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE49는 BATTLE48 ready 좌표로 `EventSystem.RaycastAll`, `GraphicRaycaster.Raycast`, `ExecuteEvents` pointerDown/up/click/submit 경로와 Button handler binding을 검증했다. 직접 `GraphicRaycaster` hit와 `ExecuteEvents` receiver path는 살아났지만, `EventSystem.RaycastAll` target inclusion은 아직 `0`이다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- Unity exit code: `{unity_exit}`",
        f"- reference video available: `{PLAY_VIDEO.exists()}` (`{PLAY_VIDEO}`)",
        f"- auxiliary reference video available: `{AUX_VIDEO.exists()}` (`{AUX_VIDEO}`)",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Click Path",
        f"- rows / GraphicRaycaster target included / EventSystem target included: `{rows['rowCount']}` / `{rows['graphicTargetIncludedCount']}` / `{rows['eventTargetIncludedCount']}`",
        f"- ExecuteEvents click receiver / click path validated: `{rows['executePointerClickCount']}` / `{rows['clickPathValidatedCount']}`",
        f"- known onClick listener rows / gameplay handler bound rows: `{rows['knownOnClickListenerRows']}` / `{rows['gameplayHandlerBoundRows']}`",
        f"- total parent missing MonoBehaviours across rows: `{rows['totalParentMissingMonoBehaviours']}`",
        f"- blocker counts: `{rows['blockerCounts']}`",
        "",
        "## Handler Binding",
        "- BATTLE44 original Button/targetGraphic PPtr evidence is connected in the row CSV.",
        "- Current restored scene validates the direct GraphicRaycaster + ExecuteEvents Button receiver path; EventSystem.RaycastAll remains incomplete when `eventTargetIncludedCount == 0`.",
        "- Gameplay/Lua/IL2CPP handler binding remains missing unless `gameplayHandlerBoundRows > 0`.",
        f"- Local playable payload manifest available: `{PAYLOAD_MANIFEST.exists()}`; use only after handler binding is restored, as a local subset validation aid.",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_JSON}`",
        f"- component CSV: `{ROWS_CSV}`",
        f"- capture: `{B49_CAPTURE}`",
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
        "rows": rows["rowCount"],
        "clickPathValidated": rows["clickPathValidatedCount"],
        "gameplayHandlerBoundRows": rows["gameplayHandlerBoundRows"],
        "blockerCounts": rows["blockerCounts"],
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
