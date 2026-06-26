from __future__ import annotations

import csv
import json
import os
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_CHAR_DIR = ROOT / "reports" / "characters"
REPORT_BATTLE_DIR = ROOT / "reports" / "battle"

MANIFEST = REPORT_BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED.json"
MANIFEST_CSV = REPORT_BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED.csv"
B54_JSON = REPORT_BATTLE_DIR / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_RESULT.json"
B54_ACTORS = REPORT_BATTLE_DIR / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_ACTORS.csv"
B54_CARDS = REPORT_BATTLE_DIR / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_HERO_CARDS.csv"
B57_JSON = REPORT_BATTLE_DIR / "BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_RESULT.json"
B57_MAPPING = REPORT_BATTLE_DIR / "BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_REHYDRATION_MAPPING.csv"
B57_VISIBILITY = REPORT_BATTLE_DIR / "BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_VISIBILITY.csv"
B67_ACTOR_POS = REPORT_BATTLE_DIR / "BATTLE_67_ASPECT_CORRECT_CROP_VISUAL_VALIDATION_NO_PATCH_ACTOR_CONTENT_RECT_POSITION_MATRIX.csv"
B60_SKILL_LOAD = REPORT_BATTLE_DIR / "BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH_SKILL_TIMELINE_SOURCE_LOAD_VALIDATION.csv"
B64_DECISION = REPORT_BATTLE_DIR / "BATTLE_64_TIMELINE_PLAYABLEASSET_COMPATIBILITY_AND_ORIGINAL_BINDING_SOURCE_TRACE_NO_PATCH_DECISION_NEXT_ACTION_MATRIX.csv"

CHAR63 = REPORT_CHAR_DIR / "CHARACTER_63_UNRESOLVED_ACTOR_BUNDLE_LOCAL_EVIDENCE_RESCAN_NO_NETWORK_NO_FAKE_RESULT.json"
CHAR64 = REPORT_CHAR_DIR / "CHARACTER_64_LOCAL_EXACT_1036_BUNDLE_WIDER_PC_SEARCH_NO_NETWORK_NO_COPY_NO_IMPORT_RESULT.json"

OUT_BASE = "CHARACTER_65_FULL_BATTLE_PAYLOAD_ROSTER_AND_BUNDLE_GAP_MATRIX_NO_NETWORK_NO_IMPORT_RESULT"
OUT_JSON = REPORT_CHAR_DIR / f"{OUT_BASE}.json"
OUT_MD = REPORT_CHAR_DIR / f"{OUT_BASE}.md"
OUT_ACTOR_CSV = REPORT_CHAR_DIR / f"{OUT_BASE}_FULL_BATTLE_ACTOR_CARD_ROSTER_MATRIX.csv"
OUT_SKILL_CSV = REPORT_CHAR_DIR / f"{OUT_BASE}_SKILL_TIMELINE_EFFECT_PAYLOAD_MATRIX.csv"
OUT_GAP_CSV = REPORT_CHAR_DIR / f"{OUT_BASE}_LOCAL_BUNDLE_READINESS_AND_GAP_MATRIX.csv"
OUT_PROPOSAL_JSON = REPORT_BATTLE_DIR / "BATTLE_FULL_PAYLOAD_LIST_CANDIDATE_PROPOSAL_FROM_CHARACTER65_ROSTER_GAP_MATRIX.json"


def rel(path: Path) -> str:
    try:
        return path.relative_to(ROOT).as_posix()
    except ValueError:
        return str(path)


def read_json(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8"))


def read_csv_rows(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict], fields: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields, extrasaction="ignore")
        writer.writeheader()
        for row in rows:
            writer.writerow({key: row.get(key, "") for key in fields})


