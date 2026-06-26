"""Static dependency-closure + native-surface analyzer for the battle Lua.

Walks the transitive require() graph from a Lua entry module (default
ProcedureNormalBattle) over the decoded Lua, and reports:
  - how many modules resolve / are missing,
  - the CS.* native surface (grouped), and the distinct CS.YouYou.* classes,
  - the global-table API surface for native-bound globals (LuaUtils, ...).

This turns "boot and hit one missing symbol per Unity round-trip" into a single static
work-list for the M2 stub layer. Read-only.

Run: python _restore_tools/scripts/analyze_battle_lua_closure.py [EntryModuleLeafName]
"""
from __future__ import annotations

import collections
import os
import re
import sys

ROOT = r"C:\Users\godho\Downloads\girlswar"
DECODED = [
    os.path.join(ROOT, "girlswar_merged_extracted", "decoded", "xlua_all"),
    os.path.join(ROOT, "girlswar_merged_extracted", "decoded", "xlua_battle"),
    os.path.join(ROOT, "girlswar_merged_extracted", "decoded", "xlua"),
]
SUFFIX = "_security_xor_raw.lua"
REQ = re.compile(r"""require[ (]["']([^"']+)["']""")
CS = re.compile(r"CS\.[A-Za-z_][A-Za-z0-9_.]*")
# native-bound globals whose method surface we want enumerated
GLOBALS = ["LuaUtils", "GameTools", "GameInit", "JsonUtil"]


def build_index():
    name2path = {}
    for root in DECODED:
        for dp, _, fs in os.walk(root):
            for fn in fs:
                if fn.endswith(SUFFIX):
                    nm = fn[fn.index("_") + 1: -len(SUFFIX)]
                    name2path.setdefault(nm, os.path.join(dp, fn))
    return name2path


def main() -> int:
    entry = sys.argv[1] if len(sys.argv) > 1 else "ProcedureNormalBattle"
    name2path = build_index()

    seen, stack = set(), [entry]
    missing, resolved = set(), []
    cs = collections.Counter()
    glob_calls = {g: collections.Counter() for g in GLOBALS}

    while stack:
        nm = stack.pop()
        if nm in seen:
            continue
        seen.add(nm)
        p = name2path.get(nm)
        if not p:
            missing.add(nm)
            continue
        resolved.append(nm)
        txt = open(p, encoding="utf-8", errors="replace").read()
        for m in REQ.findall(txt):
            leaf = m.replace(".", "/").split("/")[-1]
            if leaf not in seen:
                stack.append(leaf)
        for c in CS.findall(txt):
            cs[c] += 1
        for g in GLOBALS:
            for mm in re.findall(g + r"[.:]([A-Za-z0-9_]+)", txt):
                glob_calls[g][mm] += 1

    print(f"entry              : {entry}")
    print(f"modules resolved   : {len(resolved)}")
    print(f"modules MISSING    : {len(missing)} {sorted(missing)[:15]}")
    print()
    yy = sorted({".".join(c.split(".")[:3]) for c in cs if c.startswith("CS.YouYou.")})
    print(f"CS.YouYou.* classes ({len(yy)}) — the native stub list:")
    for k in yy:
        print("  ", k)
    print()
    other = collections.Counter()
    for c, n in cs.items():
        if c.startswith("CS.YouYou."):
            continue
        other[".".join(c.split(".")[:3])] += n
    print("other CS.* surface (top 15):")
    for k, v in other.most_common(15):
        print(f"  {v:5d} {k}")
    print()
    for g in GLOBALS:
        if glob_calls[g]:
            top = ", ".join(f"{k}({v})" for k, v in glob_calls[g].most_common(12))
            print(f"{g} surface: {top}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
