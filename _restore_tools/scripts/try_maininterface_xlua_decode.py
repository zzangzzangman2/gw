from __future__ import annotations

import csv
import gzip
import json
import struct
import zlib
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
PROJECT = BASE / "girlswar_maininterface_unity"
REPORT_DIR = PROJECT / "Assets" / "RestoreData" / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"
NATIVE_DIR = BASE / "il2cpp_native"
METADATA = NATIVE_DIR / "global-metadata.dat"

ASSET_CSV = REPORT_DIR / "maininterface_xlua_asset_format.csv"
RAW_ASSET_CSV = REPORT_DIR / "maininterface_xlua_textasset_raw.csv"
OUT_CSV = REPORT_DIR / "maininterface_xlua_decode_attempts.csv"
OUT_JSON = REPORT_DIR / "maininterface_xlua_decode_summary.json"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_XLUA_DECODE_ATTEMPTS.md"
DECODED_DIR = MERGED / "decoded" / "xlua"

MAGIC = bytes([0x0C, 0x07, 0x08, 0x0D, 0x0B, 0x09])
SOKETKEY_OFFSET = 0x582889
ASS_OFFSET = 0x582B67
SECURITY_XORSCALE_OFFSET = 0x5829D1
SECURITY_XORSCALE_SIZE = 22

LUA_MARKERS = [
    b"local ",
    b"function",
    b"return",
    b"require",
    b"self.",
    b"XLua",
    b"CS.",
    b"UI_",
    b"MainPage",
]


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, object]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def hex_bytes(data: bytes, limit: int = 32) -> str:
    return " ".join(f"{b:02X}" for b in data[:limit])


def clean_preview(data: bytes, limit: int = 160) -> str:
    parts: list[str] = []
    for b in data[:limit]:
        if b == 9:
            parts.append("\\t")
        elif b == 10:
            parts.append("\\n")
        elif b == 13:
            parts.append("\\r")
        elif 32 <= b <= 126:
            parts.append(chr(b))
        else:
            parts.append(f"\\x{b:02X}")
    return "".join(parts)


def printable_ratio(data: bytes) -> float:
    if not data:
        return 0.0
    printable = sum(1 for b in data if b in (9, 10, 13) or 32 <= b <= 126)
    return printable / len(data)


def to_int_array(data: bytes, include_length: bool) -> list[int]:
    n = (len(data) + 3) // 4
    padded = data + b"\x00" * (n * 4 - len(data))
    values = list(struct.unpack("<" + "I" * n, padded)) if n else []
    if include_length:
        values.append(len(data))
    return values


def to_byte_array(values: list[int], include_length: bool) -> bytes | None:
    n = len(values) * 4
    if include_length:
        if not values:
            return b""
        m = values[-1] & 0xFFFFFFFF
        n -= 4
        if m < n - 3 or m > n:
            return None
        n = m
        values = values[:-1]
    data = b"".join(struct.pack("<I", value & 0xFFFFFFFF) for value in values)
    return data[:n]


def xxtea_decrypt(data: bytes, key: bytes) -> bytes | None:
    if not data:
        return b""
    v = to_int_array(data, False)
    if len(v) < 2:
        return data
    k = to_int_array(key, False)
    if len(k) < 4:
        k.extend([0] * (4 - len(k)))
    n = len(v) - 1
    delta = 0x9E3779B9
    rounds = 6 + 52 // (n + 1)
    total = (rounds * delta) & 0xFFFFFFFF
    y = v[0]
    while total:
        e = (total >> 2) & 3
        for p in range(n, 0, -1):
            z = v[p - 1]
            y = v[p]
            mx = (((z >> 5) ^ ((y << 2) & 0xFFFFFFFF)) + ((y >> 3) ^ ((z << 4) & 0xFFFFFFFF))) & 0xFFFFFFFF
            mx ^= ((total ^ y) + (k[(p & 3) ^ e] ^ z)) & 0xFFFFFFFF
            v[p] = (v[p] - mx) & 0xFFFFFFFF
        z = v[n]
        y = v[0]
        mx = (((z >> 5) ^ ((y << 2) & 0xFFFFFFFF)) + ((y >> 3) ^ ((z << 4) & 0xFFFFFFFF))) & 0xFFFFFFFF
        mx ^= ((total ^ y) + (k[e] ^ z)) & 0xFFFFFFFF
        v[0] = (v[0] - mx) & 0xFFFFFFFF
        total = (total - delta) & 0xFFFFFFFF
    return to_byte_array(v, True)


