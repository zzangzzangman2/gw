from __future__ import annotations

import csv
import json
import re
from collections import defaultdict
from datetime import datetime
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
RESTORE_DATA = PROJECT / "Assets" / "RestoreData"
REPORT_DATA = RESTORE_DATA / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"

RECT_CSV = RESTORE_DATA / "maininterface_rects.csv"
SPRITE_CSV = RESTORE_DATA / "maininterface_sprite_map.csv"
TEXT_CSV = RESTORE_DATA / "maininterface_text_components.csv"
TMP_CSV = RESTORE_DATA / "maininterface_text_tmp_details.csv"
BUTTON_CSV = RESTORE_DATA / "maininterface_buttons.csv"
RAYCAST_OVERRIDE_CSV = RESTORE_DATA / "maininterface_raycast_overrides.csv"
ROUTE_RECT_OVERRIDE_CSV = RESTORE_DATA / "maininterface_route_rect_overrides.csv"
SCENE_PATH = PROJECT / "Assets" / "Scenes" / "MainInterface_Wireframe.unity"

OUT_JSON = REPORT_DATA / "maininterface_route_cluster_hierarchy_analysis.json"
OUT_NODES_CSV = REPORT_DATA / "maininterface_route_cluster_nodes.csv"
OUT_COMPONENTS_CSV = REPORT_DATA / "maininterface_route_cluster_components.csv"
OUT_DUPLICATES_CSV = REPORT_DATA / "maininterface_route_cluster_duplicate_texts.csv"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_ROUTE_CLUSTER_HIERARCHY_ANALYSIS.md"

ROOT_ID = "5568884429252053541"
NODE_MIDDLE_ID = "9056630568254389742"
ROUTE_NODE_IDS = {
    "51920382737909704",
    "-3930377403474185176",
    "1745568030950951925",
    "7836085562230756963",
    "-3820167396480157270",
}


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists() or path.stat().st_size == 0:
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def f(value: str) -> float:
    try:
        return float(value)
    except Exception:
        return 0.0


def b(value: str) -> bool:
    return str(value).strip().lower() in {"1", "true", "yes"}


def children(row: dict[str, str]) -> list[str]:
    value = row.get("child_ids", "")
    return [v for v in value.split(";") if v]


def safe_text(value: str, limit: int = 80) -> str:
    value = (value or "").replace("\r", "\\r").replace("\n", "\\n")
    return value[:limit]


def load_overrides() -> tuple[dict[str, bool], dict[str, bool], dict[str, tuple[float, float]], dict[str, tuple[float, float, float]]]:
    active: dict[str, bool] = {}
    raycast: dict[str, bool] = {}
    for row in read_csv(RAYCAST_OVERRIDE_CSV):
        go = row.get("game_object_id", "")
        if go and row.get("active", "") != "":
            active[go] = b(row.get("active", ""))
        component = row.get("component_path_id", "")
        if component and row.get("raycast_target", "") != "":
            raycast[component] = b(row.get("raycast_target", ""))

    size: dict[str, tuple[float, float]] = {}
    scale: dict[str, tuple[float, float, float]] = {}
    for row in read_csv(ROUTE_RECT_OVERRIDE_CSV):
        if b(row.get("set_size_delta", "")):
            size[row.get("rect_path_id", "")] = (f(row.get("size_delta_x", "")), f(row.get("size_delta_y", "")))
        if b(row.get("set_local_scale", "")):
            scale[row.get("rect_path_id", "")] = (f(row.get("local_scale_x", "")), f(row.get("local_scale_y", "")), f(row.get("local_scale_z", "")))
    return active, raycast, size, scale


def path_for(path_id: str, rects: dict[str, dict[str, str]]) -> str:
    parts = []
    seen = set()
    current = path_id
    while current and current not in seen and current in rects:
        seen.add(current)
        row = rects[current]
        parts.append(f"{row.get('game_object_name','')}({current})")
        current = row.get("father_id", "")
        if current == "0":
            break
    return "/".join(reversed(parts))


def active_chain(path_id: str, rects: dict[str, dict[str, str]], active_overrides: dict[str, bool]) -> bool:
    seen = set()
    current = path_id
    while current and current not in seen and current in rects:
        seen.add(current)
        row = rects[current]
        active = b(row.get("game_object_active", ""))
        go = row.get("game_object_id", "")
        if go in active_overrides:
            active = active_overrides[go]
        if not active:
            return False
        current = row.get("father_id", "")
        if current == "0":
            break
    return True


def route_owner(path_id: str, rects: dict[str, dict[str, str]]) -> str:
    current = path_id
    seen = set()
    while current and current not in seen and current in rects:
        if current in ROUTE_NODE_IDS or current == NODE_MIDDLE_ID:
            return current
        seen.add(current)
        current = rects[current].get("father_id", "")
    return ""


