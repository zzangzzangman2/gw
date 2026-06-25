from __future__ import annotations

import json
import re
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
SCENE = UNITY_DIR / "Assets" / "Scenes" / "BattleAssetBackedPreview.unity"
VISUAL_MANIFEST = UNITY_DIR / "Assets" / "RestoreData" / "battle" / "BATTLE_ASSET_BACKED_PREVIEW_VISUALS.json"
RESULT_JSON = BASE / "reports" / "battle" / "BATTLE_ASSET_BACKED_PREVIEW_RESULT.json"
RESULT_MD = BASE / "reports" / "battle" / "BATTLE_ASSET_BACKED_PREVIEW_RESULT.md"
UNITY_LOG = BASE / "reports" / "battle" / "BATTLE_09_UNITY_ASSET_BACKED_PREVIEW.log"


def main() -> None:
    manifest = json.loads(VISUAL_MANIFEST.read_text(encoding="utf-8"))
    result = json.loads(RESULT_JSON.read_text(encoding="utf-8")) if RESULT_JSON.exists() else {}
    log_text = UNITY_LOG.read_text(encoding="utf-8", errors="replace") if UNITY_LOG.exists() else ""
    scene_text = SCENE.read_text(encoding="utf-8", errors="replace") if SCENE.exists() else ""
    unity_success = "BattleAssetBackedPreview generated." in log_text
    verified = {
        "status": "unity_scene_generated" if unity_success else "visual_assets_prepared",
        "scenePath": str(SCENE),
        "sceneExists": SCENE.exists(),
        "sceneBytes": SCENE.stat().st_size if SCENE.exists() else 0,
        "visualManifest": str(VISUAL_MANIFEST),
        "unityLog": str(UNITY_LOG),
        "unityBatchmodeSuccess": unity_success,
        "visualAssetCopiedCount": manifest["summary"]["visualAssetCopiedCount"],
        "mapLayerCount": manifest["summary"]["mapLayerCount"],
        "actorTextureFallbackCount": manifest["summary"]["actorTextureFallbackCount"],
        "missingPlaceholderCount": manifest["summary"]["missingPlaceholderCount"],
        "scenePatternCounts": {
            "TextureActor": len(re.findall("TextureActor_", scene_text)),
            "MissingActor": len(re.findall("MissingActor_", scene_text)),
            "MapLayer": len(re.findall("MapLayer_", scene_text)),
        },
        "nextStepRecommendation": manifest["nextStepRecommendation"],
    }
    result.update(verified)
    RESULT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    refresh_md(manifest, result)
    print(json.dumps(result, ensure_ascii=False, indent=2))


def refresh_md(manifest: dict, result: dict) -> None:
    lines = [
        "# Battle Asset-Backed Preview Result",
        "",
        "## Outputs",
        f"- Scene: `{result['scenePath']}`",
        f"- Visual manifest: `{result['visualManifest']}`",
        f"- Unity log: `{result['unityLog']}`",
        f"- Unity batchmode success: `{result['unityBatchmodeSuccess']}`",
        "",
        "## Counts",
        f"- Visual assets copied: `{result['visualAssetCopiedCount']}`",
        f"- Map layers: `{result['mapLayerCount']}`",
        f"- Actor texture fallbacks: `{result['actorTextureFallbackCount']}`",
        f"- Missing placeholders: `{result['missingPlaceholderCount']}`",
        f"- Scene pattern counts: `{result['scenePatternCounts']}`",
        "",
        "## Map Layers",
        "| name | type | size | unity asset |",
        "| --- | --- | --- | --- |",
    ]
    for layer in manifest["mapLayers"]:
        lines.append(f"| {layer.get('name')} | {layer.get('assetType')} | {layer.get('width')}x{layer.get('height')} | {layer.get('unityAssetPath')} |")
    lines.extend(["", "## Actor Visuals", "| side | heroDid | visual | texture | missing reason |", "| --- | --- | --- | --- | --- |"])
    for actor in manifest["actors"]:
        lines.append(f"| {actor.get('side')} | {actor.get('heroDid')} | {actor.get('visualStatus')} | {actor.get('textureAsset', {}).get('unityAssetPath', '')} | {actor.get('loadStatus', '')} |")
    lines.extend(["", "## Next Step", f"- {result['nextStepRecommendation']}"])
    RESULT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
