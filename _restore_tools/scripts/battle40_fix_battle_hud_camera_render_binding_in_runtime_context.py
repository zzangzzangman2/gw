import argparse
import csv
import json
import math
from pathlib import Path

import cv2
import numpy as np
from PIL import Image, ImageDraw

BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")

UNITY_JSON = UNITY_DATA / "BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_UNITY.json"
COMPONENTS_CSV = UNITY_DATA / "BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_COMPONENTS.csv"
CANVAS_CSV = UNITY_DATA / "BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_CANVAS_DIFF.csv"
ACTOR_BOUNDS_CSV = UNITY_DATA / "BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_ACTOR_BOUNDS.csv"
B39_JSON = REPORT_DIR / "BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_RESULT.json"
B29_JSON = REPORT_DIR / "BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05_RESULT.json"
B29_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleHeroListSkillCardBindClip05_1920x1080.png"
B40_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle40HudCameraRenderBindingRuntimeContext_1920x1080.png"
B40_SEQUENCE_DIR = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "battle40_sequence"

OUT_MD = REPORT_DIR / "BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_RESULT.json"
UNITY_OUT_JSON = UNITY_DATA / "BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT.json"
OUT_CSV = UNITY_DATA / "BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_COMPARISON.csv"
CONTACT = REPORT_DIR / "BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_CONTACT_SHEET.jpg"
VIDEO_SEQUENCE = REPORT_DIR / "BATTLE_40_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg"
UNITY_LOG = REPORT_DIR / "BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT.log"


def read_json(path: Path, fallback):
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def count_cmds(path: Path):
    return len(list(path.glob("*.cmd"))) if path.exists() else 0


def extract_video_frames():
    times = [485.0, 485.4, 485.8, 486.2, 486.6, 487.0]
    cap = cv2.VideoCapture(str(VIDEO))
    frames = []
    for t in times:
        cap.set(cv2.CAP_PROP_POS_MSEC, t * 1000)
        ok, frame = cap.read()
        if ok:
            frames.append({"t": t, "bgr": frame})
    cap.release()
    return frames


def load_runtime_frames():
    frames = []
    for i in range(6):
        path = B40_SEQUENCE_DIR / f"Battle40RuntimeContext_{i:02d}_1920x1080.png"
        img = cv2.imread(str(path))
        if img is not None:
            frames.append({"t": 485.0 + i * 0.4, "bgr": img, "path": str(path)})
    return frames


def union_box(boxes):
    if not boxes:
        return None
    x1 = min(b[0] for b in boxes)
    y1 = min(b[1] for b in boxes)
    x2 = max(b[0] + b[2] for b in boxes)
    y2 = max(b[1] + b[3] for b in boxes)
    return (x1, y1, x2 - x1, y2 - y1)


def norm_box(box, w, h):
    x, y, bw, bh = box
    return {
        "x": round(x / w, 6),
        "y": round(y / h, 6),
        "w": round(bw / w, 6),
        "h": round(bh / h, 6),
        "cx": round((x + bw / 2) / w, 6),
        "cy": round((y + bh / 2) / h, 6),
    }


def detect_video_motion_boxes(frames):
    all_actor = []
    per_pair = []
    for a, b in zip(frames, frames[1:]):
        prev = cv2.cvtColor(a["bgr"], cv2.COLOR_BGR2GRAY)
        curr = cv2.cvtColor(b["bgr"], cv2.COLOR_BGR2GRAY)
        diff = cv2.absdiff(prev, curr)
        _, mask = cv2.threshold(diff, 20, 255, cv2.THRESH_BINARY)
        mask = cv2.dilate(mask, np.ones((5, 5), np.uint8), iterations=2)
        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        h, w = mask.shape
        boxes = []
        for c in contours:
            x, y, bw, bh = cv2.boundingRect(c)
            area = bw * bh
            cx = (x + bw / 2) / w
            cy = (y + bh / 2) / h
            if area >= 180 and 0.14 <= cy <= 0.75 and 0.03 <= cx <= 0.98:
                box = (x, y, bw, bh)
                boxes.append(box)
                all_actor.append(box)
        per_pair.append({"pair": f"{a['t']:.1f}-{b['t']:.1f}", "actorBoxes": boxes})
    return all_actor, per_pair