def command_policy_status() -> dict:
    root_cmd = sorted(p.name for p in ROOT.glob("*.cmd"))
    tools_cmd = sorted(p.name for p in (ROOT / "_restore_tools").glob("*.cmd"))
    return {
        "rootCmdCount": len(root_cmd),
        "rootCmdFiles": root_cmd,
        "restoreToolsDirectCmdCount": len(tools_cmd),
        "restoreToolsDirectCmdFiles": tools_cmd,
        "policyOk": len(root_cmd) == 1 and len(tools_cmd) == 0,
    }


def str_id(value: Any) -> str:
    return str(value or "").strip()


def key_from_parts(*parts: Any) -> str:
    return "|".join(str_id(p) for p in parts)


def index_by(rows: list[dict[str, str]], *fields: str) -> dict[str, list[dict[str, str]]]:
    out: dict[str, list[dict[str, str]]] = {}
    for row in rows:
        key = key_from_parts(*(row.get(field, "") for field in fields))
        out.setdefault(key, []).append(row)
    return out


def first_index_by(rows: list[dict[str, str]], *fields: str) -> dict[str, dict[str, str]]:
    return {key: value[0] for key, value in index_by(rows, *fields).items() if value}


def actor_candidate_status(local_status: str) -> str:
    if local_status == "loadable":
        return "ready_local"
    if local_status == "not_fetchable_local":
        return "source_known_missing_bundle"
    if local_status == "unresolved_enemy_payload_instance":
        return "unresolved_source_chain"
    return "unresolved_source_chain"


def skill_candidate_status(skill: dict, owner_actor_status: str) -> str:
    local_status = skill.get("localStatus", "")
    if local_status == "loadable" and owner_actor_status == "ready_local":
        return "ready_local"
    if owner_actor_status == "unresolved_source_chain":
        return "unresolved_source_chain"
    if owner_actor_status == "source_known_missing_bundle":
        return "source_known_missing_bundle"
    if local_status in {"data_only_missing_actor", "passive_no_timeline"}:
        return "source_known_missing_bundle"
    if local_status == "loadable":
        return "ready_local"
    return "source_known_missing_bundle"


def bool_text(value: Any) -> str:
    if isinstance(value, bool):
        return "True" if value else "False"
    return str(value or "")


