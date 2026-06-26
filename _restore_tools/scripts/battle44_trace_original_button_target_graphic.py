from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path
from typing import Any

import cv2
import numpy as np
from PIL import Image, ImageDraw
import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
PLAY_VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")

BUNDLE = BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "ui" / "uiprefabandres" / "battle_ext_prefabs.assetbundle"
TYPE_EVIDENCE = UNITY_DATA / "BATTLE_UI_COMPONENT_TYPE_EVIDENCE.csv"
B43_JSON = REPORT_DIR / "BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_RESULT.json"
B43_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle43PlayableContextValidationCandidate_1920x1080.png"
B44_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle44OriginalButtonTargetGraphicCandidate_1920x1080.png"

EVIDENCE_CSV = UNITY_DATA / "BATTLE_44_ORIGINAL_BUTTON_TARGET_GRAPHIC_EVIDENCE.csv"
PATCH_MANIFEST = UNITY_DATA / "BATTLE_44_ORIGINAL_BUTTON_TARGET_GRAPHIC_PATCH_MANIFEST.csv"
UNITY_JSON = UNITY_DATA / "BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION_UNITY.json"
UNITY_ROWS = UNITY_DATA / "BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION_COMPONENTS.csv"
OUT_MD = REPORT_DIR / "BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION_RESULT.md"
OUT_JSON = REPORT_DIR / "BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION_RESULT.json"
CONTACT = REPORT_DIR / "BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION_CONTACT_SHEET.jpg"
UNITY_LOG = REPORT_DIR / "BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION.log"


def read_json(path: Path, fallback: Any) -> Any:
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow({k: row.get(k, "") for k in fieldnames})


def count_cmds(path: Path) -> int:
    return len(list(path.glob("*.cmd"))) if path.exists() else 0


def ref_path_id(tree: dict[str, Any], key: str) -> int:
    node = tree.get(key, {})
    if isinstance(node, dict):
        return int(node.get("m_PathID") or 0)
    return 0


def pptr(tree: dict[str, Any], key: str) -> str:
    node = tree.get(key, {})
    if isinstance(node, dict):
        return f"{int(node.get('m_FileID') or 0)}:{int(node.get('m_PathID') or 0)}"
    return "0:0"


def vec2(node: Any) -> str:
    if not isinstance(node, dict):
        return ""
    return f"{float(node.get('x') or 0):.3f}/{float(node.get('y') or 0):.3f}"


def color(node: Any) -> str:
    if not isinstance(node, dict):
        return ""
    return "/".join(f"{float(node.get(k) or 0):.3f}" for k in ("r", "g", "b", "a"))


def normalize_suffix(path: str) -> str:
    prefixes = [
        "UI_NormalBattle/",
        "UI_Battle3DUI/",
        "UI_NormalBattle_Pause/",
        "UI_NormalBattle_SkipView/",
        "UI_TestBattle/",
    ]
    for prefix in prefixes:
        if path.startswith(prefix):
            return path[len(prefix):]
    if path.startswith("UI_BattleBoxPage/"):
        return "root_battle/" + path
    return path


