from __future__ import annotations

import csv
import json
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
INDEX_DIR = MERGED / "indexes"
REPORT_DIR = BASE / "reports" / "battle"
UNITY_BATTLE_DATA = BASE / "girlswar_battle_unity" / "Assets" / "RestoreData" / "battle"

MANIFEST_PATH = REPORT_DIR / "BATTLE_PROTOTYPE_MANIFEST.json"
PAYLOAD_PATH = REPORT_DIR / "BATTLE_TEST_PAYLOAD.json"
TRACE_CSV = REPORT_DIR / "BATTLE_RESOURCE_TRACE.csv"
BUNDLES_CSV = REPORT_DIR / "BATTLE_PROTOTYPE_BUNDLES.csv"
SKILLS_CSV = REPORT_DIR / "BATTLE_PROTOTYPE_SKILLS.csv"
RESOURCE_INDEX_CSV = UNITY_BATTLE_DATA / "resource_index.csv"

ASSETBUNDLES_CSV = INDEX_DIR / "assetbundles.csv"
UNITY_OBJECTS_CSV = INDEX_DIR / "unity_objects.csv"
UNITY_IMAGES_CSV = INDEX_DIR / "unity_images.csv"
UNITY_TEXTASSETS_CSV = INDEX_DIR / "unity_textassets.csv"
VERSIONFILE_CDN_CSV = INDEX_DIR / "versionfile_CDNVersionFile_bytes.csv"

LOAD_MAP_JSON = UNITY_BATTLE_DATA / "BATTLE_ASSETBUNDLE_LOAD_MAP.json"
OUT_ACTORS = REPORT_DIR / "BATTLE_08_ACTOR_LOAD_CANDIDATES.csv"
OUT_ENEMY = REPORT_DIR / "BATTLE_08_ENEMY_DATATABLE_CANDIDATES.csv"
OUT_MAP = REPORT_DIR / "BATTLE_08_MAP_CANDIDATES.csv"
OUT_SKILLS = REPORT_DIR / "BATTLE_08_SKILL_BUNDLE_CANDIDATES.csv"
OUT_MISSING = REPORT_DIR / "BATTLE_08_MISSING_CLASSIFICATION.csv"
OUT_RESULT_JSON = REPORT_DIR / "BATTLE_08_ASSETBUNDLE_SPINE_LOADING_RESULT.json"
OUT_REPORT_MD = REPORT_DIR / "BATTLE_ASSETBUNDLE_SPINE_LOADING_PLAN.md"

sys.path.insert(0, str(Path(__file__).parent))
import build_battle_prototype_manifest as b5  # noqa: E402


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def write_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def norm(value: str | Path | None) -> str:
    return str(value or "").replace("\\", "/").lower()


def rel(path: str | Path | None) -> str:
    if not path:
        return ""
    p = Path(path)
    try:
        return str(p.relative_to(BASE)).replace("\\", "/")
    except Exception:
        return str(path).replace("\\", "/")


def load_manifest() -> dict[str, Any]:
    return json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))


def by_bundle(rows: list[dict[str, str]]) -> dict[str, list[dict[str, str]]]:
    out: dict[str, list[dict[str, str]]] = defaultdict(list)
    for row in rows:
        out[norm(row.get("bundle"))].append(row)
    return out


def load_index_subset(wanted_bundles: set[str]) -> dict[str, Any]:
    bundle_rows = read_csv(ASSETBUNDLES_CSV)
    bundle_by_name = {norm(r.get("bundle")): r for r in bundle_rows}
    wanted = {norm(b) for b in wanted_bundles if b}
    objects = []
    images = []
    textassets = []
    for path, dest in [(UNITY_OBJECTS_CSV, objects), (UNITY_IMAGES_CSV, images), (UNITY_TEXTASSETS_CSV, textassets)]:
        with path.open("r", encoding="utf-8-sig", newline="") as f:
            reader = csv.DictReader(f)
            for row in reader:
                if norm(row.get("bundle")) in wanted:
                    dest.append(row)
    return {
        "bundleByName": bundle_by_name,
        "objectsByBundle": by_bundle(objects),
        "imagesByBundle": by_bundle(images),
        "textassetsByBundle": by_bundle(textassets),
    }


