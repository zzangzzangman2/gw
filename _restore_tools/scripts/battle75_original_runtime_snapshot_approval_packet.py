from __future__ import annotations

import csv
import json
from collections import defaultdict
from datetime import datetime
from pathlib import Path


PREFIX = "BATTLE_75_ORIGINAL_RUNTIME_SNAPSHOT_APPROVAL_PACKET_FOR_UI_NORMALBATTLE_ROUTE_TMP_MASK_HANDLER_AFTER_B74_NO_EXECUTION_NO_PATCH"
B73_PREFIX = "BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH"
B74_PREFIX = "BATTLE_74_TMP_MASK_STENCIL_AUTOSIZE_GAP_CLOSURE_AFTER_B73_NO_PATCH"
B59_PREFIX = "BATTLE_59_AUDIT_LOCAL_SOURCE_BACKED_XLUA_RUNTIME_RECOVERY_FEASIBILITY_AND_BOOTSTRAP_REQUIREMENTS_NO_STUB_NO_EXTERNAL"
B58_PREFIX = "BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER"


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


def norm(value: str) -> str:
    return (value or "").replace("\\", "/").strip().lower()


def first_nonempty(*values):
    for value in values:
        if value is not None and str(value).strip() != "":
            return value
    return ""


def join_unique(values, sep=" | "):
    seen = []
    for value in values:
        s = str(value or "").strip()
        if s and s not in seen:
            seen.append(s)
    return sep.join(seen)


def count_root_cmds(root: Path):
    root_cmd = len(list(root.glob("*.cmd")))
    direct_restore_cmd = len(list((root / "_restore_tools").glob("*.cmd"))) if (root / "_restore_tools").exists() else 0
    return {
        "rootCmdCount": root_cmd,
        "restoreToolsDirectCmdCount": direct_restore_cmd,
        "policyOk": root_cmd == 1 and direct_restore_cmd == 0,
    }


def field_category(field_name: str, object_path: str = ""):
    f = (field_name or "").lower()
    p = (object_path or "").lower()
    if p.startswith("runtime/") or any(x in p for x in ["xlua", "luamanager", "gameentry", "modulesinit", "procedurenormalbattle", "luaform", "luaunit"]):
        return "handler_lua_lifecycle"
    if any(x in f for x in ["luaf", "lua", "handler", "onclick", "uiev", "delegate", "lifecycle", "modulesinit", "procedure"]):
        return "handler_lua_lifecycle"
    if f in {"activeself", "activeinhierarchy", "enabled", "parentactivechain"}:
        return "active_chain"
    if "sibling" in f or "order" in f:
        return "sibling_order"
    if any(x in f for x in ["anchor", "pivot", "sizedelta", "anchoredposition", "localposition", "localscale", "rect", "offset"]):
        return "rect_transform"
    if "canvasgroup" in f or "canvasscaler" in f or f.startswith("canvas") or "scalefactor" in f:
        return "canvas_canvas_scaler_canvas_group"
    if any(x in f for x in ["graphic", "image", "button", "raycast", "targetgraphic", "sprite", "color", "alpha", "cull"]):
        return "graphic_image_button_raycast"
    if any(x in f for x in ["tmp", "text", "font", "autosiz", "characterspacing", "wordspacing", "linespacing", "alignment"]):
        return "tmp_autosize_font_material"
    if any(x in f for x in ["mask", "rectmask", "stencil", "materialforrendering"]):
        return "mask_rectmask_stencil_material"
    if any(x in p for x in ["herolistcontainer", "ui_battleitemfly", "normalbattle_heroitem", "trans_battle_box"]):
        return "battle_payload_related_ui"
    if "component" in f or "missingscript" in f:
        return "component_rehydration"
    return "other_runtime_state"


def requirement_level(category: str, source_classifications: set[str], field_name: str):
    f = field_name.lower()
    if "component_rehydration_required" in source_classifications:
        return "blocked-by-component-rehydration"
    if category in {"handler_lua_lifecycle", "active_chain", "sibling_order", "rect_transform", "canvas_canvas_scaler_canvas_group", "graphic_image_button_raycast", "tmp_autosize_font_material", "mask_rectmask_stencil_material"}:
        return "required"
    if f in {"worldposition", "rect", "offsetmin", "offsetmax", "tmpwordspacing", "tmplineSpacing".lower()}:
        return "nice-to-have"
    return "required"


