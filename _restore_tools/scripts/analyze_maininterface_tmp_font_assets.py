from __future__ import annotations

import csv
import gzip
import json
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
PROJECT = BASE / "girlswar_maininterface_unity"
REPORT_DATA = PROJECT / "Assets" / "RestoreData" / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"

EXPORT_MAP_CSV = MERGED / "indexes" / "unity_bundle_export_map.csv"
ASSETBUNDLES_CSV = MERGED / "indexes" / "assetbundles.csv"

OUT_BUNDLES_CSV = REPORT_DATA / "maininterface_tmp_font_bundle_inventory.csv"
OUT_FONT_ASSETS_CSV = REPORT_DATA / "maininterface_tmp_font_assets.csv"
OUT_MATERIALS_CSV = REPORT_DATA / "maininterface_tmp_font_materials.csv"
OUT_TEXTURES_CSV = REPORT_DATA / "maininterface_tmp_font_textures.csv"
OUT_SUMMARY_JSON = REPORT_DATA / "maininterface_tmp_font_assets_summary.json"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_TMP_FONT_ASSET_INVENTORY.md"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def load_json(path: Path) -> Any:
    if not path.exists():
        return None
    return json.loads(path.read_text(encoding="utf-8"))


def iter_structure(path: Path):
    if not path.exists():
        return
    with gzip.open(path, "rt", encoding="utf-8", errors="replace") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                yield json.loads(line)
            except json.JSONDecodeError:
                continue


def ref_path_id(value: Any) -> str:
    if isinstance(value, dict):
        return str(value.get("m_PathID", ""))
    return ""


def classify_bundle(bundle: str) -> str:
    lower = bundle.lower()
    if lower == "download/commonprefabsandres/tmpshaders.assetbundle":
        return "tmp_shaders"
    if "/tmp/" in lower:
        return "tmp_font_asset"
    if "/font_material_" in lower:
        return "font_material_preset"
    if "/font/" in lower:
        return "source_font"
    if lower.endswith("font_view.assetbundle") or lower.endswith("font_new_view.assetbundle"):
        return "font_view_prefabs"
    return "uifont_other"


def image_inventory(export_dir: Path) -> tuple[int, str]:
    image_dir = export_dir / "images"
    if not image_dir.exists():
        return 0, ""
    images = sorted(path.relative_to(export_dir).as_posix() for path in image_dir.rglob("*.png"))
    return len(images), ";".join(images[:8])


def material_shader_name(tree: dict[str, Any]) -> str:
    shader = tree.get("m_Shader")
    if isinstance(shader, dict):
        return ref_path_id(shader)
    return ""


def color_value(saved_properties: Any, key: str) -> str:
    if not isinstance(saved_properties, dict):
        return ""
    colors = saved_properties.get("m_Colors") or []
    if not isinstance(colors, list):
        return ""
    for item in colors:
        if not isinstance(item, dict):
            continue
        first = item.get("first")
        second = item.get("second")
        name = ""
        if isinstance(first, dict):
            name = str(first.get("name", ""))
        elif isinstance(first, str):
            name = first
        if name != key or not isinstance(second, dict):
            continue
        return ",".join(str(second.get(k, "")) for k in ("r", "g", "b", "a"))
    return ""


def read_assetbundle_status() -> dict[str, dict[str, str]]:
    result: dict[str, dict[str, str]] = {}
    if not ASSETBUNDLES_CSV.exists():
        return result
    for row in read_csv(ASSETBUNDLES_CSV):
        result[row.get("bundle", "").lower()] = row
    return result


