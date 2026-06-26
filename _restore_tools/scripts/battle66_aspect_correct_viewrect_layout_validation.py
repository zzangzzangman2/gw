from __future__ import annotations

import csv
import json
import math
import struct
from datetime import datetime
from pathlib import Path


PREFIX = "BATTLE_66_ASPECT_CORRECT_VIEWRECT_ROUTE_HUD_CARD_ACTOR_LAYOUT_VALIDATION_NO_PATCH"


def read_json(path: Path, default=None):
    if not path.exists():
        return default
    return json.loads(path.read_text(encoding="utf-8"))


def read_csv(path: Path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows, fieldnames):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


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


def yes(value):
    return str(value).lower() == "true"


def count_root_cmds(root: Path):
    root_cmd = len(list(root.glob("*.cmd")))
    direct_restore_cmd = len(list((root / "_restore_tools").glob("*.cmd"))) if (root / "_restore_tools").exists() else 0
    return {
        "rootCmdCount": root_cmd,
        "restoreToolsDirectCmdCount": direct_restore_cmd,
        "policy": "root .cmd count 1 / _restore_tools direct .cmd count 0 maintained",
        "policyOk": root_cmd == 1 and direct_restore_cmd == 0,
    }


def ratio_range_to_text(values):
    return "/".join(str(v) for v in values)


