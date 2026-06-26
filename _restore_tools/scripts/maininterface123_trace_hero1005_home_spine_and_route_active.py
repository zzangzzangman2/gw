import csv
import json
from datetime import datetime
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
RESTORE = PROJECT / "Assets" / "RestoreData"
REPORTS = BASE / "reports" / "maininterface"
INDEXES = BASE / "girlswar_merged_extracted" / "indexes"

REFERENCE = Path(r"C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png")
CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_restored_1680x720.png"
LUA = BASE / "girlswar_merged_extracted" / "decoded" / "xlua" / "-6351603197391775840_UI_MainPage_security_xor_raw.lua"
BUILDER = PROJECT / "Assets" / "Editor" / "MainInterfaceSceneBuilder.cs"

OUT_JSON = RESTORE / "maininterface_123_hero1005_home_spine_route_active_trace.json"
OUT_MD = REPORTS / "MAININTERFACE_123_HERO1005_HOME_SPINE_ROUTE_ACTIVE_TRACE_RESULT.md"
OUT_BUNDLE_CSV = REPORTS / "MAININTERFACE_123_hero1005_bundle_assets.csv"
OUT_ROUTE_CSV = REPORTS / "MAININTERFACE_123_route_active_evidence.csv"
TOOL = BASE / "_restore_tools" / "cmd_archive" / "123_TRACE_HERO1005_HOME_SPINE_ROUTE_ACTIVE_STATE.cmd"

RECTS = RESTORE / "maininterface_rects.csv"
SPRITES = RESTORE / "maininterface_sprite_map.csv"
VISUAL_OVERRIDES = RESTORE / "maininterface_visual_overrides.csv"
RAYCAST_OVERRIDES = RESTORE / "maininterface_raycast_overrides.csv"
ROUTE_RECT_OVERRIDES = RESTORE / "maininterface_route_rect_overrides.csv"

TARGET_BUNDLES = {
    "download/roleprefabsandres/paintingprefabandres/1005.assetbundle",
    "download/roleprefabsandres/battleprefabandres/1005.assetbundle",
    "download/roleprefabsandres/rolebigsetpainting/1005.assetbundle",
    "download/roleprefabsandres/paintingsleepprefabandres/1005.assetbundle",
    "download/roleprefabsandres/storyprefabandres/1005_4.assetbundle",
    "download/live2d/1005.assetbundle",
    "download/live2d/1005_ext_prefab.assetbundle",
    "download/live2d/1043.assetbundle",
    "download/live2d/1043_ext_prefab.assetbundle",
    "download/xlualogic/modules/marry.assetbundle",
    "download/xlualogic/modules/herolive2d.assetbundle",
    "download/xlualogic/modules/live2dpreload.assetbundle",
    "download/xlualogic/datanode/datatable/create/live2d.assetbundle",
}

TARGET_RECTS = {
    "UI_MainInterface": "5568884429252053541",
    "UI_bg": "-7723620072473078182",
    "UI_heroSpine": "-5284402592931468190",
    "UI_touchSpine": "718716608411067892",
    "right": "6922878451781464554",
    "node_middle": "9056630568254389742",
    "wanfaWorldNode": "-3820167396480157270",
    "worldwanfaBtn": "3512211464843089861",
    "mian_wanfa_item_1": "51920382737909704",
    "mian_wanfa_item_2": "-3930377403474185176",
    "mian_wanfa_item_3": "1745568030950951925",
    "mian_wanfa_item_4": "7836085562230756963",
}

LUA_RANGES = [
    (103, 130, "OnInit review-only active changes"),
    (1327, 1385, "refreshRightMiddleView and item 3/4 dynamic active state"),
    (1419, 1489, "right-bottom function gates"),
    (1491, 1560, "refreshMiddle normal hero Spine and background path"),
    (1637, 1667, "SetMarryHeroModel Live2D branch"),
    (2896, 2898, "world button click handler"),
]

BUILDER_RANGES = [
    (252, 259, "CanvasScaler"),
    (281, 285, "initial SetActive from RectTransform CSV"),
    (305, 316, "sibling order and rect overrides"),
    (371, 383, "capture rebuilds before screenshot"),
    (504, 510, "ApplyRectRow preserves source localScale"),
    (591, 604, "active overrides"),
    (607, 640, "Image/Sprite application skips empty sprite refs"),
]