def bundle_exists(bundle: str, bundle_by_name: dict[str, dict[str, str]]) -> bool:
    row = bundle_by_name.get(norm(bundle))
    return bool(row and row.get("status") == "ok")


def bundle_counts(bundle: str, objects_by_bundle: dict[str, list[dict[str, str]]]) -> dict[str, int]:
    return dict(Counter(row.get("type", "") for row in objects_by_bundle.get(norm(bundle), [])))


def candidate_bundle_for_prefab(prefab_id: Any) -> str:
    return f"download/roleprefabsandres/battleprefabandres/{prefab_id}.assetbundle" if prefab_id else ""


def normalize_timeline_bundle(bundle: str, bundle_by_name: dict[str, dict[str, str]]) -> tuple[str, str]:
    b = norm(bundle)
    if b in bundle_by_name:
        return bundle, "as_listed"
    m = re.match(r"(download/commonprefabsandres/skilleffect/[^/]+)/(?:[^/]+)\.assetbundle$", b)
    if m:
        candidate = m.group(1) + ".assetbundle"
        if candidate in bundle_by_name:
            return candidate, "normalized_timeline_asset_path_to_bundle"
    return bundle, "not_found"


def cdn_has_bundle(bundle: str) -> bool:
    target = norm(bundle)
    if not target:
        return False
    with VERSIONFILE_CDN_CSV.open("r", encoding="utf-8-sig", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            if norm(row.get("path")) == target or norm(row.get("file")) == target or target in norm(",".join(row.values())):
                return True
    return False


def asset_candidates(bundle: str, indexes: dict[str, Any]) -> dict[str, Any]:
    b = norm(bundle)
    textassets = indexes["textassetsByBundle"].get(b, [])
    images = indexes["imagesByBundle"].get(b, [])
    objects = indexes["objectsByBundle"].get(b, [])
    skel = [r for r in textassets if r.get("name", "").lower().endswith(".skel")]
    atlas = [r for r in textassets if r.get("name", "").lower().endswith(".atlas")]
    textures = [r for r in images if r.get("type") == "Texture2D"]
    materials = [r for r in objects if r.get("type") == "Material"]
    game_objects = [r for r in objects if r.get("type") == "GameObject"]
    return {
        "skeletonData": skel[0].get("output", "") if skel else "",
        "atlas": atlas[0].get("output", "") if atlas else "",
        "texture": textures[0].get("output", "") if textures else "",
        "material": materials[0].get("path_id", "") if materials else "",
        "gameObject": game_objects[0].get("path_id", "") if game_objects else "",
        "skelCandidates": len(skel),
        "atlasCandidates": len(atlas),
        "textureCandidates": len(textures),
        "materialCandidates": len(materials),
        "gameObjectCandidates": len(game_objects),
        "typeCounts": bundle_counts(bundle, indexes["objectsByBundle"]),
    }


def load_enemy_tables() -> tuple[dict[int, dict[str, Any]], dict[int, dict[str, Any]], dict[int, dict[str, Any]]]:
    textassets = b5.load_textasset_map()
    model_table = b5.load_table("model", "DTmodelEntity", "DTmodelEntityTableData", textassets)
    monster_k = b5.load_table("monster_k", "DTMonster_KEntity", "DTMonster_KEntityTableData", textassets)
    monster_o = b5.load_table("monster_o", "DTMonster_OEntity", "DTMonster_OEntityTableData", textassets)
    return model_table.rows, monster_k.rows, monster_o.rows


def skill_candidate_rows(indexes: dict[str, Any], bundle_by_name: dict[str, dict[str, str]]) -> tuple[list[dict[str, Any]], dict[str, int]]:
    skill_rows = read_csv(SKILLS_CSV)
    rows: list[dict[str, Any]] = []
    seen = set()
    for row in skill_rows:
        key = (row.get("skillDid"), row.get("prefabId"), row.get("skillBundle"), row.get("timelineFound"))
        if key in seen:
            continue
        seen.add(key)
        bundle = row.get("skillBundle", "")
        normalized, note = normalize_timeline_bundle(bundle, bundle_by_name)
        exists = bundle_exists(normalized, bundle_by_name)
        counts = bundle_counts(normalized, indexes["objectsByBundle"]) if exists else {}
        rows.append(
            {
                "side": row.get("side", ""),
                "ownerHeroDid": row.get("ownerHeroDid", ""),
                "skillDid": row.get("skillDid", ""),
                "skillFound": row.get("skillFound", ""),
                "prefabId": row.get("prefabId", ""),
                "timelineFound": row.get("timelineFound", ""),
                "bundle": bundle,
                "normalizedBundle": normalized,
                "bundleExists": exists,
                "normalizeNote": note,
                "gameObjects": counts.get("GameObject", 0),
                "particleSystems": counts.get("ParticleSystem", 0),
                "materials": counts.get("Material", 0),
                "textures": counts.get("Texture2D", 0),
            }
        )
    stats = {
        "skillRows": len(skill_rows),
        "uniqueSkillCandidates": len(rows),
        "skillFoundRows": sum(1 for r in skill_rows if str(r.get("skillFound")).lower() == "true"),
        "skillMissingRows": sum(1 for r in skill_rows if str(r.get("skillFound")).lower() != "true"),
        "bundleCandidateExists": sum(1 for r in rows if r["bundleExists"]),
    }
    return rows, stats


def build() -> dict[str, Any]:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    UNITY_BATTLE_DATA.mkdir(parents=True, exist_ok=True)
    manifest = load_manifest()
    payload = json.loads(PAYLOAD_PATH.read_text(encoding="utf-8"))
    bundle_csv_rows = read_csv(BUNDLES_CSV)

    model_rows, monster_k_rows, monster_o_rows = load_enemy_tables()

    listed_bundles = {r.get("bundle", "") for r in bundle_csv_rows}
    actor_bundles = {a.get("actorBundle", "") for a in manifest.get("actors", [])}
    enemy_candidate_bundles: set[str] = set()
    enemy_prefill: dict[int, dict[str, Any]] = {}
    for actor in manifest.get("actors", []):
        if actor.get("side") != "enemy":
            continue
        hero_did = int(actor.get("payloadHeroDid") or 0)
        candidate = monster_k_rows.get(hero_did) or monster_o_rows.get(hero_did)
        source = "DTMonster_K" if hero_did in monster_k_rows else ("DTMonster_O" if hero_did in monster_o_rows else "")
        if not candidate:
            continue
        model_id = candidate.get("modelID", "")
        model_candidate = model_rows.get(int(model_id or 0))
        prefab_id = model_candidate.get("prefabId", "") if model_candidate else model_id
        bundle = candidate_bundle_for_prefab(prefab_id)
        enemy_candidate_bundles.add(bundle)
        enemy_prefill[hero_did] = {
            "source": source,
            "modelId": model_id,
            "prefabId": prefab_id,
            "bundle": bundle,
        }
    map_bundles = {b.get("bundle", "") for b in manifest.get("map", {}).get("bundles", [])}
    skill_bundles = {r.get("skillBundle", "") for r in read_csv(SKILLS_CSV)}
    normalized_skill_bundles_seed = set()
    raw_bundle_index = {norm(r.get("bundle")): r for r in read_csv(ASSETBUNDLES_CSV)}
    for b in listed_bundles | skill_bundles:
        normalized_skill_bundles_seed.add(normalize_timeline_bundle(b, raw_bundle_index)[0])
    wanted_bundles = {b for b in listed_bundles | actor_bundles | enemy_candidate_bundles | map_bundles | skill_bundles | normalized_skill_bundles_seed if b}
    indexes = load_index_subset(wanted_bundles)
    bundle_by_name = indexes["bundleByName"]

    actor_rows: list[dict[str, Any]] = []
    enemy_rows: list[dict[str, Any]] = []
    load_actors: list[dict[str, Any]] = []

    for actor in manifest.get("actors", []):
        side = actor.get("side")
        hero_did = int(actor.get("payloadHeroDid") or 0)
        bundle = actor.get("actorBundle") or ""
        model_id = actor.get("modelId")
        prefab_id = actor.get("prefabId")
        enemy_source = ""
        enemy_reason = ""
        enemy_model_id = ""
        enemy_prefab_id = ""
        enemy_bundle = ""
        enemy_bundle_exists = False
        if side == "enemy":
            candidate = enemy_prefill.get(hero_did)
            if candidate:
                enemy_source = candidate["source"]
                enemy_model_id = candidate["modelId"]
                enemy_prefab_id = candidate["prefabId"]
                enemy_bundle = candidate["bundle"]
                enemy_bundle_exists = bundle_exists(enemy_bundle, bundle_by_name)
                enemy_reason = "resolved_via_monster_variant_table"
                if not bundle:
                    bundle = enemy_bundle
                    model_id = enemy_model_id
                    prefab_id = enemy_prefab_id
            else:
                enemy_reason = "payload_derived_monster_id_not_found_in_extracted_DTMonster_KO"
            enemy_rows.append(
                {
                    "heroDid": hero_did,
                    "payloadHeroId": actor.get("payloadHeroId", ""),
                    "waveNo": actor.get("waveNo", ""),
                    "missingReasonBeforeB08": "BATTLE_05_used_DTMonster_main_only",
                    "candidateTable": enemy_source,
                    "candidateModelId": enemy_model_id,
                    "candidatePrefabId": enemy_prefab_id,
                    "candidateBundle": enemy_bundle,
                    "candidateBundleExists": enemy_bundle_exists,
                    "candidateStatus": enemy_reason,
                }
            )
        bundle = bundle or ""
        exists = bundle_exists(bundle, bundle_by_name)
        candidates = asset_candidates(bundle, indexes) if exists else {
            "skeletonData": "",
            "atlas": "",
            "texture": "",
            "material": "",
            "gameObject": "",
            "skelCandidates": 0,
            "atlasCandidates": 0,
            "textureCandidates": 0,
            "materialCandidates": 0,
            "gameObjectCandidates": 0,
            "typeCounts": {},
        }
        load_status = "loadable_spine_bundle" if exists and candidates["skeletonData"] and candidates["atlas"] and candidates["texture"] else "not_loadable_yet"
        if not exists and cdn_has_bundle(bundle):
            load_status = "listed_in_cdn_versionfile_not_extracted"
        elif not exists and side == "enemy" and enemy_source:
            load_status = "enemy_datatable_resolved_bundle_missing_or_not_extracted"
        actor_row = {
            "side": side,
            "waveNo": actor.get("waveNo", ""),
            "heroDid": hero_did,
            "heroId": actor.get("payloadHeroId", ""),
            "model": model_id or "",
            "prefab": prefab_id or "",
            "bundle": bundle,
            "exists": exists,
            "skeletonData": candidates["skeletonData"],
            "atlas": candidates["atlas"],
            "texture": candidates["texture"],
            "material": candidates["material"],
            "gameObject": candidates["gameObject"],
            "loadStatus": load_status,
            "skelCandidates": candidates["skelCandidates"],
            "atlasCandidates": candidates["atlasCandidates"],
            "textureCandidates": candidates["textureCandidates"],
            "materialCandidates": candidates["materialCandidates"],
            "gameObjectCandidates": candidates["gameObjectCandidates"],
        }
        actor_rows.append(actor_row)
        load_actors.append(actor_row)

    map_rows: list[dict[str, Any]] = []
    for bundle in sorted(map_bundles):
        exists = bundle_exists(bundle, bundle_by_name)
        counts = bundle_counts(bundle, indexes["objectsByBundle"]) if exists else {}
        images = indexes["imagesByBundle"].get(norm(bundle), [])
        for image in images or [{}]:
            map_rows.append(
                {
                    "mapId": manifest.get("summary", {}).get("mapId"),
                    "bundle": bundle,
                    "exists": exists,
                    "assetType": image.get("type", ""),
                    "name": image.get("name", ""),
                    "width": image.get("width", ""),
                    "height": image.get("height", ""),
                    "output": image.get("output", ""),
                    "spriteCount": counts.get("Sprite", 0),
                    "textureCount": counts.get("Texture2D", 0),
                    "gameObjectCount": counts.get("GameObject", 0),
                }
            )

    skill_rows, skill_stats = skill_candidate_rows(indexes, bundle_by_name)

    missing_rows: list[dict[str, Any]] = []
    for row in bundle_csv_rows:
        bundle = row.get("bundle", "")
        if str(row.get("exists")).lower() == "true":
            continue
        normalized, note = normalize_timeline_bundle(bundle, bundle_by_name)
        exists_after = bundle_exists(normalized, bundle_by_name)
        classification = "path_normalize_issue" if exists_after else "missing_extracted_bundle"
        if cdn_has_bundle(bundle):
            classification = "listed_in_cdn_versionfile_not_extracted"
        if row.get("kind") == "actor_spine" and "1036" in bundle:
            classification = "listed_in_cdn_versionfile_not_extracted" if cdn_has_bundle(bundle) else classification
        missing_rows.append(
            {
                "kind": row.get("kind", ""),
                "bundle": bundle,
                "normalizedBundle": normalized,
                "existsAfterNormalize": exists_after,
                "classification": classification,
                "referencedBy": row.get("referenced_by", ""),
                "source": row.get("source", ""),
            }
        )

    load_map = {
        "status": "prepared",
        "manifest": "Assets/RestoreData/battle/BATTLE_PROTOTYPE_MANIFEST.json",
        "payload": "Assets/RestoreData/battle/BATTLE_TEST_PAYLOAD.json",
        "mapId": manifest.get("summary", {}).get("mapId"),
        "battleType": manifest.get("summary", {}).get("battleType"),
        "randomSeed": manifest.get("summary", {}).get("randomSeed"),
        "actors": load_actors,
        "mapCandidates": map_rows,
        "skillCandidates": skill_rows,
        "missingClassification": missing_rows,
    }

    summary = {
        "actorTotal": len(actor_rows),
        "actorLoadable": sum(1 for r in actor_rows if r["loadStatus"] == "loadable_spine_bundle"),
        "ourActorLoadable": sum(1 for r in actor_rows if r["side"] == "our" and r["loadStatus"] == "loadable_spine_bundle"),
        "enemyResolvedViaKO": sum(1 for r in enemy_rows if r["candidateTable"]),
        "enemyCandidateBundleExisting": sum(1 for r in enemy_rows if r["candidateBundleExists"]),
        "mapCandidateRows": len(map_rows),
        "skillCandidateRows": skill_stats["uniqueSkillCandidates"],
        "skillFoundRows": skill_stats["skillFoundRows"],
        "skillMissingRows": skill_stats["skillMissingRows"],
        "remainingMissing": dict(Counter(r["classification"] for r in missing_rows)),
        "inputFiles": {
            "manifest": str(MANIFEST_PATH),
            "payload": str(PAYLOAD_PATH),
            "traceCsvExists": TRACE_CSV.exists(),
            "bundlesCsv": str(BUNDLES_CSV),
            "resourceIndex": str(RESOURCE_INDEX_CSV),
        },
        "loadMap": str(LOAD_MAP_JSON),
    }
    load_map["summary"] = summary

    write_json(LOAD_MAP_JSON, load_map)
    write_json(OUT_RESULT_JSON, {"summary": summary, "loadMap": str(LOAD_MAP_JSON)})
    write_csv(
        OUT_ACTORS,
        actor_rows,
        ["side", "waveNo", "heroDid", "heroId", "model", "prefab", "bundle", "exists", "skeletonData", "atlas", "texture", "material", "gameObject", "loadStatus", "skelCandidates", "atlasCandidates", "textureCandidates", "materialCandidates", "gameObjectCandidates"],
    )
    write_csv(
        OUT_ENEMY,
        enemy_rows,
        ["heroDid", "payloadHeroId", "waveNo", "missingReasonBeforeB08", "candidateTable", "candidateModelId", "candidatePrefabId", "candidateBundle", "candidateBundleExists", "candidateStatus"],
    )
    write_csv(
        OUT_MAP,
        map_rows,
        ["mapId", "bundle", "exists", "assetType", "name", "width", "height", "output", "spriteCount", "textureCount", "gameObjectCount"],
    )
    write_csv(
        OUT_SKILLS,
        skill_rows,
        ["side", "ownerHeroDid", "skillDid", "skillFound", "prefabId", "timelineFound", "bundle", "normalizedBundle", "bundleExists", "normalizeNote", "gameObjects", "particleSystems", "materials", "textures"],
    )
    write_csv(
        OUT_MISSING,
        missing_rows,
        ["kind", "bundle", "normalizedBundle", "existsAfterNormalize", "classification", "referencedBy", "source"],
    )
    write_report(summary, actor_rows, enemy_rows, map_rows, skill_rows, missing_rows)
    return summary


def write_report(summary: dict[str, Any], actors: list[dict[str, Any]], enemies: list[dict[str, Any]], maps: list[dict[str, Any]], skills: list[dict[str, Any]], missing: list[dict[str, Any]]) -> None:
    def table(headers: list[str], rows: list[dict[str, Any]], limit: int | None = None) -> list[str]:
        out = ["| " + " | ".join(headers) + " |", "| " + " | ".join("---" for _ in headers) + " |"]
        for row in rows[:limit]:
            out.append("| " + " | ".join(str(row.get(h, "")).replace("|", "/") for h in headers) + " |")
        return out

    lines = [
        "# Battle AssetBundle / Spine Loading Plan",
        "",
        "## Outputs",
        f"- Load map: `{LOAD_MAP_JSON}`",
        f"- Actor candidates: `{OUT_ACTORS}`",
        f"- Enemy datatable candidates: `{OUT_ENEMY}`",
        f"- Map candidates: `{OUT_MAP}`",
        f"- Skill candidates: `{OUT_SKILLS}`",
        f"- Missing classification: `{OUT_MISSING}`",
        "",
        "## Summary",
        f"- Actor loadable: `{summary['actorLoadable']}` / `{summary['actorTotal']}`",
        f"- Our actor loadable: `{summary['ourActorLoadable']}` / `3`",
        f"- Enemy ids resolved through K/O monster tables: `{summary['enemyResolvedViaKO']}` / `9`",
        f"- Enemy candidate bundles existing: `{summary['enemyCandidateBundleExisting']}` / `9`",
        f"- Map candidate rows: `{summary['mapCandidateRows']}`",
        f"- Skill candidates: `{summary['skillCandidateRows']}`; skill rows found/missing: `{summary['skillFoundRows']}` / `{summary['skillMissingRows']}`",
        f"- Remaining missing classification: `{summary['remainingMissing']}`",
        "",
        "## Actor Load Candidates",
        *table(["side", "heroDid", "model", "prefab", "exists", "loadStatus", "skeletonData", "atlas", "texture"], actors),
        "",
        "## Enemy Datatable Reinforcement",
        *table(["heroDid", "candidateTable", "candidateModelId", "candidatePrefabId", "candidateBundle", "candidateBundleExists", "candidateStatus"], enemies),
        "",
        "## Map 11001 Candidates",
        *table(["mapId", "assetType", "name", "width", "height", "output"], maps, 12),
        "",
        "## Skill Candidate Snapshot",
        *table(["skillDid", "skillFound", "prefabId", "timelineFound", "normalizedBundle", "bundleExists", "normalizeNote"], skills, 40),
        "",
        "## Missing Bundle Classification",
        *table(["kind", "bundle", "normalizedBundle", "existsAfterNormalize", "classification"], missing),
    ]
    OUT_REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    summary = build()
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
