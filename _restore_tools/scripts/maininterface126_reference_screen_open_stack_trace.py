from __future__ import annotations

import csv
import json
import math
import re
from collections import defaultdict
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageStat


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
REPORTS = BASE / "reports" / "maininterface"
RESTORE_REPORTS = PROJECT / "Assets" / "RestoreData" / "reports"
REFERENCE = Path(r"C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png")
UI124_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui124_hero1005_spine_1680x720.png"
UI126_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui126_oldroot_hero1005_candidate_1680x720.png"

RECTS = PROJECT / "Assets" / "RestoreData" / "maininterface_rects.csv"
SPRITES = PROJECT / "Assets" / "RestoreData" / "maininterface_sprite_map.csv"
TEXTS = PROJECT / "Assets" / "RestoreData" / "maininterface_text_components.csv"
BUTTON_HANDLERS = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_button_lua_handler_join.csv"

XLUA_DIR = BASE / "girlswar_merged_extracted" / "decoded" / "xlua"
MAINPAGE = XLUA_DIR / "-6351603197391775840_UI_MainPage_security_xor_raw.lua"
MAINPAGEMGR = XLUA_DIR / "-3138555983938251346_MainPageMgr_security_xor_raw.lua"
LIMITMGR = XLUA_DIR / "-9035189407698220568_MainPageLimitMgr_security_xor_raw.lua"
ACTITEM = XLUA_DIR / "-8694572285188909557_UI_MainPageActItem_security_xor_raw.lua"
FACEACTITEM = XLUA_DIR / "-7919191389644174794_UI_MainPageFaceActItem_security_xor_raw.lua"

OUT_ELEMENTS = REPORTS / "MAININTERFACE_126_reference_element_candidates.csv"
OUT_LUA = REPORTS / "MAININTERFACE_126_lua_open_stack_candidates.csv"
OUT_ROOTS = REPORTS / "MAININTERFACE_126_prefab_root_candidates.csv"
OUT_DIFF_CSV = REPORTS / "MAININTERFACE_126_reference_diff_regions.csv"
OUT_CONTACT = REPORTS / "MAININTERFACE_126_REFERENCE_DIFF_CONTACT.png"
OUT_JSON = RESTORE_REPORTS / "maininterface_126_reference_screen_open_stack_trace.json"
OUT_MD = REPORTS / "MAININTERFACE_126_REFERENCE_SCREEN_OPEN_STACK_AND_PREFAB_ID_TRACE_RESULT.md"
UI126_CLICK_CSV = RESTORE_REPORTS / "maininterface_126_oldroot_click_validation.csv"
UI126_CLICK_JSON = RESTORE_REPORTS / "maininterface_126_oldroot_click_validation_summary.json"

ROOTS = {
    "UI_MainInterface": "5568884429252053541",
    "UI_MainInterface_old": "2475216337245998118",
}

ELEMENTS = {
    "hero_background": ["UI_bg", "UI_heroSpine", "UI_touchSpine", "p_changeBgHero"],
    "top_profile_level": ["bg_juese", "head_yuan150", "btn_head", "bg_jingyan", "bg_guanzhi", "btn_fight"],
    "top_currency": ["UI_currency", "btn_jia", "text_num_gold", "text_num_holy", "im_icon_gold", "im_icon_holy"],
    "right_activity_icon_stack": ["node_act_btn", "btn_act_", "btn_act", "txt_act_name", "btn_shangdian"],
    "right_chat_and_social_stack": ["liaotian", "btn_baiqipao", "p_chat_private", "btn_paihangbang", "btn_haoyou", "btn_youjian", "btn_shangdian"],
    "bottom_menu_buttons": ["node_bottom", "bottom", "rightTopGrid", "toogles", "toggles", "toggle", "btnToggle"],
    "left_story_task_banner": ["node_renwu", "btn_renwu", "node_wuyu", "node_tujian", "huodong3", "leftbannerNode", "btn_download"],
    "route_world_cluster": ["node_middle", "wanfaWorldNode", "worldwanfaBtn", "UI_Main_wanfa_item", "wanfaBtn"],
    "hide_show_mask": ["mask", "btn_jiantou", "btn_yincang", "btn_show", "but_mask"],
}