def main():
    root = Path(__file__).resolve().parents[2]
    reports = root / "reports" / "battle"
    video_reports = root / "reports" / "video_reference"
    unity = root / "girlswar_battle_unity"

    ref_json_path = video_reports / "REFERENCE_MP4_VISUAL_CHECKPOINT_MATRIX_20260626_060212.json"
    b54_json_path = reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_RESULT.json"
    b57_json_path = reports / "BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_RESULT.json"

    ref = read_json(ref_json_path, {})
    b54 = read_json(b54_json_path, {})
    b57 = read_json(b57_json_path, {})

    routes = read_csv(reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_ROUTES.csv")
    cards = read_csv(reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_HERO_CARDS.csv")
    actors = read_csv(reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_ACTORS.csv")
    tmp_rows = read_csv(reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_TMP_TEXT.csv")
    mask_rows = read_csv(reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_MASKS.csv")
    button_rows = read_csv(reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_BUTTON_ROUTES.csv")

    b57_capture = root / "girlswar_battle_unity" / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle57RuntimeRehydratedAssetBundleActorsCandidate_1920x1080.png"
    b51_capture = root / "girlswar_battle_unity" / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle51LuaBridgeRaycasterRegistrationCandidate_1920x1080.png"
    b57_size = image_size(b57_capture)
    b51_size = image_size(b51_capture)

    source_info = ref.get("source") or {}
    current_candidate = ref.get("currentCandidateComparison") or {}
    reference_video = {
        "path": source_info.get("video"),
        "width": source_info.get("videoWidth"),
        "height": source_info.get("videoHeight"),
        "aspect": source_info.get("videoAspect"),
    }
    attached_image = {
        "path": source_info.get("mainReferenceImage"),
        "width": source_info.get("mainReferenceImageWidth"),
        "height": source_info.get("mainReferenceImageHeight"),
        "aspect": source_info.get("mainReferenceImageAspect"),
    }
    reference_aspect = float(reference_video.get("aspect") or attached_image.get("aspect") or 2.2456)
    candidate_width = (b57_size or b51_size or {"width": 1920})["width"]
    candidate_height = (b57_size or b51_size or {"height": 1080})["height"]
    candidate_aspect = round(candidate_width / candidate_height, 6)
    content_height = round(candidate_width / reference_aspect)
    extra_vertical = candidate_height - content_height
    letterbox_top = extra_vertical / 2.0
    aspect_rect = {
        "x": 0,
        "y": round(letterbox_top, 3),
        "width": candidate_width,
        "height": content_height,
        "bottom": round(letterbox_top + content_height, 3),
        "extraVerticalPixels": round(extra_vertical, 3),
        "normalized": {
            "x": 0,
            "y": round(letterbox_top / candidate_height, 6),
            "width": 1,
            "height": round(content_height / candidate_height, 6),
        },
        "note": "analysis-only content rect for reference-aspect comparison; not a patch",
    }

    summary = b54.get("summary") or b54
    route_count = int(summary.get("routeCount", len(routes)) or len(routes))
    active_route_zero_scale = int(summary.get("activeRouteZeroScaleCount", 0) or 0)
    inactive_critical = int(summary.get("inactiveCriticalCount", 0) or 0)
    actor_rows = int(summary.get("actorRows", len(actors)) or len(actors))
    active_actor_rows = int(summary.get("activeActorRows", sum(1 for r in actors if yes(r.get("activeInHierarchy")))) or 0)
    active_loadable_actor_rows = int(summary.get("activeLoadableActorRows", sum(1 for r in actors if yes(r.get("activeInHierarchy")) and r.get("payloadLocalStatus") == "loadable")) or 0)
    card_rows = int(summary.get("cardRows", len(cards)) or len(cards))
    active_card_rows = int(summary.get("activeCardRows", sum(1 for r in cards if yes(r.get("activeInHierarchy")))) or 0)
    active_cards_with_sprite = int(summary.get("activeCardsWithSpriteRows", 0) or 0)
    text_rows = int(summary.get("textRows", len(tmp_rows)) or len(tmp_rows))
    mask_count = int(summary.get("maskRows", len(mask_rows)) or len(mask_rows))
    mask_component_rows = int(summary.get("maskComponentRows", sum(1 for r in mask_rows if yes(r.get("hasMaskComponent")))) or 0)
    mask_name_only_rows = int(summary.get("maskNameOnlyRows", mask_count - mask_component_rows) or 0)
    negative_spacing_rows = int(summary.get("negativeCharacterSpacingRows", sum(1 for r in tmp_rows if (r.get("characterSpacing") or "0").startswith("-"))) or 0)
    autosize_on_rows = sum(1 for r in tmp_rows if str(r.get("enableAutoSizing")) == "1")

    reference_ranges = {
        "aspect_view_rect": "~2.24:1 reference; current comparison requires aspect-correct content rect",
        "top_hud": "reference y~0.03-0.14, centered VS/wave under center",
        "right_rail": "reference x~0.90-0.96, y~0.38-0.59 AUTO/play/x2 stack",
        "bottom_cards": "reference five-card region x~0.30-0.71, y~0.80-1.00",
        "friendly_formation": "reference friendly units x~0.18-0.45, y~0.25-0.86",
        "enemy_formation": "reference enemies x~0.55-0.82, y~0.25-0.82",
        "tmp_text": "compact high-contrast Korean labels; exact prefab/runtime values required",
        "mask_stencil": "screen/portrait/stencil effects require working Mask/Stencil evidence",
    }

    layout_rows = [
        {
            "checkpoint": "aspect_view_rect",
            "referenceRegion": reference_ranges["aspect_view_rect"],
            "currentEvidence": f"referenceAspect={reference_aspect}; candidateCaptureAspect={candidate_aspect}; captures={candidate_width}x{candidate_height}",
            "aspectCorrectedInterpretation": f"contentRect={aspect_rect['x']}/{aspect_rect['y']}/{aspect_rect['width']}/{aspect_rect['height']} normalizedY={aspect_rect['normalized']['y']}",
            "status": "mismatch",
            "blockerCategory": "wrong_render_aspect_view_rect",
            "allowedNextStep": "reproduce candidate capture with reference-aspect GameView/camera/render rect before layout patch",
            "forbiddenAction": "coordinate-only success or stretching current 16:9 capture",
        },
        {
            "checkpoint": "top_hud_root_top_topcenter",
            "referenceRegion": reference_ranges["top_hud"],
            "currentEvidence": f"BATTLE54 routeRows={route_count}; inactiveCritical={inactive_critical}; {current_candidate.get('topHudFinding', 'current control tower observed top HUD y~0.19-0.28 in 16:9 capture')}",
            "aspectCorrectedInterpretation": "raw 16:9 coordinate comparison invalid; approximate content-rect y still does not prove reference match",
            "status": "mismatch_needs_aspect_correct_reprobe",
            "blockerCategory": "wrong_render_aspect_view_rect_plus_route_validation_pending",
            "allowedNextStep": "after aspect-correct capture, validate original RectTransform active/sibling/canvas ordering",
            "forbiddenAction": "manual coordinate patch without source-backed route evidence",
        },
        {
            "checkpoint": "right_control_rail_buttons",
            "referenceRegion": reference_ranges["right_rail"],
            "currentEvidence": f"BATTLE54 buttonRows={len(button_rows)}; BATTLE58 active/interactable raycast buttons existed but Lua lifecycle/listeners stayed 0",
            "aspectCorrectedInterpretation": "input/raycast evidence is not enough for visual/layout or original handler proof",
            "status": "mismatch_needs_aspect_correct_reprobe",
            "blockerCategory": "wrong_render_aspect_view_rect_plus_xlua_handler_blocker",
            "allowedNextStep": "validate visual rail placement after aspect-correct capture; keep handler blocker separate",
            "forbiddenAction": "fake onClick, fake handler, or coordinate-only rail success",
        },
        {
            "checkpoint": "bottom_five_card_region",
            "referenceRegion": reference_ranges["bottom_cards"],
            "currentEvidence": f"cardRows={card_rows}; activeCardRows={active_card_rows}; activeCardsWithSprite={active_cards_with_sprite}; 1036 remains not_fetchable_local; {current_candidate.get('bottomCardFinding', '')}",
            "aspectCorrectedInterpretation": "bottom region is incomplete independent of aspect because expected five-card assembly/full payload is absent",
            "status": "mismatch",
            "blockerCategory": "incomplete_card_icon_payload",
            "allowedNextStep": "resolve source-backed card payload/actor 1036 evidence before claiming five-card match",
            "forbiddenAction": "fake card/icon/text or whole-atlas substitute",
        },
        {
            "checkpoint": "friendly_actor_formation_band",
            "referenceRegion": reference_ranges["friendly_formation"],
            "currentEvidence": f"BATTLE57 source-backed visible actors=3; BATTLE54 activeLoadableActorRows={active_loadable_actor_rows}; full payload local actors still 3/12; {current_candidate.get('actorFinding', '')}",
            "aspectCorrectedInterpretation": "BATTLE57 proves local subset visibility only; not full friendly formation or final layout",
            "status": "mismatch",
            "blockerCategory": "incomplete_actor_payload",
            "allowedNextStep": "after aspect-correct capture, compare visible subset separately from missing full payload",
            "forbiddenAction": "dummy actor, fake mesh, or using subset visibility as full restore proof",
        },
        {
            "checkpoint": "enemy_actor_formation_band",
            "referenceRegion": reference_ranges["enemy_formation"],
            "currentEvidence": "enemy local loadable model 3001 only; unresolved enemy ids remain 1100112/1100113/1100121/1100122/1100123/1100131/1100132/1100133",
            "aspectCorrectedInterpretation": "enemy side cannot be reference-complete until source-backed enemy payload gaps close",
            "status": "mismatch",
            "blockerCategory": "incomplete_actor_payload",
            "allowedNextStep": "obtain or trace unresolved enemy source payloads",
            "forbiddenAction": "fake enemy actor or reusing 3001 as full enemy formation",
        },
        {
            "checkpoint": "tmp_text_scale_autosize",
            "referenceRegion": reference_ranges["tmp_text"],
            "currentEvidence": f"TMP/Text rows={text_rows}; autosizeOn={autosize_on_rows}; negativeCharacterSpacingRows={negative_spacing_rows}",
            "aspectCorrectedInterpretation": "text values are evidence rows, not fields to normalize by hand",
            "status": "reviewed_not_patchable_without_source_runtime",
            "blockerCategory": "tmp_runtime_source_validation_pending",
            "allowedNextStep": "validate original prefab/runtime TMP settings after correct aspect",
            "forbiddenAction": "arbitrary font/autosize/spacing correction",
        },
        {
            "checkpoint": "mask_stencil_routes",
            "referenceRegion": reference_ranges["mask_stencil"],
            "currentEvidence": f"maskRows={mask_count}; serializedMaskishRows={mask_component_rows}; nameOnlyMaskRows={mask_name_only_rows}; m_Script fileID 0 rows are not working-stencil proof",
            "aspectCorrectedInterpretation": "mask rows were reviewed but no source-backed stencil patch is allowed from name/component count alone",
            "status": "reviewed_not_patchable_without_source_runtime",
            "blockerCategory": "mask_stencil_source_validation_pending",
            "allowedNextStep": "probe actual working Mask/Stencil only with source-backed script persistence/runtime evidence",
            "forbiddenAction": "fake Mask/Stencil patch",
        },
    ]

    camera_rows = [
        {
            "evidenceKind": "reference_video",
            "path": str(reference_video.get("path", "")),
            "width": reference_video.get("width"),
            "height": reference_video.get("height"),
            "aspect": reference_video.get("aspect"),
            "finding": "reference aspect baseline from auxiliary video",
            "mutation": "none",
        },
        {
            "evidenceKind": "attached_reference_image",
            "path": str(attached_image.get("path", "")),
            "width": attached_image.get("width"),
            "height": attached_image.get("height"),
            "aspect": attached_image.get("aspect"),
            "finding": "attached MainInterface reference is also ~2.24:1",
            "mutation": "none",
        },
        {
            "evidenceKind": "battle57_capture",
            "path": str(b57_capture),
            "width": (b57_size or {}).get("width"),
            "height": (b57_size or {}).get("height"),
            "aspect": (b57_size or {}).get("aspect"),
            "finding": "candidate capture is 16:9 1920x1080, not reference aspect",
            "mutation": "none",
        },
        {
            "evidenceKind": "battle51_capture",
            "path": str(b51_capture),
            "width": (b51_size or {}).get("width"),
            "height": (b51_size or {}).get("height"),
            "aspect": (b51_size or {}).get("aspect"),
            "finding": "candidate capture is 16:9 1920x1080, not reference aspect",
            "mutation": "none",
        },
        {
            "evidenceKind": "project_version",
            "path": str(unity / "ProjectSettings" / "ProjectVersion.txt"),
            "width": "",
            "height": "",
            "aspect": "",
            "finding": "Unity 6000.4.9f1 project; no Timeline/package mutation in this task",
            "mutation": "none",
        },
        {
            "evidenceKind": "capture_script_constant",
            "path": str(unity / "Assets" / "Editor" / "Battle51RestoreLuaBridgeAndRaycasterRegistrationEditor.cs"),
            "width": 1920,
            "height": 1080,
            "aspect": 1.777778,
            "finding": "BATTLE51 RenderCamera called with 1920x1080",
            "mutation": "none",
        },
        {
            "evidenceKind": "capture_script_constant",
            "path": str(unity / "Assets" / "Editor" / "Battle57RehydrateSourceBackedAssetBundleActorsEditor.cs"),
            "width": 1920,
            "height": 1080,
            "aspect": 1.777778,
            "finding": "BATTLE57 report/capture path is 1920x1080; aspect-correct reprobe required before coordinate/layout patch",
            "mutation": "none",
        },
        {
            "evidenceKind": "aspect_correct_content_rect",
            "path": "computed_from_reference_aspect_and_1920x1080_capture",
            "width": aspect_rect["width"],
            "height": aspect_rect["height"],
            "aspect": round(aspect_rect["width"] / aspect_rect["height"], 6),
            "finding": f"letterbox-equivalent analysis rect top={aspect_rect['y']} bottom={aspect_rect['bottom']} extraVertical={aspect_rect['extraVerticalPixels']}",
            "mutation": "none",
        },
    ]

    blocker_rows = [
        {
            "blockerCategory": "wrong_render_aspect_view_rect",
            "confirmed": True,
            "evidence": f"referenceAspect={reference_aspect}; candidateCaptureAspect={candidate_aspect}; aspectDelta={round(reference_aspect - candidate_aspect, 6)}",
            "separateFrom": "route active state, payload, Timeline, xLua",
            "patchAllowedNow": False,
            "nextEvidenceNeeded": "aspect-correct capture/probe using source-backed camera/canvas/capture settings",
        },
        {
            "blockerCategory": "wrong_route_active_state_sibling_order",
            "confirmed": "pending_after_aspect",
            "evidence": f"routeRows={route_count}; activeRouteZeroScale={active_route_zero_scale}; inactiveCritical={inactive_critical}",
            "separateFrom": "render aspect and payload gaps",
            "patchAllowedNow": False,
            "nextEvidenceNeeded": "source-backed RectTransform/sibling/active comparison after aspect-correct reprobe",
        },
        {
            "blockerCategory": "incomplete_card_icon_payload",
            "confirmed": True,
            "evidence": f"activeCardRows={active_card_rows}; activeCardsWithSprite={active_cards_with_sprite}; expected reference region is five cards",
            "separateFrom": "render aspect",
            "patchAllowedNow": False,
            "nextEvidenceNeeded": "source-backed 1036/card/icon payload resolution",
        },
        {
            "blockerCategory": "incomplete_actor_payload",
            "confirmed": True,
            "evidence": f"activeLoadableActorRows={active_loadable_actor_rows}; actorRows={actor_rows}; BATTLE_LOCAL_PLAYABLE_PAYLOAD remains local subset only",
            "separateFrom": "actor renderer visibility already solved for local subset",
            "patchAllowedNow": False,
            "nextEvidenceNeeded": "source-backed 1036 and unresolved enemy payloads",
        },
        {
            "blockerCategory": "timeline_package_and_binding_blocker",
            "confirmed": True,
            "evidence": "BATTLE64/65: Timeline package absent in project; local candidate requires approval; BATTLE63 TimelineAsset assignability mismatch",
            "separateFrom": "HUD/card coordinate validation",
            "patchAllowedNow": False,
            "nextEvidenceNeeded": "approval for local Timeline package candidate import/test or original runtime context",
        },
        {
            "blockerCategory": "xlua_gameentry_handler_blocker",
            "confirmed": True,
            "evidence": "BATTLE58/59: original xLua/GameEntry/LuaManager runtime unavailable; listener/lifecycle rows remain 0",
            "separateFrom": "raycast target inclusion and actor visibility",
            "patchAllowedNow": False,
            "nextEvidenceNeeded": "original runtime or approved external xLua path; no fake handler",
        },
        {
            "blockerCategory": "tmp_mask_source_validation_pending",
            "confirmed": True,
            "evidence": f"TMP rows reviewed={text_rows}; mask rows reviewed={mask_count}; negativeSpacing={negative_spacing_rows}; maskNameOnly={mask_name_only_rows}",
            "separateFrom": "visual aspect mismatch",
            "patchAllowedNow": False,
            "nextEvidenceNeeded": "source-backed prefab/runtime TMP and working stencil proof",
        },
    ]

    decision_rows = [
        {
            "decision": "safe_no_patch_report_only",
            "recommended": True,
            "why": "Current candidate captures are 16:9 while reference is ~2.24:1; layout coordinates cannot be patched safely yet.",
            "requiresApproval": False,
            "allowedNextAction": "produce aspect-correct validation capture/probe without scene/package mutation",
            "successCriteria": "same source-backed scene captured with reference-aspect rect; no restored/playable claim",
        },
        {
            "decision": "aspect_correct_capture_validation_required_before_layout_patch",
            "recommended": True,
            "why": "Aspect mismatch is a first-order blocker and affects top HUD, right rail, bottom card, and actor band comparisons.",
            "requiresApproval": False,
            "allowedNextAction": "read-only or candidate capture-only probe using reference aspect; compare normalized layout again",
            "successCriteria": "reference/current normalized rows become comparable",
        },
        {
            "decision": "source_backed_route_recttransform_patch_candidate_after_aspect_only",
            "recommended": False,
            "why": "Route/RectTransform changes may be needed, but only after aspect-correct evidence isolates actual route mismatch.",
            "requiresApproval": False,
            "allowedNextAction": "defer patch; collect exact source-backed route/sibling deltas",
            "successCriteria": "original prefab/PPtr/RectTransform evidence maps to candidate scene fields",
        },
        {
            "decision": "requires_timeline_import_approval_for_skill_overlay",
            "recommended": False,
            "why": "TimelineAsset compatibility remains blocked without approved package/runtime import.",
            "requiresApproval": True,
            "allowedNextAction": "separate follow-up if user approves local Timeline candidate import/test",
            "successCriteria": "PlayableAsset assignability only; not playability",
        },
        {
            "decision": "requires_xlua_gameentry_runtime_for_handler_playability",
            "recommended": False,
            "why": "Input handler/lifecycle remains absent; fake handlers remain forbidden.",
            "requiresApproval": True,
            "allowedNextAction": "obtain original runtime or approved external xLua experiment",
            "successCriteria": "original Lua lifecycle binds original closures",
        },
        {
            "decision": "requires_actor_bundle_acquisition_for_full_formation",
            "recommended": False,
            "why": "BATTLE57 visible actors are local subset only and cannot satisfy full reference formation.",
            "requiresApproval": False,
            "allowedNextAction": "trace/acquire 1036 and unresolved enemy bundles with source evidence",
            "successCriteria": "full actor payload source-backed and visible",
        },
        {
            "decision": "forbidden_to_guess_fake_hud_card_icon_actor",
            "recommended": True,
            "why": "Missing visual/card/actor fields are payload/source gaps, not permission to invent substitutes.",
            "requiresApproval": False,
            "allowedNextAction": "record blocker only",
            "successCriteria": "no fake HUD/card/icon/text/actor/effect and no coordinate-only success",
        },
    ]

    route_hud_mismatches = sum(1 for r in layout_rows if r["checkpoint"] in {"aspect_view_rect", "top_hud_root_top_topcenter", "right_control_rail_buttons"} and "mismatch" in r["status"])
    bottom_card_mismatches = sum(1 for r in layout_rows if r["checkpoint"] == "bottom_five_card_region" and "mismatch" in r["status"])
    actor_formation_mismatches = sum(1 for r in layout_rows if r["checkpoint"] in {"friendly_actor_formation_band", "enemy_actor_formation_band"} and "mismatch" in r["status"])
    tmp_mask_rows_reviewed = text_rows + mask_count

    command_policy = count_root_cmds(root)
    result = {
        "task": PREFIX,
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "playableClaim": False,
        "patchApplied": False,
        "sceneSaved": False,
        "packageImported": False,
        "manifestModified": False,
        "runtimeInstrumentationUsed": False,
        "referenceAspect": reference_aspect,
        "candidateCaptureAspect": candidate_aspect,
        "aspectMismatchConfirmed": not math.isclose(reference_aspect, candidate_aspect, rel_tol=0.01),
        "aspectCorrectContentRect": aspect_rect,
        "routeHudMismatchRows": route_hud_mismatches,
        "bottomCardMismatchRows": bottom_card_mismatches,
        "actorFormationMismatchRows": actor_formation_mismatches,
        "tmpMaskRowsReviewed": tmp_mask_rows_reviewed,
        "tmpMaskRowsReviewedDetail": {"tmpTextRows": text_rows, "maskRows": mask_count},
        "recommendedDecision": "safe_no_patch_report_only_then_aspect_correct_capture_validation",
        "nextBlocker": "ASPECT_CORRECT_CAPTURE_VALIDATION_REQUIRED_BEFORE_ROUTE_HUD_CARD_ACTOR_LAYOUT_PATCH",
        "guardrailsTouched": [
            "no_scene_save",
            "no_package_import",
            "no_manifest_edit",
            "no_xlua_or_handler_patch",
            "no_fake_hud_card_icon_text_actor_effect",
            "no_screenshot_or_atlas_paste",
            "no_coordinate_only_success",
            "no_runtime_instrumentation",
        ],
        "commandPolicy": command_policy,
        "inputs": {
            "controlTowerStatus": str(root / "reports" / "CONTROL_TOWER_STATUS_20260626_060425.md"),
            "referenceMatrix": str(ref_json_path),
            "battle54Result": str(b54_json_path),
            "battle57Result": str(b57_json_path),
            "battle57Capture": str(b57_capture),
            "battle51Capture": str(b51_capture),
        },
        "counts": {
            "routeRows": route_count,
            "activeRouteZeroScaleRows": active_route_zero_scale,
            "inactiveCriticalRows": inactive_critical,
            "cardRows": card_rows,
            "activeCardRows": active_card_rows,
            "activeCardsWithSpriteRows": active_cards_with_sprite,
            "actorRows": actor_rows,
            "activeActorRows": active_actor_rows,
            "activeLoadableActorRows": active_loadable_actor_rows,
            "buttonRouteRows": len(button_rows),
            "tmpTextRows": text_rows,
            "tmpAutosizeOnRows": autosize_on_rows,
            "tmpNegativeCharacterSpacingRows": negative_spacing_rows,
            "maskRows": mask_count,
            "maskComponentRows": mask_component_rows,
            "maskNameOnlyRows": mask_name_only_rows,
        },
        "battle57Carryover": {
            "sourceBackedActorsVisible": b57.get("sourceBackedActorsVisible") or b57.get("actorsVisibleDuringProbe") or "see BATTLE57 result",
            "isFinalRestoredBattleScreen": False,
        },
    }

    layout_csv = reports / f"{PREFIX}_REFERENCE_VS_CURRENT_NORMALIZED_LAYOUT_CHECKPOINT_MATRIX.csv"
    camera_csv = reports / f"{PREFIX}_CAMERA_CANVAS_SCALER_RENDER_ASPECT_EVIDENCE_MATRIX.csv"
    blocker_csv = reports / f"{PREFIX}_ROUTE_CARD_ACTOR_TMP_MASK_BLOCKER_SEPARATION_MATRIX.csv"
    decision_csv = reports / f"{PREFIX}_DECISION_AND_NEXT_ACTION_MATRIX.csv"
    json_path = reports / f"{PREFIX}_RESULT.json"
    md_path = reports / f"{PREFIX}_RESULT.md"

    write_csv(
        layout_csv,
        layout_rows,
        [
            "checkpoint",
            "referenceRegion",
            "currentEvidence",
            "aspectCorrectedInterpretation",
            "status",
            "blockerCategory",
            "allowedNextStep",
            "forbiddenAction",
        ],
    )
    write_csv(camera_csv, camera_rows, ["evidenceKind", "path", "width", "height", "aspect", "finding", "mutation"])
    write_csv(blocker_csv, blocker_rows, ["blockerCategory", "confirmed", "evidence", "separateFrom", "patchAllowedNow", "nextEvidenceNeeded"])
    write_csv(decision_csv, decision_rows, ["decision", "recommended", "why", "requiresApproval", "allowedNextAction", "successCriteria"])

    json_path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = []
    md.append(f"# {PREFIX} Result")
    md.append("")
    md.append("## Verdict")
    md.append("- `restoredClaim=false`, `playableClaim=false`.")
    md.append("- No scene, package, manifest, xLua, handler, HUD/card/actor/effect, or coordinate patch was applied.")
    md.append(f"- Reference aspect is `{reference_aspect}`; current candidate capture aspect is `{candidate_aspect}`. Aspect mismatch is confirmed.")
    md.append(
        f"- For a 1920-wide comparison, the reference-aspect content rect is `x={aspect_rect['x']}, y={aspect_rect['y']}, w={aspect_rect['width']}, h={aspect_rect['height']}`; this is analysis-only, not a patch."
    )
    md.append("")
    md.append("## Layout Findings")
    md.append(f"- Route/HUD mismatch rows: `{route_hud_mismatches}`.")
    md.append(f"- Bottom card mismatch rows: `{bottom_card_mismatches}`.")
    md.append(f"- Actor formation mismatch rows: `{actor_formation_mismatches}`.")
    md.append(f"- TMP/mask rows reviewed: `{tmp_mask_rows_reviewed}` (`TMP/Text={text_rows}`, `Mask={mask_count}`).")
    md.append("- BATTLE57 actor visibility remains source-backed for the local subset only; it is not full formation or final playability proof.")
    md.append("- Bottom card/card-icon state remains incomplete: active cards with sprites exist for the local subset, but the reference five-card assembly and 1036/full payload are not complete.")
    md.append("")
    md.append("## Root Cause Separation")
    for row in blocker_rows:
        md.append(f"- `{row['blockerCategory']}`: {row['evidence']}")
    md.append("")
    md.append("## Recommended Decision")
    md.append("- `safe_no_patch_report_only_then_aspect_correct_capture_validation`.")
    md.append("- Next blocker: `ASPECT_CORRECT_CAPTURE_VALIDATION_REQUIRED_BEFORE_ROUTE_HUD_CARD_ACTOR_LAYOUT_PATCH`.")
    md.append("- Timeline package import, xLua/GameEntry handler runtime, and full actor payload gaps remain separate blockers.")
    md.append("")
    md.append("## Outputs")
    md.append(f"- `{layout_csv}`")
    md.append(f"- `{camera_csv}`")
    md.append(f"- `{blocker_csv}`")
    md.append(f"- `{decision_csv}`")
    md.append(f"- `{json_path}`")
    md.append("")
    md.append("## Command Policy")
    md.append(f"- root `.cmd` count: `{command_policy['rootCmdCount']}`")
    md.append(f"- `_restore_tools` direct `.cmd` count: `{command_policy['restoreToolsDirectCmdCount']}`")
    md.append(f"- policy ok: `{command_policy['policyOk']}`")
    md_path.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(json.dumps({"result": str(json_path), "md": str(md_path), "aspectMismatchConfirmed": result["aspectMismatchConfirmed"]}, ensure_ascii=False))


if __name__ == "__main__":
    main()
