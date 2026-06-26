import csv
import json
import struct
from datetime import datetime
from pathlib import Path


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = ROOT / "reports" / "maininterface"
CAPTURE_DIR = ROOT / "girlswar_maininterface_unity" / "Assets" / "RestoreCaptures"
REFERENCE_IMAGE = Path(r"C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png")
VIDEO_REFERENCE_JSON = ROOT / "reports" / "video_reference" / "REFERENCE_MP4_VISUAL_CHECKPOINT_MATRIX_20260626_060212.json"
UI146_JSON = REPORT_DIR / "MAININTERFACE_146_RUNTIME_SNAPSHOT_PROBE_SPEC_AND_SOURCE_HOOK_POINTS_NO_EXECUTION_NO_PATCH_RESULT.json"
UI144_METRICS = REPORT_DIR / "MAININTERFACE_144_reference_diff_region_metrics_vs_ui128_ui136_ui144.csv"
UI128_METRICS = REPORT_DIR / "MAININTERFACE_128_reference_diff_regions.csv"

PREFIX = "MAININTERFACE_147_REFERENCE_ASPECT_CAPTURE_ROOTCAUSE_CONSOLIDATION_NO_PATCH"


def png_size(path: Path):
    with path.open("rb") as f:
        header = f.read(24)
    if len(header) < 24 or header[:8] != b"\x89PNG\r\n\x1a\n":
        raise ValueError(f"not a PNG: {path}")
    return struct.unpack(">II", header[16:24])


def command_policy():
    root_cmds = sorted(p.name for p in ROOT.glob("*.cmd"))
    direct_restore_cmds = sorted(p.name for p in (ROOT / "_restore_tools").glob("*.cmd")) if (ROOT / "_restore_tools").exists() else []
    return {
        "rootCmdCount": len(root_cmds),
        "rootCmdFiles": root_cmds,
        "restoreToolsDirectCmdCount": len(direct_restore_cmds),
        "restoreToolsDirectCmdFiles": direct_restore_cmds,
        "policySatisfied": len(root_cmds) == 1 and len(direct_restore_cmds) == 0,
    }


def read_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def read_csv_rows(path: Path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows, fieldnames):
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def capture_label(path: Path):
    name = path.stem
    for prefix in [
        "maininterface_",
        "maininterface",
    ]:
        name = name.removeprefix(prefix)
    return name


def aspect_row(label, path, width, height, reference_aspect, source, include=True):
    aspect = width / height
    aspect_correct_height = width / reference_aspect
    return {
        "label": label,
        "sourceType": source,
        "path": str(path),
        "includedAsRelevant": str(include),
        "width": width,
        "height": height,
        "aspect": round(aspect, 6),
        "referenceAspect": round(reference_aspect, 6),
        "aspectDeltaVsReference": round(aspect - reference_aspect, 6),
        "aspectDeltaPctVsReference": round(((aspect - reference_aspect) / reference_aspect) * 100, 3),
        "aspectCorrectHeightAtThisWidth": round(aspect_correct_height, 2),
        "heightMinusAspectCorrectHeight": round(height - aspect_correct_height, 2),
        "finding": (
            "reference_anchor"
            if abs(aspect - reference_aspect) < 0.0001
            else "candidate_is_wider_than_reference" if aspect > reference_aspect
            else "candidate_is_taller_than_reference"
        ),
    }


def find_candidate_captures(reference_aspect):
    explicit_names = [
        "maininterface_route_spine_runtime_ui_material_bound_1680x720.png",
        "maininterface_restored_1680x720.png",
        "maininterface_ui124_hero1005_spine_1680x720.png",
        "maininterface_ui126_oldroot_hero1005_candidate_1680x720.png",
        "maininterface_ui127_oldroot_bg1005_runtime_candidate_1680x720.png",
        "maininterface_ui128_oldroot_runtime_activity_text_tmp_click_candidate_1680x720.png",
        "maininterface_ui135_hero1005_homepara_backfront_candidate_1680x720.png",
        "maininterface_ui136_uidock_openstack_candidate_1680x720.png",
        "maininterface_ui144_uidock_renderer_rootcanvas_candidate_1680x720.png",
    ]
    rows = []
    for name in explicit_names:
        path = CAPTURE_DIR / name
        if not path.exists():
            continue
        width, height = png_size(path)
        rows.append(aspect_row(capture_label(path), path, width, height, reference_aspect, "candidate_capture", True))

    # Include older 16:9 capture as a historical caution if present.
    old = CAPTURE_DIR / "maininterface_restored_1280x720.png"
    if old.exists():
        width, height = png_size(old)
        rows.append(aspect_row(capture_label(old), old, width, height, reference_aspect, "historical_capture", True))

    return rows