LUA_KEYWORDS = [
    "UI_MainInterface_old",
    "UI_MainInterface",
    "OpenMainEnterView",
    "OpenUIForm",
    "UI_MainInterface_in",
    "UI_MainInterface_idle",
    "UI_MainInterface_out",
    "refreshRightMiddleView",
    "refreshRightBottomView",
    "refreshRightGoldView",
    "SetLimitPageView",
    "SetActJumpPageView",
    "GetMainInletTopFunc",
    "SetToggleLayoutGroupView",
    "worldwanfaBtn",
    "mian_wanfa_item_",
    "GetPlayerBigSpineAll",
    "GetPaintingBg",
    "homePara",
    "onBtnHideUI",
    "onBtnShow",
    "UI_Adventure",
    "UI_Dock",
]

REGIONS = {
    "full": (0.0, 0.0, 1.0, 1.0),
    "top_bar": (0.0, 0.0, 1.0, 0.18),
    "left_lobby": (0.0, 0.12, 0.35, 0.92),
    "center_hero": (0.18, 0.0, 0.72, 0.92),
    "right_cluster": (0.68, 0.10, 1.0, 0.92),
    "bottom_nav": (0.0, 0.76, 1.0, 1.0),
}


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: list[dict[str, object]], fieldnames: list[str] | None = None) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if not fieldnames:
        fieldnames = list(rows[0].keys()) if rows else ["empty"]
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def build_hierarchy(rect_rows: list[dict[str, str]]) -> tuple[dict[str, dict[str, str]], dict[str, list[dict[str, str]]]]:
    by_path = {row["path_id"]: row for row in rect_rows}
    root_name_by_pid = {}
    hierarchy_by_pid = {}
    depth_by_pid = {}

    def walk(pid: str, root_name: str, prefix: str, depth: int) -> None:
        row = by_path.get(pid)
        if not row:
            return
        path = f"{prefix}/{row['game_object_name']}" if prefix else row["game_object_name"]
        root_name_by_pid[pid] = root_name
        hierarchy_by_pid[pid] = path
        depth_by_pid[pid] = depth
        for child in filter(None, row.get("child_ids", "").split(";")):
            walk(child, root_name, path, depth + 1)

    for root_name, root_pid in ROOTS.items():
        walk(root_pid, root_name, "", 0)

    rows = []
    children = defaultdict(list)
    for row in rect_rows:
        pid = row["path_id"]
        enriched = dict(row)
        enriched["root_name"] = root_name_by_pid.get(pid, "")
        enriched["hierarchy_path"] = hierarchy_by_pid.get(pid, "")
        enriched["depth"] = str(depth_by_pid.get(pid, ""))
        rows.append(enriched)
        children[row.get("father_id", "")].append(enriched)
    return by_path, {r["path_id"]: r for r in rows}, children


def make_lookup(rows: list[dict[str, str]], key: str) -> dict[str, list[dict[str, str]]]:
    out: dict[str, list[dict[str, str]]] = defaultdict(list)
    for row in rows:
        out[row.get(key, "")].append(row)
    return out


def candidate_rows() -> tuple[list[dict[str, object]], list[dict[str, object]]]:
    rect_rows = read_csv(RECTS)
    _, enriched_by_path, _ = build_hierarchy(rect_rows)
    sprite_by_go = make_lookup(read_csv(SPRITES), "game_object_id")
    text_by_go = make_lookup(read_csv(TEXTS), "game_object_id")
    handler_by_go = make_lookup(read_csv(BUTTON_HANDLERS), "button_game_object_id")

    rows = []
    root_rows = []
    for root_name, root_pid in ROOTS.items():
        root_nodes = [row for row in enriched_by_path.values() if row["root_name"] == root_name]
        root_rows.append(
            {
                "rootName": root_name,
                "rootRectId": root_pid,
                "nodeCount": len(root_nodes),
                "activeNodeCount": sum(1 for r in root_nodes if r["game_object_active"] == "True"),
                "hasLuaMainPageComponent": "yes",
                "hasAnimatorUI_MainInterface": "yes",
                "evidence": "UnityPy component trace: both roots contain UI_MainPage.bytes MonoBehaviour and UI_MainInterface Animator controller",
            }
        )

    for row in enriched_by_path.values():
        root_name = row["root_name"]
        if not root_name:
            continue
        path = row["hierarchy_path"]
        haystack = (path + " " + row["game_object_name"]).lower()
        sprite_names = sorted({s.get("sprite_name", "") for s in sprite_by_go.get(row["game_object_id"], []) if s.get("sprite_name", "")})
        text_values = [t.get("text", "") for t in text_by_go.get(row["game_object_id"], []) if t.get("text", "")]
        handlers = [
            f"{h.get('handler_module','')}.{h.get('handler','')}:{h.get('handler_line','')}"
            for h in handler_by_go.get(row["game_object_id"], [])
            if h.get("handler", "")
        ]
        for element, keywords in ELEMENTS.items():
            if not any(keyword.lower() in haystack for keyword in keywords):
                continue
            rows.append(
                {
                    "referenceElement": element,
                    "rootName": root_name,
                    "hierarchyPath": path,
                    "gameObjectName": row["game_object_name"],
                    "gameObjectId": row["game_object_id"],
                    "rectPathId": row["path_id"],
                    "active": row["game_object_active"],
                    "depth": row["depth"],
                    "anchoredPos": f"{row.get('anchored_pos_x','')},{row.get('anchored_pos_y','')}",
                    "sizeDelta": f"{row.get('size_delta_x','')},{row.get('size_delta_y','')}",
                    "localScale": f"{row.get('local_scale_x','')},{row.get('local_scale_y','')},{row.get('local_scale_z','')}",
                    "spriteNames": ";".join(sprite_names[:8]),
                    "texts": ";".join(text_values[:5]),
                    "buttonHandlers": ";".join(handlers[:5]),
                    "candidateReason": reason_for(element, root_name, path),
                }
            )
    return rows, root_rows


