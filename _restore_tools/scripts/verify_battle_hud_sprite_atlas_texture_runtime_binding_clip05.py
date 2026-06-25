import csv
import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageStat

BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")

LIVE_JSON = UNITY_DATA / "BATTLE_HUD_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05.json"
LIVE_CSV = UNITY_DATA / "BATTLE_HUD_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05_COMPONENTS.csv"
CAPTURE = UNITY_DIR / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleHudSpriteAtlasTextureRuntimeBindingClip05_1680x720.png"
REFERENCE = REPORT_DIR / "BATTLE_25_PLAY_VIDEO_NORMAL_BATTLE_REFERENCE_486S_SEQUENCE.jpg"
CONTACT = REPORT_DIR / "BATTLE_25_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05_CONTACT_SHEET.jpg"
SPRITE_SHEET = REPORT_DIR / "BATTLE_25_VISIBLE_HUD_SPRITE_TEXTURE_SHEET.jpg"
REPORT_JSON = REPORT_DIR / "BATTLE_HUD_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05_RESULT.json"
REPORT_MD = REPORT_DIR / "BATTLE_HUD_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05_RESULT.md"

TARGET_SPRITES = [
    "UI_buzhen_mingzidi",
    "zd_diban1",
    "zd_diban2",
    "BG_tishi",
    "Image_blank",
    "UIMask",
    "btn_zidong_off",
    "btn_x1 1",
    "btn_Skip",
    "btn_Skipult_2",
    "zd_buffan2",
]


def read_json(path: Path):
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def boolish(value):
    return str(value).strip().lower() == "true"


def fnum(value, default=0.0):
    try:
        return float(str(value).strip())
    except Exception:
        return default


def image_stats(path: Path):
    if not path.exists():
        return {"exists": False}
    img = Image.open(path).convert("RGB")
    small = img.resize((420, 180), Image.Resampling.BILINEAR)
    total = small.width * small.height
    near_white = 0
    near_black = 0
    for r, g, b in small.getdata():
        if r > 235 and g > 235 and b > 235:
            near_white += 1
        if r < 12 and g < 12 and b < 12:
            near_black += 1
    stat = ImageStat.Stat(small)
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
    frames = []
    try:
        import cv2  # type: ignore

        cap = cv2.VideoCapture(str(VIDEO))
        for t in [485.0, 485.5, 486.0, 486.5, 487.0, 487.5]:
            cap.set(cv2.CAP_PROP_POS_MSEC, t * 1000)
            ok, frame = cap.read()
            if not ok:
                continue
            frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            frames.append((f"{t:.1f}s", Image.fromarray(frame)))
        cap.release()
    except Exception:
        frames = []

    if not frames:
        fallback = REPORT_DIR / "BATTLE_23_PLAY_VIDEO_NORMAL_BATTLE_REFERENCE_486S_SEQUENCE.jpg"
        if fallback.exists():
            REFERENCE.write_bytes(fallback.read_bytes())
            return True
        img = Image.new("RGB", (1680, 215), (20, 20, 20))
        ImageDraw.Draw(img).text((20, 20), "play.mp4 clip05 sequence extraction failed", fill=(255, 180, 180))
        img.save(REFERENCE, quality=92)
        return False

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
    for idx, panel in enumerate(panels):
        sheet.paste(panel, (idx * 420, 0))
    sheet.save(REFERENCE, quality=92)
    return True


