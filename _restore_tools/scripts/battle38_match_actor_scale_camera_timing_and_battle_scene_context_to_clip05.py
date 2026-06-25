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

UNITY_JSON = UNITY_DATA / "BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_UNITY.json"
ACTOR_BOUNDS_CSV = UNITY_DATA / "BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_ACTOR_BOUNDS.csv"
B37_RESULT = REPORT_DIR / "BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_RESULT.json"
B29_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleHeroListSkillCardBindClip05_1920x1080.png"
B29_JSON = REPORT_DIR / "BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05_RESULT.json"
B38_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle38MatchActorScaleCameraTimingAndBattleSceneContextToClip05_1920x1080.png"
B38_SEQUENCE_DIR = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "battle38_sequence"

OUT_MD = REPORT_DIR / "BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_RESULT.json"
UNITY_OUT_JSON = UNITY_DATA / "BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05.json"
OUT_CSV = UNITY_DATA / "BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_COMPARISON.csv"
CONTACT = REPORT_DIR / "BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_CONTACT_SHEET.jpg"
VIDEO_SEQUENCE = REPORT_DIR / "BATTLE_38_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg"
UNITY_LOG = REPORT_DIR / "BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05.log"

LUA_ROOT = BASE / "girlswar_merged_extracted" / "decoded" / "xlua_battle"
EVIDENCE_KEYWORDS = [
    "HeroCtrl", "ResetPos", "GetPos", "spineboyScale", "RefreshSpineBoyScale",
    "SetSpineAnimation", "SetSpineInvisible", "formation", "Formation", "BattleCamera",
    "Camera", "LoadSkin", "SetTimelineEffect", "BuildPatchMgr:PlayTimeLine",
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


def load_b38_frames():
    frames = []
    for i in range(6):
        path = B38_SEQUENCE_DIR / f"Battle38Runtime_{i:02d}_1920x1080.png"
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


def detect_runtime_actor_boxes(frames):
    all_actor = []
    per_frame = []
    for frame in frames:
        img = frame["bgr"]
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        _, mask = cv2.threshold(gray, 24, 255, cv2.THRESH_BINARY)
        hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
        magenta = cv2.inRange(hsv, (140, 80, 80), (175, 255, 255))
        mask = cv2.bitwise_or(mask, magenta)
        mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, np.ones((5, 5), np.uint8))
        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        boxes = []
        for c in contours:
            x, y, bw, bh = cv2.boundingRect(c)
            if bw * bh >= 180:
                box = (x, y, bw, bh)
                boxes.append(box)
                all_actor.append(box)
        per_frame.append({"t": frame["t"], "actorBoxes": boxes})
    return all_actor, per_frame


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


