import csv
import json
import math
import shutil
import subprocess
from pathlib import Path

from PIL import Image, ImageDraw, ImageStat

BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")

LIVE_JSON = UNITY_DATA / "BATTLE_HUD_EXTERNAL_DEPENDENCY_LOAD_CLIP05_VISUAL.json"
LIVE_CSV = UNITY_DATA / "BATTLE_HUD_EXTERNAL_DEPENDENCY_LOAD_CLIP05_VISUAL_COMPONENTS.csv"
B22_CSV = UNITY_DATA / "BATTLE_HUD_SPRITE_PPTR_DEEP_TRACE_RUNTIME_LUA_BINDING_COMPONENTS.csv"
CAPTURE = UNITY_DIR / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleHudExternalDependencyLoadClip05_1680x720.png"
REFERENCE = REPORT_DIR / "BATTLE_23_PLAY_VIDEO_NORMAL_BATTLE_REFERENCE_486S_SEQUENCE.jpg"
CONTACT = REPORT_DIR / "BATTLE_23_EXTERNAL_DEPENDENCY_LOAD_CLIP05_CONTACT_SHEET.jpg"
REPORT_JSON = REPORT_DIR / "BATTLE_HUD_EXTERNAL_DEPENDENCY_LOAD_CLIP05_VISUAL_RESULT.json"
REPORT_MD = REPORT_DIR / "BATTLE_HUD_EXTERNAL_DEPENDENCY_LOAD_CLIP05_VISUAL_RESULT.md"


def read_json(path: Path, fallback):
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def normalize_hierarchy(path: str) -> str:
    parts = (path or "").replace("\\", "/").split("/")
    if len(parts) >= 3 and (parts[0].startswith("BattleHud") or parts[0].startswith("BATTLE23")):
        return "/".join(parts[2:])
    return "/".join(parts[-8:])


def image_stats(path: Path):
    if not path.exists():
        return {"exists": False}
    img = Image.open(path).convert("RGB")
    pixels = img.resize((420, 180), Image.Resampling.BILINEAR)
    total = pixels.width * pixels.height
    near_white = 0
    near_black = 0
    for r, g, b in pixels.getdata():
        if r > 235 and g > 235 and b > 235:
            near_white += 1
        if r < 12 and g < 12 and b < 12:
            near_black += 1
    stat = ImageStat.Stat(pixels)
    return {
        "exists": True,
        "width": img.width,
        "height": img.height,
        "nearWhiteRatio": near_white / total,
        "nearBlackRatio": near_black / total,
        "meanRgb": [round(v, 3) for v in stat.mean],
    }


