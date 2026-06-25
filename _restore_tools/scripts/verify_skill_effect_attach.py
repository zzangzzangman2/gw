from __future__ import annotations

import json
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"

ATTACH_MANIFEST = UNITY_DATA / "BATTLE_FLOW_SKILL_EFFECT_ATTACH_MANIFEST.json"
UNITY_RESULT = UNITY_DATA / "BATTLE_FLOW_SKILL_EFFECT_ATTACH_RESULT.json"
SCENE = UNITY_DIR / "Assets" / "Scenes" / "BattleRuntimeFlowSkillEffectAttach.unity"
REPORT_MD = REPORT_DIR / "BATTLE_SKILL_EFFECT_ATTACH_RESULT.md"
REPORT_JSON = REPORT_DIR / "BATTLE_SKILL_EFFECT_ATTACH_RESULT.json"
LOG = REPORT_DIR / "BATTLE_14_UNITY_SKILL_EFFECT_ATTACH.log"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def main() -> None:
    manifest = read_json(ATTACH_MANIFEST)
    unity = read_json(UNITY_RESULT)
    log = LOG.read_text(encoding="utf-8", errors="replace") if LOG.exists() else ""
    result = {
        "attachManifest": str(ATTACH_MANIFEST),
        "unityResult": str(UNITY_RESULT),
        "scene": str(SCENE),
        "sceneExists": SCENE.exists(),
        "unityBatchmodeSuccess": "BattleSkillEffectAttach generated." in log,
        "knownSkillIds": manifest.get("counts", {}).get("knownSkillIds", 0),
        "loadableAttachments": manifest.get("counts", {}).get("loadableAttachments", 0),
        "unresolvedSkills": manifest.get("counts", {}).get("unresolvedSkills", 0),
        "uniqueBundles": manifest.get("counts", {}).get("uniqueBundles", 0),
        "instantiateSuccess": unity.get("summary", {}).get("instantiateSuccess", 0),
        "instantiateFail": unity.get("summary", {}).get("instantiateFail", 0),
        "loadedBundles": unity.get("summary", {}).get("loadedBundles", 0),
        "next": "BATTLE_15_CLOSE_COMMON_EFFECT_DEPENDENCIES_OR_ATTACH_PLAYABLE_MARKERS",
    }
    REPORT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(result, manifest, unity)
    print(json.dumps(result, ensure_ascii=False, indent=2))


def write_report(result: dict[str, Any], manifest: dict[str, Any], unity: dict[str, Any]) -> None:
    lines = [
        "# Battle Skill Effect Attach Result",
        "",
        "## Outputs",
        f"- Attach manifest: `{result['attachManifest']}`",
        f"- Unity result: `{result['unityResult']}`",
        f"- Scene: `{result['scene']}`",
        f"- Unity batchmode success: `{result['unityBatchmodeSuccess']}`",
        "",
        "## Counts",
        f"- Known skill ids: `{result['knownSkillIds']}`",
        f"- Loadable attachments: `{result['loadableAttachments']}`",
        f"- Unresolved skills: `{result['unresolvedSkills']}`",
        f"- Unique skill/effect bundles: `{result['uniqueBundles']}`",
        f"- Loaded bundles: `{result['loadedBundles']}`",
        f"- Instantiated effect prefabs success/fail: `{result['instantiateSuccess']}/{result['instantiateFail']}`",
        "",
        "## Attached Effects",
        "| skillId | owner | bundle | prefabAsset | instantiate | reason |",
        "| ---: | --- | --- | --- | --- | --- |",
    ]
    by_skill = {str(row.get("skillId")): row for row in unity.get("attachments", [])}
    for row in manifest.get("attachments", []):
        unity_row = by_skill.get(str(row.get("skillId")), {})
        lines.append(
            f"| {row.get('skillId')} | {row.get('side')}:{row.get('heroDid')} | {row.get('bundle')} | {row.get('prefabAsset')} | {unity_row.get('instantiateSuccess', False)} | {unity_row.get('failReason', '')} |"
        )
    lines.extend(
        [
            "",
            "## Unresolved Skills",
            "| skillId | reason | owners |",
            "| ---: | --- | --- |",
        ]
    )
    for row in manifest.get("unresolvedSkills", []):
        owners = ";".join(f"{o.get('side')}:{o.get('heroDid')}" for o in row.get("owners", []))
        lines.append(f"| {row.get('skillId')} | {row.get('reason')} | {owners} |")
    lines.extend(
        [
            "",
            "## Notes",
            "- This scene attaches only original loadable prefab/effect evidence. It does not invent AI, target selection, timing, damage, or skill animation logic.",
            "- BATTLE_15 should close common effect dependencies or add playable/timeline markers before any battle UI/HUD work.",
        ]
    )
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
