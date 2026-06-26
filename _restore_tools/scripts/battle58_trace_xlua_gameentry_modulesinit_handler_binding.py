from __future__ import annotations

import argparse
import csv
import json
import shutil
from collections import Counter
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
REPORT_DIR = BASE / "reports" / "battle"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
PREFIX = "BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER"

UNITY_SUMMARY = UNITY_DATA / f"{PREFIX}_UNITY_SUMMARY.json"
UNITY_BUTTONS = UNITY_DATA / f"{PREFIX}_HUD_BUTTON_HANDLER_AUDIT.csv"
UNITY_CLICK = UNITY_DATA / f"{PREFIX}_CLICK_VALIDATION.csv"

OUT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
OUT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
OUT_BUTTONS = REPORT_DIR / f"{PREFIX}_HUD_BUTTON_HANDLER_AUDIT.csv"
OUT_CLICK = REPORT_DIR / f"{PREFIX}_CLICK_VALIDATION.csv"
OUT_SOURCE_TRACE = REPORT_DIR / f"{PREFIX}_XLUA_GAMEENTRY_MODULESINIT_SOURCE_TRACE.csv"
OUT_DEP_GRAPH = REPORT_DIR / f"{PREFIX}_LUA_DEPENDENCY_GRAPH.csv"
OUT_PAYLOAD_GAPS = REPORT_DIR / f"{PREFIX}_FULL_PAYLOAD_GAPS.csv"
OUT_LOG = REPORT_DIR / f"{PREFIX}.log"

B50_HANDLERS = REPORT_DIR / "BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_HANDLERS.csv"
B52_SCHEMA = REPORT_DIR / "BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_RUNTIME_DEPENDENCY_SCHEMA.csv"
B53_IMPORT = REPORT_DIR / "BATTLE_53_RESTORE_OR_IMPORT_SOURCE_BACKED_XLUA_RUNTIME_AND_MODULESINIT_BOOTSTRAP_OR_ACCEPT_BLOCK_IMPORT_CANDIDATES.csv"
B57_JSON = REPORT_DIR / "BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_RESULT.json"
PAYLOAD_JSON = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.json"
LUA_MAINCITY = REPORT_DIR / "BATTLE_50_DECODED_MAINCITY_LUA"
XLUA_BATTLE = BASE / "girlswar_merged_extracted" / "decoded" / "xlua_battle"
IL2CPP_DUMP = BASE / "girlswar_merged_extracted" / "extracted" / "il2cpp_dump" / "dump.cs"
PLAY_VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")


TRACE_PATTERNS = [
    ("xLua runtime", "XLua.LuaEnv", [IL2CPP_DUMP]),
    ("xLua runtime", "XLua.LuaTable", [IL2CPP_DUMP]),
    ("xLua runtime", "XLua.LuaFunction", [IL2CPP_DUMP]),
    ("GameEntry Lua", "GameEntry.Lua", [IL2CPP_DUMP]),
    ("LuaManager", "LoadUIScript", [IL2CPP_DUMP]),
    ("LuaManager", "GetLuaBuff", [IL2CPP_DUMP]),
    ("Lua bridge", "LuaForm", [IL2CPP_DUMP]),
    ("Lua bridge", "LuaUnit", [IL2CPP_DUMP]),
    ("Lua bridge", "UIEventListener", [IL2CPP_DUMP]),
    ("Lua bridge", "LuaComBinder", [IL2CPP_DUMP]),
    ("UI_NormalBattle", "btnAuto.onClick:AddListener", [LUA_MAINCITY / "874003978109174219_UI_NormalBattle.lua"]),
    ("UI_NormalBattle", "btnTwoSpeed.onClick:AddListener", [LUA_MAINCITY / "874003978109174219_UI_NormalBattle.lua"]),
    ("UI_NormalBattle", "btnFastSkill.onClick:AddListener", [LUA_MAINCITY / "874003978109174219_UI_NormalBattle.lua"]),
    ("UI_NormalBattle", "btnBuff.onClick:AddListener", [LUA_MAINCITY / "874003978109174219_UI_NormalBattle.lua"]),
    ("UI_BattleBoxPage", "UIEventListener", [LUA_MAINCITY / "8374052518232552317_UI_BattleBoxPage.lua"]),
    ("UI_Battle3DUI", "UI_BattleBoxPage:GetComponent", [LUA_MAINCITY / "-712482409242173665_UI_Battle3DUI.lua"]),
    ("ProcedureNormalBattle", "function t.SetGameSpeed", list((XLUA_BATTLE / "download_xlualogic_modules_procedure").glob("*ProcedureNormalBattle*.lua"))),
    ("ProcedureNormalBattle", "function t.ChangeToAuto", list((XLUA_BATTLE / "download_xlualogic_modules_procedure").glob("*ProcedureNormalBattle*.lua"))),
    ("ProcedureNormalBattle", "function t.ChangeToManual", list((XLUA_BATTLE / "download_xlualogic_modules_procedure").glob("*ProcedureNormalBattle*.lua"))),
    ("ProcedureNormalBattle", "function t.ChangeGameFastSkill", list((XLUA_BATTLE / "download_xlualogic_modules_procedure").glob("*ProcedureNormalBattle*.lua"))),
]


