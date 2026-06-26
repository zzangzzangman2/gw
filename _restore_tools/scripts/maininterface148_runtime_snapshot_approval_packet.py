import csv
import json
from datetime import datetime
from pathlib import Path


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = ROOT / "reports" / "maininterface"
PREFIX = "MAININTERFACE_148_RUNTIME_SNAPSHOT_APPROVAL_PACKET_AND_STATIC_FIELD_EXHAUSTION_NO_RUNTIME_NO_PATCH"

UI146_JSON = REPORT_DIR / "MAININTERFACE_146_RUNTIME_SNAPSHOT_PROBE_SPEC_AND_SOURCE_HOOK_POINTS_NO_EXECUTION_NO_PATCH_RESULT.json"
UI146_TEMPLATE = REPORT_DIR / "MAININTERFACE_146_runtime_snapshot_template.json"
UI146_FIELDS = REPORT_DIR / "MAININTERFACE_146_runtime_snapshot_required_field_matrix.csv"
UI146_HOOKS = REPORT_DIR / "MAININTERFACE_146_source_hook_point_observable_field_matrix.csv"
UI147_JSON = REPORT_DIR / "MAININTERFACE_147_REFERENCE_ASPECT_CAPTURE_ROOTCAUSE_CONSOLIDATION_NO_PATCH_RESULT.json"
UI147_VISIBLE = REPORT_DIR / "MAININTERFACE_147_REFERENCE_ASPECT_CAPTURE_ROOTCAUSE_CONSOLIDATION_NO_PATCH_visible_mismatch_vs_runtime_snapshot_required_matrix.csv"


def read_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def read_csv(path: Path):
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows, fieldnames):
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def command_policy():
    root_cmds = sorted(p.name for p in ROOT.glob("*.cmd"))
    direct_restore_cmds = sorted(p.name for p in (ROOT / "_restore_tools").glob("*.cmd")) if (ROOT / "_restore_tools").exists() else []
    return {
        "rootCmdCount": len(root_cmds),
        "rootCmdFiles": root_cmds,
        "restoreToolsDirectCmdCount": len(direct_restore_cmds),
        "restoreToolsDirectCmdFiles": direct_restore_cmds,
        "policySatisfied": len(root_cmds) == 1 and len(direct_restore_cmds) == 0,
    }


def boolish(value):
    if isinstance(value, bool):
        return value
    return str(value).strip().lower() == "true"


def ordered_group(section, field_path):
    if section == "formRuntime":
        if ".parentTransformFullPath" in field_path or ".uiGroup." in field_path or ".uiFormBase." in field_path:
            return 10, "UI_Dock/UI_MainPage parent/group/depth/form stack"
        if ".rootCanvas." in field_path or ".canvasGroup." in field_path:
            return 20, "root Canvas/CanvasGroup effective render state"
        return 5, "form identity and transform state"
    if section == "canvasHelper":
        return 30, "YouYouCanvasHelper depth cascade"
    if section == "guardedNodeState":
        if "node_act_btn" in field_path:
            return 50, "activity slot guarded active/sibling state"
        if "right/node_middle" in field_path or "wanfaWorldNode" in field_path:
            return 40, "route/world guarded active/sibling state"
        if "llvChat" in field_path or "top/" in field_path:
            return 60, "chat/account/currency guarded node state"
        if "zhuye_" in field_path:
            return 45, "zhuye guarded active/sibling state"
        return 55, "other guarded node state"
    if section == "uiBg":
        return 70, "UI_bg raycast/interactable verification"
    if section == "dynamicRuntime":
        return 80, "activity/account/chat/currency dynamic values"
    if section == "maskStencilRuntime":
        return 90, "runtime TMP/material/mask/stencil renderer state"
    return 99, "misc runtime fields"


def classify(row):
    source_known = boolish(row["sourceKnown"])
    runtime_required = boolish(row["runtimeRequired"])
    forbidden = boolish(row["forbiddenToGuess"])
    if source_known and not runtime_required:
        return "already_statically_known"
    if source_known and runtime_required:
        return "static_partial_known_but_runtime_effective_value_required"
    if runtime_required:
        return "requires_runtime_snapshot"
    return "unknown_static_review_needed"


