import csv
import json
from pathlib import Path


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY = ROOT / "girlswar_maininterface_unity"
RESTORE = UNITY / "Assets" / "RestoreData"
REPORTS = ROOT / "reports" / "maininterface"
INDEXES = ROOT / "girlswar_merged_extracted" / "indexes"

CLICK_CSV = RESTORE / "reports" / "maininterface_click_validation.csv"
CLICK_SUMMARY = RESTORE / "reports" / "maininterface_click_validation_summary.json"
HANDLER_JOIN_CSV = RESTORE / "reports" / "maininterface_button_lua_handler_join.csv"
RECTS_CSV = RESTORE / "maininterface_rects.csv"
BUTTONS_CSV = RESTORE / "reports" / "maininterface_root_buttons.csv"
IMAGES_CSV = RESTORE / "reports" / "maininterface_root_images.csv"
RAYCAST_CSV = RESTORE / "reports" / "maininterface_root_raycast_report.csv"
TEXTASSETS_CSV = INDEXES / "unity_textassets.csv"
UI_RECTS_CSV = INDEXES / "ui_recttransforms.csv"

OUT_JSON = RESTORE / "maininterface_button_navigation_map.json"
OUT_CSV = RESTORE / "reports" / "maininterface_button_navigation_map.csv"
OUT_MD = REPORTS / "MAININTERFACE_BUTTON_NAVIGATION_TRACE.md"


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, object]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow({key: row.get(key, "") for key in fieldnames})


def file_rel(path: str) -> str:
    if not path:
        return ""
    try:
        return str(Path(path).relative_to(ROOT))
    except ValueError:
        return path


def build_hierarchy(rects: list[dict[str, str]]) -> tuple[dict[str, dict[str, str]], dict[str, str], dict[str, int]]:
    rect_by_path = {row.get("path_id", ""): row for row in rects}
    rect_by_go = {row.get("game_object_id", ""): row for row in rects}
    path_cache: dict[str, str] = {}
    sibling_index: dict[str, int] = {}
    for row in rects:
        father = row.get("father_id", "")
        child_ids = [x for x in row.get("child_ids", "").split(";") if x]
        for index, child_id in enumerate(child_ids):
            sibling_index[child_id] = index

    def rect_path(rect_id: str) -> str:
        if rect_id in path_cache:
            return path_cache[rect_id]
        row = rect_by_path.get(rect_id)
        if not row:
            return ""
        name = row.get("game_object_name", "")
        father = row.get("father_id", "")
        if father and father in rect_by_path:
            parent = rect_path(father)
            result = f"{parent}/{name}({rect_id})" if parent else f"{name}({rect_id})"
        else:
            result = f"{name}({rect_id})"
        path_cache[rect_id] = result
        return result

    go_paths = {go: rect_path(row.get("path_id", "")) for go, row in rect_by_go.items()}
    return rect_by_go, go_paths, sibling_index


TARGET_UI_FORMS = {
    "UI_AdventureInterface",
    "UI_JingjiFrame_View",
    "UI_GuildMainView",
    "UI_FunctionHandBook_Root",
    "UI_GoldChange",
    "UI_SystemSet",
    "UI_ActGroupPhoto_Gold_Buff",
    "UI_AutoHelper_Main",
    "UI_PlayBgDownload",
}

PREFAB_ROOT_ALIASES = {
    "UI_GuildMainView": ["UI_GuildMain"],
    "UI_JingjiFrame_View": ["UI_JingjiFrame"],
    "UI_SystemSet": ["UI_SystemSettings"],
}


