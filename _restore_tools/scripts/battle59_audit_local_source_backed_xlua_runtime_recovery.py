from __future__ import annotations

import csv
import json
import os
import re
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
ASSETS = PROJECT / "Assets"
PACKAGES = PROJECT / "Packages"
REPORT_DIR = BASE / "reports" / "battle"
PREFIX = "BATTLE_59_AUDIT_LOCAL_SOURCE_BACKED_XLUA_RUNTIME_RECOVERY_FEASIBILITY_AND_BOOTSTRAP_REQUIREMENTS_NO_STUB_NO_EXTERNAL"

OUT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
OUT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
OUT_RUNTIME = REPORT_DIR / f"{PREFIX}_XLUA_RUNTIME_AVAILABILITY_EVIDENCE.csv"
OUT_BOOTSTRAP = REPORT_DIR / f"{PREFIX}_GAMEENTRY_LUAMANAGER_MODULESINIT_BOOTSTRAP_REQUIREMENT_GRAPH.csv"
OUT_MATRIX = REPORT_DIR / f"{PREFIX}_ORIGINAL_HANDLER_BINDING_FEASIBILITY_DECISION_MATRIX.csv"
OUT_PAYLOAD = REPORT_DIR / f"{PREFIX}_FULL_PAYLOAD_BLOCKER_SEPARATION.csv"
OUT_LOG = REPORT_DIR / f"{PREFIX}.log"

B57_JSON = REPORT_DIR / "BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_RESULT.json"
B58_JSON = REPORT_DIR / "BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_RESULT.json"
B58_BUTTONS = REPORT_DIR / "BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_HUD_BUTTON_HANDLER_AUDIT.csv"
B58_DEP_GRAPH = REPORT_DIR / "BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_LUA_DEPENDENCY_GRAPH.csv"
B58_PAYLOAD_GAPS = REPORT_DIR / "BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_FULL_PAYLOAD_GAPS.csv"
B52_SCHEMA = REPORT_DIR / "BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_RUNTIME_DEPENDENCY_SCHEMA.csv"
B53_IMPORT = REPORT_DIR / "BATTLE_53_RESTORE_OR_IMPORT_SOURCE_BACKED_XLUA_RUNTIME_AND_MODULESINIT_BOOTSTRAP_OR_ACCEPT_BLOCK_IMPORT_CANDIDATES.csv"
PAYLOAD_JSON = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.json"
PAYLOAD_CSV = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.csv"

IL2CPP_DUMP = BASE / "girlswar_merged_extracted" / "extracted" / "il2cpp_dump" / "dump.cs"
DUMMY_DLL_DIR = BASE / "girlswar_merged_extracted" / "extracted" / "il2cpp_dump" / "DummyDll"
MERGED = BASE / "girlswar_merged_extracted"
XLUA_BATTLE = MERGED / "decoded" / "xlua_battle"
MAIN_LUA = REPORT_DIR / "BATTLE_50_DECODED_MAINCITY_LUA"
UNITY_TEXT_INDEX = MERGED / "indexes" / "unity_textassets.csv"

PLAY_VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")

IGNORE_DIRS = {".git", "Library", "Temp", "Logs", "obj", ".vs", "Build", "Builds"}
TEXT_EXTS = {".cs", ".asmdef", ".json", ".csv", ".txt", ".md", ".lua", ".xml"}


def read_json(path: Path, fallback: Any) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8-sig"))
    except Exception:
        return fallback


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


def rel(path: Path | str) -> str:
    p = Path(path)
    try:
        return str(p.relative_to(BASE))
    except Exception:
        return str(path)


def truthy(value: Any) -> bool:
    return str(value).strip().lower() in {"1", "true", "yes"}


def intv(value: Any) -> int:
    try:
        return int(float(str(value or "0")))
    except Exception:
        return 0


def safe_read(path: Path, limit: int = 2_000_000) -> str:
    try:
        data = path.read_bytes()[:limit]
    except OSError:
        return ""
    for enc in ("utf-8", "utf-16", "cp949", "latin-1"):
        try:
            return data.decode(enc, errors="ignore")
        except Exception:
            pass
    return ""


def find_line(path: Path, pattern: str) -> tuple[int, str]:
    if not path.exists() or not path.is_file():
        return 0, ""
    rx = re.compile(pattern, re.I)
    try:
        with path.open("r", encoding="utf-8", errors="ignore") as f:
            for i, line in enumerate(f, 1):
                if rx.search(line):
                    return i, line.strip()[:420]
    except Exception:
        return 0, ""
    return 0, ""


def walk_files(roots: list[Path], suffixes: set[str] | None = None) -> list[Path]:
    found: list[Path] = []
    for root in roots:
        if not root.exists():
            continue
        for dirpath, dirnames, filenames in os.walk(root):
            dirnames[:] = [d for d in dirnames if d not in IGNORE_DIRS]
            for filename in filenames:
                path = Path(dirpath) / filename
                if suffixes and path.suffix.lower() not in suffixes:
                    continue
                found.append(path)
    return found


