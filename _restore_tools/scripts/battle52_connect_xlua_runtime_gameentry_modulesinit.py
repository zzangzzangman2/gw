from __future__ import annotations

import argparse
import csv
import json
import re
from pathlib import Path
from typing import Any

import cv2
from PIL import Image, ImageDraw


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
REPORT_DIR = BASE / "reports" / "battle"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
MERGED = BASE / "girlswar_merged_extracted"

PREFIX = "BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK"
EDIT_JSON = UNITY_DATA / f"{PREFIX}_EDITMODE.json"
EDIT_CSV = UNITY_DATA / f"{PREFIX}_EDITMODE.csv"
PLAY_JSON = UNITY_DATA / f"{PREFIX}_PLAYMODE.json"
PLAY_CSV = UNITY_DATA / f"{PREFIX}_PLAYMODE.csv"
TYPE_CSV = UNITY_DATA / f"{PREFIX}_TYPES.csv"
SCHEMA_CSV = REPORT_DIR / f"{PREFIX}_RUNTIME_DEPENDENCY_SCHEMA.csv"
SCHEMA_JSON = REPORT_DIR / f"{PREFIX}_RUNTIME_DEPENDENCY_SCHEMA.json"
BUTTONS_CSV = REPORT_DIR / f"{PREFIX}_BUTTONS.csv"
OUT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
OUT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
CONTACT = REPORT_DIR / f"{PREFIX}_CONTACT_SHEET.jpg"
LOG = REPORT_DIR / f"{PREFIX}.log"

B51_JSON = REPORT_DIR / "BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_RESULT.json"
B51_BUTTONS = REPORT_DIR / "BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_BUTTONS.csv"
B50_DIR = REPORT_DIR / "BATTLE_50_DECODED_MAINCITY_LUA"
NORMAL_LUA = B50_DIR / "874003978109174219_UI_NormalBattle.lua"
BATTLE3D_LUA = B50_DIR / "-712482409242173665_UI_Battle3DUI.lua"
BOX_LUA = B50_DIR / "8374052518232552317_UI_BattleBoxPage.lua"
PROC_LUA = MERGED / "decoded" / "xlua_battle" / "download_xlualogic_modules_procedure" / "-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua"
DUMP = MERGED / "extracted" / "il2cpp_dump" / "dump.cs"
B51_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle51LuaBridgeRaycasterRegistrationCandidate_1920x1080.png"
PLAY_VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")
PAYLOAD_MANIFEST = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.md"


BUTTON_ORDER = ["btnAuto", "btnBuff", "btnTwoSpeed", "btnFastSkill", "btn_box"]


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


def count_cmds(path: Path) -> int:
    return len(list(path.glob("*.cmd"))) if path.exists() else 0


def boolv(row: dict[str, str], key: str) -> bool:
    return (row.get(key) or "").lower() == "true"


def intv(row: dict[str, str], key: str) -> int:
    try:
        return int(float(row.get(key) or 0))
    except Exception:
        return 0


def line_text(path: Path, start: int, end: int) -> str:
    if not path.exists():
        return ""
    lines = path.read_text(encoding="utf-8-sig", errors="replace").splitlines()
    return "\n".join(f"{idx + 1}:{lines[idx]}" for idx in range(max(start - 1, 0), min(end, len(lines))))


def find_line(path: Path, pattern: str) -> int:
    if not path.exists():
        return 0
    rgx = re.compile(pattern)
    for idx, line in enumerate(path.read_text(encoding="utf-8-sig", errors="replace").splitlines(), 1):
        if rgx.search(line):
            return idx
    return 0


def dump_line(pattern: str) -> int:
    if not DUMP.exists():
        return 0
    rgx = re.compile(pattern)
    with DUMP.open("r", encoding="utf-8-sig", errors="replace") as f:
        for idx, line in enumerate(f, 1):
            if rgx.search(line):
                return idx
    return 0


