from __future__ import annotations

import csv
import json
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Any

import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
PROJECT = BASE / "girlswar_maininterface_unity"
REPORT_DATA = PROJECT / "Assets" / "RestoreData" / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"

TMP_DETAILS_CSV = PROJECT / "Assets" / "RestoreData" / "maininterface_text_tmp_details.csv"
EXPORT_MAP_CSV = MERGED / "indexes" / "unity_bundle_export_map.csv"
ASSETBUNDLE_ROOT = MERGED / "merged_content" / "AssetBundles"

OUT_SUMMARY_JSON = REPORT_DATA / "maininterface_tmp_shared_material_summary.json"
OUT_MATERIALS_CSV = REPORT_DATA / "maininterface_tmp_shared_materials.csv"
OUT_PROPERTIES_CSV = REPORT_DATA / "maininterface_tmp_shared_material_properties.csv"
OUT_MISSING_CSV = REPORT_DATA / "maininterface_tmp_shared_material_missing.csv"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_TMP_SHARED_MATERIAL_ANALYSIS.md"


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


def pair_first_second(item: Any) -> tuple[Any, Any]:
    if isinstance(item, dict):
        return item.get("first"), item.get("second")
    if isinstance(item, (list, tuple)) and len(item) >= 2:
        return item[0], item[1]
    return "", ""


def flatten_color(value: Any) -> str:
    if not isinstance(value, dict):
        return ""
    return ",".join(str(value.get(k, "")) for k in ("r", "g", "b", "a"))


def flatten_vec2(value: Any) -> str:
    if not isinstance(value, dict):
        return ""
    return ",".join(str(value.get(k, "")) for k in ("x", "y"))


def collect_shared_material_refs() -> tuple[dict[str, dict[str, Any]], Counter[str]]:
    refs: dict[str, dict[str, Any]] = {}
    usage: Counter[str] = Counter()
    for row in read_csv(TMP_DETAILS_CSV):
        path_id = (row.get("shared_material_path_id") or "").strip()
        if not path_id or path_id == "0":
            continue
        usage[path_id] += 1
        entry = refs.setdefault(
            path_id,
            {
                "shared_material_path_id": path_id,
                "usage_count": 0,
                "font_asset_names": set(),
                "font_asset_path_ids": set(),
                "texts": [],
                "game_object_names": set(),
            },
        )
        entry["font_asset_names"].add(row.get("font_asset_name", ""))
        entry["font_asset_path_ids"].add(row.get("font_asset_path_id", ""))
        entry["game_object_names"].add(row.get("game_object_name", ""))
        text = row.get("display_text") or row.get("source_text_raw") or ""
        if text and len(entry["texts"]) < 8:
            entry["texts"].append(text)
    for path_id, count in usage.items():
        refs[path_id]["usage_count"] = count
    return refs, usage


def iter_uifont_bundles() -> list[tuple[str, Path]]:
    rows = read_csv(EXPORT_MAP_CSV)
    result: list[tuple[str, Path]] = []
    for row in rows:
        bundle = row.get("bundle", "")
        lower = bundle.lower()
        if not lower.startswith("download/ui/uifont/") and lower != "download/commonprefabsandres/tmpshaders.assetbundle":
            continue
        bundle_path = ASSETBUNDLE_ROOT / bundle.replace("/", "\\")
        if not bundle_path.exists():
            bundle_path = ASSETBUNDLE_ROOT / Path(*bundle.split("/"))
        if bundle_path.exists():
            result.append((bundle, bundle_path))
    return result