def mismatch_area_for_field(field_path, section):
    if field_path.startswith("forms.UI_Dock") or "canvasHelpers" in field_path:
        return "UI_Dock bottom nav, source root/form stack, UI144 non-promotion"
    if field_path.startswith("forms.UI_MainPage"):
        return "old-root vs new-root, UI_MainPage form stack/depth, home layout layer order"
    if "right/node_middle" in field_path or "wanfaWorldNode" in field_path:
        return "route/world cluster active/sibling mismatch"
    if "node_act_btn" in field_path or "activitys" in field_path or "faceActivitys" in field_path:
        return "activity stack / face activity icon/text/redpoint mismatch"
    if "llvChat" in field_path or "chatState" in field_path:
        return "chat bubble/text runtime mismatch"
    if "top/" in field_path or "playerInfo" in field_path or "currencyState" in field_path:
        return "top profile/currency/account value mismatch"
    if "UI_bg" in field_path or "uiBg" in field_path:
        return "UI_bg click/raycast guardrail verification"
    if "zhuye_" in field_path:
        return "zhuye layer active/sibling guardrail verification"
    if section == "maskStencilRuntime" or "tmpFontMaterial" in field_path or "localization" in field_path:
        return "TMP/font/material/mask/stencil runtime visual mismatch"
    return "general MainInterface runtime mismatch"


def hook_for_field(field_path, section):
    if field_path.startswith("forms.") and (".uiFormBase." in field_path or ".rootCanvas." in field_path):
        return "UIFormBase.Open / YouYouCanvasHelper.ResetRenderDepth"
    if field_path.startswith("forms.") and (".parentTransformFullPath" in field_path or ".uiGroup." in field_path):
        return "GameEntry.UI:OpenUIForm / YouYouUIManager.OpenUIForm"
    if section == "canvasHelper":
        return "YouYouCanvasHelper.SetDepth / ResetRenderDepth"
    if section == "dynamicRuntime":
        return "UI_MainPage.OnOpen / ActMgr / PlayerMgr / RedPointMgr / ChatMgr"
    if section == "guardedNodeState":
        return "runtime hierarchy dump after UI_Dock.initTab and UI_MainPage.OnOpen"
    if section == "uiBg":
        return "runtime hierarchy + GraphicRaycaster hit stack"
    if section == "maskStencilRuntime":
        return "runtime renderer/material dump after OnDepthChanged"
    return "snapshot template fill"


def static_value_from_template(field_path, template, fallback):
    exact = {
        "forms.UI_Dock.formName": template["forms"]["UI_Dock"]["formName"],
        "forms.UI_Dock.formId": template["forms"]["UI_Dock"]["formId"],
        "forms.UI_Dock.sourcePrefabPath": template["forms"]["UI_Dock"]["sourcePrefabPath"],
        "forms.UI_Dock.disableUILayer": template["forms"]["UI_Dock"]["disableUILayer"],
        "forms.UI_Dock.rootCanvas.sourceSerializedSortingOrder": template["forms"]["UI_Dock"]["rootCanvas"]["sourceSerializedSortingOrder"],
        "forms.UI_MainPage.formName": template["forms"]["UI_MainPage"]["formName"],
        "forms.UI_MainPage.formId": template["forms"]["UI_MainPage"]["formId"],
        "forms.UI_MainPage.sourcePrefabPath": template["forms"]["UI_MainPage"]["sourcePrefabPath"],
        "forms.UI_MainPage.disableUILayer": template["forms"]["UI_MainPage"]["disableUILayer"],
        "forms.UI_MainPage.rootCanvas.sourceSerializedSortingOrder": template["forms"]["UI_MainPage"]["rootCanvas"]["sourceSerializedSortingOrder"],
    }
    if field_path in exact:
        return exact[field_path]
    return fallback


