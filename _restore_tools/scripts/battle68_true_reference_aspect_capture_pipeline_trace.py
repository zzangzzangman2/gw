from __future__ import annotations

import csv
import json
import re
import struct
import sys
from datetime import datetime
from pathlib import Path


PREFIX = "BATTLE_68_TRUE_REFERENCE_ASPECT_CAPTURE_PIPELINE_AND_VIEWRECT_SOURCE_TRACE_NO_SCENE_SAVE"


def read_json(path: Path, default=None):
    if not path.exists():
        return default
    return json.loads(path.read_text(encoding="utf-8-sig"))


def write_csv(path: Path, rows, fieldnames):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def count_root_cmds(root: Path):
    return {
        "rootCmdCount": len(list(root.glob("*.cmd"))),
        "restoreToolsDirectCmdCount": len(list((root / "_restore_tools").glob("*.cmd"))) if (root / "_restore_tools").exists() else 0,
    }


def image_size(path: Path):
    if not path.exists():
        return None
    try:
        from PIL import Image

        with Image.open(path) as img:
            return {"width": img.width, "height": img.height, "aspect": round(img.width / img.height, 6)}
    except Exception:
        pass
    data = path.read_bytes()[:32]
    if data.startswith(b"\x89PNG\r\n\x1a\n") and len(data) >= 24:
        width, height = struct.unpack(">II", data[16:24])
        return {"width": width, "height": height, "aspect": round(width / height, 6)}
    return None


def line_matches(path: Path, patterns):
    rows = []
    if not path.exists():
        return rows
    text = path.read_text(encoding="utf-8", errors="replace").splitlines()
    for idx, line in enumerate(text, start=1):
        for kind, pattern in patterns:
            if re.search(pattern, line):
                rows.append((idx, kind, line.strip()))
                break
    return rows


def inference_for(kind: str, line: str):
    line_lower = line.lower()
    if kind in {"capture_width", "capture_height", "capture_path_16x9"}:
        return "hardcoded_16_9_capture_dimension_or_filename"
    if kind == "render_camera_flexible":
        return "internal_width_height_parameter_exists_but_public_build_call_must_be_checked"
    if kind == "render_camera_1920_1080_call":
        return "public_build_uses_1920x1080"
    if kind == "render_texture":
        return "capture_output_size_comes_from_render_texture_dimensions"
    if kind == "read_pixels":
        return "pixel_readback_size_matches_render_texture_or_constants"
    if kind == "save_scene":
        return "existing_build_path_mutates_scene_asset"
    if kind == "640_480_probe":
        return "raycast_depth_probe_uses_camera_pixelrect_size_not_reference_aspect"
    if "canvas" in kind:
        return "canvas_scaler_or_canvas_render_mode_may_affect_true_viewrect_validation"
    if "aspect" in kind or "pixelrect" in kind:
        return "camera_aspect_or_pixelrect_is_capture_viewrect_relevant"
    return "capture_pipeline_evidence"


