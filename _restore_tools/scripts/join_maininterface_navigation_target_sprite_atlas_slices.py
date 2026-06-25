import argparse
import csv
import gzip
import json
from collections import Counter, defaultdict
from datetime import datetime
from pathlib import Path


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY = ROOT / "girlswar_maininterface_unity"
MERGED = ROOT / "girlswar_merged_extracted"
RESTORE = UNITY / "Assets" / "RestoreData"
REPORTS = ROOT / "reports" / "maininterface"

TRACE_JSON = RESTORE / "maininterface_navigation_target_missing_script_sprite_trace.json"
TRACE_CSV = RESTORE / "reports" / "maininterface_navigation_target_missing_script_sprite_trace.csv"
JOIN_JSON = RESTORE / "maininterface_navigation_target_sprite_atlas_slice_join.json"
JOIN_CSV = RESTORE / "reports" / "maininterface_navigation_target_sprite_atlas_slice_join.csv"
CAPTURE_JSON = RESTORE / "maininterface_navigation_target_sprite_atlas_slice_join_capture.json"
CLICK_SUMMARY = RESTORE / "reports" / "maininterface_click_validation_summary.json"
REPORT_MD = REPORTS / "MAININTERFACE_NAVIGATION_TARGET_SPRITE_ATLAS_SLICE_JOIN_RESULT.md"

UNITY_IMAGES = MERGED / "indexes" / "unity_images.csv"
ASSETBUNDLES = MERGED / "indexes" / "assetbundles.csv"
GUILD_PREFAB_STRUCTURE = MERGED / "extracted" / "unity" / "bundles" / "b_12b344b00d675546" / "structure.jsonl.gz"
TOOL = ROOT / "_restore_tools" / "106_JOIN_MAININTERFACE_NAVIGATION_TARGET_SPRITE_ATLAS_SLICES.cmd"


