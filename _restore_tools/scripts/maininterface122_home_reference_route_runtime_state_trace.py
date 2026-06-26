import csv
import json
from datetime import datetime
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
RESTORE = PROJECT / "Assets" / "RestoreData"
REPORTS = BASE / "reports" / "maininterface"

REFERENCE = Path(r"C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png")
ROUTE_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_route_spine_runtime_ui_material_bound_1680x720.png"
HOME_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_restored_1680x720.png"

RECTS = RESTORE / "maininterface_rects.csv"
RAYCAST_OVERRIDES = RESTORE / "maininterface_raycast_overrides.csv"
VISUAL_OVERRIDES = RESTORE / "maininterface_visual_overrides.csv"
ROUTE_RECT_OVERRIDES = RESTORE / "maininterface_route_rect_overrides.csv"
SPRITES = RESTORE / "maininterface_sprite_map.csv"
TMP_DETAILS = RESTORE / "maininterface_text_tmp_details.csv"
CLICK_JSON = RESTORE / "reports" / "maininterface_click_validation_summary.json"
UI121_JSON = RESTORE / "maininterface_121_route_skeletongraphic_canvasrenderer_texture_handoff_clipping_zong1.json"
LUA = BASE / "girlswar_merged_extracted" / "decoded" / "xlua" / "-6351603197391775840_UI_MainPage_security_xor_raw.lua"
BUILDER = PROJECT / "Assets" / "Editor" / "MainInterfaceSceneBuilder.cs"

OUT_JSON = RESTORE / "maininterface_122_home_reference_route_runtime_state_trace.json"
OUT_MD = REPORTS / "MAININTERFACE_122_HOME_REFERENCE_ROUTE_RUNTIME_STATE_TRACE_RESULT.md"
TOOL = BASE / "_restore_tools" / "cmd_archive" / "122_TRACE_HOME_REFERENCE_ROUTE_RUNTIME_STATE.cmd"


PATH_IDS = {
    "UI_MainInterface": "5568884429252053541",
    "UI_bg": "-7723620072473078182",
    "UI_heroSpine": "-5284402592931468190",
    "UI_touchSpine": "718716608411067892",
    "right": "6922878451781464554",
    "node_middle": "9056630568254389742",
    "wanfaWorldNode": "-3820167396480157270",
    "worldwanfaBtn": "3512211464843089861",
    "spine_diqiu": "-1766545527926586392",
    "left": "-7709903567246479490",
    "middle": "8271973229136916334",
    "mask": "-9138204023542992015",
    "bg_dibu": "8482476106785833996",
}


