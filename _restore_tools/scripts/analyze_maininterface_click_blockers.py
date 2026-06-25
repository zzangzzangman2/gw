from __future__ import annotations

import csv
import json
from collections import Counter, defaultdict
from datetime import datetime
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
REPORT_DIR = PROJECT / "Assets" / "RestoreData" / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"
RESTORE_DATA = PROJECT / "Assets" / "RestoreData"

CLICK_CSV = REPORT_DIR / "maininterface_click_validation.csv"
ROOT_BUTTONS_CSV = REPORT_DIR / "maininterface_root_buttons.csv"
ROOT_RAYCAST_CSV = REPORT_DIR / "maininterface_root_raycast_report.csv"
RECTS_CSV = RESTORE_DATA / "maininterface_rects.csv"

OUT_CSV = REPORT_DIR / "maininterface_click_blocker_analysis.csv"
OUT_JSON = REPORT_DIR / "maininterface_click_blocker_analysis_summary.json"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_CLICK_BLOCKER_ANALYSIS.md"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def truthy(value: Any) -> bool:
    return str(value).strip().lower() in {"1", "true", "yes"}


def compact_float(value: str) -> str:
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return value or ""
    return f"{parsed:.3f}".rstrip("0").rstrip(".")


def build_rect_paths(rect_rows: list[dict[str, str]]) -> dict[str, str]:
    rect_by_path = {row.get("path_id", ""): row for row in rect_rows if row.get("path_id")}
    cache: dict[str, str] = {}

    def path_for_rect(rect_id: str) -> str:
        if not rect_id:
            return ""
        if rect_id in cache:
            return cache[rect_id]
        row = rect_by_path.get(rect_id)
        if not row:
            return ""
        father_id = row.get("father_id", "")
        parent_path = path_for_rect(father_id) if father_id in rect_by_path else ""
        name = row.get("game_object_name", "") or f"<rect:{rect_id}>"
        path = f"{parent_path}/{name}" if parent_path else name
        cache[rect_id] = path
        return path

    return {row.get("game_object_id", ""): path_for_rect(row.get("path_id", "")) for row in rect_rows}


def index_rows(rows: list[dict[str, str]], key: str) -> dict[str, dict[str, str]]:
    indexed: dict[str, dict[str, str]] = {}
    for row in rows:
        value = row.get(key, "")
        if value and value not in indexed:
            indexed[value] = row
    return indexed


def category_for(row: dict[str, str], top_row: dict[str, str] | None) -> tuple[str, str]:
    button_name = row.get("button_name", "")
    top_object = row.get("raycast_top_object", "")
    top_status = (top_row or {}).get("status", "")
    top_alpha = compact_float((top_row or {}).get("color_a", ""))

    if truthy(row.get("raycast_clickable")):
        return "clickable", "Already passes click validation; keep as evidence."
    if not truthy(row.get("active_in_hierarchy")):
        return (
            "inactive_source_object",
            "Keep in extracted evidence, but do not count as current-screen clickable until its source state is active.",
        )
    if button_name == "UI_bg" or top_object == "UI_touchSpine":
        return (
            "background_touch_layer",
            "Treat as background/touch capture evidence, not a restored gameplay button; exclude from required button-click coverage.",
        )
    if button_name == top_object == "btn_act":
        return (
            "transparent_repeated_activity_button",
            "Multiple transparent btn_act copies overlap. Restore only the active runtime list entries or give repeated items resolved list positions before enabling raycast.",
        )
    if top_object == "btn_act":
        return (
            "activity_button_overlaps_menu",
            "A transparent activity button is above this control. Check the owning list/state root, then disable raycast on placeholder copies or separate the activity item layout.",
        )
    if top_object == "btnToggle5" and button_name.startswith("btnToggle"):
        return (
            "same_slot_toggle_state_stack",
            "The bottom toggle alternatives occupy the same slot; keep btnToggle5 as current clickable state and restore the other toggles as inactive/state alternatives.",
        )
    if top_object == "btn_watch" and button_name in {"btn_beijing", "btn_qinmi", "btn_marry", "btn_yincang"}:
        return (
            "same_slot_top_button_stack",
            "Top button alternatives share the btn_watch slot. Keep btn_watch as the current clickable state and restore the covered buttons as inactive/state alternatives.",
        )
    if top_object == "funhandbook_Btn":
        return (
            "same_slot_top_menu_stack",
            "Top menu alternatives share one slot. Pick the active runtime state for this screen or move the covered entries into their expanded/menu state before enabling clicks.",
        )
    if top_object == "Image":
        return (
            "decorative_image_raycast_blocker",
            "A decorative Image is above the Button. If it has no button handler, set raycastTarget=false or bind the Button targetGraphic to the visible image child.",
        )
    if top_status == "empty_sprite_ref" and top_alpha in {"0", "0.0"}:
        return (
            "transparent_empty_sprite_blocker",
            "The blocker has no sprite and alpha 0. Preserve it as evidence, but disable raycast unless a Lua handler proves it is the interactive surface.",
        )
    return (
        "unclassified_blocker",
        "Inspect this blocker in Unity hierarchy, then choose either active-state filtering or raycastTarget=false based on visual and Lua evidence.",
    )


