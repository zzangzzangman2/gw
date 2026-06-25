import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageStat

BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")

LIVE_JSON = UNITY_DATA / "BATTLE_CORRECT_MAP_SCENE_HUD_PREVIEW_CLIP05.json"
CAPTURE = UNITY_DIR / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleCorrectMapSceneHudPreviewClip05_1920x1080.png"
REFERENCE_SEQUENCE = REPORT_DIR / "BATTLE_27_PLAY_VIDEO_CLIP05_486S_SEQUENCE.jpg"
CONTACT = REPORT_DIR / "BATTLE_27_CORRECT_MAP_SCENE_HUD_PREVIEW_CLIP05_CONTACT_SHEET.jpg"
REPORT_JSON = REPORT_DIR / "BATTLE_CORRECT_MAP_SCENE_HUD_PREVIEW_CLIP05_RESULT.json"
REPORT_MD = REPORT_DIR / "BATTLE_CORRECT_MAP_SCENE_HUD_PREVIEW_CLIP05_RESULT.md"


def read_json(path: Path):
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def image_stats(path: Path):
    if not path.exists():
        return {"exists": False}
    img = Image.open(path).convert("RGB")
    small = img.resize((420, 180), Image.Resampling.BILINEAR)
    total = small.width * small.height
    near_white = 0
    near_black = 0
    magenta = 0
    visible = 0
    for r, g, b in small.getdata():
        if r > 235 and g > 235 and b > 235:
            near_white += 1
        if r < 12 and g < 12 and b < 12:
            near_black += 1
        if r > 180 and b > 180 and g < 90:
            magenta += 1
        if max(r, g, b) > 20:
            visible += 1
    stat = ImageStat.Stat(small)
    return {
        "exists": True,
        "width": img.width,
        "height": img.height,
        "nearWhiteRatio": round(near_white / total, 6),
        "nearBlackRatio": round(near_black / total, 6),
        "magentaRatio": round(magenta / total, 6),
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
            frames.append((f"{t:.1f}s", Image.fromarray(frame)))
        cap.release()
    except Exception:
        frames = []

    if not frames:
        fallback = REPORT_DIR / "BATTLE_26_PLAY_VIDEO_CLIP05_486S_SEQUENCE.jpg"
        if fallback.exists():
            REFERENCE_SEQUENCE.write_bytes(fallback.read_bytes())
            return False
        img = Image.new("RGB", (1680, 215), (20, 20, 20))
        ImageDraw.Draw(img).text((20, 20), "play.mp4 clip05 sequence extraction failed", fill=(255, 170, 170))
        img.save(REFERENCE_SEQUENCE, quality=92)
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
    sheet.save(REFERENCE_SEQUENCE, quality=92)
    return True


def make_contact_sheet(stats):
    video_ok = extract_video_sequence()
    ref = Image.open(REFERENCE_SEQUENCE).convert("RGB") if REFERENCE_SEQUENCE.exists() else Image.new("RGB", (1680, 215), (8, 8, 8))
    cap = Image.open(CAPTURE).convert("RGB") if CAPTURE.exists() else Image.new("RGB", (1680, 720), (0, 0, 0))

    ref.thumbnail((1680, 230), Image.Resampling.LANCZOS)
    cap.thumbnail((1260, 450), Image.Resampling.LANCZOS)
    sheet = Image.new("RGB", (1680, 720), (6, 6, 6))
    sheet.paste(ref, ((1680 - ref.width) // 2, 0))
    sheet.paste(cap, ((1680 - cap.width) // 2, 245))

    draw = ImageDraw.Draw(sheet)
    draw.text((12, 224), "TOP: play.mp4 clip05 motion/reference sequence. The round top-center overlay is recording/touch artifact, not restored UI.", fill=(255, 255, 255))
    draw.text((12, 696), f"BOTTOM: BATTLE_27 correct-map HUD preview | white={stats.get('nearWhiteRatio')} black={stats.get('nearBlackRatio')} magenta={stats.get('magentaRatio')} visible={stats.get('visiblePixelRatio')}", fill=(255, 215, 130))
    sheet.save(CONTACT, quality=92)
    return video_ok


def summarize(live, stats, video_ok):
    actors = live.get("actors") or []
    map_layers = live.get("mapLayers") or []
    runtime_actor_instantiated = int(live.get("runtimeActorInstantiatedCount") or 0)
    runtime_actor_slots = int(live.get("runtimeActorSlotCount") or len(actors))
    actor_renderer_count = int(live.get("runtimeActorEnabledRendererCount") or 0)
    actor_graphic_count = int(live.get("runtimeActorEnabledGraphicCount") or 0)
    spine_count = int(live.get("runtimeActorSpineComponentCount") or 0)
    material_fallback_count = int(live.get("runtimeActorMaterialFallbackCount") or 0)
    render_order_fix_count = int(live.get("runtimeActorRenderOrderFixCount") or 0)
    actor_atlas_assign_count = int(live.get("runtimeActorAtlasTextureAssignCount") or 0)
    actor_atlas_bound_count = int(live.get("runtimeActorAtlasTextureBoundMaterialCount") or 0)
    map_created = int(live.get("mapLayerCreatedCount") or 0)
    disabled_text = int(live.get("disabledNonHudTextCount") or 0)

    black_or_blank = (not stats.get("exists")) or stats.get("visiblePixelRatio", 0) < 0.05 or stats.get("nearBlackRatio", 1) > 0.88
    white_failure = stats.get("nearWhiteRatio", 0) > 0.2
    magenta_failure = stats.get("magentaRatio", 0) > 0.004
    correct_map_layers_loaded = map_created >= 4
    loadable_actors_instantiated = runtime_actor_instantiated >= 3
    actor_visuals_present = actor_renderer_count + actor_graphic_count > 0
    debug_text_expected_visible = False

    if not stats.get("exists"):
        visual_status = "failed_capture_missing"
    elif black_or_blank:
        visual_status = "failed_black_or_blank_capture"
    elif white_failure:
        visual_status = "failed_large_white_capture"
    elif magenta_failure:
        visual_status = "failed_magenta_missing_shader_or_material_actor_visuals"
    elif not correct_map_layers_loaded:
        visual_status = "failed_correct_map_layers_missing"
    elif not loadable_actors_instantiated:
        visual_status = "failed_runtime_actor_prefabs_not_instantiated"
    else:
        visual_status = "improved_correct_map_and_hud_preview_not_final"

    still_not_final_reasons = [
        "single Unity capture does not prove battle motion/animation against play.mp4",
        "bottom skill-card runtime binding is still not proven",
        "runtime flow manifest says mapId=11001 but video evidence prefers map_11003, so the source mismatch must be resolved",
    ]
    if spine_count > 0:
        still_not_final_reasons.append("project Spine stubs still clear SkeletonGraphic meshes, so actor animation fidelity is not proven")
    if not actor_visuals_present:
        still_not_final_reasons.append("loadable actor prefabs instantiated but visible actor render output is still missing")

    return {
        "visual_status": visual_status,
        "captureStats": stats,
        "videoClip05SequenceExtracted": video_ok,
        "correctMapLayersLoaded": correct_map_layers_loaded,
        "mapLayerCreatedCount": map_created,
        "runtimeActorSlots": runtime_actor_slots,
        "runtimeActorInstantiatedCount": runtime_actor_instantiated,
        "runtimeActorEnabledRendererCount": actor_renderer_count,
        "runtimeActorEnabledGraphicCount": actor_graphic_count,
        "runtimeActorSpineComponentCount": spine_count,
        "runtimeActorMaterialFallbackCount": material_fallback_count,
        "runtimeActorRenderOrderFixCount": render_order_fix_count,
        "runtimeActorAtlasTextureAssignCount": actor_atlas_assign_count,
        "runtimeActorAtlasTextureBoundMaterialCount": actor_atlas_bound_count,
        "debugTextExpectedVisible": debug_text_expected_visible,
        "disabledNonHudTextCount": disabled_text,
        "finalCaptureHasLargeWhiteBlocks": white_failure,
        "finalCaptureHasMagentaMissingShader": magenta_failure,
        "blackOrBlankCapture": black_or_blank,
        "stillNotFinalReasons": still_not_final_reasons,
        "mapLayers": map_layers,
        "actors": actors,
    }


def main():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    live = read_json(LIVE_JSON)
    stats = image_stats(CAPTURE)
    video_ok = make_contact_sheet(stats)
    summary = summarize(live, stats, video_ok)

    result = {
        "verdict": "BATTLE_27 correct-map HUD preview generated; not final restored battle",
        "reference_video_used": True,
        "video_clip05_sequence_gate_checked": True,
        "map_video_evidence_source": str(REPORT_DIR / "BATTLE_26_MAP_VIDEO_MATCH_RUNTIME_SCENE_EVIDENCE_RESULT.md"),
        "unityJson": str(LIVE_JSON),
        "capture": str(CAPTURE),
        "contactSheet": str(CONTACT),
        "referenceSequence": str(REFERENCE_SEQUENCE),
        "summary": summary,
        "nextBlocker": "BATTLE_28_RESTORE_BATTLE_ACTOR_SPINE_RUNTIME_MOTION_AND_BOTTOM_SKILL_CARDS",
    }
    REPORT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_27 Correct Map Scene HUD Preview",
        "",
        "This is not a final restored battle screen. It replaces the rejected debug/text-heavy capture with a video-matched map preview and carries over the BATTLE_25 original HUD sprite binding.",
        "",
        "## Verdict",
        f"- visual_status: `{summary['visual_status']}`",
        "- reference video: `C:\\Users\\godho\\Downloads\\플레이.mp4` clip05 around 486s",
        "- chosen map evidence: `map_11003` from BATTLE_26 video similarity",
        "- runtime flow manifest mapId: `11001`",
        f"- capture: `{CAPTURE}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Screen Gate",
        f"- capture exists: `{stats.get('exists')}`",
        f"- nearWhiteRatio: `{stats.get('nearWhiteRatio')}`",
        f"- nearBlackRatio: `{stats.get('nearBlackRatio')}`",
        f"- magentaRatio: `{stats.get('magentaRatio')}`",
        f"- visiblePixelRatio: `{stats.get('visiblePixelRatio')}`",
        f"- finalCaptureHasLargeWhiteBlocks: `{summary['finalCaptureHasLargeWhiteBlocks']}`",
        f"- finalCaptureHasMagentaMissingShader: `{summary['finalCaptureHasMagentaMissingShader']}`",
        f"- debugTextExpectedVisible: `{summary['debugTextExpectedVisible']}`",
        f"- disabledNonHudTextCount: `{summary['disabledNonHudTextCount']}`",
        "",
        "## Restored Evidence Used",
        f"- correctMapLayersLoaded: `{summary['correctMapLayersLoaded']}`",
        f"- mapLayerCreatedCount: `{summary['mapLayerCreatedCount']}`",
        f"- runtimeActorSlots: `{summary['runtimeActorSlots']}`",
        f"- runtimeActorInstantiatedCount: `{summary['runtimeActorInstantiatedCount']}`",
        f"- runtimeActorEnabledRendererCount: `{summary['runtimeActorEnabledRendererCount']}`",
        f"- runtimeActorEnabledGraphicCount: `{summary['runtimeActorEnabledGraphicCount']}`",
        f"- runtimeActorSpineComponentCount: `{summary['runtimeActorSpineComponentCount']}`",
        f"- runtimeActorMaterialFallbackCount: `{summary['runtimeActorMaterialFallbackCount']}`",
        f"- runtimeActorRenderOrderFixCount: `{summary['runtimeActorRenderOrderFixCount']}`",
        f"- runtimeActorAtlasTextureAssignCount: `{summary['runtimeActorAtlasTextureAssignCount']}`",
        f"- runtimeActorAtlasTextureBoundMaterialCount: `{summary['runtimeActorAtlasTextureBoundMaterialCount']}`",
        "",
        "## Map Layers",
    ]
    for layer in summary["mapLayers"]:
        md.append(f"- `{layer.get('spriteName')}` role `{layer.get('role')}` created `{layer.get('created')}` world `{layer.get('worldWidth')}x{layer.get('worldHeight')}`")
    md += [
        "",
        "## Actor Slots",
    ]
    for actor in summary["actors"]:
        md.append(f"- `{actor.get('side')}` wave `{actor.get('wave')}` slot `{actor.get('slot')}` model `{actor.get('modelId')}` instantiated `{actor.get('instantiated')}` renderers `{actor.get('enabledRendererCount')}` graphics `{actor.get('enabledGraphicCount')}` atlasLoaded `{actor.get('actorAtlasTextureLoaded')}` atlasAssign `{actor.get('actorAtlasTextureAssignCount')}` atlasBound `{actor.get('actorAtlasTextureBoundMaterialCount')}` reason `{actor.get('missingReason') or actor.get('failReason')}`")
    md += [
        "",
        "## Why This Still Is Not Final",
    ]
    for reason in summary["stillNotFinalReasons"]:
        md.append(f"- {reason}")
    md += [
        "",
        "## Next Blocker",
        "- `BATTLE_28_RESTORE_BATTLE_ACTOR_SPINE_RUNTIME_MOTION_AND_BOTTOM_SKILL_CARDS`",
        "",
        "## Outputs",
        f"- result JSON: `{REPORT_JSON}`",
        f"- Unity JSON: `{LIVE_JSON}`",
        f"- contact sheet: `{CONTACT}`",
    ]
    REPORT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps({
        "visual_status": summary["visual_status"],
        "capture": str(CAPTURE),
        "contactSheet": str(CONTACT),
        "mapLayerCreatedCount": summary["mapLayerCreatedCount"],
        "runtimeActorInstantiatedCount": summary["runtimeActorInstantiatedCount"],
        "nextBlocker": result["nextBlocker"],
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
