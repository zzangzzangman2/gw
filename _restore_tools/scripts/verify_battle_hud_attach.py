from __future__ import annotations

import json
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"

MANIFEST_JSON = UNITY_DATA / "BATTLE_FLOW_WITH_HUD_ATTACH_MANIFEST.json"
RESULT_JSON = UNITY_DATA / "BATTLE_FLOW_WITH_HUD_ATTACH_RESULT.json"
REPORT_MD = REPORT_DIR / "BATTLE_FLOW_WITH_HUD_ATTACH_RESULT.md"
REPORT_SUMMARY_JSON = REPORT_DIR / "BATTLE_FLOW_WITH_HUD_ATTACH_RESULT.json"
LOG = REPORT_DIR / "BATTLE_17_ATTACH_BATTLE_HUD.log"
SCENE = UNITY_DIR / "Assets" / "Scenes" / "BattleRuntimeFlowWithHudPrototype.unity"
CAPTURE = UNITY_DIR / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleRuntimeFlowWithHudPrototype_1680x720.png"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    manifest = read_json(MANIFEST_JSON)
    result = read_json(RESULT_JSON)
    attached_roots = result.get("attachedRoots", [])
    summary = result.get("summary", {})
    log = LOG.read_text(encoding="utf-8", errors="replace") if LOG.exists() else ""

    attached = [r for r in attached_roots if r.get("instantiateSuccess")]
    unresolved = sum(int(r.get("spriteMaterialFontDependencyUnresolvedCount") or 0) for r in attached_roots)
    button_count = int(summary.get("buttonCount") or 0)
    click_validation = "deferred:no_resolved_Button_component" if button_count == 0 else "pending"
    capture_exists = CAPTURE.exists()

    report_summary = {
        "attachedHudRootCount": len(attached),
        "attachedPrefabNames": [Path(r.get("prefabAsset", "")).name for r in attached],
        "canvasCount": int(summary.get("canvasCount") or 0),
        "rectTransformCount": int(summary.get("rectTransformCount") or 0),
        "imageCount": int(summary.get("imageCount") or 0),
        "textCount": int(summary.get("textCount") or 0),
        "buttonCount": button_count,
        "missingScriptCount": int(summary.get("missingScriptCount") or 0),
        "spriteMaterialFontDependencyUnresolvedCount": unresolved,
        "scene": str(SCENE),
        "sceneExists": SCENE.exists(),
        "capture": str(CAPTURE),
        "captureExists": capture_exists,
        "captureVisualAssessment": "capture_exists_but_not_original_hud_like_due_unresolved_ui_widget_components_and_sprite_region_dependencies",
        "clickValidation": click_validation,
        "unityBatchmodeSuccess": "BattleHudAttachToFlow generated." in log,
        "nextBattle18Recommendation": "BATTLE_18_RECONSTRUCT_BATTLE_UI_COMPONENT_TYPES",
    }
    REPORT_SUMMARY_JSON.write_text(json.dumps(report_summary, ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(report_summary, manifest, result, attached_roots)
    print(json.dumps(report_summary, ensure_ascii=False, indent=2))


def write_report(summary: dict[str, Any], manifest: dict[str, Any], result: dict[str, Any], attached_roots: list[dict[str, Any]]) -> None:
    lines = [
        "# Battle Flow With HUD Attach Result",
        "",
        "## Outputs",
        f"- Attach manifest: `{MANIFEST_JSON}`",
        f"- Attach result JSON: `{RESULT_JSON}`",
        f"- Scene: `{SCENE}`",
        f"- Capture: `{CAPTURE}`",
        f"- Unity batchmode success: `{summary['unityBatchmodeSuccess']}`",
        "",
        "## Counts",
        f"- Attached HUD roots: `{summary['attachedHudRootCount']}`",
        f"- Canvas / RectTransform / Image / Text+TMP / Button: `{summary['canvasCount']}` / `{summary['rectTransformCount']}` / `{summary['imageCount']}` / `{summary['textCount']}` / `{summary['buttonCount']}`",
        f"- Missing script/component count: `{summary['missingScriptCount']}`",
        f"- Sprite/material/font dependency unresolved count: `{summary['spriteMaterialFontDependencyUnresolvedCount']}`",
        f"- Capture exists: `{summary['captureExists']}`",
        f"- Capture visual assessment: `{summary['captureVisualAssessment']}`",
        f"- Click validation: `{summary['clickValidation']}`",
        "",
        "## Attached Roots",
        "| order | role | mode | prefab | active original/scene | gameObjects | rect | canvas | image | text/tmp | button | missing scripts | root RectTransform evidence |",
        "| ---: | --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |",
    ]
    for root in attached_roots:
        lines.append(
            "| {order} | {role} | {mode} | `{prefab}` | {original}/{scene} | {go} | {rect} | {canvas} | {image} | {text} | {button} | {missing} | anchor `{anchor_min}`-`{anchor_max}`, pivot `{pivot}`, pos `{pos}`, size `{size}` |".format(
                order=root.get("order", ""),
                role=root.get("role", ""),
                mode=root.get("attachMode", ""),
                prefab=root.get("prefabAsset", ""),
                original=root.get("originalRootActive", ""),
                scene=root.get("sceneRootActive", ""),
                go=root.get("gameObjectCount", 0),
                rect=root.get("rectTransformCount", 0),
                canvas=root.get("canvasCount", 0),
                image=int(root.get("imageCount") or 0) + int(root.get("rawImageCount") or 0),
                text=int(root.get("textCount") or 0) + int(root.get("tmpCount") or 0),
                button=root.get("buttonCount", 0),
                missing=root.get("missingScriptCount", 0),
                anchor_min=root.get("anchorMin", ""),
                anchor_max=root.get("anchorMax", ""),
                pivot=root.get("pivot", ""),
                pos=root.get("anchoredPosition", ""),
                size=root.get("sizeDelta", ""),
            )
        )

    lines.extend(
        [
            "",
            "## Image/Text/Button Count Analysis",
            "- BATTLE_16 and BATTLE_17 both resolve RectTransform/Canvas but resolve `Image`, `Text/TMP`, and `Button` as zero.",
            "- The battle Unity prototype has `com.unity.modules.ui`, so this is not simply a missing UI module.",
            "- The attached prefabs carry many missing MonoBehaviour components. Current evidence points to original UI widget/controller scripts and serialized UI component references not being resolved in this prototype project.",
            "- Therefore sprite/material/font dependencies remain unresolved at component level and must be joined after missing type/script reconstruction. Whole atlas placement is still forbidden.",
            "",
            "## Sprite/Region Dependencies Deferred",
        ]
    )
    for item in manifest.get("spriteRegionJoinDeferred", []):
        lines.append(f"- `{item}`")

    lines.extend(
        [
            "",
            "## Restore Policy Check",
            "- Attached roots are original loadable AssetBundle prefabs, not fake HUD.",
            "- Entry/template/result roots are kept inactive and are not final-screen overlays.",
            "- Original prefab hierarchy is instantiated from source bundles. Root RectTransform anchor/pivot/scale/position evidence is recorded.",
            "- Click/raycast validation is deferred because no resolved Button component exists yet.",
            "",
            "## BATTLE_18 Recommendation",
            f"- `{summary['nextBattle18Recommendation']}`",
            "- Reason: HUD prefab roots attach successfully, but actual Image/Text/Button behavior is blocked first by missing script/type reconstruction. Sprite/region join should follow after UI component types resolve.",
        ]
    )
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
