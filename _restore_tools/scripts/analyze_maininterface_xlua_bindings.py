from __future__ import annotations

import csv
import gzip
import json
import re
from collections import Counter
from pathlib import Path
from typing import Any


ROOT = Path(r"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted")
PROJECT = Path(r"C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity")
GIRLSWAR = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = PROJECT / "Assets" / "RestoreData" / "reports"
REPORT_MD_DIR = GIRLSWAR / "reports" / "maininterface"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_XLUA_LOADER_ANALYSIS.md"

UI_BUNDLE = "download/ui/uiprefabandres/maininterface.assetbundle"
XLUA_BUNDLE = "download/xlualogic/modules/maininterface.assetbundle"
MAININTERFACE_ROOT_RECT = "5568884429252053541"

LUA_BINDING_SCRIPT_ID = "8347263561838679580"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow({key: row.get(key, "") for key in fieldnames})


def export_dir_for(bundle: str) -> Path:
    for row in read_csv(ROOT / "indexes" / "unity_bundle_export_map.csv"):
        if row.get("bundle") == bundle:
            return ROOT / row["export_dir"]
    raise RuntimeError(f"bundle not found in unity_bundle_export_map.csv: {bundle}")


def iter_structure(export_dir: Path) -> list[dict[str, Any]]:
    result: list[dict[str, Any]] = []
    with gzip.open(export_dir / "structure.jsonl.gz", "rt", encoding="utf-8", errors="ignore") as f:
        for line in f:
            if line.strip():
                result.append(json.loads(line))
    return result


def ref_path_id(value: Any) -> str:
    if isinstance(value, dict):
        return str(value.get("m_PathID", ""))
    return ""


def build_root_maps(records: list[dict[str, Any]]) -> tuple[set[str], dict[str, str], dict[str, str], dict[str, str]]:
    rect_children: dict[str, list[str]] = {}
    rect_to_go: dict[str, str] = {}
    go_to_name: dict[str, str] = {}
    component_to_go: dict[str, str] = {}

    for rec in records:
        path_id = str(rec.get("path_id", ""))
        typ = rec.get("type", "")
        tree = rec.get("tree") or {}
        if typ == "RectTransform":
            rect_to_go[path_id] = ref_path_id(tree.get("m_GameObject"))
            rect_children[path_id] = [ref_path_id(item) for item in tree.get("m_Children", []) if ref_path_id(item)]
        elif typ == "GameObject":
            go_to_name[path_id] = tree.get("m_Name", "")
        elif typ == "MonoBehaviour":
            component_to_go[path_id] = ref_path_id(tree.get("m_GameObject"))

    descendants: set[str] = set()
    stack = [MAININTERFACE_ROOT_RECT]
    while stack:
        rect_id = stack.pop()
        if rect_id in descendants:
            continue
        descendants.add(rect_id)
        stack.extend(rect_children.get(rect_id, []))

    root_game_objects = {rect_to_go[rect_id] for rect_id in descendants if rect_to_go.get(rect_id)}
    return root_game_objects, go_to_name, component_to_go, rect_to_go


