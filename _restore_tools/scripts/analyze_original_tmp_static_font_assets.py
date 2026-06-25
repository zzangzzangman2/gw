from __future__ import annotations

import csv
import json
import re
from datetime import datetime
from pathlib import Path
from typing import Any

import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
PROJECT = BASE / "girlswar_maininterface_unity"
REPORT_DATA = PROJECT / "Assets" / "RestoreData" / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"
EXPORT_MAP_CSV = MERGED / "indexes" / "unity_bundle_export_map.csv"
TMP_BUNDLE_DIR = MERGED / "merged_content" / "AssetBundles" / "download" / "ui" / "uifont" / "japanese" / "tmp"
UNITY_TMP_DIR = PROJECT / "Assets" / "RestoreData" / "TMP" / "original_fonts"

OUT_SUMMARY_JSON = REPORT_DATA / "maininterface_original_tmp_static_font_summary.json"
OUT_FONT_SUMMARY_CSV = REPORT_DATA / "maininterface_original_tmp_static_font_summary.csv"
OUT_GLYPHS_CSV = REPORT_DATA / "maininterface_original_tmp_static_glyphs.csv"
OUT_CHARACTERS_CSV = REPORT_DATA / "maininterface_original_tmp_static_characters.csv"
OUT_MATERIAL_PROPS_CSV = REPORT_DATA / "maininterface_original_tmp_static_material_properties.csv"
OUT_COMPARISON_CSV = REPORT_DATA / "maininterface_tmp_static_vs_current_comparison.csv"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_ORIGINAL_TMP_STATIC_FONT_ANALYSIS.md"

FONT_TARGETS = [
    {
        "font_key": "riyu",
        "bundle": "download/ui/uifont/japanese/tmp/riyu.assetbundle",
        "file_name": "riyu.assetbundle",
        "current_asset": UNITY_TMP_DIR / "GirlsWarOriginal_riyu_TMP.asset",
    },
    {
        "font_key": "EPM",
        "bundle": "download/ui/uifont/japanese/tmp/epm.assetbundle",
        "file_name": "epm.assetbundle",
        "current_asset": UNITY_TMP_DIR / "GirlsWarOriginal_EPM_TMP.asset",
    },
    {
        "font_key": "num",
        "bundle": "download/ui/uifont/japanese/tmp/num.assetbundle",
        "file_name": "num.assetbundle",
        "current_asset": UNITY_TMP_DIR / "GirlsWarOriginal_num_TMP.asset",
    },
]


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


def prop_name(value: Any) -> str:
    if isinstance(value, dict):
        return str(value.get("name", ""))
    return str(value or "")


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


def flatten_color(value: Any) -> str:
    if not isinstance(value, dict):
        return ""
    return ",".join(str(value.get(k, "")) for k in ("r", "g", "b", "a"))


def flatten_vec2(value: Any) -> str:
    if not isinstance(value, dict):
        return ""
    return ",".join(str(value.get(k, "")) for k in ("x", "y"))


def pair_first_second(item: Any) -> tuple[Any, Any]:
    if isinstance(item, dict):
        return item.get("first"), item.get("second")
    if isinstance(item, (list, tuple)) and len(item) >= 2:
        return item[0], item[1]
    return "", ""


