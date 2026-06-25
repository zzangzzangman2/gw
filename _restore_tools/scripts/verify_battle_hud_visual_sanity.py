from __future__ import annotations

import json
from pathlib import Path

from PIL import Image, ImageDraw


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"

UNITY_JSON = UNITY_DATA / "BATTLE_HUD_VISUAL_SANITY_REBASE_TO_PLAY_VIDEO_RESULT.json"
B19_JOIN_JSON = UNITY_DATA / "BATTLE_HUD_SPRITE_REGION_FONT_JOIN_RESULT.json"
REFERENCE_JSON = REPORT_DIR / "BATTLE_20_PLAY_VIDEO_NORMAL_BATTLE_REFERENCE_486S.json"
REFERENCE_JPG = REPORT_DIR / "BATTLE_20_PLAY_VIDEO_NORMAL_BATTLE_REFERENCE_486S.jpg"
REPORT_JSON = REPORT_DIR / "BATTLE_HUD_VISUAL_SANITY_REBASE_TO_PLAY_VIDEO_RESULT.json"
REPORT_MD = REPORT_DIR / "BATTLE_HUD_VISUAL_SANITY_REBASE_TO_PLAY_VIDEO_RESULT.md"
CONTACT_SHEET = REPORT_DIR / "BATTLE_20_HUD_VISUAL_SANITY_CONTACT_SHEET.jpg"
CAPTURE = UNITY_DIR / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleHudVisualSanity_1680x720.png"
LOG = REPORT_DIR / "BATTLE_20_HUD_VISUAL_SANITY.log"


def read_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def image_stats(path: Path) -> dict:
    if not path.exists():
        return {"exists": False, "mean": 0.0, "nonBlackRatio": 0.0, "size": [0, 0]}
    image = Image.open(path).convert("L")
    hist = image.histogram()
    total = max(1, image.size[0] * image.size[1])
    mean = sum(i * hist[i] for i in range(256)) / total
    non_black = sum(hist[10:]) / total
    near_white = sum(hist[245:]) / total
    return {"exists": True, "mean": round(mean, 3), "nonBlackRatio": round(non_black, 5), "nearWhiteRatio": round(near_white, 5), "size": list(image.size)}


