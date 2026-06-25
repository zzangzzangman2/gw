import csv
import json
import math
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageStat

BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")

BATTLE27_CAPTURE = UNITY_DIR / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleCorrectMapSceneHudPreviewClip05_1680x720.png"
BATTLE27_JSON = UNITY_DATA / "BATTLE_CORRECT_MAP_SCENE_HUD_PREVIEW_CLIP05.json"
HUD_CSV = UNITY_DATA / "BATTLE_HUD_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05_COMPONENTS.csv"
FLOW_JSON = UNITY_DATA / "BATTLE_RUNTIME_FLOW_MANIFEST.json"
SKILL_PROBE_JSON = UNITY_DATA / "BATTLE_SKILL_EFFECT_STREAMING_PROBE.json"
XLUA_BATTLE = BASE / "girlswar_merged_extracted" / "decoded" / "xlua_battle"

REFERENCE_SEQUENCE = REPORT_DIR / "BATTLE_28_PLAY_VIDEO_CLIP05_486S_SEQUENCE.jpg"
CONTACT = REPORT_DIR / "BATTLE_28_ACTOR_MOTION_SKILLCARD_EVIDENCE_CONTACT_SHEET.jpg"
REPORT_JSON = REPORT_DIR / "BATTLE_28_ACTOR_MOTION_SKILLCARD_EVIDENCE_RESULT.json"
REPORT_MD = REPORT_DIR / "BATTLE_28_ACTOR_MOTION_SKILLCARD_EVIDENCE_RESULT.md"


def read_json(path):
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path):
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


def extract_video_frames():
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
    return frames


