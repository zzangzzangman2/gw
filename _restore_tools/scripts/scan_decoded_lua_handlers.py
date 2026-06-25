from __future__ import annotations

import csv
import json
import re
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
PROJECT = BASE / "girlswar_maininterface_unity"
DECODED_DIR = MERGED / "decoded" / "xlua"
REPORT_DIR = PROJECT / "Assets" / "RestoreData" / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"

OUT_CSV = REPORT_DIR / "maininterface_decoded_lua_handlers.csv"
OUT_JSON = REPORT_DIR / "maininterface_decoded_lua_handler_summary.json"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_LUA_HANDLER_SCAN.md"

LISTENER_RE = re.compile(
    r"(?P<target>[\w\.\[\]\"']+)\.(?P<event>onClick|onValueChanged|onEndEdit)\s*:\s*AddListener\s*\((?P<handler>.*)"
)
ADD_BTN_RE = re.compile(
    r"(?P<owner>[\w\.:]*)AddBtnClickListener\s*\(\s*(?P<target>[^,\)]+)\s*,\s*(?P<handler>.*)"
)
EVENT_RE = re.compile(r"EventSystem\.AddListener\s*\(\s*(?P<event_id>[^,\)]+)\s*,\s*(?P<handler>[^,\)]+)")
ASSIGN_RE = re.compile(r"(?P<target>[\w\.\[\]\"']+)\.(?P<event>onClick)\s*=\s*(?P<handler>[\w_]+)")
TOUCH_RE = re.compile(r"UIUtil\.AddTouchEventMulti\s*\((?P<args>.*)")


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def module_from_file(path: Path) -> tuple[str, str]:
    stem = path.stem
    if stem.endswith("_security_xor_raw"):
        stem = stem[: -len("_security_xor_raw")]
    if "_" in stem:
        path_id, module = stem.split("_", 1)
    else:
        path_id, module = "", stem
    return path_id, module


def clean_handler(text: str) -> str:
    text = text.strip()
    if not text:
        return "multiline_or_empty"
    if text.startswith("function"):
        return "inline_function"
    text = text.rstrip()
    if text.endswith(")") and text.count("(") == text.count(")"):
        text = text[:-1].strip()
    elif text.endswith(")") and re.fullmatch(r"[\w_\.]+(?:\([^)]*\))?\)", text):
        text = text[:-1].strip()
    return text[:200]


def split_lua_args(text: str) -> list[str]:
    args: list[str] = []
    current: list[str] = []
    depth = 0
    quote = ""
    escape = False
    for char in text.strip().rstrip(")"):
        if quote:
            current.append(char)
            if escape:
                escape = False
            elif char == "\\":
                escape = True
            elif char == quote:
                quote = ""
            continue
        if char in {"'", '"'}:
            quote = char
            current.append(char)
            continue
        if char in "([{":
            depth += 1
        elif char in ")]}" and depth > 0:
            depth -= 1
        if char == "," and depth == 0:
            args.append("".join(current).strip())
            current = []
        else:
            current.append(char)
    if current:
        args.append("".join(current).strip())
    return args


def clean_touch_handlers(args_text: str) -> str:
    args = split_lua_args(args_text)
    handlers = [arg for arg in args[1:] if arg]
    if not handlers:
        return "multiline_or_empty"
    return "|".join(handlers)[:200]


def target_name(expr: str) -> str:
    expr = expr.strip()
    expr = expr.replace(".transform", "")
    bracket = re.search(r"\[['\"]([^'\"]+)['\"]\]", expr)
    if bracket:
        return bracket.group(1)
    if "." in expr:
        expr = expr.split(".")[-1]
    if ":" in expr:
        expr = expr.split(":")[-1]
    return expr.strip()


