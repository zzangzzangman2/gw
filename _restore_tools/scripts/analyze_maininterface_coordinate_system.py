import csv
import json
from datetime import datetime
from pathlib import Path


BASE = Path(__file__).resolve().parents[2]
UNITY = BASE / "girlswar_maininterface_unity"
MERGED = BASE / "girlswar_merged_extracted"
REPORTS = BASE / "reports" / "maininterface"
RESTORE_REPORTS = UNITY / "Assets" / "RestoreData" / "reports"

ROOT_RECT_ID = "5568884429252053541"
ROOT_NAME = "UI_MainInterface"
RECTS_CSV = UNITY / "Assets" / "RestoreData" / "maininterface_rects.csv"
BUILD_JSON = UNITY / "Assets" / "RestoreData" / "maininterface_build_result.json"
CAPTURE_JSON = UNITY / "Assets" / "RestoreCaptures" / "maininterface_capture_result.json"
CLICK_JSON = RESTORE_REPORTS / "maininterface_click_validation_summary.json"
BLOCKER_JSON = RESTORE_REPORTS / "maininterface_click_blocker_analysis_summary.json"
LUA_MAIN = MERGED / "decoded" / "xlua" / "-6351603197391775840_UI_MainPage_security_xor_raw.lua"

ROOT_CHILDREN_CSV = RESTORE_REPORTS / "maininterface_coordinate_root_children.csv"
SUMMARY_JSON = RESTORE_REPORTS / "maininterface_coordinate_system_summary.json"
MARKDOWN = REPORTS / "MAININTERFACE_COORDINATE_SYSTEM_REBASE.md"


def read_json(path):
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def load_csv(path):
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def num(value):
    try:
        return float(value)
    except Exception:
        return 0.0


def lua_evidence_lines():
    if not LUA_MAIN.exists():
        return []
    lines = LUA_MAIN.read_text(encoding="utf-8", errors="replace").splitlines()
    evidence = []
    for line_no in range(3038, 3046):
        if line_no <= len(lines):
            evidence.append({"line": line_no, "text": lines[line_no - 1]})
    return evidence


