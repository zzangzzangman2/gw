from __future__ import annotations

import csv
import json
from datetime import datetime
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
REPORT_DATA = PROJECT / "Assets" / "RestoreData" / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"

RIGHT_ROUTE_CSV = REPORT_DATA / "maininterface_right_route_text_layout.csv"
TMP_DETAILS_CSV = PROJECT / "Assets" / "RestoreData" / "maininterface_text_tmp_details.csv"
SHARED_MATERIALS_CSV = REPORT_DATA / "maininterface_tmp_shared_materials.csv"

OUT_CSV = REPORT_DATA / "maininterface_route_tmp_state_after_material.csv"
OUT_SUMMARY_JSON = REPORT_DATA / "maininterface_route_tmp_state_after_material_summary.json"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_ROUTE_TMP_STATE_AFTER_MATERIAL.md"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def b(value: str) -> bool:
    return str(value).strip().lower() in {"1", "true", "yes"}


def f(value: str) -> float:
    try:
        return float(value)
    except (TypeError, ValueError):
        return 0.0


def main() -> int:
    tmp_by_go = {row.get("game_object_id", ""): row for row in read_csv(TMP_DETAILS_CSV)}
    material_by_path = {row.get("shared_material_path_id", ""): row for row in read_csv(SHARED_MATERIALS_CSV)}

    rows: list[dict[str, Any]] = []
    for route in read_csv(RIGHT_ROUTE_CSV):
        if route.get("classification") != "TMP_like":
            continue
        text = route.get("text", "")
        if not text:
            continue
        go_id = route.get("game_object_id", "")
        detail = tmp_by_go.get(go_id, {})
        shared_path_id = detail.get("shared_material_path_id", "")
        material = material_by_path.get(shared_path_id, {})
        font_size = f(detail.get("font_size") or route.get("font_size"))
        rect_w = f(route.get("size_delta_x"))
        rect_h = f(route.get("size_delta_y"))
        active_chain = b(route.get("active_chain"))
        prefab_active = b(route.get("prefab_active"))

        flags = []
        if active_chain:
            flags.append("visible_chain")
        else:
            flags.append("inactive_chain")
        if rect_h <= 0:
            flags.append("zero_or_negative_height")
        elif font_size > rect_h:
            flags.append("font_larger_than_rect")
        elif rect_h < font_size * 1.15:
            flags.append("tight_height")
        if rect_w <= 0:
            flags.append("zero_or_negative_width")
        if material:
            flags.append("shared_material_found")
        else:
            flags.append("shared_material_missing")

        rows.append(
            {
                "hierarchy_path": route.get("hierarchy_path", ""),
                "game_object_id": go_id,
                "game_object_name": route.get("game_object_name", ""),
                "parent_name": route.get("parent_name", ""),
                "text": text,
                "active_chain": active_chain,
                "prefab_active": prefab_active,
                "anchored_pos_x": route.get("anchored_pos_x", ""),
                "anchored_pos_y": route.get("anchored_pos_y", ""),
                "size_delta_x": rect_w,
                "size_delta_y": rect_h,
                "font_asset_name": detail.get("font_asset_name", ""),
                "font_size": font_size,
                "font_size_min": detail.get("font_size_min", ""),
                "font_size_max": detail.get("font_size_max", ""),
                "enable_auto_sizing": detail.get("enable_auto_sizing", ""),
                "resolved_alignment": detail.get("resolved_alignment", ""),
                "character_spacing": detail.get("character_spacing", ""),
                "line_spacing": detail.get("line_spacing", ""),
                "overflow_mode": detail.get("overflow_mode", ""),
                "shared_material_path_id": shared_path_id,
                "shared_material_name": material.get("material_name", ""),
                "shared_material_bundle": material.get("bundle", ""),
                "flags": ";".join(flags),
            }
        )

    active_rows = [row for row in rows if row["active_chain"]]
    suspicious_active = [
        row for row in active_rows
        if "zero_or_negative_height" in row["flags"]
        or "font_larger_than_rect" in row["flags"]
        or "zero_or_negative_width" in row["flags"]
    ]
    summary = {
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "route_tmp_text_rows": len(rows),
        "active_route_tmp_text_rows": len(active_rows),
        "suspicious_active_rows": len(suspicious_active),
        "shared_material_missing_rows": len([row for row in rows if "shared_material_missing" in row["flags"]]),
        "zero_height_active_rows": len([row for row in active_rows if "zero_or_negative_height" in row["flags"]]),
        "font_larger_than_rect_active_rows": len([row for row in active_rows if "font_larger_than_rect" in row["flags"]]),
        "verdict": "shared materials are now known; remaining visible route mismatch is concentrated in active-state, zero/tight rect height, font scale, and sibling/sorting",
    }
    fields = [
        "hierarchy_path", "game_object_id", "game_object_name", "parent_name", "text", "active_chain",
        "prefab_active", "anchored_pos_x", "anchored_pos_y", "size_delta_x", "size_delta_y",
        "font_asset_name", "font_size", "font_size_min", "font_size_max", "enable_auto_sizing",
        "resolved_alignment", "character_spacing", "line_spacing", "overflow_mode",
        "shared_material_path_id", "shared_material_name", "shared_material_bundle", "flags",
    ]
    write_csv(OUT_CSV, rows, fields)
    OUT_SUMMARY_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    write_markdown(summary, rows, suspicious_active)
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return 0