def main() -> None:
    if not DECODED_DIR.exists():
        raise FileNotFoundError(DECODED_DIR)

    rows: list[dict[str, Any]] = []
    for lua_path in sorted(DECODED_DIR.glob("*.lua")):
        path_id, module = module_from_file(lua_path)
        lines = lua_path.read_text(encoding="utf-8", errors="replace").splitlines()
        for idx, line in enumerate(lines, start=1):
            stripped = line.strip()
            for kind, match in [
                ("listener", LISTENER_RE.search(stripped)),
                ("add_btn_click", ADD_BTN_RE.search(stripped)),
                ("event_system", EVENT_RE.search(stripped)),
                ("event_assign", ASSIGN_RE.search(stripped)),
                ("touch_event_multi", TOUCH_RE.search(stripped)),
            ]:
                if not match:
                    continue
                groups = match.groupdict()
                if kind == "event_system":
                    target_expr = groups.get("event_id", "")
                    event = "EventSystem.AddListener"
                    handler = clean_handler(groups.get("handler", ""))
                elif kind == "touch_event_multi":
                    args = groups.get("args", "")
                    split_args = split_lua_args(args)
                    target_expr = split_args[0] if split_args else "UIUtil.AddTouchEventMulti"
                    event = "touch"
                    handler = clean_touch_handlers(args)
                else:
                    target_expr = groups.get("target", "")
                    event = groups.get("event", "button")
                    handler = clean_handler(groups.get("handler", ""))
                rows.append(
                    {
                        "module": module,
                        "path_id": path_id,
                        "file": str(lua_path),
                        "line": idx,
                        "kind": kind,
                        "target_expr": target_expr,
                        "target_name": target_name(target_expr),
                        "event": event,
                        "handler": handler,
                        "raw_line": stripped,
                    }
                )

    write_csv(
        OUT_CSV,
        rows,
        ["module", "path_id", "file", "line", "kind", "target_expr", "target_name", "event", "handler", "raw_line"],
    )

    listener_rows = [row for row in rows if row["kind"] in {"listener", "add_btn_click", "event_assign", "touch_event_multi"}]
    event_rows = [row for row in rows if row["kind"] == "event_system"]
    unique_targets = sorted({str(row["target_name"]) for row in listener_rows if row["target_name"]})
    summary = {
        "decoded_dir": str(DECODED_DIR),
        "lua_files": len(list(DECODED_DIR.glob("*.lua"))),
        "handler_rows": len(rows),
        "ui_listener_rows": len(listener_rows),
        "event_system_rows": len(event_rows),
        "unique_ui_targets": len(unique_targets),
        "outputs": {"csv": str(OUT_CSV), "json": str(OUT_JSON), "md": str(OUT_MD)},
    }
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    by_module: dict[str, int] = {}
    for row in listener_rows:
        by_module[str(row["module"])] = by_module.get(str(row["module"]), 0) + 1

    md = [
        "# MainInterface decoded Lua handler scan",
        "",
        "## Summary",
        "",
        f"- Decoded Lua files: `{summary['lua_files']}`",
        f"- Handler/event rows: `{summary['handler_rows']}`",
        f"- UI listener rows: `{summary['ui_listener_rows']}`",
        f"- EventSystem rows: `{summary['event_system_rows']}`",
        f"- Unique UI target names: `{summary['unique_ui_targets']}`",
        "",
        "## MainPage direct handlers",
        "",
        "| Target | Event | Handler | Line |",
        "|---|---|---|---:|",
    ]
    main_rows = [
        row
        for row in listener_rows
        if row["module"] == "UI_MainPage" and str(row["target_name"]).startswith(("btn", "vip", "youjian", "haoyou", "paihangbang", "funhandbook", "worldwanfa"))
    ]
    for row in main_rows[:80]:
        md.append(f"| `{row['target_name']}` | `{row['event']}` | `{row['handler']}` | {row['line']} |")

    md.extend(
        [
            "",
            "## Top Modules By UI Listener Count",
            "",
            "| Module | UI listener rows |",
            "|---|---:|",
        ]
    )
    for module, count in sorted(by_module.items(), key=lambda item: (-item[1], item[0]))[:20]:
        md.append(f"| `{module}` | {count} |")
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