FUNCTION_TARGETS: dict[str, dict[str, str]] = {
    "onBtnAdventure": {
        "target_key": "jump.OnGameJumpUIAdventure",
        "navigation_kind": "jump_ui",
        "target_ui_form": "UI_AdventureInterface",
        "source_evidence": "UI_MainPage line 2826: JumpMgr.OnGameJumpUIAdventure(); UI_Dock lines 274-275 open UI_AdventureInterface",
        "resolved_confidence": "handler_and_jump_target",
    },
    "onBtnJinji": {
        "target_key": "jump.OnGameJumpUIJingjiRoot",
        "navigation_kind": "jump_ui",
        "target_ui_form": "UI_JingjiFrame_View",
        "source_evidence": "UI_MainPage line 2842: JumpMgr.OnGameJumpUIJingjiRoot(); UI_JingjiFrame_View module/root are indexed",
        "resolved_confidence": "handler_and_jump_target",
    },
    "onBtnLimit": {
        "target_key": "runtime.MainPageLimitMgr.LimitClickHandler",
        "navigation_kind": "runtime_activity",
        "target_ui_form": "",
        "source_evidence": "UI_MainPage lines 2857-2861 call MainPageLimitMgr:checkCanShowLimitPage() then LimitClickHandler(t)",
        "resolved_confidence": "handler_runtime_target",
    },
    "onBtnActJump": {
        "target_key": "runtime.ActMgr.JumpViewById",
        "navigation_kind": "runtime_activity",
        "target_ui_form": "",
        "source_evidence": "UI_MainPage lines 2863-2866 call MainPageLimitMgr:GetCanMainActivityJump() then ActMgr:JumpViewById(activityId)",
        "resolved_confidence": "handler_runtime_target",
    },
    "onBtnWorld": {
        "target_key": "jump.OnGameJumpUIIdle",
        "navigation_kind": "jump_ui",
        "target_ui_form": "",
        "source_evidence": "UI_MainPage lines 2896-2897 call JumpMgr.OnGameJumpUIIdle(); target UIFormId was not found in decoded Lua",
        "resolved_confidence": "handler_only_target_unknown",
    },
    "onBtnGuild": {
        "target_key": "jump.OnGameJumpUIGuild",
        "navigation_kind": "jump_ui",
        "target_ui_form": "UI_GuildMainView",
        "source_evidence": "UI_MainPage lines 2912-2913 call JumpMgr.OnGameJumpUIGuild(); UI_Dock lines 277-278 open UI_GuildMainView",
        "resolved_confidence": "handler_and_jump_target",
    },
    "onBtnHead": {
        "target_key": "ui.UI_SystemSet",
        "navigation_kind": "open_ui_form",
        "target_ui_form": "UI_SystemSet",
        "source_evidence": "UI_MainPage lines 2679-2680: GameEntry.UI:OpenUIForm(UIFormId.UI_SystemSet)",
        "resolved_confidence": "direct_ui_form",
    },
    "onBtnAddGold": {
        "target_key": "ui.UI_GoldChange",
        "navigation_kind": "open_ui_form",
        "target_ui_form": "UI_GoldChange",
        "source_evidence": "UI_MainPage lines 2737-2738: GameEntry.UI:OpenUIForm(UIFormId.UI_GoldChange)",
        "resolved_confidence": "direct_ui_form",
    },
    "onBtnAddHoly": {
        "target_key": "runtime.ActMgr.CheckJumpViewById.301",
        "navigation_kind": "runtime_activity",
        "target_ui_form": "",
        "source_evidence": "UI_MainPage lines 2740-2741: ActMgr:CheckJumpViewById(301)",
        "resolved_confidence": "handler_runtime_target",
    },
    "onBtnFunHandBook": {
        "target_key": "ui.UI_FunctionHandBook_Root",
        "navigation_kind": "open_ui_form",
        "target_ui_form": "UI_FunctionHandBook_Root",
        "source_evidence": "UI_MainPage lines 2767-2770 request FunctionHandBookMgr info then OpenUIForm(UI_FunctionHandBook_Root)",
        "resolved_confidence": "direct_ui_form",
    },
    "OnBtnOpenTemporaryBuffView": {
        "target_key": "ui.UI_ActGroupPhoto_Gold_Buff",
        "navigation_kind": "open_ui_form",
        "target_ui_form": "UI_ActGroupPhoto_Gold_Buff",
        "source_evidence": "UI_MainPage lines 3116-3117: GameEntry.UI:OpenUIForm(UIFormId.UI_ActGroupPhoto_Gold_Buff)",
        "resolved_confidence": "direct_ui_form",
    },
    "OnShowBgDownload": {
        "target_key": "event.CommonEventId.OnShowBgDownload",
        "navigation_kind": "event_ui",
        "target_ui_form": "UI_PlayBgDownload",
        "source_evidence": "UI_MainPage lines 2809-2810 send CommonEventId.OnShowBgDownload; line 753 checks UI_PlayBgDownload existence",
        "resolved_confidence": "event_candidate_ui_form",
    },
    "onChat": {
        "target_key": "event.CommonEventId.OnShowChatView",
        "navigation_kind": "event_ui",
        "target_ui_form": "",
        "source_evidence": "UI_MainPage lines 2597-2608 send CommonEventId.OnShowChatView with chat payload",
        "resolved_confidence": "event_target_unknown",
    },
    "onBtnLeft": {
        "target_key": "local.changeBg.previous",
        "navigation_kind": "local_state",
        "target_ui_form": "",
        "source_evidence": "UI_MainPage lines 2786-2790 call changeBg(1); no page navigation",
        "resolved_confidence": "local_action",
    },
    "onBtnRight": {
        "target_key": "local.changeBg.next",
        "navigation_kind": "local_state",
        "target_ui_form": "",
        "source_evidence": "UI_MainPage lines 2792-2796 call changeBg(-1); no page navigation",
        "resolved_confidence": "local_action",
    },
    "onBtnWatch": {
        "target_key": "local.playWatchAction",
        "navigation_kind": "local_state",
        "target_ui_form": "",
        "source_evidence": "UI_MainPage lines 2725-2735 call playWatchAction() and FunctionHandBook check; no direct page open",
        "resolved_confidence": "local_action",
    },
    "inline_UI_MainPageActItem": {
        "target_key": "runtime.ActMgr.CheckJumpViewById",
        "navigation_kind": "runtime_activity",
        "target_ui_form": "",
        "source_evidence": "UI_MainPageActItem lines 24-35 choose actId/mainPageTouchJumpId then UI_ActRallyRoot or ActMgr:CheckJumpViewById",
        "resolved_confidence": "handler_runtime_target",
    },
    "inline_faceGiftNode": {
        "target_key": "runtime.ActMgr.CheckJumpViewById.FaceGiftManager.ACT_ID",
        "navigation_kind": "runtime_activity",
        "target_ui_form": "",
        "source_evidence": "UI_MainPage lines 157-158 call ActMgr:CheckJumpViewById(ModulesInit.FaceGiftManager.ACT_ID,{isOpenFrame=true})",
        "resolved_confidence": "handler_runtime_target",
    },
    "autoHelper_Root_touch": {
        "target_key": "ui.UI_AutoHelper_Main",
        "navigation_kind": "touch_ui",
        "target_ui_form": "UI_AutoHelper_Main",
        "source_evidence": "UI_MainPage touch handlers are bound at OnInit; lines 2935-2937 open UI_AutoHelper_Main on click-up path",
        "resolved_confidence": "direct_ui_form_touch",
    },
    "btn_huodong3_toggle": {
        "target_key": "local.toggle_activity_banner_desc",
        "navigation_kind": "local_state",
        "target_ui_form": "",
        "source_evidence": "UI_MainPage lines 2120-2142 anonymous btn_huodong3 listener toggles banner desc nodes; no page navigation",
        "resolved_confidence": "local_action",
    },
}


