#!/usr/bin/env python3
from __future__ import annotations

import csv
import json
import re
from datetime import datetime
from pathlib import Path
from typing import Any


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = ROOT / "reports" / "maininterface"
RESTORE = ROOT / "girlswar_maininterface_unity" / "Assets" / "RestoreData"
RESTORE_REPORTS = RESTORE / "reports"
MERGED = ROOT / "girlswar_merged_extracted"
IL2CPP_DUMP = MERGED / "extracted" / "il2cpp_dump" / "dump.cs"
DT_FORM = MERGED / "extracted" / "unity" / "bundles" / "b_118e2d32692e66cc" / "textassets" / "7179387777078280832_DTSysUIFormEntityTableData.txt"
UI_DOCK_LUA = MERGED / "decoded" / "xlua" / "-4615102950863731052_UI_Dock_security_xor_raw.lua"
UI_MAINPAGE_LUA = MERGED / "decoded" / "xlua" / "-6351603197391775840_UI_MainPage_security_xor_raw.lua"
MAININTERFACE_BUNDLE = MERGED / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "ui" / "uiprefabandres" / "maininterface.assetbundle"
COMPONENTS = RESTORE / "maininterface_components.csv"
RECTS = RESTORE / "maininterface_rects.csv"
LUA_COM_BINDINGS = RESTORE_REPORTS / "maininterface_lua_com_bindings.csv"
UI136_PROBE = REPORT_DIR / "MAININTERFACE_136_uidock_candidate_scene_probe.csv"
UI140_FINDINGS = REPORT_DIR / "MAININTERFACE_140_static_formula_and_binding_findings.csv"

TASK = "MAININTERFACE_141_STATIC_FORM_DEPTH_FORMULA_TO_SOURCE_UI_DOCK_MAINPAGE_EVIDENCE_NO_PATCH"
RESULT_MD = REPORT_DIR / f"{TASK}_RESULT.md"
RESULT_JSON = REPORT_DIR / f"{TASK}_RESULT.json"
DTSYS_CSV = REPORT_DIR / "MAININTERFACE_141_dtsysuiform_field_decode_formula_input_matrix.csv"
UILAYER_CSV = REPORT_DIR / "MAININTERFACE_141_uilayer_group_cursor_baseorder_source_availability_matrix.csv"
CANVASHELPER_CSV = REPORT_DIR / "MAININTERFACE_141_canvashelper_serialized_depth_evidence_matrix.csv"
SPINE_CSV = REPORT_DIR / "MAININTERFACE_141_uidock_sp_uispinectr_skeletongraphic_binding_evidence_matrix.csv"

CANVASHELPER_SCRIPT_ID = "2150366434557054024"
SKELETON_GRAPHIC_SCRIPT_ID = "-6938409698251234290"
UISPINECTR_SCRIPT_ID = "-8877758280253173385"
LUA_FORM_SCRIPT_ID = "8347263561838679580"
DOCK_PAGE_SCRIPT_ID = "2349074181781781832"


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8-sig", errors="replace") if path.exists() else ""


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


def command_policy() -> dict[str, Any]:
    root_cmd = len(list(ROOT.glob("*.cmd")))
    restore_direct_cmd = len(list((ROOT / "_restore_tools").glob("*.cmd")))
    return {
        "rootCmdCount": root_cmd,
        "restoreToolsDirectCmdCount": restore_direct_cmd,
        "policyOk": root_cmd == 1 and restore_direct_cmd == 0,
    }


def snippet(path: Path, start: int, end: int) -> str:
    lines = read_lines(path)
    return " | ".join(f"L{i}:{lines[i - 1]}" for i in range(start, min(end, len(lines)) + 1))


def parse_dt_row(line: str) -> list[str]:
    inner = line.strip()
    if inner.endswith(","):
        inner = inner[:-1]
    if inner.startswith("{") and inner.endswith("}"):
        inner = inner[1:-1]
    return next(csv.reader([inner]))


