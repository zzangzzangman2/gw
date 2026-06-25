import json
import os
from pathlib import Path

import cv2
import numpy as np
from PIL import Image, ImageDraw

BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")

UNITY_PROBE_JSON = UNITY_DATA / "BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_UNITY.json"
COMPONENT_CSV = UNITY_DATA / "BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_COMPONENTS.csv"
B30_JSON = REPORT_DIR / "BATTLE_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE_RESULT.json"
B31_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle31ActorSpineAnimationRuntimeProbe_1920x1080.png"

OUT_MD = REPORT_DIR / "BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_RESULT.json"
UNITY_OUT_JSON = UNITY_DATA / "BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE.json"
CONTACT = REPORT_DIR / "BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_CONTACT_SHEET.jpg"
VIDEO_SEQUENCE = REPORT_DIR / "BATTLE_31_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg"

LUA_ROOT = BASE / "girlswar_merged_extracted" / "decoded" / "xlua_battle"
IL2CPP_STRINGS = BASE / "girlswar_merged_extracted" / "extracted" / "il2cpp_dump" / "stringliteral.json"

LUA_KEYWORDS = [
    "HeroCtrl:InitViewWith",
    "HeroCtrl:OnOpen",
    "PlayAnimation",
    "SetAnimationSpeed",
    "SetTimelineEffect",
    "BattleTimeline",
    "InitTimeline",
    "spineAnim",
    "SysPrefabId.HeroCtrl",
    "HeroBattleInfo",
]
IL2CPP_KEYWORDS = [
    "SkeletonAnimation",
    "SkeletonData",
    "NewSkeletonAnimationGameObject",
    "PlayAnimation",
    "SetAnimationSpeed",
    "SetTimelineEffect",
    "AnimationState",
    "spinematandshaders",
    "Timeline",
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


def frame_row(frames):
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


def motion_summary(frames):
    counts = []
    for a, b in zip(frames, frames[1:]):
        prev = cv2.cvtColor(a["bgr"], cv2.COLOR_BGR2GRAY)
        curr = cv2.cvtColor(b["bgr"], cv2.COLOR_BGR2GRAY)
        diff = cv2.absdiff(prev, curr)
        _, mask = cv2.threshold(diff, 20, 255, cv2.THRESH_BINARY)
        changed = int(np.count_nonzero(mask))
        counts.append({"pair": f"{a['t']:.1f}-{b['t']:.1f}", "changedPixels": changed})
    return counts


def make_contact(summary, frames):
    top = frame_row(frames)
    VIDEO_SEQUENCE.parent.mkdir(parents=True, exist_ok=True)
    top.save(VIDEO_SEQUENCE, quality=92)

    capture_panel = Image.new("RGB", (960, 560), (8, 8, 8))
    if B31_CAPTURE.exists():
        cap = Image.open(B31_CAPTURE).convert("RGB")
        cap.thumbnail((940, 500), Image.Resampling.LANCZOS)
        capture_panel.paste(cap, (10, 0))
    d = ImageDraw.Draw(capture_panel)
    d.text((10, 510), "BATTLE_31 static actor prefab probe capture: no debug/path labels in capture", fill=(245, 245, 245))
    d.text((10, 532), f"motion replay: {summary['actorMotionReplayed']} / visual_status: {summary['visual_status']}", fill=(255, 210, 120))

    text_panel = Image.new("RGB", (960, 560), (8, 8, 8))
    td = ImageDraw.Draw(text_panel)
    lines = [
        "BATTLE_31 summary",
        f"verdict: {summary['verdict']}",
        f"bundle load: {summary['unitySummary'].get('bundleLoadSuccess')}",
        f"prefab instantiate: {summary['unitySummary'].get('prefabInstantiateSuccess')}",
        f"missing scripts: {summary['unitySummary'].get('missingScriptCount')}",
        f"skeleton-like assets: {summary['unitySummary'].get('skeletonLikeAssetCount')}",
        f"animation candidates: {summary['unitySummary'].get('animationCandidateAssetCount')}",
        f"timeline candidates: {summary['unitySummary'].get('timelineCandidateAssetCount')}",
        f"Lua evidence lines: {len(summary['luaEvidence'])}",
        f"IL2CPP string hits: {len(summary['il2cppStringEvidence'])}",
        "Still not final: original clip05 actor motion is not replayed.",
    ]
    y = 20
    for line in lines:
        td.text((20, y), line, fill=(235, 235, 235))
        y += 30

    sheet = Image.new("RGB", (1920, 180 + 560), (0, 0, 0))
    sheet.paste(top, (0, 0))
    sheet.paste(capture_panel, (0, 180))
    sheet.paste(text_panel, (960, 180))
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT, quality=92)


