#!/usr/bin/env python3
from __future__ import annotations

import csv
import json
import re
import shutil
import subprocess
from datetime import datetime
from pathlib import Path
from typing import Any


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = ROOT / "girlswar_maininterface_unity"
REPORT_DIR = ROOT / "reports" / "maininterface"
RESTORE = PROJECT / "Assets" / "RestoreData"
RESTORE_REPORTS = RESTORE / "reports"
XLUA = ROOT / "girlswar_merged_extracted" / "decoded" / "xlua"
IL2CPP = ROOT / "girlswar_merged_extracted" / "extracted" / "il2cpp_dump"
DUMMY_ASM = IL2CPP / "DummyDll" / "Assembly-CSharp.dll"

TASK = "MAININTERFACE_138_TRACE_UI_MANAGER_CANVASHELPER_AND_UISPINECTR_RUNTIME_ALGORITHM_OR_LOCAL_EXECUTABLE_PROBE_NO_PATCH"
RESULT_MD = REPORT_DIR / f"{TASK}_RESULT.md"
RESULT_JSON = REPORT_DIR / f"{TASK}_RESULT.json"
UIMGR_CSV = REPORT_DIR / "MAININTERFACE_138_uimanager_canvashelper_methods_fields_callsites.csv"
UISPINE_CSV = REPORT_DIR / "MAININTERFACE_138_uispinectr_sp_runtime_component_trace.csv"
RUNTIME_CSV = REPORT_DIR / "MAININTERFACE_138_local_runtime_dump_feasibility_matrix.csv"

UI_MAIN = XLUA / "-6351603197391775840_UI_MainPage_security_xor_raw.lua"
UI_DOCK = XLUA / "-4615102950863731052_UI_Dock_security_xor_raw.lua"
VIEWMGR = ROOT / "girlswar_merged_extracted" / "extracted" / "unity" / "bundles" / "b_272c9612f336692d" / "textassets" / "-1526566646294714906_ViewMgr.txt"
DT_FORM = ROOT / "girlswar_merged_extracted" / "extracted" / "unity" / "bundles" / "b_118e2d32692e66cc" / "textassets" / "7179387777078280832_DTSysUIFormEntityTableData.txt"
COMPONENTS = RESTORE / "maininterface_components.csv"
LUA_BINDINGS = RESTORE_REPORTS / "maininterface_lua_com_bindings.csv"
UI136_PROBE = REPORT_DIR / "MAININTERFACE_136_uidock_candidate_scene_probe.csv"
UI137_JSON = REPORT_DIR / "MAININTERFACE_137_TRACE_PRODUCTION_FORM_LAYER_ORDER_AND_ACTIVITY_ACCOUNT_CHAT_RUNTIME_STATE_NO_FAKE_PATCH_RESULT.json"


def read_text(path: Path) -> str:
    if not path.exists():
        return ""
    return path.read_text(encoding="utf-8-sig", errors="replace")


def read_lines(path: Path) -> list[str]:
    return read_text(path).splitlines()


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for row in rows:
            writer.writerow({field: row.get(field, "") for field in fields})


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


def snippet(path: Path, start: int, end: int) -> str:
    lines = read_lines(path)
    parts: list[str] = []
    for i in range(start, min(end, len(lines)) + 1):
        parts.append(f"L{i}:{lines[i - 1]}")
    return " | ".join(parts)


def find_lines(path: Path, pattern: str, limit: int = 20) -> list[tuple[int, str]]:
    rx = re.compile(pattern)
    rows: list[tuple[int, str]] = []
    for i, line in enumerate(read_lines(path), 1):
        if rx.search(line):
            rows.append((i, line.strip()))
            if len(rows) >= limit:
                break
    return rows


def command_policy() -> dict[str, Any]:
    return {
        "rootCmdCount": len(list(ROOT.glob("*.cmd"))),
        "restoreToolsDirectCmdCount": len(list((ROOT / "_restore_tools").glob("*.cmd"))),
    }