def reason_for(element: str, root_name: str, path: str) -> str:
    if root_name == "UI_MainInterface_old" and element in {
        "right_chat_and_social_stack",
        "left_story_task_banner",
        "bottom_menu_buttons",
    }:
        return "strong_reference_layout_candidate_old_root_has_matching_stack"
    if root_name == "UI_MainInterface" and element == "route_world_cluster":
        return "mismatch_cluster_visible_in_current_capture_but_absent_from_reference"
    if root_name == "UI_MainInterface_old" and element == "route_world_cluster":
        return "old_root_has_no_world_route_middle_cluster_match_expected_absence"
    return "prefab_hierarchy_name_sprite_handler_candidate"


def lua_rows() -> list[dict[str, object]]:
    files = [MAINPAGE, MAINPAGEMGR, LIMITMGR, ACTITEM, FACEACTITEM]
    files += sorted(XLUA_DIR.glob("*UI_Adventure*_security_xor_raw.lua"))
    files += sorted(XLUA_DIR.glob("*UI_Dock*_security_xor_raw.lua"))
    rows = []
    seen = set()
    for path in files:
        if not path.exists() or path in seen:
            continue
        seen.add(path)
        lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
        for idx, line in enumerate(lines, start=1):
            if not any(keyword in line for keyword in LUA_KEYWORDS):
                continue
            rows.append(
                {
                    "moduleFile": path.name,
                    "line": idx,
                    "keywordHits": ";".join(k for k in LUA_KEYWORDS if k in line),
                    "snippet": line.strip(),
                    "openStackInterpretation": interpret_lua(path.name, line),
                }
            )
    return rows[:700]


def interpret_lua(name: str, line: str) -> str:
    if "GetPlayerBigSpineAll" in line or "GetPaintingBg" in line or "homePara" in line:
        return "normal_home_hero_background_runtime_branch"
    if "UI_MainInterface_in" in line or "UI_MainInterface_idle" in line or "UI_MainInterface_out" in line:
        return "maininterface_animator_visibility_motion"
    if "OpenUIForm" in line:
        return "button_or_runtime_opens_additional_ui_form_candidate"
    if "worldwanfaBtn" in line or "mian_wanfa_item_" in line or "refreshRightMiddleView" in line:
        return "new_root_route_world_cluster_logic"
    if "UI_Dock" in name:
        return "dock_overlay_or_bottom_flow_candidate"
    if "UI_Adventure" in name:
        return "adventure_overlay_candidate_not_reference_home_default"
    return "mainpage_runtime_state_candidate"


def image(path: Path) -> Image.Image:
    return Image.open(path).convert("RGB")


def crop_norm(img: Image.Image, box: tuple[float, float, float, float]) -> Image.Image:
    w, h = img.size
    return img.crop((round(box[0] * w), round(box[1] * h), round(box[2] * w), round(box[3] * h)))


def mean_abs(a: Image.Image, b: Image.Image) -> float:
    stat = ImageStat.Stat(ImageChops.difference(a, b))
    return float(sum(stat.mean) / (3 * 255.0))


def rms(a: Image.Image, b: Image.Image) -> float:
    stat = ImageStat.Stat(ImageChops.difference(a, b))
    return float(math.sqrt(sum(v * v for v in stat.rms) / 3.0) / 255.0)


def changed(a: Image.Image, b: Image.Image, threshold: int = 30) -> float:
    diff = ImageChops.difference(a, b)
    total = diff.width * diff.height
    count = sum(1 for px in diff.getdata() if max(px) >= threshold)
    return count / total if total else 0.0


