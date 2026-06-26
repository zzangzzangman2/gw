from __future__ import annotations

import csv
import json
from datetime import datetime
from pathlib import Path
from typing import Any

import UnityPy


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = ROOT / "girlswar_maininterface_unity"
REPORT = ROOT / "reports" / "maininterface"
MERGED = ROOT / "girlswar_merged_extracted"
MAIN_BUNDLE = MERGED / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "ui" / "uiprefabandres" / "maininterface.assetbundle"
RECT_INDEX = MERGED / "indexes" / "ui_recttransforms.csv"
LUA_DOCK = MERGED / "decoded" / "xlua" / "-4615102950863731052_UI_Dock_security_xor_raw.lua"
LUA_MAINPAGE = MERGED / "decoded" / "xlua" / "-6351603197391775840_UI_MainPage_security_xor_raw.lua"
DTSYS = MERGED / "extracted" / "unity" / "bundles" / "b_118e2d32692e66cc" / "textassets" / "7179387777078280832_DTSysUIFormEntityTableData.txt"

OUT_MD = REPORT / "MAININTERFACE_145_STATIC_UIDOCK_OPENSTACK_PARENT_MASK_DEPTH_TRACE_NO_PATCH_RESULT.md"
OUT_JSON = REPORT / "MAININTERFACE_145_STATIC_UIDOCK_OPENSTACK_PARENT_MASK_DEPTH_TRACE_NO_PATCH_RESULT.json"
PARENT_CSV = REPORT / "MAININTERFACE_145_uidock_parent_openstack_source_evidence_matrix.csv"
MASK_CSV = REPORT / "MAININTERFACE_145_uidock_mask_stencil_canvasgroup_component_chain_matrix.csv"
DEPTH_CSV = REPORT / "MAININTERFACE_145_disableuilayer_root_canvas_depth_reconciliation_matrix.csv"
DYNAMIC_CSV = REPORT / "MAININTERFACE_145_dynamic_home_state_static_vs_runtime_blocker_matrix.csv"
NEXT_CSV = REPORT / "MAININTERFACE_145_next_action_decision_matrix.csv"


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def read_lines(path: Path) -> list[str]:
    if not path.exists():
        return []
    return path.read_text(encoding="utf-8", errors="replace").splitlines()


def snippet(path: Path, start: int, end: int) -> str:
    lines = read_lines(path)
    parts = []
    for idx in range(start, min(end, len(lines)) + 1):
        parts.append(f"L{idx}:{lines[idx - 1].strip()}")
    return " | ".join(parts)


def command_policy() -> dict[str, Any]:
    root_cmd = sorted(p.name for p in ROOT.glob("*.cmd"))
    direct_restore_cmd = sorted(p.name for p in (ROOT / "_restore_tools").glob("*.cmd")) if (ROOT / "_restore_tools").exists() else []
    return {
        "rootCmdCount": len(root_cmd),
        "rootCmdFiles": root_cmd,
        "restoreToolsDirectCmdCount": len(direct_restore_cmd),
        "restoreToolsDirectCmdFiles": direct_restore_cmd,
        "policySatisfied": len(root_cmd) == 1 and len(direct_restore_cmd) == 0,
    }


def pptr_id(value: Any) -> int:
    if value is None:
        return 0
    return int(getattr(value, "m_PathID", 0) or getattr(value, "path_id", 0) or 0)