def build() -> dict:
    os.chdir(ROOT)
    manifest = read_json(MANIFEST)
    char63 = read_json(CHAR63)
    char64 = read_json(CHAR64)
    b54_json = read_json(B54_JSON)
    b57_json = read_json(B57_JSON)

    manifest_rows = read_csv_rows(MANIFEST_CSV)
    b54_actor_rows = read_csv_rows(B54_ACTORS)
    b54_card_rows = read_csv_rows(B54_CARDS)
    b57_mapping_rows = read_csv_rows(B57_MAPPING)
    b57_visibility_rows = read_csv_rows(B57_VISIBILITY)
    b67_rows = read_csv_rows(B67_ACTOR_POS)
    b60_skill_rows = read_csv_rows(B60_SKILL_LOAD)
    b64_decision_rows = read_csv_rows(B64_DECISION)

    b54_actor_by_hero = index_by(b54_actor_rows, "payloadHeroDid")
    b54_card_by_hero = first_index_by(b54_card_rows, "payloadHeroDid")
    b57_mapping_by_hero = first_index_by(b57_mapping_rows, "payloadHeroDid")
    b57_visibility_by_hero = first_index_by(b57_visibility_rows, "payloadHeroDid")
    b67_by_hero = first_index_by(b67_rows, "heroDid")
    b60_by_skill = first_index_by(b60_skill_rows, "ownerHeroDid", "skillDid", "prefabField", "prefabId")

    actor_status_by_hero: dict[str, str] = {}
    actor_rows: list[dict] = []
    readiness_rows: list[dict] = []

    for actor in manifest.get("actors", []):
        hero = str_id(actor.get("payloadHeroDid"))
        local_status = str_id(actor.get("localStatus"))
        candidate_status = actor_candidate_status(local_status)
        actor_status_by_hero[hero] = candidate_status

        b54_active = [r for r in b54_actor_by_hero.get(hero, []) if r.get("sourceKind") == "active_runtime_actor_candidate"]
        b54_disabled = [r for r in b54_actor_by_hero.get(hero, []) if r.get("sourceKind") == "disabled_legacy_actor_candidate"]
        card = b54_card_by_hero.get(hero, {})
        b57_map = b57_mapping_by_hero.get(hero, {})
        b57_vis = b57_visibility_by_hero.get(hero, {})
        b67 = b67_by_hero.get(hero, {})

        if candidate_status == "ready_local":
            battle_visibility_status = "source_backed_visible_local_subset" if (b67.get("capturePixelSignal") == "True" or b57_vis.get("capturePixelSignal") == "True") else "source_backed_bundle_ready"
        elif candidate_status == "source_known_missing_bundle":
            battle_visibility_status = "card_source_known_actor_missing_bundle"
        else:
            battle_visibility_status = "unresolved_actor_not_placed"

        row = {
            "rowCategory": "actor_card",
            "battleListCandidateStatus": candidate_status,
            "side": actor.get("side", ""),
            "waveNo": actor.get("waveNo", ""),
            "slot": actor.get("slot", ""),
            "heroDidOrMonsterId": hero,
            "payloadHeroId": actor.get("payloadHeroId", ""),
            "datatable": actor.get("datatable", ""),
            "datatableFound": actor.get("datatableFound", ""),
            "modelId": actor.get("modelId", ""),
            "modelFound": actor.get("modelFound", ""),
            "prefabId": actor.get("prefabId", ""),
            "expectedBattleActorBundle": actor.get("actorBundle") or actor.get("bundle", ""),
            "bundleExists": actor.get("actorBundleExists", actor.get("bundleExists", "")),
            "localStatus": local_status,
            "reason": actor.get("reason", ""),
            "sysPrefabAssetPath": actor.get("sysPrefabAssetPath", ""),
            "skillDidList": actor.get("skillDidList", ""),
            "nameKey": actor.get("nameKey", ""),
            "cardPresentInB54": bool(card),
            "cardActiveInHierarchy": card.get("activeInHierarchy", ""),
            "cardImageWithSpriteCount": card.get("imageWithSpriteCount", ""),
            "b54ActiveActorRows": len(b54_active),
            "b54DisabledLegacyActorRows": len(b54_disabled),
            "b57BundleLoaded": b57_map.get("bundleLoaded", b57_map.get("bundleLoadSuccess", "")),
            "b57PrefabInstantiated": b57_map.get("prefabInstantiated", b57_map.get("instantiateSuccess", "")),
            "b57CapturePixelSignal": b57_vis.get("capturePixelSignal", ""),
            "b67CapturePixelSignal": b67.get("capturePixelSignal", ""),
            "b67ContentRectInterpretation": b67.get("interpretation", ""),
            "currentBattleVisibilityStatus": battle_visibility_status,
            "notPromotableWeakMatchNote": "1036 same-name rolebigsetpainting/skillprefabs matches were rejected" if hero == "1036" else "",
            "sourceEvidence": "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED + BATTLE54/BATTLE57/BATTLE67",
        }
        actor_rows.append(row)
        readiness_rows.append(
            {
                "rowCategory": "actor",
                "ownerOrActorId": hero,
                "side": row["side"],
                "waveNo": row["waveNo"],
                "slot": row["slot"],
                "resourceId": row["prefabId"],
                "resourceBundle": row["expectedBattleActorBundle"],
                "battleListCandidateStatus": candidate_status,
                "localStatus": local_status,
                "gapType": "none" if candidate_status == "ready_local" else ("missing_exact_actor_bundle" if candidate_status == "source_known_missing_bundle" else "missing_authoritative_actor_chain"),
                "nextAction": "usable in local subset" if candidate_status == "ready_local" else ("requires exact local actor bundle/acquisition" if candidate_status == "source_known_missing_bundle" else "requires authoritative DTMonster/DTHero->DTmodel->prefab chain"),
                "sourceEvidence": row["sourceEvidence"],
            }
        )

    skill_rows: list[dict] = []
    for skill in manifest.get("skills", []):
        owner = str_id(skill.get("ownerHeroDid"))
        owner_status = actor_status_by_hero.get(owner, "unresolved_source_chain")
        candidate_status = skill_candidate_status(skill, owner_status)
        b60 = b60_by_skill.get(key_from_parts(owner, skill.get("skillDid", ""), skill.get("prefabField", ""), skill.get("prefabId", "")), {})
        timeline_runtime_blocker = ""
        if candidate_status == "ready_local":
            timeline_runtime_blocker = "BATTLE64: TimelineAsset/PlayableAsset type/runtime binding blocker remains for visual activation"
        elif owner_status != "ready_local":
            timeline_runtime_blocker = "owner actor is not ready; skill stays data-only for full payload list"
        elif skill.get("localStatus") == "passive_no_timeline":
            timeline_runtime_blocker = "passive/no DTSkillAct timeline prefab row"

        row = {
            "rowCategory": "skill",
            "battleListCandidateStatus": candidate_status,
            "side": skill.get("side", ""),
            "waveNo": skill.get("waveNo", ""),
            "ownerHeroDid": owner,
            "ownerHeroId": skill.get("ownerHeroId", ""),
            "ownerActorCandidateStatus": owner_status,
            "skillDid": skill.get("skillDid", ""),
            "skillType": skill.get("skillType", ""),
            "prefabField": skill.get("prefabField", ""),
            "prefabId": skill.get("prefabId", ""),
            "skillBundle": skill.get("bundle", ""),
            "skillBundleExists": skill.get("bundleExists", ""),
            "localStatus": skill.get("localStatus", ""),
            "missingDependencyBundles": skill.get("missingDependencyBundles", ""),
            "resolvedParentBundles": skill.get("resolvedParentBundles", ""),
            "resolvedExactDependencyBundles": skill.get("resolvedExactDependencyBundles", ""),
            "reason": skill.get("reason", ""),
            "b60BundleLoadSuccess": b60.get("bundleLoadSuccess", ""),
            "b60AssetLoadSuccess": b60.get("assetLoadSuccess", ""),
            "b60InstantiateSuccess": b60.get("instantiateSuccess", ""),
            "b60ResourceCompleteStrictBeforeSpeedline": b60.get("resourceCompleteStrict", ""),
            "timelineEffectRuntimeBlocker": timeline_runtime_blocker,
            "sourceEvidence": "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED + BATTLE60/BATTLE64 where available",
        }
        skill_rows.append(row)
        readiness_rows.append(
            {
                "rowCategory": "skill",
                "ownerOrActorId": owner,
                "side": row["side"],
                "waveNo": row["waveNo"],
                "slot": "",
                "resourceId": row["prefabId"] or row["skillDid"],
                "resourceBundle": row["skillBundle"],
                "battleListCandidateStatus": candidate_status,
                "localStatus": row["localStatus"],
                "gapType": "none" if candidate_status == "ready_local" else ("owner_actor_missing_or_unresolved" if owner_status != "ready_local" else "no_timeline_or_missing_skill_resource"),
                "nextAction": "usable as local subset asset row; BATTLE64 runtime/timeline blocker remains" if candidate_status == "ready_local" else timeline_runtime_blocker,
                "sourceEvidence": row["sourceEvidence"],
            }
        )

    weak_match_rows = []
    for weak in read_json(CHAR64).get("weakSameFilenameMatches", []):
        weak_match_rows.append(
            {
                "rowCategory": "weak_match",
                "ownerOrActorId": "1036",
                "side": "our",
                "waveNo": "",
                "slot": "1",
                "resourceId": "1036.assetbundle",
                "resourceBundle": weak.get("absolutePath", ""),
                "battleListCandidateStatus": "not_promotable_weak_match",
                "localStatus": weak.get("classification", ""),
                "gapType": "same_filename_different_category",
                "nextAction": "do not promote; exact battle actor bundle still required",
                "sourceEvidence": "CHARACTER64 wider local search",
            }
        )
    readiness_rows.extend(weak_match_rows)

    battle_list_rows = actor_rows + skill_rows
    ready_local_rows = [row for row in battle_list_rows if row.get("battleListCandidateStatus") == "ready_local"]
    source_known_missing_rows = [row for row in battle_list_rows if row.get("battleListCandidateStatus") == "source_known_missing_bundle"]
    unresolved_rows = [row for row in battle_list_rows if row.get("battleListCandidateStatus") == "unresolved_source_chain"]

    proposal = {
        "name": "BATTLE_FULL_PAYLOAD_LIST_CANDIDATE_PROPOSAL_FROM_CHARACTER65_ROSTER_GAP_MATRIX",
        "generatedBy": rel(Path(__file__)),
        "classification": "proposal_only_not_manifest_overwrite_not_full_restore_claim",
        "doesNotOverwrite": rel(MANIFEST),
        "readyLocalRows": ready_local_rows,
        "sourceKnownMissingBundleRows": source_known_missing_rows,
        "unresolvedSourceChainRows": unresolved_rows,
        "notPromotableWeakMatches": weak_match_rows,
        "guardrails": {
            "networkUsed": False,
            "filesCopied": False,
            "filesImported": False,
            "sceneModified": False,
            "weakMatchesPromoted": False,
        },
    }
    OUT_PROPOSAL_JSON.write_text(json.dumps(proposal, ensure_ascii=False, indent=2), encoding="utf-8")

    result = {
        "name": OUT_BASE,
        "generatedBy": rel(Path(__file__)),
        "generatedAtUtc": datetime.now(timezone.utc).isoformat(),
        "workspace": str(ROOT),
        "networkUsed": False,
        "filesCopied": False,
        "filesImported": False,
        "sceneModified": False,
        "battleListRows": battle_list_rows,
        "readyLocalRows": ready_local_rows,
        "sourceKnownMissingBundleRows": source_known_missing_rows,
        "unresolvedSourceChainRows": unresolved_rows,
        "weakMatchesPromoted": False,
        "proposalWritten": True,
        "proposalPath": rel(OUT_PROPOSAL_JSON),
        "nextBlocker": "Full payload battle list cannot be promoted to ready until exact 1036 battle actor bundle is acquired locally and unresolved enemy payload ids receive authoritative actor chains/source-backed aliases; visual activation still needs Timeline/xLua runtime context.",
        "guardrailsTouched": {
            "networkDownloadHeadGet": False,
            "filesCopied": False,
            "filesImported": False,
            "filesMoved": False,
            "filesDeleted": False,
            "sceneModified": False,
            "manifestOverwritten": False,
            "fakeActorSkillCardData": False,
            "weakNameOnlyAliasPromotion": False,
        },
        "commandPolicy": command_policy_status(),
        "summary": {
            "battleListRowCount": len(battle_list_rows),
            "actorRows": len(actor_rows),
            "skillRows": len(skill_rows),
            "readyLocalRows": len(ready_local_rows),
            "sourceKnownMissingBundleRows": len(source_known_missing_rows),
            "unresolvedSourceChainRows": len(unresolved_rows),
            "notPromotableWeakMatchRows": len(weak_match_rows),
            "actorCandidateStatusCounts": dict(Counter(row["battleListCandidateStatus"] for row in actor_rows)),
            "skillCandidateStatusCounts": dict(Counter(row["battleListCandidateStatus"] for row in skill_rows)),
            "b54ActiveLoadableActorRows": b54_json.get("summary", {}).get("activeLoadableActorRows", ""),
            "b57SourceBackedRehydratedActors": b57_json.get("mapping", {}).get("sourceBackedRehydratedRows", ""),
        },
        "inputsRead": [
            rel(CHAR63),
            rel(CHAR64),
            rel(B54_JSON),
            rel(B54_ACTORS),
            rel(B54_CARDS),
            rel(B57_JSON),
            rel(B67_ACTOR_POS),
            rel(MANIFEST),
            rel(B60_SKILL_LOAD),
            rel(B64_DECISION),
        ],
        "actorCardRosterRows": actor_rows,
        "skillTimelineEffectRows": skill_rows,
        "localBundleReadinessGapRows": readiness_rows,
        "battle64DecisionRows": b64_decision_rows,
        "char63Summary": char63.get("summary", {}),
        "char64Summary": char64.get("summary", {}),
    }
    return result


