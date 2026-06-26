"""Audit offline DT*DBModel load paths for the battle Lua closure.

This is a read-only static pass over decoded Lua. It confirms whether the
DBModel modules needed by ProcedureNormalBattle can populate without a server,
and records the harness flags that keep them on the embedded-data path.
"""
from __future__ import annotations

import collections
import json
import os
import re
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
DECODED_ROOTS = [
    ROOT / "girlswar_merged_extracted" / "decoded" / "xlua_all",
    ROOT / "girlswar_merged_extracted" / "decoded" / "xlua_battle",
    ROOT / "girlswar_merged_extracted" / "decoded" / "xlua",
]
REPORT_MD = ROOT / "reports" / "battle" / "BATTLE_DATATABLE_OFFLINE_LOAD_AUDIT.md"
REPORT_JSON = ROOT / "reports" / "battle" / "BATTLE_DATATABLE_OFFLINE_LOAD_AUDIT.json"

SUFFIX = "_security_xor_raw.lua"
REQ = re.compile(r"""require[ (]["']([^"']+)["']""")
READ_JSON = re.compile(r"""GameInit\.ReadJsonData\(["']([^"']+)["']\)""")
WRITE_JSON = re.compile(r"""GameInit\.WriteFile\(["']([^"']+)["']""")
IO_HEADER = re.compile(r"""["']([^"']*EntityTableDataHeader\.bigd)["']""")
IO_DATA = re.compile(r"""["']([^"']*EntityTableData\.bigd)["']""")
ENTITY_REQ = re.compile(r"""require\(["'](DataNode/DataTable/Create/[^"']+Entity)["']\)""")


def rel(path: Path) -> str:
    return path.relative_to(ROOT).as_posix()


def leaf_from_require(name: str) -> str:
    return name.replace(".", "/").split("/")[-1]


def build_index() -> dict[str, Path]:
    index: dict[str, Path] = {}
    for root in DECODED_ROOTS:
        if not root.exists():
            continue
        for path in root.rglob(f"*{SUFFIX}"):
            filename = path.name
            if "_" not in filename:
                continue
            leaf = filename[filename.index("_") + 1 : -len(SUFFIX)]
            index.setdefault(leaf, path)
    return index


def walk_closure(entry: str, index: dict[str, Path]):
    seen: set[str] = set()
    stack = [entry]
    missing: set[str] = set()
    resolved: list[str] = []
    require_paths: dict[str, set[str]] = collections.defaultdict(set)
    dbmodel_requires: dict[str, set[str]] = collections.defaultdict(set)

    while stack:
        leaf = stack.pop()
        if leaf in seen:
            continue
        seen.add(leaf)
        path = index.get(leaf)
        if not path:
            missing.add(leaf)
            continue
        resolved.append(leaf)
        text = path.read_text(encoding="utf-8", errors="replace")
        for req in REQ.findall(text):
            req_leaf = leaf_from_require(req)
            require_paths[req_leaf].add(req)
            if "DataNode/DataTable/Create/" in req and req_leaf.endswith("DBModel"):
                dbmodel_requires[req_leaf].add(req)
            if req_leaf not in seen:
                stack.append(req_leaf)

    dbmodels = sorted(dbmodel_requires)
    return resolved, missing, require_paths, dbmodel_requires, dbmodels


def classify(text: str) -> tuple[str, str]:
    uses_server = "GameInit.ServerLoadTable" in text
    uses_client_io = "ClientIsSupportIOLoad" in text
    has_init_require = "InitRequire" in text and "Entity')" in text
    has_init_io = "InitIO" in text and "EntityTableData" in text
    has_get_list_by_io = "GetListByIO" in text

    if uses_server and uses_client_io and has_init_require and has_init_io:
        return (
            "self_populates_when_client_io_disabled",
            "Use GameInit.ServerLoadTable=false and GameTools.ClientIsSupportIOLoad()=false. "
            "That keeps GetList/GetEntity on InitRequire(), which loads embedded EntityTableData. "
            "Returning true switches to .bigd IO files; ServerLoadTable=true expects a JSON cache via GameInit.ReadJsonData.",
        )
    if has_init_require and not has_init_io:
        return (
            "inline_require_only",
            "Embedded require path only; no server or .bigd IO flag needed.",
        )
    if has_init_io and has_get_list_by_io:
        return (
            "io_file_path_requires_staged_bigd",
            "Can use local IO only if EntityTableData .bigd files are present and io.open is available.",
        )
    return (
        "manual_review",
        "Pattern differs from the standard DBModel loader; inspect before relying on it.",
    )


