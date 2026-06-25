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

UNITY_JSON = UNITY_DATA / "BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS_UNITY.json"
UNITY_COMPONENT_CSV = UNITY_DATA / "BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS_UNITY_COMPONENTS.csv"
CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle34SpineAnimationStateShaderRenderProbe_1920x1080.png"

OUT_MD = REPORT_DIR / "BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS_RESULT.json"
UNITY_OUT_JSON = UNITY_DATA / "BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS.json"
OUT_CSV = UNITY_DATA / "BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS_COMPONENTS.csv"
CONTACT = REPORT_DIR / "BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS_CONTACT_SHEET.jpg"
VIDEO_SEQUENCE = REPORT_DIR / "BATTLE_34_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg"

VENDOR_SPINE_PACKAGE = BASE / "_restore_tools" / "vendor" / "spine-unity-4.0-2024-08-21.unitypackage"
SPINE_STUB = PROJECT / "Assets" / "Scripts" / "BattleUIExternalStubs" / "SpineUnity" / "SpineActorRuntimeStubs.cs"

TARGETS = [
    {
        "side": "our",
        "heroDid": "1002",
        "modelId": "1002",
        "expectedAnimation": "ult",
        "bundle": "download/roleprefabsandres/battleprefabandres/1002.assetbundle",
        "bundlePath": BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "roleprefabsandres" / "battleprefabandres" / "1002.assetbundle",
    },
    {
        "side": "our",
        "heroDid": "1034",
        "modelId": "1034",
        "expectedAnimation": "skill1",
        "bundle": "download/roleprefabsandres/battleprefabandres/1034.assetbundle",
        "bundlePath": BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "roleprefabsandres" / "battleprefabandres" / "1034.assetbundle",
    },
    {
        "side": "enemy",
        "heroDid": "1100111",
        "modelId": "3001",
        "expectedAnimation": "attack",
        "bundle": "download/roleprefabsandres/battleprefabandres/3001.assetbundle",
        "bundlePath": BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "roleprefabsandres" / "battleprefabandres" / "3001.assetbundle",
    },
]


def read_json(path: Path, fallback):
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def pptr(value):
    if isinstance(value, dict):
        return {"fileID": value.get("m_FileID", 0), "pathID": value.get("m_PathID", 0)}
    return {"fileID": 0, "pathID": 0}


def ascii_hits(raw: bytes):
    if isinstance(raw, str):
        raw = raw.encode("latin1", "ignore")
    hits = []
    for m in re.finditer(rb"[A-Za-z0-9_./-]{3,}", raw or b""):
        s = m.group().decode("ascii", "ignore")
        if any(k in s.lower() for k in ["idle", "stand", "attack", "skill", "ult", "run", "walk", "die", "hit"]):
            hits.append(s)
    return hits


def atlas_region_count(text: str):
    if not text:
        return 0
    lines = [line.strip() for line in text.splitlines()]
    count = 0
    for i, line in enumerate(lines[:-1]):
        if not line or ":" in line or line.lower().endswith(".png"):
            continue
        if ":" in lines[i + 1]:
            count += 1
    return count


def shader_ref_from_material(data):
    shader = data.get("m_Shader") or {}
    return pptr(shader)


def texture_refs_from_material(data):
    refs = []
    props = data.get("m_SavedProperties") or {}
    for name, env in props.get("m_TexEnvs", []) or []:
        tex = (env or {}).get("m_Texture") or {}
        refs.append({"slot": name, **pptr(tex)})
    return refs