def parse_screen_rect(value):
    if not value:
        return None
    try:
        parts = [float(p) for p in value.split("/")]
        if len(parts) != 4:
            return None
        x1, y1, x2, y2 = parts
        x1 = max(0, min(1920, x1))
        x2 = max(0, min(1920, x2))
        y1 = max(0, min(1080, y1))
        y2 = max(0, min(1080, y2))
        left = min(x1, x2)
        right = max(x1, x2)
        top = 1080 - max(y1, y2)
        bottom = 1080 - min(y1, y2)
        w = right - left
        h = bottom - top
        if w <= 0 or h <= 0:
            return None
        return (int(left), int(top), int(w), int(h))
    except Exception:
        return None


def actor_boxes_from_csv(rows):
    boxes = []
    per_frame = []
    by_frame = {}
    for row in rows:
        try:
            frame = int(row.get("frame") or 0)
        except Exception:
            frame = 0
        box = parse_screen_rect(row.get("screenRect", ""))
        if box:
            boxes.append(box)
            by_frame.setdefault(frame, []).append(box)
    for i in range(6):
        per_frame.append({"frame": i, "actorBoxes": by_frame.get(i, [])})
    return boxes, per_frame


def compare_boxes(ref_boxes, runtime_boxes, size=(1920, 1080)):
    ref = union_box(ref_boxes)
    run = union_box(runtime_boxes)
    if not ref or not run:
        return {"hasReference": bool(ref), "hasRuntime": bool(run)}
    rn = norm_box(ref, *size)
    un = norm_box(run, *size)
    center = math.sqrt((rn["cx"] - un["cx"]) ** 2 + (rn["cy"] - un["cy"]) ** 2)
    ref_area = rn["w"] * rn["h"]
    run_area = un["w"] * un["h"]
    return {
        "hasReference": True,
        "hasRuntime": True,
        "referenceUnionNorm": rn,
        "runtimeUnionNorm": un,
        "centerDistanceNorm": round(center, 6),
        "runtimeToReferenceAreaRatio": round(run_area / ref_area, 6) if ref_area else None,
    }


def hud_visibility_metrics(candidate_path: Path, reference_path: Path):
    cand = cv2.imread(str(candidate_path))
    ref = cv2.imread(str(reference_path))
    if cand is None or ref is None:
        return {"cameraVisibleBattleHud": False, "reason": "candidate_or_reference_capture_missing"}
    zones = {
        "topHpVs": (slice(0, 260), slice(300, 1620)),
        "bottomCards": (slice(650, 930), slice(560, 1360)),
        "rightControls": (slice(180, 910), slice(1600, 1910)),
    }
    out = {}
    visible_votes = 0
    for name, sl in zones.items():
        ref_zone = ref[sl]
        cand_zone = cand[sl]
        diff = float(np.mean(np.abs(ref_zone.astype(np.float32) - cand_zone.astype(np.float32))) / 255.0)
        try:
            corr = float(np.corrcoef(ref_zone.reshape(-1).astype(float), cand_zone.reshape(-1).astype(float))[0, 1])
        except Exception:
            corr = 0.0
        zone_visible = corr >= 0.55 and diff <= 0.14
        if zone_visible:
            visible_votes += 1
        out[name] = {
            "meanAbsDiffVsBattle29HudReference": round(diff, 6),
            "pixelCorrelationVsBattle29HudReference": round(corr, 6),
            "zoneVisibleByReferenceSimilarity": zone_visible,
        }
    out["cameraVisibleBattleHud"] = visible_votes >= 2 and out["bottomCards"]["zoneVisibleByReferenceSimilarity"]
    out["visibleHudZoneVoteCount"] = visible_votes
    out["reason"] = "HUD/card regions are camera-visible by BATTLE29 reference similarity." if out["cameraVisibleBattleHud"] else "HUD/card regions still do not match BATTLE29/clip05 reference visibility."
    return out