def make_markdown(
    generated_at: str,
    summary: dict[str, Any],
    blocked_rows: list[dict[str, Any]],
    category_counts: Counter[str],
    top_counts: Counter[str],
) -> str:
    lines: list[str] = []
    lines.append("# MainInterface Click Blocker Analysis")
    lines.append("")
    lines.append(f"- Generated: {generated_at}")
    lines.append(f"- Source click validation: `{CLICK_CSV}`")
    lines.append(f"- Source restore rules: `{BASE.parent / 'apk_extracted_ui_restore_rules.txt'}`")
    lines.append(f"- Output CSV: `{OUT_CSV}`")
    lines.append("")
    lines.append("## Summary")
    lines.append("")
    lines.append(f"- Total Button components: {summary['total_buttons']}")
    lines.append(f"- Active Buttons: {summary['active_buttons']}")
    lines.append(f"- Inactive/source-state Buttons: {summary['inactive_buttons']}")
    lines.append(f"- Raycast-clickable Buttons: {summary['raycast_clickable_buttons']}")
    lines.append(f"- Active but blocked Buttons: {summary['active_blocked_buttons']}")
    lines.append(f"- Invoked click logs available: {summary['invoked_clicks']}")
    lines.append("")
    lines.append("## Blocker Categories")
    lines.append("")
    if not category_counts:
        lines.append("No active blocked buttons remain in the current click-validation pass.")
        lines.append("")
    lines.append("| Category | Count | Restore decision |")
    lines.append("|---|---:|---|")
    category_notes = {
        "transparent_repeated_activity_button": "Repeated transparent `btn_act` copies need runtime-list filtering or resolved positions.",
        "same_slot_toggle_state_stack": "Treat as state alternatives; only the active state should receive raycast now.",
        "same_slot_top_menu_stack": "Treat as menu/state alternatives sharing one slot.",
        "same_slot_top_button_stack": "Treat as top-button state alternatives sharing the current btn_watch slot.",
        "decorative_image_raycast_blocker": "Disable decorative Image raycast or bind the Button to that visible graphic.",
        "activity_button_overlaps_menu": "Separate transparent activity placeholders from visible menu buttons.",
        "background_touch_layer": "Not a required restored gameplay button for this one-screen click pass.",
        "transparent_empty_sprite_blocker": "Disable raycast unless Lua evidence proves it is the real hit surface.",
        "unclassified_blocker": "Manual hierarchy inspection still required.",
    }
    for category, count in category_counts.most_common():
        lines.append(f"| `{category}` | {count} | {category_notes.get(category, '')} |")
    lines.append("")
    lines.append("## Top Blocking Objects")
    lines.append("")
    if not top_counts:
        lines.append("No top blocking objects remain for active buttons.")
        lines.append("")
    lines.append("| Raycast top object | Count |")
    lines.append("|---|---:|")
    for name, count in top_counts.most_common():
        lines.append(f"| `{name}` | {count} |")
    lines.append("")
    lines.append("## Active Blocked Buttons")
    lines.append("")
    if not blocked_rows:
        lines.append("No active blocked buttons remain. Active buttons are all raycast-clickable in this pass.")
        lines.append("")
    lines.append("| Button | Screen | Top blocker | Lua handler | Category |")
    lines.append("|---|---:|---|---|---|")
    for row in blocked_rows:
        lua = row.get("lua_handler") or ""
        if row.get("lua_module"):
            lua = f"{row['lua_module']}:{lua}" if lua else row["lua_module"]
        lines.append(
            "| `{button}` | {x},{y} | `{top}` | `{lua}` | `{category}` |".format(
                button=row.get("button_name", ""),
                x=row.get("screen_x", ""),
                y=row.get("screen_y", ""),
                top=row.get("top_object", ""),
                lua=lua,
                category=row.get("category", ""),
            )
        )
    lines.append("")
    lines.append("## Restore Order")
    lines.append("")
    lines.append("1. Exclude `UI_bg`/touch-layer background hits from required gameplay button coverage, while keeping their source evidence.")
    lines.append("2. Resolve transparent `btn_act` duplicates first, because they cause most blockers and can hide real side-menu controls.")
    lines.append("3. Convert same-slot state stacks (`btnToggle*`, top menu alternatives) into explicit active/inactive screen states.")
    lines.append("4. Disable raycast on decorative Image blockers after verifying they have no Lua handler, or bind their parent Button to the visible graphic.")
    lines.append("5. Re-run `_restore_tools\\37_VALIDATE_MAININTERFACE_BUTTON_CLICKS.cmd`, then `_restore_tools\\39_ANALYZE_MAININTERFACE_CLICK_BLOCKERS.cmd` and `_restore_tools\\04_VERIFY_MAININTERFACE_OUTPUTS.cmd`.")
    lines.append("")
    lines.append("## Rule Check")
    lines.append("")
    lines.append("- This report does not replace button logging; it uses the generated click-validation log and CSV as evidence.")
    lines.append("- It avoids coordinate-only restoration by keeping Button component ids, Lua handler matches, and hierarchy paths where available.")
    lines.append("- No source evidence is deleted or overwritten; this is a derived analysis file.")
    lines.append("")
    return "\n".join(lines)