def read_json(path: Path, fallback: Any) -> Any:
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], headers: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=headers)
        writer.writeheader()
        for row in rows:
            writer.writerow({h: row.get(h, "") for h in headers})


def copy_csv(src: Path, dst: Path) -> list[dict[str, str]]:
    if src.exists():
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(src, dst)
    return read_csv(dst)


def truthy(v: Any) -> bool:
    return str(v).strip().lower() in {"true", "1", "yes"}


def intv(v: Any) -> int:
    try:
        return int(float(str(v or "0")))
    except Exception:
        return 0


def count_cmds(path: Path) -> int:
    return len(list(path.glob("*.cmd"))) if path.exists() else 0


def find_first(pattern: str, paths: list[Path]) -> tuple[Path | None, int, str]:
    lower = pattern.lower()
    for path in paths:
        if not path.exists() or not path.is_file():
            continue
        try:
            with path.open("r", encoding="utf-8", errors="ignore") as f:
                for i, line in enumerate(f, 1):
                    if lower in line.lower():
                        return path, i, line.strip()[:500]
        except Exception:
            continue
    return None, 0, ""


def build_source_trace() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for category, pattern, paths in TRACE_PATTERNS:
        hit_path, line, snippet = find_first(pattern, paths)
        rows.append(
            {
                "category": category,
                "symbolOrPattern": pattern,
                "found": bool(hit_path),
                "evidenceFile": str(hit_path or ""),
                "line": line,
                "snippet": snippet,
                "classification": classify_trace(category, pattern, bool(hit_path)),
            }
        )
    for row in read_csv(B50_HANDLERS):
        rows.append(
            {
                "category": "button_handler",
                "symbolOrPattern": row.get("buttonName", ""),
                "found": row.get("sourceBacked", "") or "True",
                "evidenceFile": row.get("sourceFile", ""),
                "line": row.get("lineStart", ""),
                "snippet": row.get("evidenceSnippet", ""),
                "classification": "source_backed_lua_handler_available_not_bound_without_lifecycle",
                "handlerCandidate": row.get("handlerMethodCandidate", ""),
            }
        )
    return rows


def classify_trace(category: str, pattern: str, found: bool) -> str:
    if not found:
        return "not_found_in_local_evidence"
    if category in {"xLua runtime", "GameEntry Lua", "LuaManager"}:
        return "source_backed_type_or_string_evidence_not_executable_in_restored_project"
    if category in {"Lua bridge"}:
        return "source_backed_bridge_type_schema_present_but_no_runtime_lifecycle"
    return "source_backed_lua_source_available"


