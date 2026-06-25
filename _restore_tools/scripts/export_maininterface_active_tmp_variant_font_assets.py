from __future__ import annotations

import csv
import json
from datetime import datetime
from pathlib import Path
from typing import Any

import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
PROJECT = BASE / "girlswar_maininterface_unity"
REPORT_DATA = PROJECT / "Assets" / "RestoreData" / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"

ROUTE_TMP_CSV = REPORT_DATA / "maininterface_route_tmp_state_after_material.csv"
TMP_FONT_ASSETS_CSV = REPORT_DATA / "maininterface_tmp_font_assets.csv"
EXPORT_MAP_CSV = MERGED / "indexes" / "unity_bundle_export_map.csv"
ASSETBUNDLE_ROOT = MERGED / "merged_content" / "AssetBundles"

OUT_SUMMARY_JSON = REPORT_DATA / "maininterface_active_tmp_variant_font_assets_summary.json"
OUT_FONT_SUMMARY_CSV = REPORT_DATA / "maininterface_active_tmp_variant_font_summary.csv"
OUT_GLYPHS_CSV = REPORT_DATA / "maininterface_active_tmp_variant_glyphs.csv"
OUT_CHARACTERS_CSV = REPORT_DATA / "maininterface_active_tmp_variant_characters.csv"
OUT_MATERIAL_PROPS_CSV = REPORT_DATA / "maininterface_active_tmp_variant_material_properties.csv"
OUT_USAGE_CSV = REPORT_DATA / "maininterface_active_tmp_variant_usage.csv"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_ACTIVE_TMP_VARIANT_FONT_ASSETS.md"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def ref_path_id(value: Any) -> str:
    if isinstance(value, dict):
        return str(value.get("m_PathID", ""))
    return ""


def pair_first_second(item: Any) -> tuple[Any, Any]:
    if isinstance(item, dict):
        return item.get("first"), item.get("second")
    if isinstance(item, (list, tuple)) and len(item) >= 2:
        return item[0], item[1]
    return "", ""


def prop_name(value: Any) -> str:
    if isinstance(value, dict):
        return str(value.get("name", ""))
    return str(value or "")


def flatten_color(value: Any) -> str:
    if not isinstance(value, dict):
        return ""
    return ",".join(str(value.get(k, "")) for k in ("r", "g", "b", "a"))


def flatten_vec2(value: Any) -> str:
    if not isinstance(value, dict):
        return ""
    return ",".join(str(value.get(k, "")) for k in ("x", "y"))


def char_display(codepoint: int) -> str:
    if codepoint == 10:
        return "\\n"
    if codepoint == 13:
        return "\\r"
    if codepoint == 9:
        return "\\t"
    if codepoint < 32:
        return f"U+{codepoint:04X}"
    try:
        return chr(codepoint)
    except ValueError:
        return f"U+{codepoint:04X}"


def source_font_for(font_name: str) -> tuple[str, str]:
    lower = font_name.lower()
    if lower.startswith("epm"):
        return "EPM", "Assets/RestoreData/TMP/original_fonts/EPM_source.ttf"
    if lower.startswith("num"):
        return "num", "Assets/RestoreData/TMP/original_fonts/num_source.ttf"
    return "riyu", "Assets/RestoreData/TMP/original_fonts/riyu_source.ttf"


def build_export_dir_map() -> dict[str, Path]:
    result: dict[str, Path] = {}
    if not EXPORT_MAP_CSV.exists():
        return result
    for row in read_csv(EXPORT_MAP_CSV):
        bundle = row.get("bundle", "").lower()
        export_dir = row.get("export_dir", "")
        if bundle and export_dir:
            result[bundle] = MERGED / export_dir
    return result


def find_image_for_texture(export_dir: Path | None, texture_path_id: str) -> str:
    if not export_dir or not texture_path_id:
        return ""
    image_dir = export_dir / "images"
    if not image_dir.exists():
        return ""
    matches = sorted(image_dir.rglob(f"*{texture_path_id}*.png"))
    return str(matches[0]) if matches else ""


def bundle_path_for(bundle: str) -> Path:
    path = ASSETBUNDLE_ROOT / bundle.replace("/", "\\")
    if path.exists():
        return path
    return ASSETBUNDLE_ROOT / Path(*bundle.split("/"))