def trace_original_buttons() -> list[dict[str, Any]]:
    env = UnityPy.load(str(BUNDLE))
    scripts: dict[int, dict[str, str]] = {}
    go_name: dict[int, str] = {}
    go_transform: dict[int, int] = {}
    transform_go: dict[int, int] = {}
    transform_parent: dict[int, int] = {}
    rects: dict[int, dict[str, Any]] = {}

    for obj in env.objects:
        if obj.type.name == "MonoScript":
            data = obj.read()
            scripts[int(obj.path_id)] = {
                "className": getattr(data, "m_ClassName", "") or "",
                "namespace": getattr(data, "m_Namespace", "") or "",
                "assemblyName": getattr(data, "m_AssemblyName", "") or "",
            }
        elif obj.type.name == "GameObject":
            tree = obj.read_typetree()
            go_name[int(obj.path_id)] = tree.get("m_Name", "")
        elif obj.type.name in {"RectTransform", "Transform"}:
            tree = obj.read_typetree()
            tid = int(obj.path_id)
            gid = int(tree.get("m_GameObject", {}).get("m_PathID") or 0)
            go_transform[gid] = tid
            transform_go[tid] = gid
            transform_parent[tid] = int(tree.get("m_Father", {}).get("m_PathID") or 0)
            rects[gid] = {
                "rectTransformPathId": tid,
                "anchorMin": vec2(tree.get("m_AnchorMin")),
                "anchorMax": vec2(tree.get("m_AnchorMax")),
                "anchoredPosition": vec2(tree.get("m_AnchoredPosition")),
                "sizeDelta": vec2(tree.get("m_SizeDelta")),
                "pivot": vec2(tree.get("m_Pivot")),
                "localScale": "",
            }
            scale = tree.get("m_LocalScale")
            if isinstance(scale, dict):
                rects[gid]["localScale"] = f"{float(scale.get('x') or 0):.3f}/{float(scale.get('y') or 0):.3f}/{float(scale.get('z') or 0):.3f}"

    def path_for(go_id: int) -> str:
        tid = go_transform.get(go_id, 0)
        names: list[str] = []
        guard = 0
        while tid and guard < 96:
            gid = transform_go.get(tid, 0)
            names.append(go_name.get(gid, f"go_{gid}"))
            tid = transform_parent.get(tid, 0)
            guard += 1
        return "/".join(reversed([n for n in names if n]))

    mono: dict[int, dict[str, Any]] = {}
    for obj in env.objects:
        if obj.type.name != "MonoBehaviour":
            continue
        tree = obj.read_typetree()
        sid = ref_path_id(tree, "m_Script")
        script = scripts.get(sid, {})
        cls = script.get("className", "")
        ns = script.get("namespace", "")
        full = f"{ns}.{cls}".strip(".")
        gid = ref_path_id(tree, "m_GameObject")
        mono[int(obj.path_id)] = {
            "componentPathId": int(obj.path_id),
            "gameObjectPathId": gid,
            "className": cls,
            "fullName": full,
            "assemblyName": script.get("assemblyName", ""),
            "scriptPathId": sid,
            "hierarchyPath": path_for(gid),
            "tree": tree,
        }

    rows: list[dict[str, Any]] = []
    for comp in mono.values():
        if comp["fullName"] != "UnityEngine.UI.Button":
            continue
        tree = comp["tree"]
        target_id = ref_path_id(tree, "m_TargetGraphic")
        target = mono.get(target_id)
        button_rect = rects.get(comp["gameObjectPathId"], {})
        target_rect = rects.get((target or {}).get("gameObjectPathId", 0), {})
        original_button_path = comp["hierarchyPath"]
        original_target_path = (target or {}).get("hierarchyPath", "")
        rows.append({
            "sourceBundle": "download/ui/uiprefabandres/battle_ext_prefabs.assetbundle",
            "sourceBundlePath": str(BUNDLE),
            "buttonComponentPathId": comp["componentPathId"],
            "buttonGameObjectPathId": comp["gameObjectPathId"],
            "buttonScriptPathId": comp["scriptPathId"],
            "buttonFullName": comp["fullName"],
            "originalButtonPath": original_button_path,
            "buttonSuffix": normalize_suffix(original_button_path),
            "targetGraphicRef": pptr(tree, "m_TargetGraphic"),
            "targetComponentPathId": target_id,
            "targetGameObjectPathId": (target or {}).get("gameObjectPathId", ""),
            "targetFullName": (target or {}).get("fullName", ""),
            "targetScriptPathId": (target or {}).get("scriptPathId", ""),
            "originalTargetPath": original_target_path,
            "targetSuffix": normalize_suffix(original_target_path) if original_target_path else "",
            "targetRaycastTarget": (target or {}).get("tree", {}).get("m_RaycastTarget", ""),
            "targetColor": color((target or {}).get("tree", {}).get("m_Color", {})),
            "targetSpriteRef": pptr((target or {}).get("tree", {}), "m_Sprite"),
            "targetMaterialRef": pptr((target or {}).get("tree", {}), "m_Material"),
            "buttonSizeDelta": button_rect.get("sizeDelta", ""),
            "buttonAnchoredPosition": button_rect.get("anchoredPosition", ""),
            "buttonAnchorMin": button_rect.get("anchorMin", ""),
            "buttonAnchorMax": button_rect.get("anchorMax", ""),
            "buttonPivot": button_rect.get("pivot", ""),
            "targetSizeDelta": target_rect.get("sizeDelta", ""),
            "targetAnchoredPosition": target_rect.get("anchoredPosition", ""),
            "targetAnchorMin": target_rect.get("anchorMin", ""),
            "targetAnchorMax": target_rect.get("anchorMax", ""),
            "targetPivot": target_rect.get("pivot", ""),
            "patchEligible": str(original_button_path.startswith("UI_NormalBattle/") or original_button_path.startswith("UI_Battle3DUI/")).lower(),
            "evidence": "original MonoBehaviour Button m_TargetGraphic PPtr from battle_ext_prefabs",
        })
    rows.sort(key=lambda r: r["originalButtonPath"])
    return rows


