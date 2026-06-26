import csv
import json
import os
import re
from datetime import datetime
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
REPORT_DIR = ROOT / "reports" / "battle"
PREFIX = "BATTLE_53_RESTORE_OR_IMPORT_SOURCE_BACKED_XLUA_RUNTIME_AND_MODULESINIT_BOOTSTRAP_OR_ACCEPT_BLOCK"


KEYWORDS = [
    "XLua",
    "LuaEnv",
    "LuaTable",
    "LuaFunction",
    "LuaDLL",
    "xlua",
    "lua53",
    "libxlua",
    "xlua.dll",
    "luaopen",
    "LuaManager",
    "LoadUIScript",
    "MyLoader",
    "GetLuaBuff",
]


IGNORE_PARTS = {
    ".git",
    "Library",
    "Temp",
    "Logs",
    "obj",
    "Build",
    "Builds",
    ".vs",
}


def rel(path: Path) -> str:
    try:
        return str(path.relative_to(ROOT))
    except ValueError:
        return str(path)


def safe_read_text(path: Path, limit: int = 1024 * 1024) -> str:
    try:
        data = path.read_bytes()[:limit]
    except OSError:
        return ""
    for enc in ("utf-8", "utf-16", "cp949", "latin-1"):
        try:
            return data.decode(enc, errors="ignore")
        except Exception:
            continue
    return ""


def should_skip(path: Path) -> bool:
    return any(part in IGNORE_PARTS for part in path.parts)


def classify_path(path: Path) -> tuple[str, str]:
    lower = str(path).lower()
    name = path.name.lower()
    suffix = path.suffix.lower()

    if "dummydll" in lower or "il2cpp_dump" in lower:
        return (
            "source_backed_type_signature_only_not_executable",
            "IL2CPP dump/DummyDll provides original type signatures but not a runnable Unity editor xLua runtime.",
        )
    if name in {"global-metadata.dat", "gameassembly.dll", "libil2cpp.so"} or "global-metadata" in name:
        return (
            "native_player_runtime_not_editor_importable",
            "Player metadata/native runtime evidence is source-backed but cannot be imported as a managed editor xLua runtime.",
        )
    if "restore_overlay" in lower and suffix in {".so", ".dll", ".dat"}:
        return (
            "native_player_runtime_not_editor_importable",
            "Extracted player-side native artifact, not a Unity editor/package runtime.",
        )
    if suffix in {".dll", ".cs", ".asmdef"} and (
        "xlua" in lower or "luaenv" in lower or "luadll" in lower
    ):
        if "girlswar_battle_unity" in lower and "assets" in lower and "battle52" not in lower:
            return (
                "source_backed_importable_editor_runtime",
                "Potential restored Unity project editor/runtime candidate; requires isolated compile probe before use.",
            )
        return (
            "source_backed_type_signature_only_not_executable",
            "Matched xLua names outside a runnable project runtime path or only in generated evidence.",
        )
    if suffix in {".txt", ".json", ".csv", ".md", ".cs", ".h", ".lua", ".bytes"}:
        return (
            "source_backed_type_signature_only_not_executable",
            "Text/Lua/script evidence or generated report only; not executable editor runtime.",
        )
    return ("not_found", "No importable runtime classification from path alone.")