def first_existing(patterns: list[str], roots: list[Path]) -> list[Path]:
    rows: list[Path] = []
    rx = re.compile("|".join(patterns), re.I)
    for path in walk_files(roots):
        if rx.search(path.name) or rx.search(str(path)):
            rows.append(path)
    return rows


def scan_project_runtime_candidates() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    candidate_files = walk_files([ASSETS, PACKAGES], {".cs", ".dll", ".asmdef", ".so", ".bundle"})
    runtime_rx = re.compile(r"(XLua|LuaEnv|LuaTable|LuaFunction|LuaDLL|xlua|lua53|libxlua)", re.I)
    for path in candidate_files:
        lower = str(path).lower()
        generated_evidence = (
            "\\editor\\battle" in lower
            or "\\restoredata\\battle\\" in lower
            or "\\reports\\" in lower
        )
        content_hit = False
        line = 0
        snippet = ""
        if path.suffix.lower() in TEXT_EXTS:
            text = safe_read(path, 256_000)
            content_hit = bool(runtime_rx.search(text))
            if content_hit:
                line, snippet = find_line(path, r"XLua|LuaEnv|LuaTable|LuaFunction|LuaDLL|namespace\s+XLua")
        name_hit = bool(runtime_rx.search(path.name))
        if not name_hit and not content_hit:
            continue
        if generated_evidence:
            classification = "generated_probe_or_restore_evidence_not_runtime"
            status = "insufficient"
            reason = "Matched BATTLE probe/report assets only; not a reusable xLua runtime implementation."
        elif path.suffix.lower() in {".dll", ".cs", ".asmdef"} and ("plugins" in lower or "packages" in lower):
            classification = "source_backed_importable_editor_runtime_candidate"
            status = "requires_compile_probe"
            reason = "Located under Unity project plugin/package path; would require isolated compile/runtime probe."
        else:
            classification = "not_importable_editor_runtime"
            status = "insufficient"
            reason = "Name/content mentions xLua, but path is not an executable editor runtime location."
        rows.append(
            {
                "evidenceGroup": "restored_unity_project_assets_packages",
                "symbolOrArtifact": path.name,
                "path": str(path),
                "relativePath": rel(path),
                "line": line,
                "snippet": snippet,
                "classification": classification,
                "localStatus": status,
                "editorExecutable": str(classification == "source_backed_importable_editor_runtime_candidate"),
                "reason": reason,
            }
        )
    if not any(r["classification"] == "source_backed_importable_editor_runtime_candidate" for r in rows):
        rows.append(
            {
                "evidenceGroup": "restored_unity_project_assets_packages",
                "symbolOrArtifact": "XLua.LuaEnv/LuaDLL executable editor runtime",
                "path": "",
                "relativePath": "",
                "line": 0,
                "snippet": "",
                "classification": "not_found",
                "localStatus": "missing",
                "editorExecutable": "False",
                "reason": "No source-backed importable xLua editor/runtime assembly or package was found under Assets/Packages/Plugins.",
            }
        )
    return rows


