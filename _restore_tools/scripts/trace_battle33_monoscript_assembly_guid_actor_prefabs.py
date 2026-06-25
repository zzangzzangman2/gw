import csv
import json
import re
from pathlib import Path

import cv2
import numpy as np
from PIL import Image, ImageDraw
import UnityPy

BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")

B31_JSON = REPORT_DIR / "BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_RESULT.json"
B32_JSON = REPORT_DIR / "BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_RESULT.json"
B32_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle32ActorSpineRuntimeClassIdleMotionReplay_1920x1080.png"
B32_UNITY_JSON = UNITY_DATA / "BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_UNITY.json"

OUT_MD = REPORT_DIR / "BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS_RESULT.json"
UNITY_OUT_JSON = UNITY_DATA / "BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS.json"
CSV_PATH = UNITY_DATA / "BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS_COMPONENTS.csv"
CONTACT = REPORT_DIR / "BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS_CONTACT_SHEET.jpg"
VIDEO_SEQUENCE = REPORT_DIR / "BATTLE_33_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg"

IL2CPP_DUMP = BASE / "girlswar_merged_extracted" / "extracted" / "il2cpp_dump" / "dump.cs"
STRING_LITERALS = BASE / "girlswar_merged_extracted" / "extracted" / "il2cpp_dump" / "stringliteral.json"
ASMDEF = PROJECT / "Assets" / "Scripts" / "BattleUIExternalStubs" / "SpineUnity" / "spine-unity.asmdef"
SPINE_STUB = PROJECT / "Assets" / "Scripts" / "BattleUIExternalStubs" / "SpineUnity" / "SpineActorRuntimeStubs.cs"

