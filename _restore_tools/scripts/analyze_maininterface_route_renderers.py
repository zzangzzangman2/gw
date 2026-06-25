from __future__ import annotations

import csv
import gzip
import json
import os
import shutil
from collections import defaultdict
from pathlib import Path

try:
    from PIL import Image
except Exception:  # pragma: no cover
    Image = None


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY = ROOT / "girlswar_maininterface_unity"
RESTORE = UNITY / "Assets" / "RestoreData"
REPORTS = ROOT / "reports" / "maininterface"
MERGED = ROOT / "girlswar_merged_extracted"
INDEXES = MERGED / "indexes"
EXTRACTED = MERGED / "extracted" / "unity" / "bundles"

MAIN_BUNDLE = "download/ui/uiprefabandres/maininterface.assetbundle"
MAIN_EXPORT = EXTRACTED / "b_c3b1e8926fc41b4c" / "structure.jsonl.gz"

TRACE_JSON = RESTORE / "reports" / "maininterface_route_renderer_asset_trace.json"
TRACE_CSV = RESTORE / "reports" / "maininterface_route_renderer_asset_trace.csv"
RESOURCE_CSV = RESTORE / "reports" / "maininterface_route_renderer_resources.csv"
PARTICLE_CSV = RESTORE / "reports" / "maininterface_route_renderer_particles.csv"
MD_REPORT = REPORTS / "MAININTERFACE_ROUTE_RENDERER_ASSET_TRACE.md"
FALLBACK_DIR = RESTORE / "route_renderer_fallbacks"
VISUAL_OVERRIDES = RESTORE / "maininterface_visual_overrides.csv"
CLICK_SUMMARY = RESTORE / "reports" / "maininterface_click_validation_summary.json"
CAPTURE_PNG = UNITY / "Assets" / "RestoreCaptures" / "maininterface_restored_1680x720.png"

ROUTE_NODES_CSV = RESTORE / "reports" / "maininterface_route_cluster_nodes.csv"
RECTS_CSV = RESTORE / "maininterface_rects.csv"
COMPONENTS_CSV = RESTORE / "maininterface_components.csv"
EXT_DEPS_CSV = RESTORE / "maininterface_external_dependencies.csv"

WORLD_GO = "2331390164297400090"
WORLD_BTN_RT = "3512211464843089861"
SPINE_DIQIU_GO = "-18476541444226972"
SPINE_DIQIU_RT = "-1766545527926586392"
SPINE_XIAOREN_GO = "-2079722989211931163"
SPINE_XIAOREN_RT = "3375689855543054311"


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


def load_jsonl_gz(path: Path) -> dict[str, dict]:
    result: dict[str, dict] = {}
    if not path.exists():
        return result
    with gzip.open(path, "rt", encoding="utf-8", errors="replace") as f:
        for line in f:
            if not line.strip():
                continue
            obj = json.loads(line)
            result[str(obj["path_id"])] = obj
    return result


def ref_path_id(value) -> str:
    if isinstance(value, dict):
        return str(value.get("m_PathID", ""))
    return ""


def ref_file_id(value) -> str:
    if isinstance(value, dict):
        return str(value.get("m_FileID", ""))
    return ""


def vec2(value) -> str:
    if not isinstance(value, dict):
        return ""
    return f'{value.get("x", 0)},{value.get("y", 0)}'


def vec3(value) -> str:
    if not isinstance(value, dict):
        return ""
    return f'{value.get("x", 0)},{value.get("y", 0)},{value.get("z", 0)}'


def file_rel(path: Path) -> str:
    try:
        return str(path.relative_to(ROOT))
    except ValueError:
        return str(path)


def extracted_path(value: str) -> Path:
    if not value:
        return Path()
    path = Path(value)
    if path.is_absolute():
        return path
    if value.replace("\\", "/").startswith("extracted/"):
        return MERGED / value
    return ROOT / value


