from __future__ import annotations

import csv
import json
import re
from pathlib import Path
from typing import Any

import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
REPORT_DIR = BASE / "reports" / "battle"
NATIVE_DIR = BASE / "il2cpp_native"
METADATA = NATIVE_DIR / "global-metadata.dat"

RAW_DIR = MERGED / "extracted" / "unity" / "raw_textassets" / "battle_xlua"
DECODED_DIR = MERGED / "decoded" / "xlua_battle"

OUT_RAW_CSV = REPORT_DIR / "BATTLE_XLUA_RAW_TEXTASSETS.csv"
OUT_DECODE_CSV = REPORT_DIR / "BATTLE_XLUA_DECODE_RESULTS.csv"
OUT_SUMMARY = REPORT_DIR / "battle_xlua_decode_summary.json"
OUT_MD = REPORT_DIR / "BATTLE_XLUA_DECODE_RESULTS.md"

SECURITY_XORSCALE_OFFSET = 0x5829D1
SECURITY_XORSCALE_SIZE = 22

TARGETS = [
    ("download/xlualogic/modules/battle.assetbundle", None),
    ("download/xlualogic/modules/battlepreview.assetbundle", None),
    ("download/xlualogic/modules/battlerelicscript.assetbundle", None),
    ("download/xlualogic/modules/battleskillscript.assetbundle", None),
    ("download/xlualogic/modules/battlebuffscript.assetbundle", None),
    ("download/xlualogic/modules/procedure.assetbundle", re.compile(r"^ProcedureNormalBattle$")),
    ("download/xlualogic/modules/maincity.assetbundle", re.compile(r"^UI_NormalBattle")),
]

LUA_MARKERS = [
    b"local ",
    b"function",
    b"return",
    b"require",
    b"self.",
    b"CS.",
    b"Battle",
    b"Hero",
    b"Skill",
]


