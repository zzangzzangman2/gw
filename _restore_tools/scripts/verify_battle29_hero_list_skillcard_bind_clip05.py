import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageStat

BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")

BATTLE29_JSON = UNITY_DATA / "BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05.json"
BATTLE27_JSON = UNITY_DATA / "BATTLE_CORRECT_MAP_SCENE_HUD_PREVIEW_CLIP05.json"
BATTLE29_CAPTURE = UNITY_DIR / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleHeroListSkillCardBindClip05_1920x1080.png"
BATTLE27_CAPTURE = UNITY_DIR / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleCorrectMapSceneHudPreviewClip05_1920x1080.png"
REFERENCE_SEQUENCE = REPORT_DIR / "BATTLE_29_PLAY_VIDEO_CLIP05_486S_SEQUENCE.jpg"
CONTACT = REPORT_DIR / "BATTLE_29_HERO_LIST_SKILLCARD_BIND_CLIP05_CONTACT_SHEET.jpg"
MAP_SPRITE_SHEET = REPORT_DIR / "BATTLE_29_MAP_11003_SPRITE_CONTACT_SHEET.jpg"
REPORT_JSON = REPORT_DIR / "BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05_RESULT.json"
REPORT_MD = REPORT_DIR / "BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05_RESULT.md"


def read_json(path):
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def image_stats(path):
    if not path.exists():
        return {"exists": False}
    img = Image.open(path).convert("RGB")
    small = img.resize((420, 180), Image.Resampling.BILINEAR)
    total = small.width * small.height
    near_white = 0
    near_black = 0
    visible = 0
    for r, g, b in small.getdata():
        if r > 235 and g > 235 and b > 235:
            near_white += 1
        if r < 12 and g < 12 and b < 12:
            near_black += 1
        if max(r, g, b) > 20:
            visible += 1
    stat = ImageStat.Stat(small)
    return {
        "exists": True,
        "width": img.width,
        "height": img.height,
        "nearWhiteRatio": round(near_white / total, 6),
        "nearBlackRatio": round(near_black / total, 6),
        "visiblePixelRatio": round(visible / total, 6),
        "meanRgb": [round(v, 3) for v in stat.mean],
    }