def collect_candidates() -> list[dict]:
    search_roots = [
        ROOT / "girlswar_merged_extracted",
        ROOT / "girlswar_battle_unity" / "Assets",
        ROOT / "girlswar_battle_unity" / "Packages",
        ROOT / "girlswar_battle_unity" / "ProjectSettings",
        ROOT / "reports" / "battle",
    ]
    candidates: dict[str, dict] = {}
    name_re = re.compile(
        r"(xlua|luaenv|luatable|luafunction|luadll|lua53|libxlua|xlua\.dll|luaopen|luamanager|loaduiscript|getluabuff|myloader|gameassembly|global-metadata|dummydll|libil2cpp)",
        re.I,
    )

    for root in search_roots:
        if not root.exists():
            continue
        for dirpath, dirnames, filenames in os.walk(root):
            dir_path = Path(dirpath)
            dirnames[:] = [d for d in dirnames if d not in IGNORE_PARTS]
            if should_skip(dir_path):
                continue
            for filename in filenames:
                path = dir_path / filename
                if should_skip(path):
                    continue
                if name_re.search(filename) or name_re.search(str(path)):
                    category, reason = classify_path(path)
                    candidates[str(path)] = {
                        "path": str(path),
                        "relativePath": rel(path),
                        "name": filename,
                        "size": path.stat().st_size if path.exists() else 0,
                        "matchKind": "path_or_name",
                        "matchedKeywords": ";".join(
                            sorted({kw for kw in KEYWORDS if kw.lower() in str(path).lower()})
                        ),
                        "classification": category,
                        "reason": reason,
                    }

    text_exts = {".cs", ".txt", ".json", ".csv", ".md", ".h", ".xml", ".asmdef", ".lua"}
    for root in search_roots:
        if not root.exists():
            continue
        for dirpath, dirnames, filenames in os.walk(root):
            dir_path = Path(dirpath)
            dirnames[:] = [d for d in dirnames if d not in IGNORE_PARTS]
            if should_skip(dir_path):
                continue
            for filename in filenames:
                path = dir_path / filename
                if path.suffix.lower() not in text_exts or should_skip(path):
                    continue
                text = safe_read_text(path, limit=512 * 1024)
                hits = sorted({kw for kw in KEYWORDS if kw.lower() in text.lower()})
                if not hits:
                    continue
                category, reason = classify_path(path)
                existing = candidates.get(str(path))
                if existing:
                    existing["matchKind"] = existing["matchKind"] + "+content"
                    existing["matchedKeywords"] = ";".join(
                        sorted(set(existing["matchedKeywords"].split(";")) | set(hits))
                    ).strip(";")
                else:
                    candidates[str(path)] = {
                        "path": str(path),
                        "relativePath": rel(path),
                        "name": filename,
                        "size": path.stat().st_size if path.exists() else 0,
                        "matchKind": "content",
                        "matchedKeywords": ";".join(hits),
                        "classification": category,
                        "reason": reason,
                    }

    # External option is recorded as an approval-gated non-source-backed path, not used.
    candidates["EXTERNAL_XLUA_PACKAGE_OPTION"] = {
        "path": "EXTERNAL_XLUA_PACKAGE_OPTION",
        "relativePath": "EXTERNAL_XLUA_PACKAGE_OPTION",
        "name": "xLua upstream/open-source package",
        "size": 0,
        "matchKind": "not_downloaded_not_installed",
        "matchedKeywords": "xLua;LuaEnv;LuaDLL",
        "classification": "non_source_backed_external_package_option_requires_user_approval",
        "reason": "External package would be non-source-backed for this restore and requires explicit user approval before any download/import.",
    }

    return sorted(candidates.values(), key=lambda r: (r["classification"], r["relativePath"]))


def load_json(path: Path, default):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return default


def load_csv(path: Path) -> list[dict]:
    try:
        with path.open("r", encoding="utf-8-sig", newline="") as f:
            return list(csv.DictReader(f))
    except Exception:
        return []


def write_csv(path: Path, rows: list[dict], fields: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)


def command_policy() -> dict:
    root_cmds = sorted(str(p) for p in ROOT.glob("*.cmd"))
    direct_cmds = sorted(str(p) for p in (ROOT / "_restore_tools").glob("*.cmd"))
    return {
        "rootCmdCount": len(root_cmds),
        "rootCmdFiles": root_cmds,
        "restoreToolsDirectCmdCount": len(direct_cmds),
        "restoreToolsDirectCmdFiles": direct_cmds,
    }


