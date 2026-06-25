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
RESTORE_DATA = PROJECT / "Assets" / "RestoreData"
REPORT_DATA = RESTORE_DATA / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"

MAIN_EXPORT_DIR = MERGED / "extracted" / "unity" / "bundles" / "b_c3b1e8926fc41b4c"
TEXT_COMPONENTS_CSV = RESTORE_DATA / "maininterface_text_components.csv"
TMP_FONT_ASSETS_CSV = REPORT_DATA / "maininterface_tmp_font_assets.csv"

OUT_CSV = RESTORE_DATA / "maininterface_text_tmp_details.csv"
OUT_SUMMARY_JSON = REPORT_DATA / "maininterface_text_tmp_details_summary.json"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_TMP_TEXT_DETAILS.md"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def iter_structure(path: Path):
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


def ref_file_id(value: Any) -> str:
    if isinstance(value, dict):
        return str(value.get("m_FileID", ""))
    return ""


def f(value: Any) -> str:
    if value is None:
        return ""
    return str(value)


def n(value: Any, default: int = 0) -> int:
    try:
        if value in ("", None):
            return default
        return int(float(value))
    except (TypeError, ValueError):
        return default


def bool_int(value: Any) -> str:
    return "1" if n(value) != 0 else "0"


def color_channels(value: Any, prefix: str) -> dict[str, Any]:
    if not isinstance(value, dict):
        return {
            f"{prefix}_r": "",
            f"{prefix}_g": "",
            f"{prefix}_b": "",
            f"{prefix}_a": "",
            f"{prefix}_rgba": "",
        }
    return {
        f"{prefix}_r": value.get("r", ""),
        f"{prefix}_g": value.get("g", ""),
        f"{prefix}_b": value.get("b", ""),
        f"{prefix}_a": value.get("a", ""),
        f"{prefix}_rgba": value.get("rgba", ""),
    }


def vector4(value: Any, prefix: str) -> dict[str, Any]:
    if not isinstance(value, dict):
        return {f"{prefix}_x": "", f"{prefix}_y": "", f"{prefix}_z": "", f"{prefix}_w": ""}
    return {
        f"{prefix}_x": value.get("x", ""),
        f"{prefix}_y": value.get("y", ""),
        f"{prefix}_z": value.get("z", ""),
        f"{prefix}_w": value.get("w", ""),
    }


def resolved_alignment(tree: dict[str, Any]) -> int:
    text_alignment = n(tree.get("m_textAlignment"), 0)
    horizontal = n(tree.get("m_HorizontalAlignment"), 0)
    vertical = n(tree.get("m_VerticalAlignment"), 0)
    if text_alignment not in (0, 65535):
        return text_alignment
    if horizontal or vertical:
        return horizontal | vertical
    return text_alignment


