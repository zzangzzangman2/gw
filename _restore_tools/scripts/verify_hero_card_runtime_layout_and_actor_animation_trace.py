import csv
import json
import math
import os
from pathlib import Path

import cv2
import numpy as np
from PIL import Image, ImageDraw

BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DATA = BASE / "girlswar_battle_unity" / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")

B29_JSON = REPORT_DIR / "BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05_RESULT.json"
B29_CAPTURE = BASE / "girlswar_battle_unity" / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleHeroListSkillCardBindClip05_1920x1080.png"
RUNTIME_MANIFEST = UNITY_DATA / "BATTLE_RUNTIME_STREAMING_MANIFEST.json"
STREAMING_PROBE = UNITY_DATA / "BATTLE_ASSETBUNDLE_STREAMING_PROBE.json"
HIERARCHY_DUMP = UNITY_DATA / "BATTLE_PREFAB_HIERARCHY_DUMP.json"
B28_JSON = REPORT_DIR / "BATTLE_28_ACTOR_MOTION_SKILLCARD_EVIDENCE_RESULT.json"

OUT_JSON = REPORT_DIR / "BATTLE_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE_RESULT.json"
OUT_MD = REPORT_DIR / "BATTLE_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE_RESULT.md"
UNITY_OUT_JSON = UNITY_DATA / "BATTLE_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE.json"
OUT_CSV = UNITY_DATA / "BATTLE_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE_GAPS.csv"
CONTACT = REPORT_DIR / "BATTLE_30_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE_CONTACT_SHEET.jpg"
FRAME_SEQUENCE = REPORT_DIR / "BATTLE_30_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg"

LUA_ROOT = BASE / "girlswar_merged_extracted" / "decoded" / "xlua_battle"
ANIMATION_KEYWORDS = [
    "SkeletonAnimation", "AnimationState", "SetAnimation", "AddAnimation", "ChangeToRun",
    "ChangeState", "BattleTimeline", "Timeline", "CurrTimelineEffect", "PlayAnim",
    "spine", "Spine", "HeroCtrl", "BattleSkillEffectManager",
]


def read_json(path: Path, fallback):
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def extract_frames():
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


def norm_box(box, w, h):
    x, y, bw, bh = box
    return {
        "x": round(x / w, 5), "y": round(y / h, 5),
        "w": round(bw / w, 5), "h": round(bh / h, 5),
        "cx": round((x + bw / 2) / w, 5), "cy": round((y + bh / 2) / h, 5),
    }


def union_box(boxes):
    if not boxes:
        return None
    x1 = min(b[0] for b in boxes)
    y1 = min(b[1] for b in boxes)
    x2 = max(b[0] + b[2] for b in boxes)
    y2 = max(b[1] + b[3] for b in boxes)
    return (x1, y1, x2 - x1, y2 - y1)


def detect_motion_boxes(frames):
    pairs = []
    all_actor = []
    all_card = []
    for a, b in zip(frames, frames[1:]):
        prev = cv2.cvtColor(a["bgr"], cv2.COLOR_BGR2GRAY)
        curr = cv2.cvtColor(b["bgr"], cv2.COLOR_BGR2GRAY)
        diff = cv2.absdiff(prev, curr)
        _, mask = cv2.threshold(diff, 20, 255, cv2.THRESH_BINARY)
        mask = cv2.dilate(mask, np.ones((5, 5), np.uint8), iterations=2)
        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        h, w = mask.shape
        boxes = []
        actor = []
        card = []
        for c in contours:
            x, y, bw, bh = cv2.boundingRect(c)
            area = bw * bh
            if area < 180:
                continue
            box = (x, y, bw, bh)
            boxes.append(box)
            cy = (y + bh / 2) / h
            cx = (x + bw / 2) / w
            if cy >= 0.68 and 0.25 <= cx <= 0.75:
                card.append(box)
                all_card.append(box)
            elif 0.18 <= cy <= 0.72 and 0.05 <= cx <= 0.95:
                actor.append(box)
                all_actor.append(box)
        pairs.append({"pair": f"{a['t']:.1f}-{b['t']:.1f}s", "boxes": boxes, "actorBoxes": actor, "cardBoxes": card})
    return pairs, all_actor, all_card


