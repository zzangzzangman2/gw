from __future__ import annotations

import argparse
import csv
import json
import re
from pathlib import Path
from typing import Any

import cv2
import numpy as np
from PIL import Image, ImageDraw
import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
MERGED = BASE / "girlswar_merged_extracted"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
NATIVE_DIR = BASE / "il2cpp_native"

PLAY_VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")

UNITY_JSON = UNITY_DATA / "BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_UNITY.json"
EVENTSYSTEM_CSV = UNITY_DATA / "BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_EVENTSYSTEM.csv"
HANDLER_CSV = REPORT_DIR / "BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_HANDLERS.csv"
MISSING_CHAIN_CSV = REPORT_DIR / "BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_MISSING_CHAIN.csv"
BUTTON_SUMMARY_CSV = REPORT_DIR / "BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_BUTTONS.csv"
DECODED_DIR = REPORT_DIR / "BATTLE_50_DECODED_MAINCITY_LUA"

B49_JSON = REPORT_DIR / "BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_RESULT.json"
B49_CSV = UNITY_DATA / "BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_COMPONENTS.csv"
B44_EVIDENCE_CSV = UNITY_DATA / "BATTLE_44_ORIGINAL_BUTTON_TARGET_GRAPHIC_EVIDENCE.csv"
B50_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle50OriginalLuaIl2cppButtonHandlerTrace_1920x1080.png"
B49_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle49RealClickInputHandlerValidation_1920x1080.png"

OUT_MD = REPORT_DIR / "BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_RESULT.json"
CONTACT = REPORT_DIR / "BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_CONTACT_SHEET.jpg"
UNITY_LOG = REPORT_DIR / "BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS.log"
PAYLOAD_MANIFEST = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.md"

SECURITY_XORSCALE_OFFSET = 0x5829D1
SECURITY_XORSCALE_SIZE = 22

BUTTON_ORDER = ["btnAuto", "btnBuff", "btnTwoSpeed", "btnFastSkill", "btn_box"]

HANDLER_WINDOWS = {
    "btnAuto": ("UI_NormalBattle", 86, 110, "btnAuto.onClick:AddListener", "ModulesInit.ProcedureNormalBattle.ChangeToAuto(true) / ChangeToManual"),
    "btnBuff": ("UI_NormalBattle", 180, 184, "btnBuff.onClick:AddListener", "ShowBuffView(f==false)"),
    "btnTwoSpeed": ("UI_NormalBattle", 111, 131, "btnTwoSpeed.onClick:AddListener", "ModulesInit.ProcedureNormalBattle.SetGameSpeed"),
    "btnFastSkill": ("UI_NormalBattle", 132, 146, "btnFastSkill.onClick:AddListener", "ModulesInit.ProcedureNormalBattle.ChangeGameFastSkill + CheckFastSkill"),
    "btn_box": ("UI_BattleBoxPage", 162, 178, "CS.YouYou.UIEventListener.onClick", "showFlyAction -> RecycleBoxInstance via UIEventListener"),
}


def read_json(path: Path, fallback: Any) -> Any:
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def boolv(row: dict[str, str], key: str) -> bool:
    return (row.get(key) or "").lower() == "true"


def intv(row: dict[str, str], key: str) -> int:
    try:
        return int(float(row.get(key) or 0))
    except Exception:
        return 0


def count_cmds(path: Path) -> int:
    return len(list(path.glob("*.cmd"))) if path.exists() else 0


def repeating_xor(data: bytes, key: bytes) -> bytes:
    return bytes(b ^ key[i % len(key)] for i, b in enumerate(data))


