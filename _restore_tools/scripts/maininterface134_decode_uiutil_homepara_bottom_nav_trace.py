#!/usr/bin/env python3
from __future__ import annotations

import csv
import json
import math
import re
import struct
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Any

import UnityPy


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = ROOT / "girlswar_merged_extracted"
PROJECT = ROOT / "girlswar_maininterface_unity"
REPORT_DIR = ROOT / "reports" / "maininterface"
RESTORE_REPORT_DIR = PROJECT / "Assets" / "RestoreData" / "reports"
NATIVE_DIR = ROOT / "il2cpp_native"

PREFIX = "MAININTERFACE_134_DECODE_UIUTIL_HOMEPARA_AND_OLDROOT_BOTTOM_NAV_RUNTIME_STATE_SOURCE_TRACE_NO_PATCH"
RESULT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
RESULT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
UIUTIL_TRACE_CSV = REPORT_DIR / "MAININTERFACE_134_uiutil_homepara_source_trace.csv"
DTMODEL_PATTERN_CSV = REPORT_DIR / "MAININTERFACE_134_dtmodel_homepara_pattern.csv"
BOTTOM_NAV_CSV = REPORT_DIR / "MAININTERFACE_134_bottom_nav_source_animator_runtime_state_evidence.csv"
PATCH_MATRIX_CSV = REPORT_DIR / "MAININTERFACE_134_source_backed_patch_matrix_NO_SCENE_PATCH.csv"
DECODED_UIUTIL_LUA = REPORT_DIR / "MAININTERFACE_134_UIUtil_security_xor_raw.lua"

COMMON_BUNDLE = MERGED / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "xlualogic" / "common.assetbundle"
METADATA = NATIVE_DIR / "global-metadata.dat"
DTMODEL = MERGED / "extracted" / "unity" / "bundles" / "b_a6bf6dda1077db5c" / "textassets" / "4179655536068063362_DTmodelEntity.txt"
DTMODEL_TABLE = MERGED / "extracted" / "unity" / "bundles" / "b_a6bf6dda1077db5c" / "textassets" / "-741484770043515851_DTmodelEntityTableData.txt"
UI_MAINPAGE = MERGED / "decoded" / "xlua" / "-6351603197391775840_UI_MainPage_security_xor_raw.lua"
UI_DOCK = MERGED / "decoded" / "xlua" / "-4615102950863731052_UI_Dock_security_xor_raw.lua"
ROLE_LORD_SHOW = MERGED / "decoded" / "xlua" / "4894329040263920622_UI_RoleLordShow_security_xor_raw.lua"
UI_BGSET = MERGED / "decoded" / "xlua" / "-1733260267463332757_UI_BgSet_security_xor_raw.lua"
LUA_BINDINGS = RESTORE_REPORT_DIR / "maininterface_lua_com_bindings.csv"
UI133_HERO = REPORT_DIR / "MAININTERFACE_133_hero_bg_probe.csv"
UI133_BOTTOM = REPORT_DIR / "MAININTERFACE_133_bottom_nav_probe.csv"
UI125_ANIM_BINDINGS = REPORT_DIR / "MAININTERFACE_125_unitypy_generic_bindings.csv"
UI125_PREFAB_NODES = REPORT_DIR / "MAININTERFACE_125_prefab_node_candidates.csv"
UI125_BUTTONS = REPORT_DIR / "MAININTERFACE_125_button_handler_candidates.csv"
UI126_OPEN_STACK = REPORT_DIR / "MAININTERFACE_126_lua_open_stack_candidates.csv"
UI126_ELEMENTS = REPORT_DIR / "MAININTERFACE_126_reference_element_candidates.csv"

SECURITY_XORSCALE_OFFSET = 0x5829D1
SECURITY_XORSCALE_SIZE = 22


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str] | None = None) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if fieldnames is None:
        fieldnames = []
        for row in rows:
            for key in row:
                if key not in fieldnames:
                    fieldnames.append(key)
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def command_policy() -> dict[str, Any]:
    root_cmd = len(list(ROOT.glob("*.cmd")))
    direct = len(list((ROOT / "_restore_tools").glob("*.cmd")))
    return {
        "rootCmdCount": root_cmd,
        "restoreToolsDirectCmdCount": direct,
        "policyOk": root_cmd == 1 and direct == 0,
    }


def text_asset_raw_payload(payload: Any) -> bytes:
    if payload is None:
        return b""
    if isinstance(payload, str):
        return payload.encode("utf-8", "surrogateescape")
    if isinstance(payload, bytearray):
        return bytes(payload)
    if isinstance(payload, bytes):
        return payload
    return str(payload).encode("utf-8", "surrogateescape")


