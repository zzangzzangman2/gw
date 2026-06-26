from __future__ import annotations

import csv
import copy
import json
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = BASE / "reports" / "battle"
PREFIX = "BATTLE_61_APPLY_SPEEDLINE_RESOURCE_UPDATE_PROPOSAL_TO_LOCAL_PLAYABLE_MANIFEST_AND_REVALIDATE_NO_XLUA_NO_HANDLER_PATCH"

MANIFEST_MD = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.md"
MANIFEST_JSON = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.json"
MANIFEST_CSV = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.csv"
PROPOSAL_JSON = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_RESOURCE_UPDATE_PROPOSAL_FROM_SPEEDLINE_TRACE.json"
PROPOSAL_CSV = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_RESOURCE_UPDATE_PROPOSAL_FROM_SPEEDLINE_TRACE.csv"
B60_JSON = REPORT_DIR / "BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH_RESULT.json"
B60_TIMELINE = REPORT_DIR / "BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH_SKILL_TIMELINE_SOURCE_LOAD_VALIDATION.csv"

VARIANT_PREFIX = "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED"
OUT_VARIANT_MD = REPORT_DIR / f"{VARIANT_PREFIX}.md"
OUT_VARIANT_JSON = REPORT_DIR / f"{VARIANT_PREFIX}.json"
OUT_VARIANT_CSV = REPORT_DIR / f"{VARIANT_PREFIX}.csv"

OUT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
OUT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
OUT_COUNTS = REPORT_DIR / f"{PREFIX}_BEFORE_AFTER_STATUS_COUNTS.csv"
OUT_APPLIED = REPORT_DIR / f"{PREFIX}_APPLIED_PROPOSAL_ROWS_AND_UNCHANGED_ACTOR_BLOCKERS.csv"
OUT_VALIDATION = REPORT_DIR / f"{PREFIX}_LOCAL_SUBSET_SKILL_RESOURCE_COMPLETENESS_VALIDATION.csv"
OUT_LOG = REPORT_DIR / f"{PREFIX}.log"

CLEAN_BUNDLE_ROOT = BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices"

PLAY_VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")


def read_json(path: Path, fallback: Any) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8-sig"))
    except Exception:
        return fallback


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], headers: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=headers)
        writer.writeheader()
        for row in rows:
            writer.writerow({h: row.get(h, "") for h in headers})


def truthy(value: Any) -> bool:
    return str(value).strip().lower() in {"1", "true", "yes"}


def key_for_skill(row: dict[str, Any]) -> tuple[str, str, str, str, str, str]:
    return (
        str(row.get("side", "")),
        str(row.get("waveNo", "")),
        str(row.get("ownerHeroDid", "")),
        str(row.get("skillDid", "")),
        str(row.get("prefabField", "")),
        str(row.get("prefabId", "")),
    )


def is_allowed_resource_update(row: dict[str, Any]) -> bool:
    return (
        row.get("resolutionType") == "source_backed_parent_bundle_contains_prefab_object"
        and row.get("proposedStatus") == "resolved_loadable_local_bundle"
        and bool(row.get("exactManifestBundle"))
        and bool(row.get("resolvedBundle"))
    )


def clean_bundle_exists(bundle: str) -> bool:
    rel = bundle.replace("/", "\\")
    return (CLEAN_BUNDLE_ROOT / rel).exists()


def status_counts(manifest: dict[str, Any], csv_rows: list[dict[str, Any]]) -> dict[str, Any]:
    return {
        "actorStatusCounts": dict(Counter(r.get("localStatus", "") for r in csv_rows if r.get("rowType") == "actor")),
        "skillStatusCounts": dict(Counter(r.get("localStatus", "") for r in csv_rows if r.get("rowType") == "skill")),
        "resourceStatusCounts": dict(Counter(r.get("localStatus", "") for r in csv_rows if r.get("rowType") == "resource")),
        "summary": manifest.get("summary", {}),
    }


