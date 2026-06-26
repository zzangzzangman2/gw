from __future__ import annotations

import argparse
import csv
import json
import shutil
from collections import Counter
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
REPORT_DIR = BASE / "reports" / "battle"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
PREFIX = "BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH"

UNITY_SUMMARY = UNITY_DATA / f"{PREFIX}_UNITY_SUMMARY.json"
UNITY_PREFABS = UNITY_DATA / f"{PREFIX}_ACTOR_PREFAB_AUDIT.csv"
UNITY_DEPS = UNITY_DATA / f"{PREFIX}_RENDERER_MATERIAL_SHADER_DEPENDENCIES.csv"
UNITY_SCENE = UNITY_DATA / f"{PREFIX}_CURRENT_SCENE_ACTORS.csv"

OUT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
OUT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
OUT_PREFABS = REPORT_DIR / f"{PREFIX}_ACTOR_PREFAB_AUDIT.csv"
OUT_DEPS = REPORT_DIR / f"{PREFIX}_RENDERER_MATERIAL_SHADER_DEPENDENCIES.csv"
OUT_SCENE = REPORT_DIR / f"{PREFIX}_CURRENT_SCENE_ACTORS.csv"
LOG = REPORT_DIR / f"{PREFIX}.log"

B55_JSON = REPORT_DIR / "BATTLE_55_VALIDATE_CANVAS_ZERO_SCALE_RUNTIME_RENDER_AND_ACTOR_VISIBILITY_OR_SOURCE_BACKED_PATCH_RESULT.json"
B31_JSON = REPORT_DIR / "BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_RESULT.json"
B34_JSON = REPORT_DIR / "BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS_RESULT.json"
B37_JSON = REPORT_DIR / "BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_RESULT.json"
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


def truthy(v: Any) -> bool:
    return str(v).strip().lower() in {"true", "1", "yes"}


def intv(v: Any) -> int:
    try:
        return int(float(str(v or "0")))
    except Exception:
        return 0


def summarize_prefabs(rows: list[dict[str, str]]) -> dict[str, Any]:
    return {
        "rows": len(rows),
        "bundleLoadSuccess": sum(1 for r in rows if truthy(r.get("bundleLoaded"))),
        "prefabLoaded": sum(1 for r in rows if truthy(r.get("prefabLoaded"))),
        "liveMeshReadyRows": sum(1 for r in rows if truthy(r.get("liveMeshReady"))),
        "skeletonAnimationRows": sum(1 for r in rows if intv(r.get("skeletonAnimationComponentCount")) > 0),
        "skeletonDataNonNullRows": sum(1 for r in rows if intv(r.get("skeletonDataAssetNonNullCount")) > 0),
        "assetDatabasePrefabExistsRows": sum(1 for r in rows if truthy(r.get("assetDatabasePrefabExists"))),
        "totalMeshVertices": sum(intv(r.get("meshVertexCount")) for r in rows),
        "totalMaterialSlots": sum(intv(r.get("materialSlotCount")) for r in rows),
        "unsupportedShaderMaterialRows": sum(1 for r in rows if intv(r.get("unsupportedShaderMaterialCount")) > 0),
        "statuses": dict(Counter(r.get("status", "") for r in rows)),
        "actors": [
            {
                "heroDid": r.get("heroDid"),
                "modelId": r.get("modelId"),
                "meshVertices": intv(r.get("meshVertexCount")),
                "materials": r.get("rendererMaterialNames"),
                "skeletonData": r.get("skeletonDataAssetNames"),
                "liveMeshReady": truthy(r.get("liveMeshReady")),
                "projectPrefabImported": truthy(r.get("assetDatabasePrefabExists")),
            }
            for r in rows
        ],
    }


def summarize_scene(rows: list[dict[str, str]]) -> dict[str, Any]:
    gaps = Counter(r.get("importGap", "") for r in rows)
    return {
        "rows": len(rows),
        "foundRows": sum(1 for r in rows if truthy(r.get("found"))),
        "sceneMeshReadyRows": sum(1 for r in rows if truthy(r.get("sceneMeshReady"))),
        "sceneMaterialReadyRows": sum(1 for r in rows if truthy(r.get("sceneMaterialReady"))),
        "importGapCounts": dict(gaps),
        "actors": [
            {
                "heroDid": r.get("heroDid"),
                "modelId": r.get("modelId"),
                "meshFilters": intv(r.get("meshFilterCount")),
                "meshWithMesh": intv(r.get("meshFilterWithMeshCount")),
                "meshVertices": intv(r.get("meshVertexCount")),
                "materialSlots": intv(r.get("materialSlotCount")),
                "materialNull": intv(r.get("materialNullCount")),
                "boundsSize": r.get("boundsSize"),
                "importGap": r.get("importGap"),
            }
            for r in rows
        ],
    }