def decode_maincity_lua() -> dict[str, Path]:
    DECODED_DIR.mkdir(parents=True, exist_ok=True)
    key = (NATIVE_DIR / "global-metadata.dat").read_bytes()[SECURITY_XORSCALE_OFFSET : SECURITY_XORSCALE_OFFSET + SECURITY_XORSCALE_SIZE]
    bundle = MERGED / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "xlualogic" / "modules" / "maincity.assetbundle"
    targets = {"UI_NormalBattle", "UI_Battle3DUI", "UI_BattleBoxPage", "UI_NormalBattle_HeroItem", "UI_NormalBattle_Pause"}
    outputs: dict[str, Path] = {}
    env = UnityPy.load(bundle.read_bytes())
    for obj in env.objects:
        if obj.type.name != "TextAsset":
            continue
        data = obj.read()
        name = str(getattr(data, "m_Name", None) or getattr(data, "name", None) or obj.path_id)
        if name not in targets:
            continue
        payload = getattr(data, "script", None)
        if payload is None:
            payload = getattr(data, "m_Script", None)
        raw = payload if isinstance(payload, bytes) else str(payload).encode("utf-8", "surrogateescape")
        decoded = repeating_xor(raw, key)
        out = DECODED_DIR / f"{obj.path_id}_{name}.lua"
        out.write_bytes(decoded)
        outputs[name] = out
    return outputs


def line_slice(path: Path, start: int, end: int) -> str:
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    selected = []
    for n in range(start, min(end, len(lines)) + 1):
        selected.append(f"{n}:{lines[n - 1].strip()}")
    return " | ".join(selected)


