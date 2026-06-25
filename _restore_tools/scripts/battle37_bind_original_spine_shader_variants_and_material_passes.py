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

UNITY_JSON = UNITY_DATA / "BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_UNITY.json"
MATERIAL_CSV = UNITY_DATA / "BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_MATERIALS.csv"
COMPONENT_CSV = UNITY_DATA / "BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_COMPONENTS.csv"
CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle37BindOriginalSpineShaderVariantsAndMaterialPasses_1920x1080.png"
SCENE = PROJECT / "Assets" / "Scenes" / "Battle37BindOriginalSpineShaderVariantsAndMaterialPasses.unity"

OUT_MD = REPORT_DIR / "BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_RESULT.json"
UNITY_OUT_JSON = UNITY_DATA / "BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES.json"
CONTACT = REPORT_DIR / "BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_CONTACT_SHEET.jpg"
VIDEO_SEQUENCE = REPORT_DIR / "BATTLE_37_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg"
UNITY_LOG = REPORT_DIR / "BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES.log"


def read_json(path: Path, fallback):
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def count_cmds(path: Path):
    return len(list(path.glob("*.cmd"))) if path.exists() else 0


def read_csv(path: Path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


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
    top = image_row(frames)
    top.save(VIDEO_SEQUENCE, quality=92)

    capture_panel = Image.new("RGB", (960, 560), (8, 8, 8))
    if CAPTURE.exists():
        cap = Image.open(CAPTURE).convert("RGB")
        cap.thumbnail((940, 500), Image.Resampling.LANCZOS)
        capture_panel.paste(cap, (10, 0))
    d = ImageDraw.Draw(capture_panel)
    d.text((10, 510), "BATTLE_37 runtime capture: no debug/path labels; not final battle screen", fill=(245, 245, 245))
    d.text((10, 532), f"motion={summary['actorMotionReplayed']} meshChanged={summary['meshHashChangedActorCount']} magenta={summary['captureMetrics'].get('magentaPixelRatio')}", fill=(255, 210, 120))

    text_panel = Image.new("RGB", (960, 560), (8, 8, 8))
    td = ImageDraw.Draw(text_panel)
    lines = [
        "BATTLE_37 summary",
        f"verdict: {summary['verdict']}",
        f"visual_status: {summary['visual_status']}",
        f"shader rebind applied: {summary['shaderRebindAppliedCount']}",
        f"unsupported before/after: {summary['unsupportedShaderBeforeCount']} / {summary['unsupportedShaderAfterCount']}",
        f"SetAnimation: {summary['animationStateSetSucceededCount']}/3",
        f"mesh hash changed: {summary['meshHashChangedActorCount']}/3",
        f"magenta ratio: {summary['captureMetrics'].get('magentaPixelRatio')}",
        f"next blocker: {summary['nextBlocker']}",
    ]
    y = 18
    for line in lines:
        td.text((20, y), line, fill=(235, 235, 235))
        y += 30

    sheet = Image.new("RGB", (1920, 740), (0, 0, 0))
    sheet.paste(top, (0, 0))
    sheet.paste(capture_panel, (0, 180))
    sheet.paste(text_panel, (960, 180))
    sheet.save(CONTACT, quality=92)


def classify(unity_exit_code, unity, material_rows, metrics):
    summary = unity.get("summary") or {}
    runtime = unity.get("runtimeTypePresence") or {}
    actors = unity.get("actors") or []

    shader_before = int(summary.get("unsupportedShaderMaterialBeforeCount") or 0)
    shader_after = int(summary.get("unsupportedShaderMaterialAfterCount") or 0)
    rebind_applied = int(summary.get("shaderRebindAppliedCount") or 0)
    same_name_supported = int(summary.get("sameNameProjectShaderSupportedCount") or 0)
    mesh_changed = int(summary.get("meshHashChangedActorCount") or 0)
    set_animation = int(summary.get("animationStateSetSucceededCount") or 0)
    magenta = float(metrics.get("magentaPixelRatio") or 0)
    actor_motion_replayed = False

    if unity_exit_code != 0:
        visual_status = "failed_unity_batch_or_compile"
        blocker = "Unity batch/probe did not complete, so shader/pass binding cannot be trusted."
        next_blocker = "BATTLE_38_FIX_BATTLE37_COMPILE_OR_BATCH_ERROR"
    elif rebind_applied == 0 and shader_before > 0:
        visual_status = "failed_same_name_supported_shader_not_found"
        blocker = "Original AssetBundle shader names remain unsupported and no same-name supported project shader was available for evidence-backed rebind."
        next_blocker = "BATTLE_38_IMPORT_OR_COMPILE_ORIGINAL_SPINE_SHADER_VARIANTS"
    elif rebind_applied > 0 and magenta > 0.01:
        visual_status = "failed_shader_rebind_applied_but_magenta_remains"
        blocker = "Same-name Spine shader rebind was applied, but magenta render evidence remains in capture."
        next_blocker = "BATTLE_38_TRACE_MATERIAL_KEYWORDS_RENDER_PIPELINE_AND_SUBSHADER_PASS_SELECTION"
    elif rebind_applied > 0 and mesh_changed == 3:
        visual_status = "failed_clip05_actor_motion_layout_not_yet_matched_after_shader_binding"
        blocker = "Shader/pass binding improved actor rendering evidence, but clip05 full actor layout/motion/timing is not yet matched."
        next_blocker = "BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05"
    elif mesh_changed < 3:
        visual_status = "failed_mesh_motion_regressed_after_shader_probe"
        blocker = "Shader/material probe regressed mesh update evidence."
        next_blocker = "BATTLE_38_REPAIR_SPINE_UPDATE_FLOW_AFTER_SHADER_BINDING"
    else:
        visual_status = "failed_runtime_state_inconclusive"
        blocker = "Shader/material state did not yield a conclusive user-visible clip05 match."
        next_blocker = "BATTLE_38_TRACE_SPINE_RENDER_PIPELINE_DEEPER"

    return {
        "runtime": runtime,
        "actors": actors,
        "materialRows": material_rows,
        "unsupportedShaderBeforeCount": shader_before,
        "unsupportedShaderAfterCount": shader_after,
        "sameNameProjectShaderSupportedCount": same_name_supported,
        "shaderRebindAppliedCount": rebind_applied,
        "animationStateSetSucceededCount": set_animation,
        "meshHashChangedActorCount": mesh_changed,
        "actorMotionReplayed": actor_motion_replayed,
        "visual_status": visual_status,
        "blocker": blocker,
        "nextBlocker": next_blocker,
    }


def verify(unity_exit_code: int):
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    UNITY_DATA.mkdir(parents=True, exist_ok=True)
    frames = extract_frames()
    unity = read_json(UNITY_JSON, {})
    material_rows = read_csv(MATERIAL_CSV)
    metrics = capture_metrics(CAPTURE)
    classified = classify(unity_exit_code, unity, material_rows, metrics)

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
        "unsupportedShaderBeforeCount": classified["unsupportedShaderBeforeCount"],
        "unsupportedShaderAfterCount": classified["unsupportedShaderAfterCount"],
        "sameNameProjectShaderSupportedCount": classified["sameNameProjectShaderSupportedCount"],
        "shaderRebindAppliedCount": classified["shaderRebindAppliedCount"],
        "animationStateSetSucceededCount": classified["animationStateSetSucceededCount"],
        "meshHashChangedActorCount": classified["meshHashChangedActorCount"],
        "actors": classified["actors"],
        "materialRows": classified["materialRows"],
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
            "materialCsv": str(MATERIAL_CSV),
            "componentCsv": str(COMPONENT_CSV),
            "capture": str(CAPTURE),
            "contactSheet": str(CONTACT),
            "videoSequence": str(VIDEO_SEQUENCE),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "No arbitrary unlit/material substitution was applied.",
            "Shader rebind, when present, used the original material shader name and only a same-name supported Spine project shader.",
            "Clip05 485.0-487.0s sequence remains the gate; non-magenta actor render alone is not a final battle screen.",
        ],
    }
    make_contact(result, frames)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    UNITY_OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_37 Bind Original Spine Shader Variants And Material Passes Result",
        "",
        "**원본 clip05 actor motion은 아직 재현 안 됐다.** shader/material rebind probe를 수행했지만, clip05 485.0-487.0s 전체 전투 actor motion/layout/timing 성공으로 보지 않는다.",
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
        "## Shader / Material Binding",
        f"- unsupported shader/material before: `{result['unsupportedShaderBeforeCount']}`",
        f"- unsupported shader/material after: `{result['unsupportedShaderAfterCount']}`",
        f"- same-name supported project shader count: `{result['sameNameProjectShaderSupportedCount']}`",
        f"- evidence-backed shader rebind applied: `{result['shaderRebindAppliedCount']}`",
        f"- mesh hash changed actors: `{result['meshHashChangedActorCount']}` / `3`",
        f"- AnimationState SetAnimation success: `{result['animationStateSetSucceededCount']}` / `3`",
        "",
        "## Actor Summary",
    ]
    for actor in result["actors"]:
        md.append(
            f"- `{actor.get('heroDid')}` model `{actor.get('modelId')}`: anim `{actor.get('animationStateUsedName')}`, "
            f"mesh hash changes `{actor.get('meshHashChangedFrameCount')}`, shader rebinds `{actor.get('shaderRebindAppliedCount')}`, "
            f"status `{actor.get('motionReplayStatus')}`"
        )
    md.extend([
        "",
        "## Blocker",
        f"- {result['blocker']}",
        "- No fake material, fake actor motion, or debug overlay was accepted as final output.",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_OUT_JSON}`",
        f"- Unity probe JSON: `{UNITY_JSON}`",
        f"- material CSV: `{MATERIAL_CSV}`",
        f"- component CSV: `{COMPONENT_CSV}`",
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
        "shaderRebindAppliedCount": result["shaderRebindAppliedCount"],
        "unsupportedShaderBeforeCount": result["unsupportedShaderBeforeCount"],
        "unsupportedShaderAfterCount": result["unsupportedShaderAfterCount"],
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