def dtsys_matrix() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for line_no, line in enumerate(read_lines(DT_FORM), 1):
        if "UI_Dock" not in line and "UI_MainPage" not in line:
            continue
        try:
            parsed = parse_dt_row(line)
        except Exception:
            continue
        if len(parsed) < 20 or parsed[2] not in {"UI_Dock", "UI_MainPage"}:
            continue
        name = parsed[2]
        ui_group_id = parsed[3]
        disable = parsed[4]
        is_lock = parsed[5]
        is_full = parsed[13]
        show_mode = parsed[11]
        freeze_mode = parsed[14]
        rows.append(
            {
                "formName": name,
                "formId": parsed[0],
                "sourceLine": line_no,
                "desc": parsed[1],
                "uiGroupId": ui_group_id,
                "disableUILayer": disable,
                "isLock": is_lock,
                "assetPathKorean": parsed[9],
                "canMulit": parsed[10],
                "showMode": show_mode,
                "bgBlur": parsed[12],
                "isFull": is_full,
                "freezeMode": freeze_mode,
                "bgMusic": parsed[15],
                "dependentName": parsed[16],
                "dependentAudioBanks": parsed[17],
                "dependentPacks": parsed[18],
                "preloadAssets": parsed[19],
                "formulaInputStatus": "partial_static_input_only",
                "sortingFormulaImpact": "DisableUILayer=1 means UIFormBase.Open static branch may skip YouYouUIManager.SetSortingOrder; exact CurrCanvas.sortingOrder then depends on prefab/default/runtime state not fully available from DTSysUIForm alone.",
                "openOrderEvidence": "UI_Dock.OnOpen default tab MAIN_PAGE; UI_Dock.setCurrView opens UI_MainPage via GameEntry.UI:OpenUIForm; UI_MainPage.OnOpen refreshes runtime state.",
                "source": str(DT_FORM),
                "rawRow": line.strip(),
                "patchDecision": "no_patch_exact_form_sorting_not_recovered",
            }
        )
    return rows


def uilayer_matrix() -> list[dict[str, Any]]:
    return [
        {
            "evidenceTarget": "UIGroup class fields",
            "source": str(IL2CPP_DUMP),
            "sourceEvidence": "UIGroup has Id, BaseOrder, Group fields in dump.cs; BaseOrder is part of source type shape.",
            "valueRecovered": "field_shape_only",
            "neededForExactFormula": "UIGroup array instances and BaseOrder values for runtime UI manager groups",
            "availability": "not_found_in_static_serialized_manager_objects",
            "decision": "requires_runtime_dump_or_manager_serialized_group_asset",
        },
        {
            "evidenceTarget": "DTSysUIForm.UiGroupId",
            "source": str(DT_FORM),
            "sourceEvidence": "UI_Dock and UI_MainPage rows both decode UiGroupId=1.",
            "valueRecovered": "1",
            "neededForExactFormula": "selects UI group/layer dictionary branch if DisableUILayer does not bypass sorting",
            "availability": "source_backed",
            "decision": "partial_input_recovered",
        },
        {
            "evidenceTarget": "DTSysUIForm.DisableUILayer",
            "source": str(DT_FORM),
            "sourceEvidence": "UI_Dock and UI_MainPage rows both decode DisableUILayer=1.",
            "valueRecovered": "1",
            "neededForExactFormula": "UI140 shows UIFormBase.Open calls SetSortingOrder only when not DisableUILayer.",
            "availability": "source_backed",
            "decision": "sorting_cursor_path_likely_bypassed_for_these_forms_but_runtime_validation_needed",
        },
        {
            "evidenceTarget": "UILayer group cursor current value",
            "source": "UI140 capstone + local static files",
            "sourceEvidence": "UILayer.SetSortingOrder increments a group cursor by 100, but current cursor before UI_Dock/UI_MainPage open was not found.",
            "valueRecovered": "not_recovered",
            "neededForExactFormula": "if DisableUILayer is false in runtime, exact CurrCanvas.sortingOrder = group cursor after increment",
            "availability": "not_source_backed",
            "decision": "requires_runtime_dump",
        },
        {
            "evidenceTarget": "Production open order",
            "source": f"{UI_DOCK_LUA}; {UI_MAINPAGE_LUA}",
            "sourceEvidence": "UI_Dock defaults DOCK_TYPE.MAIN_PAGE and setCurrView calls GameEntry.UI:OpenUIForm(UI_MainPage); UI_MainPage.OnOpen then runs refresh/UI_MainInterface_in.",
            "valueRecovered": "UI_Dock -> UI_MainPage source path recovered",
            "neededForExactFormula": "open order determines form init/open side effects and layer closure behavior",
            "availability": "source_backed_lua_path",
            "decision": "partial_open_order_recovered_not_exact_sorting",
        },
    ]