def main() -> None:
    text_rows = {row.get("component_path_id", ""): row for row in read_csv(TEXT_COMPONENTS_CSV)}
    font_assets = {row.get("path_id", ""): row for row in read_csv(TMP_FONT_ASSETS_CSV)}

    rows: list[dict[str, Any]] = []
    font_counter: Counter[str] = Counter()
    family_counter: Counter[str] = Counter()
    material_counter: Counter[str] = Counter()

    for obj in iter_structure(MAIN_EXPORT_DIR / "structure.jsonl.gz"):
        tree = obj.get("tree") or {}
        if obj.get("type") != "MonoBehaviour" or not isinstance(tree, dict):
            continue
        if "m_fontAsset" not in tree or "m_fontSize" not in tree:
            continue

        component_path_id = str(obj.get("path_id", ""))
        text_row = text_rows.get(component_path_id, {})
        font_ref = tree.get("m_fontAsset")
        material_ref = tree.get("m_sharedMaterial")
        font_path_id = ref_path_id(font_ref)
        material_path_id = ref_path_id(material_ref)
        font_row = font_assets.get(font_path_id, {})

        font_counter[font_path_id] += 1
        family_counter[font_row.get("family_name", "") or "unmatched"] += 1
        material_counter[material_path_id] += 1

        row: dict[str, Any] = {
            "component_path_id": component_path_id,
            "game_object_id": ref_path_id(tree.get("m_GameObject")) or text_row.get("game_object_id", ""),
            "game_object_name": text_row.get("game_object_name", ""),
            "script_id": ref_path_id(tree.get("m_Script")),
            "source_text_raw": tree.get("m_text", ""),
            "display_text": text_row.get("text", ""),
            "enabled": bool_int(tree.get("m_Enabled")),
            "raycast_target": bool_int(tree.get("m_RaycastTarget")),
            "font_asset_file_id": ref_file_id(font_ref),
            "font_asset_path_id": font_path_id,
            "font_asset_name": font_row.get("name", ""),
            "font_asset_bundle": font_row.get("bundle", ""),
            "font_family": font_row.get("family_name", ""),
            "font_style_name": font_row.get("style_name", ""),
            "font_material_path_id_from_font_asset": font_row.get("material_path_id", ""),
            "shared_material_file_id": ref_file_id(material_ref),
            "shared_material_path_id": material_path_id,
            "font_material_path_id": ref_path_id(tree.get("m_fontMaterial")),
            "base_material_path_id": ref_path_id(tree.get("m_baseMaterial")),
            "font_size": tree.get("m_fontSize", ""),
            "font_size_base": tree.get("m_fontSizeBase", ""),
            "font_size_min": tree.get("m_fontSizeMin", ""),
            "font_size_max": tree.get("m_fontSizeMax", ""),
            "font_weight": tree.get("m_fontWeight", ""),
            "font_style": tree.get("m_fontStyle", ""),
            "enable_auto_sizing": bool_int(tree.get("m_enableAutoSizing")),
            "horizontal_alignment": tree.get("m_HorizontalAlignment", ""),
            "vertical_alignment": tree.get("m_VerticalAlignment", ""),
            "text_alignment": tree.get("m_textAlignment", ""),
            "resolved_alignment": resolved_alignment(tree),
            "character_spacing": tree.get("m_characterSpacing", ""),
            "word_spacing": tree.get("m_wordSpacing", ""),
            "line_spacing": tree.get("m_lineSpacing", ""),
            "line_spacing_max": tree.get("m_lineSpacingMax", ""),
            "paragraph_spacing": tree.get("m_paragraphSpacing", ""),
            "char_width_max_adj": tree.get("m_charWidthMaxAdj", ""),
            "enable_word_wrapping": bool_int(tree.get("m_enableWordWrapping")),
            "word_wrapping_ratios": tree.get("m_wordWrappingRatios", ""),
            "overflow_mode": tree.get("m_overflowMode", ""),
            "enable_kerning": bool_int(tree.get("m_enableKerning")),
            "enable_extra_padding": bool_int(tree.get("m_enableExtraPadding")),
            "is_rich_text": bool_int(tree.get("m_isRichText")),
            "parse_ctrl_characters": bool_int(tree.get("m_parseCtrlCharacters")),
            "is_right_to_left": bool_int(tree.get("m_isRightToLeft")),
            "color_mode": tree.get("m_colorMode", ""),
            "override_html_colors": bool_int(tree.get("m_overrideHtmlColors")),
            "geometry_sorting_order": tree.get("m_geometrySortingOrder", ""),
            "use_max_visible_descender": bool_int(tree.get("m_useMaxVisibleDescender")),
            "page_to_display": tree.get("m_pageToDisplay", ""),
        }
        row.update(color_channels(tree.get("m_Color"), "color"))
        row.update(color_channels(tree.get("m_fontColor"), "font_color"))
        row.update(color_channels(tree.get("m_fontColor32"), "font_color32"))
        row.update(color_channels(tree.get("m_faceColor"), "face_color"))
        row.update(vector4(tree.get("m_margin"), "margin"))
        row.update(vector4(tree.get("m_maskOffset"), "mask_offset"))
        rows.append(row)

    fieldnames = [
        "component_path_id", "game_object_id", "game_object_name", "script_id", "source_text_raw", "display_text",
        "enabled", "raycast_target", "font_asset_file_id", "font_asset_path_id", "font_asset_name",
        "font_asset_bundle", "font_family", "font_style_name", "font_material_path_id_from_font_asset",
        "shared_material_file_id", "shared_material_path_id", "font_material_path_id", "base_material_path_id",
        "font_size", "font_size_base", "font_size_min", "font_size_max", "font_weight", "font_style",
        "enable_auto_sizing", "horizontal_alignment", "vertical_alignment", "text_alignment", "resolved_alignment",
        "character_spacing", "word_spacing", "line_spacing", "line_spacing_max", "paragraph_spacing",
        "char_width_max_adj", "enable_word_wrapping", "word_wrapping_ratios", "overflow_mode",
        "enable_kerning", "enable_extra_padding", "is_rich_text", "parse_ctrl_characters", "is_right_to_left",
        "color_mode", "override_html_colors", "geometry_sorting_order", "use_max_visible_descender",
        "page_to_display", "color_r", "color_g", "color_b", "color_a", "color_rgba",
        "font_color_r", "font_color_g", "font_color_b", "font_color_a", "font_color_rgba",
        "font_color32_r", "font_color32_g", "font_color32_b", "font_color32_a", "font_color32_rgba",
        "face_color_r", "face_color_g", "face_color_b", "face_color_a", "face_color_rgba",
        "margin_x", "margin_y", "margin_z", "margin_w",
        "mask_offset_x", "mask_offset_y", "mask_offset_z", "mask_offset_w",
    ]
    write_csv(OUT_CSV, rows, fieldnames)

    summary = {
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "source_bundle_export_dir": str(MAIN_EXPORT_DIR),
        "tmp_text_rows": len(rows),
        "font_asset_path_ids": dict(font_counter),
        "font_families": dict(family_counter),
        "shared_material_path_ids": dict(material_counter),
        "matched_font_asset_rows": sum(1 for row in rows if row.get("font_asset_name")),
        "unmatched_font_asset_rows": sum(1 for row in rows if not row.get("font_asset_name")),
        "details_csv": str(OUT_CSV),
    }
    OUT_SUMMARY_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_SUMMARY_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    md: list[str] = []
    md.append("# MainInterface TMP Text Details")
    md.append("")
    md.append(f"Generated: {summary['generated_at']}")
    md.append("")
    md.append("## Verdict")
    md.append("")
    md.append("MainInterface TMP-like text rows now have a dedicated field export. The restore builder should use this CSV to create `TextMeshProUGUI` components and preserve TMP layout fields instead of rendering them as `UnityEngine.UI.Text`.")
    md.append("")
    md.append("## Counts")
    md.append("")
    md.append("| item | value |")
    md.append("| --- | ---: |")
    md.append(f"| TMP text rows | {summary['tmp_text_rows']} |")
    md.append(f"| matched original TMP FontAsset rows | {summary['matched_font_asset_rows']} |")
    md.append(f"| unmatched TMP FontAsset rows | {summary['unmatched_font_asset_rows']} |")
    md.append("")
    md.append("## FontAsset Usage")
    md.append("")
    md.append("| font pathID | rows | matched asset | family | bundle |")
    md.append("| --- | ---: | --- | --- | --- |")
    font_lookup = {row.get("path_id", ""): row for row in read_csv(TMP_FONT_ASSETS_CSV)}
    for path_id, count in font_counter.most_common():
        font_row = font_lookup.get(str(path_id), {})
        md.append(
            f"| `{path_id}` | {count} | `{font_row.get('name', '')}` | "
            f"`{font_row.get('family_name', '')}` | `{font_row.get('bundle', '')}` |"
        )
    md.append("")
    md.append("## Restore Notes")
    md.append("")
    md.append("1. `display_text` comes from the already decoded text CSV, because some raw `m_text` values in the Unity tree are mojibake.")
    md.append("2. `resolved_alignment` is derived from `m_HorizontalAlignment | m_VerticalAlignment` when `m_textAlignment` is `65535`.")
    md.append("3. Original TMP FontAsset pathIDs match the uifont TMP inventory, but the Unity project still needs reconstructed/imported TMP FontAsset assets for final font fidelity.")
    md.append("4. This export is the input for the first TMP builder pass.")
    md.append("")
    md.append("## Generated Files")
    md.append("")
    md.append(f"- `{OUT_CSV}`")
    md.append(f"- `{OUT_SUMMARY_JSON}`")
    OUT_MD.parent.mkdir(parents=True, exist_ok=True)
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(f"[GirlsWarRestore] TMP text details CSV: {OUT_CSV}")
    print(f"[GirlsWarRestore] TMP text details summary: {OUT_SUMMARY_JSON}")
    print(f"[GirlsWarRestore] Report: {OUT_MD}")


if __name__ == "__main__":
    main()