def active_variant_usage() -> list[dict[str, Any]]:
    rows = [row for row in read_csv(ROUTE_TMP_CSV) if row.get("active_chain") == "True"]
    usage: dict[str, dict[str, Any]] = {}
    for row in rows:
        material_name = (row.get("shared_material_name") or "").strip()
        if not material_name:
            continue
        entry = usage.setdefault(
            material_name,
            {
                "variant_font_name": material_name,
                "usage_count": 0,
                "shared_material_path_ids": set(),
                "base_font_asset_names": set(),
                "texts": [],
                "objects": set(),
                "flags": set(),
            },
        )
        entry["usage_count"] += 1
        entry["shared_material_path_ids"].add(row.get("shared_material_path_id", ""))
        entry["base_font_asset_names"].add(row.get("font_asset_name", ""))
        entry["objects"].add(row.get("game_object_name", ""))
        for flag in (row.get("flags", "") or "").split(";"):
            if flag:
                entry["flags"].add(flag)
        text = row.get("text", "")
        if text and text not in entry["texts"] and len(entry["texts"]) < 8:
            entry["texts"].append(text)
    result = []
    for entry in usage.values():
        result.append(
            {
                "variant_font_name": entry["variant_font_name"],
                "usage_count": entry["usage_count"],
                "shared_material_path_ids": ";".join(sorted(entry["shared_material_path_ids"])),
                "base_font_asset_names": ";".join(sorted(entry["base_font_asset_names"])),
                "game_object_names": ";".join(sorted(entry["objects"])),
                "text_samples": ";".join(entry["texts"]),
                "flags": ";".join(sorted(entry["flags"])),
            }
        )
    return sorted(result, key=lambda row: (-int(row["usage_count"]), row["variant_font_name"]))


def material_property_rows(font_key: str, bundle: str, material_path_id: str, material_tree: dict[str, Any]) -> list[dict[str, Any]]:
    if not isinstance(material_tree, dict) or not material_tree:
        return []
    saved = material_tree.get("m_SavedProperties") or {}
    rows: list[dict[str, Any]] = []
    for item in saved.get("m_TexEnvs") or []:
        first, second = pair_first_second(item)
        second = second or {}
        rows.append(
            {
                "font_key": font_key,
                "bundle": bundle,
                "material_path_id": material_path_id,
                "material_name": material_tree.get("m_Name", ""),
                "property_type": "texture",
                "property_name": prop_name(first),
                "value": ref_path_id(second.get("m_Texture") or {}),
                "scale": flatten_vec2(second.get("m_Scale")),
                "offset": flatten_vec2(second.get("m_Offset")),
            }
        )
    for item in saved.get("m_Floats") or []:
        first, second = pair_first_second(item)
        rows.append(
            {
                "font_key": font_key,
                "bundle": bundle,
                "material_path_id": material_path_id,
                "material_name": material_tree.get("m_Name", ""),
                "property_type": "float",
                "property_name": prop_name(first),
                "value": second,
                "scale": "",
                "offset": "",
            }
        )
    for item in saved.get("m_Colors") or []:
        first, second = pair_first_second(item)
        rows.append(
            {
                "font_key": font_key,
                "bundle": bundle,
                "material_path_id": material_path_id,
                "material_name": material_tree.get("m_Name", ""),
                "property_type": "color",
                "property_name": prop_name(first),
                "value": flatten_color(second),
                "scale": "",
                "offset": "",
            }
        )
    return rows