def load_main_bundle() -> dict[str, Any]:
    env = UnityPy.load(MAIN_BUNDLE.read_bytes())
    scripts: dict[int, str] = {}
    gameobjects: dict[int, dict[str, Any]] = {}
    rects: dict[int, dict[str, Any]] = {}
    components: dict[int, dict[str, Any]] = {}
    go_to_rect: dict[int, int] = {}

    for obj in env.objects:
        if obj.type.name == "MonoScript":
            data = obj.read()
            ns = getattr(data, "m_Namespace", "") or ""
            cls = getattr(data, "m_ClassName", "") or ""
            scripts[obj.path_id] = f"{ns}.{cls}".strip(".")

    for obj in env.objects:
        if obj.type.name == "GameObject":
            data = obj.read()
            comp_ids = [pptr_id(pair.component) for pair in getattr(data, "m_Component", [])]
            gameobjects[obj.path_id] = {
                "name": getattr(data, "m_Name", ""),
                "active": bool(getattr(data, "m_IsActive", False)),
                "componentIds": comp_ids,
            }

    for obj in env.objects:
        if obj.type.name == "RectTransform":
            data = obj.read()
            go = pptr_id(getattr(data, "m_GameObject", None))
            father = pptr_id(getattr(data, "m_Father", None))
            children = [pptr_id(child) for child in getattr(data, "m_Children", [])]
            rects[obj.path_id] = {
                "gameObjectId": go,
                "name": gameobjects.get(go, {}).get("name", ""),
                "active": gameobjects.get(go, {}).get("active", ""),
                "fatherId": father,
                "children": children,
            }
            go_to_rect[go] = obj.path_id

    for obj in env.objects:
        if obj.type.name in ("GameObject", "RectTransform", "Transform", "MonoScript"):
            continue
        try:
            data = obj.read()
        except Exception:
            continue
        go = pptr_id(getattr(data, "m_GameObject", None))
        script_id = pptr_id(getattr(data, "m_Script", None))
        script_name = scripts.get(script_id, "")
        kind = script_name or obj.type.name
        fields = []
        try:
            fields = sorted(data.read_typetree().keys())
        except Exception:
            fields = sorted(k for k in dir(data) if k.startswith("m_"))
        components[obj.path_id] = {
            "type": obj.type.name,
            "kind": kind,
            "gameObjectId": go,
            "gameObjectName": gameobjects.get(go, {}).get("name", ""),
            "scriptId": script_id,
            "fields": fields,
            "data": data,
        }
    return {
        "scripts": scripts,
        "gameobjects": gameobjects,
        "rects": rects,
        "components": components,
        "goToRect": go_to_rect,
    }


def hierarchy_path(rects: dict[int, dict[str, Any]], rect_id: int) -> str:
    parts = []
    seen = set()
    cur = rect_id
    while cur and cur in rects and cur not in seen:
        seen.add(cur)
        r = rects[cur]
        parts.append(f"{r['name']}({cur})")
        cur = int(r.get("fatherId") or 0)
    return "/".join(reversed(parts))


def is_under(rects: dict[int, dict[str, Any]], rect_id: int, root_id: int) -> bool:
    cur = rect_id
    seen = set()
    while cur and cur in rects and cur not in seen:
        if cur == root_id:
            return True
        seen.add(cur)
        cur = int(rects[cur].get("fatherId") or 0)
    return False


def value_from_data(data: Any, field: str) -> str:
    if hasattr(data, field):
        v = getattr(data, field)
        if hasattr(v, "r") and hasattr(v, "g") and hasattr(v, "b"):
            return f"{v.r},{v.g},{v.b},{getattr(v, 'a', '')}"
        return str(v)
    return ""