def material_properties(font_key: str, path_id: str, bundle: str, tree: dict[str, Any]) -> list[dict[str, Any]]:
    saved = tree.get("m_SavedProperties") or {}
    rows: list[dict[str, Any]] = []
    for item in saved.get("m_TexEnvs") or []:
        first, second = pair_first_second(item)
        second = second or {}
        rows.append(
            {
                "shared_material_path_id": path_id,
                "font_key": font_key,
                "bundle": bundle,
                "material_name": tree.get("m_Name", ""),
                "property_type": "texture",
                "property_name": prop_name(first),
                "value": ref_path_id((second.get("m_Texture") or {})),
                "scale": flatten_vec2(second.get("m_Scale")),
                "offset": flatten_vec2(second.get("m_Offset")),
            }
        )
    for item in saved.get("m_Floats") or []:
        first, second = pair_first_second(item)
        rows.append(
            {
                "shared_material_path_id": path_id,
                "font_key": font_key,
                "bundle": bundle,
                "material_name": tree.get("m_Name", ""),
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
                "shared_material_path_id": path_id,
                "font_key": font_key,
                "bundle": bundle,
                "material_name": tree.get("m_Name", ""),
                "property_type": "color",
                "property_name": prop_name(first),
                "value": flatten_color(second),
                "scale": "",
                "offset": "",
            }
        )
    return rows


def guess_font_key(ref: dict[str, Any], material_name: str) -> str:
    names = {str(v).lower() for v in ref.get("font_asset_names", set()) if v}
    material_lower = material_name.lower()
    for key in ("riyu", "epm", "num"):
        if key in names or key in material_lower:
            return "EPM" if key == "epm" else key
    if "EPM" in ref.get("font_asset_names", set()):
        return "EPM"
    return sorted(ref.get("font_asset_names", [""]))[0] if ref.get("font_asset_names") else ""


def main() -> int:
    refs, usage = collect_shared_material_refs()
    target_ids = set(refs)
    found_rows: list[dict[str, Any]] = []
    property_rows: list[dict[str, Any]] = []
    found_ids: set[str] = set()

    for bundle, bundle_path in iter_uifont_bundles():
        try:
            env = UnityPy.load(str(bundle_path))
        except Exception:
            continue
        for obj in env.objects:
            if obj.type.name != "Material":
                continue
            path_id = str(obj.path_id)
            if path_id not in target_ids:
                continue
            try:
                tree = obj.read_typetree()
            except Exception:
                continue
            ref = refs[path_id]
            found_ids.add(path_id)
            font_key = guess_font_key(ref, tree.get("m_Name", ""))
            saved = tree.get("m_SavedProperties") or {}
            found_rows.append(
                {
                    "shared_material_path_id": path_id,
                    "usage_count": ref["usage_count"],
                    "font_key": font_key,
                    "font_asset_names": ";".join(sorted(ref["font_asset_names"])),
                    "game_object_names": ";".join(sorted(ref["game_object_names"]))[:300],
                    "text_samples": ";".join(ref["texts"])[:300],
                    "bundle": bundle,
                    "bundle_path": str(bundle_path),
                    "material_name": tree.get("m_Name", ""),
                    "shader_path_id": ref_path_id(tree.get("m_Shader")),
                    "texture_property_count": len(saved.get("m_TexEnvs") or []),
                    "float_property_count": len(saved.get("m_Floats") or []),
                    "color_property_count": len(saved.get("m_Colors") or []),
                }
            )
            property_rows.extend(material_properties(font_key, path_id, bundle, tree))

    missing_rows = []
    for path_id, ref in sorted(refs.items(), key=lambda item: (-item[1]["usage_count"], item[0])):
        if path_id in found_ids:
            continue
        missing_rows.append(
            {
                "shared_material_path_id": path_id,
                "usage_count": ref["usage_count"],
                "font_asset_names": ";".join(sorted(ref["font_asset_names"])),
                "game_object_names": ";".join(sorted(ref["game_object_names"]))[:300],
                "text_samples": ";".join(ref["texts"])[:300],
            }
        )

    summary = {
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "referenced_shared_material_count": len(refs),
        "found_shared_material_count": len(found_ids),
        "missing_shared_material_count": len(missing_rows),
        "total_tmp_text_refs": sum(usage.values()),
        "top_usage": [
            {"shared_material_path_id": path_id, "usage_count": count}
            for path_id, count in usage.most_common(20)
        ],
        "verdict": "shared material presets are required; MainInterface currently cannot match TMP route text if it only uses base font materials",
    }
    OUT_SUMMARY_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_SUMMARY_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    write_csv(
        OUT_MATERIALS_CSV,
        sorted(found_rows, key=lambda row: (-int(row["usage_count"]), row["shared_material_path_id"])),
        [
            "shared_material_path_id",
            "usage_count",
            "font_key",
            "font_asset_names",
            "game_object_names",
            "text_samples",
            "bundle",
            "bundle_path",
            "material_name",
            "shader_path_id",
            "texture_property_count",
            "float_property_count",
            "color_property_count",
        ],
    )
    write_csv(
        OUT_PROPERTIES_CSV,
        property_rows,
        [
            "shared_material_path_id",
            "font_key",
            "bundle",
            "material_name",
            "property_type",
            "property_name",
            "value",
            "scale",
            "offset",
        ],
    )
    write_csv(
        OUT_MISSING_CSV,
        missing_rows,
        ["shared_material_path_id", "usage_count", "font_asset_names", "game_object_names", "text_samples"],
    )
    write_markdown(summary, found_rows, missing_rows)
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return 0


