from __future__ import annotations

import csv
import json
import math
import statistics
import struct
from datetime import datetime
from pathlib import Path


PREFIX = "BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH"


def read_json(path: Path, default=None):
    if not path.exists():
        return default
    return json.loads(path.read_text(encoding="utf-8-sig"))


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
        data = path.read_bytes()[:32]
        if data.startswith(b"\x89PNG\r\n\x1a\n") and len(data) >= 24:
            width, height = struct.unpack(">II", data[16:24])
            return {"width": width, "height": height, "aspect": round(width / height, 6)}
    return None


def clamp_box(width, height, box):
    x1 = max(0, min(width, int(round(box[0] * width))))
    y1 = max(0, min(height, int(round(box[1] * height))))
    x2 = max(x1 + 1, min(width, int(round(box[2] * width))))
    y2 = max(y1 + 1, min(height, int(round(box[3] * height))))
    return x1, y1, x2, y2


def luminance(pixel):
    r, g, b = pixel[:3]
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def region_stats(img, norm_box):
    width, height = img.size
    x1, y1, x2, y2 = clamp_box(width, height, norm_box)
    crop = img.crop((x1, y1, x2, y2)).convert("RGB")
    pixels = list(crop.getdata())
    total = len(pixels)
    if total == 0:
        return {}
    lum = [luminance(p) for p in pixels]
    non_dark = sum(1 for v in lum if v > 18)
    bright = sum(1 for v in lum if v > 80)
    very_dark = total - non_dark
    bbox = non_dark_bbox(crop, offset=(x1, y1))
    return {
        "pixelBox": f"{x1}/{y1}/{x2 - 1}/{y2 - 1}",
        "pixelCount": total,
        "meanLuma": round(sum(lum) / total, 4),
        "nonDarkRatio": round(non_dark / total, 6),
        "brightRatio": round(bright / total, 6),
        "veryDarkRatio": round(very_dark / total, 6),
        "lumaStd": round(statistics.pstdev(lum), 4) if len(lum) > 1 else 0,
        "nonDarkBBox": bbox,
    }


def non_dark_bbox(img, offset=(0, 0), threshold=18):
    width, height = img.size
    pix = img.convert("RGB").load()
    min_x, min_y, max_x, max_y = width, height, -1, -1
    for y in range(height):
        for x in range(width):
            if luminance(pix[x, y]) > threshold:
                min_x = min(min_x, x)
                min_y = min(min_y, y)
                max_x = max(max_x, x)
                max_y = max(max_y, y)
    if max_x < 0:
        return ""
    ox, oy = offset
    return f"{min_x + ox}/{min_y + oy}/{max_x + ox}/{max_y + oy}"


def black_gutter(img, threshold=18, column_ratio=0.94):
    width, height = img.size
    pix = img.convert("RGB").load()
    dark_columns = []
    for x in range(width):
        dark = 0
        for y in range(height):
            if luminance(pix[x, y]) <= threshold:
                dark += 1
        dark_columns.append(dark / height)
    left = 0
    while left < width and dark_columns[left] >= column_ratio:
        left += 1
    right = 0
    idx = width - 1
    while idx >= 0 and dark_columns[idx] >= column_ratio:
        right += 1
        idx -= 1
    return {
        "leftGutterPx": left,
        "rightGutterPx": right,
        "leftGutterNorm": round(left / width, 6),
        "rightGutterNorm": round(right / width, 6),
        "totalGutterRatio": round((left + right) / width, 6),
        "detected": left > width * 0.02 or right > width * 0.02,
    }


def count_root_cmds(root: Path):
    root_cmd = len(list(root.glob("*.cmd")))
    direct_restore_cmd = len(list((root / "_restore_tools").glob("*.cmd"))) if (root / "_restore_tools").exists() else 0
    return {
        "rootCmdCount": root_cmd,
        "restoreToolsDirectCmdCount": direct_restore_cmd,
        "policyOk": root_cmd == 1 and direct_restore_cmd == 0,
    }


def lower_path(row):
    return (row.get("path") or "").lower()


