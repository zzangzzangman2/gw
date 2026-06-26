from __future__ import annotations

import csv
import json
from datetime import datetime
from pathlib import Path
from typing import Any


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT = ROOT / "reports" / "maininterface"

OUT_MD = REPORT / "MAININTERFACE_146_RUNTIME_SNAPSHOT_PROBE_SPEC_AND_SOURCE_HOOK_POINTS_NO_EXECUTION_NO_PATCH_RESULT.md"
OUT_JSON = REPORT / "MAININTERFACE_146_RUNTIME_SNAPSHOT_PROBE_SPEC_AND_SOURCE_HOOK_POINTS_NO_EXECUTION_NO_PATCH_RESULT.json"
FIELD_CSV = REPORT / "MAININTERFACE_146_runtime_snapshot_required_field_matrix.csv"
HOOK_CSV = REPORT / "MAININTERFACE_146_source_hook_point_observable_field_matrix.csv"
APPROVAL_CSV = REPORT / "MAININTERFACE_146_approval_level_capture_path_decision_matrix.csv"
TEMPLATE_JSON = REPORT / "MAININTERFACE_146_runtime_snapshot_template.json"
PATCH_DECISION_CSV = REPORT / "MAININTERFACE_146_static_known_vs_runtime_missing_patch_decision_matrix.csv"


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


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


def field(section: str, path: str, required_for: str, source_known: bool, static_value: Any, runtime_required: bool, approval: str, forbidden: bool, notes: str) -> dict[str, Any]:
    return {
        "section": section,
        "fieldPath": path,
        "requiredFor": required_for,
        "sourceKnown": source_known,
        "currentStaticValue": "" if static_value is None else static_value,
        "runtimeRequired": runtime_required,
        "approvalLevel": approval,
        "forbiddenToGuess": forbidden,
        "notes": notes,
    }


FORM_FIELDS = [
    ("formName", False, "UI_Dock/UI_MainPage", "identify form"),
    ("formId", False, "248/249", "identify form"),
    ("sourcePrefabPath", False, "UIPrefabAndRes/MainInterface/Prefabs/UI_Dock or UI_MainInterface", "asset selection"),
    ("disableUILayer", False, "true from DTSysUIForm", "depth branch"),
    ("activeSelf", True, None, "final active state"),
    ("activeInHierarchy", True, None, "final active state"),
    ("parentTransformFullPath", True, None, "production parent/group path"),
    ("siblingIndex", True, None, "production sibling/order"),
    ("localPosition", True, None, "runtime transform verification"),
    ("anchoredPosition", True, None, "runtime transform verification"),
    ("sizeDelta", True, None, "runtime transform verification"),
    ("localScale", True, None, "runtime transform verification"),
    ("uiGroup.groupId", True, "1 static only", "effective UI group"),
    ("uiGroup.groupObjectPath", True, None, "effective UI group"),
    ("uiGroup.layerObjectPath", True, None, "effective UI layer"),
    ("uiGroup.baseOrder", True, None, "effective UI layer"),
    ("uiGroup.sortingCursorBeforeOpen", True, None, "depth formula"),
    ("uiGroup.sortingCursorAfterOpen", True, None, "depth formula"),
    ("rootCanvas.sortingLayerID", True, None, "render order"),
    ("rootCanvas.sortingOrder", True, "UI_Dock source=100; UI_MainInterface source=0", "render order"),
    ("rootCanvas.overrideSorting", True, "false source", "render order"),
    ("rootCanvas.renderMode", True, "ScreenSpaceCamera source", "render order"),
    ("rootCanvas.worldCameraFullPath", True, None, "render order"),
    ("rootCanvas.planeDistance", True, "100 source", "render order"),
    ("rootCanvas.targetDisplay", True, None, "render order"),
    ("uiFormBase.depth", True, None, "UI140 formula"),
    ("uiFormBase.groupId", True, None, "UI140 formula"),
    ("uiFormBase.currCanvasSortingOrder", True, None, "UI140 formula"),
    ("canvasGroup.alpha", True, "1 source", "raycast/visibility"),
    ("canvasGroup.interactable", True, "true source", "raycast/visibility"),
    ("canvasGroup.blocksRaycasts", True, "true source", "raycast/visibility"),
]