def trace_bundle(target):
    env = UnityPy.load(str(target["bundlePath"]))
    objects = {}
    for obj in env.objects:
        try:
            data = obj.read_typetree()
        except Exception:
            continue
        objects[obj.path_id] = {"type": obj.type.name, "data": data}

    rows = []
    scripts = {
        pid: o["data"]
        for pid, o in objects.items()
        if o["type"] == "MonoScript"
    }
    text_assets = {
        pid: o["data"]
        for pid, o in objects.items()
        if o["type"] == "TextAsset"
    }
    textures = {
        pid: o["data"]
        for pid, o in objects.items()
        if o["type"] == "Texture2D"
    }
    materials = {
        pid: o["data"]
        for pid, o in objects.items()
        if o["type"] == "Material"
    }

    skeleton_data_rows = []
    atlas_rows = []
    actor_rows = []
    for pid, obj in objects.items():
        if obj["type"] != "MonoBehaviour":
            continue
        data = obj["data"]
        script_ref = pptr(data.get("m_Script"))
        script = scripts.get(script_ref["pathID"], {})
        class_name = script.get("m_ClassName", "")
        namespace = script.get("m_Namespace", "")
        full_name = ".".join([p for p in [namespace, class_name] if p])
        if full_name == "Spine.Unity.SkeletonAnimation":
            actor_rows.append({"pathID": pid, "data": data, "script": script, "scriptRef": script_ref})
        if full_name == "Spine.Unity.SkeletonDataAsset":
            skeleton_data_rows.append({"pathID": pid, "data": data, "script": script, "scriptRef": script_ref})
        if full_name == "Spine.Unity.SpineAtlasAsset":
            atlas_rows.append({"pathID": pid, "data": data, "script": script, "scriptRef": script_ref})

    for srow in skeleton_data_rows:
        data = srow["data"]
        skel_ref = pptr(data.get("skeletonJSON"))
        skel_data = text_assets.get(skel_ref["pathID"], {})
        raw = skel_data.get("m_Script", b"")
        hits = ascii_hits(raw)
        atlas_refs = [pptr(x) for x in data.get("atlasAssets", []) or []]
        mat_refs = []
        atlas_names = []
        atlas_region_total = 0
        atlas_text_bytes = 0
        texture_names = []
        material_names = []
        material_shader_refs = []
        material_texture_refs = []
        for aref in atlas_refs:
            atlas = objects.get(aref["pathID"], {}).get("data", {})
            atlas_names.append(atlas.get("m_Name", ""))
            atlas_file_ref = pptr(atlas.get("atlasFile"))
            atlas_text = text_assets.get(atlas_file_ref["pathID"], {})
            atlas_text_value = atlas_text.get("m_Script", "")
            if isinstance(atlas_text_value, bytes):
                try:
                    atlas_text_value = atlas_text_value.decode("utf-8", "ignore")
                except Exception:
                    atlas_text_value = ""
            atlas_text_bytes += len(atlas_text_value or "")
            atlas_region_total += atlas_region_count(atlas_text_value)
            for mref in atlas.get("materials", []) or []:
                m = pptr(mref)
                mat_refs.append(m)
                mat = materials.get(m["pathID"], {})
                material_names.append(mat.get("m_Name", ""))
                material_shader_refs.append(shader_ref_from_material(mat))
                for tref in texture_refs_from_material(mat):
                    material_texture_refs.append(tref)
                    if tref["fileID"] == 0 and tref["pathID"] in textures:
                        tex = textures[tref["pathID"]]
                        texture_names.append(f"{tex.get('m_Name')}({tex.get('m_Width')}x{tex.get('m_Height')})")

        actor_for_skeleton = [
            a for a in actor_rows
            if pptr(a["data"].get("skeletonDataAsset"))["pathID"] == srow["pathID"]
        ]
        expected = target["expectedAnimation"]
        rows.append({
            "side": target["side"],
            "heroDid": target["heroDid"],
            "modelId": target["modelId"],
            "bundle": target["bundle"],
            "bundleExists": target["bundlePath"].exists(),
            "bundleFileSize": target["bundlePath"].stat().st_size if target["bundlePath"].exists() else 0,
            "skeletonDataPathID": srow["pathID"],
            "skeletonDataName": data.get("m_Name", ""),
            "skeletonJsonPathID": skel_ref["pathID"],
            "skeletonTextAssetName": skel_data.get("m_Name", ""),
            "skeletonBytes": len(raw or b""),
            "skeletonScale": data.get("scale", ""),
            "expectedAnimation": expected,
            "expectedAnimationInSkel": expected in hits,
            "animationEvidence": ";".join(dict.fromkeys(hits[:80])),
            "atlasAssetPathIDs": ";".join(str(x["pathID"]) for x in atlas_refs),
            "atlasNames": ";".join(atlas_names),
            "atlasTextBytes": atlas_text_bytes,
            "atlasRegionCount": atlas_region_total,
            "materialPathIDs": ";".join(str(x["pathID"]) for x in mat_refs),
            "materialNames": ";".join(material_names),
            "materialShaderRefs": json.dumps(material_shader_refs, ensure_ascii=False),
            "materialTextureRefs": json.dumps(material_texture_refs, ensure_ascii=False),
            "textureNames": ";".join(dict.fromkeys(texture_names)),
            "actorMonoBehaviourPathIDs": ";".join(str(a["pathID"]) for a in actor_for_skeleton),
            "actorSerializedAnimationNames": ";".join(str(a["data"].get("_animationName", "")) for a in actor_for_skeleton),
        })
    return rows