def build_schema(edit: dict[str, Any]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []

    def add(component: str, required: str, status: str, evidence: str, required_by: str, blocker: str) -> None:
        rows.append(
            {
                "component": component,
                "requiredTypeOrGlobal": required,
                "status": status,
                "evidence": evidence,
                "requiredBy": required_by,
                "blockerIfMissing": blocker,
            }
        )

    add("xLua runtime", "XLua.LuaEnv", "missing_in_restored_unity_project", f"{DUMP}:{dump_line(r'public class LuaEnv')}", "YouYou.LuaManager.luaEnv and LoadUIScript", "blocked_missing_xlua_runtime")
    add("xLua runtime", "XLua.LuaTable", "missing_in_restored_unity_project", f"{DUMP}:{dump_line(r'public class LuaTable')}", "LuaForm/LuaUnit scriptEnv and LuaComBinder.GetComponents", "blocked_missing_xlua_runtime")
    add("xLua runtime", "XLua.LuaFunction", "missing_in_restored_unity_project", f"{DUMP}:{dump_line(r'public class LuaFunction')}", "LuaManager event delegates", "blocked_missing_xlua_runtime")
    add("GameEntry", "YouYou.GameEntry.Lua", "missing_in_restored_unity_project", f"{DUMP}:{dump_line(r'public class GameEntry')}; {DUMP}:{dump_line(r'public static LuaManager get_Lua')}", "LuaForm/LuaUnit lifecycle script loading and decoded Lua GameEntry.* calls", "blocked_missing_gameentry_lua_manager")
    add("LuaManager", "YouYou.LuaManager.LoadUIScript", "missing_in_restored_unity_project", f"{DUMP}:{dump_line(r'public object\[\] LoadUIScript')}", "LuaForm/LuaUnit OnInit/Init", "blocked_missing_lua_manager_loader")
    add("LuaManager loader", "MyLoader/GetLuaBuff/LoadLuaAssetBundle", "missing_in_restored_unity_project", f"{DUMP}:{dump_line(r'private byte\[\] MyLoader')}; {DUMP}:{dump_line(r'private byte\[\] GetLuaBuff')}", "Load decoded UI and procedure Lua bytes", "blocked_missing_lua_asset_loader")
    add("Bridge", "YouYou.LuaForm", "source_backed_stub_present_not_runtime_lifecycle", f"{DUMP}:{dump_line(r'public class LuaForm : UIFormBase')}", "UI_NormalBattle OnInit/Open", "blocked_stub_does_not_execute_xlua")
    add("Bridge", "YouYou.LuaUnit", "source_backed_stub_present_not_runtime_lifecycle", f"{DUMP}:{dump_line(r'public class LuaUnit : MonoBehaviour')}", "UI_Battle3DUI and UI_BattleBoxPage Init/Open", "blocked_stub_does_not_execute_xlua")
    add("Bridge", "LuaComponentBinder.LuaComBinder", "source_backed_stub_present_partial_schema_only", f"{DUMP}:{dump_line(r'public class LuaComBinder : MonoBehaviour')}", "UI_BattleBoxPage GenBox LuaUtils.GetLuaComBinder/GetComponents", "blocked_no_luatable_components")
    add("Bridge", "YouYou.UIEventListener.onClick", "source_backed_stub_present_delegate_unbound", f"{DUMP}:{dump_line(r'public class UIEventListener : MonoBehaviour')}", "btn_box lines 162-178", "blocked_no_lua_closure_delegate")
    add("Lua module table", "ModulesInit.ProcedureNormalBattle", "decoded_source_available_not_bootstrapped", f"{PROC_LUA}:1; SetGameSpeed:{find_line(PROC_LUA, r'function t\.SetGameSpeed')}; ChangeToAuto:{find_line(PROC_LUA, r'function t\.ChangeToAuto')}", "btnAuto/btnTwoSpeed/btnFastSkill/btnBuff/UI_Battle3DUI/UI_BattleBoxPage", "blocked_modulesinit_not_initialized")
    add("Lua global", "ModulesInit.PhotoArtistMgr", "required_unresolved", f"{NORMAL_LUA}:100", "btnAuto closure", "blocked_missing_photo_artist_mgr")
    add("Lua global", "GameFunction/GameFunctionType", "required_unresolved", f"{NORMAL_LUA}:95; {NORMAL_LUA}:118; {NORMAL_LUA}:139", "btnAuto/btnTwoSpeed/btnFastSkill gates", "blocked_missing_game_function_globals")
    add("Lua global", "LuaUtils", "required_unresolved", f"{NORMAL_LUA}:103; {BOX_LUA}:49; {BATTLE3D_LUA}:3", "UI state toggles and box item lifecycle", "blocked_missing_lua_utils")
    add("Lua global", "EventSystem/CommonEventId", "required_unresolved", f"{BATTLE3D_LUA}:8; {BOX_LUA}:24; {PROC_LUA}:3805", "Battle UI events and ProcedureNormalBattle auto/manual", "blocked_missing_lua_event_bus")
    add("Lua global", "SaveMgr/PlayerMgr/GameTools/SetTimeScaleType", "required_unresolved", f"{PROC_LUA}:933-947", "ProcedureNormalBattle.SetGameSpeed", "blocked_missing_save_player_time_globals")
    add("Lua global", "UIUtil/DOTween/GameEntry.CameraCtrl", "required_unresolved", f"{BOX_LUA}:163-178", "btn_box click reward animation", "blocked_missing_box_animation_runtime")
    return rows


def button_rows(edit_rows: list[dict[str, str]], play_rows: list[dict[str, str]], b51_rows: list[dict[str, str]], schema: list[dict[str, Any]]) -> list[dict[str, Any]]:
    edit_by = {(r.get("phase"), r.get("buttonName")): r for r in edit_rows}
    play_by = {r.get("buttonName"): r for r in play_rows if r.get("phase") == "playmode_one_frame"}
    b51_by = {r.get("buttonName"): r for r in b51_rows}
    out: list[dict[str, Any]] = []
    info = {
        "btnAuto": {
            "luaFile": str(NORMAL_LUA),
            "luaLines": "86-110",
            "handler": "UI_NormalBattle.OnInit btnAuto closure -> ModulesInit.ProcedureNormalBattle.ChangeToAuto(true)/ChangeToManual",
            "missing": "XLua.LuaEnv; GameEntry.Lua/LuaManager.LoadUIScript; ModulesInit.ProcedureNormalBattle; GameFunction/GameFunctionType; ModulesInit.PhotoArtistMgr; LuaUtils",
        },
        "btnBuff": {
            "luaFile": str(NORMAL_LUA),
            "luaLines": "180-184, 1446-1452",
            "handler": "UI_NormalBattle.OnInit btnBuff closure -> ShowBuffView(f==false)",
            "missing": "XLua.LuaEnv; GameEntry.Lua/LuaManager.LoadUIScript; LuaUtils; ModulesInit.ProcedureNormalBattle:GetAllBuffIconShowMap for opened buff view",
        },
        "btnTwoSpeed": {
            "luaFile": str(NORMAL_LUA),
            "luaLines": "111-131; ProcedureNormalBattle 933-947",
            "handler": "UI_NormalBattle.OnInit btnTwoSpeed closure -> ModulesInit.ProcedureNormalBattle.SetGameSpeed",
            "missing": "XLua.LuaEnv; GameEntry.Lua/LuaManager.LoadUIScript; ModulesInit.ProcedureNormalBattle; SaveMgr; PlayerMgr; GameTools; SetTimeScaleType; LuaUtils",
        },
        "btnFastSkill": {
            "luaFile": str(NORMAL_LUA),
            "luaLines": "132-146, 690-699; ProcedureNormalBattle 964-974",
            "handler": "UI_NormalBattle.OnInit btnFastSkill closure -> ChangeGameFastSkill + CheckFastSkill",
            "missing": "XLua.LuaEnv; GameEntry.Lua/LuaManager.LoadUIScript; ModulesInit.ProcedureNormalBattle; SaveMgr; PlayerMgr; GameFunction/GameFunctionType; LuaUtils",
        },
        "btn_box": {
            "luaFile": str(BOX_LUA),
            "luaLines": "149-178; UI_Battle3DUI 3-20",
            "handler": "UI_BattleBoxPage.GenBox -> CS.YouYou.UIEventListener.onClick reward animation",
            "missing": "XLua.LuaEnv; UI_Battle3DUI LuaUnit Init/Open; UI_BattleBoxPage LuaUnit Open; LuaComponentBinder.GetComponents; ModulesInit.ProcedureNormalBattle.dropBoxData/GetWaveData; UIUtil; DOTween; GameEntry.CameraCtrl",
        },
    }
    for button in BUTTON_ORDER:
        before = edit_by.get(("edit_before_forced", button), {})
        forced = edit_by.get(("edit_after_forced", button), {})
        play = play_by.get(button, {})
        carry = b51_by.get(button, {})
        rowinfo = info[button]
        out.append(
            {
                "buttonName": button,
                "luaFile": rowinfo["luaFile"],
                "luaLines": rowinfo["luaLines"],
                "handlerPath": rowinfo["handler"],
                "luaLifecycleExecuted": boolv(before, "luaLifecycleExecuted") or boolv(play, "luaLifecycleExecuted"),
                "listenerBound": (intv(before, "buttonOnClickPersistentCount") + intv(before, "buttonOnClickRuntimeCount") > 0) or boolv(before, "uiEventListenerHasDelegate"),
                "eventSystemTargetIncludedEditBefore": boolv(before, "eventTargetIncluded"),
                "eventSystemTargetIncludedPlayMode": boolv(play, "eventTargetIncluded"),
                "eventSystemTargetIncludedForced": boolv(forced, "eventTargetIncluded") or boolv(carry, "eventSystemTargetIncludedAfterForcedRaycasterRegistration"),
                "directGraphicTargetIncluded": boolv(before, "directTargetIncluded") or boolv(carry, "directGraphicRaycasterTargetIncluded"),
                "missingGlobalCsTypeMethodObject": rowinfo["missing"],
                "handlerExecution": "blocked_missing_xlua_runtime_and_modulesinit_bootstrap",
                "patchDecision": "blocked_no_patch_no_fake_handler",
            }
        )
    return out


def capture_metrics(path: Path) -> dict[str, Any]:
    img = cv2.imread(str(path))
    if img is None:
        return {"captureExists": False}
    total = img.shape[0] * img.shape[1]
    return {
        "captureExists": True,
        "width": int(img.shape[1]),
        "height": int(img.shape[0]),
        "nonBlackPixelRatio": round(float((img > 20).any(axis=2).sum()) / total, 6),
    }


def actual_xlua_assets() -> list[str]:
    assets = PROJECT / "Assets"
    if not assets.exists():
        return []
    out: list[str] = []
    for path in assets.rglob("*"):
        if not path.is_file():
            continue
        lower = str(path).lower()
        name = path.name.lower()
        if "battle52" in lower or "battle_52" in lower:
            continue
        if "xlua" in lower and path.suffix.lower() in {".dll", ".cs", ".asmdef", ".so", ".bundle", ".a", ".m", ".mm"}:
            out.append(str(path))
    return out


def make_contact(summary: dict[str, Any]) -> None:
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    width, height = 1600, 900
    canvas = Image.new("RGB", (width, height), (8, 8, 8))
    draw = ImageDraw.Draw(canvas)
    if B51_CAPTURE.exists():
        img = Image.open(B51_CAPTURE).convert("RGB")
        img.thumbnail((960, 540))
        canvas.paste(img, (24, 24))
        draw.text((24, 24 + img.height + 8), "BATTLE51/BATTLE52 visual baseline (unchanged)", fill=(230, 230, 230))
    x = 1020
    y = 30
    lines = [
        "BATTLE52 summary",
        f"final restored: {summary['isFinalRestoredBattleScreen']}",
        f"visual_status: {summary['visual_status']}",
        f"xLua runtime available: {summary['xluaRuntimeAvailable']}",
        f"GameEntry/LuaManager available: {summary['youyouGameEntryAvailable']} / {summary['youyouLuaManagerAvailable']}",
        f"B51 event/direct/forced: {summary['eventSystemTargetIncludedB51CarryoverBefore']} / {summary['directGraphicTargetIncludedB51Carryover']} / {summary['eventSystemTargetIncludedB51CarryoverForced']}",
        f"B52 edit event/direct/forced: {summary['eventSystemTargetIncludedEditBefore']} / {summary['directGraphicTargetIncludedEditBefore']} / {summary['eventSystemTargetIncludedForced']}",
        f"playmode event: {summary['eventSystemTargetIncludedPlayMode']}",
        f"listener bound: {summary['listenerBoundCount']}",
        f"lua lifecycle executed: {summary['luaLifecycleExecutedCount']}",
        "",
        "No fake onClick, overlay, gameplay handler, or art patch.",
        f"play video available: {summary['referenceVideoAvailable']}",
        f"aux reference available: {summary['auxiliaryReferenceVideoAvailable']}",
    ]
    for line in lines:
        draw.text((x, y), line, fill=(235, 235, 235))
        y += 26
    canvas.save(CONTACT, quality=92)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=["verify"])
    parser.add_argument("--unity-exit", type=int, default=0)
    parser.add_argument("--playmode-exit", type=int, default=-999)
    args = parser.parse_args()

    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    edit = read_json(EDIT_JSON, {})
    play = read_json(PLAY_JSON, {})
    edit_rows = read_csv(EDIT_CSV)
    play_rows = read_csv(PLAY_CSV)
    type_rows = read_csv(TYPE_CSV)
    b51_rows = read_csv(B51_BUTTONS)
    b51 = read_json(B51_JSON, {})
    schema = build_schema(edit)
    buttons = button_rows(edit_rows, play_rows, b51_rows, schema)
    write_csv(SCHEMA_CSV, schema, ["component", "requiredTypeOrGlobal", "status", "evidence", "requiredBy", "blockerIfMissing"])
    SCHEMA_JSON.write_text(json.dumps(schema, ensure_ascii=False, indent=2), encoding="utf-8")
    write_csv(
        BUTTONS_CSV,
        buttons,
        [
            "buttonName",
            "luaFile",
            "luaLines",
            "handlerPath",
            "luaLifecycleExecuted",
            "listenerBound",
            "eventSystemTargetIncludedEditBefore",
            "eventSystemTargetIncludedPlayMode",
            "eventSystemTargetIncludedForced",
            "directGraphicTargetIncluded",
            "missingGlobalCsTypeMethodObject",
            "handlerExecution",
            "patchDecision",
        ],
    )

    event_edit = int(edit.get("eventSystemTargetIncludedBefore") or 0)
    direct_edit = int(edit.get("directGraphicTargetIncludedBefore") or 0)
    forced = int(edit.get("eventSystemTargetIncludedForced") or 0)
    play_event = int(play.get("eventSystemTargetIncludedBefore") or 0) if play else 0
    b51_direct = sum(1 for r in b51_rows if boolv(r, "directGraphicRaycasterTargetIncluded"))
    b51_forced = sum(1 for r in b51_rows if boolv(r, "eventSystemTargetIncludedAfterForcedRaycasterRegistration"))
    b51_event_before = sum(1 for r in b51_rows if boolv(r, "eventSystemTargetIncluded"))
    listener_bound = sum(1 for b in buttons if b["listenerBound"])
    lifecycle = sum(1 for b in buttons if b["luaLifecycleExecuted"])
    xlua_available = bool(edit.get("xluaRuntimeAvailable"))
    gameentry_available = bool(edit.get("youyouGameEntryAvailable"))
    luamanager_available = bool(edit.get("youyouLuaManagerAvailable"))
    real_xlua_assets = actual_xlua_assets()
    visual_status = "blocked_missing_xlua_runtime_modulesinit_bootstrap_no_fake_handler_patch"
    patch_decision = "blocked_no_patch"
    if xlua_available and gameentry_available and luamanager_available:
        visual_status = "blocked_modulesinit_lua_dependency_chain_not_bootstrapped"

    summary = {
        "verdict": "BATTLE52 traced original xLua/GameEntry/LuaManager/ModulesInit runtime chain and blocked without fake handler because the restored Unity project lacks executable xLua/GameEntry/LuaManager bootstrap.",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "patchDecision": patch_decision,
        "unityExitCode": args.unity_exit,
        "playmodeExitCode": args.playmode_exit,
        "referenceVideoAvailable": PLAY_VIDEO.exists(),
        "referenceVideoPath": str(PLAY_VIDEO),
        "auxiliaryReferenceVideoAvailable": AUX_VIDEO.exists(),
        "auxiliaryReferenceVideoPath": str(AUX_VIDEO),
        "xluaRuntimeAvailable": xlua_available,
        "xluaLuaTableAvailable": bool(edit.get("xluaLuaTableAvailable")),
        "xluaLuaFunctionAvailable": bool(edit.get("xluaLuaFunctionAvailable")),
        "youyouGameEntryAvailable": gameentry_available,
        "youyouLuaManagerAvailable": luamanager_available,
        "actualXluaRuntimeAssetCount": len(real_xlua_assets),
        "actualXluaRuntimeAssets": real_xlua_assets,
        "projectXluaProbeSelfMatches": edit.get("projectXluaAssets", ""),
        "sourceBackedBridgeStillPresent": {
            "luaForm": edit.get("luaFormCount"),
            "luaUnit": edit.get("luaUnitCount"),
            "luaComBinder": edit.get("luaComBinderCount"),
            "uiEventListener": edit.get("uiEventListenerCount"),
        },
        "eventSystemTargetIncludedEditBefore": event_edit,
        "directGraphicTargetIncludedEditBefore": direct_edit,
        "eventSystemTargetIncludedB51CarryoverBefore": b51_event_before,
        "directGraphicTargetIncludedB51Carryover": b51_direct,
        "eventSystemTargetIncludedB51CarryoverForced": b51_forced,
        "eventSystemTargetIncludedAfterToggle": int(edit.get("eventSystemTargetIncludedAfterToggle") or 0),
        "eventSystemTargetIncludedForced": forced,
        "eventSystemTargetIncludedPlayMode": play_event,
        "listenerBoundCount": listener_bound,
        "luaLifecycleExecutedCount": lifecycle,
        "raycasterManagerEditBefore": edit.get("raycasterManagerBefore", ""),
        "raycasterManagerAfterToggle": edit.get("raycasterManagerAfterToggle", ""),
        "raycasterManagerAfterForced": edit.get("raycasterManagerAfterForced", ""),
        "raycasterManagerPlayMode": play.get("raycasterManagerBefore", "") if play else "",
        "playModeProbe": {
            "available": bool(play),
            "failReason": play.get("failReason", "") if play else "deferred_by_checkpoint_not_blocking_result",
            "sceneOpened": play.get("sceneOpened", False) if play else False,
        },
        "buttonRows": buttons,
        "runtimeDependencyRows": len(schema),
        "runtimeDependencySchemaCsv": str(SCHEMA_CSV),
        "runtimeDependencySchemaJson": str(SCHEMA_JSON),
        "typeRowsCsv": str(TYPE_CSV),
        "editRowsCsv": str(EDIT_CSV),
        "playRowsCsv": str(PLAY_CSV),
        "localPlayablePayloadManifest": {
            "available": PAYLOAD_MANIFEST.exists(),
            "path": str(PAYLOAD_MANIFEST),
            "useCondition": "Use only after source-backed handler binding executes; local subset is debug/runtime validation only, not full payload or final restore evidence.",
        },
        "captureMetrics": capture_metrics(B51_CAPTURE),
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "json": str(OUT_JSON),
            "buttonsCsv": str(BUTTONS_CSV),
            "runtimeDependencySchemaCsv": str(SCHEMA_CSV),
            "runtimeDependencySchemaJson": str(SCHEMA_JSON),
            "contactSheet": str(CONTACT),
            "unityLog": str(LOG),
        },
        "nextBlocker": "BATTLE_53_RESTORE_OR_IMPORT_SOURCE_BACKED_XLUA_RUNTIME_AND_MODULESINIT_BOOTSTRAP_OR_ACCEPT_BLOCK",
        "notes": [
            "No fake transparent overlay, fake onClick closure, fake gameplay handler, fake art, screenshot paste, or coordinate-only success was added.",
            "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST remains validation context only after real source-backed handler binding.",
            "플레이.mp4 is missing when referenceVideoAvailable is false; 참고.mp4 is auxiliary only.",
        ],
    }

    make_contact(summary)
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    md_lines = [
        f"# {PREFIX} Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE52는 원본 xLua/GameEntry/LuaManager/ModulesInit 런타임 체인을 끝까지 추적했지만, 현재 복원 Unity 프로젝트에는 실행 가능한 xLua/GameEntry/LuaManager bootstrap이 없어 원본 Lua closure binding을 진행하지 않았다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- patch decision: `{patch_decision}`",
        f"- Unity edit exit code: `{args.unity_exit}`",
        f"- Unity PlayMode exit code: `{args.playmode_exit}`",
        f"- reference video available: `{PLAY_VIDEO.exists()}` (`{PLAY_VIDEO}`)",
        f"- auxiliary reference video available: `{AUX_VIDEO.exists()}` (`{AUX_VIDEO}`)",
        "",
        "## Runtime Availability",
        f"- xLua LuaEnv/LuaTable/LuaFunction in restored Unity project: `{xlua_available}` / `{summary['xluaLuaTableAvailable']}` / `{summary['xluaLuaFunctionAvailable']}`",
        f"- GameEntry/LuaManager in restored Unity project: `{gameentry_available}` / `{luamanager_available}`",
        f"- actual xLua runtime/package/native plugin assets under `girlswar_battle_unity/Assets`: `{len(real_xlua_assets)}`",
        f"- xLua string matches found by Unity probe are self/probe files only: `{edit.get('projectXluaAssets', '')}`",
        f"- BATTLE51 bridge still present: LuaForm/LuaUnit/LuaComBinder/UIEventListener = `{edit.get('luaFormCount')}` / `{edit.get('luaUnitCount')}` / `{edit.get('luaComBinderCount')}` / `{edit.get('uiEventListenerCount')}`",
        "- original evidence confirms the missing chain: `GameEntry.Lua -> YouYou.LuaManager -> XLua.LuaEnv -> LoadUIScript -> LuaForm/LuaUnit delegates -> decoded UI OnInit/Open`.",
        "",
        "## Input Plumbing",
        f"- BATTLE51 carryover EventSystem-before/direct/forced target inclusion: `{b51_event_before}` / `{b51_direct}` / `{b51_forced}`",
        f"- BATTLE52 edit-mode EventSystem/direct/forced target inclusion: `{event_edit}` / `{direct_edit}` / `{forced}`",
        f"- after GraphicRaycaster toggle target inclusion: `{summary['eventSystemTargetIncludedAfterToggle']}`",
        f"- PlayMode target inclusion: `{play_event}`",
        "- BATTLE52 edit-mode raycast rows are non-authoritative for hit readiness because Unity logged `EventSystem.current` unknown in batch context; BATTLE51 direct/forced input evidence remains the authoritative carryover.",
        f"- edit RaycasterManager before: `{edit.get('raycasterManagerBefore', '')}`",
        f"- PlayMode RaycasterManager: `{summary['raycasterManagerPlayMode']}`",
        "",
        "## Handler Binding",
        f"- listener bound count: `{listener_bound}`",
        f"- Lua lifecycle executed count: `{lifecycle}`",
        "- handler execution: `blocked_missing_xlua_runtime_and_modulesinit_bootstrap`",
        "- no fake `Button.onClick`, fake `UIEventListener` delegate, fake gameplay handler, or fake overlay was added.",
        "",
        "## Button Rows",
    ]
    for b in buttons:
        md_lines.append(
            f"- `{b['buttonName']}`: lifecycle/listener/edit/play/forced/direct = `{b['luaLifecycleExecuted']}` / `{b['listenerBound']}` / `{b['eventSystemTargetIncludedEditBefore']}` / `{b['eventSystemTargetIncludedPlayMode']}` / `{b['eventSystemTargetIncludedForced']}` / `{b['directGraphicTargetIncluded']}`, blocker=`{b['handlerExecution']}`"
        )
    md_lines.extend(
        [
            "",
            "## Runtime Dependency Schema",
            f"- schema CSV: `{SCHEMA_CSV}`",
            f"- schema JSON: `{SCHEMA_JSON}`",
            f"- type CSV: `{TYPE_CSV}`",
            "- key blocker: `blocked_missing_xlua_runtime`; even source-backed bridge fields cannot execute decoded `UI_NormalBattle`, `UI_Battle3DUI`, or `UI_BattleBoxPage` without `XLua.LuaEnv`, `GameEntry.Lua`, and `LuaManager.LoadUIScript`.",
            "",
            "## Payload Manifest Use",
            f"- local playable manifest available: `{PAYLOAD_MANIFEST.exists()}`",
            "- use only after real source-backed handler binding; it is not full payload or final restore evidence.",
            "",
            "## Outputs",
            f"- result JSON: `{OUT_JSON}`",
            f"- buttons CSV: `{BUTTONS_CSV}`",
            f"- runtime dependency schema CSV: `{SCHEMA_CSV}`",
            f"- edit rows CSV: `{EDIT_CSV}`",
            f"- PlayMode rows CSV: `{PLAY_CSV}`",
            f"- contact sheet: `{CONTACT}`",
            "",
            "## Command Policy Check",
            f"- root CMD count: `{summary['rootCmdCount']}`",
            f"- `_restore_tools` direct CMD count: `{summary['restoreToolsDirectCmdCount']}`",
            "",
            "## Next Blocker",
            f"- `{summary['nextBlocker']}`",
        ]
    )
    OUT_MD.write_text("\n".join(md_lines) + "\n", encoding="utf-8")
    return 0 if args.unity_exit == 0 and (args.playmode_exit == 0 or args.playmode_exit == -999) else 1


if __name__ == "__main__":
    raise SystemExit(main())