def scene_guid_counts() -> dict[str, int]:
    if not SCENE_PATH.exists():
        return {}
    text = SCENE_PATH.read_text(encoding="utf-8", errors="replace")
    return {guid: len(re.findall(re.escape(guid), text)) for guid in [
        "a070138850f2c0741a7f23bbab89f6dc",
        "a25b0cd4a793905498ea765125d1fae5",
        "50f0e3d4993d93246b7b530934bd405d",
    ]}


def main() -> int:
    generated_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    rect_rows = read_csv(RECT_CSV)
    rects = {row["path_id"]: row for row in rect_rows}
    by_go = {row["game_object_id"]: row for row in rect_rows}
    active_overrides, raycast_overrides, size_overrides, scale_overrides = load_overrides()

    descendants: set[str] = set()
    stack = [NODE_MIDDLE_ID]
    while stack:
        current = stack.pop()
        if current in descendants or current not in rects:
            continue
        descendants.add(current)
        stack.extend(children(rects[current]))

    node_rows: list[dict[str, Any]] = []
    for path_id in sorted(descendants, key=lambda pid: path_for(pid, rects)):
        row = rects[path_id]
        original_active = b(row.get("game_object_active", ""))
        current_active = active_overrides.get(row.get("game_object_id", ""), original_active)
        original_size = (f(row.get("size_delta_x", "")), f(row.get("size_delta_y", "")))
        current_size = size_overrides.get(path_id, original_size)
        original_scale = (f(row.get("local_scale_x", "")), f(row.get("local_scale_y", "")), f(row.get("local_scale_z", "")))
        builder_scale = (1.0, 1.0, 1.0) if original_scale == (0.0, 0.0, 0.0) else original_scale
        current_scale = scale_overrides.get(path_id, builder_scale)
        siblings = children(rects.get(row.get("father_id", ""), {}))
        sibling_index = siblings.index(path_id) if path_id in siblings else -1
        node_rows.append({
            "path_id": path_id,
            "game_object_id": row.get("game_object_id", ""),
            "name": row.get("game_object_name", ""),
            "owner": rects.get(route_owner(path_id, rects), {}).get("game_object_name", ""),
            "hierarchy_path": path_for(path_id, rects),
            "parent_id": row.get("father_id", ""),
            "parent_name": rects.get(row.get("father_id", ""), {}).get("game_object_name", ""),
            "sibling_index": sibling_index,
            "sibling_count": len(siblings),
            "original_active": original_active,
            "current_active": current_active,
            "active_chain": active_chain(path_id, rects, active_overrides),
            "anchor_min": f"{row.get('anchor_min_x','')},{row.get('anchor_min_y','')}",
            "anchor_max": f"{row.get('anchor_max_x','')},{row.get('anchor_max_y','')}",
            "pivot": f"{row.get('pivot_x','')},{row.get('pivot_y','')}",
            "anchored_pos": f"{row.get('anchored_pos_x','')},{row.get('anchored_pos_y','')}",
            "original_size": f"{original_size[0]}x{original_size[1]}",
            "current_size": f"{current_size[0]}x{current_size[1]}",
            "original_local_scale": f"{original_scale[0]},{original_scale[1]},{original_scale[2]}",
            "current_local_scale": f"{current_scale[0]},{current_scale[1]},{current_scale[2]}",
            "child_order": ";".join(f"{rects[c].get('game_object_name','')}({c})" for c in children(row) if c in rects),
        })

    tmp_by_component = {row.get("component_path_id", ""): row for row in read_csv(TMP_CSV)}
    text_by_go: dict[str, list[dict[str, str]]] = defaultdict(list)
    for row in read_csv(TEXT_CSV):
        text_by_go[row.get("game_object_id", "")].append(row)
    sprite_by_go: dict[str, list[dict[str, str]]] = defaultdict(list)
    for row in read_csv(SPRITE_CSV):
        sprite_by_go[row.get("game_object_id", "")].append(row)
    buttons_by_go: dict[str, list[dict[str, str]]] = defaultdict(list)
    for row in read_csv(BUTTON_CSV):
        buttons_by_go[row.get("game_object_id", "")].append(row)

    component_rows: list[dict[str, Any]] = []
    duplicate_key_rows: dict[tuple[str, str, str], list[dict[str, Any]]] = defaultdict(list)
    for path_id in descendants:
        row = rects[path_id]
        go = row.get("game_object_id", "")
        owner_id = route_owner(path_id, rects)
        owner_name = rects.get(owner_id, {}).get("game_object_name", "")
        active = active_chain(path_id, rects, active_overrides)
        for sprite in sprite_by_go.get(go, []):
            current_raycast = raycast_overrides.get(sprite.get("component_path_id", ""), b(sprite.get("raycast_target", "")))
            component_rows.append({
                "owner": owner_name,
                "node": row.get("game_object_name", ""),
                "component": "Image",
                "component_path_id": sprite.get("component_path_id", ""),
                "active_chain": active,
                "raycast_target": current_raycast,
                "sprite_or_text": sprite.get("sprite_name", ""),
                "asset_or_material": sprite.get("unity_asset_path", ""),
                "font_size": "",
                "size": f"{row.get('size_delta_x','')}x{row.get('size_delta_y','')}",
                "hierarchy_path": path_for(path_id, rects),
            })
        for text in text_by_go.get(go, []):
            tmp = tmp_by_component.get(text.get("component_path_id", ""), {})
            display = text.get("text") or tmp.get("display_text") or tmp.get("source_text_raw") or ""
            material = tmp.get("shared_material_path_id", "")
            component_rows.append({
                "owner": owner_name,
                "node": row.get("game_object_name", ""),
                "component": "TMP" if tmp else "Text",
                "component_path_id": text.get("component_path_id", ""),
                "active_chain": active,
                "raycast_target": text.get("raycast_target", ""),
                "sprite_or_text": safe_text(display),
                "asset_or_material": material,
                "font_size": tmp.get("font_size", text.get("font_size", "")),
                "size": f"{row.get('size_delta_x','')}x{row.get('size_delta_y','')}",
                "hierarchy_path": path_for(path_id, rects),
            })
            if active and display:
                duplicate_key_rows[(owner_name, row.get("game_object_name", ""), display)].append(component_rows[-1])
        for button in buttons_by_go.get(go, []):
            component_rows.append({
                "owner": owner_name,
                "node": row.get("game_object_name", ""),
                "component": "Button",
                "component_path_id": button.get("component_path_id", ""),
                "active_chain": active,
                "raycast_target": "",
                "sprite_or_text": "",
                "asset_or_material": button.get("target_graphic", ""),
                "font_size": "",
                "size": f"{row.get('size_delta_x','')}x{row.get('size_delta_y','')}",
                "hierarchy_path": path_for(path_id, rects),
            })

    duplicate_rows = []
    for (owner, node, text), rows in duplicate_key_rows.items():
        if len(rows) <= 1:
            continue
        duplicate_rows.append({
            "owner": owner,
            "node": node,
            "text": safe_text(text),
            "active_count": len(rows),
            "paths": " | ".join(r["hierarchy_path"] for r in rows[:6]),
        })

    write_csv(OUT_NODES_CSV, node_rows, [
        "path_id", "game_object_id", "name", "owner", "hierarchy_path", "parent_id", "parent_name",
        "sibling_index", "sibling_count", "original_active", "current_active", "active_chain",
        "anchor_min", "anchor_max", "pivot", "anchored_pos", "original_size", "current_size",
        "original_local_scale", "current_local_scale", "child_order",
    ])
    write_csv(OUT_COMPONENTS_CSV, component_rows, [
        "owner", "node", "component", "component_path_id", "active_chain", "raycast_target",
        "sprite_or_text", "asset_or_material", "font_size", "size", "hierarchy_path",
    ])
    write_csv(OUT_DUPLICATES_CSV, duplicate_rows, ["owner", "node", "text", "active_count", "paths"])

    route_parent = rects[NODE_MIDDLE_ID]
    route_children = [c for c in children(route_parent) if c in rects]
    active_route_children = [
        {
            "name": rects[c].get("game_object_name", ""),
            "path_id": c,
            "active": active_chain(c, rects, active_overrides),
            "pos": f"{rects[c].get('anchored_pos_x','')},{rects[c].get('anchored_pos_y','')}",
            "size": f"{rects[c].get('size_delta_x','')}x{rects[c].get('size_delta_y','')}",
            "sibling_index": route_children.index(c),
        }
        for c in route_children
    ]

    summary = {
        "generated_at": generated_at,
        "node_middle_child_count": len(route_children),
        "active_node_middle_children": [r for r in active_route_children if r["active"]],
        "active_duplicate_text_groups": len(duplicate_rows),
        "route_rect_override_count": len(size_overrides),
        "route_scale_override_count": len(scale_overrides),
        "active_override_count_under_node_middle": sum(
            1 for row in node_rows if row["original_active"] != row["current_active"]
        ),
        "scene_variant_guid_counts": scene_guid_counts(),
    }
    OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    write_markdown(generated_at, summary, active_route_children, node_rows, component_rows, duplicate_rows)
    print(json.dumps({"generated": str(OUT_MD), **summary}, ensure_ascii=False, indent=2))
    return 0