def scan_bridge_and_il2cpp_evidence() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    bridge_patterns = [
        ("YouYou.LuaForm", r"class\s+LuaForm|LuaForm", "bridge_schema_present_not_lifecycle"),
        ("YouYou.LuaUnit", r"class\s+LuaUnit|LuaUnit", "bridge_schema_present_not_lifecycle"),
        ("LuaComponentBinder.LuaComBinder", r"class\s+LuaComBinder|LuaComBinder", "bridge_schema_present_partial"),
        ("YouYou.UIEventListener", r"class\s+UIEventListener|UIEventListener", "bridge_schema_present_delegate_unbound"),
        ("YouYou.GameEntry", r"class\s+GameEntry|GameEntry\.Lua", "missing_in_restored_project_or_type_signature_only"),
        ("YouYou.LuaManager", r"class\s+LuaManager|LoadUIScript|GetLuaBuff|MyLoader", "missing_in_restored_project_or_type_signature_only"),
        ("XLua.LuaEnv", r"class\s+LuaEnv|namespace\s+XLua|LuaEnv", "missing_in_restored_project_or_type_signature_only"),
        ("XLua.LuaTable", r"class\s+LuaTable|LuaTable", "missing_in_restored_project_or_type_signature_only"),
        ("XLua.LuaFunction", r"class\s+LuaFunction|LuaFunction", "missing_in_restored_project_or_type_signature_only"),
    ]
    project_text_files = walk_files([ASSETS], {".cs"})
    for symbol, pattern, default_classification in bridge_patterns:
        hit_path = None
        hit_line = 0
        hit_snippet = ""
        for path in project_text_files:
            line, snippet = find_line(path, pattern)
            if line:
                hit_path, hit_line, hit_snippet = path, line, snippet
                break
        is_runtime = symbol.startswith("XLua.") or symbol in {"YouYou.GameEntry", "YouYou.LuaManager"}
        if hit_path and not is_runtime:
            status = "partial_schema_present"
            classification = default_classification
            reason = "Source-backed bridge candidate exists in restored project, but BATTLE58 shows no Lua lifecycle/delegate binding."
        elif hit_path and is_runtime:
            status = "generated_or_signature_only"
            classification = "not_verified_executable_runtime"
            reason = "Symbol text appears in generated probe/source evidence, not as verified executable bootstrap runtime."
        else:
            status = "missing"
            classification = "not_found_in_restored_project"
            reason = "No restored Unity project implementation found."
        rows.append(
            {
                "evidenceGroup": "restored_bridge_runtime_symbols",
                "symbolOrArtifact": symbol,
                "path": str(hit_path or ""),
                "relativePath": rel(hit_path) if hit_path else "",
                "line": hit_line,
                "snippet": hit_snippet,
                "classification": classification,
                "localStatus": status,
                "editorExecutable": "False" if status != "verified_runtime" else "True",
                "reason": reason,
            }
        )

    il2cpp_patterns = [
        ("XLua.LuaEnv", r"class\s+LuaEnv|LuaEnv"),
        ("XLua.LuaTable", r"class\s+LuaTable|LuaTable"),
        ("XLua.LuaFunction", r"class\s+LuaFunction|LuaFunction"),
        ("YouYou.GameEntry.Lua", r"GameEntry.*Lua|LuaManager"),
        ("YouYou.LuaManager.LoadUIScript", r"LoadUIScript"),
        ("LuaManager.MyLoader/GetLuaBuff", r"MyLoader|GetLuaBuff|LoadLuaAssetBundle"),
        ("LuaDLL/native bridge signatures", r"LuaDLL|luaopen|lua53"),
    ]
    for symbol, pattern in il2cpp_patterns:
        line, snippet = find_line(IL2CPP_DUMP, pattern)
        rows.append(
            {
                "evidenceGroup": "il2cpp_dump",
                "symbolOrArtifact": symbol,
                "path": str(IL2CPP_DUMP if line else ""),
                "relativePath": rel(IL2CPP_DUMP) if line else "",
                "line": line,
                "snippet": snippet,
                "classification": "source_backed_type_signature_only_not_executable" if line else "not_found",
                "localStatus": "signature_only" if line else "missing",
                "editorExecutable": "False",
                "reason": "IL2CPP dump confirms original symbol/signature only; it is not a runnable Unity editor runtime.",
            }
        )

    if DUMMY_DLL_DIR.exists():
        for dll in sorted(DUMMY_DLL_DIR.glob("*.dll"))[:200]:
            name_hit = re.search(r"(Assembly-CSharp|XLua|Lua|GameEntry)", dll.name, re.I)
            if not name_hit:
                continue
            rows.append(
                {
                    "evidenceGroup": "dummy_dll",
                    "symbolOrArtifact": dll.name,
                    "path": str(dll),
                    "relativePath": rel(dll),
                    "line": 0,
                    "snippet": "",
                    "classification": "source_backed_type_signature_only_not_executable",
                    "localStatus": "signature_only",
                    "editorExecutable": "False",
                    "reason": "DummyDll is decompiled/type-signature evidence from IL2CPP; not a source-backed executable editor runtime.",
                }
            )
    return rows


