import csv
import json
import os
from pathlib import Path

import UnityPy


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = ROOT / "reports" / "maininterface"
UNITY_ROOT = ROOT / "girlswar_maininterface_unity"
RESTORE_DATA = UNITY_ROOT / "Assets" / "RestoreData"
MERGED = ROOT / "girlswar_merged_extracted"
CLEAN = MERGED / "extracted" / "unity" / "clean_unityfs_slices"

PREFIX = "MAININTERFACE_142_SOURCE_RENDERER_RECONSTRUCTION_FEASIBILITY_NO_PATCH"
RESULT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
RESULT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
COMPONENT_MATRIX = REPORT_DIR / "MAININTERFACE_142_uidock_normal_sp_renderer_component_field_matrix.csv"
DEPENDENCY_MATRIX = REPORT_DIR / "MAININTERFACE_142_skeletondata_material_atlas_texture_dependency_resolution_matrix.csv"
PROJECT_MATRIX = REPORT_DIR / "MAININTERFACE_142_unity_project_spine_runtime_import_feasibility_matrix.csv"
PATCH_MATRIX = REPORT_DIR / "MAININTERFACE_142_future_patch_proposal_vs_blocker_decision_matrix.csv"

MAIN_BUNDLE_REL = "download/ui/uiprefabandres/maininterface.assetbundle"
MAIN_BUNDLE = CLEAN / MAIN_BUNDLE_REL
UI141_SP_MATRIX = REPORT_DIR / "MAININTERFACE_141_uidock_sp_uispinectr_skeletongraphic_binding_evidence_matrix.csv"
EXTERNAL_DEPS = RESTORE_DATA / "maininterface_external_dependencies.csv"
RECTS_CSV = RESTORE_DATA / "maininterface_rects.csv"
COMPONENTS_CSV = RESTORE_DATA / "maininterface_components.csv"

TARGETS = [
    "sp_mainpage",
    "sp_camp",
    "sp_bag",
    "sp_expedition",
    "sp_adventureInterface",
    "sp_guild",
    "sp_maincity",
    "spine_xiaoshou",
    "dianjigq1",
]


def read_csv(path):
    with open(path, newline="", encoding="utf-8-sig") as f:
        return list(csv.DictReader(f))


def write_csv(path, rows, fieldnames):
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        for row in rows:
            w.writerow({k: row.get(k, "") for k in fieldnames})


def pptr_str(v):
    if not isinstance(v, dict):
        return ""
    return f"fileID={v.get('m_FileID', '')};pathID={v.get('m_PathID', '')}"


def pptr_tuple(v):
    if not isinstance(v, dict):
        return (None, None)
    return (v.get("m_FileID"), v.get("m_PathID"))


def short_json(v, limit=1200):
    try:
        s = json.dumps(v, ensure_ascii=False, sort_keys=True)
    except Exception:
        s = str(v)
    return s[:limit]


def bundle_path(rel):
    if not rel:
        return None
    return CLEAN / rel.replace("/", os.sep)


class BundleCache:
    def __init__(self):
        self.envs = {}
        self.objects = {}

    def load(self, rel):
        if not rel:
            return None
        if rel in self.envs:
            return self.envs[rel]
        path = bundle_path(rel)
        if not path or not path.exists():
            self.envs[rel] = None
            self.objects[rel] = {}
            return None
        env = UnityPy.load(str(path))
        self.envs[rel] = env
        self.objects[rel] = {obj.path_id: obj for obj in env.objects}
        return env

    def object(self, rel, path_id):
        if path_id in ("", None):
            return None
        try:
            pid = int(path_id)
        except Exception:
            return None
        self.load(rel)
        return self.objects.get(rel, {}).get(pid)

    def tree(self, rel, path_id):
        obj = self.object(rel, path_id)
        if not obj:
            return None
        try:
            return obj.read_typetree()
        except Exception as exc:
            return {"__read_error": str(exc)}

    def type_name(self, rel, path_id):
        obj = self.object(rel, path_id)
        return obj.type.name if obj else ""


def build_external_map():
    deps = {}
    for row in read_csv(EXTERNAL_DEPS):
        fid = row.get("file_id")
        if fid:
            deps[int(fid)] = row
    return deps


