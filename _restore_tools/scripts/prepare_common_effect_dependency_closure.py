from __future__ import annotations

import csv
import json
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
EXTRACTED = BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices"

SKILL_PROBE = UNITY_DATA / "BATTLE_SKILL_EFFECT_STREAMING_PROBE.json"
ATTACH_MANIFEST = UNITY_DATA / "BATTLE_FLOW_SKILL_EFFECT_ATTACH_MANIFEST.json"
PROTOTYPE_SKILLS = REPORT_DIR / "BATTLE_PROTOTYPE_SKILLS.csv"
RESOURCE_INDEX = UNITY_DATA / "resource_index.csv"
CLOSURE_JSON = UNITY_DATA / "BATTLE_COMMON_EFFECT_DEPENDENCY_CLOSURE.json"
PLAYABLE_MARKER_JSON = UNITY_DATA / "BATTLE_SKILL_EFFECT_PLAYABLE_MARKER_MANIFEST.json"
PREP_JSON = REPORT_DIR / "BATTLE_COMMON_EFFECT_DEPENDENCY_CLOSURE_PREP.json"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def norm(value: str) -> str:
    return value.replace("\\", "/").strip().lower()


def find_aggregate_common_bundle(name: str) -> Path | None:
    root = EXTRACTED / "download" / "commonprefabsandres" / "skilleffect"
    if not root.exists():
        return None
    wanted = name.lower().replace(".assetbundle", "")
    exact = root / f"{wanted}.assetbundle"
    if exact.exists():
        return exact
    for path in root.rglob("*.assetbundle"):
        lower = path.as_posix().lower()
        if wanted in lower:
            return path
    return None


def header(path: Path | None) -> str:
    if not path or not path.exists():
        return ""
    return path.read_bytes()[:16].decode("ascii", errors="replace")


def skill_rows_by_id(rows: list[dict[str, str]]) -> dict[int, list[dict[str, str]]]:
    result: dict[int, list[dict[str, str]]] = {}
    for row in rows:
        try:
            sid = int(row.get("skillDid") or 0)
        except ValueError:
            continue
        if sid:
            result.setdefault(sid, []).append(row)
    return result


def classify_unresolved(skill: dict[str, Any], proto_rows: list[dict[str, str]]) -> dict[str, Any]:
    skill_id = int(skill.get("skillId", 0))
    skill_types = sorted({row.get("skillType", "") for row in proto_rows if row.get("skillType", "")})
    any_skill_found = any((row.get("skillFound") or "").lower() == "true" for row in proto_rows)
    any_timeline_found = any((row.get("timelineFound") or "").lower() == "true" for row in proto_rows)
    has_bundle_candidates = bool(skill.get("bundleCandidates"))
    lua_evidence_count = len(skill.get("decodedLuaEvidence", []))
    actor_missing = any(o.get("heroDid") == "1036" for o in skill.get("owners", []))

    if "2" in skill_types and not any_timeline_found and not has_bundle_candidates:
        category = "passive/no-effect skill"
        detail = "skillType=2 with no timeline or prefab bundle candidate in prototype skill table"
    elif not has_bundle_candidates:
        category = "skill id to bundle join missing"
        detail = "no skill bundle candidate was produced from datatable/timeline joins"
    elif actor_missing:
        category = "actor/model bundle missing linked issue"
        detail = "owner actor 1036 battle model bundle is still missing, but skill bundle may exist independently"
    else:
        category = "common dependency path normalize issue"
        detail = "candidate exists in dependency path but did not resolve to an extracted file"

    return {
        "skillId": skill_id,
        "category": category,
        "detail": detail,
        "skillTypes": skill_types,
        "skillFound": any_skill_found,
        "timelineFound": any_timeline_found,
        "luaEvidenceCount": lua_evidence_count,
        "owners": skill.get("owners", []),
        "previousReason": skill.get("unresolvedReason", ""),
    }


