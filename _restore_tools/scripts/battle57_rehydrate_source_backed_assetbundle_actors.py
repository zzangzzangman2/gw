from __future__ import annotations

import argparse
import csv
import json
import shutil
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
REPORT_DIR = BASE / "reports" / "battle"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
CAPTURE_DIR = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor"
PREFIX = "BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH"

UNITY_SUMMARY = UNITY_DATA / f"{PREFIX}_UNITY_SUMMARY.json"
UNITY_MAPPING = UNITY_DATA / f"{PREFIX}_REHYDRATION_MAPPING.csv"
UNITY_RENDERERS = UNITY_DATA / f"{PREFIX}_RENDERERS.csv"
UNITY_VISIBILITY = UNITY_DATA / f"{PREFIX}_VISIBILITY.csv"

OUT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
OUT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
OUT_MAPPING = REPORT_DIR / f"{PREFIX}_REHYDRATION_MAPPING.csv"
OUT_RENDERERS = REPORT_DIR / f"{PREFIX}_RENDERERS.csv"
OUT_VISIBILITY = REPORT_DIR / f"{PREFIX}_VISIBILITY.csv"
OUT_CONTACT = REPORT_DIR / f"{PREFIX}_CONTACT_SHEET.jpg"
OUT_LOG = REPORT_DIR / f"{PREFIX}.log"

CAPTURE = CAPTURE_DIR / "Battle57RuntimeRehydratedAssetBundleActorsCandidate_1920x1080.png"
BASELINE = CAPTURE_DIR / "Battle57RuntimeRehydratedAssetBundleActorsCandidate_without_actors_1920x1080.png"
DIFF = CAPTURE_DIR / "Battle57RuntimeRehydratedAssetBundleActorsCandidate_actor_diff_1920x1080.png"

B56_JSON = REPORT_DIR / "BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH_RESULT.json"
B55_JSON = REPORT_DIR / "BATTLE_55_VALIDATE_CANVAS_ZERO_SCALE_RUNTIME_RENDER_AND_ACTOR_VISIBILITY_OR_SOURCE_BACKED_PATCH_RESULT.json"
PAYLOAD_JSON = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.json"
PLAY_VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")


def read_json(path: Path, fallback: Any) -> Any:
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def copy_csv(src: Path, dst: Path) -> list[dict[str, str]]:
    if src.exists():
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(src, dst)
    return read_csv(dst)


def count_cmds(path: Path) -> int:
    return len(list(path.glob("*.cmd"))) if path.exists() else 0


def truthy(value: Any) -> bool:
    return str(value).strip().lower() in {"true", "1", "yes"}


def intv(value: Any) -> int:
    try:
        return int(float(str(value or "0")))
    except Exception:
        return 0


def floatv(value: Any) -> float:
    try:
        return float(str(value or "0"))
    except Exception:
        return 0.0