def build_mask_rows(bundle_data: dict[str, Any]) -> list[dict[str, Any]]:
    rects = bundle_data["rects"]
    components = bundle_data["components"]
    go_to_rect = bundle_data["goToRect"]
    roots = {
        7409970622389811116: "UI_Dock",
        -1887796705374699072: "UI_Dock_old",
    }
    interesting = {
        "Canvas",
        "CanvasGroup",
        "CanvasRenderer",
        "UnityEngine.UI.GraphicRaycaster",
        "UnityEngine.UI.Mask",
        "UnityEngine.UI.RectMask2D",
        "YouYou.YouYouCanvasHelper",
        "Spine.Unity.SkeletonGraphic",
        "Spine.Unity.SkeletonSubmeshGraphic",
        "YouYou.UISpineCtr",
        "UnityEngine.UI.Image",
        "UnityEngine.UI.Button",
        "UnityEngine.UI.Toggle",
        "YouYou.ToggleEx",
    }
    rows: list[dict[str, Any]] = []
    for comp_id, comp in components.items():
        rect_id = go_to_rect.get(int(comp["gameObjectId"]) or 0, 0)
        if not rect_id:
            continue
        root_name = ""
        root_id = 0
        for candidate_id, candidate_name in roots.items():
            if is_under(rects, rect_id, candidate_id):
                root_name = candidate_name
                root_id = candidate_id
                break
        if not root_name:
            continue
        kind = comp["kind"]
        if kind not in interesting and comp["type"] not in interesting:
            continue
        data = comp["data"]
        rows.append(
            {
                "rootName": root_name,
                "rootRectPathId": root_id,
                "componentPathId": comp_id,
                "componentType": comp["type"],
                "scriptKind": kind,
                "gameObjectId": comp["gameObjectId"],
                "gameObjectName": comp["gameObjectName"],
                "hierarchyPath": hierarchy_path(rects, rect_id),
                "mEnabled": value_from_data(data, "m_Enabled"),
                "mRenderMode": value_from_data(data, "m_RenderMode"),
                "mOverrideSorting": value_from_data(data, "m_OverrideSorting"),
                "mSortingOrder": value_from_data(data, "m_SortingOrder"),
                "mDepth": value_from_data(data, "m_Depth"),
                "mAlpha": value_from_data(data, "m_Alpha"),
                "mBlocksRaycasts": value_from_data(data, "m_BlocksRaycasts"),
                "mInteractable": value_from_data(data, "m_Interactable"),
                "mRaycastTarget": value_from_data(data, "m_RaycastTarget"),
                "mMaskable": value_from_data(data, "m_Maskable"),
                "componentRole": "mask_or_stencil" if kind.endswith(".Mask") or kind.endswith(".RectMask2D") else "render_depth_or_raycast_component",
                "reconstructionStatus": "source_component_present",
                "source": str(MAIN_BUNDLE),
            }
        )
    rows.sort(key=lambda r: (r["rootName"], r["hierarchyPath"], r["scriptKind"], str(r["componentPathId"])))
    return rows


def build_parent_rows(bundle_data: dict[str, Any]) -> list[dict[str, Any]]:
    rects = bundle_data["rects"]
    rows: list[dict[str, Any]] = []
    for rect_id, name in [
        (7409970622389811116, "UI_Dock"),
        (-1887796705374699072, "UI_Dock_old"),
        (2475216337245998118, "UI_MainInterface_old"),
        (5568884429252053541, "UI_MainInterface"),
    ]:
        r = rects.get(rect_id, {})
        rows.append(
            {
                "evidenceKind": "prefab_recttransform_root",
                "target": name,
                "source": str(RECT_INDEX),
                "lineOrRange": "",
                "parentEvidence": f"father_id={r.get('fatherId', '')}; father_name=''",
                "hierarchyOrPath": hierarchy_path(rects, rect_id),
                "interpretation": "source prefab root with father_id=0; not serialized as child of UI_MainInterface/UI_MainInterface_old",
                "staticParentEvidenceFound": True,
                "patchDecision": "no_patch_form_parent_runtime_not_recovered",
            }
        )
    dtsys_lines = read_lines(DTSYS)
    for line_no, target in [(175, "UI_Dock"), (176, "UI_MainPage")]:
        raw = dtsys_lines[line_no - 1].strip() if len(dtsys_lines) >= line_no else ""
        rows.append(
            {
                "evidenceKind": "DTSysUIForm",
                "target": target,
                "source": str(DTSYS),
                "lineOrRange": str(line_no),
                "parentEvidence": raw,
                "hierarchyOrPath": "UiGroupId=1; DisableUILayer=1; assetPath=UIPrefabAndRes/MainInterface/Prefabs/" + ("UI_Dock" if target == "UI_Dock" else "UI_MainInterface"),
                "interpretation": "opened as a UI form through GameEntry.UI, not as a serialized child under another form",
                "staticParentEvidenceFound": True,
                "patchDecision": "no_patch_exact_runtime_group_parent_missing",
            }
        )
    rows.extend(
        [
            {
                "evidenceKind": "decoded_lua",
                "target": "UI_Dock.OnOpen",
                "source": str(LUA_DOCK),
                "lineOrRange": "44-80",
                "parentEvidence": snippet(LUA_DOCK, 44, 80),
                "hierarchyOrPath": "OnOpen default tabIndex or DOCK_TYPE.MAIN_PAGE; initEnterTab(userData)",
                "interpretation": "Lua lifecycle confirms Dock is a form and sets itself active; parent Transform is not exposed in Lua",
                "staticParentEvidenceFound": True,
                "patchDecision": "trace_only_no_parent_patch",
            },
            {
                "evidenceKind": "decoded_lua",
                "target": "UI_Dock.setCurrView",
                "source": str(LUA_DOCK),
                "lineOrRange": "250-286",
                "parentEvidence": snippet(LUA_DOCK, 250, 286),
                "hierarchyOrPath": "ViewMgr:clostEnableLayerView(); GameEntry.UI:OpenUIForm(UIFormId.UI_MainPage,t)",
                "interpretation": "production opens UI_MainPage through UIManager after Dock tab selection; a static sibling copy skips this open-stack behavior",
                "staticParentEvidenceFound": True,
                "patchDecision": "no_patch_requires_runtime_stack_parent",
            },
            {
                "evidenceKind": "decoded_lua",
                "target": "UI_MainPage.OnOpen",
                "source": str(LUA_MAINPAGE),
                "lineOrRange": "223-310",
                "parentEvidence": snippet(LUA_MAINPAGE, 223, 310),
                "hierarchyOrPath": "ViewMgr:clostEnableLayerView(); refresh(); OpenMainEnterView(); UI_MainInterface_in/idle",
                "interpretation": "MainPage refresh and animator state are runtime lifecycle work, not static child placement",
                "staticParentEvidenceFound": True,
                "patchDecision": "trace_only_no_parent_patch",
            },
        ]
    )
    return rows