def write_csv(rows):
    OUT_CSV.parent.mkdir(parents=True, exist_ok=True)
    fields = [
        "side", "heroDid", "modelId", "bundle", "bundleExists", "bundleFileSize",
        "skeletonDataPathID", "skeletonDataName", "skeletonJsonPathID", "skeletonTextAssetName",
        "skeletonBytes", "skeletonScale", "expectedAnimation", "expectedAnimationInSkel",
        "animationEvidence", "atlasAssetPathIDs", "atlasNames", "atlasTextBytes",
        "atlasRegionCount", "materialPathIDs", "materialNames", "materialShaderRefs",
        "materialTextureRefs", "textureNames", "actorMonoBehaviourPathIDs", "actorSerializedAnimationNames",
    ]
    with OUT_CSV.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for row in rows:
            writer.writerow({k: row.get(k, "") for k in fields})


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


def video_row(frames):
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
    top = video_row(frames)
    VIDEO_SEQUENCE.parent.mkdir(parents=True, exist_ok=True)
    top.save(VIDEO_SEQUENCE, quality=92)

    capture_panel = Image.new("RGB", (960, 560), (8, 8, 8))
    if CAPTURE.exists():
        cap = Image.open(CAPTURE).convert("RGB")
        cap.thumbnail((940, 500), Image.Resampling.LANCZOS)
        capture_panel.paste(cap, (10, 0))
    d = ImageDraw.Draw(capture_panel)
    d.text((10, 510), "BATTLE_34 probe capture: no debug/path labels; not a final battle screen", fill=(245, 245, 245))
    d.text((10, 532), f"motion={summary['actorMotionReplayed']} meshUpdated={summary['realMeshUpdatedCount']} magenta={summary['captureMetrics'].get('magentaPixelRatio')}", fill=(255, 210, 120))

    text_panel = Image.new("RGB", (960, 560), (8, 8, 8))
    td = ImageDraw.Draw(text_panel)
    lines = [
        "BATTLE_34 summary",
        f"verdict: {summary['verdict']}",
        f"visual_status: {summary['visual_status']}",
        f"skel refs: {summary['skeletonDataTraceCount']}",
        f"expected animation in skel: {summary['expectedAnimationInSkelCount']}/3",
        f"AnimationState set: {summary['animationStateSetSucceededCount']}/3",
        f"real mesh updated: {summary['realMeshUpdatedCount']}/3",
        f"runtime bridge: {summary['runtimeBridgeKindCounts']}",
        f"magenta ratio: {summary['captureMetrics'].get('magentaPixelRatio')}",
        "Still failed: clip05 actor motion is not reproduced.",
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
    frames = extract_frames()
    if not frames:
        raise SystemExit("could not extract play.mp4 clip05 485-487s frames")

    trace_rows = []
    for target in TARGETS:
        trace_rows.extend(trace_bundle(target))
    write_csv(trace_rows)

    unity_summary = unity.get("summary", {})
    actors = unity.get("actors", [])
    metrics = capture_metrics(CAPTURE)
    real_mesh_updated = int(unity_summary.get("realMeshUpdatedCount") or 0)
    animation_state_set = int(unity_summary.get("animationStateSetSucceededCount") or 0)
    skeleton_animation_count = int(unity_summary.get("skeletonAnimationComponentCount") or 0)
    mesh_vertices_after = int(unity_summary.get("meshVertexCountAfter") or 0)
    expected_in_skel = sum(1 for row in trace_rows if str(row.get("expectedAnimationInSkel")).lower() == "true")

    bridge_counts = {}
    for actor in actors:
        key = actor.get("runtimeBridgeKind", "unknown")
        bridge_counts[key] = bridge_counts.get(key, 0) + 1

    actor_motion_replayed = False
    visual_status = "failed_spine_animationstate_or_mesh_update_runtime_incomplete"
    if metrics.get("magentaPixelRatio", 0) > 0.01:
        visual_status = "failed_spine_shader_or_runtime_mesh_still_magenta"
    if real_mesh_updated == 0:
        visual_status = "failed_spine_animationstate_mesh_generator_missing"

    next_blocker = "BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS"
    blocker = (
        "Original skel/atlas/material/texture evidence exists, and expected animation names are exact-matched for 2/3 actors "
        "(3001 serialized animation is attack, while the binary string evidence exposes attackR-style candidates). "
        "The battle project still uses a proxy spine-unity assembly without SkeletonBinary/MeshGenerator, so AnimationState calls "
        "succeed only at proxy level and LateUpdate does not produce a real updated Spine mesh."
    )

    summary = {
        "verdict": "아직 원본 clip05 actor motion 재현 아님",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "reference_video_used": True,
        "videoTimeRangeSeconds": "485.0-487.0",
        "referenceFrameCount": len(frames),
        "referenceMotionPairs": motion_pairs(frames),
        "actorMotionReplayed": actor_motion_replayed,
        "skeletonDataTraceCount": len(trace_rows),
        "expectedAnimationInSkelCount": expected_in_skel,
        "skeletonAnimationComponentCount": skeleton_animation_count,
        "animationStateSetSucceededCount": animation_state_set,
        "realMeshUpdatedCount": real_mesh_updated,
        "meshVertexCountAfter": mesh_vertices_after,
        "runtimeBridgeKindCounts": bridge_counts,
        "captureMetrics": metrics,
        "vendorSpinePackage": {
            "path": str(VENDOR_SPINE_PACKAGE),
            "exists": VENDOR_SPINE_PACKAGE.exists(),
            "size": VENDOR_SPINE_PACKAGE.stat().st_size if VENDOR_SPINE_PACKAGE.exists() else 0,
        },
        "spineStub": {
            "path": str(SPINE_STUB),
            "exists": SPINE_STUB.exists(),
        },
        "shaderDependency": unity.get("shaderDependency", {}),
        "unityProbe": unity,
        "skelAtlasTraceRows": trace_rows,
        "blocker": blocker,
        "nextBlocker": next_blocker,
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "unityDataJson": str(UNITY_OUT_JSON),
            "unityProbeJson": str(UNITY_JSON),
            "traceCsv": str(OUT_CSV),
            "unityComponentCsv": str(UNITY_COMPONENT_CSV),
            "capture": str(CAPTURE),
            "contactSheet": str(CONTACT),
            "videoSequence": str(VIDEO_SEQUENCE),
        },
        "notes": [
            "No fake material, fake animation, or coordinate-only visual correction was applied.",
            "The capture contains no debug/path/evidence labels.",
            "Magenta/static output remains failure even when AnimationState proxy calls succeed.",
        ],
    }
    make_contact(summary, frames)
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    UNITY_OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_34 Reconstruct Spine AnimationState And Shader Render From Skel Atlas Result",
        "",
        "**아직 원본 clip05 actor motion 재현 아님.** 원본 `.skel/.atlas/png/material` evidence는 확인됐고 animation 이름은 2/3 exact match지만, 실제 Spine `SkeletonBinary/MeshGenerator/LateUpdate` 렌더 흐름은 아직 복원되지 않았다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- reference video sequence: `플레이.mp4` 485.0-487.0s, frames `{len(frames)}`",
        f"- actor motion replayed: `{actor_motion_replayed}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Runtime Probe",
        f"- SkeletonAnimation components: `{skeleton_animation_count}`",
        f"- AnimationState SetAnimation proxy success: `{animation_state_set}` / `3`",
        f"- real mesh updated count: `{real_mesh_updated}` / `3`",
        f"- mesh vertices after probe: `{mesh_vertices_after}`",
        f"- runtime bridge kind counts: `{bridge_counts}`",
        f"- magenta pixel ratio: `{metrics.get('magentaPixelRatio')}`",
        "",
        "## Skel / Atlas / Texture Evidence",
        f"- SkeletonData trace rows: `{len(trace_rows)}`",
        f"- expected animation name present in `.skel`: `{expected_in_skel}` / `3`",
        f"- vendor Spine 4 package exists: `{VENDOR_SPINE_PACKAGE.exists()}`",
        "",
        "## Actor Evidence",
    ]
    for row in trace_rows:
        md.append(
            f"- `{row['heroDid']}` model `{row['modelId']}`: skel `{row['skeletonTextAssetName']}` bytes `{row['skeletonBytes']}`, "
            f"expected animation `{row['expectedAnimation']}` present `{row['expectedAnimationInSkel']}`, "
            f"atlas regions `{row['atlasRegionCount']}`, material `{row['materialNames']}`, texture `{row['textureNames']}`"
        )
    md.extend([
        "",
        "## Blocker",
        f"- {blocker}",
        "- Shader/material evidence is recorded, but magenta/static rendering was not hidden with arbitrary material.",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_OUT_JSON}`",
        f"- trace CSV: `{OUT_CSV}`",
        f"- Unity probe JSON: `{UNITY_JSON}`",
        f"- Unity component CSV: `{UNITY_COMPONENT_CSV}`",
        f"- capture: `{CAPTURE}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Next Blocker",
        f"- `{next_blocker}`",
    ])
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(json.dumps({
        "visual_status": visual_status,
        "actorMotionReplayed": actor_motion_replayed,
        "skeletonDataTraceCount": len(trace_rows),
        "expectedAnimationInSkelCount": expected_in_skel,
        "skeletonAnimationComponentCount": skeleton_animation_count,
        "animationStateSetSucceededCount": animation_state_set,
        "realMeshUpdatedCount": real_mesh_updated,
        "meshVertexCountAfter": mesh_vertices_after,
        "magentaPixelRatio": metrics.get("magentaPixelRatio"),
        "contactSheet": str(CONTACT),
        "nextBlocker": next_blocker,
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
