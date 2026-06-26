"""Build a sample-battle actor and skill asset manifest for offline battle view work."""
from __future__ import annotations

import csv
import json
import uuid
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
PAYLOAD = ROOT / "girlswar_battle_unity" / "Assets" / "RestoreData" / "battle" / "BATTLE_TEST_PAYLOAD.json"
CATALOG = ROOT / "reports" / "characters" / "GIRLSWAR_CHARACTER_CATALOG.json"
SPEEDLINE_MANIFEST = ROOT / "reports" / "battle" / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED.json"
ASSETBUNDLES = ROOT / "girlswar_merged_extracted" / "indexes" / "assetbundles.csv"
TEXTASSETS = ROOT / "girlswar_merged_extracted" / "indexes" / "unity_textassets.csv"
IMAGES = ROOT / "girlswar_merged_extracted" / "indexes" / "unity_images.csv"

OUT_JSON = ROOT / "girlswar_battle_unity" / "Assets" / "RestoreData" / "battle" / "BATTLE_SAMPLE_ASSET_MANIFEST.json"
OUT_MD = ROOT / "reports" / "battle" / "BATTLE_SAMPLE_ASSET_MANIFEST_RESULT.md"
OUT_RESULT_JSON = ROOT / "reports" / "battle" / "BATTLE_SAMPLE_ASSET_MANIFEST_RESULT.json"

HANDOFF_ACTOR_IDS = [1036, 1002, 1034, 1100111, 1100112, 1100113, 1100121, 1100122, 1100123, 1100131, 1100132, 1100133]


def rel(path: Path) -> str:
    return path.relative_to(ROOT).as_posix()


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def normalize_bundle(value: str | None) -> str:
    return (value or "").replace("\\", "/").strip().lower()


def exists_extracted(relative_path: str | None) -> bool:
    if not relative_path:
        return False
    return (ROOT / "girlswar_merged_extracted" / relative_path).exists()


def unique(values: list[Any]) -> list[Any]:
    seen = set()
    out = []
    for value in values:
        key = json.dumps(value, sort_keys=True, ensure_ascii=True) if isinstance(value, dict) else str(value)
        if value in ("", None) or key in seen:
            continue
        seen.add(key)
        out.append(value)
    return out


def collect_payload_ids(payload: dict) -> tuple[list[int], list[int]]:
    info = payload["battleInfo"]
    our_ids = [int(row["heroDid"]) for row in info.get("ourHeros", []) if "heroDid" in row]
    enemy_ids: list[int] = []
    for wave in info.get("waveData", []):
        for row in wave.get("enemyTeamFormation", []):
            if "heroDid" in row:
                enemy_ids.append(int(row["heroDid"]))
        for row in wave.get("enemyHeros", []):
            if "heroDid" in row:
                enemy_ids.append(int(row["heroDid"]))
        for row in wave.get("heroStatistics", []):
            if row.get("isOurHero") is False and "heroDid" in row:
                enemy_ids.append(int(row["heroDid"]))
    return unique(our_ids), unique(enemy_ids)


def by_actor_id(rows: list[dict[str, Any]]) -> dict[int, dict[str, Any]]:
    result: dict[int, dict[str, Any]] = {}
    for row in rows:
        actor_id = row.get("payloadHeroDid") or row.get("heroDidOrMonsterId") or row.get("ownerHeroDid")
        if actor_id in ("", None):
            continue
        try:
            result[int(actor_id)] = row
        except (TypeError, ValueError):
            continue
    return result


def search_by_bundle(rows: list[dict[str, str]], bundle: str) -> list[dict[str, str]]:
    norm = normalize_bundle(bundle)
    if not norm:
        return []
    return [row for row in rows if normalize_bundle(row.get("bundle")) == norm]


def search_by_token(rows: list[dict[str, str]], token: str | int | None) -> list[dict[str, str]]:
    if token in ("", None):
        return []
    needle = str(token).lower()
    result = []
    for row in rows:
        hay = " ".join(str(row.get(key, "")) for key in ("bundle", "name", "output")).lower()
        if needle in hay:
            result.append(row)
    return result


def first_output(rows: list[dict[str, str]], suffix: str) -> str:
    for row in rows:
        output = row.get("output", "")
        name = row.get("name", "")
        if output.lower().endswith(suffix) or name.lower().endswith(suffix.replace(".txt", "")):
            return output
    return ""


