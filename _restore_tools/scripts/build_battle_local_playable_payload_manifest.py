from __future__ import annotations

import csv
import json
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
REPORTS = BASE / "reports"
CHAR_DIR = REPORTS / "characters"
BATTLE_DIR = REPORTS / "battle"
MERGED = BASE / "girlswar_merged_extracted"
INDEX_DIR = MERGED / "indexes"

ROSTER_JSON = CHAR_DIR / "GIRLSWAR_CHARACTER_ROSTER.json"
GAP_MD = CHAR_DIR / "GIRLSWAR_CHARACTER_GAP_REPORT.md"
DEEP_TRACE_MD = CHAR_DIR / "CHARACTER_RESOURCE_GAP_DEEP_TRACE.md"
CDN_TRACE_MD = CHAR_DIR / "CHARACTER_1036_CDN_ACQUISITION_TRACE.md"
PAYLOAD_JSON = BATTLE_DIR / "BATTLE_TEST_PAYLOAD.json"
PROTOTYPE_JSON = BATTLE_DIR / "BATTLE_PROTOTYPE_MANIFEST.json"
ASSETBUNDLES_CSV = INDEX_DIR / "assetbundles.csv"

OUT_JSON = BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.json"
OUT_CSV = BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.csv"
OUT_MD = BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.md"


def rel(path: Path | str) -> str:
    p = Path(path)
    try:
        return str(p.relative_to(BASE)).replace("\\", "/")
    except Exception:
        return str(path).replace("\\", "/")


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    fields = [
        "rowType",
        "localStatus",
        "side",
        "waveNo",
        "slot",
        "payloadHeroDid",
        "payloadHeroId",
        "ownerHeroDid",
        "ownerHeroId",
        "skillDid",
        "skillType",
        "prefabField",
        "prefabId",
        "bundle",
        "bundleExists",
        "missingDependencyBundles",
        "reason",
        "source",
    ]
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def read_assetbundle_set() -> set[str]:
    bundles: set[str] = set()
    if not ASSETBUNDLES_CSV.exists():
        return bundles
    with ASSETBUNDLES_CSV.open("r", encoding="utf-8-sig", newline="") as f:
        for row in csv.DictReader(f):
            bundle = (row.get("bundle") or "").replace("\\", "/").lower()
            if bundle:
                bundles.add(bundle)
    return bundles


def bundle_exists(bundle: str, bundle_set: set[str]) -> bool:
    return bundle.replace("\\", "/").lower() in bundle_set


def dep_asset_to_bundle(asset_path: str) -> str:
    p = asset_path.replace("\\", "/")
    low = p.lower()
    if not low.startswith("assets/download/"):
        return ""
    rest = p[len("Assets/Download/") :]
    parts = rest.split("/")
    if len(parts) < 2:
        return ""
    if parts[0].lower() == "skillprefabsandres" and len(parts) >= 2:
        return f"download/skillprefabsandres/{parts[1].lower()}.assetbundle"
    if (
        parts[0].lower() == "commonprefabsandres"
        and len(parts) >= 2
        and parts[-1].lower().endswith(".prefab")
    ):
        bundle_parts = [x.lower() for x in parts[:-2]]
        bundle_name = parts[-2].lower()
        return "download/" + "/".join(bundle_parts + [bundle_name + ".assetbundle"])
    return ""


def split_pipe(value: str) -> list[str]:
    if not value:
        return []
    return [x for x in str(value).split("|") if x]


def actor_local_status(actor: dict[str, Any]) -> tuple[str, str]:
    load_status = actor.get("loadStatus")
    did = actor.get("payloadHeroDid")
    if load_status == "loadable_spine_bundle":
        return "loadable", "actor bundle and spine evidence exist locally"
    if did == 1036 or load_status == "bundle_not_in_extracted_assetbundle_index":
        return "not_fetchable_local", "1036 actor bundle is present in CDNVersionFile but absent locally; CDN acquisition trace found no asset CDN build rule"
    if actor.get("side") == "enemy" and not actor.get("datatableFound"):
        return "unresolved_enemy_payload_instance", "payload enemy id has no authoritative DTMonster_* row or alias in local evidence"
    return "data_only_missing_actor", f"actor load status from roster: {load_status}"