def prepare() -> None:
    rows = trace_original_buttons()
    fields = [
        "sourceBundle", "sourceBundlePath", "buttonComponentPathId", "buttonGameObjectPathId", "buttonScriptPathId",
        "buttonFullName", "originalButtonPath", "buttonSuffix", "targetGraphicRef", "targetComponentPathId",
        "targetGameObjectPathId", "targetFullName", "targetScriptPathId", "originalTargetPath", "targetSuffix",
        "targetRaycastTarget", "targetColor", "targetSpriteRef", "targetMaterialRef", "buttonSizeDelta",
        "buttonAnchoredPosition", "buttonAnchorMin", "buttonAnchorMax", "buttonPivot", "targetSizeDelta",
        "targetAnchoredPosition", "targetAnchorMin", "targetAnchorMax", "targetPivot", "patchEligible", "evidence",
    ]
    write_csv(EVIDENCE_CSV, rows, fields)
    patch_rows = [r for r in rows if r["patchEligible"] == "true"]
    write_csv(PATCH_MANIFEST, patch_rows, fields)
    print(json.dumps({
        "originalButtonCount": len(rows),
        "patchEligibleCount": len(patch_rows),
        "empty4RaycastTargetCount": sum(1 for r in rows if r["targetFullName"] == "UnityEngine.UI.Empty4Raycast"),
        "evidenceCsv": str(EVIDENCE_CSV),
        "patchManifest": str(PATCH_MANIFEST),
    }, ensure_ascii=False, indent=2))


def capture_metrics(path: Path) -> dict[str, Any]:
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


def image_similarity(a: Path, b: Path) -> dict[str, Any]:
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


def panel(label: str, path: Path, size: tuple[int, int] = (640, 360)) -> Image.Image:
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


def make_contact(result: dict[str, Any]) -> None:
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet = Image.new("RGB", (1920, 860), (0, 0, 0))
    sheet.paste(panel("BATTLE43 candidate", B43_CAPTURE), (0, 0))
    sheet.paste(panel("BATTLE44 targetGraphic candidate", B44_CAPTURE), (640, 0))
    summary = Image.new("RGB", (640, 360), (8, 8, 8))
    draw = ImageDraw.Draw(summary)
    u = result.get("unitySummary", {})
    lines = [
        "BATTLE_44 summary",
        f"visual_status: {result.get('visual_status')}",
        f"final restored: {result.get('isFinalRestoredBattleScreen')}",
        f"original Buttons: {result.get('originalButtonCount')}",
        f"patch eligible: {result.get('patchEligibleButtonCount')}",
        f"matched/applied: {u.get('matchedButtonCount')} / {u.get('patchedButtonCount')}",
        f"Empty4Raycast added: {u.get('empty4RaycastAddedCount')}",
        f"Button reopen: {u.get('reopenButtonCount')}",
        f"raycast ready reopen: {u.get('reopenRaycastReadyButtonCount')}",
        f"Mask/TMP reopen: {u.get('reopenMaskCount')} / {u.get('reopenTmpCount')}",
        f"next blocker: {result.get('nextBlocker')}",
    ]
    y = 18
    for line in lines:
        draw.text((18, y), line, fill=(235, 235, 235))
        y += 27
    sheet.paste(summary, (1280, 0))
    sheet.paste(panel("BATTLE44 candidate detail", B44_CAPTURE, (960, 500)), (0, 360))
    notes = Image.new("RGB", (960, 500), (8, 8, 8))
    draw = ImageDraw.Draw(notes)
    note_lines = [
        "No fake HUD/card/icon, screenshot paste, whole-atlas placement, or fake onClick.",
        "Patch only applies original Button root -> m_TargetGraphic evidence.",
        f"play video available: {PLAY_VIDEO.exists()} {PLAY_VIDEO}",
        f"aux reference available: {AUX_VIDEO.exists()} {AUX_VIDEO}",
        "Mask/TMP are counted only; not patched in BATTLE44.",
    ]
    y = 20
    for line in note_lines:
        draw.text((18, y), line, fill=(235, 235, 235))
        y += 30
    sheet.paste(notes, (960, 360))
    sheet.save(CONTACT, quality=92)