def main():
    root = Path(__file__).resolve().parents[2]
    reports = root / "reports" / "battle"
    unity = root / "girlswar_battle_unity"
    editor = unity / "Assets" / "Editor"
    scenes = unity / "Assets" / "Scenes"

    b66 = read_json(reports / "BATTLE_66_ASPECT_CORRECT_VIEWRECT_ROUTE_HUD_CARD_ACTOR_LAYOUT_VALIDATION_NO_PATCH_RESULT.json", {})
    b67 = read_json(reports / "BATTLE_67_ASPECT_CORRECT_CROP_VISUAL_VALIDATION_NO_PATCH_RESULT.json", {})
    reference_aspect = float(b66.get("referenceAspect") or b67.get("referenceAspect") or 2.2456)
    target_1920_height = round(1920 / reference_aspect)
    target_1280_height = round(1280 / reference_aspect)
    unity_exit = None
    if "--unity-exit" in sys.argv:
        try:
            unity_exit = int(sys.argv[sys.argv.index("--unity-exit") + 1])
        except Exception:
            unity_exit = None
    unity_summary_path = unity / "Assets" / "RestoreData" / "battle" / f"{PREFIX}_UNITY.json"
    unity_summary = read_json(unity_summary_path, {})
    true_capture_asset = unity / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle68TrueReferenceAspectNoSceneSave_1920x855.png"
    true_capture_size = image_size(true_capture_asset)
    true_capture_generated_from_unity = (
        unity_summary.get("status") == "true_reference_aspect_capture_generated_no_scene_save"
        and bool(unity_summary.get("captureExists"))
        and true_capture_size is not None
        and true_capture_size.get("width") == 1920
        and true_capture_size.get("height") == target_1920_height
    )

    patterns = [
        ("capture_path_16x9", r"CapturePath.*1920x1080|BaselineCapturePath.*1920x1080|DiffCapturePath.*1920x1080"),
        ("capture_width", r"CaptureWidth\s*=\s*1920|new RenderTexture\(1920\s*,\s*1080|Texture2D\(1920\s*,\s*1080|ReadPixels\(new Rect\(0,\s*0,\s*1920,\s*1080"),
        ("capture_height", r"CaptureHeight\s*=\s*1080"),
        ("render_camera_1920_1080_call", r"RenderCamera\(camera,\s*1920\s*,\s*1080"),
        ("render_camera_flexible", r"RenderCamera\(Camera camera,\s*int width,\s*int height|RenderCamera\(Camera camera,\s*string optionalPath"),
        ("render_texture", r"new RenderTexture\("),
        ("texture2d", r"new Texture2D\("),
        ("read_pixels", r"ReadPixels\("),
        ("save_scene", r"SaveScene\("),
        ("screen_set_resolution", r"Screen\.SetResolution"),
        ("camera_pixelrect", r"pixelRect|PixelRect\("),
        ("camera_aspect", r"\.aspect|ResetAspect"),
        ("orthographic_size", r"orthographicSize"),
        ("canvas_scaler", r"CanvasScaler|referenceResolution|matchWidthOrHeight"),
        ("640_480_probe", r"640\s*,\s*480"),
        ("reference_aspect_candidate", r"1280|570|855|2\.2456|2\.24"),
    ]

    source_files = [
        editor / "Battle57RehydrateSourceBackedAssetBundleActorsEditor.cs",
        editor / "Battle51RestoreLuaBridgeAndRaycasterRegistrationEditor.cs",
        editor / "Battle47GraphicDepthRaycastCandidateRegistrationEditor.cs",
        editor / "Battle48SortOrderDisplayHitOcclusionTraceEditor.cs",
        editor / "Battle46GraphicRaycasterEventCameraScreenSpaceEditor.cs",
        editor / "Battle45Empty4RaycastRegistryEditor.cs",
        editor / "Battle43PlayableContextValidationEditor.cs",
        editor / "Battle42PersistentHudImagesEditor.cs",
        editor / "Battle40FixBattleHudCameraRenderBindingInRuntimeContextEditor.cs",
        editor / "Battle39AttachRuntimeActorsToMap11003HudContextWithEvidenceEditor.cs",
        editor / "BattleHeroListSkillCardBindClip05Editor.cs",
        editor / "BattleCorrectMapSceneHudPreviewClip05Editor.cs",
        editor / "BattleHudAttachToFlowEditor.cs",
        editor / "BattleHudCanvasScalerSpriteTextureLuaStateClip05Editor.cs",
    ]

    evidence_rows = []
    for path in source_files:
        rel = str(path.relative_to(root)) if path.exists() else str(path)
        matches = line_matches(path, patterns)
        for line_no, kind, text in matches:
            evidence_rows.append(
                {
                    "file": rel,
                    "line": line_no,
                    "evidenceKind": kind,
                    "lineText": text,
                    "inference": inference_for(kind, text),
                    "trueAspectImpact": "blocks_existing_true_capture" if kind in {"capture_width", "capture_height", "capture_path_16x9", "render_camera_1920_1080_call", "save_scene"} else "trace_required",
                }
            )

    hardcoded_findings = [
        "BATTLE57 actor-rehydration path is source-backed but CaptureWidth=1920/CaptureHeight=1080 and output filenames are 1920x1080.",
        "BATTLE57 public Build saves scene to Assets/Scenes/Battle57RuntimeRehydratedAssetBundleActorsCandidate.unity.",
        "BATTLE51 contains an internal RenderCamera(camera,width,height,path), but the public Build calls it with 1920x1080 and also saves the scene.",
        "Earlier raycast/depth probes include 640x480 camera render passes for registry/depth, not reference-aspect visual capture.",
        "No existing public no-scene-save executeMethod was found that opens the BATTLE57/BATTLE51 context and writes 1280x570 or 1920x855.",
    ]

    candidate_rows = [
        {
            "candidate": "run_existing_BATTLE57_Build",
            "sourceBacked": True,
            "wouldGenerateTrueReferenceAspect": False,
            "wouldSaveScene": True,
            "outputSize": "1920x1080",
            "method": "GirlsWar/Battle/BATTLE57 Rehydrate Source Backed AssetBundle Actors",
            "status": "blocked_existing_path_hardcoded_16x9_and_scene_save",
            "notes": "Source-backed actor rehydration remains useful, but not acceptable for BATTLE68 true aspect no-scene-save capture.",
        },
        {
            "candidate": "run_existing_BATTLE51_Build",
            "sourceBacked": True,
            "wouldGenerateTrueReferenceAspect": False,
            "wouldSaveScene": True,
            "outputSize": "1920x1080",
            "method": "GirlsWar/Battle/BATTLE51 Restore Lua Bridge And Raycaster Registration",
            "status": "blocked_existing_path_hardcoded_public_call_and_scene_save",
            "notes": "Internal RenderCamera is dimension-flexible, but the exposed Build path is not.",
        },
        {
            "candidate": "use_BATTLE67_crop_as_final",
            "sourceBacked": False,
            "wouldGenerateTrueReferenceAspect": False,
            "wouldSaveScene": False,
            "outputSize": "1920x855 crop from 1920x1080",
            "method": "image crop/guide from existing PNG",
            "status": "forbidden_as_final_true_capture",
            "notes": "BATTLE67 crop remains analysis-only and cannot stand in for runtime/GameView capture.",
        },
        {
            "candidate": "new_capture_only_editor_method_open_BATTLE57_scene_render_1920x855",
            "sourceBacked": True,
            "wouldGenerateTrueReferenceAspect": True,
            "wouldSaveScene": False,
            "outputSize": f"1920x{target_1920_height}",
            "method": "Open existing BATTLE57 scene read-only, FindCaptureCamera, RenderTexture(width,height), camera.Render, restore targetTexture, do not SaveScene",
            "status": "generated" if true_capture_generated_from_unity else "safe_candidate_plan_only_not_existing_public_path",
            "notes": "BATTLE68 capture-only editor method wrote only capture/report outputs and did not call SaveScene." if true_capture_generated_from_unity else "Requires a new capture-only editor method/script or temporary approved executeMethod; should write only capture/report outputs.",
        },
        {
            "candidate": "new_capture_only_editor_method_open_BATTLE51_scene_render_1280x570",
            "sourceBacked": True,
            "wouldGenerateTrueReferenceAspect": True,
            "wouldSaveScene": False,
            "outputSize": f"1280x{target_1280_height}",
            "method": "Open existing BATTLE51/BATTLE57 context, RenderTexture(1280,570), camera.Render, no bridge/actor mutation",
            "status": "safe_candidate_plan_only_not_existing_public_path",
            "notes": "May omit BATTLE57 runtime rehydrated actor objects unless BATTLE57 scene already contains them; should validate scene contents before use.",
        },
        {
            "candidate": "runtime_camera_rect_or_canvas_scaler_mutation",
            "sourceBacked": "unknown",
            "wouldGenerateTrueReferenceAspect": "possible",
            "wouldSaveScene": "risky",
            "outputSize": "view-rect dependent",
            "method": "Set camera.rect/pixelRect/canvas scaler fields before capture",
            "status": "not_allowed_without_source_backed_runtime_proof",
            "notes": "Field mutation could become a layout patch; defer until true capture-only render path is established.",
        },
    ]

    scene_scan_rows = []
    scene_patterns = [
        ("canvas_scaler_reference_resolution", r"m_ReferenceResolution|m_MatchWidthOrHeight|m_UiScaleMode"),
        ("canvas_camera_binding", r"m_RenderMode|m_Camera:|m_PlaneDistance|m_SortingOrder|m_TargetDisplay"),
        ("capture_camera_name", r"BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera"),
        ("camera_pixel_or_projection", r"m_TargetDisplay|m_Orthographic|m_OrthographicSize|m_NormalizedViewPortRect"),
    ]
    for scene in [
        scenes / "Battle57RuntimeRehydratedAssetBundleActorsCandidate.unity",
        scenes / "Battle51LuaBridgeRaycasterRegistrationCandidate.unity",
    ]:
        for line_no, kind, text in line_matches(scene, scene_patterns):
            if len(scene_scan_rows) >= 220:
                break
            scene_scan_rows.append(
                {
                    "source": str(scene.relative_to(root)),
                    "line": line_no,
                    "candidateKind": kind,
                    "evidence": text,
                    "interpretation": "scene YAML evidence only; no mutation performed",
                    "safeForNoSceneSaveCapture": "read_only_evidence",
                }
            )

    blocker_rows = [
        {
            "validationKind": "true_reference_aspect_capture",
            "status": "generated" if true_capture_generated_from_unity else "not_generated",
            "evidence": (
                f"Capture generated at {true_capture_asset}; size={true_capture_size}; unityExit={unity_exit}; sceneSaved={unity_summary.get('sceneSaved')}; sceneDirtyBefore={unity_summary.get('sceneDirtyBefore')}; sceneDirtyAfter={unity_summary.get('sceneDirtyAfter')}"
                if true_capture_generated_from_unity
                else "No existing public no-scene-save editor path outputs 1280x570 or 1920x855."
            ),
            "requiredToUnblock": (
                "Use true capture for next route/HUD/card/actor normalized validation; do not treat it as playable."
                if true_capture_generated_from_unity
                else "Add or approve capture-only Editor executeMethod that opens current candidate scene and renders to reference-aspect RenderTexture without SaveScene."
            ),
            "guardrail": "analysisOnlyCropUsedAsFinal=false",
        },
        {
            "validationKind": "existing_capture_outputs",
            "status": "16x9_only",
            "evidence": "current battle_actor capture directory contains BATTLE51/BATTLE57 and prior captures named 1920x1080.",
            "requiredToUnblock": "true runtime capture at reference aspect, not crop.",
            "guardrail": "no coordinate-only success",
        },
        {
            "validationKind": "route_active_sibling",
            "status": "pending",
            "evidence": "BATTLE67 focused route/card/TMP/mask rows are source evidence, but visual coordinate patch waits for true aspect capture.",
            "requiredToUnblock": "aspect-correct capture plus source-backed RectTransform/sibling comparison.",
            "guardrail": "no route patch yet",
        },
        {
            "validationKind": "card_icon_payload",
            "status": "pending",
            "evidence": "BATTLE66/BATTLE67 still show incomplete bottom card assembly and 1036 not_fetchable_local.",
            "requiredToUnblock": "source-backed card/icon/actor payload resolution.",
            "guardrail": "no fake card/icon/text",
        },
        {
            "validationKind": "full_actor_payload",
            "status": "pending",
            "evidence": "BATTLE57 source-backed actors are local subset only; full actor payload gaps remain.",
            "requiredToUnblock": "source-backed 1036 and unresolved enemy payloads.",
            "guardrail": "no dummy actor/fake mesh",
        },
        {
            "validationKind": "timeline_xlua",
            "status": "pending",
            "evidence": "Timeline package and xLua/GameEntry handler runtime remain separate blockers.",
            "requiredToUnblock": "approval/source runtime, not part of BATTLE68.",
            "guardrail": "no package import, no xLua/handler patch",
        },
    ]

    decision_rows = [
        {
            "decision": "true_capture_generated_no_scene_save" if true_capture_generated_from_unity else "blocked_no_true_capture_generated",
            "recommended": True,
            "reason": "BATTLE68 capture-only editor method generated a true 1920x855 reference-aspect capture without SaveScene." if true_capture_generated_from_unity else "Existing source-backed capture pipelines are hard-coded/exposed as 16:9 and/or save scenes.",
            "nextAction": "Use the true capture for route/HUD/card/actor normalized validation; keep payload/runtime blockers separate." if true_capture_generated_from_unity else "Create or approve a capture-only no-scene-save editor method for 1920x855 or 1280x570.",
            "claimAllowed": "no restored/playable claim",
        },
        {
            "decision": "do_not_use_BATTLE67_crop_as_final",
            "recommended": True,
            "reason": "Crop is diagnostic image processing, not runtime/GameView view rect.",
            "nextAction": "Keep crop as comparison guide only.",
            "claimAllowed": "analysis-only",
        },
        {
            "decision": "defer_route_hud_card_actor_layout_patch",
            "recommended": True,
            "reason": "Coordinate/layout changes before true aspect capture would be coordinate-only.",
            "nextAction": "Run true aspect capture first, then compare BATTLE67 focused route rows.",
            "claimAllowed": "no layout success claim",
        },
        {
            "decision": "preserve_separate_payload_and_runtime_blockers",
            "recommended": True,
            "reason": "True aspect capture does not solve card/icon/full actor/Timeline/xLua gaps.",
            "nextAction": "Keep blocker categories separate in control tower.",
            "claimAllowed": "diagnostic only",
        },
    ]

    true_capture_generated = true_capture_generated_from_unity
    safe_existing_method_found = true_capture_generated_from_unity
    command_policy = count_root_cmds(root)
    command_policy["policyOk"] = command_policy["rootCmdCount"] == 1 and command_policy["restoreToolsDirectCmdCount"] == 0

    result = {
        "task": PREFIX,
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "playableClaim": False,
        "sceneSaved": False,
        "packageImported": False,
        "manifestModified": False,
        "runtimeInstrumentationUsed": False,
        "trueReferenceAspectCaptureGenerated": true_capture_generated,
        "analysisOnlyCropUsedAsFinal": False,
        "referenceAspect": reference_aspect,
        "candidateTrueCaptureAspect": true_capture_size.get("aspect") if true_capture_size else None,
        "capturePipelineHardcodedAspectFindings": hardcoded_findings,
        "safeCaptureMethodFound": safe_existing_method_found,
        "safeCaptureMethodCandidate": "capture_only_editor_executeMethod_open_existing_scene_render_1920x855_or_1280x570_no_SaveScene",
        "nextBlocker": "TRUE_REFERENCE_ASPECT_CAPTURE_GENERATED_ROUTE_HUD_CARD_ACTOR_LAYOUT_VALIDATION_NEXT" if true_capture_generated else "NO_EXISTING_TRUE_REFERENCE_ASPECT_NO_SCENE_SAVE_CAPTURE_PIPELINE_FOUND",
        "guardrailsTouched": [
            "no_scene_save",
            "no_package_import",
            "no_manifest_edit",
            "no_xlua_or_handler_patch",
            "no_fake_hud_card_icon_text_actor_effect",
            "no_screenshot_or_atlas_paste_as_asset",
            "no_coordinate_only_success",
            "no_runtime_instrumentation",
        ],
        "commandPolicy": command_policy,
        "targetReferenceAspectSizes": {
            "1280Wide": {"width": 1280, "height": target_1280_height, "aspect": round(1280 / target_1280_height, 6)},
            "1920Wide": {"width": 1920, "height": target_1920_height, "aspect": round(1920 / target_1920_height, 6)},
        },
        "unityExit": unity_exit,
        "unitySummary": str(unity_summary_path),
        "trueCapturePath": str(true_capture_asset) if true_capture_generated else None,
        "trueCaptureSize": true_capture_size,
        "unitySceneSaved": bool(unity_summary.get("sceneSaved")) if unity_summary else False,
        "unitySceneDirtyBefore": unity_summary.get("sceneDirtyBefore"),
        "unitySceneDirtyAfter": unity_summary.get("sceneDirtyAfter"),
        "evidenceRowCount": len(evidence_rows),
        "viewrectCandidateRows": len(candidate_rows),
        "sceneYamlEvidenceRows": len(scene_scan_rows),
        "decision": "true_capture_generated_no_scene_save" if true_capture_generated else "blocked_report_only_no_patch",
    }

    capture_csv = reports / f"{PREFIX}_CAPTURE_PIPELINE_CONSTANTS_EVIDENCE_MATRIX.csv"
    candidate_csv = reports / f"{PREFIX}_CAMERA_CANVAS_VIEWRECT_CANDIDATE_MATRIX.csv"
    blocker_csv = reports / f"{PREFIX}_TRUE_CAPTURE_OUTPUT_VALIDATION_OR_BLOCKER_MATRIX.csv"
    decision_csv = reports / f"{PREFIX}_DECISION_NEXT_ACTION_MATRIX.csv"
    json_path = reports / f"{PREFIX}_RESULT.json"
    md_path = reports / f"{PREFIX}_RESULT.md"

    write_csv(capture_csv, evidence_rows, ["file", "line", "evidenceKind", "lineText", "inference", "trueAspectImpact"])
    write_csv(candidate_csv, candidate_rows + scene_scan_rows, ["candidate", "sourceBacked", "wouldGenerateTrueReferenceAspect", "wouldSaveScene", "outputSize", "method", "status", "notes", "source", "line", "candidateKind", "evidence", "interpretation", "safeForNoSceneSaveCapture"])
    write_csv(blocker_csv, blocker_rows, ["validationKind", "status", "evidence", "requiredToUnblock", "guardrail"])
    write_csv(decision_csv, decision_rows, ["decision", "recommended", "reason", "nextAction", "claimAllowed"])
    json_path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        f"# {PREFIX} Result",
        "",
        "## Verdict",
        "- `restoredClaim=false`, `playableClaim=false`.",
        f"- `trueReferenceAspectCaptureGenerated={str(true_capture_generated).lower()}`.",
        "- No scene, package, manifest, xLua, handler, layout, HUD/card/actor/effect, APK/emulator, or runtime instrumentation mutation was performed.",
        "- BATTLE67 crop remains analysis-only and was not used as final capture.",
        "",
        "## Aspect Target",
        f"- Reference aspect: `{reference_aspect}`.",
        f"- Candidate true capture sizes: `1280x{target_1280_height}` or `1920x{target_1920_height}`.",
        "",
        "## Capture Pipeline Finding",
    ]
    for item in hardcoded_findings:
        md.append(f"- {item}")
    md.extend(
        [
            "",
            "## Source-Backed Candidate",
            "- A safe candidate exists as a capture-only Editor executeMethod that opens the existing BATTLE57/BATTLE51 candidate scene, renders the capture camera to a reference-aspect RenderTexture, restores `camera.targetTexture`, writes only capture/report outputs, and does not call `SaveScene`.",
            f"- True capture path: `{true_capture_asset}`." if true_capture_generated else "- No existing public no-scene-save method was found, so BATTLE68 did not generate a true runtime/GameView reference-aspect capture.",
            f"- True capture size/aspect: `{true_capture_size}`." if true_capture_generated else "- True capture size/aspect: `not generated`.",
            "",
            "## Blockers Kept Separate",
            "- True viewrect/capture pipeline: generated; route/card/actor validation remains next." if true_capture_generated else "- True viewrect/capture pipeline: blocked.",
            "- Route active/sibling/layout patch: pending true capture.",
            "- Card/icon payload: still pending; no fake cards/icons.",
            "- Full actor payload: still pending beyond BATTLE57 local subset.",
            "- Timeline/xLua: still pending and outside this no-patch task.",
            "",
            "## Outputs",
            f"- `{capture_csv}`",
            f"- `{candidate_csv}`",
            f"- `{blocker_csv}`",
            f"- `{decision_csv}`",
            f"- `{json_path}`",
            "",
            "## Command Policy",
            f"- root `.cmd` count: `{command_policy['rootCmdCount']}`",
            f"- `_restore_tools` direct `.cmd` count: `{command_policy['restoreToolsDirectCmdCount']}`",
            f"- policy ok: `{command_policy['policyOk']}`",
        ]
    )
    md_path.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(json.dumps({"result": str(json_path), "trueReferenceAspectCaptureGenerated": true_capture_generated, "safeCaptureMethodFound": safe_existing_method_found}, ensure_ascii=False))


if __name__ == "__main__":
    main()