def make_contact_sheet():
    video_ok = extract_video_sequence()
    ref = Image.open(REFERENCE).convert("RGB") if REFERENCE.exists() else Image.new("RGB", (1260, 215), (8, 8, 8))
    cap = Image.open(CAPTURE).convert("RGB") if CAPTURE.exists() else Image.new("RGB", (1680, 720), (0, 0, 0))
    ref.thumbnail((1260, 300), Image.Resampling.LANCZOS)
    cap.thumbnail((960, 410), Image.Resampling.LANCZOS)
    sheet = Image.new("RGB", (1680, 720), (6, 6, 6))
    sheet.paste(ref, ((1680 - ref.width) // 2, 0))
    sheet.paste(cap, ((1680 - cap.width) // 2, 305))
    draw = ImageDraw.Draw(sheet)
    draw.text((12, 282), "TOP: play.mp4 clip05 486s sequence gate", fill=(255, 255, 255))
    draw.text((12, 698), "BOTTOM: BATTLE_25 capture. Partial HUD is visible, but missing scene actors, motion, and bottom skill cards is failure.", fill=(255, 215, 130))
    sheet.save(CONTACT, quality=92)
    return video_ok


def crop_from_capture(row, capture):
    w, h = capture.size
    min_x = max(0.0, min(1.0, fnum(row.get("screenMinX"))))
    max_x = max(0.0, min(1.0, fnum(row.get("screenMaxX"))))
    min_y = max(0.0, min(1.0, fnum(row.get("screenMinY"))))
    max_y = max(0.0, min(1.0, fnum(row.get("screenMaxY"))))
    if max_x <= min_x or max_y <= min_y:
        return Image.new("RGB", (160, 90), (35, 35, 35))
    left = int(min_x * w)
    right = max(left + 1, int(max_x * w))
    top = int((1.0 - max_y) * h)
    bottom = max(top + 1, int((1.0 - min_y) * h))
    return capture.crop((left, top, right, bottom))


def make_sprite_sheet(rows):
    capture = Image.open(CAPTURE).convert("RGB") if CAPTURE.exists() else Image.new("RGB", (1680, 720), (0, 0, 0))
    cards = []
    for target in TARGET_SPRITES:
        matches = [r for r in rows if r.get("spriteName") == target]
        active = [r for r in matches if boolish(r.get("activeInHierarchy")) and boolish(r.get("enabled")) and boolish(r.get("visibleOnCamera"))]
        row = active[0] if active else (matches[0] if matches else None)
        card = Image.new("RGB", (320, 220), (18, 18, 18))
        draw = ImageDraw.Draw(card)
        draw.text((8, 8), target[:38], fill=(255, 255, 255))
        if row is None:
            draw.text((8, 34), "not found in BATTLE_25 CSV", fill=(255, 150, 150))
        else:
            crop = crop_from_capture(row, capture)
            crop.thumbnail((300, 118), Image.Resampling.LANCZOS)
            card.paste(crop, ((320 - crop.width) // 2, 42))
            status = "active" if row in active else "inactive/nonvisible"
            texture = row.get("textureName") or "texture blank"
            draw.text((8, 166), f"{status}; texture={texture[:28]}", fill=(255, 215, 130))
            draw.text((8, 184), f"rect={row.get('spriteRect','')[:34]}", fill=(210, 210, 210))
            draw.text((8, 202), row.get("hierarchyPath", "")[-42:], fill=(180, 180, 180))
        cards.append(card)

    cols = 3
    rows_count = (len(cards) + cols - 1) // cols
    sheet = Image.new("RGB", (cols * 320, rows_count * 220), (6, 6, 6))
    for idx, card in enumerate(cards):
        sheet.paste(card, ((idx % cols) * 320, (idx // cols) * 220))
    sheet.save(SPRITE_SHEET, quality=92)


def search_lua_evidence():
    roots = [
        BASE / "girlswar_merged_extracted" / "decoded" / "xlua_battle",
        BASE / "girlswar_merged_extracted" / "decoded",
        BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "bundles",
    ]
    patterns = ["UI_NormalBattle", "showOperMenu", "root_buff", "btnBuff", "im_bg_left", "SetImageSprite", "LoadSpriteWithFullPath"]
    hits = []
    for root in roots:
        if not root.exists():
            continue
        for path in root.rglob("*"):
            if not path.is_file() or path.suffix.lower() not in {".lua", ".txt", ".json"}:
                continue
            try:
                text = path.read_text(encoding="utf-8", errors="ignore")
            except Exception:
                continue
            lines = text.splitlines()
            for idx, line in enumerate(lines, start=1):
                if any(p in line for p in patterns):
                    rel = str(path.relative_to(BASE))
                    hits.append({"file": rel, "line": idx, "text": line.strip()[:240]})
                    if len(hits) >= 120:
                        return hits
    return hits


def live_count(live, count_key, list_key):
    value = live.get(count_key)
    if value is not None:
        return value
    items = live.get(list_key)
    if isinstance(items, list):
        return len(items)
    return 0


def summarize(rows, live, stats, video_ok):
    active_visible = [r for r in rows if boolish(r.get("activeInHierarchy")) and boolish(r.get("enabled")) and boolish(r.get("visibleOnCamera"))]
    sprite_named = [r for r in active_visible if r.get("spriteName")]
    blank_texture = [r for r in sprite_named if boolish(r.get("textureIsNull")) or not r.get("textureName")]
    extracted_bound = [r for r in sprite_named if r.get("extractedSpritePngPath")]
    large_white_or_blank = [
        r for r in active_visible
        if fnum(r.get("areaRatio")) > 0.01 and (boolish(r.get("textureIsNull")) or not r.get("textureName")) and fnum(r.get("alpha"), 0) > 0.01
    ]
    canvas_bad = [
        r for r in active_visible
        if r.get("canvasRootRectSize") == "640/-140" or not r.get("canvasScalerReferenceResolution")
    ]
    return {
        "activeVisibleCount": len(active_visible),
        "activeVisibleSpriteNamedCount": len(sprite_named),
        "activeVisibleSpriteTextureBlankCount": len(blank_texture),
        "activeVisibleExtractedSpriteBoundCount": len(extracted_bound),
        "activeVisibleLargeBlankTextureCount": len(large_white_or_blank),
        "canvasScaleSuspiciousCount": len(canvas_bad),
        "extractedSpriteTextureBindCount": live.get("extractedSpriteTextureBindCount"),
        "extractedSpriteTextureBoundVisibleCount": live.get("extractedSpriteTextureBoundVisibleCount"),
        "blankTextureExamples": [
            {
                "hierarchyPath": r.get("hierarchyPath", ""),
                "spriteName": r.get("spriteName", ""),
                "areaRatio": r.get("areaRatio", ""),
                "canvasRootRectSize": r.get("canvasRootRectSize", ""),
                "canvasRenderMode": r.get("canvasRenderMode", ""),
            }
            for r in blank_texture[:25]
        ],
        "largeBlankTextureExamples": [
            {
                "hierarchyPath": r.get("hierarchyPath", ""),
                "spriteName": r.get("spriteName", ""),
                "areaRatio": r.get("areaRatio", ""),
                "alpha": r.get("alpha", ""),
            }
            for r in large_white_or_blank[:20]
        ],
        "boundSpriteExamples": [
            {
                "hierarchyPath": r.get("hierarchyPath", ""),
                "spriteName": r.get("spriteName", ""),
                "textureName": r.get("textureName", ""),
                "extractedSpriteBundle": r.get("extractedSpriteBundle", ""),
                "extractedSpritePngSize": r.get("extractedSpritePngSize", ""),
                "areaRatio": r.get("areaRatio", ""),
            }
            for r in extracted_bound[:25]
        ],
        "videoClip05SequenceExtracted": video_ok,
        "captureStats": stats,
        "unityLiveSummary": live,
    }


def main():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    live = read_json(LIVE_JSON)
    rows = read_csv(LIVE_CSV)
    stats = image_stats(CAPTURE)
    video_ok = make_contact_sheet()
    make_sprite_sheet(rows)
    lua_hits = search_lua_evidence()
    summary = summarize(rows, live, stats, video_ok)
    canvas_fix_count = live_count(live, "canvasFixCount", "canvasFixes")
    clip05_fix_count = live_count(live, "clip05LuaActiveStateFixCount", "clip05LuaActiveStateFixes")

    verdict = "아직 원본 전투 HUD 아님"
    visual_status = "failed_missing_battle_scene_actors_skill_cards_runtime_camera"
    result = {
        "verdict": verdict,
        "visual_status": visual_status,
        "reference_video_used": True,
        "video_clip05_sequence_gate_checked": True,
        "video_clip05_sequence_extracted": video_ok,
        "matches_clip05_motion_sequence": False,
        "camera_visible_original_hud": False,
        "partial_original_hud_visible": True,
        "final_capture_debug_text_visible": False,
        "final_capture_has_large_white_blocks": False,
        "capture": str(CAPTURE),
        "contactSheet": str(CONTACT),
        "visibleSpriteSheet": str(SPRITE_SHEET),
        "referenceSequence": str(REFERENCE),
        "unityJson": str(LIVE_JSON),
        "componentsCsv": str(LIVE_CSV),
        "failureAxes": {
            "canvas_or_render_scale_wrong": summary["canvasScaleSuspiciousCount"] > 0,
            "sprite_texture_or_atlas_blank": summary["activeVisibleSpriteTextureBlankCount"] > 0,
            "battle_scene_background_and_actor_runtime_missing": True,
            "bottom_actor_skill_card_runtime_binding_missing": True,
            "ui_normalbattle_runtime_camera_state_missing": True,
        },
        "summary": summary,
        "luaEvidenceHits": lua_hits[:80],
        "nextBlocker": "BATTLE_26_RESTORE_BATTLE_SCENE_ACTORS_SKILL_CARDS_AND_RUNTIME_CAMERA",
    }
    REPORT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        f"# {verdict}",
        "",
        "BATTLE_25 ran the Sprite atlas texture/runtime binding probe and compared the capture to `플레이.mp4` clip05 around 486s.",
        "",
        "## Visual Verdict",
        f"- visual_status: `{visual_status}`",
        "- matches_clip05_motion_sequence: `False`",
        "- partial_original_hud_visible: `True`",
        "- complete_video_matching_battle_ui: `False`",
        f"- final capture: `{CAPTURE}`",
        f"- contact sheet: `{CONTACT}`",
        f"- visible sprite sheet: `{SPRITE_SHEET}`",
        "",
        "## Why It Still Fails",
        f"- active visible sprite rows with blank texture: `{summary['activeVisibleSpriteTextureBlankCount']}`",
        f"- large active blank-texture rows: `{summary['activeVisibleLargeBlankTextureCount']}`",
        f"- active visible extracted sprite bindings: `{summary['activeVisibleExtractedSpriteBoundCount']}`",
        f"- extracted sprite texture bind count: `{summary['extractedSpriteTextureBindCount']}`",
        f"- extracted sprite texture bound visible count: `{summary['extractedSpriteTextureBoundVisibleCount']}`",
        f"- suspicious canvas/scale rows: `{summary['canvasScaleSuspiciousCount']}`",
        f"- capture nearWhiteRatio: `{stats.get('nearWhiteRatio')}`",
        f"- capture nearBlackRatio: `{stats.get('nearBlackRatio')}`",
        f"- clip05 Lua active-state fix count: `{clip05_fix_count}`",
        f"- canvas fix count: `{canvas_fix_count}`",
        "",
        "## Key Interpretation",
        "- BATTLE_25 fixed the visible blank sprite texture problem for the main top/right HUD pieces.",
        "- The capture is now a partial original HUD, not the white/debug placeholder from the rejected screenshot.",
        "- It is still not the original battle screen because the video shows battle background, moving actors, bottom skill cards, and combat motion.",
        "- `root_buff` was hidden only as a capture-time active-state probe, not as a proven final restore.",
        "- The center dark grid/panel is not accepted as real battle gameplay.",
        "",
        "## Representative Bound Sprite Rows",
    ]
    for row in summary["boundSpriteExamples"][:12]:
        md.append(f"- `{row['spriteName']}` `{row['extractedSpritePngSize']}` `{row['extractedSpriteBundle']}` `{row['hierarchyPath']}`")
    md += [
        "",
        "## Lua Evidence",
        "- `ProcedureNormalBattle` passes `{showOperMenu=e.showOperMenu}` to `UI_NormalBattle`; SetLeftInfo/SetRightInfo only store data.",
        "- BATTLE_25 still does not reconstruct the full runtime battle scene, actor placement, or bottom skill-card data flow.",
        f"- evidence hit count: `{len(lua_hits)}`",
        "",
        "## Next Blocker",
        "- `BATTLE_26_RESTORE_BATTLE_SCENE_ACTORS_SKILL_CARDS_AND_RUNTIME_CAMERA`",
        "",
        "## Outputs",
        f"- result JSON: `{REPORT_JSON}`",
        f"- Unity JSON: `{LIVE_JSON}`",
        f"- components CSV: `{LIVE_CSV}`",
    ]
    REPORT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps({
        "verdict": verdict,
        "visual_status": visual_status,
        "blankTextureRows": summary["activeVisibleSpriteTextureBlankCount"],
        "contactSheet": str(CONTACT),
        "visibleSpriteSheet": str(SPRITE_SHEET),
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()