def main() -> None:
    for path in (CLICK_CSV, ROOT_BUTTONS_CSV, ROOT_RAYCAST_CSV, RECTS_CSV):
        if not path.exists():
            raise FileNotFoundError(path)

    click_rows = read_csv(CLICK_CSV)
    button_rows = read_csv(ROOT_BUTTONS_CSV)
    raycast_rows = read_csv(ROOT_RAYCAST_CSV)
    rect_rows = read_csv(RECTS_CSV)

    button_by_component = index_rows(button_rows, "component_path_id")
    raycast_by_component = index_rows(raycast_rows, "component_path_id")
    rect_path_by_go = build_rect_paths(rect_rows)

    blocked_rows: list[dict[str, Any]] = []
    category_counts: Counter[str] = Counter()
    top_counts: Counter[str] = Counter()
    confidence_counts: Counter[str] = Counter()
    grouped_buttons: dict[str, list[str]] = defaultdict(list)

    for row in click_rows:
        if truthy(row.get("raycast_clickable")) or not truthy(row.get("active_in_hierarchy")):
            continue

        button_component = row.get("component_path_id", "")
        button_info = button_by_component.get(button_component, {})
        button_go = row.get("game_object_path_id") or button_info.get("game_object_id", "")
        button_path = rect_path_by_go.get(button_go, "")

        top_component = row.get("raycast_top_component_path_id", "")
        top_button_info = button_by_component.get(top_component, {})
        top_raycast_info = raycast_by_component.get(top_component, {})
        top_info = top_button_info or top_raycast_info
        top_go = top_info.get("game_object_id", "")
        top_path = rect_path_by_go.get(top_go, "")
        category, action = category_for(row, top_raycast_info if top_raycast_info else None)

        out = {
            "button_name": row.get("button_name", ""),
            "button_component_path_id": button_component,
            "button_game_object_id": button_go,
            "button_path": button_path,
            "screen_x": compact_float(row.get("screen_x", "")),
            "screen_y": compact_float(row.get("screen_y", "")),
            "top_object": row.get("raycast_top_object", ""),
            "top_kind": row.get("raycast_top_kind", ""),
            "top_component_path_id": top_component,
            "top_path": top_path,
            "top_status": top_raycast_info.get("status", ""),
            "top_color_a": compact_float(top_raycast_info.get("color_a", "")),
            "top_width": compact_float(top_raycast_info.get("width", "")),
            "top_height": compact_float(top_raycast_info.get("height", "")),
            "raycast_hit_count": row.get("raycast_hit_count", ""),
            "lua_confidence": row.get("lua_confidence", ""),
            "lua_module": row.get("lua_module", ""),
            "lua_handler": row.get("lua_handler", ""),
            "lua_event": row.get("lua_event", ""),
            "category": category,
            "restore_action": action,
        }
        blocked_rows.append(out)
        category_counts[category] += 1
        top_counts[out["top_object"]] += 1
        confidence_counts[row.get("lua_confidence", "")] += 1
        grouped_buttons[category].append(out["button_name"])

    generated_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    summary = {
        "generated_at": generated_at,
        "total_buttons": len(click_rows),
        "active_buttons": sum(1 for row in click_rows if truthy(row.get("active_in_hierarchy"))),
        "inactive_buttons": sum(1 for row in click_rows if not truthy(row.get("active_in_hierarchy"))),
        "raycast_clickable_buttons": sum(1 for row in click_rows if truthy(row.get("raycast_clickable"))),
        "active_blocked_buttons": len(blocked_rows),
        "invoked_clicks": sum(1 for row in click_rows if truthy(row.get("click_invoked"))),
        "category_counts": dict(category_counts.most_common()),
        "top_blocker_counts": dict(top_counts.most_common()),
        "lua_confidence_counts_for_active_blocked": dict(confidence_counts.most_common()),
        "buttons_by_category": {key: values for key, values in grouped_buttons.items()},
        "outputs": {
            "csv": str(OUT_CSV),
            "json": str(OUT_JSON),
            "md": str(OUT_MD),
        },
    }

    fieldnames = [
        "button_name",
        "button_component_path_id",
        "button_game_object_id",
        "button_path",
        "screen_x",
        "screen_y",
        "top_object",
        "top_kind",
        "top_component_path_id",
        "top_path",
        "top_status",
        "top_color_a",
        "top_width",
        "top_height",
        "raycast_hit_count",
        "lua_confidence",
        "lua_module",
        "lua_handler",
        "lua_event",
        "category",
        "restore_action",
    ]
    write_csv(OUT_CSV, blocked_rows, fieldnames)
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    OUT_MD.write_text(make_markdown(generated_at, summary, blocked_rows, category_counts, top_counts), encoding="utf-8")

    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
