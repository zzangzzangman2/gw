import argparse
import csv
import json
import tarfile
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

VENDOR_PACKAGE = BASE / "_restore_tools" / "vendor" / "spine-unity-4.0-2024-08-21.unitypackage"
RUNTIME_ROOT = PROJECT / "Assets" / "Spine" / "Runtime"
STUB_ASMDEF = PROJECT / "Assets" / "Scripts" / "BattleUIExternalStubs" / "SpineUnity" / "spine-unity.asmdef"
STUB_ACTOR = PROJECT / "Assets" / "Scripts" / "BattleUIExternalStubs" / "SpineUnity" / "SpineActorRuntimeStubs.cs"
STUB_UI = PROJECT / "Assets" / "Scripts" / "BattleUIExternalStubs" / "SpineUnity" / "SpineUnityStubs.cs"

UNITY_JSON = UNITY_DATA / "BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_UNITY.json"
UNITY_COMPONENT_CSV = UNITY_DATA / "BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_UNITY_COMPONENTS.csv"
PREP_JSON = UNITY_DATA / "BATTLE_35_SPINE_RUNTIME_IMPORT_PREP.json"
CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle35RealSpineRuntimeMeshGeneratorProbe_1920x1080.png"

OUT_MD = REPORT_DIR / "BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_RESULT.json"
UNITY_OUT_JSON = UNITY_DATA / "BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS.json"
OUT_CSV = UNITY_DATA / "BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_COMPONENTS.csv"
CONTACT = REPORT_DIR / "BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_CONTACT_SHEET.jpg"
VIDEO_SEQUENCE = REPORT_DIR / "BATTLE_35_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg"
UNITY_LOG = REPORT_DIR / "BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS.log"

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


