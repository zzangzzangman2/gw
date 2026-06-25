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

UNITY_JSON = UNITY_DATA / "BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_UNITY.json"
ACTOR_BOUNDS_CSV = UNITY_DATA / "BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_ACTOR_BOUNDS.csv"
B38_JSON = REPORT_DIR / "BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_RESULT.json"
B29_JSON = REPORT_DIR / "BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05_RESULT.json"
B29_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleHeroListSkillCardBindClip05_1920x1080.png"
B39_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle39RuntimeActorsMap11003HudContext_1920x1080.png"
B39_SEQUENCE_DIR = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "battle39_sequence"

OUT_MD = REPORT_DIR / "BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_RESULT.json"
UNITY_OUT_JSON = UNITY_DATA / "BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE.json"
OUT_CSV = UNITY_DATA / "BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_COMPARISON.csv"
CONTACT = REPORT_DIR / "BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_CONTACT_SHEET.jpg"
VIDEO_SEQUENCE = REPORT_DIR / "BATTLE_39_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg"
UNITY_LOG = REPORT_DIR / "BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE.log"

LUA_ROOT = BASE / "girlswar_merged_extracted" / "decoded" / "xlua_battle"
EVIDENCE_KEYWORDS = [
    "UI_NormalBattle", "NormalBattle", "ProcedureNormalBattle", "OnBattleUILoadComplete",
    "SetLeftInfo", "SetRightInfo", "OnShowHeadBar", "HeroCtrl", "BattleTeam",
    "formation", "Formation", "ResortTeamFormation", "LoadPlayerHeros",
    "LoadEnemyPlayerHeros", "spineboyScale", "GetSpineBoyLogicScale", "RefreshSpineBoyScale",
    "SetSpineAnimation", "SetTimelineEffect", "BattleCamera", "Camera", "MapId",
]


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
        path = B39_SEQUENCE_DIR / f"Battle39RuntimeContext_{i:02d}_1920x1080.png"
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
        # Unity screen y has origin bottom-left; convert to image top-left.
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


def image_region_metrics(img):
    h, w = img.shape[:2]
    top = img[: int(h * 0.18), :, :]
    bottom = img[int(h * 0.70):, :, :]
    right = img[:, int(w * 0.82):, :]

    def non_dark(region):
        return round(float(np.count_nonzero(np.any(region > 32, axis=2))) / (region.shape[0] * region.shape[1]), 6)

    return {
        "topNonDarkRatio": non_dark(top),
        "bottomNonDarkRatio": non_dark(bottom),
        "rightNonDarkRatio": non_dark(right),
    }


def capture_metrics(path: Path):
    img = cv2.imread(str(path))
    if img is None:
        return {"captureExists": False}
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    magenta = cv2.inRange(hsv, (140, 80, 80), (175, 255, 255))
    non_black = np.any(img > 20, axis=2)
    total = img.shape[0] * img.shape[1]
    metrics = {
        "captureExists": True,
        "width": int(img.shape[1]),
        "height": int(img.shape[0]),
        "magentaPixelRatio": round(float(np.count_nonzero(magenta)) / total, 6),
        "nonBlackPixelRatio": round(float(np.count_nonzero(non_black)) / total, 6),
    }
    metrics.update(image_region_metrics(img))
    return metrics


def hud_visibility_metrics(candidate_path: Path, reference_path: Path):
    cand = cv2.imread(str(candidate_path))
    ref = cv2.imread(str(reference_path))
    if cand is None or ref is None:
        return {
            "cameraVisibleBattleHud": False,
            "reason": "candidate_or_reference_capture_missing",
        }
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
        zone_visible = corr >= 0.55 and diff <= 0.12
        if zone_visible:
            visible_votes += 1
        out[name] = {
            "meanAbsDiffVsBattle29HudReference": round(diff, 6),
            "pixelCorrelationVsBattle29HudReference": round(corr, 6),
            "zoneVisibleByReferenceSimilarity": zone_visible,
        }
    out["cameraVisibleBattleHud"] = visible_votes >= 2 and out["bottomCards"]["zoneVisibleByReferenceSimilarity"]
    out["visibleHudZoneVoteCount"] = visible_votes
    out["reason"] = (
        "BATTLE39 capture has partial HUD/card similarity to BATTLE29 context."
        if out["cameraVisibleBattleHud"]
        else "BATTLE39 capture does not match BATTLE29/clip05 HUD/card visible regions; scene object presence is not camera-visible HUD."
    )
    return out