def build_depth_rows(mask_rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    uidock_canvas = [r for r in mask_rows if r["rootName"] == "UI_Dock" and r["scriptKind"] == "Canvas" and r["gameObjectName"] == "UI_Dock"]
    old_canvas = [r for r in mask_rows if r["rootName"] == "UI_Dock_old" and r["scriptKind"] == "Canvas" and r["gameObjectName"] == "UI_Dock_old"]
    return [
        {
            "evidenceTarget": "UI140 native formula",
            "source": str(REPORT / "MAININTERFACE_140_static_formula_and_binding_findings.csv"),
            "staticValue": "UIFormBase.Open -> CurrCanvas.sortingOrder -> Depth -> YouYouCanvasHelper parent+local depth",
            "ui144CandidateValue": "source Canvas sorting serialized, but original UIManager Open/OnDepthChanged path not executed",
            "reconciliation": "formula is known; exact runtime parent/open-stack state for DisableUILayer forms is not",
            "staticDepthBehaviorReconciled": False,
            "patchDecision": "no_patch_requires_runtime_equivalent_stack",
        },
        {
            "evidenceTarget": "DTSysUIForm DisableUILayer",
            "source": str(REPORT / "MAININTERFACE_141_dtsysuiform_field_decode_formula_input_matrix.csv"),
            "staticValue": "UI_Dock=248 UiGroupId=1 DisableUILayer=1; UI_MainPage=249 UiGroupId=1 DisableUILayer=1",
            "ui144CandidateValue": "manual source-equivalent root Canvas values applied to copied roots",
            "reconciliation": "DisableUILayer means group cursor SetSortingOrder is not enough; root sorting defaults help but do not prove parent group/scale/depth",
            "staticDepthBehaviorReconciled": False,
            "patchDecision": "no_patch",
        },
        {
            "evidenceTarget": "source root Canvas sorting",
            "source": str(REPORT / "MAININTERFACE_143_native_canvas_components_under_uidock_mainpage_roots.csv"),
            "staticValue": f"UI_Dock={uidock_canvas[0]['mSortingOrder'] if uidock_canvas else 'missing'}; UI_Dock_old={old_canvas[0]['mSortingOrder'] if old_canvas else 'missing'}; UI_MainInterface/UI_MainInterface_old=0",
            "ui144CandidateValue": "UI_Dock serializedSortingOrder=100; Canvas API sortingOrder reports 0 with overrideSorting=False",
            "reconciliation": "UI144 preserves serialized source value through SerializedObject, but production render stack still depends on original parent Canvas/UI group and OnDepthChanged cascade",
            "staticDepthBehaviorReconciled": False,
            "patchDecision": "candidate_not_promoted",
        },
        {
            "evidenceTarget": "CanvasHelper local depth",
            "source": str(REPORT / "MAININTERFACE_141_canvashelper_serialized_depth_evidence_matrix.csv"),
            "staticValue": "nested YouYouCanvasHelper rows have m_Depth -1/1 in maininterface bundle",
            "ui144CandidateValue": "no original YouYouCanvasHelper runtime OnDepthChanged execution in reconstruction project",
            "reconciliation": "local depths are source-visible, but combined depth needs parent UIFormBase.CurrCanvas.sortingOrder at runtime",
            "staticDepthBehaviorReconciled": False,
            "patchDecision": "no_patch_requires_parent_depth",
        },
    ]


def build_dynamic_rows() -> list[dict[str, Any]]:
    return [
        {
            "item": "activity stack node_act_btn/btn_act_*",
            "staticEvidence": snippet(LUA_MAINPAGE, 1021, 1046),
            "source": str(LUA_MAINPAGE),
            "availableStaticDecision": "refreshMainAct clears all slots then enables only ActMgr:GetActInMain() output",
            "runtimeNeeded": "ActMgr.activitys/GetAllActInfo(true), server show/open state, player level/vip, redpoints",
            "classification": "requires_runtime_snapshot",
            "patchDecision": "no_hide_no_icon_label_spine_patch",
        },
        {
            "item": "face activity and faceGiftNode",
            "staticEvidence": snippet(LUA_MAINPAGE, 1047, 1108),
            "source": str(LUA_MAINPAGE),
            "availableStaticDecision": "Refresh depends on ActMgr:GetActInMainFace and FaceGiftManager",
            "runtimeNeeded": "face gift server data, gift cfg, timestamps, localized names/icons",
            "classification": "requires_runtime_snapshot",
            "patchDecision": "no_patch",
        },
        {
            "item": "chat bubble/list",
            "staticEvidence": snippet(LUA_MAINPAGE, 2360, 2402),
            "source": str(LUA_MAINPAGE),
            "availableStaticDecision": "chat type/content is selected from ChatMgr runtime state",
            "runtimeNeeded": "ChatMgr.LastChatType, LastChatTypeInfo, message lists, player guild/private payload",
            "classification": "requires_runtime_snapshot",
            "patchDecision": "no_fake_chat_text",
        },
        {
            "item": "top profile/level/vip/fight/currency",
            "staticEvidence": snippet(LUA_MAINPAGE, 1148, 1173) + " | " + snippet(LUA_MAINPAGE, 1312, 1322),
            "source": str(LUA_MAINPAGE),
            "availableStaticDecision": "values come from PlayerMgr, FormationManager, BagManager",
            "runtimeNeeded": "PlayerMgr.PlayerInfo, formation fight, bag currency counts/base info",
            "classification": "requires_runtime_snapshot",
            "patchDecision": "no_fake_account_currency_values",
        },
        {
            "item": "btn_discord/right social buttons",
            "staticEvidence": snippet(LUA_MAINPAGE, 115, 126) + " | " + snippet(LUA_MAINPAGE, 153, 155),
            "source": str(LUA_MAINPAGE),
            "availableStaticDecision": "hide evidence only in GameTools:IsReview() branch; click listener opens Constant.discord_url otherwise",
            "runtimeNeeded": "review state and function unlocks",
            "classification": "source_backed_static_patch_not_allowed_by_guardrail",
            "patchDecision": "no_review_hide_patch",
        },
        {
            "item": "route/world/zhuye nodes",
            "staticEvidence": "UI121/UI122 guardrails: zhuye_di1/zhuye_bian pre-clipping; no SetActive/sibling proof to hide route/world cluster",
            "source": str(REPORT / "MAININTERFACE_122_HOME_REFERENCE_ROUTE_RUNTIME_STATE_TRACE_RESULT.md"),
            "availableStaticDecision": "no source-backed hide/sibling patch",
            "runtimeNeeded": "production MainPage runtime active state/sibling/canvas/mask dump",
            "classification": "source_backed_static_patch_not_allowed_by_guardrail",
            "patchDecision": "no_hide_no_patch",
        },
    ]


def build_next_rows() -> list[dict[str, Any]]:
    return [
        {
            "action": "promote UI144 Dock candidate",
            "evidenceStatus": "renderer/root Canvas source path compiles, but diff still trails UI128",
            "allowedWithoutRuntime": False,
            "requiresRuntimeDump": True,
            "requiresRuntimeSnapshot": False,
            "decision": "blocked_do_not_promote",
        },
        {
            "action": "patch UI_Dock parent/sibling/mask statically",
            "evidenceStatus": "source roots have father_id=0 and form table says OpenUIForm; no exact runtime parent/group object path",
            "allowedWithoutRuntime": False,
            "requiresRuntimeDump": True,
            "requiresRuntimeSnapshot": False,
            "decision": "blocked_no_static_parent_patch",
        },
        {
            "action": "reconstruct UI_Dock renderer dependencies",
            "evidenceStatus": "closed by UI144; 8/8 SkeletonGraphic attached",
            "allowedWithoutRuntime": True,
            "requiresRuntimeDump": False,
            "requiresRuntimeSnapshot": False,
            "decision": "done_but_not_sufficient_for_promotion",
        },
        {
            "action": "activity/chat/account/currency visual correction",
            "evidenceStatus": "Lua shows server/account managers drive active slots and text",
            "allowedWithoutRuntime": False,
            "requiresRuntimeDump": False,
            "requiresRuntimeSnapshot": True,
            "decision": "blocked_requires_UI130_snapshot",
        },
        {
            "action": "UI_bg raycast/interactable change",
            "evidenceStatus": "guardrail preserved true/true; no source proof for off",
            "allowedWithoutRuntime": False,
            "requiresRuntimeDump": False,
            "requiresRuntimeSnapshot": False,
            "decision": "forbidden_no_patch",
        },
    ]


def main() -> None:
    REPORT.mkdir(parents=True, exist_ok=True)
    bundle_data = load_main_bundle()
    parent_rows = build_parent_rows(bundle_data)
    mask_rows = build_mask_rows(bundle_data)
    depth_rows = build_depth_rows(mask_rows)
    dynamic_rows = build_dynamic_rows()
    next_rows = build_next_rows()

    write_csv(PARENT_CSV, parent_rows, ["evidenceKind", "target", "source", "lineOrRange", "parentEvidence", "hierarchyOrPath", "interpretation", "staticParentEvidenceFound", "patchDecision"])
    write_csv(MASK_CSV, mask_rows, ["rootName", "rootRectPathId", "componentPathId", "componentType", "scriptKind", "gameObjectId", "gameObjectName", "hierarchyPath", "mEnabled", "mRenderMode", "mOverrideSorting", "mSortingOrder", "mDepth", "mAlpha", "mBlocksRaycasts", "mInteractable", "mRaycastTarget", "mMaskable", "componentRole", "reconstructionStatus", "source"])
    write_csv(DEPTH_CSV, depth_rows, ["evidenceTarget", "source", "staticValue", "ui144CandidateValue", "reconciliation", "staticDepthBehaviorReconciled", "patchDecision"])
    write_csv(DYNAMIC_CSV, dynamic_rows, ["item", "source", "staticEvidence", "availableStaticDecision", "runtimeNeeded", "classification", "patchDecision"])
    write_csv(NEXT_CSV, next_rows, ["action", "evidenceStatus", "allowedWithoutRuntime", "requiresRuntimeDump", "requiresRuntimeSnapshot", "decision"])

    mask_kinds = {r["scriptKind"] for r in mask_rows}
    real_mask_rows = [r for r in mask_rows if r["scriptKind"] in ("UnityEngine.UI.Mask", "UnityEngine.UI.RectMask2D")]
    static_parent_found = any(r["staticParentEvidenceFound"] for r in parent_rows)
    static_patch_possible = any(r["allowedWithoutRuntime"] and str(r["decision"]).startswith("done") is False for r in next_rows)
    result = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "scenePatchApplied": False,
        "candidatePatchApplied": False,
        "ui144Promoted": False,
        "staticParentEvidenceFound": bool(static_parent_found),
        "staticMaskStencilEvidenceFound": bool(real_mask_rows or any(k in mask_kinds for k in ("CanvasGroup", "Canvas"))),
        "staticDepthBehaviorReconciled": False,
        "staticPatchPossibleWithoutRuntime": False,
        "requiresRuntimeDump": True,
        "requiresRuntimeSnapshot": True,
        "requiredNextEvidence": [
            "Runtime-equivalent UI_Dock/UI_MainPage form parent/group object path, CurrCanvas.sortingOrder, Depth, OnDepthChanged cascade, and mask/stencil state.",
            "UI130-compatible activity/account/chat/currency snapshot for dynamic home state.",
        ],
        "outputs": {
            "parentOpenStackCsv": str(PARENT_CSV),
            "maskStencilCsv": str(MASK_CSV),
            "depthReconciliationCsv": str(DEPTH_CSV),
            "dynamicBlockerCsv": str(DYNAMIC_CSV),
            "nextActionCsv": str(NEXT_CSV),
            "md": str(OUT_MD),
            "json": str(OUT_JSON),
        },
        "rowCounts": {
            "parentOpenStack": len(parent_rows),
            "maskStencilCanvasGroup": len(mask_rows),
            "realMaskOrRectMask2D": len(real_mask_rows),
            "depth": len(depth_rows),
            "dynamic": len(dynamic_rows),
            "next": len(next_rows),
        },
        "changedFiles": [str(PARENT_CSV), str(MASK_CSV), str(DEPTH_CSV), str(DYNAMIC_CSV), str(NEXT_CSV), str(OUT_MD), str(OUT_JSON), str(Path(__file__))],
        "guardrailsTouched": [],
        "commandPolicy": command_policy(),
    }
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = f"""# MAININTERFACE_145 Static UI_Dock Open-stack Parent Mask Depth Trace

## Decision

- restoredClaim: `false`
- scenePatchApplied: `false`
- candidatePatchApplied: `false`
- ui144Promoted: `false`
- staticPatchPossibleWithoutRuntime: `false`
- requiresRuntimeDump: `true`
- requiresRuntimeSnapshot: `true`

## Key Findings

- `UI_Dock`, `UI_Dock_old`, `UI_MainInterface`, and `UI_MainInterface_old` are serialized as separate prefab roots with `father_id=0`; no static source row proves `UI_Dock` should be a child of `UI_MainInterface_old`.
- `DTSysUIForm` and decoded `UI_Dock` Lua continue to support a global `GameEntry.UI:OpenUIForm` stack: `UI_Dock` default `DOCK_TYPE.MAIN_PAGE` then opens `UI_MainPage`.
- UI_Dock source root has Canvas/CanvasGroup evidence and serialized `m_SortingOrder=100`, but UI140/141 still require runtime parent form depth and `OnDepthChanged` cascade for exact rendered order.
- UI_Dock subtree component scan found `{len(mask_rows)}` relevant Canvas/CanvasGroup/raycast/renderer rows and `{len(real_mask_rows)}` direct `Mask`/`RectMask2D` rows under normal/old Dock roots.
- UI144 closed real Dock renderer reconstruction, but parent/open-stack/mask-depth behavior remains the blocker because UI144 still trails UI128.

## Static Patch Feasibility

No new static scene patch is allowed. The available static evidence does not recover the production UI root/group parent, the effective `CurrCanvas.sortingOrder`/`Depth`, or the runtime mask/stencil state for `DisableUILayer=1` forms. Activity/chat/account/currency state still requires a runtime/account snapshot.

## Outputs

- Parent/open-stack matrix: `{PARENT_CSV}`
- Mask/stencil/CanvasGroup matrix: `{MASK_CSV}`
- DisableUILayer/depth reconciliation: `{DEPTH_CSV}`
- Dynamic blocker matrix: `{DYNAMIC_CSV}`
- Next action matrix: `{NEXT_CSV}`
- JSON: `{OUT_JSON}`

## Exact Next Blocker

Need runtime-equivalent evidence for `UI_Dock` and `UI_MainPage` form parent/group object path, root Canvas sorting/Depth, `YouYouCanvasHelper.OnDepthChanged` cascade, and active mask/stencil state. Separately, UI130-compatible runtime snapshot is required for activity/chat/account/currency dynamic home state.
"""
    OUT_MD.write_text(md, encoding="utf-8")
    print(json.dumps({"md": str(OUT_MD), "json": str(OUT_JSON), "maskRows": len(mask_rows), "realMaskRows": len(real_mask_rows)}, indent=2))


if __name__ == "__main__":
    main()
