from __future__ import annotations

import csv
import json
from datetime import datetime
from pathlib import Path


PREFIX = "BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH"


def read_json(path: Path, default=None):
    if not path.exists():
        return default
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows, fieldnames):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def count_root_cmds(root: Path):
    root_cmd = len(list(root.glob("*.cmd")))
    direct_restore_cmd = len(list((root / "_restore_tools").glob("*.cmd"))) if (root / "_restore_tools").exists() else 0
    return {
        "rootCmdCount": root_cmd,
        "restoreToolsDirectCmdCount": direct_restore_cmd,
        "policyOk": root_cmd == 1 and direct_restore_cmd == 0,
    }


def bool_value(value):
    if isinstance(value, bool):
        return value
    if value is None:
        return False
    return str(value).strip().lower() == "true"


def owner_for_path(path: str):
    if "btnAuto" in path:
        return (
            "UI_NormalBattle.lua",
            "lines 86-110, 404-407, 441-445, 518-520, 1494+",
            "btnAuto click/active/new/lock/on-off state is owned by ModulesInit.ProcedureNormalBattle and LuaUtils.SetChildActive",
            "handler_or_xlua_required",
        )
    if "btnTwoSpeed" in path:
        return (
            "UI_NormalBattle.lua",
            "lines 111-131, 410-417, 528-530, 683-687, 1193, 1278",
            "btnTwoSpeed click/speed/on-off/lock state is owned by ModulesInit.ProcedureNormalBattle",
            "handler_or_xlua_required",
        )
    if "btnFastSkill" in path:
        return (
            "UI_NormalBattle.lua",
            "lines 132-146, 533-535, 690-699, 1279",
            "btnFastSkill state is owned by ChangeGameFastSkill/CheckFastSkill and unlock/runtime state",
            "handler_or_xlua_required",
        )
    if "btnSkip" in path or "im_Skip" in path or "skip" in path.lower():
        return (
            "UI_NormalBattle.lua",
            "lines 47-69, 81, 428-489, 522-525, 544, 838, 1246-1264, 1276",
            "skip button visibility/icon/text/new/lock state is runtime battle-type and PhotoArtistMgr owned",
            "handler_or_xlua_required",
        )
    if "btnPause" in path:
        return (
            "UI_NormalBattle.lua",
            "lines 73-75, 562-620, 796-830, 1182-1184, 1275",
            "pause visibility is battle-type/runtime state owned",
            "handler_or_xlua_required",
        )
    if "TopCenter" in path:
        return (
            "UI_NormalBattle.lua",
            "lines 222, 467-489, 1194, 1218, 1224",
            "TopCenter and wave/round/top HUD visibility/text values are runtime battle-state owned",
            "handler_or_xlua_required",
        )
    if "root_opra" in path:
        return (
            "original prefab + UI_NormalBattle.lua",
            "BATTLE54/BATTLE70 route rows; UI_NormalBattle ShowAllOperBtn/CheckPauseBtnState paths",
            "right rail static RectTransform is visible in candidate scene, but active/state children are runtime owned",
            "runtime_snapshot_required",
        )
    if "root_battle/root_top" in path:
        return (
            "original prefab + UI_NormalBattle.lua",
            "BATTLE54/BATTLE70 route rows plus TopCenter runtime calls",
            "top route static values are visible, but final visibility/text/round/wave state needs runtime snapshot",
            "runtime_snapshot_required",
        )
    return (
        "candidate scene/static prefab evidence",
        "BATTLE72 candidate scene component export",
        "field currently observed only in candidate scene; no source-backed delta proving a patch",
        "already_matches_candidate_scene",
    )


