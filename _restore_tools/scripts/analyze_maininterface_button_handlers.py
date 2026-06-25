from __future__ import annotations

import csv
import json
import re
from pathlib import Path


ROOT = Path(r"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted")
PROJECT = Path(r"C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity")
BASE = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = PROJECT / "Assets" / "RestoreData" / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"
OUT_CSV = REPORT_DIR / "maininterface_button_handler_candidates.csv"
OUT_LUACOM_JOIN_CSV = REPORT_DIR / "maininterface_button_luacom_join.csv"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_BUTTON_HANDLER_CANDIDATES.md"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, str]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def normalize_button(name: str) -> str:
    value = name.lower()
    for part in ["guide_", "btn_", "_btn", "button", "redpoint", "red_point", "im_", "ui_"]:
        value = value.replace(part, "_")
    value = re.sub(r"[^a-z0-9]+", "_", value).strip("_")
    value = re.sub(r"_+", "_", value)
    return value


def short_excerpt(text: str, needle: str) -> str:
    clean = text.strip().replace("\t", " ")
    if len(clean) <= 320:
        return clean
    idx = clean.lower().find(needle.lower())
    if idx < 0:
        return clean[:320]
    start = max(0, idx - 120)
    end = min(len(clean), idx + 200)
    return clean[start:end]


def iter_search_files() -> list[Path]:
    roots = [
        ROOT / "extracted" / "config_zips",
    ]
    files: list[Path] = []
    for base in roots:
        if not base.exists():
            continue
        for path in base.rglob("*"):
            if not path.is_file():
                continue
            if path.suffix.lower() not in {".txt", ".json", ".cs"}:
                continue
            # Huge il2cpp.h/script.json are less useful for button literal search and slow.
            if path.name in {"il2cpp.h", "script.json"}:
                continue
            if path.name not in {"dump.cs", "stringliteral.json"} and path.stat().st_size > 2_000_000:
                continue
            files.append(path)
    for name in ["dump.cs", "stringliteral.json"]:
        path = ROOT / "extracted" / "il2cpp_dump" / name
        if path.exists():
            files.append(path)

    textasset_root = ROOT / "extracted" / "unity" / "bundles"
    guide_name_patterns = [
        "*guide*.txt",
        "*openpaopao*.txt",
        "*mainpage*.txt",
        "*activity*.txt",
        "*act*.txt",
    ]
    seen = {path.resolve() for path in files}
    if textasset_root.exists():
        for pattern in guide_name_patterns:
            for path in textasset_root.glob(f"*/textassets/{pattern}"):
                if not path.is_file():
                    continue
                resolved = path.resolve()
                if resolved in seen:
                    continue
                if path.stat().st_size > 2_000_000:
                    continue
                files.append(path)
                seen.add(resolved)
    return files


def source_kind(path: Path) -> str:
    text = path.as_posix().lower()
    if "il2cpp_dump" in text:
        return "il2cpp"
    if "config_zips" in text:
        return "config"
    if "textassets" in text and "dtguide" in text:
        return "guide_textasset"
    if "xlualogic" in text:
        return "xlua_textasset"
    return "unity_textasset"