def interesting_route_rows(routes, cards, actors, tmp_rows, mask_rows):
    rows = []
    route_terms = [
        ("top_hud", ["root_top", "topcenter", "enemyinfo", "selfinfo"]),
        ("right_rail", ["root_opra", "btnauto", "btntwospeed", "btnfastskill", "btnbuff", "btn_box"]),
        ("bottom_cards", ["bottomcenter", "herolistcontainer", "battle29boundherocard", "uieffect_meili"]),
        ("actor_formation", ["battle39_runtimeactor", "battle57", "runtimeactor"]),
    ]
    for kind, terms in route_terms:
        source = actors if kind == "actor_formation" else routes
        for row in source:
            path = lower_path(row)
            if any(term in path for term in terms):
                out = {
                    "evidenceKind": kind,
                    "sourceTable": "actors" if source is actors else "routes",
                    "path": row.get("path", ""),
                    "activeSelf": row.get("activeSelf", ""),
                    "activeInHierarchy": row.get("activeInHierarchy", ""),
                    "siblingIndex": row.get("siblingIndex", ""),
                    "siblingCount": row.get("siblingCount", ""),
                    "anchoredPosition": row.get("anchoredPosition", ""),
                    "localPosition": row.get("localPosition", ""),
                    "localScale": row.get("localScale", ""),
                    "sizeDelta": row.get("sizeDelta", ""),
                    "anchorMin": row.get("anchorMin", ""),
                    "anchorMax": row.get("anchorMax", ""),
                    "warning": row.get("warning", ""),
                    "payloadHeroDid": row.get("payloadHeroDid", ""),
                    "payloadLocalStatus": row.get("payloadLocalStatus", ""),
                    "tmpText": "",
                    "tmpAutoSize": "",
                    "tmpCharacterSpacing": "",
                    "maskEvidence": "",
                    "interpretation": "",
                }
                if kind == "bottom_cards" and row.get("payloadLocalStatus") == "not_fetchable_local":
                    out["interpretation"] = "card route active but actor payload missing locally"
                elif "zeroish" in row.get("warning", ""):
                    out["interpretation"] = "active route has zero-ish scale; source-backed runtime impact must be probed before patch"
                rows.append(out)
    for row in cards:
        rows.append(
            {
                "evidenceKind": "bottom_card_payload",
                "sourceTable": "hero_cards",
                "path": row.get("path", ""),
                "activeSelf": row.get("activeSelf", ""),
                "activeInHierarchy": row.get("activeInHierarchy", ""),
                "siblingIndex": row.get("siblingIndex", ""),
                "siblingCount": row.get("siblingCount", ""),
                "anchoredPosition": row.get("anchoredPosition", ""),
                "localPosition": row.get("localPosition", ""),
                "localScale": row.get("localScale", ""),
                "sizeDelta": row.get("sizeDelta", ""),
                "anchorMin": row.get("anchorMin", ""),
                "anchorMax": row.get("anchorMax", ""),
                "warning": row.get("warning", ""),
                "payloadHeroDid": row.get("payloadHeroDid", ""),
                "payloadLocalStatus": row.get("payloadLocalStatus", ""),
                "tmpText": row.get("textSamples", ""),
                "tmpAutoSize": "",
                "tmpCharacterSpacing": "",
                "maskEvidence": row.get("maskLikeDescendantCount", ""),
                "interpretation": "active local card row" if row.get("payloadLocalStatus") == "loadable" else "active card row blocked by payload",
            }
        )
    for row in tmp_rows:
        path = lower_path(row)
        if any(term in path for term in ["root_top", "bottomcenter", "root_opra", "herolistcontainer", "battle29boundherocard"]):
            rows.append(
                {
                    "evidenceKind": "tmp_text",
                    "sourceTable": "tmp_text",
                    "path": row.get("path", ""),
                    "activeSelf": row.get("activeSelf", ""),
                    "activeInHierarchy": row.get("activeInHierarchy", ""),
                    "siblingIndex": row.get("siblingIndex", ""),
                    "siblingCount": row.get("siblingCount", ""),
                    "anchoredPosition": row.get("anchoredPosition", ""),
                    "localPosition": row.get("localPosition", ""),
                    "localScale": row.get("localScale", ""),
                    "sizeDelta": row.get("sizeDelta", ""),
                    "anchorMin": row.get("anchorMin", ""),
                    "anchorMax": row.get("anchorMax", ""),
                    "warning": row.get("warning", ""),
                    "payloadHeroDid": "",
                    "payloadLocalStatus": "",
                    "tmpText": row.get("text", ""),
                    "tmpAutoSize": row.get("enableAutoSizing", ""),
                    "tmpCharacterSpacing": row.get("characterSpacing", ""),
                    "maskEvidence": "",
                    "interpretation": "do not normalize TMP fields without source runtime evidence",
                }
            )
    for row in mask_rows:
        path = lower_path(row)
        if any(term in path for term in ["root_top", "bottomcenter", "herolistcontainer", "battle29boundherocard", "scrollviewbuff"]):
            rows.append(
                {
                    "evidenceKind": "mask",
                    "sourceTable": "masks",
                    "path": row.get("path", ""),
                    "activeSelf": row.get("activeSelf", ""),
                    "activeInHierarchy": row.get("activeInHierarchy", ""),
                    "siblingIndex": row.get("siblingIndex", ""),
                    "siblingCount": row.get("siblingCount", ""),
                    "anchoredPosition": row.get("anchoredPosition", ""),
                    "localPosition": row.get("localPosition", ""),
                    "localScale": row.get("localScale", ""),
                    "sizeDelta": row.get("sizeDelta", ""),
                    "anchorMin": row.get("anchorMin", ""),
                    "anchorMax": row.get("anchorMax", ""),
                    "warning": row.get("warning", ""),
                    "payloadHeroDid": "",
                    "payloadLocalStatus": "",
                    "tmpText": "",
                    "tmpAutoSize": "",
                    "tmpCharacterSpacing": "",
                    "maskEvidence": row.get("evidence", ""),
                    "interpretation": "mask/stencil behavior not guaranteed by serialized/name-only evidence",
                }
            )
    return rows


