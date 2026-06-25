from __future__ import annotations

import csv
import json
from collections import Counter, defaultdict
from datetime import datetime
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
PROJECT = BASE / "girlswar_maininterface_unity"
RESTORE_DATA = PROJECT / "Assets" / "RestoreData"
REPORT_DATA = RESTORE_DATA / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"

RECT_CSV = RESTORE_DATA / "maininterface_rects.csv"
TEXT_CSV = RESTORE_DATA / "maininterface_text_components.csv"
COMPONENT_CSV = RESTORE_DATA / "maininterface_components.csv"
OVERRIDE_CSV = RESTORE_DATA / "maininterface_raycast_overrides.csv"
MANIFEST_JSON = PROJECT / "Packages" / "manifest.json"
SCENE_BUILDER = PROJECT / "Assets" / "Editor" / "MainInterfaceSceneBuilder.cs"
UIFONT_DIR = MERGED / "merged_content" / "AssetBundles" / "download" / "ui" / "uifont"

OUT_SCRIPT_CSV = REPORT_DATA / "maininterface_text_script_type_audit.csv"
OUT_ROUTE_CSV = REPORT_DATA / "maininterface_right_route_text_layout.csv"
OUT_SUMMARY_JSON = REPORT_DATA / "maininterface_text_font_layout_summary.json"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_TEXT_FONT_LAYOUT_ANALYSIS.md"

ROOT_RECT_ID = "5568884429252053541"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def classify_text_component(keys: str) -> str:
    if "m_fontAsset" in keys or "m_fontMaterial" in keys or "m_textAlignment" in keys:
        return "TMP_like"
    if "m_TextComponent" in keys or "m_Placeholder" in keys:
        return "InputField"
    if "m_FontData" in keys:
        return "UGUI_Text"
    return "unknown_text_component"


def hierarchy_path(row: dict[str, str], by_rect: dict[str, dict[str, str]]) -> str:
    parts: list[str] = []
    cur: dict[str, str] | None = row
    seen: set[str] = set()
    while cur:
        path_id = cur.get("path_id", "")
        if path_id in seen:
            break
        seen.add(path_id)
        name = cur.get("game_object_name", "") or "rect"
        parts.append(f"{name}({path_id})")
        cur = by_rect.get(cur.get("father_id", ""))
    return "/".join(reversed(parts))


def active_chain(row: dict[str, str], by_rect: dict[str, dict[str, str]]) -> bool:
    cur: dict[str, str] | None = row
    seen: set[str] = set()
    while cur:
        path_id = cur.get("path_id", "")
        if path_id in seen:
            break
        seen.add(path_id)
        if cur.get("game_object_active", "").lower() == "false":
            return False
        cur = by_rect.get(cur.get("father_id", ""))
    return True


def descendants(root_id: str, children_by_parent: dict[str, list[dict[str, str]]]) -> set[str]:
    result: set[str] = set()
    stack = [root_id]
    while stack:
        cur = stack.pop()
        if cur in result:
            continue
        result.add(cur)
        for child in children_by_parent.get(cur, []):
            stack.append(child.get("path_id", ""))
    return result


def load_manifest_dependencies() -> dict[str, str]:
    if not MANIFEST_JSON.exists():
        return {}
    try:
        data = json.loads(MANIFEST_JSON.read_text(encoding="utf-8"))
        deps = data.get("dependencies", {})
        if isinstance(deps, dict):
            return {str(k): str(v) for k, v in deps.items()}
    except Exception:
        return {}
    return {}


def scene_builder_text_notes() -> dict[str, Any]:
    if not SCENE_BUILDER.exists():
        return {
            "exists": False,
            "uses_os_font_fallback": False,
            "creates_unity_text_for_all_rows": False,
            "uses_tmp_namespace": False,
        }
    text = SCENE_BUILDER.read_text(encoding="utf-8", errors="replace")
    return {
        "exists": True,
        "uses_os_font_fallback": "CreateDynamicFontFromOSFont" in text,
        "creates_unity_text_for_all_rows": "typeof(Text)" in text and "AddComponent<Text>" in text,
        "uses_tmp_namespace": "using TMPro" in text or "TextMeshProUGUI" in text,
        "sets_tmp_font_asset": "TMP_FontAsset" in text or ".fontMaterial" in text,
    }