def load_export_map() -> dict[str, Path]:
    rows = read_csv(INDEXES / "unity_bundle_export_map.csv")
    result: dict[str, Path] = {}
    for row in rows:
        export_dir = row.get("export_dir", "")
        if export_dir:
            result[row.get("bundle", "")] = MERGED / export_dir
    return result


def index_by_bundle_pid(path: Path) -> dict[tuple[str, str], dict[str, str]]:
    result = {}
    for row in read_csv(path):
        result[(row.get("bundle", ""), row.get("path_id", ""))] = row
    return result


def index_images_by_bundle_name() -> dict[tuple[str, str], dict[str, str]]:
    result = {}
    for row in read_csv(INDEXES / "unity_images.csv"):
        result[(row.get("bundle", ""), row.get("name", ""))] = row
    return result


def parse_spine_atlas(path: Path) -> tuple[str, dict[str, dict[str, object]]]:
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    page = lines[0].strip() if lines else ""
    regions: dict[str, dict[str, object]] = {}
    current = None
    for line in lines[1:]:
        stripped = line.strip()
        if not stripped:
            continue
        if ":" not in stripped:
            current = stripped
            regions[current] = {}
            continue
        if current is None:
            continue
        key, value = stripped.split(":", 1)
        key = key.strip()
        value = value.strip()
        if key == "bounds":
            parts = [int(float(x.strip())) for x in value.split(",")]
            regions[current]["bounds"] = parts
        elif key == "offsets":
            regions[current]["offsets"] = [int(float(x.strip())) for x in value.split(",")]
        else:
            regions[current][key] = value
    return page, regions


def image_for_atlas_page(images_by_bundle_name: dict[tuple[str, str], dict[str, str]], bundle: str, page: str) -> dict[str, str] | None:
    names = []
    raw = page.strip().lstrip("\ufeff")
    if raw:
        names.append(Path(raw).stem)
        names.append(raw.replace(".png", "").replace(".PNG", ""))
    for name in names:
        row = images_by_bundle_name.get((bundle, name))
        if row:
            return row
    return None


def ensure_region_png(src: Path, dst: Path, bounds: list[int]) -> bool:
    if Image is None or not src.exists():
        return False
    dst.parent.mkdir(parents=True, exist_ok=True)
    x, y, w, h = bounds
    with Image.open(src) as im:
        cropped = im.crop((x, y, x + w, y + h))
        cropped.save(dst)
    return True


FALLBACK_VISUAL_FIELDS = [
    "target_kind",
    "component_path_id",
    "game_object_id",
    "parent_game_object_id",
    "create_child_name",
    "game_object_name",
    "sprite_asset_path",
    "color_r",
    "color_g",
    "color_b",
    "color_a",
    "preserve_aspect",
    "image_type",
    "raycast_target",
    "anchored_pos_x",
    "anchored_pos_y",
    "size_delta_x",
    "size_delta_y",
    "local_scale_x",
    "local_scale_y",
    "local_scale_z",
    "reason",
]