def parse_current_tmp_asset(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {
            "asset_exists": False,
            "asset_path": str(path),
            "asset_size": 0,
            "family_name": "",
            "style_name": "",
            "line_height": "",
            "ascent_line": "",
            "descent_line": "",
            "atlas_width": "",
            "atlas_height": "",
            "atlas_padding": "",
            "clear_dynamic_data_on_build": "",
            "glyph_count": 0,
            "character_count": 0,
            "unicodes": [],
        }

    text = path.read_text(encoding="utf-8", errors="replace")

    def scalar(name: str) -> str:
        match = re.search(rf"^\s*{re.escape(name)}:\s*(.*?)\s*$", text, re.MULTILINE)
        return match.group(1) if match else ""

    glyph_block = block_between(text, "m_GlyphTable:", "m_CharacterTable:")
    char_block = block_between(text, "m_CharacterTable:", "m_UsedGlyphRects:")
    unicodes = [int(v) for v in re.findall(r"^\s*m_Unicode:\s*(-?\d+)\s*$", char_block, re.MULTILINE)]

    return {
        "asset_exists": True,
        "asset_path": str(path),
        "asset_size": path.stat().st_size,
        "family_name": scalar("m_FamilyName"),
        "style_name": scalar("m_StyleName"),
        "line_height": scalar("m_LineHeight"),
        "ascent_line": scalar("m_AscentLine"),
        "descent_line": scalar("m_DescentLine"),
        "atlas_width": scalar("m_AtlasWidth"),
        "atlas_height": scalar("m_AtlasHeight"),
        "atlas_padding": scalar("m_AtlasPadding"),
        "clear_dynamic_data_on_build": scalar("m_ClearDynamicDataOnBuild"),
        "glyph_count": len(re.findall(r"^\s*-\s+m_Index:", glyph_block, re.MULTILINE)),
        "character_count": len(unicodes),
        "unicodes": sorted(set(unicodes)),
    }


def block_between(text: str, start_marker: str, end_marker: str) -> str:
    start = text.find(start_marker)
    if start < 0:
        return ""
    end = text.find(end_marker, start + len(start_marker))
    if end < 0:
        return text[start:]
    return text[start:end]


def analyze_bundle(target: dict[str, Any], export_dirs: dict[str, Path]) -> dict[str, Any]:
    bundle_path = TMP_BUNDLE_DIR / target["file_name"]
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
        if obj.type.name == "MonoBehaviour" and ("m_GlyphTable" in tree or "m_CharacterTable" in tree):
            font_tree = tree
            font_path_id = str(obj.path_id)

    if not font_tree:
        raise RuntimeError(f"No TMP FontAsset-like MonoBehaviour found in {bundle_path}")

    face = font_tree.get("m_FaceInfo") or {}
    creation = font_tree.get("m_CreationSettings") or {}
    glyphs = font_tree.get("m_GlyphTable") or []
    characters = font_tree.get("m_CharacterTable") or []
    atlas_refs = font_tree.get("m_AtlasTextures") or []
    atlas_path_ids = [ref_path_id(v) for v in atlas_refs]
    material_path_id = ref_path_id(font_tree.get("material"))
    material_type, material_tree = objects_by_path_id.get(material_path_id, ("", {}))
    texture_infos = []
    export_dir = export_dirs.get(target["bundle"].lower())

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
                "font_key": target["font_key"],
                "bundle": target["bundle"],
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
    original_unicodes: list[int] = []
    for char in characters:
        codepoint = int(char.get("m_Unicode", 0))
        original_unicodes.append(codepoint)
        char_rows.append(
            {
                "font_key": target["font_key"],
                "bundle": target["bundle"],
                "font_path_id": font_path_id,
                "unicode": codepoint,
                "unicode_hex": f"U+{codepoint:04X}",
                "char": char_display(codepoint),
                "glyph_index": char.get("m_GlyphIndex", ""),
                "scale": char.get("m_Scale", ""),
                "element_type": char.get("m_ElementType", ""),
            }
        )

    material_rows = material_property_rows(target["font_key"], target["bundle"], material_path_id, material_tree)
    current = parse_current_tmp_asset(target["current_asset"])
    current_unicodes = set(current["unicodes"])
    original_unicode_set = set(original_unicodes)
    missing_from_current = sorted(original_unicode_set - current_unicodes)
    extra_in_current = sorted(current_unicodes - original_unicode_set)

    summary = {
        "font_key": target["font_key"],
        "bundle": target["bundle"],
        "bundle_path": str(bundle_path),
        "export_dir": str(export_dir or ""),
        "font_path_id": font_path_id,
        "name": font_tree.get("m_Name", ""),
        "version": font_tree.get("m_Version", ""),
        "source_font_guid": font_tree.get("m_SourceFontFileGUID", ""),
        "source_font_path_id": ref_path_id(font_tree.get("m_SourceFontFile")),
        "atlas_population_mode": font_tree.get("m_AtlasPopulationMode", ""),
        "family_name": face.get("m_FamilyName", ""),
        "style_name": face.get("m_StyleName", ""),
        "point_size": face.get("m_PointSize", ""),
        "line_height": face.get("m_LineHeight", ""),
        "ascent_line": face.get("m_AscentLine", ""),
        "descent_line": face.get("m_DescentLine", ""),
        "cap_line": face.get("m_CapLine", ""),
        "mean_line": face.get("m_MeanLine", ""),
        "baseline": face.get("m_Baseline", ""),
        "tab_width": face.get("m_TabWidth", ""),
        "material_path_id": material_path_id,
        "material_name": material_tree.get("m_Name", "") if isinstance(material_tree, dict) else "",
        "material_shader_path_id": ref_path_id(material_tree.get("m_Shader")) if isinstance(material_tree, dict) else "",
        "atlas_width": font_tree.get("m_AtlasWidth", ""),
        "atlas_height": font_tree.get("m_AtlasHeight", ""),
        "atlas_padding": font_tree.get("m_AtlasPadding", ""),
        "atlas_render_mode": font_tree.get("m_AtlasRenderMode", ""),
        "atlas_texture_path_ids": ";".join(atlas_path_ids),
        "atlas_textures": texture_infos,
        "glyph_count": len(glyphs),
        "character_count": len(characters),
        "fallback_count": len(font_tree.get("m_FallbackFontAssetTable") or []),
        "creation_point_size": creation.get("pointSize", ""),
        "creation_render_mode": creation.get("renderMode", ""),
        "current_asset": current,
        "comparison": {
            "current_glyph_count": current["glyph_count"],
            "current_character_count": current["character_count"],
            "current_family_name": current["family_name"],
            "current_style_name": current["style_name"],
            "current_atlas_width": current["atlas_width"],
            "current_atlas_height": current["atlas_height"],
            "current_clear_dynamic_data_on_build": current["clear_dynamic_data_on_build"],
            "unicode_overlap": len(original_unicode_set & current_unicodes),
            "original_unicode_missing_from_current": len(missing_from_current),
            "current_unicode_extra_vs_original": len(extra_in_current),
            "missing_sample": "".join(char_display(v) for v in missing_from_current[:40]),
            "extra_sample": "".join(char_display(v) for v in extra_in_current[:40]),
        },
    }
    return {
        "summary": summary,
        "glyph_rows": glyph_rows,
        "char_rows": char_rows,
        "material_rows": material_rows,
    }


def material_property_rows(font_key: str, bundle: str, material_path_id: str, material_tree: dict[str, Any]) -> list[dict[str, Any]]:
    if not isinstance(material_tree, dict) or not material_tree:
        return []
    saved = material_tree.get("m_SavedProperties") or {}
    rows: list[dict[str, Any]] = []
    for item in saved.get("m_TexEnvs") or []:
        first, second = pair_first_second(item)
        second = second or {}
        texture_ref = second.get("m_Texture") or {}
        rows.append(
            {
                "font_key": font_key,
                "bundle": bundle,
                "material_path_id": material_path_id,
                "material_name": material_tree.get("m_Name", ""),
                "property_type": "texture",
                "property_name": prop_name(first),
                "value": ref_path_id(texture_ref),
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


def write_reports(results: list[dict[str, Any]]) -> None:
    generated_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    summaries = [r["summary"] for r in results]
    glyph_rows = [row for result in results for row in result["glyph_rows"]]
    char_rows = [row for result in results for row in result["char_rows"]]
    material_rows = [row for result in results for row in result["material_rows"]]

    summary_payload = {
        "generated_at": generated_at,
        "font_count": len(summaries),
        "fonts": summaries,
    }
    OUT_SUMMARY_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_SUMMARY_JSON.write_text(json.dumps(summary_payload, ensure_ascii=False, indent=2), encoding="utf-8")

    summary_fields = [
        "font_key", "bundle", "font_path_id", "name", "family_name", "style_name", "point_size",
        "line_height", "ascent_line", "descent_line", "material_path_id", "material_name",
        "material_shader_path_id", "atlas_width", "atlas_height", "atlas_padding", "atlas_render_mode",
        "atlas_texture_path_ids", "glyph_count", "character_count", "fallback_count",
    ]
    write_csv(OUT_FONT_SUMMARY_CSV, [{k: s.get(k, "") for k in summary_fields} for s in summaries], summary_fields)
    write_csv(
        OUT_GLYPHS_CSV,
        glyph_rows,
        [
            "font_key", "bundle", "font_path_id", "glyph_index", "width", "height", "bearing_x",
            "bearing_y", "advance", "rect_x", "rect_y", "rect_width", "rect_height", "scale", "atlas_index",
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

    comparison_rows: list[dict[str, Any]] = []
    for summary in summaries:
        comparison = summary["comparison"]
        current = summary["current_asset"]
        comparison_rows.append(
            {
                "font_key": summary["font_key"],
                "original_family_name": summary["family_name"],
                "current_family_name": comparison["current_family_name"],
                "original_style_name": summary["style_name"],
                "current_style_name": comparison["current_style_name"],
                "original_atlas": f"{summary['atlas_width']}x{summary['atlas_height']}",
                "current_atlas": f"{comparison['current_atlas_width']}x{comparison['current_atlas_height']}",
                "original_glyph_count": summary["glyph_count"],
                "current_glyph_count": comparison["current_glyph_count"],
                "original_character_count": summary["character_count"],
                "current_character_count": comparison["current_character_count"],
                "unicode_overlap": comparison["unicode_overlap"],
                "original_unicode_missing_from_current": comparison["original_unicode_missing_from_current"],
                "current_unicode_extra_vs_original": comparison["current_unicode_extra_vs_original"],
                "current_clear_dynamic_data_on_build": comparison["current_clear_dynamic_data_on_build"],
                "current_asset_size": current["asset_size"],
                "missing_sample": comparison["missing_sample"],
                "extra_sample": comparison["extra_sample"],
            }
        )
    write_csv(
        OUT_COMPARISON_CSV,
        comparison_rows,
        [
            "font_key", "original_family_name", "current_family_name", "original_style_name", "current_style_name",
            "original_atlas", "current_atlas", "original_glyph_count", "current_glyph_count",
            "original_character_count", "current_character_count", "unicode_overlap",
            "original_unicode_missing_from_current", "current_unicode_extra_vs_original",
            "current_clear_dynamic_data_on_build", "current_asset_size", "missing_sample", "extra_sample",
        ],
    )
    write_markdown(generated_at, summaries, comparison_rows)


def write_markdown(generated_at: str, summaries: list[dict[str, Any]], comparison_rows: list[dict[str, Any]]) -> None:
    lines: list[str] = []
    lines.append("# MainInterface Original TMP Static Font Analysis")
    lines.append("")
    lines.append(f"Generated: {generated_at}")
    lines.append("")
    lines.append("## Verdict")
    lines.append("")
    lines.append("원본 `riyu`/`EPM`/`num` TMP FontAsset에는 정적 glyph table, character table, material, atlas Texture2D가 실제로 들어 있다. 현재 Unity 프로젝트의 `GirlsWarOriginal_*_TMP.asset`은 source font로 다시 만든 동적 TMP asset이라 원본 정적 TMP asset과 family/glyph coverage가 다르다.")
    lines.append("")
    lines.append("따라서 현재 글씨가 어긋나는 다음 병목은 좌표가 아니라 원본 정적 TMP atlas/glyph/material 이식이다.")
    lines.append("")
    lines.append("## Original Static TMP Assets")
    lines.append("")
    lines.append("| font | family | style | atlas | glyphs | chars | material | texture image |")
    lines.append("| --- | --- | --- | --- | ---: | ---: | --- | --- |")
    for summary in summaries:
        texture = (summary.get("atlas_textures") or [{}])[0]
        image_path = texture.get("image_path", "")
        image_label = Path(image_path).name if image_path else ""
        lines.append(
            f"| `{summary['font_key']}` | `{summary['family_name']}` | `{summary['style_name']}` | "
            f"`{summary['atlas_width']}x{summary['atlas_height']}` | {summary['glyph_count']} | "
            f"{summary['character_count']} | `{summary['material_name']}` `{summary['material_path_id']}` | `{image_label}` |"
        )
    lines.append("")
    lines.append("## Current Unity Asset Difference")
    lines.append("")
    lines.append("| font | original family | current family | original glyphs/chars | current glyphs/chars | unicode overlap | original missing in current | current extra |")
    lines.append("| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |")
    for row in comparison_rows:
        lines.append(
            f"| `{row['font_key']}` | `{row['original_family_name']}` | `{row['current_family_name']}` | "
            f"{row['original_glyph_count']} / {row['original_character_count']} | "
            f"{row['current_glyph_count']} / {row['current_character_count']} | {row['unicode_overlap']} | "
            f"{row['original_unicode_missing_from_current']} | {row['current_unicode_extra_vs_original']} |"
        )
    lines.append("")
    lines.append("## Important Notes")
    lines.append("")
    lines.append("- `riyu` 원본 family는 `DFMincho-SU`이지만 현재 Unity 재생성 asset은 `tway_sky`로 잡힌다.")
    lines.append("- `EPM` 원본 family는 EPSON 계열 이름으로 들어오지만 현재 Unity 재생성 asset은 source font import 결과에 의존한다.")
    lines.append("- `num`은 원본과 현재가 모두 `Impact` 계열이지만 unicode coverage는 원본 정적 table과 다르다.")
    lines.append("- 원본 atlas PNG는 이미 추출되어 있으며, 다음 단계에서 이 PNG와 glyph/character table을 Unity TMP FontAsset sub-asset에 맞춰 재구성해야 한다.")
    lines.append("")
    lines.append("## Next Restore Step")
    lines.append("")
    lines.append("1. Unity TMP FontAsset YAML에 원본 `m_FaceInfo`, `m_GlyphTable`, `m_CharacterTable`, `m_AtlasTextures`, material preset을 주입 가능한지 probe한다.")
    lines.append("2. 직접 YAML patch가 깨지면 Editor script에서 TMP FontAsset을 만든 뒤 SerializedObject로 원본 table/material/atlas를 복사한다.")
    lines.append("3. `riyu`, `EPM`, `num` 3개만 먼저 적용하고 MainInterface 캡처에서 오른쪽 route label과 좌상단 텍스트를 비교한다.")
    lines.append("4. 성공하면 나머지 색상/outline variant TMP bundle로 확장한다.")
    lines.append("")
    lines.append("## Generated Files")
    lines.append("")
    for path in [
        OUT_SUMMARY_JSON,
        OUT_FONT_SUMMARY_CSV,
        OUT_GLYPHS_CSV,
        OUT_CHARACTERS_CSV,
        OUT_MATERIAL_PROPS_CSV,
        OUT_COMPARISON_CSV,
    ]:
        lines.append(f"- `{path}`")
    OUT_MD.parent.mkdir(parents=True, exist_ok=True)
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    export_dirs = build_export_dir_map()
    results = [analyze_bundle(target, export_dirs) for target in FONT_TARGETS]
    write_reports(results)
    print(json.dumps({"generated": str(OUT_MD), "fonts": [r["summary"]["font_key"] for r in results]}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