def write_markdown(summary: dict[str, Any], found_rows: list[dict[str, Any]], missing_rows: list[dict[str, Any]]) -> None:
    lines: list[str] = []
    lines.append("# MainInterface TMP Shared Material Analysis")
    lines.append("")
    lines.append(f"Generated: {summary['generated_at']}")
    lines.append("")
    lines.append("## Verdict")
    lines.append("")
    lines.append("MainInterface TMP 텍스트는 base FontAsset material만 쓰지 않는다. `shared_material_path_id` 기준으로 색상, outline, underlay, gradient scale이 다른 material preset을 참조한다. 현재 빌더가 static TMP FontAsset의 기본 material만 쓰면 route 라벨 두께/색/스케일이 원본과 달라질 수 있다.")
    lines.append("")
    lines.append("## Counts")
    lines.append("")
    lines.append("| item | value |")
    lines.append("| --- | ---: |")
    lines.append(f"| referenced shared materials | {summary['referenced_shared_material_count']} |")
    lines.append(f"| found shared materials | {summary['found_shared_material_count']} |")
    lines.append(f"| missing shared materials | {summary['missing_shared_material_count']} |")
    lines.append(f"| total TMP text refs | {summary['total_tmp_text_refs']} |")
    lines.append("")
    lines.append("## Top Found Materials")
    lines.append("")
    lines.append("| shared pathID | refs | font | material | bundle | text samples |")
    lines.append("| --- | ---: | --- | --- | --- | --- |")
    for row in sorted(found_rows, key=lambda item: (-int(item["usage_count"]), item["shared_material_path_id"]))[:20]:
        lines.append(
            f"| `{row['shared_material_path_id']}` | {row['usage_count']} | `{row['font_key']}` | "
            f"`{row['material_name']}` | `{row['bundle']}` | `{row['text_samples']}` |"
        )
    lines.append("")
    lines.append("## Missing Materials")
    lines.append("")
    if missing_rows:
        lines.append("| shared pathID | refs | font | text samples |")
        lines.append("| --- | ---: | --- | --- |")
        for row in missing_rows[:20]:
            lines.append(
                f"| `{row['shared_material_path_id']}` | {row['usage_count']} | `{row['font_asset_names']}` | `{row['text_samples']}` |"
            )
    else:
        lines.append("모든 referenced shared material pathID를 원본 uifont bundle에서 찾았다.")
    lines.append("")
    lines.append("## Next")
    lines.append("")
    lines.append("1. 찾은 shared material property를 Unity Material asset으로 재구성한다.")
    lines.append("2. `TmpTextDetailRow.sharedMaterialPathId` 기준으로 `TextMeshProUGUI.fontSharedMaterial`을 지정한다.")
    lines.append("3. route 라벨 캡처를 다시 확인하고, 그 다음 active state/sibling 보정을 진행한다.")
    lines.append("")
    lines.append("## Generated Files")
    lines.append("")
    for path in [OUT_SUMMARY_JSON, OUT_MATERIALS_CSV, OUT_PROPERTIES_CSV, OUT_MISSING_CSV]:
        lines.append(f"- `{path}`")
    OUT_MD.parent.mkdir(parents=True, exist_ok=True)
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    raise SystemExit(main())