def analyze_lua_bindings(records: list[dict[str, Any]]) -> tuple[list[dict[str, Any]], list[dict[str, Any]], dict[str, Any]]:
    root_gos, go_to_name, component_to_go, _ = build_root_maps(records)

    bindings: list[dict[str, Any]] = []
    com_rows: list[dict[str, Any]] = []
    com_type_counts = Counter()
    root_com_count = 0
    root_button_com_count = 0

    for rec in records:
        if rec.get("type") != "MonoBehaviour":
            continue
        tree = rec.get("tree") or {}
        script_id = ref_path_id(tree.get("m_Script"))
        if script_id != LUA_BINDING_SCRIPT_ID:
            continue

        path_id = str(rec.get("path_id", ""))
        owner_go = ref_path_id(tree.get("m_GameObject"))
        groups = tree.get("m_LuaComGroups", []) or []
        lua_com_count = 0
        type_counter = Counter()
        root_bound = owner_go in root_gos

        for group in groups:
            group_name = group.get("Name", "")
            for com in group.get("LuaComs", []) or []:
                lua_com_count += 1
                typ = str(com.get("Type", ""))
                type_counter[typ] += 1
                com_type_counts[typ] += 1
                com_obj = ref_path_id(com.get("ComObj"))
                com_go = component_to_go.get(com_obj, com_obj)
                com_in_root = com_go in root_gos
                if com_in_root:
                    root_com_count += 1
                if typ == "4" and com_in_root:
                    root_button_com_count += 1
                com_rows.append(
                    {
                        "lua_component_path_id": path_id,
                        "owner_game_object_id": owner_go,
                        "owner_game_object_name": go_to_name.get(owner_go, ""),
                        "owner_in_main_root": str(root_bound).lower(),
                        "lua_script_path": tree.get("LuaScriptPath", ""),
                        "lua_script_path_id": ref_path_id(tree.get("luaScript")),
                        "group_name": group_name,
                        "com_name": com.get("Name", ""),
                        "com_type": typ,
                        "com_obj_path_id": com_obj,
                        "com_game_object_id": com_go,
                        "com_game_object_name": go_to_name.get(com_go, ""),
                        "com_in_main_root": str(com_in_root).lower(),
                    }
                )

        bindings.append(
            {
                "lua_component_path_id": path_id,
                "owner_game_object_id": owner_go,
                "owner_game_object_name": go_to_name.get(owner_go, ""),
                "owner_in_main_root": str(root_bound).lower(),
                "script_id": script_id,
                "lua_script_path": tree.get("LuaScriptPath", ""),
                "lua_script_path_id": ref_path_id(tree.get("luaScript")),
                "group_count": len(groups),
                "lua_com_count": lua_com_count,
                "button_type4_count": type_counter.get("4", 0),
                "type_counts": json.dumps(dict(sorted(type_counter.items())), ensure_ascii=False),
            }
        )

    summary = {
        "lua_binding_script_id": LUA_BINDING_SCRIPT_ID,
        "lua_binding_components": len(bindings),
        "lua_bindings_in_main_root": sum(1 for row in bindings if row["owner_in_main_root"] == "true"),
        "lua_com_entries": len(com_rows),
        "lua_com_entries_in_main_root": root_com_count,
        "root_button_type4_lua_com_entries": root_button_com_count,
        "lua_com_type_counts": dict(sorted(com_type_counts.items())),
    }
    return bindings, com_rows, summary


def analyze_xlua_assets() -> tuple[list[dict[str, Any]], dict[str, Any]]:
    textasset_rows = read_csv(ROOT / "indexes" / "unity_textassets.csv")
    rows: list[dict[str, Any]] = []
    prefix_counts = Counter()
    encrypted_like = 0

    for row in textasset_rows:
        if row.get("bundle") != XLUA_BUNDLE:
            continue
        output = ROOT / row.get("output", "")
        data = output.read_bytes() if output.exists() else b""
        prefix4 = data[:4].decode("latin1", errors="replace")
        prefix_hex = data[:16].hex(" ")
        ascii_ratio = 0.0
        if data:
            ascii_ratio = sum(1 for b in data[:512] if b in (9, 10, 13) or 32 <= b <= 126) / min(len(data), 512)
        is_encrypted_like = prefix4 in {"A-EV", "K7HT"} or ascii_ratio < 0.85
        encrypted_like += int(is_encrypted_like)
        prefix_counts[prefix4] += 1
        rows.append(
            {
                "name": row.get("name", ""),
                "path_id": row.get("path_id", ""),
                "output": row.get("output", ""),
                "size": len(data),
                "prefix4": prefix4,
                "prefix16_hex": prefix_hex,
                "ascii_ratio_first512": f"{ascii_ratio:.3f}",
                "encrypted_or_packed_like": str(is_encrypted_like).lower(),
            }
        )

    summary = {
        "xlua_textassets": len(rows),
        "encrypted_or_packed_like": encrypted_like,
        "prefix_counts": dict(sorted(prefix_counts.items())),
    }
    return rows, summary