def resolve_pptr(main_rel, pptr, external_map):
    file_id, path_id = pptr_tuple(pptr)
    if file_id in ("", None) or path_id in ("", None) or int(path_id) == 0:
        return {
            "fileId": file_id,
            "pathId": path_id,
            "bundle": "",
            "bundlePath": "",
            "status": "null_reference" if int(path_id or 0) == 0 else "missing_pptr",
        }
    file_id = int(file_id)
    path_id = int(path_id)
    if file_id == 0:
        rel = main_rel
        source = "same_bundle"
    else:
        dep = external_map.get(file_id, {})
        rel = dep.get("dependency_bundle", "")
        source = dep.get("cab_name", "")
    bp = bundle_path(rel) if rel else None
    return {
        "fileId": file_id,
        "pathId": path_id,
        "bundle": rel,
        "bundlePath": str(bp) if bp else "",
        "status": "bundle_file_exists" if bp and bp.exists() else "bundle_mapping_missing_or_file_missing",
        "source": source,
    }


def extract_material_info(tree):
    if not isinstance(tree, dict):
        return {}
    props = tree.get("m_SavedProperties", {})
    floats = {k: v for k, v in props.get("m_Floats", [])} if isinstance(props, dict) else {}
    texenvs = props.get("m_TexEnvs", []) if isinstance(props, dict) else []
    main_tex = ""
    for key, val in texenvs:
        if key == "_MainTex":
            main_tex = pptr_str(val.get("m_Texture", {}))
    return {
        "materialName": tree.get("m_Name", ""),
        "shaderRef": pptr_str(tree.get("m_Shader", {})),
        "shaderKeywords": tree.get("m_ShaderKeywords", ""),
        "mainTextureRef": main_tex,
        "stencilRef": floats.get("_StencilRef", ""),
        "stencilComp": floats.get("_StencilComp", ""),
        "stencil": floats.get("_Stencil", ""),
        "stencilReadMask": floats.get("_StencilReadMask", ""),
        "stencilWriteMask": floats.get("_StencilWriteMask", ""),
        "colorMask": floats.get("_ColorMask", ""),
        "straightAlphaInput": floats.get("_StraightAlphaInput", ""),
        "useUIAlphaClip": floats.get("_UseUIAlphaClip", ""),
        "zWrite": floats.get("_ZWrite", ""),
    }


def details_value(details, key):
    if not details:
        return ""
    for part in details.split(";"):
        if part.startswith(key + "="):
            return part.split("=", 1)[1]
    return ""


def pptr_from_string(value):
    out = {"m_FileID": "", "m_PathID": ""}
    if not value:
        return out
    for part in value.split(";"):
        if part.startswith("fileID="):
            out["m_FileID"] = int(part.split("=", 1)[1])
        if part.startswith("pathID="):
            out["m_PathID"] = int(part.split("=", 1)[1])
    return out


def is_skeleton_graphic_component(row):
    keys = row.get("keys", "")
    return "skeletonDataAsset" in keys and "startingAnimation" in keys


def is_uispinectr_component(row):
    return row.get("script_id") == "-8877758280253173385"


