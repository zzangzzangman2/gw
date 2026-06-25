from __future__ import annotations

import csv
import json
import struct
from pathlib import Path

from elftools.elf.elffile import ELFFile


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
REPORT_DIR = PROJECT / "Assets" / "RestoreData" / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"
NATIVE_DIR = BASE / "il2cpp_native"
LIB = NATIVE_DIR / "libil2cpp.so"
METADATA = NATIVE_DIR / "global-metadata.dat"

OUT_CSV = REPORT_DIR / "maininterface_xxtea_static_arrays.csv"
OUT_JSON = REPORT_DIR / "maininterface_xxtea_static_arrays_summary.json"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_XXTEA_STATIC_ARRAYS.md"

MAGIC = bytes([0x0C, 0x07, 0x08, 0x0D, 0x0B, 0x09])

FIELDS = [
    {
        "static_field": "SoketKey",
        "il2cpp_static_field_offset": "0x0",
        "array_length": 8,
        "cctor_slot_va": 0x303A278,
        "runtime_field_handle": 0x8000000B,
        "private_impl_field": "<PrivateImplementationDetails>.51BC53F57A91F0EA5E505C3FA50DBF7A4643F1D998AD328C11BFD334FEA3FDA7",
        "metadata_offset": 0x582889,
        "dump_note": "internal static readonly long ... = 6374570772997240934",
    },
    {
        "static_field": "ass",
        "il2cpp_static_field_offset": "0x8",
        "array_length": 64,
        "cctor_slot_va": 0x2FE9CB0,
        "runtime_field_handle": 0x8000001F,
        "private_impl_field": "<PrivateImplementationDetails>.FE21119749EA1152146E5E80F04AFFC8FE4D1161C7D8EDE6C6F74A864B7C2FCE",
        "metadata_offset": 0x582B67,
        "dump_note": "internal static readonly __StaticArrayInitTypeSize=64",
    },
]


def hex_bytes(data: bytes) -> str:
    return " ".join(f"{b:02X}" for b in data)


def ascii_preview(data: bytes) -> str:
    return "".join(chr(b) if 32 <= b <= 126 else "." for b in data)


def load_segments() -> list[dict[str, int]]:
    with LIB.open("rb") as f:
        elf = ELFFile(f)
        segments: list[dict[str, int]] = []
        for seg in elf.iter_segments():
            if seg["p_type"] != "PT_LOAD":
                continue
            segments.append(
                {
                    "vaddr": int(seg["p_vaddr"]),
                    "filesz": int(seg["p_filesz"]),
                    "offset": int(seg["p_offset"]),
                }
            )
        return segments


def va_to_offset(va: int, segments: list[dict[str, int]]) -> int | None:
    for seg in segments:
        start = seg["vaddr"]
        end = start + seg["filesz"]
        if start <= va < end:
            return seg["offset"] + (va - start)
    return None


def read_u64_at_va(data: bytes, va: int, segments: list[dict[str, int]]) -> int | None:
    offset = va_to_offset(va, segments)
    if offset is None or offset + 8 > len(data):
        return None
    return struct.unpack_from("<Q", data, offset)[0]


def write_csv(path: Path, rows: list[dict[str, object]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    lib_data = LIB.read_bytes()
    metadata_data = METADATA.read_bytes()
    segments = load_segments()

    rows: list[dict[str, object]] = []
    for item in FIELDS:
        slot = int(item["cctor_slot_va"])
        metadata_usage_table_va = read_u64_at_va(lib_data, slot, segments)
        handle_from_table = (
            read_u64_at_va(lib_data, metadata_usage_table_va, segments)
            if metadata_usage_table_va is not None
            else None
        )
        metadata_offset = int(item["metadata_offset"])
        size = int(item["array_length"])
        field_bytes = metadata_data[metadata_offset : metadata_offset + size]
        rows.append(
            {
                "static_field": item["static_field"],
                "il2cpp_static_field_offset": item["il2cpp_static_field_offset"],
                "array_length": size,
                "cctor_slot_va": f"0x{slot:X}",
                "metadata_usage_table_va": ""
                if metadata_usage_table_va is None
                else f"0x{metadata_usage_table_va:X}",
                "runtime_field_handle_expected": f"0x{int(item['runtime_field_handle']):X}",
                "runtime_field_handle_from_table": ""
                if handle_from_table is None
                else f"0x{handle_from_table:X}",
                "private_impl_field": item["private_impl_field"],
                "metadata_offset": f"0x{metadata_offset:X}",
                "bytes_hex": hex_bytes(field_bytes),
                "ascii_preview": ascii_preview(field_bytes),
                "dump_note": item["dump_note"],
                "handle_matches": handle_from_table == int(item["runtime_field_handle"]),
            }
        )

    write_csv(
        OUT_CSV,
        rows,
        [
            "static_field",
            "il2cpp_static_field_offset",
            "array_length",
            "cctor_slot_va",
            "metadata_usage_table_va",
            "runtime_field_handle_expected",
            "runtime_field_handle_from_table",
            "private_impl_field",
            "metadata_offset",
            "bytes_hex",
            "ascii_preview",
            "dump_note",
            "handle_matches",
        ],
    )

    summary = {
        "libil2cpp": str(LIB),
        "global_metadata": str(METADATA),
        "decrypt_bytearray_magic_hex": hex_bytes(MAGIC),
        "fields": rows,
        "outputs": {
            "csv": str(OUT_CSV),
            "json": str(OUT_JSON),
            "md": str(OUT_MD),
        },
    }
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    soket = next(row for row in rows if row["static_field"] == "SoketKey")
    ass = next(row for row in rows if row["static_field"] == "ass")
    md = [
        "# MainInterface XXTEA 정적 배열 추적",
        "",
        "## 요약",
        "",
        f"- DecryptByteArray magic: `{hex_bytes(MAGIC)}`",
        f"- `SoketKey`: metadata offset `{soket['metadata_offset']}`, bytes `{soket['bytes_hex']}`",
        f"- `ass`: metadata offset `{ass['metadata_offset']}`, 64 bytes recovered",
        "- `XXTEAUtil..cctor` initializes `SoketKey` at static field offset `0x0` and `ass` at `0x8`.",
        "",
        "## 회수한 필드",
        "",
        "| 필드 | Static offset | 길이 | cctor slot | Usage table | Runtime handle | Metadata offset | Bytes |",
        "|---|---:|---:|---:|---:|---:|---:|---|",
    ]
    for row in rows:
        md.append(
            "| {static_field} | `{il2cpp_static_field_offset}` | {array_length} | `{cctor_slot_va}` | `{metadata_usage_table_va}` | `{runtime_field_handle_from_table}` | `{metadata_offset}` | `{bytes_hex}` |".format(
                **row
            )
        )
    md.extend(
        [
            "",
            "## 복원 영향",
            "",
            "- `0C 07 08 0D 0B 09`로 시작하는 파일은 native `DecryptByteArray` 암호화 branch를 탄다.",
            "- 현재 MainInterface xLua TextAsset은 `A-EV` 또는 `K7HT`로 시작하므로 이 magic branch에 직접 들어가지 않는다.",
            "- 회수한 배열은 직접 decode 실험 재현과, 나중에 magic branch를 쓰는 asset을 만났을 때 필요하다.",
        ]
    )
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