def scan_native_and_lua_assets() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    native_patterns = [r"GameAssembly\.dll", r"global-metadata\.dat", r"libil2cpp\.so", r"libxlua.*\.so", r"lua53.*\.dll", r"xlua.*\.dll"]
    native_files = first_existing(native_patterns, [MERGED])
    for path in native_files[:200]:
        lower_name = path.name.lower()
        if "xlua" in lower_name or "lua53" in lower_name or "libxlua" in lower_name:
            classification = "native_or_player_side_lua_candidate_not_editor_importable"
            reason = "Native/player-side Lua artifact would not provide managed xLua C# runtime/bootstrap in the restored Unity editor project."
        else:
            classification = "native_player_runtime_not_editor_importable"
            reason = "Player metadata/native binary is source-backed but not importable as Unity editor managed runtime."
        rows.append(
            {
                "evidenceGroup": "native_player_runtime",
                "symbolOrArtifact": path.name,
                "path": str(path),
                "relativePath": rel(path),
                "line": 0,
                "snippet": "",
                "classification": classification,
                "localStatus": "native_only",
                "editorExecutable": "False",
                "reason": reason,
            }
        )
    if not native_files:
        rows.append(
            {
                "evidenceGroup": "native_player_runtime",
                "symbolOrArtifact": "GameAssembly/global-metadata/libil2cpp/xlua native",
                "path": "",
                "relativePath": "",
                "line": 0,
                "snippet": "",
                "classification": "not_found",
                "localStatus": "missing",
                "editorExecutable": "False",
                "reason": "No matching native/player artifact found in local extracted tree.",
            }
        )

    lua_sources = [
        ("ModulesInit TextAsset index", UNITY_TEXT_INDEX, r"ModulesInit"),
        ("ProcedureNormalBattle TextAsset index", UNITY_TEXT_INDEX, r"ProcedureNormalBattle"),
        ("UI_NormalBattle decoded Lua", MAIN_LUA / "874003978109174219_UI_NormalBattle.lua", r"btnAuto\.onClick|btnTwoSpeed\.onClick|btnFastSkill\.onClick|btnBuff\.onClick"),
        ("UI_BattleBoxPage decoded Lua", MAIN_LUA / "8374052518232552317_UI_BattleBoxPage.lua", r"UIEventListener|onClick"),
        ("UI_Battle3DUI decoded Lua", MAIN_LUA / "-712482409242173665_UI_Battle3DUI.lua", r"UI_BattleBoxPage|LuaUnit"),
    ]
    proc_files = list((XLUA_BATTLE / "download_xlualogic_modules_procedure").glob("*ProcedureNormalBattle*.lua"))
    if proc_files:
        lua_sources.append(("ProcedureNormalBattle decoded Lua", proc_files[0], r"SetGameSpeed|ChangeToAuto|ChangeToManual|ChangeGameFastSkill"))
    for symbol, path, pattern in lua_sources:
        line, snippet = find_line(path, pattern)
        rows.append(
            {
                "evidenceGroup": "decoded_lua_or_textasset",
                "symbolOrArtifact": symbol,
                "path": str(path if line else ""),
                "relativePath": rel(path) if line else "",
                "line": line,
                "snippet": snippet,
                "classification": "source_backed_lua_source_available_not_runtime" if line else "not_found",
                "localStatus": "source_available_not_bootstrapped" if line else "missing",
                "editorExecutable": "False",
                "reason": "Decoded/source-backed Lua is required input, but it cannot execute without xLua/GameEntry/LuaManager bootstrap.",
            }
        )
    rows.append(
        {
            "evidenceGroup": "external_option",
            "symbolOrArtifact": "GitHub/upstream xLua package",
            "path": "EXTERNAL_XLUA_PACKAGE_OPTION",
            "relativePath": "EXTERNAL_XLUA_PACKAGE_OPTION",
            "line": 0,
            "snippet": "",
            "classification": "non_source_backed_external_package_option_requires_user_approval",
            "localStatus": "not_downloaded_not_imported",
            "editorExecutable": "False",
            "reason": "External package import/download is forbidden in BATTLE59 and would require explicit user approval.",
        }
    )
    return rows


def build_runtime_evidence() -> list[dict[str, Any]]:
    rows = []
    rows.extend(scan_project_runtime_candidates())
    rows.extend(scan_bridge_and_il2cpp_evidence())
    rows.extend(scan_native_and_lua_assets())
    return rows


def runtime_status_lookup(rows: list[dict[str, Any]]) -> dict[str, str]:
    by_symbol: dict[str, str] = {}
    for row in rows:
        sym = str(row.get("symbolOrArtifact", ""))
        status = str(row.get("localStatus", ""))
        classification = str(row.get("classification", ""))
        if sym and sym not in by_symbol:
            by_symbol[sym] = f"{status}:{classification}"
    return by_symbol


