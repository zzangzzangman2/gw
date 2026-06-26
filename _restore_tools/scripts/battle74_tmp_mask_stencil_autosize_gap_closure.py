from __future__ import annotations

import csv
import json
from datetime import datetime
from pathlib import Path


PREFIX = "BATTLE_74_TMP_MASK_STENCIL_AUTOSIZE_GAP_CLOSURE_AFTER_B73_NO_PATCH"
B73_PREFIX = "BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH"
B54_PREFIX = "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD"
B70_PREFIX = "BATTLE_70_TRUE_ASPECT_BLACK_GUTTER_ROUTE_HUD_SOURCE_DELTA_NO_PATCH"


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


def write_json(path: Path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, ensure_ascii=False, indent=2), encoding="utf-8")


def norm_path(path: str) -> str:
    return (path or "").replace("\\", "/").strip().lower()


def bool_value(value) -> bool:
    if isinstance(value, bool):
        return value
    return str(value or "").strip().lower() in {"true", "1", "yes"}


def int_value(value) -> int:
    try:
        return int(str(value or "0").strip())
    except ValueError:
        return 0


def count_root_cmds(root: Path):
    root_cmd = len(list(root.glob("*.cmd")))
    direct_restore_cmd = len(list((root / "_restore_tools").glob("*.cmd"))) if (root / "_restore_tools").exists() else 0
    return {
        "rootCmdCount": root_cmd,
        "restoreToolsDirectCmdCount": direct_restore_cmd,
        "policyOk": root_cmd == 1 and direct_restore_cmd == 0,
    }


def owner_for_path(path: str):
    p = path.lower()
    if "btnauto" in p:
        return (
            "UI_NormalBattle.lua",
            "lines 86-110, 404-407, 441-445, 518-520, 1494+",
            "btnAuto TMP/mask state is downstream of original Lua button state and ModulesInit.ProcedureNormalBattle",
            "handler_or_xlua_required",
        )
    if "btntwospeed" in p:
        return (
            "UI_NormalBattle.lua",
            "lines 111-131, 410-417, 528-530, 683-687, 1193, 1278",
            "btnTwoSpeed labels/icons are speed state owned by ProcedureNormalBattle and Lua",
            "handler_or_xlua_required",
        )
    if "btnfastskill" in p:
        return (
            "UI_NormalBattle.lua",
            "lines 132-146, 533-535, 690-699, 1279",
            "btnFastSkill TMP/icon state is owned by ChangeGameFastSkill/CheckFastSkill runtime state",
            "handler_or_xlua_required",
        )
    if "btnskip" in p or "im_skip" in p or "/skip" in p:
        return (
            "UI_NormalBattle.lua",
            "lines 47-69, 81, 428-489, 522-525, 544, 838, 1246-1264, 1276",
            "skip UI labels/icons are battle-type/runtime controlled",
            "handler_or_xlua_required",
        )
    if "btnpause" in p:
        return (
            "UI_NormalBattle.lua",
            "lines 73-75, 562-620, 796-830, 1182-1184, 1275",
            "pause/quit labels and state are runtime dialog/state owned",
            "handler_or_xlua_required",
        )
    if "/root_top/topcenter" in p:
        return (
            "UI_NormalBattle.lua + ModulesInit.ProcedureNormalBattle",
            "lines 222, 467-489, 1194, 1218, 1224",
            "TopCenter enemy/player name, wave, and head-mask state are populated by runtime battle data",
            "handler_or_xlua_required",
        )
    if "/root_opra/" in p:
        return (
            "original prefab + UI_NormalBattle.lua",
            "BATTLE70 route HUD matrix; UI_NormalBattle ShowAllOperBtn/CheckPauseBtnState paths",
            "right rail active/state children require original runtime snapshot before patching",
            "runtime_snapshot_required",
        )
    if "/root_battle/" in p:
        return (
            "original prefab + UI_NormalBattle.lua",
            "BATTLE54 route/TMP/mask rows; BATTLE70 route HUD source-delta matrix",
            "battle HUD TMP/mask values may be static serialized source, but active chain and runtime values need snapshot",
            "runtime_snapshot_required",
        )
    return (
        "BATTLE54 serialized source row",
        "BATTLE54 TMP/mask audit row",
        "outside B73 focused HUD/right rail set or not enough owner evidence",
        "runtime_snapshot_required",
    )