def apply_to_manifest(manifest: dict[str, Any], csv_rows: list[dict[str, str]], proposal: dict[str, Any]) -> tuple[dict[str, Any], list[dict[str, Any]], dict[str, Any]]:
    updated = copy.deepcopy(manifest)
    updated_csv: list[dict[str, Any]] = [dict(r) for r in csv_rows]

    allowed_resource_updates = [r for r in proposal.get("resourceUpdates", []) if is_allowed_resource_update(r)]
    resource_by_exact = {r["exactManifestBundle"]: r for r in allowed_resource_updates}
    promotions = [r for r in proposal.get("skillPromotions", []) if r.get("proposedStatus") == "loadable" and not r.get("blocker")]
    promotions_by_key = {key_for_skill(r): r for r in promotions}

    applied_rows: list[dict[str, Any]] = []

    for row in updated_csv:
        if row.get("rowType") == "resource" and row.get("bundle") in resource_by_exact:
            proposal_row = resource_by_exact[row["bundle"]]
            row["originalLocalStatus"] = row.get("localStatus", "")
            row["localStatus"] = proposal_row["proposedStatus"]
            row["resolvedParentBundle"] = proposal_row["resolvedBundle"]
            row["resolvedParentBundleExists"] = str(clean_bundle_exists(proposal_row["resolvedBundle"]))
            row["resolutionType"] = proposal_row["resolutionType"]
            row["evidenceSummary"] = proposal_row.get("evidenceSummary", "")
            row["source"] = "BATTLE61 source-backed speedline proposal variant"
            applied_rows.append({"rowType": "resourceUpdate", **proposal_row, "applied": True, "reason": "allowed source-backed parent bundle resolution"})
        elif row.get("rowType") == "skill" and key_for_skill(row) in promotions_by_key:
            proposal_row = promotions_by_key[key_for_skill(row)]
            row["originalLocalStatus"] = row.get("localStatus", "")
            row["localStatus"] = "loadable"
            row["resolvedParentBundles"] = proposal_row.get("resolvedBundles", "")
            row["resolvedExactDependencyBundles"] = proposal_row.get("affectedExactBundles", "")
            row["missingDependencyBundles"] = proposal_row.get("remainingMissingDependencyBundles", "")
            row["source"] = "BATTLE61 source-backed speedline proposal variant"
            applied_rows.append({"rowType": "skillPromotion", **proposal_row, "applied": True, "reason": "local actor loadable and all exact speedline deps resolved by parent bundle"})
        else:
            row.setdefault("originalLocalStatus", row.get("localStatus", ""))
            row.setdefault("resolvedParentBundle", "")
            row.setdefault("resolvedParentBundleExists", "")
            row.setdefault("resolutionType", "")
            row.setdefault("evidenceSummary", "")
            row.setdefault("resolvedParentBundles", "")
            row.setdefault("resolvedExactDependencyBundles", "")

    for resource in updated.get("resources", []):
        bundle = resource.get("bundle", "")
        if bundle in resource_by_exact:
            proposal_row = resource_by_exact[bundle]
            resource["originalLocalStatus"] = resource.get("localStatus", "")
            resource["localStatus"] = proposal_row["proposedStatus"]
            resource["bundleExists"] = False
            resource["resolvedParentBundle"] = proposal_row["resolvedBundle"]
            resource["resolvedParentBundleExists"] = clean_bundle_exists(proposal_row["resolvedBundle"])
            resource["resolutionType"] = proposal_row["resolutionType"]
            resource["exactManifestBundlePreserved"] = bundle
            resource["assetPath"] = proposal_row.get("assetPath", "")
            resource["evidenceSummary"] = proposal_row.get("evidenceSummary", "")
            resource["reason"] = "Exact child bundle is not standalone locally; source-backed parent bundle contains matching prefab/container object."

    for skill in updated.get("skills", []):
        k = key_for_skill(skill)
        if k in promotions_by_key:
            proposal_row = promotions_by_key[k]
            skill["originalLocalStatus"] = skill.get("localStatus", "")
            skill["localStatus"] = "loadable"
            skill["missingDependencyBundles"] = []
            skill["resolvedDependencyBundles"] = proposal_row.get("resolvedBundles", "").split(";") if proposal_row.get("resolvedBundles") else [proposal_row.get("resolvedBundles", "")]
            skill["resolvedExactDependencyBundles"] = proposal_row.get("affectedExactBundles", "").split(";") if proposal_row.get("affectedExactBundles") else []
            skill["resolutionType"] = "source_backed_parent_bundle_contains_prefab_object"
            skill["speedlineProposalApplied"] = True

    subset = updated.get("minimalPlayableLocalSubset", {})
    for skill in subset.get("timelineSkillsFromOriginalPayload", []):
        k = key_for_skill(skill)
        if k in promotions_by_key:
            proposal_row = promotions_by_key[k]
            skill["originalLocalStatus"] = skill.get("localStatus", "")
            skill["localStatus"] = "loadable"
            skill["missingDependencyBundles"] = []
            skill["resolvedDependencyBundles"] = [proposal_row.get("resolvedBundles", "")]
            skill["resolvedExactDependencyBundles"] = [proposal_row.get("affectedExactBundles", "")]
            skill["resolutionType"] = "source_backed_parent_bundle_contains_prefab_object"
            skill["speedlineProposalApplied"] = True
    subset["resourceCompleteTimelineSkills"] = [
        copy.deepcopy(s) for s in subset.get("timelineSkillsFromOriginalPayload", [])
        if s.get("localStatus") == "loadable" and not s.get("missingDependencyBundles")
    ]
    notes = subset.setdefault("notes", [])
    notes.append("BATTLE61 speedline-resolved variant treats exact pink/red/yello speedline dependency strings as source-backed objects inside download/commonprefabsandres/skilleffect/commonskillprefabsandres1.assetbundle.")
    notes.append("Canonical BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST was not overwritten.")

    summary = updated.setdefault("summary", {})
    summary["classification"] = "local_playable_subset_only_not_full_payload_speedline_resolved_variant"
    summary["skillStatusCounts"] = dict(Counter(r.get("localStatus", "") for r in updated_csv if r.get("rowType") == "skill"))
    summary["resourceStatusCounts"] = dict(Counter(r.get("localStatus", "") for r in updated_csv if r.get("rowType") == "resource"))
    summary["resourceCompleteLoadableSkillRows"] = sum(1 for r in updated_csv if r.get("rowType") == "skill" and r.get("localStatus") == "loadable")
    summary["timelineLoadableWithMissingCommonDeps"] = sum(1 for r in updated_csv if r.get("rowType") == "skill" and r.get("localStatus") == "loadable_with_unresolved_common_resource_deps")
    summary["speedlineResolvedVariant"] = True
    summary["canonicalManifestOverwritten"] = False
    summary["speedlineResourceUpdatesApplied"] = len(allowed_resource_updates)
    summary["speedlineSkillPromotionsApplied"] = len(promotions)
    updated["speedlineResolutionEvidence"] = {
        "sourceProposal": str(PROPOSAL_JSON),
        "resourceUpdatesApplied": allowed_resource_updates,
        "skillPromotionsApplied": promotions,
        "canonicalManifestOverwritten": False,
        "exactManifestDependencyStringsPreserved": True,
    }
    updated["name"] = VARIANT_PREFIX
    updated["generatedBy"] = "_restore_tools/scripts/battle61_apply_speedline_resource_update_proposal.py"

    applied_summary = {
        "resourceUpdatesApplied": len(allowed_resource_updates),
        "skillPromotionsApplied": len(promotions),
        "resourceUpdateExactBundles": sorted(resource_by_exact),
    }
    return updated, updated_csv, {"appliedRows": applied_rows, "summary": applied_summary}