def analyze_font(row: dict[str, str], export_dirs: dict[str, Path]) -> dict[str, Any]:
    font_key = row["name"]
    bundle = row["bundle"]
    bundle_path = bundle_path_for(bundle)
    if not bundle_path.exists():
        raise FileNotFoundError(bundle_path)

    env = UnityPy.load(str(bundle_path))
    objects_by_path_id: dict[str, tuple[str, dict[str, Any]]] = {}
    font_tree: dict[str, Any] | None = None
    font_path_id = ""
    for obj in env.objects:
        if obj.type.name not in {"MonoBehaviour", "Material", "Texture2D"}:
            continue
        tree = obj.read_typetree()
        objects_by_path_id[str(obj.path_id)] = (obj.type.name, tree)
        if obj.type.name == "MonoBehaviour" and str(obj.path_id) == str(row["path_id"]):
            font_tree = tree
            font_path_id = str(obj.path_id)

    if not font_tree:
        raise RuntimeError(f"No TMP FontAsset path_id={row['path_id']} in {bundle_path}")

    base_font_key, source_font_path = source_font_for(font_key)
    face = font_tree.get("m_FaceInfo") or {}
    creation = font_tree.get("m_CreationSettings") or {}
    glyphs = font_tree.get("m_GlyphTable") or []
    characters = font_tree.get("m_CharacterTable") or []
    atlas_path_ids = [ref_path_id(v) for v in font_tree.get("m_AtlasTextures") or []]
    material_path_id = ref_path_id(font_tree.get("material"))
    _, material_tree = objects_by_path_id.get(material_path_id, ("", {}))
    export_dir = export_dirs.get(bundle.lower())
    texture_infos = []
    for texture_path_id in atlas_path_ids:
        texture_type, texture_tree = objects_by_path_id.get(texture_path_id, ("", {}))
        texture_infos.append(
            {
                "path_id": texture_path_id,
                "type": texture_type,
                "name": texture_tree.get("m_Name", ""),
                "width": texture_tree.get("m_Width", ""),
                "height": texture_tree.get("m_Height", ""),
                "texture_format": texture_tree.get("m_TextureFormat", ""),
                "image_path": find_image_for_texture(export_dir, texture_path_id),
            }
        )

    glyph_rows = []
    for glyph in glyphs:
        metrics = glyph.get("m_Metrics") or {}
        rect = glyph.get("m_GlyphRect") or {}
        glyph_rows.append(
            {
                "font_key": font_key,
                "bundle": bundle,
                "font_path_id": font_path_id,
                "glyph_index": glyph.get("m_Index", ""),
                "width": metrics.get("m_Width", ""),
                "height": metrics.get("m_Height", ""),
                "bearing_x": metrics.get("m_HorizontalBearingX", ""),
                "bearing_y": metrics.get("m_HorizontalBearingY", ""),
                "advance": metrics.get("m_HorizontalAdvance", ""),
                "rect_x": rect.get("m_X", ""),
                "rect_y": rect.get("m_Y", ""),
                "rect_width": rect.get("m_Width", ""),
                "rect_height": rect.get("m_Height", ""),
                "scale": glyph.get("m_Scale", ""),
                "atlas_index": glyph.get("m_AtlasIndex", ""),
            }
        )

    char_rows = []
    for char in characters:
        codepoint = int(char.get("m_Unicode", 0))
        char_rows.append(
            {
                "font_key": font_key,
                "bundle": bundle,
                "font_path_id": font_path_id,
                "unicode": codepoint,
                "unicode_hex": f"U+{codepoint:04X}",
                "char": char_display(codepoint),
                "glyph_index": char.get("m_GlyphIndex", ""),
                "scale": char.get("m_Scale", ""),
                "element_type": char.get("m_ElementType", ""),
            }
        )

    summary = {
        "font_key": font_key,
        "base_font_key": base_font_key,
        "source_font_path": source_font_path,
        "bundle": bundle,
        "bundle_path": str(bundle_path),
        "export_dir": str(export_dir or ""),
        "font_path_id": font_path_id,
        "name": font_tree.get("m_Name", ""),
        "version": font_tree.get("m_Version", ""),
        "family_name": face.get("m_FamilyName", ""),
        "style_name": face.get("m_StyleName", ""),
        "point_size": face.get("m_PointSize", ""),
        "line_height": face.get("m_LineHeight", ""),
        "ascent_line": face.get("m_AscentLine", ""),
        "descent_line": face.get("m_DescentLine", ""),
        "material_path_id": material_path_id,
        "material_name": material_tree.get("m_Name", "") if isinstance(material_tree, dict) else "",
        "atlas_width": font_tree.get("m_AtlasWidth", ""),
        "atlas_height": font_tree.get("m_AtlasHeight", ""),
        "atlas_padding": font_tree.get("m_AtlasPadding", ""),
        "atlas_render_mode": font_tree.get("m_AtlasRenderMode", ""),
        "atlas_texture_path_ids": ";".join(atlas_path_ids),
        "atlas_image_path": texture_infos[0]["image_path"] if texture_infos else "",
        "glyph_count": len(glyphs),
        "character_count": len(characters),
        "fallback_count": len(font_tree.get("m_FallbackFontAssetTable") or []),
        "creation_point_size": creation.get("pointSize", ""),
        "creation_render_mode": creation.get("renderMode", ""),
        "static_asset_path": f"Assets/RestoreData/TMP/static_probe/variants/GirlsWarStaticProbe_{sanitize(font_key)}_TMP.asset",
    }
    return {
        "summary": summary,
        "glyph_rows": glyph_rows,
        "char_rows": char_rows,
        "material_rows": material_property_rows(font_key, bundle, material_path_id, material_tree),
    }


def sanitize(value: str) -> str:
    return "".join(c if c.isalnum() else "_" for c in value).strip("_")