GUARDED_NODES = [
    "zhuye_di1",
    "zhuye_bian",
    "right/node_middle",
    "right/node_middle/wanfaWorldNode",
    "right/node_middle/wanfaWorldNode/worldwanfaBtn",
    "right/node_act_btn",
    "right/node_act_btn/btn_act_1",
    "right/node_act_btn/btn_act_2",
    "right/node_act_btn/btn_act_3",
    "right/node_act_btn/btn_act_4",
    "right/node_act_btn/btn_act_5",
    "right/node_act_btn/btn_act_6",
    "right/node_act_btn/btn_act_7",
    "right/node_act_btn/btn_act_8",
    "btn_discord",
    "llvChat",
    "top/profile",
    "top/currency_gold",
    "top/currency_holy",
    "UI_bg",
]


def build_field_rows() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for form_name in ("UI_Dock", "UI_MainPage"):
        for key, runtime_required, static_value, required_for in FORM_FIELDS:
            known = not runtime_required
            value = static_value
            if key == "formName":
                value = form_name
            if key == "formId":
                value = "248" if form_name == "UI_Dock" else "249"
            rows.append(
                field(
                    "formRuntime",
                    f"forms.{form_name}.{key}",
                    required_for,
                    known or static_value is not None,
                    value,
                    runtime_required,
                    "approved_original_runtime_dump_required" if runtime_required else "no_execution_static_schema_only",
                    runtime_required,
                    "Required for exact form parent/depth decision." if runtime_required else "Source-known static identity field.",
                )
            )
    for form_name in ("UI_Dock", "UI_MainPage"):
        for idx in range(1, 5):
            rows.append(field("canvasHelper", f"forms.{form_name}.canvasHelpers[{idx}].hierarchyPath", "depth cascade", False, None, True, "approved_original_runtime_dump_required", True, "Enumerate all helpers at runtime; template keeps placeholders only."))
            rows.append(field("canvasHelper", f"forms.{form_name}.canvasHelpers[{idx}].m_Depth", "depth cascade", False, None, True, "approved_original_runtime_dump_required", True, "Local helper depth after OnDepthChanged."))
            rows.append(field("canvasHelper", f"forms.{form_name}.canvasHelpers[{idx}].effectiveCanvasSortingOrder", "depth cascade", False, None, True, "approved_original_runtime_dump_required", True, "Combined parent depth plus local depth."))
    for node in GUARDED_NODES:
        rows.extend(
            [
                field("guardedNodeState", f"guardedNodes.{node}.fullPath", "guardrail active-state decision", False, None, True, "approved_original_runtime_dump_required", True, "Needed before hiding/reparenting any guarded node."),
                field("guardedNodeState", f"guardedNodes.{node}.activeSelf", "guardrail active-state decision", False, None, True, "approved_original_runtime_dump_required", True, "Forbidden to guess."),
                field("guardedNodeState", f"guardedNodes.{node}.activeInHierarchy", "guardrail active-state decision", False, None, True, "approved_original_runtime_dump_required", True, "Forbidden to guess."),
                field("guardedNodeState", f"guardedNodes.{node}.siblingIndex", "order decision", False, None, True, "approved_original_runtime_dump_required", True, "Forbidden to guess."),
            ]
        )
    for key in ("image.raycastTarget", "button.interactable", "button.enabled", "topGraphicPath"):
        rows.append(field("uiBg", f"uiBg.{key}", "UI_bg guardrail", False, None, True, "approved_original_runtime_dump_required", True, "Must preserve or source-back any change."))
    activity_fields = [
        "activitys",
        "faceActivitys",
        "playerInfo.level",
        "playerInfo.vip",
        "playerInfo.playerId",
        "playerInfo.name",
        "playerInfo.head",
        "playerInfo.headFrame",
        "playerInfo.guildId",
        "redPointState.serverRedPointIds",
        "redPointState.actSpecificRedPoints",
        "reviewState.GameTools_IsReview",
        "reviewState.GameEntry_IsReview",
        "reviewState.GameEntry_IsCommittee",
        "guideState.ModulesInit_GuideMgr_isGuide",
        "guideState.CurrGuidEnterActId",
        "timeState.serverTimeStep",
        "timeState.serverMillTimeStamp",
        "clientCallbackOutputs.showInMainFunc",
        "clientCallbackOutputs.clientCheckIsOpen",
        "clientCallbackOutputs.getActNewName",
        "clientCallbackOutputs.mainPageTouchJumpId",
        "localization.keys",
        "resources.activitySpine",
        "resources.tmpFontMaterial",
        "chatState.lastChatType",
        "chatState.visibleMessages",
        "currencyState.gold",
        "currencyState.holyCrystal",
        "formationState.mainFightValue",
    ]
    for key in activity_fields:
        rows.append(field("dynamicRuntime", f"dynamicRuntime.{key}", "UI130 replay/activity account chat currency", False, None, True, "approved_original_runtime_dump_required or approved_manual_screenshot_plus_json_snapshot", True, "UI130 refuses fake defaults."))
    for key in ("maskComponents", "rectMask2DComponents", "stencilMaterialStates", "canvasRendererMaterialCount", "skeletonGraphicCanvasRendererDepth"):
        rows.append(field("maskStencilRuntime", f"runtimeMaskStencil.{key}", "mask/stencil decision", False, None, True, "approved_original_runtime_dump_required", True, "UI145 found no direct source Mask/RectMask2D under Dock; runtime still must prove active state if present."))
    return rows