def read_csv(path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def read_json(path):
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_lines(path):
    if not path.exists():
        return []
    return path.read_text(encoding="utf-8-sig", errors="replace").splitlines()


def image_stats(path):
    stats = {
        "path": str(path),
        "exists": path.exists(),
        "width": 0,
        "height": 0,
        "bytes": path.stat().st_size if path.exists() else 0,
    }
    if not path.exists():
        return stats
    try:
        from PIL import Image, ImageStat

        with Image.open(path) as im:
            rgba = im.convert("RGBA")
            stats["width"], stats["height"] = rgba.size
            alpha = rgba.getchannel("A")
            alpha_stat = ImageStat.Stat(alpha)
            alpha_hist = alpha.histogram()
            visible = sum(alpha_hist[1:])
            stats["visiblePixelRatio"] = round(visible / (rgba.size[0] * rgba.size[1]), 6)
            stats["meanAlpha"] = round(alpha_stat.mean[0], 4)
            rgb = rgba.convert("RGB")
            stat = ImageStat.Stat(rgb)
            stats["meanRgb"] = [round(v, 3) for v in stat.mean]
    except Exception as exc:
        stats["error"] = str(exc)
    return stats


def compare_images(reference, capture):
    out = {
        "reference": str(reference),
        "capture": str(capture),
        "canCompare": False,
    }
    if not reference.exists() or not capture.exists():
        out["reason"] = "missing_image"
        return out
    try:
        from PIL import Image, ImageChops, ImageStat

        with Image.open(reference) as ref, Image.open(capture) as cap:
            ref_rgba = ref.convert("RGBA").resize(cap.size)
            cap_rgba = cap.convert("RGBA")
            diff = ImageChops.difference(ref_rgba, cap_rgba).convert("RGB")
            stat = ImageStat.Stat(diff)
            mean = sum(stat.mean) / 3.0
            rms = sum(v * v for v in stat.rms) ** 0.5 / 3.0
            out.update(
                {
                    "canCompare": True,
                    "referenceSize": list(ref.size),
                    "captureSize": list(cap.size),
                    "meanAbsDiff": round(mean, 3),
                    "rmsDiff": round(rms, 3),
                    "classification": "mismatch" if mean > 35 else "possibly_close",
                }
            )
    except Exception as exc:
        out["reason"] = str(exc)
    return out


def row_by_path(rows):
    return {r.get("path_id", ""): r for r in rows}


def find_rect(rows, name, path_id):
    by_id = row_by_path(rows)
    r = by_id.get(path_id, {})
    if r:
        return {
            "key": name,
            "pathId": path_id,
            "gameObjectId": r.get("game_object_id", ""),
            "name": r.get("game_object_name", ""),
            "active": r.get("game_object_active", ""),
            "fatherId": r.get("father_id", ""),
            "anchoredPosition": [r.get("anchored_pos_x", ""), r.get("anchored_pos_y", "")],
            "sizeDelta": [r.get("size_delta_x", ""), r.get("size_delta_y", "")],
            "localScale": [r.get("local_scale_x", ""), r.get("local_scale_y", ""), r.get("local_scale_z", "")],
            "childIds": [x for x in r.get("child_ids", "").split(";") if x],
        }
    return {"key": name, "pathId": path_id, "missing": True}


def sibling_index(rects, path_id):
    by_id = row_by_path(rects)
    row = by_id.get(path_id)
    if not row:
        return None
    parent = by_id.get(row.get("father_id", ""))
    if not parent:
        return None
    children = [x for x in parent.get("child_ids", "").split(";") if x]
    try:
        return children.index(path_id)
    except ValueError:
        return None


def collect_prefab_state(rects):
    rows = []
    for name, path_id in PATH_IDS.items():
        item = find_rect(rects, name, path_id)
        item["siblingIndex"] = sibling_index(rects, path_id)
        rows.append(item)
    return rows


def collect_overrides(path, needles):
    rows = read_csv(path)
    hits = []
    for row in rows:
        hay = " ".join(str(row.get(k, "")) for k in row.keys()).lower()
        if any(n.lower() in hay for n in needles):
            hits.append(row)
    return hits


def collect_sprite_state(rows):
    hits = []
    wanted_go = {"-1457103517121630268", "6569245046781814939", "-1874286104444283317"}
    wanted_names = {"UI_bg", "UI_heroSpine", "UI_touchSpine"}
    for r in rows:
        if r.get("game_object_id") in wanted_go or r.get("game_object_name") in wanted_names:
            hits.append(
                {
                    "componentPathId": r.get("component_path_id", ""),
                    "gameObjectId": r.get("game_object_id", ""),
                    "name": r.get("game_object_name", ""),
                    "status": r.get("status", ""),
                    "assetPath": r.get("unity_asset_path", ""),
                    "colorA": r.get("color_a", ""),
                    "raycastTarget": r.get("raycast_target", ""),
                    "imageType": r.get("image_type", ""),
                }
            )
    return hits


def lua_line_hits(lines, ranges):
    hits = []
    for start, end, label in ranges:
        snippets = []
        for idx in range(start, min(end, len(lines)) + 1):
            snippets.append({"line": idx, "text": lines[idx - 1]})
        hits.append({"label": label, "start": start, "end": end, "lines": snippets})
    return hits


def builder_hits(lines):
    wanted = {
        "canvas_scaler": range(252, 260),
        "initial_active": range(281, 286),
        "sibling_order": range(305, 314),
        "active_overrides": range(592, 604),
        "root_scale_fallback": range(488, 511),
        "tmp_details": range(1687, 1738),
    }
    hits = []
    for label, line_range in wanted.items():
        snippets = []
        for idx in line_range:
            if 1 <= idx <= len(lines):
                snippets.append({"line": idx, "text": lines[idx - 1]})
        hits.append({"label": label, "lines": snippets})
    return hits


def summarize_ui121(data):
    clips = data.get("clipRows") or []
    textures = data.get("textureRows") or []
    zhuye_preclip = [
        r for r in clips
        if r.get("attachmentName") in {"zhuye_di1", "zhuye_bian"} and not r.get("clippingActiveAtAttachment")
    ]
    clipped = [r for r in clips if r.get("clippingActiveAtAttachment")]
    return {
        "status": data.get("status", ""),
        "decision": data.get("decision", ""),
        "nextBlocker": data.get("nextBlocker", ""),
        "clipRows": len(clips),
        "clippedRows": len(clipped),
        "preClipZhuyeRows": len(zhuye_preclip),
        "textureRows": len(textures),
    }


def root_cmd_counts():
    return {
        "rootCmds": sorted(p.name for p in BASE.glob("*.cmd")),
        "directRestoreToolsCmds": sorted(p.name for p in (BASE / "_restore_tools").glob("*.cmd")),
    }


def write_report(result):
    REPORTS.mkdir(parents=True, exist_ok=True)
    md = []
    md.append("# MainInterface 122 Home Reference Route Runtime State Trace Result")
    md.append("")
    md.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} KST")
    md.append("")
    md.append("## Verdict")
    md.append("")
    md.append("Not restored. The actual reference is a character lobby/home screen, while the current captures are route/world-cluster state over a castle background.")
    md.append("")
    md.append("No evidence-backed visual patch was applied in UI122. Hiding `wanfaWorldNode`, `worldwanfaBtn`, `zhuye_di1`, or `zhuye_bian` would be an arbitrary visual match because decoded `UI_MainPage` does not provide normal-home SetActive evidence that disables the world button, and UI121 confirms `zhuye_di1/zhuye_bian` are pre-clipping original attachments.")
    md.append("")
    md.append("## Image Comparison")
    md.append("")
    md.append("| image | exists | size | bytes | notes |")
    md.append("| --- | ---: | --- | ---: | --- |")
    for item in (result["referenceImage"], result["homeCapture"], result["routeCapture"]):
        size = f"{item.get('width', 0)}x{item.get('height', 0)}"
        notes = item.get("error", "")
        if item.get("meanRgb"):
            notes = "meanRgb=" + ",".join(str(v) for v in item["meanRgb"])
        md.append(f"| `{item['path']}` | `{item.get('exists')}` | `{size}` | `{item.get('bytes', 0)}` | `{notes}` |")
    md.append("")
    for comp in result["imageComparisons"]:
        md.append(f"- `{Path(comp['capture']).name}` vs reference: `{comp.get('classification', comp.get('reason', ''))}`, meanAbsDiff=`{comp.get('meanAbsDiff', '')}`, rmsDiff=`{comp.get('rmsDiff', '')}`.")
    md.append("")
    md.append("## Active-State Evidence")
    md.append("")
    md.append("| key | active | sibling | father | anchored | size | scale | children |")
    md.append("| --- | --- | ---: | --- | --- | --- | --- | ---: |")
    for row in result["prefabState"]:
        md.append(
            f"| `{row.get('key')}` | `{row.get('active', '')}` | `{row.get('siblingIndex', '')}` | `{row.get('fatherId', '')}` | "
            f"`{','.join(row.get('anchoredPosition', []))}` | `{','.join(row.get('sizeDelta', []))}` | "
            f"`{','.join(row.get('localScale', []))}` | `{len(row.get('childIds', []))}` |"
        )
    md.append("")
    md.append("The CSV prefab state has `right/node_middle/wanfaWorldNode/worldwanfaBtn/spine_diqiu` active. `MainInterfaceSceneBuilder` preserves `row.active` first, then applies only the override CSV. The current override CSV does not target these route owners for deactivation.")
    md.append("")
    md.append("## Lua Evidence")
    md.append("")
    md.append("| lines | meaning |")
    md.append("| --- | --- |")
    md.append("| `103-125` | `OnInit` wires right/left buttons and only hides `mian_wanfa_item_3/4` in review mode; no normal-home hide for `wanfaWorldNode/worldwanfaBtn`. |")
    md.append("| `1327-1385` | `refreshRightMiddleView`, `SetLimitPageView`, and `SetActJumpPageView` populate items 1/2 and conditionally hide/show items 3/4. |")
    md.append("| `1419-1489` | `SetFuncShowStatus` gates bottom toggles by function unlock; this supports runtime active-state dependency, not static prefab success. |")
    md.append("| `1491-1560` | `refreshMiddle` chooses the player hero, mounts hero Spine/Live2D, and loads `UI_bg` from `UIUtil.GetPaintingBg(heroId)`. |")
    md.append("| `2896-2897` | `onBtnWorld` jumps to idle/world; it is a click handler, not default route activation evidence. |")
    md.append("")
    md.append("## Builder/Material Checks")
    md.append("")
    md.append("- Canvas/CanvasScaler: builder creates ScreenSpaceOverlay and ScaleWithScreenSize 1680x720, match 0.5.")
    md.append("- Sibling order: builder replays each CSV parent `child_ids` order. The route cluster is active because the source rows and route visual overrides are active, not because of an observed sibling-order bug.")
    md.append("- TMP: builder loads TMP detail rows including font size, auto-size, material, spacing, wrapping, and color. TMP mismatch remains secondary to the wrong route/home state.")
    md.append("- Mask/stencil/clipping: UI121 says `zhuye_di1/zhuye_bian` are pre-clipping and `zong1` clips later attachments such as `diqiu/yun/yun2`; no evidence supports hiding zhuye.")
    md.append("")
    md.append("## Runtime Gaps")
    md.append("")
    for row in result["spriteState"]:
        md.append(f"- `{row['name']}` `{row['gameObjectId']}`: status=`{row['status']}`, asset=`{row['assetPath']}`, alpha=`{row['colorA']}`.")
    md.append("")
    md.append("## Next Blocker")
    md.append("")
    md.append("Reconstruct or simulate the original `UI_MainPage` normal-home runtime pass from evidence: player hero selection, `UIUtil.GetPaintingBg(heroId)`, `UIUtil.GetPlayerBigSpineAll/GetPlayerLive2dModel`, and GameFunction/MainPageLimitMgr active-state results. Until that exists, the current static/route capture must remain failed and should not be judged against the character lobby reference as restored.")
    md.append("")
    md.append("## Files")
    md.append("")
    md.append(f"- JSON: `{OUT_JSON}`")
    md.append(f"- Tool: `{TOOL}`")
    md.append(f"- Reference: `{REFERENCE}`")
    md.append(f"- Current route capture: `{ROUTE_CAPTURE}`")
    md.append(f"- Current home capture: `{HOME_CAPTURE}`")
    md.append("")
    md.append("## Command Layout")
    md.append("")
    md.append(f"- root CMDs: `{len(result['cmdCounts']['rootCmds'])}` {result['cmdCounts']['rootCmds']}")
    md.append(f"- `_restore_tools` direct CMDs: `{len(result['cmdCounts']['directRestoreToolsCmds'])}` {result['cmdCounts']['directRestoreToolsCmds']}")
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")