def make_contact_sheet(reference: Path, capture: Path, output: Path) -> None:
    panels = []
    for label, path in [("reference play.mp4 486s sequence", reference), ("BATTLE_20 capture", capture)]:
        if path.exists():
            image = Image.open(path).convert("RGB")
        else:
            image = Image.new("RGB", (840, 360), (0, 0, 0))
        image.thumbnail((840, 360), Image.Resampling.LANCZOS)
        panel = Image.new("RGB", (840, 400), (10, 10, 10))
        panel.paste(image, ((840 - image.width) // 2, 0))
        draw = ImageDraw.Draw(panel)
        draw.text((12, 372), label, fill=(255, 255, 255))
        panels.append(panel)
    sheet = Image.new("RGB", (1680, 400), (6, 6, 6))
    sheet.paste(panels[0], (0, 0))
    sheet.paste(panels[1], (840, 0))
    output.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(output, quality=92)


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    unity = read_json(UNITY_JSON)
    b19_join = read_json(B19_JOIN_JSON)
    reference = read_json(REFERENCE_JSON)
    log = LOG.read_text(encoding="utf-8", errors="replace") if LOG.exists() else ""
    capture_stats = image_stats(CAPTURE)
    make_contact_sheet(REFERENCE_JPG, CAPTURE, CONTACT_SHEET)

    debug_overlay_visible = bool(unity.get("debugOverlayVisible", False))
    black_or_blank = bool(capture_stats["exists"] and (capture_stats["mean"] < 6 or capture_stats["nonBlackRatio"] < 0.002))
    default_white_blocks_visible = bool(capture_stats.get("nearWhiteRatio", 0.0) > 0.22)
    large_white_bands_visible = default_white_blocks_visible
    placeholder_block_visible = bool(default_white_blocks_visible)
    b19_summary = b19_join.get("summary", {})
    active_graphic_count = int(unity.get("activeGraphicCount") or 0)
    resolved_sprite_count = int(b19_summary.get("resolvedSpriteCount") or 0)
    visible_original_sprite_count = 0 if placeholder_block_visible else resolved_sprite_count
    camera_visible_hud = bool(unity.get("cameraVisibleHud", False)) and not black_or_blank
    camera_visible_original_hud = bool(camera_visible_hud and not placeholder_block_visible and visible_original_sprite_count > 0)
    top_present = bool(unity.get("topHudZonePresent", False)) and camera_visible_hud
    bottom_present = bool(unity.get("bottomHudZonePresent", False)) and camera_visible_hud
    right_present = bool(unity.get("rightHudZonePresent", False)) and camera_visible_hud
    zone_false_positive = bool((top_present or bottom_present or right_present) and placeholder_block_visible)
    matches_clip05 = bool(top_present and bottom_present and right_present and reference.get("reference_video_used", False) and camera_visible_original_hud)

    if debug_overlay_visible:
        visual_status = "failed_debug_overlay"
        next_blocker = "debug/evidence overlay exclusion must be narrowed before HUD validation"
    elif black_or_blank:
        visual_status = "failed_black_capture"
        next_blocker = "Canvas/camera/sorting/runtime binding; HUD is not visible in capture"
    elif not camera_visible_hud:
        visual_status = "failed_offscreen_or_camera"
        next_blocker = "Canvas render mode, worldCamera, sorting order, or RectTransform bounds"
    elif not matches_clip05:
        visual_status = "failed_missing_runtime_binding"
        next_blocker = "BATTLE_21_BATTLE_HUD_RUNTIME_BINDING_AND_SPRITE_PPTR_VISUAL_TRACE"
    else:
        visual_status = "acceptable_partial"
        next_blocker = "floating damage and cut-in motion reconstruction"

    summary = {
        "reference_video_used": bool(reference.get("reference_video_used", False)),
        "visual_status": visual_status,
        "matches_clip05_static_hud_layout": matches_clip05,
        "debug_overlay_visible": debug_overlay_visible,
        "black_or_blank_capture": black_or_blank,
        "default_white_ui_blocks_visible": default_white_blocks_visible,
        "large_white_bands_visible": large_white_bands_visible,
        "placeholder_block_visible": placeholder_block_visible,
        "camera_visible_hud": camera_visible_hud,
        "camera_visible_original_hud": camera_visible_original_hud,
        "topHudZonePresent": top_present,
        "bottomHudZonePresent": bottom_present,
        "rightHudZonePresent": right_present,
        "topBottomRightZoneFalsePositive": zone_false_positive,
        "activeGraphicCount": active_graphic_count,
        "resolvedSpriteCountFromB19": resolved_sprite_count,
        "visibleOriginalSpriteCount": visible_original_sprite_count,
        "nextBlocker": next_blocker,
        "captureStats": capture_stats,
        "unityBatchmodeSuccess": "BattleHudVisualSanity generated." in log,
        "referenceContactSheet": str(REFERENCE_JPG),
        "capture": str(CAPTURE),
        "contactSheet": str(CONTACT_SHEET),
        "unityResult": str(UNITY_JSON),
        "scene": unity.get("scene", ""),
        "hudRootFound": unity.get("hudRootFound", False),
        "activeHudRoots": unity.get("activeHudRoots", 0),
        "canvasCount": unity.get("canvasCount", 0),
        "hudCanvasCount": unity.get("hudCanvasCount", 0),
        "activeGraphicCount": unity.get("activeGraphicCount", 0),
        "captureVisualizationFixApplied": unity.get("captureVisualizationFixApplied", False),
        "b19Reclassified": {
            "debugTextCapture": "failed_debug_overlay",
            "blackAfterSuppression": "failed_black_capture",
            "previousCaptureVisualStatus": "debug_overlay_suppressed_hud_not_camera_visible_yet",
        },
    }
    REPORT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(summary, unity, reference)
    print(json.dumps(summary, ensure_ascii=False, indent=2))


def write_report(summary: dict, unity: dict, reference: dict) -> None:
    lines = [
        "# Battle HUD Visual Sanity Rebase To Play Video Result",
        "",
        "## Verdict First",
        f"- visual_status: `{summary['visual_status']}`",
        f"- matches_clip05_static_hud_layout: `{summary['matches_clip05_static_hud_layout']}`",
        f"- camera_visible_hud: `{summary['camera_visible_hud']}`",
        f"- camera_visible_original_hud: `{summary['camera_visible_original_hud']}`",
        f"- black_or_blank_capture: `{summary['black_or_blank_capture']}`",
        f"- default_white_ui_blocks_visible: `{summary['default_white_ui_blocks_visible']}`",
        f"- placeholder_block_visible: `{summary['placeholder_block_visible']}`",
        f"- top/bottom/right zone false positive: `{summary['topBottomRightZoneFalsePositive']}`",
        f"- debug_overlay_visible: `{summary['debug_overlay_visible']}`",
        f"- next_blocker: `{summary['nextBlocker']}`",
        "",
        "## Required Fields",
        f"- reference_video_used: `{summary['reference_video_used']}`",
        f"- top/bottom/right HUD zones present: `{summary['topHudZonePresent']}` / `{summary['bottomHudZonePresent']}` / `{summary['rightHudZonePresent']}`",
        "- top/bottom/right zone false positive because placeholder graphics cover zones.",
        f"- capture_visualization_fix_applied: `{summary['captureVisualizationFixApplied']}`",
        "",
        "## Outputs",
        f"- Reference normal battle sheet: `{summary['referenceContactSheet']}`",
        f"- Capture after visual sanity: `{summary['capture']}`",
        f"- Contact sheet: `{summary['contactSheet']}`",
        f"- Report JSON: `{REPORT_JSON}`",
        f"- Unity data JSON: `{UNITY_JSON}`",
        f"- Unity batchmode success: `{summary['unityBatchmodeSuccess']}`",
        "",
        "## BATTLE_19 Reclassification",
        "- Debug/evidence text screen is a visual failure, not a restored HUD.",
        "- Black capture after suppressing roots is a visual failure, not acceptable output.",
        "- BATTLE_20 treats BATTLE_19 as needing Canvas/camera/runtime visual sanity before button handler work.",
        "",
        "## Clip 05 Reference",
        f"- Source video: `{reference.get('sourceVideo', '')}`",
        f"- Clip 05: `{reference.get('clip05', '')}`",
        f"- Frame window: `{reference.get('normalBattleHudPersistenceWindow', '')}`",
        "- Expected persistent zones: top HP/VS, bottom actor/skill cards, right vertical controls.",
        "",
        "## Unity Scene / Camera / Canvas Dump Summary",
        f"- scene: `{summary['scene']}`",
        f"- hud_root_found / active_hud_roots: `{summary['hudRootFound']}` / `{summary['activeHudRoots']}`",
        f"- canvas_count / hud_canvas_count: `{summary['canvasCount']}` / `{summary['hudCanvasCount']}`",
        f"- active_graphic_count: `{summary['activeGraphicCount']}`",
        f"- resolved_sprite_count_from_BATTLE19: `{summary['resolvedSpriteCountFromB19']}`",
        f"- visible_original_sprite_count: `{summary['visibleOriginalSpriteCount']}`",
        f"- capture stats mean/nonBlackRatio: `{summary['captureStats'].get('mean')}` / `{summary['captureStats'].get('nonBlackRatio')}`",
        f"- capture nearWhiteRatio: `{summary['captureStats'].get('nearWhiteRatio')}`",
        "",
        "## Root Cause Classification",
    ]
    for cause in unity.get("rootCauseClassification", []):
        lines.append(f"- {cause}")
    if summary["default_white_ui_blocks_visible"]:
        lines.append("- default_white_ui_blocks_visible: camera now sees live HUD hierarchy, but unresolved sprite/PPtr/material data renders as large white Image blocks; this is not original battle HUD quality.")
    if summary["topBottomRightZoneFalsePositive"]:
        lines.append("- top/bottom/right zone flags are false positives because placeholder/default graphics cover those zones without matching clip05 HUD sprites or shapes.")
    lines.extend(["", "## Next BATTLE_21 Recommendation", f"- `{summary['nextBlocker']}`"])
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