def metric_lookup():
    rows = read_csv_rows(UI144_METRICS) + read_csv_rows(UI128_METRICS)
    keep = {}
    for row in rows:
        key = (row.get("comparison") or row.get("captureLabel"), row.get("region"))
        keep[key] = row
    return keep


def make_visible_mismatch_matrix():
    return [
        {
            "area": "capture aspect / view rect",
            "visibleMismatchAfterAspectNormalization": "partial",
            "aspectOrFramingContribution": "yes_minor_to_moderate_for_MainInterface_candidates",
            "requiresRuntimeSnapshot": "no_for_aspect_measurement_yes_for_final_layout_decision",
            "sourceKnownNow": "reference image 1180x526 and mp4 1280x570 are both ~2.24; latest UI captures are 1680x720 ~2.333",
            "cannotDecideWithoutRuntime": "whether production GameView/root Canvas used exactly the attached 2.24 view rect for live UI_Dock/MainPage stack",
            "decision": "normalize comparisons before coordinates; no coordinate patch",
            "evidence": "CONTROL_TOWER_STATUS_20260626_060425; REFERENCE_MP4_VISUAL_CHECKPOINT_MATRIX_20260626_060212; capture PNG dimensions",
        },
        {
            "area": "old-root vs new-root / UI_MainInterface_old",
            "visibleMismatchAfterAspectNormalization": "yes",
            "aspectOrFramingContribution": "not_primary",
            "requiresRuntimeSnapshot": "yes_for_final_open_stack_parent_depth",
            "sourceKnownNow": "UI126 found old-root closer to reference than new-root; UI128 safe old-root remains best visual baseline",
            "cannotDecideWithoutRuntime": "production UI_Dock/UI_MainPage parent/group/depth and active form stack",
            "decision": "use old-root as safe analysis baseline, no production promotion without runtime stack/depth",
            "evidence": "MAININTERFACE_126 result; MAININTERFACE_128 result; MAININTERFACE_145/146 runtime gate",
        },
        {
            "area": "UI_Dock bottom nav / source root",
            "visibleMismatchAfterAspectNormalization": "yes",
            "aspectOrFramingContribution": "not_primary",
            "requiresRuntimeSnapshot": "yes_for_parent_depth_canvashelper_cascade",
            "sourceKnownNow": "UI_Dock open-stack source is strong; UI144 imported real sp_* renderers and Canvas sorting but still trailed UI128",
            "cannotDecideWithoutRuntime": "DisableUILayer runtime depth, parent object path, CanvasHelper OnDepthChanged cascade, active mask/stencil if any",
            "decision": "UI_Dock simple sibling/root-canvas reconstruction not promoted",
            "evidence": "MAININTERFACE_136, UI144, UI145, UI146",
        },
        {
            "area": "route/world cluster active and sibling order",
            "visibleMismatchAfterAspectNormalization": "yes_where_new_root_is_used",
            "aspectOrFramingContribution": "not_primary",
            "requiresRuntimeSnapshot": "yes_or_exact_source SetActive/sibling evidence",
            "sourceKnownNow": "guardrails preserve right/node_middle/wanfaWorldNode/worldwanfaBtn; no source-backed hide has been proven",
            "cannotDecideWithoutRuntime": "normal home activeSelf/activeInHierarchy/siblingIndex for guarded route/world nodes",
            "decision": "no hide or sibling patch",
            "evidence": "UI125/UI126/UI131/UI146 guarded fields",
        },
        {
            "area": "activity stack / face activity / right dynamic icons",
            "visibleMismatchAfterAspectNormalization": "yes",
            "aspectOrFramingContribution": "not_primary",
            "requiresRuntimeSnapshot": "yes",
            "sourceKnownNow": "ActMgr:GetActInMain selects runtime server/account/redpoint-dependent entries; no local snapshot can drive it",
            "cannotDecideWithoutRuntime": "activity ids, show/open state, player vip/level, redpoint/client callbacks, localized labels/spine ids",
            "decision": "no activity slot hide/label/icon/spine patch",
            "evidence": "MAININTERFACE_128, UI129, UI130, UI146",
        },
        {
            "area": "top profile / currency / chat text",
            "visibleMismatchAfterAspectNormalization": "yes",
            "aspectOrFramingContribution": "not_primary",
            "requiresRuntimeSnapshot": "yes",
            "sourceKnownNow": "static font/material evidence exists, but values/text are player/chat/runtime-driven",
            "cannotDecideWithoutRuntime": "PlayerMgr.PlayerInfo, currency, chat state, localization keys actually selected at runtime",
            "decision": "no fake account/currency/chat text",
            "evidence": "MAININTERFACE_129, UI132, UI146",
        },
        {
            "area": "TMP/font/material/autosize",
            "visibleMismatchAfterAspectNormalization": "minor_remaining",
            "aspectOrFramingContribution": "secondary",
            "requiresRuntimeSnapshot": "only_for_dynamic_labels",
            "sourceKnownNow": "UI132 audited 80 text nodes; 7 static source-identified nodes already bound; dynamic labels excluded",
            "cannotDecideWithoutRuntime": "dynamic label content and selected localized keys",
            "decision": "static patch lane exhausted for now; no dynamic text edits",
            "evidence": "MAININTERFACE_132",
        },
        {
            "area": "mask/stencil/material state",
            "visibleMismatchAfterAspectNormalization": "possible",
            "aspectOrFramingContribution": "not_primary",
            "requiresRuntimeSnapshot": "yes_for_runtime_mask_stencil_state",
            "sourceKnownNow": "UI145 found 0 direct Mask/RectMask2D under Dock roots, but runtime material/stencil/canvas state is still unobserved",
            "cannotDecideWithoutRuntime": "active runtime mask/stencil/material states and SkeletonGraphic CanvasRenderer depth",
            "decision": "no invented mask or stencil patch",
            "evidence": "MAININTERFACE_145, UI146 runtimeMaskStencil fields",
        },
    ]


