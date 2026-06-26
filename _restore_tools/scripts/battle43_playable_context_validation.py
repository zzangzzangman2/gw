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
PLAY_VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")

UNITY_JSON = UNITY_DATA / "BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_UNITY.json"
ROWS_CSV = UNITY_DATA / "BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_COMPONENTS.csv"
B42_JSON = REPORT_DIR / "BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES_RESULT.json"
PAYLOAD_JSON = UNITY_DATA / "BATTLE_TEST_PAYLOAD.json"
RESOURCE_INDEX = UNITY_DATA / "resource_index.csv"
TYPE_EVIDENCE = UNITY_DATA / "BATTLE_UI_COMPONENT_TYPE_EVIDENCE.csv"
B42_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle42PersistentBattleHudImagesFromOriginalSpriteEvidence_1920x1080.png"
B43_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle43PlayableContextValidationCandidate_1920x1080.png"

OUT_MD = REPORT_DIR / "BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_RESULT.json"
CONTACT = REPORT_DIR / "BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_CONTACT_SHEET.jpg"
PATCH_PLAN = REPORT_DIR / "BATTLE_43_MINIMAL_PLAYABLE_CONTEXT_PATCH_PLAN.md"
UNITY_LOG = REPORT_DIR / "BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING.log"


def read_json(path, fallback):
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def count_cmds(path):
    return len(list(path.glob("*.cmd"))) if path.exists() else 0


def capture_metrics(path):
    img = cv2.imread(str(path))
    if img is None:
        return {"captureExists": False}
    total = img.shape[0] * img.shape[1]
    return {
        "captureExists": True,
        "width": int(img.shape[1]),
        "height": int(img.shape[0]),
        "nonBlackPixelRatio": round(float(np.count_nonzero(np.any(img > 20, axis=2))) / total, 6),
    }


def image_similarity(a, b):
    ia = cv2.imread(str(a))
    ib = cv2.imread(str(b))
    if ia is None or ib is None:
        return {"available": False}
    if ia.shape != ib.shape:
        ib = cv2.resize(ib, (ia.shape[1], ia.shape[0]))
    diff = float(np.mean(np.abs(ia.astype(np.float32) - ib.astype(np.float32))) / 255.0)
    try:
        corr = float(np.corrcoef(ia.reshape(-1).astype(float), ib.reshape(-1).astype(float))[0, 1])
    except Exception:
        corr = 0.0
    return {"available": True, "meanAbsDiff": round(diff, 6), "pixelCorrelation": round(corr, 6)}


def payload_summary():
    payload = read_json(PAYLOAD_JSON, {})
    battle = payload.get("battleInfo", {})
    our = battle.get("ourHeros", [])
    waves = battle.get("waveData", [])
    enemy = []
    if waves:
        enemy = waves[0].get("enemyTeamFormation", [])
    return {
        "mapId": battle.get("mapId"),
        "battleType": battle.get("battleType"),
        "ourHeroCount": len(our),
        "ourHeroes": [
            {
                "heroDid": h.get("heroDid"),
                "heroId": h.get("heroId"),
                "curHp": h.get("curHp"),
                "curMp": h.get("curMp"),
                "skills": [s.get("skillDid") for s in h.get("skills", []) if s.get("skillDid")],
            }
            for h in our
        ],
        "ourTeamFormation": battle.get("ourTeamFormation", []),
        "waveCount": len(waves),
        "firstWaveEnemyFormation": enemy,
    }