def make_contact_sheet(out_path: Path, refs, capture_path: Path):
    try:
        from PIL import Image, ImageDraw
    except Exception:
        return None
    images = []
    labels = []
    for p in refs + [capture_path]:
        if p.exists():
            img = Image.open(p).convert("RGB")
            img.thumbnail((640, 285))
            images.append(img.copy())
            labels.append(p.name)
    if not images:
        return None
    w = 700
    h = 340 * len(images)
    sheet = Image.new("RGB", (w, h), (20, 20, 20))
    draw = ImageDraw.Draw(sheet)
    regions = {
        "top": (0.0, 0.03, 1.0, 0.16),
        "right": (0.88, 0.30, 0.99, 0.66),
        "cards": (0.25, 0.75, 0.78, 1.0),
        "actors": (0.12, 0.20, 0.88, 0.92),
    }
    y = 0
    for label, img in zip(labels, images):
        sheet.paste(img, (30, y + 35))
        draw.text((30, y + 12), label, fill=(240, 240, 240))
        for name, box in regions.items():
            x1, yy1, x2, yy2 = clamp_box(img.width, img.height, box)
            color = {"top": (255, 80, 80), "right": (80, 200, 255), "cards": (255, 220, 80), "actors": (100, 255, 100)}[name]
            draw.rectangle((30 + x1, y + 35 + yy1, 30 + x2, y + 35 + yy2), outline=color, width=2)
            draw.text((30 + x1 + 3, y + 35 + yy1 + 3), name, fill=color)
        y += 340
    out_path.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(out_path, quality=92)
    return out_path


