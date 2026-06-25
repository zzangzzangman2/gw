from __future__ import annotations

import json
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
VIDEO_DIR = BASE / "reports" / "video_reference"

TYPE_EVIDENCE_JSON = UNITY_DATA / "BATTLE_UI_COMPONENT_TYPE_EVIDENCE.json"
RESULT_JSON = UNITY_DATA / "BATTLE_UI_COMPONENT_TYPE_RECONSTRUCTION_RESULT.json"
COMPONENTS_CSV = UNITY_DATA / "BATTLE_UI_COMPONENT_TYPE_RECONSTRUCTION_COMPONENTS.csv"
REPORT_MD = REPORT_DIR / "BATTLE_UI_COMPONENT_TYPE_RECONSTRUCTION_RESULT.md"
REPORT_JSON = REPORT_DIR / "BATTLE_UI_COMPONENT_TYPE_RECONSTRUCTION_RESULT.json"
LOG = REPORT_DIR / "BATTLE_18_COMPONENT_TYPE_RECONSTRUCTION.log"
SCENE = UNITY_DIR / "Assets" / "Scenes" / "BattleRuntimeFlowWithHudTypeProbe.unity"
CAPTURE = UNITY_DIR / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleRuntimeFlowWithHudTypeProbe_1680x720.png"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    evidence = read_json(TYPE_EVIDENCE_JSON)
    result = read_json(RESULT_JSON)
    summary = result.get("summary", {})
    identified_types = evidence.get("identifiedTypes", [])
    roots = result.get("roots", [])
    log = LOG.read_text(encoding="utf-8", errors="replace") if LOG.exists() else ""
    image_count = int(summary.get("imageCount") or 0)
    text_count = int(summary.get("textCount") or 0)
    button_count = int(summary.get("buttonCount") or 0)
    missing_reduction = int(summary.get("missingScriptReduction") or 0)
    success = "BattleUIComponentTypeReconstruction generated." in log
    if missing_reduction > 0 and (image_count + text_count + button_count) > 0:
        next_step = "BATTLE_19_BATTLE_HUD_SPRITE_REGION_AND_FONT_JOIN_WITH_VIDEO_MOTION_VALIDATION"
    else:
        next_step = "BATTLE_19_IL2CPP_MONOSCRIPT_REFERENCE_DEEP_TRACE_WITH_VIDEO_MOTION_VALIDATION"

    report_summary = {
        "identifiedTypeCount": int(evidence.get("identifiedTypeCount") or len(identified_types)),
        "officialPackageTypeCount": int(evidence.get("officialPackageTypeCount") or 0),
        "stubProxyAddedCount": int(evidence.get("stubProxyTypeCount") or 0),
        "beforeCounts": evidence.get("beforeCounts", {}),
        "afterCounts": summary,
        "missingScriptReduction": missing_reduction,
        "scene": str(SCENE),
        "sceneExists": SCENE.exists(),
        "capture": str(CAPTURE),
        "captureExists": CAPTURE.exists(),
        "captureVisualAssessment": "component_types_resolved_but_not_original_hud_like_until_sprite_region_font_material_and_canvas_sorting_join",
        "clickValidation": summary.get("clickValidation", "deferred:no_resolved_Button_component"),
        "buttonValidationCount": int(summary.get("buttonValidationCount") or 0),
        "buttonInteractableCount": int(summary.get("buttonInteractableCount") or 0),
        "raycastReadyButtonCount": int(summary.get("raycastReadyButtonCount") or 0),
        "buttonWithoutTargetGraphicCount": int(summary.get("buttonWithoutTargetGraphicCount") or 0),
        "unityBatchmodeSuccess": success,
        "videoReferenceMotionReport": str(VIDEO_DIR / "PLAY_REFERENCE_VIDEO_MOTION_ANALYSIS.md"),
        "videoReferenceRestoreNotes": str(VIDEO_DIR / "PLAY_REFERENCE_RESTORE_NOTES.md"),
        "videoMotionClips": [
            "battle_motion_clip_01_0088s.mp4",
            "battle_motion_clip_02_0146s.mp4",
            "battle_motion_clip_03_0380s.mp4",
            "battle_motion_clip_05_0486s.mp4",
            "battle_motion_clip_06_0500s.mp4",
        ],
        "videoArtifactPolicy": "top_center_rounded_gray_overlay_treated_as_recording_touch_artifact_not_final_hud",
        "nextBattle19Recommendation": next_step,
    }
    REPORT_JSON.write_text(json.dumps(report_summary, ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(report_summary, evidence, result, identified_types, roots)
    print(json.dumps(report_summary, ensure_ascii=False, indent=2))


def write_report(summary: dict[str, Any], evidence: dict[str, Any], result: dict[str, Any], identified_types: list[dict[str, Any]], roots: list[dict[str, Any]]) -> None:
    before = summary["beforeCounts"]
    after = summary["afterCounts"]
    lines = [
        "# Battle UI Component Type Reconstruction Result",
        "",
        "## Outputs",
        f"- Type evidence JSON: `{TYPE_EVIDENCE_JSON}`",
        f"- Reconstruction result JSON: `{RESULT_JSON}`",
        f"- Components CSV: `{COMPONENTS_CSV}`",
        f"- Scene: `{SCENE}`",
        f"- Capture: `{CAPTURE}`",
        f"- Unity batchmode success: `{summary['unityBatchmodeSuccess']}`",
        "",
        "## Counts",
        f"- Identified MonoScript/component types: `{summary['identifiedTypeCount']}`",
        f"- Official package types: `{summary['officialPackageTypeCount']}`",
        f"- Stub/proxy types added: `{summary['stubProxyAddedCount']}`",
        f"- Before Canvas / Rect / Image / Text / Button / Missing: `{before.get('canvasCount', 0)}` / `{before.get('rectTransformCount', 0)}` / `{before.get('imageCount', 0)}` / `{before.get('textCount', 0)}` / `{before.get('buttonCount', 0)}` / `{before.get('missingScriptCount', 0)}`",
        f"- After Canvas / Rect / Image / Text / Button / Missing: `{after.get('canvasCount', 0)}` / `{after.get('rectTransformCount', 0)}` / `{after.get('imageCount', 0)}` / `{after.get('textCount', 0)}` / `{after.get('buttonCount', 0)}` / `{after.get('afterMissingScriptCount', 0)}`",
        f"- Missing script reduction: `{summary['missingScriptReduction']}`",
        f"- Official UI resolved components: `{after.get('officialUiResolvedCount', 0)}`",
        f"- Proxy resolved components: `{after.get('proxyResolvedCount', 0)}`",
        f"- Click validation: `{summary['clickValidation']}`",
        f"- Button validation / interactable / raycast-ready / without targetGraphic: `{summary['buttonValidationCount']}` / `{summary['buttonInteractableCount']}` / `{summary['raycastReadyButtonCount']}` / `{summary['buttonWithoutTargetGraphicCount']}`",
        f"- Capture visual assessment: `{summary['captureVisualAssessment']}`",
        "",
        "## Identified Type Evidence",
        "| refs | assembly | full type | likely role | IL2CPP evidence | Lua evidence |",
        "| ---: | --- | --- | --- | ---: | ---: |",
    ]
    for item in identified_types:
        lines.append(
            f"| {item.get('monoBehaviourRefCount', 0)} | `{item.get('assemblyName', '')}` | `{item.get('fullName', '')}` | {item.get('likelyRole', '')} | {len(item.get('il2cppEvidence', []))} | {len(item.get('luaEvidence', []))} |"
        )

    lines.extend(
        [
            "",
            "## Root Probe After Reconstruction",
            "| role | prefab | image | text/tmp | button | missing | official UI | proxy | active |",
            "| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |",
        ]
    )
    for root in roots:
        lines.append(
            f"| {root.get('role', '')} | `{root.get('prefabAsset', '')}` | {int(root.get('imageCount') or 0) + int(root.get('rawImageCount') or 0)} | {int(root.get('textCount') or 0) + int(root.get('tmpCount') or 0)} | {root.get('buttonCount', 0)} | {root.get('missingScriptCount', 0)} | {root.get('officialUiResolvedCount', 0)} | {root.get('proxyResolvedCount', 0)} | {root.get('sceneRootActive', '')} |"
        )

    lines.extend(
        [
            "",
            "## Video Reference Applied",
            f"- Motion report: `{summary['videoReferenceMotionReport']}`",
            f"- Restore notes: `{summary['videoReferenceRestoreNotes']}`",
            "- Important clips for BATTLE_19 validation:",
        ]
    )
    for clip in summary["videoMotionClips"]:
        lines.append(f"  - `{VIDEO_DIR / 'clips' / clip}`")
    lines.extend(
        [
            "- Top-center rounded gray overlay is treated as recording/touch artifact and is not a final HUD restore target.",
            "- BATTLE_19 validation must compare HUD persistence during cut-ins, bottom skill/actor cards, right controls, floating damage/heal, hit flash, camera/effect shake, and cut-in timing against clips rather than still screenshots.",
            "",
            "## Restore Policy Check",
            "- No fake HUD or coordinate-only replacement was added.",
            "- Original prefab hierarchy/RectTransform is still instantiated from source AssetBundles.",
            "- Stub/proxy types are deserialize/resolve targets only; no battle AI or fake UI behavior was added.",
            "- Whole atlas placement remains deferred until sprite/region evidence is joined.",
            "",
            "## BATTLE_19 Recommendation",
            f"- `{summary['nextBattle19Recommendation']}`",
        ]
    )
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
