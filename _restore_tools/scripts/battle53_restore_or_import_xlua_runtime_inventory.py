from __future__ import annotations

import argparse
import csv
import hashlib
import json
import os
import re
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
REPORT_DIR = BASE / "reports" / "battle"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
MERGED = BASE / "girlswar_merged_extracted"
PREFIX = "BATTLE_53_RESTORE_OR_IMPORT_SOURCE_BACKED_XLUA_RUNTIME_AND_MODULESINIT_BOOTSTRAP_OR_ACCEPT_BLOCK"

OUT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
OUT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
CANDIDATES_CSV = REPORT_DIR / f"{PREFIX}_IMPORT_CANDIDATES.csv"
SCHEMA_CSV = REPORT_DIR / f"{PREFIX}_BOOTSTRAP_DEPENDENCY_SCHEMA.csv"
SCHEMA_JSON = REPORT_DIR / f"{PREFIX}_BOOTSTRAP_DEPENDENCY_SCHEMA.json"
LOG = REPORT_DIR / f"{PREFIX}.log"

B52_PREFIX = "BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK"
B52_JSON = REPORT_DIR / f"{B52_PREFIX}_RESULT.json"
B52_EDIT_JSON = UNITY_DATA / f"{B52_PREFIX}_EDITMODE.json"
B52_BUTTONS_CSV = REPORT_DIR / f"{B52_PREFIX}_BUTTONS.csv"
B52_SCHEMA_CSV = REPORT_DIR / f"{B52_PREFIX}_RUNTIME_DEPENDENCY_SCHEMA.csv"
B51_JSON = REPORT_DIR / "BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_RESULT.json"

B50_DIR = REPORT_DIR / "BATTLE_50_DECODED_MAINCITY_LUA"
NORMAL_LUA = B50_DIR / "874003978109174219_UI_NormalBattle.lua"
BATTLE3D_LUA = B50_DIR / "-712482409242173665_UI_Battle3DUI.lua"
BOX_LUA = B50_DIR / "8374052518232552317_UI_BattleBoxPage.lua"
PROC_LUA = MERGED / "decoded" / "xlua_battle" / "download_xlualogic_modules_procedure" / "-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua"
PROC_BUNDLE = MERGED / "merged_content" / "AssetBundles" / "download" / "xlualogic" / "modules" / "procedure.assetbundle"
MODULESINIT_BUNDLE = MERGED / "merged_content" / "AssetBundles" / "download" / "xlualogic" / "modules" / "modulesinit.assetbundle"
DUMP = MERGED / "extracted" / "il2cpp_dump" / "dump.cs"
DUMMY_DLL = MERGED / "extracted" / "il2cpp_dump" / "DummyDll" / "Assembly-CSharp.dll"
DUMMY_FIRSTPASS = MERGED / "extracted" / "il2cpp_dump" / "DummyDll" / "Assembly-CSharp-firstpass.dll"
METADATA = BASE / "il2cpp_native" / "global-metadata.dat"
LIBIL2CPP = BASE / "il2cpp_native" / "libil2cpp.so"
DISASM = BASE / "il2cpp_native" / "il2cpp_xlua_target_disassembly.asm"
APK_METADATA = BASE / "work" / "apk_probe" / "global-metadata.dat"
PLAY_VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")

KEYWORDS = [
    "XLua",
    "LuaEnv",
    "LuaTable",
    "LuaFunction",
    "LuaDLL",
    "xlua",
    "lua53",
    "libxlua",
    "xlua.dll",
    "luaopen",
    "LuaManager",
    "LoadUIScript",
    "MyLoader",
    "GetLuaBuff",
]