def main() -> None:
    export_rows = read_csv(EXPORT_MAP_CSV)
    status_by_bundle = read_assetbundle_status()

    target_rows = [
        row for row in export_rows
        if row.get("bundle", "").lower().startswith("download/ui/uifont/")
        or row.get("bundle", "").lower() == "download/commonprefabsandres/tmpshaders.assetbundle"
    ]

    bundle_rows: list[dict[str, Any]] = []
    font_asset_rows: list[dict[str, Any]] = []
    material_rows: list[dict[str, Any]] = []
    texture_rows: list[dict[str, Any]] = []
    type_counter: Counter[str] = Counter()
    class_counter: Counter[str] = Counter()
    image_counter = 0

    for row in sorted(target_rows, key=lambda r: r.get("bundle", "")):
        bundle = row.get("bundle", "")
        export_dir = MERGED / row.get("export_dir", "")
        type_counts = load_json(export_dir / "type_counts.json") or {}
        bundle_class = classify_bundle(bundle)
        class_counter[bundle_class] += 1
        image_count, image_samples = image_inventory(export_dir)
        image_counter += image_count
        status = status_by_bundle.get(bundle.lower(), {})

        for type_name, count in type_counts.items():
            type_counter[str(type_name)] += int(count)

        bundle_rows.append({
            "bundle": bundle,
            "class": bundle_class,
            "export_dir": str(export_dir),
            "parse_status": status.get("parse_status", ""),
            "object_count": status.get("object_count", ""),
            "used_offset": status.get("used_offset", ""),
            "size": status.get("size", ""),
            "type_counts": json.dumps(type_counts, ensure_ascii=False, sort_keys=True),
            "image_count": image_count,
            "image_samples": image_samples,
        })

        for obj in iter_structure(export_dir / "structure.jsonl.gz"):
            obj_type = obj.get("type", "")
            path_id = str(obj.get("path_id", ""))
            tree = obj.get("tree") or {}
            if not isinstance(tree, dict):
                continue

            if obj_type == "MonoBehaviour" and (
                "m_FaceInfo" in tree or "m_GlyphTable" in tree or "m_CharacterTable" in tree
            ):
                face = tree.get("m_FaceInfo") or {}
                creation = tree.get("m_CreationSettings") or {}
                atlas_textures = tree.get("m_AtlasTextures") or []
                if not isinstance(atlas_textures, list):
                    atlas_textures = []
                font_asset_rows.append({
                    "bundle": bundle,
                    "export_dir": str(export_dir),
                    "path_id": path_id,
                    "name": tree.get("m_Name", ""),
                    "script_path_id": ref_path_id(tree.get("m_Script")),
                    "version": tree.get("m_Version", ""),
                    "family_name": face.get("m_FamilyName", ""),
                    "style_name": face.get("m_StyleName", ""),
                    "point_size": face.get("m_PointSize", ""),
                    "line_height": face.get("m_LineHeight", ""),
                    "ascent_line": face.get("m_AscentLine", ""),
                    "descent_line": face.get("m_DescentLine", ""),
                    "source_font_guid": tree.get("m_SourceFontFileGUID", ""),
                    "source_font_path_id": ref_path_id(tree.get("m_SourceFontFile")),
                    "material_path_id": ref_path_id(tree.get("material")),
                    "atlas_width": tree.get("m_AtlasWidth", ""),
                    "atlas_height": tree.get("m_AtlasHeight", ""),
                    "atlas_padding": tree.get("m_AtlasPadding", ""),
                    "atlas_render_mode": tree.get("m_AtlasRenderMode", ""),
                    "atlas_texture_path_ids": ";".join(ref_path_id(v) for v in atlas_textures),
                    "atlas_path_id": ref_path_id(tree.get("atlas")),
                    "glyph_count": len(tree.get("m_GlyphTable") or []),
                    "character_count": len(tree.get("m_CharacterTable") or []),
                    "fallback_count": len(tree.get("m_FallbackFontAssetTable") or []),
                    "creation_point_size": creation.get("pointSize", ""),
                    "creation_render_mode": creation.get("renderMode", ""),
                })

            elif obj_type == "Material":
                saved = tree.get("m_SavedProperties")
                material_rows.append({
                    "bundle": bundle,
                    "export_dir": str(export_dir),
                    "path_id": path_id,
                    "name": tree.get("m_Name", ""),
                    "shader_path_id": material_shader_name(tree),
                    "main_texture_path_id": ref_path_id(
                        (tree.get("m_SavedProperties") or {}).get("m_TexEnvs", [{}])[0].get("second", {}).get("m_Texture")
                    ) if isinstance((tree.get("m_SavedProperties") or {}).get("m_TexEnvs"), list)
                    and (tree.get("m_SavedProperties") or {}).get("m_TexEnvs") else "",
                    "face_color": color_value(saved, "_FaceColor"),
                    "outline_color": color_value(saved, "_OutlineColor"),
                })

            elif obj_type == "Texture2D":
                texture_rows.append({
                    "bundle": bundle,
                    "export_dir": str(export_dir),
                    "path_id": path_id,
                    "name": tree.get("m_Name", ""),
                    "width": tree.get("m_Width", ""),
                    "height": tree.get("m_Height", ""),
                    "texture_format": tree.get("m_TextureFormat", ""),
                    "mip_count": tree.get("m_MipCount", ""),
                })

            elif obj_type == "Font":
                font_asset_rows.append({
                    "bundle": bundle,
                    "export_dir": str(export_dir),
                    "path_id": path_id,
                    "name": tree.get("m_Name", ""),
                    "script_path_id": "",
                    "version": "",
                    "family_name": tree.get("m_Name", ""),
                    "style_name": "source Font object",
                    "point_size": "",
                    "line_height": "",
                    "ascent_line": "",
                    "descent_line": "",
                    "source_font_guid": "",
                    "source_font_path_id": "",
                    "material_path_id": "",
                    "atlas_width": "",
                    "atlas_height": "",
                    "atlas_padding": "",
                    "atlas_render_mode": "",
                    "atlas_texture_path_ids": "",
                    "atlas_path_id": "",
                    "glyph_count": "",
                    "character_count": "",
                    "fallback_count": "",
                    "creation_point_size": "",
                    "creation_render_mode": "",
                })

    summary = {
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "target_bundle_count": len(bundle_rows),
        "bundle_classes": dict(class_counter),
        "aggregate_type_counts": dict(type_counter),
        "tmp_font_asset_rows": len([r for r in font_asset_rows if r.get("version")]),
        "source_font_type_count": int(type_counter.get("Font", 0)),
        "source_font_structured_rows": len([r for r in font_asset_rows if r.get("style_name") == "source Font object"]),
        "material_type_count": int(type_counter.get("Material", 0)),
        "material_structured_rows": len(material_rows),
        "texture2d_type_count": int(type_counter.get("Texture2D", 0)),
        "texture2d_structured_rows": len(texture_rows),
        "extracted_png_images": image_counter,
        "font_families": sorted({str(r.get("family_name", "")) for r in font_asset_rows if r.get("family_name")}),
        "verdict": "original TMP font assets are present in uifont/tmp bundles and should drive TMP TextMeshProUGUI restoration",
    }

    write_csv(
        OUT_BUNDLES_CSV,
        bundle_rows,
        ["bundle", "class", "export_dir", "parse_status", "object_count", "used_offset", "size", "type_counts", "image_count", "image_samples"],
    )
    write_csv(
        OUT_FONT_ASSETS_CSV,
        font_asset_rows,
        [
            "bundle", "export_dir", "path_id", "name", "script_path_id", "version", "family_name", "style_name",
            "point_size", "line_height", "ascent_line", "descent_line", "source_font_guid", "source_font_path_id",
            "material_path_id", "atlas_width", "atlas_height", "atlas_padding", "atlas_render_mode",
            "atlas_texture_path_ids", "atlas_path_id", "glyph_count", "character_count", "fallback_count",
            "creation_point_size", "creation_render_mode",
        ],
    )
    write_csv(
        OUT_MATERIALS_CSV,
        material_rows,
        ["bundle", "export_dir", "path_id", "name", "shader_path_id", "main_texture_path_id", "face_color", "outline_color"],
    )
    write_csv(
        OUT_TEXTURES_CSV,
        texture_rows,
        ["bundle", "export_dir", "path_id", "name", "width", "height", "texture_format", "mip_count"],
    )
    OUT_SUMMARY_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_SUMMARY_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    md: list[str] = []
    md.append("# MainInterface TMP Font Asset Inventory")
    md.append("")
    md.append(f"Generated: {summary['generated_at']}")
    md.append("")
    md.append("## Verdict")
    md.append("")
    md.append("원본 TMP 폰트 에셋은 `download/ui/uifont/japanese/tmp` 번들 안에 실제로 존재한다. 따라서 MainInterface TMP-like 텍스트는 OS 폰트 fallback이 아니라 이 TMP FontAsset/Material/Texture 근거를 사용해 복원해야 한다.")
    md.append("")
    md.append("## Counts")
    md.append("")
    md.append("| item | value |")
    md.append("| --- | ---: |")
    md.append(f"| target font/shader bundles | {summary['target_bundle_count']} |")
    md.append(f"| TMP FontAsset structured rows | {summary['tmp_font_asset_rows']} |")
    md.append(f"| source Font objects in type counts | {summary['source_font_type_count']} |")
    md.append(f"| source Font structured rows | {summary['source_font_structured_rows']} |")
    md.append(f"| Material objects in type counts | {summary['material_type_count']} |")
    md.append(f"| Material structured rows | {summary['material_structured_rows']} |")
    md.append(f"| Texture2D objects in type counts | {summary['texture2d_type_count']} |")
    md.append(f"| Texture2D structured rows | {summary['texture2d_structured_rows']} |")
    md.append(f"| extracted PNG atlas/images | {summary['extracted_png_images']} |")
    md.append("")
    md.append("## Extraction Gap")
    md.append("")
    md.append("`type_counts.json` 기준으로 Font/Material/Texture2D 오브젝트는 존재하지만, 현재 `structure.jsonl.gz`에는 여러 폰트 번들의 Material/Texture 트리가 직렬화되어 있지 않다. 따라서 지금 단계에서는 TMP FontAsset의 glyph/metric/pathID와 추출 PNG atlas를 우선 근거로 쓰고, face/outline/shader property까지 필요하면 해당 uifont 번들을 Material/Texture 포함 모드로 재추출해야 한다.")
    md.append("")
    md.append("## Bundle Classes")
    md.append("")
    md.append("| class | count |")
    md.append("| --- | ---: |")
    for key, value in sorted(summary["bundle_classes"].items()):
        md.append(f"| `{key}` | {value} |")
    md.append("")
    md.append("## Font Families")
    md.append("")
    for family in summary["font_families"]:
        md.append(f"- `{family}`")
    md.append("")
    md.append("## Atlas/Image Samples")
    md.append("")
    md.append("| bundle | class | images | samples |")
    md.append("| --- | --- | ---: | --- |")
    shown_images = 0
    for row in bundle_rows:
        if int(row.get("image_count") or 0) <= 0:
            continue
        md.append(
            f"| `{row['bundle']}` | `{row['class']}` | {row['image_count']} | "
            f"`{row['image_samples']}` |"
        )
        shown_images += 1
        if shown_images >= 20:
            break
    md.append("")
    md.append("## First TMP Font Assets")
    md.append("")
    md.append("| bundle | name | family | style | atlas | glyphs | material pathID |")
    md.append("| --- | --- | --- | --- | --- | ---: | --- |")
    shown = 0
    for row in font_asset_rows:
        if not row.get("version"):
            continue
        md.append(
            f"| `{row['bundle']}` | `{row['name']}` | `{row['family_name']}` | `{row['style_name']}` | "
            f"`{row['atlas_width']}x{row['atlas_height']}` | {row['glyph_count']} | `{row['material_path_id']}` |"
        )
        shown += 1
        if shown >= 20:
            break
    md.append("")
    md.append("## Restore Direction")
    md.append("")
    md.append("1. Use Unity 6000 `com.unity.ugui` 2.0 TMP support; `TextMeshProUGUI` compile/create is validated by the isolated probe.")
    md.append("2. Convert TMP-like text rows to `TextMeshProUGUI`, preserving TMP serialized fields from source components.")
    md.append("3. Use `tmp/*.assetbundle` TMP FontAsset rows and their material/texture refs as the source of font family, atlas size, glyph metrics, and material presets.")
    md.append("4. Keep UGUI `m_FontData` rows on the old `UnityEngine.UI.Text` path.")
    md.append("5. Re-run graphics capture only after TMP and right route visibility state are restored.")
    md.append("")
    md.append("## Generated Files")
    md.append("")
    md.append(f"- `{OUT_SUMMARY_JSON}`")
    md.append(f"- `{OUT_BUNDLES_CSV}`")
    md.append(f"- `{OUT_FONT_ASSETS_CSV}`")
    md.append(f"- `{OUT_MATERIALS_CSV}`")
    md.append(f"- `{OUT_TEXTURES_CSV}`")
    OUT_MD.parent.mkdir(parents=True, exist_ok=True)
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(f"[GirlsWarRestore] TMP font summary: {OUT_SUMMARY_JSON}")
    print(f"[GirlsWarRestore] TMP font asset CSV: {OUT_FONT_ASSETS_CSV}")
    print(f"[GirlsWarRestore] TMP material CSV: {OUT_MATERIALS_CSV}")
    print(f"[GirlsWarRestore] TMP texture CSV: {OUT_TEXTURES_CSV}")
    print(f"[GirlsWarRestore] Report: {OUT_MD}")


if __name__ == "__main__":
    main()