def field_decisions(row):
    path = row.get("path", "")
    owner_file, lines, rationale, base = owner_for_path(path)
    decisions = []

    def add(field, value, classification, reason):
        decisions.append(
            {
                "path": path,
                "name": row.get("name", ""),
                "focusGroup": row.get("focusGroup", ""),
                "fieldName": field,
                "observedValue": value,
                "sourceOwner": owner_file,
                "sourceEvidence": lines,
                "classification": classification,
                "reason": reason,
                "patchDecision": "no_patch_in_battle73",
            }
        )

    if path.endswith("CanvasLuaStateHUD_01_ui_normalbattle") or path.endswith("/root_battle") or path.endswith("/root_opra") or path.endswith("/root_battle/root_top") or path.endswith("/root_battle/root_top/TopCenter"):
        add("activeSelf/activeInHierarchy", row.get("activeSelf", "") + "/" + row.get("activeInHierarchy", ""), base, rationale)
        add("siblingIndex/siblingCount", row.get("siblingIndex", "") + "/" + row.get("siblingCount", ""), "runtime_snapshot_required" if base != "already_matches_candidate_scene" else base, "sibling order is observable but should be frozen from runtime/source snapshot before patch")
        add("RectTransform", f"anchor={row.get('anchorMin','')}-{row.get('anchorMax','')}; anchored={row.get('anchoredPosition','')}; size={row.get('sizeDelta','')}; scale={row.get('localScale','')}", "runtime_snapshot_required" if base != "already_matches_candidate_scene" else base, "coordinate-only route transform patch remains forbidden without runtime/source delta")

    if row.get("hasButton") == "True":
        add("Button/interactable/listeners", f"enabled={row.get('buttonEnabled')}; interactable={row.get('buttonInteractable')}; persistent={row.get('buttonPersistentListenerCount')}; target={row.get('buttonTargetGraphicPath')}", "handler_or_xlua_required", "original onClick/listener binding is still blocked by xLua/GameEntry/ModulesInit runtime absence")

    if row.get("hasGraphic") == "True" or row.get("hasImage") == "True":
        add("Graphic/Image", f"enabled={row.get('graphicEnabled')}; raycast={row.get('graphicRaycastTarget')}; sprite={row.get('imageSprite')}; alpha={row.get('graphicAlpha')}; depth={row.get('graphicDepth')}", base if base == "handler_or_xlua_required" else "runtime_snapshot_required", "visible graphic fields may be static, but final right-rail/top-HUD state is runtime-owned or needs snapshot")

    if row.get("hasTmpText") == "True":
        add("TMP", f"text={row.get('tmpText')}; fontSize={row.get('tmpFontSize')}; auto={row.get('tmpEnableAutoSizing')}; spacing={row.get('tmpCharacterSpacing')}; scale={row.get('localScale')}", "runtime_snapshot_required", "TMP text/value/autosize/spacing must be compared against original runtime or prefab snapshot before patch")

    if row.get("hasMask") == "True" or row.get("hasRectMask2D") == "True" or row.get("hasMaskNamedComponent") == "True":
        add("Mask/Stencil", f"mask={row.get('hasMask')}; show={row.get('maskShowMaskGraphic')}; rectMask={row.get('hasRectMask2D')}; named={row.get('hasMaskNamedComponent')}", "runtime_snapshot_required", "mask/stencil behavior cannot be inferred from name or candidate state alone")

    if row.get("hasCanvas") == "True" or row.get("hasCanvasScaler") == "True" or row.get("hasCanvasGroup") == "True":
        add("Canvas/CanvasScaler/CanvasGroup", f"canvas={row.get('canvasRenderMode')}; scaler={row.get('canvasScalerReferenceResolution')}; groupBlocks={row.get('canvasGroupBlocksRaycasts')}", "runtime_snapshot_required", "canvas input/render plumbing is observable but needs runtime snapshot before changing HUD layout")

    if not decisions:
        add("observedCandidateState", "active=" + row.get("activeInHierarchy", ""), base, rationale)
    return decisions