def list_font_bundles() -> list[str]:
    if not UIFONT_DIR.exists():
        return []
    return sorted(
        str(path.relative_to(MERGED / "merged_content" / "AssetBundles")).replace("\\", "/")
        for path in UIFONT_DIR.rglob("*.assetbundle")
    )


def main() -> None:
    rects = read_csv(RECT_CSV)
    texts = read_csv(TEXT_CSV)
    components = read_csv(COMPONENT_CSV)
    overrides = read_csv(OVERRIDE_CSV) if OVERRIDE_CSV.exists() else []

    by_rect = {row.get("path_id", ""): row for row in rects}
    by_go = {row.get("game_object_id", ""): row for row in rects}
    children_by_parent: dict[str, list[dict[str, str]]] = defaultdict(list)
    for row in rects:
        children_by_parent[row.get("father_id", "")].append(row)

    component_by_path = {row.get("component_path_id", ""): row for row in components}
    text_by_go: dict[str, list[dict[str, str]]] = defaultdict(list)
    for row in texts:
        text_by_go[row.get("game_object_id", "")].append(row)

    script_counter = Counter(row.get("script_id", "") for row in texts)
    script_examples: dict[str, dict[str, str]] = {}
    for row in texts:
        sid = row.get("script_id", "")
        if sid not in script_examples:
            comp = component_by_path.get(row.get("component_path_id", ""), {})
            script_examples[sid] = {
                "script_id": sid,
                "count": "0",
                "classification": classify_text_component(comp.get("keys", "")),
                "example_game_object_name": row.get("game_object_name", ""),
                "example_text": row.get("text", ""),
                "component_keys": comp.get("keys", ""),
            }

    script_rows: list[dict[str, Any]] = []
    for sid, count in script_counter.most_common():
        example = dict(script_examples.get(sid, {"script_id": sid}))
        example["count"] = count
        script_rows.append(example)

    root_rights = [
        row for row in rects
        if row.get("game_object_name") == "right" and row.get("father_id") == ROOT_RECT_ID
    ]
    route_root = root_rights[0] if root_rights else None
    route_ids = descendants(route_root["path_id"], children_by_parent) if route_root else set()

    override_go_ids = {row.get("game_object_id", "") for row in overrides if row.get("game_object_id")}
    route_rows: list[dict[str, Any]] = []
    tmp_route_count = 0
    active_tmp_route_count = 0
    for text in texts:
        rect = by_go.get(text.get("game_object_id", ""))
        if not rect or rect.get("path_id") not in route_ids:
            continue
        comp = component_by_path.get(text.get("component_path_id", ""), {})
        classification = classify_text_component(comp.get("keys", ""))
        is_active_chain = active_chain(rect, by_rect)
        if classification == "TMP_like":
            tmp_route_count += 1
            if is_active_chain:
                active_tmp_route_count += 1
        parent = by_rect.get(rect.get("father_id", ""), {})
        route_rows.append({
            "hierarchy_path": hierarchy_path(rect, by_rect),
            "rect_path_id": rect.get("path_id", ""),
            "game_object_id": text.get("game_object_id", ""),
            "game_object_name": text.get("game_object_name", ""),
            "parent_name": parent.get("game_object_name", ""),
            "parent_path_id": parent.get("path_id", ""),
            "prefab_active": rect.get("game_object_active", ""),
            "active_chain": is_active_chain,
            "override_present": text.get("game_object_id", "") in override_go_ids,
            "script_id": text.get("script_id", ""),
            "classification": classification,
            "text": text.get("text", ""),
            "font_size": text.get("font_size", ""),
            "alignment": text.get("alignment", ""),
            "anchored_pos_x": rect.get("anchored_pos_x", ""),
            "anchored_pos_y": rect.get("anchored_pos_y", ""),
            "size_delta_x": rect.get("size_delta_x", ""),
            "size_delta_y": rect.get("size_delta_y", ""),
            "diagnosis": (
                "TMP rendered as UGUI Text in current builder"
                if classification == "TMP_like"
                else "UGUI Text path"
            ),
        })

    active_on_off_by_parent: dict[str, set[str]] = defaultdict(set)
    for row in route_rows:
        if row["active_chain"] and row["game_object_name"] in {"text_on", "text_off"}:
            active_on_off_by_parent[str(row["parent_path_id"])].add(str(row["game_object_name"]))
    mixed_on_off_parent_count = sum(1 for names in active_on_off_by_parent.values() if {"text_on", "text_off"} <= names)

    deps = load_manifest_dependencies()
    font_bundles = list_font_bundles()
    builder = scene_builder_text_notes()

    summary = {
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "text_component_count": len(texts),
        "script_type_count": len(script_counter),
        "tmp_like_text_count": sum(1 for row in script_rows if row["classification"] == "TMP_like" for _ in range(int(row["count"]))),
        "ugui_text_count": sum(1 for row in script_rows if row["classification"] == "UGUI_Text" for _ in range(int(row["count"]))),
        "input_field_count": sum(1 for row in script_rows if row["classification"] == "InputField" for _ in range(int(row["count"]))),
        "route_right_root_path_id": route_root.get("path_id", "") if route_root else "",
        "route_text_rows": len(route_rows),
        "route_tmp_like_text_rows": tmp_route_count,
        "route_active_tmp_like_text_rows": active_tmp_route_count,
        "route_active_parent_with_both_text_on_off": mixed_on_off_parent_count,
        "manifest_has_textmeshpro_package": "com.unity.textmeshpro" in deps,
        "manifest_has_ugui_package": "com.unity.ugui" in deps,
        "uifont_assetbundle_count": len(font_bundles),
        "uifont_assetbundle_samples": font_bundles[:30],
        "scene_builder": builder,
        "verdict": (
            "current_capture_text_is_not_final: TMP-like source text is rendered as UGUI Text "
            "with OS font fallback, and route on/off state still needs Lua-driven filtering"
        ),
    }

    write_csv(
        OUT_SCRIPT_CSV,
        script_rows,
        ["script_id", "count", "classification", "example_game_object_name", "example_text", "component_keys"],
    )
    write_csv(
        OUT_ROUTE_CSV,
        route_rows,
        [
            "hierarchy_path",
            "rect_path_id",
            "game_object_id",
            "game_object_name",
            "parent_name",
            "parent_path_id",
            "prefab_active",
            "active_chain",
            "override_present",
            "script_id",
            "classification",
            "text",
            "font_size",
            "alignment",
            "anchored_pos_x",
            "anchored_pos_y",
            "size_delta_x",
            "size_delta_y",
            "diagnosis",
        ],
    )
    OUT_SUMMARY_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_SUMMARY_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    md: list[str] = []
    md.append("# MainInterface Text / Font / Route Layout Analysis")
    md.append("")
    md.append(f"Generated: {summary['generated_at']}")
    md.append("")
    md.append("## Verdict")
    md.append("")
    md.append("현재 캡처의 글씨 위치와 폰트는 정상 복원으로 보면 안 된다.")
    md.append("")
    md.append("- 오른쪽 route 라벨을 포함한 주요 텍스트 다수가 TMP 계열 원본 필드를 가진다.")
    md.append("- 현재 `MainInterfaceSceneBuilder`는 모든 텍스트를 `UnityEngine.UI.Text`로 만들고 OS 폰트 fallback을 넣는다.")
    md.append("- 그래서 원본 `m_fontAsset`, `m_fontMaterial`, `m_textAlignment`, `m_characterSpacing`, `m_lineSpacing`, `m_margin`, word wrapping, SDF material 효과가 사라진다.")
    md.append("- `text_on` / `text_off` 같은 상태 텍스트와 route item 활성 조건은 아직 Lua branch 기준으로 완전히 검증되지 않았다.")
    md.append("")
    md.append("## Counts")
    md.append("")
    md.append("| item | value |")
    md.append("| --- | ---: |")
    md.append(f"| total text rows | {summary['text_component_count']} |")
    md.append(f"| script ids | {summary['script_type_count']} |")
    md.append(f"| TMP-like rows | {summary['tmp_like_text_count']} |")
    md.append(f"| UGUI Text rows | {summary['ugui_text_count']} |")
    md.append(f"| InputField rows | {summary['input_field_count']} |")
    md.append(f"| right route text rows | {summary['route_text_rows']} |")
    md.append(f"| right route TMP-like rows | {summary['route_tmp_like_text_rows']} |")
    md.append(f"| active right route TMP-like rows | {summary['route_active_tmp_like_text_rows']} |")
    md.append(f"| active parents with both text_on/text_off | {summary['route_active_parent_with_both_text_on_off']} |")
    md.append(f"| UI font assetbundles found | {summary['uifont_assetbundle_count']} |")
    md.append("")
    md.append("## Text Component Types")
    md.append("")
    md.append("| script id | count | classification | example object | example text |")
    md.append("| --- | ---: | --- | --- | --- |")
    for row in script_rows:
        md.append(
            f"| `{row['script_id']}` | {row['count']} | `{row['classification']}` | "
            f"`{row.get('example_game_object_name', '')}` | `{row.get('example_text', '')}` |"
        )
    md.append("")
    md.append("## Project Font State")
    md.append("")
    md.append("| item | value |")
    md.append("| --- | --- |")
    md.append(f"| `com.unity.textmeshpro` in manifest | `{summary['manifest_has_textmeshpro_package']}` |")
    md.append(f"| `com.unity.ugui` in manifest | `{summary['manifest_has_ugui_package']}` |")
    md.append(f"| SceneBuilder uses OS font fallback | `{builder['uses_os_font_fallback']}` |")
    md.append(f"| SceneBuilder creates UGUI Text for rows | `{builder['creates_unity_text_for_all_rows']}` |")
    md.append(f"| SceneBuilder uses TMP namespace | `{builder['uses_tmp_namespace']}` |")
    md.append(f"| SceneBuilder sets TMP font asset/material | `{builder['sets_tmp_font_asset']}` |")
    md.append("")
    md.append("## Font Bundle Evidence")
    md.append("")
    if font_bundles:
        for item in font_bundles[:30]:
            md.append(f"- `{item}`")
        if len(font_bundles) > 30:
            md.append(f"- ... {len(font_bundles) - 30} more")
    else:
        md.append("- No `download/ui/uifont` assetbundles found in merged content.")
    md.append("")
    md.append("## Corrected Direction")
    md.append("")
    md.append("1. TMP-like text rows must be restored as `TextMeshProUGUI`, not `UnityEngine.UI.Text`.")
    md.append("2. Import or reconstruct the original TMP font assets/materials from `download/ui/uifont/japanese` and `commonprefabsandres/tmpshaders.assetbundle`.")
    md.append("3. Preserve TMP layout fields: alignment, margin, character spacing, line spacing, word wrapping, overflow, auto sizing, and material presets.")
    md.append("4. For right route buttons, verify Lua-driven current-state filtering for `text_on` / `text_off`, selected/unselected states, and dynamic route item visibility.")
    md.append("5. Only after the TMP/state pass should the Hero Spine `main_only` capture be judged visually.")
    md.append("")
    md.append("## Generated Files")
    md.append("")
    md.append(f"- `{OUT_SUMMARY_JSON}`")
    md.append(f"- `{OUT_SCRIPT_CSV}`")
    md.append(f"- `{OUT_ROUTE_CSV}`")

    OUT_MD.parent.mkdir(parents=True, exist_ok=True)
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(f"[GirlsWarRestore] Text/font/layout summary: {OUT_SUMMARY_JSON}")
    print(f"[GirlsWarRestore] Text script audit CSV: {OUT_SCRIPT_CSV}")
    print(f"[GirlsWarRestore] Right route text layout CSV: {OUT_ROUTE_CSV}")
    print(f"[GirlsWarRestore] Report: {OUT_MD}")
    print(f"[GirlsWarRestore] Verdict: {summary['verdict']}")


if __name__ == "__main__":
    main()