def collect_lua_evidence(limit=80):
    hits = []
    if not LUA_ROOT.exists():
        return hits
    priority_names = ("HeroCtrl", "ProcedureNormalBattle", "BattlePreview", "HeroBattleInfo", "BattleTimeline")
    files = []
    for path in LUA_ROOT.rglob("*.lua"):
        name = path.name.lower()
        score = sum(1 for p in priority_names if p.lower() in name)
        if score or "battle" in str(path).lower():
            files.append((0 if score else 1, path))
    for _, path in sorted(files, key=lambda x: (x[0], str(x[1])))[:1200]:
        try:
            text = path.read_text(encoding="utf-8", errors="ignore").splitlines()
        except Exception:
            continue
        for idx, line in enumerate(text, start=1):
            if any(k.lower() in line.lower() for k in LUA_KEYWORDS):
                hits.append({
                    "path": str(path),
                    "line": idx,
                    "text": line.strip()[:240],
                })
                if len(hits) >= limit:
                    return hits
    return hits


def collect_il2cpp_evidence(limit=80):
    hits = []
    if not IL2CPP_STRINGS.exists():
        return hits
    try:
        data = json.loads(IL2CPP_STRINGS.read_text(encoding="utf-8", errors="ignore"))
    except Exception:
        return hits
    for item in data:
        value = str(item.get("value", ""))
        if any(k.lower() in value.lower() for k in IL2CPP_KEYWORDS):
            hits.append({
                "index": item.get("index"),
                "value": value[:240],
            })
            if len(hits) >= limit:
                break
    return hits