def make_sequence_sheet(frames):
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    panels = []
    if not frames:
        img = Image.new("RGB", (1680, 215), (20, 20, 20))
        ImageDraw.Draw(img).text((20, 20), "play.mp4 clip05 sequence extraction failed", fill=(255, 170, 170))
        img.save(REFERENCE_SEQUENCE, quality=92)
        return
    for t, img in frames:
        panel_img = img.convert("RGB")
        panel_img.thumbnail((420, 180), Image.Resampling.LANCZOS)
        panel = Image.new("RGB", (420, 215), (8, 8, 8))
        panel.paste(panel_img, ((420 - panel_img.width) // 2, 0))
        draw = ImageDraw.Draw(panel)
        draw.text((8, 188), f"play.mp4 clip05 {t:.1f}s", fill=(235, 235, 235))
        panels.append(panel)
    sheet = Image.new("RGB", (420 * len(panels), 215), (5, 5, 5))
    for idx, panel in enumerate(panels):
        sheet.paste(panel, (idx * 420, 0))
    sheet.save(REFERENCE_SEQUENCE, quality=92)


def mask_components(mask, min_area=90):
    width, height = mask.size
    pix = mask.load()
    seen = set()
    boxes = []
    for y in range(height):
        for x in range(width):
            if (x, y) in seen or pix[x, y] == 0:
                continue
            stack = [(x, y)]
            seen.add((x, y))
            min_x = max_x = x
            min_y = max_y = y
            area = 0
            while stack:
                cx, cy = stack.pop()
                area += 1
                min_x = min(min_x, cx)
                max_x = max(max_x, cx)
                min_y = min(min_y, cy)
                max_y = max(max_y, cy)
                for nx, ny in ((cx + 1, cy), (cx - 1, cy), (cx, cy + 1), (cx, cy - 1)):
                    if nx < 0 or ny < 0 or nx >= width or ny >= height:
                        continue
                    if (nx, ny) in seen or pix[nx, ny] == 0:
                        continue
                    seen.add((nx, ny))
                    stack.append((nx, ny))
            if area >= min_area:
                boxes.append({
                    "x": min_x,
                    "y": min_y,
                    "w": max_x - min_x + 1,
                    "h": max_y - min_y + 1,
                    "area": area,
                    "cx": (min_x + max_x + 1) / 2,
                    "cy": (min_y + max_y + 1) / 2,
                })
    boxes.sort(key=lambda item: item["area"], reverse=True)
    return boxes


def threshold_diff_image(img_a, img_b):
    a = img_a.convert("RGB").resize((420, 180), Image.Resampling.BILINEAR)
    b = img_b.convert("RGB").resize((420, 180), Image.Resampling.BILINEAR)
    diff = ImageChops.difference(a, b).convert("L")
    mask = Image.new("L", diff.size, 0)
    dp = diff.load()
    mp = mask.load()
    for y in range(diff.height):
        for x in range(diff.width):
            if dp[x, y] > 22:
                mp[x, y] = 255
    return diff, mask


def analyze_video_motion(frames):
    pairs = []
    all_boxes = []
    actor_motion_boxes = []
    bottom_motion_boxes = []
    for idx in range(len(frames) - 1):
        t0, img0 = frames[idx]
        t1, img1 = frames[idx + 1]
        diff, mask = threshold_diff_image(img0, img1)
        boxes = mask_components(mask, min_area=80)
        for box in boxes:
            box["pair"] = f"{t0:.1f}-{t1:.1f}s"
            box["normX"] = round(box["cx"] / 420, 4)
            box["normY"] = round(box["cy"] / 180, 4)
            all_boxes.append(box)
            if 0.18 <= box["normY"] <= 0.78 and box["area"] >= 120:
                actor_motion_boxes.append(box)
            if box["normY"] >= 0.68 and box["area"] >= 80:
                bottom_motion_boxes.append(box)
        pairs.append((t0, t1, diff, mask, boxes))
    return {
        "pairCount": len(pairs),
        "motionComponentCount": len(all_boxes),
        "actorMotionComponentCount": len(actor_motion_boxes),
        "bottomMotionComponentCount": len(bottom_motion_boxes),
        "largestMotionBoxes": all_boxes[:25],
        "actorMotionBoxes": actor_motion_boxes[:25],
        "bottomMotionBoxes": bottom_motion_boxes[:25],
        "pairs": pairs,
    }


def crop_stage(img):
    img = img.convert("RGB")
    return img.crop((0, int(img.height * 0.1), img.width, int(img.height * 0.97)))


def bottom_card_color_ratio(img):
    img = img.convert("RGB")
    left = int(img.width * 0.22)
    right = int(img.width * 0.78)
    top = int(img.height * 0.72)
    bottom = int(img.height * 0.98)
    crop = img.crop((left, top, right, bottom)).resize((280, 130), Image.Resampling.BILINEAR)
    total = crop.width * crop.height
    bright_sat = 0
    edge_like = 0
    for r, g, b in crop.getdata():
        mx = max(r, g, b)
        mn = min(r, g, b)
        if mx > 130 and (mx - mn) > 45:
            bright_sat += 1
        if mx - mn > 70:
            edge_like += 1
    return {
        "brightSaturatedRatio": round(bright_sat / total, 6),
        "highChromaRatio": round(edge_like / total, 6),
    }


def analyze_bottom_card_region(frames):
    video_ratios = []
    for t, img in frames:
        ratio = bottom_card_color_ratio(img)
        ratio["time"] = t
        video_ratios.append(ratio)
    capture_ratio = bottom_card_color_ratio(Image.open(BATTLE27_CAPTURE)) if BATTLE27_CAPTURE.exists() else {}
    return {
        "videoBottomCardColorRatios": video_ratios,
        "battle27BottomCardColorRatio": capture_ratio,
    }


def analyze_hud_bottom_components(rows):
    bottom_candidates = []
    for row in rows:
        path = row.get("hierarchyPath", "")
        text = (path + " " + row.get("spriteName", "") + " " + row.get("textSample", "")).lower()
        is_bottom = fnum(row.get("screenMinY")) < 0.35 or "bottom" in path.lower() or "herolist" in path.lower()
        is_skillish = any(key in text for key in ["skill", "hero", "card", "head", "bottom", "btnfastskill", "btntwospeed", "oper", "opra"])
        if not is_bottom or not is_skillish:
            continue
        bottom_candidates.append(row)

    active_visible = [
        row for row in bottom_candidates
        if boolish(row.get("activeInHierarchy")) and boolish(row.get("enabled")) and boolish(row.get("visibleOnCamera"))
    ]
    meaningful = [row for row in active_visible if fnum(row.get("areaRatio")) > 0.001]
    bottom_center_meaningful = [
        row for row in meaningful
        if fnum(row.get("screenMinX")) < 0.8 and fnum(row.get("screenMaxX")) > 0.2 and fnum(row.get("screenMinY")) < 0.35
    ]
    return {
        "bottomCandidateCount": len(bottom_candidates),
        "activeVisibleBottomCandidateCount": len(active_visible),
        "meaningfulBottomCandidateCount": len(meaningful),
        "meaningfulBottomCenterCandidateCount": len(bottom_center_meaningful),
        "bottomCenterExamples": [
            {
                "role": row.get("role", ""),
                "spriteName": row.get("spriteName", ""),
                "textSample": row.get("textSample", ""),
                "hierarchyPath": row.get("hierarchyPath", ""),
                "screenMinX": row.get("screenMinX", ""),
                "screenMaxX": row.get("screenMaxX", ""),
                "screenMinY": row.get("screenMinY", ""),
                "screenMaxY": row.get("screenMaxY", ""),
                "areaRatio": row.get("areaRatio", ""),
                "extractedSpritePngSize": row.get("extractedSpritePngSize", ""),
            }
            for row in bottom_center_meaningful[:40]
        ],
    }


def analyze_actor_runtime(flow, battle27):
    slots = flow.get("actorSlots") or []
    b27_actors = battle27.get("actors") or []
    loadable = [slot for slot in slots if slot.get("loadStatus") == "runtime_prefab"]
    missing = [slot for slot in slots if slot.get("loadStatus") != "runtime_prefab"]
    instantiated = [actor for actor in b27_actors if actor.get("instantiated")]
    textured = [actor for actor in instantiated if actor.get("actorAtlasTextureLoaded") and actor.get("actorAtlasTextureBoundMaterialCount", 0) > 0]
    return {
        "runtimeSlotCount": len(slots),
        "runtimePrefabSlotCount": len(loadable),
        "missingSlotCount": len(missing),
        "battle27InstantiatedActorCount": len(instantiated),
        "battle27TexturedActorCount": len(textured),
        "missingSlots": [
            {
                "side": slot.get("side"),
                "wave": slot.get("wave"),
                "slot": slot.get("slot"),
                "heroDid": slot.get("heroDid"),
                "modelId": slot.get("modelId"),
                "missingReason": slot.get("missingReason"),
                "skillIds": slot.get("skillIds"),
            }
            for slot in missing
        ],
        "instantiatedActors": [
            {
                "side": actor.get("side"),
                "wave": actor.get("wave"),
                "slot": actor.get("slot"),
                "heroDid": actor.get("heroDid"),
                "modelId": actor.get("modelId"),
                "enabledRendererCount": actor.get("enabledRendererCount"),
                "spineSkeletonGraphicCount": actor.get("spineSkeletonGraphicCount"),
                "spineSkeletonAnimationCount": actor.get("spineSkeletonAnimationCount"),
                "actorAtlasTextureBoundMaterialCount": actor.get("actorAtlasTextureBoundMaterialCount"),
            }
            for actor in instantiated
        ],
    }


def analyze_skill_probe(probe):
    skills = probe.get("skills") or []
    found = [skill for skill in skills if skill.get("skillFound")]
    timeline = [skill for skill in skills if skill.get("timelineFound")]
    loadable_probe = []
    unique_loadable_probe = {}
    missing_bundle_candidates = []
    unique_missing_bundle_candidates = {}
    for skill in skills:
        for probe_row in skill.get("unityBundleProbe") or []:
            if probe_row.get("loadableEffectPrefabCount", 0) > 0:
                row = {"skillId": skill.get("skillId"), **probe_row}
                loadable_probe.append(row)
                bundle_key = probe_row.get("bundle") or f"skill:{skill.get('skillId')}"
                if bundle_key not in unique_loadable_probe:
                    unique_loadable_probe[bundle_key] = row
        for cand in skill.get("bundleCandidates") or []:
            if not cand.get("exists"):
                row = {"skillId": skill.get("skillId"), **cand}
                missing_bundle_candidates.append(row)
                bundle_key = cand.get("bundle") or f"skill:{skill.get('skillId')}"
                if bundle_key not in unique_missing_bundle_candidates:
                    unique_missing_bundle_candidates[bundle_key] = row
    return {
        "skillCount": len(skills),
        "skillFoundCount": len(found),
        "timelineFoundCount": len(timeline),
        "loadableEffectBundleProbeCount": len(loadable_probe),
        "loadableEffectPrefabCountTotal": sum(row.get("loadableEffectPrefabCount", 0) for row in loadable_probe),
        "uniqueLoadableEffectBundleCount": len(unique_loadable_probe),
        "uniqueLoadableEffectPrefabCountTotal": sum(row.get("loadableEffectPrefabCount", 0) for row in unique_loadable_probe.values()),
        "missingBundleCandidateCount": len(missing_bundle_candidates),
        "uniqueMissingBundleCandidateCount": len(unique_missing_bundle_candidates),
        "loadableEffectBundleExamples": loadable_probe[:20],
        "uniqueLoadableEffectBundleExamples": list(unique_loadable_probe.values())[:20],
        "missingBundleCandidateExamples": missing_bundle_candidates[:30],
        "uniqueMissingBundleCandidateExamples": list(unique_missing_bundle_candidates.values())[:30],
    }


def search_lua_evidence():
    patterns = [
        "UI_NormalBattle",
        "showOperMenu",
        "GameFastSkill",
        "HeroSkillInfo",
        "skillCount",
        "OnBattleUILoadComplete",
        "SetLeftInfo",
        "SetRightInfo",
        "LoadPlayerHeros",
        "LoadEnemyPlayerHeros",
        "OnShowHeadBar",
        "BeginFightPlayWithServer",
        "BeginBattleWithServer",
    ]
    hits = []
    if not XLUA_BATTLE.exists():
        return hits
    for path in XLUA_BATTLE.rglob("*.lua"):
        try:
            lines = path.read_text(encoding="utf-8", errors="ignore").splitlines()
        except Exception:
            continue
        for idx, line in enumerate(lines, start=1):
            if any(pattern in line for pattern in patterns):
                hits.append({
                    "file": str(path.relative_to(BASE)),
                    "line": idx,
                    "text": line.strip()[:260],
                })
                if len(hits) >= 140:
                    return hits
    return hits


def make_contact_sheet(frames, motion, card, hud, actor):
    make_sequence_sheet(frames)
    sheet = Image.new("RGB", (1680, 1080), (6, 6, 6))
    draw = ImageDraw.Draw(sheet)

    ref = Image.open(REFERENCE_SEQUENCE).convert("RGB") if REFERENCE_SEQUENCE.exists() else Image.new("RGB", (1680, 215), (8, 8, 8))
    ref.thumbnail((1680, 220), Image.Resampling.LANCZOS)
    sheet.paste(ref, ((1680 - ref.width) // 2, 0))
    draw.text((12, 224), "TOP: play.mp4 clip05 sequence. This gate checks motion, not one still screenshot.", fill=(255, 255, 255))

    if motion["pairs"]:
        panels = []
        for t0, t1, diff, mask, boxes in motion["pairs"][:5]:
            panel = Image.new("RGB", (320, 220), (12, 12, 12))
            diff_rgb = diff.convert("RGB")
            diff_rgb.thumbnail((300, 135), Image.Resampling.LANCZOS)
            panel.paste(diff_rgb, ((320 - diff_rgb.width) // 2, 8))
            pd = ImageDraw.Draw(panel)
            pd.text((8, 150), f"motion {t0:.1f}-{t1:.1f}s", fill=(235, 235, 235))
            pd.text((8, 170), f"components={len(boxes)}", fill=(255, 215, 130))
            for box in boxes[:5]:
                x0 = int(10 + box["x"] * 300 / 420)
                y0 = int(8 + box["y"] * 135 / 180)
                x1 = int(10 + (box["x"] + box["w"]) * 300 / 420)
                y1 = int(8 + (box["y"] + box["h"]) * 135 / 180)
                pd.rectangle((x0, y0, x1, y1), outline=(255, 80, 80), width=1)
            panels.append(panel)
        for idx, panel in enumerate(panels):
            sheet.paste(panel, (20 + idx * 330, 250))

    cap = Image.open(BATTLE27_CAPTURE).convert("RGB") if BATTLE27_CAPTURE.exists() else Image.new("RGB", (1680, 720), (0, 0, 0))
    cap_stage = crop_stage(cap)
    cap_stage.thumbnail((960, 410), Image.Resampling.LANCZOS)
    sheet.paste(cap_stage, (20, 650))
    draw.text((20, 630), "BATTLE_27 current capture: map/HUD/3 textured actors visible, but static and not video-motion matched.", fill=(255, 215, 130))

    summary_x = 1010
    y = 650
    lines = [
        "BATTLE_28 evidence summary",
        f"video motion components: {motion['motionComponentCount']}",
        f"actor motion components: {motion['actorMotionComponentCount']}",
        f"bottom motion components: {motion['bottomMotionComponentCount']}",
        f"runtime slots: {actor['runtimeSlotCount']}",
        f"runtime prefab slots: {actor['runtimePrefabSlotCount']}",
        f"missing actor slots: {actor['missingSlotCount']}",
        f"BATTLE_27 textured actors: {actor['battle27TexturedActorCount']}",
        f"HUD bottom-center meaningful rows: {hud['meaningfulBottomCenterCandidateCount']}",
        f"video bottom card chroma avg: {avg_card_ratio(card, 'brightSaturatedRatio')}",
        f"BATTLE_27 bottom card chroma: {card['battle27BottomCardColorRatio'].get('brightSaturatedRatio')}",
    ]
    for line in lines:
        draw.text((summary_x, y), line, fill=(235, 235, 235))
        y += 24
    sheet.save(CONTACT, quality=92)


def avg_card_ratio(card, key):
    values = [row.get(key, 0) for row in card.get("videoBottomCardColorRatios", [])]
    if not values:
        return None
    return round(sum(values) / len(values), 6)


def main():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    frames = extract_video_frames()
    battle27 = read_json(BATTLE27_JSON)
    flow = read_json(FLOW_JSON)
    skill_probe = read_json(SKILL_PROBE_JSON)
    hud_rows = read_csv(HUD_CSV)

    motion = analyze_video_motion(frames)
    card = analyze_bottom_card_region(frames)
    hud = analyze_hud_bottom_components(hud_rows)
    actor = analyze_actor_runtime(flow, battle27)
    skill = analyze_skill_probe(skill_probe)
    lua_hits = search_lua_evidence()
    make_contact_sheet(frames, motion, card, hud, actor)

    verdict = "battle28_evidence_collected_not_final"
    result = {
        "verdict": verdict,
        "referenceVideo": str(VIDEO),
        "videoClip": "clip05 around 486s",
        "battle27Capture": str(BATTLE27_CAPTURE),
        "contactSheet": str(CONTACT),
        "motionEvidence": {k: v for k, v in motion.items() if k != "pairs"},
        "bottomSkillCardEvidence": card,
        "hudBottomComponentEvidence": hud,
        "actorRuntimeEvidence": actor,
        "skillEffectEvidence": skill,
        "luaEvidenceHits": lua_hits,
        "failureAxes": {
            "actor_motion_not_proven": True,
            "bottom_skill_cards_not_restored": True,
            "missing_runtime_actor_bundles": actor["missingSlotCount"] > 0,
            "skill_effects_available_but_not_integrated_into_motion": skill["uniqueLoadableEffectPrefabCountTotal"] > 0,
            "map_id_conflict_still_open": battle27.get("runtimeFlowManifestMapId") != battle27.get("mapChosenByVideoEvidence"),
        },
        "nextBlocker": "BATTLE_29_BIND_UI_NORMALBATTLE_HERO_LIST_SKILL_CARDS_AND_TRACE_ACTOR_ANIMATION_RUNTIME",
    }
    REPORT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_28 Actor Motion And Skill-Card Evidence",
        "",
        "This is not a final restored battle screen. It uses the play video as a motion gate and separates actor motion, bottom skill-card UI, actor bundle coverage, and skill-effect availability.",
        "",
        "## Verdict",
        f"- verdict: `{verdict}`",
        "- reference video: `C:\\Users\\godho\\Downloads\\플레이.mp4` clip05 around 486s",
        f"- contact sheet: `{CONTACT}`",
        f"- BATTLE_27 capture: `{BATTLE27_CAPTURE}`",
        "",
        "## Video Motion Gate",
        f"- frame pair count: `{motion['pairCount']}`",
        f"- motion component count: `{motion['motionComponentCount']}`",
        f"- actor motion component count: `{motion['actorMotionComponentCount']}`",
        f"- bottom motion component count: `{motion['bottomMotionComponentCount']}`",
        "- interpretation: the source video has moving actors and changing bottom-card/skill visual state, so a still or static prefab placement is not enough.",
        "",
        "## Bottom Skill-Card Evidence",
        f"- video bottom-card bright saturated average: `{avg_card_ratio(card, 'brightSaturatedRatio')}`",
        f"- BATTLE_27 bottom-card bright saturated ratio: `{card['battle27BottomCardColorRatio'].get('brightSaturatedRatio')}`",
        f"- HUD bottom candidate rows: `{hud['bottomCandidateCount']}`",
        f"- active visible bottom candidate rows: `{hud['activeVisibleBottomCandidateCount']}`",
        f"- meaningful bottom-center rows: `{hud['meaningfulBottomCenterCandidateCount']}`",
        "- interpretation: the color ratio alone is weak because the warm floor also has high chroma; the stronger failure evidence is that meaningful bottom-center HUD rows are `0` while the video motion mask catches changing bottom card regions.",
        "",
        "## Actor Runtime Evidence",
        f"- runtime actor slots: `{actor['runtimeSlotCount']}`",
        f"- runtime prefab slots: `{actor['runtimePrefabSlotCount']}`",
        f"- missing actor slots: `{actor['missingSlotCount']}`",
        f"- BATTLE_27 instantiated actors: `{actor['battle27InstantiatedActorCount']}`",
        f"- BATTLE_27 textured actors: `{actor['battle27TexturedActorCount']}`",
        "- interpretation: BATTLE_27 improved from blank/magenta to textured actors, but actor motion/formation/scale still does not match the video.",
        "",
        "## Missing Actor Slots",
    ]
    for slot in actor["missingSlots"][:20]:
        md.append(f"- `{slot['side']}` wave `{slot['wave']}` slot `{slot['slot']}` heroDid `{slot['heroDid']}` model `{slot['modelId']}` reason `{slot['missingReason']}` skills `{slot['skillIds']}`")
    md += [
        "",
        "## Skill Effect Evidence",
        f"- skill count: `{skill['skillCount']}`",
        f"- skill found count: `{skill['skillFoundCount']}`",
        f"- timeline found count: `{skill['timelineFoundCount']}`",
        f"- loadable effect bundle probes: `{skill['loadableEffectBundleProbeCount']}`",
        f"- loadable effect prefab total with repeated bundles: `{skill['loadableEffectPrefabCountTotal']}`",
        f"- unique loadable effect bundles: `{skill['uniqueLoadableEffectBundleCount']}`",
        f"- unique loadable effect prefab total: `{skill['uniqueLoadableEffectPrefabCountTotal']}`",
        f"- missing effect bundle candidates: `{skill['missingBundleCandidateCount']}`",
        f"- unique missing effect bundle candidates: `{skill['uniqueMissingBundleCandidateCount']}`",
        "- interpretation: skill/effect assets exist for part of the fight, but they are not yet integrated into a runtime actor animation/motion replay.",
        "",
        "## Lua Evidence Samples",
    ]
    for hit in lua_hits[:20]:
        md.append(f"- `{hit['file']}:{hit['line']}` `{hit['text']}`")
    md += [
        "",
        "## Current Failure Axes",
        "- actor motion is not proven against the video sequence",
        "- bottom skill-card runtime UI is not restored",
        "- 9 of 12 runtime actor slots still lack loadable actor prefabs",
        "- skill effect prefabs are available but not attached to a video-matched runtime battle replay",
        "- runtime manifest mapId `11001` conflicts with video-matched `map_11003` evidence",
        "",
        "## Next Blocker",
        "- `BATTLE_29_BIND_UI_NORMALBATTLE_HERO_LIST_SKILL_CARDS_AND_TRACE_ACTOR_ANIMATION_RUNTIME`",
        "",
        "## Outputs",
        f"- result JSON: `{REPORT_JSON}`",
        f"- contact sheet: `{CONTACT}`",
        f"- reference sequence: `{REFERENCE_SEQUENCE}`",
    ]
    REPORT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps({
        "verdict": verdict,
        "contactSheet": str(CONTACT),
        "actorMotionComponentCount": motion["actorMotionComponentCount"],
        "bottomMotionComponentCount": motion["bottomMotionComponentCount"],
        "battle27TexturedActorCount": actor["battle27TexturedActorCount"],
        "meaningfulBottomCenterRows": hud["meaningfulBottomCenterCandidateCount"],
        "nextBlocker": result["nextBlocker"],
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