def main() -> None:
    skill_probe = read_json(SKILL_PROBE)
    attach_manifest = read_json(ATTACH_MANIFEST)
    proto_by_skill = skill_rows_by_id(read_csv(PROTOTYPE_SKILLS))
    resource_rows = read_csv(RESOURCE_INDEX)
    unresolved_ids = {int(row.get("skillId")) for row in attach_manifest.get("unresolvedSkills", [])}
    skills_by_id = {int(row.get("skillId")): row for row in skill_probe.get("skills", [])}
    classifications = [classify_unresolved(skills_by_id.get(sid, {"skillId": sid}), proto_by_skill.get(sid, [])) for sid in sorted(unresolved_ids)]

    failed_common: dict[str, dict[str, Any]] = {}
    for result in skill_probe.get("bundleProbeResults", []):
        bundle = result.get("bundle", "")
        if result.get("loadSuccess") is False and "commonprefabsandres" in bundle:
            leaf = Path(norm(bundle)).stem
            aggregate = find_aggregate_common_bundle("commonskillprefabsandres1")
            failed_common[norm(bundle)] = {
                "dependencyName": leaf,
                "failedBundle": norm(bundle),
                "failedReason": result.get("failReason", ""),
                "aggregateBundle": "download/commonprefabsandres/skilleffect/commonskillprefabsandres1.assetbundle",
                "absolutePath": str(aggregate) if aggregate else "",
                "aggregateExists": bool(aggregate and aggregate.exists()),
                "aggregateHeader": header(aggregate),
                "resourceIndexHits": sum(1 for row in resource_rows if leaf in (row.get("bundle", "") + row.get("referenced_by", "")).lower()),
            }

    markers = []
    for index, attachment in enumerate(attach_manifest.get("attachments", [])):
        prefab = attachment.get("prefabAsset", "")
        playable = prefab[:-7] + ".playable" if prefab.endswith(".prefab") else prefab + ".playable"
        markers.append(
            {
                "skillId": attachment.get("skillId"),
                "side": attachment.get("side"),
                "heroDid": attachment.get("heroDid"),
                "bundle": attachment.get("bundle"),
                "absolutePath": attachment.get("absolutePath"),
                "prefabAsset": prefab,
                "expectedPlayableAsset": playable,
                "x": round(float(attachment.get("x", 0)), 3),
                "y": round(float(attachment.get("y", 0)) + 0.48, 3),
                "scale": 0.14,
                "markerIndex": index,
            }
        )

    closure = {
        "status": "prepared_common_effect_dependency_closure",
        "sourceEvidence": {
            "skillProbe": str(SKILL_PROBE),
            "attachManifest": str(ATTACH_MANIFEST),
            "prototypeSkills": str(PROTOTYPE_SKILLS),
            "resourceIndex": str(RESOURCE_INDEX),
        },
        "unresolvedSkillClassifications": classifications,
        "commonDependencyTargets": list(failed_common.values()),
        "counts": {
            "unresolvedSkills": len(classifications),
            "passiveNoEffectSkills": sum(1 for row in classifications if row["category"] == "passive/no-effect skill"),
            "commonDependencyTargets": len(failed_common),
            "commonAggregateFound": sum(1 for row in failed_common.values() if row["aggregateExists"]),
            "playableMarkersPlanned": len(markers),
        },
    }
    playable_manifest = {
        "status": "prepared_playable_marker_manifest",
        "scene": "Assets/Scenes/BattleRuntimeFlowSkillEffectPlayableMarkers.unity",
        "sourceAttachManifest": str(ATTACH_MANIFEST),
        "markers": markers,
        "counts": {
            "markers": len(markers),
            "uniqueBundles": len({m["bundle"] for m in markers}),
        },
    }
    CLOSURE_JSON.write_text(json.dumps(closure, ensure_ascii=False, indent=2), encoding="utf-8")
    PLAYABLE_MARKER_JSON.write_text(json.dumps(playable_manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    PREP_JSON.write_text(json.dumps({"closure": closure["counts"], "playable": playable_manifest["counts"]}, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({"closure": closure["counts"], "playable": playable_manifest["counts"]}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