def analyze_dbmodel(leaf: str, path: Path | None, require_paths: set[str]) -> dict:
    if path is None:
        return {
            "module": leaf,
            "resolved": False,
            "requirePaths": sorted(require_paths),
            "classification": "missing_decoded_module",
            "recommendation": "Decode/source module is missing; battle closure cannot be proven offline.",
        }

    text = path.read_text(encoding="utf-8", errors="replace")
    classification, recommendation = classify(text)
    read_json = sorted(set(READ_JSON.findall(text)))
    write_json = sorted(set(WRITE_JSON.findall(text)))
    io_files = sorted(set(IO_HEADER.findall(text) + IO_DATA.findall(text)))
    entity_requires = sorted(set(ENTITY_REQ.findall(text)))

    return {
        "module": leaf,
        "resolved": True,
        "path": rel(path),
        "requirePaths": sorted(require_paths),
        "classification": classification,
        "recommendation": recommendation,
        "usesServerLoadTable": "GameInit.ServerLoadTable" in text,
        "usesClientIsSupportIOLoad": "ClientIsSupportIOLoad" in text,
        "hasInitRequire": "InitRequire" in text,
        "hasInitIO": "InitIO" in text,
        "hasGetListByIO": "GetListByIO" in text,
        "readJsonFiles": read_json,
        "writeJsonFiles": write_json,
        "ioFiles": io_files,
        "entityRequires": entity_requires,
    }


def write_reports(payload: dict) -> None:
    REPORT_JSON.parent.mkdir(parents=True, exist_ok=True)
    REPORT_JSON.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    rows = payload["dbModels"]
    counts = collections.Counter(row["classification"] for row in rows)
    lines = [
        "# BATTLE_DATATABLE_OFFLINE_LOAD_AUDIT",
        "",
        f"Generated: {payload['generatedAtUtc']}",
        f"Entry: `{payload['entry']}`",
        "",
        "## Result",
        "",
        f"- pass: `{str(payload['pass']).lower()}`",
        f"- closure modules resolved: `{payload['closure']['resolvedCount']}`",
        f"- closure modules missing: `{payload['closure']['missingCount']}`",
        f"- battle closure DBModels: `{len(rows)}`",
        f"- classifications: `{dict(sorted(counts.items()))}`",
        "",
        "## Harness flags",
        "",
        "- Set `GameInit.ServerLoadTable=false` for offline decoded-data loading.",
        "- Set `GameTools.ClientIsSupportIOLoad()` to `false` unless the matching `EntityTableData*.bigd` files are staged and readable.",
        "- With that flag pair, standard DBModels self-populate via `InitRequire()` from embedded decoded `*Entity` / `*EntityTableData` modules.",
        "- `GameInit.ServerLoadTable=true` is not the offline bootstrap path; it calls `GameInit.ReadJsonData(...)` and expects a prior JSON cache.",
        "",
        "## DBModels",
        "",
        "| module | class | read json | write json | io files | note |",
        "| --- | --- | --- | --- | --- | --- |",
    ]
    for row in rows:
        read_json = ", ".join(row.get("readJsonFiles") or [])
        write_json = ", ".join(row.get("writeJsonFiles") or [])
        io_files = ", ".join(row.get("ioFiles") or [])
        note = row.get("recommendation", "").replace("|", "/")
        lines.append(
            f"| `{row['module']}` | `{row['classification']}` | `{read_json}` | `{write_json}` | `{io_files}` | {note} |"
        )

    lines += [
        "",
        "## Evidence",
        "",
        "- Standard loader shape observed: `LoadList()` branches on `GameInit.ServerLoadTable`, then on `GameTools.ClientIsSupportIOLoad()==false`.",
        "- In the false branch, `GetList()` / `GetEntity()` call `InitRequire()` and populate from decoded entity table modules.",
        "- In the true branch, `InitIO()` prepares `.bigd` header/data paths and later reads via `io.open`; this is a separate staged-IO requirement.",
    ]
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    entry = "ProcedureNormalBattle"
    index = build_index()
    resolved, missing, _require_paths, dbmodel_requires, dbmodels = walk_closure(entry, index)
    rows = [
        analyze_dbmodel(leaf, index.get(leaf), dbmodel_requires.get(leaf, set()))
        for leaf in dbmodels
    ]

    payload = {
        "name": "BATTLE_DATATABLE_OFFLINE_LOAD_AUDIT",
        "generatedBy": rel(Path(__file__).resolve()),
        "generatedAtUtc": datetime.now(timezone.utc).isoformat(),
        "entry": entry,
        "workspace": str(ROOT),
        "closure": {
            "resolvedCount": len(resolved),
            "missingCount": len(missing),
            "missing": sorted(missing),
        },
        "pass": not missing and all(row.get("resolved") for row in rows),
        "recommendedHarnessFlags": {
            "GameInit.ServerLoadTable": False,
            "GameTools.ClientIsSupportIOLoad": False,
            "reason": "False selects embedded decoded EntityTableData self-population; true selects .bigd IO files.",
        },
        "dbModels": rows,
    }
    write_reports(payload)
    print(json.dumps({"pass": payload["pass"], "dbModelCount": len(rows)}, indent=2))
    return 0 if payload["pass"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