def collect_evidence(limit=120):
    hits = []
    if not LUA_ROOT.exists():
        return hits
    for path in LUA_ROOT.rglob("*.lua"):
        try:
            lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
        except Exception:
            continue
        for i, line in enumerate(lines, start=1):
            if any(k in line for k in EVIDENCE_KEYWORDS):
                hits.append({"path": str(path.relative_to(BASE)), "line": i, "text": line.strip()[:260]})
                if len(hits) >= limit:
                    return hits
    return hits


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
        run_panels.append(panel_from_bgr(frame["bgr"], f"B39 context {i}", boxes, (320, 180)))
    runtime_row = Image.new("RGB", (320 * max(1, len(run_panels)), 180), (0, 0, 0))
    for i, p in enumerate(run_panels):
        runtime_row.paste(p, (i * 320, 0))

    b29_panel = Image.new("RGB", (960, 500), (8, 8, 8))
    b29 = cv2.imread(str(b29_capture))
    if b29 is not None:
        p = panel_from_bgr(b29, "BATTLE29 context source (map/HUD/cards)", None, (960, 500))
        b29_panel.paste(p, (0, 0))

    text_panel = Image.new("RGB", (960, 500), (8, 8, 8))
    td = ImageDraw.Draw(text_panel)
    lines = [
        "BATTLE_39 summary",
        f"verdict: {summary['verdict']}",
        f"visual_status: {summary['visual_status']}",
        f"runtime actor boxes: {summary['runtimeActorBoxCount']}",
        f"reference actor boxes: {summary['referenceActorBoxCount']}",
        f"actor center gap: {summary['actorLayoutGap'].get('centerDistanceNorm')}",
        f"actor area ratio: {summary['actorLayoutGap'].get('runtimeToReferenceAreaRatio')}",
        f"context map/HUD/cards: {summary['runtimeContext'].get('hasBattleMap')} / {summary['runtimeContext'].get('hasBattleHud')} / {summary['runtimeContext'].get('hasHeroCards')}",
        f"camera-visible HUD: {summary.get('cameraVisibleBattleHud')}",
        f"mesh changed actors: {summary['meshHashChangedActorCount']}/3",
        f"magenta ratio: {summary['captureMetrics'].get('magentaPixelRatio')}",
        f"placement status: {summary['runtimeContext'].get('actorPlacementEvidenceStatus')}",
        f"next blocker: {summary['nextBlocker']}",
    ]
    y = 20
    for line in lines:
        td.text((20, y), line, fill=(235, 235, 235))
        y += 29

    sheet = Image.new("RGB", (1920, 180 + 180 + 500), (0, 0, 0))
    sheet.paste(top, (0, 0))
    sheet.paste(runtime_row, (0, 180))
    sheet.paste(b29_panel, (0, 360))
    sheet.paste(text_panel, (960, 360))
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT, quality=92)


