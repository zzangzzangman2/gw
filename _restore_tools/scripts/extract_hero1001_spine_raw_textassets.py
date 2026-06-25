from __future__ import annotations

import csv
import json
import shutil
from pathlib import Path
from typing import Any

import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
PROJECT = BASE / "girlswar_maininterface_unity"
REPORTS = BASE / "reports" / "maininterface"
RESTORE_REPORTS = PROJECT / "Assets" / "RestoreData" / "reports"

BUNDLE_REL = Path("extracted/unity/clean_unityfs_slices/download/roleprefabsandres/paintingprefabandres/1001.assetbundle")
BUNDLE = MERGED / BUNDLE_REL
MERGED_RAW_DIR = MERGED / "extracted" / "unity" / "raw_textassets" / "download_roleprefabsandres_paintingprefabandres_1001"
UNITY_RAW_DIR = PROJECT / "Assets" / "RestoreData" / "hero1001_spine_source_raw" / "paintingprefabandres_1001"
UNITY_OLD_DIR = PROJECT / "Assets" / "RestoreData" / "hero1001_spine_source" / "paintingprefabandres_1001"

OUT_CSV = RESTORE_REPORTS / "maininterface_hero1001_spine_raw_textassets.csv"
OUT_JSON = RESTORE_REPORTS / "maininterface_hero1001_spine_raw_textassets_summary.json"
OUT_MD = REPORTS / "MAININTERFACE_HERO1001_SPINE_RAW_TEXTASSETS.md"


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def safe_name(name: str) -> str:
    return "".join(ch if ch.isalnum() or ch in ("_", "-", ".") else "_" for ch in name)


def payload_to_raw(payload: Any) -> tuple[bytes, str, int, int]:
    if payload is None:
        return b"", "empty", 0, 0
    if isinstance(payload, str):
        surrogate_count = sum(1 for ch in payload if 0xDC80 <= ord(ch) <= 0xDCFF)
        nonlatin_count = sum(1 for ch in payload if ord(ch) > 255 and not (0xDC80 <= ord(ch) <= 0xDCFF))
        return payload.encode("utf-8", "surrogateescape"), "str_surrogateescape_utf8", surrogate_count, nonlatin_count
    if isinstance(payload, bytes):
        return payload, "bytes", 0, 0
    if isinstance(payload, bytearray):
        return bytes(payload), "bytearray", 0, 0
    raw = str(payload).encode("utf-8", "surrogateescape")
    return raw, f"fallback_{type(payload).__name__}", 0, 0


def output_name(asset_name: str) -> str:
    name = safe_name(asset_name)
    if name.endswith(".skel"):
        return name + ".bytes"
    if name.endswith(".atlas"):
        return name + ".txt"
    return name + ".bytes"


def version_offsets(data: bytes) -> str:
    found = []
    for token in (b"4.0.56", b"4.0.47", b"4.0.64", b"Spine"):
        index = data.find(token)
        if index >= 0:
            found.append(f"{token.decode('ascii')}@{index}")
    return ", ".join(found)


def question_count(data: bytes) -> int:
    return data.count(0x3F)


def copy_png_sources() -> list[str]:
    copied = []
    if not UNITY_OLD_DIR.exists():
        return copied
    for path in sorted(UNITY_OLD_DIR.glob("*.png")):
        dest = UNITY_RAW_DIR / path.name
        shutil.copy2(path, dest)
        copied.append(dest.name)
    return copied