def write_markdown(
    generated_at: str,
    summary: dict[str, Any],
    active_route_children: list[dict[str, Any]],
    node_rows: list[dict[str, Any]],
    component_rows: list[dict[str, Any]],
    duplicate_rows: list[dict[str, Any]],
) -> None:
    lines = [
        "# MainInterface Route Cluster Hierarchy Analysis",
        "",
        f"Generated: {generated_at}",
        "",
        "## Verdict",
        "",
    ]
    if summary["active_override_count_under_node_middle"] == 0:
        lines.append("`node_middle` 아래 route cluster에는 현재 active override가 적용되지 않았다. 즉 현재 겹침은 builder가 원본 active를 잘못 덮은 결과가 아니라, 원본 active state를 그대로 살린 뒤 카드 내부 state/텍스트/스프라이트가 함께 보이는 문제다.")
    else:
        lines.append("`node_middle` 아래 일부 active override가 적용되어 있다. 아래 표의 원본/현재 active 차이를 먼저 확인해야 한다.")
    lines.append("")
    lines.append("`UI_Main_wanfa_item_1..4`와 `wanfaWorldNode`는 원본 RectTransform CSV 기준 모두 active이며 같은 parent `node_middle` 아래 sibling으로 존재한다. 따라서 route item 자체를 임의로 끄는 것은 원본 근거가 약하다.")
    lines.append("")
    lines.append("## node_middle Child Order")
    lines.append("")
    lines.append("| idx | child | active | pos | size | pathID |")
    lines.append("| ---: | --- | --- | --- | --- | --- |")
    for row in active_route_children:
        lines.append(f"| {row['sibling_index']} | `{row['name']}` | `{row['active']}` | `{row['pos']}` | `{row['size']}` | `{row['path_id']}` |")
    lines.append("")
    lines.append("## Route Owner Nodes")
    lines.append("")
    lines.append("| owner | active | pos | size | scale | child order |")
    lines.append("| --- | --- | --- | --- | --- | --- |")
    for row in node_rows:
        if row["path_id"] not in ROUTE_NODE_IDS and row["path_id"] != NODE_MIDDLE_ID:
            continue
        lines.append(
            f"| `{row['name']}` | `{row['active_chain']}` | `{row['anchored_pos']}` | "
            f"`{row['current_size']}` | `{row['current_local_scale']}` | `{row['child_order']}` |"
        )
    lines.append("")
    lines.append("## Active Text/Image Highlights")
    lines.append("")
    lines.append("| owner | node | component | active | text/sprite | material/asset | font | size |")
    lines.append("| --- | --- | --- | --- | --- | --- | ---: | --- |")
    for row in component_rows:
        if not row["active_chain"]:
            continue
        if row["component"] not in {"TMP", "Image", "Button"}:
            continue
        text = row["sprite_or_text"]
        if not text and row["component"] != "Button":
            continue
        if row["owner"] not in {"UI_Main_wanfa_item_1", "UI_Main_wanfa_item_2", "UI_Main_wanfa_item_3", "UI_Main_wanfa_item_4", "wanfaWorldNode"}:
            continue
        asset = Path(row["asset_or_material"]).name if str(row["asset_or_material"]).startswith("Assets/") else row["asset_or_material"]
        lines.append(
            f"| `{row['owner']}` | `{row['node']}` | `{row['component']}` | `{row['active_chain']}` | "
            f"`{text}` | `{asset}` | {row['font_size'] or ''} | `{row['size']}` |"
        )
    lines.append("")
    lines.append("## Active Duplicate Text Groups")
    lines.append("")
    if duplicate_rows:
        lines.append("| owner | node | text | count | paths |")
        lines.append("| --- | --- | --- | ---: | --- |")
        for row in duplicate_rows:
            lines.append(f"| `{row['owner']}` | `{row['node']}` | `{row['text']}` | {row['active_count']} | `{row['paths']}` |")
    else:
        lines.append("No duplicate active text components with the same owner/node/text key were found under route cluster.")
    lines.append("")
    lines.append("## Current Scene Checks")
    lines.append("")
    for guid, count in summary["scene_variant_guid_counts"].items():
        lines.append(f"- variant font GUID `{guid}` references in scene: `{count}`")
    lines.append("")
    lines.append("## Next")
    lines.append("")
    lines.append("1. Do not disable `UI_Main_wanfa_item_1..4` as duplicates unless a stronger runtime state source is found.")
    lines.append("2. Focus on each route card's internal active children: `text_name`, `text_wanfaTips`, `wanfaBgImg`, `wanfaBtn`, and world node `text_big/text_small` composition.")
    lines.append("3. If capture shows label/image overlap after variant font use, prefer TMP layout/material override backed by the original TMP row over parent route-item deactivation.")
    lines.append("")
    lines.append("## Generated Files")
    lines.append("")
    for path in [OUT_JSON, OUT_NODES_CSV, OUT_COMPONENTS_CSV, OUT_DUPLICATES_CSV]:
        lines.append(f"- `{path}`")
    OUT_MD.parent.mkdir(parents=True, exist_ok=True)
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    raise SystemExit(main())