def unlock_category(category: str, object_path: str):
    p = object_path.lower()
    if category == "handler_lua_lifecycle":
        return "confirm_original_handler_xlua_runtime_state_only_not_static_replacement"
    if category in {"tmp_autosize_font_material", "mask_rectmask_stencil_material", "component_rehydration"}:
        return "unlock_tmp_mask_component_rehydration_review"
    if any(x in p for x in ["herolistcontainer", "ui_battleitemfly", "normalbattle_heroitem", "trans_battle_box"]):
        return "separate_payload_or_card_ui_blocker_do_not_mix_into_hud_patch"
    if category in {"active_chain", "sibling_order", "rect_transform", "canvas_canvas_scaler_canvas_group", "graphic_image_button_raycast"}:
        return "unlock_route_hud_static_scene_patch_review_later"
    return "supporting_runtime_context"


def source_static_classification(category: str, requirement: str, source_classifications: set[str], owner: str):
    if requirement == "blocked-by-component-rehydration":
        return "component_rehydration_required"
    if "handler" in owner.lower() or "lua" in owner.lower() or category == "handler_lua_lifecycle":
        return "handler_or_xlua_required"
    if category == "battle_payload_related_ui":
        return "blocked_by_payload"
    return "runtime_snapshot_required"


def add_field(bucket: dict, object_path: str, field_name: str, source: str, current: str, source_value: str, owner: str, runtime_object: str, why: str, allowed: str, unlocked_by: str, classification: str):
    if not object_path or not field_name:
        return
    key = (norm(object_path), field_name.strip())
    item = bucket.setdefault(
        key,
        {
            "objectPath": object_path,
            "fieldName": field_name.strip(),
            "sources": [],
            "currentCandidateValues": [],
            "sourceValues": [],
            "owners": [],
            "runtimeObjects": [],
            "whyRequired": [],
            "allowedAcquisition": [],
            "patchUnlockedBy": [],
            "sourceClassifications": set(),
        },
    )
    item["sources"].append(source)
    item["currentCandidateValues"].append(current)
    item["sourceValues"].append(source_value)
    item["owners"].append(owner)
    item["runtimeObjects"].append(runtime_object)
    item["whyRequired"].append(why)
    item["allowedAcquisition"].append(allowed)
    item["patchUnlockedBy"].append(unlocked_by)
    if classification:
        item["sourceClassifications"].add(classification)