def build_handler_rows(decoded: dict[str, Path]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for button in BUTTON_ORDER:
        module, start, end, binding_kind, method = HANDLER_WINDOWS[button]
        source = decoded.get(module)
        rows.append(
            {
                "buttonName": button,
                "sourceModule": module,
                "sourceFile": str(source or ""),
                "lineStart": start,
                "lineEnd": end,
                "bindingKind": binding_kind,
                "handlerMethodCandidate": method,
                "evidenceSnippet": line_slice(source, start, end) if source and source.exists() else "missing_decoded_lua",
                "bridgeRequirement": bridge_requirement(button),
                "sourceBacked": bool(source and source.exists()),
            }
        )
    # Panel-level bridge evidence for btn_box.
    battle3d = decoded.get("UI_Battle3DUI")
    rows.append(
        {
            "buttonName": "btn_box_panel_bridge",
            "sourceModule": "UI_Battle3DUI",
            "sourceFile": str(battle3d or ""),
            "lineStart": 3,
            "lineEnd": 20,
            "bindingKind": "panel LuaUnit bridge",
            "handlerMethodCandidate": "UI_BattleBoxPage:GetComponent(typeof(CS.YouYou.LuaUnit)):Init/Open",
            "evidenceSnippet": line_slice(battle3d, 3, 20) if battle3d and battle3d.exists() else "missing_decoded_lua",
            "bridgeRequirement": "CS.YouYou.LuaUnit on UI_BattleBoxPage plus LuaComBinder components dictionary",
            "sourceBacked": bool(battle3d and battle3d.exists()),
        }
    )
    return rows


def bridge_requirement(button: str) -> str:
    if button == "btn_box":
        return "CS.YouYou.UIEventListener runtime component on btn_box plus CS.YouYou.LuaUnit/LuaComBinder on UI_BattleBoxPage"
    return "UI_NormalBattle Lua panel lifecycle must run OnInit, with Lua globals bound to UnityEngine.UI.Button fields"


def build_missing_chain_rows(event_rows: list[dict[str, str]]) -> list[dict[str, Any]]:
    rows = []
    for row in event_rows:
        rows.append(
            {
                "buttonName": row.get("buttonName"),
                "buttonScenePath": row.get("buttonScenePath"),
                "missingOnButton": row.get("missingOnButton"),
                "missingOnParents": row.get("missingOnParents"),
                "buttonComponentTypes": row.get("buttonComponentTypes"),
                "missingComponentChain": row.get("missingComponentChain"),
                "minimumRequiredChainCandidate": minimum_chain(row.get("buttonName") or ""),
                "patchDecision": "blocked_no_patch",
            }
        )
    return rows


def minimum_chain(button: str) -> str:
    if button == "btn_box":
        return "Restore original CS.YouYou.LuaUnit/LuaComBinder for UI_BattleBoxPage and CS.YouYou.UIEventListener bridge on btn_box; do not fake onClick."
    return "Restore source-backed Lua panel bridge that runs UI_NormalBattle.OnInit and binds Button.onClick AddListener closures; do not fake UnityEvent."


def build_button_summary(
    b49_rows: list[dict[str, str]],
    b44_rows: list[dict[str, str]],
    event_rows: list[dict[str, str]],
    handler_rows: list[dict[str, Any]],
) -> list[dict[str, Any]]:
    by_button_b49 = {r.get("buttonName"): r for r in b49_rows}
    by_button_event = {r.get("buttonName"): r for r in event_rows}
    by_button_handler = {r.get("buttonName"): r for r in handler_rows if r.get("buttonName") in BUTTON_ORDER}
    summaries = []
    for button in BUTTON_ORDER:
        b49 = by_button_b49.get(button, {})
        ev = by_button_event.get(button, {})
        handler = by_button_handler.get(button, {})
        originals = [r for r in b44_rows if button in (r.get("originalButtonPath") or "")]
        original = next((r for r in originals if (r.get("patchEligible") or "").lower() == "true"), originals[0] if originals else {})
        summaries.append(
            {
                "buttonName": button,
                "originalButtonPath": b49.get("originalButtonPath") or original.get("originalButtonPath"),
                "originalButtonScriptPathId": b49.get("originalButtonScriptPathId") or original.get("buttonScriptPathId"),
                "originalButtonScriptType": original.get("buttonFullName") or "UnityEngine.UI.Button",
                "originalTargetGraphicRef": b49.get("originalTargetGraphicRef") or original.get("targetGraphicRef"),
                "originalTargetType": b49.get("originalTargetFullName") or original.get("targetFullName"),
                "luaSourceModule": handler.get("sourceModule"),
                "luaLines": f"{handler.get('lineStart')}-{handler.get('lineEnd')}",
                "handlerMethodCandidate": handler.get("handlerMethodCandidate"),
                "bridgeRequirement": handler.get("bridgeRequirement"),
                "currentMissingOnButton": ev.get("missingOnButton") or b49.get("buttonMissingMonoBehaviourCount"),
                "currentMissingOnParents": ev.get("missingOnParents") or b49.get("parentMissingMonoBehaviourCount"),
                "eventSystemRaycastAllCause": ev.get("eventSystemRootCause") or "not_probed",
                "directGraphicRaycasterHitCount": ev.get("directGraphicRaycasterHitCount") or b49.get("graphicRaycasterHitCount"),
                "eventSystemRaycastAllCount": ev.get("eventSystemRaycastAllCount") or b49.get("eventSystemRaycastAllCount"),
                "eventSystemTargetIncluded": ev.get("eventTargetIncluded") or b49.get("eventTargetIncluded"),
                "currentRaycasterRegistered": ev.get("currentRaycasterRegistered"),
                "afterToggleRegistered": ev.get("currentRaycasterRegisteredAfterToggle"),
                "afterToggleEventTargetIncluded": ev.get("eventTargetIncludedAfterToggle"),
                "patchDecision": "blocked_no_patch",
            }
        )
    return summaries


def capture_metrics(path: Path) -> dict[str, Any]:
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


def image_similarity(a: Path, b: Path) -> dict[str, Any]:
    ia = cv2.imread(str(a))
    ib = cv2.imread(str(b))
    if ia is None or ib is None:
        return {"available": False}
    if ia.shape != ib.shape:
        ib = cv2.resize(ib, (ia.shape[1], ia.shape[0]))
    diff = float(np.mean(np.abs(ia.astype(np.float32) - ib.astype(np.float32))) / 255.0)
    corr = float(np.corrcoef(ia.reshape(-1).astype(float), ib.reshape(-1).astype(float))[0, 1])
    return {"available": True, "meanAbsDiff": round(diff, 6), "pixelCorrelation": round(corr, 6)}


def make_contact(result: dict[str, Any]) -> None:
    sheet = Image.new("RGB", (1920, 900), (0, 0, 0))
    sheet.paste(panel("BATTLE49 candidate", B49_CAPTURE), (0, 0))
    sheet.paste(panel("BATTLE50 candidate", B50_CAPTURE), (640, 0))
    text = Image.new("RGB", (640, 360), (8, 8, 8))
    draw = ImageDraw.Draw(text)
    lines = [
        "BATTLE_50 summary",
        f"visual_status: {result['visual_status']}",
        f"final restored: {result['isFinalRestoredBattleScreen']}",
        f"rows/direct/event: {result['rowSummary']['rowCount']} / {result['rowSummary']['directTargetIncludedCount']} / {result['rowSummary']['eventTargetIncludedCount']}",
        f"handler source-backed: {result['rowSummary']['sourceBackedHandlerRows']}",
        f"patch: {result['patchDecision']}",
    ]
    y = 18
    for line in lines:
        draw.text((18, y), line[:100], fill=(235, 235, 235))
        y += 27
    sheet.paste(text, (1280, 0))
    sheet.paste(panel("BATTLE50 detail", B50_CAPTURE, (960, 540)), (0, 360))
    notes = Image.new("RGB", (960, 540), (8, 8, 8))
    draw = ImageDraw.Draw(notes)
    note_lines = [
        "No fake transparent overlay, fake onClick, fake gameplay handler, fake HUD/card/icon, screenshot paste, or whole-atlas patch.",
        f"play video available: {PLAY_VIDEO.exists()} {PLAY_VIDEO}",
        f"aux reference available: {AUX_VIDEO.exists()} {AUX_VIDEO}",
        f"payload manifest available: {PAYLOAD_MANIFEST.exists()} use only after handler binding",
    ]
    y = 20
    for line in note_lines:
        draw.text((18, y), line[:135], fill=(235, 235, 235))
        y += 30
    sheet.paste(notes, (960, 360))
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT, quality=92)


