from __future__ import annotations

import csv
import json
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
REPORT_DIR = PROJECT / "Assets" / "RestoreData" / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"

BUTTON_JOIN_CSV = REPORT_DIR / "maininterface_button_luacom_join.csv"
HANDLER_CSV = REPORT_DIR / "maininterface_decoded_lua_handlers.csv"
CANDIDATE_CSV = REPORT_DIR / "maininterface_button_handler_candidates.csv"
OUT_CSV = REPORT_DIR / "maininterface_button_lua_handler_join.csv"
OUT_JSON = REPORT_DIR / "maininterface_button_lua_handler_join_summary.json"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_BUTTON_LUA_HANDLER_JOIN.md"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def modules_from_script_paths(value: str) -> list[str]:
    modules: list[str] = []
    for item in (value or "").split(";"):
        item = item.strip().replace("\\", "/")
        if not item:
            continue
        name = Path(item).name
        if name.lower().endswith(".bytes"):
            name = name[:-6]
        if name and name not in modules:
            modules.append(name)
    return modules


def split_names(value: str) -> list[str]:
    names: list[str] = []
    for item in (value or "").replace(";", ",").split(","):
        item = item.strip()
        if item and item not in names:
            names.append(item)
    return names


def best_match(matches: list[tuple[int, str, dict[str, str]]], modules: list[str], strict_modules: list[str]) -> tuple[str, str, dict[str, str] | None]:
    if not matches:
        return "missing", "", None
    exact = [item for item in matches if item[2].get("module") in strict_modules]
    if exact:
        exact.sort(key=lambda item: (item[0], item[1], int(item[2].get("line") or 0)))
        return "module_and_target", exact[0][1], exact[0][2]
    candidate_exact = [item for item in matches if item[2].get("module") in modules]
    if candidate_exact:
        candidate_exact.sort(key=lambda item: (item[0], item[1], int(item[2].get("line") or 0)))
        return "candidate_module_and_target", candidate_exact[0][1], candidate_exact[0][2]
    matches.sort(key=lambda item: (item[0], item[1], int(item[2].get("line") or 0)))
    return "target_name_only", matches[0][1], matches[0][2]