def run_ilspy(type_name: str) -> str:
    if not shutil.which("ilspycmd") or not DUMMY_ASM.exists():
        return ""
    try:
        result = subprocess.run(
            ["ilspycmd", "-t", type_name, str(DUMMY_ASM)],
            cwd=str(ROOT),
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=60,
            check=False,
        )
    except Exception as exc:
        return f"ILSPY_ERROR: {exc}"
    return result.stdout


def parse_members(type_name: str, source_text: str) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    current_attr: list[str] = []
    pending_token = ""
    pending_address = ""
    for line_no, raw in enumerate(source_text.splitlines(), 1):
        line = raw.strip()
        if not line:
            continue
        if line.startswith("[Token("):
            pending_token = line
            continue
        if line.startswith("[Address("):
            pending_address = line
            continue
        if line.startswith("[") or line.endswith("]"):
            current_attr.append(line)
            continue
        kind = ""
        name = ""
        detail = ""
        if re.match(r"(public|private|protected|internal).*;", line):
            kind = "field"
            detail = line
            m = re.search(r"\s([A-Za-z_<>][A-Za-z0-9_<>]*)\s*;", line)
            name = m.group(1) if m else line
        elif re.match(r"(public|private|protected|internal).*[\w<>]\s*\(", line) or re.match(r"(public|private|protected|internal).*operator", line):
            kind = "method"
            detail = line
            m = re.search(r"\s([A-Za-z_<>][A-Za-z0-9_<>]*)\s*\(", line)
            name = m.group(1) if m else line
        elif re.match(r"(public|private|protected|internal).*\{", line) and "=>" not in line:
            kind = "property_or_event"
            detail = line
            m = re.search(r"\s([A-Za-z_<>][A-Za-z0-9_<>]*)\s*$", line.rstrip("{").strip())
            name = m.group(1) if m else line
        if kind:
            rows.append(
                {
                    "source_kind": "ilspy_dummy_dll_decompile",
                    "source_path": str(DUMMY_ASM),
                    "line_or_range": line_no,
                    "class_or_file": type_name,
                    "symbol": name,
                    "evidence_type": kind,
                    "detail": detail,
                    "token_or_address": " ".join(x for x in [pending_token, pending_address] if x),
                    "interpretation": "DummyDll exposes signature/field shape but not the IL2CPP native method body; use as structural evidence, not algorithm proof.",
                    "decision": "algorithm_body_not_recovered_from_dummy_dll",
                }
            )
            current_attr.clear()
            pending_token = ""
            pending_address = ""
    return rows


def script_json_hits() -> list[dict[str, Any]]:
    script_json = IL2CPP / "script.json"
    wanted = {
        "YouYouYouYouUIManagerWrap._m_OpenUIForm": "YouYouUIManager.OpenUIForm xLua wrapper",
        "YouYouYouYouUIManagerWrap._m_CloseUIForm": "YouYouUIManager.CloseUIForm xLua wrapper",
        "YouYouYouYouUIManagerWrap._m_GetUIGroup": "YouYouUIManager.GetUIGroup xLua wrapper",
        "YouYouYouYouUIManagerWrap._m_NormalFormCanvasScaler": "YouYouUIManager.NormalFormCanvasScaler xLua wrapper",
        "YouYouYouYouUIManagerWrap._m_FullFormCanvasScaler": "YouYouUIManager.FullFormCanvasScaler xLua wrapper",
        "YouYouYouYouCanvasHelperWrap._m_SetDepth": "YouYouCanvasHelper.SetDepth xLua wrapper",
        "YouYouYouYouCanvasHelperWrap._m_ResetDepth": "YouYouCanvasHelper.ResetDepth xLua wrapper",
        "YouYouYouYouCanvasHelperWrap._m_ResetRenderDepth": "YouYouCanvasHelper.ResetRenderDepth xLua wrapper",
        "YouYouYouYouCanvasHelperWrap._m_OnDepthChanged": "YouYouCanvasHelper.OnDepthChanged xLua wrapper",
        "YouYouUISpineCtrWrap._m_PlayAnimation": "UISpineCtr.PlayAnimation xLua wrapper",
        "YouYouUISpineCtrWrap._m_PlayAnimation2": "UISpineCtr.PlayAnimation2 xLua wrapper",
        "YouYouUISpineCtrWrap._m_SetToSetupPose": "UISpineCtr.SetToSetupPose xLua wrapper",
        "YouYouUISpineCtrWrap._m_ClearTracks": "UISpineCtr.ClearTracks xLua wrapper",
    }
    rows: list[dict[str, Any]] = []
    if not script_json.exists():
        return rows
    found: set[str] = set()
    with script_json.open("r", encoding="utf-8", errors="replace") as f:
        for line_no, line in enumerate(f, 1):
            for needle, label in wanted.items():
                if needle in line and needle not in found:
                    found.add(needle)
                    rows.append(
                        {
                            "source_kind": "il2cpp_script_json",
                            "source_path": str(script_json),
                            "line_or_range": line_no,
                            "class_or_file": "script.json",
                            "symbol": needle,
                            "evidence_type": "xLua_wrap_method",
                            "detail": line.strip(),
                            "token_or_address": "",
                            "interpretation": f"{label} exists in generated xLua wrap metadata; wrapper presence does not recover runtime implementation.",
                            "decision": "metadata_only_needs_runtime_or_native_algorithm",
                        }
                    )
                    break
            if len(found) == len(wanted):
                break
    return rows