def prepare_runtime_import():
    UNITY_DATA.mkdir(parents=True, exist_ok=True)
    if not VENDOR_PACKAGE.exists():
        raise SystemExit(f"vendor package not found: {VENDOR_PACKAGE}")

    extracted = []
    skipped = []
    with tarfile.open(VENDOR_PACKAGE, "r:gz") as tar:
        dirs = sorted({m.name.split("/")[0] for m in tar.getmembers() if "/" in m.name})
        for directory in dirs:
            pathname = ""
            try:
                f = tar.extractfile(tar.getmember(f"{directory}/pathname"))
                pathname = f.read().decode("utf-8", "ignore") if f else ""
            except KeyError:
                continue
            if not pathname.startswith("Assets/Spine/Runtime"):
                continue
            if pathname.endswith("/"):
                continue
            dest = PROJECT / pathname.replace("/", "\\")
            try:
                member = tar.getmember(f"{directory}/asset")
            except KeyError:
                dest.mkdir(parents=True, exist_ok=True)
                skipped.append({"pathname": pathname, "reason": "directory_or_no_asset"})
                continue
            dest.parent.mkdir(parents=True, exist_ok=True)
            data = tar.extractfile(member).read()
            dest.write_bytes(data)
            extracted.append({"pathname": pathname, "bytes": len(data)})
            try:
                meta_member = tar.getmember(f"{directory}/asset.meta")
                meta_data = tar.extractfile(meta_member).read()
                Path(str(dest) + ".meta").write_bytes(meta_data)
            except KeyError:
                pass

    prep = {
        "vendorPackage": str(VENDOR_PACKAGE),
        "vendorPackageExists": VENDOR_PACKAGE.exists(),
        "vendorPackageSize": VENDOR_PACKAGE.stat().st_size if VENDOR_PACKAGE.exists() else 0,
        "runtimeRoot": str(RUNTIME_ROOT),
        "runtimeFileCount": len(extracted),
        "runtimeBytes": sum(row["bytes"] for row in extracted),
        "stubAsmdef": str(STUB_ASMDEF),
        "stubAsmdefContent": STUB_ASMDEF.read_text(encoding="utf-8", errors="ignore") if STUB_ASMDEF.exists() else "",
        "legacyProxyGuarded": {
            "SpineActorRuntimeStubs": file_contains(STUB_ACTOR, "BATTLE_USE_LEGACY_SPINE_PROXY"),
            "SpineUnityStubs": file_contains(STUB_UI, "BATTLE_USE_LEGACY_SPINE_PROXY"),
        },
        "sampleExtracted": extracted[:40],
        "skipped": skipped[:40],
    }
    PREP_JSON.write_text(json.dumps(prep, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({
        "runtimeFileCount": prep["runtimeFileCount"],
        "runtimeBytes": prep["runtimeBytes"],
        "runtimeRoot": prep["runtimeRoot"],
        "stubAsmdefContent": prep["stubAsmdefContent"],
    }, ensure_ascii=False, indent=2))


def file_contains(path: Path, text: str):
    return path.exists() and text in path.read_text(encoding="utf-8", errors="ignore")


def ascii_hits(raw):
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
    scripts = {pid: o["data"] for pid, o in objects.items() if o["type"] == "MonoScript"}
    text_assets = {pid: o["data"] for pid, o in objects.items() if o["type"] == "TextAsset"}
    textures = {pid: o["data"] for pid, o in objects.items() if o["type"] == "Texture2D"}
    materials = {pid: o["data"] for pid, o in objects.items() if o["type"] == "Material"}

    rows = []
    actor_rows = []
    skeleton_data_rows = []
    for pid, obj in objects.items():
        if obj["type"] != "MonoBehaviour":
            continue
        data = obj["data"]
        script_ref = pptr(data.get("m_Script"))
        script = scripts.get(script_ref["pathID"], {})
        full_name = ".".join([x for x in [script.get("m_Namespace", ""), script.get("m_ClassName", "")] if x])
        if full_name == "Spine.Unity.SkeletonAnimation":
            actor_rows.append({"pathID": pid, "data": data})
        if full_name == "Spine.Unity.SkeletonDataAsset":
            skeleton_data_rows.append({"pathID": pid, "data": data})

    for srow in skeleton_data_rows:
        data = srow["data"]
        skel_ref = pptr(data.get("skeletonJSON"))
        skel_data = text_assets.get(skel_ref["pathID"], {})
        raw = skel_data.get("m_Script", b"")
        hits = ascii_hits(raw)
        atlas_refs = [pptr(x) for x in data.get("atlasAssets", []) or []]
        material_names = []
        texture_names = []
        atlas_region_total = 0
        for aref in atlas_refs:
            atlas = objects.get(aref["pathID"], {}).get("data", {})
            atlas_file_ref = pptr(atlas.get("atlasFile"))
            atlas_text = text_assets.get(atlas_file_ref["pathID"], {})
            atlas_text_value = atlas_text.get("m_Script", "")
            if isinstance(atlas_text_value, bytes):
                atlas_text_value = atlas_text_value.decode("utf-8", "ignore")
            atlas_region_total += atlas_region_count(atlas_text_value)
            for mref in atlas.get("materials", []) or []:
                m = pptr(mref)
                mat = materials.get(m["pathID"], {})
                material_names.append(mat.get("m_Name", ""))
                for tref in texture_refs_from_material(mat):
                    if tref["fileID"] == 0 and tref["pathID"] in textures:
                        tex = textures[tref["pathID"]]
                        texture_names.append(f"{tex.get('m_Name')}({tex.get('m_Width')}x{tex.get('m_Height')})")
        actors = [a for a in actor_rows if pptr(a["data"].get("skeletonDataAsset"))["pathID"] == srow["pathID"]]
        rows.append({
            "side": target["side"],
            "heroDid": target["heroDid"],
            "modelId": target["modelId"],
            "bundle": target["bundle"],
            "skeletonDataPathID": srow["pathID"],
            "skeletonTextAssetName": skel_data.get("m_Name", ""),
            "skeletonBytes": len(raw or b""),
            "expectedAnimation": target["expectedAnimation"],
            "expectedAnimationInSkel": target["expectedAnimation"] in hits,
            "animationEvidence": ";".join(dict.fromkeys(hits[:80])),
            "atlasRegionCount": atlas_region_total,
            "materialNames": ";".join(dict.fromkeys(material_names)),
            "textureNames": ";".join(dict.fromkeys(texture_names)),
            "actorSerializedAnimationNames": ";".join(str(a["data"].get("_animationName", "")) for a in actors),
        })
    return rows


def write_csv(rows):
    OUT_CSV.parent.mkdir(parents=True, exist_ok=True)
    fields = [
        "side", "heroDid", "modelId", "bundle", "skeletonDataPathID",
        "skeletonTextAssetName", "skeletonBytes", "expectedAnimation",
        "expectedAnimationInSkel", "animationEvidence", "atlasRegionCount",
        "materialNames", "textureNames", "actorSerializedAnimationNames",
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
    d.text((10, 510), "BATTLE_35 probe capture: no debug/path labels; not a final battle screen", fill=(245, 245, 245))
    d.text((10, 532), f"motion={summary['actorMotionReplayed']} meshUpdated={summary['realMeshUpdatedCount']} magenta={summary['captureMetrics'].get('magentaPixelRatio')}", fill=(255, 210, 120))

    text_panel = Image.new("RGB", (960, 560), (8, 8, 8))
    td = ImageDraw.Draw(text_panel)
    lines = [
        "BATTLE_35 summary",
        f"verdict: {summary['verdict']}",
        f"visual_status: {summary['visual_status']}",
        f"real runtime: {summary['runtimeTypePresence'].get('realRuntimePresent')}",
        f"animation state set: {summary['animationStateSetSucceededCount']}/3",
        f"real mesh updated: {summary['realMeshUpdatedCount']}/3",
        f"magenta ratio: {summary['captureMetrics'].get('magentaPixelRatio')}",
        f"unity exit: {summary['unityExitCode']}",
        "Clip05 motion gate still decides the verdict.",
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


def verify(unity_exit_code: int):
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    UNITY_DATA.mkdir(parents=True, exist_ok=True)
    frames = extract_frames()
    if not frames:
        raise SystemExit("could not extract play.mp4 clip05 485-487s frames")

    prep = read_json(PREP_JSON, {})
    unity = read_json(UNITY_JSON, {})
    trace_rows = []
    for target in TARGETS:
        trace_rows.extend(trace_bundle(target))
    write_csv(trace_rows)

    runtime = unity.get("runtimeTypePresence", {})
    unity_summary = unity.get("summary", {})
    metrics = capture_metrics(CAPTURE)
    real_runtime_present = bool(runtime.get("realRuntimePresent"))
    animation_state_set = int(unity_summary.get("animationStateSetSucceededCount") or 0)
    real_mesh_updated = int(unity_summary.get("realMeshUpdatedCount") or 0)
    skeleton_animation_count = int(unity_summary.get("skeletonAnimationComponentCount") or 0)
    expected_in_skel = sum(1 for row in trace_rows if str(row.get("expectedAnimationInSkel")).lower() == "true")

    actor_motion_replayed = False
    visual_status = "failed_real_spine_runtime_not_compiled_or_not_loaded"
    if unity_exit_code == 0 and real_runtime_present and real_mesh_updated == 0:
        visual_status = "failed_real_spine_runtime_loaded_but_mesh_not_updated"
    if unity_exit_code == 0 and real_runtime_present and real_mesh_updated > 0:
        visual_status = "failed_clip05_actor_motion_not_verified_after_mesh_update"
    if metrics.get("magentaPixelRatio", 0) > 0.01:
        visual_status = "failed_spine_shader_or_runtime_mesh_still_magenta"

    if unity_exit_code != 0:
        blocker = "Vendor Spine runtime import did not complete Unity batch compilation/probe; inspect Unity log before claiming runtime replay."
        next_blocker = "BATTLE_36_FIX_SPINE_4_RUNTIME_IMPORT_COMPILE_OR_API_COMPATIBILITY"
    elif not real_runtime_present:
        blocker = "Unity probe ran, but real Spine runtime types were not present under spine-unity/spine-csharp."
        next_blocker = "BATTLE_36_FIX_SPINE_4_RUNTIME_ASSEMBLY_BINDING"
    elif real_mesh_updated == 0:
        blocker = "Real Spine runtime types are present, but the original AssetBundle actor instances did not show a changed mesh after AnimationState/LateUpdate probe."
        next_blocker = "BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING"
    else:
        blocker = "Mesh update evidence exists, but clip05 actor motion sequence is still not matched/proven."
        next_blocker = "BATTLE_36_VALIDATE_SPINE_ACTOR_MOTION_AGAINST_CLIP05_SEQUENCE"

    summary = {
        "verdict": "clip05 actor motion not reproduced",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "reference_video_used": True,
        "videoTimeRangeSeconds": "485.0-487.0",
        "referenceFrameCount": len(frames),
        "referenceMotionPairs": motion_pairs(frames),
        "actorMotionReplayed": actor_motion_replayed,
        "unityExitCode": unity_exit_code,
        "runtimeImportPrep": prep,
        "runtimeTypePresence": runtime,
        "skeletonDataTraceCount": len(trace_rows),
        "expectedAnimationInSkelCount": expected_in_skel,
        "skeletonAnimationComponentCount": skeleton_animation_count,
        "animationStateSetSucceededCount": animation_state_set,
        "realMeshUpdatedCount": real_mesh_updated,
        "captureMetrics": metrics,
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
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "No fake material, fake animation, or coordinate-only visual correction was applied.",
            "The capture must not be treated as success unless clip05 actor motion is visually/temporally matched.",
            "3001 serialized animation remains attack; skel string evidence includes attackR-style candidates.",
        ],
    }
    make_contact(summary, frames)
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    UNITY_OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_35 Import Or Reconstruct Real Spine 4 Runtime Mesh Generator For Actors Result",
        "",
        "**아직 원본 clip05 actor motion 재현 아님.** vendor Spine 4 runtime import/probe를 시도했지만, clip05 485.0-487.0s actor motion 성공 판정에는 도달하지 않았다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- reference video sequence: `플레이.mp4` 485.0-487.0s, frames `{len(frames)}`",
        f"- actor motion replayed: `{actor_motion_replayed}`",
        f"- Unity exit code: `{unity_exit_code}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Runtime Import / Probe",
        f"- imported runtime files: `{prep.get('runtimeFileCount')}`",
        f"- imported runtime bytes: `{prep.get('runtimeBytes')}`",
        f"- real runtime present: `{real_runtime_present}`",
        f"- runtime type presence: `{runtime}`",
        f"- SkeletonAnimation components: `{skeleton_animation_count}`",
        f"- AnimationState SetAnimation success: `{animation_state_set}` / `3`",
        f"- real mesh updated count: `{real_mesh_updated}` / `3`",
        f"- magenta pixel ratio: `{metrics.get('magentaPixelRatio')}`",
        "",
        "## Skel / Atlas / Texture Evidence",
        f"- SkeletonData trace rows: `{len(trace_rows)}`",
        f"- expected animation exact match in `.skel`: `{expected_in_skel}` / `3`",
    ]
    for row in trace_rows:
        md.append(
            f"- `{row['heroDid']}` model `{row['modelId']}`: skel `{row['skeletonTextAssetName']}` bytes `{row['skeletonBytes']}`, "
            f"expected `{row['expectedAnimation']}` present `{row['expectedAnimationInSkel']}`, "
            f"atlas regions `{row['atlasRegionCount']}`, material `{row['materialNames']}`, texture `{row['textureNames']}`"
        )
    md.extend([
        "",
        "## Blocker",
        f"- {blocker}",
        "- Magenta/static rendering was not hidden with arbitrary material, and no fake actor motion was generated.",
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
        "unityExitCode": unity_exit_code,
        "realRuntimePresent": real_runtime_present,
        "skeletonAnimationComponentCount": skeleton_animation_count,
        "animationStateSetSucceededCount": animation_state_set,
        "realMeshUpdatedCount": real_mesh_updated,
        "magentaPixelRatio": metrics.get("magentaPixelRatio"),
        "contactSheet": str(CONTACT),
        "nextBlocker": next_blocker,
    }, ensure_ascii=False, indent=2))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("mode", choices=["prepare", "verify"])
    parser.add_argument("--unity-exit", type=int, default=0)
    args = parser.parse_args()
    if args.mode == "prepare":
        prepare_runtime_import()
    else:
        verify(args.unity_exit)


if __name__ == "__main__":
    main()