def decode_uiutil() -> tuple[bytes, bytes, list[dict[str, Any]]]:
    metadata = METADATA.read_bytes()
    xor_key = metadata[SECURITY_XORSCALE_OFFSET : SECURITY_XORSCALE_OFFSET + SECURITY_XORSCALE_SIZE]
    env = UnityPy.load(COMMON_BUNDLE.read_bytes())
    rows: list[dict[str, Any]] = []
    raw = b""
    for obj in env.objects:
        if obj.type.name != "TextAsset":
            continue
        data = obj.read()
        name = str(getattr(data, "m_Name", None) or getattr(data, "name", None) or "")
        if name != "UIUtil":
            continue
        payload = getattr(data, "script", None)
        if payload is None:
            payload = getattr(data, "m_Script", None)
        raw = text_asset_raw_payload(payload)
        decoded = bytes(b ^ xor_key[i % len(xor_key)] for i, b in enumerate(raw))
        ratio = printable_ratio(decoded[:4096])
        rows.append(
            {
                "evidence_kind": "raw_textasset_decode",
                "source": str(COMMON_BUNDLE),
                "path_id": obj.path_id,
                "asset_name": name,
                "raw_size": len(raw),
                "decoded_size": len(decoded),
                "xor_key_offset": hex(SECURITY_XORSCALE_OFFSET),
                "xor_key_hex": xor_key.hex(" "),
                "printable_ratio_first4096": f"{ratio:.3f}",
                "status": "decoded_lua_like" if decoded.startswith(b"local ") else "decoded_unexpected_prefix",
                "snippet": decoded[:160].decode("utf-8", "replace").replace("\n", "\\n"),
            }
        )
        return raw, decoded, rows
    raise RuntimeError("UIUtil TextAsset not found in common.assetbundle")


def printable_ratio(data: bytes) -> float:
    if not data:
        return 0.0
    return sum(1 for b in data if b in (9, 10, 13) or 32 <= b <= 126) / len(data)


def extract_function(lua_text: str, name: str) -> tuple[int, str]:
    pattern = f"function {name}"
    idx = lua_text.find(pattern)
    if idx < 0:
        return -1, ""
    line = lua_text[:idx].count("\n") + 1
    next_idx = lua_text.find("\nfunction ", idx + len(pattern))
    if next_idx < 0:
        next_idx = len(lua_text)
    return line, lua_text[idx:next_idx].strip()


def one_line(text: str, limit: int = 300) -> str:
    text = re.sub(r"\s+", " ", text.strip())
    return text[:limit]


def line_evidence(path: Path, patterns: list[tuple[str, str]], context: int = 0) -> list[dict[str, Any]]:
    if not path.exists():
        return []
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    rows: list[dict[str, Any]] = []
    for label, pattern in patterns:
        for idx, line in enumerate(lines, start=1):
            if pattern in line:
                if context:
                    start = max(1, idx - context)
                    end = min(len(lines), idx + context)
                    snippet = " | ".join(f"L{i}:{lines[i-1]}" for i in range(start, end + 1))
                else:
                    snippet = line
                rows.append(
                    {
                        "evidence_kind": "lua_callsite",
                        "source": str(path),
                        "line": idx,
                        "symbol": label,
                        "status": "found",
                        "snippet": snippet,
                    }
                )
    return rows


