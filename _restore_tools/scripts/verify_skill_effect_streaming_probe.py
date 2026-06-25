from __future__ import annotations

import csv
import json
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"

CANDIDATES_JSON = UNITY_DATA / "BATTLE_SKILL_EFFECT_STREAMING_CANDIDATES.json"
UNITY_PROBE_JSON = UNITY_DATA / "BATTLE_SKILL_EFFECT_STREAMING_UNITY_BUNDLE_PROBE.json"
UNITY_PROBE_CSV = UNITY_DATA / "BATTLE_SKILL_EFFECT_STREAMING_UNITY_BUNDLE_PROBE.csv"
FINAL_JSON = UNITY_DATA / "BATTLE_SKILL_EFFECT_STREAMING_PROBE.json"
FINAL_CSV = REPORT_DIR / "BATTLE_SKILL_EFFECT_STREAMING_PROBE.csv"
REPORT_MD = REPORT_DIR / "BATTLE_SKILL_EFFECT_STREAMING_PROBE_RESULT.md"
RESULT_JSON = REPORT_DIR / "BATTLE_SKILL_EFFECT_STREAMING_PROBE_RESULT.json"
SCENE = UNITY_DIR / "Assets" / "Scenes" / "BattleSkillEffectStreamingProbe.unity"
LOG = REPORT_DIR / "BATTLE_13_UNITY_SKILL_EFFECT_STREAMING.log"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def csv_write(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for row in rows:
            writer.writerow({field: row.get(field, "") for field in fields})


def main() -> None:
    candidates = read_json(CANDIDATES_JSON)
    unity_probe = read_json(UNITY_PROBE_JSON)
    bundle_results = {r.get("bundle", "").lower(): r for r in unity_probe.get("results", [])}
    skill_rows: list[dict[str, Any]] = []
    for skill in candidates.get("skills", []):
        bundles = skill.get("bundleCandidates", [])
        related_results = [bundle_results.get(b.get("bundle", "").lower(), {}) for b in bundles if b.get("bundle", "").lower() in bundle_results]
        load_success = sum(1 for r in related_results if r.get("loadSuccess"))
        load_fail = sum(1 for r in related_results if not r.get("loadSuccess"))
        prefab_count = sum(int(r.get("loadableEffectPrefabCount") or 0) for r in related_results)
        timeline_count = sum(int(r.get("matchingTimelinePrefabCount") or 0) for r in related_results)
        unresolved = skill.get("unresolvedReason", "")
        if not unresolved and not load_success:
            unresolved = "unity_assetbundle_load_failed"
        skill_rows.append(
            {
                "skillId": skill.get("skillId"),
                "owners": ";".join(f"{o.get('side')}:{o.get('heroDid')}" for o in skill.get("owners", [])),
                "luaEvidenceCount": len(skill.get("decodedLuaEvidence", [])),
                "skillFound": skill.get("skillFound"),
                "timelineFound": skill.get("timelineFound"),
                "bundleCandidateCount": len(bundles),
                "bundleExistsCount": sum(1 for b in bundles if b.get("exists")),
                "unityLoadSuccess": load_success,
                "unityLoadFail": load_fail,
                "timelinePrefabCandidateCount": timeline_count,
                "loadableEffectPrefabCount": prefab_count,
                "prefabDependencyCount": skill.get("prefabDependencyCount", 0),
                "unresolvedReason": unresolved,
            }
        )

    summary = {
        "skillIdsCount": len(skill_rows),
        "bundleCandidateCount": len(unity_probe.get("results", [])),
        "loadSuccess": unity_probe.get("summary", {}).get("loadSuccess", 0),
        "loadFail": unity_probe.get("summary", {}).get("loadFail", 0),
        "prefabCandidateCount": sum(int(r.get("loadableEffectPrefabCount") or 0) for r in unity_probe.get("results", [])),
        "timelineCandidateCount": sum(int(r.get("matchingTimelinePrefabCount") or 0) for r in unity_probe.get("results", [])),
        "instantiatedMarkerCount": unity_probe.get("summary", {}).get("instantiatedMarkerCount", 0),
        "scene": str(SCENE),
        "sceneExists": SCENE.exists(),
        "unityBatchmodeSuccess": "BattleSkillEffectStreamingProbe generated." in (LOG.read_text(encoding="utf-8", errors="replace") if LOG.exists() else ""),
        "json": str(FINAL_JSON),
        "report": str(REPORT_MD),
        "nextBattle14Recommendation": "loadable skill effect를 flow scene에 attach",
    }
    final_payload = {
        "status": "skill_effect_streaming_probe_complete",
        "summary": summary,
        "skills": enrich_skills(candidates.get("skills", []), bundle_results),
        "bundleProbeResults": unity_probe.get("results", []),
        "sourceEvidence": candidates.get("sourceEvidence", {}),
        "next": "BATTLE_14_ATTACH_LOADABLE_SKILL_EFFECT_TO_FLOW_SCENE",
    }
    FINAL_JSON.write_text(json.dumps(final_payload, ensure_ascii=False, indent=2), encoding="utf-8")
    RESULT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    csv_write(
        FINAL_CSV,
        skill_rows,
        [
            "skillId",
            "owners",
            "luaEvidenceCount",
            "skillFound",
            "timelineFound",
            "bundleCandidateCount",
            "bundleExistsCount",
            "unityLoadSuccess",
            "unityLoadFail",
            "timelinePrefabCandidateCount",
            "loadableEffectPrefabCount",
            "prefabDependencyCount",
            "unresolvedReason",
        ],
    )
    write_report(summary, skill_rows, unity_probe.get("results", []), candidates)
    print(json.dumps(summary, ensure_ascii=False, indent=2))


def enrich_skills(skills: list[dict[str, Any]], bundle_results: dict[str, dict[str, Any]]) -> list[dict[str, Any]]:
    enriched = []
    for skill in skills:
        copy = dict(skill)
        results = []
        for candidate in skill.get("bundleCandidates", []):
            result = bundle_results.get(candidate.get("bundle", "").lower())
            if result:
                results.append(
                    {
                        "bundle": result.get("bundle"),
                        "loadSuccess": result.get("loadSuccess"),
                        "assetNameCount": result.get("assetNameCount"),
                        "typeCounts": result.get("typeCounts"),
                        "matchingTimelinePrefabCount": result.get("matchingTimelinePrefabCount"),
                        "loadableEffectPrefabCount": result.get("loadableEffectPrefabCount"),
                        "instantiateSuccess": result.get("instantiateSuccess"),
                        "failReason": result.get("failReason"),
                    }
                )
        copy["unityBundleProbe"] = results
        enriched.append(copy)
    return enriched


def write_report(summary: dict[str, Any], skill_rows: list[dict[str, Any]], bundle_results: list[dict[str, Any]], candidates: dict[str, Any]) -> None:
    lines = [
        "# Battle Skill/Effect Streaming Probe Result",
        "",
        "## Outputs",
        f"- JSON: `{FINAL_JSON}`",
        f"- CSV: `{FINAL_CSV}`",
        f"- Scene: `{SCENE}`",
        f"- Unity bundle probe JSON: `{UNITY_PROBE_JSON}`",
        f"- Unity batchmode success: `{summary['unityBatchmodeSuccess']}`",
        "",
        "## Counts",
        f"- Skill ids: `{summary['skillIdsCount']}`",
        f"- Bundle candidates: `{summary['bundleCandidateCount']}`",
        f"- Bundle load success/fail: `{summary['loadSuccess']}/{summary['loadFail']}`",
        f"- Loadable effect prefab candidates: `{summary['prefabCandidateCount']}`",
        f"- Matching timeline prefab candidates: `{summary['timelineCandidateCount']}`",
        f"- Instantiated scene markers: `{summary['instantiatedMarkerCount']}`",
        "",
        "## Skill Rows",
        "| skillId | owners | lua | skill | timeline | bundles | exists | load ok | load fail | timeline prefabs | effect prefabs | unresolved |",
        "| ---: | --- | ---: | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |",
    ]
    for row in skill_rows:
        lines.append(
            f"| {row.get('skillId')} | {row.get('owners')} | {row.get('luaEvidenceCount')} | {row.get('skillFound')} | {row.get('timelineFound')} | {row.get('bundleCandidateCount')} | {row.get('bundleExistsCount')} | {row.get('unityLoadSuccess')} | {row.get('unityLoadFail')} | {row.get('timelinePrefabCandidateCount')} | {row.get('loadableEffectPrefabCount')} | {row.get('unresolvedReason')} |"
        )
    lines.extend(
        [
            "",
            "## Bundle Probe",
            "| bundle | exists | load | assets | GameObject | Texture2D | Material | TextAsset | timeline prefabs | loadable prefabs | instantiate | reason |",
            "| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |",
        ]
    )
    for result in bundle_results:
        types = result.get("typeCounts", {})
        lines.append(
            f"| {result.get('bundle')} | {result.get('fileExists')} | {result.get('loadSuccess')} | {result.get('assetNameCount')} | {types.get('GameObject',0)} | {types.get('Texture2D',0)} | {types.get('Material',0)} | {types.get('TextAsset',0)} | {result.get('matchingTimelinePrefabCount')} | {result.get('loadableEffectPrefabCount')} | {result.get('instantiateSuccess')} | {result.get('failReason','')} |"
        )
    lines.extend(
        [
            "",
            "## Script Evidence",
            f"- Flow manifest: `{candidates.get('sourceEvidence', {}).get('flowManifest', '')}`",
            f"- Prototype skills CSV: `{candidates.get('sourceEvidence', {}).get('prototypeSkills', '')}`",
            "- BATTLE_14 recommendation: `loadable skill effect를 flow scene에 attach`.",
        ]
    )
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