def main():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    UNITY_DATA.mkdir(parents=True, exist_ok=True)
    unity = read_json(UNITY_PROBE_JSON, {})
    b30 = read_json(B30_JSON, {})
    frames = extract_frames()
    if not frames:
        raise SystemExit("could not extract play.mp4 clip05 485-487s frames")

    lua_evidence = collect_lua_evidence()
    il2cpp_evidence = collect_il2cpp_evidence()
    unity_summary = unity.get("summary", {})
    missing_scripts = int(unity_summary.get("missingScriptCount") or 0)
    animation_candidates = int(unity_summary.get("animationCandidateAssetCount") or 0)
    timeline_candidates = int(unity_summary.get("timelineCandidateAssetCount") or 0)
    prefab_count = int(unity_summary.get("prefabInstantiateSuccess") or 0)

    actor_motion_replayed = False
    visual_status = "failed_actor_motion_runtime_replay_missing"
    if prefab_count <= 0:
        visual_status = "failed_actor_prefab_instantiate_missing"
    elif missing_scripts > 0:
        visual_status = "failed_missing_spine_animation_runtime_class"

    summary = {
        "verdict": "아직 원본 clip05 actor motion 재현 아님",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "reference_video_used": True,
        "videoTimeRangeSeconds": "485.0-487.0",
        "referenceFrameCount": len(frames),
        "referenceMotionPairs": motion_summary(frames),
        "actorMotionReplayed": actor_motion_replayed,
        "debugOverlayInFinalCapture": False,
        "battle30ActorGap": b30.get("actorGap", {}).get("centerDistanceNorm"),
        "battle30CardGap": b30.get("cardGap", {}).get("centerDistanceNorm"),
        "unityProbe": unity,
        "unitySummary": unity_summary,
        "luaEvidence": lua_evidence,
        "il2cppStringEvidence": il2cpp_evidence,
        "runtimeClassCandidates": [
            "Spine.Unity.SkeletonAnimation",
            "Spine.Unity.SkeletonRenderer",
            "Spine.Unity.SkeletonMecanim",
            "Spine.Unity.SkeletonDataAsset",
            "Spine.AnimationState",
            "BattleTimeline / SetTimelineEffect Lua bridge",
        ],
        "blocker": "3개 actor prefab은 로드/instantiate되지만 원본 Spine SkeletonAnimation/SkeletonDataAsset runtime class와 HeroCtrl/Timeline animation-state replay가 연결되지 않아 clip05 actor motion이 재현되지 않는다.",
        "nextBlocker": "BATTLE_32_RESOLVE_BATTLE_ACTOR_SPINE_RUNTIME_CLASS_AND_IDLE_MOTION_REPLAY",
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "unityDataJson": str(UNITY_OUT_JSON),
            "unityProbeJson": str(UNITY_PROBE_JSON),
            "componentCsv": str(COMPONENT_CSV),
            "capture": str(B31_CAPTURE),
            "contactSheet": str(CONTACT),
            "videoSequence": str(VIDEO_SEQUENCE),
        },
        "notes": [
            "BATTLE_31 uses the play.mp4 clip05 485.0-487.0s sequence as the visual/motion gate.",
            "The probe capture contains static loaded actor prefabs only; no evidence/debug/path text is added to that capture.",
            "The analysis contact sheet may contain labels, but it is not a final battle capture.",
            "No fake actor animation or coordinate-only motion was created.",
        ],
    }
    make_contact(summary, frames)
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    UNITY_OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    actors = unity.get("actors", [])
    md = [
        "# BATTLE_31 Actor Spine Animation Runtime Probe Result",
        "",
        "**아직 원본 clip05 actor motion 재현 아님.** 3개 actor prefab은 로드/instantiate되지만, 원본 Spine runtime class와 Lua `HeroCtrl`/timeline replay가 아직 연결되지 않았다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- reference video sequence: `플레이.mp4` 485.0-487.0s, frames `{len(frames)}`",
        f"- actor motion replayed: `{actor_motion_replayed}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Unity Actor Probe",
        f"- bundle load success: `{unity_summary.get('bundleLoadSuccess')}`",
        f"- prefab instantiate success: `{unity_summary.get('prefabInstantiateSuccess')}`",
        f"- component rows: `{unity_summary.get('componentRowCount')}`",
        f"- missing scripts: `{unity_summary.get('missingScriptCount')}`",
        f"- skeleton-like assets: `{unity_summary.get('skeletonLikeAssetCount')}`",
        f"- animation candidate assets: `{unity_summary.get('animationCandidateAssetCount')}`",
        f"- timeline candidate assets: `{unity_summary.get('timelineCandidateAssetCount')}`",
        "",
        "## Actor Details",
    ]
    for actor in actors:
        md.append(
            f"- `{actor.get('side')}` heroDid `{actor.get('heroDid')}` model `{actor.get('modelId')}`: "
            f"loaded `{actor.get('bundleLoaded')}`, instantiated `{actor.get('prefabInstantiated')}`, "
            f"missingScript `{actor.get('missingScriptCount')}`, skeletonAssets `{len(actor.get('skeletonLikeAssets', []))}`, "
            f"skelBytes `{actor.get('skelBytes')}`, atlasFirstLine `{actor.get('atlasFirstLine')}`"
        )
    md.extend([
        "",
        "## Runtime Class / Lua Evidence",
        f"- Lua evidence lines: `{len(lua_evidence)}`",
        f"- IL2CPP string hits: `{len(il2cpp_evidence)}`",
        "- runtime class candidates: `Spine.Unity.SkeletonAnimation`, `SkeletonRenderer`, `SkeletonMecanim`, `SkeletonDataAsset`, `Spine.AnimationState`, `BattleTimeline/SetTimelineEffect`",
        "",
        "## Blocker",
        f"- {summary['blocker']}",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_OUT_JSON}`",
        f"- Unity probe JSON: `{UNITY_PROBE_JSON}`",
        f"- component CSV: `{COMPONENT_CSV}`",
        f"- static probe capture: `{B31_CAPTURE}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Next Blocker",
        f"- `{summary['nextBlocker']}`",
    ])
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(json.dumps({
        "visual_status": visual_status,
        "actorMotionReplayed": actor_motion_replayed,
        "bundleLoadSuccess": unity_summary.get("bundleLoadSuccess"),
        "prefabInstantiateSuccess": unity_summary.get("prefabInstantiateSuccess"),
        "missingScriptCount": unity_summary.get("missingScriptCount"),
        "skeletonLikeAssetCount": unity_summary.get("skeletonLikeAssetCount"),
        "contactSheet": str(CONTACT),
        "nextBlocker": summary["nextBlocker"],
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