def verify(unity_exit: int) -> None:
    evidence = read_csv(EVIDENCE_CSV)
    patch_rows = read_csv(PATCH_MANIFEST)
    unity = read_json(UNITY_JSON, {})
    b43 = read_json(B43_JSON, {})
    type_rows = read_csv(TYPE_EVIDENCE)
    type_counts = {r.get("className"): r.get("monoBehaviourRefCount") for r in type_rows}

    ready = int(unity.get("reopenRaycastReadyButtonCount") or 0)
    if unity_exit != 0:
        visual_status = "failed_unity_batch_or_compile"
        next_blocker = "BATTLE_45_FIX_BATTLE44_COMPILE_OR_BATCH_ERROR"
        blocker = "Unity batch/probe did not complete."
    elif ready > 0:
        visual_status = "button_target_graphic_mapping_improved_but_final_playable_false"
        next_blocker = "BATTLE_45_BIND_BUTTON_INPUT_TO_LUA_IL2CPP_AND_TRACE_MASK_TMP_ACTOR_CONTEXT"
        blocker = "Original Button root/targetGraphic mapping produced raycast-ready controls, but no Lua/IL2CPP click handlers, Mask/TMP, or actor runtime binding are complete."
    else:
        visual_status = "failed_original_target_graphic_mapping_still_not_raycast_ready"
        next_blocker = "BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE"
        blocker = "Original Button root/targetGraphic mapping did not produce raycast-ready controls."

    result = {
        "verdict": "BATTLE44 traced original Button m_TargetGraphic serialization and attempted minimal targetGraphic-only patch; final playable screen remains false",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "unityExitCode": unity_exit,
        "referenceVideoAvailable": PLAY_VIDEO.exists(),
        "referenceVideoPath": str(PLAY_VIDEO),
        "auxiliaryReferenceVideoAvailable": AUX_VIDEO.exists(),
        "auxiliaryReferenceVideoPath": str(AUX_VIDEO),
        "originalButtonCount": len(evidence),
        "patchEligibleButtonCount": len(patch_rows),
        "empty4RaycastTargetCount": sum(1 for r in evidence if r.get("targetFullName") == "UnityEngine.UI.Empty4Raycast"),
        "imageTargetCount": sum(1 for r in evidence if r.get("targetFullName") in {"UnityEngine.UI.Image", "YouYou.YouYouImage"}),
        "typeEvidenceCounts": {
            "Button": type_counts.get("Button"),
            "Image": type_counts.get("Image"),
            "Empty4Raycast": type_counts.get("Empty4Raycast"),
            "GraphicRaycaster": type_counts.get("GraphicRaycaster"),
            "Mask": type_counts.get("Mask"),
            "RectMask2D": type_counts.get("RectMask2D"),
            "TextMeshProUGUI": type_counts.get("TextMeshProUGUI"),
        },
        "unitySummary": unity,
        "battle43Carryover": {
            "visual_status": b43.get("visual_status"),
            "reopenButtonCount": b43.get("unitySummary", {}).get("reopen", {}).get("button"),
            "reopenRaycastReadyButtonCount": b43.get("unitySummary", {}).get("reopenRaycastReadyButtonCount"),
            "raycastFailureSummary": b43.get("raycastFailureSummary"),
        },
        "captureMetrics": capture_metrics(B44_CAPTURE),
        "battle43ToBattle44CaptureSimilarity": image_similarity(B43_CAPTURE, B44_CAPTURE),
        "blocker": blocker,
        "nextBlocker": next_blocker,
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "evidenceCsv": str(EVIDENCE_CSV),
            "patchManifest": str(PATCH_MANIFEST),
            "unityDataJson": str(UNITY_JSON),
            "unityRowsCsv": str(UNITY_ROWS),
            "capture": str(B44_CAPTURE),
            "contactSheet": str(CONTACT),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "BATTLE44 does not add fake art, fake HUD/cards/icons, screenshot paste, whole-atlas placement, or fake onClick handlers.",
            "Mask/RectMask2D and TMP/Text are counted only in BATTLE44.",
            "TargetGraphic mapping is from original battle_ext_prefabs MonoBehaviour m_TargetGraphic PPtr evidence.",
        ],
    }
    make_contact(result)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_44 Trace Original Button MonoScript And TargetGraphic Serialization Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE44는 원본 `battle_ext_prefabs`의 Button `m_TargetGraphic` PPtr를 추적하고, BATTLE43 후보 scene에 원본 Button root/targetGraphic 매핑만 적용했다. fake onClick handler는 추가하지 않았다.",
        "",
        "## Verdict",
        f"- visual_status: `{visual_status}`",
        "- final screen claim: `false`",
        f"- Unity exit code: `{unity_exit}`",
        f"- reference video available: `{PLAY_VIDEO.exists()}` (`{PLAY_VIDEO}`)",
        f"- auxiliary reference video available: `{AUX_VIDEO.exists()}` (`{AUX_VIDEO}`)",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Original Serialization Evidence",
        f"- original Button MonoBehaviour count traced: `{len(evidence)}`",
        f"- patch-eligible battle Button count: `{len(patch_rows)}`",
        f"- Empty4Raycast targetGraphic count: `{result['empty4RaycastTargetCount']}`",
        f"- Image/YouYouImage targetGraphic count: `{result['imageTargetCount']}`",
        f"- type evidence counts: `{result['typeEvidenceCounts']}`",
        f"- evidence CSV: `{EVIDENCE_CSV}`",
        "",
        "## Candidate Patch Validation",
        f"- matched/applied Button mappings: `{unity.get('matchedButtonCount')}` / `{unity.get('patchedButtonCount')}`",
        f"- Empty4Raycast added: `{unity.get('empty4RaycastAddedCount')}`",
        f"- Empty4Raycast after/reopen: `{unity.get('after', {}).get('empty4Raycast')}` / `{unity.get('reopen', {}).get('empty4Raycast')}`",
        f"- missing scripts before/reopen: `{unity.get('before', {}).get('missingScript')}` / `{unity.get('reopen', {}).get('missingScript')}`",
        f"- stale BATTLE43 heuristic Buttons removed: `{unity.get('removedHeuristicButtonCount')}`",
        f"- Button reopen: `{unity.get('reopenButtonCount')}`",
        f"- raycast-ready Button after/reopen: `{unity.get('raycastReadyButtonCount')}` / `{unity.get('reopenRaycastReadyButtonCount')}`",
        f"- raycast failure reasons: `{unity.get('raycastFailureReasons')}`",
        f"- Mask/RectMask2D reopen: `{unity.get('reopenMaskCount')}` / `{unity.get('reopenRectMask2DCount')}`",
        f"- TMP/Text reopen: `{unity.get('reopenTmpCount')}` / `{unity.get('reopenTextCount')}`",
        f"- BATTLE43→BATTLE44 capture similarity: `{result['battle43ToBattle44CaptureSimilarity']}`",
        "",
        "## Blocker",
        f"- {blocker}",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- evidence CSV: `{EVIDENCE_CSV}`",
        f"- patch manifest CSV: `{PATCH_MANIFEST}`",
        f"- Unity data JSON: `{UNITY_JSON}`",
        f"- Unity rows CSV: `{UNITY_ROWS}`",
        f"- capture: `{B44_CAPTURE}`",
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
        "originalButtonCount": len(evidence),
        "patchEligibleButtonCount": len(patch_rows),
        "patchedButtonCount": unity.get("patchedButtonCount"),
        "reopenButtonCount": unity.get("reopenButtonCount"),
        "reopenRaycastReadyButtonCount": unity.get("reopenRaycastReadyButtonCount"),
        "nextBlocker": next_blocker,
        "rootCmdCount": result["rootCmdCount"],
        "restoreToolsDirectCmdCount": result["restoreToolsDirectCmdCount"],
    }, ensure_ascii=False, indent=2))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("mode", choices=["prepare", "verify"])
    parser.add_argument("--unity-exit", type=int, default=0)
    args = parser.parse_args()
    if args.mode == "prepare":
        prepare()
    else:
        verify(args.unity_exit)


if __name__ == "__main__":
    main()