def build_uiutil_trace(decoded: bytes, decode_rows: list[dict[str, Any]]) -> tuple[list[dict[str, Any]], dict[str, Any]]:
    text = decoded.decode("utf-8", "replace")
    DECODED_UIUTIL_LUA.write_text(text, encoding="utf-8")
    rows = list(decode_rows)
    function_names = [
        "UIUtil.GetPlayerBigSpineAll",
        "UIUtil.GetHeroModelId",
        "UIUtil.GetHeroModelCfgData",
        "UIUtil.GetPaintingBg",
        "UIUtil.GetPlayerBigSpineAllHeroShow",
    ]
    function_summary: dict[str, Any] = {}
    for name in function_names:
        line, body = extract_function(text, name)
        status = "found" if body else "missing"
        rows.append(
            {
                "evidence_kind": "uiutil_function",
                "source": str(DECODED_UIUTIL_LUA),
                "line": line,
                "symbol": name,
                "status": status,
                "snippet": one_line(body, 900),
            }
        )
        function_summary[name] = {"line": line, "found": bool(body)}

    gb_line, gb_body = extract_function(text, "UIUtil.GetPlayerBigSpineAll")
    semantic_checks = [
        ("heroModelId", "local e=UIUtil.GetHeroModelId(e)"),
        ("modelEntity", "local e=r.GetEntity(e)"),
        ("spawnPaintingGroup", "GameTools:PoolGameObjectSpawn("),
        ("parent", "LuaUtils.SetParent(t,a)"),
        ("rootZeroLocalPos", "LuaUtils.SetLocalPos(t,0,0,0)"),
        ("targetChild", 'local a=t:Find("Painting_"..e.id)'),
        ("paramScale", "local t=e[i][1]"),
        ("paramX", "local s=e[i][2]"),
        ("paramY", "local n=e[i][3]"),
        ("flipXFlag", "if e[i][4]then"),
        ("applyLocalPos", "LuaUtils.SetLocalPos(a,s,n,0)"),
        ("applyLocalScale", "LuaUtils.SetLocalScale(a,t*o,t,t)"),
        ("fallbackLocalPos", "LuaUtils.SetLocalPos(a,0,0,0)"),
        ("fallbackLocalScale", "LuaUtils.SetLocalScale(a,1,1,1)"),
        ("mainSkeletonAnimation", 'i:PlayAnimation(0,e,false,t)'),
        ("resetBaseData", "UIUtil.ResetUISpineBaseData(a)"),
        ("backLayer", 't:Find("Painting_"..e.id.."_back")'),
        ("frontLayer", 't:Find("Painting_"..e.id.."_front")'),
    ]
    for symbol, needle in semantic_checks:
        status = "found" if needle in gb_body else "missing"
        rows.append(
            {
                "evidence_kind": "homepara_semantics",
                "source": str(DECODED_UIUTIL_LUA),
                "line": gb_line,
                "symbol": symbol,
                "status": status,
                "snippet": needle,
            }
        )

    rows.extend(
        line_evidence(
            UI_MAINPAGE,
            [
                ("UI_MainPage.GetPlayerBigSpineAll", "UIUtil.GetPlayerBigSpineAll("),
                ("UI_MainPage.homeParaArg", '"homePara",'),
                ("UI_MainPage.GetPaintingBg", "UIUtil.GetPaintingBg(i)"),
                ("UI_MainPage.UI_touchSpine", "LuaUtils.SetActive(UI_touchSpine.transform,true)"),
                ("UI_MainPage.heroSpinePositionSaved", "ee=UI_heroSpine.transform.position"),
            ],
            context=2,
        )
    )
    rows.extend(
        line_evidence(
            ROLE_LORD_SHOW,
            [("UI_RoleLordShow.teamParaCallsite", 'UIUtil.GetPlayerBigSpineAll(t,trans_spine,"teamPara"')],
            context=2,
        )
    )
    rows.extend(
        line_evidence(
            UI_BGSET,
            [
                ("UI_BgSet.GetHeroModelCfgData", "UIUtil.GetHeroModelCfgData"),
                ("UI_BgSet.GetBigPaintingPath", "UIUtil.GetBigPaintingPath"),
            ],
            context=1,
        )
    )
    summary = {
        "decodedUiUtil": str(DECODED_UIUTIL_LUA),
        "getPlayerBigSpineAllLine": gb_line,
        "homeParaMeaning": {
            "value1": "scale",
            "value2": "localPosition.x",
            "value3": "localPosition.y",
            "value4_optional": "x scale flip flag; when present xScale = -scale",
            "targetTransform": "spawned Painting_<modelId> child under paintingGroup root, not UI_heroSpine RectTransform itself",
            "parentTransform": "passed UI_heroSpine transform receives spawned paintingGroup root at local position 0,0,0",
        },
    }
    return rows, summary


def split_lua_top_level_items(table_text: str) -> list[str]:
    items: list[str] = []
    depth = 0
    in_str = False
    quote = ""
    escape = False
    start = None
    for i, ch in enumerate(table_text):
        if in_str:
            if escape:
                escape = False
            elif ch == "\\":
                escape = True
            elif ch == quote:
                in_str = False
            continue
        if ch in ("'", '"'):
            in_str = True
            quote = ch
            continue
        if ch == "{":
            if depth == 0:
                start = i
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0 and start is not None:
                items.append(table_text[start : i + 1])
                start = None
    return items