def build_bootstrap_graph(runtime_rows: list[dict[str, Any]], buttons: list[dict[str, str]]) -> list[dict[str, Any]]:
    lookup = runtime_status_lookup(runtime_rows)
    rows: list[dict[str, Any]] = []
    requirements = [
        ("01", "XLua.LuaEnv", "xLua managed runtime", "missing", "Create Lua VM, loaders, tables/functions", "All UI Lua lifecycle and Button closure binding", "No executable local restored project runtime candidate"),
        ("02", "XLua.LuaTable/LuaFunction", "xLua managed runtime", "missing", "Expose Lua modules/delegates to C# bridge", "LuaForm/LuaUnit/UIEventListener delegates", "Type/signature evidence only"),
        ("03", "XLua.LuaDLL/native plugin", "xLua native bridge", "missing_or_native_only", "Back xLua managed runtime with native Lua VM", "XLua.LuaEnv", "No editor-importable local plugin/package"),
        ("04", "YouYou.GameEntry.Lua", "GameEntry service", "missing", "Provide LuaManager service to bridge components", "LuaForm/LuaUnit lifecycle and decoded GameEntry.* calls", "GameEntry unavailable in restored Unity project"),
        ("05", "YouYou.LuaManager.LoadUIScript", "LuaManager loader", "missing", "Resolve/decrypt/load UI Lua scripts", "UI_NormalBattle/UI_Battle3DUI/UI_BattleBoxPage", "Original signatures only; no runtime object"),
        ("06", "LuaManager.MyLoader/GetLuaBuff/LoadLuaAssetBundle", "Lua loader/decrypt path", "missing", "Load decoded/source TextAsset bytes and module graph", "ModulesInit/ProcedureNormalBattle/UI modules", "Decoded assets exist but loader runtime missing"),
        ("07", "YouYou.LuaForm", "bridge component", "partial_schema_present", "Invoke OnInit/Open and bind UI_NormalBattle closures", "btnAuto/btnBuff/btnTwoSpeed/btnFastSkill", "Bridge exists but lifecycle rows remain 0"),
        ("08", "YouYou.LuaUnit", "bridge component", "partial_schema_present", "Init/Open nested battle UI units", "UI_Battle3DUI and box page", "Bridge exists but lifecycle rows remain 0"),
        ("09", "LuaComponentBinder.LuaComBinder", "component binder", "partial_schema_present", "Resolve named child controls/components for Lua", "UI_BattleBoxPage GenBox and UI scripts", "Partial schema only; no Lua-driven dictionary lifecycle"),
        ("10", "YouYou.UIEventListener.onClick", "UI event bridge", "delegate_unbound", "Bind Lua click delegate to btn_box", "btn_box", "Component exists on btn_box but delegate rows remain 0"),
        ("11", "ModulesInit", "Lua module table", "decoded_source_available_not_bootstrapped", "Initialize module table and managers", "ProcedureNormalBattle, EventSystem, managers", "Decoded source exists; not executed"),
        ("12", "ModulesInit.ProcedureNormalBattle", "battle Lua module", "decoded_source_available_not_initialized", "Provide ChangeToAuto/Manual/SetGameSpeed/FastSkill/battle state", "4 HUD buttons and battle lifecycle", "Decoded source exists; not assigned into live ModulesInit"),
        ("13", "SaveMgr/PlayerMgr/GameTools/SetTimeScaleType", "Lua/CS globals", "unresolved", "Support speed/auto/manual handler body", "btnTwoSpeed/btnAuto", "Required globals unresolved"),
        ("14", "GameFunction/GameFunctionType/LuaUtils/EventSystem/CommonEventId", "Lua/CS globals", "unresolved", "Support UI gates/events/component lookup", "UI_NormalBattle and box page", "Required globals unresolved"),
        ("15", "UIUtil/DOTween/GameEntry.CameraCtrl", "UI/animation services", "unresolved", "Support battle box reward animation and world/camera positions", "btn_box", "Required services unresolved"),
    ]
    for order, node, kind, status, purpose, required_by, blocker in requirements:
        evidence = ""
        for row in runtime_rows:
            if node.split("/")[0] in str(row.get("symbolOrArtifact", "")) or str(row.get("symbolOrArtifact", "")) in node:
                evidence = f"{row.get('classification')} @ {row.get('relativePath') or row.get('path')}"
                break
        rows.append(
            {
                "order": order,
                "node": node,
                "kind": kind,
                "purpose": purpose,
                "requiredBy": required_by,
                "localEvidenceStatus": lookup.get(node, status),
                "feasibility": "blocked" if status.startswith("missing") or "unresolved" in status or "delegate_unbound" in status else "insufficient_partial",
                "evidence": evidence,
                "blockerIfMissing": blocker,
            }
        )

    for row in read_csv(B52_SCHEMA):
        rows.append(
            {
                "order": "B52",
                "node": row.get("requiredTypeOrGlobal", ""),
                "kind": row.get("component", ""),
                "purpose": "BATTLE52 carryover dependency",
                "requiredBy": row.get("requiredBy", ""),
                "localEvidenceStatus": row.get("status", ""),
                "feasibility": "blocked" if "missing" in row.get("status", "") or "unresolved" in row.get("status", "") else "insufficient_partial",
                "evidence": row.get("evidence", ""),
                "blockerIfMissing": row.get("blockerIfMissing", ""),
            }
        )

    before = [r for r in buttons if r.get("phase") == "before_forced_raycaster_registration"]
    for button in before:
        rows.append(
            {
                "order": "BTN",
                "node": button.get("buttonName", ""),
                "kind": "HUD button",
                "purpose": button.get("handlerCandidate", ""),
                "requiredBy": "original Lua click closure",
                "localEvidenceStatus": "raycast_ready_unity_handler_unbound",
                "feasibility": "blocked",
                "evidence": f"directTargetIncluded={button.get('directTargetIncluded')}; onClickKnownCount={button.get('onClickKnownCount')}; uiEventListenerDelegate={button.get('uiEventListenerHasDelegate')}",
                "blockerIfMissing": "Needs source-backed xLua/GameEntry/LuaManager lifecycle to bind original closure; fake handler forbidden.",
            }
        )
    return rows