def capture_metrics(path: Path):
    img = cv2.imread(str(path))
    if img is None:
        return {"captureExists": False}
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    magenta = cv2.inRange(hsv, (140, 80, 80), (175, 255, 255))
    total = img.shape[0] * img.shape[1]
    return {
        "captureExists": True,
        "width": int(img.shape[1]),
        "height": int(img.shape[0]),
        "magentaPixelRatio": round(float(np.count_nonzero(magenta)) / total, 6),
        "nonBlackPixelRatio": round(float(np.count_nonzero(np.any(img > 20, axis=2))) / total, 6),
    }


def canvas_summary(rows):
    after = [r for r in rows if r.get("phase") == "after"]
    before = [r for r in rows if r.get("phase") == "before"]
    return {
        "beforeCanvasRows": len(before),
        "afterCanvasRows": len(after),
        "afterScreenSpaceCamera": sum(1 for r in after if r.get("renderMode") == "ScreenSpaceCamera"),
        "afterScreenSpaceOverlay": sum(1 for r in after if r.get("renderMode") == "ScreenSpaceOverlay"),
        "afterWorldCameraMatchRows": sum(1 for r in after if str(r.get("worldCameraMatchesCapture", "")).lower() == "true"),
        "fixRows": sum(1 for r in rows if r.get("fixReason")),
    }


def component_summary(rows):
    active = [r for r in rows if str(r.get("activeInHierarchy", "")).lower() == "true" and str(r.get("enabled", "")).lower() == "true"]
    images = [r for r in rows if r.get("componentType") == "Image"]
    return {
        "rowCount": len(rows),
        "activeGraphicCount": len(active),
        "imageRows": len(images),
        "imageWithSpriteRows": sum(1 for r in images if r.get("spriteName")),
        "imageWithTextureRows": sum(1 for r in images if r.get("textureName")),
        "textRows": sum(1 for r in rows if r.get("componentType") in ("Text", "TextMeshProUGUI", "TMP_Text")),
        "buttonCandidateByPathRows": sum(1 for r in rows if "btn" in r.get("path", "").lower()),
    }


def draw_boxes(panel, boxes, color, label):
    draw = ImageDraw.Draw(panel)
    for i, (x, y, w, h) in enumerate(boxes[:18], start=1):
        draw.rectangle((x, y, x + w, y + h), outline=color, width=3)
        draw.text((x + 2, max(0, y - 16)), f"{label}{i}", fill=color)


def panel_from_bgr(frame, title, boxes=None, size=(320, 180)):
    img = Image.fromarray(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
    img.thumbnail((size[0], size[1] - 30), Image.Resampling.LANCZOS)
    panel = Image.new("RGB", size, (8, 8, 8))
    xoff = (size[0] - img.width) // 2
    panel.paste(img, (xoff, 0))
    if boxes:
        sx = img.width / frame.shape[1]
        sy = img.height / frame.shape[0]
        scaled = [(int(x * sx) + xoff, int(y * sy), int(w * sx), int(h * sy)) for x, y, w, h in boxes]
        draw_boxes(panel, scaled, (255, 80, 80), "A")
    ImageDraw.Draw(panel).text((8, size[1] - 22), title, fill=(235, 235, 235))
    return panel


def make_contact(video_frames, video_pairs, runtime_frames, runtime_pairs, b29_capture, summary):
    top_panels = []
    for i, frame in enumerate(video_frames):
        boxes = video_pairs[min(i, len(video_pairs) - 1)]["actorBoxes"] if video_pairs else []
        top_panels.append(panel_from_bgr(frame["bgr"], f"video {frame['t']:.1f}s", boxes, (320, 180)))
    top = Image.new("RGB", (320 * max(1, len(top_panels)), 180), (0, 0, 0))
    for i, p in enumerate(top_panels):
        top.paste(p, (i * 320, 0))
    top.save(VIDEO_SEQUENCE, quality=92)

    run_panels = []
    for i, frame in enumerate(runtime_frames):
        boxes = runtime_pairs[i]["actorBoxes"] if i < len(runtime_pairs) else []
        run_panels.append(panel_from_bgr(frame["bgr"], f"B40 runtime {i}", boxes, (320, 180)))
    runtime_row = Image.new("RGB", (320 * max(1, len(run_panels)), 180), (0, 0, 0))
    for i, p in enumerate(run_panels):
        runtime_row.paste(p, (i * 320, 0))

    b29_panel = Image.new("RGB", (960, 500), (8, 8, 8))
    b29 = cv2.imread(str(b29_capture))
    if b29 is not None:
        b29_panel.paste(panel_from_bgr(b29, "BATTLE29 HUD/card reference", None, (960, 500)), (0, 0))

    text_panel = Image.new("RGB", (960, 500), (8, 8, 8))
    td = ImageDraw.Draw(text_panel)
    lines = [
        "BATTLE_40 summary",
        f"verdict: {summary['verdict']}",
        f"visual_status: {summary['visual_status']}",
        f"camera-visible HUD: {summary['cameraVisibleBattleHud']}",
        f"HUD zone votes: {summary['hudVisibilityMetrics'].get('visibleHudZoneVoteCount')}",
        f"canvas fixes: {summary['unitySummary'].get('canvasFixCount')}",
        f"sprite rebinds: {summary['unitySummary'].get('extractedSpriteBindCount')}",
        f"actor center gap: {summary['actorLayoutGap'].get('centerDistanceNorm')}",
        f"actor area ratio: {summary['actorLayoutGap'].get('runtimeToReferenceAreaRatio')}",
        f"next blocker: {summary['nextBlocker']}",
    ]
    y = 20
    for line in lines:
        td.text((20, y), line, fill=(235, 235, 235))
        y += 30

    sheet = Image.new("RGB", (1920, 180 + 180 + 500), (0, 0, 0))
    sheet.paste(top, (0, 0))
    sheet.paste(runtime_row, (0, 180))
    sheet.paste(b29_panel, (0, 360))
    sheet.paste(text_panel, (960, 360))
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT, quality=92)