def extract_named_lua_table(text: str, name: str) -> str:
    marker = f"{name}={{"
    start = text.find(marker)
    if start < 0:
        return ""
    brace_start = text.find("{", start)
    if brace_start < 0:
        return ""
    depth = 0
    in_str = False
    quote = ""
    escape = False
    for idx in range(brace_start, len(text)):
        ch = text[idx]
        if in_str:
            if escape:
                escape = False
            elif ch == "\\":
                escape = True
            elif ch == quote:
                in_str = False
            continue
        if ch in ("'", '"'):
            in_str = True
            quote = ch
            continue
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                return text[brace_start + 1 : idx]
    return ""


def parse_row_fields(row: str) -> list[str]:
    inner = row.strip()
    if inner.startswith("{") and inner.endswith("}"):
        inner = inner[1:-1]
    fields: list[str] = []
    depth = 0
    in_str = False
    quote = ""
    escape = False
    start = 0
    for i, ch in enumerate(inner):
        if in_str:
            if escape:
                escape = False
            elif ch == "\\":
                escape = True
            elif ch == quote:
                in_str = False
            continue
        if ch in ("'", '"'):
            in_str = True
            quote = ch
            continue
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
        elif ch == "," and depth == 0:
            fields.append(inner[start:i].strip())
            start = i + 1
    fields.append(inner[start:].strip())
    return fields


def parse_numeric_array(value: str) -> list[float]:
    value = value.strip()
    if not (value.startswith("{") and value.endswith("}")):
        return []
    return [float(x) for x in re.findall(r"-?\d+(?:\.\d+)?", value)]


def clean_lua_string(value: str) -> str:
    value = value.strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in ("'", '"'):
        return value[1:-1]
    return value


def build_dtmodel_pattern() -> tuple[list[dict[str, Any]], dict[str, Any]]:
    if not DTMODEL_TABLE.exists():
        # Fallback: find it by name if the bundle hash changes.
        candidates = list((MERGED / "extracted" / "unity" / "bundles").glob("**/*DTmodelEntityTableData.txt"))
        if not candidates:
            return [], {"status": "missing_dtmodel_table"}
        table_path = candidates[0]
    else:
        table_path = DTMODEL_TABLE
    text = table_path.read_text(encoding="utf-8", errors="replace")
    byidx_body = extract_named_lua_table(text, "ByIdx")
    if not byidx_body:
        first_brace = text.find("{")
        last_brace = text.rfind("}")
        byidx_body = text[first_brace + 1 : last_brace] if first_brace >= 0 and last_brace > first_brace else ""
    rows = split_lua_top_level_items(byidx_body)
    out: list[dict[str, Any]] = []
    home_counter: Counter[str] = Counter()
    team_counter: Counter[str] = Counter()
    non_default = 0
    examples_needed = {1001, 1005, 1016, 1022, 1036}
    for row_text in rows:
        fields = parse_row_fields(row_text)
        if len(fields) < 36:
            continue
        try:
            model_id = int(float(fields[0]))
        except ValueError:
            continue
        home = parse_numeric_array(fields[9])
        team = parse_numeric_array(fields[10])
        awake = parse_numeric_array(fields[11]) if len(fields) > 11 else []
        soul = parse_numeric_array(fields[12]) if len(fields) > 12 else []
        painting_bg = clean_lua_string(fields[35]) if len(fields) > 35 else ""
        home_key = json.dumps(home, separators=(",", ":"))
        team_key = json.dumps(team, separators=(",", ":"))
        home_counter[home_key] += 1
        team_counter[team_key] += 1
        if home != [1.0, 0.0, 0.0]:
            non_default += 1
        include = model_id in examples_needed or home != [1.0, 0.0, 0.0] or len(home) >= 4
        if include:
            out.append(
                {
                    "model_id": model_id,
                    "homePara": json.dumps(home, ensure_ascii=False),
                    "home_scale": home[0] if len(home) > 0 else "",
                    "home_x": home[1] if len(home) > 1 else "",
                    "home_y": home[2] if len(home) > 2 else "",
                    "home_flip_flag": home[3] if len(home) > 3 else "",
                    "teamPara": json.dumps(team, ensure_ascii=False),
                    "awakePara": json.dumps(awake, ensure_ascii=False),
                    "soulPara": json.dumps(soul, ensure_ascii=False),
                    "paintingBg": painting_bg,
                    "interpretation": "homePara[1]=scale; [2]=local x; [3]=local y; [4] optional horizontal flip, per decoded UIUtil.GetPlayerBigSpineAll",
                    "source": str(table_path),
                }
            )
    summary = {
        "source": str(table_path),
        "parsedRows": len(rows),
        "sampleRowsWritten": len(out),
        "nonDefaultHomeParaRows": non_default,
        "topHomeParaPatterns": home_counter.most_common(12),
        "topTeamParaPatterns": team_counter.most_common(8),
    }
    out.sort(key=lambda r: (r["model_id"] != 1005, r["model_id"]))
    return out, summary