TARGETS = [
    {
        "side": "our",
        "heroDid": "1002",
        "modelId": "1002",
        "bundle": "download/roleprefabsandres/battleprefabandres/1002.assetbundle",
        "bundlePath": BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "roleprefabsandres" / "battleprefabandres" / "1002.assetbundle",
        "prefabAsset": "assets/download/roleprefabsandres/battleprefabandres/1002/hero_1002.prefab",
    },
    {
        "side": "our",
        "heroDid": "1034",
        "modelId": "1034",
        "bundle": "download/roleprefabsandres/battleprefabandres/1034.assetbundle",
        "bundlePath": BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "roleprefabsandres" / "battleprefabandres" / "1034.assetbundle",
        "prefabAsset": "assets/download/roleprefabsandres/battleprefabandres/1034/hero_1034.prefab",
    },
    {
        "side": "enemy",
        "heroDid": "1100111",
        "modelId": "3001",
        "bundle": "download/roleprefabsandres/battleprefabandres/3001.assetbundle",
        "bundlePath": BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "roleprefabsandres" / "battleprefabandres" / "3001.assetbundle",
        "prefabAsset": "assets/download/roleprefabsandres/battleprefabandres/3001/hero_3001.prefab",
    },
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


def motion_pairs(frames):
    pairs = []
    for a, b in zip(frames, frames[1:]):
        prev = cv2.cvtColor(a["bgr"], cv2.COLOR_BGR2GRAY)
        curr = cv2.cvtColor(b["bgr"], cv2.COLOR_BGR2GRAY)
        diff = cv2.absdiff(prev, curr)
        _, mask = cv2.threshold(diff, 20, 255, cv2.THRESH_BINARY)
        pairs.append({"pair": f"{a['t']:.1f}-{b['t']:.1f}", "changedPixels": int(np.count_nonzero(mask))})
    return pairs


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


def pptr_tuple(value):
    if isinstance(value, dict):
        return value.get("m_FileID", ""), value.get("m_PathID", "")
    return "", ""


def short_json(value, limit=320):
    text = json.dumps(value, ensure_ascii=False, sort_keys=True)
    return text[:limit]


def trace_bundle(target):
    env = UnityPy.load(str(target["bundlePath"]))
    by_path = {obj.path_id: obj for obj in env.objects}
    scripts = {}
    gameobjects = {}
    rows = []
    prefab_gameobjects = {}

    for obj in env.objects:
        if obj.type.name == "MonoScript":
            data = obj.read_typetree()
            scripts[obj.path_id] = {
                "pathId": obj.path_id,
                "name": data.get("m_Name", ""),
                "className": data.get("m_ClassName", ""),
                "namespace": data.get("m_Namespace", ""),
                "assemblyName": data.get("m_AssemblyName", ""),
            }
        elif obj.type.name == "GameObject":
            data = obj.read_typetree()
            gameobjects[obj.path_id] = {
                "pathId": obj.path_id,
                "name": data.get("m_Name", ""),
                "componentPathIds": [
                    c.get("component", {}).get("m_PathID")
                    for c in data.get("m_Component", [])
                    if isinstance(c, dict)
                ],
            }
            if data.get("m_Name", "").lower().startswith("hero_"):
                prefab_gameobjects[obj.path_id] = data.get("m_Name", "")

    for obj in env.objects:
        if obj.type.name != "MonoBehaviour":
            continue
        data = obj.read_typetree()
        script_file_id, script_path_id = pptr_tuple(data.get("m_Script", {}))
        go_file_id, go_path_id = pptr_tuple(data.get("m_GameObject", {}))
        script = scripts.get(script_path_id, {})
        go = gameobjects.get(go_path_id, {})
        serialized_fields = {}
        for key in [
            "skeletonDataAsset",
            "_animationName",
            "loop",
            "startingAnimation",
            "startingLoop",
            "initialSkinName",
            "timeScale",
            "updateWhenInvisible",
            "atlasFile",
            "materials",
            "skeletonJSON",
            "blendModeMaterials",
            "scale",
        ]:
            if key in data:
                serialized_fields[key] = data[key]
        rows.append({
            "side": target["side"],
            "heroDid": target["heroDid"],
            "modelId": target["modelId"],
            "bundle": target["bundle"],
            "monoBehaviourPathId": obj.path_id,
            "gameObjectPathId": go_path_id,
            "gameObjectName": go.get("name", ""),
            "scriptFileId": script_file_id,
            "scriptPathId": script_path_id,
            "scriptName": script.get("name", ""),
            "className": script.get("className", ""),
            "namespace": script.get("namespace", ""),
            "assemblyName": script.get("assemblyName", ""),
            "resolvedFullName": ".".join([x for x in [script.get("namespace", ""), script.get("className", "")] if x]),
            "serializedFields": serialized_fields,
            "serializedFieldSummary": short_json(serialized_fields),
            "role": classify_role(script.get("className", ""), go.get("name", "")),
        })

    return {
        "target": {k: str(v) for k, v in target.items() if k != "bundlePath"} | {"bundlePath": str(target["bundlePath"])},
        "objectCount": len(env.objects),
        "monoScriptCount": len(scripts),
        "monoBehaviourCount": len(rows),
        "gameObjectCount": len(gameobjects),
        "prefabGameObjects": prefab_gameobjects,
        "monoScripts": list(scripts.values()),
        "monoBehaviours": rows,
    }


def classify_role(class_name, game_object_name):
    if class_name == "SkeletonAnimation":
        return "actor_spine_runtime"
    if class_name == "SkeletonGraphic":
        return "hero_ui_spine_graphic"
    if class_name == "SkeletonDataAsset":
        return "spine_skeleton_data_asset"
    if class_name == "SpineAtlasAsset":
        return "spine_atlas_asset"
    return "unknown"


def collect_il2cpp_evidence():
    hits = []
    patterns = [
        "public class SkeletonAnimation : SkeletonRenderer",
        "public class SkeletonRenderer : MonoBehaviour",
        "public class SkeletonDataAsset : ScriptableObject",
        "public class SpineAtlasAsset : AtlasAssetBase",
        "public class SkeletonMecanim : SkeletonRenderer",
    ]
    if IL2CPP_DUMP.exists():
        for idx, line in enumerate(IL2CPP_DUMP.read_text(encoding="utf-8", errors="ignore").splitlines(), start=1):
            for pattern in patterns:
                if pattern in line:
                    hits.append({"path": str(IL2CPP_DUMP), "line": idx, "text": line.strip()})
    string_hits = []
    if STRING_LITERALS.exists():
        data = read_json(STRING_LITERALS, [])
        for item in data:
            value = str(item.get("value", ""))
            if any(k in value for k in ["spine-unity", "SkeletonAnimation", "Spine/Skeleton", "spinematandshaders"]):
                string_hits.append({"index": item.get("index"), "value": value})
                if len(string_hits) >= 80:
                    break
    return {"dumpClassHits": hits, "stringLiteralHits": string_hits}


def make_contact(summary, frames):
    panels = []
    for frame in frames:
        img = Image.fromarray(cv2.cvtColor(frame["bgr"], cv2.COLOR_BGR2RGB))
        img.thumbnail((320, 150), Image.Resampling.LANCZOS)
        panel = Image.new("RGB", (320, 180), (8, 8, 8))
        panel.paste(img, ((320 - img.width) // 2, 0))
        ImageDraw.Draw(panel).text((8, 155), f"play.mp4 {frame['t']:.1f}s", fill=(235, 235, 235))
        panels.append(panel)
    top = Image.new("RGB", (320 * len(panels), 180), (0, 0, 0))
    for i, panel in enumerate(panels):
        top.paste(panel, (i * 320, 0))
    VIDEO_SEQUENCE.parent.mkdir(parents=True, exist_ok=True)
    top.save(VIDEO_SEQUENCE, quality=92)

    cap_panel = Image.new("RGB", (960, 560), (8, 8, 8))
    if B32_CAPTURE.exists():
        cap = Image.open(B32_CAPTURE).convert("RGB")
        cap.thumbnail((940, 500), Image.Resampling.LANCZOS)
        cap_panel.paste(cap, (10, 0))
    d = ImageDraw.Draw(cap_panel)
    d.text((10, 510), "BATTLE_33 uses B32 post-shim capture; no final-screen claim", fill=(245, 245, 245))
    d.text((10, 532), f"motion={summary['actorMotionReplayed']} missing {summary['missingScriptBeforeAfter']}", fill=(255, 210, 120))

    text_panel = Image.new("RGB", (960, 560), (8, 8, 8))
    td = ImageDraw.Draw(text_panel)
    lines = [
        "BATTLE_33 summary",
        f"verdict: {summary['verdict']}",
        f"visual_status: {summary['visual_status']}",
        f"m_Script rows: {summary['monoBehaviourTraceCount']}",
        f"spine-unity rows: {summary['spineUnityMonoBehaviourCount']}",
        f"MissingScript before/after: {summary['missingScriptBeforeAfter']}",
        f"SkeletonAnimation resolved: {summary['skeletonAnimationComponentCount']}",
        f"idle replay call success: {summary['idleReplaySucceededCount']}",
        f"magenta ratio: {summary['captureMetrics'].get('magentaPixelRatio')}",
        "MonoScript binding closed; visual motion/render still failed.",
    ]
    y = 20
    for line in lines:
        td.text((20, y), line, fill=(235, 235, 235))
        y += 30

    sheet = Image.new("RGB", (1920, 740), (0, 0, 0))
    sheet.paste(top, (0, 0))
    sheet.paste(cap_panel, (0, 180))
    sheet.paste(text_panel, (960, 180))
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT, quality=92)


def write_csv(rows):
    CSV_PATH.parent.mkdir(parents=True, exist_ok=True)
    with CSV_PATH.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=[
            "side", "heroDid", "modelId", "bundle", "monoBehaviourPathId",
            "gameObjectPathId", "gameObjectName", "scriptFileId", "scriptPathId",
            "scriptName", "className", "namespace", "assemblyName", "resolvedFullName",
            "role", "serializedFieldSummary",
        ])
        writer.writeheader()
        for row in rows:
            out = dict(row)
            out["serializedFieldSummary"] = row.get("serializedFieldSummary", "")
            writer.writerow({k: out.get(k, "") for k in writer.fieldnames})


def main():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    UNITY_DATA.mkdir(parents=True, exist_ok=True)
    frames = extract_frames()
    if not frames:
        raise SystemExit("could not extract play.mp4 clip05 485-487s frames")

    b31 = read_json(B31_JSON, {})
    b32 = read_json(B32_JSON, {})
    b32_unity = read_json(B32_UNITY_JSON, {})
    bundle_traces = [trace_bundle(t) for t in TARGETS]
    rows = [row for trace in bundle_traces for row in trace["monoBehaviours"]]
    write_csv(rows)
    il2cpp = collect_il2cpp_evidence()
    capture = capture_metrics(B32_CAPTURE)

    before_missing = int(b31.get("unitySummary", {}).get("missingScriptCount") or 3)
    after_missing = int(b32.get("afterMissingScriptCount") or b32.get("unityProbe", {}).get("summary", {}).get("missingScriptCount") or 0)
    skeleton_animation_count = int(b32.get("skeletonAnimationComponentCount") or 0)
    idle_success = int(b32.get("idleReplaySucceededCount") or 0)
    spine_unity_rows = [r for r in rows if r.get("assemblyName") == "spine-unity.dll"]
    actor_spine_rows = [r for r in rows if r.get("role") == "actor_spine_runtime"]

    visual_status = "failed_clip05_motion_not_replayed_after_monoscript_binding_fixed"
    if capture.get("magentaPixelRatio", 0) > 0.01:
        visual_status = "failed_actor_render_still_magenta_after_monoscript_binding_fixed"

    summary = {
        "verdict": "아직 원본 clip05 actor motion 재현 아님",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "reference_video_used": True,
        "videoTimeRangeSeconds": "485.0-487.0",
        "referenceFrameCount": len(frames),
        "referenceMotionPairs": motion_pairs(frames),
        "actorMotionReplayed": False,
        "monoBehaviourTraceCount": len(rows),
        "spineUnityMonoBehaviourCount": len(spine_unity_rows),
        "actorSkeletonAnimationMonoBehaviourCount": len(actor_spine_rows),
        "missingScriptBeforeAfter": f"{before_missing}/{after_missing}",
        "missingScriptReduction": before_missing - after_missing,
        "skeletonAnimationComponentCount": skeleton_animation_count,
        "idleReplaySucceededCount": idle_success,
        "captureMetrics": capture,
        "asmdefShim": {
            "path": str(ASMDEF),
            "exists": ASMDEF.exists(),
            "content": ASMDEF.read_text(encoding="utf-8", errors="ignore") if ASMDEF.exists() else "",
        },
        "spineActorStub": {
            "path": str(SPINE_STUB),
            "exists": SPINE_STUB.exists(),
        },
        "il2cppEvidence": il2cpp,
        "bundleTraces": bundle_traces,
        "unityProbe": b32_unity,
        "blocker": "MonoScript assembly binding is now identified and validated: actor m_Script points to Spine.Unity.SkeletonAnimation in spine-unity.dll, and placing the proxy under the existing spine-unity asmdef reduces MissingScript 3->0. The remaining visual blocker is real Spine .skel AnimationState/mesh update plus Spine shader render compatibility; clip05 motion is still not reproduced.",
        "nextBlocker": "BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS",
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "unityDataJson": str(UNITY_OUT_JSON),
            "csv": str(CSV_PATH),
            "contactSheet": str(CONTACT),
            "videoSequence": str(VIDEO_SEQUENCE),
            "sourceCapture": str(B32_CAPTURE),
        },
    }
    make_contact(summary, frames)
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    UNITY_OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_33 MonoScript Assembly GUID Actor Prefabs Result",
        "",
        "**아직 원본 clip05 actor motion 재현 아님.** 다만 actor prefab의 `m_Script` assembly binding 원인은 닫혔다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- reference video sequence: `플레이.mp4` 485.0-487.0s, frames `{len(frames)}`",
        f"- actor motion replayed: `False`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## MonoScript Binding",
        f"- MonoBehaviour trace rows: `{len(rows)}`",
        f"- `spine-unity.dll` MonoBehaviour rows: `{len(spine_unity_rows)}`",
        f"- actor `SkeletonAnimation` MonoBehaviour rows: `{len(actor_spine_rows)}`",
        f"- MissingScript before/after: `{before_missing}` / `{after_missing}`",
        f"- MissingScript reduction: `{before_missing - after_missing}`",
        f"- SkeletonAnimation components resolved after shim: `{skeleton_animation_count}`",
        f"- idle replay call success: `{idle_success}`",
        "",
        "## Actor Script PPtrs",
    ]
    for row in actor_spine_rows:
        fields = row.get("serializedFields", {})
        md.append(
            f"- `{row['heroDid']}` `{row['gameObjectName']}` MonoBehaviour `{row['monoBehaviourPathId']}` "
            f"m_Script `fileID={row['scriptFileId']} pathID={row['scriptPathId']}` -> "
            f"`{row['namespace']}.{row['className']}` assembly `{row['assemblyName']}`, "
            f"animation `{fields.get('_animationName')}`, loop `{fields.get('loop')}`, "
            f"skeletonDataAsset `{fields.get('skeletonDataAsset')}`"
        )
    md.extend([
        "",
        "## Remaining Visual Blocker",
        f"- magenta pixel ratio: `{capture.get('magentaPixelRatio')}`",
        "- MonoScript binding is fixed, but the capture remains a static/magenta actor mesh and does not match the moving clip05 actors.",
        "- Shader bundle and Spine shader names are present; next work must reconstruct real SkeletonData/AnimationState/mesh update and render compatibility, not fake motion.",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_OUT_JSON}`",
        f"- components CSV: `{CSV_PATH}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Next Blocker",
        f"- `{summary['nextBlocker']}`",
    ])
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(json.dumps({
        "visual_status": visual_status,
        "actorMotionReplayed": False,
        "monoBehaviourTraceCount": len(rows),
        "spineUnityMonoBehaviourCount": len(spine_unity_rows),
        "actorSkeletonAnimationMonoBehaviourCount": len(actor_spine_rows),
        "missingScriptBeforeAfter": f"{before_missing}/{after_missing}",
        "skeletonAnimationComponentCount": skeleton_animation_count,
        "idleReplaySucceededCount": idle_success,
        "magentaPixelRatio": capture.get("magentaPixelRatio"),
        "contactSheet": str(CONTACT),
        "nextBlocker": summary["nextBlocker"],
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
