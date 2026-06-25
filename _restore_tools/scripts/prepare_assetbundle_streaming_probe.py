from __future__ import annotations

import csv
import json
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
INDEX_DIR = MERGED / "indexes"
UNITY_DATA = BASE / "girlswar_battle_unity" / "Assets" / "RestoreData" / "battle"
LOAD_MAP = UNITY_DATA / "BATTLE_ASSETBUNDLE_LOAD_MAP.json"
VISUALS = UNITY_DATA / "BATTLE_ASSET_BACKED_PREVIEW_VISUALS.json"
TARGETS_CSV = UNITY_DATA / "BATTLE_ASSETBUNDLE_STREAMING_TARGETS.csv"
PREP_JSON = UNITY_DATA / "BATTLE_ASSETBUNDLE_STREAMING_TARGETS_PREP.json"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def norm(text: str) -> str:
    return text.replace("\\", "/").lower()


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    load_map = json.loads(LOAD_MAP.read_text(encoding="utf-8"))
    visuals = json.loads(VISUALS.read_text(encoding="utf-8"))
    bundle_index = {norm(r["bundle"]): r for r in read_csv(INDEX_DIR / "assetbundles.csv")}

    targets: list[dict[str, Any]] = []
    seen: set[str] = set()

    def add_target(kind: str, id_value: str, bundle: str, label: str) -> None:
        key = norm(bundle)
        if not key or key in seen:
            return
        seen.add(key)
        index_row = bundle_index.get(key, {})
        clean_slice = index_row.get("clean_slice", "")
        absolute = str(MERGED / clean_slice) if clean_slice else ""
        targets.append(
            {
                "kind": kind,
                "id": id_value,
                "label": label,
                "bundle": bundle,
                "absolutePath": absolute,
                "fileExists": Path(absolute).exists() if absolute else False,
                "size": Path(absolute).stat().st_size if absolute and Path(absolute).exists() else 0,
                "indexStatus": index_row.get("status", ""),
                "indexObjectCount": index_row.get("object_count", ""),
            }
        )

    for actor in load_map.get("actors", []):
        if actor.get("loadStatus") == "loadable_spine_bundle":
            add_target("actor", str(actor.get("heroDid", "")), actor.get("bundle", ""), f"{actor.get('side')}:{actor.get('heroDid')}")

    map_bundle = ""
    for row in load_map.get("mapCandidates", []):
        if row.get("bundle"):
            map_bundle = row["bundle"]
            break
    add_target("map", str(load_map.get("mapId", "11001")), map_bundle, "mapId:11001")

    summary = {
        "targetCount": len(targets),
        "existingFiles": sum(1 for t in targets if t["fileExists"]),
        "visualManifest": str(VISUALS),
        "visualAssetCopiedCount": visuals.get("summary", {}).get("visualAssetCopiedCount", 0),
    }
    write_csv(TARGETS_CSV, targets, ["kind", "id", "label", "bundle", "absolutePath", "fileExists", "size", "indexStatus", "indexObjectCount"])
    PREP_JSON.write_text(json.dumps({"summary": summary, "targets": targets}, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