def summarize_deps(rows: list[dict[str, str]]) -> dict[str, Any]:
    types = Counter(r.get("assetType", "") for r in rows if r.get("sourceKind") == "actor_bundle_asset")
    shaders = sorted(set(r.get("shaderName", "") for r in rows if r.get("shaderName")))
    return {
        "rows": len(rows),
        "actorBundleAssetTypeCounts": dict(types),
        "shaderNames": shaders,
        "shaderBundleShaderRows": sum(1 for r in rows if r.get("sourceKind") == "shader_bundle_shader"),
        "textAssetRows": sum(1 for r in rows if r.get("assetType") == "UnityEngine.TextAsset"),
        "textureRows": sum(1 for r in rows if r.get("assetType") == "UnityEngine.Texture2D"),
        "materialRows": sum(1 for r in rows if r.get("assetType") == "UnityEngine.Material"),
    }


def build_report(result: dict[str, Any]) -> str:
    lines = [
        f"# {PREFIX} Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE56 audits the source actor bundles and the current saved scene actor render refs; it does not import external packages or save a scene patch.",
        "",
        "## Verdict",
        f"- visual_status: `{result['visual_status']}`",
        f"- final screen claim: `{str(result['isFinalRestoredBattleScreen']).lower()}`",
        f"- patch decision: `{result['patchDecision']}`",
        f"- scene saved: `{str(result['sceneSaved']).lower()}`",
        f"- source-backed patch available now: `{str(result['sourceBackedPatchAvailableNow']).lower()}`",
        f"- next blocker: `{result['nextBlocker']}`",
        "",
        "## Source Bundle Audit",
        f"- actor prefab rows: `{result['prefabAudit']['rows']}`",
        f"- bundle load / prefab load: `{result['prefabAudit']['bundleLoadSuccess']}` / `{result['prefabAudit']['prefabLoaded']}`",
        f"- live prefab mesh-ready rows: `{result['prefabAudit']['liveMeshReadyRows']}`",
        f"- SkeletonAnimation / SkeletonData rows: `{result['prefabAudit']['skeletonAnimationRows']}` / `{result['prefabAudit']['skeletonDataNonNullRows']}`",
        f"- project-imported prefab rows: `{result['prefabAudit']['assetDatabasePrefabExistsRows']}`",
        f"- total live prefab mesh vertices: `{result['prefabAudit']['totalMeshVertices']}`",
        "",
        "## Current Scene Gap",
        f"- current scene actor rows: `{result['currentScene']['rows']}`",
        f"- scene mesh-ready rows: `{result['currentScene']['sceneMeshReadyRows']}`",
        f"- scene material-ready rows: `{result['currentScene']['sceneMaterialReadyRows']}`",
        f"- import gap counts: `{result['currentScene']['importGapCounts']}`",
        "- Interpretation: BATTLE39/BATTLE51 saved scene actors retained Transform/MeshRenderer shell components, but AssetBundle mesh/material references did not persist as project assets after reopen.",
        "- Build-chain link: the actor scene builder instantiated live AssetBundle prefabs successfully, but did not create persistent project assets for the Spine SkeletonDataAsset, generated mesh, atlas materials, or texture/shader dependencies.",
        "",
        "## Dependency Split",
        f"- dependency rows: `{result['dependencies']['rows']}`",
        f"- actor bundle asset type counts: `{result['dependencies']['actorBundleAssetTypeCounts']}`",
        f"- material rows / texture rows / text rows: `{result['dependencies']['materialRows']}` / `{result['dependencies']['textureRows']}` / `{result['dependencies']['textAssetRows']}`",
        f"- shader bundle shader rows: `{result['dependencies']['shaderBundleShaderRows']}`",
        "",
        "## Decision",
        "- No candidate scene patch was saved because the available source-backed fix is not a small MeshRenderer PPtr assignment. The original render path is Spine `SkeletonAnimation` + `SkeletonDataAsset` + atlas/material/shader, and those references must be imported into project assets or rebuilt by a source-backed scene builder before they can persist.",
        "- Replacing actors with flat sprites, whole atlas pages, dummy meshes, or copied screenshots remains forbidden.",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- actor prefab audit CSV: `{OUT_PREFABS}`",
        f"- renderer/material/shader dependency CSV: `{OUT_DEPS}`",
        f"- current scene actor CSV: `{OUT_SCENE}`",
        f"- Unity log: `{result['outputs']['unityLog']}`",
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
    prefabs = copy_csv(UNITY_PREFABS, OUT_PREFABS)
    deps = copy_csv(UNITY_DEPS, OUT_DEPS)
    scene = copy_csv(UNITY_SCENE, OUT_SCENE)
    b55 = read_json(B55_JSON, {})
    b31 = read_json(B31_JSON, {})
    b34 = read_json(B34_JSON, {})
    b37 = read_json(B37_JSON, {})
    payload = read_json(PAYLOAD_JSON, {})

    source_patch_available = False
    result = {
        "prefix": PREFIX,
        "unityExitCode": unity_exit,
        "visual_status": "actor_prefab_source_import_gap_audit_complete_no_scene_patch",
        "isFinalRestoredBattleScreen": False,
        "patchDecision": "blocked_no_patch",
        "sceneSaved": False,
        "sourceBackedPatchAvailableNow": source_patch_available,
        "sceneOpened": bool(summary.get("sceneOpened", False)),
        "prefabAudit": summarize_prefabs(prefabs),
        "dependencies": summarize_deps(deps),
        "currentScene": summarize_scene(scene),
        "b55Carryover": {
            "primaryConclusion": b55.get("actors", {}).get("primaryConclusion"),
            "rowsWithMesh": b55.get("actors", {}).get("rowsWithMesh"),
            "rowsWithEnabledRenderer": b55.get("actors", {}).get("rowsWithEnabledRenderer"),
        },
        "priorSpineEvidence": {
            "b31VisualStatus": b31.get("visual_status"),
            "b31BundleLoadSuccess": b31.get("unitySummary", {}).get("bundleLoadSuccess"),
            "b34VisualStatus": b34.get("visual_status"),
            "b34RuntimeProbe": b34.get("runtimeProbe", {}),
            "b37VisualStatus": b37.get("visual_status"),
        },
        "payloadCarryover": {
            "classification": payload.get("summary", {}).get("classification"),
            "loadableActors": payload.get("summary", {}).get("loadableActors"),
            "totalActors": payload.get("summary", {}).get("totalActors"),
            "actorStatusCounts": payload.get("summary", {}).get("actorStatusCounts"),
        },
        "nextBlocker": "SOURCE_BACKED_ACTOR_PREFAB_IMPORT_PIPELINE_REQUIRED_OR_REUSE_BATTLE37_RUNTIME_IN_SCENE_BUILDER",
        "referenceVideoAvailable": PLAY_VIDEO.exists(),
        "referenceVideoPath": str(PLAY_VIDEO),
        "auxiliaryReferenceVideoAvailable": AUX_VIDEO.exists(),
        "auxiliaryReferenceVideoPath": str(AUX_VIDEO),
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "json": str(OUT_JSON),
            "actorPrefabAuditCsv": str(OUT_PREFABS),
            "rendererMaterialShaderDependencyCsv": str(OUT_DEPS),
            "currentSceneActorCsv": str(OUT_SCENE),
            "unitySummary": str(UNITY_SUMMARY),
            "unityLog": str(REPORT_DIR / f"{PREFIX}_UNITY.log"),
            "log": str(LOG),
        },
        "notes": [
            "No fake actor/card/icon/text/onClick/gameplay handler was added.",
            "No screenshot paste, whole atlas actor, dummy mesh, coordinate-only success, or external package import/download was used.",
            "The local subset remains validation-only and is not a full restore claim.",
        ],
    }
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    OUT_MD.write_text(build_report(result), encoding="utf-8")
    LOG.write_text(
        "\n".join(
            [
                f"{PREFIX}",
                f"unityExitCode={unity_exit}",
                f"prefabRows={len(prefabs)}",
                f"dependencyRows={len(deps)}",
                f"sceneRows={len(scene)}",
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