def read_csv(path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def iter_csv(path):
    if not path.exists():
        return
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        for row in csv.DictReader(f):
            yield row


def read_lines(path):
    if not path.exists():
        return []
    return path.read_text(encoding="utf-8-sig", errors="replace").splitlines()


def image_stats(path):
    stats = {"path": str(path), "exists": path.exists()}
    if not path.exists():
        return stats
    stats["bytes"] = path.stat().st_size
    try:
        from PIL import Image, ImageChops, ImageStat

        with Image.open(path) as im:
            rgba = im.convert("RGBA")
            stats["size"] = list(rgba.size)
            stat = ImageStat.Stat(rgba.convert("RGB"))
            stats["meanRgb"] = [round(v, 3) for v in stat.mean]
        if REFERENCE.exists() and path.exists():
            with Image.open(REFERENCE) as ref, Image.open(path) as cap:
                ref = ref.convert("RGBA").resize(cap.size)
                cap = cap.convert("RGBA")
                diff = ImageChops.difference(ref, cap).convert("RGB")
                dstat = ImageStat.Stat(diff)
                mean = sum(dstat.mean) / 3.0
                stats["meanAbsDiffVsReference"] = round(mean, 3)
                stats["classification"] = "mismatch" if mean > 35 else "possibly_close"
    except Exception as exc:
        stats["error"] = str(exc)
    return stats


def parent_sibling_index(rects_by_id, row):
    parent = rects_by_id.get(row.get("father_id", ""))
    if not parent:
        return None
    children = [x for x in parent.get("child_ids", "").split(";") if x]
    try:
        return children.index(row.get("path_id", ""))
    except ValueError:
        return None


def collect_rect_state():
    rects = read_csv(RECTS)
    by_id = {r.get("path_id", ""): r for r in rects}
    out = []
    for key, path_id in TARGET_RECTS.items():
        r = by_id.get(path_id, {})
        out.append(
            {
                "key": key,
                "pathId": path_id,
                "name": r.get("game_object_name", ""),
                "gameObjectId": r.get("game_object_id", ""),
                "active": r.get("game_object_active", ""),
                "fatherId": r.get("father_id", ""),
                "siblingIndex": parent_sibling_index(by_id, r) if r else None,
                "anchoredPosition": [r.get("anchored_pos_x", ""), r.get("anchored_pos_y", "")],
                "sizeDelta": [r.get("size_delta_x", ""), r.get("size_delta_y", "")],
                "localScale": [r.get("local_scale_x", ""), r.get("local_scale_y", ""), r.get("local_scale_z", "")],
                "childCount": len([x for x in r.get("child_ids", "").split(";") if x]) if r else 0,
                "missing": not bool(r),
            }
        )
    return out


def collect_sprite_state():
    wanted_names = {"UI_bg", "UI_heroSpine", "UI_touchSpine"}
    out = []
    for r in read_csv(SPRITES):
        if r.get("game_object_name") in wanted_names:
            out.append(
                {
                    "componentPathId": r.get("component_path_id", ""),
                    "gameObjectId": r.get("game_object_id", ""),
                    "name": r.get("game_object_name", ""),
                    "status": r.get("status", ""),
                    "assetPath": r.get("unity_asset_path", ""),
                    "colorA": r.get("color_a", ""),
                    "raycastTarget": r.get("raycast_target", ""),
                    "preserveAspect": r.get("preserve_aspect", ""),
                }
            )
    return out


def collect_override_hits():
    needles = {
        "ui_bg",
        "ui_herospine",
        "ui_touchspine",
        "right",
        "node_middle",
        "wanfaworldnode",
        "worldwanfabtn",
        "mian_wanfa_item_3",
        "mian_wanfa_item_4",
    }
    result = {}
    for label, path in [
        ("visualOverrides", VISUAL_OVERRIDES),
        ("raycastOverrides", RAYCAST_OVERRIDES),
        ("routeRectOverrides", ROUTE_RECT_OVERRIDES),
    ]:
        hits = []
        for row in read_csv(path):
            hay = " ".join(str(v) for v in row.values()).lower()
            if any(n in hay for n in needles):
                hits.append(row)
        result[label] = hits
    return result


def collect_bundle_assets():
    rows = []
    bundle_meta = {
        r.get("bundle", ""): r for r in iter_csv(INDEXES / "assetbundles.csv") if r.get("bundle", "") in TARGET_BUNDLES
    }
    for bundle in sorted(TARGET_BUNDLES):
        meta = bundle_meta.get(bundle, {})
        rows.append(
            {
                "source": "assetbundle",
                "bundle": bundle,
                "pathId": "",
                "type": "",
                "name": "",
                "size": meta.get("size", ""),
                "status": meta.get("status", "missing_from_index"),
                "output": "",
            }
        )

    for version_index in ["versionfile_VersionFile_bytes.csv", "versionfile_CDNVersionFile_bytes.csv"]:
        for row in iter_csv(INDEXES / version_index):
            bundle = row.get("AssetBundleName", "")
            if bundle not in TARGET_BUNDLES:
                continue
            rows.append(
                {
                    "source": version_index.replace(".csv", ""),
                    "bundle": bundle,
                    "pathId": row.get("index", ""),
                    "type": "VersionFile",
                    "name": bundle.rsplit("/", 1)[-1],
                    "size": row.get("Size", ""),
                    "status": "IsFirstData={0}; IsEncrypt={1}; Version={2}; ResOffset={3}".format(
                        row.get("IsFirstData", ""),
                        row.get("IsEncrypt", ""),
                        row.get("Version", ""),
                        row.get("ResOffset", ""),
                    ),
                    "output": "MD5=" + row.get("MD5", ""),
                }
            )

    for row in iter_csv(INDEXES / "unity_textassets.csv"):
        bundle = row.get("bundle", "")
        if bundle not in TARGET_BUNDLES:
            continue
        name = row.get("name", "")
        if ("1005" in name) or ("1043" in name) or name.startswith("Live2d_") or "UI_heroLive2d" in name:
            rows.append(
                {
                    "source": "textasset",
                    "bundle": bundle,
                    "pathId": row.get("path_id", ""),
                    "type": "TextAsset",
                    "name": name,
                    "size": row.get("size", ""),
                    "status": "indexed",
                    "output": row.get("output", ""),
                }
            )

    for row in iter_csv(INDEXES / "unity_images.csv"):
        bundle = row.get("bundle", "")
        if bundle not in TARGET_BUNDLES:
            continue
        name = row.get("name", "")
        if ("1005" in name) or ("1043" in name) or name.startswith("texture_"):
            rows.append(
                {
                    "source": "image",
                    "bundle": bundle,
                    "pathId": row.get("path_id", ""),
                    "type": row.get("type", ""),
                    "name": name,
                    "size": f"{row.get('width', '')}x{row.get('height', '')}",
                    "status": "indexed",
                    "output": row.get("output", ""),
                }
            )
    return rows


def collect_line_ranges(lines, ranges):
    out = []
    for start, end, label in ranges:
        snippets = []
        for line_no in range(start, end + 1):
            if 1 <= line_no <= len(lines):
                snippets.append({"line": line_no, "text": lines[line_no - 1]})
        out.append({"label": label, "start": start, "end": end, "lines": snippets})
    return out


def write_csv(path, rows):
    path.parent.mkdir(parents=True, exist_ok=True)
    keys = sorted({k for row in rows for k in row.keys()})
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=keys)
        writer.writeheader()
        writer.writerows(rows)