def find_match(row_path: str, candidate_by_norm: dict[str, dict], candidate_norms: list[str]):
    n = norm_path(row_path)
    if n in candidate_by_norm:
        return "exact", candidate_by_norm[n]
    suffix_hits = [p for p in candidate_norms if p.endswith("/" + n.split("/", 1)[-1]) or n.endswith("/" + p.split("/", 1)[-1])]
    if suffix_hits:
        suffix_hits.sort(key=len)
        return "suffix", candidate_by_norm[suffix_hits[-1]]
    tail = "/".join(n.split("/")[-4:])
    if tail:
        tail_hits = [p for p in candidate_norms if p.endswith(tail)]
        if tail_hits:
            tail_hits.sort(key=len)
            return "tail4", candidate_by_norm[tail_hits[-1]]
    return "none", {}


def candidate_component_gap(match_row: dict, source_component_hint: str, want: str):
    if not match_row:
        return "source_row_not_present_in_b73_candidate_focus_or_path_missing"
    component_types = match_row.get("componentTypes", "")
    missing_count = int_value(match_row.get("missingScriptCount"))
    if want == "tmp":
        if bool_value(match_row.get("hasTmpText")):
            return "loaded_tmp_component_present"
        if "<missing>" in component_types or missing_count > 0:
            return "tmp_component_absent_or_unresolved_missing_script_in_candidate"
        return "tmp_component_absent_in_candidate"
    if bool_value(match_row.get("hasMask")) or bool_value(match_row.get("hasRectMask2D")):
        return "loaded_mask_component_present"
    if "<missing>" in component_types or missing_count > 0 or "serialized_missing_script" in source_component_hint:
        return "mask_component_absent_or_unresolved_missing_script_in_candidate"
    return "mask_component_absent_in_candidate"


def primary_classification(match_row: dict, loaded_component: bool, owner_class: str, gap: str):
    if not loaded_component:
        return "component_rehydration_required"
    if owner_class == "handler_or_xlua_required":
        return "handler_or_xlua_required"
    if owner_class == "runtime_snapshot_required":
        return "runtime_snapshot_required"
    return "runtime_snapshot_required"


def snapshot_fields(kind: str):
    base = [
        "activeSelf",
        "activeInHierarchy",
        "enabled",
        "parentActiveChain",
        "siblingIndex",
        "anchorMin",
        "anchorMax",
        "pivot",
        "sizeDelta",
        "anchoredPosition",
        "localScale",
        "componentTypes",
        "missingScriptCount",
    ]
    if kind == "tmp":
        return base + [
            "text",
            "tmpEnabled",
            "fontSize",
            "fontSizeBase",
            "enableAutoSizing",
            "fontSizeMin",
            "fontSizeMax",
            "characterSpacing",
            "characterHorizontalScale",
            "fontAssetRef",
            "sharedMaterialRef",
            "tmpMaterial",
            "tmpColor",
            "tmpAlpha",
            "tmpRaycastTarget",
        ]
    return base + [
        "maskEnabled",
        "showMaskGraphic",
        "rectMaskEnabled",
        "maskComponentType",
        "maskScriptRef",
        "graphicEnabled",
        "graphicRaycastTarget",
        "graphicMaterial",
        "imageSprite",
        "canvasRendererCull",
        "stencilMaterialState",
    ]