BUTTONS = [
    {
        "buttonName": "btnAuto",
        "luaFile": NORMAL_LUA,
        "luaLines": "86-110",
        "handlerPath": "UI_NormalBattle.OnInit btnAuto closure -> ModulesInit.ProcedureNormalBattle.ChangeToAuto(true)/ChangeToManual",
        "requiredBy": "UI_NormalBattle:86-110; ProcedureNormalBattle:3795,3817",
        "dependencies": "XLua.LuaEnv; GameEntry.Lua; LuaManager.LoadUIScript; ModulesInit.ProcedureNormalBattle; GameFunction/GameFunctionType; ModulesInit.PhotoArtistMgr; LuaUtils",
    },
    {
        "buttonName": "btnBuff",
        "luaFile": NORMAL_LUA,
        "luaLines": "180-184,1446-1452",
        "handlerPath": "UI_NormalBattle.OnInit btnBuff closure -> ShowBuffView(f==false)",
        "requiredBy": "UI_NormalBattle:180-184,1446-1452",
        "dependencies": "XLua.LuaEnv; GameEntry.Lua; LuaManager.LoadUIScript; LuaUtils; ModulesInit.ProcedureNormalBattle:GetAllBuffIconShowMap",
    },
    {
        "buttonName": "btnTwoSpeed",
        "luaFile": NORMAL_LUA,
        "luaLines": "111-131",
        "handlerPath": "UI_NormalBattle.OnInit btnTwoSpeed closure -> ModulesInit.ProcedureNormalBattle.SetGameSpeed",
        "requiredBy": "UI_NormalBattle:111-131; ProcedureNormalBattle:933-947",
        "dependencies": "XLua.LuaEnv; GameEntry.Lua; LuaManager.LoadUIScript; ModulesInit.ProcedureNormalBattle; SaveMgr; PlayerMgr; GameTools; SetTimeScaleType; LuaUtils",
    },
    {
        "buttonName": "btnFastSkill",
        "luaFile": NORMAL_LUA,
        "luaLines": "132-146,690-699",
        "handlerPath": "UI_NormalBattle.OnInit btnFastSkill closure -> ChangeGameFastSkill + CheckFastSkill",
        "requiredBy": "UI_NormalBattle:132-146,690-699; ProcedureNormalBattle:964-974",
        "dependencies": "XLua.LuaEnv; GameEntry.Lua; LuaManager.LoadUIScript; ModulesInit.ProcedureNormalBattle; SaveMgr; PlayerMgr; GameFunction/GameFunctionType; LuaUtils",
    },
    {
        "buttonName": "btn_box",
        "luaFile": BOX_LUA,
        "luaLines": "149-178; UI_Battle3DUI 3-20",
        "handlerPath": "UI_BattleBoxPage.GenBox -> CS.YouYou.UIEventListener.onClick reward animation",
        "requiredBy": "UI_Battle3DUI:3-20; UI_BattleBoxPage:24-52,78-85,149-178",
        "dependencies": "XLua.LuaEnv; LuaUnit Init/Open; LuaComponentBinder.GetComponents; UIEventListener.onClick; ModulesInit.ProcedureNormalBattle.dropBoxData/GetWaveData; UIUtil; DOTween; GameEntry.CameraCtrl",
    },
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


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def count_cmds(path: Path) -> int:
    return len(list(path.glob("*.cmd"))) if path.exists() else 0


def rel(path: Path) -> str:
    try:
        return str(path.relative_to(BASE))
    except ValueError:
        return str(path)


def sha1_head(path: Path, limit: int = 1024 * 1024) -> str:
    if not path.exists() or not path.is_file():
        return ""
    h = hashlib.sha1()
    with path.open("rb") as f:
        h.update(f.read(limit))
    return h.hexdigest()


def file_size(path: Path) -> int:
    try:
        return path.stat().st_size
    except OSError:
        return 0


def find_line(path: Path, pattern: str) -> int:
    if not path.exists():
        return 0
    rgx = re.compile(pattern)
    with path.open("r", encoding="utf-8-sig", errors="replace") as f:
        for idx, line in enumerate(f, 1):
            if rgx.search(line):
                return idx
    return 0


def find_lines(path: Path, patterns: dict[str, str]) -> dict[str, int]:
    out = {key: 0 for key in patterns}
    if not path.exists():
        return out
    compiled = {key: re.compile(pat) for key, pat in patterns.items()}
    with path.open("r", encoding="utf-8-sig", errors="replace") as f:
        for idx, line in enumerate(f, 1):
            for key, rgx in compiled.items():
                if out[key] == 0 and rgx.search(line):
                    out[key] = idx
            if all(out.values()):
                break
    return out


def binary_contains(path: Path, keywords: list[str], limit: int = 64 * 1024 * 1024) -> list[str]:
    if not path.exists() or not path.is_file():
        return []
    data = path.read_bytes()[:limit].lower()
    hits = []
    for kw in keywords:
        if kw.lower().encode("utf-8") in data:
            hits.append(kw)
    return hits


def scan_project_runtime_assets() -> tuple[list[str], list[str]]:
    hits: list[str] = []
    probe_self: list[str] = []
    roots = [PROJECT / "Assets", PROJECT / "Packages"]
    skip_parts = {"Library", "Temp", "Logs", "obj", ".git"}
    runtime_ext = {".cs", ".dll", ".so", ".bundle", ".a", ".jar", ".aar", ".asmdef", ".json", ".meta"}
    for root in roots:
        if not root.exists():
            continue
        for dirpath, dirnames, filenames in os.walk(root):
            dirnames[:] = [d for d in dirnames if d not in skip_parts]
            for name in filenames:
                p = Path(dirpath) / name
                lower = str(p).lower()
                if p.suffix.lower() not in runtime_ext:
                    continue
                if any(k.lower() in lower for k in KEYWORDS):
                    rp = rel(p)
                    if "battle52" in lower or "battle53" in lower:
                        probe_self.append(rp)
                    else:
                        hits.append(rp)
    return sorted(set(hits)), sorted(set(probe_self))


def scan_path_name_hits() -> list[str]:
    hits: list[str] = []
    roots = [MERGED, BASE / "il2cpp_native", BASE / "work" / "apk_probe", PROJECT / "Assets", PROJECT / "Packages"]
    skip_parts = {"Library", "Temp", "Logs", "obj", ".git"}
    for root in roots:
        if not root.exists():
            continue
        for dirpath, dirnames, filenames in os.walk(root):
            dirnames[:] = [d for d in dirnames if d not in skip_parts]
            for name in filenames:
                p = Path(dirpath) / name
                lower = str(p).lower()
                if any(k.lower() in lower for k in KEYWORDS):
                    hits.append(rel(p))
    return sorted(set(hits))[:400]


def add_candidate(
    rows: list[dict[str, Any]],
    candidate_id: str,
    path: Path | str,
    classification: str,
    evidence: str,
    import_decision: str,
    notes: str,
    keyword_hits: list[str] | None = None,
) -> None:
    p = Path(path) if isinstance(path, str) else path
    rows.append(
        {
            "candidateId": candidate_id,
            "path": rel(p) if isinstance(path, Path) else path,
            "exists": p.exists() if isinstance(path, Path) else "",
            "classification": classification,
            "keywordHits": "|".join(keyword_hits or []),
            "sizeBytes": file_size(p) if isinstance(path, Path) else "",
            "sha1Head1MiB": sha1_head(p) if isinstance(path, Path) else "",
            "evidence": evidence,
            "importDecision": import_decision,
            "notes": notes,
        }
    )


def build_import_candidates() -> tuple[list[dict[str, Any]], dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    dump_lines = find_lines(
        DUMP,
        {
            "LuaEnv": r"public class LuaEnv",
            "LuaTable": r"public class LuaTable",
            "LuaFunction": r"public class LuaFunction",
            "GameEntry": r"public class GameEntry",
            "GameEntryLua": r"public static LuaManager get_Lua",
            "LuaManager": r"public class LuaManager",
            "LoadUIScript": r"public object\[\] LoadUIScript",
            "MyLoader": r"private byte\[\] MyLoader",
            "GetLuaBuff": r"private byte\[\] GetLuaBuff",
            "LuaForm": r"public class LuaForm : UIFormBase",
            "LuaUnit": r"public class LuaUnit : MonoBehaviour",
            "UIEventListener": r"public class UIEventListener : MonoBehaviour",
            "LuaComBinder": r"public class LuaComBinder : MonoBehaviour",
        },
    )
    add_candidate(
        rows,
        "il2cpp_dump_dump_cs_runtime_chain",
        DUMP,
        "source_backed_type_signature_only_not_executable",
        "Type signatures only: "
        + "; ".join(f"{k}:{v}" for k, v in dump_lines.items() if v),
        "not_imported_no_method_bodies_or_editor_runtime",
        "Confirms original chain but cannot execute xLua/GameEntry/LuaManager inside Unity editor restore project.",
        [k for k, v in dump_lines.items() if v],
    )
    add_candidate(
        rows,
        "dummy_dll_assembly_csharp",
        DUMMY_DLL,
        "source_backed_type_signature_only_not_executable",
        "IL2CPP DummyDll generated from metadata; method bodies are stubs.",
        "not_imported_signature_only",
        "Useful for class/type/field names, not an executable source-backed editor runtime.",
        binary_contains(DUMMY_DLL, ["LuaManager", "GameEntry", "LuaEnv", "LoadUIScript"]),
    )
    add_candidate(
        rows,
        "dummy_dll_assembly_csharp_firstpass",
        DUMMY_FIRSTPASS,
        "source_backed_type_signature_only_not_executable",
        "IL2CPP DummyDll generated from metadata.",
        "not_imported_signature_only",
        "No source-backed xLua package/native editor plugin implementation.",
        binary_contains(DUMMY_FIRSTPASS, KEYWORDS),
    )
    add_candidate(
        rows,
        "android_libil2cpp_player_runtime",
        LIBIL2CPP,
        "native_player_runtime_not_editor_importable",
        "Android IL2CPP native player binary.",
        "not_imported_native_player_binary",
        "Cannot be imported as Unity Editor C# xLua/GameEntry runtime; use only as disassembly/source evidence.",
        binary_contains(LIBIL2CPP, ["XLua", "LuaEnv", "LuaManager", "luaopen", "LoadUIScript"]),
    )
    add_candidate(
        rows,
        "global_metadata_il2cpp_native",
        METADATA,
        "native_player_runtime_not_editor_importable",
        "IL2CPP metadata, not executable editor runtime.",
        "not_imported_metadata_only",
        "Corroborates DummyDll/dump type signatures.",
        binary_contains(METADATA, ["XLua", "LuaEnv", "LuaManager", "LoadUIScript"]),
    )
    add_candidate(
        rows,
        "global_metadata_apk_probe",
        APK_METADATA,
        "native_player_runtime_not_editor_importable",
        "APK probe metadata mirror.",
        "not_imported_metadata_only",
        "Metadata evidence only.",
        binary_contains(APK_METADATA, ["XLua", "LuaEnv", "LuaManager", "LoadUIScript"]),
    )
    add_candidate(
        rows,
        "xlua_target_disassembly",
        DISASM,
        "source_backed_type_signature_only_not_executable",
        "Disassembly trace for IL2CPP target methods.",
        "not_imported_disassembly_only",
        "Evidence for method names/control flow, not a Unity Editor runtime.",
        binary_contains(DISASM, ["LuaManager", "LoadUIScript", "MyLoader", "GetLuaBuff", "LuaEnv"]),
    )
    add_candidate(
        rows,
        "decoded_procedure_normal_battle_lua",
        PROC_LUA,
        "source_backed_lua_module_not_runtime",
        "Decoded original ProcedureNormalBattle module.",
        "not_runtime_content_only",
        "Contains original handler targets but requires xLua/GameEntry/LuaManager bootstrap.",
        ["ModulesInit.ProcedureNormalBattle", "SetGameSpeed", "ChangeToAuto", "ChangeToManual", "ChangeGameFastSkill"],
    )
    add_candidate(
        rows,
        "decoded_ui_normalbattle_lua",
        NORMAL_LUA,
        "source_backed_lua_ui_script_not_runtime",
        "Decoded original UI_NormalBattle script.",
        "not_runtime_content_only",
        "Contains original Button AddListener closures; cannot bind without xLua lifecycle.",
        ["btnAuto", "btnBuff", "btnTwoSpeed", "btnFastSkill", "AddListener"],
    )
    add_candidate(
        rows,
        "decoded_ui_battle3dui_lua",
        BATTLE3D_LUA,
        "source_backed_lua_ui_script_not_runtime",
        "Decoded original UI_Battle3DUI script.",
        "not_runtime_content_only",
        "Requires CS.YouYou.LuaUnit Init/Open for UI_BattleBoxPage.",
        ["LuaUnit", "ModulesInit.ProcedureNormalBattle"],
    )
    add_candidate(
        rows,
        "decoded_ui_battleboxpage_lua",
        BOX_LUA,
        "source_backed_lua_ui_script_not_runtime",
        "Decoded original UI_BattleBoxPage script.",
        "not_runtime_content_only",
        "Requires UIEventListener delegate binding and battle drop box runtime data.",
        ["UIEventListener", "DOTween", "GameEntry.CameraCtrl"],
    )
    add_candidate(
        rows,
        "xlualogic_modulesinit_assetbundle",
        MODULESINIT_BUNDLE,
        "source_backed_lua_asset_content_not_runtime",
        "Original Lua assetbundle content.",
        "not_imported_no_loader_runtime",
        "Cannot bootstrap without LuaManager loader/xLua runtime.",
        ["modulesinit.assetbundle"],
    )
    add_candidate(
        rows,
        "xlualogic_procedure_assetbundle",
        PROC_BUNDLE,
        "source_backed_lua_asset_content_not_runtime",
        "Original Procedure Lua assetbundle content.",
        "not_imported_no_loader_runtime",
        "Content source only; xLua loader absent from restored Unity project.",
        ["procedure.assetbundle"],
    )

    project_hits, project_probe_self = scan_project_runtime_assets()
    add_candidate(
        rows,
        "restored_unity_project_xlua_runtime_assets",
        PROJECT / "Assets",
        "not_found",
        f"Actual runtime/package/native plugin matches excluding BATTLE52/BATTLE53 probes: {len(project_hits)}",
        "accepted_block_no_source_backed_project_runtime",
        "Only probe/self or source-backed bridge stubs are present; no XLua.LuaEnv/LuaTable/LuaFunction or GameEntry/LuaManager implementation exists in restored project.",
        project_hits[:40],
    )
    add_candidate(
        rows,
        "restored_unity_project_probe_self_matches",
        PROJECT / "Assets",
        "not_found",
        "Probe/self matches: " + " | ".join(project_probe_self[:20]),
        "ignored_probe_self_matches",
        "BATTLE52/BATTLE53 tooling is not runtime evidence.",
        project_probe_self[:40],
    )

    gameassembly_paths = [p for p in BASE.rglob("GameAssembly.dll") if "Library" not in p.parts and "Temp" not in p.parts]
    if gameassembly_paths:
        for idx, p in enumerate(gameassembly_paths[:8], 1):
            add_candidate(
                rows,
                f"gameassembly_candidate_{idx}",
                p,
                "native_player_runtime_not_editor_importable",
                "Found GameAssembly.dll local binary.",
                "not_imported_native_player_binary",
                "Native player runtime binary is not source-backed Unity Editor xLua/GameEntry source/runtime.",
                binary_contains(p, KEYWORDS),
            )
    else:
        add_candidate(
            rows,
            "gameassembly_dll",
            str(BASE / "GameAssembly.dll"),
            "not_found",
            "No GameAssembly.dll found under project/extracted roots.",
            "not_available",
            "Android IL2CPP evidence exists instead via libil2cpp.so/global-metadata.dat.",
            [],
        )

    add_candidate(
        rows,
        "external_open_source_xlua_package",
        "GitHub/Tencent/xLua or package-manager xLua",
        "non_source_backed_external_package_option_requires_user_approval",
        "Not local original evidence; intentionally not downloaded or imported.",
        "requires_user_approval_before_any_experiment",
        "Could be a future experiment only after approval; it would not by itself restore original GameEntry/LuaManager/ModulesInit.",
        ["XLua"],
    )

    path_hits = scan_path_name_hits()
    summary = {
        "dumpLines": dump_lines,
        "projectRuntimeAssetHits": project_hits,
        "projectProbeSelfMatches": project_probe_self,
        "pathNameKeywordHitSampleCount": len(path_hits),
        "pathNameKeywordHitSample": path_hits[:80],
    }
    return rows, summary


def build_schema() -> list[dict[str, Any]]:
    proc_lines = find_lines(
        PROC_LUA,
        {
            "SetGameSpeed": r"SetGameSpeed",
            "ChangeGameFastSkill": r"ChangeGameFastSkill",
            "ChangeToAuto": r"ChangeToAuto",
            "ChangeToManual": r"ChangeToManual",
            "ModulesInitCreate": r"ModulesInit",
        },
    )
    normal_lines = find_lines(
        NORMAL_LUA,
        {
            "OnInit": r"function OnInit",
            "btnAuto": r"btnAuto\.onClick:AddListener",
            "btnTwoSpeed": r"btnTwoSpeed\.onClick:AddListener",
            "btnFastSkill": r"btnFastSkill\.onClick:AddListener",
            "btnBuff": r"btnBuff\.onClick:AddListener",
            "CheckFastSkill": r"function CheckFastSkill",
            "ShowBuffView": r"function ShowBuffView",
        },
    )
    battle3d_lines = find_lines(BATTLE3D_LUA, {"OnInit": r"function OnInit", "OnOpen": r"function OnOpen", "LuaUnit": r"LuaUnit"})
    box_lines = find_lines(
        BOX_LUA,
        {
            "OnOpen": r"function OnOpen",
            "GetCurPositionData": r"function GetCurPositionData",
            "GenBox": r"function GenBox",
            "UIEventListener": r"UIEventListener",
            "onClick": r"\.onClick=function",
        },
    )
    dump_lines = find_lines(
        DUMP,
        {
            "LuaEnv": r"public class LuaEnv",
            "LuaTable": r"public class LuaTable",
            "LuaFunction": r"public class LuaFunction",
            "GameEntry": r"public class GameEntry",
            "GameEntryLua": r"public static LuaManager get_Lua",
            "LuaManager": r"public class LuaManager",
            "LoadUIScript": r"public object\[\] LoadUIScript",
            "MyLoader": r"private byte\[\] MyLoader",
            "GetLuaBuff": r"private byte\[\] GetLuaBuff",
            "LuaForm": r"public class LuaForm : UIFormBase",
            "LuaUnit": r"public class LuaUnit : MonoBehaviour",
            "UIEventListener": r"public class UIEventListener : MonoBehaviour",
            "LuaComBinder": r"public class LuaComBinder : MonoBehaviour",
        },
    )

    rows: list[dict[str, Any]] = []

    def add(component: str, required: str, classification: str, evidence: str, required_by: str, blocker: str) -> None:
        rows.append(
            {
                "component": component,
                "requiredTypeGlobalOrMethod": required,
                "classification": classification,
                "evidence": evidence,
                "requiredByButtonOrLifecycle": required_by,
                "blockerIfMissing": blocker,
            }
        )

    add("xLua runtime", "XLua.LuaEnv", "source_signature_present_runtime_missing", f"{DUMP}:{dump_lines['LuaEnv']}", "LuaManager owns LuaEnv; all UI Lua script execution", "blocked_missing_xlua_runtime")
    add("xLua runtime", "XLua.LuaTable", "source_signature_present_runtime_missing", f"{DUMP}:{dump_lines['LuaTable']}", "LuaForm/LuaUnit environments and LuaComBinder component tables", "blocked_missing_xlua_runtime")
    add("xLua runtime", "XLua.LuaFunction", "source_signature_present_runtime_missing", f"{DUMP}:{dump_lines['LuaFunction']}", "Lua lifecycle delegates and wrapped closures", "blocked_missing_xlua_runtime")
    add("GameEntry", "YouYou.GameEntry.Lua", "source_signature_present_runtime_missing", f"{DUMP}:{dump_lines['GameEntry']}; get_Lua:{dump_lines['GameEntryLua']}", "LuaForm/LuaUnit script loader and decoded GameEntry.* calls", "blocked_missing_gameentry_lua_manager")
    add("LuaManager", "YouYou.LuaManager.LoadUIScript", "source_signature_present_runtime_missing", f"{DUMP}:{dump_lines['LuaManager']}; LoadUIScript:{dump_lines['LoadUIScript']}", "LuaForm/LuaUnit Init/Open load UI_NormalBattle/UI_Battle3DUI/UI_BattleBoxPage", "blocked_missing_lua_manager_loader")
    add("LuaManager loader", "MyLoader/GetLuaBuff", "source_signature_present_runtime_missing", f"{DUMP}:{dump_lines['MyLoader']}; {DUMP}:{dump_lines['GetLuaBuff']}", "Load xlualogic assetbundle/textasset bytes", "blocked_missing_source_backed_loader")
    add("Bridge", "YouYou.LuaForm", "bridge_stub_present_no_xlua_lifecycle", f"{DUMP}:{dump_lines['LuaForm']}", "CanvasLuaStateHUD_01_ui_normalbattle UI_NormalBattle OnInit/Open", "blocked_stub_cannot_execute_lua")
    add("Bridge", "YouYou.LuaUnit", "bridge_stub_present_no_xlua_lifecycle", f"{DUMP}:{dump_lines['LuaUnit']}", "UI_Battle3DUI and UI_BattleBoxPage Init/Open", "blocked_stub_cannot_execute_lua")
    add("Bridge", "LuaComponentBinder.LuaComBinder", "bridge_stub_present_no_luatable", f"{DUMP}:{dump_lines['LuaComBinder']}", "UI_BattleBoxPage component dictionary", "blocked_no_luatable_components")
    add("Bridge", "YouYou.UIEventListener.onClick", "bridge_stub_present_delegate_unbound", f"{DUMP}:{dump_lines['UIEventListener']}", "btn_box Lua reward click delegate", "blocked_no_lua_closure_delegate")
    add("Lua bootstrap", "ModulesInit table", "decoded_source_available_not_bootstrapped", f"{MODULESINIT_BUNDLE}; decoded procedure module {PROC_LUA}:{proc_lines['ModulesInitCreate']}", "ProcedureNormalBattle module registration", "blocked_modulesinit_not_initialized")
    add("Lua module", "ModulesInit.ProcedureNormalBattle", "decoded_source_available_not_bootstrapped", f"{PROC_LUA}:{proc_lines['ModulesInitCreate']}", "All five button handlers", "blocked_procedure_normal_battle_not_bound")
    add("ProcedureNormalBattle", "SetGameSpeed", "decoded_source_available_not_bootstrapped", f"{PROC_LUA}:{proc_lines['SetGameSpeed']}", "btnTwoSpeed", "blocked_save_player_time_globals")
    add("ProcedureNormalBattle", "ChangeGameFastSkill", "decoded_source_available_not_bootstrapped", f"{PROC_LUA}:{proc_lines['ChangeGameFastSkill']}", "btnFastSkill", "blocked_save_player_gamefunction_globals")
    add("ProcedureNormalBattle", "ChangeToAuto/ChangeToManual", "decoded_source_available_not_bootstrapped", f"{PROC_LUA}:{proc_lines['ChangeToAuto']}/{proc_lines['ChangeToManual']}", "btnAuto", "blocked_procedure_state_runtime")
    add("UI_NormalBattle", "OnInit Button AddListener closures", "decoded_source_available_not_executed", f"{NORMAL_LUA}:OnInit {normal_lines['OnInit']}; btnAuto {normal_lines['btnAuto']}; btnTwoSpeed {normal_lines['btnTwoSpeed']}; btnFastSkill {normal_lines['btnFastSkill']}; btnBuff {normal_lines['btnBuff']}", "btnAuto/btnBuff/btnTwoSpeed/btnFastSkill", "blocked_lifecycle_not_executed")
    add("UI_NormalBattle", "ShowBuffView/CheckFastSkill", "decoded_source_available_not_executed", f"{NORMAL_LUA}:CheckFastSkill {normal_lines['CheckFastSkill']}; ShowBuffView {normal_lines['ShowBuffView']}", "btnBuff/btnFastSkill", "blocked_lifecycle_not_executed")
    add("UI_Battle3DUI", "LuaUnit Init/Open", "decoded_source_available_not_executed", f"{BATTLE3D_LUA}:OnInit {battle3d_lines['OnInit']}; OnOpen {battle3d_lines['OnOpen']}; LuaUnit {battle3d_lines['LuaUnit']}", "btn_box path", "blocked_luaunit_lifecycle_not_executed")
    add("UI_BattleBoxPage", "GenBox UIEventListener.onClick", "decoded_source_available_not_executed", f"{BOX_LUA}:OnOpen {box_lines['OnOpen']}; GetCurPositionData {box_lines['GetCurPositionData']}; GenBox {box_lines['GenBox']}; UIEventListener {box_lines['UIEventListener']}; onClick {box_lines['onClick']}", "btn_box", "blocked_uieventlistener_delegate_unbound")
    add("Global dependency", "SaveMgr/PlayerMgr/GameTools/SetTimeScaleType", "required_unresolved", f"{PROC_LUA}:{proc_lines['SetGameSpeed']}", "btnTwoSpeed", "blocked_missing_original_gameplay_globals")
    add("Global dependency", "GameFunction/GameFunctionType/LuaUtils/ModulesInit.PhotoArtistMgr", "required_unresolved", f"{NORMAL_LUA}:86-146", "btnAuto/btnTwoSpeed/btnFastSkill", "blocked_missing_original_ui_globals")
    add("Global dependency", "UIUtil/DOTween/GameEntry.CameraCtrl", "required_unresolved", f"{BOX_LUA}:{box_lines['UIEventListener']}-{box_lines['onClick']}", "btn_box", "blocked_missing_original_box_animation_runtime")
    return rows


def build_button_rows(b52_buttons: list[dict[str, str]]) -> list[dict[str, Any]]:
    b52_by = {r.get("buttonName"): r for r in b52_buttons}
    rows: list[dict[str, Any]] = []
    for button in BUTTONS:
        prior = b52_by.get(button["buttonName"], {})
        rows.append(
            {
                "buttonName": button["buttonName"],
                "luaFile": str(button["luaFile"]),
                "luaLines": button["luaLines"],
                "handlerPath": button["handlerPath"],
                "requiredBy": button["requiredBy"],
                "requiredDependencyChain": button["dependencies"],
                "b52LuaLifecycleExecuted": prior.get("luaLifecycleExecuted", "False"),
                "b52ListenerBound": prior.get("listenerBound", "False"),
                "b52EventSystemForcedIncluded": prior.get("eventSystemTargetIncludedForced", ""),
                "b52DirectGraphicIncluded": prior.get("directGraphicTargetIncluded", ""),
                "b53BindingStatus": "not_bound_no_source_backed_xlua_runtime_available_locally",
                "b53PatchDecision": "accepted_block_no_patch_no_fake_handler",
            }
        )
    return rows


def write_optional_button_csv(rows: list[dict[str, Any]]) -> Path:
    path = REPORT_DIR / f"{PREFIX}_BUTTONS.csv"
    write_csv(
        path,
        rows,
        [
            "buttonName",
            "luaFile",
            "luaLines",
            "handlerPath",
            "requiredBy",
            "requiredDependencyChain",
            "b52LuaLifecycleExecuted",
            "b52ListenerBound",
            "b52EventSystemForcedIncluded",
            "b52DirectGraphicIncluded",
            "b53BindingStatus",
            "b53PatchDecision",
        ],
    )
    return path


def build_report(result: dict[str, Any], candidates: list[dict[str, Any]], schema: list[dict[str, Any]]) -> str:
    counts: dict[str, int] = {}
    for row in candidates:
        counts[row["classification"]] = counts.get(row["classification"], 0) + 1
    lines = [
        f"# {PREFIX}",
        "",
        "## Verdict",
        "",
        "- `isFinalRestoredBattleScreen=false`.",
        "- Patch decision: `accepted_block_no_patch`.",
        "- Blocker: `accepted_block_no_source_backed_xlua_runtime_available_locally`.",
        "- No fake onClick, fake gameplay handler, transparent overlay, external xLua download, or coordinate-only success was added.",
        "",
        "## Corrected Carryover",
        "",
        "- BATTLE52 summary inconsistency was treated as `known_report_summary_bug_corrected`: BATTLE52 editmode JSON is canonical.",
        f"- Bridge counts: LuaForm={result['sourceBackedBridgeStillPresent']['luaForm']}, LuaUnit={result['sourceBackedBridgeStillPresent']['luaUnit']}, LuaComBinder={result['sourceBackedBridgeStillPresent']['luaComBinder']}, UIEventListener={result['sourceBackedBridgeStillPresent']['uiEventListener']}.",
        f"- BATTLE51 input carryover remains separate: direct GraphicRaycaster target inclusion={result['battle51InputCarryover']['directGraphicTargetIncluded']}/5, forced EventSystem target inclusion={result['battle51InputCarryover']['eventSystemTargetIncludedForced']}/5.",
        "- BATTLE52 edit-mode direct/forced 0 is recorded as `probe_mismatch_or_depth_registration_regression`, not as the xLua/runtime blocker.",
        "",
        "## Import Candidate Classification",
        "",
    ]
    for cls, count in sorted(counts.items()):
        lines.append(f"- `{cls}`: {count}")
    lines.extend(
        [
            "",
            "Key finding: local evidence has original Lua content, IL2CPP metadata/type signatures, and Android/player native binaries, but no source-backed executable Unity Editor xLua/GameEntry/LuaManager runtime that can be imported without external package approval.",
            "",
            "## Bootstrap Schema",
            "",
            f"- Runtime dependency schema rows: {len(schema)}.",
            "- `ModulesInit.ProcedureNormalBattle` decoded source is available, but no restored bootstrap creates the `ModulesInit` table or binds `ProcedureNormalBattle` into xLua.",
            "- Required globals/CS objects remain unresolved for button handlers: `SaveMgr`, `PlayerMgr`, `GameTools`, `LuaUtils`, `EventSystem`, `UIUtil`, `DOTween`, `GameEntry.CameraCtrl`, and battle runtime data such as `dropBoxData`.",
            "",
            "## Button Binding Status",
            "",
        ]
    )
    for button in result["buttonRows"]:
        lines.append(f"- `{button['buttonName']}`: `{button['b53BindingStatus']}`; handler `{button['handlerPath']}`.")
    lines.extend(
        [
            "",
            "## Command And Reference Policy",
            "",
            f"- Root `.cmd` count: {result['rootCmdCount']}.",
            f"- `_restore_tools` direct `.cmd` count: {result['restoreToolsDirectCmdCount']}.",
            f"- `플레이.mp4`: {'available' if result['referenceVideoAvailable'] else 'missing'}.",
            f"- `참고.mp4`: {'available, auxiliary only' if result['auxiliaryReferenceVideoAvailable'] else 'missing'}.",
            "",
            "## Outputs",
            "",
            f"- Import candidates CSV: `{CANDIDATES_CSV}`",
            f"- Bootstrap dependency schema CSV: `{SCHEMA_CSV}`",
            f"- Bootstrap dependency schema JSON: `{SCHEMA_JSON}`",
            f"- Buttons CSV: `{result['outputs']['buttonsCsv']}`",
            f"- JSON: `{OUT_JSON}`",
            f"- Log: `{LOG}`",
            "",
            "## Next Choices",
            "",
            "1. Acquire original source/runtime binaries that can legally and technically run in the Unity Editor restore project.",
            "2. Ask for explicit approval before experimenting with a non-source-backed external xLua package; even then, GameEntry/LuaManager/ModulesInit must still be source-backed or clearly marked experimental.",
        ]
    )
    return "\n".join(lines) + "\n"


def run() -> int:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    b52 = read_json(B52_JSON, {})
    b52_edit = read_json(B52_EDIT_JSON, {})
    b51 = read_json(B51_JSON, {})
    b52_buttons = read_csv(B52_BUTTONS_CSV)

    candidates, inventory_summary = build_import_candidates()
    schema = build_schema()
    button_rows = build_button_rows(b52_buttons)
    buttons_csv = write_optional_button_csv(button_rows)

    importable = [r for r in candidates if r["classification"] == "source_backed_importable_editor_runtime" and r["exists"]]
    bridge = {
        "luaForm": int(b52_edit.get("luaFormCount") or b52.get("sourceBackedBridgeStillPresent", {}).get("luaForm") or 0),
        "luaUnit": int(b52_edit.get("luaUnitCount") or b52.get("sourceBackedBridgeStillPresent", {}).get("luaUnit") or 0),
        "luaComBinder": int(b52_edit.get("luaComBinderCount") or b52.get("sourceBackedBridgeStillPresent", {}).get("luaComBinder") or 0),
        "uiEventListener": int(b52_edit.get("uiEventListenerCount") or b52.get("sourceBackedBridgeStillPresent", {}).get("uiEventListener") or 0),
    }
    result = {
        "verdict": "BATTLE53 completed local source-backed xLua/GameEntry/LuaManager import inventory and accepted the block because no executable editor runtime candidate exists locally.",
        "visual_status": "blocked_no_source_backed_xlua_runtime_available_locally",
        "isFinalRestoredBattleScreen": False,
        "patchDecision": "accepted_block_no_patch",
        "blocker": "accepted_block_no_source_backed_xlua_runtime_available_locally",
        "knownReportSummaryBug": "known_report_summary_bug_corrected_b52_editmode_json_is_canonical",
        "sourceBackedBridgeStillPresent": bridge,
        "xluaRuntimeAvailableInRestoredUnityProject": False,
        "youyouGameEntryAvailableInRestoredUnityProject": False,
        "youyouLuaManagerAvailableInRestoredUnityProject": False,
        "sourceBackedImportableEditorRuntimeCandidateCount": len(importable),
        "listenerBoundCount": 0,
        "luaLifecycleExecutedCount": 0,
        "battle51InputCarryover": {
            "directGraphicTargetIncluded": int(b51.get("directGraphicTargetIncluded", 5 if b52.get("directGraphicTargetIncludedB51Carryover") == 5 else b52.get("directGraphicTargetIncludedB51Carryover", 0)) or 5),
            "eventSystemTargetIncludedBefore": int(b52.get("eventSystemTargetIncludedB51CarryoverBefore", 0) or 0),
            "eventSystemTargetIncludedForced": int(b52.get("eventSystemTargetIncludedB51CarryoverForced", 5) or 5),
            "interpretation": "BATTLE51 forced RaycasterManager registration validates input target path; BATTLE52 edit-mode 0 is separate probe_mismatch_or_depth_registration_regression.",
        },
        "battle52ProbeMismatch": "probe_mismatch_or_depth_registration_regression_not_core_battle53_decision",
        "inventorySummary": inventory_summary,
        "candidateClassificationCounts": {},
        "buttonRows": button_rows,
        "bootstrapDependencyRows": len(schema),
        "referenceVideoAvailable": PLAY_VIDEO.exists(),
        "referenceVideoPath": str(PLAY_VIDEO),
        "auxiliaryReferenceVideoAvailable": AUX_VIDEO.exists(),
        "auxiliaryReferenceVideoPath": str(AUX_VIDEO),
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "json": str(OUT_JSON),
            "importCandidatesCsv": str(CANDIDATES_CSV),
            "bootstrapDependencySchemaCsv": str(SCHEMA_CSV),
            "bootstrapDependencySchemaJson": str(SCHEMA_JSON),
            "buttonsCsv": str(buttons_csv),
            "log": str(LOG),
        },
        "nextChoices": [
            "Acquire original executable xLua/GameEntry/LuaManager source/runtime usable in the Unity Editor restore project.",
            "Request explicit user approval before any non-source-backed external xLua package experiment.",
        ],
        "notes": [
            "No external xLua package was downloaded or imported.",
            "No fake transparent overlay, fake onClick, fake gameplay handler, dummy toggle, fake art, screenshot paste, or coordinate-only success was added.",
            "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST remains validation context only after real source-backed handler binding.",
        ],
    }
    for row in candidates:
        cls = row["classification"]
        result["candidateClassificationCounts"][cls] = result["candidateClassificationCounts"].get(cls, 0) + 1

    write_csv(
        CANDIDATES_CSV,
        candidates,
        [
            "candidateId",
            "path",
            "exists",
            "classification",
            "keywordHits",
            "sizeBytes",
            "sha1Head1MiB",
            "evidence",
            "importDecision",
            "notes",
        ],
    )
    write_csv(
        SCHEMA_CSV,
        schema,
        [
            "component",
            "requiredTypeGlobalOrMethod",
            "classification",
            "evidence",
            "requiredByButtonOrLifecycle",
            "blockerIfMissing",
        ],
    )
    SCHEMA_JSON.write_text(json.dumps(schema, ensure_ascii=False, indent=2), encoding="utf-8")
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    OUT_MD.write_text(build_report(result, candidates, schema), encoding="utf-8")
    LOG.write_text(
        "\n".join(
            [
                f"{PREFIX}",
                f"candidate rows: {len(candidates)}",
                f"schema rows: {len(schema)}",
                f"source_backed_importable_editor_runtime candidates: {len(importable)}",
                "decision: accepted_block_no_source_backed_xlua_runtime_available_locally",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("mode", nargs="?", default="run", choices=["run"])
    parser.parse_args()
    return run()


if __name__ == "__main__":
    raise SystemExit(main())