def main():
    REPORTS.mkdir(parents=True, exist_ok=True)
    RESTORE_REPORTS.mkdir(parents=True, exist_ok=True)

    rects = load_csv(RECTS_CSV)
    root = next((r for r in rects if r.get("path_id") == ROOT_RECT_ID), None)
    children = [r for r in rects if r.get("father_id") == ROOT_RECT_ID]

    children_rows = []
    for r in children:
        children_rows.append(
            {
                "path_id": r.get("path_id", ""),
                "game_object_id": r.get("game_object_id", ""),
                "game_object_name": r.get("game_object_name", ""),
                "active": r.get("game_object_active", ""),
                "anchor_min_x": r.get("anchor_min_x", ""),
                "anchor_min_y": r.get("anchor_min_y", ""),
                "anchor_max_x": r.get("anchor_max_x", ""),
                "anchor_max_y": r.get("anchor_max_y", ""),
                "anchored_pos_x": r.get("anchored_pos_x", ""),
                "anchored_pos_y": r.get("anchored_pos_y", ""),
                "size_delta_x": r.get("size_delta_x", ""),
                "size_delta_y": r.get("size_delta_y", ""),
                "pivot_x": r.get("pivot_x", ""),
                "pivot_y": r.get("pivot_y", ""),
                "local_scale_x": r.get("local_scale_x", ""),
                "local_scale_y": r.get("local_scale_y", ""),
            }
        )

    with ROOT_CHILDREN_CSV.open("w", encoding="utf-8", newline="") as out:
        writer = csv.DictWriter(out, fieldnames=list(children_rows[0].keys()) if children_rows else ["path_id"])
        writer.writeheader()
        writer.writerows(children_rows)

    build = read_json(BUILD_JSON)
    capture = read_json(CAPTURE_JSON)
    click = read_json(CLICK_JSON)
    blocker = read_json(BLOCKER_JSON)
    lua_lines = lua_evidence_lines()

    root_zero = bool(
        root
        and num(root.get("anchor_min_x")) == 0
        and num(root.get("anchor_min_y")) == 0
        and num(root.get("anchor_max_x")) == 0
        and num(root.get("anchor_max_y")) == 0
        and num(root.get("size_delta_x")) == 0
        and num(root.get("size_delta_y")) == 0
    )
    ui_bg = next((r for r in children if r.get("game_object_name") == "UI_bg"), None)
    ui_bg_size = {
        "width": num(ui_bg.get("size_delta_x")) if ui_bg else 0,
        "height": num(ui_bg.get("size_delta_y")) if ui_bg else 0,
    }

    summary = {
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "rule_file": str(BASE.parent / "apk_extracted_ui_restore_rules.txt"),
        "root_rect_id": ROOT_RECT_ID,
        "root_name": ROOT_NAME,
        "root_prefab_rect_is_zero_sized": root_zero,
        "direct_child_count": len(children),
        "runtime_design_width_candidate": 1680,
        "runtime_design_height_candidate": 720,
        "ui_bg_size_delta": ui_bg_size,
        "previous_1280_direction_status": "failed_visual_shape_check",
        "current_coordinate_status": "1680x720_coordinate_basis_preferred_not_final_screen_complete",
        "build": build,
        "capture": capture,
        "click_validation": click,
        "click_blockers": blocker,
        "lua_screen_fit_evidence": lua_lines,
        "outputs": {
            "root_children_csv": str(ROOT_CHILDREN_CSV),
            "summary_json": str(SUMMARY_JSON),
            "markdown": str(MARKDOWN),
        },
    }
    SUMMARY_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    lua_md = "\n".join(f"- `{x['line']}`: `{x['text']}`" for x in lua_lines)
    child_md = "\n".join(
        f"| `{r['game_object_name']}` | `{r['active']}` | `{r['anchor_min_x']},{r['anchor_min_y']}` | `{r['anchor_max_x']},{r['anchor_max_y']}` | `{r['anchored_pos_x']},{r['anchored_pos_y']}` | `{r['size_delta_x']}x{r['size_delta_y']}` |"
        for r in children_rows
    )
    if not child_md:
        child_md = "| | | | | | |"

    md = f"""# MainInterface Coordinate System Rebase

- Generated: `{summary['generated_at']}`
- Rule file: `{summary['rule_file']}`
- Root: `{ROOT_NAME}` / `{ROOT_RECT_ID}`
- Current capture: `{capture.get('capturePath', '')}` `{capture.get('width', '')}x{capture.get('height', '')}`
- Current visible pixels: `{capture.get('visiblePixelCount', '')}`

## Direction Correction

- The earlier `1280x720` direction is marked as `failed_visual_shape_check`.
- The reason is not missing sprites alone. The prefab root is zero-sized in the asset and must be mounted under the runtime UI root before child anchors mean anything.
- `UI_bg` is `1680x720`, and root children use left/right/center anchors around that width.
- Lua clamps runtime logical width with `Screen.width * GameEntry.Instance.StandardHeight / Screen.height`, then `MinWidth` / `MaxWidth`.
- Therefore the current MainInterface coordinate basis is re-centered on `1680x720`.
- This does **not** mean the screen is complete. The hero character is still a runtime Spine/Live2D mount task, and some visible text/state is still default extracted data.

## Lua Screen-Fit Evidence

{lua_md}

## Root Children

| Name | Active | Anchor Min | Anchor Max | Anchored Pos | Size |
|---|---|---|---|---|---|
{child_md}

## Current Verification

| Check | Result |
|---|---:|
| Build RectTransforms | `{build.get('rectTransformCount', '')}` |
| Applied sprites | `{build.get('spriteAppliedCount', '')}` |
| Visual overrides | `{build.get('visualOverrideCount', '')}` |
| Capture size | `{capture.get('width', '')}x{capture.get('height', '')}` |
| Active buttons | `{click.get('activeButtons', '')}` |
| Raycast-clickable buttons | `{click.get('raycastClickableButtons', '')}` |
| Blocked active buttons | `{click.get('raycastBlockedButtons', blocker.get('active_blocked_buttons', ''))}` |
| Invoked click logs | `{click.get('invokedClicks', '')}` |

## Next Restore Work

1. Keep `1680x720` as the MainInterface coordinate candidate until `GameEntry.StandardWidth/Height/MinWidth/MaxWidth` serialized values are recovered.
2. Do not call the screen complete from visible pixel count or button logs.
3. Restore `UI_heroSpine` / `UI_touchSpine` through runtime Spine/Live2D evidence, not by placing `Painting_*.png` atlas textures as UI.
4. Replace default extracted text/state with config/runtime values only when source evidence is mapped.
5. Re-run graphical capture and click validation after each visual step.

## Outputs

- Root children CSV: `{ROOT_CHILDREN_CSV}`
- Summary JSON: `{SUMMARY_JSON}`
- Markdown: `{MARKDOWN}`
"""
    MARKDOWN.write_text(md, encoding="utf-8")
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