def repeating_xor(data: bytes, key: bytes) -> bytes:
    if not key:
        return data
    return bytes(b ^ key[i % len(key)] for i, b in enumerate(data))


def strip_utf8_bom_to_spaces(data: bytes) -> bytes:
    if len(data) >= 3 and data[:3] == b"\xEF\xBB\xBF":
        return b"   " + data[3:]
    return data


def decompress_candidates(data: bytes) -> list[tuple[str, bytes]]:
    out: list[tuple[str, bytes]] = []
    for label, payload in [
        ("zlib", data),
        ("zlib_skip1", data[1:]),
        ("zlib_skip2", data[2:]),
        ("zlib_skip4", data[4:]),
    ]:
        try:
            out.append((label, zlib.decompress(payload)))
        except Exception:
            pass
    try:
        out.append(("gzip", gzip.decompress(data)))
    except Exception:
        pass
    return out


def classify(data: bytes | None) -> dict[str, object]:
    if data is None:
        return {
            "classification": "invalid",
            "score": -100,
            "printable_ratio": 0.0,
            "lua_marker_count": 0,
            "preview": "",
        }
    first = data[:4096]
    ratio = printable_ratio(first)
    marker_count = sum(1 for marker in LUA_MARKERS if marker in first)
    score = int(ratio * 40) + marker_count * 12
    classification = "binary"
    if data.startswith(b"\x1bLua") or data.startswith(b"\x1bLJ"):
        classification = "lua_bytecode"
        score += 120
    elif marker_count >= 2 and ratio >= 0.65:
        classification = "lua_like_text"
        score += 80
    elif data.startswith((b"A-EV", b"K7HT")):
        classification = "encoded_text_prefix"
        score += 5
    elif data.startswith((b"\x78\x01", b"\x78\x9C", b"\x78\xDA")):
        classification = "zlib_stream"
        score += 50
    elif data.startswith(b"\x1F\x8B"):
        classification = "gzip_stream"
        score += 50
    elif ratio >= 0.85:
        classification = "mostly_printable"
        score += 15
    return {
        "classification": classification,
        "score": score,
        "printable_ratio": round(ratio, 3),
        "lua_marker_count": marker_count,
        "preview": clean_preview(data),
    }


def add_attempt(rows: list[dict[str, object]], asset: dict[str, str], attempt: str, data: bytes | None) -> None:
    info = classify(data)
    rows.append(
        {
            "asset_name": asset["name"],
            "path_id": asset["path_id"],
            "attempt": attempt,
            "output_size": 0 if data is None else len(data),
            "classification": info["classification"],
            "score": info["score"],
            "printable_ratio": info["printable_ratio"],
            "lua_marker_count": info["lua_marker_count"],
            "prefix_hex": "" if data is None else hex_bytes(data),
            "preview": info["preview"],
        }
    )


def best_single_xor(data: bytes) -> tuple[int, bytes, dict[str, object]]:
    best_key = 0
    best_data = data
    best_info = classify(data)
    for key in range(256):
        candidate = bytes(b ^ key for b in data)
        info = classify(candidate)
        if int(info["score"]) > int(best_info["score"]):
            best_key = key
            best_data = candidate
            best_info = info
    return best_key, best_data, best_info


def resolve_asset_path(row: dict[str, str]) -> Path:
    output = Path(row["output"])
    if output.is_absolute():
        return output
    return MERGED / output


def safe_output_name(asset_name: str, path_id: str, attempt: str) -> str:
    safe_attempt = "".join(c if c.isalnum() or c in ("_", "-") else "_" for c in attempt)
    safe_name = "".join(c if c.isalnum() or c in ("_", "-") else "_" for c in asset_name)
    return f"{path_id}_{safe_name}_{safe_attempt}.lua"