def md_table(headers, rows):
    out = ["| " + " | ".join(headers) + " |", "| " + " | ".join("---" for _ in headers) + " |"]
    for row in rows:
        out.append("| " + " | ".join(str(row.get(h, "")).replace("|", "\\|") for h in headers) + " |")
    return "\n".join(out)


def main():
    REPORTS.mkdir(parents=True, exist_ok=True)
    RESTORE.mkdir(parents=True, exist_ok=True)

    capture_stats = image_stats(CAPTURE)
    reference_stats = image_stats(REFERENCE)
    rect_state = collect_rect_state()
    sprite_state = collect_sprite_state()
    override_hits = collect_override_hits()
    bundle_assets = collect_bundle_assets()
    lua_evidence = collect_line_ranges(read_lines(LUA), LUA_RANGES)
    builder_evidence = collect_line_ranges(read_lines(BUILDER), BUILDER_RANGES)

    hero_assets = [
        r for r in bundle_assets
        if (
            r["bundle"] == "download/roleprefabsandres/paintingprefabandres/1005.assetbundle"
            or r["bundle"].startswith("download/live2d/")
            or "UI_heroLive2d_1005" in r["name"]
        )
    ]
    route_rows = [r for r in rect_state if r["key"] in {"right", "node_middle", "wanfaWorldNode", "worldwanfaBtn", "mian_wanfa_item_1", "mian_wanfa_item_2", "mian_wanfa_item_3", "mian_wanfa_item_4"}]

    result = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "verdict": "not_restored_no_visual_patch_applied",
        "reference": reference_stats,
        "capture": capture_stats,
        "rectState": rect_state,
        "spriteState": sprite_state,
        "overrideHits": override_hits,
        "bundleAssets": bundle_assets,
        "luaEvidence": lua_evidence,
        "builderEvidence": builder_evidence,
        "conclusions": [
            "UI_heroSpine is active in RectTransform CSV, but its Image rows are empty_sprite_ref with alpha 0 and there are no prefab children. The character is absent because no runtime Spine/Live2D asset is mounted.",
            "Decoded UI_MainPage normal home branch uses UIUtil.GetPlayerBigSpineAll(heroDid, UI_heroSpine, 'homePara') and then UIUtil.GetPaintingBg(heroDid). For hero/background 1005 this points first to paintingprefabandres/1005, not battleprefabandres/1005.",
            "Decoded UI_MainPage Live2D path is SetMarryHeroModel -> UIUtil.GetPlayerLive2dModel only under isMarry/isSelfMarry. Live2D assets are evidence for the marry branch, not default normal home unless player state evidence proves it.",
            "right/node_middle/wanfaWorldNode/worldwanfaBtn are active in the source prefab rows. Lua evidence only hides mian_wanfa_item_3/4 under review/no-limit/no-act states; no normal-home SetActive evidence hides wanfaWorldNode/worldwanfaBtn.",
            "No evidence-backed hide patch is applied. The next fix should mount the 1005 home Spine runtime on UI_heroSpine and continue looking for real runtime state evidence before changing route cluster active state.",
        ],
        "files": {
            "json": str(OUT_JSON),
            "markdown": str(OUT_MD),
            "bundleCsv": str(OUT_BUNDLE_CSV),
            "routeCsv": str(OUT_ROUTE_CSV),
            "tool": str(TOOL),
        },
    }

    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    write_csv(OUT_BUNDLE_CSV, bundle_assets)
    write_csv(OUT_ROUTE_CSV, route_rows)

    hero_table = [
        {
            "bundle": r["bundle"],
            "source": r["source"],
            "name": r["name"],
            "size": r["size"],
            "status": r["status"],
            "output": r["output"],
        }
        for r in hero_assets[:40]
    ]
    route_table = [
        {
            "key": r["key"],
            "active": r["active"],
            "siblingIndex": r["siblingIndex"],
            "anchored": ",".join(r["anchoredPosition"]),
            "size": ",".join(r["sizeDelta"]),
            "scale": ",".join(r["localScale"]),
            "children": r["childCount"],
        }
        for r in route_rows
    ]
    sprite_table = [
        {
            "name": r["name"],
            "gameObjectId": r["gameObjectId"],
            "status": r["status"],
            "alpha": r["colorA"],
            "asset": r["assetPath"],
        }
        for r in sprite_state
    ]

    lua_summary = [
        {"lines": f"{x['start']}-{x['end']}", "evidence": x["label"]}
        for x in lua_evidence
    ]
    builder_summary = [
        {"lines": f"{x['start']}-{x['end']}", "evidence": x["label"]}
        for x in builder_evidence
    ]

    md = []
    md.append("# MainInterface 123 Hero 1005 Home Spine And Route Active Trace Result\n")
    md.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} KST\n")
    md.append("## Verdict\n")
    md.append("Not restored. `maininterface_restored_1680x720.png` now uses the 1005 night/moon background, but the 1005 character is still absent and the right route/world cluster remains visible.\n")
    md.append("No visual patch was applied in UI123. The evidence supports a hero runtime restoration blocker, not an arbitrary route hide.\n")
    md.append("## Capture Check\n")
    md.append(md_table(["path", "exists", "size", "bytes", "meanAbsDiffVsReference", "classification"], [
        {
            "path": str(REFERENCE),
            "exists": reference_stats.get("exists"),
            "size": reference_stats.get("size", ""),
            "bytes": reference_stats.get("bytes", ""),
            "meanAbsDiffVsReference": "",
            "classification": "",
        },
        {
            "path": str(CAPTURE),
            "exists": capture_stats.get("exists"),
            "size": capture_stats.get("size", ""),
            "bytes": capture_stats.get("bytes", ""),
            "meanAbsDiffVsReference": capture_stats.get("meanAbsDiffVsReference", ""),
            "classification": capture_stats.get("classification", ""),
        },
    ]))
    md.append("\n## Hero Runtime Evidence\n")
    md.append("- `UI_heroSpine` is active in the prefab rows, but has `sizeDelta=0,0`, no child ids, and sprite rows with `empty_sprite_ref` plus alpha `0.0`.")
    md.append("- Decoded `UI_MainPage.refreshMiddle` normal branch calls `UIUtil.GetPlayerBigSpineAll(i, UI_heroSpine, \"homePara\", ...)`, then loads `UI_bg` from `UIUtil.GetPaintingBg(i)`.")
    md.append("- For hero/background 1005, the home Spine candidate is `download/roleprefabsandres/paintingprefabandres/1005.assetbundle`, which contains `Painting_1005.skel`, `Painting_1005.atlas`, `Painting_1005_back.skel`, `Painting_1005_back.atlas`, and the `PaintingBG_1005` image family.")
    md.append("- `battleprefabandres/1005.assetbundle` is indexed, but it is the battle actor bundle. It is not the evidence-backed first choice for `homePara` lobby restoration.")
    md.append("- Live2D evidence is split: `download/live2d/1005.assetbundle` appears in the CDN versionfile but is not present in the current extracted `assetbundles.csv`; `download/live2d/1043.assetbundle` is extracted locally and `UI_heroLive2d_1005` exists under `marry.assetbundle`.")
    md.append("- Even with that Live2D evidence, decoded `UI_MainPage` reaches `SetMarryHeroModel -> UIUtil.GetPlayerLive2dModel` only in the `isMarry/isSelfMarry` branches, not the normal home branch.")
    md.append(md_table(["bundle", "source", "name", "size", "status", "output"], hero_table))
    md.append("\n## Current Hero Sprite Rows\n")
    md.append(md_table(["name", "gameObjectId", "status", "alpha", "asset"], sprite_table))
    md.append("\n## Route Active-State Evidence\n")
    md.append(md_table(["key", "active", "siblingIndex", "anchored", "size", "scale", "children"], route_table))
    md.append("\nDecoded Lua hides or shows `mian_wanfa_item_3/4` based on review mode and `MainPageLimitMgr`, but no normal-home evidence was found that hides `right`, `node_middle`, `wanfaWorldNode`, or `worldwanfaBtn`.")
    md.append("\n## Lua Evidence Map\n")
    md.append(md_table(["lines", "evidence"], lua_summary))
    md.append("\n## Builder Evidence Map\n")
    md.append(md_table(["lines", "evidence"], builder_summary))
    md.append("\nThe current builder now rebuilds before capture and preserves CSV `localScale`. Its sprite path still skips rows with `empty_sprite_ref`, so it cannot create the missing 1005 character until a runtime Spine/Live2D mount path is implemented.")
    md.append("\n## Next Blocker\n")
    md.append("Implement an evidence-backed 1005 home Spine restoration path for `UI_heroSpine`: import/build from `paintingprefabandres/1005` and mount the `Painting_1005` home skeleton with the same `homePara` semantics used by Lua. Route/world cluster deactivation remains blocked until real runtime evidence is found; hiding `wanfaWorldNode/worldwanfaBtn` now would be arbitrary.")
    md.append("\n## Files\n")
    md.append(f"- JSON: `{OUT_JSON}`")
    md.append(f"- Bundle asset CSV: `{OUT_BUNDLE_CSV}`")
    md.append(f"- Route active CSV: `{OUT_ROUTE_CSV}`")
    md.append(f"- Tool: `{TOOL}`")
    md.append(f"- Capture: `{CAPTURE}`")

    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    TOOL.write_text(
        "@echo off\r\n"
        "setlocal\r\n"
        "cd /d C:\\Users\\godho\\Downloads\\girlswar\r\n"
        "py -3 _restore_tools\\scripts\\maininterface123_trace_hero1005_home_spine_and_route_active.py\r\n",
        encoding="utf-8",
    )

    print(f"Wrote {OUT_JSON}")
    print(f"Wrote {OUT_MD}")
    print(f"Wrote {OUT_BUNDLE_CSV}")
    print(f"Wrote {OUT_ROUTE_CSV}")
    print(f"Wrote {TOOL}")


if __name__ == "__main__":
    main()
