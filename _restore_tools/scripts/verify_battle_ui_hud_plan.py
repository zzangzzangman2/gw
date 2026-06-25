from __future__ import annotations

import json
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"

CANDIDATES_JSON = UNITY_DATA / "BATTLE_UI_HUD_CANDIDATES.json"
PROBE_JSON = UNITY_DATA / "BATTLE_UI_HUD_BUNDLE_PROBE.json"
REPORT_MD = REPORT_DIR / "BATTLE_UI_HUD_RESTORE_AND_ALIGNMENT_PLAN.md"
REPORT_JSON = REPORT_DIR / "BATTLE_UI_HUD_RESTORE_AND_ALIGNMENT_PLAN.json"
SCENE = UNITY_DIR / "Assets" / "Scenes" / "BattleUIHudEvidenceProbe.unity"
LOG = REPORT_DIR / "BATTLE_16_UNITY_UI_HUD_PROBE.log"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def main() -> None:
    candidates = read_json(CANDIDATES_JSON)
    probe = read_json(PROBE_JSON)
    results = probe.get("results", [])
    loadable_bundles = [r for r in results if r.get("loadSuccess")]
    loadable_prefab_bundles = [r for r in results if r.get("loadSuccess") and r.get("prefabRootCount", 0) > 0]
    image_count = sum(int(r.get("imageComponentCount") or 0) for r in results)
    text_count = sum(int(r.get("textComponentCount") or 0) + int(r.get("tmpComponentCount") or 0) for r in results)
    button_count = sum(int(r.get("buttonComponentCount") or 0) for r in results)
    canvas_count = sum(int(r.get("canvasCount") or 0) for r in results)
    rect_count = sum(int(r.get("rectTransformCount") or 0) for r in results)
    sprite_count = sum(int(r.get("spriteCount") or 0) for r in results)
    log = LOG.read_text(encoding="utf-8", errors="replace") if LOG.exists() else ""
    unity_success = "BattleUIHudEvidenceProbe generated." in log

    direct_restore = [r for r in results if r.get("loadSuccess") and r.get("prefabRootCount", 0) > 0 and (r.get("canvasCount", 0) > 0 or r.get("rectTransformCount", 0) > 0)]
    needs_join = [r for r in results if r.get("loadSuccess") and r.get("prefabRootCount", 0) == 0 and (r.get("spriteCount", 0) > 0 or r.get("texture2DCount", 0) > 0)]
    missing = [r for r in results if not r.get("loadSuccess")]

    summary = {
        "candidateCount": candidates.get("counts", {}).get("candidateCount", 0),
        "probeResultCount": len(results),
        "loadableBundleCount": len(loadable_bundles),
        "loadablePrefabBundleCount": len(loadable_prefab_bundles),
        "prefabRootCount": sum(int(r.get("prefabRootCount") or 0) for r in results),
        "canvasCount": canvas_count,
        "rectTransformCount": rect_count,
        "imageCount": image_count,
        "textCount": text_count,
        "buttonCount": button_count,
        "spriteCount": sprite_count,
        "scene": str(SCENE),
        "sceneExists": SCENE.exists(),
        "unityBatchmodeSuccess": unity_success,
        "nextBattle17Recommendation": "BATTLE_17_ATTACH_LOADABLE_BATTLE_HUD_PREFABS_TO_FLOW_SCENE",
    }
    REPORT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(summary, candidates, results, direct_restore, needs_join, missing)
    print(json.dumps(summary, ensure_ascii=False, indent=2))


