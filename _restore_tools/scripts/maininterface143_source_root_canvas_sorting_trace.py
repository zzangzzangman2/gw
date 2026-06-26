import csv
import json
from datetime import datetime
from pathlib import Path

import UnityPy


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = ROOT / "reports" / "maininterface"
RESTORE = ROOT / "girlswar_maininterface_unity" / "Assets" / "RestoreData"
CLEAN = ROOT / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices"
MAIN_BUNDLE_REL = "download/ui/uiprefabandres/maininterface.assetbundle"
MAIN_BUNDLE = CLEAN / MAIN_BUNDLE_REL
RECTS = RESTORE / "maininterface_rects.csv"
COMPONENTS = RESTORE / "maininterface_components.csv"

PREFIX = "MAININTERFACE_143_SOURCE_ONLY_ROOT_CANVAS_SORTING_FOR_DISABLEUILAYER_FORMS_NO_PATCH"
RESULT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
RESULT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
CANVAS_CSV = REPORT_DIR / "MAININTERFACE_143_native_canvas_components_under_uidock_mainpage_roots.csv"
ROOT_COMPONENT_CSV = REPORT_DIR / "MAININTERFACE_143_root_form_serialized_component_matrix.csv"
DECISION_CSV = REPORT_DIR / "MAININTERFACE_143_depth_input_source_availability_decision_matrix.csv"

TARGET_ROOT_NAMES = {
    "UI_Dock",
    "UI_Dock_old",
    "UI_MainInterface",
    "UI_MainInterface_old",
}


def read_csv(path):
    with open(path, newline="", encoding="utf-8-sig") as f:
        return list(csv.DictReader(f))


def write_csv(path, rows, fieldnames):
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow({k: row.get(k, "") for k in fieldnames})


def safe_tree(obj):
    try:
        return obj.read_typetree()
    except Exception as exc:
        return {"__read_error": str(exc)}


def pptr_path_id(value):
    if isinstance(value, dict):
        return str(value.get("m_PathID", ""))
    return ""


def command_policy():
    root_cmd = len(list(ROOT.glob("*.cmd")))
    direct_cmd = len(list((ROOT / "_restore_tools").glob("*.cmd")))
    return {
        "rootCmdCountActual": root_cmd,
        "restoreToolsDirectCmdCountActual": direct_cmd,
        "policyOk": root_cmd == 1 and direct_cmd == 0,
    }


def build_rect_indexes(rect_rows):
    rect_by_id = {r["path_id"]: r for r in rect_rows}
    rect_by_go = {r["game_object_id"]: r for r in rect_rows}
    children_by_rect = {}
    for row in rect_rows:
        children_by_rect.setdefault(row.get("father_id", ""), []).append(row)
    return rect_by_id, rect_by_go, children_by_rect


def rect_path(rect_id, rect_by_id):
    parts = []
    seen = set()
    cur = str(rect_id)
    while cur and cur != "0" and cur not in seen and cur in rect_by_id:
        seen.add(cur)
        row = rect_by_id[cur]
        parts.append(f"{row.get('game_object_name', '')}({row.get('game_object_id', '')})")
        cur = str(row.get("father_id", ""))
    return "/".join(reversed(parts))


def is_descendant_rect(rect_id, root_rect_id, rect_by_id):
    cur = str(rect_id)
    root = str(root_rect_id)
    seen = set()
    while cur and cur != "0" and cur not in seen:
        if cur == root:
            return True
        seen.add(cur)
        row = rect_by_id.get(cur)
        if not row:
            return False
        cur = str(row.get("father_id", ""))
    return False