def scan_hits(buttons: list[str], files: list[Path]) -> dict[str, list[dict[str, str]]]:
    tokens_by_button = {name: normalize_button(name) for name in buttons}
    term_to_buttons: dict[str, set[str]] = {}
    for button, token in tokens_by_button.items():
        terms = {button.lower()}
        if len(token) >= 4:
            terms.add(f"guide_btn_{token}")
        if len(token) >= 6:
            terms.add(token)
        for term in terms:
            term_to_buttons.setdefault(term, set()).add(button)
    pattern = re.compile("|".join(re.escape(term) for term in sorted(term_to_buttons, key=len, reverse=True)), re.IGNORECASE)
    result = {name: [] for name in buttons}
    max_hits_per_button = 12

    for path in files:
        try:
            raw = path.read_text(encoding="utf-8", errors="ignore")
        except Exception:
            continue
        lower_path = path.as_posix().lower()
        # Most xLua module TextAssets are encrypted and full of random text. Skip direct scans there.
        if "b_d42e8b7494fbffa1" in lower_path:
            continue
        for line_no, line in enumerate(raw.splitlines(), start=1):
            lower_line = line.lower()
            matches = list(pattern.finditer(line))
            if not matches:
                continue
            matched: set[str] = set()
            for match in matches:
                term = match.group(0).lower()
                for button in term_to_buttons.get(term, set()):
                    token = tokens_by_button[button]
                    if term == token and not ("guide_" in lower_line or "open_mainpage" in lower_line or "on_click" in lower_line):
                        continue
                    matched.add(button)
            if not matched:
                continue
            rel = path.relative_to(ROOT).as_posix() if path.is_relative_to(ROOT) else path.as_posix()
            for button in matched:
                if len(result[button]) >= max_hits_per_button:
                    continue
                needle = button if button.lower() in lower_line else tokens_by_button[button]
                result[button].append(
                    {
                        "source_kind": source_kind(path),
                        "file": rel,
                        "line": str(line_no),
                        "excerpt": short_excerpt(line, needle),
                    }
                )
    return result


def encrypted_xlua_modules() -> list[dict[str, str]]:
    rows = read_csv(ROOT / "indexes" / "unity_textassets.csv")
    modules: list[dict[str, str]] = []
    for row in rows:
        if row.get("bundle") != "download/xlualogic/modules/maininterface.assetbundle":
            continue
        out = ROOT / row.get("output", "")
        encrypted = ""
        prefix = ""
        try:
            data = out.read_bytes()[:8]
            prefix = data.hex(" ")
            encrypted = "yes" if data.startswith(b"A-EV") or data.startswith(b"K7HT") else "unknown"
        except Exception:
            encrypted = "missing"
        modules.append(
            {
                "name": row.get("name", ""),
                "path_id": row.get("path_id", ""),
                "output": row.get("output", ""),
                "encrypted": encrypted,
                "prefix_hex": prefix,
            }
        )
    return modules


def candidate_modules_for(button: str) -> str:
    token = normalize_button(button)
    modules = ["UI_MainPage", "MainPageMgr"]
    if any(part in token for part in ["act", "huodong", "banner"]):
        modules.append("UI_MainPageActItem")
    if any(part in token for part in ["head", "qinmi", "marry", "watch", "face"]):
        modules.append("UI_MainPageFaceActItem")
    if any(part in token for part in ["line", "liaotian", "chat"]):
        modules.append("UI_Line_Show")
    if any(part in token for part in ["system", "set", "yincang"]):
        modules.append("UI_SystemSet")
    return ";".join(dict.fromkeys(modules))


def load_luacom_bindings() -> tuple[dict[str, list[dict[str, str]]], list[dict[str, str]]]:
    path = REPORT_DIR / "maininterface_lua_com_bindings.csv"
    if not path.exists():
        return {}, []
    rows = read_csv(path)
    by_component: dict[str, list[dict[str, str]]] = {}
    root_button_rows: list[dict[str, str]] = []
    for row in rows:
        if row.get("com_type") != "4":
            continue
        if row.get("com_in_main_root") != "true":
            continue
        component_id = row.get("com_obj_path_id", "")
        if not component_id:
            continue
        by_component.setdefault(component_id, []).append(row)
        root_button_rows.append(row)
    return by_component, root_button_rows