def main() -> None:
    metadata = METADATA.read_bytes()
    soketkey = metadata[SOKETKEY_OFFSET : SOKETKEY_OFFSET + 8]
    ass = metadata[ASS_OFFSET : ASS_OFFSET + 64]
    security_xorscale = metadata[SECURITY_XORSCALE_OFFSET : SECURITY_XORSCALE_OFFSET + SECURITY_XORSCALE_SIZE]
    asset_csv = RAW_ASSET_CSV if RAW_ASSET_CSV.exists() else ASSET_CSV
    assets = read_csv(asset_csv)

    attempt_rows: list[dict[str, object]] = []
    best_rows: list[dict[str, object]] = []
    saved_outputs: list[str] = []
    magic_branch_count = 0

    for asset in assets:
        path = resolve_asset_path(asset)
        data = path.read_bytes()
        local_rows: list[dict[str, object]] = []
        local_payloads: dict[str, bytes | None] = {}

        def record(attempt: str, payload: bytes | None) -> None:
            local_payloads[attempt] = payload
            add_attempt(local_rows, asset, attempt, payload)

        record("raw_utf8_fallback", data)
        record("strip_prefix4", data[4:])

        security_xor_raw = repeating_xor(data, security_xorscale)
        record("security_xor_raw", security_xor_raw)
        record("getluabuff_security_xor_raw_bomspace", strip_utf8_bom_to_spaces(security_xor_raw))
        for label, decompressed in decompress_candidates(security_xor_raw):
            record(f"security_xor_raw_{label}", decompressed)

        for label, decompressed in decompress_candidates(data):
            record(f"raw_{label}", decompressed)
        for label, decompressed in decompress_candidates(data[4:]):
            record(f"strip4_{label}", decompressed)

        key_attempts = [
            ("soketkey", soketkey),
            ("ass64", ass),
            ("ass16", ass[:16]),
            ("literal_A-EV", b"A-EV"),
            ("literal_K7HT", b"K7HT"),
        ]
        for key_name, key in key_attempts:
            for source_name, source_data in [("raw", data), ("strip4", data[4:])]:
                decoded = xxtea_decrypt(source_data, key)
                record(f"xxtea_{key_name}_{source_name}", decoded)
                if decoded is not None:
                    for label, decompressed in decompress_candidates(decoded):
                        record(f"xxtea_{key_name}_{source_name}_{label}", decompressed)

        if data.startswith(MAGIC):
            magic_branch_count += 1
            magic_decoded = xxtea_decrypt(data[len(MAGIC) :], ass)
            record("decryptbytearray_magic_ass64", magic_decoded)
            if magic_decoded is not None:
                for label, decompressed in decompress_candidates(magic_decoded):
                    record(f"decryptbytearray_magic_ass64_{label}", decompressed)

        for key_name, key in [("soketkey", soketkey), ("ass64", ass)]:
            for source_name, source_data in [("raw", data), ("strip4", data[4:])]:
                record(f"xor_repeat_{key_name}_{source_name}", repeating_xor(source_data, key))

        for source_name, source_data in [("raw", data), ("strip4", data[4:])]:
            key, candidate, _info = best_single_xor(source_data)
            record(f"xor_single_best_{source_name}_0x{key:02X}", candidate)

        best = max(local_rows, key=lambda row: int(row["score"]))
        best_rows.append(best)
        attempt_rows.extend(local_rows)

        if best["classification"] in {"lua_like_text", "lua_bytecode"} and int(best["score"]) >= 100:
            attempt_name = str(best["attempt"])
            payload = local_payloads.get(attempt_name)
            if payload is not None:
                out_name = safe_output_name(asset["name"], asset["path_id"], attempt_name)
                out_path = DECODED_DIR / out_name
                DECODED_DIR.mkdir(parents=True, exist_ok=True)
                out_path.write_bytes(payload)
                saved_outputs.append(str(out_path))

    write_csv(
        OUT_CSV,
        attempt_rows,
        [
            "asset_name",
            "path_id",
            "attempt",
            "output_size",
            "classification",
            "score",
            "printable_ratio",
            "lua_marker_count",
            "prefix_hex",
            "preview",
        ],
    )

    lua_like = [row for row in best_rows if row["classification"] in {"lua_like_text", "lua_bytecode"}]
    summary = {
        "assets": len(assets),
        "asset_csv": str(asset_csv),
        "attempt_rows": len(attempt_rows),
        "magic_branch_assets": magic_branch_count,
        "best_lua_like_assets": len(lua_like),
        "soketkey_hex": hex_bytes(soketkey),
        "ass_hex": hex_bytes(ass, 64),
        "security_xorscale_offset": f"0x{SECURITY_XORSCALE_OFFSET:X}",
        "security_xorscale_hex": hex_bytes(security_xorscale, SECURITY_XORSCALE_SIZE),
        "outputs": {
            "csv": str(OUT_CSV),
            "json": str(OUT_JSON),
            "md": str(OUT_MD),
            "decoded_dir": str(DECODED_DIR),
        },
        "saved_outputs": saved_outputs,
        "best_rows": best_rows,
    }
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# MainInterface xLua decode 실험",
        "",
        "## 요약",
        "",
        f"- 테스트한 TextAsset: `{len(assets)}`",
        f"- Asset CSV: `{asset_csv}`",
        f"- 실험 row: `{len(attempt_rows)}`",
        f"- `DecryptByteArray` magic branch 진입 asset: `{magic_branch_count}`",
        f"- Lua-like 최종 결과: `{len(lua_like)}`",
        f"- `SoketKey`: `{hex_bytes(soketkey)}`",
        f"- `ass`: `{hex_bytes(ass, 64)}`",
        f"- `SecurityUtil.xorScale`: `{hex_bytes(security_xorscale, SECURITY_XORSCALE_SIZE)}`",
        "",
        "## 해석",
        "",
        "- MainInterface xLua TextAsset은 native `0C 07 08 0D 0B 09` magic이 아니라 `A-EV` 또는 `K7HT`로 시작한다.",
        "- `LuaManager.GetLuaBuff`는 TextAsset bytes를 읽은 뒤 `/DataTable/`, `/Proto/`가 아니면 `YouYouUtil.SecurityUtil.Xor`를 적용한다.",
        "- `SecurityUtil.Xor`는 `xorScale[i % 22]` 반복 XOR이며, `xorScale`은 IL2CPP `.cctor` 정적 배열에서 회수했다.",
        "- 이 리포트는 raw fallback, GetLuaBuff SecurityUtil.Xor, prefix strip, zlib/gzip, 회수 키 기반 XXTEA, XOR probe를 재현 가능하게 기록한다.",
        "",
        "## Asset별 최고 점수 시도",
        "",
        "| Asset | Prefix | 최고 점수 시도 | 분류 | 점수 | Preview |",
        "|---|---|---|---:|---:|---|",
    ]
    prefix_by_name = {row["name"]: row.get("prefix4", "") for row in assets}
    for row in sorted(best_rows, key=lambda item: (str(item["asset_name"]))):
        preview = str(row["preview"]).replace("|", "\\|")
        md.append(
            f"| `{row['asset_name']}` | `{prefix_by_name.get(str(row['asset_name']), '')}` | `{row['attempt']}` | `{row['classification']}` | `{row['score']}` | `{preview[:120]}` |"
        )
    md.extend(
        [
            "",
            "## 산출물",
            "",
            f"- CSV: `{OUT_CSV}`",
            f"- JSON: `{OUT_JSON}`",
            f"- decoded output directory: `{DECODED_DIR}`",
        ]
    )
    if saved_outputs:
        md.append(f"- 고신뢰 decoded 파일 저장: `{len(saved_outputs)}`")
    else:
        md.append("- 고신뢰 decoded 파일 저장: `0`")
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(json.dumps(summary, ensure_ascii=True, indent=2))


if __name__ == "__main__":
    main()