def main() -> int:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    b52_json = load_json(
        REPORT_DIR
        / "BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_RESULT.json",
        {},
    )
    b52_schema_rows = load_csv(
        REPORT_DIR
        / "BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_RUNTIME_DEPENDENCY_SCHEMA.csv"
    )
    b52_button_rows = load_csv(
        REPORT_DIR
        / "BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_BUTTONS.csv"
    )

    candidates = collect_candidates()
    importable = [
        row for row in candidates if row["classification"] == "source_backed_importable_editor_runtime"
    ]
    classification_counts: dict[str, int] = {}
    for row in candidates:
        classification_counts[row["classification"]] = classification_counts.get(row["classification"], 0) + 1

    schema_rows = []
    for row in b52_schema_rows:
        schema_rows.append(
            {
                "component": row.get("component", ""),
                "requiredTypeOrGlobal": row.get("requiredTypeOrGlobal", ""),
                "status": row.get("status", ""),
                "evidence": row.get("evidence", ""),
                "requiredBy": row.get("requiredBy", ""),
                "blockerIfMissing": row.get("blockerIfMissing", ""),
                "b53Disposition": "required_after_xlua_runtime_inventory",
            }
        )
    schema_rows.extend(
        [
            {
                "component": "Runtime import decision",
                "requiredTypeOrGlobal": "source-backed importable editor xLua runtime",
                "status": "not_found" if not importable else "candidate_found_requires_probe",
                "evidence": "BATTLE53 import candidates CSV",
                "requiredBy": "LuaForm/LuaUnit original lifecycle and Lua closure binding",
                "blockerIfMissing": "accepted_block_no_source_backed_xlua_runtime_available_locally",
                "b53Disposition": "do_not_import_external_package_without_user_approval",
            },
            {
                "component": "Runtime import decision",
                "requiredTypeOrGlobal": "external xLua package",
                "status": "approval_required_not_used",
                "evidence": "not downloaded or installed",
                "requiredBy": "possible future experiment only",
                "blockerIfMissing": "non_source_backed_external_package_option_requires_user_approval",
                "b53Disposition": "requires explicit user approval",
            },
        ]
    )

    result_status = (
        "source_backed_importable_editor_runtime_candidate_found_requires_isolated_probe"
        if importable
        else "accepted_block_no_source_backed_xlua_runtime_available_locally"
    )
    patch_decision = "blocked_no_patch" if not importable else "candidate_inventory_only_no_patch"

    candidates_csv = REPORT_DIR / f"{PREFIX}_IMPORT_CANDIDATES.csv"
    schema_csv = REPORT_DIR / f"{PREFIX}_BOOTSTRAP_DEPENDENCY_SCHEMA.csv"
    schema_json = REPORT_DIR / f"{PREFIX}_BOOTSTRAP_DEPENDENCY_SCHEMA.json"
    result_json = REPORT_DIR / f"{PREFIX}_RESULT.json"
    result_md = REPORT_DIR / f"{PREFIX}_RESULT.md"

    write_csv(
        candidates_csv,
        candidates,
        [
            "path",
            "relativePath",
            "name",
            "size",
            "matchKind",
            "matchedKeywords",
            "classification",
            "reason",
        ],
    )
    write_csv(
        schema_csv,
        schema_rows,
        [
            "component",
            "requiredTypeOrGlobal",
            "status",
            "evidence",
            "requiredBy",
            "blockerIfMissing",
            "b53Disposition",
        ],
    )
    schema_json.write_text(json.dumps(schema_rows, ensure_ascii=False, indent=2), encoding="utf-8")

    policy = command_policy()
    result = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "verdict": result_status,
        "visual_status": "xlua_runtime_inventory_complete_no_fake_handler_patch",
        "isFinalRestoredBattleScreen": False,
        "patchDecision": patch_decision,
        "sourceBackedImportableEditorRuntimeCount": len(importable),
        "classificationCounts": classification_counts,
        "b52Carryover": {
            "sourceBackedBridgeStillPresent": b52_json.get("sourceBackedBridgeStillPresent", {}),
            "listenerBoundCount": b52_json.get("listenerBoundCount", 0),
            "luaLifecycleExecutedCount": b52_json.get("luaLifecycleExecutedCount", 0),
            "directGraphicTargetIncludedB51Carryover": b52_json.get(
                "directGraphicTargetIncludedB51Carryover", 5
            ),
            "eventSystemTargetIncludedB51CarryoverForced": b52_json.get(
                "eventSystemTargetIncludedB51CarryoverForced", 5
            ),
            "correctedCarryover": "BATTLE52 result JSON now has bridge counts; editmode JSON remains corroborating evidence.",
        },
        "buttonRowsCarriedFromB52": b52_button_rows,
        "outputs": {
            "report": str(result_md),
            "json": str(result_json),
            "importCandidatesCsv": str(candidates_csv),
            "bootstrapDependencySchemaCsv": str(schema_csv),
            "bootstrapDependencySchemaJson": str(schema_json),
        },
        "nextBlocker": (
            "USER_DECISION_OR_SOURCE_RUNTIME_REQUIRED_FOR_XLUA_GAMEENTRY_BOOTSTRAP"
            if not importable
            else "BATTLE_54_ISOLATED_SOURCE_BACKED_XLUA_IMPORT_COMPILE_PROBE"
        ),
        "allowedNextOptions": [
            "Provide original xLua/GameEntry/LuaManager source or editor-compatible binaries from the same game/client.",
            "Explicitly approve a non-source-backed external xLua package experiment.",
            "Keep battle work blocked at source-backed runtime absence and continue non-runtime evidence tasks.",
        ],
        "notes": [
            "No fake onClick, fake UIEventListener delegate, fake gameplay handler, overlay, screenshot paste, or external package import was added.",
            "DummyDll/IL2CPP dump artifacts are source-backed signatures, not executable runtime.",
            "global-metadata.dat/player native files are source-backed runtime evidence, not editor-importable managed xLua runtime.",
        ],
        **policy,
    }
    result_json.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md_lines = [
        f"# {PREFIX} Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE53 only inventories source-backed xLua/GameEntry/LuaManager runtime candidates and does not patch gameplay.",
        "",
        "## Verdict",
        f"- status: `{result_status}`",
        "- final screen claim: `false`",
        f"- patch decision: `{patch_decision}`",
        f"- source-backed importable editor runtime candidates: `{len(importable)}`",
        "",
        "## Classification Counts",
    ]
    for key in sorted(classification_counts):
        md_lines.append(f"- `{key}`: `{classification_counts[key]}`")
    md_lines.extend(
        [
            "",
            "## Corrected BATTLE52 Carryover",
            f"- bridge counts: `{result['b52Carryover']['sourceBackedBridgeStillPresent']}`",
            f"- listener bound count: `{result['b52Carryover']['listenerBoundCount']}`",
            f"- Lua lifecycle executed count: `{result['b52Carryover']['luaLifecycleExecutedCount']}`",
            f"- BATTLE51 direct target included carryover: `{result['b52Carryover']['directGraphicTargetIncludedB51Carryover']}`",
            f"- BATTLE51 forced EventSystem target included carryover: `{result['b52Carryover']['eventSystemTargetIncludedB51CarryoverForced']}`",
            "",
            "## Import Decision",
        ]
    )
    if importable:
        md_lines.append("- At least one local candidate was classified as `source_backed_importable_editor_runtime`; it still requires isolated compile/probe before use.")
    else:
        md_lines.extend(
            [
                "- No local `source_backed_importable_editor_runtime` candidate was found.",
                "- IL2CPP dump/DummyDll evidence remains `source_backed_type_signature_only_not_executable`.",
                "- Player metadata/native runtime evidence remains `native_player_runtime_not_editor_importable`.",
                "- External xLua remains `non_source_backed_external_package_option_requires_user_approval` and was not downloaded/imported.",
            ]
        )
    md_lines.extend(
        [
            "",
            "## Outputs",
            f"- result JSON: `{result_json}`",
            f"- import candidates CSV: `{candidates_csv}`",
            f"- bootstrap dependency schema CSV: `{schema_csv}`",
            f"- bootstrap dependency schema JSON: `{schema_json}`",
            "",
            "## Command Policy",
            f"- root `.cmd` count: `{policy['rootCmdCount']}`",
            f"- `_restore_tools` direct `.cmd` count: `{policy['restoreToolsDirectCmdCount']}`",
            "",
            "## Next Blocker",
            f"- `{result['nextBlocker']}`",
        ]
    )
    result_md.write_text("\n".join(md_lines) + "\n", encoding="utf-8")

    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