def context_metrics(frames, b29_capture):
    mid = frames[len(frames) // 2]["bgr"]
    h, w = mid.shape[:2]
    top = mid[: int(h * 0.18), :, :]
    bottom = mid[int(h * 0.70):, :, :]
    right = mid[:, int(w * 0.82):, :]
    def non_dark(region):
        return round(float(np.count_nonzero(np.any(region > 32, axis=2))) / (region.shape[0] * region.shape[1]), 6)
    b29 = cv2.imread(str(b29_capture))
    b29_non_dark = None
    if b29 is not None:
        b29_non_dark = round(float(np.count_nonzero(np.any(b29 > 32, axis=2))) / (b29.shape[0] * b29.shape[1]), 6)
    return {
        "videoTopHudNonDarkRatio": non_dark(top),
        "videoBottomHudNonDarkRatio": non_dark(bottom),
        "videoRightControlNonDarkRatio": non_dark(right),
        "battle29ContextNonDarkRatio": b29_non_dark,
    }


def capture_metrics(path: Path):
    img = cv2.imread(str(path))
    if img is None:
        return {"captureExists": False}
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    magenta = cv2.inRange(hsv, (140, 80, 80), (175, 255, 255))
    non_black = np.any(img > 20, axis=2)
    total = img.shape[0] * img.shape[1]
    return {
        "captureExists": True,
        "width": int(img.shape[1]),
        "height": int(img.shape[0]),
        "magentaPixelRatio": round(float(np.count_nonzero(magenta)) / total, 6),
        "nonBlackPixelRatio": round(float(np.count_nonzero(non_black)) / total, 6),
    }


def collect_evidence(limit=80):
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
                hits.append({"path": str(path.relative_to(BASE)), "line": i, "text": line.strip()[:240]})
                if len(hits) >= limit:
                    return hits
    return hits


def draw_boxes(panel, boxes, color, label):
    draw = ImageDraw.Draw(panel)
    for i, (x, y, w, h) in enumerate(boxes[:16], start=1):
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
    for frame in video_frames:
        boxes = []
        # Use nearby motion-pair boxes where possible.
        idx = min(max(0, len(top_panels)), len(video_pairs) - 1)
        if video_pairs:
            boxes = video_pairs[idx]["actorBoxes"]
        top_panels.append(panel_from_bgr(frame["bgr"], f"video {frame['t']:.1f}s", boxes, (320, 180)))
    top = Image.new("RGB", (320 * len(top_panels), 180), (0, 0, 0))
    for i, p in enumerate(top_panels):
        top.paste(p, (i * 320, 0))
    top.save(VIDEO_SEQUENCE, quality=92)

    run_panels = []
    for i, frame in enumerate(runtime_frames):
        boxes = runtime_pairs[i]["actorBoxes"] if i < len(runtime_pairs) else []
        run_panels.append(panel_from_bgr(frame["bgr"], f"B38 runtime {i}", boxes, (320, 180)))
    runtime_row = Image.new("RGB", (320 * max(1, len(run_panels)), 180), (0, 0, 0))
    for i, p in enumerate(run_panels):
        runtime_row.paste(p, (i * 320, 0))

    b29_panel = Image.new("RGB", (960, 500), (8, 8, 8))
    b29 = cv2.imread(str(b29_capture))
    if b29 is not None:
        p = panel_from_bgr(b29, "BATTLE29 map/HUD/card context (not final)", None, (960, 500))
        b29_panel.paste(p, (0, 0))

    text_panel = Image.new("RGB", (960, 500), (8, 8, 8))
    td = ImageDraw.Draw(text_panel)
    lines = [
        "BATTLE_38 summary",
        f"verdict: {summary['verdict']}",
        f"visual_status: {summary['visual_status']}",
        f"runtime actor boxes: {summary['runtimeActorBoxCount']}",
        f"reference actor boxes: {summary['referenceActorBoxCount']}",
        f"actor center gap: {summary['actorLayoutGap'].get('centerDistanceNorm')}",
        f"actor area ratio: {summary['actorLayoutGap'].get('runtimeToReferenceAreaRatio')}",
        f"has map/HUD in B38: {summary['runtimeContext'].get('hasBattleMap')} / {summary['runtimeContext'].get('hasBattleHud')}",
        f"mesh changed actors: {summary['meshHashChangedActorCount']}/3",
        f"magenta ratio: {summary['captureMetrics'].get('magentaPixelRatio')}",
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
        {"metric": "actor_center_gap_norm", "value": result["actorLayoutGap"].get("centerDistanceNorm"), "note": "video union vs BATTLE38 runtime union"},
        {"metric": "actor_area_ratio_runtime_to_reference", "value": result["actorLayoutGap"].get("runtimeToReferenceAreaRatio"), "note": "scale/layout gap"},
        {"metric": "runtime_has_battle_map", "value": result["runtimeContext"].get("hasBattleMap"), "note": "BATTLE38 actor-only probe"},
        {"metric": "runtime_has_battle_hud", "value": result["runtimeContext"].get("hasBattleHud"), "note": "BATTLE38 actor-only probe"},
        {"metric": "mesh_hash_changed_actor_count", "value": result["meshHashChangedActorCount"], "note": "runtime motion evidence"},
        {"metric": "magenta_pixel_ratio", "value": result["captureMetrics"].get("magentaPixelRatio"), "note": "shader blocker nearly closed"},
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
    runtime_frames = load_b38_frames()
    unity = read_json(UNITY_JSON, {})
    b37 = read_json(B37_RESULT, {})
    b29 = read_json(B29_JSON, {})
    bounds_rows = read_csv(ACTOR_BOUNDS_CSV)
    ref_actor, video_pairs = detect_video_motion_boxes(video_frames)
    runtime_actor, runtime_pairs = detect_runtime_actor_boxes(runtime_frames)
    layout_gap = compare_boxes(ref_actor, runtime_actor)
    metrics = capture_metrics(B38_CAPTURE)
    evidence = collect_evidence()
    unity_summary = unity.get("summary", {})
    runtime_context = unity.get("context", {"hasBattleMap": False, "hasBattleHud": False})
    mesh_changed = int(unity_summary.get("meshHashChangedActorCount") or 0)
    has_map = bool(runtime_context.get("hasBattleMap"))
    has_hud = bool(runtime_context.get("hasBattleHud"))
    actor_motion_replayed = False

    if unity_exit_code != 0:
        visual_status = "failed_unity_batch_or_compile"
        blocker = "Unity batch/probe did not complete, so actor scale/camera/timing cannot be trusted."
        next_blocker = "BATTLE_39_FIX_BATTLE38_COMPILE_OR_BATCH_ERROR"
    elif not has_map or not has_hud:
        visual_status = "failed_battle_scene_context_map_hud_missing"
        blocker = "Actor runtime motion exists, but BATTLE38 remains actor-only: original map/HUD/context from clip05 is not attached to the runtime actor scene."
        next_blocker = "BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE"
    elif layout_gap.get("centerDistanceNorm") is None or layout_gap.get("centerDistanceNorm", 1) > 0.08:
        visual_status = "failed_actor_scale_camera_layout_gap"
        blocker = "Actor runtime screen bounds still differ from clip05 actor bounds; evidence-backed formation/camera placement is not resolved."
        next_blocker = "BATTLE_39_TRACE_FORMATION_CAMERA_POSITIONS_FROM_LUA_AND_PREFAB"
    elif mesh_changed < 3:
        visual_status = "failed_actor_runtime_motion_incomplete"
        blocker = "Not all actor runtime meshes changed across the sequence."
        next_blocker = "BATTLE_39_REPAIR_ACTOR_RUNTIME_SEQUENCE_ADVANCE"
    else:
        visual_status = "failed_clip05_timing_not_verified"
        blocker = "Actor layout/context is closer, but frame timing/skill state has not been verified against clip05."
        next_blocker = "BATTLE_39_MATCH_ACTOR_ANIMATION_TIMING_AND_SKILL_STATE_TO_CLIP05"

    result = {
        "verdict": "clip05 actor motion/layout/timing not reproduced",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "reference_video_used": True,
        "videoTimeRangeSeconds": "485.0-487.0",
        "referenceFrameCount": len(video_frames),
        "runtimeFrameCount": len(runtime_frames),
        "unityExitCode": unity_exit_code,
        "actorMotionLayoutTimingReplayed": actor_motion_replayed,
        "referenceActorBoxCount": len(ref_actor),
        "runtimeActorBoxCount": len(runtime_actor),
        "actorLayoutGap": layout_gap,
        "runtimeContext": runtime_context,
        "contextMetrics": context_metrics(video_frames, B29_CAPTURE),
        "captureMetrics": metrics,
        "meshHashChangedActorCount": mesh_changed,
        "animationStateSetSucceededCount": int(unity_summary.get("animationStateSetSucceededCount") or 0),
        "shaderRebindAppliedCount": int(unity_summary.get("shaderRebindAppliedCount") or 0),
        "battle37Carryover": {
            "visual_status": b37.get("visual_status"),
            "magentaPixelRatio": b37.get("captureMetrics", {}).get("magentaPixelRatio"),
            "shaderRebindAppliedCount": b37.get("shaderRebindAppliedCount"),
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
            "capture": str(B38_CAPTURE),
            "contactSheet": str(CONTACT),
            "videoSequence": str(VIDEO_SEQUENCE),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "No coordinate-only actor placement fix was applied.",
            "BATTLE38 final capture has no debug/path/evidence labels; analysis labels are only in the contact sheet.",
            "BATTLE29 map/HUD/card context is evidence-bearing but not yet integrated with BATTLE37/BATTLE38 runtime actor sequence.",
        ],
    }
    make_contact(video_frames, video_pairs, runtime_frames, runtime_pairs, B29_CAPTURE, result)
    write_comparison_csv(result)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    UNITY_OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_38 Match Actor Scale Camera Timing And Battle Scene Context To Clip05 Result",
        "",
        "**원본 clip05 actor motion/layout/timing은 아직 재현 안 됐다.** BATTLE38은 `플레이.mp4` 485.0-487.0s sequence와 runtime actor sequence를 비교했지만, actor-only context라 clip05 전투 화면으로 볼 수 없다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- reference video used: `True` (`플레이.mp4` 485.0-487.0s, frames `{len(video_frames)}`)",
        f"- actor motion/layout/timing replayed: `{actor_motion_replayed}`",
        f"- Unity exit code: `{unity_exit_code}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Layout / Context Comparison",
        f"- reference actor boxes: `{len(ref_actor)}`",
        f"- runtime actor boxes: `{len(runtime_actor)}`",
        f"- actor center gap norm: `{layout_gap.get('centerDistanceNorm')}`",
        f"- runtime/reference actor area ratio: `{layout_gap.get('runtimeToReferenceAreaRatio')}`",
        f"- runtime has battle map/HUD: `{has_map}` / `{has_hud}`",
        f"- BATTLE29 context map layers/cards: `{result['battle29Context'].get('mapLayerCreatedCount')}` / `{result['battle29Context'].get('boundHeroCardCount')}`",
        "",
        "## Runtime Actor Evidence",
        f"- mesh hash changed actors: `{mesh_changed}` / `3`",
        f"- AnimationState SetAnimation success: `{result['animationStateSetSucceededCount']}` / `3`",
        f"- shader rebind applied: `{result['shaderRebindAppliedCount']}`",
        f"- magenta pixel ratio: `{metrics.get('magentaPixelRatio')}`",
        "",
        "## Evidence Notes",
        f"- Lua/formation/camera/timing evidence rows: `{len(evidence)}`",
        "- Existing BATTLE29 map/HUD/card context and BATTLE37 actor runtime are separate; joining them needs evidence-backed scene context, not coordinate-only placement.",
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
        f"- capture: `{B38_CAPTURE}`",
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
        "actorMotionLayoutTimingReplayed": actor_motion_replayed,
        "unityExitCode": unity_exit_code,
        "actorCenterGapNorm": layout_gap.get("centerDistanceNorm"),
        "actorAreaRatio": layout_gap.get("runtimeToReferenceAreaRatio"),
        "hasBattleMap": has_map,
        "hasBattleHud": has_hud,
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