def unitypy_objects_by_path_id(path_ids: set[int]) -> dict[int, dict[str, Any]]:
    out: dict[int, dict[str, Any]] = {}
    if not MAININTERFACE_BUNDLE.exists() or not path_ids:
        return out
    try:
        import UnityPy  # type: ignore
    except Exception as exc:
        return {pid: {"unitypy_error": f"{type(exc).__name__}: {exc}"} for pid in path_ids}
    try:
        env = UnityPy.load(str(MAININTERFACE_BUNDLE))
        for obj in env.objects:
            if obj.path_id not in path_ids:
                continue
            try:
                tree = obj.read_typetree()
            except Exception as exc:
                tree = {"read_typetree_error": f"{type(exc).__name__}: {exc}"}
            out[obj.path_id] = tree
    except Exception as exc:
        return {pid: {"unitypy_error": f"{type(exc).__name__}: {exc}"} for pid in path_ids}
    return out


def pptr_summary(value: Any) -> str:
    if isinstance(value, dict):
        file_id = value.get("m_FileID", value.get("m_FileId", value.get("file_id", "")))
        path_id = value.get("m_PathID", value.get("m_PathId", value.get("path_id", "")))
        return f"fileID={file_id};pathID={path_id}"
    return str(value)


def canvashelper_matrix() -> list[dict[str, Any]]:
    comp_rows = read_csv(COMPONENTS)
    helpers = [r for r in comp_rows if r.get("script_id") == CANVASHELPER_SCRIPT_ID or "m_Depth" in r.get("keys", "")]
    path_ids = {int(r["component_path_id"]) for r in helpers if re.fullmatch(r"-?\d+", r.get("component_path_id", ""))}
    trees = unitypy_objects_by_path_id(path_ids)
    rows: list[dict[str, Any]] = []
    for r in helpers:
        pid = int(r["component_path_id"]) if re.fullmatch(r"-?\d+", r.get("component_path_id", "")) else None
        tree = trees.get(pid, {}) if pid is not None else {}
        m_depth = tree.get("m_Depth", "")
        enabled = tree.get("m_Enabled", "")
        context = "unknown_or_non_target"
        if r.get("game_object_name") in {"UI_Dock", "UI_Dock_old", "UI_MainInterface", "UI_MainInterface_old"}:
            context = "form_root"
        elif r.get("game_object_name", "").lower() in {"bgbtn", "im_juese", "im_juese (1)"}:
            context = "nested_canvashelper_candidate"
        rows.append(
            {
                "componentPathId": r.get("component_path_id"),
                "gameObjectId": r.get("game_object_id"),
                "gameObjectName": r.get("game_object_name"),
                "bundle": r.get("bundle"),
                "scriptId": r.get("script_id"),
                "scriptType": "YouYou.YouYouCanvasHelper" if r.get("script_id") == CANVASHELPER_SCRIPT_ID else "unknown_m_Depth_component",
                "context": context,
                "mDepthRecovered": m_depth != "",
                "mDepth": m_depth,
                "mEnabled": enabled,
                "keys": r.get("keys"),
                "formulaUse": "combinedDepth = parent UIFormBase.CurrCanvas.sortingOrder + m_Depth, per UI140",
                "exactDepthStatus": "partial" if m_depth != "" else "blocked_missing_serialized_value",
                "source": str(MAININTERFACE_BUNDLE if tree else COMPONENTS),
                "decision": "cannot_compute_exact_canvashelper_depth_without_parent_form_sorting" if m_depth != "" else "blocked_no_serialized_value",
            }
        )
    return rows


