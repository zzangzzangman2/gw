from __future__ import annotations

import csv
import json
import re
import shutil
from collections import Counter
from pathlib import Path

import UnityPy


SOURCE_ROOT = Path(r"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted")
PROJECT_ROOT = Path(r"C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity")
MAIN_BUNDLE = "download/ui/uiprefabandres/maininterface.assetbundle"

RESTORE_DATA = PROJECT_ROOT / "Assets" / "RestoreData"
SPRITE_DEST_ROOT = PROJECT_ROOT / "Assets" / "RestoredSprites" / "maininterface"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, fieldnames: list[str], rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def clean_slice(bundle: str) -> Path:
    return SOURCE_ROOT / "extracted" / "unity" / "clean_unityfs_slices" / Path(bundle)


def cab_name_from_external_path(path: str) -> str:
    match = re.search(r"(CAB-[0-9a-fA-F]+)", path)
    return match.group(1) if match else path


def safe_segment(value: str, limit: int = 80) -> str:
    value = value.replace("\\", "_").replace("/", "_")
    value = re.sub(r"[^0-9A-Za-z._-]+", "_", value).strip("._")
    if not value:
        value = "unnamed"
    return value[:limit]


def get_main_externals() -> list[dict[str, str]]:
    env = UnityPy.load(clean_slice(MAIN_BUNDLE).read_bytes())
    first = next(iter(env.objects))
    externals = first.assets_file.externals
    result: list[dict[str, str]] = []
    for index, external in enumerate(externals, start=1):
        external_path = str(getattr(external, "path", ""))
        result.append(
            {
                "file_id": str(index),
                "external_path": external_path,
                "cab_name": cab_name_from_external_path(external_path),
            }
        )
    return result


def build_cab_to_bundle(related_bundles: list[str]) -> dict[str, str]:
    cab_to_bundle: dict[str, str] = {}
    global_index = SOURCE_ROOT / "indexes" / "unity_cab_to_bundle.csv"
    if global_index.exists():
        for row in read_csv(global_index):
            cab_to_bundle.setdefault(row.get("cab_name", ""), row.get("bundle", ""))
    for bundle in related_bundles:
        path = clean_slice(bundle)
        if not path.exists():
            continue
        try:
            env = UnityPy.load(path.read_bytes())
            names = sorted({obj.assets_file.name for obj in env.objects})
        except Exception:
            continue
        for name in names:
            cab_to_bundle.setdefault(name, bundle)
    return cab_to_bundle


def parse_sprite_ref(value: str) -> tuple[int, int] | None:
    value = (value or "").strip()
    if not value or value == "0":
        return None
    if ":" not in value:
        return None
    file_id, path_id = value.split(":", 1)
    try:
        return int(file_id), int(path_id)
    except ValueError:
        return None


def unity_asset_path(abs_path: Path) -> str:
    return abs_path.relative_to(PROJECT_ROOT).as_posix()


