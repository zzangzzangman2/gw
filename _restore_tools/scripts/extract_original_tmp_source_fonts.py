from __future__ import annotations

import json
from datetime import datetime
from pathlib import Path

import UnityPy


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
FONT_BUNDLE_DIR = ROOT / "girlswar_merged_extracted" / "merged_content" / "AssetBundles" / "download" / "ui" / "uifont" / "japanese" / "font"
UNITY_PROJECT = ROOT / "girlswar_maininterface_unity"
OUTPUT_DIR = UNITY_PROJECT / "Assets" / "RestoreData" / "TMP" / "original_fonts"
REPORT_DIR = ROOT / "reports" / "maininterface"

FONT_SOURCES = [
    {
        "font_asset_name": "riyu",
        "source_bundle": "riyu_1.assetbundle",
        "source_font_object": "riyu_1",
        "font_asset_path_id": "2268522548353052838",
        "tmp_bundle": "download/ui/uifont/japanese/tmp/riyu.assetbundle",
    },
    {
        "font_asset_name": "EPM",
        "source_bundle": "epm.assetbundle",
        "source_font_object": "EPM",
        "font_asset_path_id": "-724809986894116682",
        "tmp_bundle": "download/ui/uifont/japanese/tmp/epm.assetbundle",
    },
    {
        "font_asset_name": "num",
        "source_bundle": "num.assetbundle",
        "source_font_object": "num",
        "font_asset_path_id": "454391846754054610",
        "tmp_bundle": "download/ui/uifont/japanese/tmp/num.assetbundle",
    },
]


def font_extension(data: bytes) -> str:
    if data.startswith(b"OTTO"):
        return ".otf"
    if data.startswith(b"\x00\x01\x00\x00") or data.startswith(b"true") or data.startswith(b"typ1"):
        return ".ttf"
    if data.startswith(b"ttcf"):
        return ".ttc"
    return ".fontdata"


def extract_font(source: dict) -> dict:
    bundle_path = FONT_BUNDLE_DIR / source["source_bundle"]
    if not bundle_path.exists():
        raise FileNotFoundError(bundle_path)

    env = UnityPy.load(str(bundle_path))
    font_rows = []
    for obj in env.objects:
        if obj.type.name != "Font":
            continue
        tree = obj.read_typetree()
        font_data = bytes(tree.get("m_FontData", []))
        font_name = tree.get("m_Name", "")
        font_names = tree.get("m_FontNames", [])
        ext = font_extension(font_data)
        output_name = f"{source['font_asset_name']}_source{ext}"
        output_path = OUTPUT_DIR / output_name
        OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
        output_path.write_bytes(font_data)
        font_rows.append(
            {
                **source,
                "source_bundle_path": str(bundle_path),
                "object_path_id": str(obj.path_id),
                "object_name": font_name,
                "font_names": font_names,
                "bytes": len(font_data),
                "magic": font_data[:8].hex(),
                "extension": ext,
                "unity_asset_path": "Assets/RestoreData/TMP/original_fonts/" + output_name,
                "output_path": str(output_path),
            }
        )

    if not font_rows:
        raise RuntimeError(f"No Font object found in {bundle_path}")
    return font_rows[0]


def write_reports(rows: list[dict]) -> None:
    generated_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    summary = {
        "generated_at": generated_at,
        "font_count": len(rows),
        "fonts": rows,
    }
    json_path = UNITY_PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_original_tmp_source_fonts.json"
    json_path.parent.mkdir(parents=True, exist_ok=True)
    json_path.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    md_path = REPORT_DIR / "MAININTERFACE_ORIGINAL_TMP_SOURCE_FONTS.md"
    lines = [
        "# MainInterface Original TMP Source Fonts",
        "",
        f"Generated: {generated_at}",
        "",
        "## Result",
        "",
        "원본 `uifont/japanese/font` 번들에서 TMP FontAsset 생성에 필요한 source font bytes를 추출했다.",
        "",
        "| TMP FontAsset | source bundle | object | bytes | extension | Unity asset path |",
        "| --- | --- | --- | ---: | --- | --- |",
    ]
    for row in rows:
        lines.append(
            "| `{font_asset_name}` | `{source_bundle}` | `{object_name}` | {bytes} | `{extension}` | `{unity_asset_path}` |".format(
                **row
            )
        )
    lines.extend(
        [
            "",
            "## Next",
            "",
            "SceneBuilder에서 `riyu`, `EPM`, `num` 각각의 source font로 TMP FontAsset을 생성하고, "
            "MainInterface TMP text row의 `font_asset_name`/`font_asset_path_id`에 따라 개별 적용한다.",
            "",
            "## Generated Files",
            "",
            f"- `{json_path}`",
        ]
    )
    for row in rows:
        lines.append(f"- `{row['output_path']}`")
    md_path.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    rows = [extract_font(source) for source in FONT_SOURCES]
    write_reports(rows)
    print(json.dumps({"font_count": len(rows), "fonts": rows}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