def detect_static_boxes_bgr(image_bgr):
    hsv = cv2.cvtColor(image_bgr, cv2.COLOR_BGR2HSV)
    h, w = image_bgr.shape[:2]
    # Skill/card UI tends to be bright and saturated in bottom-center. Actor candidates are smaller high-saturation/edge regions above cards.
    card_mask = np.zeros((h, w), dtype=np.uint8)
    bottom = hsv[int(h * 0.58):h, :, :]
    card_roi = cv2.inRange(bottom, (10, 45, 70), (179, 255, 255))
    card_roi = cv2.dilate(card_roi, np.ones((5, 5), np.uint8), iterations=1)
    card_mask[int(h * 0.58):h, :] = card_roi
    actor_mask = np.zeros((h, w), dtype=np.uint8)
    mid = hsv[int(h * 0.18):int(h * 0.78), :, :]
    actor_roi = cv2.inRange(mid, (0, 50, 50), (179, 255, 255))
    actor_roi = cv2.morphologyEx(actor_roi, cv2.MORPH_OPEN, np.ones((3, 3), np.uint8))
    actor_mask[int(h * 0.18):int(h * 0.78), :] = actor_roi

    def contours_to_boxes(mask, area_min, area_max, cx_min=0, cx_max=1):
        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        out = []
        for c in contours:
            x, y, bw, bh = cv2.boundingRect(c)
            area = bw * bh
            cx = (x + bw / 2) / w
            if area_min <= area <= area_max and cx_min <= cx <= cx_max:
                out.append((x, y, bw, bh))
        return sorted(out, key=lambda b: b[2] * b[3], reverse=True)

    return {
        "actorBoxes": contours_to_boxes(actor_mask, 200, 50000, 0.05, 0.95)[:20],
        "cardBoxes": contours_to_boxes(card_mask, 250, 80000, 0.2, 0.8)[:20],
    }


def summarize_box_gap(ref_boxes, cap_boxes, ref_size, cap_size):
    ref_union = union_box(ref_boxes)
    cap_union = union_box(cap_boxes)
    if not ref_union or not cap_union:
        return {
            "hasReference": bool(ref_union),
            "hasCapture": bool(cap_union),
            "centerDistanceNorm": None,
            "scaleRatioArea": None,
        }
    rn = norm_box(ref_union, *ref_size)
    cn = norm_box(cap_union, *cap_size)
    dist = math.sqrt((rn["cx"] - cn["cx"]) ** 2 + (rn["cy"] - cn["cy"]) ** 2)
    ref_area = rn["w"] * rn["h"]
    cap_area = cn["w"] * cn["h"]
    return {
        "hasReference": True,
        "hasCapture": True,
        "referenceUnionNorm": rn,
        "captureUnionNorm": cn,
        "centerDistanceNorm": round(dist, 5),
        "scaleRatioArea": round((cap_area / ref_area), 5) if ref_area > 0 else None,
    }


def draw_boxes_on_pil(img, boxes, color, label_prefix=""):
    draw = ImageDraw.Draw(img)
    for i, box in enumerate(boxes[:12], start=1):
        x, y, w, h = box
        draw.rectangle((x, y, x + w, y + h), outline=color, width=3)
        if label_prefix:
            draw.text((x + 2, max(0, y - 16)), f"{label_prefix}{i}", fill=color)
    return img