def main() -> None:
    images = read_csv(RESTORE_DATA / "maininterface_images.csv")
    related_images = read_csv(RESTORE_DATA / "maininterface_related_images.csv")
    export_map = read_csv(RESTORE_DATA / "maininterface_related_export_map.csv")

    related_bundles = [row["bundle"] for row in export_map]
    externals = get_main_externals()
    external_by_file_id = {int(row["file_id"]): row for row in externals}
    cab_to_bundle = build_cab_to_bundle(related_bundles)

    by_bundle_path: dict[tuple[str, str], dict[str, str]] = {}
    global_images_path = SOURCE_ROOT / "indexes" / "unity_images.csv"
    manual_images_path = (
        SOURCE_ROOT
        / "extracted"
        / "unity"
        / "manual_sprite_reextract"
        / "maininterface"
        / "manual_sprite_reextract.csv"
    )
    image_indexes = [related_images]
    if global_images_path.exists():
        image_indexes.append(read_csv(global_images_path))
    if manual_images_path.exists():
        image_indexes.append(read_csv(manual_images_path))
    for table in image_indexes:
        for row in table:
            if row.get("type") != "Sprite":
                continue
            by_bundle_path.setdefault((row.get("bundle", ""), row.get("path_id", "")), row)
    if manual_images_path.exists():
        for row in read_csv(manual_images_path):
            if row.get("type") != "Sprite" or row.get("error"):
                continue
            by_bundle_path[(row.get("bundle", ""), row.get("path_id", ""))] = row

    SPRITE_DEST_ROOT.mkdir(parents=True, exist_ok=True)

    rows: list[dict[str, str]] = []
    copied = 0
    statuses: Counter[str] = Counter()
    unique_sources: set[str] = set()
    for image in images:
        sprite_ref = image.get("sprite_ref", "")
        parsed = parse_sprite_ref(sprite_ref)
        file_id = ""
        path_id = ""
        external_path = ""
        cab_name = ""
        dependency_bundle = ""
        source_output = ""
        source_name = ""
        width = ""
        height = ""
        asset_path = ""
        status = "empty_sprite_ref"

        if parsed is not None:
            file_id_int, path_id_int = parsed
            file_id = str(file_id_int)
            path_id = str(path_id_int)
            if file_id_int == 0:
                dependency_bundle = MAIN_BUNDLE
            elif file_id_int in external_by_file_id:
                ext = external_by_file_id[file_id_int]
                external_path = ext["external_path"]
                cab_name = ext["cab_name"]
                if external_path == "Library/unity default resources":
                    status = "default_resource_skip"
                else:
                    dependency_bundle = cab_to_bundle.get(cab_name, "")
                    if not dependency_bundle:
                        status = "missing_dependency_bundle"
            else:
                status = "external_file_id_out_of_range"

            if dependency_bundle:
                sprite = by_bundle_path.get((dependency_bundle, path_id))
                if sprite:
                    source_output = sprite.get("output", "")
                    source_name = sprite.get("name", "")
                    width = sprite.get("width", "")
                    height = sprite.get("height", "")
                    src = SOURCE_ROOT / source_output
                    if source_output and src.exists():
                        bundle_dir = safe_segment(dependency_bundle.replace(".assetbundle", ""))
                        filename = f"fid{file_id}_{path_id}_{safe_segment(source_name, 70)}.png"
                        dst = SPRITE_DEST_ROOT / bundle_dir / filename
                        dst.parent.mkdir(parents=True, exist_ok=True)
                        if not dst.exists() or dst.stat().st_size != src.stat().st_size:
                            shutil.copy2(src, dst)
                        asset_path = unity_asset_path(dst)
                        status = "ready"
                        copied += 1
                        unique_sources.add(source_output)
                    else:
                        status = "missing_extracted_sprite_png"
                elif status == "empty_sprite_ref":
                    status = "missing_sprite_path_id"
                elif status not in {
                    "default_resource_skip",
                    "missing_dependency_bundle",
                    "external_file_id_out_of_range",
                }:
                    status = "missing_sprite_path_id"

        statuses[status] += 1
        rows.append(
            {
                "component_path_id": image.get("component_path_id", ""),
                "game_object_id": image.get("game_object_id", ""),
                "game_object_name": image.get("game_object_name", ""),
                "sprite_ref": sprite_ref,
                "file_id": file_id,
                "path_id": path_id,
                "external_path": external_path,
                "cab_name": cab_name,
                "dependency_bundle": dependency_bundle,
                "sprite_name": source_name,
                "width": width,
                "height": height,
                "source_output": source_output,
                "unity_asset_path": asset_path,
                "raycast_target": image.get("raycast_target", ""),
                "maskable": image.get("maskable", ""),
                "image_type": image.get("image_type", ""),
                "preserve_aspect": image.get("preserve_aspect", ""),
                "fill_method": image.get("fill_method", ""),
                "fill_amount": image.get("fill_amount", ""),
                "color_r": image.get("color_r", ""),
                "color_g": image.get("color_g", ""),
                "color_b": image.get("color_b", ""),
                "color_a": image.get("color_a", ""),
                "status": status,
            }
        )

    write_csv(
        RESTORE_DATA / "maininterface_sprite_map.csv",
        [
            "component_path_id",
            "game_object_id",
            "game_object_name",
            "sprite_ref",
            "file_id",
            "path_id",
            "external_path",
            "cab_name",
            "dependency_bundle",
            "sprite_name",
            "width",
            "height",
            "source_output",
            "unity_asset_path",
            "raycast_target",
            "maskable",
            "image_type",
            "preserve_aspect",
            "fill_method",
            "fill_amount",
            "color_r",
            "color_g",
            "color_b",
            "color_a",
            "status",
        ],
        rows,
    )
    write_csv(
        RESTORE_DATA / "maininterface_external_dependencies.csv",
        ["file_id", "external_path", "cab_name", "dependency_bundle"],
        [
            {
                **row,
                "dependency_bundle": cab_to_bundle.get(row["cab_name"], ""),
            }
            for row in externals
        ],
    )

    summary = {
        "image_components": len(images),
        "external_dependencies": len(externals),
        "resolved_external_bundles": sum(1 for row in externals if cab_to_bundle.get(row["cab_name"])),
        "copied_sprite_assignments": copied,
        "unique_sprite_pngs": len(unique_sources),
        "statuses": dict(sorted(statuses.items())),
    }
    (RESTORE_DATA / "maininterface_sprite_summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
