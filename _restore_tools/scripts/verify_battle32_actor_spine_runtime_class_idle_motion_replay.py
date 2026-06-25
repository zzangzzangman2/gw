import json
from pathlib import Path

import cv2
import numpy as np
from PIL import Image, ImageDraw

BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")

UNITY_JSON = UNITY_DATA / "BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_UNITY.json"
UNITY_OUT_JSON = UNITY_DATA / "BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY.json"
COMPONENT_CSV = UNITY_DATA / "BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_COMPONENTS.csv"
B32_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle32ActorSpineRuntimeClassIdleMotionReplay_1920x1080.png"
B31_JSON = REPORT_DIR / "BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_RESULT.json"

OUT_MD = REPORT_DIR / "BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_RESULT.json"
CONTACT = REPORT_DIR / "BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_CONTACT_SHEET.jpg"
VIDEO_SEQUENCE = REPORT_DIR / "BATTLE_32_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg"


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


def motion_pairs(frames):
    out = []
    for a, b in zip(frames, frames[1:]):
        prev = cv2.cvtColor(a["bgr"], cv2.COLOR_BGR2GRAY)
        curr = cv2.cvtColor(b["bgr"], cv2.COLOR_BGR2GRAY)
        diff = cv2.absdiff(prev, curr)
        _, mask = cv2.threshold(diff, 20, 255, cv2.THRESH_BINARY)
        out.append({"pair": f"{a['t']:.1f}-{b['t']:.1f}", "changedPixels": int(np.count_nonzero(mask))})
    return out


def capture_metrics(path: Path):
    img = cv2.imread(str(path))
    if img is None:
        return {"captureExists": False}
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    magenta = cv2.inRange(hsv, (140, 80, 80), (175, 255, 255))
    bright = cv2.inRange(hsv, (0, 0, 210), (179, 45, 255))
    non_black = np.any(img > 20, axis=2)
    total = img.shape[0] * img.shape[1]
    return {
        "captureExists": True,
        "width": int(img.shape[1]),
        "height": int(img.shape[0]),
        "magentaPixelRatio": round(float(np.count_nonzero(magenta)) / total, 6),
        "brightWhitePixelRatio": round(float(np.count_nonzero(bright)) / total, 6),
        "nonBlackPixelRatio": round(float(np.count_nonzero(non_black)) / total, 6),
    }