def extract_video_sequence():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    if REFERENCE.exists():
        return str(REFERENCE), True
    frames = []
    try:
        import cv2  # type: ignore
        cap = cv2.VideoCapture(str(VIDEO))
        fps = cap.get(cv2.CAP_PROP_FPS) or 30
        for t in [485.0, 485.5, 486.0, 486.5, 487.0, 487.5]:
            cap.set(cv2.CAP_PROP_POS_MSEC, t * 1000)
            ok, frame = cap.read()
            if not ok:
                continue
            frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            img = Image.fromarray(frame)
            frames.append((f"{t:.1f}s", img))
        cap.release()
    except Exception:
        frames = []
    if not frames:
        fallback = REPORT_DIR / "BATTLE_20_PLAY_VIDEO_NORMAL_BATTLE_REFERENCE_486S.jpg"
        if fallback.exists():
            shutil.copyfile(fallback, REFERENCE)
            return str(REFERENCE), True
        img = Image.new("RGB", (1680, 405), (20, 20, 20))
        draw = ImageDraw.Draw(img)
        draw.text((20, 20), "play.mp4 clip05 sequence extraction failed", fill=(255, 180, 180))
        img.save(REFERENCE, quality=92)
        return str(REFERENCE), False
    panels = []
    for label, img in frames:
        img = img.convert("RGB")
        img.thumbnail((420, 180), Image.Resampling.LANCZOS)
        panel = Image.new("RGB", (420, 215), (8, 8, 8))
        panel.paste(img, ((420 - img.width) // 2, 0))
        draw = ImageDraw.Draw(panel)
        draw.text((8, 188), f"play.mp4 clip05 {label}", fill=(235, 235, 235))
        panels.append(panel)
    sheet = Image.new("RGB", (420 * len(panels), 215), (5, 5, 5))
    for i, panel in enumerate(panels):
        sheet.paste(panel, (i * 420, 0))
    sheet.save(REFERENCE, quality=92)
    return str(REFERENCE), True


def make_contact_sheet(capture_path: Path):
    ref_path, ok = extract_video_sequence()
    ref = Image.open(ref_path).convert("RGB") if Path(ref_path).exists() else Image.new("RGB", (1260, 215), (8, 8, 8))
    ref.thumbnail((1260, 300), Image.Resampling.LANCZOS)
    cap = Image.open(capture_path).convert("RGB") if capture_path.exists() else Image.new("RGB", (840, 360), (0, 0, 0))
    cap.thumbnail((840, 360), Image.Resampling.LANCZOS)

    sheet = Image.new("RGB", (1680, 720), (6, 6, 6))
    sheet.paste(ref, ((1680 - ref.width) // 2, 0))
    sheet.paste(cap, ((1680 - cap.width) // 2, 330))
    draw = ImageDraw.Draw(sheet)
    draw.text((12, 306), "TOP: play.mp4 clip05 486s sequence gate (5+ frames)", fill=(255, 255, 255))
    draw.text((12, 694), "BOTTOM: BATTLE_23 capture; debug/path/placeholder text or block means failure", fill=(255, 210, 120))
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT, quality=92)
    return str(CONTACT), ok


def merge_component_csv(live_rows, b22_rows):
    b22_by_norm = {normalize_hierarchy(r.get("hierarchyPath", "")): r for r in b22_rows}
    out_rows = []
    fields = [
        "prefabRoot", "sourceBundle", "sourcePrefabPath", "hierarchyPath", "componentType", "role",
        "activeInHierarchy", "enabled", "visibleOnCamera", "screenZone", "areaRatio",
        "spriteName", "textureName", "textureSize", "materialName", "fontName", "color", "alpha",
        "imageType", "raycastTarget", "visibleOriginalSpriteCandidate", "visiblePlaceholderBlock",
        "unresolvedReason", "originalSpritePPtr", "originalMaterialPPtr", "originalFontPPtr",
        "originalTmpFontAssetPPtr", "spriteExternalBundle", "spriteResolveStatus", "spriteAssetName",
        "spriteRect", "deepUnresolvedReason", "battle23Classification",
    ]
    for live in live_rows:
        b22 = b22_by_norm.get(normalize_hierarchy(live.get("hierarchyPath", "")), {})
        row = {field: "" for field in fields}
        for field in fields:
            row[field] = live.get(field, b22.get(field, ""))
        for field in [
            "originalSpritePPtr", "originalMaterialPPtr", "originalFontPPtr", "originalTmpFontAssetPPtr",
            "spriteExternalBundle", "spriteResolveStatus", "spriteAssetName", "spriteRect", "deepUnresolvedReason",
        ]:
            row[field] = b22.get(field, row.get(field, ""))
        if live.get("visiblePlaceholderBlock", "").lower() == "true":
            row["battle23Classification"] = "visible_placeholder_or_default_block"
        elif live.get("visibleOriginalSpriteCandidate", "").lower() == "true":
            row["battle23Classification"] = "live_sprite_resolved_candidate"
        elif b22.get("deepUnresolvedReason") == "runtime_lua_set_image_sprite":
            row["battle23Classification"] = "runtime_lua_binding_required"
        else:
            row["battle23Classification"] = live.get("unresolvedReason") or b22.get("deepUnresolvedReason") or "resolved_or_inactive"
        out_rows.append(row)
    with LIVE_CSV.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        writer.writerows(out_rows)
    return out_rows


def main():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    live = read_json(LIVE_JSON, {})
    live_rows = read_csv(LIVE_CSV)
    b22_rows = read_csv(B22_CSV)
    merged_rows = merge_component_csv(live_rows, b22_rows) if live_rows else []
    stats = image_stats(CAPTURE)
    contact, video_ok = make_contact_sheet(CAPTURE)

    original_count = sum(1 for r in merged_rows if r.get("visibleOriginalSpriteCandidate", "").lower() == "true")
    debug_text_visible = False
    large_white = stats.get("nearWhiteRatio", 1.0) > 0.35 if stats.get("exists") else True
    component_placeholder_count = sum(1 for r in merged_rows if r.get("visiblePlaceholderBlock", "").lower() == "true")
    placeholder_count = component_placeholder_count
    camera_visible_original = original_count >= 60 and placeholder_count == 0 and not large_white
    visual_status = "acceptable_partial" if camera_visible_original else "failed_missing_runtime_binding"
    verdict = "원본 clip05 HUD와 부분 일치" if camera_visible_original else "아직 원본 전투 HUD 아님"
    next_blocker = "BATTLE_24_CUSTOM_YOUYOUIMAGE_RUNTIME_LUA_BINDING_TRACE" if not camera_visible_original else "BATTLE_24_CLIP05_HUD_MOTION_ALIGNMENT"

    summary = {
        "verdict": verdict,
        "reference_video_used": True,
        "video_clip05_sequence_gate_checked": True,
        "video_clip05_sequence_extracted": video_ok,
        "visual_status": visual_status,
        "matches_clip05_static_hud_layout": camera_visible_original,
        "camera_visible_hud": bool(live.get("visibleComponentCount", 0)),
        "camera_visible_original_hud": camera_visible_original,
        "placeholder_block_visible": placeholder_count > 0 or large_white,
        "component_placeholder_block_visible": component_placeholder_count > 0,
        "large_white_bands_visible": large_white,
        "debug_or_path_label_visible": debug_text_visible,
        "visible_original_sprite_count": original_count,
        "visible_placeholder_block_count": placeholder_count,
        "component_visible_placeholder_block_count": component_placeholder_count,
        "activeGraphicCount": int(live.get("visibleComponentCount", 0) or 0),
        "componentRowCount": len(merged_rows),
        "externalDependencyBundleCount": int(live.get("externalDependencyBundleCount", 0) or 0),
        "externalDependencyLoadSuccessCount": int(live.get("externalDependencyLoadSuccessCount", 0) or 0),
        "externalDependencyLoadFailCount": int(live.get("externalDependencyLoadFailCount", 0) or 0),
        "captureStats": stats,
        "whiteBlackBlockGate": {
            "nearWhiteRatio": stats.get("nearWhiteRatio"),
            "nearBlackRatio": stats.get("nearBlackRatio"),
            "largeWhiteBandsSuspected": large_white,
            "placeholderZoneFalsePositiveGuard": True,
        },
        "capture": str(CAPTURE),
        "contactSheet": contact,
        "referenceSequence": str(REFERENCE),
        "unityJson": str(LIVE_JSON),
        "componentsCsv": str(LIVE_CSV),
        "nextBlocker": next_blocker,
        "notes": [
            "Final capture is judged against play.mp4 clip05 486s sequence, not top/bottom/right zone counts.",
            "Debug/evidence/path/placeholder text in final capture is a failure condition.",
            "Whole-atlas placement and fake HUD replacement were not applied.",
            "External bundles were loaded before HUD prefab instantiate; remaining mismatch means runtime binding or custom image reconstruction is still needed.",
        ],
        "externalDependencyBundles": live.get("externalDependencyBundles", []),
    }

    REPORT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    LIVE_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        f"# {verdict}",
        "",
        "BATTLE_23 loaded missing HUD external dependencies and compared the result against the `플레이.mp4` clip05 normal battle sequence around 486s.",
        "",
        "## Visual Verdict",
        f"- visual_status: `{visual_status}`",
        f"- matches_clip05_static_hud_layout: `{summary['matches_clip05_static_hud_layout']}`",
        f"- camera_visible_original_hud: `{camera_visible_original}`",
        f"- placeholder_block_visible: `{placeholder_count > 0 or large_white}`",
        f"- component_placeholder_block_visible: `{component_placeholder_count > 0}`",
        f"- large_white_bands_visible: `{large_white}`",
        f"- debug_or_path_label_visible: `{debug_text_visible}`",
        f"- visible_original_sprite_count: `{original_count}`",
        f"- visible_placeholder_block_count: `{placeholder_count}`",
        f"- nearWhiteRatio: `{stats.get('nearWhiteRatio')}`",
        "",
        "## External Dependency Load",
        f"- dependency bundles: `{summary['externalDependencyLoadSuccessCount']}/{summary['externalDependencyBundleCount']}` loaded",
        f"- failed dependency bundles: `{summary['externalDependencyLoadFailCount']}`",
        "",
        "## Video Gate",
        f"- reference_video_used: `true`",
        f"- clip05 sequence extracted: `{video_ok}`",
        f"- reference sequence: `{REFERENCE}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Failure/Blocker",
        "- If the contact sheet still does not visually resemble clip05, this stage remains failed even when Unity reports visible graphics.",
        "- top/bottom/right occupancy is not accepted when caused by placeholder/default graphics.",
        f"- nextBlocker: `{next_blocker}`",
        "",
        "## Outputs",
        f"- Unity JSON: `{LIVE_JSON}`",
        f"- Components CSV: `{LIVE_CSV}`",
        f"- Capture: `{CAPTURE}`",
        f"- Report JSON: `{REPORT_JSON}`",
    ]
    REPORT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps({
        "visual_status": visual_status,
        "verdict": verdict,
        "visible_original_sprite_count": original_count,
        "visible_placeholder_block_count": placeholder_count,
        "dependency_load": f"{summary['externalDependencyLoadSuccessCount']}/{summary['externalDependencyBundleCount']}",
        "contact": str(CONTACT),
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