def make_contact(frames, motion_pairs, capture_bgr, ref_actor, ref_card, cap_actor, cap_card, summary):
    panels = []
    for frame in frames:
        img = Image.fromarray(cv2.cvtColor(frame["bgr"], cv2.COLOR_BGR2RGB))
        img.thumbnail((300, 140), Image.Resampling.LANCZOS)
        panel = Image.new("RGB", (300, 170), (8, 8, 8))
        panel.paste(img, ((300 - img.width) // 2, 0))
        ImageDraw.Draw(panel).text((8, 145), f"video {frame['t']:.1f}s", fill=(230, 230, 230))
        panels.append(panel)
    top = Image.new("RGB", (300 * len(panels), 170), (4, 4, 4))
    for i, p in enumerate(panels):
        top.paste(p, (i * 300, 0))

    motion_panels = []
    for pair in motion_pairs:
        idx = min(len(frames) - 1, motion_pairs.index(pair) + 1)
        base = Image.fromarray(cv2.cvtColor(frames[idx]["bgr"], cv2.COLOR_BGR2RGB))
        base.thumbnail((360, 168), Image.Resampling.LANCZOS)
        sx = base.width / frames[idx]["bgr"].shape[1]
        sy = base.height / frames[idx]["bgr"].shape[0]
        actor = [(int(x * sx), int(y * sy), int(w * sx), int(h * sy)) for x, y, w, h in pair["actorBoxes"]]
        card = [(int(x * sx), int(y * sy), int(w * sx), int(h * sy)) for x, y, w, h in pair["cardBoxes"]]
        panel = Image.new("RGB", (360, 225), (8, 8, 8))
        panel.paste(base, ((360 - base.width) // 2, 0))
        offset_x = (360 - base.width) // 2
        actor = [(x + offset_x, y, w, h) for x, y, w, h in actor]
        card = [(x + offset_x, y, w, h) for x, y, w, h in card]
        draw_boxes_on_pil(panel, actor, (255, 70, 70), "A")
        draw_boxes_on_pil(panel, card, (80, 220, 255), "C")
        d = ImageDraw.Draw(panel)
        d.text((8, 188), f"motion {pair['pair']}", fill=(235, 235, 235))
        d.text((8, 207), f"actor={len(pair['actorBoxes'])} card={len(pair['cardBoxes'])}", fill=(235, 210, 120))
        motion_panels.append(panel)
    motion_row = Image.new("RGB", (360 * len(motion_panels), 225), (4, 4, 4))
    for i, p in enumerate(motion_panels):
        motion_row.paste(p, (i * 360, 0))

    cap_img = Image.fromarray(cv2.cvtColor(capture_bgr, cv2.COLOR_BGR2RGB))
    cap_img.thumbnail((960, 540), Image.Resampling.LANCZOS)
    sx = cap_img.width / capture_bgr.shape[1]
    sy = cap_img.height / capture_bgr.shape[0]
    actor = [(int(x * sx), int(y * sy), int(w * sx), int(h * sy)) for x, y, w, h in cap_actor]
    card = [(int(x * sx), int(y * sy), int(w * sx), int(h * sy)) for x, y, w, h in cap_card]
    cap_panel = Image.new("RGB", (1000, 610), (8, 8, 8))
    cap_panel.paste(cap_img, (20, 0))
    draw_boxes_on_pil(cap_panel, actor, (255, 70, 70), "A")
    draw_boxes_on_pil(cap_panel, card, (80, 220, 255), "C")
    d = ImageDraw.Draw(cap_panel)
    d.text((20, 550), "BATTLE_29 capture with detected actor/card candidates", fill=(255, 255, 255))
    d.text((20, 574), f"actor gap={summary['actorGap'].get('centerDistanceNorm')} card gap={summary['cardGap'].get('centerDistanceNorm')}", fill=(255, 220, 120))

    text_panel = Image.new("RGB", (800, 610), (8, 8, 8))
    td = ImageDraw.Draw(text_panel)
    y = 20
    for line in [
        "BATTLE_30 summary",
        f"verdict: {summary['verdict']}",
        f"video actor boxes: {summary['referenceActorBoxCount']}",
        f"video card boxes: {summary['referenceCardBoxCount']}",
        f"capture actor boxes: {summary['captureActorBoxCount']}",
        f"capture card boxes: {summary['captureCardBoxCount']}",
        f"actor center gap: {summary['actorGap'].get('centerDistanceNorm')}",
        f"actor area ratio: {summary['actorGap'].get('scaleRatioArea')}",
        f"card center gap: {summary['cardGap'].get('centerDistanceNorm')}",
        f"card area ratio: {summary['cardGap'].get('scaleRatioArea')}",
        f"loadable actor prefabs: {summary['animationEvidence']['loadableActorPrefabCount']}",
        f"missing actor slots: {summary['animationEvidence']['missingActorSlotCount']}",
        "Still not final: actor animation/runtime replay missing.",
    ]:
        td.text((20, y), line, fill=(235, 235, 235))
        y += 30

    sheet = Image.new("RGB", (1800, 170 + 225 + 610 + 60), (0, 0, 0))
    sheet.paste(top, (0, 0))
    sheet.paste(motion_row, (0, 190))
    sheet.paste(cap_panel, (0, 435))
    sheet.paste(text_panel, (1000, 435))
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT, quality=92)
    top.save(FRAME_SEQUENCE, quality=92)


def collect_lua_animation_evidence(limit=80):
    hits = []
    if not LUA_ROOT.exists():
        return hits
    for path in LUA_ROOT.rglob("*.lua"):
        try:
            lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
        except Exception:
            continue
        for i, line in enumerate(lines, start=1):
            if any(k in line for k in ANIMATION_KEYWORDS):
                hits.append({"path": str(path.relative_to(BASE)), "line": i, "text": line.strip()[:220]})
                if len(hits) >= limit:
                    return hits
    return hits


def build_animation_evidence():
    runtime = read_json(RUNTIME_MANIFEST, {})
    streaming = read_json(STREAMING_PROBE, {})
    hierarchy = read_json(HIERARCHY_DUMP, {})
    actors = runtime.get("actors", [])
    loadable = [a for a in actors if a.get("loadStatus") == "runtime_prefab"]
    missing = [a for a in actors if a.get("loadStatus") != "runtime_prefab"]
    return {
        "runtimeActorSlotCount": len(actors),
        "loadableActorPrefabCount": len(loadable),
        "missingActorSlotCount": len(missing),
        "loadableActors": [
            {
                "side": a.get("side"),
                "heroDid": a.get("heroDid"),
                "model": a.get("model"),
                "bundle": a.get("bundle"),
                "prefabAsset": a.get("prefabAsset"),
                "loadStatus": a.get("loadStatus"),
            }
            for a in loadable
        ],
        "missingActors": [
            {
                "side": a.get("side"),
                "heroDid": a.get("heroDid"),
                "model": a.get("model"),
                "missingReason": a.get("missingReason"),
            }
            for a in missing
        ],
        "streamingProbeSummary": streaming.get("summary", {}),
        "skeletonEvidence": hierarchy.get("skeletonEvidence", []),
        "hierarchyObjects": hierarchy.get("objects", []),
        "luaAnimationEvidence": collect_lua_animation_evidence(),
        "motionReplayBlocker": "Spine/SkeletonData assets and actor prefabs exist for 3 actors, but prefab MissingScript/animation-state runtime class and Lua HeroCtrl timeline replay are not reconstructed; 9 actor slots still lack loadable prefabs.",
    }


def write_csv(summary):
    fields = ["kind", "hasReference", "hasCapture", "centerDistanceNorm", "scaleRatioArea", "referenceUnionNorm", "captureUnionNorm"]
    OUT_CSV.parent.mkdir(parents=True, exist_ok=True)
    with OUT_CSV.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for kind in ["actorGap", "cardGap"]:
            item = summary[kind]
            writer.writerow({
                "kind": kind,
                "hasReference": item.get("hasReference"),
                "hasCapture": item.get("hasCapture"),
                "centerDistanceNorm": item.get("centerDistanceNorm"),
                "scaleRatioArea": item.get("scaleRatioArea"),
                "referenceUnionNorm": json.dumps(item.get("referenceUnionNorm", {}), ensure_ascii=False),
                "captureUnionNorm": json.dumps(item.get("captureUnionNorm", {}), ensure_ascii=False),
            })


def main():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    UNITY_DATA.mkdir(parents=True, exist_ok=True)
    b29 = read_json(B29_JSON, {})
    frames = extract_frames()
    if not frames:
        raise SystemExit("could not extract play.mp4 frames around 485-487s")
    motion_pairs, ref_actor_boxes, ref_card_boxes = detect_motion_boxes(frames)
    capture_bgr = cv2.imread(str(B29_CAPTURE))
    if capture_bgr is None:
        raise SystemExit(f"missing BATTLE_29 capture: {B29_CAPTURE}")
    static = detect_static_boxes_bgr(capture_bgr)
    ref_size = (frames[0]["bgr"].shape[1], frames[0]["bgr"].shape[0])
    cap_size = (capture_bgr.shape[1], capture_bgr.shape[0])
    animation = build_animation_evidence()
    summary = {
        "verdict": "battle30_layout_motion_trace_not_final",
        "visual_status": "failed_actor_motion_runtime_replay_missing",
        "isFinalRestoredBattleScreen": False,
        "reference_video_used": True,
        "videoTimeRangeSeconds": "485.0-487.0",
        "referenceFrameCount": len(frames),
        "battle29Capture": str(B29_CAPTURE),
        "contactSheet": str(CONTACT),
        "frameSequence": str(FRAME_SEQUENCE),
        "referenceActorBoxCount": len(ref_actor_boxes),
        "referenceCardBoxCount": len(ref_card_boxes),
        "captureActorBoxCount": len(static["actorBoxes"]),
        "captureCardBoxCount": len(static["cardBoxes"]),
        "actorGap": summarize_box_gap(ref_actor_boxes, static["actorBoxes"], ref_size, cap_size),
        "cardGap": summarize_box_gap(ref_card_boxes, static["cardBoxes"], ref_size, cap_size),
        "battle29HeroCards": b29.get("unityLiveSummary", {}).get("cards", []),
        "battle29FailureAxes": b29.get("failureAxes", {}),
        "animationEvidence": animation,
        "nextBlocker": "BATTLE_31_ATTACH_LOADABLE_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE",
        "notes": [
            "This is not a final battle screen claim.",
            "Video sequence motion boxes are used instead of a single screenshot.",
            "BATTLE_29 card binding is improved but card positions are still inferred; actor animation/runtime replay is missing.",
            "No debug text was added to final capture; labels only appear in the analysis contact sheet.",
        ],
    }
    make_contact(frames, motion_pairs, capture_bgr, ref_actor_boxes, ref_card_boxes, static["actorBoxes"], static["cardBoxes"], summary)
    write_csv(summary)
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    UNITY_OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_30 Hero Card Runtime Layout And Actor Animation Trace",
        "",
        "This is not a final restored battle screen. It verifies BATTLE_29 against the `플레이.mp4` clip05 485.0-487.0s sequence.",
        "",
        "## Verdict",
        f"- visual_status: `{summary['visual_status']}`",
        "- final screen claim: `false`",
        f"- reference frames: `{summary['referenceFrameCount']}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Actor/Card Layout Gap",
        f"- reference actor boxes: `{summary['referenceActorBoxCount']}`",
        f"- capture actor boxes: `{summary['captureActorBoxCount']}`",
        f"- actor center gap norm: `{summary['actorGap'].get('centerDistanceNorm')}`",
        f"- actor area scale ratio: `{summary['actorGap'].get('scaleRatioArea')}`",
        f"- reference card boxes: `{summary['referenceCardBoxCount']}`",
        f"- capture card boxes: `{summary['captureCardBoxCount']}`",
        f"- card center gap norm: `{summary['cardGap'].get('centerDistanceNorm')}`",
        f"- card area scale ratio: `{summary['cardGap'].get('scaleRatioArea')}`",
        "",
        "## Animation Replay Evidence",
        f"- runtime actor slots: `{animation['runtimeActorSlotCount']}`",
        f"- loadable actor prefabs: `{animation['loadableActorPrefabCount']}`",
        f"- missing actor slots: `{animation['missingActorSlotCount']}`",
        f"- skeleton evidence assets: `{len(animation['skeletonEvidence'])}`",
        f"- Lua animation/timeline evidence lines: `{len(animation['luaAnimationEvidence'])}`",
        f"- blocker: {animation['motionReplayBlocker']}",
        "",
        "## Loadable Actors",
    ]
    for actor in animation["loadableActors"]:
        md.append(f"- `{actor['side']}` heroDid `{actor['heroDid']}` model `{actor['model']}` bundle `{actor['bundle']}`")
    md.extend([
        "",
        "## Missing Actor Slots",
    ])
    for actor in animation["missingActors"][:12]:
        md.append(f"- `{actor['side']}` heroDid `{actor['heroDid']}` model `{actor['model']}` reason `{actor['missingReason']}`")
    md.extend([
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_OUT_JSON}`",
        f"- layout gaps CSV: `{OUT_CSV}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Next Blocker",
        f"- `{summary['nextBlocker']}`",
    ])
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps({
        "visual_status": summary["visual_status"],
        "actorGap": summary["actorGap"].get("centerDistanceNorm"),
        "cardGap": summary["cardGap"].get("centerDistanceNorm"),
        "loadableActorPrefabs": animation["loadableActorPrefabCount"],
        "missingActorSlots": animation["missingActorSlotCount"],
        "contactSheet": str(CONTACT),
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