def main():
    root = Path(__file__).resolve().parents[2]
    reports = root / "reports" / "battle"
    b73_result_path = reports / f"{B73_PREFIX}_RESULT.json"
    b73_component_path = reports / f"{B73_PREFIX}_CANDIDATE_SCENE_HUD_RIGHT_RAIL_COMPONENT_STATE_MATRIX.csv"
    b54_tmp_path = reports / f"{B54_PREFIX}_TMP_TEXT.csv"
    b54_mask_path = reports / f"{B54_PREFIX}_MASKS.csv"
    b54_routes_path = reports / f"{B54_PREFIX}_ROUTES.csv"
    b70_route_path = reports / f"{B70_PREFIX}_ROUTE_HUD_RIGHT_RAIL_SOURCE_DELTA_MATRIX.csv"

    b73_result = read_json(b73_result_path, {})
    b73_rows = read_csv(b73_component_path)
    b54_tmp_rows = read_csv(b54_tmp_path)
    b54_mask_rows = read_csv(b54_mask_path)
    b54_routes = read_csv(b54_routes_path)
    b70_routes = read_csv(b70_route_path)

    candidate_by_norm = {norm_path(r.get("path")): r for r in b73_rows if r.get("path")}
    candidate_norms = list(candidate_by_norm.keys())
    route_norms = {norm_path(r.get("path") or r.get("routePath")) for r in b54_routes}
    b70_norms = {norm_path(r.get("routePath")): r for r in b70_routes if r.get("routePath")}

    tmp_map_rows = []
    mask_map_rows = []
    classification_rows = []
    snapshot_rows = []

    def add_snapshot(kind: str, source_row: dict, match_row: dict, owner, classification: str):
        source_path = source_row.get("path", "")
        for field in snapshot_fields(kind):
            current = match_row.get(field, "") if match_row else ""
            if not current:
                current = source_row.get(field, "")
            snapshot_rows.append(
                {
                    "kind": kind,
                    "objectPath": source_path,
                    "fieldName": field,
                    "currentCandidateValue": current,
                    "sourceValue": source_row.get(field, ""),
                    "requiredSnapshotOwner": owner[0],
                    "requiredRuntimeObjectOrModule": "original runtime UI scene after UI_NormalBattle.Open / ModulesInit.ProcedureNormalBattle init",
                    "whyRequired": owner[2],
                    "classification": classification,
                    "allowedAcquisition": "approved runtime snapshot/dump only; no APK/emulator instrumentation in BATTLE74",
                    "patchUnlockedBy": "source-backed runtime snapshot plus resolved TMP/Mask component type/script evidence",
                }
            )

    for source in b54_tmp_rows:
        path = source.get("path", "")
        match_kind, match = find_match(path, candidate_by_norm, candidate_norms)
        owner = owner_for_path(path)
        gap = candidate_component_gap(match, source.get("componentTypes", ""), "tmp")
        loaded = bool_value(match.get("hasTmpText")) if match else False
        classification = primary_classification(match, loaded, owner[3], gap)
        route_known = norm_path(path) in route_norms or norm_path(path) in b70_norms
        row = {
            "sourceKind": "tmp",
            "sourcePath": path,
            "sourceName": source.get("name", ""),
            "sourceActiveSelf": source.get("activeSelf", ""),
            "sourceActiveInHierarchy": source.get("activeInHierarchy", ""),
            "sourceSiblingIndex": source.get("siblingIndex", ""),
            "sourceAnchoredPosition": source.get("anchoredPosition", ""),
            "sourceLocalScale": source.get("localScale", ""),
            "sourceSizeDelta": source.get("sizeDelta", ""),
            "sourceText": source.get("text", ""),
            "sourceFontSize": source.get("fontSize", ""),
            "sourceFontSizeBase": source.get("fontSizeBase", ""),
            "sourceEnableAutoSizing": source.get("enableAutoSizing", ""),
            "sourceFontSizeMin": source.get("fontSizeMin", ""),
            "sourceFontSizeMax": source.get("fontSizeMax", ""),
            "sourceCharacterSpacing": source.get("characterSpacing", ""),
            "sourceCharacterHorizontalScale": source.get("characterHorizontalScale", ""),
            "sourceFontAssetRef": source.get("fontAssetRef", ""),
            "sourceSharedMaterialRef": source.get("sharedMaterialRef", ""),
            "matchKind": match_kind,
            "candidatePath": match.get("path", ""),
            "candidateActiveSelf": match.get("activeSelf", ""),
            "candidateActiveInHierarchy": match.get("activeInHierarchy", ""),
            "candidateMissingScriptCount": match.get("missingScriptCount", ""),
            "candidateComponentTypes": match.get("componentTypes", ""),
            "candidateHasTmpText": match.get("hasTmpText", ""),
            "candidateTmpText": match.get("tmpText", ""),
            "candidateTmpFontSize": match.get("tmpFontSize", ""),
            "candidateTmpEnableAutoSizing": match.get("tmpEnableAutoSizing", ""),
            "candidateTmpFontSizeMin": match.get("tmpFontSizeMin", ""),
            "candidateTmpFontSizeMax": match.get("tmpFontSizeMax", ""),
            "candidateTmpCharacterSpacing": match.get("tmpCharacterSpacing", ""),
            "candidateTmpFont": match.get("tmpFont", ""),
            "candidateTmpMaterial": match.get("tmpMaterial", ""),
            "candidateLoadedComponent": str(loaded),
            "componentGap": gap,
            "routeKnownInB54OrB70": str(route_known),
            "sourceOwner": owner[0],
            "sourceEvidence": owner[1],
            "ownershipRationale": owner[2],
            "primaryClassification": classification,
            "patchDecision": "no_patch_in_battle74",
        }
        tmp_map_rows.append(row)
        classification_rows.append(row)
        add_snapshot("tmp", source, match, owner, classification)

    for source in b54_mask_rows:
        path = source.get("path", "")
        match_kind, match = find_match(path, candidate_by_norm, candidate_norms)
        owner = owner_for_path(path)
        hint = source.get("componentTypes", "") + " " + source.get("maskComponentType", "")
        gap = candidate_component_gap(match, hint, "mask")
        loaded = bool_value(match.get("hasMask")) or bool_value(match.get("hasRectMask2D")) if match else False
        classification = primary_classification(match, loaded, owner[3], gap)
        route_known = norm_path(path) in route_norms or norm_path(path) in b70_norms
        row = {
            "sourceKind": "mask",
            "sourcePath": path,
            "sourceName": source.get("name", ""),
            "sourceActiveSelf": source.get("activeSelf", ""),
            "sourceActiveInHierarchy": source.get("activeInHierarchy", ""),
            "sourceSiblingIndex": source.get("siblingIndex", ""),
            "sourceAnchoredPosition": source.get("anchoredPosition", ""),
            "sourceLocalScale": source.get("localScale", ""),
            "sourceSizeDelta": source.get("sizeDelta", ""),
            "sourceHasMaskComponent": source.get("hasMaskComponent", ""),
            "sourceMaskComponentType": source.get("maskComponentType", ""),
            "sourceShowMaskGraphic": source.get("showMaskGraphic", ""),
            "sourceMaskScriptRef": source.get("maskScriptRef", ""),
            "sourceEvidence": source.get("evidence", ""),
            "matchKind": match_kind,
            "candidatePath": match.get("path", ""),
            "candidateActiveSelf": match.get("activeSelf", ""),
            "candidateActiveInHierarchy": match.get("activeInHierarchy", ""),
            "candidateMissingScriptCount": match.get("missingScriptCount", ""),
            "candidateComponentTypes": match.get("componentTypes", ""),
            "candidateHasMask": match.get("hasMask", ""),
            "candidateMaskEnabled": match.get("maskEnabled", ""),
            "candidateMaskShowMaskGraphic": match.get("maskShowMaskGraphic", ""),
            "candidateHasRectMask2D": match.get("hasRectMask2D", ""),
            "candidateRectMaskEnabled": match.get("rectMaskEnabled", ""),
            "candidateHasMaskNamedComponent": match.get("hasMaskNamedComponent", ""),
            "candidateLoadedComponent": str(loaded),
            "componentGap": gap,
            "routeKnownInB54OrB70": str(route_known),
            "sourceOwner": owner[0],
            "ownerSourceEvidence": owner[1],
            "ownershipRationale": owner[2],
            "primaryClassification": classification,
            "patchDecision": "no_patch_in_battle74",
        }
        mask_map_rows.append(row)
        classification_rows.append(row)
        add_snapshot("mask", source, match, owner, classification)

    def count_rows(rows, pred):
        return sum(1 for r in rows if pred(r))

    tmp_mapped = count_rows(tmp_map_rows, lambda r: r["matchKind"] != "none")
    mask_mapped = count_rows(mask_map_rows, lambda r: r["matchKind"] != "none")
    loaded_tmp = count_rows(tmp_map_rows, lambda r: bool_value(r["candidateLoadedComponent"]))
    loaded_mask = count_rows(mask_map_rows, lambda r: bool_value(r["candidateLoadedComponent"]))
    component_rehydrate = count_rows(classification_rows, lambda r: r["primaryClassification"] == "component_rehydration_required")
    runtime_snapshot = len(classification_rows)
    handler_or_xlua = count_rows(classification_rows, lambda r: r.get("sourceOwner", "").startswith("UI_NormalBattle") or "ModulesInit" in r.get("sourceOwner", ""))

    decision_rows = [
        {
            "decisionCategory": "source_backed_static_patch_candidate",
            "count": 0,
            "evidence": "B54 serialized TMP/mask rows exist, but B73 candidate does not prove loaded component/script/runtime state parity",
            "decision": "no_static_tmp_mask_patch_in_battle74",
            "nextAction": "collect approved runtime snapshot and resolve component/script rehydration evidence first",
        },
        {
            "decisionCategory": "component_rehydration_required",
            "count": component_rehydrate,
            "evidence": "B54 source rows map to B73 absent/missing-script TMP/Mask components or fall outside B73 focused component export",
            "decision": "blocked_pending_tmp_mask_component_type_script_rehydration",
            "nextAction": "trace original TMP/Mask script/component persistence and runtime loaded type state",
        },
        {
            "decisionCategory": "runtime_snapshot_required",
            "count": runtime_snapshot,
            "evidence": "all B54 TMP/mask source rows still need active chain, sibling, material/stencil, autosize, and parent state from original runtime after component rehydration",
            "decision": "blocked_pending_tmp_mask_runtime_snapshot",
            "nextAction": "capture exact runtime field values after UI_NormalBattle.Open",
        },
        {
            "decisionCategory": "handler_or_xlua_required",
            "count": handler_or_xlua,
            "evidence": "TopCenter and operation button text/mask state is owned by UI_NormalBattle.lua / ModulesInit.ProcedureNormalBattle",
            "decision": "blocked_pending_xlua_gameentry_modulesinit",
            "nextAction": "recover approved original xLua/GameEntry runtime or provide original runtime snapshot",
        },
        {
            "decisionCategory": "forbidden_guess",
            "count": 1,
            "evidence": "Coordinate-only or visual-only TMP/mask/stencil patch would invent runtime state",
            "decision": "do_not_patch_from_reference_image_only",
            "nextAction": "keep no-patch guardrail",
        },
    ]

    out_tmp = reports / f"{PREFIX}_B54_TMP_SOURCE_ROWS_MAPPED_TO_B73_CANDIDATE_COMPONENT_STATE.csv"
    out_mask = reports / f"{PREFIX}_B54_MASK_STENCIL_SOURCE_ROWS_MAPPED_TO_B73_CANDIDATE_COMPONENT_STATE.csv"
    out_class = reports / f"{PREFIX}_TMP_MASK_MISSING_COMPONENT_AND_RUNTIME_OWNERSHIP_CLASSIFICATION_MATRIX.csv"
    out_snap = reports / f"{PREFIX}_TMP_MASK_STENCIL_RUNTIME_SNAPSHOT_FIELD_SPEC.csv"
    out_decision = reports / f"{PREFIX}_PATCH_CANDIDATE_VS_BLOCKER_DECISION_MATRIX.csv"
    out_json = reports / f"{PREFIX}_RESULT.json"
    out_md = reports / f"{PREFIX}_RESULT.md"

    tmp_fields = list(tmp_map_rows[0].keys()) if tmp_map_rows else []
    mask_fields = list(mask_map_rows[0].keys()) if mask_map_rows else []
    class_fields = sorted({k for row in classification_rows for k in row.keys()})
    snap_fields = list(snapshot_rows[0].keys()) if snapshot_rows else []
    decision_fields = list(decision_rows[0].keys())

    write_csv(out_tmp, tmp_map_rows, tmp_fields)
    write_csv(out_mask, mask_map_rows, mask_fields)
    write_csv(out_class, classification_rows, class_fields)
    write_csv(out_snap, snapshot_rows, snap_fields)
    write_csv(out_decision, decision_rows, decision_fields)

    result = {
        "task": PREFIX,
        "generatedAt": datetime.now().replace(microsecond=0).isoformat(),
        "restoredClaim": False,
        "playableClaim": False,
        "patchApplied": False,
        "sceneSaved": False,
        "canonicalSceneOverwritten": False,
        "candidateSceneUsed": True,
        "candidateScenePath": b73_result.get("candidateScenePath", str(root / "girlswar_battle_unity" / "Assets" / "Scenes" / "Battle72Map11003TrueAspectReprojectionPersistedCandidate.unity")),
        "packageImported": False,
        "manifestModified": False,
        "runtimeInstrumentationUsed": False,
        "hudRoutePatched": False,
        "tmpMaskPatched": False,
        "cardPayloadPatched": False,
        "actorPayloadPatched": False,
        "battle73ResultUsed": True,
        "b54TmpRowsReviewed": len(b54_tmp_rows),
        "b54MaskRowsReviewed": len(b54_mask_rows),
        "b73CandidateRowsReviewed": len(b73_rows),
        "tmpRowsMappedToCandidate": tmp_mapped,
        "maskRowsMappedToCandidate": mask_mapped,
        "candidateLoadedTmpComponentRows": loaded_tmp,
        "candidateLoadedMaskComponentRows": loaded_mask,
        "missingScriptOrComponentRows": component_rehydrate,
        "sourceBackedStaticPatchCandidates": 0,
        "runtimeSnapshotRequiredRows": runtime_snapshot,
        "handlerOrXluaRequiredRows": handler_or_xlua,
        "componentRehydrationRequiredRows": component_rehydrate,
        "forbiddenGuessRows": 1,
        "tmpMaskRuntimeSnapshotFieldsCount": len(snapshot_rows),
        "recommendedNextAction": "COLLECT_APPROVED_ORIGINAL_RUNTIME_TMP_MASK_STENCIL_SNAPSHOT_AND_RESOLVE_TMP_MASK_COMPONENT_REHYDRATION_BEFORE_PATCH",
        "nextBlocker": "TMP_MASK_STENCIL_COMPONENT_REHYDRATION_AND_ORIGINAL_RUNTIME_SNAPSHOT_REQUIRED_NO_STATIC_PATCH",
        "guardrailsTouched": [
            "no_scene_save",
            "no_canonical_scene_overwrite",
            "no_package_import",
            "no_manifest_edit",
            "no_xlua_or_handler_patch",
            "no_tmp_mask_stencil_patch",
            "no_hud_route_patch",
            "no_card_or_actor_payload_patch",
            "no_fake_hud_card_icon_text_actor_effect",
            "no_screenshot_or_atlas_paste_as_asset",
            "no_coordinate_only_success",
            "no_runtime_instrumentation",
        ],
        "commandPolicy": count_root_cmds(root),
        "inputs": {
            "battle73Result": str(b73_result_path),
            "battle73ComponentCsv": str(b73_component_path),
            "battle54TmpCsv": str(b54_tmp_path),
            "battle54MaskCsv": str(b54_mask_path),
            "battle54RoutesCsv": str(b54_routes_path),
            "battle70RouteHudCsv": str(b70_route_path),
        },
        "outputs": {
            "tmpMappedCsv": str(out_tmp),
            "maskMappedCsv": str(out_mask),
            "classificationCsv": str(out_class),
            "snapshotSpecCsv": str(out_snap),
            "decisionCsv": str(out_decision),
        },
        "notes": [
            "B73 zero TMP/mask count means no loaded TMP_Text/Mask/RectMask2D components were detected in the B73 focused candidate component export.",
            "B54 still provides source serialized TMP rows and mask-ish rows; B74 maps those source rows to B73 observations and classifies missing loaded components separately.",
            "runtimeSnapshotRequiredRows and handlerOrXluaRequiredRows are blocker ownership counts, not exclusive primary classifications and not safe patch counts.",
        ],
    }
    write_json(out_json, result)

    md = f"""# {PREFIX}

## Result
- restoredClaim: false
- playableClaim: false
- patchApplied: false
- sceneSaved: false
- canonicalSceneOverwritten: false
- candidateSceneUsed: true
- battle73ResultUsed: true

## Why BATTLE73 had zero TMP/Mask rows
BATTLE73 counted loaded candidate components only. Its focused B72 candidate-scene export reviewed {len(b73_rows)} HUD/right-rail rows, but detected `candidateLoadedTmpComponentRows={loaded_tmp}` and `candidateLoadedMaskComponentRows={loaded_mask}` after mapping B54 source evidence. B54 still contains serialized TMP source rows and mask-ish source rows; the gap is component/script rehydration and runtime state, not permission to patch from coordinates.

## Counts
- B54 TMP rows reviewed: {len(b54_tmp_rows)}
- B54 mask/stencil rows reviewed: {len(b54_mask_rows)}
- B73 candidate rows reviewed: {len(b73_rows)}
- TMP rows mapped to B73 candidate: {tmp_mapped}
- Mask rows mapped to B73 candidate: {mask_mapped}
- Missing script/component rows: {component_rehydrate}
- Runtime snapshot required rows: {runtime_snapshot}
- Handler/xLua owned rows: {handler_or_xlua}
- Safe source-backed static TMP/mask patch candidates: 0
- TMP/mask runtime snapshot fields: {len(snapshot_rows)}

## Decision
No TMP/mask/stencil/autosize patch was applied. B54 source rows are not enough by themselves because B73 candidate observations show absent or unresolved loaded components, and many visible states are owned by `UI_NormalBattle.lua` / `ModulesInit.ProcedureNormalBattle` runtime state.

## Next Blocker
`TMP_MASK_STENCIL_COMPONENT_REHYDRATION_AND_ORIGINAL_RUNTIME_SNAPSHOT_REQUIRED_NO_STATIC_PATCH`

## Outputs
- `{out_tmp}`
- `{out_mask}`
- `{out_class}`
- `{out_snap}`
- `{out_decision}`
"""
    out_md.write_text(md, encoding="utf-8")


if __name__ == "__main__":
    main()
