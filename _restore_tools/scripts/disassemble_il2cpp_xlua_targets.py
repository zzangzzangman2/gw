from __future__ import annotations

import csv
import json
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM
from elftools.elf.elffile import ELFFile


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
REPORT_DIR = PROJECT / "Assets" / "RestoreData" / "reports"
NATIVE_DIR = BASE / "il2cpp_native"
LIB = NATIVE_DIR / "libil2cpp.so"

OUT_ASM = NATIVE_DIR / "il2cpp_xlua_target_disassembly.asm"
OUT_CSV = REPORT_DIR / "maininterface_il2cpp_xlua_disassembly.csv"
OUT_JSON = REPORT_DIR / "maininterface_il2cpp_xlua_disassembly_summary.json"

EXTRA_TARGETS = [
    {"symbol": "SecurityUtil.Xor", "rva": "0xF84ED4", "signature_or_field": "public static byte[] Xor(byte[] buffer) { }"},
    {"symbol": "SecurityUtil..cctor", "rva": "0xF85030", "signature_or_field": "private static void .cctor()"},
    {"symbol": "XXTEAUtil.Encrypt(byte[])", "rva": "0x1C78D98", "signature_or_field": "public static byte[] Encrypt(byte[] data) { }"},
    {"symbol": "XXTEAUtil.Decrypt(byte[])", "rva": "0x1C79540", "signature_or_field": "public static byte[] Decrypt(byte[] data) { }"},
    {"symbol": "XXTEAUtil.Encrypt(string,key)", "rva": "0x1C79974", "signature_or_field": "public static string Encrypt(string source, string key) { }"},
    {"symbol": "XXTEAUtil.Decrypt(string,key)", "rva": "0x1C79D68", "signature_or_field": "public static string Decrypt(string source, string key) { }"},
    {"symbol": "XXTEAUtil.ToIntArray", "rva": "0x1C78E80", "signature_or_field": "public static int[] ToIntArray(byte[] data, bool includeLength) { }"},
    {"symbol": "XXTEAUtil.ToByteArray", "rva": "0x1C793B0", "signature_or_field": "public static byte[] ToByteArray(int[] data, bool includeLength) { }"},
    {"symbol": "XXTEAUtil.Base64Decode", "rva": "0x1C7A234", "signature_or_field": "public static string Base64Decode(string data) { }"},
    {"symbol": "XXTEAUtil.Base64Encode", "rva": "0x1C7A3F0", "signature_or_field": "public static string Base64Encode(string data) { }"},
    {"symbol": "XXTEAUtil..cctor", "rva": "0x1C7A5A4", "signature_or_field": "private static void .cctor()"},
]


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, str]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def load_segments() -> list[dict[str, int]]:
    with LIB.open("rb") as f:
        elf = ELFFile(f)
        segments = []
        for seg in elf.iter_segments():
            if seg["p_type"] != "PT_LOAD":
                continue
            segments.append(
                {
                    "vaddr": int(seg["p_vaddr"]),
                    "memsz": int(seg["p_memsz"]),
                    "offset": int(seg["p_offset"]),
                    "filesz": int(seg["p_filesz"]),
                    "flags": int(seg["p_flags"]),
                }
            )
        return segments


def rva_to_offset(rva: int, segments: list[dict[str, int]]) -> int:
    for seg in segments:
        start = seg["vaddr"]
        end = start + seg["filesz"]
        if start <= rva < end:
            return seg["offset"] + (rva - start)
    raise ValueError(f"RVA {rva:#x} is not inside a PT_LOAD file range")


def disassemble_at(rva: int, size: int = 0x480) -> list[str]:
    segments = load_segments()
    offset = rva_to_offset(rva, segments)
    data = LIB.read_bytes()[offset : offset + size]
    md = Cs(CS_ARCH_ARM64, CS_MODE_ARM)
    lines = []
    for insn in md.disasm(data, rva):
        lines.append(f"{insn.address:08x}: {insn.mnemonic:<8} {insn.op_str}".rstrip())
    return lines


def main() -> None:
    method_rows = read_csv(REPORT_DIR / "maininterface_xlua_loader_methods.csv")
    targets = [
        row
        for row in method_rows
        if row.get("rva")
        and (
            row.get("symbol", "").startswith("XXTEAUtil.")
            or row.get("symbol", "")
            in {"LuaManager.GetLuaBuff", "LuaManager.MyLoader", "LuaManager.LoadUIScript"}
        )
    ]
    targets.extend(EXTRA_TARGETS)

    segments = load_segments()
    csv_rows: list[dict[str, str]] = []
    asm_blocks: list[str] = []
    for target in targets:
        symbol = target["symbol"]
        rva = int(target["rva"], 16)
        try:
            offset = rva_to_offset(rva, segments)
            lines = disassemble_at(rva)
            status = "ok"
            first_lines = "\n".join(lines[:12])
            asm_blocks.append(
                "\n".join(
                    [
                        f"; {symbol}",
                        f"; RVA {rva:#x} file_offset {offset:#x}",
                        f"; {target.get('signature_or_field', '')}",
                        *lines,
                        "",
                    ]
                )
            )
        except Exception as exc:
            offset = -1
            status = f"error: {exc}"
            first_lines = ""
        csv_rows.append(
            {
                "symbol": symbol,
                "rva": f"0x{rva:X}",
                "file_offset": "" if offset < 0 else f"0x{offset:X}",
                "status": status,
                "first_12_instructions": first_lines,
            }
        )

    OUT_ASM.write_text("\n".join(asm_blocks), encoding="utf-8")
    write_csv(OUT_CSV, csv_rows, ["symbol", "rva", "file_offset", "status", "first_12_instructions"])
    summary = {
        "libil2cpp": str(LIB),
        "targets": len(targets),
        "successful_targets": sum(1 for row in csv_rows if row["status"] == "ok"),
        "asm_output": str(OUT_ASM),
        "csv_output": str(OUT_CSV),
    }
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