def spine_matrix() -> list[dict[str, Any]]:
    bindings = read_csv(LUA_COM_BINDINGS)
    comp_rows = read_csv(COMPONENTS)
    rect_rows = read_csv(RECTS)
    probe = read_csv(UI136_PROBE)
    probe_by_prefix: dict[str, dict[str, str]] = {}
    for row in probe:
        name = row.get("name", "")
        prefix = name.split("__", 1)[0]
        if prefix:
            probe_by_prefix.setdefault(prefix, row)

    comp_by_go: dict[str, list[dict[str, str]]] = {}
    for comp in comp_rows:
        comp_by_go.setdefault(comp.get("game_object_id", ""), []).append(comp)
        comp_by_go.setdefault(comp.get("component_path_id", ""), []).append(comp)

    rect_to_go = {r.get("path_id", ""): r.get("game_object_id", "") for r in rect_rows}

    dock_bindings = [
        r for r in bindings
        if r.get("owner_game_object_name") in {"UI_Dock", "UI_Dock_old"}
        and (r.get("com_name", "").startswith("sp_") or r.get("group_name") in {"spine", "gray_spine"})
    ]
    path_ids: set[int] = set()
    for b in dock_bindings:
        mapped_go = rect_to_go.get(b.get("com_obj_path_id", ""), "")
        candidate_keys = {b.get("com_game_object_id", ""), b.get("com_obj_path_id", ""), mapped_go}
        comps_for_binding: list[dict[str, str]] = []
        for key in candidate_keys:
            comps_for_binding.extend(comp_by_go.get(key, []))
        for comp in comps_for_binding:
            if comp.get("script_id") in {SKELETON_GRAPHIC_SCRIPT_ID, UISPINECTR_SCRIPT_ID} and re.fullmatch(r"-?\d+", comp.get("component_path_id", "")):
                path_ids.add(int(comp["component_path_id"]))
    trees = unitypy_objects_by_path_id(path_ids)

    rows: list[dict[str, Any]] = []
    for b in dock_bindings:
        name = b.get("com_name", "")
        mapped_go = rect_to_go.get(b.get("com_obj_path_id", ""), "")
        candidate_keys = {b.get("com_game_object_id", ""), b.get("com_obj_path_id", ""), mapped_go}
        comps: list[dict[str, str]] = []
        for key in candidate_keys:
            comps.extend(comp_by_go.get(key, []))
        sg = [c for c in comps if c.get("script_id") == SKELETON_GRAPHIC_SCRIPT_ID or "skeletonDataAsset" in c.get("keys", "")]
        ctr = [c for c in comps if c.get("script_id") == UISPINECTR_SCRIPT_ID]
        sg_details: list[str] = []
        for c in sg:
            tree = trees.get(int(c["component_path_id"])) if re.fullmatch(r"-?\d+", c.get("component_path_id", "")) else {}
            sg_details.append(
                ";".join(
                    [
                        f"component={c.get('component_path_id')}",
                        f"skeletonDataAsset={pptr_summary(tree.get('skeletonDataAsset', ''))}",
                        f"startingAnimation={tree.get('startingAnimation', '')}",
                        f"startingLoop={tree.get('startingLoop', '')}",
                        f"material={pptr_summary(tree.get('m_Material', ''))}",
                    ]
                )
            )
        probe_row = probe_by_prefix.get(name, {})
        rows.append(
            {
                "bindingRoot": b.get("owner_game_object_name"),
                "groupName": b.get("group_name"),
                "comName": name,
                "comType": b.get("com_type"),
                "comObjPathId": b.get("com_obj_path_id"),
                "comGameObjectId": b.get("com_game_object_id"),
                "mappedGameObjectIdFromRect": mapped_go,
                "sourceHasSkeletonGraphic": bool(sg),
                "sourceHasUISpineCtr": bool(ctr),
                "skeletonGraphicComponentCount": len(sg),
                "uiSpineCtrComponentCount": len(ctr),
                "skeletonGraphicDetails": " | ".join(sg_details),
                "candidateComponentTypes": probe_row.get("componentTypes", "not_found"),
                "candidateHasRealRenderer": "SkeletonGraphic" in probe_row.get("componentTypes", "") or "UISpineCtr" in probe_row.get("componentTypes", ""),
                "luaCallsite": "UI_Dock.initTab lines 138-149: GetComponent(CS.YouYou.UISpineCtr), PlayAnimation A/B",
                "bindingStatus": "source_binding_present_candidate_missing_runtime_renderer" if sg or ctr else "recttransform_or_binding_only_no_renderer_chain",
                "decision": "no_patch_until_source_renderer_reconstruction_and_depth_stack_are_both_exact",
            }
        )
    return rows