def snapshot_rows_for_targets(component_rows):
    target_names = ["TopCenter", "root_top", "root_opra", "btnAuto", "btnTwoSpeed", "btnFastSkill", "btnSkip", "btnPause", "btnBuff", "im_on", "im_off", "im_lock", "im_new", "text", "bg_wave", "txtRound"]
    fields = [
        "activeSelf",
        "activeInHierarchy",
        "siblingIndex",
        "anchorMin",
        "anchorMax",
        "pivot",
        "sizeDelta",
        "anchoredPosition",
        "localScale",
        "graphicEnabled",
        "graphicRaycastTarget",
        "imageSprite",
        "tmpText",
        "tmpFontSize",
        "tmpEnableAutoSizing",
        "tmpCharacterSpacing",
        "hasMask",
        "maskShowMaskGraphic",
        "buttonInteractable",
        "buttonTargetGraphicPath",
    ]
    rows = []
    seen = set()
    for row in component_rows:
        path = row.get("path", "")
        if not any(t in path for t in target_names):
            continue
        owner_file, lines, rationale, classification = owner_for_path(path)
        for field in fields:
            value = row.get(field, "")
            if value == "":
                continue
            key = (path, field)
            if key in seen:
                continue
            seen.add(key)
            rows.append(
                {
                    "objectPath": path,
                    "fieldName": field,
                    "currentCandidateValue": value,
                    "requiredSnapshotOwner": owner_file,
                    "requiredRuntimeObjectOrModule": "ModulesInit.ProcedureNormalBattle / UI_NormalBattle lifecycle" if classification == "handler_or_xlua_required" else "original runtime UI scene after UI_NormalBattle.Open",
                    "whyRequired": rationale,
                    "allowedAcquisition": "approved runtime snapshot/dump only; no APK/emulator instrumentation in BATTLE73",
                    "patchUnlockedBy": "source-backed runtime snapshot matching object path and field",
                }
            )
    return rows