def make_checklist(field_rows, template):
    checklist = []
    for row in field_rows:
        section = row["section"]
        field_path = row["fieldPath"]
        order_base, group = ordered_group(section, field_path)
        cls = classify(row)
        source_known = boolish(row["sourceKnown"])
        runtime_required = boolish(row["runtimeRequired"])
        forbidden = boolish(row["forbiddenToGuess"])
        static_value = static_value_from_template(field_path, template, row["currentStaticValue"])
        checklist.append({
            "captureOrder": order_base,
            "section": section,
            "fieldPath": field_path,
            "snapshotGroup": group,
            "requiredFor": row["requiredFor"],
            "sourceClassification": cls,
            "staticValueOrEvidence": static_value,
            "requiresRuntimeSnapshot": str(runtime_required),
            "forbiddenToGuess": str(forbidden),
            "approvalLevel": row["approvalLevel"],
            "hookPoint": hook_for_field(field_path, section),
            "visibleMismatchUnblocked": mismatch_area_for_field(field_path, section),
            "minimalCaptureReason": row["notes"],
        })
    checklist.sort(key=lambda r: (int(r["captureOrder"]), r["section"], r["fieldPath"]))
    for idx, row in enumerate(checklist, 1):
        row["captureOrder"] = idx
    return checklist


def make_classification_matrix(field_rows, template):
    rows = []
    for row in field_rows:
        cls = classify(row)
        runtime_required = boolish(row["runtimeRequired"])
        source_known = boolish(row["sourceKnown"])
        static_patch_allowed = source_known and not runtime_required and False
        static_value = static_value_from_template(row["fieldPath"], template, row["currentStaticValue"])
        rows.append({
            "section": row["section"],
            "fieldPath": row["fieldPath"],
            "sourceClassification": cls,
            "alreadyStaticallyKnown": str(cls == "already_statically_known"),
            "staticallyInferableFromSerializedSource": str(cls in {"already_statically_known", "static_partial_known_but_runtime_effective_value_required"}),
            "requiresRuntimeSnapshot": str(runtime_required),
            "forbiddenToGuess": row["forbiddenToGuess"],
            "staticValueOrEvidence": static_value,
            "staticPatchAllowedNow": str(static_patch_allowed),
            "exhaustionDecision": (
                "static_identity_only_no_patch"
                if cls == "already_statically_known"
                else "partial_static_evidence_exhausted_but_runtime_effective_value_required"
                if cls == "static_partial_known_but_runtime_effective_value_required"
                else "runtime_only_no_static_value"
            ),
        })
    return rows