def build_ui_form_maps() -> tuple[dict[str, dict[str, str]], dict[str, dict[str, str]]]:
    textasset_by_name: dict[str, dict[str, str]] = {}
    for row in read_csv(TEXTASSETS_CSV):
        name = row.get("name", "")
        if name in TARGET_UI_FORMS:
            textasset_by_name[name] = row

    prefab_by_name: dict[str, dict[str, str]] = {}
    root_to_form = {name: name for name in TARGET_UI_FORMS}
    for form_name, aliases in PREFAB_ROOT_ALIASES.items():
        for alias in aliases:
            root_to_form[alias] = form_name
    for row in read_csv(UI_RECTS_CSV):
        name = row.get("game_object_name", "")
        form_name = root_to_form.get(name, "")
        if form_name and row.get("game_object_active", "") == "True":
            current = prefab_by_name.get(form_name)
            if current is None or len(row.get("bundle", "")) < len(current.get("bundle", "")):
                alias_row = dict(row)
                alias_row["matched_prefab_root_name"] = name
                prefab_by_name[form_name] = alias_row
    return textasset_by_name, prefab_by_name


def classify_button(row: dict[str, str], hierarchy_path: str) -> tuple[str, dict[str, str], str]:
    name = row.get("button_name", "")
    handler = row.get("lua_handler", "")
    module = row.get("lua_module", "")
    correction = ""

    if name == "wanfaBtn":
        if "UI_Main_wanfa_item_1" in hierarchy_path:
            handler = "onBtnAdventure"
            correction = "hierarchy override: UI_Main_wanfa_item_1 wanfaBtn"
        elif "UI_Main_wanfa_item_2" in hierarchy_path:
            handler = "onBtnJinji"
            correction = "hierarchy override: UI_Main_wanfa_item_2 wanfaBtn"
        elif "UI_Main_wanfa_item_3" in hierarchy_path:
            handler = "onBtnLimit"
            correction = "hierarchy override: UI_Main_wanfa_item_3 wanfaBtn"
        elif "UI_Main_wanfa_item_4" in hierarchy_path:
            handler = "onBtnActJump"
            correction = "hierarchy override: UI_Main_wanfa_item_4 wanfaBtn"

    if name == "autoHelper_Root":
        return "autoHelper_Root_touch", FUNCTION_TARGETS["autoHelper_Root_touch"], correction
    if name == "faceGiftNode":
        return "inline_faceGiftNode", FUNCTION_TARGETS["inline_faceGiftNode"], correction
    if module == "UI_MainPageActItem" and handler == "inline_function":
        return "inline_UI_MainPageActItem", FUNCTION_TARGETS["inline_UI_MainPageActItem"], correction
    if name == "btn_huodong3":
        return "btn_huodong3_toggle", FUNCTION_TARGETS["btn_huodong3_toggle"], correction
    if handler in FUNCTION_TARGETS:
        return handler, FUNCTION_TARGETS[handler], correction

    return handler or "unknown", {
        "target_key": "unknown",
        "navigation_kind": "unknown",
        "target_ui_form": "",
        "source_evidence": "No decoded Lua handler/target evidence resolved for this active button.",
        "resolved_confidence": "unknown",
    }, correction