def main() -> None:
    if not BUNDLE.exists():
        raise FileNotFoundError(BUNDLE)

    MERGED_RAW_DIR.mkdir(parents=True, exist_ok=True)
    UNITY_RAW_DIR.mkdir(parents=True, exist_ok=True)
    RESTORE_REPORTS.mkdir(parents=True, exist_ok=True)
    REPORTS.mkdir(parents=True, exist_ok=True)

    env = UnityPy.load(BUNDLE.read_bytes())
    rows: list[dict[str, Any]] = []
    for obj in env.objects:
        if obj.type.name != "TextAsset":
            continue
        data = obj.read()
        asset_name = str(getattr(data, "m_Name", None) or getattr(data, "name", None) or f"textasset_{obj.path_id}")
        if not (asset_name.endswith(".skel") or asset_name.endswith(".atlas")):
            continue
        payload = getattr(data, "script", None)
        if payload is None:
            payload = getattr(data, "m_Script", None)
        raw, source_kind, surrogate_count, nonlatin_count = payload_to_raw(payload)
        file_name = output_name(asset_name)

        merged_out = MERGED_RAW_DIR / f"{obj.path_id}_{file_name}"
        unity_out = UNITY_RAW_DIR / file_name
        merged_out.write_bytes(raw)
        unity_out.write_bytes(raw)

        old_path = UNITY_OLD_DIR / file_name
        old = old_path.read_bytes() if old_path.exists() else b""
        rows.append(
            {
                "path_id": obj.path_id,
                "asset_name": asset_name,
                "file_name": file_name,
                "raw_size": len(raw),
                "old_size": len(old) if old else "",
                "raw_head16_hex": raw[:16].hex(" ").upper(),
                "old_head16_hex": old[:16].hex(" ").upper() if old else "",
                "raw_question_count": question_count(raw),
                "old_question_count": question_count(old) if old else "",
                "raw_version_offsets": version_offsets(raw),
                "old_version_offsets": version_offsets(old) if old else "",
                "source_kind": source_kind,
                "surrogate_byte_count": surrogate_count,
                "nonlatin_codepoint_count": nonlatin_count,
                "merged_raw_output": str(merged_out.relative_to(MERGED)).replace("\\", "/"),
                "unity_raw_output": str(unity_out.relative_to(PROJECT)).replace("\\", "/"),
                "differs_from_old_export": bool(old and old != raw),
            }
        )

    copied_pngs = copy_png_sources()
    readme = [
        "# Hero 1001 Raw Spine Source",
        "",
        "These `.skel.bytes` files were re-extracted from Unity TextAsset `m_Script` with `surrogateescape`.",
        "The older `hero1001_spine_source` files are kept as evidence, but their binary bytes contain replacement `?` values.",
        "",
        "Use this folder for Spine runtime probe imports.",
    ]
    (UNITY_RAW_DIR.parent / "README.md").write_text("\n".join(readme) + "\n", encoding="utf-8")

    rows.sort(key=lambda row: str(row["asset_name"]))
    write_csv(
        OUT_CSV,
        rows,
        [
            "path_id",
            "asset_name",
            "file_name",
            "raw_size",
            "old_size",
            "raw_head16_hex",
            "old_head16_hex",
            "raw_question_count",
            "old_question_count",
            "raw_version_offsets",
            "old_version_offsets",
            "source_kind",
            "surrogate_byte_count",
            "nonlatin_codepoint_count",
            "merged_raw_output",
            "unity_raw_output",
            "differs_from_old_export",
        ],
    )

    summary = {
        "source_bundle": str(BUNDLE),
        "merged_raw_dir": str(MERGED_RAW_DIR),
        "unity_raw_dir": str(UNITY_RAW_DIR),
        "textassets": len(rows),
        "copied_pngs": copied_pngs,
        "raw_total_bytes": sum(int(row["raw_size"]) for row in rows),
        "old_total_bytes": sum(int(row["old_size"] or 0) for row in rows),
        "raw_question_count": sum(int(row["raw_question_count"]) for row in rows),
        "old_question_count": sum(int(row["old_question_count"] or 0) for row in rows),
        "differing_exports": sum(1 for row in rows if row["differs_from_old_export"]),
        "outputs": {"csv": str(OUT_CSV), "json": str(OUT_JSON), "md": str(OUT_MD)},
    }
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    table = "\n".join(
        f"| `{row['asset_name']}` | `{row['raw_size']}` | `{row['old_size']}` | `{row['raw_head16_hex']}` | `{row['old_head16_hex']}` | `{row['differs_from_old_export']}` |"
        for row in rows
    )
    OUT_MD.write_text(
        "\n".join(
            [
                "# Hero 1001 Raw Spine TextAssets",
                "",
                "## Summary",
                "",
                f"- Source bundle: `{BUNDLE}`",
                f"- Raw TextAssets: `{len(rows)}`",
                f"- Raw output: `{UNITY_RAW_DIR}`",
                f"- Differing old exports: `{summary['differing_exports']}`",
                f"- Raw `?` byte count: `{summary['raw_question_count']}`",
                f"- Old `?` byte count: `{summary['old_question_count']}`",
                "",
                "## Why This Matters",
                "",
                "The previous `.skel.bytes` copies were exported through a text path and contain replacement `?` bytes.",
                "Spine 4.0 could import atlas/material files, but failed to read those corrupted skeleton binaries.",
                "This extraction preserves the original TextAsset bytes and keeps the older export as evidence.",
                "",
                "## Comparison",
                "",
                "| asset | raw bytes | old bytes | raw head16 | old head16 | differs |",
                "| --- | ---: | ---: | --- | --- | --- |",
                table,
                "",
                "## Outputs",
                "",
                f"- CSV: `{OUT_CSV}`",
                f"- JSON: `{OUT_JSON}`",
                f"- Unity raw folder: `{UNITY_RAW_DIR}`",
                f"- Merged raw folder: `{MERGED_RAW_DIR}`",
            ]
        )
        + "\n",
        encoding="utf-8",
    )

    print(json.dumps(summary, ensure_ascii=True, indent=2))


if __name__ == "__main__":
    main()