def write_report(summary: dict[str, Any], candidates: dict[str, Any], results: list[dict[str, Any]], direct_restore: list[dict[str, Any]], needs_join: list[dict[str, Any]], missing: list[dict[str, Any]]) -> None:
    lines = [
        "# Battle UI/HUD Restore And Alignment Plan",
        "",
        "## Outputs",
        f"- Candidates JSON: `{CANDIDATES_JSON}`",
        f"- Bundle probe JSON: `{PROBE_JSON}`",
        f"- Probe scene: `{SCENE}`",
        f"- Unity batchmode success: `{summary['unityBatchmodeSuccess']}`",
        "",
        "## Counts",
        f"- HUD candidates: `{summary['candidateCount']}`",
        f"- Loadable bundles: `{summary['loadableBundleCount']}`",
        f"- Loadable prefab bundles: `{summary['loadablePrefabBundleCount']}`",
        f"- Prefab roots: `{summary['prefabRootCount']}`",
        f"- Canvas / RectTransform / Image / Text+TMP / Button: `{summary['canvasCount']}` / `{summary['rectTransformCount']}` / `{summary['imageCount']}` / `{summary['textCount']}` / `{summary['buttonCount']}`",
        f"- Sprite candidates: `{summary['spriteCount']}`",
        "",
        "## Restore Rules Applied",
        f"- Rules file: `{candidates.get('rulesEvidence', '')}`",
        "- Do not place whole atlases as UI. Track sprite/region evidence before final placement.",
        "- Do not fake buttons or panels without original prefab/handler evidence. Unknown controls stay unknown/log-only.",
        "- Final HUD must preserve prefab hierarchy, RectTransform anchor/pivot/scale, sibling order, CanvasScaler, font/material evidence, and click/raycast validation logs.",
        "- Battle log/debug-only elements must not be final-screen overlays.",
        "",
        "## Immediately Restorable HUD Prefab Candidates",
        "| bundle | prefabs | canvas | scaler | rect | image | text/tmp | button | root sample |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |",
    ]
    for r in sorted(direct_restore, key=lambda x: -int(x.get("prefabRootCount") or 0)):
        lines.append(
            f"| {r.get('bundle')} | {r.get('prefabRootCount')} | {r.get('canvasCount')} | {r.get('canvasScalerCount')} | {r.get('rectTransformCount')} | {r.get('imageComponentCount')} | {int(r.get('textComponentCount') or 0) + int(r.get('tmpComponentCount') or 0)} | {r.get('buttonComponentCount')} | `{r.get('prefabRootSample','')}` |"
        )
    lines.extend(
        [
            "",
            "## Needs Sprite/Region Join",
            "| bundle | sprites | textures | materials | note |",
            "| --- | ---: | ---: | ---: | --- |",
        ]
    )
    for r in needs_join:
        lines.append(f"| {r.get('bundle')} | {r.get('spriteCount')} | {r.get('texture2DCount')} | {r.get('materialCount')} | sprite/region mapping required before placement |")
    lines.extend(
        [
            "",
            "## Missing Or Header/Load Problem",
            "| bundle | exists | header | load | reason |",
            "| --- | --- | --- | --- | --- |",
        ]
    )
    for r in missing:
        lines.append(f"| {r.get('bundle')} | {r.get('fileExists')} | `{r.get('unityFsHeader','')}` | {r.get('loadSuccess')} | {r.get('failReason','')} |")
    lines.extend(
        [
            "",
            "## Lua / Handler Evidence",
            "| pattern | line | file | snippet |",
            "| --- | ---: | --- | --- |",
        ]
    )
    for item in candidates.get("luaEvidence", [])[:40]:
        lines.append(f"| {item.get('pattern')} | {item.get('line')} | {item.get('path')} | `{item.get('snippet','')}` |")
    lines.extend(
        [
            "",
            "## BATTLE_17 Order",
            "1. Attach loadable battle HUD prefab roots from `download/ui/uiprefabandres/battle*.assetbundle` to a dedicated evidence scene, preserving original hierarchy and Canvas/CanvasScaler.",
            "2. Attach result panel candidates from `winlose*.assetbundle` as separate entry-point roots, not as fake final overlays.",
            "3. Map sprite-region dependencies from `uibattle`, `uibufficon`, `uihurtnum`, and `uiheroheadbattle` per component reference.",
            "4. Add click/raycast validation logs only for buttons with original Button/handler evidence.",
            f"- Next recommendation: `{summary['nextBattle17Recommendation']}`",
        ]
    )
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