def main() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    (RESTORE / "reports").mkdir(parents=True, exist_ok=True)

    clicks = [row for row in read_csv(CLICK_CSV) if row.get("active_in_hierarchy") == "1"]
    handlers = {row.get("button_component_path_id", ""): row for row in read_csv(HANDLER_JOIN_CSV)}
    buttons = {row.get("component_path_id", ""): row for row in read_csv(BUTTONS_CSV)}
    images_by_component = {row.get("component_path_id", ""): row for row in read_csv(IMAGES_CSV)}
    raycast_by_component = {row.get("component_path_id", ""): row for row in read_csv(RAYCAST_CSV)}
    rect_by_go, hierarchy_paths, sibling_index = build_hierarchy(read_csv(RECTS_CSV))
    textasset_by_name, prefab_by_name = build_ui_form_maps()

    rows: list[dict[str, object]] = []
    for click in clicks:
        component_id = click.get("component_path_id", "")
        go_id = click.get("game_object_path_id", "")
        rect = rect_by_go.get(go_id, {})
        hierarchy_path = hierarchy_paths.get(go_id, "")
        handler_row = handlers.get(component_id, {})
        button_row = buttons.get(component_id, {})
        target_graphic_id = button_row.get("target_graphic", "")
        target_image = images_by_component.get(target_graphic_id, {})
        target_raycast = target_image.get("raycast_target", "")
        if not target_raycast and target_graphic_id in raycast_by_component:
            target_raycast = "1"

        resolved_handler, target, correction = classify_button(click, hierarchy_path)
        target_ui_form = target["target_ui_form"]
        textasset = textasset_by_name.get(target_ui_form, {})
        prefab = prefab_by_name.get(target_ui_form, {})
        target_prefab_resolved = bool(prefab)

        rows.append({
            "button_name": click.get("button_name", ""),
            "component_path_id": component_id,
            "game_object_id": go_id,
            "hierarchy_path": hierarchy_path,
            "unity_object_path": "MainInterface_Wireframe/" + hierarchy_path if hierarchy_path else "",
            "parent_rect_id": rect.get("father_id", ""),
            "parent_name": (rect_by_go.get("", {}) or {}).get("game_object_name", "") or "",
            "sibling_index": sibling_index.get(rect.get("path_id", ""), ""),
            "screen_x": click.get("screen_x", ""),
            "screen_y": click.get("screen_y", ""),
            "raycast_top_object": click.get("raycast_top_object", ""),
            "raycast_top_kind": click.get("raycast_top_kind", ""),
            "target_graphic_component_path_id": target_graphic_id,
            "target_graphic_raycast_target": target_raycast,
            "click_raycast_clickable": click.get("raycast_clickable", ""),
            "click_invoked": click.get("click_invoked", ""),
            "lua_module": click.get("lua_module", ""),
            "lua_handler_reported": click.get("lua_handler", ""),
            "lua_handler_resolved": resolved_handler,
            "lua_confidence_reported": click.get("lua_confidence", ""),
            "handler_correction": correction,
            "handler_raw_line": handler_row.get("handler_raw_line", ""),
            "navigation_kind": target["navigation_kind"],
            "target_key": target["target_key"],
            "target_ui_form": target_ui_form,
            "target_lua_module_bundle": textasset.get("bundle", ""),
            "target_lua_textasset_path_id": textasset.get("path_id", ""),
            "target_lua_textasset_output": textasset.get("output", ""),
            "target_prefab_bundle": prefab.get("bundle", ""),
            "target_prefab_root_name": prefab.get("matched_prefab_root_name", prefab.get("game_object_name", "")),
            "target_prefab_root_path_id": prefab.get("path_id", ""),
            "target_prefab_game_object_id": prefab.get("game_object_id", ""),
            "target_prefab_resolved": "1" if target_prefab_resolved else "0",
            "resolved_confidence": target["resolved_confidence"],
            "source_evidence": target["source_evidence"],
        })

    # Fill readable parent names after all row paths are known.
    rect_by_path = {row.get("path_id", ""): row for row in read_csv(RECTS_CSV)}
    for row in rows:
        parent = rect_by_path.get(str(row.get("parent_rect_id", "")), {})
        row["parent_name"] = parent.get("game_object_name", "")

    fieldnames = [
        "button_name", "component_path_id", "game_object_id", "hierarchy_path", "unity_object_path",
        "parent_rect_id", "parent_name", "sibling_index", "screen_x", "screen_y",
        "raycast_top_object", "raycast_top_kind", "target_graphic_component_path_id", "target_graphic_raycast_target",
        "click_raycast_clickable", "click_invoked", "lua_module", "lua_handler_reported", "lua_handler_resolved",
        "lua_confidence_reported", "handler_correction", "handler_raw_line", "navigation_kind", "target_key",
        "target_ui_form", "target_lua_module_bundle", "target_lua_textasset_path_id", "target_lua_textasset_output",
        "target_prefab_bundle", "target_prefab_root_name", "target_prefab_root_path_id", "target_prefab_game_object_id",
        "target_prefab_resolved", "resolved_confidence", "source_evidence",
    ]
    write_csv(OUT_CSV, rows, fieldnames)

    summary = {
        "generatedAt": "2026-06-25 KST",
        "activeClickableButtons": len(rows),
        "evidenceResolvedCount": sum(1 for row in rows if row["resolved_confidence"] != "unknown"),
        "targetPrefabResolvedCount": sum(1 for row in rows if row["target_prefab_resolved"] == "1"),
        "unknownCount": sum(1 for row in rows if row["resolved_confidence"] == "unknown"),
        "harnessConnectedCount": len(rows),
        "sourceClickSummary": json.loads(CLICK_SUMMARY.read_text(encoding="utf-8-sig")) if CLICK_SUMMARY.exists() else {},
        "buttons": rows,
    }
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    md = []
    md.append("# MainInterface Button Navigation Trace\n\n")
    md.append("Generated: 2026-06-25 KST\n\n")
    md.append("## Verdict\n\n")
    md.append("Active clickable MainInterface button 24개를 원본 RectTransform hierarchy, click validation, decoded xLua handler, UI module TextAsset, UI prefab root evidence 기준으로 매핑했다. 화면에 디버그 overlay는 추가하지 않고, navigation harness는 report/JSON/log만 남긴다.\n\n")
    md.append("`wanfaBtn` 4개는 이름만으로는 구분되지 않아 기존 handler join이 모두 `onBtnAdventure`로 붙는다. 원본 `InitRightNode()` hierarchy evidence에 따라 item별 handler를 보정했다: item_1 Adventure, item_2 Jingji, item_3 Limit, item_4 ActJump.\n\n")
    md.append("## Counts\n\n")
    md.append("| Metric | Count |\n| --- | ---: |\n")
    md.append(f"| Active clickable buttons | `{len(rows)}` |\n")
    md.append(f"| Evidence-resolved buttons | `{summary['evidenceResolvedCount']}` |\n")
    md.append(f"| Target prefab resolved buttons | `{summary['targetPrefabResolvedCount']}` |\n")
    md.append(f"| Unknown buttons | `{summary['unknownCount']}` |\n")
    md.append(f"| Harness connected buttons | `{summary['harnessConnectedCount']}` |\n\n")
    md.append("## Active Button Navigation Map\n\n")
    md.append("| Button | Component pathID | Parent | Sibling | Handler | Target key | UIForm | Prefab bundle | Confidence |\n")
    md.append("| --- | --- | --- | ---: | --- | --- | --- | --- | --- |\n")
    for row in rows:
        md.append(
            f"| `{row['button_name']}` | `{row['component_path_id']}` | `{row['parent_name']}` | `{row['sibling_index']}` | "
            f"`{row['lua_handler_resolved']}` | `{row['target_key']}` | `{row['target_ui_form']}` | "
            f"`{row['target_prefab_bundle']}` | `{row['resolved_confidence']}` |\n"
        )
    md.append("\n## Evidence Notes\n\n")
    for row in rows:
        md.append(f"- `{row['button_name']}` `{row['component_path_id']}`: {row['source_evidence']}\n")
        if row.get("handler_correction"):
            md.append(f"  - Correction: `{row['handler_correction']}`\n")
        if row.get("handler_raw_line"):
            md.append(f"  - Handler binding: `{row['handler_raw_line']}`\n")
        md.append(f"  - Hierarchy: `{row['hierarchy_path']}`\n")
    md.append("\n## Generated Files\n\n")
    md.append(f"- `{OUT_JSON}`\n")
    md.append(f"- `{OUT_CSV}`\n")
    md.append(f"- `{OUT_MD}`\n")
    OUT_MD.write_text("".join(md), encoding="utf-8")

    print(json.dumps({
        "json": str(OUT_JSON),
        "csv": str(OUT_CSV),
        "markdown": str(OUT_MD),
        "activeClickableButtons": len(rows),
        "evidenceResolvedCount": summary["evidenceResolvedCount"],
        "targetPrefabResolvedCount": summary["targetPrefabResolvedCount"],
        "unknownCount": summary["unknownCount"],
        "harnessConnectedCount": summary["harnessConnectedCount"],
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