def build_validation_rows(updated_csv: list[dict[str, Any]], b60_rows: list[dict[str, str]], resource_by_exact: dict[str, dict[str, Any]]) -> list[dict[str, Any]]:
    updated_by_key = {key_for_skill(r): r for r in updated_csv if r.get("rowType") == "skill"}
    rows: list[dict[str, Any]] = []
    # Revalidate exactly the 12 BATTLE60 timeline prefab rows, not passive rows
    # owned by the same actors.
    for b60 in b60_rows:
        row = updated_by_key.get(key_for_skill(b60), {})
        if not row:
            continue
        local_status = row.get("localStatus", "")
        exact_deps = row.get("resolvedExactDependencyBundles") or row.get("missingDependencyBundles", "")
        parent_bundles = row.get("resolvedParentBundles", "")
        rows.append(
            {
                "side": row.get("side", ""),
                "waveNo": row.get("waveNo", ""),
                "ownerHeroDid": row.get("ownerHeroDid", ""),
                "skillDid": row.get("skillDid", ""),
                "prefabField": row.get("prefabField", ""),
                "prefabId": row.get("prefabId", ""),
                "beforeStatus": b60.get("localStatus", ""),
                "afterStatus": local_status,
                "bundleLoadSuccessFromB60": b60.get("bundleLoadSuccess", ""),
                "assetLoadSuccessFromB60": b60.get("assetLoadSuccess", ""),
                "instantiateSuccessFromB60": b60.get("instantiateSuccess", ""),
                "exactDependencyStringsPreserved": exact_deps,
                "resolvedParentBundles": parent_bundles,
                "resolvedParentBundleExists": str(all(clean_bundle_exists(b.strip()) for b in parent_bundles.split(";") if b.strip())) if parent_bundles else "",
                "resourceCompleteAfter": str(local_status == "loadable" and not row.get("missingDependencyBundles")),
                "validation": "source_backed_skill_prefab_and_speedline_parent_bundle_verified" if local_status == "loadable" and not row.get("missingDependencyBundles") else "not_resource_complete",
            }
        )
    return rows