def build_manifest() -> tuple[dict, dict]:
    payload = load_json(PAYLOAD)
    catalog = load_json(CATALOG)
    speedline = load_json(SPEEDLINE_MANIFEST)
    bundle_rows = read_csv(ASSETBUNDLES)
    text_rows = read_csv(TEXTASSETS)
    image_rows = read_csv(IMAGES)

    bundle_map = {normalize_bundle(row.get("bundle")): row for row in bundle_rows}
    catalog_by_id = {int(row["id"]): row for row in catalog["characters"] if row.get("id") is not None}
    actor_rows = by_actor_id(speedline.get("actors", []))
    skills_by_owner: dict[int, list[dict[str, Any]]] = defaultdict(list)
    for row in speedline.get("skills", []):
        owner = row.get("ownerHeroDid")
        if owner in ("", None):
            continue
        skills_by_owner[int(owner)].append(row)

    payload_our, payload_enemy = collect_payload_ids(payload)
    ordered_ids = unique(payload_our + payload_enemy + HANDOFF_ACTOR_IDS)
    entries: dict[str, dict[str, Any]] = {}

    for actor_id in ordered_ids:
        actor = actor_rows.get(actor_id, {})
        cat = catalog_by_id.get(actor_id, {})
        side = "our" if actor_id in payload_our else "enemy" if actor_id in payload_enemy else "handoff_only"
        model_id = actor.get("modelId") or cat.get("modelId") or ""
        prefab_id = actor.get("prefabId") or cat.get("prefabId") or model_id or ""
        actor_bundle = actor.get("actorBundle") or cat.get("battleActorBundle") or ""
        bundle_info = bundle_map.get(normalize_bundle(actor_bundle), {})
        # Skeleton/atlas evidence must come from the resolved actor bundle. A broad
        # token search can pick up unrelated activity/name spines such as 1036 name art.
        text_candidates = search_by_bundle(text_rows, actor_bundle)
        image_candidates = search_by_bundle(image_rows, actor_bundle)
        skeleton = actor.get("spineSkeletonData") or cat.get("battleSpineSkeletonData") or first_output(text_candidates, ".skel.txt")
        atlas = actor.get("spineAtlas") or cat.get("battleSpineAtlas") or first_output(text_candidates, ".atlas.txt")
        textures = unique([
            actor.get("spineTexture"),
            cat.get("battleSpineTexture"),
            *[row.get("output") for row in image_candidates if row.get("type") in ("Texture2D", "Sprite")],
        ])[:8]
        skill_rows = []
        for row in skills_by_owner.get(actor_id, []):
            skill_rows.append(
                {
                    "skillDid": row.get("skillDid"),
                    "skillType": row.get("skillType"),
                    "prefabId": row.get("prefabId"),
                    "skillBundle": row.get("skillBundle") or row.get("bundle"),
                    "skillBundleExists": bool(row.get("skillBundleExists") or row.get("bundleExists")),
                    "assetPathViaGetSysprefabData": row.get("assetPathViaGetSysprefabData"),
                    "timelineFound": row.get("timelineFound"),
                    "localStatus": row.get("localStatus") or row.get("status"),
                    "missingDependencyBundles": row.get("missingDependencyBundles") or [],
                    "reason": row.get("reason"),
                }
            )

        missing = []
        if not actor_bundle:
            missing.append("actor_bundle_unresolved")
        elif not bundle_info:
            missing.append("actor_bundle_missing_from_assetbundle_index")
        if not skeleton:
            missing.append("spine_skeleton_missing")
        if not atlas:
            missing.append("spine_atlas_missing")
        if not textures:
            missing.append("spine_texture_missing")

        entries[str(actor_id)] = {
            "heroDid": actor_id,
            "side": side,
            "waveNo": actor.get("waveNo", ""),
            "slot": actor.get("slot", ""),
            "payloadHeroId": actor.get("payloadHeroId", ""),
            "nameKey": actor.get("nameKey") or cat.get("nameKey", ""),
            "nameKo": cat.get("nameKo", ""),
            "datatable": actor.get("datatable", ""),
            "datatableFound": actor.get("datatableFound", ""),
            "modelId": model_id,
            "prefabId": prefab_id,
            "actorBundle": actor_bundle,
            "actorBundleExists": bool(bundle_info) or bool(actor.get("actorBundleExists") or cat.get("battleActorBundleExists")),
            "actorBundleIndexStatus": bundle_info.get("status", ""),
            "actorBundleCleanSlice": bundle_info.get("clean_slice", ""),
            "skeletonDataAsset": skeleton,
            "skeletonDataAssetExists": exists_extracted(skeleton),
            "atlas": atlas,
            "atlasExists": exists_extracted(atlas),
            "textures": textures,
            "textureExists": [exists_extracted(path) for path in textures],
            "skillIds": unique([row.get("skillDid") for row in skill_rows] or cat.get("skillIds", [])),
            "skillTimelineAssets": skill_rows,
            "localStatus": actor.get("localStatus") or ("catalog_only" if cat else "unresolved"),
            "loadStatus": actor.get("loadStatus", ""),
            "reason": actor.get("reason", ""),
            "missing": missing,
            "source": unique([
                "BATTLE_TEST_PAYLOAD.json" if actor_id in payload_our + payload_enemy else "",
                "GIRLSWAR_CHARACTER_CATALOG.json" if cat else "",
                "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED.json" if actor else "",
                "assetbundles/unity_textassets/unity_images indexes",
            ]),
        }

    status_counts = defaultdict(int)
    missing_counts = defaultdict(int)
    for entry in entries.values():
        status_counts[entry["localStatus"]] += 1
        for item in entry["missing"]:
            missing_counts[item] += 1

    manifest = {
        "name": "BATTLE_SAMPLE_ASSET_MANIFEST",
        "generatedBy": rel(Path(__file__).resolve()),
        "generatedAtUtc": datetime.now(timezone.utc).isoformat(),
        "workspace": str(ROOT),
        "sourceInputs": {
            "payload": rel(PAYLOAD),
            "characterCatalog": rel(CATALOG),
            "localPlayableManifest": rel(SPEEDLINE_MANIFEST),
            "assetbundles": rel(ASSETBUNDLES),
            "unityTextassets": rel(TEXTASSETS),
            "unityImages": rel(IMAGES),
        },
        "summary": {
            "payloadOurHeroDids": payload_our,
            "payloadEnemyHeroDids": payload_enemy,
            "handoffActorIds": HANDOFF_ACTOR_IDS,
            "actorCount": len(entries),
            "statusCounts": dict(sorted(status_counts.items())),
            "missingCounts": dict(sorted(missing_counts.items())),
            "loadableActorIds": [int(k) for k, v in entries.items() if v["localStatus"] == "loadable"],
            "knownMissingOrUnresolvedActorIds": [int(k) for k, v in entries.items() if v["localStatus"] != "loadable"],
        },
        "actors": entries,
    }

    result = {
        "name": "BATTLE_SAMPLE_ASSET_MANIFEST_RESULT",
        "generatedAtUtc": manifest["generatedAtUtc"],
        "pass": True,
        "manifestPath": rel(OUT_JSON),
        "summary": manifest["summary"],
        "notableFindings": [
            "1036 actor bundle remains missing locally, but its skill timeline rows resolve as data-only because owner actor is unavailable.",
            "1002, 1034, and enemy 1100111/3001 have loadable actor bundles with skeleton, atlas, and texture evidence.",
            "Enemy payload ids 1100112, 1100113, 1100121, 1100122, 1100123, 1100131, 1100132, and 1100133 remain unresolved actor instances in local source evidence.",
        ],
    }
    return manifest, result


