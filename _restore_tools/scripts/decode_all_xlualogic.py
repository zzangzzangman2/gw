"""Decode ALL download/xlualogic Lua TextAssets (datatable, proto, common, every module).

The battle runtime requires modules beyond the battle bundles already decoded (e.g.
DataNode/DataTable/Create/constant/DTBattleDBModel, Common/cs_coroutine). This decodes the
full xlualogic tree with the same XOR-22 method (SecurityUtil.xorScale @ global-metadata
0x5829D1, 22 bytes) so the custom Lua loader can resolve any require.

Output: girlswar_merged_extracted/decoded/xlua_all/<bundle-relpath>/<id>_<Name>_security_xor_raw.lua
(The loader scans decoded/ recursively and indexes by unique leaf name.)

Read-only over original slices; writes only into decoded/xlua_all.
"""
from __future__ import annotations

import re
from pathlib import Path

import UnityPy

ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = ROOT / "girlswar_merged_extracted"
SLICES = MERGED / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "xlualogic"
META = ROOT / "il2cpp_native" / "global-metadata.dat"
XORSCALE_OFFSET = 0x5829D1
XORSCALE_SIZE = 22
OUT_ROOT = MERGED / "decoded" / "xlua_all"

SAFE = re.compile(r"[^A-Za-z0-9_.-]")


def raw_payload(payload) -> bytes:
    if payload is None:
        return b""
    if isinstance(payload, (bytes, bytearray)):
        return bytes(payload)
    if isinstance(payload, str):
        return payload.encode("utf-8", "surrogateescape")
    return str(payload).encode("utf-8", "surrogateescape")


def xor(data: bytes, key: bytes) -> bytes:
    return bytes(b ^ key[i % len(key)] for i, b in enumerate(data))


def main() -> int:
    xs = META.read_bytes()[XORSCALE_OFFSET:XORSCALE_OFFSET + XORSCALE_SIZE]
    bundles = sorted(SLICES.rglob("*.assetbundle"))
    written = 0
    bundles_ok = 0
    errors = 0
    for b in bundles:
        try:
            env = UnityPy.load(b.read_bytes())
        except Exception:
            errors += 1
            continue
        rel = b.relative_to(SLICES).with_suffix("")  # bundle subpath without .assetbundle
        out_dir = OUT_ROOT / rel
        any_here = False
        for o in env.objects:
            if o.type.name != "TextAsset":
                continue
            try:
                d = o.read()
            except Exception:
                continue
            name = getattr(d, "m_Name", None) or getattr(d, "name", "")
            payload = getattr(d, "m_Script", None)
            if payload is None:
                payload = getattr(d, "script", None)
            raw = raw_payload(payload)
            if not raw:
                continue
            # Only XOR-encrypted TextAssets carry the 'A-EV' magic; data-table TextAssets
            # were stored as plaintext Lua already. XORing plaintext would corrupt it
            # (XOR is symmetric: plaintext ^ key == the A-EV form), so pass plaintext through.
            dec = xor(raw, xs) if raw[:4] == b"A-EV" else raw
            safe_name = SAFE.sub("_", str(name)) or "unnamed"
            if not any_here:
                out_dir.mkdir(parents=True, exist_ok=True)
                any_here = True
            (out_dir / f"{o.path_id}_{safe_name}_security_xor_raw.lua").write_bytes(dec)
            written += 1
        if any_here:
            bundles_ok += 1
    print(f"bundles scanned : {len(bundles)}")
    print(f"bundles with lua: {bundles_ok}")
    print(f"lua files written: {written}")
    print(f"load errors     : {errors}")
    print(f"output root     : {OUT_ROOT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