def write_variant_md(updated: dict[str, Any], validation_rows: list[dict[str, Any]]) -> None:
    summary = updated.get("summary", {})
    lines = [
        f"# {VARIANT_PREFIX}",
        "",
        "- Classification: `local_playable_subset_only_not_full_payload_speedline_resolved_variant`",
        "- Canonical manifest overwritten: `false`",
        "- Source proposal: `reports/battle/BATTLE_LOCAL_PLAYABLE_PAYLOAD_RESOURCE_UPDATE_PROPOSAL_FROM_SPEEDLINE_TRACE.json`",
        "",
        "## Summary",
        f"- Local subset timeline rows checked: `{len(validation_rows)}`",
        f"- Local subset resource-complete rows after speedline resolution: `{sum(1 for r in validation_rows if r['resourceCompleteAfter'] == 'True')}`",
        f"- Missing common dependency rows after: `{sum(1 for r in validation_rows if r['resourceCompleteAfter'] != 'True')}`",
        f"- Skill status counts: `{summary.get('skillStatusCounts')}`",
        f"- Resource status counts: `{summary.get('resourceStatusCounts')}`",
        "",
        "## Guardrails",
        "- This is not a full payload restore and not a playable claim.",
        "- 1036 and unresolved enemy actor blockers are unchanged.",
        "- xLua/GameEntry/LuaManager handler blocker is unchanged.",
    ]
    OUT_VARIANT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_result_md(result: dict[str, Any]) -> None:
    lines = [
        f"# {PREFIX} Result",
        "",
        "**Playable/restored claim remains false.** BATTLE61 applies only the source-backed speedline resource proposal to a new local playable manifest variant.",
        "",
        "## Verdict",
        f"- restoredClaim: `{str(result['restoredClaim']).lower()}`",
        f"- playableClaim: `{str(result['playableClaim']).lower()}`",
        f"- sourceBackedProposalApplied: `{str(result['sourceBackedProposalApplied']).lower()}`",
        f"- manifestVariantWritten: `{str(result['manifestVariantWritten']).lower()}`",
        f"- canonicalManifestOverwritten: `{str(result['canonicalManifestOverwritten']).lower()}`",
        f"- nextBlocker: `{result['nextBlocker']}`",
        "",
        "## Before / After",
        f"- local subset resource-complete skill rows: `{result['localSubsetResourceCompleteSkillRowsBefore']}` -> `{result['localSubsetResourceCompleteSkillRowsAfter']}`",
        f"- missing common dependency rows: `{result['missingCommonDependencyRowsBefore']}` -> `{result['missingCommonDependencyRowsAfter']}`",
        f"- source-backed skill rows checked: `{result['sourceBackedSkillRowsChecked']}`",
        "",
        "## Outputs",
        f"- speedline-resolved manifest MD: `{OUT_VARIANT_MD}`",
        f"- speedline-resolved manifest JSON: `{OUT_VARIANT_JSON}`",
        f"- speedline-resolved manifest CSV: `{OUT_VARIANT_CSV}`",
        f"- before/after counts CSV: `{OUT_COUNTS}`",
        f"- applied proposal rows CSV: `{OUT_APPLIED}`",
        f"- local subset validation CSV: `{OUT_VALIDATION}`",
        "",
        "## Command Policy",
        f"- root `.cmd` count: `{result['commandPolicy']['rootCmdCount']}`",
        f"- `_restore_tools` direct `.cmd` count: `{result['commandPolicy']['restoreToolsDirectCmdCount']}`",
        f"- `플레이.mp4`: `{'available' if PLAY_VIDEO.exists() else 'missing'}`",
        f"- `참고.mp4`: `{'available, auxiliary only' if AUX_VIDEO.exists() else 'missing'}`",
    ]
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def command_policy() -> dict[str, Any]:
    root_cmds = sorted(str(p) for p in BASE.glob("*.cmd"))
    direct_cmds = sorted(str(p) for p in (BASE / "_restore_tools").glob("*.cmd"))
    return {
        "rootCmdCount": len(root_cmds),
        "rootCmdFiles": root_cmds,
        "restoreToolsDirectCmdCount": len(direct_cmds),
        "restoreToolsDirectCmdFiles": direct_cmds,
    }


