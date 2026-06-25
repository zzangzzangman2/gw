from __future__ import annotations

import json
import re
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
SCENE_PATH = UNITY_DIR / "Assets" / "Scenes" / "BattlePrototype.unity"
RESULT_JSON = UNITY_DIR / "Assets" / "Scenes" / "BATTLE_07_SCENE_BUILD_RESULT.json"
REPORT_MD = BASE / "reports" / "battle" / "BATTLE_MINIMAL_SCENE_BUILD_RESULT.md"
UNITY_LOG = BASE / "reports" / "battle" / "BATTLE_07_UNITY_BATCHMODE.log"


def count(pattern: str, text: str) -> int:
    return len(re.findall(pattern, text))


def main() -> None:
    scene_text = SCENE_PATH.read_text(encoding="utf-8", errors="replace") if SCENE_PATH.exists() else ""
    log_text = UNITY_LOG.read_text(encoding="utf-8", errors="replace") if UNITY_LOG.exists() else ""
    result = json.loads(RESULT_JSON.read_text(encoding="utf-8")) if RESULT_JSON.exists() else {}
    unity_success = "BattlePrototype scene generated. actors=12, missingBundles=4" in log_text
    result.update(
        {
            "status": "unity_batchmode_generated" if unity_success else result.get("status", "scene_draft_generated"),
            "sceneExists": SCENE_PATH.exists(),
            "sceneFileBytes": SCENE_PATH.stat().st_size if SCENE_PATH.exists() else 0,
            "unityBatchmodeLog": str(UNITY_LOG),
            "unityBatchmodeSuccess": unity_success,
            "verifiedPatternCounts": {
                "OurActor": count("OurActor_", scene_text),
                "EnemyActor": count("EnemyActor_", scene_text),
                "Map_11001": count("Map_11001", scene_text),
                "SkillResourceSummary": count("SkillResourceSummary", scene_text),
                "BattlePrototypeRoot": count("BattlePrototypeRoot", scene_text),
            },
        }
    )
    RESULT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    lines = [
        "# Battle Minimal Scene Build Result",
        "",
        "## Generated Scene",
        f"- Scene: `{SCENE_PATH}`",
        "- Editor script: `Assets/Editor/BattlePrototypeSceneBuilder.cs`",
        "- Manifest: `Assets/RestoreData/battle/BATTLE_PROTOTYPE_MANIFEST.json`",
        "- Payload: `Assets/RestoreData/battle/BATTLE_TEST_PAYLOAD.json`",
        f"- Unity batchmode success: `{unity_success}`",
        "",
        "## Counts",
        f"- GameObject/entry count: `{result.get('objectCount', 0)}`",
        f"- Actor placeholders: `{result.get('actorPlaceholderCount', 0)}` (`our={result.get('ourActorCount', 0)}`, `enemy={result.get('enemyActorCount', 0)}`)",
        f"- Scene pattern check: `OurActor={result['verifiedPatternCounts']['OurActor']}`, `EnemyActor={result['verifiedPatternCounts']['EnemyActor']}`",
        f"- Map placeholders: `{result.get('mapPlaceholderCount', 0)}`",
        f"- Missing referenced bundles: `{result.get('missingBundleCount', 0)}`",
        "",
        "## Payload",
        f"- mapId: `{result.get('mapId')}`",
        f"- battleType: `{result.get('battleType')}`",
        f"- randomSeed: `{result.get('randomSeed')}`",
        "",
        "## Next Command",
        "- `_restore_tools\\BATTLE_08_PREPARE_ASSETBUNDLE_SPINE_LOADING.cmd`",
    ]
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