def build_feasibility_matrix(buttons: list[dict[str, str]], runtime_rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    importable_count = sum(1 for r in runtime_rows if r.get("classification") == "source_backed_importable_editor_runtime_candidate")
    before = [r for r in buttons if r.get("phase") == "before_forced_raycaster_registration"]
    forced = {r.get("buttonName"): r for r in buttons if r.get("phase") == "after_forced_raycaster_registration"}
    source_map = {
        "btnAuto": ("UI_NormalBattle", "874003978109174219_UI_NormalBattle.lua", "86-110", "ChangeToAuto(true)/ChangeToManual"),
        "btnBuff": ("UI_NormalBattle", "874003978109174219_UI_NormalBattle.lua", "180-184", "ShowBuffView(f==false)"),
        "btnTwoSpeed": ("UI_NormalBattle", "874003978109174219_UI_NormalBattle.lua", "111-131", "ProcedureNormalBattle.SetGameSpeed"),
        "btnFastSkill": ("UI_NormalBattle", "874003978109174219_UI_NormalBattle.lua", "132-146", "ChangeGameFastSkill/CheckFastSkill"),
        "btn_box": ("UI_BattleBoxPage/UI_Battle3DUI", "8374052518232552317_UI_BattleBoxPage.lua", "162-178", "CS.YouYou.UIEventListener.onClick"),
    }
    rows: list[dict[str, Any]] = []
    for button in before:
        name = button.get("buttonName", "")
        module, lua_file, lines, handler = source_map.get(name, ("", "", "", button.get("handlerCandidate", "")))
        rows.append(
            {
                "buttonName": name,
                "inputReadyDirectGraphicRaycaster": button.get("directTargetIncluded", ""),
                "inputReadyEventSystemForced": forced.get(name, {}).get("eventTargetIncluded", ""),
                "eventSystemDefaultIncluded": button.get("eventTargetIncluded", ""),
                "activeInteractable": str(truthy(button.get("activeInHierarchy")) and truthy(button.get("interactable"))),
                "sourceBackedLuaHandler": "True",
                "luaModule": module,
                "luaFile": lua_file,
                "luaLineRange": lines,
                "handlerCandidate": handler,
                "unityEventOrDelegateCurrentlyBound": str(intv(button.get("onClickKnownCount")) > 0 or truthy(button.get("uiEventListenerHasDelegate"))),
                "luaLifecycleExecuted": button.get("luaLifecycleExecuted", "False"),
                "requiresExecutableXluaRuntime": "True",
                "requiresGameEntryLuaManager": "True",
                "requiresModulesInitProcedureNormalBattle": "True" if name != "btn_box" else "True_plus_box_services",
                "localImportableRuntimeCandidates": importable_count,
                "bindingFeasibleWithLocalEvidenceOnly": "False",
                "patchDecision": "blocked_no_patch",
                "blocker": "No local source-backed executable xLua/GameEntry/LuaManager bootstrap; fake/no-op handler forbidden.",
            }
        )
    return rows


def build_payload_separation() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    payload = read_json(PAYLOAD_JSON, {})
    summary = payload.get("summary", {})
    auth = payload.get("authoritativePayloadSummary", {})
    rows.append(
        {
            "blockerKind": "runtime_handler",
            "item": "xLua/GameEntry/LuaManager/ModulesInit bootstrap",
            "status": "blocking_handler_binding",
            "localSubsetRelation": "independent_of_actor_rendering",
            "detail": "BATTLE57 actors render, but BATTLE58/BATTLE59 handler closures cannot bind without original runtime bootstrap.",
        }
    )
    rows.append(
        {
            "blockerKind": "actor_payload",
            "item": "local actors",
            "status": "local_subset_only",
            "localSubsetRelation": "3/12 loadable",
            "detail": f"summary={summary or auth}",
        }
    )
    for row in read_csv(PAYLOAD_CSV):
        if row.get("rowType") == "actor" and row.get("localStatus") != "loadable":
            rows.append(
                {
                    "blockerKind": "actor_payload",
                    "item": row.get("payloadHeroDid") or row.get("prefabId") or row.get("bundle"),
                    "status": row.get("localStatus"),
                    "localSubsetRelation": row.get("side"),
                    "detail": row.get("reason") or row.get("missingDependencyBundles"),
                }
            )
        elif row.get("rowType") in {"skill", "resource", "timeline"} and row.get("localStatus") != "loadable":
            rows.append(
                {
                    "blockerKind": row.get("rowType"),
                    "item": row.get("skillDid") or row.get("bundle") or row.get("prefabId"),
                    "status": row.get("localStatus"),
                    "localSubsetRelation": "payload_gap",
                    "detail": row.get("reason") or row.get("missingDependencyBundles"),
                }
            )
    for row in read_csv(B58_PAYLOAD_GAPS):
        rows.append(
            {
                "blockerKind": row.get("gapKind", "payload_gap"),
                "item": row.get("id") or row.get("bundle"),
                "status": row.get("status"),
                "localSubsetRelation": row.get("side"),
                "detail": row.get("reason"),
            }
        )
    return rows


def command_policy() -> dict[str, Any]:
    root_cmds = sorted(str(p) for p in BASE.glob("*.cmd"))
    direct_cmds = sorted(str(p) for p in (BASE / "_restore_tools").glob("*.cmd"))
    return {
        "rootCmdCount": len(root_cmds),
        "rootCmdFiles": root_cmds,
        "restoreToolsDirectCmdCount": len(direct_cmds),
        "restoreToolsDirectCmdFiles": direct_cmds,
    }


def build_md(result: dict[str, Any]) -> str:
    runtime_counts = result["runtimeEvidenceClassificationCounts"]
    button = result["battle58CarryoverButtons"]
    lines = [
        f"# {PREFIX} Result",
        "",
        "**Final playable battle screen remains false.** BATTLE59 audits whether local source-backed evidence can recover an executable xLua/GameEntry/LuaManager bootstrap without stubs or external packages.",
        "",
        "## Verdict",
        f"- visual_status: `{result['visual_status']}`",
        f"- final screen claim: `{str(result['isFinalRestoredBattleScreen']).lower()}`",
        f"- patch decision: `{result['patchDecision']}`",
        f"- scene saved: `{str(result['sceneSaved']).lower()}`",
        f"- source-backed bootstrap applied: `{str(result['sourceBackedBootstrapApplied']).lower()}`",
        f"- handler binding applied: `{str(result['handlerBindingApplied']).lower()}`",
        f"- next blocker: `{result['nextBlocker']}`",
        "",
        "## Local Runtime Feasibility",
        f"- source-backed importable editor runtime candidates: `{result['sourceBackedImportableEditorRuntimeCandidates']}`",
        f"- executable xLua runtime available in restored Unity project: `{str(result['executableXluaRuntimeAvailable']).lower()}`",
        f"- GameEntry/LuaManager executable bootstrap available: `{str(result['gameEntryLuaManagerBootstrapAvailable']).lower()}`",
        f"- runtime evidence rows: `{result['runtimeEvidenceRows']}`",
        f"- runtime classifications: `{dict(runtime_counts)}`",
        "",
        "## BATTLE58 Carryover",
        f"- active/interactable HUD buttons: `{button.get('activeInteractableRows')}` / `5`",
        f"- direct GraphicRaycaster target included: `{button.get('directTargetIncludedRows')}` / `5`",
        f"- EventSystem target before/forced: `{button.get('eventTargetIncludedRows')}` / `{button.get('eventTargetIncludedForcedRows')}`",
        f"- known onClick rows: `{button.get('onClickKnownRows')}`",
        f"- UIEventListener delegate rows: `{button.get('uiEventListenerDelegateRows')}`",
        f"- handler-bound rows: `{button.get('handlerBoundRows')}`",
        "",
        "## Decision",
        "- No scene/code gameplay patch was applied. Local evidence provides decoded Lua, IL2CPP signatures, bridge component schemas, native player artifacts, and BATTLE57 actor rendering, but not an executable editor xLua/GameEntry/LuaManager runtime.",
        "- DummyDll/IL2CPP evidence is type/signature-only. Player native binaries are not editor-importable managed runtime. Decoded Lua cannot execute or bind closures without the missing bootstrap.",
        "- The allowed next choices are original source-backed runtime acquisition or explicit user approval for non-source-backed external xLua experimentation; full payload gaps remain separate.",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- xLua runtime availability/evidence CSV: `{OUT_RUNTIME}`",
        f"- GameEntry/LuaManager/ModulesInit bootstrap requirement graph CSV: `{OUT_BOOTSTRAP}`",
        f"- original handler binding feasibility matrix CSV: `{OUT_MATRIX}`",
        f"- full payload blocker separation CSV: `{OUT_PAYLOAD}`",
        "",
        "## Command Policy",
        f"- root `.cmd` count: `{result['rootCmdCount']}`",
        f"- `_restore_tools` direct `.cmd` count: `{result['restoreToolsDirectCmdCount']}`",
        f"- `플레이.mp4`: `{'available' if PLAY_VIDEO.exists() else 'missing'}`",
        f"- `참고.mp4`: `{'available, auxiliary only' if AUX_VIDEO.exists() else 'missing'}`",
    ]
    return "\n".join(lines) + "\n"


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
        "uiEventListenerDelegateRows": sum(1 for r in before if truthy(r.get("uiEventListenerHasDelegate"))),
        "handlerBoundRows": sum(1 for r in before if truthy(r.get("handlerBound"))),
    }


