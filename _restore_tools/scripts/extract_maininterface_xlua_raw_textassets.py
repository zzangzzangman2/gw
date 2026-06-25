from __future__ import annotations

import csv
import json
from pathlib import Path
from typing import Any

import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
PROJECT = BASE / "girlswar_maininterface_unity"
REPORT_DIR = PROJECT / "Assets" / "RestoreData" / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"

BUNDLE_REL = Path("extracted/unity/clean_unityfs_slices/download/xlualogic/modules/maininterface.assetbundle")
BUNDLE = MERGED / BUNDLE_REL
RAW_DIR = MERGED / "extracted" / "unity" / "raw_textassets" / "download_xlualogic_modules_maininterface"

OUT_CSV = REPORT_DIR / "maininterface_xlua_textasset_raw.csv"
OUT_JSON = REPORT_DIR / "maininterface_xlua_textasset_raw_summary.json"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_XLUA_RAW_TEXTASSETS.md"


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def safe_name(name: str) -> str:
    return "".join(ch if ch.isalnum() or ch in ("_", "-") else "_" for ch in name)


def text_asset_raw_payload(payload: Any) -> tuple[bytes, str, int, int]:
    if payload is None:
        return b"", "empty", 0, 0
    if isinstance(payload, str):
        surrogate_count = sum(1 for ch in payload if 0xDC80 <= ord(ch) <= 0xDCFF)
        nonlatin_count = sum(1 for ch in payload if ord(ch) > 255 and not (0xDC80 <= ord(ch) <= 0xDCFF))
        return payload.encode("utf-8", "surrogateescape"), "str_surrogateescape_utf8", surrogate_count, nonlatin_count
    if isinstance(payload, bytearray):
        return bytes(payload), "bytearray", 0, 0
    if isinstance(payload, bytes):
        return payload, "bytes", 0, 0
    encoded = str(payload).encode("utf-8", "surrogateescape")
    return encoded, f"fallback_{type(payload).__name__}", 0, 0


def prefix_text(data: bytes) -> str:
    return data[:4].decode("latin1", errors="replace")


def main() -> None:
    if not BUNDLE.exists():
        raise FileNotFoundError(BUNDLE)

    RAW_DIR.mkdir(parents=True, exist_ok=True)
    env = UnityPy.load(BUNDLE.read_bytes())

    rows: list[dict[str, Any]] = []
    for obj in env.objects:
        if obj.type.name != "TextAsset":
            continue
        obj_data = obj.read()
        name = str(getattr(obj_data, "m_Name", None) or getattr(obj_data, "name", None) or f"textasset_{obj.path_id}")
        payload = getattr(obj_data, "script", None)
        if payload is None:
            payload = getattr(obj_data, "m_Script", None)
        raw, source_kind, surrogate_count, nonlatin_count = text_asset_raw_payload(payload)
        out_path = RAW_DIR / f"{obj.path_id}_{safe_name(name)}.bytes"
        out_path.write_bytes(raw)
        ascii_ratio = 0.0
        if raw:
            ascii_ratio = sum(1 for b in raw[:512] if b in (9, 10, 13) or 32 <= b <= 126) / min(len(raw), 512)
        rows.append(
            {
                "bundle": "download/xlualogic/modules/maininterface.assetbundle",
                "source_bundle": str(BUNDLE),
                "path_id": obj.path_id,
                "name": name,
                "size": len(raw),
                "output": str(out_path.relative_to(MERGED)).replace("\\", "/"),
                "prefix4": prefix_text(raw),
                "prefix16_hex": raw[:16].hex(" ").upper(),
                "ascii_ratio_first512": f"{ascii_ratio:.3f}",
                "source_kind": source_kind,
                "surrogate_byte_count": surrogate_count,
                "nonlatin_codepoint_count": nonlatin_count,
            }
        )

    rows.sort(key=lambda row: str(row["name"]))
    write_csv(
        OUT_CSV,
        rows,
        [
            "bundle",
            "source_bundle",
            "path_id",
            "name",
            "size",
            "output",
            "prefix4",
            "prefix16_hex",
            "ascii_ratio_first512",
            "source_kind",
            "surrogate_byte_count",
            "nonlatin_codepoint_count",
        ],
    )

    prefix_counts: dict[str, int] = {}
    for row in rows:
        prefix_counts[str(row["prefix4"])] = prefix_counts.get(str(row["prefix4"]), 0) + 1
    summary = {
        "source_bundle": str(BUNDLE),
        "raw_dir": str(RAW_DIR),
        "textassets": len(rows),
        "prefix_counts": dict(sorted(prefix_counts.items())),
        "surrogate_byte_total": sum(int(row["surrogate_byte_count"]) for row in rows),
        "nonlatin_codepoint_total": sum(int(row["nonlatin_codepoint_count"]) for row in rows),
        "outputs": {"csv": str(OUT_CSV), "json": str(OUT_JSON), "md": str(OUT_MD)},
    }
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# MainInterface xLua raw TextAsset extraction",
        "",
        "## Summary",
        "",
        f"- Source bundle: `{BUNDLE}`",
        f"- Raw TextAssets: `{len(rows)}`",
        f"- Prefix counts: `{json.dumps(summary['prefix_counts'], ensure_ascii=False)}`",
        f"- Surrogate-escaped bytes recovered: `{summary['surrogate_byte_total']}`",
        f"- Non-latin UTF-8 codepoints recovered: `{summary['nonlatin_codepoint_total']}`",
        "",
        "## Why This Exists",
        "",
        "- Previous TextAsset exports were useful evidence, but `.txt` writing through UTF-8 replacement can turn raw encrypted bytes into `?`.",
        "- This extraction encodes UnityPy `m_Script` with `surrogateescape`, preserving the bytes Unity would expose through `TextAsset.bytes`.",
        "- Source evidence is not deleted or overwritten; raw outputs are stored in a separate folder.",
        "",
        "## Outputs",
        "",
        f"- CSV: `{OUT_CSV}`",
        f"- JSON: `{OUT_JSON}`",
        f"- Raw directory: `{RAW_DIR}`",
    ]
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(json.dumps(summary, ensure_ascii=True, indent=2))


if __name__ == "__main__":
    main()
