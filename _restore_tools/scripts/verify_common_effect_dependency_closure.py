from __future__ import annotations

import json
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"

CLOSURE_JSON = UNITY_DATA / "BATTLE_COMMON_EFFECT_DEPENDENCY_CLOSURE.json"
PLAYABLE_JSON = UNITY_DATA / "BATTLE_SKILL_EFFECT_PLAYABLE_MARKER_MANIFEST.json"
UNITY_RESULT = UNITY_DATA / "BATTLE_COMMON_EFFECT_DEPENDENCY_CLOSURE_UNITY_RESULT.json"
REPORT_JSON = REPORT_DIR / "BATTLE_COMMON_EFFECT_DEPENDENCY_CLOSURE_RESULT.json"
REPORT_MD = REPORT_DIR / "BATTLE_COMMON_EFFECT_DEPENDENCY_CLOSURE_RESULT.md"
SCENE = UNITY_DIR / "Assets" / "Scenes" / "BattleRuntimeFlowSkillEffectPlayableMarkers.unity"
LOG = REPORT_DIR / "BATTLE_15_UNITY_COMMON_EFFECT_CLOSURE.log"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def main() -> None:
    closure = read_json(CLOSURE_JSON)
    playable = read_json(PLAYABLE_JSON)
    unity = read_json(UNITY_RESULT)
    log = LOG.read_text(encoding="utf-8", errors="replace") if LOG.exists() else ""
    common_results = unity.get("commonDependencyResults", [])
    playable_results = unity.get("playableMarkerResults", [])

    for target in closure.get("commonDependencyTargets", []):
        match = next((row for row in common_results if row.get("dependencyName") == target.get("dependencyName")), None)
        if match:
            target["unityProbe"] = match
    for marker in playable.get("markers", []):
        match = next((row for row in playable_results if str(row.get("skillId")) == str(marker.get("skillId"))), None)
        if match:
            marker["unityProbe"] = match

    common_load_success = sum(1 for row in common_results if row.get("loadSuccess"))
    common_load_fail = len(common_results) - common_load_success
    playable_found = sum(1 for row in playable_results if row.get("playableFound"))
    playable_missing = len(playable_results) - playable_found
    common_attached = sum(1 for row in common_results if row.get("instantiateSuccess") or row.get("markerAttached"))
    classification_counts: dict[str, int] = {}
    for row in closure.get("unresolvedSkillClassifications", []):
        category = row.get("category", "unknown")
        classification_counts[category] = classification_counts.get(category, 0) + 1

    closure["status"] = "common_effect_dependency_closure_complete"
    closure["unityResult"] = str(UNITY_RESULT)
    closure["scene"] = str(SCENE)
    closure["summary"] = {
        "unresolvedSkills": len(closure.get("unresolvedSkillClassifications", [])),
        "classificationCounts": classification_counts,
        "commonDependencyTargets": len(common_results),
        "commonLoadSuccess": common_load_success,
        "commonLoadFail": common_load_fail,
        "commonMarkersAttached": common_attached,
    }
    playable["status"] = "playable_marker_manifest_complete"
    playable["unityResult"] = str(UNITY_RESULT)
    playable["summary"] = {
        "playableMarkers": len(playable_results),
        "playableFound": playable_found,
        "playableMissing": playable_missing,
        "sceneExists": SCENE.exists(),
        "unityBatchmodeSuccess": "BattleCommonEffectClosure generated." in log,
    }
    CLOSURE_JSON.write_text(json.dumps(closure, ensure_ascii=False, indent=2), encoding="utf-8")
    PLAYABLE_JSON.write_text(json.dumps(playable, ensure_ascii=False, indent=2), encoding="utf-8")

    result = {
        "closureJson": str(CLOSURE_JSON),
        "playableMarkerManifest": str(PLAYABLE_JSON),
        "unityResult": str(UNITY_RESULT),
        "scene": str(SCENE),
        "sceneExists": SCENE.exists(),
        "unityBatchmodeSuccess": "BattleCommonEffectClosure generated." in log,
        "unresolvedSkills": len(closure.get("unresolvedSkillClassifications", [])),
        "classificationCounts": classification_counts,
        "commonDependencyFound": sum(1 for row in closure.get("commonDependencyTargets", []) if row.get("aggregateExists")),
        "commonDependencyLoadSuccess": common_load_success,
        "commonDependencyLoadFail": common_load_fail,
        "commonMarkersAttached": common_attached,
        "playableMarkerCount": len(playable_results),
        "playableFound": playable_found,
        "playableMissing": playable_missing,
        "nextBattle16Recommendation": "BATTLE_UI_HUD_RESTORE_AND_ALIGNMENT" if common_load_success else "missing dependency extraction/normalization closure",
    }
    REPORT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(result, closure, playable, unity)
    print(json.dumps(result, ensure_ascii=False, indent=2))