def loader_string_hits() -> list[dict[str, str]]:
    path = ROOT / "extracted" / "il2cpp_dump" / "stringliteral.json"
    data = json.loads(path.read_text(encoding="utf-8"))
    terms = [
        "LuaManager.GetLuaBuff",
        "loading lua assetbundle exception",
        "LoadUIScript",
        "OnCsEventCall",
        "SoketKey",
        "DecryptByteArray",
        "DecryptGetString",
        "require 'Init/Login'",
        "download/xlualogic",
    ]
    rows: list[dict[str, str]] = []
    for item in data:
        value = item.get("value", "")
        for term in terms:
            if term.lower() in value.lower():
                rows.append(
                    {
                        "term": term,
                        "stringliteral_index": str(item.get("index", "")),
                        "value": value.replace("\n", "\\n")[:500],
                    }
                )
                break
    return rows


def method_evidence() -> list[dict[str, str]]:
    dump = (ROOT / "extracted" / "il2cpp_dump" / "dump.cs").read_text(encoding="utf-8", errors="ignore").splitlines()
    class_patterns = {
        "XXTEAUtil": re.compile(r"^public static class XXTEAUtil\b"),
        "LuaManager": re.compile(r"^public class LuaManager : ManagerBase\b"),
        "LuaForm": re.compile(r"^public class LuaForm : UIFormBase\b"),
        "LuaPage": re.compile(r"^public class LuaPage : MonoBehaviour\b"),
        "LuaUnit": re.compile(r"^public class LuaUnit : MonoBehaviour\b"),
    }
    class_starts: dict[str, int] = {}
    for index, line in enumerate(dump, start=1):
        for class_name, pattern in class_patterns.items():
            if pattern.search(line):
                class_starts[class_name] = index

    def class_end(start: int) -> int:
        for index in range(start + 1, len(dump) + 1):
            if index != start and dump[index - 1].startswith("// Namespace:"):
                return index - 1
        return len(dump)

    ranges = {name: (start, class_end(start)) for name, start in class_starts.items()}
    patterns = [
        ("XXTEAUtil", "XXTEAUtil.DecryptByteArray", "public static string DecryptByteArray", "method"),
        ("XXTEAUtil", "XXTEAUtil.DecryptGetString", "public static string DecryptGetString", "method"),
        ("XXTEAUtil", "XXTEAUtil.DecryptGetArray", "public static string[] DecryptGetArray", "method"),
        ("LuaManager", "LuaManager.Init", "public override void Init()", "method"),
        ("LuaManager", "LuaManager.InitLuaFunction", "private void InitLuaFunction()", "method"),
        ("LuaManager", "LuaManager.LoadLuaAssetBundle", "private void LoadLuaAssetBundle()", "method"),
        ("LuaManager", "LuaManager.MyLoader", "private byte[] MyLoader(ref string filePath)", "method"),
        ("LuaManager", "LuaManager.GetLuaBuff", "private byte[] GetLuaBuff(string filePath, bool isLuaUIFile)", "method"),
        ("LuaManager", "LuaManager.LoadUIScript", "public object[] LoadUIScript(string fileName, string chunkName", "method"),
        ("LuaForm", "LuaForm.LuaScriptPath", "public string LuaScriptPath; // 0x110", "field"),
        ("LuaPage", "LuaPage.LuaScriptPath", "public string LuaScriptPath; // 0x78", "field"),
        ("LuaUnit", "LuaUnit.LuaScriptPath", "public string LuaScriptPath; // 0x58", "field"),
    ]
    rows: list[dict[str, str]] = []
    for class_name, name, pattern, kind in patterns:
        start, end = ranges[class_name]
        for index in range(start, end + 1):
            line = dump[index - 1]
            if pattern in line:
                rva = ""
                if kind == "method":
                    for back in range(index - 1, max(0, index - 8), -1):
                        match = re.search(r"RVA: (0x[0-9A-Fa-f]+)", dump[back - 1])
                        if match:
                            rva = match.group(1)
                            break
                rows.append({"symbol": name, "dump_line": str(index), "rva": rva, "signature_or_field": line.strip()})
                break
    return rows


