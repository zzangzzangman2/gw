from __future__ import annotations

import csv
import json
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = BASE / "reports" / "battle"
UNITY_DIR = BASE / "girlswar_battle_unity"
SCENES_DIR = UNITY_DIR / "Assets" / "Scenes"
RESTORE_DATA_DIR = UNITY_DIR / "Assets" / "RestoreData" / "battle"
EDITOR_SCRIPT = UNITY_DIR / "Assets" / "Editor" / "BattlePrototypeSceneBuilder.cs"
MANIFEST_PATH = RESTORE_DATA_DIR / "BATTLE_PROTOTYPE_MANIFEST.json"
PAYLOAD_PATH = RESTORE_DATA_DIR / "BATTLE_TEST_PAYLOAD.json"
RESOURCE_INDEX_PATH = RESTORE_DATA_DIR / "resource_index.csv"
SCENE_PATH = SCENES_DIR / "BattlePrototype.unity"
RESULT_JSON = SCENES_DIR / "BATTLE_07_SCENE_BUILD_RESULT.json"
RESULT_MD = REPORT_DIR / "BATTLE_MINIMAL_SCENE_BUILD_RESULT.md"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def read_resource_index(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def unity_yaml_string(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', '\\"')


def scene_line(name: str, x: float, y: float, label: str) -> str:
    return f"- name: \"{unity_yaml_string(name)}\"\n  position: {{x: {x:.2f}, y: {y:.2f}, z: 0}}\n  annotation: \"{unity_yaml_string(label)}\"\n"


def write_scene_draft(manifest: dict[str, Any], payload: dict[str, Any], missing_bundle_count: int) -> dict[str, Any]:
    SCENES_DIR.mkdir(parents=True, exist_ok=True)
    summary = manifest.get("summary", {})
    actors = manifest.get("actors", [])
    our = [a for a in actors if a.get("side") == "our"]
    enemy = [a for a in actors if a.get("side") == "enemy"]
    map_info = manifest.get("map", {})
    map_bundles = map_info.get("bundles", [])
    map_bundle_text = "; ".join(b.get("bundle", "") for b in map_bundles) or "missing map bundle annotation"

    object_count = 0
    placeholder_count = 0
    lines = [
        "%YAML 1.1",
        "%TAG !u! tag:unity3d.com,2011:",
        "# Offline-generated minimal battle prototype scene.",
        "# Open the project in Unity and run GirlsWar/Battle/Build Minimal Prototype Scene to regenerate native serialized objects.",
        "--- !u!114 &100000",
        "MonoBehaviour:",
        "  m_Name: BattlePrototypeOfflineManifest",
        "  manifestPath: Assets/RestoreData/battle/BATTLE_PROTOTYPE_MANIFEST.json",
        "  payloadPath: Assets/RestoreData/battle/BATTLE_TEST_PAYLOAD.json",
        f"  mapId: {summary.get('mapId')}",
        f"  battleType: {summary.get('battleType')}",
        f"  randomSeed: {summary.get('randomSeed')}",
        f"  missingBundleCount: {missing_bundle_count}",
        "  objects:",
    ]

    lines.append(scene_line("BattlePrototypeRoot", 0, 0, "root: battle camera/canvas placeholder"))
    object_count += 1
    lines.append(scene_line("BattleCamera", 0, 0, "orthographic camera placeholder"))
    object_count += 1
    lines.append(scene_line("Map_11001_Background", 0, 1.3, f"mapId={summary.get('mapId')} bundle={map_bundle_text}"))
    object_count += 1
    placeholder_count += 1

    for idx, actor in enumerate(our):
        x = -4.5 + idx * 1.8
        label = (
            f"side=our heroDid={actor.get('payloadHeroDid')} heroId={actor.get('payloadHeroId')} "
            f"model={actor.get('modelId')} prefab={actor.get('prefabId')} bundle={actor.get('actorBundle')} "
            f"exists={actor.get('actorBundleExists')}"
        )
        lines.append(scene_line(f"OurActor_{idx + 1}_{actor.get('payloadHeroDid')}", x, -1.7, label))
        object_count += 1
        placeholder_count += 1

    for idx, actor in enumerate(enemy):
        wave = actor.get("waveNo") or ((idx // 3) + 1)
        lane = idx % 3
        x = 0.6 + lane * 1.8
        y = 1.6 - (int(wave) - 1) * 1.25
        label = (
            f"side=enemy wave={wave} heroDid={actor.get('payloadHeroDid')} heroId={actor.get('payloadHeroId')} "
            f"model={actor.get('modelId')} prefab={actor.get('prefabId')} bundle={actor.get('actorBundle') or 'missing'}"
        )
        lines.append(scene_line(f"EnemyActor_W{wave}_{lane + 1}_{actor.get('payloadHeroDid')}", x, y, label))
        object_count += 1
        placeholder_count += 1

    skill_summary = (
        f"uniqueSkills={len(summary.get('skillDids', []))} "
        f"skillRows={len(manifest.get('skills', []))} "
        f"bundleMissing={missing_bundle_count}"
    )
    lines.append(scene_line("SkillResourceSummary", 0, -3.4, skill_summary))
    object_count += 1

    SCENE_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return {
        "scenePath": str(SCENE_PATH),
        "objectCount": object_count,
        "actorPlaceholderCount": len(our) + len(enemy),
        "mapPlaceholderCount": 1,
        "placeholderCount": placeholder_count,
        "ourActorCount": len(our),
        "enemyActorCount": len(enemy),
    }


def write_result_md(result: dict[str, Any]) -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    lines = [
        "# Battle Minimal Scene Build Result",
        "",
        "## Generated Scene",
        f"- Scene: `{result['scenePath']}`",
        f"- Editor script: `{result['editorScript']}`",
        f"- Manifest: `{result['manifestPath']}`",
        f"- Payload: `{result['payloadPath']}`",
        "",
        "## Counts",
        f"- GameObject/entry count: `{result['objectCount']}`",
        f"- Actor placeholders: `{result['actorPlaceholderCount']}` (`our={result['ourActorCount']}`, `enemy={result['enemyActorCount']}`)",
        f"- Map placeholders: `{result['mapPlaceholderCount']}`",
        f"- Missing referenced bundles: `{result['missingBundleCount']}`",
        "",
        "## Payload",
        f"- mapId: `{result['mapId']}`",
        f"- battleType: `{result['battleType']}`",
        f"- randomSeed: `{result['randomSeed']}`",
        "",
        "## Next Command",
        "- `_restore_tools\\BATTLE_08_PREPARE_ASSETBUNDLE_SPINE_LOADING.cmd`",
    ]
    RESULT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    SCENES_DIR.mkdir(parents=True, exist_ok=True)
    RESTORE_DATA_DIR.mkdir(parents=True, exist_ok=True)
    if not EDITOR_SCRIPT.exists():
        raise SystemExit("Missing Editor skeleton. Run BATTLE_06 first.")
    if not MANIFEST_PATH.exists() or not PAYLOAD_PATH.exists():
        raise SystemExit("Missing copied manifest/payload. Run BATTLE_06 first.")

    manifest = read_json(MANIFEST_PATH)
    payload = read_json(PAYLOAD_PATH)
    resources = read_resource_index(RESOURCE_INDEX_PATH)
    missing_bundle_count = sum(1 for row in resources if str(row.get("exists", "")).lower() == "false")
    if not resources:
        missing_bundle_count = int(manifest.get("verification", {}).get("bundleReferences", {}).get("missing", 0))

    scene_stats = write_scene_draft(manifest, payload, missing_bundle_count)
    summary = manifest.get("summary", {})
    result = {
        "status": "scene_draft_generated",
        "scenePath": "Assets/Scenes/BattlePrototype.unity",
        "absoluteScenePath": str(SCENE_PATH),
        "editorScript": "Assets/Editor/BattlePrototypeSceneBuilder.cs",
        "manifestPath": "Assets/RestoreData/battle/BATTLE_PROTOTYPE_MANIFEST.json",
        "payloadPath": "Assets/RestoreData/battle/BATTLE_TEST_PAYLOAD.json",
        "mapId": summary.get("mapId"),
        "battleType": summary.get("battleType"),
        "randomSeed": summary.get("randomSeed"),
        "missingBundleCount": missing_bundle_count,
        "nextCommand": str(BASE / "_restore_tools" / "BATTLE_08_PREPARE_ASSETBUNDLE_SPINE_LOADING.cmd"),
        **scene_stats,
    }
    RESULT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    write_result_md(result)
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