def build_hook_rows() -> list[dict[str, Any]]:
    return [
        {"hookPoint": "GameEntry.UI:OpenUIForm", "classOrFile": "decoded Lua callsites / YouYouUIManager.OpenUIForm", "method": "OpenUIForm", "observableFields": "formId,userData,opened form instance,parent group path,open order", "sourceEvidence": "UI_Dock.setCurrView lines 250-286; UI140 YouYouUIManager OpenUIForm symbol", "approvalLevel": "approved_original_runtime_dump_required", "notes": "Do not execute now; future approved dump only."},
        {"hookPoint": "UIFormBase.Open", "classOrFile": "YouYou.UIFormBase native", "method": "Open", "observableFields": "CurrCanvas.sortingOrder,Depth,GroupId,DisableUILayer,parent transform", "sourceEvidence": "UI140 disassembly: Open stores CurrCanvas.sortingOrder into Depth and invokes OnDepthChanged", "approvalLevel": "approved_original_runtime_dump_required", "notes": "Primary depth capture point."},
        {"hookPoint": "YouYouCanvasHelper.SetDepth", "classOrFile": "YouYou.YouYouCanvasHelper", "method": "SetDepth", "observableFields": "m_Depth input,effective depth before ResetRenderDepth", "sourceEvidence": "UI140: SetDepth writes m_Depth offset 0x18 then ResetRenderDepth", "approvalLevel": "approved_original_runtime_dump_required", "notes": "Capture helper-local depth cascade."},
        {"hookPoint": "YouYouCanvasHelper.ResetRenderDepth", "classOrFile": "YouYou.YouYouCanvasHelper", "method": "ResetRenderDepth", "observableFields": "parent form sorting,child Canvas sortingOrder,SkeletonGraphic renderer order", "sourceEvidence": "UI140 ResetRenderDepth formula", "approvalLevel": "approved_original_runtime_dump_required", "notes": "Needed to reconcile UI144 source Canvas=100 with actual render stack."},
        {"hookPoint": "UI_Dock.OnOpen", "classOrFile": "decoded xlua UI_Dock", "method": "OnOpen", "observableFields": "tabIndex,userData,transform active,initEnterTab,CheckBagTip,RefreshRedPoint", "sourceEvidence": "UI145 parent/open-stack matrix lines 44-80", "approvalLevel": "approved_original_runtime_dump_required", "notes": "Lua-level state capture if approved."},
        {"hookPoint": "UI_Dock.initTab", "classOrFile": "decoded xlua UI_Dock", "method": "initTab", "observableFields": "toggle on/off,UISpineCtr component,animation A/B", "sourceEvidence": "UI136/UI144 source-backed toggle and renderer evidence", "approvalLevel": "approved_original_runtime_dump_required", "notes": "Renderer path already reconstructed; runtime active/animation confirms final state."},
        {"hookPoint": "UI_MainPage.OnOpen", "classOrFile": "decoded xlua UI_MainPage", "method": "OnOpen", "observableFields": "refresh(),OpenMainEnterView(),UI_MainInterface_in/idle,chat/account/activity state", "sourceEvidence": "UI145 matrix lines 223-310", "approvalLevel": "approved_original_runtime_dump_required", "notes": "Main dynamic state entry point."},
        {"hookPoint": "UI130 replay import", "classOrFile": "_restore_tools/scripts/maininterface130_runtime_activity_snapshot_replay.py", "method": "offline replay", "observableFields": "activity slots,face slots,labels,redpoints once JSON snapshot exists", "sourceEvidence": "UI130 pipeline result", "approvalLevel": "approved_unity_replay_import_only", "notes": "Allowed only after real snapshot JSON is provided; no live runtime execution."},
        {"hookPoint": "UI144 candidate importer", "classOrFile": "MainInterface144UIDockRendererRootCanvasCandidate.cs", "method": "future JSON import hook", "observableFields": "root Canvas sorting,parent path/depth if snapshot supplied", "sourceEvidence": "UI144 candidate validation output", "approvalLevel": "approved_unity_replay_import_only", "notes": "Future patch plan only; current task writes no Unity code."},
    ]