def main():
    root = Path(__file__).resolve().parents[2]
    reports = root / "reports" / "battle"
    work = root / "work" / "battle69_true_aspect_validation"
    work.mkdir(parents=True, exist_ok=True)

    b68 = read_json(reports / "BATTLE_68_TRUE_REFERENCE_ASPECT_CAPTURE_PIPELINE_AND_VIEWRECT_SOURCE_TRACE_NO_SCENE_SAVE_RESULT.json", {})
    unity_summary = read_json(root / "girlswar_battle_unity" / "Assets" / "RestoreData" / "battle" / "BATTLE_68_TRUE_REFERENCE_ASPECT_CAPTURE_PIPELINE_AND_VIEWRECT_SOURCE_TRACE_NO_SCENE_SAVE_UNITY.json", {})
    char65 = read_json(root / "reports" / "characters" / "CHARACTER_65_FULL_BATTLE_PAYLOAD_ROSTER_AND_BUNDLE_GAP_MATRIX_NO_NETWORK_NO_IMPORT_RESULT.json", {})

    routes = read_csv(reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_ROUTES.csv")
    cards = read_csv(reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_HERO_CARDS.csv")
    actors = read_csv(reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_ACTORS.csv")
    tmp_rows = read_csv(reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_TMP_TEXT.csv")
    mask_rows = read_csv(reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_MASKS.csv")

    capture = root / "girlswar_battle_unity" / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle68TrueReferenceAspectNoSceneSave_1920x855.png"
    refs = [
        root / "work" / "reference_video" / "frames_5s" / "sample_004.jpg",
        root / "work" / "reference_video" / "frames_5s" / "sample_007.jpg",
        root / "work" / "reference_video" / "frames_5s" / "sample_012.jpg",
    ]

    from PIL import Image

    regions = [
        ("full_frame", (0.0, 0.0, 1.0, 1.0), "full capture/reference frame"),
        ("top_hud", (0.0, 0.03, 1.0, 0.16), "reference top HUD/portraits/VS/wave band"),
        ("right_control_rail", (0.88, 0.30, 0.99, 0.66), "reference right AUTO/play/x2 control rail"),
        ("bottom_five_cards", (0.25, 0.75, 0.78, 1.0), "reference bottom five-card assembly"),
        ("friendly_actor_band", (0.12, 0.20, 0.48, 0.92), "reference friendly formation band"),
        ("enemy_actor_band", (0.50, 0.20, 0.88, 0.92), "reference enemy formation band"),
    ]

    image_rows = []
    layout_rows = []
    ref_region_stats = {}
    for source_kind, path in [("true_capture", capture)] + [(f"reference_{i+1}", p) for i, p in enumerate(refs)]:
        if not path.exists():
            image_rows.append({"sourceKind": source_kind, "path": str(path), "exists": False})
            continue
        img = Image.open(path).convert("RGB")
        size = image_size(path)
        gutter = black_gutter(img)
        bbox = non_dark_bbox(img)
        image_rows.append(
            {
                "sourceKind": source_kind,
                "path": str(path),
                "exists": True,
                "width": size["width"],
                "height": size["height"],
                "aspect": size["aspect"],
                "nonDarkBBox": bbox,
                **gutter,
            }
        )
        for region_name, box, description in regions:
            stats = region_stats(img, box)
            row = {
                "sourceKind": source_kind,
                "region": region_name,
                "referenceRegionDescription": description,
                "normBox": "/".join(str(v) for v in box),
                **stats,
            }
            if source_kind.startswith("reference"):
                ref_region_stats.setdefault(region_name, []).append(stats)
            layout_rows.append(row)

    comparison_rows = []
    true_by_region = {r["region"]: r for r in layout_rows if r["sourceKind"] == "true_capture"}
    for region_name, box, description in regions:
        refs_stats = ref_region_stats.get(region_name, [])
        true_stats = true_by_region.get(region_name, {})
        ref_non_dark = statistics.mean([r.get("nonDarkRatio", 0) for r in refs_stats]) if refs_stats else 0
        true_non_dark = true_stats.get("nonDarkRatio", 0)
        ref_bright = statistics.mean([r.get("brightRatio", 0) for r in refs_stats]) if refs_stats else 0
        true_bright = true_stats.get("brightRatio", 0)
        delta_non_dark = true_non_dark - ref_non_dark
        delta_bright = true_bright - ref_bright
        if region_name == "full_frame":
            classification = "black_gutter_or_global_framing_check"
        elif region_name == "bottom_five_cards":
            classification = "bottom_card_payload_and_layout_mismatch"
        elif region_name in {"friendly_actor_band", "enemy_actor_band"}:
            classification = "actor_subset_payload_layout_mismatch"
        elif region_name == "right_control_rail":
            classification = "right_rail_visual_layout_mismatch_plus_handler_blocker"
        else:
            classification = "hud_route_layout_mismatch"
        comparison_rows.append(
            {
                "region": region_name,
                "referenceRegionDescription": description,
                "normBox": "/".join(str(v) for v in box),
                "referenceMeanNonDarkRatio": round(ref_non_dark, 6),
                "trueCaptureNonDarkRatio": true_non_dark,
                "deltaNonDarkRatio": round(delta_non_dark, 6),
                "referenceMeanBrightRatio": round(ref_bright, 6),
                "trueCaptureBrightRatio": true_bright,
                "deltaBrightRatio": round(delta_bright, 6),
                "trueCaptureNonDarkBBox": true_stats.get("nonDarkBBox", ""),
                "classification": classification,
                "patchDecision": "no_patch_source_validation_only",
            }
        )

    source_rows = interesting_route_rows(routes, cards, actors, tmp_rows, mask_rows)
    ready_actors = [r for r in char65.get("battleListRows", []) if r.get("rowCategory") == "actor_card" and r.get("battleListCandidateStatus") == "ready_local"]
    missing_actor_rows = [r for r in char65.get("battleListRows", []) if r.get("rowCategory") == "actor_card" and r.get("battleListCandidateStatus") != "ready_local"]
    source_known_missing = [r for r in missing_actor_rows if r.get("battleListCandidateStatus") == "source_known_missing_bundle"]
    unresolved_enemy = [r for r in missing_actor_rows if r.get("battleListCandidateStatus") == "unresolved_source_chain"]
    skill_rows = [r for r in char65.get("battleListRows", []) if r.get("rowCategory") == "skill"]
    ready_skill = [r for r in skill_rows if r.get("battleListCandidateStatus") == "ready_local"]
    blocked_skill = [r for r in skill_rows if r.get("battleListCandidateStatus") != "ready_local"]

    blocker_rows = [
        {
            "blockerCategory": "true_aspect_capture_available",
            "status": "solved_for_validation",
            "evidence": f"{capture} aspect={image_size(capture)['aspect'] if capture.exists() else ''}; sceneSaved={unity_summary.get('sceneSaved')}",
            "sourceBackedSafeNextAction": "Use BATTLE68 capture for exact normalized route/HUD/card/actor validation.",
            "forbiddenToGuess": "Do not treat aspect capture as restored/playable.",
        },
        {
            "blockerCategory": "wrong_render_framing_black_gutters",
            "status": "needs_source_backed_camera_viewrect_or_map_framing_trace",
            "evidence": json.dumps(black_gutter(Image.open(capture).convert("RGB")), ensure_ascii=False) if capture.exists() else "capture_missing",
            "sourceBackedSafeNextAction": "Trace camera orthographic/pixelRect/map layer framing before any view rect/map scale patch.",
            "forbiddenToGuess": "No screenshot stretch, no overlay, no coordinate-only success.",
        },
        {
            "blockerCategory": "route_hud_layout",
            "status": "pending_patch_candidate_after_source_delta",
            "evidence": "Top HUD/right rail regions differ in true aspect comparison; BATTLE54 route rows identify root_top/root_opra/TopCenter candidates.",
            "sourceBackedSafeNextAction": "Compare BATTLE54 route active/sibling/anchor rows against original prefab/runtime evidence before patch.",
            "forbiddenToGuess": "Do not manually drag HUD controls by coordinates.",
        },
        {
            "blockerCategory": "bottom_card_payload_and_layout",
            "status": "blocked_by_payload_plus_layout",
            "evidence": f"active card rows={sum(1 for c in cards if c.get('activeInHierarchy') == 'True')}; 1036 source-known missing bundle rows={len(source_known_missing)}",
            "sourceBackedSafeNextAction": "Resolve 1036 exact battle actor/card chain and then validate five-card assembly.",
            "forbiddenToGuess": "No fake card/icon/text.",
        },
        {
            "blockerCategory": "actor_payload_full_formation",
            "status": "blocked_by_payload",
            "evidence": f"ready actors={len(ready_actors)}; source-known missing={len(source_known_missing)}; unresolved enemies={len(unresolved_enemy)}",
            "sourceBackedSafeNextAction": "Acquire/trace exact 1036 bundle and enemy chains before full formation claim.",
            "forbiddenToGuess": "No dummy actor/fake mesh/reusing 3001 for missing enemies.",
        },
        {
            "blockerCategory": "timeline_xlua_runtime",
            "status": "blocked_separate",
            "evidence": f"ready skill rows={len(ready_skill)}; blocked skill rows={len(blocked_skill)}; xLua/GameEntry handler runtime remains unavailable.",
            "sourceBackedSafeNextAction": "Keep Timeline/xLua approval/runtime blockers separate from layout validation.",
            "forbiddenToGuess": "No fake handler/no dummy Lua/no package import.",
        },
        {
            "blockerCategory": "tmp_mask_source_validation",
            "status": "review_only",
            "evidence": f"TMP rows={len(tmp_rows)}; mask rows={len(mask_rows)}",
            "sourceBackedSafeNextAction": "Use BATTLE54 rows to validate TMP/mask only after original runtime/source proof.",
            "forbiddenToGuess": "No arbitrary TMP autosize/spacing or fake mask/stencil patch.",
        },
    ]

    safe_patch_candidates = [
        row for row in blocker_rows
        if row["blockerCategory"] in {"wrong_render_framing_black_gutters", "route_hud_layout"}
    ]
    contact_sheet = make_contact_sheet(work / f"{PREFIX}_reference_vs_true_capture_contact_sheet.jpg", refs, capture)

    true_capture_size = image_size(capture) or {}
    gutter_info = black_gutter(Image.open(capture).convert("RGB")) if capture.exists() else {"detected": False}
    route_hud_mismatch_rows = sum(1 for r in comparison_rows if r["region"] in {"top_hud", "right_control_rail", "full_frame"})
    bottom_card_mismatch_rows = sum(1 for r in comparison_rows if r["region"] == "bottom_five_cards")
    actor_payload_blocked_rows = len(missing_actor_rows)
    tmp_mask_rows_reviewed = len(tmp_rows) + len(mask_rows)
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
        "trueCaptureUsed": True,
        "trueCaptureAspect": true_capture_size.get("aspect"),
        "blackGutterDetected": bool(gutter_info.get("detected")),
        "blackGutter": gutter_info,
        "routeHudMismatchRows": route_hud_mismatch_rows,
        "bottomCardMismatchRows": bottom_card_mismatch_rows,
        "actorPayloadBlockedRows": actor_payload_blocked_rows,
        "tmpMaskRowsReviewed": tmp_mask_rows_reviewed,
        "safePatchCandidatesCount": len(safe_patch_candidates),
        "nextBlocker": "TRUE_ASPECT_ROUTE_HUD_VIEWRECT_SOURCE_DELTA_AND_PAYLOAD_GAPS_BEFORE_PATCH",
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
        "inputs": {
            "trueCapture": str(capture),
            "battle68Result": str(reports / "BATTLE_68_TRUE_REFERENCE_ASPECT_CAPTURE_PIPELINE_AND_VIEWRECT_SOURCE_TRACE_NO_SCENE_SAVE_RESULT.json"),
            "character65": str(root / "reports" / "characters" / "CHARACTER_65_FULL_BATTLE_PAYLOAD_ROSTER_AND_BUNDLE_GAP_MATRIX_NO_NETWORK_NO_IMPORT_RESULT.json"),
        },
        "payloadCounts": {
            "readyActors": len(ready_actors),
            "sourceKnownMissingActors": len(source_known_missing),
            "unresolvedEnemyActors": len(unresolved_enemy),
            "readySkillRows": len(ready_skill),
            "blockedSkillRows": len(blocked_skill),
        },
        "outputs": {
            "contactSheet": str(contact_sheet) if contact_sheet else None,
        },
    }

    image_csv = reports / f"{PREFIX}_TRUE_CAPTURE_IMAGE_REGION_AND_BLACK_GUTTER_MATRIX.csv"
    layout_csv = reports / f"{PREFIX}_REFERENCE_VS_TRUE_CAPTURE_NORMALIZED_LAYOUT_MATRIX.csv"
    source_csv = reports / f"{PREFIX}_SOURCE_ROUTE_CARD_ACTOR_TMP_MASK_EVIDENCE_JOIN_MATRIX.csv"
    blocker_csv = reports / f"{PREFIX}_BLOCKER_SEPARATION_AND_NEXT_ACTION_MATRIX.csv"
    json_path = reports / f"{PREFIX}_RESULT.json"
    md_path = reports / f"{PREFIX}_RESULT.md"

    write_csv(image_csv, image_rows, ["sourceKind", "path", "exists", "width", "height", "aspect", "nonDarkBBox", "leftGutterPx", "rightGutterPx", "leftGutterNorm", "rightGutterNorm", "totalGutterRatio", "detected"])
    write_csv(layout_csv, comparison_rows, ["region", "referenceRegionDescription", "normBox", "referenceMeanNonDarkRatio", "trueCaptureNonDarkRatio", "deltaNonDarkRatio", "referenceMeanBrightRatio", "trueCaptureBrightRatio", "deltaBrightRatio", "trueCaptureNonDarkBBox", "classification", "patchDecision"])
    write_csv(source_csv, source_rows, ["evidenceKind", "sourceTable", "path", "activeSelf", "activeInHierarchy", "siblingIndex", "siblingCount", "anchoredPosition", "localPosition", "localScale", "sizeDelta", "anchorMin", "anchorMax", "warning", "payloadHeroDid", "payloadLocalStatus", "tmpText", "tmpAutoSize", "tmpCharacterSpacing", "maskEvidence", "interpretation"])
    write_csv(blocker_csv, blocker_rows, ["blockerCategory", "status", "evidence", "sourceBackedSafeNextAction", "forbiddenToGuess"])
    json_path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        f"# {PREFIX} Result",
        "",
        "## Verdict",
        "- `restoredClaim=false`, `playableClaim=false`.",
        "- `patchApplied=false`; no scene/package/manifest/xLua/handler/runtime mutation was performed.",
        f"- True capture used: `{capture}`.",
        f"- True capture aspect: `{true_capture_size.get('aspect')}`.",
        f"- Black gutter detected: `{bool(gutter_info.get('detected'))}` (`left={gutter_info.get('leftGutterPx')}`, `right={gutter_info.get('rightGutterPx')}`).",
        "",
        "## Mismatch Summary",
        f"- Route/HUD mismatch rows: `{route_hud_mismatch_rows}`.",
        f"- Bottom card mismatch rows: `{bottom_card_mismatch_rows}`.",
        f"- Actor payload blocked rows: `{actor_payload_blocked_rows}`.",
        f"- TMP/mask rows reviewed: `{tmp_mask_rows_reviewed}`.",
        f"- Safe patch candidate categories recorded, not applied: `{len(safe_patch_candidates)}`.",
        "",
        "## Blocker Split",
    ]
    for row in blocker_rows:
        md.append(f"- `{row['blockerCategory']}`: {row['status']} - {row['evidence']}")
    md.extend(
        [
            "",
            "## Outputs",
            f"- `{image_csv}`",
            f"- `{layout_csv}`",
            f"- `{source_csv}`",
            f"- `{blocker_csv}`",
            f"- `{json_path}`",
        ]
    )
    if contact_sheet:
        md.append(f"- analysis contact sheet: `{contact_sheet}`")
    md.extend(
        [
            "",
            "## Command Policy",
            f"- root `.cmd` count: `{command_policy['rootCmdCount']}`",
            f"- `_restore_tools` direct `.cmd` count: `{command_policy['restoreToolsDirectCmdCount']}`",
            f"- policy ok: `{command_policy['policyOk']}`",
        ]
    )
    md_path.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(json.dumps({"result": str(json_path), "trueCaptureAspect": result["trueCaptureAspect"], "blackGutterDetected": result["blackGutterDetected"]}, ensure_ascii=False))


if __name__ == "__main__":
    main()
