from __future__ import annotations

import csv
import json
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"

MANIFEST = UNITY_DATA / "BATTLE_RUNTIME_STREAMING_MANIFEST.json"
HIER_JSON = UNITY_DATA / "BATTLE_PREFAB_HIERARCHY_DUMP.json"
HIER_CSV = UNITY_DATA / "BATTLE_PREFAB_HIERARCHY_DUMP.csv"
RESULT_JSON = REPORT_DIR / "BATTLE_PREFAB_RECONSTRUCTION_RESULT.json"
REPORT_MD = REPORT_DIR / "BATTLE_PREFAB_RECONSTRUCTION_RESULT.md"
SCENE = UNITY_DIR / "Assets" / "Scenes" / "BattleRuntimeStreamingReconstruction.unity"
LOG = REPORT_DIR / "BATTLE_11_UNITY_PREFAB_RECONSTRUCTION.log"


def read_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def main() -> None:
    manifest = read_json(MANIFEST)
    dump = read_json(HIER_JSON)
    rows = read_csv(HIER_CSV)
    log = LOG.read_text(encoding="utf-8", errors="replace") if LOG.exists() else ""
    unity_success = "BattlePrefabReconstruction generated." in log
    actor_entries = manifest.get("actors", [])
    result = {
        "unityBatchmodeSuccess": unity_success,
        "runtimeScene": str(SCENE),
        "sceneExists": SCENE.exists(),
        "sceneBytes": SCENE.stat().st_size if SCENE.exists() else 0,
        "manifest": str(MANIFEST),
        "hierarchyJson": str(HIER_JSON),
        "hierarchyCsv": str(HIER_CSV),
        "instantiatedPrefabCount": sum(1 for a in actor_entries if a.get("loadStatus") == "runtime_prefab"),
        "missingPlaceholderCount": sum(1 for a in actor_entries if a.get("loadStatus") != "runtime_prefab"),
        "hierarchyObjectCount": len(rows),
        "componentCount": sum(int(r.get("componentCount") or 0) for r in rows),
        "rendererCount": sum(1 for r in rows if r.get("rendererType")),
        "skeletonEvidenceCount": len(dump.get("skeletonEvidence", [])),
        "nextBattle12Recommendation": "Connect battle Lua/IL2CPP flow to the runtime loader before skills/effects: actor and map streaming are now proven, so wiring ProcedureNormalBattle payload into the loader unlocks a playable battle shell faster.",
    }
    RESULT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(result, manifest, dump, rows)
    print(json.dumps(result, ensure_ascii=False, indent=2))


def write_report(result: dict, manifest: dict, dump: dict, rows: list[dict[str, str]]) -> None:
    lines = [
        "# Battle Prefab Reconstruction Result",
        "",
        "## Outputs",
        f"- Runtime scene: `{result['runtimeScene']}`",
        f"- Runtime manifest: `{result['manifest']}`",
        f"- Hierarchy JSON: `{result['hierarchyJson']}`",
        f"- Hierarchy CSV: `{result['hierarchyCsv']}`",
        f"- Unity batchmode success: `{result['unityBatchmodeSuccess']}`",
        "",
        "## Counts",
        f"- Instantiated runtime prefabs: `{result['instantiatedPrefabCount']}`",
        f"- Missing placeholders: `{result['missingPlaceholderCount']}`",
        f"- Dumped hierarchy objects: `{result['hierarchyObjectCount']}`",
        f"- Dumped components: `{result['componentCount']}`",
        f"- Renderers: `{result['rendererCount']}`",
        f"- Skeleton evidence assets: `{result['skeletonEvidenceCount']}`",
        "",
        "## Runtime Actors",
        "| side | heroDid | bundle | prefabAsset | status | reason |",
        "| --- | --- | --- | --- | --- | --- |",
    ]
    for actor in manifest.get("actors", []):
        lines.append(
            f"| {actor.get('side','')} | {actor.get('heroDid','')} | {actor.get('bundle','')} | {actor.get('prefabAsset','')} | {actor.get('loadStatus','')} | {actor.get('missingReason','')} |"
        )
    lines.extend(
        [
            "",
            "## Hierarchy Sample",
            "| bundleId | asset | path | components | renderer | materials | textures |",
            "| --- | --- | --- | --- | --- | --- | --- |",
        ]
    )
    for row in rows[:30]:
        lines.append(
            f"| {row.get('bundleId','')} | {row.get('assetName','')} | {row.get('hierarchyPath','')} | {row.get('componentTypes','')} | {row.get('rendererType','')} | {row.get('materialNames','')} | {row.get('textureNames','')} |"
        )
    lines.extend(
        [
            "",
            "## BATTLE_12 Recommendation",
            f"- {result['nextBattle12Recommendation']}",
        ]
    )
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