def main():
    root = Path(__file__).resolve().parents[2]
    reports = root / "reports" / "battle"
    unity_data = root / "girlswar_battle_unity" / "Assets" / "RestoreData" / "battle"
    unity_component_csv = unity_data / f"{PREFIX}_COMPONENT_STATE_UNITY.csv"
    unity_summary_path = unity_data / f"{PREFIX}_UNITY.json"
    component_rows = read_csv(unity_component_csv)
    unity_summary = read_json(unity_summary_path, {})
    b72 = read_json(reports / "BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE_RESULT.json", {})

    candidate_scene_path = b72.get("candidateScene") or str(root / "girlswar_battle_unity" / "Assets" / "Scenes" / "Battle72Map11003TrueAspectReprojectionPersistedCandidate.unity")

    # Output 1: copied/enriched component state.
    component_out_rows = []
    for row in component_rows:
        owner_file, lines, rationale, classification = owner_for_path(row.get("path", ""))
        enriched = dict(row)
        enriched["sourceOwner"] = owner_file
        enriched["sourceEvidence"] = lines
        enriched["ownershipRationale"] = rationale
        enriched["primaryClassification"] = classification
        component_out_rows.append(enriched)

    # Output 2: source ownership trace at focused group/button level.
    ownership_rows = [
        {
            "target": "root_battle/root_top",
            "sourceOwner": "original prefab + UI_NormalBattle.lua",
            "evidence": "BATTLE54/BATTLE70 route rows; TopCenter visibility controlled by UI_NormalBattle lines 222/1194/1218/1224",
            "ownedFields": "active state, child visibility, round/wave text, some stateful descendants",
            "currentConclusion": "static route exists, final state requires runtime snapshot",
            "classification": "runtime_snapshot_required",
        },
        {
            "target": "root_battle/root_top/TopCenter",
            "sourceOwner": "UI_NormalBattle.lua / ModulesInit.ProcedureNormalBattle",
            "evidence": "UI_NormalBattle lines 222, 467-489, 1194, 1218, 1224",
            "ownedFields": "activeSelf, wave/round display, player/enemy top info state",
            "currentConclusion": "do not patch until original runtime state is available",
            "classification": "handler_or_xlua_required",
        },
        {
            "target": "root_opra",
            "sourceOwner": "original prefab + UI_NormalBattle.lua",
            "evidence": "BATTLE54/BATTLE70 route rows; UI_NormalBattle ShowAllOperBtn/CheckPauseBtnState",
            "ownedFields": "right rail active group and child button states",
            "currentConclusion": "root RectTransform is observable; final state requires runtime snapshot",
            "classification": "runtime_snapshot_required",
        },
        {
            "target": "btnAuto",
            "sourceOwner": "UI_NormalBattle.lua / ModulesInit.ProcedureNormalBattle",
            "evidence": "lines 86-110, 404-407, 441-445, 518-520, 1494+",
            "ownedFields": "onClick, active, im_on/im_off, lock, new marker",
            "currentConclusion": "xLua/GameEntry/ModulesInit missing; handler binding remains 0",
            "classification": "handler_or_xlua_required",
        },
        {
            "target": "btnTwoSpeed",
            "sourceOwner": "UI_NormalBattle.lua / ModulesInit.ProcedureNormalBattle",
            "evidence": "lines 111-131, 410-417, 528-530, 683-687, 1193, 1278",
            "ownedFields": "onClick, im_on/im_off, lock, GameSpeed state",
            "currentConclusion": "requires handler/runtime state",
            "classification": "handler_or_xlua_required",
        },
        {
            "target": "btnFastSkill",
            "sourceOwner": "UI_NormalBattle.lua / ModulesInit.ProcedureNormalBattle",
            "evidence": "lines 132-146, 533-535, 690-699, 1279",
            "ownedFields": "onClick, im_on/im_off, lock, fast skill state",
            "currentConclusion": "requires handler/runtime state",
            "classification": "handler_or_xlua_required",
        },
        {
            "target": "btnSkip/btnPause",
            "sourceOwner": "UI_NormalBattle.lua / ModulesInit.ProcedureNormalBattle / PhotoArtistMgr",
            "evidence": "btnSkip lines 47-69/81/428-489/522-525/544/838/1246-1264/1276; btnPause lines 73-75/562-620/796-830/1182-1184/1275",
            "ownedFields": "visibility, new marker, lock marker, sprite/text, pause presence by battle type",
            "currentConclusion": "requires runtime snapshot; coordinate-only hide/show forbidden",
            "classification": "handler_or_xlua_required",
        },
    ]

    decision_rows = []
    for row in component_rows:
        decision_rows.extend(field_decisions(row))

    snapshot_rows = snapshot_rows_for_targets(component_rows)

    patch_rows = [
        {
            "candidateOrBlocker": "source_backed_static_patch_candidate",
            "count": 0,
            "evidence": "No route/HUD/right rail field has a proven static source delta after B72; current state is only candidate scene/prefab observation.",
            "decision": "no_static_patch_in_battle73",
            "nextAction": "collect runtime snapshot first",
        },
        {
            "candidateOrBlocker": "runtime_snapshot_required",
            "count": sum(1 for r in decision_rows if r["classification"] == "runtime_snapshot_required"),
            "evidence": "RectTransform/sibling/TMP/mask/canvas fields are observable but not safely patchable without original runtime state.",
            "decision": "blocked_pending_runtime_snapshot",
            "nextAction": "use minimal runtime snapshot field spec",
        },
        {
            "candidateOrBlocker": "handler_or_xlua_required",
            "count": sum(1 for r in decision_rows if r["classification"] == "handler_or_xlua_required"),
            "evidence": "UI_NormalBattle button/top HUD state is owned by ModulesInit.ProcedureNormalBattle; xLua/GameEntry runtime remains unavailable.",
            "decision": "blocked_pending_xlua_gameentry_modulesinit",
            "nextAction": "provide source-backed runtime or approved snapshot evidence",
        },
        {
            "candidateOrBlocker": "forbidden_guess",
            "count": 1,
            "evidence": "Coordinate-only active/RectTransform/TMP/mask changes would only match a screenshot region and are forbidden.",
            "decision": "do_not_patch",
            "nextAction": "avoid arbitrary HUD/right rail movement/hide/show",
        },
        {
            "candidateOrBlocker": "map_reprojection",
            "count": 1,
            "evidence": "BATTLE72 map reprojection remains validated persisted candidate.",
            "decision": "already_validated_out_of_scope_for_battle73",
            "nextAction": "keep as mapReprojectionCandidateState=validated_persisted_battle72",
        },
    ]

    source_static_candidates = sum(1 for r in decision_rows if r["classification"] == "source_backed_static_patch_candidate")
    runtime_required = sum(1 for r in decision_rows if r["classification"] == "runtime_snapshot_required")
    handler_required = sum(1 for r in decision_rows if r["classification"] == "handler_or_xlua_required")
    forbidden = sum(1 for r in decision_rows if r["classification"] == "forbidden_guess") + 1
    command_policy = count_root_cmds(root)

    component_csv = reports / f"{PREFIX}_CANDIDATE_SCENE_HUD_RIGHT_RAIL_COMPONENT_STATE_MATRIX.csv"
    ownership_csv = reports / f"{PREFIX}_SOURCE_OWNERSHIP_AND_HANDLER_TRACE_MATRIX.csv"
    decision_csv = reports / f"{PREFIX}_ACTIVE_SIBLING_ORDER_MASK_STENCIL_TMP_AUTOSIZE_DECISION_MATRIX.csv"
    snapshot_csv = reports / f"{PREFIX}_MINIMAL_RUNTIME_SNAPSHOT_FIELD_SPEC.csv"
    patch_csv = reports / f"{PREFIX}_PATCH_CANDIDATE_VS_BLOCKER_DECISION_MATRIX.csv"
    json_path = reports / f"{PREFIX}_RESULT.json"
    md_path = reports / f"{PREFIX}_RESULT.md"

    component_fields = list(component_out_rows[0].keys()) if component_out_rows else ["path"]
    write_csv(component_csv, component_out_rows, component_fields)
    write_csv(ownership_csv, ownership_rows, ["target", "sourceOwner", "evidence", "ownedFields", "currentConclusion", "classification"])
    write_csv(decision_csv, decision_rows, ["path", "name", "focusGroup", "fieldName", "observedValue", "sourceOwner", "sourceEvidence", "classification", "reason", "patchDecision"])
    write_csv(snapshot_csv, snapshot_rows, ["objectPath", "fieldName", "currentCandidateValue", "requiredSnapshotOwner", "requiredRuntimeObjectOrModule", "whyRequired", "allowedAcquisition", "patchUnlockedBy"])
    write_csv(patch_csv, patch_rows, ["candidateOrBlocker", "count", "evidence", "decision", "nextAction"])

    result = {
        "task": PREFIX,
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "playableClaim": False,
        "patchApplied": False,
        "sceneSaved": False,
        "canonicalSceneOverwritten": False,
        "candidateSceneUsed": True,
        "candidateScenePath": candidate_scene_path,
        "packageImported": False,
        "manifestModified": False,
        "runtimeInstrumentationUsed": False,
        "hudRoutePatched": False,
        "cardPayloadPatched": False,
        "actorPayloadPatched": False,
        "mapReprojectionCandidateState": "validated_persisted_battle72",
        "hudNodesReviewed": int(unity_summary.get("hudNodesReviewed") or len(component_rows)),
        "rightRailNodesReviewed": int(unity_summary.get("rightRailNodesReviewed") or sum(1 for r in component_rows if r.get("focusGroup") in {"right_rail", "button_or_state_child"})),
        "tmpRowsReviewed": int(unity_summary.get("tmpRowsReviewed") or sum(1 for r in component_rows if r.get("hasTmpText") == "True")),
        "maskStencilRowsReviewed": int(unity_summary.get("maskStencilRowsReviewed") or sum(1 for r in component_rows if r.get("hasMask") == "True" or r.get("hasRectMask2D") == "True" or r.get("hasMaskNamedComponent") == "True")),
        "siblingOrderRowsReviewed": int(unity_summary.get("siblingOrderRowsReviewed") or len(component_rows)),
        "sourceBackedStaticPatchCandidates": source_static_candidates,
        "runtimeSnapshotRequiredRows": runtime_required,
        "handlerOrXluaRequiredRows": handler_required,
        "forbiddenGuessRows": forbidden,
        "minimalRuntimeSnapshotFieldsCount": len(snapshot_rows),
        "recommendedNextAction": "ACQUIRE_APPROVED_ORIGINAL_RUNTIME_SNAPSHOT_FOR_UI_NORMALBATTLE_ROUTE_HUD_RIGHT_RAIL_FIELDS_BEFORE_ANY_PATCH",
        "nextBlocker": "ORIGINAL_RUNTIME_SNAPSHOT_OR_XLUA_GAMEENTRY_MODULESINIT_HANDLER_STATE_REQUIRED_FOR_HUD_RIGHT_RAIL_PATCH",
        "guardrailsTouched": [
            "no_scene_save",
            "no_canonical_scene_overwrite",
            "no_package_import",
            "no_manifest_edit",
            "no_xlua_or_handler_patch",
            "no_hud_route_patch",
            "no_card_or_actor_payload_patch",
            "no_fake_hud_card_icon_text_actor_effect",
            "no_screenshot_or_atlas_paste_as_asset",
            "no_coordinate_only_success",
            "no_runtime_instrumentation",
        ],
        "commandPolicy": command_policy,
        "unitySummary": str(unity_summary_path),
        "unityComponentCsv": str(unity_component_csv),
        "outputs": {
            "componentCsv": str(component_csv),
            "ownershipCsv": str(ownership_csv),
            "decisionCsv": str(decision_csv),
            "snapshotSpecCsv": str(snapshot_csv),
            "patchDecisionCsv": str(patch_csv),
        },
    }
    json_path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        f"# {PREFIX} Result",
        "",
        "## Verdict",
        "- `restoredClaim=false`, `playableClaim=false`.",
        "- `patchApplied=false`; candidate scene was opened for audit only and not saved.",
        "- BATTLE72 map reprojection remains `validated_persisted_battle72`.",
        "",
        "## Reviewed Counts",
        f"- HUD nodes reviewed: `{result['hudNodesReviewed']}`.",
        f"- Right rail nodes reviewed: `{result['rightRailNodesReviewed']}`.",
        f"- TMP rows reviewed: `{result['tmpRowsReviewed']}`.",
        f"- Mask/stencil rows reviewed: `{result['maskStencilRowsReviewed']}`.",
        f"- Sibling/order rows reviewed: `{result['siblingOrderRowsReviewed']}`.",
        "",
        "## Decision",
        f"- Safe source-backed static patch candidates: `{source_static_candidates}`.",
        f"- Runtime snapshot required rows: `{runtime_required}`.",
        f"- Handler/xLua required rows: `{handler_required}`.",
        f"- Forbidden guess rows: `{forbidden}`.",
        f"- Minimal runtime snapshot fields: `{len(snapshot_rows)}`.",
        "",
        "## Blocker",
        "- HUD/right rail active state, on/off children, skip/pause/speed/fast-skill state, TMP text values, and mask/stencil behavior remain owned by runtime `UI_NormalBattle` / `ModulesInit.ProcedureNormalBattle` or require an original runtime snapshot.",
        "- No coordinate-only route/HUD patch is source-backed after BATTLE72.",
        "",
        "## Outputs",
        f"- `{component_csv}`",
        f"- `{ownership_csv}`",
        f"- `{decision_csv}`",
        f"- `{snapshot_csv}`",
        f"- `{patch_csv}`",
        f"- `{json_path}`",
        "",
        "## Command Policy",
        f"- root `.cmd` count: `{command_policy['rootCmdCount']}`",
        f"- `_restore_tools` direct `.cmd` count: `{command_policy['restoreToolsDirectCmdCount']}`",
        f"- policy ok: `{command_policy['policyOk']}`",
    ]
    md_path.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(
        json.dumps(
            {
                "result": str(json_path),
                "hudNodesReviewed": result["hudNodesReviewed"],
                "rightRailNodesReviewed": result["rightRailNodesReviewed"],
                "sourceBackedStaticPatchCandidates": source_static_candidates,
                "minimalRuntimeSnapshotFieldsCount": len(snapshot_rows),
                "nextBlocker": result["nextBlocker"],
            },
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()
