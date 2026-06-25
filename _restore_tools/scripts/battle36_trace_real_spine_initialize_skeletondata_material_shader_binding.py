import argparse
import csv
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

UNITY_JSON = UNITY_DATA / "BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_UNITY.json"
UNITY_COMPONENT_CSV = UNITY_DATA / "BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_COMPONENTS.csv"
CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle36TraceRealSpineInitializeSkeletonDataMaterialShaderBinding_1920x1080.png"
SCENE = PROJECT / "Assets" / "Scenes" / "Battle36TraceRealSpineInitializeSkeletonDataMaterialShaderBinding.unity"

OUT_MD = REPORT_DIR / "BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_RESULT.json"
UNITY_OUT_JSON = UNITY_DATA / "BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING.json"
CONTACT = REPORT_DIR / "BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_CONTACT_SHEET.jpg"
VIDEO_SEQUENCE = REPORT_DIR / "BATTLE_36_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg"
UNITY_LOG = REPORT_DIR / "BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING.log"


def read_json(path: Path, fallback):
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def count_cmds(path: Path):
    return len(list(path.glob("*.cmd"))) if path.exists() else 0


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
    rows = []
    for a, b in zip(frames, frames[1:]):
        prev = cv2.cvtColor(a["bgr"], cv2.COLOR_BGR2GRAY)
        curr = cv2.cvtColor(b["bgr"], cv2.COLOR_BGR2GRAY)
        diff = cv2.absdiff(prev, curr)
        _, mask = cv2.threshold(diff, 20, 255, cv2.THRESH_BINARY)
        rows.append({"pair": f"{a['t']:.1f}-{b['t']:.1f}", "changedPixels": int(np.count_nonzero(mask))})
    return rows


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