def main() -> None:
    button_rows = read_csv(REPORT_DIR / "maininterface_root_buttons.csv")
    button_instance_count = len(button_rows)
    buttons = sorted({row.get("game_object_name", "") for row in button_rows if row.get("game_object_name", "")})
    hits = scan_hits(buttons, iter_search_files())
    modules = encrypted_xlua_modules()
    luacom_by_component, root_luacom_rows = load_luacom_bindings()

    luacom_by_button: dict[str, list[dict[str, str]]] = {button: [] for button in buttons}
    luacom_join_rows: list[dict[str, str]] = []
    for row in button_rows:
        component_id = row.get("component_path_id", "")
        button_name = row.get("game_object_name", "")
        matches = luacom_by_component.get(component_id, [])
        for match in matches:
            luacom_by_button.setdefault(button_name, []).append(match)
        luacom_join_rows.append(
            {
                "button_component_path_id": component_id,
                "button_game_object_id": row.get("game_object_id", ""),
                "button_game_object_name": button_name,
                "lua_exact_match_count": str(len(matches)),
                "lua_script_paths": ";".join(sorted({item.get("lua_script_path", "") for item in matches if item.get("lua_script_path", "")})),
                "lua_group_names": ";".join(sorted({item.get("group_name", "") for item in matches if item.get("group_name", "")})),
                "lua_com_names": ";".join(sorted({item.get("com_name", "") for item in matches if item.get("com_name", "")})),
                "lua_owner_game_object_name": ";".join(sorted({item.get("owner_game_object_name", "") for item in matches if item.get("owner_game_object_name", "")})),
            }
        )

    by_button_rows: list[dict[str, str]] = []
    for button in buttons:
        button_hits = hits.get(button, [])
        luacom_matches = luacom_by_button.get(button, [])
        guide_events = sorted(
            {
                item["excerpt"]
                for item in button_hits
                if "OPEN_MAINPAGE_SUC" in item["excerpt"] or "ON_CLICK_" in item["excerpt"]
            }
        )
        by_button_rows.append(
            {
                "button_name": button,
                "normalized_token": normalize_button(button),
                "candidate_xlua_modules": candidate_modules_for(button),
                "lua_com_exact_match_count": str(len(luacom_matches)),
                "lua_script_paths": ";".join(sorted({item.get("lua_script_path", "") for item in luacom_matches if item.get("lua_script_path", "")})),
                "lua_group_names": ";".join(sorted({item.get("group_name", "") for item in luacom_matches if item.get("group_name", "")})),
                "lua_com_names": ";".join(sorted({item.get("com_name", "") for item in luacom_matches if item.get("com_name", "")})),
                "direct_hit_count": str(len(button_hits)),
                "source_kinds": ";".join(sorted({item["source_kind"] for item in button_hits})),
                "guide_or_event_evidence": " || ".join(guide_events[:3]),
                "hit_1": json.dumps(button_hits[0], ensure_ascii=False) if len(button_hits) > 0 else "",
                "hit_2": json.dumps(button_hits[1], ensure_ascii=False) if len(button_hits) > 1 else "",
                "hit_3": json.dumps(button_hits[2], ensure_ascii=False) if len(button_hits) > 2 else "",
            }
        )

    write_csv(
        OUT_CSV,
        by_button_rows,
        [
            "button_name",
            "normalized_token",
            "candidate_xlua_modules",
            "lua_com_exact_match_count",
            "lua_script_paths",
            "lua_group_names",
            "lua_com_names",
            "direct_hit_count",
            "source_kinds",
            "guide_or_event_evidence",
            "hit_1",
            "hit_2",
            "hit_3",
        ],
    )

    write_csv(
        OUT_LUACOM_JOIN_CSV,
        luacom_join_rows,
        [
            "button_component_path_id",
            "button_game_object_id",
            "button_game_object_name",
            "lua_exact_match_count",
            "lua_script_paths",
            "lua_group_names",
            "lua_com_names",
            "lua_owner_game_object_name",
        ],
    )

    module_csv = REPORT_DIR / "maininterface_xlua_modules.csv"
    write_csv(module_csv, modules, ["name", "path_id", "output", "encrypted", "prefix_hex"])

    hit_buttons = sum(1 for row in by_button_rows if int(row["direct_hit_count"]) > 0)
    event_buttons = sum(1 for row in by_button_rows if row["guide_or_event_evidence"])
    summary = {
        "root_button_instances": button_instance_count,
        "unique_button_names": len(buttons),
        "root_luacom_type4_entries": len(root_luacom_rows),
        "button_instances_with_luacom_exact_match": sum(1 for row in luacom_join_rows if int(row["lua_exact_match_count"]) > 0),
        "unique_button_names_with_luacom_exact_match": sum(1 for row in by_button_rows if int(row["lua_com_exact_match_count"]) > 0),
        "buttons_with_direct_text_hits": hit_buttons,
        "buttons_with_guide_or_event_evidence": event_buttons,
        "xlua_modules": len(modules),
        "encrypted_xlua_modules": sum(1 for row in modules if row["encrypted"] == "yes"),
        "candidate_csv": str(OUT_CSV),
        "xlua_module_csv": str(module_csv),
    }
    (REPORT_DIR / "maininterface_button_handler_summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )

    top_rows = sorted(by_button_rows, key=lambda r: int(r["direct_hit_count"]), reverse=True)[:20]
    md_lines = [
        "# MainInterface Button Handler Candidates",
        "",
        "이 문서는 복원된 `UI_MainInterface` root 버튼을 직접 텍스트/config/IL2CPP 증거와 연결한 후보 보고서다.",
        "",
        "중요: `download/xlualogic/modules/maininterface.assetbundle` TextAsset 본문은 `A-EV` prefix로 시작한다. Lua 본문이 암호화/패킹되어 있으므로 정확한 함수명은 별도 디코더나 런타임 instrumentation으로 확인해야 한다.",
        "",
        "## 요약",
        "",
        f"- Root Button 인스턴스: {summary['root_button_instances']}",
        f"- 고유 Button 이름: {summary['unique_button_names']}",
        f"- Root LuaCom Type 4 버튼 바인딩: {summary['root_luacom_type4_entries']}",
        f"- LuaCom 정확 매칭 Button 인스턴스: {summary['button_instances_with_luacom_exact_match']}",
        f"- LuaCom 정확 매칭 고유 Button 이름: {summary['unique_button_names_with_luacom_exact_match']}",
        f"- 직접 텍스트 증거가 있는 Button 이름: {summary['buttons_with_direct_text_hits']}",
        f"- 가이드/이벤트 증거가 있는 Button 이름: {summary['buttons_with_guide_or_event_evidence']}",
        f"- MainInterface XLua 모듈: {summary['xlua_modules']}",
        f"- 암호화/패킹된 XLua 모듈: {summary['encrypted_xlua_modules']}",
        "",
        "## 우선 확인할 XLua 모듈 후보",
        "",
        "- `UI_MainPage`",
        "- `MainPageMgr`",
        "- `UI_MainPageActItem`: activity/banner 계열 버튼",
        "- `UI_MainPageFaceActItem`: face/head/qinmi/marry/watch 계열 버튼",
        "- `UI_Line_Show`: chat/line 계열 버튼",
        "- `UI_SystemSet`: settings 계열 버튼",
        "",
        "## 직접 증거 샘플",
        "",
        "| Button | LuaCom | 그룹/이름 | 직접 hit | 증거 출처 | 후보 모듈 | 이벤트 증거 |",
        "|---|---:|---|---:|---|---|---|",
    ]
    for row in top_rows:
        event = row["guide_or_event_evidence"].replace("|", "\\|")[:220]
        lua_ref = "; ".join(part for part in [row["lua_group_names"], row["lua_com_names"]] if part).replace("|", "\\|")[:180]
        md_lines.append(
            f"| `{row['button_name']}` | {row['lua_com_exact_match_count']} | {lua_ref} | {row['direct_hit_count']} | {row['source_kinds']} | `{row['candidate_xlua_modules']}` | {event} |"
        )
    md_lines.extend(
        [
            "",
            "## 파일",
            "",
            f"- CSV: `{OUT_CSV}`",
            f"- Button-LuaCom join CSV: `{OUT_LUACOM_JOIN_CSV}`",
            f"- XLua 모듈 목록: `{module_csv}`",
            f"- 요약 JSON: `{REPORT_DIR / 'maininterface_button_handler_summary.json'}`",
        ]
    )
    OUT_MD.write_text("\n".join(md_lines) + "\n", encoding="utf-8")
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