def build_hook_candidates():
    return [
        {
            "hookId": "H01",
            "sourceBackedLocation": "YouYou.LuaManager.GetLuaBuff",
            "evidence": "BATTLE59 bootstrap graph: LuaManager.MyLoader/GetLuaBuff/LoadLuaAssetBundle required for decoded UI Lua",
            "capturePoint": "return bytes/module name for UI_NormalBattle and dependency modules",
            "fieldsToDump": "moduleName,luaAssetBundleName,byteLength,loadSuccess,error",
            "unblocks": "proves original Lua source/load path before lifecycle snapshot",
            "approvalRequired": "true",
            "executionInBattle75": "false",
        },
        {
            "hookId": "H02",
            "sourceBackedLocation": "YouYou.LuaManager.LoadUIScript",
            "evidence": "BATTLE59 bootstrap graph rows 04-06",
            "capturePoint": "when UI_NormalBattle / UI_Battle3DUI / UI_BattleBoxPage scripts are loaded",
            "fieldsToDump": "scriptPath,moduleName,luaTableExists,OnInitExists,OpenExists,error",
            "unblocks": "validates original UI module load and lifecycle entry availability",
            "approvalRequired": "true",
            "executionInBattle75": "false",
        },
        {
            "hookId": "H03",
            "sourceBackedLocation": "YouYou.LuaForm OnInit/Open for CanvasLuaStateHUD_01_ui_normalbattle",
            "evidence": "BATTLE51/B58 bridge rows present but lifecycle executed rows remain 0",
            "capturePoint": "after LuaForm invokes UI_NormalBattle OnInit and Open",
            "fieldsToDump": "luaScriptPath,luaTable,OnInitCalled,OpenCalled,binderKeys,exception",
            "unblocks": "original handler closure binding ownership and route active state snapshot",
            "approvalRequired": "true",
            "executionInBattle75": "false",
        },
        {
            "hookId": "H04",
            "sourceBackedLocation": "UI_NormalBattle.OnInit / Open / Refresh",
            "evidence": "BATTLE50/B58 UI_NormalBattle handler source trace",
            "capturePoint": "post Open/Refresh, before player input",
            "fieldsToDump": "root_battle/root_top/root_opra active chain, TopCenter state, button children, TMP and mask states",
            "unblocks": "route/HUD/right rail static review after runtime state is known",
            "approvalRequired": "true",
            "executionInBattle75": "false",
        },
        {
            "hookId": "H05",
            "sourceBackedLocation": "UI_NormalBattle.ShowAllOperBtn",
            "evidence": "BATTLE73 source ownership trace for root_opra/right rail",
            "capturePoint": "after method returns",
            "fieldsToDump": "btnAuto,btnBuff,btnTwoSpeed,btnFastSkill,btnSkip,btnPause active/interactable/on-off/new/lock children",
            "unblocks": "right rail active/sibling/button state patch review",
            "approvalRequired": "true",
            "executionInBattle75": "false",
        },
        {
            "hookId": "H06",
            "sourceBackedLocation": "UI_NormalBattle.CheckPauseBtnState",
            "evidence": "BATTLE73 source ownership trace for skip/pause",
            "capturePoint": "after method returns",
            "fieldsToDump": "btnPause/btnSkip visible children, labels, lock/new state, runtime battle type flags",
            "unblocks": "pause/skip route state patch review",
            "approvalRequired": "true",
            "executionInBattle75": "false",
        },
        {
            "hookId": "H07",
            "sourceBackedLocation": "UI_NormalBattle TopCenter update paths",
            "evidence": "BATTLE73/B74 TopCenter handler/xLua-required rows",
            "capturePoint": "after enemy/player top info populated",
            "fieldsToDump": "EnemyInfo/PlayerInfo text, mask, head icon, active chain, sibling, TMP values, mask/stencil state",
            "unblocks": "TopCenter TMP/mask runtime snapshot and component rehydration review",
            "approvalRequired": "true",
            "executionInBattle75": "false",
        },
        {
            "hookId": "H08",
            "sourceBackedLocation": "ModulesInit.ProcedureNormalBattle",
            "evidence": "BATTLE50/B58/B59 ProcedureNormalBattle dependency graph",
            "capturePoint": "after ModulesInit initialized for normal battle",
            "fieldsToDump": "isAuto,gameSpeed,fastSkill,round,wave,battleType,canPause,canSkip,method availability",
            "unblocks": "handler state cannot be statically replaced; confirms original source behavior",
            "approvalRequired": "true",
            "executionInBattle75": "false",
        },
        {
            "hookId": "H09",
            "sourceBackedLocation": "Unity scene after UI_NormalBattle.Open one frame wait",
            "evidence": "BATTLE73/B74 candidate scene field specs",
            "capturePoint": "hierarchy dump of B72/Battle HUD roots after original runtime open",
            "fieldsToDump": "deduplicated field checklist objectPath+fieldName values",
            "unblocks": "primary approved runtime snapshot packet for static review",
            "approvalRequired": "true",
            "executionInBattle75": "false",
        },
        {
            "hookId": "H10",
            "sourceBackedLocation": "Unity UI components material/stencil inspection",
            "evidence": "BATTLE74 TMP/mask/stencil gap closure",
            "capturePoint": "after Canvas update and before capture",
            "fieldsToDump": "TMP font/material, materialForRendering, stencil ID/compare/op if observable, Mask/RectMask2D enabled/showMaskGraphic",
            "unblocks": "TMP/mask/stencil component rehydration review",
            "approvalRequired": "true",
            "executionInBattle75": "false",
        },
        {
            "hookId": "H11",
            "sourceBackedLocation": "Button/UIEventListener click binding table",
            "evidence": "BATTLE58 active/interactable buttons 5/5 but listener/delegate rows 0",
            "capturePoint": "after UI_NormalBattle and UI_BattleBoxPage bind original closures",
            "fieldsToDump": "buttonPath,onClick counts,UIEventListener delegate present,closure source,function name,bound target",
            "unblocks": "confirms original handler binding; no fake handler replacement",
            "approvalRequired": "true",
            "executionInBattle75": "false",
        },
        {
            "hookId": "H12",
            "sourceBackedLocation": "GameEntry.Lua / YouYou.LuaManager service availability",
            "evidence": "BATTLE59 executable xLua/GameEntry/LuaManager candidate 0",
            "capturePoint": "bootstrap service state before UI load",
            "fieldsToDump": "GameEntry exists, LuaManager exists, LuaEnv exists, loaders registered, error chain",
            "unblocks": "decides whether runtime recovery path exists or external approval is required",
            "approvalRequired": "true",
            "executionInBattle75": "false",
        },
    ]