def image_row(frames):
    panels = []
    for frame in frames:
        img = Image.fromarray(cv2.cvtColor(frame["bgr"], cv2.COLOR_BGR2RGB))
        img.thumbnail((320, 150), Image.Resampling.LANCZOS)
        panel = Image.new("RGB", (320, 180), (8, 8, 8))
        panel.paste(img, ((320 - img.width) // 2, 0))
        ImageDraw.Draw(panel).text((8, 155), f"play.mp4 {frame['t']:.1f}s", fill=(235, 235, 235))
        panels.append(panel)
    row = Image.new("RGB", (320 * max(1, len(panels)), 180), (0, 0, 0))
    for i, panel in enumerate(panels):
        row.paste(panel, (i * 320, 0))
    return row


def make_contact(summary, frames):
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    top = image_row(frames)
    top.save(VIDEO_SEQUENCE, quality=92)

    capture_panel = Image.new("RGB", (960, 560), (8, 8, 8))
    if CAPTURE.exists():
        cap = Image.open(CAPTURE).convert("RGB")
        cap.thumbnail((940, 500), Image.Resampling.LANCZOS)
        capture_panel.paste(cap, (10, 0))
    d = ImageDraw.Draw(capture_panel)
    d.text((10, 510), "BATTLE_36 runtime capture: no debug/path labels; not final battle screen", fill=(245, 245, 245))
    d.text((10, 532), f"motion={summary['actorMotionReplayed']} meshChanged={summary['meshHashChangedActorCount']} magenta={summary['captureMetrics'].get('magentaPixelRatio')}", fill=(255, 210, 120))

    text_panel = Image.new("RGB", (960, 560), (8, 8, 8))
    td = ImageDraw.Draw(text_panel)
    lines = [
        "BATTLE_36 summary",
        f"verdict: {summary['verdict']}",
        f"visual_status: {summary['visual_status']}",
        f"SkeletonAnimation: {summary['skeletonAnimationComponentCount']}/3",
        f"Initialize valid: {summary['afterInitializeValidCount']}/3",
        f"SetAnimation: {summary['animationStateSetSucceededCount']}/3",
        f"Update(float): {summary['updateFloatCalledCount']}/3",
        f"mesh hash changed: {summary['meshHashChangedActorCount']}/3",
        f"unsupported shader materials: {summary['unsupportedShaderMaterialCount']}",
        f"magenta ratio: {summary['captureMetrics'].get('magentaPixelRatio')}",
        f"next blocker: {summary['nextBlocker']}",
    ]
    y = 18
    for line in lines:
        td.text((20, y), line, fill=(235, 235, 235))
        y += 28

    sheet = Image.new("RGB", (1920, 740), (0, 0, 0))
    sheet.paste(top, (0, 0))
    sheet.paste(capture_panel, (0, 180))
    sheet.paste(text_panel, (960, 180))
    sheet.save(CONTACT, quality=92)


def write_actor_csv(actors):
    csv_path = UNITY_DATA / "BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_ACTORS.csv"
    fields = [
        "heroDid", "modelId", "expectedAnimation", "animationStateUsedName",
        "skeletonDataAssetName", "boneCount", "slotCount", "animationCount",
        "expectedAnimationInRuntime", "meshGeneratorNonNull", "meshVertexCountAfter",
        "meshHashChangedFrameCount", "meshBoundsChangedFrameCount", "unsupportedShaderMaterialCount",
        "motionReplayStatus", "runtimeException",
    ]
    csv_path.parent.mkdir(parents=True, exist_ok=True)
    with csv_path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for actor in actors:
            writer.writerow({field: actor.get(field, "") for field in fields})
    return csv_path


def classify(unity_exit_code, unity, metrics):
    actors = unity.get("actors") or []
    summary = unity.get("summary") or {}
    runtime = unity.get("runtimeTypePresence") or {}
    real_runtime = bool(runtime.get("realRuntimePresent"))
    skeleton_animation_count = int(summary.get("skeletonAnimationComponentCount") or 0)
    set_animation = int(summary.get("animationStateSetSucceededCount") or 0)
    initialize_count = int(summary.get("initializeCalledCount") or 0)
    valid_count = sum(1 for a in actors if a.get("afterInitializeValid"))
    update_float_count = int(summary.get("updateFloatCalledCount") or 0)
    skeleton_data_null_count = int(summary.get("skeletonDataNullCount") or 0)
    mesh_generator_count = int(summary.get("meshGeneratorNonNullCount") or 0)
    mesh_changed_count = sum(1 for a in actors if int(a.get("meshHashChangedFrameCount") or 0) > 0)
    unsupported_shader_count = int(summary.get("unsupportedShaderMaterialCount") or 0)
    magenta = float(metrics.get("magentaPixelRatio") or 0)

    actor_motion_replayed = False
    if unity_exit_code != 0:
        visual_status = "failed_unity_batch_or_compile"
        next_blocker = "BATTLE_37_FIX_SPINE_RUNTIME_PROBE_COMPILE_OR_BATCH_ERROR"
        blocker = "Unity batch/probe did not complete, so runtime state cannot be trusted."
    elif not real_runtime:
        visual_status = "failed_real_spine_runtime_missing"
        next_blocker = "BATTLE_37_REPAIR_SPINE_RUNTIME_ASSEMBLY_BINDING"
        blocker = "Real Spine runtime types were not loaded in the battle Unity project."
    elif skeleton_data_null_count:
        visual_status = "failed_skeletondata_initialize_null_or_empty"
        next_blocker = "BATTLE_37_REBUILD_SKELETONDATA_ASSET_ATLAS_BINDING"
        blocker = "At least one actor SkeletonDataAsset could not produce SkeletonData after Initialize."
    elif set_animation == 3 and mesh_changed_count == 0:
        visual_status = "failed_animation_state_advances_but_mesh_hash_static"
        next_blocker = "BATTLE_37_TRACE_SPINE_ANIMATIONSTATE_TRACK_TIME_AND_MESH_GENERATOR_BUFFERS"
        blocker = "SetAnimation and Update(float) run, but sampled mesh hash/bounds did not change across frames."
    elif mesh_changed_count > 0 and magenta > 0.01:
        visual_status = "failed_mesh_updates_but_shader_material_render_still_magenta"
        next_blocker = "BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES"
        blocker = "Mesh changes are present, but the capture still contains magenta render evidence from shader/material binding."
    elif mesh_changed_count > 0:
        visual_status = "failed_clip05_actor_motion_not_yet_matched_after_mesh_update"
        next_blocker = "BATTLE_37_MATCH_ACTOR_ANIMATION_NAMES_SCALE_TIMING_TO_CLIP05_SEQUENCE"
        blocker = "Mesh changes are present, but clip05 actor motion/layout/timing has not been matched."
    elif unsupported_shader_count:
        visual_status = "failed_shader_material_unsupported"
        next_blocker = "BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES"
        blocker = "Renderer materials report unsupported shader/pass state."
    else:
        visual_status = "failed_runtime_state_inconclusive"
        next_blocker = "BATTLE_37_TRACE_SPINE_RUNTIME_INTERNAL_STATE_DEEPER"
        blocker = "Runtime state did not identify a single complete render/motion path yet."

    return {
        "actors": actors,
        "runtime": runtime,
        "realRuntimePresent": real_runtime,
        "skeletonAnimationComponentCount": skeleton_animation_count,
        "initializeCalledCount": initialize_count,
        "afterInitializeValidCount": valid_count,
        "animationStateSetSucceededCount": set_animation,
        "updateFloatCalledCount": update_float_count,
        "skeletonDataNullCount": skeleton_data_null_count,
        "meshGeneratorNonNullCount": mesh_generator_count,
        "meshHashChangedActorCount": mesh_changed_count,
        "unsupportedShaderMaterialCount": unsupported_shader_count,
        "actorMotionReplayed": actor_motion_replayed,
        "visual_status": visual_status,
        "nextBlocker": next_blocker,
        "blocker": blocker,
    }


def verify(unity_exit_code: int):
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    UNITY_DATA.mkdir(parents=True, exist_ok=True)

    frames = extract_frames()
    unity = read_json(UNITY_JSON, {})
    metrics = capture_metrics(CAPTURE)
    classified = classify(unity_exit_code, unity, metrics)
    actor_csv = write_actor_csv(classified["actors"])

    result = {
        "verdict": "clip05 actor motion not reproduced",
        "visual_status": classified["visual_status"],
        "isFinalRestoredBattleScreen": False,
        "reference_video_used": True,
        "videoTimeRangeSeconds": "485.0-487.0",
        "referenceFrameCount": len(frames),
        "referenceMotionPairs": motion_pairs(frames),
        "actorMotionReplayed": classified["actorMotionReplayed"],
        "unityExitCode": unity_exit_code,
        "sceneExists": SCENE.exists(),
        "captureMetrics": metrics,
        "runtimeTypePresence": classified["runtime"],
        "skeletonAnimationComponentCount": classified["skeletonAnimationComponentCount"],
        "initializeCalledCount": classified["initializeCalledCount"],
        "afterInitializeValidCount": classified["afterInitializeValidCount"],
        "animationStateSetSucceededCount": classified["animationStateSetSucceededCount"],
        "updateFloatCalledCount": classified["updateFloatCalledCount"],
        "skeletonDataNullCount": classified["skeletonDataNullCount"],
        "meshGeneratorNonNullCount": classified["meshGeneratorNonNullCount"],
        "meshHashChangedActorCount": classified["meshHashChangedActorCount"],
        "unsupportedShaderMaterialCount": classified["unsupportedShaderMaterialCount"],
        "actors": classified["actors"],
        "unityProbe": unity,
        "blocker": classified["blocker"],
        "nextBlocker": classified["nextBlocker"],
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "unityDataJson": str(UNITY_OUT_JSON),
            "unityProbeJson": str(UNITY_JSON),
            "componentCsv": str(UNITY_COMPONENT_CSV),
            "actorCsv": str(actor_csv),
            "capture": str(CAPTURE),
            "contactSheet": str(CONTACT),
            "videoSequence": str(VIDEO_SEQUENCE),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "No fake material, fake animation, or coordinate-only visual correction was applied.",
            "Clip05 485.0-487.0s video sequence remains the gate; static/magenta capture is failure.",
            "No root CMD or _restore_tools direct CMD was created for BATTLE_36.",
        ],
    }
    make_contact(result, frames)

    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    UNITY_OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    actors = result["actors"]
    md = [
        "# BATTLE_36 Trace Real Spine Initialize SkeletonData Material Shader Binding Result",
        "",
        "**원본 clip05 actor motion은 아직 재현 안 됐다.** clip05 485.0-487.0s sequence를 기준으로, 현재 probe는 최종 전투 화면이나 원본 actor motion 성공으로 볼 수 없다.",
        "",
        "## Verdict",
        f"- visual_status: `{result['visual_status']}`",
        "- final screen claim: `false`",
        f"- reference video used: `{result['reference_video_used']}` (`플레이.mp4` 485.0-487.0s, frames `{len(frames)}`)",
        f"- actor motion replayed: `{result['actorMotionReplayed']}`",
        f"- Unity exit code: `{unity_exit_code}`",
        f"- capture magenta ratio: `{metrics.get('magentaPixelRatio')}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Runtime State",
        f"- real runtime present: `{result['runtimeTypePresence'].get('realRuntimePresent')}`",
        f"- SkeletonAnimation components: `{result['skeletonAnimationComponentCount']}` / `3`",
        f"- Initialize called / valid: `{result['initializeCalledCount']}` / `{result['afterInitializeValidCount']}`",
        f"- SkeletonData null count: `{result['skeletonDataNullCount']}`",
        f"- MeshGenerator non-null count: `{result['meshGeneratorNonNullCount']}`",
        f"- AnimationState SetAnimation success: `{result['animationStateSetSucceededCount']}` / `3`",
        f"- Update(float) called: `{result['updateFloatCalledCount']}` / `3`",
        f"- mesh hash changed actors: `{result['meshHashChangedActorCount']}` / `3`",
        f"- unsupported shader material count: `{result['unsupportedShaderMaterialCount']}`",
        "",
        "## Actor Trace",
    ]
    for actor in actors:
        md.append(
            f"- `{actor.get('heroDid')}` model `{actor.get('modelId')}`: anim used `{actor.get('animationStateUsedName')}`, "
            f"SkeletonData `{actor.get('skeletonDataAssetName')}`, bones/slots/anims `{actor.get('boneCount')}`/`{actor.get('slotCount')}`/`{actor.get('animationCount')}`, "
            f"expected in runtime `{actor.get('expectedAnimationInRuntime')}`, mesh hash changes `{actor.get('meshHashChangedFrameCount')}`, "
            f"status `{actor.get('motionReplayStatus')}`"
        )
    md.extend([
        "",
        "## Blocker",
        f"- {result['blocker']}",
        "- Magenta/static output was not hidden by arbitrary material, and no fake animation was generated.",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_OUT_JSON}`",
        f"- Unity probe JSON: `{UNITY_JSON}`",
        f"- component CSV: `{UNITY_COMPONENT_CSV}`",
        f"- actor CSV: `{actor_csv}`",
        f"- capture: `{CAPTURE}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Command Policy Check",
        f"- root CMD count: `{result['rootCmdCount']}`",
        f"- `_restore_tools` direct CMD count: `{result['restoreToolsDirectCmdCount']}`",
        "",
        "## Next Blocker",
        f"- `{result['nextBlocker']}`",
    ])
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(json.dumps({
        "visual_status": result["visual_status"],
        "actorMotionReplayed": result["actorMotionReplayed"],
        "unityExitCode": unity_exit_code,
        "skeletonAnimationComponentCount": result["skeletonAnimationComponentCount"],
        "afterInitializeValidCount": result["afterInitializeValidCount"],
        "animationStateSetSucceededCount": result["animationStateSetSucceededCount"],
        "updateFloatCalledCount": result["updateFloatCalledCount"],
        "meshHashChangedActorCount": result["meshHashChangedActorCount"],
        "magentaPixelRatio": metrics.get("magentaPixelRatio"),
        "nextBlocker": result["nextBlocker"],
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