def resource_summary(payload):
    rows = read_csv(RESOURCE_INDEX)
    hero_dids = {str(h.get("heroDid")) for h in payload.get("ourHeroes", [])}
    skill_ids = {str(s) for h in payload.get("ourHeroes", []) for s in h.get("skills", [])}
    relevant = []
    missing = []
    for row in rows:
        ref = row.get("referenced_by", "")
        bundle = row.get("bundle", "")
        exists = row.get("exists", "").lower() == "true"
        if any(h in ref for h in hero_dids) or any(s in ref for s in skill_ids) or row.get("kind") == "battle_map":
            relevant.append(row)
            if not exists:
                missing.append(row)
    return {
        "relevantBundleCount": len(relevant),
        "missingBundleCount": len(missing),
        "missingBundles": [m.get("bundle") for m in missing[:20]],
        "relevantBundles": relevant[:40],
    }


def type_evidence_summary():
    rows = read_csv(TYPE_EVIDENCE)
    keep = {}
    for r in rows:
        name = r.get("className")
        if name in {"GraphicRaycaster", "Button", "Mask", "RectMask2D", "TextMeshProUGUI", "Text", "CanvasScaler", "Image"}:
            keep[name] = {
                "fullName": r.get("fullName"),
                "likelyRole": r.get("likelyRole"),
                "monoBehaviourRefCount": r.get("monoBehaviourRefCount"),
                "scriptPathIds": r.get("scriptPathIds"),
                "bundles": r.get("bundles"),
                "luaEvidenceCount": r.get("luaEvidenceCount"),
            }
    return keep


def raycast_failure_summary():
    rows = read_csv(ROWS_CSV)
    misses = [r for r in rows if r.get("status") == "button_raycast_miss"]
    reasons = {}
    samples = []
    hit_counts = []
    for row in misses:
        evidence = row.get("evidence", "")
        reason = ""
        if "reason=" in evidence:
            reason = evidence.split("reason=", 1)[1].split(";", 1)[0].strip()
        reasons[reason or "unknown"] = reasons.get(reason or "unknown", 0) + 1
        hit_count = None
        if "hitCount=" in evidence:
            raw = evidence.split("hitCount=", 1)[1].split(";", 1)[0].strip()
            try:
                hit_count = int(raw)
                hit_counts.append(hit_count)
            except ValueError:
                pass
        if len(samples) < 8:
            samples.append({
                "path": row.get("path"),
                "rectSize": row.get("rectSize"),
                "canvasPath": row.get("canvasPath"),
                "evidence": evidence,
            })
    return {
        "missCount": len(misses),
        "reasonCounts": reasons,
        "allMissesHadZeroGraphicHits": bool(misses) and all(v == 0 for v in hit_counts) and len(hit_counts) == len(misses),
        "samples": samples,
    }