def panel(label: str, path: Path, size=(640, 360)) -> Image.Image:
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


def row_summary(event_rows: list[dict[str, str]], handler_rows: list[dict[str, Any]]) -> dict[str, Any]:
    return {
        "rowCount": len(event_rows),
        "directTargetIncludedCount": sum(1 for r in event_rows if boolv(r, "directTargetIncluded")),
        "eventTargetIncludedCount": sum(1 for r in event_rows if boolv(r, "eventTargetIncluded")),
        "afterToggleEventTargetIncludedCount": sum(1 for r in event_rows if boolv(r, "eventTargetIncludedAfterToggle")),
        "raycasterRegisteredCount": sum(1 for r in event_rows if boolv(r, "currentRaycasterRegistered")),
        "afterToggleRaycasterRegisteredCount": sum(1 for r in event_rows if boolv(r, "currentRaycasterRegisteredAfterToggle")),
        "sourceBackedHandlerRows": sum(1 for r in handler_rows if r.get("sourceBacked")),
        "knownUnityEventRows": sum(1 for r in event_rows if intv(r, "buttonOnClickPersistentCount") + intv(r, "buttonOnClickRuntimeCount") > 0),
        "eventTriggerRows": sum(1 for r in event_rows if intv(r, "eventTriggerCount") > 0),
        "missingOnParentsTotal": sum(intv(r, "missingOnParents") for r in event_rows),
        "eventRootCauseCounts": counts(r.get("eventSystemRootCause", "unknown") for r in event_rows),
    }


def counts(values) -> dict[str, int]:
    out: dict[str, int] = {}
    for value in values:
        out[value] = out.get(value, 0) + 1
    return out