def snippet_lines(path: Path, start: int, end: int) -> str:
    if not path.exists():
        return ""
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    out = []
    for idx in range(start, min(end, len(lines)) + 1):
        out.append(f"L{idx}:{lines[idx-1]}")
    return " | ".join(out)


def binding_rows_for_bottom() -> list[dict[str, Any]]:
    rows = read_csv(LUA_BINDINGS)
    out = []
    tokens = [
        "btnToggle",
        "toogles",
        "btn_shangdian",
        "btn_youjian",
        "btn_haoyou",
        "btn_paihangbang",
        "btn_download",
        "llv_activity_pageview",
    ]
    for r in rows:
        hay = " ".join(r.values())
        if not any(t in hay for t in tokens):
            continue
        prefab = r.get("owner_game_object_name", "")
        if prefab not in {"UI_MainInterface", "UI_MainInterface_old"}:
            continue
        out.append(
            {
                "evidence_kind": "lua_component_binding",
                "source": str(LUA_BINDINGS),
                "prefab_root": prefab,
                "owner_in_main_root": r.get("owner_in_main_root", ""),
                "group": r.get("group_name", ""),
                "name": r.get("com_name", ""),
                "path_or_symbol": f"{r.get('group_name','')}/{r.get('com_name','')}",
                "active_or_state": r.get("com_in_main_root", ""),
                "line": "",
                "snippet": f"componentType={r.get('com_type','')}; object={r.get('com_game_object_name','')}; pathId={r.get('com_obj_path_id','')}; lua={r.get('lua_script_path','')}",
                "decision": "binding_only_no_patch",
            }
        )
    return out