def write_comparison_csv(result):
    rows = [
        {"metric": "actor_center_gap_norm", "value": result["actorLayoutGap"].get("centerDistanceNorm"), "note": "video union vs BATTLE39 runtime-context union"},
        {"metric": "actor_area_ratio_runtime_to_reference", "value": result["actorLayoutGap"].get("runtimeToReferenceAreaRatio"), "note": "scale/layout gap"},
        {"metric": "runtime_has_battle_map", "value": result["runtimeContext"].get("hasBattleMap"), "note": "BATTLE29 context scene"},
        {"metric": "runtime_has_battle_hud", "value": result["runtimeContext"].get("hasBattleHud"), "note": "BATTLE29 context scene"},
        {"metric": "runtime_has_hero_cards", "value": result["runtimeContext"].get("hasHeroCards"), "note": "BATTLE29 bound cards"},
        {"metric": "camera_visible_battle_hud", "value": result.get("cameraVisibleBattleHud"), "note": "BATTLE29 HUD/card reference-region similarity, not object presence"},
        {"metric": "mesh_hash_changed_actor_count", "value": result["meshHashChangedActorCount"], "note": "runtime motion evidence"},
        {"metric": "magenta_pixel_ratio", "value": result["captureMetrics"].get("magentaPixelRatio"), "note": "shader/material visual blocker"},
        {"metric": "placement_original_runtime_verified", "value": result["placementOriginalRuntimeVerified"], "note": "must be true for final pass"},
    ]
    OUT_CSV.parent.mkdir(parents=True, exist_ok=True)
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
    b38 = read_json(B38_JSON, {})
    b29 = read_json(B29_JSON, {})
    bounds_rows = read_csv(ACTOR_BOUNDS_CSV)
    ref_actor, video_pairs = detect_video_motion_boxes(video_frames)
    runtime_actor, runtime_pairs = actor_boxes_from_csv(bounds_rows)
    if not runtime_actor and runtime_frames:
        # The CSV is the authoritative actor bounds dump; image fallback is intentionally avoided
        # here because map/HUD pixels can otherwise become actor false positives.
        runtime_pairs = [{"frame": i, "actorBoxes": []} for i in range(len(runtime_frames))]
    layout_gap = compare_boxes(ref_actor, runtime_actor)
    metrics = capture_metrics(B39_CAPTURE)
    hud_visibility = hud_visibility_metrics(B39_CAPTURE, B29_CAPTURE)
    evidence = collect_evidence()
    unity_summary = unity.get("summary", {})
    context = unity.get("context", {})
    has_map = bool(context.get("hasBattleMap"))
    has_hud = bool(context.get("hasBattleHud"))
    has_cards = bool(context.get("hasHeroCards"))
    camera_visible_battle_hud = bool(hud_visibility.get("cameraVisibleBattleHud"))
    placement_verified = False
    mesh_changed = int(unity_summary.get("meshHashChangedActorCount") or 0)
    actor_motion_layout_timing_context_replayed = False

    if unity_exit_code != 0:
        visual_status = "failed_unity_batch_or_compile"
        blocker = "Unity batch/probe did not complete, so map/HUD context attachment cannot be trusted."
        next_blocker = "BATTLE_40_FIX_BATTLE39_COMPILE_OR_BATCH_ERROR"
    elif not (has_map and has_hud):
        visual_status = "failed_map_hud_context_not_loaded"
        blocker = "BATTLE29 map/HUD context was not present in the BATTLE39 candidate scene."
        next_blocker = "BATTLE_40_REPAIR_BATTLE29_CONTEXT_SCENE_LOAD"
    elif not camera_visible_battle_hud:
        visual_status = "failed_hud_context_not_camera_visible_in_candidate_capture"
        blocker = "BATTLE29 HUD/card objects exist in the candidate scene, but final BATTLE39 capture does not show the clip05/BATTLE29 top/bottom/right HUD/card regions; this is a scene-object/camera-render visibility false positive."
        next_blocker = "BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT"
    elif len(runtime_actor) == 0:
        visual_status = "failed_runtime_actors_not_camera_visible_in_map_hud_context"
        blocker = "Runtime actor bounds were not visible through the BATTLE29 context camera."
        next_blocker = "BATTLE_40_FIX_RUNTIME_ACTOR_CAMERA_VISIBILITY_IN_MAP_CONTEXT"
    elif not placement_verified:
        visual_status = "failed_context_attach_candidate_not_original_runtime_verified"
        blocker = "Runtime actors are attached to the map/HUD candidate context, but positions come from BATTLE_RUNTIME_FLOW_MANIFEST/BATTLE29 inference and are not original runtime formation/camera verified for clip05 map_11003."
        next_blocker = "BATTLE_40_TRACE_ORIGINAL_FORMATION_CAMERA_RUNTIME_BINDING_FOR_ACTOR_CONTEXT"
    elif layout_gap.get("centerDistanceNorm") is None or layout_gap.get("centerDistanceNorm", 1) > 0.08:
        visual_status = "failed_actor_scale_camera_layout_gap"
        blocker = "Actor bounds differ from clip05 after context attachment."
        next_blocker = "BATTLE_40_TRACE_ORIGINAL_FORMATION_CAMERA_RUNTIME_BINDING_FOR_ACTOR_CONTEXT"
    elif mesh_changed < 3:
        visual_status = "failed_actor_runtime_motion_incomplete"
        blocker = "Not all actor meshes changed across the context sequence."
        next_blocker = "BATTLE_40_REPAIR_ACTOR_RUNTIME_SEQUENCE_ADVANCE_IN_CONTEXT"
    else:
        visual_status = "failed_clip05_timing_not_verified"
        blocker = "Context exists and actors move, but clip05 timing/skill state has not been verified."
        next_blocker = "BATTLE_40_MATCH_ACTOR_TIMING_SKILL_STATE_TO_CLIP05"

    runtime_context = {
        "hasBattleMap": has_map,
        "hasBattleHud": has_hud,
        "hasHeroCards": has_cards,
        "cameraVisibleBattleHud": camera_visible_battle_hud,
        "baseSceneOpened": bool(context.get("baseSceneOpened")),
        "disabledExistingBattle27ActorCount": int(context.get("disabledExistingBattle27ActorCount") or 0),
        "mapContextSource": context.get("mapContextSource"),
        "hudContextSource": context.get("hudContextSource"),
        "actorPlacementSource": context.get("actorPlacementSource"),
        "actorPlacementEvidenceStatus": "candidate_not_original_runtime_verified",
    }

    result = {
        "verdict": "clip05 actor motion/layout/timing + map/HUD context not reproduced",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "reference_video_used": True,
        "videoTimeRangeSeconds": "485.0-487.0",
        "referenceFrameCount": len(video_frames),
        "runtimeFrameCount": len(runtime_frames),
        "unityExitCode": unity_exit_code,
        "actorMotionLayoutTimingMapHudContextReplayed": actor_motion_layout_timing_context_replayed,
        "placementOriginalRuntimeVerified": placement_verified,
        "referenceActorBoxCount": len(ref_actor),
        "runtimeActorBoxCount": len(runtime_actor),
        "actorLayoutGap": layout_gap,
        "runtimeContext": runtime_context,
        "captureMetrics": metrics,
        "hudVisibilityMetrics": hud_visibility,
        "cameraVisibleBattleHud": camera_visible_battle_hud,
        "meshHashChangedActorCount": mesh_changed,
        "animationStateSetSucceededCount": int(unity_summary.get("animationStateSetSucceededCount") or 0),
        "shaderRebindAppliedCount": int(unity_summary.get("shaderRebindAppliedCount") or 0),
        "battle38Carryover": {
            "visual_status": b38.get("visual_status"),
            "actorLayoutGap": b38.get("actorLayoutGap"),
            "runtimeContext": b38.get("runtimeContext"),
        },
        "battle29Context": {
            "capture": str(B29_CAPTURE),
            "originalBattlemapBundleLoaded": b29.get("battle27MapSummary", {}).get("originalBattlemapBundleLoaded"),
            "mapLayerCreatedCount": b29.get("battle27MapSummary", {}).get("mapLayerCreatedCount"),
            "boundHeroCardCount": b29.get("unityLiveSummary", {}).get("boundHeroCardCount"),
            "failureAxes": b29.get("failureAxes", {}),
        },
        "unityProbe": unity,
        "actorBoundsRows": bounds_rows,
        "luaFormationCameraTimingEvidence": evidence,
        "blocker": blocker,
        "nextBlocker": next_blocker,
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "unityDataJson": str(UNITY_OUT_JSON),
            "unityProbeJson": str(UNITY_JSON),
            "actorBoundsCsv": str(ACTOR_BOUNDS_CSV),
            "comparisonCsv": str(OUT_CSV),
            "capture": str(B39_CAPTURE),
            "contactSheet": str(CONTACT),
            "videoSequence": str(VIDEO_SEQUENCE),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "Final capture has no debug/path/evidence labels from BATTLE39.",
            "Contact sheet contains analysis labels only.",
            "BATTLE29 map/HUD/card context is evidence-bearing, but BATTLE29 card positions remain inferred and BATTLE39 actor placement is not original runtime verified.",
            "No coordinate-only visual success claim is made.",
        ],
    }

    make_contact(video_frames, video_pairs, runtime_frames, runtime_pairs, B29_CAPTURE, result)
    write_comparison_csv(result)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    UNITY_OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_39 Attach Runtime Actors To Map11003 HUD Context With Evidence Result",
        "",
        "**원본 clip05 actor motion/layout/timing + map/HUD context는 아직 재현 안 됐다.** BATTLE39는 BATTLE29 map_11003/HUD/card object가 있는 scene에 runtime actor 3명을 붙였지만, 최종 capture에는 clip05/BATTLE29의 HUD/card regions가 camera-visible하지 않고 actor placement도 original runtime verified가 아니다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- reference video used: `True` (`플레이.mp4` 485.0-487.0s, frames `{len(video_frames)}`)",
        f"- actor motion/layout/timing + map/HUD context replayed: `{actor_motion_layout_timing_context_replayed}`",
        f"- placement original runtime verified: `{placement_verified}`",
        f"- Unity exit code: `{unity_exit_code}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Context Attach",
        f"- base BATTLE29 scene opened: `{runtime_context.get('baseSceneOpened')}`",
        f"- map/HUD/cards present: `{has_map}` / `{has_hud}` / `{has_cards}`",
        f"- camera-visible HUD/cards: `{camera_visible_battle_hud}`",
        f"- disabled old BATTLE27 actor roots: `{runtime_context.get('disabledExistingBattle27ActorCount')}`",
        f"- map source: `{runtime_context.get('mapContextSource')}`",
        f"- HUD/card source: `{runtime_context.get('hudContextSource')}`",
        f"- actor placement source: `{runtime_context.get('actorPlacementSource')}`",
        f"- actor placement evidence status: `{runtime_context.get('actorPlacementEvidenceStatus')}`",
        "",
        "## Clip05 Comparison",
        f"- reference actor boxes: `{len(ref_actor)}`",
        f"- runtime actor boxes: `{len(runtime_actor)}`",
        f"- actor center gap norm: `{layout_gap.get('centerDistanceNorm')}`",
        f"- runtime/reference actor area ratio: `{layout_gap.get('runtimeToReferenceAreaRatio')}`",
        f"- mesh hash changed actors: `{mesh_changed}` / `3`",
        f"- AnimationState SetAnimation success: `{result['animationStateSetSucceededCount']}` / `3`",
        f"- magenta pixel ratio: `{metrics.get('magentaPixelRatio')}`",
        f"- HUD visibility reason: `{hud_visibility.get('reason')}`",
        "",
        "## Evidence Notes",
        f"- Lua/formation/camera/HUD evidence rows: `{len(evidence)}`",
        "- BATTLE29 map/HUD/card context is useful evidence, but its card placement is already marked inferred.",
        "- BATTLE39 did not use fake HUD, fake motion, or debug labels in final capture.",
        "",
        "## Blocker",
        f"- {blocker}",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_OUT_JSON}`",
        f"- Unity probe JSON: `{UNITY_JSON}`",
        f"- actor bounds CSV: `{ACTOR_BOUNDS_CSV}`",
        f"- comparison CSV: `{OUT_CSV}`",
        f"- capture: `{B39_CAPTURE}`",
        f"- contact sheet: `{CONTACT}`",
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
        "actorMotionLayoutTimingMapHudContextReplayed": actor_motion_layout_timing_context_replayed,
        "placementOriginalRuntimeVerified": placement_verified,
        "unityExitCode": unity_exit_code,
        "hasBattleMap": has_map,
        "hasBattleHud": has_hud,
        "hasHeroCards": has_cards,
        "cameraVisibleBattleHud": camera_visible_battle_hud,
        "runtimeActorBoxCount": len(runtime_actor),
        "actorCenterGapNorm": layout_gap.get("centerDistanceNorm"),
        "actorAreaRatio": layout_gap.get("runtimeToReferenceAreaRatio"),
        "meshHashChangedActorCount": mesh_changed,
        "magentaPixelRatio": metrics.get("magentaPixelRatio"),
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