def verify(unity_exit: int) -> None:
    decoded = decode_maincity_lua()
    handler_rows = build_handler_rows(decoded)
    write_csv(
        HANDLER_CSV,
        handler_rows,
        ["buttonName", "sourceModule", "sourceFile", "lineStart", "lineEnd", "bindingKind", "handlerMethodCandidate", "evidenceSnippet", "bridgeRequirement", "sourceBacked"],
    )

    b49 = read_json(B49_JSON, {})
    unity = read_json(UNITY_JSON, {})
    b49_rows = read_csv(B49_CSV)
    b44_rows = read_csv(B44_EVIDENCE_CSV)
    event_rows = read_csv(EVENTSYSTEM_CSV)
    missing_rows = build_missing_chain_rows(event_rows)
    write_csv(
        MISSING_CHAIN_CSV,
        missing_rows,
        ["buttonName", "buttonScenePath", "missingOnButton", "missingOnParents", "buttonComponentTypes", "missingComponentChain", "minimumRequiredChainCandidate", "patchDecision"],
    )
    button_rows = build_button_summary(b49_rows, b44_rows, event_rows, handler_rows)
    write_csv(
        BUTTON_SUMMARY_CSV,
        button_rows,
        [
            "buttonName",
            "originalButtonPath",
            "originalButtonScriptPathId",
            "originalButtonScriptType",
            "originalTargetGraphicRef",
            "originalTargetType",
            "luaSourceModule",
            "luaLines",
            "handlerMethodCandidate",
            "bridgeRequirement",
            "currentMissingOnButton",
            "currentMissingOnParents",
            "eventSystemRaycastAllCause",
            "directGraphicRaycasterHitCount",
            "eventSystemRaycastAllCount",
            "eventSystemTargetIncluded",
            "currentRaycasterRegistered",
            "afterToggleRegistered",
            "afterToggleEventTargetIncluded",
            "patchDecision",
        ],
    )

    rows = row_summary(event_rows, handler_rows)
    visual_status = "original_lua_handlers_traced_but_missing_bridge_and_eventsystem_registration_block_patch"
    patch_decision = "blocked_no_patch"
    next_blocker = "BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION"
    result = {
        "verdict": "BATTLE50 traced original Lua/IL2CPP button handler candidates and narrowed restored-scene blockers; final playable screen remains false",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "unityExitCode": unity_exit,
        "referenceVideoAvailable": PLAY_VIDEO.exists(),
        "referenceVideoPath": str(PLAY_VIDEO),
        "auxiliaryReferenceVideoAvailable": AUX_VIDEO.exists(),
        "auxiliaryReferenceVideoPath": str(AUX_VIDEO),
        "unitySummary": unity,
        "battle49Carryover": {
            "visual_status": b49.get("visual_status"),
            "directGraphicRaycasterClickPathValidated": b49.get("rowSummary", {}).get("clickPathValidatedCount"),
            "eventSystemTargetIncludedCount": b49.get("rowSummary", {}).get("eventTargetIncludedCount"),
        },
        "rowSummary": rows,
        "buttonRows": button_rows,
        "patchDecision": patch_decision,
        "nextBlocker": next_blocker,
        "captureMetrics": capture_metrics(B50_CAPTURE),
        "battle49ToBattle50CaptureSimilarity": image_similarity(B49_CAPTURE, B50_CAPTURE),
        "localPlayablePayloadManifest": {
            "available": PAYLOAD_MANIFEST.exists(),
            "path": str(PAYLOAD_MANIFEST),
            "useCondition": "Use only after source-backed handler binding is restored; local subset is debug/runtime validation only, not full payload or final restore evidence.",
        },
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "eventSystemCsv": str(EVENTSYSTEM_CSV),
            "handlerCsv": str(HANDLER_CSV),
            "missingChainCsv": str(MISSING_CHAIN_CSV),
            "buttonSummaryCsv": str(BUTTON_SUMMARY_CSV),
            "decodedLuaDir": str(DECODED_DIR),
            "capture": str(B50_CAPTURE),
            "contactSheet": str(CONTACT),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "BATTLE50 does not add fake transparent overlays, fake onClick handlers, fake gameplay handlers, fake HUD/cards/icons, screenshot paste, or whole-atlas placement.",
            "플레이.mp4 remains missing when referenceVideoAvailable is false; 참고.mp4 is auxiliary only.",
        ],
    }
    make_contact(result)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    write_markdown(result)
    print(json.dumps({
        "visual_status": visual_status,
        "rows": rows,
        "patchDecision": patch_decision,
        "nextBlocker": next_blocker,
        "rootCmdCount": result["rootCmdCount"],
        "restoreToolsDirectCmdCount": result["restoreToolsDirectCmdCount"],
    }, ensure_ascii=False, indent=2))