def panel(label, path, size=(640, 360)):
    img = cv2.imread(str(path))
    out = Image.new("RGB", size, (8, 8, 8))
    draw = ImageDraw.Draw(out)
    if img is not None:
        pil = Image.fromarray(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
        pil.thumbnail((size[0], size[1] - 28), Image.Resampling.LANCZOS)
        out.paste(pil, ((size[0] - pil.width) // 2, 0))
    else:
        draw.text((20, 140), f"missing: {path}", fill=(235, 235, 235))
    draw.text((8, size[1] - 21), label, fill=(235, 235, 235))
    return out


def make_contact(result):
    sheet = Image.new("RGB", (1920, 860), (0, 0, 0))
    sheet.paste(panel("BATTLE42 source capture", B42_CAPTURE), (0, 0))
    sheet.paste(panel("BATTLE43 candidate capture", B43_CAPTURE), (640, 0))
    text = Image.new("RGB", (640, 360), (8, 8, 8))
    draw = ImageDraw.Draw(text)
    lines = [
        "BATTLE_43 summary",
        f"visual_status: {result['visual_status']}",
        f"final restored: {result['isFinalRestoredBattleScreen']}",
        f"GraphicRaycaster before/reopen: {result['unitySummary'].get('before', {}).get('graphicRaycaster')} / {result['unitySummary'].get('reopen', {}).get('graphicRaycaster')}",
        f"Button before/reopen: {result['unitySummary'].get('before', {}).get('button')} / {result['unitySummary'].get('reopen', {}).get('button')}",
        f"raycast ready reopen: {result['unitySummary'].get('reopenRaycastReadyButtonCount')}",
        f"Mask/RectMask reopen: {result['unitySummary'].get('reopen', {}).get('mask')} / {result['unitySummary'].get('reopen', {}).get('rectMask2D')}",
        f"TMP/Text reopen: {result['unitySummary'].get('reopen', {}).get('tmp')} / {result['unitySummary'].get('reopen', {}).get('text')}",
        f"formation heroes: {result['payloadSummary'].get('ourHeroCount')}",
        f"missing bundles: {result['resourceSummary'].get('missingBundleCount')}",
        f"next blocker: {result['nextBlocker']}",
    ]
    y = 20
    for line in lines:
        draw.text((18, y), line, fill=(235, 235, 235))
        y += 28
    sheet.paste(text, (1280, 0))
    large = panel("BATTLE43 candidate detail", B43_CAPTURE, (960, 500))
    sheet.paste(large, (0, 360))
    notes = Image.new("RGB", (960, 500), (8, 8, 8))
    draw = ImageDraw.Draw(notes)
    note_lines = [
        "play video unavailable: " + str(not PLAY_VIDEO.exists()) + " " + str(PLAY_VIDEO),
        "aux reference available: " + str(AUX_VIDEO.exists()) + " " + str(AUX_VIDEO),
        "No fake HUD/card/icon, screenshot paste, or whole-atlas placement.",
        "BATTLE43 patch is interaction plumbing only.",
        "Mask/TMP remain blockers because original serialized field mapping is not reconstructed.",
    ]
    y = 20
    for line in note_lines:
        draw.text((18, y), line, fill=(235, 235, 235))
        y += 30
    sheet.paste(notes, (960, 360))
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT, quality=92)


def write_patch_plan(result):
    u = result["unitySummary"]
    payload = result["payloadSummary"]
    resources = result["resourceSummary"]
    raycast = result.get("raycastFailureSummary", {})
    md = [
        "# BATTLE_43 Minimal Playable Context Patch Plan",
        "",
        "## Applied In BATTLE43 Candidate",
        f"- Added `GraphicRaycaster` to active canvases: `{u.get('graphicRaycasterAddedCount')}`.",
        f"- Added evidence-backed `Button` components to active button-like Image controls: `{u.get('buttonAddedCount')}`.",
        f"- Reopen component raycast-ready buttons: `{u.get('reopenRaycastReadyButtonCount')}`.",
        "- No click handlers were fabricated; this is component/raycast readiness only.",
        "",
        "## Still Blocked",
        f"- Mask/RectMask2D remain `{u.get('reopen', {}).get('mask')}` / `{u.get('reopen', {}).get('rectMask2D')}` after reopen despite source evidence counts in `BATTLE_UI_COMPONENT_TYPE_EVIDENCE.csv`.",
        f"- TMP/Text remain `{u.get('reopen', {}).get('tmp')}` / `{u.get('reopen', {}).get('text')}`; original text/font/material/autosize values are not reconstructed.",
        f"- Missing script count remains `{u.get('reopen', {}).get('missingScript')}`; custom YouYouImage/Lua binder/control scripts are still unresolved.",
        f"- Missing resource bundles for playable actor/skill context: `{resources.get('missingBundleCount')}`.",
        f"- Button raycast misses are `{raycast.get('reasonCounts')}`; current samples show `hitCount=0`, so no Graphic is hit at the candidate button centers.",
        "",
        "## Runtime Data Evidence",
        f"- Map id: `{payload.get('mapId')}`; battle type: `{payload.get('battleType')}`; waves: `{payload.get('waveCount')}`.",
        f"- Our heroes: `{', '.join(str(h.get('heroDid')) for h in payload.get('ourHeroes', []))}`.",
        "- Our formation positions are present in `BATTLE_TEST_PAYLOAD.json` and can replace BATTLE29 inferred card placement in the next patch.",
        "- Skill ids are present in payload and `resource_index.csv`; timeline/common effect missing bundles must be handled before skill/cut-in playback can be called playable.",
        "",
        "## Next Patch Candidate",
        "- Use `BATTLE_TEST_PAYLOAD.json` to bind hero cards and actor roots by formation position, not hard-coded BATTLE29 slots.",
        "- Restore TMP/Text from original prefab serialized YAML/PPtr evidence before adding visible labels.",
        "- Restore Mask/RectMask2D only after mapping original missing-script serialized fields to exact transforms.",
        "- Trace original Button MonoScript locations and `targetGraphic` serialized references; BATTLE43's child-Image heuristic can persist Buttons, but it does not recreate the original raycast geometry.",
        "- Link Lua/IL2CPP button handlers after component raycast readiness; current BATTLE43 button patch deliberately has no fake onClick.",
    ]
    PATCH_PLAN.write_text("\n".join(md) + "\n", encoding="utf-8")


def verify(unity_exit):
    unity = read_json(UNITY_JSON, {})
    b42 = read_json(B42_JSON, {})
    payload = payload_summary()
    resources = resource_summary(payload)
    type_evidence = type_evidence_summary()
    raycast_failures = raycast_failure_summary()
    similarity = image_similarity(B42_CAPTURE, B43_CAPTURE)

    reopen = unity.get("reopen", {})
    raycast_ready = int(unity.get("reopenRaycastReadyButtonCount") or 0)
    buttons = int(reopen.get("button") or 0)
    masks = int(reopen.get("mask") or 0) + int(reopen.get("rectMask2D") or 0)
    texts = int(reopen.get("text") or 0) + int(reopen.get("tmp") or 0)

    if unity_exit != 0:
        visual_status = "failed_unity_batch_or_compile"
        blocker = "Unity batch/probe did not complete."
        next_blocker = "BATTLE_44_FIX_BATTLE43_COMPILE_OR_BATCH_ERROR"
    elif buttons > 0 and raycast_ready > 0:
        visual_status = "failed_interaction_plumbing_improved_but_mask_tmp_runtime_binding_still_incomplete"
        blocker = "GraphicRaycaster/Button/raycast readiness now persists, but Mask/TMP/text/custom Lua handlers and formation/skill runtime binding are still incomplete."
        next_blocker = "BATTLE_44_BIND_FORMATION_PAYLOAD_TO_HUD_ACTOR_SKILL_CONTEXT_WITH_MASK_TMP_TRACE"
    else:
        visual_status = "failed_button_raycast_context_not_ready"
        blocker = "BATTLE43 did not produce persistent raycast-ready button candidates."
        next_blocker = "BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION"

    if masks == 0:
        blocker += " Mask/RectMask2D are still absent."
    if texts == 0:
        blocker += " TMP/Text are still absent."

    result = {
        "verdict": "playable context validation advanced, but final battle screen is not restored",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "unityExitCode": unity_exit,
        "referenceVideoAvailable": PLAY_VIDEO.exists(),
        "referenceVideoPath": str(PLAY_VIDEO),
        "auxiliaryReferenceVideoAvailable": AUX_VIDEO.exists(),
        "auxiliaryReferenceVideoPath": str(AUX_VIDEO),
        "unitySummary": unity,
        "typeEvidenceSummary": type_evidence,
        "payloadSummary": payload,
        "resourceSummary": resources,
        "raycastFailureSummary": raycast_failures,
        "captureMetrics": capture_metrics(B43_CAPTURE),
        "battle42ToBattle43CaptureSimilarity": similarity,
        "battle42Carryover": {
            "visual_status": b42.get("visual_status"),
            "cameraVisibleBattleHud": b42.get("cameraVisibleBattleHud"),
            "reopenImageCount": b42.get("unitySummary", {}).get("reopenImageCount"),
            "reopenGraphicCount": b42.get("unitySummary", {}).get("reopenGraphicCount"),
        },
        "blocker": blocker,
        "nextBlocker": next_blocker,
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "unityDataJson": str(UNITY_JSON),
            "componentsCsv": str(ROWS_CSV),
            "capture": str(B43_CAPTURE),
            "contactSheet": str(CONTACT),
            "patchPlan": str(PATCH_PLAN),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "BATTLE43 does not add fake art, fake cards, fake icons, screenshot paste, or whole-atlas placement.",
            "BATTLE43 only patches component/raycast plumbing where original Button/GraphicRaycaster evidence exists.",
            "No fake onClick handlers were attached.",
            "Final restored battle screen remains false.",
        ],
    }
    make_contact(result)
    write_patch_plan(result)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_43 Validate Mask Stencil TMP Button And Runtime Formation Skill Binding Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE43는 BATTLE42의 persistent HUD 위에서 mask/stencil, TMP/text, button/raycast, actor/formation/skill binding을 검증했고, 시각 fake 없이 interaction plumbing 최소 패치만 적용했다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- Unity exit code: `{unity_exit}`",
        f"- reference video available: `{PLAY_VIDEO.exists()}` (`{PLAY_VIDEO}`)",
        f"- auxiliary reference video available: `{AUX_VIDEO.exists()}` (`{AUX_VIDEO}`)",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Component Validation",
        f"- GraphicRaycaster before/reopen: `{unity.get('before', {}).get('graphicRaycaster')}` / `{unity.get('reopen', {}).get('graphicRaycaster')}`",
        f"- Button before/reopen: `{unity.get('before', {}).get('button')}` / `{unity.get('reopen', {}).get('button')}`",
        f"- raycast-ready Button after/reopen: `{unity.get('raycastReadyButtonCount')}` / `{unity.get('reopenRaycastReadyButtonCount')}`",
        f"- raycast failure reasons: `{raycast_failures.get('reasonCounts')}`, all zero-hit centers: `{raycast_failures.get('allMissesHadZeroGraphicHits')}`",
        f"- Mask/RectMask2D reopen: `{unity.get('reopen', {}).get('mask')}` / `{unity.get('reopen', {}).get('rectMask2D')}`",
        f"- TMP/Text reopen: `{unity.get('reopen', {}).get('tmp')}` / `{unity.get('reopen', {}).get('text')}`",
        f"- missing scripts reopen: `{unity.get('reopen', {}).get('missingScript')}`",
        f"- BATTLE42→BATTLE43 capture similarity: `{similarity}`",
        "",
        "## Runtime Binding Evidence",
        f"- payload map/battle/waves: `{payload.get('mapId')}` / `{payload.get('battleType')}` / `{payload.get('waveCount')}`",
        f"- payload heroes: `{', '.join(str(h.get('heroDid')) for h in payload.get('ourHeroes', []))}`",
        f"- relevant resource bundles: `{resources.get('relevantBundleCount')}`, missing: `{resources.get('missingBundleCount')}`",
        f"- missing bundles sample: `{resources.get('missingBundles')}`",
        "",
        "## Blocker",
        f"- {blocker}",
        "",
        "## Minimal Patch Plan",
        f"- `{PATCH_PLAN}`",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity data JSON: `{UNITY_JSON}`",
        f"- components CSV: `{ROWS_CSV}`",
        f"- capture: `{B43_CAPTURE}`",
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
        "reopenButtonCount": unity.get("reopen", {}).get("button"),
        "reopenRaycastReadyButtonCount": unity.get("reopenRaycastReadyButtonCount"),
        "reopenMaskCount": unity.get("reopen", {}).get("mask"),
        "reopenTmpCount": unity.get("reopen", {}).get("tmp"),
        "missingBundleCount": resources.get("missingBundleCount"),
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