def main():
    rects = read_csv(RECTS)
    result = {
        "status": "maininterface_122_home_reference_route_runtime_state_trace_complete",
        "generatedAt": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "referenceImage": image_stats(REFERENCE),
        "homeCapture": image_stats(HOME_CAPTURE),
        "routeCapture": image_stats(ROUTE_CAPTURE),
        "imageComparisons": [
            compare_images(REFERENCE, HOME_CAPTURE),
            compare_images(REFERENCE, ROUTE_CAPTURE),
        ],
        "prefabState": collect_prefab_state(rects),
        "routeRelatedRaycastOverrides": collect_overrides(RAYCAST_OVERRIDES, ["wanfa", "world", "route", "zhuye", "diqiu", "node_middle"]),
        "routeRelatedVisualOverrides": collect_overrides(VISUAL_OVERRIDES, ["wanfa", "world", "route", "zhuye", "diqiu", "node_middle"]),
        "routeRelatedRectOverrides": collect_overrides(ROUTE_RECT_OVERRIDES, ["wanfa", "world", "route", "entry"]),
        "spriteState": collect_sprite_state(read_csv(SPRITES)),
        "tmpRowCount": len(read_csv(TMP_DETAILS)),
        "luaEvidence": lua_line_hits(
            read_lines(LUA),
            [
                (103, 125, "OnInit SetActive review-only route item hides"),
                (1327, 1385, "right-middle route item runtime population"),
                (1419, 1489, "function-gated bottom/right active state"),
                (1491, 1560, "hero/background home runtime refresh"),
                (2896, 2897, "world button click handler only"),
            ],
        ),
        "builderEvidence": builder_hits(read_lines(BUILDER)),
        "ui121": summarize_ui121(read_json(UI121_JSON)),
        "clickValidation": read_json(CLICK_JSON),
        "visualFixApplied": False,
        "visualFixReason": "No decoded Lua or prefab evidence supports hiding route owners or zhuye attachments for normal home state.",
        "nextBlocker": "evidence-backed UI_MainPage normal-home runtime reconstruction, including hero background/spine and GameFunction/MainPageLimitMgr active-state pass",
        "cmdCounts": root_cmd_counts(),
    }
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(result)
    print(f"[GirlsWarRestore] UI122 trace complete: {OUT_MD}")
    print(f"[GirlsWarRestore] UI122 JSON: {OUT_JSON}")


if __name__ == "__main__":
    main()