def dt_form_rows() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for line_no, line in enumerate(read_lines(DT_FORM), 1):
        if "UI_Dock" not in line and "UI_MainPage" not in line:
            continue
        inner = line.strip()
        if inner.startswith("{") and inner.endswith("},"):
            inner = inner[1:-2]
        elif inner.startswith("{") and inner.endswith("}"):
            inner = inner[1:-1]
        try:
            parsed = next(csv.reader([inner]))
        except Exception:
            parsed = []
        target = parsed[2] if len(parsed) > 2 else ""
        if target not in {"UI_Dock", "UI_MainPage", "UI_Dock_xmas", "UI_MainPage_xmas"}:
            continue
        rows.append(
            {
                "source_kind": "datatable",
                "source_path": str(DT_FORM),
                "line_or_range": line_no,
                "class_or_file": "DTSysUIFormEntityTableData",
                "symbol": target,
                "evidence_type": "ui_form_row",
                "detail": f"formId={parsed[0] if len(parsed)>0 else ''}; flags3_5={'|'.join(parsed[3:6]) if len(parsed)>=6 else ''}; prefab={parsed[6] if len(parsed)>6 else ''}; module={parsed[16] if len(parsed)>16 else ''}",
                "token_or_address": "",
                "interpretation": "Form/prefab/module are source-backed; raw flag semantics alone are insufficient for exact group depth/sorting.",
                "decision": "form_identity_confirmed_depth_algorithm_unresolved",
            }
        )
    return rows


def lua_callsite_rows() -> list[dict[str, Any]]:
    specs = [
        (UI_DOCK, "UI_Dock.OnOpen", 44, 80, "default DOCK_TYPE.MAIN_PAGE, initEnterTab, lifecycle listeners"),
        (UI_DOCK, "UI_Dock.initTab", 138, 149, "calls GetComponent(CS.YouYou.UISpineCtr) and PlayAnimation A/B on sp_* bindings"),
        (UI_DOCK, "UI_Dock.setCurrView", 250, 286, "uses ViewMgr:clostEnableLayerView and GameEntry.UI:OpenUIForm(UI_MainPage)"),
        (UI_DOCK, "UI_Dock.show_hide", 575, 580, "plays UI_Dock_out/UI_Dock_in animator clips"),
        (UI_MAIN, "UI_MainPage.OnOpen", 223, 310, "runtime refresh, ViewMgr close layer, UI_MainInterface_in/idle, activity/chat/account listeners"),
    ]
    rows: list[dict[str, Any]] = []
    for path, symbol, start, end, interpretation in specs:
        rows.append(
            {
                "source_kind": "decoded_lua",
                "source_path": str(path),
                "line_or_range": f"{start}-{end}",
                "class_or_file": path.name,
                "symbol": symbol,
                "evidence_type": "runtime_callsite",
                "detail": snippet(path, start, end),
                "token_or_address": "",
                "interpretation": interpretation,
                "decision": "source_runtime_path_requires_real_UIManager_Lua_execution_or_equivalent_reimplementation",
            }
        )
    for line_no, line in find_lines(VIEWMGR, r"clostEnableLayerView|checkIsTopShowView|OnLuaViewChange|ShowView|CloseView", 30):
        rows.append(
            {
                "source_kind": "decoded_lua_textasset",
                "source_path": str(VIEWMGR),
                "line_or_range": line_no,
                "class_or_file": VIEWMGR.name,
                "symbol": "ViewMgr_layer_visibility_callsite",
                "evidence_type": "view_layer_runtime",
                "detail": line,
                "token_or_address": "",
                "interpretation": "ViewMgr participates in active layer/view close behavior before UI_MainPage/UI_Dock opens.",
                "decision": "needs_runtime_stack_probe",
            }
        )
    return rows