def build_bottom_nav_evidence() -> tuple[list[dict[str, Any]], dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    # UI_MainPage bottom/right controls.
    mainpage_patterns = [
        ("init_bag_world_pos", 104, 104, "btnToggle2 world position saved for Bag"),
        ("review_hides_toggle3_only", 115, 126, "review branch hides right/node_bottom/toogles/toggle3; normal branch has no hide here"),
        ("right_button_listeners", 180, 203, "btn_shangdian, worldwanfaBtn, btnToggle1..7 click listeners and static labels"),
        ("login_layout_group_enable", 460, 488, "SetToggleLayoutGroupView2 enables HorizontalLayoutGroup, ContentSizeFitter, node_act_btn GridLayoutGroup"),
        ("shop_function_visibility", 1128, 1138, "btn_shangdian visibility depends on review/committee and GameFunctionType.shop"),
        ("redpoint_bottom_toggles", 1809, 1814, "bottom toggle redpoint/runtime state begins here"),
        ("hide_show_maininterface_animator", 2685, 2695, "UI_MainInterface out/in animator plays for hide/show"),
        ("btnToggle_jump_handlers", 2896, 2918, "btnToggle handlers jump/open other UI"),
    ]
    for symbol, start, end, decision in mainpage_patterns:
        rows.append(
            {
                "evidence_kind": "decoded_lua",
                "source": str(UI_MAINPAGE),
                "prefab_root": "UI_MainInterface",
                "owner_in_main_root": "",
                "group": "UI_MainPage",
                "name": symbol,
                "path_or_symbol": symbol,
                "active_or_state": "runtime_logic",
                "line": f"{start}-{end}",
                "snippet": snippet_lines(UI_MAINPAGE, start, end),
                "decision": decision,
            }
        )
    # UI_Dock is likely a separate open-stack bottom nav.
    dock_patterns = [
        ("dock_type_mapping", 7, 15, "UI_Dock owns main/camp/bag/expedition/adventure/guild/city bottom dock state"),
        ("dock_onopen_default_main_page", 44, 80, "UI_Dock OnOpen defaults tabIndex to DOCK_TYPE.MAIN_PAGE and activates transform unless story-guide exception"),
        ("dock_hide_show_stack", 328, 341, "OnHideDockAndCurrUI hides/shows UI_Dock with current UI stack"),
        ("dock_animator_hide_show", 575, 580, "OnDockShowHide plays UI_Dock_out/UI_Dock_in"),
        ("dock_gray_state", 640, 658, "UI_Dock grays dock spines/redpoints but not evidence for hiding bottom dock"),
    ]
    for symbol, start, end, decision in dock_patterns:
        rows.append(
            {
                "evidence_kind": "decoded_lua",
                "source": str(UI_DOCK),
                "prefab_root": "UI_Dock",
                "owner_in_main_root": "",
                "group": "UI_Dock",
                "name": symbol,
                "path_or_symbol": symbol,
                "active_or_state": "runtime_open_stack_candidate",
                "line": f"{start}-{end}",
                "snippet": snippet_lines(UI_DOCK, start, end),
                "decision": decision,
            }
        )
    rows.extend(binding_rows_for_bottom())

    # UI133 probe rows: what is actually visible in current old-root candidate.
    for r in read_csv(UI133_BOTTOM):
        rows.append(
            {
                "evidence_kind": "ui133_candidate_probe",
                "source": str(UI133_BOTTOM),
                "prefab_root": "UI126_oldroot_candidate",
                "owner_in_main_root": "",
                "group": "probe_visible_or_bottom_region",
                "name": r.get("name", ""),
                "path_or_symbol": r.get("path", ""),
                "active_or_state": f"active={r.get('active_in_hierarchy','')}; button={r.get('has_button','')}; interactable={r.get('button_interactable','')}; raycast={r.get('graphic_raycast_target','')}",
                "line": "",
                "snippet": f"sprite={r.get('image_sprite','')}; text={r.get('text_sample','')}; screen={r.get('screen_rect','')}; decision={r.get('source_backed_decision','')}",
                "decision": "probe_only_no_patch",
            }
        )

    # Prefab candidates already extracted in UI125/126.
    for path, kind in [(UI125_PREFAB_NODES, "ui125_prefab_node"), (UI125_BUTTONS, "ui125_button_handler"), (UI126_ELEMENTS, "ui126_reference_element")]:
        for r in read_csv(path):
            hay = " ".join(r.values())
            if any(token in hay for token in ["node_bottom", "btnToggle", "toogles", "btn_shangdian", "btn_youjian", "btn_haoyou", "btn_paihangbang", "btn_download", "sp_mainpage"]):
                rows.append(
                    {
                        "evidence_kind": kind,
                        "source": str(path),
                        "prefab_root": r.get("prefabRoot", r.get("prefab_root", r.get("root", ""))),
                        "owner_in_main_root": "",
                        "group": r.get("region", r.get("module", "")),
                        "name": r.get("name", r.get("button", r.get("item", ""))),
                        "path_or_symbol": r.get("path", r.get("handler", "")),
                        "active_or_state": r.get("active", r.get("isActive", "")),
                        "line": r.get("line", ""),
                        "snippet": one_line(json.dumps(r, ensure_ascii=False), 500),
                        "decision": "prefab_or_handler_evidence_no_patch",
                    }
                )

    # Animator binding rows known from UI125: only generic paths resolved, no node_bottom.
    anim_rows = read_csv(UI125_ANIM_BINDINGS)
    node_bottom_hits = 0
    for r in anim_rows:
        hay = " ".join(r.values())
        if any(token in hay for token in ["node_bottom", "toogles", "btnToggle"]):
            node_bottom_hits += 1
    rows.append(
        {
            "evidence_kind": "animator_binding_summary",
            "source": str(UI125_ANIM_BINDINGS),
            "prefab_root": "UI_MainInterface",
            "owner_in_main_root": "",
            "group": "Animator:UI_MainInterface",
            "name": "node_bottom_binding_hits",
            "path_or_symbol": "node_bottom/toogles/btnToggle*",
            "active_or_state": str(node_bottom_hits),
            "line": "",
            "snippet": "UI125 generic binding resolution found bg_dibu,left,mask,mask arrows,right; no resolved node_bottom/toogles/btnToggle-specific binding rows.",
            "decision": "no_animator_static_patch_from_current_binding_evidence",
        }
    )

    counts = Counter(r["evidence_kind"] for r in rows)
    summary = {
        "rows": len(rows),
        "counts": dict(counts),
        "uiDockOpenStackCandidate": True,
        "mainInterfaceNodeBottomStaticEvidence": True,
        "oldRootBottomStripStaticPatchAllowedNow": False,
        "reason": "UI_MainInterface node_bottom exists as source prefab evidence, but current old-root candidate lacks that active strip; UI_Dock appears to be a separate open-stack dock UI and needs candidate scene/open-stack validation before a patch.",
    }
    return rows, summary


def build_patch_matrix(uiutil_summary: dict[str, Any], bottom_summary: dict[str, Any]) -> list[dict[str, Any]]:
    return [
        {
            "item": "Hero1005 homePara transform",
            "classification": "source_backed_static_patch_possible_next_task",
            "sourceEvidence": "Decoded UIUtil.GetPlayerBigSpineAll from common.assetbundle shows e[i][1]=scale, [2]=x, [3]=y, optional [4]=flip, applied to spawned Painting_<id> child.",
            "patchPlanOnly": "Apply homePara to the SkeletonGraphic/Painting child transform, not UI_heroSpine parent; for 1005 [1,0,0] means scale 1, local x 0, local y 0, no flip.",
            "whyNoPatchInUI134": "Task explicitly requested source trace no patch; visual/click validation should be separate.",
            "guardrail": "no coordinate-only patch; this is semantic transform evidence, but still needs candidate capture in next task",
        },
        {
            "item": "Hero1005 back/front layers",
            "classification": "needs_unity_runtime_probe",
            "sourceEvidence": "Decoded UIUtil checks Painting_<id>_back and Painting_<id>_front and plays them if present; UI124 mounted main only.",
            "patchPlanOnly": "Probe whether adding back/front SkeletonGraphics improves reference without overpainting; no whole atlas image.",
            "whyNoPatchInUI134": "Layer ordering and material/canvas interaction still needs a candidate capture task.",
            "guardrail": "whole atlas/screenshot paste forbidden",
        },
        {
            "item": "Old-root bottom navigation strip",
            "classification": "blocked_no_patch_needs_open_stack_candidate",
            "sourceEvidence": "UI_MainInterface has node_bottom/toogles/btnToggle* static prefab and UI_MainPage listeners, but current old-root candidate shows shop/mail/friends/ranking/left banner instead; UI_Dock decoded Lua is a separate bottom dock open-stack candidate.",
            "patchPlanOnly": "Build a no-fake UI_Dock open-stack candidate alongside old-root UI_MainInterface and validate against reference bottom strip.",
            "whyNoPatchInUI134": "No source-backed proof that old-root UI_MainInterface alone should import/activate new-root node_bottom, and no UI_Dock candidate capture yet.",
            "guardrail": "no coordinate-only bottom nav alignment; no activity slot hide",
        },
        {
            "item": "btn_discord/UI_bg/activity slots",
            "classification": "source_backed_static_patch_not_allowed_by_guardrail",
            "sourceEvidence": "UI128/UI129/UI130 guardrails remain; review hide only for btn_discord, no UI_bg raycast-off source, activity slots need snapshot.",
            "patchPlanOnly": "None.",
            "whyNoPatchInUI134": "Out of UI134 target and explicitly forbidden.",
            "guardrail": "btn_discord review hide, UI_bg raycast-off, node_act_btn/btn_act_* hide forbidden",
        },
    ]


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    raw, decoded, decode_rows = decode_uiutil()
    uiutil_rows, uiutil_summary = build_uiutil_trace(decoded, decode_rows)
    dt_rows, dt_summary = build_dtmodel_pattern()
    bottom_rows, bottom_summary = build_bottom_nav_evidence()
    patch_matrix = build_patch_matrix(uiutil_summary, bottom_summary)

    write_csv(UIUTIL_TRACE_CSV, uiutil_rows)
    write_csv(DTMODEL_PATTERN_CSV, dt_rows)
    write_csv(BOTTOM_NAV_CSV, bottom_rows)
    write_csv(PATCH_MATRIX_CSV, patch_matrix)

    result = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "task": PREFIX,
        "restoredClaim": False,
        "scenePatchApplied": False,
        "candidatePatchApplied": False,
        "uiutil": uiutil_summary,
        "dtmodel": dt_summary,
        "bottomNav": bottom_summary,
        "patchDecision": "no_scene_patch_source_trace_only",
        "patchMatrixCsv": str(PATCH_MATRIX_CSV),
        "outputs": {
            "resultMd": str(RESULT_MD),
            "resultJson": str(RESULT_JSON),
            "uiutilTraceCsv": str(UIUTIL_TRACE_CSV),
            "dtmodelPatternCsv": str(DTMODEL_PATTERN_CSV),
            "bottomNavEvidenceCsv": str(BOTTOM_NAV_CSV),
            "decodedUiUtilLua": str(DECODED_UIUTIL_LUA),
        },
        "commandPolicy": command_policy(),
        "changedFiles": [
            str(ROOT / "_restore_tools" / "scripts" / "maininterface134_decode_uiutil_homepara_bottom_nav_trace.py"),
            str(DECODED_UIUTIL_LUA),
            str(UIUTIL_TRACE_CSV),
            str(DTMODEL_PATTERN_CSV),
            str(BOTTOM_NAV_CSV),
            str(PATCH_MATRIX_CSV),
            str(RESULT_JSON),
            str(RESULT_MD),
        ],
    }
    RESULT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# MAININTERFACE 134 Decode UIUtil HomePara And OldRoot Bottom Nav Runtime State Source Trace Result",
        "",
        f"Generated: {result['generatedAt']}",
        "",
        "## Verdict",
        "",
        "- restoredClaim: false",
        "- scenePatchApplied: false",
        "- candidatePatchApplied: false",
        "- patchDecision: no_scene_patch_source_trace_only",
        "",
        "## UIUtil/HomePara",
        "",
        f"- Decoded UIUtil source: `{DECODED_UIUTIL_LUA}`",
        f"- `UIUtil.GetPlayerBigSpineAll` line: `{uiutil_summary['getPlayerBigSpineAllLine']}`",
        "- `homePara[1]`: scale",
        "- `homePara[2]`: spawned `Painting_<id>` local x",
        "- `homePara[3]`: spawned `Painting_<id>` local y",
        "- optional `homePara[4]`: horizontal flip flag; when present x scale becomes negative",
        "- Target transform: spawned `Painting_<id>` child under the pooled `paintingGroup`, not `UI_heroSpine` itself.",
        "- For hero1005, `[1,0,0]` means scale `1`, x `0`, y `0`, no flip. This is now source-backed, but UI134 still applies no patch by request.",
        "",
        "## DTmodelEntity Pattern",
        "",
        f"- Parsed rows: `{dt_summary.get('parsedRows')}`",
        f"- Sample rows written: `{dt_summary.get('sampleRowsWritten')}`",
        f"- Non-default homePara rows: `{dt_summary.get('nonDefaultHomeParaRows')}`",
        f"- Top homePara patterns: `{json.dumps(dt_summary.get('topHomeParaPatterns'), ensure_ascii=False)}`",
        "",
        "## Bottom Nav/Open Stack",
        "",
        "- `UI_MainInterface` has source prefab/binding evidence for `node_bottom/toogles/btnToggle*` and `UI_MainPage` registers `btnToggle1..7` click handlers.",
        "- Current UI133 old-root candidate does not expose that new-root bottom strip; it shows old-root shop/mail/friends/ranking/left banner/download candidates instead.",
        "- `UI_Dock` is a stronger open-stack candidate for the actual bottom dock: it maps `DOCK_TYPE.MAIN_PAGE..MAIN_CITY`, defaults to `MAIN_PAGE`, and plays `UI_Dock_in/out` on show/hide.",
        "- UI134 therefore does not import/activate `node_bottom` into old-root and does not patch coordinates. Next safe step is a separate UI_Dock open-stack candidate capture.",
        "",
        "## Patch Matrix",
        "",
        "| item | classification | patchPlanOnly | whyNoPatchInUI134 |",
        "| --- | --- | --- | --- |",
    ]
    for row in patch_matrix:
        md.append(
            f"| {row['item']} | {row['classification']} | {row['patchPlanOnly']} | {row['whyNoPatchInUI134']} |"
        )
    md += [
        "",
        "## Outputs",
        "",
        f"- JSON: `{RESULT_JSON}`",
        f"- UIUtil/homePara trace CSV: `{UIUTIL_TRACE_CSV}`",
        f"- DTmodel homePara pattern CSV: `{DTMODEL_PATTERN_CSV}`",
        f"- Bottom nav evidence CSV: `{BOTTOM_NAV_CSV}`",
        f"- Patch matrix CSV: `{PATCH_MATRIX_CSV}`",
        f"- Decoded UIUtil Lua: `{DECODED_UIUTIL_LUA}`",
        "",
        "## Command Policy",
        "",
        f"- root `.cmd` count: {result['commandPolicy']['rootCmdCount']}",
        f"- `_restore_tools` direct `.cmd` count: {result['commandPolicy']['restoreToolsDirectCmdCount']}",
        f"- policyOk: {str(result['commandPolicy']['policyOk']).lower()}",
        "",
        "## Next Blocker",
        "",
        "- Build a separate UI_Dock open-stack candidate with source prefab/lua evidence and capture/diff/click validation.",
        "- Apply the now-decoded homePara semantics only in a dedicated candidate patch/capture task; do not combine with bottom nav changes.",
        "- Activity/account snapshot remains required before activity slot/text/icon/spine visibility changes.",
    ]
    RESULT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