def write_markdown(summary: dict[str, Any], rows: list[dict[str, Any]], suspicious_active: list[dict[str, Any]]) -> None:
    lines: list[str] = []
    lines.append("# MainInterface Route TMP State After Material")
    lines.append("")
    lines.append(f"Generated: {summary['generated_at']}")
    lines.append("")
    lines.append("## Verdict")
    lines.append("")
    lines.append("원본 static TMP FontAsset과 shared material preset은 적용 가능한 상태가 됐다. 그래도 route 라벨이 어긋나므로 남은 문제는 route active state, zero/tight RectTransform height, font scale/autosize, sibling/sorting 쪽으로 좁혀졌다.")
    lines.append("")
    lines.append("## Counts")
    lines.append("")
    lines.append("| item | value |")
    lines.append("| --- | ---: |")
    for key in [
        "route_tmp_text_rows",
        "active_route_tmp_text_rows",
        "suspicious_active_rows",
        "shared_material_missing_rows",
        "zero_height_active_rows",
        "font_larger_than_rect_active_rows",
    ]:
        lines.append(f"| {key} | {summary[key]} |")
    lines.append("")
    lines.append("## Suspicious Active Rows")
    lines.append("")
    if suspicious_active:
        lines.append("| text | object | parent | pos | size | font | material | flags |")
        lines.append("| --- | --- | --- | --- | --- | ---: | --- | --- |")
        for row in suspicious_active[:30]:
            lines.append(
                f"| `{row['text']}` | `{row['game_object_name']}` | `{row['parent_name']}` | "
                f"`{row['anchored_pos_x']},{row['anchored_pos_y']}` | `{row['size_delta_x']}x{row['size_delta_y']}` | "
                f"{row['font_size']} | `{row['shared_material_name']}` | `{row['flags']}` |"
            )
    else:
        lines.append("기계적으로 잡히는 active route TMP rect/font 이상은 없다.")
    lines.append("")
    lines.append("## Active Route TMP Rows")
    lines.append("")
    lines.append("| text | object | parent | size | font | material | flags |")
    lines.append("| --- | --- | --- | --- | ---: | --- | --- |")
    for row in [r for r in rows if r["active_chain"]][:40]:
        lines.append(
            f"| `{row['text']}` | `{row['game_object_name']}` | `{row['parent_name']}` | "
            f"`{row['size_delta_x']}x{row['size_delta_y']}` | {row['font_size']} | `{row['shared_material_name']}` | `{row['flags']}` |"
        )
    lines.append("")
    lines.append("## Next")
    lines.append("")
    lines.append("1. zero/tight rect active rows가 원본에서 의도된 동적 layout인지, 아니면 복원 Scene에서 height가 깨진 것인지 hierarchy별로 확인한다.")
    lines.append("2. route item active override를 다시 검토해 현재 화면에 섞이면 안 되는 상태 UI를 끈다.")
    lines.append("3. material 적용 후에도 큰 라벨은 font scale/autosize와 parent localScale/sibling order를 확인한다.")
    lines.append("")
    lines.append("## Generated Files")
    lines.append("")
    lines.append(f"- `{OUT_CSV}`")
    lines.append(f"- `{OUT_SUMMARY_JSON}`")
    OUT_MD.parent.mkdir(parents=True, exist_ok=True)
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    raise SystemExit(main())