def uimanager_canvashelper_rows() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for type_name in [
        "YouYou.YouYouUIManager",
        "YouYou.AbstractUIManager",
        "YouYou.UIManager",
        "YouYou.UIManager2",
        "YouYou.UISetActiveManager",
        "YouYou.UIFormBase",
        "YouYou.UIGroup",
        "YouYou.UILayer",
        "YouYou.YouYouCanvasHelper",
        "XLua.CSObjectWrap.YouYouYouYouUIManagerWrap",
        "XLua.CSObjectWrap.YouYouYouYouCanvasHelperWrap",
    ]:
        rows.extend(parse_members(type_name, run_ilspy(type_name)))
    rows.extend(script_json_hits())
    rows.extend(dt_form_rows())
    rows.extend(lua_callsite_rows())
    return rows


def component_rows_by_game_object(ids: set[str]) -> list[dict[str, str]]:
    rows = read_csv(COMPONENTS)
    return [row for row in rows if row.get("game_object_id", "") in ids or row.get("component_path_id", "") in ids]


def uispine_rows() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for type_name in ["YouYou.UISpineCtr", "XLua.CSObjectWrap.YouYouUISpineCtrWrap"]:
        for row in parse_members(type_name, run_ilspy(type_name)):
            row = dict(row)
            row["binding_root"] = ""
            row["candidate_probe_state"] = ""
            rows.append(row)

    bindings = read_csv(LUA_BINDINGS)
    dock_bindings = [
        r for r in bindings
        if r.get("owner_game_object_name") in {"UI_Dock", "UI_Dock_old"}
        and (r.get("group_name") in {"spine", "gray_spine"} or r.get("com_name", "").startswith("sp_"))
    ]
    ids = {r.get("com_obj_path_id", "") for r in dock_bindings} | {r.get("com_game_object_id", "") for r in dock_bindings}
    component_rows = component_rows_by_game_object(ids)
    components_by_go: dict[str, list[dict[str, str]]] = {}
    for comp in component_rows:
        components_by_go.setdefault(comp.get("game_object_id", ""), []).append(comp)
        components_by_go.setdefault(comp.get("component_path_id", ""), []).append(comp)

    candidate = read_csv(UI136_PROBE)
    candidate_by_name = {r.get("name", "").split("__", 1)[0]: r for r in candidate if r.get("name", "").startswith("sp_")}

    for binding in dock_bindings:
        comps = components_by_go.get(binding.get("com_game_object_id", ""), []) + components_by_go.get(binding.get("com_obj_path_id", ""), [])
        comp_summary = " | ".join(
            f"{c.get('kind')} script={c.get('script_id')} keys={c.get('keys')}" for c in comps[:4]
        )
        name = binding.get("com_name", "")
        candidate_row = candidate_by_name.get(name) or {}
        rows.append(
            {
                "source_kind": "lua_binding_restoredata",
                "source_path": str(LUA_BINDINGS),
                "line_or_range": "",
                "class_or_file": binding.get("owner_game_object_name", ""),
                "symbol": name,
                "evidence_type": "spine_binding",
                "detail": f"group={binding.get('group_name')}; com_type={binding.get('com_type')}; objPathId={binding.get('com_obj_path_id')}; gameObjectId={binding.get('com_game_object_id')}; components={comp_summary}",
                "token_or_address": "",
                "interpretation": "Lua binds sp_* objects, then UI_Dock.initTab asks each for CS.YouYou.UISpineCtr. Component CSV shows original custom MonoBehaviour/SkeletonGraphic-related data for several source objects.",
                "decision": "source_renderer_binding_exists_but_runtime_reconstruction_incomplete",
                "binding_root": binding.get("owner_game_object_name", ""),
                "candidate_probe_state": f"UI136={candidate_row.get('componentTypes', 'not_found')}; active={candidate_row.get('activeInHierarchy', '')}; note={candidate_row.get('note', '')}",
            }
        )

    for line_no, line in find_lines(UI_DOCK, r"UISpineCtr|PlayAnimation|SetToSetupPose|ClearTracks", 20):
        rows.append(
            {
                "source_kind": "decoded_lua",
                "source_path": str(UI_DOCK),
                "line_or_range": line_no,
                "class_or_file": UI_DOCK.name,
                "symbol": "UI_Dock_UISpineCtr_callsite",
                "evidence_type": "runtime_callsite",
                "detail": line,
                "token_or_address": "",
                "interpretation": "Dock sp_* nodes require real UISpineCtr component execution; fake or flat sprite substitution is not allowed.",
                "decision": "blocked_no_fake_spine",
                "binding_root": "UI_Dock",
                "candidate_probe_state": "",
            }
        )
    return rows