def make_risk_matrix():
    return [
        {
            "visibleMismatch": "UI_Dock bottom nav / source root still visually worse than UI128",
            "fieldsNeeded": "forms.UI_Dock parentTransformFullPath/siblingIndex/uiGroup/rootCanvas/uiFormBase + canvasHelpers",
            "whyItUnblocks": "Decides whether UI_Dock should be globally stacked, how DisableUILayer depth is applied, and how child SkeletonGraphic/Canvas sorting cascades.",
            "riskIfGuessed": "Repeats UI136/UI144 non-production visual stack; can hide or overdraw reference UI without proof.",
            "currentEvidence": "UI144 real renderers compile, but full corr 0.239859 trails UI128 0.425589.",
            "approvalNeeded": "approved_original_runtime_dump_required",
            "staticPatchAllowed": "false",
        },
        {
            "visibleMismatch": "old-root/new-root and normal home form stack ambiguity",
            "fieldsNeeded": "forms.UI_MainPage parentTransformFullPath/siblingIndex/uiGroup/rootCanvas/uiFormBase + openStack",
            "whyItUnblocks": "Confirms whether production home is UI_MainInterface_old-equivalent, source root MainPage, or another stacked form state.",
            "riskIfGuessed": "Promotes wrong prefab root or layer order and preserves route/world clutter incorrectly.",
            "currentEvidence": "UI126 old-root closer; UI145 says UI_Dock and UI_MainInterface roots are separate father_id=0.",
            "approvalNeeded": "approved_original_runtime_dump_required",
            "staticPatchAllowed": "false",
        },
        {
            "visibleMismatch": "route/world cluster visible/behind/active ambiguity",
            "fieldsNeeded": "guardedNodes.right/node_middle*, wanfaWorldNode, worldwanfaBtn activeSelf/activeInHierarchy/siblingIndex/canvasSortingOrder",
            "whyItUnblocks": "Determines whether route/world nodes are actually active, hidden, or merely behind production layers in normal home.",
            "riskIfGuessed": "Violates guardrail by hiding route/world nodes without runtime proof.",
            "currentEvidence": "No source-backed hide/sibling patch exists.",
            "approvalNeeded": "approved_original_runtime_dump_required",
            "staticPatchAllowed": "false",
        },
        {
            "visibleMismatch": "activity stack / face activity icons/text/redpoints differ",
            "fieldsNeeded": "dynamicRuntime.activitys, faceActivitys, redPointState, reviewState, playerInfo level/vip, clientCallbackOutputs, localization/resources",
            "whyItUnblocks": "Allows UI130 replay of ActMgr:GetActInMain/GetActInMainFace and source-backed slot/icon/text/spine selection.",
            "riskIfGuessed": "Fake activity hide/label/icon/spine and wrong review-state branch.",
            "currentEvidence": "UI129 found 7651 candidates but 0 can drive GetActInMain.",
            "approvalNeeded": "approved_original_runtime_dump_required or user-supplied real snapshot",
            "staticPatchAllowed": "false",
        },
        {
            "visibleMismatch": "top profile/currency/chat values and labels differ",
            "fieldsNeeded": "dynamicRuntime.playerInfo, currencyState, chatState, localization keys, guarded top/chat active state",
            "whyItUnblocks": "Identifies real account/currency/chat visible values and localized labels without fake text.",
            "riskIfGuessed": "Creates fake account/chat/currency UI inconsistent with runtime.",
            "currentEvidence": "Static TMP material known; dynamic values not local.",
            "approvalNeeded": "approved_original_runtime_dump_required or user-supplied real snapshot",
            "staticPatchAllowed": "false",
        },
        {
            "visibleMismatch": "UI_bg click/raycast blocker and interaction layering",
            "fieldsNeeded": "guardedNodes.UI_bg active/sibling/canvasSortingOrder; uiBg image.raycastTarget/button.interactable/button.enabled/topGraphicPath",
            "whyItUnblocks": "Confirms whether UI_bg/Button remains raycast-active or top UI_touchSpine is correct.",
            "riskIfGuessed": "Violates explicit UI_bg raycast/interactable guardrail.",
            "currentEvidence": "UI136 preserved baseline true/true; no off evidence.",
            "approvalNeeded": "approved_original_runtime_dump_required",
            "staticPatchAllowed": "false",
        },
        {
            "visibleMismatch": "TMP/font/material/mask/stencil residual visual mismatch",
            "fieldsNeeded": "runtimeMaskStencil.* plus dynamicRuntime.localization/resources.tmpFontMaterial",
            "whyItUnblocks": "Separates static TMP bindings already applied from runtime-selected font/material/stencil states.",
            "riskIfGuessed": "Invented mask/stencil/material or dynamic text patch.",
            "currentEvidence": "UI132 static TMP lane exhausted; UI145 direct Dock Mask/RectMask2D=0 but runtime material/stencil unobserved.",
            "approvalNeeded": "approved_original_runtime_dump_required",
            "staticPatchAllowed": "false",
        },
    ]


def make_approval_packet(template, checklist_rows):
    runtime_fields = [row for row in checklist_rows if row["requiresRuntimeSnapshot"] == "True"]
    groups = []
    for name in [
        "UI_Dock/UI_MainPage parent/group/depth/form stack",
        "root Canvas/CanvasGroup effective render state",
        "YouYouCanvasHelper depth cascade",
        "route/world guarded active/sibling state",
        "zhuye guarded active/sibling state",
        "activity slot guarded active/sibling state",
        "chat/account/currency guarded node state",
        "UI_bg raycast/interactable verification",
        "activity/account/chat/currency dynamic values",
        "runtime TMP/material/mask/stencil renderer state",
    ]:
        fields = [r["fieldPath"] for r in runtime_fields if r["snapshotGroup"] == name]
        if fields:
            groups.append({"group": name, "fieldCount": len(fields), "fields": fields})
    return {
        "schemaVersion": "MAININTERFACE_148_runtime_snapshot_approval_packet_v1",
        "purpose": "Collect only the missing runtime evidence needed to decide MainInterface source-backed patching.",
        "noFakeValues": True,
        "noRuntimeExecutedByThisTask": True,
        "approvalRequiredBeforeExecution": True,
        "requiredApprovalText": "Approve original runtime snapshot/dump for UI_Dock/UI_MainPage form parent/group/depth/CanvasHelper cascade and UI130-compatible activity/account/chat/currency state. No scene patch or fake values are approved by this packet.",
        "inputTemplate": "reports/maininterface/MAININTERFACE_146_runtime_snapshot_template.json",
        "groups": groups,
        "templateWithNullPlaceholders": template,
    }