def write_markdown(binding_summary: dict[str, Any], asset_summary: dict[str, Any], method_rows: list[dict[str, str]]) -> None:
    top_methods = "\n".join(
        f"- `{row['symbol']}` line {row['dump_line']} RVA `{row['rva']}`: `{row['signature_or_field']}`"
        for row in method_rows
    )
    prefix_text = ", ".join(f"`{key}`={value}" for key, value in asset_summary["prefix_counts"].items())
    native_summary_path = GIRLSWAR / "il2cpp_native" / "il2cpp_native_summary.json"
    disasm_summary_path = REPORT_DIR / "maininterface_il2cpp_xlua_disassembly_summary.json"
    native_lines = ["아직 native 추출 요약이 없다. `22_EXTRACT_IL2CPP_NATIVE_FROM_XAPK.cmd`를 먼저 실행한다."]
    if native_summary_path.exists():
        native_rows = json.loads(native_summary_path.read_text(encoding="utf-8"))
        native_lines = [
            f"- `{Path(row['output']).name}` size {row['size']} SHA-256 `{row['sha256']}`"
            for row in native_rows
        ]
    disasm_lines = ["아직 disassembly 요약이 없다. `23_DISASSEMBLE_MAININTERFACE_XLUA_TARGETS.cmd`를 실행한다."]
    if disasm_summary_path.exists():
        disasm_summary = json.loads(disasm_summary_path.read_text(encoding="utf-8"))
        disasm_lines = [
            f"- targets: {disasm_summary['targets']}",
            f"- successful targets: {disasm_summary['successful_targets']}",
            f"- asm: `{disasm_summary['asm_output']}`",
            f"- csv: `{disasm_summary['csv_output']}`",
            "- `XXTEAUtil.DecryptByteArray` disassembly에서 `0c 07 08 0d 0b 09` 매직 검사 흐름이 보인다.",
        ]
    md = f"""# MainInterface XLua Loader Analysis

작성 시각: 2026-06-25 KST

## 결론

`maininterface.assetbundle` 안에는 Lua 바인딩 MonoBehaviour가 직접 직렬화되어 있다. 공통 script id는 `{LUA_BINDING_SCRIPT_ID}`이고, 각 컴포넌트는 `LuaScriptPath`, `luaScript`, `m_LuaComGroups`를 가진다. 따라서 버튼 복원은 좌표 추정이 아니라 원본 `LuaComGroups`의 `Name`/`Type`/`ComObj`를 따라가면 된다.

`download/xlualogic/modules/maininterface.assetbundle`의 TextAsset은 대부분 평문 Lua가 아니다. prefix 분포는 {prefix_text}이고, `A-EV`와 `K7HT` 계열은 암호화/패킹으로 봐야 한다. IL2CPP dump 기준 로드 축은 `LuaManager.MyLoader` / `LuaManager.GetLuaBuff` / `LuaManager.LoadUIScript`와 `XXTEAUtil.DecryptByteArray` 계열이다.

## 수치

| 항목 | 값 |
|---|---:|
| Lua binding components | {binding_summary['lua_binding_components']} |
| Binding components in `UI_MainInterface` root | {binding_summary['lua_bindings_in_main_root']} |
| LuaCom entries | {binding_summary['lua_com_entries']} |
| LuaCom entries in root | {binding_summary['lua_com_entries_in_main_root']} |
| Root Type 4 Button LuaCom entries | {binding_summary['root_button_type4_lua_com_entries']} |
| MainInterface XLua TextAssets | {asset_summary['xlua_textassets']} |
| Encrypted/packed-like TextAssets | {asset_summary['encrypted_or_packed_like']} |

## IL2CPP Evidence

{top_methods}

## Native IL2CPP Files

{chr(10).join(native_lines)}

## Disassembly Evidence

{chr(10).join(disasm_lines)}

## 산출 파일

- `Assets\\RestoreData\\reports\\maininterface_lua_bindings.csv`
- `Assets\\RestoreData\\reports\\maininterface_lua_com_bindings.csv`
- `Assets\\RestoreData\\reports\\maininterface_xlua_asset_format.csv`
- `Assets\\RestoreData\\reports\\maininterface_xlua_loader_methods.csv`
- `Assets\\RestoreData\\reports\\maininterface_xlua_loader_string_hits.csv`
- `Assets\\RestoreData\\reports\\maininterface_xlua_loader_summary.json`
- `Assets\\RestoreData\\reports\\maininterface_il2cpp_xlua_disassembly.csv`
- `C:\\Users\\godho\\Downloads\\girlswar\\il2cpp_native\\il2cpp_xlua_target_disassembly.asm`

## 다음 작업

1. `maininterface_lua_com_bindings.csv`에서 `owner_in_main_root=true` 및 `com_type=4`를 우선 클릭 후보로 사용한다.
2. 버튼 이름이 같은 경우 `com_obj_path_id`와 `com_game_object_id`로 Unity Button 컴포넌트와 정확히 매칭한다.
3. 실제 Lua 함수명은 `LuaManager.GetLuaBuff` 또는 `XXTEAUtil.DecryptByteArray` 반환 직후를 런타임 hook 해서 평문 스크립트를 덤프하면 확정된다.
4. static으로 더 가려면 생성된 ASM에서 `XXTEAUtil..cctor`의 `SoketKey`/`ass` 배열 초기화와 `LuaManager.GetLuaBuff`의 `A-EV`/`K7HT` 처리 분기를 따라간다.
"""
    OUT_MD.write_text(md, encoding="utf-8")


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    ui_dir = export_dir_for(UI_BUNDLE)
    records = iter_structure(ui_dir)
    binding_rows, com_rows, binding_summary = analyze_lua_bindings(records)
    asset_rows, asset_summary = analyze_xlua_assets()
    string_rows = loader_string_hits()
    method_rows = method_evidence()

    write_csv(
        REPORT_DIR / "maininterface_lua_bindings.csv",
        binding_rows,
        [
            "lua_component_path_id",
            "owner_game_object_id",
            "owner_game_object_name",
            "owner_in_main_root",
            "script_id",
            "lua_script_path",
            "lua_script_path_id",
            "group_count",
            "lua_com_count",
            "button_type4_count",
            "type_counts",
        ],
    )
    write_csv(
        REPORT_DIR / "maininterface_lua_com_bindings.csv",
        com_rows,
        [
            "lua_component_path_id",
            "owner_game_object_id",
            "owner_game_object_name",
            "owner_in_main_root",
            "lua_script_path",
            "lua_script_path_id",
            "group_name",
            "com_name",
            "com_type",
            "com_obj_path_id",
            "com_game_object_id",
            "com_game_object_name",
            "com_in_main_root",
        ],
    )
    write_csv(
        REPORT_DIR / "maininterface_xlua_asset_format.csv",
        asset_rows,
        ["name", "path_id", "output", "size", "prefix4", "prefix16_hex", "ascii_ratio_first512", "encrypted_or_packed_like"],
    )
    write_csv(REPORT_DIR / "maininterface_xlua_loader_string_hits.csv", string_rows, ["term", "stringliteral_index", "value"])
    write_csv(REPORT_DIR / "maininterface_xlua_loader_methods.csv", method_rows, ["symbol", "dump_line", "rva", "signature_or_field"])

    summary = {
        **binding_summary,
        **asset_summary,
        "method_evidence_rows": len(method_rows),
        "string_evidence_rows": len(string_rows),
        "reports_dir": str(REPORT_DIR),
        "markdown": str(OUT_MD),
    }
    (REPORT_DIR / "maininterface_xlua_loader_summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    write_markdown(binding_summary, asset_summary, method_rows)
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
