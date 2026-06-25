from __future__ import annotations

import csv
import json
import re
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = BASE / "reports" / "battle"
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
EXTRACTED = BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices"
DECODED = BASE / "girlswar_merged_extracted" / "decoded" / "xlua_battle"

FLOW = UNITY_DATA / "BATTLE_RUNTIME_FLOW_MANIFEST.json"
LOAD_MAP = UNITY_DATA / "BATTLE_ASSETBUNDLE_LOAD_MAP.json"
RESOURCE_TRACE = REPORT_DIR / "BATTLE_RESOURCE_TRACE.csv"
PROTOTYPE_SKILLS = REPORT_DIR / "BATTLE_PROTOTYPE_SKILLS.csv"
PROTOTYPE_BUNDLES = REPORT_DIR / "BATTLE_PROTOTYPE_BUNDLES.csv"
BATTLE08_SKILL_CANDIDATES = REPORT_DIR / "BATTLE_08_SKILL_BUNDLE_CANDIDATES.csv"

CANDIDATES_JSON = UNITY_DATA / "BATTLE_SKILL_EFFECT_STREAMING_CANDIDATES.json"
TARGETS_CSV = UNITY_DATA / "BATTLE_SKILL_EFFECT_STREAMING_TARGETS.csv"
PREP_JSON = REPORT_DIR / "BATTLE_SKILL_EFFECT_STREAMING_PREP.json"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def csv_write(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for row in rows:
            writer.writerow({field: row.get(field, "") for field in fields})


def norm_bundle(value: str) -> str:
    return value.replace("\\", "/").strip().lower()


def absolute_bundle(bundle: str) -> Path:
    return EXTRACTED / norm_bundle(bundle)


def derive_bundle_from_prefab(prefab_path: str) -> str:
    p = prefab_path.replace("\\", "/").strip()
    lower = p.lower()
    prefix = "assets/download/"
    if lower.startswith(prefix):
        lower = lower[len(prefix) :]
    if lower.startswith("skillprefabsandres/"):
        parts = lower.split("/")
        if len(parts) >= 2:
            return f"download/skillprefabsandres/{parts[1]}.assetbundle"
    if lower.startswith("commonprefabsandres/skilleffect/"):
        parts = lower.split("/")
        if len(parts) >= 4:
            return "download/" + "/".join(parts[:3]) + f"/{parts[3]}.assetbundle"
    return ""


def line_evidence(skill_id: int) -> list[dict[str, Any]]:
    result: list[dict[str, Any]] = []
    needle_a = f"[{skill_id}]"
    needle_b = f"Skill{skill_id}"
    folder = DECODED / "download_xlualogic_modules_battleskillscript"
    if not folder.exists():
        return result
    for path in folder.glob("*.lua"):
        name_hit = needle_b.lower() in path.name.lower()
        try:
            lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
        except OSError:
            continue
        for index, line in enumerate(lines, 1):
            if needle_a in line or needle_b in line or name_hit:
                result.append({"path": str(path), "line": index, "snippet": line.strip()[:220]})
                break
        if len(result) >= 4:
            break
    return result


def owners_by_skill(flow: dict[str, Any]) -> dict[int, list[dict[str, Any]]]:
    result: dict[int, list[dict[str, Any]]] = {}
    for actor in flow.get("actorSlots", []):
        for skill in actor.get("skillIds", []):
            sid = int(skill)
            result.setdefault(sid, []).append(
                {
                    "side": actor.get("side", ""),
                    "heroDid": actor.get("heroDid", ""),
                    "heroId": actor.get("heroId", ""),
                    "wave": actor.get("wave", 0),
                    "slot": actor.get("slot", 0),
                }
            )
    return result


def group_skill_rows(rows: list[dict[str, str]]) -> dict[int, list[dict[str, str]]]:
    grouped: dict[int, list[dict[str, str]]] = {}
    for row in rows:
        try:
            skill = int(row.get("skillDid") or 0)
        except ValueError:
            continue
        if skill:
            grouped.setdefault(skill, []).append(row)
    return grouped


def main() -> None:
    flow = read_json(FLOW)
    load_map = read_json(LOAD_MAP)
    skill_rows = group_skill_rows(read_csv(PROTOTYPE_SKILLS))
    candidate_rows = group_skill_rows(read_csv(BATTLE08_SKILL_CANDIDATES))
    bundle_trace = read_csv(PROTOTYPE_BUNDLES) + read_csv(RESOURCE_TRACE)
    owner_map = owners_by_skill(flow)
    skill_ids = [int(x) for x in flow.get("knownSkillIds", [])]

    skills: list[dict[str, Any]] = []
    targets_by_bundle: dict[str, dict[str, Any]] = {}

    for skill_id in skill_ids:
        rows = skill_rows.get(skill_id, [])
        b08_rows = candidate_rows.get(skill_id, [])
        owners = owner_map.get(skill_id, [])
        candidate_map: dict[str, dict[str, Any]] = {}
        prefab_ids: set[str] = set()
        prefab_deps: set[str] = set()
        audio_deps: set[str] = set()
        video_deps: set[str] = set()
        timeline_paths: set[str] = set()

        for row in rows:
            prefab_id = row.get("prefabId", "")
            if prefab_id:
                prefab_ids.add(prefab_id)
            if row.get("timelineAssetPath"):
                timeline_paths.add(row["timelineAssetPath"])
            for dep in row.get("prefabDeps", "").split("|"):
                dep = dep.strip()
                if dep:
                    prefab_deps.add(dep)
                    derived = derive_bundle_from_prefab(dep)
                    if derived:
                        candidate_map.setdefault(norm_bundle(derived), make_bundle_candidate(derived, "timeline_prefab_dep", skill_id))
            for dep in row.get("audioDeps", "").split("|"):
                if dep.strip():
                    audio_deps.add(dep.strip())
            for dep in row.get("videoDeps", "").split("|"):
                if dep.strip():
                    video_deps.add(dep.strip())
            if row.get("skillBundle"):
                candidate_map.setdefault(norm_bundle(row["skillBundle"]), make_bundle_candidate(row["skillBundle"], "skill_primary_bundle", skill_id))

        for row in b08_rows:
            bundle = row.get("normalizedBundle") or row.get("bundle") or ""
            if bundle:
                candidate_map.setdefault(norm_bundle(bundle), make_bundle_candidate(bundle, "battle08_candidate", skill_id))

        for row in bundle_trace:
            text = (row.get("referenced_by", "") + ";" + row.get("source", "")).lower()
            if f"skill:{skill_id}:" in text or f"timeline:{skill_id}" in text:
                bundle = row.get("bundle", "")
                if bundle:
                    candidate_map.setdefault(norm_bundle(bundle), make_bundle_candidate(bundle, row.get("kind", "bundle_trace"), skill_id))

        for candidate in candidate_map.values():
            target = targets_by_bundle.setdefault(
                norm_bundle(candidate["bundle"]),
                {
                    "kind": "skill_effect_bundle",
                    "id": norm_bundle(candidate["bundle"]).replace("/", "_").replace(".assetbundle", ""),
                    "label": candidate["bundle"],
                    "bundle": candidate["bundle"],
                    "absolutePath": str(absolute_bundle(candidate["bundle"])),
                    "skillIds": set(),
                    "expectedPrefabIds": set(),
                    "expectedTimelineAssets": set(),
                    "bundleExistsAtPrep": candidate["exists"],
                    "candidateSources": set(),
                },
            )
            target["skillIds"].add(str(skill_id))
            target["expectedPrefabIds"].update(prefab_ids)
            target["expectedTimelineAssets"].update(timeline_paths)
            target["candidateSources"].add(candidate["source"])

        unresolved = ""
        if not rows and not b08_rows:
            unresolved = "skill_datatable_or_timeline_not_joined"
        elif not any(c["exists"] for c in candidate_map.values()):
            unresolved = "bundle_candidates_missing_or_path_normalize_unresolved"
        elif not timeline_paths:
            unresolved = "timeline_asset_path_not_found"

        skills.append(
            {
                "skillId": skill_id,
                "owners": owners,
                "decodedLuaEvidence": line_evidence(skill_id),
                "skillFound": any((r.get("skillFound") or "").lower() == "true" for r in rows),
                "timelineFound": any((r.get("timelineFound") or "").lower() == "true" for r in rows),
                "prefabIds": sorted(prefab_ids),
                "timelineAssetPaths": sorted(timeline_paths),
                "prefabDependencyCount": len(prefab_deps),
                "audioDependencyCount": len(audio_deps),
                "videoDependencyCount": len(video_deps),
                "bundleCandidates": sorted(candidate_map.values(), key=lambda x: x["bundle"]),
                "unresolvedReason": unresolved,
            }
        )

    target_rows: list[dict[str, Any]] = []
    for target in targets_by_bundle.values():
        target_rows.append(
            {
                "kind": target["kind"],
                "id": target["id"],
                "label": target["label"],
                "bundle": target["bundle"],
                "absolutePath": target["absolutePath"],
                "skillIds": ";".join(sorted(target["skillIds"])),
                "expectedPrefabIds": ";".join(sorted(target["expectedPrefabIds"])),
                "expectedTimelineAssets": ";".join(sorted(target["expectedTimelineAssets"])),
                "bundleExistsAtPrep": target["bundleExistsAtPrep"],
                "candidateSources": ";".join(sorted(target["candidateSources"])),
            }
        )
    target_rows.sort(key=lambda r: r["bundle"])

    summary = {
        "skillIdsCount": len(skill_ids),
        "skillRecords": len(skills),
        "bundleCandidateCount": len(target_rows),
        "bundleCandidatesExistingAtPrep": sum(1 for t in target_rows if str(t["bundleExistsAtPrep"]).lower() == "true"),
        "flowManifest": str(FLOW),
        "loadMap": str(LOAD_MAP),
        "resourceTrace": str(RESOURCE_TRACE),
    }
    payload = {
        "status": "prepared",
        "summary": summary,
        "sourceEvidence": {
            "flowManifest": str(FLOW),
            "loadMap": str(LOAD_MAP),
            "resourceTrace": str(RESOURCE_TRACE),
            "prototypeSkills": str(PROTOTYPE_SKILLS),
            "battle08SkillCandidates": str(BATTLE08_SKILL_CANDIDATES),
        },
        "skills": skills,
        "targetsCsv": str(TARGETS_CSV),
        "unityProbeJson": str(UNITY_DATA / "BATTLE_SKILL_EFFECT_STREAMING_UNITY_BUNDLE_PROBE.json"),
    }
    CANDIDATES_JSON.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
    PREP_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    csv_write(
        TARGETS_CSV,
        target_rows,
        ["kind", "id", "label", "bundle", "absolutePath", "skillIds", "expectedPrefabIds", "expectedTimelineAssets", "bundleExistsAtPrep", "candidateSources"],
    )
    print(json.dumps(summary, ensure_ascii=False, indent=2))


def make_bundle_candidate(bundle: str, source: str, skill_id: int) -> dict[str, Any]:
    path = absolute_bundle(bundle)
    return {
        "skillId": skill_id,
        "bundle": norm_bundle(bundle),
        "absolutePath": str(path),
        "exists": path.exists(),
        "size": path.stat().st_size if path.exists() else 0,
        "normalizeNote": "as_normalized_lower_path",
        "source": source,
    }


if __name__ == "__main__":
    main()