def write_markdown(result: dict[str, Any]) -> None:
    rows = result["rowSummary"]
    md = [
        "# BATTLE_50 Trace Original Lua IL2CPP Button Handler Binding And Missing Scripts Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE50은 BATTLE49의 5개 ready button에 대해 원본 Lua handler, 원본 Button/targetGraphic PPtr, restored scene missing component chain, EventSystem.RaycastAll 원인을 분리했다.",
        "",
        "## Verdict",
        f"- visual_status: `{result['visual_status']}`",
        "- final screen claim: `false`",
        f"- patch decision: `{result['patchDecision']}`",
        f"- Unity exit code: `{result['unityExitCode']}`",
        f"- reference video available: `{result['referenceVideoAvailable']}` (`{result['referenceVideoPath']}`)",
        f"- auxiliary reference video available: `{result['auxiliaryReferenceVideoAvailable']}` (`{result['auxiliaryReferenceVideoPath']}`)",
        "",
        "## Handler Evidence",
        "- `btnAuto`: `UI_NormalBattle` lines `86-110`, `btnAuto.onClick:AddListener`, calls `ChangeToAuto(true)` or `ChangeToManual()`.",
        "- `btnBuff`: `UI_NormalBattle` lines `180-184`, `btnBuff.onClick:AddListener`, calls `ShowBuffView(f==false)`.",
        "- `btnTwoSpeed`: `UI_NormalBattle` lines `111-131`, calls `ModulesInit.ProcedureNormalBattle.SetGameSpeed()`.",
        "- `btnFastSkill`: `UI_NormalBattle` lines `132-146`, calls `ChangeGameFastSkill()` and `CheckFastSkill()`.",
        "- `btn_box`: `UI_BattleBoxPage` lines `162-178`, requires `CS.YouYou.UIEventListener` and assigns `s.onClick=function()`.",
        "- `UI_Battle3DUI` lines `3-20` require `UI_BattleBoxPage:GetComponent(typeof(CS.YouYou.LuaUnit)):Init/Open`.",
        "",
        "## Current Restored Blockers",
        f"- direct GraphicRaycaster target included: `{rows['directTargetIncludedCount']}` / `{rows['rowCount']}`",
        f"- EventSystem target included: `{rows['eventTargetIncludedCount']}` / `{rows['rowCount']}`",
        f"- EventSystem target after raycaster toggle probe: `{rows['afterToggleEventTargetIncludedCount']}` / `{rows['rowCount']}`",
        f"- source-backed handler evidence rows: `{rows['sourceBackedHandlerRows']}`",
        f"- known restored UnityEvent/EventTrigger rows: `{rows['knownUnityEventRows']}` / `{rows['eventTriggerRows']}`",
        f"- missing MonoBehaviours on button/parents total: `{rows['missingOnParentsTotal']}`",
        f"- EventSystem root-cause counts: `{rows['eventRootCauseCounts']}`",
        "",
        "## Patch Decision",
        "- `blocked_no_patch`: original Lua handler path is identified, but the restored scene lacks the source-backed bridge components that execute Lua `OnInit`/`Open` and bind runtime listeners.",
        "- Candidate binding must restore `CS.YouYou.LuaUnit` / Lua binding lifecycle and `CS.YouYou.UIEventListener` where original Lua requires it. Fake `onClick` or fake gameplay handler was not added.",
        "- `BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST` remains a local subset runtime aid only after handler binding is restored.",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- EventSystem CSV: `{EVENTSYSTEM_CSV}`",
        f"- handler CSV: `{HANDLER_CSV}`",
        f"- missing chain CSV: `{MISSING_CHAIN_CSV}`",
        f"- button summary CSV: `{BUTTON_SUMMARY_CSV}`",
        f"- decoded Lua dir: `{DECODED_DIR}`",
        f"- capture: `{B50_CAPTURE}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Command Policy Check",
        f"- root CMD count: `{result['rootCmdCount']}`",
        f"- `_restore_tools` direct CMD count: `{result['restoreToolsDirectCmdCount']}`",
        "",
        "## Next Blocker",
        f"- `{result['nextBlocker']}`",
    ]
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("mode", choices=["verify"])
    parser.add_argument("--unity-exit", type=int, default=0)
    args = parser.parse_args()
    verify(args.unity_exit)


if __name__ == "__main__":
    main()