def main():
    root = Path(__file__).resolve().parents[2]
    reports = root / "reports" / "battle"

    b73_result = read_json(reports / f"{B73_PREFIX}_RESULT.json", {})
    b74_result = read_json(reports / f"{B74_PREFIX}_RESULT.json", {})
    b59_result = read_json(reports / f"{B59_PREFIX}_RESULT.json", {})
    b58_result = read_json(reports / f"{B58_PREFIX}_RESULT.json", {})

    b73_fields = read_csv(reports / f"{B73_PREFIX}_MINIMAL_RUNTIME_SNAPSHOT_FIELD_SPEC.csv")
    b74_fields = read_csv(reports / f"{B74_PREFIX}_TMP_MASK_STENCIL_RUNTIME_SNAPSHOT_FIELD_SPEC.csv")
    b59_bootstrap = read_csv(reports / f"{B59_PREFIX}_GAMEENTRY_LUAMANAGER_MODULESINIT_BOOTSTRAP_REQUIREMENT_GRAPH.csv")
    b59_handler = read_csv(reports / f"{B59_PREFIX}_ORIGINAL_HANDLER_BINDING_FEASIBILITY_DECISION_MATRIX.csv")
    b58_buttons = read_csv(reports / f"{B58_PREFIX}_HUD_BUTTON_HANDLER_AUDIT.csv")

    bucket: dict[tuple[str, str], dict] = {}
    for row in b73_fields:
        add_field(
            bucket,
            row.get("objectPath", ""),
            row.get("fieldName", ""),
            "BATTLE73",
            row.get("currentCandidateValue", ""),
            "",
            row.get("requiredSnapshotOwner", ""),
            row.get("requiredRuntimeObjectOrModule", ""),
            row.get("whyRequired", ""),
            row.get("allowedAcquisition", ""),
            row.get("patchUnlockedBy", ""),
            "runtime_snapshot_required",
        )

    for row in b74_fields:
        add_field(
            bucket,
            row.get("objectPath", ""),
            row.get("fieldName", ""),
            "BATTLE74",
            row.get("currentCandidateValue", ""),
            row.get("sourceValue", ""),
            row.get("requiredSnapshotOwner", ""),
            row.get("requiredRuntimeObjectOrModule", ""),
            row.get("whyRequired", ""),
            row.get("allowedAcquisition", ""),
            row.get("patchUnlockedBy", ""),
            row.get("classification", ""),
        )

    # Add small, explicit lifecycle fields from B58/B59 so the packet covers handler ownership,
    # without pretending the restored editor can execute the original runtime.
    handler_rows_added = 0
    seen_button_phase = set()
    for row in b58_buttons:
        button_path = row.get("buttonPath", "")
        button_name = row.get("buttonName", "")
        if not button_path or button_name in seen_button_phase:
            continue
        seen_button_phase.add(button_name)
        for field in [
            "onClickPersistentCount",
            "onClickRuntimeCount",
            "onClickKnownCount",
            "eventTriggerCount",
            "uiEventListenerPresent",
            "uiEventListenerHasDelegate",
            "handlerBound",
            "luaLifecycleExecuted",
            "gameplayHandlerExecution",
        ]:
            add_field(
                bucket,
                button_path,
                field,
                "BATTLE58",
                row.get(field, ""),
                "",
                "UI_NormalBattle.lua / UI_BattleBoxPage.lua + xLua bridge",
                "original runtime after LuaForm/LuaUnit Open and closure binding",
                f"{button_name} original handler binding is source-backed but unexecuted in restored project",
                "approved runtime snapshot/dump only; no fake/no-op handler",
                "source-backed original handler closure binding evidence",
                "handler_or_xlua_required",
            )
            handler_rows_added += 1

    for row in b59_bootstrap:
        node = row.get("node", "")
        if not node:
            continue
        for field in ["available", "initialized", "error", "requiredBy"]:
            add_field(
                bucket,
                f"runtime/{node}",
                field,
                "BATTLE59",
                row.get("localEvidenceStatus", "") if field == "available" else row.get("requiredBy", "") if field == "requiredBy" else "",
                "",
                "GameEntry/LuaManager/ModulesInit bootstrap",
                "original runtime bootstrap before UI_NormalBattle.Open",
                row.get("purpose", ""),
                "approved source-backed runtime recovery or approved runtime dump only",
                "confirms whether original Lua lifecycle can run; cannot be replaced by static patch",
                "handler_or_xlua_required",
            )
            handler_rows_added += 1

    checklist = []
    for item in bucket.values():
        category = field_category(item["fieldName"], item["objectPath"])
        requirement = requirement_level(category, item["sourceClassifications"], item["fieldName"])
        owner = join_unique(item["owners"])
        static_class = source_static_classification(category, requirement, item["sourceClassifications"], owner)
        checklist.append(
            {
                "objectPath": item["objectPath"],
                "fieldName": item["fieldName"],
                "category": category,
                "requirementLevel": requirement,
                "currentCandidateValue": first_nonempty(*item["currentCandidateValues"]),
                "sourceValue": first_nonempty(*item["sourceValues"]),
                "runtimeValueRequired": "",
                "sourceReports": join_unique(item["sources"], ";"),
                "requiredSnapshotOwner": owner,
                "requiredRuntimeObjectOrModule": join_unique(item["runtimeObjects"]),
                "whyRequired": join_unique(item["whyRequired"]),
                "allowedAcquisition": join_unique(item["allowedAcquisition"]),
                "patchUnlockedBy": join_unique(item["patchUnlockedBy"]),
                "unblockCategory": unlock_category(category, item["objectPath"]),
                "staticVsRuntimeClassification": static_class,
                "safeToPatchNow": "false",
            }
        )

    checklist.sort(key=lambda r: (r["category"], r["objectPath"], r["fieldName"]))

    hooks = build_hook_candidates()

    unblock_rows = []
    for row in checklist:
        unblock_rows.append(
            {
                "objectPath": row["objectPath"],
                "fieldName": row["fieldName"],
                "category": row["category"],
                "requirementLevel": row["requirementLevel"],
                "unblockCategory": row["unblockCategory"],
                "unlocksRouteHudStaticReview": str(row["unblockCategory"] == "unlock_route_hud_static_scene_patch_review_later").lower(),
                "unlocksTmpMaskRehydrationReview": str(row["unblockCategory"] == "unlock_tmp_mask_component_rehydration_review").lower(),
                "confirmsHandlerRuntimeOnly": str(row["unblockCategory"] == "confirm_original_handler_xlua_runtime_state_only_not_static_replacement").lower(),
                "separatePayloadBlocker": str(row["unblockCategory"] == "separate_payload_or_card_ui_blocker_do_not_mix_into_hud_patch").lower(),
                "safeToPatchNow": "false",
                "requiredEvidenceBeforePatch": "approved original runtime snapshot value; component/script rehydration evidence when applicable",
            }
        )

    static_rows = []
    for row in checklist:
        static_rows.append(
            {
                "objectPath": row["objectPath"],
                "fieldName": row["fieldName"],
                "category": row["category"],
                "sourceReports": row["sourceReports"],
                "currentCandidateValue": row["currentCandidateValue"],
                "sourceValue": row["sourceValue"],
                "classification": row["staticVsRuntimeClassification"],
                "safeSourceBackedStaticPatchCandidateNow": "false",
                "reason": "candidate/source values are not enough without approved original runtime state; no coordinate-only or fake handler patch allowed",
            }
        )

    residual_rows = [
        {
            "blocker": "route_hud_right_rail_runtime_state",
            "status": "blocked",
            "evidence": "BATTLE73 runtimeSnapshotRequiredRows=269 and handlerOrXluaRequiredRows=94",
            "requiredNextEvidence": "approved UI_NormalBattle runtime hierarchy snapshot after Open/Refresh",
            "doNotMixWith": "map reprojection already solved by BATTLE72",
        },
        {
            "blocker": "tmp_mask_stencil_component_rehydration",
            "status": "blocked",
            "evidence": "BATTLE74 candidateLoadedTmpComponentRows=0 and candidateLoadedMaskComponentRows=0",
            "requiredNextEvidence": "resolved TMP/Mask component type/script persistence plus runtime material/stencil snapshot",
            "doNotMixWith": "reference-video visual alignment",
        },
        {
            "blocker": "xlua_gameentry_modulesinit_runtime",
            "status": "blocked",
            "evidence": "BATTLE59 executableXluaRuntimeAvailable=false and GameEntry/LuaManager bootstrap unavailable",
            "requiredNextEvidence": "original runtime binary/source or user-approved external xLua experiment",
            "doNotMixWith": "fake/no-op handlers",
        },
        {
            "blocker": "original_button_handler_binding",
            "status": "blocked",
            "evidence": "BATTLE58 onClickKnownRows=0, UIEventListener delegate rows=0, handlerBoundRows=0",
            "requiredNextEvidence": "source-backed Lua lifecycle and closure binding snapshot",
            "doNotMixWith": "input raycast readiness",
        },
        {
            "blocker": "card_actor_timeline_payload",
            "status": "separate_blocker",
            "evidence": "local subset actor/skill progress exists but full payload/timeline/xLua blockers remain",
            "requiredNextEvidence": "1036/enemy payload chain, Timeline package/runtime binding, original battle manager context",
            "doNotMixWith": "HUD route patch",
        },
    ]

    approval_template = {
        "packet": PREFIX,
        "createdAt": datetime.now().replace(microsecond=0).isoformat(),
        "approvalRequiredForRuntimeDump": True,
        "runtimeInstrumentationExecutedInThisTask": False,
        "externalXluaImportApproved": False,
        "safetyNotes": [
            "Do not use this template as restored data until values are filled from approved original runtime evidence.",
            "Do not replace missing values with candidate-scene coordinates or reference-video guesses.",
            "No fake onClick/no-op handler/stub GameEntry/xLua substitution is permitted.",
        ],
        "candidateScenePath": b73_result.get("candidateScenePath", ""),
        "snapshotTiming": "after original UI_NormalBattle OnInit/Open/Refresh and one Canvas update, before any user input",
        "fieldChecklist": [
            {
                "objectPath": row["objectPath"],
                "fieldName": row["fieldName"],
                "category": row["category"],
                "requirementLevel": row["requirementLevel"],
                "currentCandidateValue": row["currentCandidateValue"],
                "sourceValue": row["sourceValue"],
                "runtimeValue": None,
                "unblockCategory": row["unblockCategory"],
                "notes": row["whyRequired"],
            }
            for row in checklist
        ],
        "hookCandidates": hooks,
    }

    out_base = reports / PREFIX
    out_checklist = reports / f"{PREFIX}_DEDUPLICATED_MINIMAL_RUNTIME_SNAPSHOT_FIELD_CHECKLIST.csv"
    out_hooks = reports / f"{PREFIX}_HOOK_SOURCE_CANDIDATE_MATRIX.csv"
    out_unblock = reports / f"{PREFIX}_FIELD_TO_PATCH_UNBLOCK_MAPPING_MATRIX.csv"
    out_static = reports / f"{PREFIX}_STATIC_KNOWN_VS_RUNTIME_REQUIRED_CLASSIFICATION_MATRIX.csv"
    out_residual = reports / f"{PREFIX}_RESIDUAL_BLOCKER_SEPARATION_MATRIX.csv"
    out_packet = reports / f"{PREFIX}_APPROVAL_PACKET_TEMPLATE.json"
    out_json = reports / f"{PREFIX}_RESULT.json"
    out_md = reports / f"{PREFIX}_RESULT.md"

    write_csv(out_checklist, checklist, list(checklist[0].keys()) if checklist else [])
    write_csv(out_hooks, hooks, list(hooks[0].keys()))
    write_csv(out_unblock, unblock_rows, list(unblock_rows[0].keys()) if unblock_rows else [])
    write_csv(out_static, static_rows, list(static_rows[0].keys()) if static_rows else [])
    write_csv(out_residual, residual_rows, list(residual_rows[0].keys()))
    write_json(out_packet, approval_template)

    raw_b73 = len(b73_fields)
    raw_b74 = len(b74_fields)
    dedup_count = len(checklist)
    required_count = sum(1 for r in checklist if r["requirementLevel"] == "required")
    blocked_component_count = sum(1 for r in checklist if r["requirementLevel"] == "blocked-by-component-rehydration")
    handler_lifecycle_count = sum(1 for r in checklist if r["category"] == "handler_lua_lifecycle")

    result = {
        "task": PREFIX,
        "generatedAt": datetime.now().replace(microsecond=0).isoformat(),
        "restoredClaim": False,
        "playableClaim": False,
        "patchApplied": False,
        "sceneSaved": False,
        "canonicalSceneOverwritten": False,
        "packageImported": False,
        "manifestModified": False,
        "runtimeInstrumentationUsed": False,
        "externalXluaImported": False,
        "hudRoutePatched": False,
        "tmpMaskPatched": False,
        "cardPayloadPatched": False,
        "actorPayloadPatched": False,
        "battle72MapCandidateState": "validated_persisted",
        "battle73Used": True,
        "battle74Used": True,
        "battle59Used": True,
        "rawB73RuntimeFields": raw_b73,
        "rawB74TmpMaskFields": raw_b74,
        "deduplicatedRuntimeFieldsCount": dedup_count,
        "requiredFieldCount": required_count,
        "blockedByComponentRehydrationFieldCount": blocked_component_count,
        "handlerLifecycleFieldCount": handler_lifecycle_count,
        "hookCandidatesCount": len(hooks),
        "sourceBackedStaticPatchCandidatesNow": 0,
        "approvalPacketTemplateWritten": True,
        "approvalRequiredForRuntimeDump": True,
        "recommendedNextAction": "REQUEST_USER_APPROVAL_FOR_ORIGINAL_RUNTIME_SNAPSHOT_DUMP_USING_B75_APPROVAL_PACKET_TEMPLATE_OR_PROVIDE_SOURCE_BACKED_XLUA_GAMEENTRY_RUNTIME",
        "nextBlocker": "APPROVAL_REQUIRED_FOR_ORIGINAL_UI_NORMALBATTLE_RUNTIME_SNAPSHOT_OR_SOURCE_BACKED_XLUA_GAMEENTRY_MODULESINIT_RECOVERY",
        "guardrailsTouched": [
            "no_runtime_instrumentation_execution",
            "no_apk_or_emulator_launch",
            "no_scene_save",
            "no_canonical_scene_overwrite",
            "no_package_import",
            "no_manifest_edit",
            "no_external_xlua_import",
            "no_xlua_or_handler_patch",
            "no_hud_route_patch",
            "no_tmp_mask_patch",
            "no_card_or_actor_payload_patch",
            "no_fake_handler",
            "no_noop_handler",
            "no_coordinate_only_success",
        ],
        "commandPolicy": count_root_cmds(root),
        "inputs": {
            "battle73Result": str(reports / f"{B73_PREFIX}_RESULT.json"),
            "battle73SnapshotSpec": str(reports / f"{B73_PREFIX}_MINIMAL_RUNTIME_SNAPSHOT_FIELD_SPEC.csv"),
            "battle74Result": str(reports / f"{B74_PREFIX}_RESULT.json"),
            "battle74SnapshotSpec": str(reports / f"{B74_PREFIX}_TMP_MASK_STENCIL_RUNTIME_SNAPSHOT_FIELD_SPEC.csv"),
            "battle59Result": str(reports / f"{B59_PREFIX}_RESULT.json"),
            "battle59BootstrapGraph": str(reports / f"{B59_PREFIX}_GAMEENTRY_LUAMANAGER_MODULESINIT_BOOTSTRAP_REQUIREMENT_GRAPH.csv"),
            "battle58Result": str(reports / f"{B58_PREFIX}_RESULT.json"),
            "battle58HudButtonAudit": str(reports / f"{B58_PREFIX}_HUD_BUTTON_HANDLER_AUDIT.csv"),
        },
        "outputs": {
            "deduplicatedChecklistCsv": str(out_checklist),
            "hookCandidateCsv": str(out_hooks),
            "fieldToPatchUnblockCsv": str(out_unblock),
            "staticVsRuntimeCsv": str(out_static),
            "residualBlockerCsv": str(out_residual),
            "approvalPacketTemplateJson": str(out_packet),
        },
        "carryover": {
            "battle73RuntimeSnapshotRequiredRows": b73_result.get("runtimeSnapshotRequiredRows"),
            "battle73HandlerOrXluaRequiredRows": b73_result.get("handlerOrXluaRequiredRows"),
            "battle74ComponentRehydrationRequiredRows": b74_result.get("componentRehydrationRequiredRows"),
            "battle74TmpMaskRuntimeSnapshotFieldsCount": b74_result.get("tmpMaskRuntimeSnapshotFieldsCount"),
            "battle59ExecutableXluaRuntimeAvailable": b59_result.get("executableXluaRuntimeAvailable"),
            "battle59SourceBackedImportableEditorRuntimeCandidates": b59_result.get("sourceBackedImportableEditorRuntimeCandidates"),
            "battle58HandlerBindingApplied": b58_result.get("handlerBindingApplied"),
        },
    }
    write_json(out_json, result)

    md = f"""# {PREFIX}

## Result
- restoredClaim: false
- playableClaim: false
- patchApplied: false
- sceneSaved: false
- canonicalSceneOverwritten: false
- runtimeInstrumentationUsed: false
- externalXluaImported: false

## Consolidated Inputs
- BATTLE73 raw runtime fields: {raw_b73}
- BATTLE74 raw TMP/mask fields: {raw_b74}
- Deduplicated runtime fields: {dedup_count}
- Required fields: {required_count}
- Blocked by component rehydration fields: {blocked_component_count}
- Handler/lifecycle fields: {handler_lifecycle_count}
- Hook candidates: {len(hooks)}

## Decision
No safe static route/HUD/TMP/mask patch exists now. B72 map reprojection remains validated, but B73/B74 prove route state, TMP/mask/stencil state, and handler binding require approved original runtime evidence. B59 still reports no local source-backed executable xLua/GameEntry/LuaManager runtime candidate.

## Approval Packet
The approval packet template has null `runtimeValue` entries for the deduplicated objectPath/fieldName checklist. It is a request template only and must not be treated as restored data.

## Recommended Next Action
`REQUEST_USER_APPROVAL_FOR_ORIGINAL_RUNTIME_SNAPSHOT_DUMP_USING_B75_APPROVAL_PACKET_TEMPLATE_OR_PROVIDE_SOURCE_BACKED_XLUA_GAMEENTRY_RUNTIME`

## Next Blocker
`APPROVAL_REQUIRED_FOR_ORIGINAL_UI_NORMALBATTLE_RUNTIME_SNAPSHOT_OR_SOURCE_BACKED_XLUA_GAMEENTRY_MODULESINIT_RECOVERY`

## Outputs
- `{out_checklist}`
- `{out_hooks}`
- `{out_unblock}`
- `{out_static}`
- `{out_residual}`
- `{out_packet}`
"""
    out_md.write_text(md, encoding="utf-8")


if __name__ == "__main__":
    main()