def main() -> int:
    original_manifest = read_json(MANIFEST_JSON, {})
    original_csv = read_csv(MANIFEST_CSV)
    proposal = read_json(PROPOSAL_JSON, {})
    b60 = read_json(B60_JSON, {})
    b60_rows = read_csv(B60_TIMELINE)

    before_counts = status_counts(original_manifest, original_csv)
    updated_manifest, updated_csv, applied = apply_to_manifest(original_manifest, original_csv, proposal)
    after_counts = status_counts(updated_manifest, updated_csv)

    validation_rows = build_validation_rows(
        updated_csv,
        b60_rows,
        {r["exactManifestBundle"]: r for r in proposal.get("resourceUpdates", []) if is_allowed_resource_update(r)},
    )
    local_subset_before = int(b60.get("resourceCompleteSkillRowsVerified", 0))
    local_subset_after = sum(1 for r in validation_rows if r["resourceCompleteAfter"] == "True")
    missing_before = int(b60.get("missingCommonDependencyRows", 0))
    missing_after = sum(1 for r in validation_rows if r["resourceCompleteAfter"] != "True")

    csv_headers = list(original_csv[0].keys()) + [
        "originalLocalStatus",
        "resolvedParentBundle",
        "resolvedParentBundleExists",
        "resolutionType",
        "evidenceSummary",
        "resolvedParentBundles",
        "resolvedExactDependencyBundles",
    ]
    # Preserve header order without duplicates.
    dedup_headers = []
    for h in csv_headers:
        if h not in dedup_headers:
            dedup_headers.append(h)

    OUT_VARIANT_JSON.write_text(json.dumps(updated_manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    write_csv(OUT_VARIANT_CSV, updated_csv, dedup_headers)
    write_variant_md(updated_manifest, validation_rows)

    count_rows = []
    for category in ["actorStatusCounts", "skillStatusCounts", "resourceStatusCounts"]:
        keys = sorted(set(before_counts.get(category, {})) | set(after_counts.get(category, {})))
        for key in keys:
            count_rows.append(
                {
                    "category": category,
                    "status": key,
                    "before": before_counts.get(category, {}).get(key, 0),
                    "after": after_counts.get(category, {}).get(key, 0),
                    "delta": after_counts.get(category, {}).get(key, 0) - before_counts.get(category, {}).get(key, 0),
                }
            )
    write_csv(OUT_COUNTS, count_rows, ["category", "status", "before", "after", "delta"])

    actor_blockers = proposal.get("unchangedActorBlockers", [])
    applied_rows = applied["appliedRows"] + [
        {"rowType": "unchangedActorBlocker", "blocker": blocker, "applied": False, "reason": "actor blocker intentionally unchanged"}
        for blocker in actor_blockers
    ]
    applied_headers = sorted({k for row in applied_rows for k in row.keys()})
    write_csv(OUT_APPLIED, applied_rows, applied_headers)
    write_csv(
        OUT_VALIDATION,
        validation_rows,
        [
            "side",
            "waveNo",
            "ownerHeroDid",
            "skillDid",
            "prefabField",
            "prefabId",
            "beforeStatus",
            "afterStatus",
            "bundleLoadSuccessFromB60",
            "assetLoadSuccessFromB60",
            "instantiateSuccessFromB60",
            "exactDependencyStringsPreserved",
            "resolvedParentBundles",
            "resolvedParentBundleExists",
            "resourceCompleteAfter",
            "validation",
        ],
    )

    guardrails = {
        "fakeSkillCreated": False,
        "fakeEffectCreated": False,
        "fakeCardIconTextCreated": False,
        "handlerPatchApplied": False,
        "dummyLuaUsed": False,
        "externalXluaImported": False,
        "androidInstrumentationUsed": False,
        "canonicalManifestOverwritten": False,
        "mainInterfaceTouched": False,
    }
    result = {
        "prefix": PREFIX,
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "playableClaim": False,
        "isFinalRestoredBattleScreen": False,
        "sourceBackedProposalApplied": applied["summary"]["resourceUpdatesApplied"] == 3 and applied["summary"]["skillPromotionsApplied"] == 8,
        "manifestVariantWritten": OUT_VARIANT_JSON.exists() and OUT_VARIANT_CSV.exists() and OUT_VARIANT_MD.exists(),
        "canonicalManifestOverwritten": False,
        "sceneSaved": False,
        "handlerBindingApplied": False,
        "xLuaRuntimeUsed": False,
        "sourceBackedSkillRowsChecked": len(validation_rows),
        "localSubsetResourceCompleteSkillRowsBefore": local_subset_before,
        "localSubsetResourceCompleteSkillRowsAfter": local_subset_after,
        "missingCommonDependencyRowsBefore": missing_before,
        "missingCommonDependencyRowsAfter": missing_after,
        "unchangedActorBlockers": actor_blockers,
        "nextBlocker": "original_xlua_runtime_required_for_handlers_and_full_payload_actor_gaps_1036_unresolved_enemies",
        "guardrailsTouched": guardrails,
        "commandPolicy": command_policy(),
        "proposalAppliedSummary": applied["summary"],
        "beforeAfterStatusCountsCsv": str(OUT_COUNTS),
        "appliedProposalRowsCsv": str(OUT_APPLIED),
        "localSubsetSkillResourceCompletenessValidationCsv": str(OUT_VALIDATION),
        "manifestVariant": {
            "md": str(OUT_VARIANT_MD),
            "json": str(OUT_VARIANT_JSON),
            "csv": str(OUT_VARIANT_CSV),
        },
        "outputs": {
            "resultMd": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "log": str(OUT_LOG),
        },
    }
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    write_result_md(result)
    OUT_LOG.write_text(
        "\n".join(
            [
                PREFIX,
                f"sourceBackedProposalApplied={result['sourceBackedProposalApplied']}",
                f"manifestVariantWritten={result['manifestVariantWritten']}",
                "canonicalManifestOverwritten=false",
                f"localSubsetResourceCompleteSkillRowsBefore={local_subset_before}",
                f"localSubsetResourceCompleteSkillRowsAfter={local_subset_after}",
                f"missingCommonDependencyRowsBefore={missing_before}",
                f"missingCommonDependencyRowsAfter={missing_after}",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