def write_report(result: dict[str, Any], closure: dict[str, Any], playable: dict[str, Any], unity: dict[str, Any]) -> None:
    lines = [
        "# Battle Common Effect Dependency Closure Result",
        "",
        "## Outputs",
        f"- Closure JSON: `{result['closureJson']}`",
        f"- Playable marker manifest: `{result['playableMarkerManifest']}`",
        f"- Unity result: `{result['unityResult']}`",
        f"- Scene: `{result['scene']}`",
        f"- Unity batchmode success: `{result['unityBatchmodeSuccess']}`",
        "",
        "## Counts",
        f"- Unresolved skills classified: `{result['unresolvedSkills']}`",
        f"- Classification counts: `{result['classificationCounts']}`",
        f"- Common dependency found/load success/fail: `{result['commonDependencyFound']}/{result['commonDependencyLoadSuccess']}/{result['commonDependencyLoadFail']}`",
        f"- Common markers attached: `{result['commonMarkersAttached']}`",
        f"- Playable/timeline markers found/missing: `{result['playableFound']}/{result['playableMissing']}`",
        "",
        "## Unresolved Skill Classification",
        "| skillId | category | detail | skillTypes | skillFound | timelineFound | lua | owners |",
        "| ---: | --- | --- | --- | --- | --- | ---: | --- |",
    ]
    for row in closure.get("unresolvedSkillClassifications", []):
        owners = ";".join(f"{o.get('side')}:{o.get('heroDid')}" for o in row.get("owners", []))
        lines.append(
            f"| {row.get('skillId')} | {row.get('category')} | {row.get('detail')} | {','.join(row.get('skillTypes', []))} | {row.get('skillFound')} | {row.get('timelineFound')} | {row.get('luaEvidenceCount')} | {owners} |"
        )
    lines.extend(
        [
            "",
            "## Common Dependencies",
            "| dependency | failed path | aggregate | header | load | matches | instantiate | reason |",
            "| --- | --- | --- | --- | --- | ---: | --- | --- |",
        ]
    )
    for row in closure.get("commonDependencyTargets", []):
        probe = row.get("unityProbe", {})
        lines.append(
            f"| {row.get('dependencyName')} | {row.get('failedBundle')} | {row.get('aggregateBundle')} | `{row.get('aggregateHeader')}` | {probe.get('loadSuccess')} | {probe.get('matchingAssetCount', 0)} | {probe.get('instantiateSuccess')} | {probe.get('failReason', '')} |"
        )
    lines.extend(
        [
            "",
            "## Playable Markers",
            "| skillId | owner | playable | found | marker |",
            "| ---: | --- | --- | --- | --- |",
        ]
    )
    for marker in playable.get("markers", []):
        probe = marker.get("unityProbe", {})
        lines.append(
            f"| {marker.get('skillId')} | {marker.get('side')}:{marker.get('heroDid')} | {marker.get('expectedPlayableAsset')} | {probe.get('playableFound')} | {probe.get('markerAttached')} |"
        )
    lines.extend(
        [
            "",
            "## BATTLE_16 Recommendation",
            f"- `{result['nextBattle16Recommendation']}`",
            "- Common dependency closure is no longer the blocker, so the next battle restoration step should start battle UI/HUD extraction and alignment instead of treating skill/effect logic as complete.",
            "- Required HUD scope: root canvas/camera/scaler, HP/MP/energy bars, buff/debuff icons, actor labels, floating text, skill trigger indicators, auto/speed/pause/setting/skip controls, wave/round/timer indicators, and win/lose/result entry points.",
            "- Restore criteria must follow original prefab hierarchy, RectTransform anchor/pivot/scale, sibling order, CanvasScaler, sprite-region evidence, UGUI/TMP font/material evidence, and click/raycast validation logs. Unknown controls should remain unknown/log-only, not fake UI.",
        ]
    )
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