def make_video_row(frames):
    panels = []
    for frame in frames:
        img = Image.fromarray(cv2.cvtColor(frame["bgr"], cv2.COLOR_BGR2RGB))
        img.thumbnail((320, 150), Image.Resampling.LANCZOS)
        panel = Image.new("RGB", (320, 180), (8, 8, 8))
        panel.paste(img, ((320 - img.width) // 2, 0))
        ImageDraw.Draw(panel).text((8, 155), f"play.mp4 {frame['t']:.1f}s", fill=(235, 235, 235))
        panels.append(panel)
    row = Image.new("RGB", (320 * len(panels), 180), (0, 0, 0))
    for i, panel in enumerate(panels):
        row.paste(panel, (i * 320, 0))
    return row


def make_contact(summary, frames):
    top = make_video_row(frames)
    VIDEO_SEQUENCE.parent.mkdir(parents=True, exist_ok=True)
    top.save(VIDEO_SEQUENCE, quality=92)

    capture_panel = Image.new("RGB", (960, 560), (8, 8, 8))
    if B32_CAPTURE.exists():
        cap = Image.open(B32_CAPTURE).convert("RGB")
        cap.thumbnail((940, 500), Image.Resampling.LANCZOS)
        capture_panel.paste(cap, (10, 0))
    d = ImageDraw.Draw(capture_panel)
    d.text((10, 510), "BATTLE_32 probe capture: no debug/path labels; not a final battle screen", fill=(245, 245, 245))
    d.text((10, 532), f"motion replay={summary['actorMotionReplayed']} magenta={summary['captureMetrics'].get('magentaPixelRatio')}", fill=(255, 210, 120))

    text_panel = Image.new("RGB", (960, 560), (8, 8, 8))
    td = ImageDraw.Draw(text_panel)
    lines = [
        "BATTLE_32 summary",
        f"verdict: {summary['verdict']}",
        f"visual_status: {summary['visual_status']}",
        f"missing scripts before/after: {summary['beforeMissingScriptCount']} / {summary['afterMissingScriptCount']}",
        f"SkeletonAnimation resolved: {summary['skeletonAnimationComponentCount']}",
        f"idle replay call success: {summary['idleReplaySucceededCount']}",
        f"shader fallback applied: {summary['shaderFallbackAppliedCount']}",
        f"magenta ratio: {summary['captureMetrics'].get('magentaPixelRatio')}",
        f"shader bundle loaded: {summary['shaderDependency'].get('loaded')}",
        "Still not final: clip05 actor motion is not reproduced.",
    ]
    y = 20
    for line in lines:
        td.text((20, y), line, fill=(235, 235, 235))
        y += 30

    sheet = Image.new("RGB", (1920, 740), (0, 0, 0))
    sheet.paste(top, (0, 0))
    sheet.paste(capture_panel, (0, 180))
    sheet.paste(text_panel, (960, 180))
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT, quality=92)


def main():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    UNITY_DATA.mkdir(parents=True, exist_ok=True)
    unity = read_json(UNITY_JSON, {})
    b31 = read_json(B31_JSON, {})
    frames = extract_frames()
    if not frames:
        raise SystemExit("could not extract play.mp4 clip05 485-487s frames")

    unity_summary = unity.get("summary", {})
    before_missing = int(b31.get("unitySummary", {}).get("missingScriptCount") or 3)
    after_missing = int(unity_summary.get("missingScriptCount") or 0)
    skeleton_animation_count = int(unity_summary.get("skeletonAnimationComponentCount") or 0)
    idle_success = int(unity_summary.get("idleReplaySucceededCount") or 0)
    shader_fix = int(unity_summary.get("shaderFallbackAppliedCount") or 0)
    metrics = capture_metrics(B32_CAPTURE)

    actor_motion_replayed = False
    if skeleton_animation_count == 0:
        visual_status = "failed_spine_runtime_type_not_resolved"
        next_blocker = "BATTLE_33_DEEP_TRACE_MONOSCRIPT_ASSEMBLY_GUID_FOR_ACTOR_PREFABS"
    elif idle_success == 0:
        visual_status = "failed_idle_animation_state_bridge_not_resolved"
        next_blocker = "BATTLE_33_RECONSTRUCT_SPINE_ANIMATIONSTATE_FROM_SKEL_BINARY"
    else:
        visual_status = "failed_clip05_motion_not_verified_after_idle_proxy"
        next_blocker = "BATTLE_33_RECONSTRUCT_SPINE_ANIMATIONSTATE_FROM_SKEL_BINARY"

    if metrics.get("magentaPixelRatio", 0) and metrics["magentaPixelRatio"] > 0.01:
        visual_status = "failed_spine_shader_or_runtime_mesh_still_magenta"
        if skeleton_animation_count == 0:
            next_blocker = "BATTLE_33_DEEP_TRACE_MONOSCRIPT_ASSEMBLY_GUID_FOR_ACTOR_PREFABS"

    summary = {
        "verdict": "아직 원본 clip05 actor motion 재현 아님",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "reference_video_used": True,
        "videoTimeRangeSeconds": "485.0-487.0",
        "referenceFrameCount": len(frames),
        "referenceMotionPairs": motion_pairs(frames),
        "actorMotionReplayed": actor_motion_replayed,
        "beforeMissingScriptCount": before_missing,
        "afterMissingScriptCount": after_missing,
        "missingScriptReduction": before_missing - after_missing,
        "skeletonAnimationComponentCount": skeleton_animation_count,
        "idleReplaySucceededCount": idle_success,
        "shaderFallbackAppliedCount": shader_fix,
        "captureMetrics": metrics,
        "shaderDependency": unity.get("shaderDependency", {}),
        "unityProbe": unity,
        "blocker": "Spine runtime proxy/shader evidence was probed, but original clip05 actor idle/motion is still not reproduced. The remaining blocker is MonoScript assembly/type binding if SkeletonAnimation did not resolve, otherwise real SkeletonData/AnimationState reconstruction from .skel.",
        "nextBlocker": next_blocker,
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "unityDataJson": str(UNITY_OUT_JSON),
            "unityProbeJson": str(UNITY_JSON),
            "componentCsv": str(COMPONENT_CSV),
            "capture": str(B32_CAPTURE),
            "contactSheet": str(CONTACT),
            "videoSequence": str(VIDEO_SEQUENCE),
        },
        "notes": [
            "No fake actor motion was generated.",
            "The probe capture contains no debug/path labels.",
            "A local shader named Spine/Skeleton is evidence-backed by IL2CPP strings and used only to classify magenta shader dependency.",
            "Passing counts do not override the clip05 motion gate.",
        ],
    }
    make_contact(summary, frames)
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    UNITY_OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    actors = unity.get("actors", [])
    md = [
        "# BATTLE_32 Actor Spine Runtime Class Idle Motion Replay Result",
        "",
        "**아직 원본 clip05 actor motion 재현 아님.** Spine runtime class/shader proxy를 검증했지만 `플레이.mp4` 485~487초의 actor motion은 재생되지 않았다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- reference video sequence: `플레이.mp4` 485.0-487.0s, frames `{len(frames)}`",
        f"- actor motion replayed: `{actor_motion_replayed}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Runtime Class / Shader Probe",
        f"- MissingScript before/after: `{before_missing}` / `{after_missing}`",
        f"- MissingScript reduction: `{before_missing - after_missing}`",
        f"- SkeletonAnimation components resolved: `{skeleton_animation_count}`",
        f"- idle replay call success: `{idle_success}`",
        f"- shader fallback applied: `{shader_fix}`",
        f"- magenta pixel ratio: `{metrics.get('magentaPixelRatio')}`",
        f"- shader dependency loaded: `{unity.get('shaderDependency', {}).get('loaded')}`",
        f"- shader dependency status: `{unity.get('shaderDependency', {}).get('status')}`",
        "",
        "## Actor Details",
    ]
    for actor in actors:
        md.append(
            f"- `{actor.get('side')}` heroDid `{actor.get('heroDid')}` model `{actor.get('modelId')}`: "
            f"missingScript `{actor.get('missingScriptCount')}`, SkeletonAnimation `{actor.get('skeletonAnimationComponentCount')}`, "
            f"idleReplay `{actor.get('idleReplaySucceeded')}`, shaderFix `{actor.get('shaderFallbackAppliedCount')}`, "
            f"idleInSkelBytes `{actor.get('idleStringInSkelBytes')}`, atlas `{actor.get('atlasFirstLine')}`"
        )
    md.extend([
        "",
        "## Blocker",
        f"- {summary['blocker']}",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_OUT_JSON}`",
        f"- Unity probe JSON: `{UNITY_JSON}`",
        f"- component CSV: `{COMPONENT_CSV}`",
        f"- capture: `{B32_CAPTURE}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Next Blocker",
        f"- `{next_blocker}`",
    ])
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(json.dumps({
        "visual_status": visual_status,
        "actorMotionReplayed": actor_motion_replayed,
        "missingScriptBeforeAfter": f"{before_missing}/{after_missing}",
        "skeletonAnimationComponentCount": skeleton_animation_count,
        "idleReplaySucceededCount": idle_success,
        "shaderFallbackAppliedCount": shader_fix,
        "magentaPixelRatio": metrics.get("magentaPixelRatio"),
        "contactSheet": str(CONTACT),
        "nextBlocker": next_blocker,
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