def write_csv(path: Path, rows: list[dict[str, object]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def safe_name(name: str) -> str:
    return "".join(ch if ch.isalnum() or ch in ("_", "-") else "_" for ch in name)


def clean_preview(data: bytes, limit: int = 140) -> str:
    out: list[str] = []
    for b in data[:limit]:
        if b == 9:
            out.append("\\t")
        elif b == 10:
            out.append("\\n")
        elif b == 13:
            out.append("\\r")
        elif 32 <= b <= 126:
            out.append(chr(b))
        else:
            out.append(f"\\x{b:02X}")
    return "".join(out)


def printable_ratio(data: bytes) -> float:
    if not data:
        return 0.0
    sample = data[:4096]
    printable = sum(1 for b in sample if b in (9, 10, 13) or 32 <= b <= 126)
    return printable / len(sample)


def classify(data: bytes) -> tuple[str, int, float, int, str]:
    sample = data[:4096]
    ratio = printable_ratio(sample)
    markers = sum(1 for marker in LUA_MARKERS if marker in sample)
    score = int(ratio * 40) + markers * 14
    classification = "binary"
    if data.startswith(b"\x1bLua") or data.startswith(b"\x1bLJ"):
        classification = "lua_bytecode"
        score += 120
    elif markers >= 2 and ratio >= 0.65:
        classification = "lua_like_text"
        score += 90
    elif data.startswith((b"A-EV", b"K7HT")):
        classification = "encoded_text_prefix"
        score += 5
    elif ratio >= 0.85:
        classification = "mostly_printable"
        score += 10
    return classification, score, round(ratio, 3), markers, clean_preview(data)


def raw_payload(payload: Any) -> tuple[bytes, str]:
    if payload is None:
        return b"", "empty"
    if isinstance(payload, bytes):
        return payload, "bytes"
    if isinstance(payload, bytearray):
        return bytes(payload), "bytearray"
    if isinstance(payload, str):
        return payload.encode("utf-8", "surrogateescape"), "str_surrogateescape_utf8"
    return str(payload).encode("utf-8", "surrogateescape"), f"fallback_{type(payload).__name__}"


def repeating_xor(data: bytes, key: bytes) -> bytes:
    return bytes(b ^ key[i % len(key)] for i, b in enumerate(data)) if key else data


def strip_utf8_bom_to_spaces(data: bytes) -> bytes:
    if data.startswith(b"\xEF\xBB\xBF"):
        return b"   " + data[3:]
    return data


def clean_bundle_path(bundle: str) -> Path:
    return MERGED / "extracted" / "unity" / "clean_unityfs_slices" / Path(bundle)


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    RAW_DIR.mkdir(parents=True, exist_ok=True)
    DECODED_DIR.mkdir(parents=True, exist_ok=True)

    metadata = METADATA.read_bytes()
    xorscale = metadata[SECURITY_XORSCALE_OFFSET : SECURITY_XORSCALE_OFFSET + SECURITY_XORSCALE_SIZE]

    raw_rows: list[dict[str, object]] = []
    decode_rows: list[dict[str, object]] = []
    saved_outputs: list[str] = []

    for bundle, name_filter in TARGETS:
        bundle_path = clean_bundle_path(bundle)
        if not bundle_path.exists():
            decode_rows.append(
                {
                    "bundle": bundle,
                    "path_id": "",
                    "name": "",
                    "raw_size": 0,
                    "prefix4": "",
                    "best_attempt": "missing_bundle",
                    "classification": "missing",
                    "score": -100,
                    "printable_ratio": 0,
                    "lua_marker_count": 0,
                    "decoded_output": "",
                    "preview": str(bundle_path),
                }
            )
            continue
        env = UnityPy.load(bundle_path.read_bytes())
        for obj in env.objects:
            if obj.type.name != "TextAsset":
                continue
            obj_data = obj.read()
            name = str(getattr(obj_data, "m_Name", None) or getattr(obj_data, "name", None) or f"textasset_{obj.path_id}")
            if name_filter is not None and not name_filter.search(name):
                continue
            payload = getattr(obj_data, "script", None)
            if payload is None:
                payload = getattr(obj_data, "m_Script", None)
            raw, source_kind = raw_payload(payload)
            bundle_key = safe_name(bundle.replace("/", "_").replace(".assetbundle", ""))
            raw_out = RAW_DIR / bundle_key / f"{obj.path_id}_{safe_name(name)}.bytes"
            raw_out.parent.mkdir(parents=True, exist_ok=True)
            raw_out.write_bytes(raw)
            prefix4 = raw[:4].decode("latin1", errors="replace")
            raw_rows.append(
                {
                    "bundle": bundle,
                    "source_bundle": str(bundle_path),
                    "path_id": obj.path_id,
                    "name": name,
                    "raw_size": len(raw),
                    "prefix4": prefix4,
                    "prefix16_hex": raw[:16].hex(" ").upper(),
                    "source_kind": source_kind,
                    "raw_output": str(raw_out),
                }
            )

            attempts = {
                "raw": raw,
                "security_xor_raw": repeating_xor(raw, xorscale),
                "security_xor_raw_bomspace": strip_utf8_bom_to_spaces(repeating_xor(raw, xorscale)),
                "security_xor_strip4": repeating_xor(raw[4:], xorscale),
            }
            best_attempt = ""
            best_payload = b""
            best_info = ("binary", -100, 0.0, 0, "")
            for attempt, data in attempts.items():
                info = classify(data)
                if info[1] > best_info[1]:
                    best_attempt = attempt
                    best_payload = data
                    best_info = info

            classification, score, ratio, markers, preview = best_info
            decoded_output = ""
            if classification in {"lua_like_text", "lua_bytecode"} and score >= 100:
                suffix = ".lua" if classification == "lua_like_text" else ".luac"
                out_path = DECODED_DIR / bundle_key / f"{obj.path_id}_{safe_name(name)}_{best_attempt}{suffix}"
                out_path.parent.mkdir(parents=True, exist_ok=True)
                out_path.write_bytes(best_payload)
                decoded_output = str(out_path)
                saved_outputs.append(decoded_output)

            decode_rows.append(
                {
                    "bundle": bundle,
                    "path_id": obj.path_id,
                    "name": name,
                    "raw_size": len(raw),
                    "prefix4": prefix4,
                    "best_attempt": best_attempt,
                    "classification": classification,
                    "score": score,
                    "printable_ratio": ratio,
                    "lua_marker_count": markers,
                    "decoded_output": decoded_output,
                    "preview": preview,
                }
            )

    write_csv(
        OUT_RAW_CSV,
        raw_rows,
        ["bundle", "source_bundle", "path_id", "name", "raw_size", "prefix4", "prefix16_hex", "source_kind", "raw_output"],
    )
    write_csv(
        OUT_DECODE_CSV,
        decode_rows,
        [
            "bundle",
            "path_id",
            "name",
            "raw_size",
            "prefix4",
            "best_attempt",
            "classification",
            "score",
            "printable_ratio",
            "lua_marker_count",
            "decoded_output",
            "preview",
        ],
    )

    class_counts: dict[str, int] = {}
    bundle_counts: dict[str, int] = {}
    for row in decode_rows:
        class_counts[str(row["classification"])] = class_counts.get(str(row["classification"]), 0) + 1
        bundle_counts[str(row["bundle"])] = bundle_counts.get(str(row["bundle"]), 0) + 1

    summary = {
        "raw_textassets": len(raw_rows),
        "decode_rows": len(decode_rows),
        "saved_decoded_outputs": len(saved_outputs),
        "classification_counts": class_counts,
        "bundle_counts": bundle_counts,
        "security_xorscale_offset": f"0x{SECURITY_XORSCALE_OFFSET:X}",
        "security_xorscale_hex": xorscale.hex(" ").upper(),
        "outputs": {
            "raw_csv": str(OUT_RAW_CSV),
            "decode_csv": str(OUT_DECODE_CSV),
            "summary_json": str(OUT_SUMMARY),
            "decoded_dir": str(DECODED_DIR),
            "raw_dir": str(RAW_DIR),
            "md": str(OUT_MD),
        },
    }
    OUT_SUMMARY.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    top = sorted(decode_rows, key=lambda r: int(r["score"]), reverse=True)[:30]
    md = [
        "# Battle XLua Decode Results",
        "",
        "## Summary",
        "",
        f"- Raw TextAssets extracted: `{len(raw_rows)}`",
        f"- Decode rows: `{len(decode_rows)}`",
        f"- Saved decoded Lua/bytecode outputs: `{len(saved_outputs)}`",
        f"- `SecurityUtil.xorScale`: `{xorscale.hex(' ').upper()}`",
        "",
        "## Classification Counts",
        "",
        "| Classification | Count |",
        "|---|---:|",
    ]
    for key, value in sorted(class_counts.items()):
        md.append(f"| `{key}` | `{value}` |")
    md.extend(
        [
            "",
            "## Best High-Value Results",
            "",
            "| Bundle | Name | Attempt | Class | Score | Output | Preview |",
            "|---|---|---|---|---:|---|---|",
        ]
    )
    for row in top:
        preview = str(row["preview"]).replace("|", "\\|")
        md.append(
            f"| `{row['bundle']}` | `{row['name']}` | `{row['best_attempt']}` | `{row['classification']}` | `{row['score']}` | `{row['decoded_output']}` | `{preview[:100]}` |"
        )
    md.extend(
        [
            "",
            "## Outputs",
            "",
            f"- Raw CSV: `{OUT_RAW_CSV}`",
            f"- Decode CSV: `{OUT_DECODE_CSV}`",
            f"- Summary JSON: `{OUT_SUMMARY}`",
            f"- Raw directory: `{RAW_DIR}`",
            f"- Decoded directory: `{DECODED_DIR}`",
        ]
    )
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(json.dumps(summary, ensure_ascii=True, indent=2))


if __name__ == "__main__":
    main()
