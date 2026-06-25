from __future__ import annotations

import csv
import json
from pathlib import Path
from typing import Any

import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_VIDEO = BASE / "reports" / "video_reference"
INDEX_DIR = BASE / "girlswar_merged_extracted" / "indexes"

ATTACH_MANIFEST = UNITY_DATA / "BATTLE_FLOW_WITH_HUD_ATTACH_MANIFEST.json"
TYPE_RESULT = UNITY_DATA / "BATTLE_UI_COMPONENT_TYPE_RECONSTRUCTION_RESULT.json"
CANDIDATES_JSON = UNITY_DATA / "BATTLE_HUD_SPRITE_REGION_FONT_JOIN_CANDIDATES.json"
COMPONENT_CSV = UNITY_DATA / "BATTLE_HUD_SPRITE_REGION_FONT_JOIN_COMPONENTS.csv"
UNITY_MANIFEST = UNITY_DATA / "BATTLE_HUD_SPRITE_REGION_FONT_JOIN_UNITY_MANIFEST.json"

SPRITE_BUNDLES = [
    "download/artsources/uispriteres/uibattle.assetbundle",
    "download/artsources/uispriteres/uibufficon.assetbundle",
    "download/artsources/uispriteres/uihurtnum.assetbundle",
    "download/artsources/uispriteres/uiheroheadbattle.assetbundle",
    "download/artsources/uispriteres/uiminebattle.assetbundle",
    "download/artsources/uispriteres/autohelper.assetbundle",
    "download/ui/uiprefabandres/battle.assetbundle",
    "download/ui/uiprefabandres/battle_ext_prefabs.assetbundle",
    "download/ui/uiprefabandres/autohelper_ext_3.assetbundle",
]


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def bundle_path(bundle: str) -> str:
    return str(BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices" / Path(bundle.replace("/", "\\")))


def ref(tree: dict[str, Any], *keys: str) -> dict[str, int]:
    node: Any = tree
    for key in keys:
        if not isinstance(node, dict):
            return {"fileID": 0, "pathID": 0}
        node = node.get(key, {})
    if isinstance(node, dict):
        return {"fileID": int(node.get("m_FileID") or 0), "pathID": int(node.get("m_PathID") or 0)}
    return {"fileID": 0, "pathID": 0}


def pptr_string(pptr: dict[str, int]) -> str:
    return f"{pptr.get('fileID', 0)}:{pptr.get('pathID', 0)}"


def script_map(env: UnityPy.Environment) -> dict[int, dict[str, str]]:
    out: dict[int, dict[str, str]] = {}
    for obj in env.objects:
        if obj.type.name == "MonoScript":
            data = obj.read()
            out[int(obj.path_id)] = {
                "className": getattr(data, "m_ClassName", "") or "",
                "namespace": getattr(data, "m_Namespace", "") or "",
                "assemblyName": getattr(data, "m_AssemblyName", "") or "",
            }
    return out


def hierarchy_maps(env: UnityPy.Environment) -> tuple[dict[int, str], dict[int, int], dict[int, int], dict[int, int]]:
    go_name: dict[int, str] = {}
    go_transform: dict[int, int] = {}
    transform_go: dict[int, int] = {}
    transform_parent: dict[int, int] = {}
    for obj in env.objects:
        if obj.type.name == "GameObject":
            tr = obj.read_typetree()
            go_name[int(obj.path_id)] = tr.get("m_Name", "")
            for comp in tr.get("m_Component", []):
                cid = int(comp.get("component", {}).get("m_PathID") or 0)
                # The actual transform type is identified in the next pass.
                if cid:
                    pass
        elif obj.type.name in {"RectTransform", "Transform"}:
            tr = obj.read_typetree()
            tid = int(obj.path_id)
            gid = int(tr.get("m_GameObject", {}).get("m_PathID") or 0)
            parent = int(tr.get("m_Father", {}).get("m_PathID") or 0)
            transform_go[tid] = gid
            go_transform[gid] = tid
            transform_parent[tid] = parent
    return go_name, go_transform, transform_go, transform_parent


def path_for(go_id: int, go_name: dict[int, str], go_transform: dict[int, int], transform_go: dict[int, int], transform_parent: dict[int, int]) -> str:
    tid = go_transform.get(go_id, 0)
    names: list[str] = []
    guard = 0
    while tid and guard < 80:
        gid = transform_go.get(tid, 0)
        names.append(go_name.get(gid, f"go_{gid}"))
        tid = transform_parent.get(tid, 0)
        guard += 1
    return "/".join(reversed([n for n in names if n]))


def collect_prefab_components(attachments: list[dict[str, Any]]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    by_bundle: dict[str, list[dict[str, Any]]] = {}
    for item in attachments:
        by_bundle.setdefault(item["absolutePath"], []).append(item)
    for absolute, items in by_bundle.items():
        env = UnityPy.load(absolute)
        scripts = script_map(env)
        go_name, go_transform, transform_go, transform_parent = hierarchy_maps(env)
        asset_by_path = {}
        for obj in env.objects:
            try:
                data = obj.read()
                asset_by_path[int(obj.path_id)] = getattr(data, "m_Name", "") or getattr(data, "name", "") or ""
            except Exception:
                pass
        target_prefabs = {Path(i["prefabAsset"]).name.lower(): i for i in items}
        # UnityPy typetree does not expose prefab ownership directly, so keep bundle-level
        # component evidence and let Unity scene probe map runtime roots.
        for obj in env.objects:
            if obj.type.name != "MonoBehaviour":
                continue
            tree = obj.read_typetree()
            sid = int(tree.get("m_Script", {}).get("m_PathID") or 0)
            script = scripts.get(sid, {})
            cls = script.get("className", "")
            if cls not in {"Image", "YouYouImage", "RawImage", "Text", "TextMeshProUGUI", "Button"}:
                continue
            go_id = int(tree.get("m_GameObject", {}).get("m_PathID") or 0)
            sprite = ref(tree, "m_Sprite")
            material = ref(tree, "m_Material")
            font = ref(tree, "m_FontData", "m_Font")
            font_asset = ref(tree, "m_fontAsset")
            shared_material = ref(tree, "m_sharedMaterial")
            target_graphic = ref(tree, "m_TargetGraphic")
            texture = ref(tree, "m_Texture")
            role = "unknown/log-only"
            if cls in {"Image", "YouYouImage", "RawImage"}:
                role = "visual image"
            elif cls in {"Text", "TextMeshProUGUI"}:
                role = "text/font"
            elif cls == "Button":
                role = "button/raycast"
            rows.append(
                {
                    "bundle": next((i["bundle"] for i in items), ""),
                    "componentPathId": int(obj.path_id),
                    "gameObjectPathId": go_id,
                    "hierarchyPath": path_for(go_id, go_name, go_transform, transform_go, transform_parent),
                    "componentType": f"{script.get('namespace', '')}.{cls}".strip("."),
                    "role": role,
                    "spriteRef": pptr_string(sprite),
                    "materialRef": pptr_string(material),
                    "fontRef": pptr_string(font),
                    "fontAssetRef": pptr_string(font_asset),
                    "sharedMaterialRef": pptr_string(shared_material),
                    "targetGraphicRef": pptr_string(target_graphic),
                    "textureRef": pptr_string(texture),
                    "textSample": (tree.get("m_text") or tree.get("m_Text") or "")[:80],
                    "confidence": "explicit_pptr" if any(pptr_string(x) != "0:0" for x in [sprite, material, font, font_asset, shared_material, target_graphic, texture]) else "component_only",
                    "unresolvedReason": "" if any(pptr_string(x) != "0:0" for x in [sprite, material, font, font_asset, shared_material, target_graphic, texture]) else "no_serialized_sprite_font_material_pptr",
                }
            )
    return rows


def collect_sprite_index() -> list[dict[str, Any]]:
    out: list[dict[str, Any]] = []
    images_csv = INDEX_DIR / "unity_images.csv"
    if images_csv.exists():
        with images_csv.open("r", encoding="utf-8-sig", newline="") as f:
            for row in csv.DictReader(f):
                if row.get("bundle") in SPRITE_BUNDLES and row.get("type") == "Sprite":
                    out.append(row)
    return out


def main() -> None:
    UNITY_DATA.mkdir(parents=True, exist_ok=True)
    manifest = read_json(ATTACH_MANIFEST)
    type_result = read_json(TYPE_RESULT)
    attachments = manifest.get("attachments", [])
    component_rows = collect_prefab_components(attachments)
    sprite_index = collect_sprite_index()
    explicit_sprite_refs = [r for r in component_rows if r["spriteRef"] != "0:0" or r["textureRef"] != "0:0"]
    explicit_font_refs = [r for r in component_rows if r["fontRef"] != "0:0" or r["fontAssetRef"] != "0:0" or r["sharedMaterialRef"] != "0:0"]

    unity_manifest = {
        "status": "battle_hud_sprite_region_font_join_manifest_ready",
        "sourceTypeResult": str(TYPE_RESULT),
        "attachments": attachments,
        "spriteBundles": [{"bundle": b, "absolutePath": bundle_path(b), "exists": Path(bundle_path(b)).exists()} for b in SPRITE_BUNDLES],
        "scene": "Assets/Scenes/BattleRuntimeFlowWithHudSpriteFontJoin.unity",
        "capture": "Assets/RestoreCaptures/battle_hud/BattleRuntimeFlowWithHudSpriteFontJoin_1680x720.png",
        "videoReference": {
            "motionReport": str(REPORT_VIDEO / "PLAY_REFERENCE_VIDEO_MOTION_ANALYSIS.md"),
            "restoreNotes": str(REPORT_VIDEO / "PLAY_REFERENCE_RESTORE_NOTES.md"),
            "topCenterOverlayPolicy": "recording_touch_artifact_not_final_hud",
        },
        "typeProbeBefore": type_result.get("summary", {}),
    }
    candidates = {
        "status": "battle_hud_sprite_region_font_join_candidates_ready",
        "componentCandidateCount": len(component_rows),
        "explicitSpriteOrTextureRefCount": len(explicit_sprite_refs),
        "explicitFontOrMaterialRefCount": len(explicit_font_refs),
        "spriteIndexCount": len(sprite_index),
        "spriteBundles": unity_manifest["spriteBundles"],
        "components": component_rows,
        "videoReference": unity_manifest["videoReference"],
    }
    CANDIDATES_JSON.write_text(json.dumps(candidates, ensure_ascii=False, indent=2), encoding="utf-8")
    UNITY_MANIFEST.write_text(json.dumps(unity_manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    with COMPONENT_CSV.open("w", newline="", encoding="utf-8-sig") as f:
        fieldnames = list(component_rows[0].keys()) if component_rows else ["bundle", "componentPathId"]
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(component_rows)
    print(json.dumps({
        "candidates": str(CANDIDATES_JSON),
        "componentCandidateCount": len(component_rows),
        "explicitSpriteOrTextureRefCount": len(explicit_sprite_refs),
        "explicitFontOrMaterialRefCount": len(explicit_font_refs),
        "spriteIndexCount": len(sprite_index),
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