def main() -> int:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)

    b57 = read_json(B57_JSON, {})
    b58 = read_json(B58_JSON, {})
    buttons = read_csv(B58_BUTTONS)

    runtime_rows = build_runtime_evidence()
    bootstrap_rows = build_bootstrap_graph(runtime_rows, buttons)
    matrix_rows = build_feasibility_matrix(buttons, runtime_rows)
    payload_rows = build_payload_separation()

    runtime_headers = [
        "evidenceGroup",
        "symbolOrArtifact",
        "path",
        "relativePath",
        "line",
        "snippet",
        "classification",
        "localStatus",
        "editorExecutable",
        "reason",
    ]
    bootstrap_headers = [
        "order",
        "node",
        "kind",
        "purpose",
        "requiredBy",
        "localEvidenceStatus",
        "feasibility",
        "evidence",
        "blockerIfMissing",
    ]
    matrix_headers = [
        "buttonName",
        "inputReadyDirectGraphicRaycaster",
        "inputReadyEventSystemForced",
        "eventSystemDefaultIncluded",
        "activeInteractable",
        "sourceBackedLuaHandler",
        "luaModule",
        "luaFile",
        "luaLineRange",
        "handlerCandidate",
        "unityEventOrDelegateCurrentlyBound",
        "luaLifecycleExecuted",
        "requiresExecutableXluaRuntime",
        "requiresGameEntryLuaManager",
        "requiresModulesInitProcedureNormalBattle",
        "localImportableRuntimeCandidates",
        "bindingFeasibleWithLocalEvidenceOnly",
        "patchDecision",
        "blocker",
    ]
    payload_headers = ["blockerKind", "item", "status", "localSubsetRelation", "detail"]

    write_csv(OUT_RUNTIME, runtime_rows, runtime_headers)
    write_csv(OUT_BOOTSTRAP, bootstrap_rows, bootstrap_headers)
    write_csv(OUT_MATRIX, matrix_rows, matrix_headers)
    write_csv(OUT_PAYLOAD, payload_rows, payload_headers)

    class_counts = Counter(str(r.get("classification", "")) for r in runtime_rows)
    importable_count = class_counts.get("source_backed_importable_editor_runtime_candidate", 0)
    policy = command_policy()
    result = {
        "name": PREFIX,
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "visual_status": "blocked_no_local_source_backed_executable_xlua_runtime_no_stub_no_external",
        "isFinalRestoredBattleScreen": False,
        "patchDecision": "blocked_no_patch",
        "sceneSaved": False,
        "sourceBackedBootstrapApplied": False,
        "handlerBindingApplied": False,
        "nextBlocker": "requires_original_xlua_runtime_or_user_approved_external_xlua_and_full_payload_gaps",
        "executableXluaRuntimeAvailable": importable_count > 0,
        "gameEntryLuaManagerBootstrapAvailable": False,
        "sourceBackedImportableEditorRuntimeCandidates": importable_count,
        "runtimeEvidenceRows": len(runtime_rows),
        "bootstrapRequirementRows": len(bootstrap_rows),
        "handlerFeasibilityRows": len(matrix_rows),
        "fullPayloadSeparationRows": len(payload_rows),
        "runtimeEvidenceClassificationCounts": dict(class_counts),
        "battle57Carryover": {
            "runtimeRehydrateUsed": b57.get("runtimeRehydrateUsed"),
            "sourceBackedRehydratedActors": b57.get("mapping", {}).get("sourceBackedRehydratedRows"),
            "meshReadyRows": b57.get("visibility", {}).get("meshReadyRows") or b57.get("renderers", {}).get("meshNonNullRows"),
            "materialReadyRows": b57.get("visibility", {}).get("materialReadyRows") or b57.get("renderers", {}).get("materialReadyRows"),
            "frustumRows": b57.get("visibility", {}).get("frustumRows"),
            "pixelSignalRows": b57.get("visibility", {}).get("capturePixelSignalRows"),
            "isFinalRestoredBattleScreen": b57.get("isFinalRestoredBattleScreen"),
        },
        "battle58CarryoverButtons": summarize_buttons(buttons),
        "battle58Carryover": {
            "visual_status": b58.get("visual_status"),
            "patchDecision": b58.get("patchDecision"),
            "handlerBindingApplied": b58.get("handlerBindingApplied"),
            "sceneSaved": b58.get("sceneSaved"),
            "nextBlocker": b58.get("nextBlocker"),
        },
        "outputs": {
            "md": str(OUT_MD),
            "json": str(OUT_JSON),
            "runtimeEvidenceCsv": str(OUT_RUNTIME),
            "bootstrapGraphCsv": str(OUT_BOOTSTRAP),
            "handlerFeasibilityCsv": str(OUT_MATRIX),
            "fullPayloadSeparationCsv": str(OUT_PAYLOAD),
            "log": str(OUT_LOG),
        },
        "playVideo": "available" if PLAY_VIDEO.exists() else "missing",
        "auxReferenceVideo": "available_auxiliary_only" if AUX_VIDEO.exists() else "missing",
        **policy,
    }

    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    OUT_MD.write_text(build_md(result), encoding="utf-8")
    OUT_LOG.write_text(
        "\n".join(
            [
                f"{PREFIX}",
                f"runtime_rows={len(runtime_rows)}",
                f"bootstrap_rows={len(bootstrap_rows)}",
                f"matrix_rows={len(matrix_rows)}",
                f"payload_rows={len(payload_rows)}",
                f"importable_runtime_candidates={importable_count}",
                "patchDecision=blocked_no_patch",
                "sceneSaved=false",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