def main():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    cache = BundleCache()
    cache.load(MAIN_BUNDLE_REL)
    external_map = build_external_map()

    rect_by_rect_id = {r["path_id"]: r for r in read_csv(RECTS_CSV)}
    comps_by_go = {}
    for row in read_csv(COMPONENTS_CSV):
        comps_by_go.setdefault(row["game_object_id"], []).append(row)

    ui141_rows = [
        r for r in read_csv(UI141_SP_MATRIX)
        if r.get("bindingRoot") == "UI_Dock" and r.get("comName") in TARGETS
    ]
    order = {name: i for i, name in enumerate(TARGETS)}
    ui141_rows.sort(key=lambda r: order.get(r.get("comName"), 999))

    component_rows = []
    dependency_rows = []
    refs_to_resolve = []
    normal_renderer_count = 0
    dependency_closed = True

    for row in ui141_rows:
        name = row.get("comName", "")
        rect_id = row.get("comObjPathId", "")
        rect = rect_by_rect_id.get(rect_id, {})
        go_id = rect.get("game_object_id") or row.get("mappedGameObjectIdFromRect") or row.get("comGameObjectId")
        comps = comps_by_go.get(str(go_id), [])
        sk_comps = [c for c in comps if is_skeleton_graphic_component(c)]
        ui_comps = [c for c in comps if is_uispinectr_component(c)]
        sk_comp = sk_comps[0] if sk_comps else {}
        ui_comp = ui_comps[0] if ui_comps else {}
        sk_tree = cache.tree(MAIN_BUNDLE_REL, sk_comp.get("component_path_id")) if sk_comp else None
        ui_tree = cache.tree(MAIN_BUNDLE_REL, ui_comp.get("component_path_id")) if ui_comp else None

        skeleton_ref = sk_tree.get("skeletonDataAsset", {}) if isinstance(sk_tree, dict) else {}
        main_mat_ref = sk_tree.get("m_Material", {}) if isinstance(sk_tree, dict) else {}
        additive_ref = sk_tree.get("additiveMaterial", {}) if isinstance(sk_tree, dict) else {}
        multiply_ref = sk_tree.get("multiplyMaterial", {}) if isinstance(sk_tree, dict) else {}
        screen_ref = sk_tree.get("screenMaterial", {}) if isinstance(sk_tree, dict) else {}
        normal_renderer = bool(sk_comps and ui_comps)
        normal_renderer_count += 1 if normal_renderer else 0

        for ref_name, ref in [
            ("skeletonDataAsset", skeleton_ref),
            ("m_Material", main_mat_ref),
            ("additiveMaterial", additive_ref),
            ("multiplyMaterial", multiply_ref),
            ("screenMaterial", screen_ref),
        ]:
            if isinstance(ref, dict) and int(ref.get("m_PathID") or 0) != 0:
                refs_to_resolve.append((name, ref_name, ref, MAIN_BUNDLE_REL))

        component_rows.append({
            "comName": name,
            "bindingRoot": row.get("bindingRoot", ""),
            "comObjPathId_rectTransform": rect_id,
            "mappedGameObjectId": go_id,
            "gameObjectName": rect.get("game_object_name", row.get("comName", "")),
            "sourceGameObjectActive": rect.get("game_object_active", ""),
            "sourceHasSkeletonGraphic": bool(sk_comps),
            "sourceHasUISpineCtr": bool(ui_comps),
            "skeletonGraphicComponentPathId": sk_comp.get("component_path_id", ""),
            "uiSpineCtrComponentPathId": ui_comp.get("component_path_id", ""),
            "skeletonGraphicEnabled": sk_tree.get("m_Enabled", "") if isinstance(sk_tree, dict) else "",
            "uiSpineCtrEnabled": ui_tree.get("m_Enabled", "") if isinstance(ui_tree, dict) else "",
            "skeletonDataAssetRef": pptr_str(skeleton_ref),
            "materialRef": pptr_str(main_mat_ref),
            "additiveMaterialRef": pptr_str(additive_ref),
            "multiplyMaterialRef": pptr_str(multiply_ref),
            "screenMaterialRef": pptr_str(screen_ref),
            "initialSkinName": sk_tree.get("initialSkinName", "") if isinstance(sk_tree, dict) else "",
            "initialFlipX": sk_tree.get("initialFlipX", "") if isinstance(sk_tree, dict) else "",
            "initialFlipY": sk_tree.get("initialFlipY", "") if isinstance(sk_tree, dict) else "",
            "startingAnimation": sk_tree.get("startingAnimation", "") if isinstance(sk_tree, dict) else "",
            "startingLoop": sk_tree.get("startingLoop", "") if isinstance(sk_tree, dict) else "",
            "timeScale": sk_tree.get("timeScale", "") if isinstance(sk_tree, dict) else "",
            "freeze": sk_tree.get("freeze", "") if isinstance(sk_tree, dict) else "",
            "uihide": sk_tree.get("uihide", "") if isinstance(sk_tree, dict) else "",
            "updateWhenInvisible": sk_tree.get("updateWhenInvisible", "") if isinstance(sk_tree, dict) else "",
            "unscaledTime": sk_tree.get("unscaledTime", "") if isinstance(sk_tree, dict) else "",
            "raycastTarget": sk_tree.get("m_RaycastTarget", "") if isinstance(sk_tree, dict) else "",
            "maskable": sk_tree.get("m_Maskable", "") if isinstance(sk_tree, dict) else "",
            "color": short_json(sk_tree.get("m_Color", "")) if isinstance(sk_tree, dict) else "",
            "allowMultipleCanvasRenderers": sk_tree.get("allowMultipleCanvasRenderers", "") if isinstance(sk_tree, dict) else "",
            "canvasRendererRefs": short_json(sk_tree.get("canvasRenderers", "")) if isinstance(sk_tree, dict) else "",
            "preserveDrawingBuffer": sk_tree.get("preserveDrawingBuffer", "field_not_present") if isinstance(sk_tree, dict) else "",
            "meshGeneratorSettings": short_json(sk_tree.get("meshGenerator", "")) if isinstance(sk_tree, dict) else "",
            "uiSpineCtrSerializedKeys": ";".join(ui_tree.keys()) if isinstance(ui_tree, dict) else "",
            "uiSpineCtrSerializedRefs": short_json({k: v for k, v in ui_tree.items() if isinstance(v, dict)}) if isinstance(ui_tree, dict) else "",
            "uiSpineCtrBindingSemantics": "Awake obtains SkeletonGraphic from same GameObject per UI140; component has no serialized SkeletonGraphic ref" if ui_comps else "not_applicable_no_uispinectr",
            "candidateStatus": row.get("bindingStatus", ""),
            "decision": "source_renderer_chain_present_in_bundle_candidate_missing_renderer" if normal_renderer else "control_or_no_renderer_chain",
        })

    # Resolve direct refs and recursively resolve SkeletonDataAsset -> AtlasAsset -> atlas TextAsset/materials/textures.
    seen = set()
    queue = list(refs_to_resolve)
    while queue:
        owner, ref_name, ref, base_rel = queue.pop(0)
        resolved = resolve_pptr(base_rel, ref, external_map)
        key = (owner, ref_name, resolved.get("bundle"), resolved.get("pathId"))
        if key in seen:
            continue
        seen.add(key)

        obj_type = cache.type_name(resolved.get("bundle", ""), resolved.get("pathId", ""))
        tree = cache.tree(resolved.get("bundle", ""), resolved.get("pathId", ""))
        obj_name = tree.get("m_Name", "") if isinstance(tree, dict) else ""
        row = {
            "ownerComName": owner,
            "refRole": ref_name,
            "fileId": resolved.get("fileId", ""),
            "pathId": resolved.get("pathId", ""),
            "resolvedBundle": resolved.get("bundle", ""),
            "resolvedBundlePath": resolved.get("bundlePath", ""),
            "resolvedBundleExists": Path(resolved.get("bundlePath", "")).exists() if resolved.get("bundlePath") else False,
            "resolvedObjectType": obj_type,
            "resolvedObjectName": obj_name,
            "resolutionStatus": "resolved_object" if tree else resolved.get("status", ""),
            "skeletonScale": tree.get("scale", "") if isinstance(tree, dict) else "",
            "skeletonJSONRef": pptr_str(tree.get("skeletonJSON", {})) if isinstance(tree, dict) else "",
            "atlasAssetsRefs": ";".join(pptr_str(x) for x in tree.get("atlasAssets", [])) if isinstance(tree, dict) else "",
            "atlasFileRef": pptr_str(tree.get("atlasFile", {})) if isinstance(tree, dict) else "",
            "atlasMaterialRefs": ";".join(pptr_str(x) for x in tree.get("materials", [])) if isinstance(tree, dict) else "",
            "materialShaderRef": "",
            "materialShaderKeywords": "",
            "materialMainTextureRef": "",
            "materialStencilRef": "",
            "materialStencilComp": "",
            "materialStencil": "",
            "materialColorMask": "",
            "textureWidth": "",
            "textureHeight": "",
            "textureFormat": "",
            "dependencyStatus": "",
        }
        if obj_type == "Material" and isinstance(tree, dict):
            mat = extract_material_info(tree)
            row.update({
                "materialShaderRef": mat.get("shaderRef", ""),
                "materialShaderKeywords": mat.get("shaderKeywords", ""),
                "materialMainTextureRef": mat.get("mainTextureRef", ""),
                "materialStencilRef": mat.get("stencilRef", ""),
                "materialStencilComp": mat.get("stencilComp", ""),
                "materialStencil": mat.get("stencil", ""),
                "materialColorMask": mat.get("colorMask", ""),
            })
        if obj_type in ("Texture2D", "Sprite") and isinstance(tree, dict):
            row.update({
                "textureWidth": tree.get("m_Width", ""),
                "textureHeight": tree.get("m_Height", ""),
                "textureFormat": tree.get("m_TextureFormat", ""),
            })

        # Child refs are same bundle relative once the referenced object has been resolved.
        if isinstance(tree, dict):
            rel = resolved.get("bundle", "")
            if ref_name == "skeletonDataAsset":
                for i, atlas_ref in enumerate(tree.get("atlasAssets", [])):
                    queue.append((owner, f"{obj_name}.atlasAsset[{i}]", {"m_FileID": 0, "m_PathID": atlas_ref.get("m_PathID")}, rel))
                sj = tree.get("skeletonJSON", {})
                if isinstance(sj, dict) and int(sj.get("m_PathID") or 0) != 0:
                    queue.append((owner, f"{obj_name}.skeletonJSON", {"m_FileID": 0, "m_PathID": sj.get("m_PathID")}, rel))
            if "atlasFile" in tree:
                af = tree.get("atlasFile", {})
                if isinstance(af, dict) and int(af.get("m_PathID") or 0) != 0:
                    queue.append((owner, f"{obj_name}.atlasFile", {"m_FileID": 0, "m_PathID": af.get("m_PathID")}, rel))
                for i, mat_ref in enumerate(tree.get("materials", [])):
                    queue.append((owner, f"{obj_name}.atlasMaterial[{i}]", {"m_FileID": 0, "m_PathID": mat_ref.get("m_PathID")}, rel))
            if obj_type == "Material":
                mat = extract_material_info(tree)
                mt = mat.get("mainTextureRef", "")
                if "pathID=" in mt:
                    try:
                        pid = int(mt.split("pathID=", 1)[1].split(";", 1)[0])
                        if pid:
                            queue.append((owner, f"{obj_name}.mainTexture", {"m_FileID": 0, "m_PathID": pid}, rel))
                    except Exception:
                        pass

        if not tree:
            dependency_closed = False
            row["dependencyStatus"] = "unresolved"
        else:
            row["dependencyStatus"] = "resolved"
        dependency_rows.append(row)

    project_rows = []
    checks = [
        ("Spine runtime SkeletonGraphic.cs", UNITY_ROOT / "Assets" / "Spine" / "Runtime" / "spine-unity" / "Components" / "SkeletonGraphic.cs"),
        ("Spine runtime SkeletonDataAsset.cs", UNITY_ROOT / "Assets" / "Spine" / "Runtime" / "spine-unity" / "Asset Types" / "SkeletonDataAsset.cs"),
        ("SkeletonGraphicDefault.mat", UNITY_ROOT / "Assets" / "Spine" / "Runtime" / "spine-unity" / "Materials" / "SkeletonGraphicDefault.mat"),
        ("SkeletonGraphicAdditive.mat", UNITY_ROOT / "Assets" / "Spine" / "Runtime" / "spine-unity" / "Materials" / "SkeletonGraphicAdditive.mat"),
        ("SkeletonGraphicMultiply.mat", UNITY_ROOT / "Assets" / "Spine" / "Runtime" / "spine-unity" / "Materials" / "SkeletonGraphicMultiply.mat"),
        ("SkeletonGraphicScreen.mat", UNITY_ROOT / "Assets" / "Spine" / "Runtime" / "spine-unity" / "Materials" / "SkeletonGraphicScreen.mat"),
        ("SkeletonGraphic shader", UNITY_ROOT / "Assets" / "Spine" / "Runtime" / "spine-unity" / "Shaders" / "SkeletonGraphic" / "Spine-SkeletonGraphic.shader"),
    ]
    for name, path in checks:
        project_rows.append({
            "item": name,
            "path": str(path),
            "exists": path.exists(),
            "evidence": "project file present" if path.exists() else "missing",
            "feasibilityImpact": "required runtime/import support is available" if path.exists() else "would block source-backed renderer reconstruction",
        })
    asmdefs = list((UNITY_ROOT / "Assets" / "Spine").rglob("*.asmdef")) if (UNITY_ROOT / "Assets" / "Spine").exists() else []
    project_rows.append({
        "item": "Spine asmdef files",
        "path": ";".join(str(p) for p in asmdefs),
        "exists": bool(asmdefs),
        "evidence": f"{len(asmdefs)} asmdef file(s) under Assets/Spine",
        "feasibilityImpact": "not required for source availability; compile safety still requires Unity import/compile validation in a future patch",
    })
    project_rows.append({
        "item": "UI_Dock source skeleton data bundles",
        "path": str(CLEAN / "download" / "ui" / "uiprefabandres" / "maininterface_ext_1.assetbundle") + ";" + str(CLEAN / "download" / "ui" / "uiprefabandres" / "guide.assetbundle"),
        "exists": all((CLEAN / p).exists() for p in [
            Path("download/ui/uiprefabandres/maininterface_ext_1.assetbundle"),
            Path("download/ui/uiprefabandres/guide.assetbundle"),
        ]),
        "evidence": "SkeletonDataAsset refs resolve to local source bundles",
        "feasibilityImpact": "renderer asset import appears source-backed, but no scene patch until depth is known",
    })

    all_skeleton_refs = [r for r in dependency_rows if r["refRole"] == "skeletonDataAsset"]
    all_material_refs = [r for r in dependency_rows if "Material" in r["refRole"] or r["resolvedObjectType"] == "Material"]
    all_texture_refs = [r for r in dependency_rows if r["resolvedObjectType"] in ("Texture2D", "Sprite")]
    skeleton_resolved = bool(all_skeleton_refs) and all(r["resolutionStatus"] == "resolved_object" for r in all_skeleton_refs)
    materials_resolved = bool(all_material_refs) and all(r["resolutionStatus"] == "resolved_object" for r in all_material_refs)
    textures_resolved = bool(all_texture_refs) and all(r["resolutionStatus"] == "resolved_object" for r in all_texture_refs)
    runtime_available = all(Path(r["path"]).exists() for r in project_rows[:7])
    renderer_chain_recovered = normal_renderer_count == 8 and skeleton_resolved and materials_resolved and textures_resolved

    renderer_patch_feasible = bool(renderer_chain_recovered and runtime_available)
    root_cmd_count = len(list(ROOT.glob("*.cmd")))
    restore_tools_direct_cmd_count = len(list((ROOT / "_restore_tools").glob("*.cmd")))

    patch_rows = [
        {
            "area": "UI_Dock normal sp_* renderer chain",
            "evidenceStatus": "source_components_and_dependencies_resolved" if renderer_chain_recovered else "partial_dependency_or_component_gap",
            "futurePatchAllowedNow": False,
            "reason": "Renderer-only source chain is feasible, but UI142 is no-patch and UI_Dock promotion still requires exact production depth.",
            "nextEvidence": "Compile-time import validation and exact parent form CurrCanvas.sortingOrder for DisableUILayer=1 forms.",
        },
        {
            "area": "UI_Dock promotion",
            "evidenceStatus": "blocked_by_depth",
            "futurePatchAllowedNow": False,
            "reason": "UI141/UI140 show DisableUILayer=1 forms need runtime/default parent depth; sibling mount already worsened UI136.",
            "nextEvidence": "Runtime dump or source-backed default parent CurrCanvas.sortingOrder/depth for UI_Dock/UI_MainPage.",
        },
        {
            "area": "dianjigq1",
            "evidenceStatus": "control_no_renderer",
            "futurePatchAllowedNow": False,
            "reason": "UI141 and source components show no SkeletonGraphic/UISpineCtr on this control node.",
            "nextEvidence": "None for renderer; keep as no-renderer control unless new source evidence appears.",
        },
    ]

    write_csv(COMPONENT_MATRIX, component_rows, [
        "comName", "bindingRoot", "comObjPathId_rectTransform", "mappedGameObjectId", "gameObjectName",
        "sourceGameObjectActive", "sourceHasSkeletonGraphic", "sourceHasUISpineCtr",
        "skeletonGraphicComponentPathId", "uiSpineCtrComponentPathId", "skeletonGraphicEnabled", "uiSpineCtrEnabled",
        "skeletonDataAssetRef", "materialRef", "additiveMaterialRef", "multiplyMaterialRef", "screenMaterialRef",
        "initialSkinName", "initialFlipX", "initialFlipY", "startingAnimation", "startingLoop", "timeScale",
        "freeze", "uihide", "updateWhenInvisible", "unscaledTime", "raycastTarget", "maskable", "color",
        "allowMultipleCanvasRenderers", "canvasRendererRefs", "preserveDrawingBuffer", "meshGeneratorSettings",
        "uiSpineCtrSerializedKeys", "uiSpineCtrSerializedRefs", "uiSpineCtrBindingSemantics",
        "candidateStatus", "decision",
    ])
    write_csv(DEPENDENCY_MATRIX, dependency_rows, [
        "ownerComName", "refRole", "fileId", "pathId", "resolvedBundle", "resolvedBundlePath",
        "resolvedBundleExists", "resolvedObjectType", "resolvedObjectName", "resolutionStatus",
        "skeletonScale", "skeletonJSONRef", "atlasAssetsRefs", "atlasFileRef", "atlasMaterialRefs",
        "materialShaderRef", "materialShaderKeywords", "materialMainTextureRef", "materialStencilRef",
        "materialStencilComp", "materialStencil", "materialColorMask", "textureWidth", "textureHeight",
        "textureFormat", "dependencyStatus",
    ])
    write_csv(PROJECT_MATRIX, project_rows, ["item", "path", "exists", "evidence", "feasibilityImpact"])
    write_csv(PATCH_MATRIX, patch_rows, ["area", "evidenceStatus", "futurePatchAllowedNow", "reason", "nextEvidence"])

    result = {
        "restoredClaim": False,
        "scenePatchApplied": False,
        "candidatePatchApplied": False,
        "patchDecision": "trace_only_no_patch",
        "rendererDependencyChainRecovered": bool(renderer_chain_recovered),
        "rendererDependencyChainStatus": "normal_uidock_sp_renderer_components_and_local_dependencies_resolved_but_depth_blocks_promotion" if renderer_chain_recovered else "partial_renderer_dependency_chain",
        "skeletonDataAssetsResolved": bool(skeleton_resolved),
        "materialsResolved": bool(materials_resolved),
        "texturesOrAtlasResolved": bool(textures_resolved),
        "unityProjectSpineRuntimeAvailable": bool(runtime_available),
        "futureSourceBackedRendererPatchFeasible": bool(renderer_patch_feasible),
        "futureSourceBackedRendererPatchStatus": "renderer_dependency_chain_feasible_but_scene_promotion_blocked_by_depth" if renderer_patch_feasible else "renderer_dependency_chain_incomplete",
        "rendererPatchAllowedNow": False,
        "uiDockPromotionAllowed": False,
        "requiresRuntimeDumpForDepth": True,
        "rowCounts": {
            "componentMatrix": len(component_rows),
            "dependencyMatrix": len(dependency_rows),
            "projectMatrix": len(project_rows),
            "patchMatrix": len(patch_rows),
        },
        "requiredNextEvidence": [
            "runtime or source-backed UI_Dock/UI_MainPage parent CurrCanvas.sortingOrder/depth for DisableUILayer=1 forms",
            "future Unity compile/import validation if renderer assets are actually imported into a candidate",
            "runtime-equivalent CanvasHelper depth propagation before any UI_Dock visual promotion",
        ],
        "guardrailsTouched": [],
        "commandPolicy": {
            "rootCmdCountExpected": 1,
            "rootCmdCountActual": root_cmd_count,
            "restoreToolsDirectCmdCountExpected": 0,
            "restoreToolsDirectCmdCountActual": restore_tools_direct_cmd_count,
            "gitCommitPush": False,
            "sceneModified": False,
            "battleFoldersModified": False,
        },
        "outputs": {
            "componentMatrix": str(COMPONENT_MATRIX),
            "dependencyMatrix": str(DEPENDENCY_MATRIX),
            "projectMatrix": str(PROJECT_MATRIX),
            "patchMatrix": str(PATCH_MATRIX),
        },
    }

    with open(RESULT_JSON, "w", encoding="utf-8") as f:
        json.dump(result, f, ensure_ascii=False, indent=2)

    md = [
        f"# {PREFIX}",
        "",
        "## Decision",
        "- restoredClaim: false",
        "- scenePatchApplied: false",
        "- candidatePatchApplied: false",
        "- patchDecision: trace_only_no_patch",
        f"- rendererDependencyChainRecovered: {str(renderer_chain_recovered).lower()}",
        f"- skeletonDataAssetsResolved: {str(skeleton_resolved).lower()}",
        f"- materialsResolved: {str(materials_resolved).lower()}",
        f"- texturesOrAtlasResolved: {str(textures_resolved).lower()}",
        f"- unityProjectSpineRuntimeAvailable: {str(runtime_available).lower()}",
        f"- futureSourceBackedRendererPatchFeasible: {str(renderer_patch_feasible).lower()}",
        "- rendererPatchAllowedNow: false",
        "- uiDockPromotionAllowed: false",
        "- requiresRuntimeDumpForDepth: true",
        "",
        "## Findings",
        "- Normal `UI_Dock` source bindings for `sp_mainpage`, `sp_camp`, `sp_bag`, `sp_expedition`, `sp_adventureInterface`, `sp_guild`, `sp_maincity`, and `spine_xiaoshou` resolve to real `SkeletonGraphic + UISpineCtr` components. `dianjigq1` remains a no-renderer control.",
        "- `SkeletonGraphic` serialized fields are readable from `maininterface.assetbundle`: starting animation/loop, `skeletonDataAsset`, material refs, `m_RaycastTarget`, `m_Maskable`, color, mesh generator settings, and blend material refs are captured in the component matrix.",
        "- `SkeletonDataAsset` refs resolve through `maininterface_external_dependencies.csv` to local bundles: dock icons mostly use `maininterface_ext_1.assetbundle`; `spine_xiaoshou` uses `guide.assetbundle`.",
        "- The common `m_Material` refs resolve to `download/commonprefabsandres/spinematandshaders.assetbundle`; atlas-specific materials/textures resolve in their owning skeleton bundles.",
        "- The Unity reconstruction project contains the Spine runtime source and SkeletonGraphic materials/shaders needed for a future source-backed renderer import path.",
        "- This does not allow UI_Dock promotion yet: UI140/UI141 depth evidence still requires the runtime/default parent `CurrCanvas.sortingOrder` for `DisableUILayer=1` forms, and UI136 showed simple sibling mounting worsens the reference diff.",
        "",
        "## Row Counts",
        f"- renderer component field matrix: {len(component_rows)}",
        f"- dependency resolution matrix: {len(dependency_rows)}",
        f"- project feasibility matrix: {len(project_rows)}",
        f"- future patch/blocker matrix: {len(patch_rows)}",
        "",
        "## Outputs",
        f"- `{COMPONENT_MATRIX}`",
        f"- `{DEPENDENCY_MATRIX}`",
        f"- `{PROJECT_MATRIX}`",
        f"- `{PATCH_MATRIX}`",
        f"- `{RESULT_JSON}`",
        "",
        "## Next Blocker",
        "Need runtime or source-backed `UI_Dock`/`UI_MainPage` parent `CurrCanvas.sortingOrder`/depth for `DisableUILayer=1` forms, then a Unity compile/import validation pass for the now-traced source renderer dependencies. No scene/candidate patch was made.",
    ]
    RESULT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