def make_root_cause_matrix():
    return [
        {
            "rootCauseCategory": "aspect_or_capture_framing_contributor",
            "classification": "contributor_not_primary",
            "evidenceSummary": "Attached reference 1180x526 aspect 2.2433 and mp4 1280x570 aspect 2.2456 match each other; latest UI candidates are 1680x720 aspect 2.3333, about 4.0% wider.",
            "staticPatchPossible": "false",
            "runtimeSnapshotRequired": "false_for_measurement_true_for_production_view_rect_confirmation",
            "nextAction": "Compare inside normalized ~2.24 view rect before judging coordinates.",
        },
        {
            "rootCauseCategory": "source_root_or_form_stack_required_runtime_snapshot",
            "classification": "requires_runtime_snapshot",
            "evidenceSummary": "UI_MainInterface_old is visually closer, but UI_Dock/UI_MainPage are separate source roots and final parent/group/depth are not statically recovered.",
            "staticPatchPossible": "false",
            "runtimeSnapshotRequired": "true",
            "nextAction": "Fill UI146 form parent/group/depth/CanvasHelper fields.",
        },
        {
            "rootCauseCategory": "route_active_sibling_required_runtime_snapshot",
            "classification": "requires_runtime_snapshot_or_stronger_source_SetActive_evidence",
            "evidenceSummary": "Route/world nodes are guarded; no source-backed hide/sibling patch exists.",
            "staticPatchPossible": "false",
            "runtimeSnapshotRequired": "true",
            "nextAction": "Capture activeSelf/activeInHierarchy/siblingIndex for guarded route/world nodes in real runtime snapshot.",
        },
        {
            "rootCauseCategory": "dynamic_activity_account_chat_currency_required_runtime_snapshot",
            "classification": "requires_runtime_snapshot",
            "evidenceSummary": "UI128/UI129/UI130 prove activity/chat/account/currency state depends on runtime activitys, PlayerInfo, redpoints, chat/currency state and localization selections.",
            "staticPatchPossible": "false",
            "runtimeSnapshotRequired": "true",
            "nextAction": "Provide UI130-compatible runtime snapshot values; do not infer from video/reference.",
        },
        {
            "rootCauseCategory": "tmp_mask_material_static_known_or_runtime_missing",
            "classification": "mixed_static_known_and_runtime_missing",
            "evidenceSummary": "Static TMP material lane was audited/exhausted in UI132. Mask/stencil has source scan but runtime material/stencil and CanvasRenderer depth remain unobserved.",
            "staticPatchPossible": "false",
            "runtimeSnapshotRequired": "true_for_dynamic_labels_and_runtime_mask_stencil",
            "nextAction": "Keep no-patch until runtime snapshot/dump supplies dynamic text and mask/stencil fields.",
        },
    ]


def summarize_best_metrics():
    rows = read_csv_rows(UI144_METRICS)
    summaries = {}
    for row in rows:
        if row.get("region") == "full" and row.get("comparison", "").startswith("reference_vs_"):
            summaries[row["comparison"].replace("reference_vs_", "")] = {
                "fullCorrelation": float(row["pixelCorrelation"]),
                "meanAbsDiff": float(row["meanAbsDiff"]),
                "changedPixelRatio30": float(row["changedPixelRatio30"]),
            }
    return summaries