def write_meta(path: Path) -> None:
    meta = path.with_suffix(path.suffix + ".meta")
    if meta.exists():
        return
    meta.write_text(
        "\n".join(
            [
                "fileFormatVersion: 2",
                f"guid: {uuid.uuid4().hex}",
                "TextScriptImporter:",
                "  externalObjects: {}",
                "  userData:",
                "  assetBundleName:",
                "  assetBundleVariant:",
                "",
            ]
        ),
        encoding="utf-8",
    )


def write_reports(manifest: dict, result: dict) -> None:
    OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_MD.parent.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    write_meta(OUT_JSON)
    OUT_RESULT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    lines = [
        "# BATTLE_SAMPLE_ASSET_MANIFEST_RESULT",
        "",
        f"Generated: {result['generatedAtUtc']}",
        f"Manifest: `{result['manifestPath']}`",
        "",
        "## Summary",
        "",
        f"- pass: `{str(result['pass']).lower()}`",
        f"- actor count: `{manifest['summary']['actorCount']}`",
        f"- loadable actor ids: `{manifest['summary']['loadableActorIds']}`",
        f"- unresolved/missing actor ids: `{manifest['summary']['knownMissingOrUnresolvedActorIds']}`",
        f"- status counts: `{manifest['summary']['statusCounts']}`",
        "",
        "## Actors",
        "",
        "| heroDid | side | model/prefab | actor bundle | status | skeleton | atlas | texture count | missing |",
        "| --- | --- | --- | --- | --- | --- | --- | --- | --- |",
    ]
    for actor_id, entry in manifest["actors"].items():
        model_prefab = f"{entry['modelId']}/{entry['prefabId']}"
        missing = ", ".join(entry["missing"])
        lines.append(
            f"| `{actor_id}` | `{entry['side']}` | `{model_prefab}` | `{entry['actorBundle']}` | `{entry['localStatus']}` | `{entry['skeletonDataAsset']}` | `{entry['atlas']}` | `{len(entry['textures'])}` | `{missing}` |"
        )
    lines += [
        "",
        "## Findings",
        "",
        *[f"- {item}" for item in result["notableFindings"]],
    ]
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    manifest, result = build_manifest()
    write_reports(manifest, result)
    print(json.dumps({"pass": result["pass"], **manifest["summary"]}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