def main():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    rect_rows = read_csv(RECTS)
    comp_rows = read_csv(COMPONENTS)
    rect_by_id, rect_by_go, _ = build_rect_indexes(rect_rows)

    root_rows = [r for r in rect_rows if r.get("game_object_name") in TARGET_ROOT_NAMES and r.get("father_id") == "0"]
    root_by_go = {r["game_object_id"]: r for r in root_rows}
    root_rect_ids = {r["game_object_name"]: r["path_id"] for r in root_rows}

    env = UnityPy.load(str(MAIN_BUNDLE))
    game_object_names = {}
    object_type_by_path = {}
    canvas_rows = []
    all_native_canvas_rows = []

    for obj in env.objects:
        object_type_by_path[str(obj.path_id)] = obj.type.name
        if obj.type.name == "GameObject":
            tree = safe_tree(obj)
            game_object_names[str(obj.path_id)] = tree.get("m_Name", "")

    native_types = {
        "Canvas",
        "CanvasScaler",
        "GraphicRaycaster",
        "CanvasGroup",
    }

    for obj in env.objects:
        if obj.type.name not in native_types:
            continue
        tree = safe_tree(obj)
        go_id = pptr_path_id(tree.get("m_GameObject"))
        rect = rect_by_go.get(go_id, {})
        root_name = ""
        root_rect_id = ""
        for candidate_root_name, candidate_rect_id in root_rect_ids.items():
            if rect and is_descendant_rect(rect.get("path_id", ""), candidate_rect_id, rect_by_id):
                root_name = candidate_root_name
                root_rect_id = candidate_rect_id
                break
        row = {
            "componentType": obj.type.name,
            "componentPathId": str(obj.path_id),
            "gameObjectId": go_id,
            "gameObjectName": game_object_names.get(go_id, rect.get("game_object_name", "")),
            "rootName": root_name,
            "rootRectPathId": root_rect_id,
            "hierarchyPath": rect_path(rect.get("path_id", ""), rect_by_id) if rect else "",
            "mEnabled": tree.get("m_Enabled", ""),
            "mRenderMode": tree.get("m_RenderMode", ""),
            "mOverrideSorting": tree.get("m_OverrideSorting", ""),
            "mSortingOrder": tree.get("m_SortingOrder", ""),
            "mSortingLayerID": tree.get("m_SortingLayerID", ""),
            "mSortingLayer": tree.get("m_SortingLayer", ""),
            "mTargetDisplay": tree.get("m_TargetDisplay", ""),
            "mPixelPerfect": tree.get("m_PixelPerfect", ""),
            "mPlaneDistance": tree.get("m_PlaneDistance", ""),
            "keys": ";".join(sorted(tree.keys())) if isinstance(tree, dict) else "",
            "source": str(MAIN_BUNDLE),
        }
        all_native_canvas_rows.append(row)
        if root_name:
            canvas_rows.append(row)

    root_component_rows = []
    for root in root_rows:
        comps = [c for c in comp_rows if c.get("game_object_id") == root.get("game_object_id")]
        if not comps:
            root_component_rows.append({
                "rootName": root.get("game_object_name"),
                "rootGameObjectId": root.get("game_object_id"),
                "rootRectPathId": root.get("path_id"),
                "componentPathId": "",
                "componentKind": "none",
                "scriptId": "",
                "keys": "",
                "containsDepthOrCanvasFields": False,
                "interpretation": "No serialized RestoreData component row on root.",
            })
            continue
        for comp in comps:
            keys = comp.get("keys", "")
            has_depth = any(token in keys for token in [
                "Depth",
                "CurrCanvas",
                "GroupId",
                "DisableUILayer",
                "OnDepthChanged",
                "sortingOrder",
                "m_SortingOrder",
            ])
            interpretation = "root serialized component"
            if comp.get("script_id") == "8347263561838679580":
                interpretation = "LuaForm-like component; serialized keys do not expose UIFormBase CurrCanvas/Depth."
            elif comp.get("script_id") == "2349074181781781832":
                interpretation = "UI_Dock/UI page helper component; serialized keys expose LuaCom/pageId only."
            elif comp.get("script_id") == "8390977652835490180":
                interpretation = "GraphicRaycaster-like serialized component."
            root_component_rows.append({
                "rootName": root.get("game_object_name"),
                "rootGameObjectId": root.get("game_object_id"),
                "rootRectPathId": root.get("path_id"),
                "componentPathId": comp.get("component_path_id"),
                "componentKind": comp.get("kind"),
                "scriptId": comp.get("script_id"),
                "keys": keys,
                "containsDepthOrCanvasFields": has_depth,
                "interpretation": interpretation,
            })

    root_canvas_attached = [
        r for r in canvas_rows
        if r.get("hierarchyPath") and r.get("hierarchyPath").split("/")[-1].split("(")[0] in TARGET_ROOT_NAMES
        and r.get("componentType") == "Canvas"
    ]
    any_canvas_under_targets = any(r.get("componentType") == "Canvas" for r in canvas_rows)
    exact_sorting_from_root_canvas = bool(root_canvas_attached)
    root_depth_fields = [r for r in root_component_rows if str(r.get("containsDepthOrCanvasFields")) == "True"]

    decision_rows = [
        {
            "evidenceTarget": "native Canvas under UI_Dock/UI_MainInterface source roots",
            "source": str(MAIN_BUNDLE),
            "valueRecovered": "yes" if any_canvas_under_targets else "no",
            "details": f"{sum(1 for r in canvas_rows if r.get('componentType') == 'Canvas')} Canvas rows under target roots",
            "decision": "source_root_canvas_sorting_available" if exact_sorting_from_root_canvas else "not_found_on_target_roots",
        },
        {
            "evidenceTarget": "root Canvas m_SortingOrder for disabled-layer forms",
            "source": str(MAIN_BUNDLE),
            "valueRecovered": "yes" if exact_sorting_from_root_canvas else "no",
            "details": "; ".join(f"{r.get('rootName')}:{r.get('mSortingOrder')}" for r in root_canvas_attached),
            "decision": "can_use_serialized_root_canvas_if_runtime_keeps_it" if exact_sorting_from_root_canvas else "requires_runtime_or_manager_parent_depth",
        },
        {
            "evidenceTarget": "serialized UIFormBase CurrCanvas/Depth/GroupId on roots",
            "source": str(COMPONENTS),
            "valueRecovered": "yes" if root_depth_fields else "no",
            "details": f"{len(root_depth_fields)} root components expose depth/canvas/group-like keys",
            "decision": "source_backed" if root_depth_fields else "not_serialized_on_prefab_root",
        },
        {
            "evidenceTarget": "UI142 renderer dependency chain",
            "source": "MAININTERFACE_142",
            "valueRecovered": "yes",
            "details": "renderer-only dependencies closed; depth remains separate",
            "decision": "renderer_patch_future_feasible_but_not_allowed_now",
        },
    ]

    write_csv(CANVAS_CSV, canvas_rows, [
        "componentType",
        "componentPathId",
        "gameObjectId",
        "gameObjectName",
        "rootName",
        "rootRectPathId",
        "hierarchyPath",
        "mEnabled",
        "mRenderMode",
        "mOverrideSorting",
        "mSortingOrder",
        "mSortingLayerID",
        "mSortingLayer",
        "mTargetDisplay",
        "mPixelPerfect",
        "mPlaneDistance",
        "keys",
        "source",
    ])
    write_csv(ROOT_COMPONENT_CSV, root_component_rows, [
        "rootName",
        "rootGameObjectId",
        "rootRectPathId",
        "componentPathId",
        "componentKind",
        "scriptId",
        "keys",
        "containsDepthOrCanvasFields",
        "interpretation",
    ])
    write_csv(DECISION_CSV, decision_rows, [
        "evidenceTarget",
        "source",
        "valueRecovered",
        "details",
        "decision",
    ])

    requires_runtime_dump = not exact_sorting_from_root_canvas
    requires_runtime_validation = exact_sorting_from_root_canvas

    result = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "scenePatchApplied": False,
        "candidatePatchApplied": False,
        "patchDecision": "trace_only_no_patch",
        "nativeCanvasRowsUnderTargetRoots": len(canvas_rows),
        "nativeCanvasComponentsUnderTargetRoots": sum(1 for r in canvas_rows if r.get("componentType") == "Canvas"),
        "rootCanvasSortingRecovered": exact_sorting_from_root_canvas,
        "rootUIFormBaseDepthFieldsSerialized": bool(root_depth_fields),
        "sourceRootCanvasSortingValues": {
            r.get("rootName"): int(r.get("mSortingOrder", "0") or 0)
            for r in root_canvas_attached
        },
        "requiresRuntimeDumpForDepth": requires_runtime_dump,
        "requiresRuntimeValidationForDepth": requires_runtime_validation,
        "uiDockPromotionAllowed": False,
        "requiredNextEvidence": [
            "Unity candidate validation using source root Canvas sorting values: UI_MainInterface=0 and UI_Dock=100",
            "verify whether production-equivalent UIManager mount path keeps serialized root Canvas sorting for DisableUILayer=1 forms",
            "Unity compile/import validation before applying UI142 renderer components",
        ],
        "outputs": {
            "canvasCsv": str(CANVAS_CSV),
            "rootComponentCsv": str(ROOT_COMPONENT_CSV),
            "decisionCsv": str(DECISION_CSV),
        },
        "guardrailsTouched": [],
        "commandPolicy": command_policy(),
    }
    RESULT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        f"# {PREFIX}",
        "",
        "## Decision",
        f"- restoredClaim: {str(result['restoredClaim']).lower()}",
        f"- scenePatchApplied: {str(result['scenePatchApplied']).lower()}",
        f"- candidatePatchApplied: {str(result['candidatePatchApplied']).lower()}",
        f"- patchDecision: {result['patchDecision']}",
        f"- nativeCanvasRowsUnderTargetRoots: {result['nativeCanvasRowsUnderTargetRoots']}",
        f"- nativeCanvasComponentsUnderTargetRoots: {result['nativeCanvasComponentsUnderTargetRoots']}",
        f"- rootCanvasSortingRecovered: {str(result['rootCanvasSortingRecovered']).lower()}",
        f"- rootUIFormBaseDepthFieldsSerialized: {str(result['rootUIFormBaseDepthFieldsSerialized']).lower()}",
        f"- requiresRuntimeDumpForDepth: {str(result['requiresRuntimeDumpForDepth']).lower()}",
        f"- requiresRuntimeValidationForDepth: {str(result['requiresRuntimeValidationForDepth']).lower()}",
        f"- uiDockPromotionAllowed: {str(result['uiDockPromotionAllowed']).lower()}",
        "",
        "## Findings",
    ]
    if canvas_rows:
        md.append("- Native Canvas-family components were found under target source roots; inspect the CSV before promoting any depth value.")
    else:
        md.append("- No native Canvas-family components were found under the target source roots in the prefab bundle.")
    if root_depth_fields:
        md.append("- Some root serialized components expose depth/canvas/group-like keys.")
    else:
        md.append("- Root serialized components do not expose `UIFormBase.CurrCanvas`, `Depth`, or `GroupId`; prefab roots mainly expose LuaForm/page helper/GraphicRaycaster style data.")
    if exact_sorting_from_root_canvas:
        values = ", ".join(f"{k}={v}" for k, v in sorted(result["sourceRootCanvasSortingValues"].items()))
        md.append(f"- Source root Canvas sorting values were recovered: {values}.")
    md += [
        "- No scene/candidate patch was made.",
        "",
        "## Outputs",
        f"- `{CANVAS_CSV}`",
        f"- `{ROOT_COMPONENT_CSV}`",
        f"- `{DECISION_CSV}`",
        f"- `{RESULT_JSON}`",
        "",
        "## Next Blocker",
        "- Next gate is a Unity candidate compile/import/capture validation using the recovered source root Canvas sorting values and UI142 renderer dependencies. Runtime dump is only required if source-backed candidate validation contradicts the expected depth behavior.",
    ]
    RESULT_MD.write_text("\n".join(md), encoding="utf-8")


if __name__ == "__main__":
    main()