def read_json(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_json(path: Path, data: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def write_csv(path: Path, rows: list[dict[str, object]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow({k: row.get(k, "") for k in fieldnames})


def load_sprite_index() -> dict[str, dict[str, str]]:
    sprites: dict[str, dict[str, str]] = {}
    for row in read_csv(UNITY_IMAGES):
        if row.get("type") == "Sprite":
            sprites[row.get("path_id", "")] = row
    return sprites


def load_clean_bundle_map() -> dict[str, str]:
    result: dict[str, str] = {}
    for row in read_csv(ASSETBUNDLES):
        clean = row.get("clean_slice", "")
        if row.get("status") == "ok" and clean:
            result[row.get("bundle", "")] = str((MERGED / clean).resolve())
    return result


def load_guild_prefab_structure() -> tuple[dict[int, dict], dict[int, str], dict[int, dict], dict[int, list[int]]]:
    objects: dict[int, dict] = {}
    game_objects: dict[int, str] = {}
    rects: dict[int, dict] = {}
    go_components: dict[int, list[int]] = defaultdict(list)
    with gzip.open(GUILD_PREFAB_STRUCTURE, "rt", encoding="utf-8", errors="replace") as f:
        for line in f:
            obj = json.loads(line)
            path_id = int(obj["path_id"])
            typ = obj.get("type", "")
            tree = obj.get("tree", {})
            objects[path_id] = obj
            if typ == "GameObject":
                game_objects[path_id] = tree.get("m_Name", "")
                for component in tree.get("m_Component", []):
                    component_id = component.get("component", {}).get("m_PathID", 0)
                    if component_id:
                        go_components[path_id].append(int(component_id))
            elif typ == "RectTransform":
                rects[path_id] = tree
    return objects, game_objects, rects, go_components


def build_hierarchy_paths(
    game_objects: dict[int, str],
    rects: dict[int, dict],
    go_components: dict[int, list[int]],
    root_name: str,
) -> dict[str, int]:
    root_go = next((pid for pid, name in game_objects.items() if name == root_name), None)
    if root_go is None:
        return {}
    root_rect = next((cid for cid in go_components[root_go] if cid in rects), None)
    if root_rect is None:
        return {}

    path_to_go: dict[str, int] = {}

    def walk(rect_id: int, parent_names: list[str]) -> None:
        tree = rects[rect_id]
        go = int(tree.get("m_GameObject", {}).get("m_PathID", 0))
        current_names = parent_names + [game_objects.get(go, "")]
        path_to_go["/".join(current_names)] = go
        for child in tree.get("m_Children", []):
            child_id = int(child.get("m_PathID", 0))
            if child_id in rects:
                walk(child_id, current_names)

    walk(root_rect, [])
    return path_to_go


def normalize_trace_path(path: str) -> str:
    return path.replace("UI_GuildMain_NavigationPrototype", "UI_GuildMain")


def first_sprite_reference(objects: dict[int, dict], component_ids: list[int]) -> tuple[int, int, int]:
    for component_id in component_ids:
        tree = objects.get(component_id, {}).get("tree", {})
        if "m_Sprite" not in tree:
            continue
        sprite_ref = tree.get("m_Sprite", {})
        return (
            component_id,
            int(sprite_ref.get("m_FileID", 0) or 0),
            int(sprite_ref.get("m_PathID", 0) or 0),
        )
    return 0, 0, 0


def prepare_join() -> dict:
    trace = read_json(TRACE_JSON)
    sprites = load_sprite_index()
    clean_bundles = load_clean_bundle_map()
    objects, game_objects, rects, go_components = load_guild_prefab_structure()
    path_to_go = build_hierarchy_paths(game_objects, rects, go_components, "UI_GuildMain")
    targets = trace.get("targets", [])
    guild = next((t for t in targets if t.get("prefabRootName") == "UI_GuildMain"), {})
    top_areas = guild.get("topWhiteAreas", [])

    rows: list[dict[str, object]] = []
    confirmed_dependency_bundles: dict[str, str] = {}
    unresolved_reasons = Counter()

    for rank, area in enumerate(top_areas, start=1):
        original_path = normalize_trace_path(area.get("hierarchyPath", ""))
        go = path_to_go.get(original_path)
        component_id, file_id, sprite_path_id = first_sprite_reference(objects, go_components.get(go, [])) if go else (0, 0, 0)
        sprite = sprites.get(str(sprite_path_id), {}) if sprite_path_id else {}
        clean_bundle = clean_bundles.get(sprite.get("bundle", ""), "")
        confidence = "unresolved"
        reason = ""
        if not go:
            reason = "original_hierarchy_path_not_found_in_guild_ext_prefabs_dump"
        elif sprite_path_id == 0:
            reason = "original_image_m_Sprite_is_null_or_runtime_bound"
        elif not sprite:
            reason = "serialized_sprite_path_id_not_found_in_unity_images_index"
        elif not clean_bundle or not Path(clean_bundle).exists():
            reason = "sprite_bundle_clean_unityfs_slice_missing"
        else:
            confidence = "confirmed_original_hierarchy_sprite_path_id"
            confirmed_dependency_bundles[sprite["bundle"]] = clean_bundle

        if reason:
            unresolved_reasons[reason] += 1

        rows.append(
            {
                "rank": rank,
                "target": "UI_GuildMain",
                "missing_ref": area.get("spriteReferenceString", ""),
                "trace_hierarchy_path": area.get("hierarchyPath", ""),
                "original_hierarchy_path": original_path,
                "rect_area": area.get("rectArea", ""),
                "original_game_object_path_id": go or "",
                "original_image_component_path_id": component_id or "",
                "serialized_sprite_file_id": file_id if component_id else "",
                "serialized_sprite_path_id": sprite_path_id if component_id else "",
                "sprite_name": sprite.get("name", ""),
                "sprite_bundle": sprite.get("bundle", ""),
                "sprite_width": sprite.get("width", ""),
                "sprite_height": sprite.get("height", ""),
                "sprite_png": str((MERGED / sprite.get("output", "")).resolve()) if sprite.get("output") else "",
                "clean_unityfs_bundle_path": clean_bundle,
                "confidence": confidence,
                "unresolved_reason": reason,
            }
        )

    confirmed_rows = [r for r in rows if r["confidence"] == "confirmed_original_hierarchy_sprite_path_id"]
    resolved_refs = {r["missing_ref"] for r in confirmed_rows if r.get("missing_ref")}
    unresolved_refs = {r["missing_ref"] for r in rows if r["confidence"] != "confirmed_original_hierarchy_sprite_path_id" and r.get("missing_ref")}
    output = {
        "generatedAt": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "step": "MAININTERFACE_NAVIGATION_TARGET_SPRITE_ATLAS_SLICE_JOIN",
        "target": "UI_GuildMain",
        "sourcePrefabBundle": "download/ui/uiprefabandres/guild_ext_prefabs.assetbundle",
        "sourceStructureDump": str(GUILD_PREFAB_STRUCTURE),
        "topWhiteAreaCount": len(top_areas),
        "resolvedTopWhiteAreaCount": len(confirmed_rows),
        "unresolvedTopWhiteAreaCount": len(rows) - len(confirmed_rows),
        "resolvedMissingRefCount": len(resolved_refs),
        "unresolvedMissingRefCount": len(unresolved_refs),
        "appliedSpriteSliceCount": 0,
        "appliedDependencyBundleCount": len(confirmed_dependency_bundles),
        "applicationMode": "load_confirmed_sprite_dependency_bundles_before_prefab_instantiate",
        "wholeAtlasApplied": False,
        "rectTransformModified": False,
        "confirmedDependencyBundles": [
            {"bundle": bundle, "cleanUnityFsBundlePath": path}
            for bundle, path in sorted(confirmed_dependency_bundles.items())
        ],
        "targets": [
            {
                "targetKey": guild.get("targetKey", ""),
                "targetUiForm": guild.get("targetUiForm", ""),
                "prefabRootName": "UI_GuildMain",
                "confirmedDependencyCleanUnityFsBundlePaths": [
                    path for _, path in sorted(confirmed_dependency_bundles.items())
                ],
            }
        ],
        "unresolvedReasons": dict(unresolved_reasons),
        "rows": rows,
    }
    write_json(JOIN_JSON, output)
    write_csv(
        JOIN_CSV,
        rows,
        [
            "rank",
            "target",
            "missing_ref",
            "trace_hierarchy_path",
            "original_hierarchy_path",
            "rect_area",
            "original_game_object_path_id",
            "original_image_component_path_id",
            "serialized_sprite_file_id",
            "serialized_sprite_path_id",
            "sprite_name",
            "sprite_bundle",
            "sprite_width",
            "sprite_height",
            "sprite_png",
            "clean_unityfs_bundle_path",
            "confidence",
            "unresolved_reason",
        ],
    )
    return output


def file_info(path: Path) -> str:
    if not path.exists():
        return "missing"
    return f"{path} ({path.stat().st_size} bytes)"


def write_report() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    join = read_json(JOIN_JSON)
    capture = read_json(CAPTURE_JSON)
    click = read_json(CLICK_SUMMARY)
    trace = read_json(TRACE_JSON)
    rows = read_csv(JOIN_CSV)
    capture_targets = capture.get("targets", [])
    guild_capture = next((t for t in capture_targets if t.get("prefabRootName") == "UI_GuildMain"), {})
    before_guild = next((t for t in trace.get("targets", []) if t.get("prefabRootName") == "UI_GuildMain"), {})
    confirmed = [r for r in rows if r.get("confidence") == "confirmed_original_hierarchy_sprite_path_id"]
    unresolved = [r for r in rows if r.get("confidence") != "confirmed_original_hierarchy_sprite_path_id"]

    lines = [
        "# MainInterface Navigation Target Sprite Atlas Slice Join Result",
        "",
        f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} KST",
        "",
        "## Verdict",
        "",
        "UI_GuildMain top white areas were joined by original prefab hierarchy path to serialized `m_Sprite` PPtr evidence. No coordinate override, fake panel, debug overlay, or whole-atlas Image assignment was used. Confirmed SpriteRes bundles are preloaded so Unity can resolve the original Sprite slices during prefab instantiate.",
        "",
        "## Counts",
        "",
        "| Metric | Count |",
        "| --- | ---: |",
        f"| Top white areas analyzed | `{join.get('topWhiteAreaCount', '')}` |",
        f"| Resolved top white areas | `{join.get('resolvedTopWhiteAreaCount', '')}` |",
        f"| Unresolved top white areas | `{join.get('unresolvedTopWhiteAreaCount', '')}` |",
        f"| Resolved unique missing refs | `{join.get('resolvedMissingRefCount', '')}` |",
        f"| Confirmed dependency bundles | `{join.get('appliedDependencyBundleCount', '')}` |",
        f"| Direct sprite/crop overrides | `{join.get('appliedSpriteSliceCount', 0)}` |",
        "",
        "## Confirmed Sprite Dependencies",
        "",
        "| Bundle | Clean UnityFS path |",
        "| --- | --- |",
    ]
    for bundle in join.get("confirmedDependencyBundles", []):
        lines.append(f"| `{bundle.get('bundle', '')}` | `{bundle.get('cleanUnityFsBundlePath', '')}` |")

    lines.extend(
        [
            "",
            "## UI_GuildMain Top Ref Join",
            "",
            "| Rank | Missing ref | Original path | Sprite | Bundle | Confidence | Reason |",
            "| ---: | --- | --- | --- | --- | --- | --- |",
        ]
    )
    for row in rows[:30]:
        lines.append(
            f"| `{row.get('rank', '')}` | `{row.get('missing_ref', '')}` | "
            f"`{row.get('original_hierarchy_path', '')}` | `{row.get('sprite_name', '')}` "
            f"(`{row.get('serialized_sprite_path_id', '')}`) | `{row.get('sprite_bundle', '')}` | "
            f"`{row.get('confidence', '')}` | `{row.get('unresolved_reason', '')}` |"
        )

    lines.extend(
        [
            "",
            "## Before / After Capture",
            "",
            "| Metric | Before trace | After sprite join |",
            "| --- | ---: | ---: |",
            f"| UI_GuildMain white no-sprite Images | `{before_guild.get('whiteNoSpriteImageCount', '')}` | `{guild_capture.get('whiteNoSpriteImageCount', '')}` |",
            f"| UI_GuildMain missing Image sprites | `{before_guild.get('imageNullSpriteCount', '')}` | `{guild_capture.get('missingImageSpriteCount', '')}` |",
            f"| UI_GuildMain missing script objects | `{before_guild.get('missingScriptObjectCount', '')}` | `{guild_capture.get('missingScriptObjectCount', '')}` |",
            f"| UI_GuildMain capture path | `after_trace_fix` | `{guild_capture.get('capturePath', '')}` |",
            "",
            "## Verification",
            "",
            "| Check | Result |",
            "| --- | --- |",
            f"| Join JSON | `{file_info(JOIN_JSON)}` |",
            f"| Join CSV | `{file_info(JOIN_CSV)}` rows=`{len(rows)}` |",
            f"| After join capture JSON | `{file_info(CAPTURE_JSON)}` |",
            f"| Capture targets | `{capture.get('captureSuccessCount', '')}/{capture.get('targetCount', '')}` success, blank suspicion `{capture.get('blankSuspicionCount', '')}` |",
            f"| Click validation generatedAt | `{click.get('generatedAt', '')}` |",
            f"| Active / clickable / blocked / invoked | `{click.get('activeButtons', '')}` / `{click.get('raycastClickableButtons', '')}` / `{click.get('raycastBlockedButtons', '')}` / `{click.get('invokedClicks', '')}` |",
            f"| Tool | `{TOOL}` |",
            "",
            "## Unresolved Blocker",
            "",
            "Some top white areas have original `m_Sprite` set to null (`m_FileID=0`, `m_PathID=0`), especially runtime-bound character/news nodes. These need target runtime Lua/XLua initialization or script/type reconstruction evidence; they were not guessed.",
            "",
            "## Next Recommendation",
            "",
            "Next: `remaining navigation target sprite joins`",
            "",
            "## Generated Files",
            "",
            f"- `{JOIN_JSON}`",
            f"- `{JOIN_CSV}`",
            f"- `{CAPTURE_JSON}`",
            f"- `{REPORT_MD}`",
        ]
    )
    REPORT_MD.write_text("\n".join(lines), encoding="utf-8")
    print(f"wrote {REPORT_MD}")
    print(
        "resolved_refs={0} applied_dependency_bundles={1} guild_white_before={2} guild_white_after={3}".format(
            join.get("resolvedMissingRefCount", ""),
            join.get("appliedDependencyBundleCount", ""),
            before_guild.get("whiteNoSpriteImageCount", ""),
            guild_capture.get("whiteNoSpriteImageCount", ""),
        )
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prepare", action="store_true")
    parser.add_argument("--report", action="store_true")
    args = parser.parse_args()
    if not args.prepare and not args.report:
        args.prepare = True
        args.report = True
    if args.prepare:
        output = prepare_join()
        print(
            f"prepared {JOIN_JSON} resolvedTop={output['resolvedTopWhiteAreaCount']} "
            f"dependencies={output['appliedDependencyBundleCount']}"
        )
    if args.report:
        write_report()


if __name__ == "__main__":
    main()