def make_md(payload: dict[str, Any], row_counts: dict[str, int]) -> str:
    return f"""# {TASK}

Generated: {payload['generatedAt']}

## Decision
- restoredClaim: false
- scenePatchApplied: false
- candidatePatchApplied: false
- patchDecision: {payload['patchDecision']}
- exactFormSortingRecovered: false
- exactCanvasHelperDepthRecovered: false
- uiDockSpineRendererBindingRecovered: false
- uiDockPromotionAllowed: false
- requiresRuntimeDump: true

## Findings
- UI140 formula was applied to local source evidence only; no scene/candidate patch was made.
- `DTSysUIForm` rows are source-backed: `UI_Dock=248`, `UI_MainPage=249`, both `UiGroupId=1`, both `DisableUILayer=1`.
- Because UI140 shows `UIFormBase.Open` only calls `SetSortingOrder(form,true)` when the form is not `DisableUILayer`, exact form sorting is still not derivable from the group cursor alone. The source does not expose the runtime `CurrCanvas.sortingOrder` defaults or the UI manager group object state for these disabled-layer forms.
- `YouYouCanvasHelper` components with `m_Depth` exist in the source bundle and can be enumerated, but exact rendered depth still needs parent form sorting order.
- UI_Dock `sp_*` source objects include real `SkeletonGraphic`/`UISpineCtr` evidence for several bindings, while the UI136 candidate still has RectTransform-only `sp_*` placeholders. Reconstructing the renderer without the exact source binding/depth chain remains unsafe.

## Row Counts
- DTSysUIForm/formula matrix: {row_counts['dtsys']}
- UILayer/BaseOrder matrix: {row_counts['uilayer']}
- CanvasHelper matrix: {row_counts['canvashelper']}
- UI_Dock sp binding matrix: {row_counts['spine']}

## Next Blocker
Need a source-backed or runtime-dumped `UI_Dock`/`UI_MainPage` `CurrCanvas.sortingOrder`/parent form depth state for `DisableUILayer=1` forms, plus an exact UI_Dock `sp_*` SkeletonGraphic/SkeletonDataAsset/material reconstruction path. Until both are proven together, UI_Dock promotion stays blocked.
"""


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    dtsys = dtsys_matrix()
    uilayer = uilayer_matrix()
    canvashelper = canvashelper_matrix()
    spine = spine_matrix()

    write_csv(DTSYS_CSV, dtsys, [
        "formName", "formId", "sourceLine", "desc", "uiGroupId", "disableUILayer", "isLock",
        "assetPathKorean", "canMulit", "showMode", "bgBlur", "isFull", "freezeMode", "bgMusic",
        "dependentName", "dependentAudioBanks", "dependentPacks", "preloadAssets",
        "formulaInputStatus", "sortingFormulaImpact", "openOrderEvidence", "source", "rawRow", "patchDecision",
    ])
    write_csv(UILAYER_CSV, uilayer, [
        "evidenceTarget", "source", "sourceEvidence", "valueRecovered", "neededForExactFormula",
        "availability", "decision",
    ])
    write_csv(CANVASHELPER_CSV, canvashelper, [
        "componentPathId", "gameObjectId", "gameObjectName", "bundle", "scriptId", "scriptType",
        "context", "mDepthRecovered", "mDepth", "mEnabled", "keys", "formulaUse",
        "exactDepthStatus", "source", "decision",
    ])
    write_csv(SPINE_CSV, spine, [
        "bindingRoot", "groupName", "comName", "comType", "comObjPathId", "comGameObjectId",
        "mappedGameObjectIdFromRect", "sourceHasSkeletonGraphic", "sourceHasUISpineCtr", "skeletonGraphicComponentCount",
        "uiSpineCtrComponentCount", "skeletonGraphicDetails", "candidateComponentTypes",
        "candidateHasRealRenderer", "luaCallsite", "bindingStatus", "decision",
    ])

    row_counts = {
        "dtsys": len(dtsys),
        "uilayer": len(uilayer),
        "canvashelper": len(canvashelper),
        "spine": len(spine),
    }
    payload = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "task": TASK,
        "restoredClaim": False,
        "scenePatchApplied": False,
        "candidatePatchApplied": False,
        "patchDecision": "trace_only_no_patch",
        "exactFormSortingRecovered": False,
        "exactCanvasHelperDepthRecovered": False,
        "uiDockSpineRendererBindingRecovered": False,
        "uiDockPromotionAllowed": False,
        "requiresRuntimeDump": True,
        "requiredNextEvidence": [
            "runtime or source-backed CurrCanvas.sortingOrder/default parent form depth for UI_Dock and UI_MainPage when DTSysUIForm.DisableUILayer=1",
            "serialized UIGroup array/BaseOrder/group parent object state from the original UI manager, if disabled-layer forms still inherit group placement through another path",
            "exact UI_Dock sp_* SkeletonGraphic/SkeletonDataAsset/material reconstruction path tied to the same runtime form depth chain",
            "UI130-compatible account/activity/chat snapshot remains separately required for dynamic labels/icons",
        ],
        "guardrailsTouched": {
            "sceneOrCandidatePatched": False,
            "uiBgRaycastInteractableAltered": False,
            "btnDiscordReviewHideApplied": False,
            "activitySlotsHiddenOrFaked": False,
            "routeWorldZhuyeNodesHidden": False,
            "painting1005BackPromoted": False,
            "fakeHudIconTextSpineCreated": False,
            "androidOrEmulatorRuntimeExecuted": False,
            "externalToolOrPackageInstalled": False,
        },
        "evidenceSummary": {
            "uiDockForm": next((r for r in dtsys if r["formName"] == "UI_Dock"), {}),
            "uiMainPageForm": next((r for r in dtsys if r["formName"] == "UI_MainPage"), {}),
            "ui140FormulaSource": str(UI140_FINDINGS),
            "luaOpenStack": {
                "uiDockOnOpen": snippet(UI_DOCK_LUA, 44, 80),
                "uiDockSetCurrView": snippet(UI_DOCK_LUA, 250, 286),
                "uiMainPageOnOpen": snippet(UI_MAINPAGE_LUA, 223, 310),
            },
        },
        "outputs": {
            "dtsysUIFormFormulaInputMatrix": str(DTSYS_CSV),
            "uiLayerGroupCursorBaseOrderMatrix": str(UILAYER_CSV),
            "canvasHelperSerializedDepthMatrix": str(CANVASHELPER_CSV),
            "uiDockSpineBindingMatrix": str(SPINE_CSV),
        },
        "rowCounts": row_counts,
        "commandPolicy": command_policy(),
    }
    write_json(RESULT_JSON, payload)
    RESULT_MD.write_text(make_md(payload, row_counts), encoding="utf-8")


if __name__ == "__main__":
    main()