def runtime_files_summary() -> dict[str, Any]:
    paths = {
        "apk": ROOT / "girlswar_merged_extracted" / "split_apks" / "com.girlwars.kr.apk",
        "libil2cpp_root": ROOT / "il2cpp_native" / "libil2cpp.so",
        "metadata_root": ROOT / "il2cpp_native" / "global-metadata.dat",
        "libil2cpp_probe": ROOT / "work" / "apk_probe" / "libil2cpp.so",
        "metadata_probe": ROOT / "work" / "apk_probe" / "global-metadata.dat",
        "unity_project": PROJECT,
    }
    return {key: {"path": str(path), "exists": path.exists(), "size": path.stat().st_size if path.exists() and path.is_file() else ""} for key, path in paths.items()}


def runtime_matrix_rows() -> list[dict[str, Any]]:
    files = runtime_files_summary()
    rows = [
        {
            "probe_path": "IL2CPP DummyDll + script.json static trace",
            "local_artifact": f"{DUMMY_ASM}; {IL2CPP / 'script.json'}",
            "exists": DUMMY_ASM.exists(),
            "can_run_original_game": False,
            "can_dump_ui_stack": False,
            "can_recover_depth_algorithm": "partial_signature_only",
            "can_recover_uispine_renderer": "partial_signature_and_serialized_refs_only",
            "risk_or_blocker": "DummyDll has fields/signatures/RVAs but empty method bodies; native lib analysis or live runtime needed for formulas.",
            "decision": "use_as_static_evidence_not_patch_basis",
        },
        {
            "probe_path": "Original APK local launch/instrumentation",
            "local_artifact": files["apk"]["path"],
            "exists": files["apk"]["exists"],
            "can_run_original_game": "not_in_current_windows_shell_without_android_runtime",
            "can_dump_ui_stack": "feasible_only_with_safe_android_emulator/device_and_instrumentation",
            "can_recover_depth_algorithm": "yes_if_runtime_dump_hooks_GameEntry_UI_YouYouCanvasHelper",
            "can_recover_uispine_renderer": "yes_if_runtime_dump_hooks_UISpineCtr_and_serialized_SkeletonGraphic",
            "risk_or_blocker": "No configured emulator/device/runtime hook in this task; launching/instrumenting original app is outside current no-patch local Unity rebuild flow.",
            "decision": "blocked_pending_user_approved_runtime_dump_environment",
        },
        {
            "probe_path": "Native libil2cpp/global-metadata reverse trace",
            "local_artifact": f"{files['libil2cpp_root']['path']}; {files['metadata_root']['path']}",
            "exists": files["libil2cpp_root"]["exists"] and files["metadata_root"]["exists"],
            "can_run_original_game": False,
            "can_dump_ui_stack": False,
            "can_recover_depth_algorithm": "possible_with_native_disassembly_but_not_completed_here",
            "can_recover_uispine_renderer": "possible_with_native_disassembly_but_not_runtime_state",
            "risk_or_blocker": "Would need native IL2CPP method body analysis at RVAs from DummyDll; current evidence does not yet recover formulas safely.",
            "decision": "next_static_deep_dive_candidate_not_scene_patch",
        },
        {
            "probe_path": "Unity project candidate replay",
            "local_artifact": str(PROJECT),
            "exists": PROJECT.exists(),
            "can_run_original_game": False,
            "can_dump_ui_stack": "static_candidate_only",
            "can_recover_depth_algorithm": "no_without_reimplementing_UIManager_or_loading_original_runtime",
            "can_recover_uispine_renderer": "no_for_UI_Dock_sp_until_custom_component_and_assets_are_bound",
            "risk_or_blocker": "UI136 capture proved simple source-built sibling mount worsens metrics; current project does not execute original YouYouUIManager/UISpineCtr runtime path.",
            "decision": "trace_only_no_candidate_promotion",
        },
        {
            "probe_path": "External xLua/package import",
            "local_artifact": "not used",
            "exists": False,
            "can_run_original_game": False,
            "can_dump_ui_stack": False,
            "can_recover_depth_algorithm": False,
            "can_recover_uispine_renderer": False,
            "risk_or_blocker": "Forbidden without explicit user approval.",
            "decision": "forbidden",
        },
    ]
    return rows