def build_actor_rows(roster: dict[str, Any]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for actor in roster["actors"]:
        status, reason = actor_local_status(actor)
        row = {
            **actor,
            "localStatus": status,
            "reason": reason,
            "rowType": "actor",
            "bundle": actor.get("actorBundle", ""),
            "bundleExists": actor.get("actorBundleExists", False),
            "source": "GIRLSWAR_CHARACTER_ROSTER.json actors + deep trace status rules",
        }
        rows.append(row)
    return rows


def build_resource_rows(
    roster: dict[str, Any],
    prototype: dict[str, Any],
    actor_rows: list[dict[str, Any]],
    bundle_set: set[str],
) -> list[dict[str, Any]]:
    refs: dict[str, dict[str, Any]] = {}

    def add(kind: str, bundle: str, referenced_by: str, source: str) -> None:
        if not bundle:
            return
        key = bundle.replace("\\", "/").lower()
        row = refs.setdefault(
            key,
            {
                "rowType": "resource",
                "kind": kind,
                "bundle": key,
                "bundleExists": bundle_exists(key, bundle_set),
                "referencedBy": [],
                "source": source,
            },
        )
        row["referencedBy"].append(referenced_by)

    for b in prototype.get("map", {}).get("bundles", []):
        add("battle_map", b.get("bundle", ""), b.get("referenced_by", "map"), "BATTLE_PROTOTYPE_MANIFEST.map")
    for actor in actor_rows:
        add("actor_bundle", actor.get("actorBundle", ""), f"{actor.get('side')}:{actor.get('payloadHeroDid')}", "roster.actorBundle")
    for skill in roster["skills"]:
        add("skill_bundle", skill.get("skillBundle", ""), f"skill:{skill.get('skillDid')}:{skill.get('prefabId')}", "roster.skillBundle")
        for dep in split_pipe(skill.get("prefabDeps", "")):
            add("timeline_prefab_dep", dep_asset_to_bundle(dep), f"timeline:{skill.get('prefabId')}", "BattleTimelineResMap.prefabDeps")

    rows = []
    for row in sorted(refs.values(), key=lambda r: (r["kind"], r["bundle"])):
        if row["bundleExists"]:
            row["localStatus"] = "loadable"
            row["reason"] = "bundle exists in extracted assetbundle index"
        elif row["kind"] == "actor_bundle" and row["bundle"].endswith("/1036.assetbundle"):
            row["localStatus"] = "not_fetchable_local"
            row["reason"] = "1036 actor bundle row is known from CDNVersionFile but exact local bundle and asset CDN rule are absent"
        elif row["kind"] == "timeline_prefab_dep" and "commonprefabsandres" in row["bundle"]:
            row["localStatus"] = "unresolved_missing_common_bundle"
            row["reason"] = "common timeline dependency bundle, such as speedline, is referenced but absent locally"
        else:
            row["localStatus"] = "not_fetchable_local"
            row["reason"] = "bundle referenced by local data but absent from extracted assetbundle index"
        row["referencedBy"] = sorted(set(row["referencedBy"]))
        rows.append(row)
    return rows


def build_skill_rows(roster: dict[str, Any], actor_rows: list[dict[str, Any]], resource_rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    actor_status_by_owner: dict[tuple[str, str, str], dict[str, Any]] = {}
    actor_status_by_did: defaultdict[int, list[dict[str, Any]]] = defaultdict(list)
    for actor in actor_rows:
        actor_status_by_owner[(str(actor.get("side", "")), str(actor.get("waveNo", "")), str(actor.get("payloadHeroDid", "")))] = actor
        try:
            actor_status_by_did[int(actor.get("payloadHeroDid"))].append(actor)
        except Exception:
            pass

    resource_by_bundle = {r["bundle"]: r for r in resource_rows}
    rows: list[dict[str, Any]] = []
    for skill in roster["skills"]:
        owner_key = (str(skill.get("side", "")), str(skill.get("waveNo", "")), str(skill.get("ownerHeroDid", "")))
        owner_actor = actor_status_by_owner.get(owner_key)
        if not owner_actor:
            owner_candidates = actor_status_by_did.get(int(skill.get("ownerHeroDid") or 0), [])
            owner_actor = owner_candidates[0] if owner_candidates else {}
        owner_status = owner_actor.get("localStatus", "data_only_missing_actor")

        dep_bundles = sorted(
            {
                dep_asset_to_bundle(dep)
                for dep in split_pipe(skill.get("prefabDeps", ""))
                if dep_asset_to_bundle(dep)
            }
        )
        missing_dep_bundles = [
            b
            for b in dep_bundles
            if resource_by_bundle.get(b, {}).get("localStatus") != "loadable"
        ]

        if skill.get("skillPassiveFound") and not skill.get("skillActFound"):
            local_status = "passive_no_timeline"
            reason = "passive-style skill row has no DTSkillAct prefab/timeline mapping"
        elif skill.get("status") != "timeline_resolved":
            local_status = "missing_timeline_mapping"
            reason = f"roster skill status: {skill.get('status')}"
        elif owner_status != "loadable":
            local_status = "data_only_missing_actor"
            reason = f"timeline resolves, but owner actor is {owner_status}"
        elif not skill.get("skillBundleExists"):
            local_status = "not_fetchable_local"
            reason = "skill bundle referenced by timeline is absent locally"
        elif missing_dep_bundles:
            local_status = "loadable_with_unresolved_common_resource_deps"
            reason = "main skill timeline bundle exists, but known common dependency bundle(s) are unresolved"
        else:
            local_status = "loadable"
            reason = "owner actor, skill bundle, timeline, and known prefab dependency bundles exist locally"

        rows.append(
            {
                **skill,
                "rowType": "skill",
                "localStatus": local_status,
                "ownerActorStatus": owner_status,
                "missingDependencyBundles": missing_dep_bundles,
                "reason": reason,
                "bundle": skill.get("skillBundle", ""),
                "bundleExists": skill.get("skillBundleExists", False),
                "source": "GIRLSWAR_CHARACTER_ROSTER.json skills + resource dependency checks",
            }
        )
    return rows


def payload_summary(payload: dict[str, Any]) -> dict[str, Any]:
    battle = payload["battleInfo"]
    return {
        "mapId": battle.get("mapId"),
        "battleType": battle.get("battleType"),
        "randomSeed": battle.get("randomSeed"),
        "fightResult": battle.get("fightResult"),
        "ourHeroDids": [h.get("heroDid") for h in battle.get("ourHeros", [])],
        "ourHeroIds": [h.get("heroId") for h in battle.get("ourHeros", [])],
        "enemyHeroDids": [e.get("heroDid") for w in battle.get("waveData", []) for e in w.get("enemyTeamFormation", [])],
        "waveCount": len(battle.get("waveData", [])),
    }


def build_subset(payload: dict[str, Any], actor_rows: list[dict[str, Any]], skill_rows: list[dict[str, Any]]) -> dict[str, Any]:
    loadable_actor_keys = {(a.get("side"), str(a.get("waveNo", "")), a.get("payloadHeroDid")) for a in actor_rows if a["localStatus"] == "loadable"}
    loadable_our_dids = {did for side, _wave, did in loadable_actor_keys if side == "our"}
    loadable_enemy = {(wave, did) for side, wave, did in loadable_actor_keys if side == "enemy"}
    skill_status_ok = {"loadable", "loadable_with_unresolved_common_resource_deps"}

    battle = payload["battleInfo"]
    our_heros = [h for h in battle.get("ourHeros", []) if h.get("heroDid") in loadable_our_dids]
    waves = []
    for wave in battle.get("waveData", []):
        wave_no = str(wave.get("waveNo", ""))
        enemies = [e for e in wave.get("enemyTeamFormation", []) if (wave_no, e.get("heroDid")) in loadable_enemy]
        if enemies:
            waves.append({"waveNo": wave.get("waveNo"), "enemyTeamFormation": enemies})

    subset_skills = [
        {
            "side": s.get("side"),
            "waveNo": s.get("waveNo"),
            "ownerHeroDid": s.get("ownerHeroDid"),
            "ownerHeroId": s.get("ownerHeroId"),
            "skillDid": s.get("skillDid"),
            "skillType": s.get("skillType"),
            "prefabField": s.get("prefabField"),
            "prefabId": s.get("prefabId"),
            "assetPathViaGetSysprefabData": s.get("assetPathViaGetSysprefabData"),
            "skillBundle": s.get("skillBundle"),
            "localStatus": s.get("localStatus"),
            "missingDependencyBundles": s.get("missingDependencyBundles"),
        }
        for s in skill_rows
        if s.get("localStatus") in skill_status_ok
    ]
    resource_complete_skills = [s for s in subset_skills if s["localStatus"] == "loadable"]

    return {
        "purpose": "debug/interaction/runtime validation subset only; this is not a full original payload replacement and not a full restore claim",
        "ourHerosFromOriginalPayload": our_heros,
        "enemyWavesFromOriginalPayload": waves,
        "timelineSkillsFromOriginalPayload": subset_skills,
        "resourceCompleteTimelineSkills": resource_complete_skills,
        "notes": [
            "No fake replacement actors, skills, cards, coordinates, or aliases were introduced.",
            "Rows are retained only when their original payload actor id resolves to local actor evidence.",
            "Skills marked loadable_with_unresolved_common_resource_deps have a resolved timeline and local skill bundle, but missing common speedline-style dependency bundles remain unresolved.",
        ],
    }


def summarize(actor_rows: list[dict[str, Any]], skill_rows: list[dict[str, Any]], resource_rows: list[dict[str, Any]]) -> dict[str, Any]:
    return {
        "classification": "local_playable_subset_only_not_full_payload",
        "actorStatusCounts": dict(Counter(r["localStatus"] for r in actor_rows)),
        "skillStatusCounts": dict(Counter(r["localStatus"] for r in skill_rows)),
        "resourceStatusCounts": dict(Counter(r["localStatus"] for r in resource_rows)),
        "loadableActors": sum(1 for r in actor_rows if r["localStatus"] == "loadable"),
        "totalActors": len(actor_rows),
        "timelineResolvedSkillRows": sum(1 for r in skill_rows if r.get("status") == "timeline_resolved"),
        "totalSkillRows": len(skill_rows),
        "resourceCompleteLoadableSkillRows": sum(1 for r in skill_rows if r["localStatus"] == "loadable"),
        "timelineLoadableWithMissingCommonDeps": sum(
            1 for r in skill_rows if r["localStatus"] == "loadable_with_unresolved_common_resource_deps"
        ),
    }


def write_md(report: dict[str, Any]) -> None:
    s = report["summary"]
    subset = report["minimalPlayableLocalSubset"]
    blockers = report["nextBlockers"]
    skill_by_owner: dict[tuple[str, str, Any, str], list[dict[str, Any]]] = defaultdict(list)
    for skill in report["skills"]:
        key = (
            str(skill.get("side", "")),
            str(skill.get("waveNo", "")),
            skill.get("ownerHeroDid"),
            str(skill.get("ownerActorStatus", "")),
        )
        skill_by_owner[key].append(skill)
    lines = [
        "# BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST",
        "",
        f"- Classification: `{s['classification']}`",
        f"- Authoritative payload: `{report['sourceInputs']['battleTestPayload']}`",
        f"- Output JSON: `reports/battle/{OUT_JSON.name}`",
        f"- Output CSV: `reports/battle/{OUT_CSV.name}`",
        "",
        "## Summary",
        f"- Actors loadable: `{s['loadableActors']}` / `{s['totalActors']}`",
        f"- Skill timeline rows resolved: `{s['timelineResolvedSkillRows']}` / `{s['totalSkillRows']}`",
        f"- Resource-complete loadable skill rows: `{s['resourceCompleteLoadableSkillRows']}`",
        f"- Timeline rows with unresolved common deps: `{s['timelineLoadableWithMissingCommonDeps']}`",
        f"- Actor statuses: `{s['actorStatusCounts']}`",
        f"- Skill statuses: `{s['skillStatusCounts']}`",
        f"- Resource statuses: `{s['resourceStatusCounts']}`",
        "",
        "## Actor Rows",
        "| side | wave | slot | heroDid | heroId | prefabId | bundle | status | reason |",
        "| --- | ---: | ---: | ---: | ---: | ---: | --- | --- | --- |",
    ]
    for a in report["actors"]:
        lines.append(
            f"| {a.get('side')} | {a.get('waveNo')} | {a.get('slot')} | {a.get('payloadHeroDid')} | {a.get('payloadHeroId')} | {a.get('prefabId')} | `{a.get('actorBundle', '')}` | `{a.get('localStatus')}` | {a.get('reason')} |"
        )
    lines.extend(
        [
            "",
            "## Skill / Timeline Rows",
            "| side | wave | ownerHeroDid | ownerActorStatus | skillLocalStatuses | resolved prefabIds | missing deps |",
            "| --- | ---: | ---: | --- | --- | --- | --- |",
        ]
    )
    for key, skills in sorted(skill_by_owner.items(), key=lambda item: (item[0][0], item[0][1], str(item[0][2]))):
        side, wave, owner_did, owner_status = key
        status_counts = dict(Counter(s.get("localStatus") for s in skills))
        prefab_ids = sorted({str(s.get("prefabId")) for s in skills if s.get("prefabId")})
        missing = sorted({b for s in skills for b in s.get("missingDependencyBundles", [])})
        lines.append(
            f"| {side} | {wave} | {owner_did} | `{owner_status}` | `{status_counts}` | `{', '.join(prefab_ids)}` | `{', '.join(missing)}` |"
        )
    lines.extend(
        [
            "",
            "## Resource Gaps",
            "| kind | bundle | exists | status | referencedBy |",
            "| --- | --- | --- | --- | --- |",
        ]
    )
    for r in report["resources"]:
        if r["localStatus"] != "loadable":
            refs = ", ".join(r.get("referencedBy", [])[:8])
            lines.append(f"| {r.get('kind')} | `{r.get('bundle')}` | `{r.get('bundleExists')}` | `{r.get('localStatus')}` | {refs} |")
    lines.extend(
        [
            "",
            "## Minimal Playable Local Subset",
            f"- Purpose: {subset['purpose']}",
            f"- Original our heroes retained: `{[h.get('heroDid') for h in subset['ourHerosFromOriginalPayload']]}`",
            f"- Original enemy wave rows retained: `{[(w['waveNo'], [e.get('heroDid') for e in w['enemyTeamFormation']]) for w in subset['enemyWavesFromOriginalPayload']]}`",
            f"- Timeline skill rows retained: `{len(subset['timelineSkillsFromOriginalPayload'])}`",
            f"- Resource-complete timeline skill rows: `{len(subset['resourceCompleteTimelineSkills'])}`",
            f"- Strict resource-complete skill prefabIds: `{[s.get('prefabId') for s in subset['resourceCompleteTimelineSkills']]}`",
            "",
            "This subset is only for local interaction/runtime validation. It is not a full original payload replacement and must not be reported as a full restore.",
            "",
            "## Next Blockers",
        ]
    )
    for blocker in blockers:
        lines.append(f"- {blocker}")
    lines.extend(
        [
            "",
            "## Source Rules",
            "- No Unity scene was modified.",
            "- No fake actor/card/skill mapping was introduced.",
            "- No Git commit/push was performed.",
        ]
    )
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    roster = load_json(ROSTER_JSON)
    payload = load_json(PAYLOAD_JSON)
    prototype = load_json(PROTOTYPE_JSON) if PROTOTYPE_JSON.exists() else {}
    bundle_set = read_assetbundle_set()

    actor_rows = build_actor_rows(roster)
    resource_rows = build_resource_rows(roster, prototype, actor_rows, bundle_set)
    skill_rows = build_skill_rows(roster, actor_rows, resource_rows)
    subset = build_subset(payload, actor_rows, skill_rows)

    report = {
        "name": "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST",
        "generatedBy": rel(Path(__file__)),
        "workspace": str(BASE),
        "sourceInputs": {
            "characterRoster": rel(ROSTER_JSON),
            "gapReport": rel(GAP_MD),
            "resourceGapDeepTrace": rel(DEEP_TRACE_MD),
            "character1036CdnTrace": rel(CDN_TRACE_MD),
            "battleTestPayload": rel(PAYLOAD_JSON),
            "battlePrototypeManifest": rel(PROTOTYPE_JSON) if PROTOTYPE_JSON.exists() else "",
            "assetbundleIndex": rel(ASSETBUNDLES_CSV),
        },
        "authoritativePayloadSummary": payload_summary(payload),
        "summary": summarize(actor_rows, skill_rows, resource_rows),
        "actors": actor_rows,
        "skills": skill_rows,
        "resources": resource_rows,
        "minimalPlayableLocalSubset": subset,
        "nextBlockers": [
            "Full original payload execution still requires the missing 1036 actor battle bundle or an authoritative asset CDN acquisition path.",
            "Full original payload execution still requires authoritative mappings for unresolved enemy payload instance ids 1100112/1100113/1100121/1100122/1100123/1100131/1100132/1100133.",
            "Common timeline dependency bundles such as pink/red/yellow speedline remain unresolved where reported; they were not guessed or replaced.",
            "The local playable subset is for interaction/runtime validation only, not a full restore claim or replacement for the authoritative embedded BATTLE_TEST_PAYLOAD.",
        ],
        "principles": [
            "Authoritative payload hero/skill ids were preserved from BATTLE_TEST_PAYLOAD.",
            "No fake replacement actor, card, skill, coordinate, or alias data was generated.",
            "No Unity scene was modified.",
            "No Git commit/push was performed.",
        ],
    }

    write_json(OUT_JSON, report)

    flat_rows: list[dict[str, Any]] = []
    for a in actor_rows:
        flat_rows.append(a)
    for s in skill_rows:
        row = {**s}
        row["missingDependencyBundles"] = "|".join(s.get("missingDependencyBundles", []))
        flat_rows.append(row)
    for r in resource_rows:
        flat_rows.append(
            {
                "rowType": "resource",
                "localStatus": r.get("localStatus"),
                "bundle": r.get("bundle"),
                "bundleExists": r.get("bundleExists"),
                "reason": r.get("reason"),
                "source": r.get("source"),
            }
        )
    write_csv(OUT_CSV, flat_rows)
    write_md(report)

    print(f"Wrote {OUT_JSON}")
    print(f"Wrote {OUT_CSV}")
    print(f"Wrote {OUT_MD}")
    print(json.dumps(report["summary"], ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