def update_visual_override_layers(region_assets: dict[str, str]) -> list[dict[str, str]]:
    rows = read_csv(VISUAL_OVERRIDES)
    rows = [row for row in rows if not row.get("target_kind", "").startswith("RouteRendererFallback")]

    layer_specs = [
        (
            "zhuye_di1",
            "route_fallback_zhuye_di1",
            "253",
            "253",
            "original worldwanfaBtn RectTransform is 253x253; Spine_shijieanniu atlas region zhuye_di1 is 253x253 and is the matching base disk/frame layer",
        ),
        (
            "diqiu",
            "route_fallback_diqiu",
            "253",
            "253",
            "original active child spine_diqiu is a SkeletonGraphic under worldwanfaBtn; atlas region diqiu is the globe attachment, normalized into the 253x253 worldwanfaBtn rect until Spine runtime transforms are restored",
        ),
        (
            "zhuye_bian",
            "route_fallback_zhuye_bian",
            "238",
            "238",
            "Spine_shijieanniu atlas region zhuye_bian is the 238x238 border/rim layer from the same world button skeleton; centered under worldwanfaBtn so route text siblings remain above it",
        ),
    ]
    applied_rows: list[dict[str, str]] = []
    for region, child_name, width, height, reason in layer_specs:
        sprite_asset_path = region_assets.get(region)
        if not sprite_asset_path:
            continue
        row = {
            "target_kind": "RouteRendererFallbackLayer",
            "component_path_id": "",
            "game_object_id": "",
            "parent_game_object_id": WORLD_GO,
            "create_child_name": child_name,
            "game_object_name": f"worldwanfaBtn/{child_name}",
            "sprite_asset_path": sprite_asset_path,
            "color_r": "1",
            "color_g": "1",
            "color_b": "1",
            "color_a": "1",
            "preserve_aspect": "1",
            "image_type": "0",
            "raycast_target": "0",
            "anchored_pos_x": "0",
            "anchored_pos_y": "0",
            "size_delta_x": width,
            "size_delta_y": height,
            "local_scale_x": "1",
            "local_scale_y": "1",
            "local_scale_z": "1",
            "reason": "route renderer multi-layer fallback: " + reason,
        }
        rows.append(row)
        applied_rows.append(row)

    write_csv(VISUAL_OVERRIDES, rows, FALLBACK_VISUAL_FIELDS)
    return applied_rows