def build_dependency_graph(buttons: list[dict[str, str]]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    schema = read_csv(B52_SCHEMA)
    for row in schema:
        rows.append(
            {
                "node": row.get("requiredTypeOrGlobal", ""),
                "kind": row.get("component", ""),
                "status": row.get("status", ""),
                "requiredBy": row.get("requiredBy", ""),
                "evidence": row.get("evidence", ""),
                "blockerIfMissing": row.get("blockerIfMissing", ""),
                "battle58Finding": "still_blocking" if "missing" in row.get("status", "") or "unresolved" in row.get("status", "") or "not_runtime" in row.get("status", "") else "present_but_not_sufficient",
            }
        )
    for button in buttons:
        if button.get("phase") != "before_forced_raycaster_registration":
            continue
        rows.append(
            {
                "node": button.get("buttonName", ""),
                "kind": "HUD button",
                "status": "raycast_ready_but_handler_unbound" if truthy(button.get("directTargetIncluded")) else "button_not_raycast_ready",
                "requiredBy": button.get("handlerCandidate", ""),
                "evidence": button.get("handlerSource", ""),
                "blockerIfMissing": button.get("gameplayHandlerExecution", ""),
                "battle58Finding": "handlerBound=" + button.get("handlerBound", "False") + "; lifecycle=" + button.get("luaLifecycleExecuted", "False"),
            }
        )
    return rows


def build_payload_gaps(payload: dict[str, Any]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for actor in payload.get("actors", []):
        status = actor.get("localStatus", "")
        if status != "loadable":
            rows.append(
                {
                    "gapKind": "actor",
                    "id": actor.get("payloadHeroDid", ""),
                    "side": actor.get("side", ""),
                    "status": status,
                    "bundle": actor.get("actorBundle", ""),
                    "reason": actor.get("reason", ""),
                }
            )
    for res in payload.get("resources", []):
        status = res.get("localStatus", "")
        if status != "loadable":
            rows.append(
                {
                    "gapKind": res.get("kind", "resource"),
                    "id": "",
                    "side": "",
                    "status": status,
                    "bundle": res.get("bundle", ""),
                    "reason": res.get("reason", ""),
                }
            )
    return rows


def summarize_buttons(rows: list[dict[str, str]]) -> dict[str, Any]:
    before = [r for r in rows if r.get("phase") == "before_forced_raycaster_registration"]
    forced = [r for r in rows if r.get("phase") == "after_forced_raycaster_registration"]
    return {
        "rows": len(rows),
        "beforeRows": len(before),
        "forcedRows": len(forced),
        "activeInteractableRows": sum(1 for r in before if truthy(r.get("activeInHierarchy")) and truthy(r.get("interactable"))),
        "directTargetIncludedRows": sum(1 for r in before if truthy(r.get("directTargetIncluded"))),
        "eventTargetIncludedRows": sum(1 for r in before if truthy(r.get("eventTargetIncluded"))),
        "eventTargetIncludedForcedRows": sum(1 for r in forced if truthy(r.get("eventTargetIncluded"))),
        "onClickKnownRows": sum(1 for r in before if intv(r.get("onClickKnownCount")) > 0),
        "uiEventListenerPresentRows": sum(1 for r in before if truthy(r.get("uiEventListenerPresent"))),
        "uiEventListenerDelegateRows": sum(1 for r in before if truthy(r.get("uiEventListenerHasDelegate"))),
        "handlerBoundRows": sum(1 for r in before if truthy(r.get("handlerBound"))),
        "buttons": [
            {
                "buttonName": r.get("buttonName"),
                "directTargetIncluded": truthy(r.get("directTargetIncluded")),
                "eventTargetIncluded": truthy(r.get("eventTargetIncluded")),
                "onClickKnownCount": intv(r.get("onClickKnownCount")),
                "uiEventListenerHasDelegate": truthy(r.get("uiEventListenerHasDelegate")),
                "handlerCandidate": r.get("handlerCandidate"),
            }
            for r in before
        ],
    }


def build_report(result: dict[str, Any]) -> str:
    lines = [
        f"# {PREFIX} Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE58 audits BATTLE57 actor-ready candidate input/handler binding and traces original xLua/GameEntry/ModulesInit requirements without fake handlers.",
        "",
        "## Verdict",
        f"- visual_status: `{result['visual_status']}`",
        f"- final screen claim: `{str(result['isFinalRestoredBattleScreen']).lower()}`",
        f"- patch decision: `{result['patchDecision']}`",
        f"- scene saved: `{str(result['sceneSaved']).lower()}`",
        f"- handler binding applied: `{str(result['handlerBindingApplied']).lower()}`",
        f"- next blocker: `{result['nextBlocker']}`",
        "",
        "## Button Audit",
        f"- active/interactable rows: `{result['buttons']['activeInteractableRows']}` / `{result['buttons']['beforeRows']}`",
        f"- direct GraphicRaycaster target included: `{result['buttons']['directTargetIncludedRows']}` / `{result['buttons']['beforeRows']}`",
        f"- EventSystem target before/forced: `{result['buttons']['eventTargetIncludedRows']}` / `{result['buttons']['eventTargetIncludedForcedRows']}`",
        f"- known onClick rows: `{result['buttons']['onClickKnownRows']}`",
        f"- UIEventListener present/delegate rows: `{result['buttons']['uiEventListenerPresentRows']}` / `{result['buttons']['uiEventListenerDelegateRows']}`",
        f"- handler-bound rows: `{result['buttons']['handlerBoundRows']}`",
        "",
        "## Runtime Trace",
        f"- xLua runtime available in restored Unity project: `{str(result['unitySummary'].get('xluaRuntimeAvailable', False)).lower()}`",
        f"- GameEntry/LuaManager available: `{str(result['unitySummary'].get('gameEntryAvailable', False)).lower()}` / `{str(result['unitySummary'].get('luaManagerAvailable', False)).lower()}`",
        f"- Lua lifecycle executed rows: `{result['unitySummary'].get('luaLifecycleExecutedRows', 0)}`",
        f"- source trace rows: `{result['sourceTraceRows']}`",
        f"- dependency graph rows: `{result['dependencyGraphRows']}`",
        "",
        "## Decision",
        "- No source-backed binding was applied. The original handler functions are traced, but the executable bootstrap is still absent: `XLua.LuaEnv`, `GameEntry.Lua`, `LuaManager.LoadUIScript`, and initialized `ModulesInit.ProcedureNormalBattle` are not available in the restored Unity project.",
        "- BATTLE57 actor rendering remains source-backed and valid, but actor visibility is not a gameplay handler or full payload proof.",
        "- Full payload remains separate: local actors are a subset only, with missing actor/common skill dependency gaps recorded.",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- HUD/button handler audit CSV: `{OUT_BUTTONS}`",
        f"- click validation CSV: `{OUT_CLICK}`",
        f"- xLua/GameEntry/ModulesInit source trace CSV: `{OUT_SOURCE_TRACE}`",
        f"- Lua dependency graph CSV: `{OUT_DEP_GRAPH}`",
        f"- full payload gaps CSV: `{OUT_PAYLOAD_GAPS}`",
        "",
        "## Command Policy",
        f"- root `.cmd` count: `{result['rootCmdCount']}`",
        f"- `_restore_tools` direct `.cmd` count: `{result['restoreToolsDirectCmdCount']}`",
        f"- `플레이.mp4`: `{'available' if result['referenceVideoAvailable'] else 'missing'}`",
        f"- `참고.mp4`: `{'available, auxiliary only' if result['auxiliaryReferenceVideoAvailable'] else 'missing'}`",
    ]
    return "\n".join(lines) + "\n"


def run(unity_exit: int) -> int:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    unity_summary = read_json(UNITY_SUMMARY, {})
    buttons = copy_csv(UNITY_BUTTONS, OUT_BUTTONS)
    click = copy_csv(UNITY_CLICK, OUT_CLICK)
    payload = read_json(PAYLOAD_JSON, {})
    b57 = read_json(B57_JSON, {})

    source_trace = build_source_trace()
    dep_graph = build_dependency_graph(buttons)
    payload_gaps = build_payload_gaps(payload)
    write_csv(OUT_SOURCE_TRACE, source_trace, ["category", "symbolOrPattern", "found", "evidenceFile", "line", "snippet", "classification", "handlerCandidate"])
    write_csv(OUT_DEP_GRAPH, dep_graph, ["node", "kind", "status", "requiredBy", "evidence", "blockerIfMissing", "battle58Finding"])
    write_csv(OUT_PAYLOAD_GAPS, payload_gaps, ["gapKind", "id", "side", "status", "bundle", "reason"])

    classification_counts = Counter(r.get("classification", "") for r in source_trace)
    dependency_status_counts = Counter(r.get("status", "") for r in dep_graph)
    payload_gap_counts = Counter(r.get("status", "") for r in payload_gaps)
    result = {
        "prefix": PREFIX,
        "unityExitCode": unity_exit,
        "visual_status": "blocked_missing_xlua_gameentry_modulesinit_bootstrap_no_fake_handler_patch",
        "isFinalRestoredBattleScreen": False,
        "patchDecision": "blocked_no_patch",
        "sceneSaved": False,
        "handlerBindingApplied": False,
        "buttons": summarize_buttons(buttons),
        "clickValidationRows": len(click),
        "unitySummary": unity_summary,
        "sourceTraceRows": len(source_trace),
        "sourceTraceClassificationCounts": dict(classification_counts),
        "dependencyGraphRows": len(dep_graph),
        "dependencyStatusCounts": dict(dependency_status_counts),
        "payloadGapRows": len(payload_gaps),
        "payloadGapStatusCounts": dict(payload_gap_counts),
        "b57ActorCarryover": {
            "visual_status": b57.get("visual_status"),
            "runtimeRehydrateUsed": b57.get("runtimeRehydrateUsed"),
            "meshReadyRows": b57.get("visibility", {}).get("meshReadyRows"),
            "capturePixelSignalRows": b57.get("visibility", {}).get("capturePixelSignalRows"),
            "isFinalRestoredBattleScreen": b57.get("isFinalRestoredBattleScreen"),
        },
        "payloadCarryover": {
            "classification": payload.get("summary", {}).get("classification"),
            "loadableActors": payload.get("summary", {}).get("loadableActors"),
            "totalActors": payload.get("summary", {}).get("totalActors"),
            "resourceCompleteLoadableSkillRows": payload.get("summary", {}).get("resourceCompleteLoadableSkillRows"),
            "totalSkillRows": payload.get("summary", {}).get("totalSkillRows"),
        },
        "nextBlocker": "SOURCE_BACKED_XLUA_GAMEENTRY_LUAMANAGER_RUNTIME_REQUIRED_FOR_ORIGINAL_HANDLER_BINDING_AND_FULL_PAYLOAD_GAPS",
        "referenceVideoAvailable": PLAY_VIDEO.exists(),
        "referenceVideoPath": str(PLAY_VIDEO),
        "auxiliaryReferenceVideoAvailable": AUX_VIDEO.exists(),
        "auxiliaryReferenceVideoPath": str(AUX_VIDEO),
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "json": str(OUT_JSON),
            "buttonAuditCsv": str(OUT_BUTTONS),
            "clickValidationCsv": str(OUT_CLICK),
            "sourceTraceCsv": str(OUT_SOURCE_TRACE),
            "dependencyGraphCsv": str(OUT_DEP_GRAPH),
            "payloadGapsCsv": str(OUT_PAYLOAD_GAPS),
            "unitySummary": str(UNITY_SUMMARY),
            "unityLog": str(REPORT_DIR / f"{PREFIX}_UNITY.log"),
            "log": str(OUT_LOG),
        },
        "notes": [
            "No fake onClick/gameplay handler, dummy Lua, stub GameEntry, external xLua package, or coordinate-only success was added.",
            "BATTLE57 source-backed actor path remains useful for visual/runtime context but does not prove handler or full payload execution.",
        ],
    }
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    OUT_MD.write_text(build_report(result), encoding="utf-8")
    OUT_LOG.write_text(
        "\n".join(
            [
                PREFIX,
                f"unityExitCode={unity_exit}",
                f"buttonRows={len(buttons)}",
                f"handlerBindingApplied=False",
                f"sourceTraceRows={len(source_trace)}",
                f"dependencyGraphRows={len(dep_graph)}",
                "patchDecision=blocked_no_patch",
                "isFinalRestoredBattleScreen=False",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    return 0 if unity_exit == 0 else unity_exit


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("mode", nargs="?", default="verify", choices=["verify"])
    parser.add_argument("--unity-exit", type=int, default=0)
    args = parser.parse_args()
    return run(args.unity_exit)


if __name__ == "__main__":
    raise SystemExit(main())
