from __future__ import annotations

import json
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"

FLOW_MANIFEST = UNITY_DATA / "BATTLE_RUNTIME_FLOW_MANIFEST.json"
SCENE = UNITY_DIR / "Assets" / "Scenes" / "BattleRuntimeFlowPrototype.unity"
LOG = REPORT_DIR / "BATTLE_12_UNITY_RUNTIME_FLOW.log"
RESULT_JSON = REPORT_DIR / "BATTLE_RUNTIME_FLOW_LINK_RESULT.json"
REPORT_MD = REPORT_DIR / "BATTLE_RUNTIME_FLOW_LINK_RESULT.md"


def read_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def main() -> None:
    manifest = read_json(FLOW_MANIFEST)
    slots = manifest.get("actorSlots", [])
    procedure = manifest.get("procedureEvidence", [])
    skill_ids = manifest.get("knownSkillIds", [])
    log = LOG.read_text(encoding="utf-8", errors="replace") if LOG.exists() else ""
    result = {
        "flowManifest": str(FLOW_MANIFEST),
        "flowManifestExists": FLOW_MANIFEST.exists(),
        "scene": str(SCENE),
        "sceneExists": SCENE.exists(),
        "sceneBytes": SCENE.stat().st_size if SCENE.exists() else 0,
        "unityBatchmodeSuccess": "BattleRuntimeFlowPrototype generated." in log,
        "mapId": manifest.get("mapId"),
        "battleType": manifest.get("battleType"),
        "randomSeed": manifest.get("randomSeed"),
        "actorSlots": len(slots),
        "loadableActors": sum(1 for s in slots if s.get("loadStatus") == "runtime_prefab"),
        "missingActors": sum(1 for s in slots if s.get("loadStatus") != "runtime_prefab"),
        "procedureEvidencePath": procedure[0].get("path") if procedure else "",
        "procedureEvidenceCount": len(procedure),
        "knownSkillIdsCount": len(skill_ids),
        "nextBattle13Recommendation": "skills/effects bundle streaming",
    }
    RESULT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(result, manifest)
    print(json.dumps(result, ensure_ascii=False, indent=2))


def write_report(result: dict, manifest: dict) -> None:
    lines = [
        "# Battle Runtime Flow Link Result",
        "",
        "## Outputs",
        f"- Flow manifest: `{result['flowManifest']}`",
        f"- Flow scene: `{result['scene']}`",
        f"- Unity batchmode success: `{result['unityBatchmodeSuccess']}`",
        "",
        "## Flow Counts",
        f"- mapId: `{result['mapId']}`",
        f"- battleType: `{result['battleType']}`",
        f"- randomSeed: `{result['randomSeed']}`",
        f"- Actor slots: `{result['actorSlots']}`",
        f"- Loadable runtime prefabs: `{result['loadableActors']}`",
        f"- Missing placeholders: `{result['missingActors']}`",
        f"- Procedure evidence count: `{result['procedureEvidenceCount']}`",
        f"- Known skill ids: `{result['knownSkillIdsCount']}`",
        "",
        "## Procedure Evidence",
        "| label | line | file | snippet |",
        "| --- | ---: | --- | --- |",
    ]
    for item in manifest.get("procedureEvidence", []):
        lines.append(f"| {item.get('label','')} | {item.get('line','')} | {item.get('path','')} | `{item.get('snippet','')}` |")
    lines.extend(
        [
            "",
            "## Actor Slots",
            "| side | wave | slot | heroDid | heroId | modelId | prefab | status | reason |",
            "| --- | ---: | ---: | --- | ---: | --- | --- | --- | --- |",
        ]
    )
    for slot in manifest.get("actorSlots", []):
        lines.append(
            f"| {slot.get('side','')} | {slot.get('wave','')} | {slot.get('slot','')} | {slot.get('heroDid','')} | {slot.get('heroId','')} | {slot.get('modelId','')} | {slot.get('prefab','')} | {slot.get('loadStatus','')} | {slot.get('missingReason','')} |"
        )
    lines.extend(
        [
            "",
            "## Next BATTLE_13",
            "- Recommend `skills/effects bundle streaming`: skill ids are already present in the flow manifest and effect/timeline bundle indexing is closer to battle implementation than HUD integration.",
        ]
    )
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