def extract_video_sequence():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    frames = []
    try:
        import cv2  # type: ignore

        cap = cv2.VideoCapture(str(VIDEO))
        for t in [485.0, 485.4, 485.8, 486.2, 486.6, 487.0]:
            cap.set(cv2.CAP_PROP_POS_MSEC, t * 1000)
            ok, frame = cap.read()
            if not ok:
                continue
            frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            frames.append((t, Image.fromarray(frame)))
        cap.release()
    except Exception:
        frames = []

    if not frames:
        fallback = REPORT_DIR / "BATTLE_28_PLAY_VIDEO_CLIP05_486S_SEQUENCE.jpg"
        if fallback.exists():
            REFERENCE_SEQUENCE.write_bytes(fallback.read_bytes())
            return False
        img = Image.new("RGB", (1680, 215), (20, 20, 20))
        ImageDraw.Draw(img).text((20, 20), "play.mp4 clip05 sequence extraction failed", fill=(255, 170, 170))
        img.save(REFERENCE_SEQUENCE, quality=92)
        return False

    panels = []
    for t, img in frames:
        img = img.convert("RGB")
        img.thumbnail((420, 180), Image.Resampling.LANCZOS)
        panel = Image.new("RGB", (420, 215), (8, 8, 8))
        panel.paste(img, ((420 - img.width) // 2, 0))
        draw = ImageDraw.Draw(panel)
        draw.text((8, 188), f"play.mp4 clip05 {t:.1f}s", fill=(235, 235, 235))
        panels.append(panel)
    sheet = Image.new("RGB", (420 * len(panels), 215), (5, 5, 5))
    for idx, panel in enumerate(panels):
        sheet.paste(panel, (idx * 420, 0))
    sheet.save(REFERENCE_SEQUENCE, quality=92)
    return True


def crop_bottom_center(path):
    if not path.exists():
        return Image.new("RGB", (560, 180), (0, 0, 0))
    img = Image.open(path).convert("RGB")
    left = int(img.width * 0.18)
    right = int(img.width * 0.82)
    top = int(img.height * 0.63)
    bottom = img.height
    crop = img.crop((left, top, right, bottom))
    crop.thumbnail((760, 250), Image.Resampling.LANCZOS)
    return crop


def bottom_card_score(path):
    if not path.exists():
        return {"exists": False}
    crop = crop_bottom_center(path).resize((380, 125), Image.Resampling.BILINEAR)
    total = crop.width * crop.height
    high_edge = 0
    non_floor_dark = 0
    for r, g, b in crop.getdata():
        mx = max(r, g, b)
        mn = min(r, g, b)
        if mx - mn > 70:
            high_edge += 1
        if mx > 80 and not (r > g > b and r - b < 90):
            non_floor_dark += 1
    return {
        "exists": True,
        "highChromaRatio": round(high_edge / total, 6),
        "nonFloorLikeRatio": round(non_floor_dark / total, 6),
    }


def battle_map_summary(battle27):
    layers = battle27.get("mapLayers") or []
    pixel_layers = [layer for layer in layers if "pixel_space" in str(layer.get("role", ""))]
    original_bundle = [layer for layer in layers if layer.get("role") == "original_battlemap_prefab_scene_bundle"]
    return {
        "capture": battle27.get("capture"),
        "mapLayerCount": battle27.get("mapLayerCount"),
        "mapLayerCreatedCount": battle27.get("mapLayerCreatedCount"),
        "originalBattlemapBundleLoaded": bool(original_bundle and original_bundle[0].get("created")),
        "originalBattlemapSpriteBindCount": original_bundle[0].get("mapSpriteTextureBindCount") if original_bundle else None,
        "pixelMatchedMapLayerCount": len(pixel_layers),
        "pixelMatchedMapLayers": [layer.get("spriteName") for layer in pixel_layers],
    }


def make_contact_sheet(live, stats, b27_card, b29_card, map_summary):
    video_ok = extract_video_sequence()
    sheet = Image.new("RGB", (1680, 1080), (6, 6, 6))
    draw = ImageDraw.Draw(sheet)

    ref = Image.open(REFERENCE_SEQUENCE).convert("RGB") if REFERENCE_SEQUENCE.exists() else Image.new("RGB", (1680, 215), (8, 8, 8))
    ref.thumbnail((1680, 220), Image.Resampling.LANCZOS)
    sheet.paste(ref, ((1680 - ref.width) // 2, 0))
    draw.text((12, 224), "TOP: play.mp4 clip05 sequence. Top-center circle is recording/touch artifact, not restored UI.", fill=(255, 255, 255))

    b27 = crop_bottom_center(BATTLE27_CAPTURE)
    b29 = crop_bottom_center(BATTLE29_CAPTURE)
    sheet.paste(b27, (35, 300))
    sheet.paste(b29, (885, 300))
    draw.text((35, 275), "BATTLE_27 bottom-center before hero-card bind", fill=(255, 215, 130))
    draw.text((885, 275), "BATTLE_29 bottom-center after binding original heroitem template", fill=(255, 215, 130))

    full = Image.open(BATTLE29_CAPTURE).convert("RGB") if BATTLE29_CAPTURE.exists() else Image.new("RGB", (1680, 720), (0, 0, 0))
    full.thumbnail((960, 410), Image.Resampling.LANCZOS)
    sheet.paste(full, (35, 640))
    summary = [
        "BATTLE_29 summary",
        f"templateFound: {live.get('templateFound')}",
        f"containerFound: {live.get('containerFound')}",
        f"boundHeroCardCount: {live.get('boundHeroCardCount')}",
        f"headSpriteBindCount: {live.get('headSpriteBindCount')}",
        f"extractedSpriteBindCount: {live.get('extractedSpriteBindCount')}",
        f"hiddenUnresolvedWhiteDataIconCount: {live.get('hiddenUnresolvedWhiteDataIconCount')}",
        f"visibleCardImageCount: {live.get('visibleCardImageCount')}",
        f"visibleWhiteLikeCardImageCount: {live.get('visibleWhiteLikeCardImageCount')}",
        f"mapLayerCreatedCount: {map_summary.get('mapLayerCreatedCount')}",
        f"pixelMatchedMapLayerCount: {map_summary.get('pixelMatchedMapLayerCount')}",
        f"BATTLE_27 bottom nonFloorLike: {b27_card.get('nonFloorLikeRatio')}",
        f"BATTLE_29 bottom nonFloorLike: {b29_card.get('nonFloorLikeRatio')}",
        f"nearWhiteRatio: {stats.get('nearWhiteRatio')}",
        "still not final: card positions are inferred from original container/template,",
        "and actor animation/runtime motion is still not replayed.",
    ]
    y = 650
    for line in summary:
        draw.text((1030, y), line, fill=(235, 235, 235))
        y += 24
    sheet.save(CONTACT, quality=92)
    return video_ok


def main():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    live = read_json(BATTLE29_JSON)
    battle27 = read_json(BATTLE27_JSON)
    map_summary = battle_map_summary(battle27)
    stats = image_stats(BATTLE29_CAPTURE)
    b27_card = bottom_card_score(BATTLE27_CAPTURE)
    b29_card = bottom_card_score(BATTLE29_CAPTURE)
    video_ok = make_contact_sheet(live, stats, b27_card, b29_card, map_summary)

    bound_count = int(live.get("boundHeroCardCount") or 0)
    head_bind_count = int(live.get("headSpriteBindCount") or 0)
    extracted_bind_count = int(live.get("extractedSpriteBindCount") or 0)
    visible_card_images = int(live.get("visibleCardImageCount") or 0)
    visible_white_like = int(live.get("visibleWhiteLikeCardImageCount") or 0)
    visual_status = "failed_hero_cards_not_bound"
    if not stats.get("exists"):
        visual_status = "failed_capture_missing"
    elif stats.get("nearWhiteRatio", 1) > 0.2:
        visual_status = "failed_large_white_capture"
    elif visible_white_like > 6:
        visual_status = "failed_visible_white_card_blocks"
    elif bound_count >= 3 and head_bind_count >= 3 and visible_card_images > 0:
        visual_status = "improved_hero_list_cards_bound_not_final"

    result = {
        "verdict": "battle29_hero_list_skillcard_bind_preview_not_final",
        "visual_status": visual_status,
        "reference_video_used": True,
        "video_clip05_sequence_extracted": video_ok,
        "unityJson": str(BATTLE29_JSON),
        "capture": str(BATTLE29_CAPTURE),
        "contactSheet": str(CONTACT),
        "captureStats": stats,
        "battle27BottomScore": b27_card,
        "battle29BottomScore": b29_card,
        "battle27MapSummary": map_summary,
        "unityLiveSummary": live,
        "hiddenUnresolvedWhiteDataIconCount": live.get("hiddenUnresolvedWhiteDataIconCount"),
        "failureAxes": {
            "heroitem_template_runtime_clone_missing_before_battle29": True,
            "battle29_positions_inferred_not_original_runtime_verified": True,
            "actor_motion_not_replayed": True,
            "skill_effect_runtime_not_attached_to_cards_or_motion": True,
        },
        "nextBlocker": "BATTLE_30_VERIFY_HERO_CARD_RUNTIME_LAYOUT_AND_ATTACH_ACTOR_ANIMATION_TRACE",
    }
    REPORT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_29 Hero List Skill-Card Bind Preview",
        "",
        "This is not a final restored battle screen. It tests the BATTLE_28 finding that `ui_normalbattle_heroitem` exists as a template but is not cloned/bound into `HeroListContainer` at runtime.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- reference video: `C:\\Users\\godho\\Downloads\\플레이.mp4` clip05 around 486s",
        f"- capture: `{BATTLE29_CAPTURE}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Binding Evidence",
        f"- templateFound: `{live.get('templateFound')}`",
        f"- containerFound: `{live.get('containerFound')}`",
        f"- boundHeroCardCount: `{live.get('boundHeroCardCount')}`",
        f"- headSpriteBindCount: `{live.get('headSpriteBindCount')}`",
        f"- extractedSpriteBindCount: `{live.get('extractedSpriteBindCount')}`",
        f"- hiddenUnresolvedWhiteDataIconCount: `{live.get('hiddenUnresolvedWhiteDataIconCount')}`",
        f"- visibleCardImageCount: `{live.get('visibleCardImageCount')}`",
        f"- visibleWhiteLikeCardImageCount: `{live.get('visibleWhiteLikeCardImageCount')}`",
        f"- BATTLE_27 bottom nonFloorLikeRatio: `{b27_card.get('nonFloorLikeRatio')}`",
        f"- BATTLE_29 bottom nonFloorLikeRatio: `{b29_card.get('nonFloorLikeRatio')}`",
        f"- capture nearWhiteRatio: `{stats.get('nearWhiteRatio')}`",
        "",
        "## Battle Map Evidence",
        f"- capture resolution: `{stats.get('width')}x{stats.get('height')}`",
        f"- originalBattlemapBundleLoaded: `{map_summary.get('originalBattlemapBundleLoaded')}`",
        f"- originalBattlemapSpriteBindCount: `{map_summary.get('originalBattlemapSpriteBindCount')}`",
        f"- mapLayerCreatedCount: `{map_summary.get('mapLayerCreatedCount')}`",
        f"- pixelMatchedMapLayerCount: `{map_summary.get('pixelMatchedMapLayerCount')}`",
        f"- pixelMatchedMapLayers: `{', '.join(map_summary.get('pixelMatchedMapLayers') or [])}`",
        "",
        "## Bound Cards",
    ]
    for card in live.get("cards") or []:
        md.append(f"- slot `{card.get('slot')}` heroDid `{card.get('heroDid')}` head `{card.get('headSprite')}` headBind `{card.get('headBindCount')}` spriteBind `{card.get('extractedSpriteBindCount')}` hiddenUnresolved `{card.get('hiddenUnresolvedWhiteDataIconCount')}` visibleImages `{card.get('visibleImageCount')}` whiteLike `{card.get('visibleWhiteLikeImageCount')}` skills `{card.get('normalSkill')}/{card.get('smallSkill')}/{card.get('bigSkill')}`")
    md += [
        "",
        "## Interpretation",
        "- BATTLE_29 uses the original `ui_normalbattle_heroitem` prefab template and original `HeroListContainer`, not a hand-drawn card.",
        "- Hero head sprites are bound from extracted original sprite slices: `head1036`, `head1002`, `head1034`.",
        "- The result is still not final because card positions are inferred from the original container width/template size rather than proven by the original Lua/UI runtime layout pass.",
        "- Actor animation and skill-effect runtime replay remain unresolved.",
        "",
        "## Next Blocker",
        "- `BATTLE_30_VERIFY_HERO_CARD_RUNTIME_LAYOUT_AND_ATTACH_ACTOR_ANIMATION_TRACE`",
        "",
        "## Outputs",
        f"- result JSON: `{REPORT_JSON}`",
        f"- Unity JSON: `{BATTLE29_JSON}`",
        f"- contact sheet: `{CONTACT}`",
        f"- map sprite sheet: `{MAP_SPRITE_SHEET}`",
    ]
    REPORT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps({
        "visual_status": visual_status,
        "boundHeroCardCount": live.get("boundHeroCardCount"),
        "headSpriteBindCount": live.get("headSpriteBindCount"),
        "extractedSpriteBindCount": live.get("extractedSpriteBindCount"),
        "hiddenUnresolvedWhiteDataIconCount": live.get("hiddenUnresolvedWhiteDataIconCount"),
        "visibleCardImageCount": live.get("visibleCardImageCount"),
        "visibleWhiteLikeCardImageCount": live.get("visibleWhiteLikeCardImageCount"),
        "contactSheet": str(CONTACT),
        "nextBlocker": result["nextBlocker"],
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