def write_outputs(result: dict) -> None:
    REPORT_CHAR_DIR.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    actor_fields = [
        "rowCategory",
        "battleListCandidateStatus",
        "side",
        "waveNo",
        "slot",
        "heroDidOrMonsterId",
        "payloadHeroId",
        "datatable",
        "datatableFound",
        "modelId",
        "modelFound",
        "prefabId",
        "expectedBattleActorBundle",
        "bundleExists",
        "localStatus",
        "reason",
        "sysPrefabAssetPath",
        "skillDidList",
        "nameKey",
        "cardPresentInB54",
        "cardActiveInHierarchy",
        "cardImageWithSpriteCount",
        "b54ActiveActorRows",
        "b54DisabledLegacyActorRows",
        "b57BundleLoaded",
        "b57PrefabInstantiated",
        "b57CapturePixelSignal",
        "b67CapturePixelSignal",
        "b67ContentRectInterpretation",
        "currentBattleVisibilityStatus",
        "notPromotableWeakMatchNote",
        "sourceEvidence",
    ]
    skill_fields = [
        "rowCategory",
        "battleListCandidateStatus",
        "side",
        "waveNo",
        "ownerHeroDid",
        "ownerHeroId",
        "ownerActorCandidateStatus",
        "skillDid",
        "skillType",
        "prefabField",
        "prefabId",
        "skillBundle",
        "skillBundleExists",
        "localStatus",
        "missingDependencyBundles",
        "resolvedParentBundles",
        "resolvedExactDependencyBundles",
        "reason",
        "b60BundleLoadSuccess",
        "b60AssetLoadSuccess",
        "b60InstantiateSuccess",
        "b60ResourceCompleteStrictBeforeSpeedline",
        "timelineEffectRuntimeBlocker",
        "sourceEvidence",
    ]
    gap_fields = [
        "rowCategory",
        "ownerOrActorId",
        "side",
        "waveNo",
        "slot",
        "resourceId",
        "resourceBundle",
        "battleListCandidateStatus",
        "localStatus",
        "gapType",
        "nextAction",
        "sourceEvidence",
    ]
    write_csv(OUT_ACTOR_CSV, result["actorCardRosterRows"], actor_fields)
    write_csv(OUT_SKILL_CSV, result["skillTimelineEffectRows"], skill_fields)
    write_csv(OUT_GAP_CSV, result["localBundleReadinessGapRows"], gap_fields)

    summary = result["summary"]
    lines = [
        "# CHARACTER_65_FULL_BATTLE_PAYLOAD_ROSTER_AND_BUNDLE_GAP_MATRIX_NO_NETWORK_NO_IMPORT_RESULT",
        "",
        f"- generatedBy: `{result['generatedBy']}`",
        f"- generatedAtUtc: `{result['generatedAtUtc']}`",
        f"- networkUsed: `{result['networkUsed']}`",
        f"- filesCopied: `{result['filesCopied']}`",
        f"- filesImported: `{result['filesImported']}`",
        f"- sceneModified: `{result['sceneModified']}`",
        f"- weakMatchesPromoted: `{result['weakMatchesPromoted']}`",
        f"- proposalWritten: `{result['proposalWritten']}`",
        "",
        "## Summary",
        "",
        f"- battleListRows: `{summary['battleListRowCount']}`",
        f"- actorRows: `{summary['actorRows']}`",
        f"- skillRows: `{summary['skillRows']}`",
        f"- readyLocalRows: `{summary['readyLocalRows']}`",
        f"- sourceKnownMissingBundleRows: `{summary['sourceKnownMissingBundleRows']}`",
        f"- unresolvedSourceChainRows: `{summary['unresolvedSourceChainRows']}`",
        f"- notPromotableWeakMatchRows: `{summary['notPromotableWeakMatchRows']}`",
        f"- actorCandidateStatusCounts: `{summary['actorCandidateStatusCounts']}`",
        f"- skillCandidateStatusCounts: `{summary['skillCandidateStatusCounts']}`",
        "",
        "## Actor/Card Roster",
        "",
        "| status | side | wave | slot | id | model | prefab | bundle | battle visibility |",
        "|---|---|---:|---:|---:|---:|---:|---|---|",
    ]
    for row in result["actorCardRosterRows"]:
        lines.append(
            f"| `{row['battleListCandidateStatus']}` | {row['side']} | {row['waveNo']} | {row['slot']} | "
            f"{row['heroDidOrMonsterId']} | {row['modelId']} | {row['prefabId']} | "
            f"`{row['expectedBattleActorBundle']}` | {row['currentBattleVisibilityStatus']} |"
        )
    lines.extend(
        [
            "",
            "## Key Conclusions",
            "",
            "- Ready local actor rows remain exactly `1002`, `1034`, and enemy `1100111 -> model/prefab 3001`.",
            "- `1036` is source-known but missing exact battle actor bundle; CHARACTER64 weak same-name files are not actor bundle matches.",
            "- Enemy ids `1100112`, `1100113`, `1100121`, `1100122`, `1100123`, `1100131`, `1100132`, `1100133` remain unresolved source chains.",
            "- Skill rows are retained in the full matrix, but rows whose owner actor is missing/unresolved are not ready battle-list runtime rows.",
            "- BATTLE64 Timeline/xLua/runtime binding blockers remain even for ready local skill assets.",
            "",
            "## Outputs",
            "",
            f"- JSON: `{rel(OUT_JSON)}`",
            f"- Actor/card CSV: `{rel(OUT_ACTOR_CSV)}`",
            f"- Skill/timeline/effect CSV: `{rel(OUT_SKILL_CSV)}`",
            f"- Readiness/gap CSV: `{rel(OUT_GAP_CSV)}`",
            f"- Proposal JSON: `{result['proposalPath']}`",
            "",
            "## Command Policy",
            "",
            f"- rootCmdCount: `{result['commandPolicy']['rootCmdCount']}`",
            f"- rootCmdFiles: `{result['commandPolicy']['rootCmdFiles']}`",
            f"- restoreToolsDirectCmdCount: `{result['commandPolicy']['restoreToolsDirectCmdCount']}`",
            f"- policyOk: `{result['commandPolicy']['policyOk']}`",
            "",
            "## Next Blocker",
            "",
            f"- {result['nextBlocker']}",
            "",
        ]
    )
    OUT_MD.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    result = build()
    write_outputs(result)
    print(json.dumps(result["summary"], ensure_ascii=False, indent=2))
    print(f"wrote {rel(OUT_MD)}")
    print(f"wrote {rel(OUT_JSON)}")
    print(f"wrote {rel(OUT_ACTOR_CSV)}")
    print(f"wrote {rel(OUT_SKILL_CSV)}")
    print(f"wrote {rel(OUT_GAP_CSV)}")
    print(f"wrote {rel(OUT_PROPOSAL_JSON)}")


if __name__ == "__main__":
    main()