def make_markdown(payload: dict[str, Any], counts: dict[str, int]) -> str:
    return f"""# {TASK}

Generated: {payload['generatedAt']}

## Decision
- restoredClaim: false
- scenePatchApplied: false
- candidatePatchApplied: false
- patchDecision: {payload['patchDecision']}
- runtimeEquivalentDepthRecovered: false
- uiDockPromotionAllowed: false
- uiSpineRendererRecovered: false
- localRuntimeDumpFeasible: {payload['localRuntimeDumpFeasible']}

## Findings
- `YouYouUIManager`, `AbstractUIManager`, `UIFormBase`, `UIGroup`, `UILayer`, and `YouYouCanvasHelper` signatures/fields are recoverable from DummyDll. They prove the production stack uses UI form groups, BaseOrder, UIFormBase.Depth, Canvas, CanvasGroup, and CanvasHelper depth handlers rather than plain sibling placement.
- `YouYouCanvasHelper` has `m_Depth`, `m_UIFormBase`, `m_Canvas`, `m_Raycaster`, plus `OnOpenHandler`, `OnCloseHandler`, `OnDepthChanged`, `ResetDepth`, `ResetRenderDepth`, and `SetDepth`. DummyDll does not expose method bodies, so sorting/depth formulas are not recovered.
- `UISpineCtr` contains a private `SkeletonGraphic` field and `PlayAnimation/PlayAnimation2/SetToSetupPose/ClearTracks` methods. `UI_Dock.initTab()` requires this component on each `sp_*` node.
- UI136 candidate rows still show Dock `sp_*` nodes as RectTransform-only, so the runtime renderer is not recovered. Source bindings and serialized components prove what is missing; they do not justify a fake renderer.
- A local APK, `libil2cpp.so`, and `global-metadata.dat` exist, but there is no current safe/local runtime dump path configured in this task. Live dump is feasible only with an approved Android runtime/instrumentation path or a later native-method-body recovery pass.

## Outputs
- UIManager/CanvasHelper evidence rows: {counts['uimgr']}
- UISpineCtr/sp evidence rows: {counts['uispine']}
- Runtime feasibility rows: {counts['runtime']}

## Next Blocker
Recover actual `YouYouUIManager`/`YouYouCanvasHelper` method bodies or run a safe original-runtime dump for `UI_Dock` + `UI_MainPage` form group, BaseOrder, form Depth, Canvas sortingOrder, masks/stencils, and `UISpineCtr` SkeletonGraphic bindings. Without that, UI_Dock promotion remains blocked.
"""


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    uimgr = uimanager_canvashelper_rows()
    uispine = uispine_rows()
    runtime = runtime_matrix_rows()

    uimgr_fields = [
        "source_kind",
        "source_path",
        "line_or_range",
        "class_or_file",
        "symbol",
        "evidence_type",
        "detail",
        "token_or_address",
        "interpretation",
        "decision",
    ]
    uispine_fields = uimgr_fields + ["binding_root", "candidate_probe_state"]
    runtime_fields = [
        "probe_path",
        "local_artifact",
        "exists",
        "can_run_original_game",
        "can_dump_ui_stack",
        "can_recover_depth_algorithm",
        "can_recover_uispine_renderer",
        "risk_or_blocker",
        "decision",
    ]
    write_csv(UIMGR_CSV, uimgr, uimgr_fields)
    write_csv(UISPINE_CSV, uispine, uispine_fields)
    write_csv(RUNTIME_CSV, runtime, runtime_fields)

    cmd_policy = command_policy()
    cmd_policy["policyOk"] = cmd_policy["rootCmdCount"] == 1 and cmd_policy["restoreToolsDirectCmdCount"] == 0
    payload: dict[str, Any] = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "task": TASK,
        "restoredClaim": False,
        "scenePatchApplied": False,
        "candidatePatchApplied": False,
        "patchDecision": "trace_only_no_patch",
        "runtimeEquivalentDepthRecovered": False,
        "uiDockPromotionAllowed": False,
        "uiSpineRendererRecovered": False,
        "localRuntimeDumpFeasible": "conditionally_feasible_with_apk_or_native_probe_but_not_currently_configured",
        "requiredNextEvidence": [
            "YouYouUIManager/AbstractUIManager/UILayer/YouYouCanvasHelper native method bodies or live runtime dump for form group/baseOrder/depth/sorting formulas",
            "runtime UI_Dock and UI_MainPage dump of parent group, Canvas sortingOrder, sibling order, mask/stencil, CanvasScaler mode, and active state",
            "UI_Dock sp_* original SkeletonGraphic/SkeletonDataAsset/material bindings or original UISpineCtr execution dump",
            "approved original APK/emulator instrumentation path or static native IL2CPP method-body recovery plan",
            "real activity/account/chat snapshot through UI130 replay pipeline for dynamic labels/icons",
        ],
        "guardrailsTouched": {
            "sceneOrCandidatePatched": False,
            "uiBgRaycastInteractableAltered": False,
            "btnDiscordReviewHideApplied": False,
            "activitySlotsHiddenOrFaked": False,
            "routeWorldZhuyeNodesHidden": False,
            "painting1005BackPromoted": False,
            "fakeHudIconTextSpineCreated": False,
        },
        "inputContext": {
            "ui137Decision": json.loads(read_text(UI137_JSON)) if UI137_JSON.exists() else {},
            "runtimeFiles": runtime_files_summary(),
        },
        "csvs": {
            "uimanagerCanvasHelperMethodsFieldsCallsites": str(UIMGR_CSV),
            "uispineCtrSpRuntimeComponentTrace": str(UISPINE_CSV),
            "localRuntimeDumpFeasibilityMatrix": str(RUNTIME_CSV),
        },
        "rowCounts": {
            "uimgr": len(uimgr),
            "uispine": len(uispine),
            "runtime": len(runtime),
        },
        "commandPolicy": cmd_policy,
    }
    write_json(RESULT_JSON, payload)
    RESULT_MD.write_text(make_markdown(payload, payload["rowCounts"]), encoding="utf-8")


if __name__ == "__main__":
    main()