def corr(a: Image.Image, b: Image.Image) -> float:
    pa = list(a.getdata())
    pb = list(b.getdata())
    step = max(1, len(pa) // 200000)
    va, vb = [], []
    for p, q in zip(pa[::step], pb[::step]):
        va.extend(p)
        vb.extend(q)
    ma = sum(va) / len(va)
    mb = sum(vb) / len(vb)
    num = sum((x - ma) * (y - mb) for x, y in zip(va, vb))
    da = math.sqrt(sum((x - ma) ** 2 for x in va))
    db = math.sqrt(sum((y - mb) ** 2 for y in vb))
    return 0.0 if da == 0 or db == 0 else num / (da * db)


def diff_rows() -> list[dict[str, object]]:
    ref_original = image(REFERENCE)
    rows = []
    for label, path in [("ui124_new_root", UI124_CAPTURE), ("ui126_old_root_candidate", UI126_CAPTURE)]:
        if not path.exists():
            continue
        cap = image(path)
        ref = ref_original.resize(cap.size, Image.Resampling.LANCZOS)
        for region, box in REGIONS.items():
            a, b = crop_norm(ref, box), crop_norm(cap, box)
            rows.append(
                {
                    "captureLabel": label,
                    "region": region,
                    "meanAbsDiff": round(mean_abs(a, b), 6),
                    "rmsDiff": round(rms(a, b), 6),
                    "changedPixelRatio30": round(changed(a, b), 6),
                    "pixelCorrelation": round(corr(a, b), 6),
                    "capturePath": str(path),
                }
            )
    return rows


def make_contact() -> None:
    ref = image(REFERENCE)
    panels = []
    for label, path in [("reference", REFERENCE), ("UI124 new-root", UI124_CAPTURE), ("UI126 old-root candidate", UI126_CAPTURE)]:
        if not path.exists():
            continue
        img = image(path)
        if label != "reference":
            img = img.resize(ref.size, Image.Resampling.LANCZOS)
        panel = img.resize((560, 240), Image.Resampling.LANCZOS)
        draw = ImageDraw.Draw(panel)
        draw.rectangle((0, 0, 560, 32), fill=(0, 0, 0))
        draw.text((10, 9), label, fill=(255, 255, 255))
        panels.append(panel)
    contact = Image.new("RGB", (560 * len(panels), 240), (0, 0, 0))
    for i, panel in enumerate(panels):
        contact.paste(panel, (560 * i, 0))
    OUT_CONTACT.parent.mkdir(parents=True, exist_ok=True)
    contact.save(OUT_CONTACT)


def read_json(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def blocked_click_rows() -> list[dict]:
    if not UI126_CLICK_CSV.exists():
        return []
    rows: list[dict] = []
    with UI126_CLICK_CSV.open("r", encoding="utf-8-sig", newline="") as f:
        for row in csv.DictReader(f):
            if (
                row.get("activeInHierarchy") == "True"
                and row.get("interactable") == "True"
                and row.get("raycastClickable") == "False"
            ):
                rows.append(row)
    return rows


def main() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    RESTORE_REPORTS.mkdir(parents=True, exist_ok=True)

    elements, roots = candidate_rows()
    lua = lua_rows()
    diffs = diff_rows()
    click_summary = read_json(UI126_CLICK_JSON)
    blocked_clicks = blocked_click_rows()
    make_contact()

    write_csv(OUT_ELEMENTS, elements)
    write_csv(OUT_ROOTS, roots)
    write_csv(OUT_LUA, lua)
    write_csv(OUT_DIFF_CSV, diffs)

    summary = {
        "generatedAt": "2026-06-26",
        "restoredClaim": False,
        "reference": str(REFERENCE),
        "ui124Capture": str(UI124_CAPTURE),
        "ui126OldRootCandidateCapture": str(UI126_CAPTURE),
        "contactSheet": str(OUT_CONTACT),
        "ui126OldRootClickSummary": click_summary,
        "ui126OldRootBlockedClicks": blocked_clicks,
        "rootCandidates": roots,
        "conclusions": [
            "Reference is unlikely to be the current UI124 new-root-only reconstruction because current root includes the route/world node_middle cluster absent from the reference.",
            "The original prefab contains a second root UI_MainInterface_old with the same UI_MainPage Lua component and UI_MainInterface Animator controller.",
            "UI_MainInterface_old has hierarchy matches for reference right chat/social stack, left story/task/banner stack, and bottom/navigation stack, and does not expose the new-root node_middle/wanfaWorldNode route cluster.",
            "UI126 old-root candidate capture confirms the old-root layout family is closer structurally, but it is not restored: UI_bg remains inactive/black, activity placeholders and missing runtime data remain visible, and pixel diff is still high.",
            "No source-backed patch is applied to hide zhuye_di1/zhuye_bian or the new-root route cluster in the production/restored scene.",
        ],
        "nextBlockers": [
            "Determine the original runtime selection rule between UI_MainInterface and UI_MainInterface_old roots. Both roots carry UI_MainPage.bytes and the same Animator controller.",
            "Resolve old-root UI_bg active/runtime LoadSpriteWithFullPath behavior for PaintingBG_1005 without forcing a coordinate-only or fake background patch.",
            "Trace ActMgr/UI_MainPageActItem runtime data for which right activity icons should be instantiated/active in the reference account state.",
            "Map old-root bottom button sprites/text/handlers more completely before using it as the main restore root.",
            "Resolve the UI126 old-root click/layer blocker: btn_discord center is topped by right/node_act_btn/btn_act_12 in the candidate scene.",
        ],
    }
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    best_by_region = {}
    for row in diffs:
        key = row["region"]
        current = best_by_region.get(key)
        if current is None or row["meanAbsDiff"] < current["meanAbsDiff"]:
            best_by_region[key] = row

    md = [
        "# MAININTERFACE_126_REFERENCE_SCREEN_OPEN_STACK_AND_PREFAB_ID_TRACE_RESULT",
        "",
        "## Verdict",
        "",
        "Restored claim remains `false`. UI126 identifies `UI_MainInterface_old` as a strong original prefab/open-stack candidate for the reference screen, but the old-root candidate capture is still not a match.",
        "",
        "## Key Evidence",
        "",
        "- `UI_MainInterface_old` and `UI_MainInterface` both contain the `UI_MainPage.bytes` Lua component and the `UI_MainInterface` Animator controller.",
        "- The current new-root reconstruction contains `right/node_middle/wanfaWorldNode/worldwanfaBtn`; reference does not show that route/world cluster.",
        "- `UI_MainInterface_old` has matching families for right chat/social buttons, right activity icon stack, left task/story/banner nodes, profile/currency clusters, and bottom navigation.",
        "- UI126 old-root candidate was captured with the real UI124 Hero1005 SkeletonGraphic asset path; no whole `Painting_1005.png` Image was used.",
        "",
        "## Click Validation",
        "",
        f"- old-root candidate total/active/clickable/blocked: `{click_summary.get('totalButtons', '')} / {click_summary.get('activeButtons', '')} / {click_summary.get('raycastClickableButtons', '')} / {click_summary.get('raycastBlockedButtons', '')}`",
        f"- click CSV: `{UI126_CLICK_CSV}`",
        f"- click JSON: `{UI126_CLICK_JSON}`",
    ]
    if blocked_clicks:
        md.append("- active blocked click evidence:")
        for row in blocked_clicks[:10]:
            md.append(f"  - `{row.get('buttonName', '')}` top=`{row.get('raycastTopObject', '')}`")
    md.extend(
        [
        "",
        "## Diff Summary",
        "",
        "| capture | region | mean abs diff | rms diff | changed >=30 | correlation |",
        "| --- | --- | ---: | ---: | ---: | ---: |",
        ]
    )
    for row in diffs:
        md.append(
            f"| `{row['captureLabel']}` | `{row['region']}` | `{row['meanAbsDiff']}` | `{row['rmsDiff']}` | `{row['changedPixelRatio30']}` | `{row['pixelCorrelation']}` |"
        )
    md.extend(
        [
            "",
            "## Files",
            "",
            f"- element candidates: `{OUT_ELEMENTS}`",
            f"- Lua/open-stack candidates: `{OUT_LUA}`",
            f"- prefab root candidates: `{OUT_ROOTS}`",
            f"- diff regions: `{OUT_DIFF_CSV}`",
            f"- old-root click CSV: `{UI126_CLICK_CSV}`",
            f"- old-root click JSON: `{UI126_CLICK_JSON}`",
            f"- contact sheet: `{OUT_CONTACT}`",
            f"- JSON: `{OUT_JSON}`",
            "",
            "## Patch Decision",
            "",
            "No production/restored-scene patch was applied. The only Unity patch is a separate old-root candidate capture scene/tool plus a builder overload that preserves the default root behavior.",
        ]
    )
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps(summary, ensure_ascii=True, indent=2))


if __name__ == "__main__":
    main()