def create_contact_sheet() -> bool:
    try:
        from PIL import Image, ImageDraw
    except Exception:
        return False

    items = [
        ("baseline without actors", BASELINE),
        ("with source-backed rehydrated actors", CAPTURE),
        ("actor on/off diff mask", DIFF),
    ]
    images = []
    for label, path in items:
        if not path.exists():
            continue
        img = Image.open(path).convert("RGB")
        img.thumbnail((640, 360))
        canvas = Image.new("RGB", (640, 398), "white")
        canvas.paste(img, ((640 - img.width) // 2, 30))
        draw = ImageDraw.Draw(canvas)
        draw.text((12, 8), label, fill=(0, 0, 0))
        images.append(canvas)
    if not images:
        return False
    sheet = Image.new("RGB", (640, 398 * len(images)), "white")
    for i, img in enumerate(images):
        sheet.paste(img, (0, i * 398))
    OUT_CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(OUT_CONTACT, quality=92)
    return True


def summarize_mapping(rows: list[dict[str, str]]) -> dict[str, Any]:
    rehydrated = [r for r in rows if r.get("mappingKind") == "source_assetbundle_runtime_rehydrate"]
    disabled = [r for r in rows if r.get("mappingKind") == "disabled_existing_hollow_shell"]
    return {
        "rows": len(rows),
        "sourceBackedRehydratedRows": len(rehydrated),
        "disabledExistingHollowShellRows": len(disabled),
        "bundleLoadedRows": sum(1 for r in rehydrated if truthy(r.get("bundleLoaded"))),
        "prefabInstantiatedRows": sum(1 for r in rehydrated if truthy(r.get("prefabInstantiated"))),
        "animationStateSetRows": sum(1 for r in rehydrated if truthy(r.get("animationStateSet"))),
        "actors": [
            {
                "side": r.get("side"),
                "heroDid": r.get("heroDid"),
                "modelId": r.get("modelId"),
                "bundle": r.get("bundle"),
                "prefabAsset": r.get("prefabAsset"),
                "newActorPath": r.get("newActorPath"),
                "animationUsed": r.get("animationUsed"),
                "skeletonDataAsset": r.get("skeletonDataAsset"),
            }
            for r in rehydrated
        ],
    }


def summarize_renderers(rows: list[dict[str, str]]) -> dict[str, Any]:
    return {
        "rows": len(rows),
        "meshNonNullRows": sum(1 for r in rows if truthy(r.get("meshNonNull"))),
        "meshVertexTotal": sum(intv(r.get("meshVertexCount")) for r in rows),
        "materialReadyRows": sum(
            1
            for r in rows
            if intv(r.get("materialSlotCount")) > 0
            and intv(r.get("materialNullCount")) == 0
            and intv(r.get("unsupportedShaderMaterialCount")) == 0
        ),
        "unsupportedShaderRows": sum(1 for r in rows if intv(r.get("unsupportedShaderMaterialCount")) > 0),
        "shaderRebindAppliedTotal": sum(intv(r.get("shaderRebindAppliedCount")) for r in rows),
        "actors": [
            {
                "heroDid": r.get("heroDid"),
                "modelId": r.get("modelId"),
                "meshVertexCount": intv(r.get("meshVertexCount")),
                "materialNames": r.get("materialNames"),
                "shaderNames": r.get("shaderNames"),
                "boundsSize": r.get("boundsSize"),
            }
            for r in rows
        ],
    }


def summarize_visibility(rows: list[dict[str, str]]) -> dict[str, Any]:
    return {
        "rows": len(rows),
        "meshReadyRows": sum(1 for r in rows if truthy(r.get("meshReady"))),
        "materialReadyRows": sum(1 for r in rows if truthy(r.get("materialReady"))),
        "frustumRows": sum(1 for r in rows if truthy(r.get("frustumCandidate"))),
        "cameraLayerRows": sum(1 for r in rows if truthy(r.get("cameraIncludesLayer"))),
        "capturePixelSignalRows": sum(1 for r in rows if truthy(r.get("capturePixelSignal"))),
        "pixelDiffTotal": sum(intv(r.get("actorPixelDiffCount")) for r in rows),
        "actors": [
            {
                "heroDid": r.get("heroDid"),
                "modelId": r.get("modelId"),
                "meshReady": truthy(r.get("meshReady")),
                "materialReady": truthy(r.get("materialReady")),
                "boundsSize": r.get("boundsSize"),
                "screenRect": r.get("screenRect"),
                "pixelDiffCount": intv(r.get("actorPixelDiffCount")),
                "capturePixelSignal": truthy(r.get("capturePixelSignal")),
            }
            for r in rows
        ],
    }


def build_report(result: dict[str, Any]) -> str:
    lines = [
        f"# {PREFIX} Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE57 validates source-backed AssetBundle actor rehydration in the battle HUD/map candidate builder without fake meshes or fake handlers.",
        "",
        "## Verdict",
        f"- visual_status: `{result['visual_status']}`",
        f"- final screen claim: `{str(result['isFinalRestoredBattleScreen']).lower()}`",
        f"- patch decision: `{result['patchDecision']}`",
        f"- scene saved: `{str(result['sceneSaved']).lower()}`",
        f"- runtime rehydrate used: `{str(result['runtimeRehydrateUsed']).lower()}`",
        f"- source-backed persistent import used: `{str(result['sourceBackedPersistentImportUsed']).lower()}`",
        f"- fake mesh used: `{str(result['fakeMeshUsed']).lower()}`",
        f"- next blocker: `{result['nextBlocker']}`",
        "",
        "## Rehydration Mapping",
        f"- source-backed rehydrated actors: `{result['mapping']['sourceBackedRehydratedRows']}`",
        f"- disabled old hollow shell rows: `{result['mapping']['disabledExistingHollowShellRows']}`",
        f"- bundle loaded / prefab instantiated: `{result['mapping']['bundleLoadedRows']}` / `{result['mapping']['prefabInstantiatedRows']}`",
        f"- animation state set rows: `{result['mapping']['animationStateSetRows']}`",
        "",
        "## Render And Visibility",
        f"- renderer rows: `{result['renderers']['rows']}`",
        f"- mesh non-null rows / mesh vertices: `{result['renderers']['meshNonNullRows']}` / `{result['renderers']['meshVertexTotal']}`",
        f"- material-ready rows: `{result['renderers']['materialReadyRows']}`",
        f"- unsupported shader rows after rebind: `{result['renderers']['unsupportedShaderRows']}`",
        f"- visibility rows mesh/material/frustum/pixel signal: `{result['visibility']['meshReadyRows']}` / `{result['visibility']['materialReadyRows']}` / `{result['visibility']['frustumRows']}` / `{result['visibility']['capturePixelSignalRows']}`",
        f"- actor on/off diff sampled pixels: `{result['visibility']['pixelDiffTotal']}`",
        "",
        "## Interpretation",
        "- This is not a whole-atlas or dummy mesh replacement. The actor instances come from the original local AssetBundles and preserve the original Spine `SkeletonAnimation`, `SkeletonDataAsset`, atlas material, texture, and animation state path.",
        "- Persistent project asset import was not attempted in this pass. The candidate scene was saved as a builder artifact, but actor render validity is proven by runtime rehydration while source bundles remain loaded, not by reopen-persistent MeshRenderer PPtrs.",
        "- HUD/button Lua handler binding remains blocked by the previous xLua/GameEntry/ModulesInit issue, so playable remains false.",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- mapping CSV: `{OUT_MAPPING}`",
        f"- renderer/material/shader CSV: `{OUT_RENDERERS}`",
        f"- actor visibility CSV: `{OUT_VISIBILITY}`",
        f"- candidate capture: `{CAPTURE}`",
        f"- actor-hidden baseline: `{BASELINE}`",
        f"- actor diff mask: `{DIFF}`",
        f"- contact sheet: `{OUT_CONTACT}`",
        "",
        "## Command Policy",
        f"- root `.cmd` count: `{result['rootCmdCount']}`",
        f"- `_restore_tools` direct `.cmd` count: `{result['restoreToolsDirectCmdCount']}`",
        f"- `플레이.mp4`: `{'available' if result['referenceVideoAvailable'] else 'missing'}`",
        f"- `참고.mp4`: `{'available, auxiliary only' if result['auxiliaryReferenceVideoAvailable'] else 'missing'}`",
    ]
    return "\n".join(lines) + "\n"


def run(unity_exit: int) -> int:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    summary = read_json(UNITY_SUMMARY, {})
    mapping = copy_csv(UNITY_MAPPING, OUT_MAPPING)
    renderers = copy_csv(UNITY_RENDERERS, OUT_RENDERERS)
    visibility = copy_csv(UNITY_VISIBILITY, OUT_VISIBILITY)
    b56 = read_json(B56_JSON, {})
    b55 = read_json(B55_JSON, {})
    payload = read_json(PAYLOAD_JSON, {})
    contact_created = create_contact_sheet()

    capture_signal_rows = sum(1 for r in visibility if truthy(r.get("capturePixelSignal")))
    mesh_ready_rows = sum(1 for r in visibility if truthy(r.get("meshReady")))
    material_ready_rows = sum(1 for r in visibility if truthy(r.get("materialReady")))
    visual_status = (
        "source_backed_assetbundle_actor_runtime_rehydrate_pixels_validated_playable_false"
        if capture_signal_rows == 3 and mesh_ready_rows == 3 and material_ready_rows == 3
        else "source_backed_assetbundle_actor_runtime_rehydrate_incomplete_playable_false"
    )
    result = {
        "prefix": PREFIX,
        "unityExitCode": unity_exit,
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "patchDecision": summary.get("patchDecision", "candidate_runtime_rehydrate_patch_no_fake_mesh"),
        "sceneSaved": bool(summary.get("sceneSaved", False)),
        "runtimeRehydrateUsed": bool(summary.get("runtimeRehydrateUsed", True)),
        "sourceBackedPersistentImportUsed": bool(summary.get("sourceBackedPersistentImportUsed", False)),
        "fakeMeshUsed": bool(summary.get("fakeMeshUsed", False)),
        "fakeHandlerUsed": bool(summary.get("fakeHandlerUsed", False)),
        "baseScene": summary.get("baseScene", ""),
        "outputScene": summary.get("outputScene", ""),
        "mapping": summarize_mapping(mapping),
        "renderers": summarize_renderers(renderers),
        "visibility": summarize_visibility(visibility),
        "unitySummary": summary,
        "b56Carryover": {
            "liveBundleMeshReadyRows": b56.get("prefabAudit", {}).get("liveMeshReadyRows"),
            "sceneMeshReadyRowsBeforeB57": b56.get("currentScene", {}).get("sceneMeshReadyRows"),
            "importGapCounts": b56.get("currentScene", {}).get("importGapCounts"),
        },
        "b55Carryover": {
            "actorPrimaryConclusion": b55.get("actors", {}).get("primaryConclusion"),
            "rowsWithMesh": b55.get("actors", {}).get("rowsWithMesh"),
        },
        "payloadCarryover": {
            "classification": payload.get("summary", {}).get("classification"),
            "loadableActors": payload.get("summary", {}).get("loadableActors"),
            "totalActors": payload.get("summary", {}).get("totalActors"),
        },
        "nextBlocker": summary.get("nextBlocker", "XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_AND_FULL_PAYLOAD_GAPS_REMAIN"),
        "referenceVideoAvailable": PLAY_VIDEO.exists(),
        "referenceVideoPath": str(PLAY_VIDEO),
        "auxiliaryReferenceVideoAvailable": AUX_VIDEO.exists(),
        "auxiliaryReferenceVideoPath": str(AUX_VIDEO),
        "captureExists": CAPTURE.exists(),
        "baselineCaptureExists": BASELINE.exists(),
        "diffCaptureExists": DIFF.exists(),
        "contactSheetCreated": contact_created,
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "json": str(OUT_JSON),
            "mappingCsv": str(OUT_MAPPING),
            "renderersCsv": str(OUT_RENDERERS),
            "visibilityCsv": str(OUT_VISIBILITY),
            "capture": str(CAPTURE),
            "baselineCapture": str(BASELINE),
            "diffCapture": str(DIFF),
            "contactSheet": str(OUT_CONTACT),
            "unitySummary": str(UNITY_SUMMARY),
            "unityLog": str(REPORT_DIR / f"{PREFIX}_UNITY.log"),
            "log": str(OUT_LOG),
        },
        "notes": [
            "No fake actor/card/icon/text/onClick/gameplay handler was added.",
            "No screenshot paste, whole atlas actor, dummy mesh, coordinate-only success, or external package import/download was used.",
            "Runtime rehydration is source-backed by local AssetBundle prefab assets; persistent import remains a separate task.",
            "The local subset remains validation-only and is not a full restore claim.",
        ],
    }
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    OUT_MD.write_text(build_report(result), encoding="utf-8")
    OUT_LOG.write_text(
        "\n".join(
            [
                PREFIX,
                f"unityExitCode={unity_exit}",
                f"mappingRows={len(mapping)}",
                f"rendererRows={len(renderers)}",
                f"visibilityRows={len(visibility)}",
                f"capturePixelSignalRows={capture_signal_rows}",
                f"patchDecision={result['patchDecision']}",
                f"isFinalRestoredBattleScreen={result['isFinalRestoredBattleScreen']}",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    return 0 if unity_exit == 0 else unity_exit


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("mode", nargs="?", default="verify", choices=["verify"])
    parser.add_argument("--unity-exit", type=int, default=0)
    args = parser.parse_args()
    return run(args.unity_exit)


if __name__ == "__main__":
    raise SystemExit(main())