def main() -> None:
    button_rows = read_csv(BUTTON_JOIN_CSV)
    handler_rows = read_csv(HANDLER_CSV)
    candidate_rows = read_csv(CANDIDATE_CSV) if CANDIDATE_CSV.exists() else []
    candidate_modules_by_button = {
        row.get("button_name", ""): split_names(row.get("candidate_xlua_modules", ""))
        for row in candidate_rows
    }
    ui_handlers = [
        row
        for row in handler_rows
        if row.get("kind") in {"listener", "add_btn_click", "event_assign", "touch_event_multi"}
        and row.get("target_name")
    ]

    by_target: dict[str, list[dict[str, str]]] = {}
    for row in ui_handlers:
        by_target.setdefault(row["target_name"], []).append(row)

    joined: list[dict[str, Any]] = []
    for button in button_rows:
        strict_modules = modules_from_script_paths(button.get("lua_script_paths", ""))
        modules = list(strict_modules)
        for module in candidate_modules_by_button.get(button.get("button_game_object_name", ""), []):
            if module not in modules:
                modules.append(module)

        target_candidates: list[tuple[int, str]] = []
        for priority, names in [
            (0, split_names(button.get("lua_com_names", ""))),
            (1, [button.get("button_game_object_name", "")]),
            (2, split_names(button.get("lua_group_names", ""))),
        ]:
            for name in names:
                if name and (priority, name) not in target_candidates:
                    target_candidates.append((priority, name))

        all_matches: list[tuple[int, str, dict[str, str]]] = []
        for priority, target in target_candidates:
            for match in by_target.get(target, []):
                all_matches.append((priority, target, match))

        confidence, matched_target, match = best_match(all_matches, modules, strict_modules)
        joined.append(
            {
                "button_component_path_id": button.get("button_component_path_id", ""),
                "button_game_object_id": button.get("button_game_object_id", ""),
                "button_game_object_name": button.get("button_game_object_name", ""),
                "lua_exact_match_count": button.get("lua_exact_match_count", ""),
                "lua_script_modules": ";".join(strict_modules),
                "candidate_xlua_modules": ";".join(modules),
                "lua_group_names": button.get("lua_group_names", ""),
                "lua_com_names": button.get("lua_com_names", ""),
                "candidate_targets": ";".join(target for _priority, target in target_candidates),
                "matched_target": matched_target,
                "handler_confidence": confidence,
                "handler_module": "" if not match else match.get("module", ""),
                "handler_kind": "" if not match else match.get("kind", ""),
                "handler_event": "" if not match else match.get("event", ""),
                "handler": "" if not match else match.get("handler", ""),
                "handler_line": "" if not match else match.get("line", ""),
                "handler_raw_line": "" if not match else match.get("raw_line", ""),
            }
        )

    write_csv(
        OUT_CSV,
        joined,
        [
            "button_component_path_id",
            "button_game_object_id",
            "button_game_object_name",
            "lua_exact_match_count",
            "lua_script_modules",
            "candidate_xlua_modules",
            "lua_group_names",
            "lua_com_names",
            "candidate_targets",
            "matched_target",
            "handler_confidence",
            "handler_module",
            "handler_kind",
            "handler_event",
            "handler",
            "handler_line",
            "handler_raw_line",
        ],
    )

    counts: dict[str, int] = {}
    for row in joined:
        key = str(row["handler_confidence"])
        counts[key] = counts.get(key, 0) + 1

    summary = {
        "button_rows": len(button_rows),
        "decoded_ui_handler_rows": len(ui_handlers),
        "confidence_counts": dict(sorted(counts.items())),
        "module_and_target_matches": counts.get("module_and_target", 0),
        "target_name_only_matches": counts.get("target_name_only", 0),
        "missing_matches": counts.get("missing", 0),
        "outputs": {"csv": str(OUT_CSV), "json": str(OUT_JSON), "md": str(OUT_MD)},
    }
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    high_rows = [row for row in joined if row["handler_confidence"] == "module_and_target"]
    main_rows = [row for row in high_rows if row["handler_module"] == "UI_MainPage"]

    md = [
        "# MainInterface Button to Lua Handler Join",
        "",
        "## Summary",
        "",
        f"- Button rows: `{len(button_rows)}`",
        f"- decoded UI handler rows: `{len(ui_handlers)}`",
        f"- module+target exact matches: `{summary['module_and_target_matches']}`",
        f"- target-name-only matches: `{summary['target_name_only_matches']}`",
        f"- missing matches: `{summary['missing_matches']}`",
        "",
        "## UI_MainPage Exact Matches",
        "",
        "| Button | Lua target | Handler | Lua line | Component pathID |",
        "|---|---|---|---:|---:|",
    ]
    for row in main_rows:
        md.append(
            f"| `{row['button_game_object_name']}` | `{row['matched_target']}` | `{row['handler']}` | {row['handler_line']} | `{row['button_component_path_id']}` |"
        )

    md.extend(
        [
            "",
            "## All Exact Matches",
            "",
            "| Button | Module | Lua target | Handler | Line |",
            "|---|---|---|---|---:|",
        ]
    )
    for row in high_rows:
        md.append(
            f"| `{row['button_game_object_name']}` | `{row['handler_module']}` | `{row['matched_target']}` | `{row['handler']}` | {row['handler_line']} |"
        )
    md.extend(
        [
            "",
            "## Outputs",
            "",
            f"- CSV: `{OUT_CSV}`",
            f"- JSON: `{OUT_JSON}`",
        ]
    )
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(json.dumps(summary, ensure_ascii=True, indent=2))


if __name__ == "__main__":
    main()