def main():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    now = datetime.now().isoformat(timespec="seconds")

    ref_w, ref_h = png_size(REFERENCE_IMAGE)
    reference_aspect = ref_w / ref_h
    video = read_json(VIDEO_REFERENCE_JSON)
    video_source = video["source"]
    video_aspect = video_source["videoAspect"]
    ui146 = read_json(UI146_JSON)

    aspect_rows = [
        aspect_row("attached_reference_image", REFERENCE_IMAGE, ref_w, ref_h, reference_aspect, "reference_image", True),
        aspect_row(
            "reference_mp4_0s_home_layout_class",
            Path(video_source["video"]),
            video_source["videoWidth"],
            video_source["videoHeight"],
            reference_aspect,
            "reference_video",
            True,
        ),
    ] + find_candidate_captures(reference_aspect)

    mismatch_rows = make_visible_mismatch_matrix()
    root_cause_rows = make_root_cause_matrix()
    metrics = summarize_best_metrics()

    aspect_csv = REPORT_DIR / f"{PREFIX}_reference_vs_candidate_capture_aspect_matrix.csv"
    mismatch_csv = REPORT_DIR / f"{PREFIX}_visible_mismatch_vs_runtime_snapshot_required_matrix.csv"
    root_cause_csv = REPORT_DIR / f"{PREFIX}_root_cause_next_action_decision_matrix.csv"
    result_json = REPORT_DIR / f"{PREFIX}_RESULT.json"
    result_md = REPORT_DIR / f"{PREFIX}_RESULT.md"

    write_csv(
        aspect_csv,
        aspect_rows,
        [
            "label",
            "sourceType",
            "path",
            "includedAsRelevant",
            "width",
            "height",
            "aspect",
            "referenceAspect",
            "aspectDeltaVsReference",
            "aspectDeltaPctVsReference",
            "aspectCorrectHeightAtThisWidth",
            "heightMinusAspectCorrectHeight",
            "finding",
        ],
    )
    write_csv(
        mismatch_csv,
        mismatch_rows,
        [
            "area",
            "visibleMismatchAfterAspectNormalization",
            "aspectOrFramingContribution",
            "requiresRuntimeSnapshot",
            "sourceKnownNow",
            "cannotDecideWithoutRuntime",
            "decision",
            "evidence",
        ],
    )
    write_csv(
        root_cause_csv,
        root_cause_rows,
        [
            "rootCauseCategory",
            "classification",
            "evidenceSummary",
            "staticPatchPossible",
            "runtimeSnapshotRequired",
            "nextAction",
        ],
    )

    candidate_aspects = [
        {
            "label": row["label"],
            "path": row["path"],
            "width": row["width"],
            "height": row["height"],
            "aspect": row["aspect"],
            "aspectDeltaPctVsReference": row["aspectDeltaPctVsReference"],
        }
        for row in aspect_rows
        if row["sourceType"] in {"candidate_capture", "historical_capture"}
    ]

    changed_files = [
        str(result_md),
        str(result_json),
        str(aspect_csv),
        str(mismatch_csv),
        str(root_cause_csv),
        str(ROOT / "_restore_tools" / "scripts" / "maininterface147_reference_aspect_rootcause_consolidation.py"),
    ]

    result = {
        "generatedAt": now,
        "restoredClaim": False,
        "scenePatchApplied": False,
        "runtimeInstrumentationExecuted": False,
        "snapshotValuesInvented": False,
        "referenceAspect": {
            "attachedReferenceImage": round(reference_aspect, 6),
            "referenceImageWidth": ref_w,
            "referenceImageHeight": ref_h,
            "referenceMp4": video_aspect,
            "referenceMp4Width": video_source["videoWidth"],
            "referenceMp4Height": video_source["videoHeight"],
        },
        "candidateCaptureAspects": candidate_aspects,
        "aspectMismatchContributor": "minor_to_moderate_coordinate_comparison_contributor_not_primary_root_cause",
        "staticPatchPossibleWithoutRuntime": False,
        "approvalRequiredForRuntimeDump": True,
        "ui146RequiredRuntimeFieldsCount": ui146.get("requiredRuntimeFieldsCount"),
        "ui146StaticKnownFieldsCount": ui146.get("staticKnownFieldsCount"),
        "bestKnownMetrics": metrics,
        "rootCauseSplit": {
            "aspect_or_capture_framing_contributor": "candidate captures are ~2.333:1 while reference/video are ~2.244:1; normalize before coordinate analysis",
            "source_root_or_form_stack_required_runtime_snapshot": "UI_MainInterface_old is closer, but UI_Dock/UI_MainPage parent/group/depth remains runtime-gated",
            "route_active_sibling_required_runtime_snapshot": "guarded route/world nodes cannot be hidden or reordered without runtime/source active-state proof",
            "dynamic_activity_account_chat_currency_required_runtime_snapshot": "activity/chat/top state needs UI130-compatible server/account snapshot",
            "tmp_mask_material_static_known_or_runtime_missing": "static TMP lane exhausted; runtime mask/stencil/material and dynamic text remain missing",
        },
        "outputs": {
            "md": str(result_md),
            "json": str(result_json),
            "captureAspectCsv": str(aspect_csv),
            "visibleMismatchCsv": str(mismatch_csv),
            "rootCauseCsv": str(root_cause_csv),
        },
        "changedFiles": changed_files,
        "nextBlocker": "Need approved real runtime snapshot/dump for UI_Dock/UI_MainPage form parent/group/depth/CanvasHelper cascade and UI130-compatible dynamic activity/account/chat/currency values; also normalize future visual comparisons to the ~2.24:1 reference view rect.",
        "guardrailsTouched": [],
        "commandPolicy": command_policy(),
    }

    result_json.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = f"""# MAININTERFACE_147 Reference Aspect Capture Root-cause Consolidation

Generated: {now}

## Verdict

- restoredClaim: `false`
- scenePatchApplied: `false`
- runtimeInstrumentationExecuted: `false`
- snapshotValuesInvented: `false`
- staticPatchPossibleWithoutRuntime: `false`
- approvalRequiredForRuntimeDump: `true`

## Aspect Finding

- Attached reference image: `{ref_w}x{ref_h}`, aspect `{reference_aspect:.4f}`
- `참고.mp4`: `{video_source["videoWidth"]}x{video_source["videoHeight"]}`, aspect `{video_aspect:.4f}`
- Latest MainInterface candidate captures are mostly `1680x720`, aspect `2.3333`.

The reference image and video agree on a wide `~2.24:1` home layout class. Current MainInterface candidates are slightly wider, about `{((1680/720-reference_aspect)/reference_aspect)*100:.2f}%` over the attached reference. This is a real comparison/framing contributor, but it does not explain the remaining UI mismatch by itself: UI128 still beats UI144 after source-backed Dock renderer/root Canvas reconstruction, and the unresolved differences map to runtime form stack/depth plus dynamic activity/account/chat/currency state.

## Root-cause Split

| cause | decision |
| --- | --- |
| aspect/capture framing | contributor; normalize future comparisons to `~2.24:1`, no coordinate patch |
| source root/form stack | runtime snapshot required for `UI_Dock`/`UI_MainPage` parent/group/depth |
| route/world active/sibling | runtime/source active-state proof required; guarded nodes stay untouched |
| activity/account/chat/currency | UI130-compatible runtime snapshot required |
| TMP/font/material/mask | static TMP lane already exhausted; runtime mask/stencil and dynamic labels still missing |

## Metrics Context

- UI128 safe old-root baseline full correlation: `{metrics.get("ui128", {}).get("fullCorrelation", "unknown")}`
- UI136 source-built Dock sibling full correlation: `{metrics.get("ui136", {}).get("fullCorrelation", "unknown")}`
- UI144 source-backed Dock renderer/root Canvas full correlation: `{metrics.get("ui144", {}).get("fullCorrelation", "unknown")}`

UI144 proves the renderer import path, but it still trails UI128 and is not promoted.

## Outputs

- Capture aspect matrix: `{aspect_csv}`
- Visible mismatch/runtime matrix: `{mismatch_csv}`
- Root-cause decision matrix: `{root_cause_csv}`
- JSON: `{result_json}`

## Next Blocker

Need approved real runtime snapshot/dump for `UI_Dock`/`UI_MainPage` form parent/group/depth/`YouYouCanvasHelper` cascade and UI130-compatible dynamic activity/account/chat/currency values. Future visual comparisons should also be normalized to the `~2.24:1` reference view rect before any coordinate judgment.

## Command Policy

- root `.cmd` count: `{result["commandPolicy"]["rootCmdCount"]}`
- `_restore_tools` direct `.cmd` count: `{result["commandPolicy"]["restoreToolsDirectCmdCount"]}`
- policySatisfied: `{result["commandPolicy"]["policySatisfied"]}`
"""
    result_md.write_text(md, encoding="utf-8")

    print(json.dumps({"md": str(result_md), "json": str(result_json), "aspectRows": len(aspect_rows)}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