def main() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    (RESTORE / "reports").mkdir(parents=True, exist_ok=True)
    FALLBACK_DIR.mkdir(parents=True, exist_ok=True)

    ext_deps = {row["file_id"]: row for row in read_csv(EXT_DEPS_CSV)}
    export_map = load_export_map()
    textassets = index_by_bundle_pid(INDEXES / "unity_textassets.csv")
    images_by_bundle_name = index_images_by_bundle_name()
    images_by_bundle_pid = index_by_bundle_pid(INDEXES / "unity_images.csv")

    main_objects = load_jsonl_gz(MAIN_EXPORT)
    game_objects = {pid: obj for pid, obj in main_objects.items() if obj.get("type") == "GameObject"}
    by_go_components: dict[str, list[dict]] = defaultdict(list)
    for obj in main_objects.values():
        tree = obj.get("tree", {})
        go = ref_path_id(tree.get("m_GameObject")) if isinstance(tree, dict) else ""
        if go:
            by_go_components[go].append(obj)

    route_nodes = read_csv(ROUTE_NODES_CSV)
    route_ids = {row.get("game_object_id", "") for row in route_nodes}
    route_names = {row.get("game_object_id", ""): row.get("name", "") for row in route_nodes}
    route_paths = {row.get("game_object_id", ""): row.get("hierarchy_path", "") for row in route_nodes}
    rect_by_go = {row.get("game_object_id", ""): row for row in route_nodes}

    focus_go_ids = {SPINE_DIQIU_GO, SPINE_XIAOREN_GO}
    for row in route_nodes:
        name = row.get("name", "")
        path = row.get("hierarchy_path", "")
        if name == "un_MainInterface_fire" or name.startswith("Renderer"):
            if "wanfaWorldNode" in path or "UI_Main_wanfa_item_" in path:
                focus_go_ids.add(row.get("game_object_id", ""))

    trace_rows: list[dict[str, object]] = []
    particle_rows: list[dict[str, object]] = []
    resource_rows: list[dict[str, object]] = []
    external_struct_cache: dict[str, dict[str, dict]] = {}

    def load_bundle_objects(bundle: str) -> dict[str, dict]:
        if bundle not in external_struct_cache:
            export_dir = export_map.get(bundle)
            structure = export_dir / "structure.jsonl.gz" if export_dir else Path()
            external_struct_cache[bundle] = load_jsonl_gz(structure)
        return external_struct_cache[bundle]

    def add_resource(kind: str, bundle: str, path_id: str, name: str = "", source: str = "", note: str = ""):
        ta = textassets.get((bundle, path_id))
        img = images_by_bundle_pid.get((bundle, path_id))
        path = ""
        resource_type = kind
        size = ""
        if ta:
            resource_type = "TextAsset"
            name = ta.get("name", name)
            path = ta.get("output", "")
            size = ta.get("size", "")
        if img:
            resource_type = img.get("type", "Texture2D")
            name = img.get("name", name)
            path = img.get("output", "")
            size = f'{img.get("width", "")}x{img.get("height", "")}'
        resource_rows.append({
            "source": source,
            "resource_type": resource_type,
            "bundle": bundle,
            "path_id": path_id,
            "name": name,
            "size": size,
            "extracted_path": path,
            "note": note,
        })

    for go_id in sorted(focus_go_ids):
        go = game_objects.get(go_id)
        if not go:
            continue
        name = go.get("tree", {}).get("m_Name", route_names.get(go_id, ""))
        active = go.get("tree", {}).get("m_IsActive", "")
        components = by_go_components.get(go_id, [])
        rect = rect_by_go.get(go_id, {})
        component_ids = [str(c.get("path_id")) for c in components]
        component_types = [c.get("type", "") for c in components]
        for comp in components:
            tree = comp.get("tree", {})
            script = ref_path_id(tree.get("m_Script"))
            row = {
                "game_object_name": name,
                "game_object_id": go_id,
                "hierarchy_path": route_paths.get(go_id, ""),
                "game_object_active": active,
                "rect_path_id": rect.get("path_id", ""),
                "anchored_pos": rect.get("anchored_pos", ""),
                "size": rect.get("original_size", ""),
                "local_scale": rect.get("original_local_scale", ""),
                "component_path_id": comp.get("path_id"),
                "component_type": comp.get("type"),
                "script_id": script,
                "component_ids_on_go": ";".join(component_ids),
                "component_types_on_go": ";".join(component_types),
                "skeleton_file_id": "",
                "skeleton_path_id": "",
                "skeleton_bundle": "",
                "skeleton_name": "",
                "atlas_path_id": "",
                "atlas_textasset_path": "",
                "texture_path": "",
                "material_refs": "",
                "starting_animation": tree.get("startingAnimation", ""),
                "starting_loop": tree.get("startingLoop", ""),
                "particle_refs": "",
                "canvas_renderer_count": "",
                "note": "",
            }

            if "skeletonDataAsset" in tree:
                sk_ref = tree.get("skeletonDataAsset")
                sk_file = ref_file_id(sk_ref)
                sk_pid = ref_path_id(sk_ref)
                dep = ext_deps.get(sk_file, {})
                sk_bundle = dep.get("dependency_bundle", "")
                row["skeleton_file_id"] = sk_file
                row["skeleton_path_id"] = sk_pid
                row["skeleton_bundle"] = sk_bundle
                row["material_refs"] = ";".join(
                    f'{key}=file{ref_file_id(tree.get(key))}:{ref_path_id(tree.get(key))}'
                    for key in ["m_Material", "additiveMaterial", "multiplyMaterial", "screenMaterial"]
                    if ref_path_id(tree.get(key))
                )
                row["canvas_renderer_count"] = len(tree.get("canvasRenderers", []) or [])
                if sk_bundle:
                    sk_objects = load_bundle_objects(sk_bundle)
                    sk_obj = sk_objects.get(sk_pid, {})
                    sk_tree = sk_obj.get("tree", {})
                    row["skeleton_name"] = sk_tree.get("m_Name", "")
                    add_resource("SkeletonDataAsset", sk_bundle, sk_pid, sk_tree.get("m_Name", ""), name, "referenced by SkeletonGraphic")
                    json_pid = ref_path_id(sk_tree.get("skeletonJSON"))
                    if json_pid:
                        add_resource("TextAsset", sk_bundle, json_pid, source=name, note="skeletonJSON")
                    atlas_refs = sk_tree.get("atlasAssets", []) or []
                    atlas_pids = [ref_path_id(x) for x in atlas_refs if ref_path_id(x)]
                    row["atlas_path_id"] = ";".join(atlas_pids)
                    for atlas_pid in atlas_pids:
                        atlas_obj = sk_objects.get(atlas_pid, {})
                        atlas_tree = atlas_obj.get("tree", {})
                        add_resource("AtlasAsset", sk_bundle, atlas_pid, atlas_tree.get("m_Name", ""), name, "SkeletonData atlasAssets")
                        atlas_file_pid = ref_path_id(atlas_tree.get("atlasFile"))
                        if atlas_file_pid:
                            ta = textassets.get((sk_bundle, atlas_file_pid), {})
                            row["atlas_textasset_path"] = ta.get("output", row["atlas_textasset_path"])
                            add_resource("TextAsset", sk_bundle, atlas_file_pid, source=name, note="atlasFile")
                            atlas_path = extracted_path(ta.get("output", ""))
                            if atlas_path.exists():
                                page, regions = parse_spine_atlas(atlas_path)
                                img = image_for_atlas_page(images_by_bundle_name, sk_bundle, page)
                                if img:
                                    row["texture_path"] = img.get("output", "")
                                    add_resource("Texture2D", sk_bundle, img.get("path_id", ""), img.get("name", ""), name, f"atlas page {page}; regions={len(regions)}")
                        for mat_ref in atlas_tree.get("materials", []) or []:
                            mat_pid = ref_path_id(mat_ref)
                            if mat_pid:
                                add_resource("Material", sk_bundle, mat_pid, source=name, note="atlas material")

            if "m_Particles" in tree:
                particle_refs = [ref_path_id(x) for x in (tree.get("m_Particles") or []) if ref_path_id(x)]
                row["particle_refs"] = ";".join(particle_refs)
                for particle_pid in particle_refs:
                    pobj = main_objects.get(particle_pid, {})
                    ptree = pobj.get("tree", {})
                    particle_rows.append({
                        "owner_name": name,
                        "owner_game_object_id": go_id,
                        "particle_component_path_id": particle_pid,
                        "particle_type": pobj.get("type", ""),
                        "particle_game_object_id": ref_path_id(ptree.get("m_GameObject")),
                        "particle_material": ref_path_id(ptree.get("m_Material")),
                        "renderer_material": ref_path_id(ptree.get("m_Materials", [{}])[0]) if isinstance(ptree.get("m_Materials"), list) and ptree.get("m_Materials") else "",
                        "note": "route card fire/effect particle reference from original MonoBehaviour",
                    })

            if script == "5804373309048859138":
                row["note"] = "CanvasRenderer separator/helper graphic under SkeletonGraphic; actual bitmap comes from parent SkeletonGraphic skeletonDataAsset"
            elif script == "-7396295067816475631":
                row["note"] = "Particle-style UI MonoBehaviour; do not force-visible without active-chain and scale evidence"
            elif script == "-6938409698251234290":
                row["note"] = "SkeletonGraphic-like component carrying material and skeletonDataAsset reference"
            elif script == "-8877758280253173385":
                row["note"] = "route wrapper MonoBehaviour on same GameObject as SkeletonGraphic"
            trace_rows.append(row)

    shijie_atlas = ROOT / "girlswar_merged_extracted" / "extracted" / "unity" / "bundles" / "b_35f69f1e4224c83e" / "textassets" / "4125696125331628132_Spine_shijieanniu.atlas.txt"
    shijie_png = ROOT / "girlswar_merged_extracted" / "extracted" / "unity" / "bundles" / "b_35f69f1e4224c83e" / "images" / "T" / "-1569618029946744867_Spine_shijieanniu.png"
    fallback_regions = ["zhuye_di1", "diqiu", "zhuye_bian", "yun", "yun2"]
    fallback_assets: dict[str, str] = {}
    fallback_bounds: dict[str, list[int]] = {}
    fallback_crop_paths: dict[str, str] = {}
    applied_layer_rows: list[dict[str, str]] = []
    fallback_applied = False
    fallback_note = "not applied"
    if shijie_atlas.exists() and shijie_png.exists():
        page, regions = parse_spine_atlas(shijie_atlas)
        for region_name in fallback_regions:
            bounds = regions.get(region_name, {}).get("bounds")
            if isinstance(bounds, list) and len(bounds) == 4:
                asset_path = f"Assets/RestoreData/route_renderer_fallbacks/Spine_shijieanniu_{region_name}.png"
                dst = UNITY / asset_path
                if ensure_region_png(shijie_png, dst, bounds):
                    fallback_assets[region_name] = asset_path
                    fallback_bounds[region_name] = bounds
                    fallback_crop_paths[region_name] = str(dst)
        applied_layer_rows = update_visual_override_layers(fallback_assets)
        fallback_applied = len(applied_layer_rows) > 0
        if fallback_applied:
            applied_names = ", ".join(row["create_child_name"] for row in applied_layer_rows)
            fallback_note = (
                f"cropped {len(fallback_assets)} Spine_shijieanniu regions from {file_rel(shijie_png)}; "
                f"applied evidence-safe worldwanfaBtn child layers: {applied_names}; "
                "yun/yun2 are cropped but not displayed because exact Spine slot transforms are not available"
            )

    trace_fields = [
        "game_object_name", "game_object_id", "hierarchy_path", "game_object_active",
        "rect_path_id", "anchored_pos", "size", "local_scale", "component_path_id",
        "component_type", "script_id", "component_ids_on_go", "component_types_on_go",
        "skeleton_file_id", "skeleton_path_id", "skeleton_bundle", "skeleton_name",
        "atlas_path_id", "atlas_textasset_path", "texture_path", "material_refs",
        "starting_animation", "starting_loop", "particle_refs", "canvas_renderer_count", "note",
    ]
    write_csv(TRACE_CSV, trace_rows, trace_fields)
    write_csv(RESOURCE_CSV, resource_rows, ["source", "resource_type", "bundle", "path_id", "name", "size", "extracted_path", "note"])
    write_csv(PARTICLE_CSV, particle_rows, ["owner_name", "owner_game_object_id", "particle_component_path_id", "particle_type", "particle_game_object_id", "particle_material", "renderer_material", "note"])

    unique_displayable = sorted({
        row["extracted_path"] for row in resource_rows
        if row.get("resource_type") == "Texture2D" and row.get("extracted_path")
    })
    summary = {
        "generated_at": "2026-06-25 KST",
        "trace_rows": len(trace_rows),
        "resource_rows": len(resource_rows),
        "particle_rows": len(particle_rows),
        "displayable_texture_count": len(unique_displayable),
        "displayable_textures": unique_displayable,
        "fallback_applied": fallback_applied,
        "fallback_assets": fallback_assets,
        "fallback_bounds": fallback_bounds,
        "applied_fallback_layers": applied_layer_rows,
        "fallback_note": fallback_note,
        "main_skeletons": [
            {
                "node": "spine_diqiu",
                "skeletonDataAsset": "fileID 59 pathID 1138517909137294754",
                "bundle": "download/ui/uiprefabandres/maininterface_ext_8.assetbundle",
                "texture": "Spine_shijieanniu.png",
            },
            {
                "node": "spine_xiaoren",
                "skeletonDataAsset": "fileID 60 pathID 5595588015970333467",
                "bundle": "download/roleprefabsandres/npcprefabandres/8007.assetbundle",
                "texture": "8007.png",
            },
        ],
    }
    TRACE_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    md = []
    md.append("# MainInterface Route Renderer Asset Trace\n")
    md.append("Generated: 2026-06-25 KST\n")
    md.append("## Verdict\n")
    md.append("`wanfaWorldNode`의 누락 비주얼은 원본 `SkeletonGraphic`/particle-style renderer 계층이다. `spine_diqiu`는 `maininterface_ext_8.assetbundle`의 `Spine_shijieanniu_SkeletonData`, `spine_xiaoren`은 `npcprefabandres/8007.assetbundle`의 `8007_SkeletonData`를 참조한다.\n")
    md.append("Fallback은 실제 Spine runtime 재생이 아니라 원본 atlas region을 개별 crop해 `worldwanfaBtn` 아래 비차단 child Image layer로 붙이는 복원이다. route owner active/sibling/anchor와 button raycast는 바꾸지 않는다.\n")
    md.append("## Skeleton References\n")
    md.append("| Node | SkeletonData ref | Bundle | Atlas/TextAsset | Texture | Animation | CanvasRenderers |\n")
    md.append("| --- | --- | --- | --- | --- | --- | ---: |\n")
    for row in trace_rows:
        if row.get("script_id") == "-6938409698251234290":
            md.append(
                f"| `{row['game_object_name']}` | file `{row['skeleton_file_id']}` path `{row['skeleton_path_id']}` | `{row['skeleton_bundle']}` | `{row['atlas_textasset_path']}` | `{row['texture_path']}` | `{row['starting_animation']}` | `{row['canvas_renderer_count']}` |\n"
            )
    md.append("\n## Displayable Resources\n")
    md.append(f"- Displayable Texture2D resources traced: `{len(unique_displayable)}`\n")
    for path in unique_displayable:
        md.append(f"- `{path}`\n")
    md.append("\n## Fallback\n")
    md.append(f"- Applied: `{fallback_applied}`\n")
    md.append("- Applied layers:\n")
    for row in applied_layer_rows:
        md.append(f"  - `{row['create_child_name']}` -> `{row['sprite_asset_path']}`, size `{row['size_delta_x']}x{row['size_delta_y']}`, raycast `{row['raycast_target']}`\n")
    md.append("- Cropped regions:\n")
    for region_name in fallback_regions:
        if region_name in fallback_assets:
            md.append(f"  - `{region_name}` bounds `{fallback_bounds.get(region_name, [])}` -> `{fallback_assets[region_name]}`\n")
    md.append(f"- Note: {fallback_note}\n")
    md.append("- Deferred display: `yun`, `yun2`, and `spine_xiaoren`/`8007` need original Spine bone/slot transforms before they can be placed without coordinate guessing.\n")
    md.append("\n## Particle / Effect Evidence\n")
    md.append(f"- Particle-style owner rows: `{len(particle_rows)}`\n")
    md.append("- `un_MainInterface_fire` and `Entry` use script id `-7396295067816475631`; these are not forced visible without original active-chain and localScale evidence.\n")
    md.append("\n## Generated Files\n")
    generated_paths = [TRACE_JSON, TRACE_CSV, RESOURCE_CSV, PARTICLE_CSV]
    generated_paths.extend(Path(path) for path in fallback_crop_paths.values())
    for path in generated_paths:
        if path:
            md.append(f"- `{path}`\n")
    md.append("\n## Latest Verification\n")
    md.append(f"- Capture: `{CAPTURE_PNG}`\n")
    md.append(f"- Capture exists: `{CAPTURE_PNG.exists()}`\n")
    if CLICK_SUMMARY.exists():
        click = json.loads(CLICK_SUMMARY.read_text(encoding="utf-8-sig"))
        md.append(f"- Click validation generated: `{click.get('generatedAt', '')}`\n")
        md.append(f"- Active buttons: `{click.get('activeButtons', '')}`\n")
        md.append(f"- Raycast-clickable active buttons: `{click.get('raycastClickableButtons', '')}/{click.get('activeButtons', '')}`\n")
        md.append(f"- Raycast-blocked active buttons: `{click.get('raycastBlockedButtons', '')}`\n")
        md.append(f"- Click logs invoked: `{click.get('invokedClicks', '')}`\n")
    else:
        md.append("- Click validation summary: `not found yet`\n")
    MD_REPORT.write_text("".join(md), encoding="utf-8")

    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