def main() -> int:
    usage_rows = active_variant_usage()
    font_assets = {row.get("name", ""): row for row in read_csv(TMP_FONT_ASSETS_CSV)}
    variant_names = [row["variant_font_name"] for row in usage_rows if row["variant_font_name"] in font_assets]
    export_dirs = build_export_dir_map()
    results = [analyze_font(font_assets[name], export_dirs) for name in variant_names]

    generated_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    summaries = [r["summary"] for r in results]
    glyph_rows = [row for result in results for row in result["glyph_rows"]]
    char_rows = [row for result in results for row in result["char_rows"]]
    material_rows = [row for result in results for row in result["material_rows"]]

    OUT_SUMMARY_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_SUMMARY_JSON.write_text(
        json.dumps(
            {
                "generated_at": generated_at,
                "active_shared_material_count": len(usage_rows),
                "variant_font_asset_count": len(summaries),
                "variant_font_names": variant_names,
                "fonts": summaries,
            },
            ensure_ascii=False,
            indent=2,
        ),
        encoding="utf-8",
    )
    write_csv(
        OUT_USAGE_CSV,
        usage_rows,
        [
            "variant_font_name",
            "usage_count",
            "shared_material_path_ids",
            "base_font_asset_names",
            "game_object_names",
            "text_samples",
            "flags",
        ],
    )
    summary_fields = [
        "font_key",
        "base_font_key",
        "source_font_path",
        "bundle",
        "font_path_id",
        "name",
        "family_name",
        "style_name",
        "point_size",
        "line_height",
        "ascent_line",
        "descent_line",
        "material_path_id",
        "material_name",
        "atlas_width",
        "atlas_height",
        "atlas_padding",
        "atlas_render_mode",
        "atlas_texture_path_ids",
        "atlas_image_path",
        "glyph_count",
        "character_count",
        "fallback_count",
        "static_asset_path",
    ]
    write_csv(OUT_FONT_SUMMARY_CSV, [{k: s.get(k, "") for k in summary_fields} for s in summaries], summary_fields)
    write_csv(
        OUT_GLYPHS_CSV,
        glyph_rows,
        [
            "font_key",
            "bundle",
            "font_path_id",
            "glyph_index",
            "width",
            "height",
            "bearing_x",
            "bearing_y",
            "advance",
            "rect_x",
            "rect_y",
            "rect_width",
            "rect_height",
            "scale",
            "atlas_index",
        ],
    )
    write_csv(
        OUT_CHARACTERS_CSV,
        char_rows,
        ["font_key", "bundle", "font_path_id", "unicode", "unicode_hex", "char", "glyph_index", "scale", "element_type"],
    )
    write_csv(
        OUT_MATERIAL_PROPS_CSV,
        material_rows,
        ["font_key", "bundle", "material_path_id", "material_name", "property_type", "property_name", "value", "scale", "offset"],
    )
    write_markdown(generated_at, usage_rows, summaries)
    print(json.dumps({"generated": str(OUT_MD), "variant_font_names": variant_names}, ensure_ascii=False, indent=2))
    return 0


def write_markdown(generated_at: str, usage_rows: list[dict[str, Any]], summaries: list[dict[str, Any]]) -> None:
    lines = [
        "# MainInterface Active TMP Variant Font Assets",
        "",
        f"Generated: {generated_at}",
        "",
        "## Verdict",
        "",
        "active route TMP는 prefab상 base FontAsset(`riyu`/`EPM`)을 참조하지만, shared material 이름과 동일한 TMP FontAsset bundle도 원본에 존재한다. 이 리포트는 그 variant FontAsset의 glyph/character/atlas/material을 별도 evidence로 내보내 A/B 렌더 검증에 쓸 수 있게 한다.",
        "",
        "## Active Shared Material Usage",
        "",
        "| variant/material | refs | base fonts | text samples | flags |",
        "| --- | ---: | --- | --- | --- |",
    ]
    for row in usage_rows:
        lines.append(
            f"| `{row['variant_font_name']}` | {row['usage_count']} | `{row['base_font_asset_names']}` | "
            f"`{row['text_samples']}` | `{row['flags']}` |"
        )
    lines.extend(["", "## Exported Variant TMP FontAssets", "", "| variant | base | atlas | glyphs | chars | source image |", "| --- | --- | --- | ---: | ---: | --- |"])
    for summary in summaries:
        lines.append(
            f"| `{summary['font_key']}` | `{summary['base_font_key']}` | "
            f"`{summary['atlas_width']}x{summary['atlas_height']}` | {summary['glyph_count']} | "
            f"{summary['character_count']} | `{Path(summary['atlas_image_path']).name if summary['atlas_image_path'] else ''}` |"
        )
    lines.extend(
        [
            "",
            "## Restore Notes",
            "",
            "- 기본 복원 경로는 원본 component의 base `m_fontAsset` + `m_sharedMaterial` 조합을 유지한다.",
            "- variant FontAsset은 shared material 이름과 같은 TMP bundle을 실험적으로 렌더링해 보기 위한 근거다.",
            "- 실제 적용은 `MainInterfaceSceneBuilder`에서 shared material pathID별 opt-in mapping으로만 해야 한다.",
            "",
            "## Generated Files",
            "",
        ]
    )
    for path in [
        OUT_USAGE_CSV,
        OUT_FONT_SUMMARY_CSV,
        OUT_GLYPHS_CSV,
        OUT_CHARACTERS_CSV,
        OUT_MATERIAL_PROPS_CSV,
        OUT_SUMMARY_JSON,
    ]:
        lines.append(f"- `{path}`")
    OUT_MD.parent.mkdir(parents=True, exist_ok=True)
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    raise SystemExit(main())