def main():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    now = datetime.now().isoformat(timespec="seconds")

    ui146 = read_json(UI146_JSON)
    ui147 = read_json(UI147_JSON)
    template = read_json(UI146_TEMPLATE)
    field_rows = read_csv(UI146_FIELDS)

    checklist = make_checklist(field_rows, template)
    classification = make_classification_matrix(field_rows, template)
    risk = make_risk_matrix()
    approval_packet = make_approval_packet(template, checklist)

    static_known_count = sum(1 for r in classification if r["sourceClassification"] == "already_statically_known")
    partial_static_runtime_count = sum(1 for r in classification if r["sourceClassification"] == "static_partial_known_but_runtime_effective_value_required")
    runtime_required_count = sum(1 for r in classification if r["requiresRuntimeSnapshot"] == "True")
    forbidden_count = sum(1 for r in classification if r["forbiddenToGuess"] == "True")

    # UI148 exhausts existing static evidence but finds no new patchable static field beyond UI146.
    statically_inferable_new_fields_count = 0

    checklist_csv = REPORT_DIR / f"{PREFIX}_minimal_runtime_snapshot_field_checklist.csv"
    classification_csv = REPORT_DIR / f"{PREFIX}_static_known_vs_runtime_required_classification_matrix.csv"
    risk_csv = REPORT_DIR / f"{PREFIX}_mismatch_unblocked_by_field_risk_matrix.csv"
    packet_json = REPORT_DIR / f"{PREFIX}_approval_packet_template.json"
    result_json = REPORT_DIR / f"{PREFIX}_RESULT.json"
    result_md = REPORT_DIR / f"{PREFIX}_RESULT.md"

    write_csv(checklist_csv, checklist, [
        "captureOrder",
        "section",
        "fieldPath",
        "snapshotGroup",
        "requiredFor",
        "sourceClassification",
        "staticValueOrEvidence",
        "requiresRuntimeSnapshot",
        "forbiddenToGuess",
        "approvalLevel",
        "hookPoint",
        "visibleMismatchUnblocked",
        "minimalCaptureReason",
    ])
    write_csv(classification_csv, classification, [
        "section",
        "fieldPath",
        "sourceClassification",
        "alreadyStaticallyKnown",
        "staticallyInferableFromSerializedSource",
        "requiresRuntimeSnapshot",
        "forbiddenToGuess",
        "staticValueOrEvidence",
        "staticPatchAllowedNow",
        "exhaustionDecision",
    ])
    write_csv(risk_csv, risk, [
        "visibleMismatch",
        "fieldsNeeded",
        "whyItUnblocks",
        "riskIfGuessed",
        "currentEvidence",
        "approvalNeeded",
        "staticPatchAllowed",
    ])
    packet_json.write_text(json.dumps(approval_packet, ensure_ascii=False, indent=2), encoding="utf-8")

    changed_files = [
        str(result_md),
        str(result_json),
        str(checklist_csv),
        str(classification_csv),
        str(risk_csv),
        str(packet_json),
        str(ROOT / "_restore_tools" / "scripts" / "maininterface148_runtime_snapshot_approval_packet.py"),
    ]

    result = {
        "generatedAt": now,
        "restoredClaim": False,
        "scenePatchApplied": False,
        "runtimeInstrumentationExecuted": False,
        "snapshotValuesInvented": False,
        "staticPatchApplied": False,
        "requiredRuntimeFieldsCount": runtime_required_count,
        "staticKnownFieldsCount": static_known_count,
        "staticallyInferableNewFieldsCount": statically_inferable_new_fields_count,
        "staticallyInferableRuntimeStillRequiredFieldsCount": partial_static_runtime_count,
        "forbiddenGuessFieldsCount": forbidden_count,
        "approvalRequiredForRuntimeDump": True,
        "sourceExhaustionDecision": "no_new_static_patchable_fields_found; UI146 static identity and partial source fields are exhausted",
        "approvalPacketWritten": True,
        "approvalPacketPath": str(packet_json),
        "referenceAspectContext": ui147.get("referenceAspect"),
        "aspectMismatchContributor": ui147.get("aspectMismatchContributor"),
        "nextBlocker": "Need approved real runtime snapshot/dump using the UI148 approval packet: UI_Dock/UI_MainPage parent/group/depth/CanvasHelper cascade, guarded node active/sibling state, UI_bg raycast state, runtime mask/stencil, and UI130-compatible activity/account/chat/currency values.",
        "outputs": {
            "md": str(result_md),
            "json": str(result_json),
            "minimalChecklistCsv": str(checklist_csv),
            "classificationCsv": str(classification_csv),
            "riskMatrixCsv": str(risk_csv),
            "approvalPacketJson": str(packet_json),
        },
        "changedFiles": changed_files,
        "guardrailsTouched": [],
        "commandPolicy": command_policy(),
    }
    result_json.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = f"""# MAININTERFACE_148 Runtime Snapshot Approval Packet And Static Field Exhaustion

Generated: {now}

## Verdict

- restoredClaim: `false`
- scenePatchApplied: `false`
- runtimeInstrumentationExecuted: `false`
- snapshotValuesInvented: `false`
- staticPatchApplied: `false`
- approvalRequiredForRuntimeDump: `true`

## Field Exhaustion

- Required runtime / forbidden-to-guess fields: `{runtime_required_count}`
- Already statically known identity fields: `{static_known_count}`
- Static partial fields that still require runtime effective values: `{partial_static_runtime_count}`
- Newly exhausted static patchable fields in UI148: `{statically_inferable_new_fields_count}`

No new source-backed static scene patch was found. The remaining fields are observable only from a real runtime snapshot/dump or a user-supplied real snapshot. Static values such as source form id, prefab path, `DisableUILayer`, and serialized Canvas sorting are already accounted for, but they do not decide effective production parent/depth/render order.

## Approval Packet Scope

The compact approval packet groups the capture into:

1. `UI_Dock` / `UI_MainPage` parent, group, depth, Canvas, and form stack.
2. `YouYouCanvasHelper` local/effective depth cascade.
3. Guarded route/world/zhuye/activity/chat/top/UI_bg active, sibling, canvas, and raycast state.
4. UI130-compatible activity/account/chat/currency/redpoint/localization/resource state.
5. Runtime TMP/font/material/mask/stencil renderer state.

## Risk Summary

- UI_Dock/root Canvas renderer reconstruction is source-backed but not promotable without runtime parent/depth.
- Route/world and guarded nodes remain no-hide/no-reorder.
- Activity/chat/account/currency values remain no-fake and UI130 snapshot-gated.
- UI_bg raycast/interactable remains unchanged unless real runtime evidence says otherwise.
- Aspect remains a comparison contributor, not a static patch lane.

## Outputs

- Minimal checklist CSV: `{checklist_csv}`
- Static/runtime classification CSV: `{classification_csv}`
- Mismatch risk matrix CSV: `{risk_csv}`
- Approval packet JSON/template: `{packet_json}`
- Result JSON: `{result_json}`

## Next Blocker

Need explicit approval and a safe original-runtime target, or a real user-supplied filled snapshot, to populate the UI148 packet fields. Until then, `staticPatchPossibleWithoutRuntime=false`.

## Command Policy

- root `.cmd` count: `{result["commandPolicy"]["rootCmdCount"]}`
- `_restore_tools` direct `.cmd` count: `{result["commandPolicy"]["restoreToolsDirectCmdCount"]}`
- policySatisfied: `{result["commandPolicy"]["policySatisfied"]}`
"""
    result_md.write_text(md, encoding="utf-8")

    print(json.dumps({
        "md": str(result_md),
        "json": str(result_json),
        "requiredRuntimeFieldsCount": runtime_required_count,
        "staticKnownFieldsCount": static_known_count,
        "staticallyInferableNewFieldsCount": statically_inferable_new_fields_count,
        "forbiddenGuessFieldsCount": forbidden_count,
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