def write_comparison_csv(result):
    rows = [
        {"metric": "camera_visible_battle_hud", "value": result["cameraVisibleBattleHud"], "note": "BATTLE29 reference-region similarity"},
        {"metric": "hud_zone_vote_count", "value": result["hudVisibilityMetrics"].get("visibleHudZoneVoteCount"), "note": "top/bottom/right visibility vote"},
        {"metric": "canvas_fix_count", "value": result["unitySummary"].get("canvasFixCount"), "note": "ScreenSpace/camera binding fixes recorded"},
        {"metric": "extracted_sprite_bind_count", "value": result["unitySummary"].get("extractedSpriteBindCount"), "note": "evidence sprite/texture rebinds"},
        {"metric": "actor_center_gap_norm", "value": result["actorLayoutGap"].get("centerDistanceNorm"), "note": "video union vs runtime union"},
        {"metric": "actor_area_ratio_runtime_to_reference", "value": result["actorLayoutGap"].get("runtimeToReferenceAreaRatio"), "note": "scale/layout gap"},
    ]
    with OUT_CSV.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=["metric", "value", "note"])
        writer.writeheader()
        writer.writerows(rows)


def verify(unity_exit_code: int):
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    UNITY_DATA.mkdir(parents=True, exist_ok=True)
    video_frames = extract_video_frames()
    runtime_frames = load_runtime_frames()
    unity = read_json(UNITY_JSON, {})
    b39 = read_json(B39_JSON, {})
    b29 = read_json(B29_JSON, {})
    component_rows = read_csv(COMPONENTS_CSV)
    canvas_rows = read_csv(CANVAS_CSV)
    actor_rows = read_csv(ACTOR_BOUNDS_CSV)
    ref_actor, video_pairs = detect_video_motion_boxes(video_frames)
    runtime_actor, runtime_pairs = actor_boxes_from_csv(actor_rows)
    layout_gap = compare_boxes(ref_actor, runtime_actor)
    hud_visibility = hud_visibility_metrics(B40_CAPTURE, B29_CAPTURE)
    camera_visible_hud = bool(hud_visibility.get("cameraVisibleBattleHud"))
    cap_metrics = capture_metrics(B40_CAPTURE)
    cs = canvas_summary(canvas_rows)
    gs = component_summary(component_rows)

    if unity_exit_code != 0:
        visual_status = "failed_unity_batch_or_compile"
        blocker = "Unity batch/probe did not complete."
        next_blocker = "BATTLE_41_FIX_BATTLE40_COMPILE_OR_BATCH_ERROR"
    elif gs.get("activeGraphicCount", 0) == 0 and cs.get("afterScreenSpaceCamera", 0) > 0:
        visual_status = "failed_hud_graphic_components_missing_after_scene_reload"
        blocker = "HUD canvases are already ScreenSpaceCamera/worldCamera-bound, but the reopened BATTLE39/BATTLE40 scene has zero resolved active Graphic/Image rows; the issue is runtime UI component/sprite texture persistence, not only camera render binding."
        next_blocker = "BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE"
    elif not camera_visible_hud:
        visual_status = "failed_hud_context_still_not_camera_visible"
        blocker = "Canvas/camera binding probe ran, but clip05/BATTLE29 HUD/card regions are still not camera-visible enough."
        next_blocker = "BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE"
    elif layout_gap.get("centerDistanceNorm") is None or layout_gap.get("centerDistanceNorm", 1) > 0.12:
        visual_status = "failed_actor_placement_still_not_clip05_runtime_verified_after_hud_binding"
        blocker = "HUD/card regions are camera-visible, but actor placement/scale/camera remains far from clip05 and is not original runtime verified."
        next_blocker = "BATTLE_41_TRACE_ORIGINAL_FORMATION_CAMERA_RUNTIME_BINDING_FOR_ACTOR_CONTEXT"
    else:
        visual_status = "failed_clip05_timing_not_verified"
        blocker = "HUD visibility improved and actor layout is closer, but clip05 motion/timing state is still not verified."
        next_blocker = "BATTLE_41_MATCH_ACTOR_TIMING_SKILL_STATE_TO_CLIP05"

    result = {
        "verdict": "clip05 actor motion/layout/timing + map/HUD context not reproduced",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "reference_video_used": True,
        "videoTimeRangeSeconds": "485.0-487.0",
        "unityExitCode": unity_exit_code,
        "cameraVisibleBattleHud": camera_visible_hud,
        "hudVisibilityMetrics": hud_visibility,
        "captureMetrics": cap_metrics,
        "actorMotionLayoutTimingMapHudContextReplayed": False,
        "actorLayoutGap": layout_gap,
        "referenceActorBoxCount": len(ref_actor),
        "runtimeActorBoxCount": len(runtime_actor),
        "unitySummary": {
            "canvasFixCount": unity.get("canvasFixCount"),
            "extractedSpriteBindCount": unity.get("extractedSpriteBindCount"),
            "beforeCanvasCount": unity.get("beforeCanvasCount"),
            "afterCanvasCount": unity.get("afterCanvasCount"),
            "beforeImageWithTextureCount": unity.get("beforeImageWithTextureCount"),
            "afterImageWithTextureCount": unity.get("afterImageWithTextureCount"),
            "afterActiveGraphicCount": unity.get("afterActiveGraphicCount"),
            "captureExists": unity.get("captureExists"),
        },
        "canvasSummary": cs,
        "componentSummary": gs,
        "battle39Carryover": {
            "visual_status": b39.get("visual_status"),
            "cameraVisibleBattleHud": b39.get("cameraVisibleBattleHud"),
            "actorLayoutGap": b39.get("actorLayoutGap"),
        },
        "battle29Context": {
            "capture": str(B29_CAPTURE),
            "mapLayerCreatedCount": b29.get("battle27MapSummary", {}).get("mapLayerCreatedCount"),
            "boundHeroCardCount": b29.get("unityLiveSummary", {}).get("boundHeroCardCount"),
            "failureAxes": b29.get("failureAxes", {}),
        },
        "blocker": blocker,
        "nextBlocker": next_blocker,
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "unityDataJson": str(UNITY_OUT_JSON),
            "unityProbeJson": str(UNITY_JSON),
            "componentsCsv": str(COMPONENTS_CSV),
            "canvasCsv": str(CANVAS_CSV),
            "actorBoundsCsv": str(ACTOR_BOUNDS_CSV),
            "comparisonCsv": str(OUT_CSV),
            "capture": str(B40_CAPTURE),
            "contactSheet": str(CONTACT),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "Final capture has no debug/path/evidence labels from BATTLE40.",
            "Canvas fixes are recorded with old/new renderMode/worldCamera/planeDistance values.",
            "No fake HUD or coordinate-only actor placement success claim is made.",
        ],
    }
    make_contact(video_frames, video_pairs, runtime_frames, runtime_pairs, B29_CAPTURE, result)
    write_comparison_csv(result)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    UNITY_OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_40 Fix Battle HUD Camera Render Binding In Runtime Context Result",
        "",
        "**원본 clip05 actor motion/layout/timing + map/HUD context는 아직 재현 안 됐다.** BATTLE40는 HUD Canvas가 이미 ScreenSpaceCamera/worldCamera에 묶여 있음을 확인했지만, 재오픈된 runtime context에서 resolved Graphic/Image가 0이라 최종 capture에 HUD/card가 렌더되지 않는다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- reference video used: `True` (`플레이.mp4` 485.0-487.0s)",
        f"- camera-visible HUD/cards: `{camera_visible_hud}`",
        f"- actor motion/layout/timing + map/HUD context replayed: `False`",
        f"- Unity exit code: `{unity_exit_code}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## HUD Camera Binding",
        f"- canvas fix count: `{unity.get('canvasFixCount')}`",
        f"- extracted sprite/texture rebind count: `{unity.get('extractedSpriteBindCount')}`",
        f"- resolved active Graphic rows: `{gs.get('activeGraphicCount')}`",
        f"- resolved Image rows: `{gs.get('imageRows')}`",
        f"- after ScreenSpaceCamera canvas rows: `{cs.get('afterScreenSpaceCamera')}`",
        f"- before/after Image texture rows: `{unity.get('beforeImageWithTextureCount')}` / `{unity.get('afterImageWithTextureCount')}`",
        f"- after active graphic count: `{unity.get('afterActiveGraphicCount')}`",
        f"- HUD visibility reason: `{hud_visibility.get('reason')}`",
        f"- top/bottom/right zone votes: `{hud_visibility.get('visibleHudZoneVoteCount')}`",
        "",
        "## Actor Context Gate",
        f"- reference/runtime actor boxes: `{len(ref_actor)}` / `{len(runtime_actor)}`",
        f"- actor center gap norm: `{layout_gap.get('centerDistanceNorm')}`",
        f"- runtime/reference actor area ratio: `{layout_gap.get('runtimeToReferenceAreaRatio')}`",
        "- actor placement remains candidate unless original formation/camera runtime binding is traced.",
        "",
        "## Diagnostics",
        f"- canvas CSV: `{CANVAS_CSV}`",
        f"- components CSV: `{COMPONENTS_CSV}`",
        f"- actor bounds CSV: `{ACTOR_BOUNDS_CSV}`",
        f"- capture: `{B40_CAPTURE}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Blocker",
        f"- {blocker}",
        "",
        "## Command Policy Check",
        f"- root CMD count: `{result['rootCmdCount']}`",
        f"- `_restore_tools` direct CMD count: `{result['restoreToolsDirectCmdCount']}`",
        "",
        "## Next Blocker",
        f"- `{next_blocker}`",
    ]
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps({
        "visual_status": visual_status,
        "cameraVisibleBattleHud": camera_visible_hud,
        "canvasFixCount": unity.get("canvasFixCount"),
        "extractedSpriteBindCount": unity.get("extractedSpriteBindCount"),
        "actorCenterGapNorm": layout_gap.get("centerDistanceNorm"),
        "actorAreaRatio": layout_gap.get("runtimeToReferenceAreaRatio"),
        "nextBlocker": next_blocker,
        "rootCmdCount": result["rootCmdCount"],
        "restoreToolsDirectCmdCount": result["restoreToolsDirectCmdCount"],
    }, ensure_ascii=False, indent=2))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("mode", choices=["verify"])
    parser.add_argument("--unity-exit", type=int, default=0)
    args = parser.parse_args()
    verify(args.unity_exit)


if __name__ == "__main__":
    main()