def build_approval_rows() -> list[dict[str, Any]]:
    return [
        {"capturePath": "no_execution_static_schema_only", "allowedNow": True, "runtimeExecution": False, "requiresApproval": False, "input": "local reports/source evidence", "output": "schema/template/CSV only", "decision": "this_task_only"},
        {"capturePath": "approved_original_runtime_dump_required", "allowedNow": False, "runtimeExecution": True, "requiresApproval": True, "input": "explicit user approval plus safe original runtime target", "output": "filled form/depth/mask/dynamic JSON snapshot", "decision": "blocked_until_approval"},
        {"capturePath": "approved_manual_screenshot_plus_json_snapshot", "allowedNow": False, "runtimeExecution": "external/manual", "requiresApproval": True, "input": "user-provided manual runtime values/screenshots", "output": "filled template checked by replay scripts", "decision": "acceptable_if_user_supplies_real_values"},
        {"capturePath": "approved_unity_replay_import_only", "allowedNow": False, "runtimeExecution": False, "requiresApproval": True, "input": "real filled snapshot JSON", "output": "candidate replay/import and validation", "decision": "blocked_until_snapshot_exists"},
    ]


def build_patch_decision_rows(field_rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    categories = [
        ("form identity/path", "forms.*.formName/formId/sourcePrefabPath", True, False, "static-known identity only; no patch by itself"),
        ("root Canvas source sorting", "forms.*.rootCanvas.sortingOrder", True, True, "source known but runtime effective behavior still missing"),
        ("form parent/group/depth", "forms.*.parentTransformFullPath/uiGroup/uiFormBase", False, True, "required for UI_Dock promotion"),
        ("CanvasHelper cascade", "forms.*.canvasHelpers", False, True, "required to reconcile child Canvas/SkeletonGraphic render order"),
        ("guarded nodes active/order", "guardedNodes.*", False, True, "forbidden to guess; no hide/reorder patch"),
        ("UI_bg raycast/interactable", "uiBg.*", False, True, "preserve unless real runtime says otherwise"),
        ("activity/chat/account/currency", "dynamicRuntime.*", False, True, "UI130 snapshot required"),
        ("mask/stencil runtime", "runtimeMaskStencil.*", False, True, "UI145 direct source Mask/RectMask2D=0 but runtime active state still needed"),
    ]
    return [
        {
            "decisionArea": area,
            "fieldPattern": pattern,
            "staticKnown": static_known,
            "runtimeMissing": runtime_missing,
            "staticPatchPossibleWithoutRuntime": False,
            "forbiddenToGuess": runtime_missing,
            "patchDecision": "no_patch" if runtime_missing else "static_identity_only",
            "notes": notes,
        }
        for area, pattern, static_known, runtime_missing, notes in categories
    ]


def build_template() -> dict[str, Any]:
    def form_template(name: str, form_id: int, prefab: str, source_sorting: int) -> dict[str, Any]:
        return {
            "formName": name,
            "formId": form_id,
            "sourcePrefabPath": prefab,
            "disableUILayer": True,
            "activeSelf": None,
            "activeInHierarchy": None,
            "parentTransformFullPath": None,
            "siblingIndex": None,
            "localPosition": None,
            "anchoredPosition": None,
            "sizeDelta": None,
            "localScale": None,
            "uiGroup": {
                "groupId": None,
                "groupObjectPath": None,
                "layerObjectPath": None,
                "baseOrder": None,
                "sortingCursorBeforeOpen": None,
                "sortingCursorAfterOpen": None,
            },
            "rootCanvas": {
                "sortingLayerID": None,
                "sortingOrder": None,
                "sourceSerializedSortingOrder": source_sorting,
                "overrideSorting": None,
                "renderMode": None,
                "worldCameraFullPath": None,
                "planeDistance": None,
                "targetDisplay": None,
            },
            "uiFormBase": {
                "depth": None,
                "groupId": None,
                "disableUILayer": None,
                "currCanvasSortingOrder": None,
            },
            "canvasGroup": {
                "alpha": None,
                "interactable": None,
                "blocksRaycasts": None,
            },
            "canvasHelpers": [],
            "runtimeMaskStencil": {
                "maskComponents": [],
                "rectMask2DComponents": [],
                "stencilMaterialStates": [],
                "canvasRendererMaterialCount": None,
                "skeletonGraphicCanvasRendererDepth": None,
            },
        }
    guarded = {
        node: {
            "fullPath": None,
            "activeSelf": None,
            "activeInHierarchy": None,
            "siblingIndex": None,
            "canvasSortingOrder": None,
        }
        for node in GUARDED_NODES
    }
    return {
        "schemaVersion": "MAININTERFACE_146_runtime_snapshot_template_v1",
        "snapshotSource": {
            "captureMechanism": None,
            "capturedAt": None,
            "runtimeBuild": None,
            "deviceOrEditor": None,
            "approvedByUser": None,
        },
        "openStack": {
            "observedOpenOrder": [],
            "currentTopForms": [],
            "ViewMgr_clostEnableLayerView_called": None,
            "UI_Dock_defaultTab": None,
        },
        "forms": {
            "UI_Dock": form_template("UI_Dock", 248, "UIPrefabAndRes/MainInterface/Prefabs/UI_Dock", 100),
            "UI_MainPage": form_template("UI_MainPage", 249, "UIPrefabAndRes/MainInterface/Prefabs/UI_MainInterface", 0),
        },
        "guardedNodes": guarded,
        "uiBg": {
            "image": {"raycastTarget": None, "enabled": None},
            "button": {"interactable": None, "enabled": None},
            "topGraphicPath": None,
        },
        "dynamicRuntime": {
            "activitys": None,
            "faceActivitys": None,
            "playerInfo": {"level": None, "vip": None, "playerId": None, "name": None, "head": None, "headFrame": None, "guildId": None},
            "redPointState": {"serverRedPointIds": None, "actSpecificRedPoints": None},
            "reviewState": {"GameTools_IsReview": None, "GameEntry_IsReview": None, "GameEntry_IsCommittee": None},
            "guideState": {"ModulesInit_GuideMgr_isGuide": None, "CurrGuidEnterActId": None},
            "timeState": {"serverTimeStep": None, "serverMillTimeStamp": None},
            "clientCallbackOutputs": {"showInMainFunc": None, "clientCheckIsOpen": None, "getActNewName": None, "mainPageTouchJumpId": None},
            "localization": {"language": None, "keys": None},
            "resources": {"activitySpine": None, "tmpFontMaterial": None},
            "chatState": {"lastChatType": None, "visibleMessages": None},
            "currencyState": {"gold": None, "holyCrystal": None},
            "formationState": {"mainFightValue": None},
        },
    }


def main() -> None:
    REPORT.mkdir(parents=True, exist_ok=True)
    field_rows = build_field_rows()
    hook_rows = build_hook_rows()
    approval_rows = build_approval_rows()
    patch_rows = build_patch_decision_rows(field_rows)
    template = build_template()

    write_csv(FIELD_CSV, field_rows, ["section", "fieldPath", "requiredFor", "sourceKnown", "currentStaticValue", "runtimeRequired", "approvalLevel", "forbiddenToGuess", "notes"])
    write_csv(HOOK_CSV, hook_rows, ["hookPoint", "classOrFile", "method", "observableFields", "sourceEvidence", "approvalLevel", "notes"])
    write_csv(APPROVAL_CSV, approval_rows, ["capturePath", "allowedNow", "runtimeExecution", "requiresApproval", "input", "output", "decision"])
    write_csv(PATCH_DECISION_CSV, patch_rows, ["decisionArea", "fieldPattern", "staticKnown", "runtimeMissing", "staticPatchPossibleWithoutRuntime", "forbiddenToGuess", "patchDecision", "notes"])
    TEMPLATE_JSON.write_text(json.dumps(template, ensure_ascii=False, indent=2), encoding="utf-8")

    required_runtime = [r for r in field_rows if r["runtimeRequired"]]
    static_known = [r for r in field_rows if r["sourceKnown"] and not r["runtimeRequired"]]
    forbidden = [r["fieldPath"] for r in field_rows if r["forbiddenToGuess"]]
    result = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "scenePatchApplied": False,
        "runtimeInstrumentationExecuted": False,
        "snapshotValuesInvented": False,
        "runtimeSnapshotTemplateWritten": True,
        "requiredRuntimeFieldsCount": len(required_runtime),
        "staticKnownFieldsCount": len(static_known),
        "forbiddenToGuessFields": forbidden,
        "approvalRequiredForRuntimeDump": True,
        "staticPatchPossibleWithoutRuntime": False,
        "nextBlocker": "Need approved real runtime snapshot/dump for UI_Dock/UI_MainPage form parent/group/depth/CanvasHelper cascade plus UI130-compatible dynamic activity/account/chat/currency values.",
        "outputs": {
            "md": str(OUT_MD),
            "json": str(OUT_JSON),
            "requiredFieldCsv": str(FIELD_CSV),
            "hookPointCsv": str(HOOK_CSV),
            "approvalDecisionCsv": str(APPROVAL_CSV),
            "templateJson": str(TEMPLATE_JSON),
            "patchDecisionCsv": str(PATCH_DECISION_CSV),
        },
        "changedFiles": [str(OUT_MD), str(OUT_JSON), str(FIELD_CSV), str(HOOK_CSV), str(APPROVAL_CSV), str(TEMPLATE_JSON), str(PATCH_DECISION_CSV), str(Path(__file__))],
        "guardrailsTouched": [],
        "commandPolicy": command_policy(),
    }
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = f"""# MAININTERFACE_146 Runtime Snapshot Probe Spec And Source Hook Points

## Decision

- restoredClaim: `false`
- scenePatchApplied: `false`
- runtimeInstrumentationExecuted: `false`
- snapshotValuesInvented: `false`
- staticPatchPossibleWithoutRuntime: `false`
- approvalRequiredForRuntimeDump: `true`

## Snapshot Scope

- Required runtime fields: `{len(required_runtime)}`
- Static-known identity fields: `{len(static_known)}`
- Template written: `{TEMPLATE_JSON}`

The template contains only source-known identity values and `null` placeholders for runtime values. No fake activity, text, icon, parent, depth, mask, or raycast value was invented.

## Hook Point Summary

- `GameEntry.UI:OpenUIForm` / `YouYouUIManager.OpenUIForm`: form open order, group path, parent instance.
- `UIFormBase.Open`: `CurrCanvas.sortingOrder`, `Depth`, `GroupId`, `DisableUILayer`.
- `YouYouCanvasHelper.SetDepth` / `ResetRenderDepth`: local `m_Depth` and effective child Canvas/SkeletonGraphic sorting.
- `UI_Dock.OnOpen`, `UI_Dock.initTab`, `UI_Dock.setCurrView`: default MAIN_PAGE tab, Dock active state, UI_MainPage open.
- `UI_MainPage.OnOpen`: activity/chat/account/currency refresh entry.
- UI130 replay script: accepts filled snapshot later; still refuses fake defaults.

## Outputs

- Required field matrix: `{FIELD_CSV}`
- Hook point matrix: `{HOOK_CSV}`
- Approval path matrix: `{APPROVAL_CSV}`
- Runtime snapshot template: `{TEMPLATE_JSON}`
- Static-known vs runtime-missing matrix: `{PATCH_DECISION_CSV}`
- JSON: `{OUT_JSON}`

## Next Blocker

{result['nextBlocker']}
"""
    OUT_MD.write_text(md, encoding="utf-8")
    print(json.dumps({"md": str(OUT_MD), "json": str(OUT_JSON), "requiredRuntimeFieldsCount": len(required_runtime), "template": str(TEMPLATE_JSON)}, indent=2))


if __name__ == "__main__":
    main()
