from __future__ import annotations

import csv
import json
from pathlib import Path


PROJECT = Path(r"C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity")
RESTORE = PROJECT / "Assets" / "RestoreData"
ROOT_RECT_ID = "5568884429252053541"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, str]], fieldnames: list[str] | None = None) -> None:
    if fieldnames is None:
        fieldnames = []
        for row in rows:
            for key in row:
                if key not in fieldnames:
                    fieldnames.append(key)
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def truthy(value: str) -> bool:
    return str(value).strip().lower() in {"1", "true"}


def num(value: str, default: float = 0.0) -> float:
    try:
        return float(value)
    except (TypeError, ValueError):
        return default


def root_rects(rects: list[dict[str, str]]) -> tuple[set[str], set[str]]:
    by_id = {row["path_id"]: row for row in rects}
    keep: set[str] = set()
    stack = [ROOT_RECT_ID]
    while stack:
        current = stack.pop()
        if current in keep:
            continue
        keep.add(current)
        row = by_id.get(current)
        if not row:
            continue
        for child in row.get("child_ids", "").split(";"):
            if child and child in by_id:
                stack.append(child)
    game_objects = {by_id[path_id]["game_object_id"] for path_id in keep if path_id in by_id}
    return keep, game_objects


def main() -> None:
    rects = read_csv(RESTORE / "maininterface_rects.csv")
    images = read_csv(RESTORE / "maininterface_sprite_map.csv")
    buttons = read_csv(RESTORE / "maininterface_buttons.csv")
    texts = read_csv(RESTORE / "maininterface_text_components.csv")
    scrolls = read_csv(RESTORE / "maininterface_scrollrects.csv")

    root_rect_ids, root_go_ids = root_rects(rects)
    button_go_ids = {row["game_object_id"] for row in buttons if row["game_object_id"] in root_go_ids}
    scroll_go_ids = {row["game_object_id"] for row in scrolls if row["game_object_id"] in root_go_ids}
    scroll_viewport_ids = {row["viewport"] for row in scrolls if row["game_object_id"] in root_go_ids}

    rect_by_go = {row["game_object_id"]: row for row in rects if row["game_object_id"] in root_go_ids}

    raycast_rows: list[dict[str, str]] = []
    for row in images:
        go_id = row.get("game_object_id", "")
        if go_id not in root_go_ids or not truthy(row.get("raycast_target", "")):
            continue
        rect = rect_by_go.get(go_id, {})
        status = row.get("status", "")
        has_sprite = status == "ready"
        is_button = go_id in button_go_ids
        is_scroll = go_id in scroll_go_ids or row.get("path_id", "") in scroll_viewport_ids
        alpha = num(row.get("color_a", "1"), 1)
        width = abs(num(rect.get("size_delta_x", "")))
        height = abs(num(rect.get("size_delta_y", "")))
        area = width * height
        risk = "ok"
        if not is_button and not is_scroll and not has_sprite:
            risk = "transparent_raycast_candidate"
        elif not is_button and area > 100000:
            risk = "large_nonbutton_raycast"
        elif alpha <= 0.01 and not is_button:
            risk = "invisible_raycast_candidate"
        raycast_rows.append(
            {
                "game_object_id": go_id,
                "game_object_name": row.get("game_object_name", ""),
                "component_path_id": row.get("component_path_id", ""),
                "sprite_ref": row.get("sprite_ref", ""),
                "sprite_name": row.get("sprite_name", ""),
                "status": status,
                "is_button": str(is_button),
                "is_scroll_or_viewport": str(is_scroll),
                "color_a": row.get("color_a", ""),
                "width": str(width),
                "height": str(height),
                "area": str(area),
                "risk": risk,
            }
        )
    raycast_rows.sort(key=lambda r: (r["risk"] == "ok", -num(r["area"])))

    root_texts = [row for row in texts if row.get("game_object_id", "") in root_go_ids]
    root_buttons = [row for row in buttons if row.get("game_object_id", "") in root_go_ids]
    root_scrolls = [row for row in scrolls if row.get("game_object_id", "") in root_go_ids]
    root_images = [row for row in images if row.get("game_object_id", "") in root_go_ids]

    report_dir = RESTORE / "reports"
    write_csv(report_dir / "maininterface_root_raycast_report.csv", raycast_rows)
    write_csv(report_dir / "maininterface_root_buttons.csv", root_buttons)
    write_csv(report_dir / "maininterface_root_scrollrects.csv", root_scrolls)
    write_csv(report_dir / "maininterface_root_texts.csv", root_texts)
    write_csv(report_dir / "maininterface_root_images.csv", root_images)

    summary = {
        "root_rect_id": ROOT_RECT_ID,
        "root_recttransforms": len(root_rect_ids),
        "root_game_objects": len(root_go_ids),
        "root_images": len(root_images),
        "root_ready_sprites": sum(1 for row in root_images if row.get("status") == "ready"),
        "root_texts": len(root_texts),
        "root_buttons": len(root_buttons),
        "root_scrollrects": len(root_scrolls),
        "raycast_targets": len(raycast_rows),
        "transparent_raycast_candidates": sum(1 for row in raycast_rows if row["risk"] == "transparent_raycast_candidate"),
        "large_nonbutton_raycast": sum(1 for row in raycast_rows if row["risk"] == "large_nonbutton_raycast"),
        "invisible_raycast_candidates": sum(1 for row in raycast_rows if row["risk"] == "invisible_raycast_candidate"),
        "reports_dir": str(report_dir),
    }
    (report_dir / "maininterface_root_interaction_summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
