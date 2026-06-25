from __future__ import annotations

import json
import shutil
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
REPORT_DIR = BASE / "reports" / "battle"
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
VISUAL_ROOT = UNITY_DATA / "VisualAssets"
LOAD_MAP = UNITY_DATA / "BATTLE_ASSETBUNDLE_LOAD_MAP.json"
VISUAL_MANIFEST = UNITY_DATA / "BATTLE_ASSET_BACKED_PREVIEW_VISUALS.json"
RESULT_JSON = REPORT_DIR / "BATTLE_ASSET_BACKED_PREVIEW_RESULT.json"
RESULT_MD = REPORT_DIR / "BATTLE_ASSET_BACKED_PREVIEW_RESULT.md"
SCENE_PATH = UNITY_DIR / "Assets" / "Scenes" / "BattleAssetBackedPreview.unity"


def asset_path_for_unity(path: Path) -> str:
    return str(path.relative_to(UNITY_DIR)).replace("\\", "/")


def source_path(relative: str) -> Path:
    return MERGED / relative


def copy_asset(src_relative: str, dst_subdir: str, dst_name: str | None = None) -> dict[str, Any]:
    src = source_path(src_relative)
    dst_dir = VISUAL_ROOT / dst_subdir
    dst_dir.mkdir(parents=True, exist_ok=True)
    dst = dst_dir / (dst_name or src.name)
    copied = False
    if src.exists():
        shutil.copy2(src, dst)
        copied = True
    return {
        "source": str(src),
        "sourceRelative": src_relative,
        "copied": copied,
        "unityAssetPath": asset_path_for_unity(dst) if copied else "",
        "bytes": dst.stat().st_size if copied else 0,
    }


def choose_map_layers(map_candidates: list[dict[str, Any]]) -> list[dict[str, Any]]:
    scored = []
    for row in map_candidates:
        try:
            w = int(row.get("width") or 0)
            h = int(row.get("height") or 0)
        except ValueError:
            w = h = 0
        name = str(row.get("name") or "")
        priority = 0
        if name == "Map_11001_2":
            priority = 100
        elif name == "Map_11001_3":
            priority = 90
        elif row.get("assetType") == "Texture2D":
            priority = 80
        scored.append((priority, w * h, row))
    scored.sort(reverse=True, key=lambda item: (item[0], item[1]))
    return [item[2] for item in scored[:3]]


def main() -> None:
    data = json.loads(LOAD_MAP.read_text(encoding="utf-8"))
    VISUAL_ROOT.mkdir(parents=True, exist_ok=True)
    (VISUAL_ROOT / "map").mkdir(parents=True, exist_ok=True)
    (VISUAL_ROOT / "actors").mkdir(parents=True, exist_ok=True)
    (VISUAL_ROOT / "evidence").mkdir(parents=True, exist_ok=True)

    map_layers = []
    for row in choose_map_layers(data.get("mapCandidates", [])):
        copied = copy_asset(row.get("output", ""), "map", row.get("name", "map_layer") + ".png")
        map_layers.append({**row, **copied})

    actors = []
    for actor in data.get("actors", []):
        hero_did = str(actor.get("heroDid", ""))
        actor_entry = dict(actor)
        actor_entry["textureAsset"] = copy_asset(actor.get("texture", ""), f"actors/{hero_did}", f"{hero_did}_texture.png") if actor.get("texture") else {"copied": False, "unityAssetPath": ""}
        actor_entry["skelEvidence"] = copy_asset(actor.get("skeletonData", ""), f"actors/{hero_did}", f"{hero_did}.skel.txt") if actor.get("skeletonData") else {"copied": False, "unityAssetPath": ""}
        actor_entry["atlasEvidence"] = copy_asset(actor.get("atlas", ""), f"actors/{hero_did}", f"{hero_did}.atlas.txt") if actor.get("atlas") else {"copied": False, "unityAssetPath": ""}
        actor_entry["visualStatus"] = "texture_billboard" if actor_entry["textureAsset"].get("copied") else "placeholder_missing"
        actors.append(actor_entry)

    visual_manifest = {
        "status": "visual_assets_prepared",
        "scene": "Assets/Scenes/BattleAssetBackedPreview.unity",
        "loadMap": "Assets/RestoreData/battle/BATTLE_ASSETBUNDLE_LOAD_MAP.json",
        "mapId": data.get("mapId"),
        "battleType": data.get("battleType"),
        "randomSeed": data.get("randomSeed"),
        "mapLayers": map_layers,
        "actors": actors,
        "summary": {
            "visualAssetCopiedCount": sum(1 for layer in map_layers if layer.get("copied")) + sum(1 for actor in actors if actor["textureAsset"].get("copied")) + sum(1 for actor in actors if actor["skelEvidence"].get("copied")) + sum(1 for actor in actors if actor["atlasEvidence"].get("copied")),
            "mapLayerCount": sum(1 for layer in map_layers if layer.get("copied")),
            "actorTextureFallbackCount": sum(1 for actor in actors if actor.get("visualStatus") == "texture_billboard"),
            "missingPlaceholderCount": sum(1 for actor in actors if actor.get("visualStatus") != "texture_billboard"),
            "actorTotal": len(actors),
        },
        "nextStepRecommendation": "AssetBundle streaming is faster next than full Spine runtime import: texture/evidence paths are already staged, while Spine runtime needs package/API compatibility work.",
    }
    VISUAL_MANIFEST.write_text(json.dumps(visual_manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    result = {
        "status": "visual_assets_prepared",
        "visualManifest": str(VISUAL_MANIFEST),
        "scenePath": str(SCENE_PATH),
        **visual_manifest["summary"],
    }
    RESULT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(visual_manifest, result)
    print(json.dumps(result, ensure_ascii=False, indent=2))


def write_report(visual_manifest: dict[str, Any], result: dict[str, Any]) -> None:
    lines = [
        "# Battle Asset-Backed Preview Result",
        "",
        "## Outputs",
        f"- Visual manifest: `{VISUAL_MANIFEST}`",
        f"- Scene target: `{SCENE_PATH}`",
        f"- Result JSON: `{RESULT_JSON}`",
        "",
        "## Counts",
        f"- Visual assets copied: `{result['visualAssetCopiedCount']}`",
        f"- Map layers: `{result['mapLayerCount']}`",
        f"- Actor texture fallbacks: `{result['actorTextureFallbackCount']}`",
        f"- Missing placeholders: `{result['missingPlaceholderCount']}`",
        "",
        "## Map Layers",
        "| name | type | size | unity asset |",
        "| --- | --- | --- | --- |",
    ]
    for layer in visual_manifest["mapLayers"]:
        lines.append(f"| {layer.get('name')} | {layer.get('assetType')} | {layer.get('width')}x{layer.get('height')} | {layer.get('unityAssetPath')} |")
    lines.extend(["", "## Actor Visuals", "| side | heroDid | visual | texture | missing reason |", "| --- | --- | --- | --- | --- |"])
    for actor in visual_manifest["actors"]:
        reason = actor.get("loadStatus", "")
        lines.append(f"| {actor.get('side')} | {actor.get('heroDid')} | {actor.get('visualStatus')} | {actor.get('textureAsset', {}).get('unityAssetPath', '')} | {reason} |")
    lines.extend(
        [
            "",
            "## Next Step",
            f"- {visual_manifest['nextStepRecommendation']}",
            "- Next command should create an AssetBundle streaming probe using the staged `BATTLE_ASSET_BACKED_PREVIEW_VISUALS.json` and original clean UnityFS slices.",
        ]
    )
    RESULT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
