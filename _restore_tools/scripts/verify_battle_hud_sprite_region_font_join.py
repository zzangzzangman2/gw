from __future__ import annotations

import json
import shutil
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
VIDEO_DIR = BASE / "reports" / "video_reference"

CANDIDATES_JSON = UNITY_DATA / "BATTLE_HUD_SPRITE_REGION_FONT_JOIN_CANDIDATES.json"
UNITY_RESULT_JSON = UNITY_DATA / "BATTLE_HUD_SPRITE_REGION_FONT_JOIN_RESULT.json"
COMPONENT_CSV = UNITY_DATA / "BATTLE_HUD_SPRITE_REGION_FONT_JOIN_COMPONENTS.csv"
REPORT_MD = REPORT_DIR / "BATTLE_HUD_SPRITE_REGION_FONT_JOIN_VIDEO_VALIDATION_RESULT.md"
REPORT_JSON = REPORT_DIR / "BATTLE_HUD_SPRITE_REGION_FONT_JOIN_VIDEO_VALIDATION_RESULT.json"
LOG = REPORT_DIR / "BATTLE_19_HUD_SPRITE_FONT_JOIN.log"
SCENE = UNITY_DIR / "Assets" / "Scenes" / "BattleRuntimeFlowWithHudSpriteFontJoin.unity"
CAPTURE = UNITY_DIR / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleRuntimeFlowWithHudSpriteFontJoin_1680x720.png"
VALIDATION_DIR = UNITY_DIR / "Assets" / "RestoreCaptures" / "battle_hud" / "video_motion_validation"
VALIDATION_JSON = VALIDATION_DIR / "BATTLE_19_VIDEO_MOTION_VALIDATION.json"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def make_validation_matrix() -> dict[str, Any]:
    VALIDATION_DIR.mkdir(parents=True, exist_ok=True)
    clips = [
        {
            "clip": "battle_motion_clip_01_0088s.mp4",
            "validation": "projectile_hit_floating_damage",
            "currentStatus": "pending_motion_reconstruction",
            "mismatchClass": "floating_damage_timing_and_effect_motion_not_reconstructed_yet",
        },
        {
            "clip": "battle_motion_clip_02_0146s.mp4",
            "validation": "bright_cut_in_flash_with_hud_camera_behavior",
            "currentStatus": "pending_motion_reconstruction",
            "mismatchClass": "cutin_flash_sorting_and_camera_timing_not_reconstructed_yet",
        },
        {
            "clip": "battle_motion_clip_03_0380s.mp4",
            "validation": "red_black_special_skill_stage_cutin",
            "currentStatus": "pending_motion_reconstruction",
            "mismatchClass": "special_skill_stage_overlay_not_reconstructed_yet",
        },
        {
            "clip": "battle_motion_clip_05_0486s.mp4",
            "validation": "normal_battle_hud_persistence_top_bottom_right",
            "currentStatus": "partially_ready_after_sprite_font_join",
            "mismatchClass": "canvas_sorting_camera_and_runtime_data_binding_still_pending",
        },
        {
            "clip": "battle_motion_clip_06_0500s.mp4",
            "validation": "full_width_beam_flash_hit",
            "currentStatus": "pending_motion_reconstruction",
            "mismatchClass": "beam_flash_effect_motion_not_reconstructed_yet",
        },
    ]
    data = {
        "video": str(BASE.parent / "플레이.mp4"),
        "motionReport": str(VIDEO_DIR / "PLAY_REFERENCE_VIDEO_MOTION_ANALYSIS.md"),
        "restoreNotes": str(VIDEO_DIR / "PLAY_REFERENCE_RESTORE_NOTES.md"),
        "topCenterOverlayPolicy": "recording_touch_artifact_not_final_hud",
        "prototypeCapture": str(CAPTURE),
        "clips": [{**c, "path": str(VIDEO_DIR / "clips" / c["clip"])} for c in clips],
        "note": "BATTLE_19 validates static HUD sprite/font readiness against motion reference requirements. Actual floating damage/cutin/beam motion reconstruction is deferred to BATTLE_20.",
    }
    VALIDATION_JSON.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    try:
        src = VIDEO_DIR / "play_motion_top6_frames.jpg"
        if src.exists():
            shutil.copy2(src, VALIDATION_DIR / "play_motion_top6_frames_reference.jpg")
        src = VIDEO_DIR / "play_overview_10s_contact.jpg"
        if src.exists():
            shutil.copy2(src, VALIDATION_DIR / "play_overview_10s_contact_reference.jpg")
    except Exception:
        pass
    return data


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    result = read_json(UNITY_RESULT_JSON)
    candidates = read_json(CANDIDATES_JSON)
    summary = result.get("summary", {})
    log = LOG.read_text(encoding="utf-8", errors="replace") if LOG.exists() else ""
    video_validation = make_validation_matrix()
    applied_sprite = int(summary.get("resolvedSpriteCount") or 0)
    resolved_fonts = int(summary.get("resolvedTextFontCount") or 0) + int(summary.get("resolvedTmpFontCount") or 0)
    material_count = int(summary.get("textMaterialResolvedCount") or 0)
    unresolved = int(summary.get("unresolvedSpriteCount") or 0)
    handler_linked = int(summary.get("handlerLinkedButtonCount") or 0)
    if applied_sprite >= 100 and resolved_fonts > 0:
        next_step = "BATTLE_20_FLOATING_DAMAGE_AND_CUTIN_MOTION_RECONSTRUCTION"
    elif applied_sprite < 50:
        next_step = "BATTLE_20_BATTLE_UI_SPRITE_PPTR_DEEP_TRACE"
    else:
        next_step = "BATTLE_20_BATTLE_UI_BUTTON_HANDLER_LUA_IL2CPP_TRACE" if handler_linked == 0 else "BATTLE_20_FLOATING_DAMAGE_AND_CUTIN_MOTION_RECONSTRUCTION"
    report_summary = {
        "appliedSpriteSliceCount": applied_sprite,
        "resolvedTextFontCount": resolved_fonts,
        "textMaterialResolvedCount": material_count,
        "unresolvedSpriteCount": unresolved,
        "buttonCount": int(summary.get("buttonCount") or 0),
        "raycastReadyButtonCount": int(summary.get("raycastReadyButtonCount") or 0),
        "handlerLinkedButtonCount": handler_linked,
        "clickValidation": summary.get("clickValidation", ""),
        "scene": str(SCENE),
        "sceneExists": SCENE.exists(),
        "capture": str(CAPTURE),
        "captureExists": CAPTURE.exists(),
        "captureVisualStatus": "debug_overlay_suppressed_hud_not_camera_visible_yet",
        "captureVisualReason": "Existing flow evidence roots are hidden for capture; HUD prefab references are joined, but Canvas render mode/camera/sorting/runtime binding still need BATTLE_20+ validation before the original HUD is visible in a still capture.",
        "unityBatchmodeSuccess": "BattleHudSpriteFontJoin generated." in log,
        "componentCandidateCount": candidates.get("componentCandidateCount", 0),
        "explicitSpriteOrTextureRefCount": candidates.get("explicitSpriteOrTextureRefCount", 0),
        "explicitFontOrMaterialRefCount": candidates.get("explicitFontOrMaterialRefCount", 0),
        "videoMotionValidation": video_validation,
        "nextBattle20Recommendation": next_step,
    }
    REPORT_JSON.write_text(json.dumps(report_summary, ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(report_summary, result, candidates, video_validation)
    print(json.dumps(report_summary, ensure_ascii=False, indent=2))


def write_report(summary: dict[str, Any], result: dict[str, Any], candidates: dict[str, Any], video_validation: dict[str, Any]) -> None:
    lines = [
        "# Battle HUD Sprite Region Font Join + Video Motion Validation Result",
        "",
        "## Outputs",
        f"- Join candidates JSON: `{CANDIDATES_JSON}`",
        f"- Unity result JSON: `{UNITY_RESULT_JSON}`",
        f"- Components CSV: `{COMPONENT_CSV}`",
        f"- Scene: `{SCENE}`",
        f"- Capture: `{CAPTURE}`",
        f"- Capture visual status: `{summary['captureVisualStatus']}`",
        f"- Capture visual reason: {summary['captureVisualReason']}",
        f"- Video validation JSON: `{VALIDATION_JSON}`",
        f"- Unity batchmode success: `{summary['unityBatchmodeSuccess']}`",
        "",
        "## Counts",
        f"- Applied/resolved sprite slices: `{summary['appliedSpriteSliceCount']}`",
        f"- Resolved Text/TMP fonts: `{summary['resolvedTextFontCount']}`",
        f"- Resolved text/font materials: `{summary['textMaterialResolvedCount']}`",
        f"- Unresolved sprite/image refs: `{summary['unresolvedSpriteCount']}`",
        f"- Component candidates / explicit sprite refs / explicit font-material refs: `{summary['componentCandidateCount']}` / `{summary['explicitSpriteOrTextureRefCount']}` / `{summary['explicitFontOrMaterialRefCount']}`",
        f"- Button / raycast-ready / handler-linked: `{summary['buttonCount']}` / `{summary['raycastReadyButtonCount']}` / `{summary['handlerLinkedButtonCount']}`",
        f"- Click validation: `{summary['clickValidation']}`",
        "",
        "## Root Results",
        "| role | prefab | sprites | unresolved sprites | text | tmp | fonts | buttons | raycast | handlers | active |",
        "| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |",
    ]
    for root in result.get("roots", []):
        lines.append(
            f"| {root.get('role','')} | `{root.get('prefabAsset','')}` | {root.get('resolvedSpriteCount',0)} | {root.get('unresolvedSpriteCount',0)} | {root.get('textCount',0)} | {root.get('tmpCount',0)} | {int(root.get('resolvedTextFontCount') or 0)+int(root.get('resolvedTmpFontCount') or 0)} | {root.get('buttonCount',0)} | {root.get('raycastReadyButtonCount',0)} | {root.get('handlerLinkedButtonCount',0)} | {root.get('sceneRootActive','')} |"
        )
    lines.extend(
        [
            "",
            "## Evidence Rules",
            "- Whole atlases were not placed as UI Images.",
            "- Sprite/font/material readiness is counted from resolved original AssetBundle references after loading candidate dependency bundles.",
            "- RectTransform hierarchy, anchors, pivots, local scale, and sibling order are preserved from source prefabs.",
            "- Missing refs remain unresolved/log-only; no fake icons, fake panels, or fake click handlers were added.",
            "",
            "## Video Motion Validation",
            f"- Source video: `{video_validation['video']}`",
            f"- Motion report: `{video_validation['motionReport']}`",
            f"- Restore notes: `{video_validation['restoreNotes']}`",
            "- Top-center circular overlay is excluded as recording/touch artifact.",
            "| clip | validation | current status | mismatch class |",
            "| --- | --- | --- | --- |",
        ]
    )
    for clip in video_validation["clips"]:
        lines.append(f"| `{clip['path']}` | {clip['validation']} | {clip['currentStatus']} | {clip['mismatchClass']} |")
    lines.extend(
        [
            "",
            "## Remaining Mismatch Classification",
            "- Normal HUD persistence is partially ready at static component/sprite/font level, but Canvas sorting/camera/runtime binding still needs motion-scene validation.",
            "- Still capture suppresses prior evidence/debug overlays; HUD visual is not camera-visible yet because Canvas/camera/sorting/runtime binding is still unresolved.",
            "- Floating damage/heal, hit flash, beam, and cut-in timing are motion reconstruction tasks and cannot be validated from a single still capture.",
            "- Button handlers are not linked yet; current validation is component/raycast-only.",
            "",
            "## BATTLE_20 Recommendation",
            f"- `{summary['nextBattle20Recommendation']}`",
        ]
    )
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
