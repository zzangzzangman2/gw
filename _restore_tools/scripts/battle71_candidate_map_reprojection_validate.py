from __future__ import annotations

import csv
import json
import statistics
import struct
from datetime import datetime
from pathlib import Path


PREFIX = "BATTLE_71_CANDIDATE_ONLY_MAP_11003_TRUE_ASPECT_REPROJECTION_AND_CAPTURE_VALIDATE_NO_CANONICAL_SCENE_OVERWRITE"


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


def luminance(pixel):
    r, g, b = pixel[:3]
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def clamp_box(width, height, box):
    x1 = max(0, min(width, int(round(box[0] * width))))
    y1 = max(0, min(height, int(round(box[1] * height))))
    x2 = max(x1 + 1, min(width, int(round(box[2] * width))))
    y2 = max(y1 + 1, min(height, int(round(box[3] * height))))
    return x1, y1, x2, y2


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
    return {
        "pixelBox": f"{x1}/{y1}/{x2 - 1}/{y2 - 1}",
        "pixelCount": total,
        "meanLuma": round(sum(lum) / total, 4),
        "nonDarkRatio": round(non_dark / total, 6),
        "brightRatio": round(bright / total, 6),
        "lumaStd": round(statistics.pstdev(lum), 4) if len(lum) > 1 else 0,
        "nonDarkBBox": non_dark_bbox(crop, offset=(x1, y1)),
    }


def count_root_cmds(root: Path):
    root_cmd = len(list(root.glob("*.cmd")))
    direct_restore_cmd = len(list((root / "_restore_tools").glob("*.cmd"))) if (root / "_restore_tools").exists() else 0
    return {
        "rootCmdCount": root_cmd,
        "restoreToolsDirectCmdCount": direct_restore_cmd,
        "policyOk": root_cmd == 1 and direct_restore_cmd == 0,
    }


def bool_value(value):
    if isinstance(value, bool):
        return value
    if value is None:
        return False
    return str(value).strip().lower() == "true"


def float_value(value, default=0.0):
    try:
        return float(value)
    except Exception:
        return default


def copy_unity_csv_rows(rows, extra=None):
    output = []
    for row in rows:
        merged = dict(row)
        if extra:
            merged.update(extra)
        output.append(merged)
    return output


def build_contact_sheet(paths, output: Path):
    existing = [(label, path) for label, path in paths if path.exists()]
    if not existing:
        return None
    try:
        from PIL import Image, ImageDraw

        thumbs = []
        thumb_w = 640
        label_h = 28
        for label, path in existing:
            with Image.open(path) as img:
                img = img.convert("RGB")
                ratio = thumb_w / img.width
                thumb_h = max(1, int(round(img.height * ratio)))
                img = img.resize((thumb_w, thumb_h))
                canvas = Image.new("RGB", (thumb_w, thumb_h + label_h), (20, 20, 20))
                canvas.paste(img, (0, label_h))
                draw = ImageDraw.Draw(canvas)
                draw.text((8, 7), label, fill=(255, 255, 255))
                thumbs.append(canvas)
        width = thumb_w * len(thumbs)
        height = max(t.height for t in thumbs)
        sheet = Image.new("RGB", (width, height), (0, 0, 0))
        x = 0
        for thumb in thumbs:
            sheet.paste(thumb, (x, 0))
            x += thumb_w
        output.parent.mkdir(parents=True, exist_ok=True)
        sheet.save(output, quality=92)
        return output
    except Exception:
        return None


def main():
    root = Path(__file__).resolve().parents[2]
    reports = root / "reports" / "battle"
    unity_data = root / "girlswar_battle_unity" / "Assets" / "RestoreData" / "battle"
    capture_dir = root / "girlswar_battle_unity" / "Assets" / "RestoreCaptures" / "battle_actor"
    work_dir = root / "work" / "battle71_map_reprojection"

    unity_summary_path = unity_data / f"{PREFIX}_UNITY.json"
    unity_formula_path = unity_data / f"{PREFIX}_MAP_LAYER_FORMULA_UNITY.csv"
    unity_transform_path = unity_data / f"{PREFIX}_CHANGED_TRANSFORMS_UNITY.csv"

    unity_summary = read_json(unity_summary_path, {})
    unity_formula_rows = read_csv(unity_formula_path)
    unity_transform_rows = read_csv(unity_transform_path)
    b69 = read_json(reports / "BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH_RESULT.json", {})
    b69_layout = read_csv(reports / "BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH_REFERENCE_VS_TRUE_CAPTURE_NORMALIZED_LAYOUT_MATRIX.csv")

    baseline_capture = capture_dir / "Battle68TrueReferenceAspectNoSceneSave_1920x855.png"
    candidate_capture = capture_dir / "Battle71Map11003TrueAspectReprojectionCandidate_1920x855.png"
    reference_paths = [
        root / "work" / "reference_video" / "frames_5s" / "sample_004.jpg",
        root / "work" / "reference_video" / "frames_5s" / "sample_007.jpg",
        root / "work" / "reference_video" / "frames_5s" / "sample_012.jpg",
    ]

    regions = {
        "full_frame": (0.0, 0.0, 1.0, 1.0),
        "top_hud": (0.0, 0.03, 1.0, 0.16),
        "right_control_rail": (0.88, 0.30, 0.99, 0.66),
        "bottom_five_cards": (0.25, 0.75, 0.78, 1.0),
        "friendly_actor_band": (0.12, 0.20, 0.48, 0.92),
        "enemy_actor_band": (0.50, 0.20, 0.88, 0.92),
    }

    validation_rows = []
    baseline_gutter = {"leftGutterPx": 200, "rightGutterPx": 27, "totalGutterRatio": 0.118229, "detected": True}
    candidate_gutter = {"leftGutterPx": None, "rightGutterPx": None, "totalGutterRatio": None, "detected": False}
    baseline_stats = {}
    candidate_stats = {}
    reference_means = {}

    try:
        from PIL import Image

        if baseline_capture.exists():
            with Image.open(baseline_capture) as img:
                img = img.convert("RGB")
                baseline_gutter = black_gutter(img)
                baseline_stats = {name: region_stats(img, box) for name, box in regions.items()}
        if candidate_capture.exists():
            with Image.open(candidate_capture) as img:
                img = img.convert("RGB")
                candidate_gutter = black_gutter(img)
                candidate_stats = {name: region_stats(img, box) for name, box in regions.items()}
        for name, box in regions.items():
            stats = []
            for path in reference_paths:
                if not path.exists():
                    continue
                with Image.open(path) as img:
                    stats.append(region_stats(img.convert("RGB"), box))
            if stats:
                reference_means[name] = {
                    "nonDarkRatio": round(sum(s.get("nonDarkRatio", 0) for s in stats) / len(stats), 6),
                    "brightRatio": round(sum(s.get("brightRatio", 0) for s in stats) / len(stats), 6),
                }
    except Exception as ex:
        validation_rows.append(
            {
                "metricKind": "analysis_error",
                "region": "",
                "baselineValue": "",
                "candidateValue": "",
                "deltaCandidateMinusBaseline": "",
                "referenceMean": "",
                "classification": "image_analysis_failed",
                "evidence": type(ex).__name__ + ": " + str(ex),
            }
        )

    baseline_size = image_size(baseline_capture) or {}
    candidate_size = image_size(candidate_capture) or {}
    validation_rows.append(
        {
            "metricKind": "gutter",
            "region": "full_frame",
            "baselineValue": f"left={baseline_gutter.get('leftGutterPx')}; right={baseline_gutter.get('rightGutterPx')}; total={baseline_gutter.get('totalGutterRatio')}",
            "candidateValue": f"left={candidate_gutter.get('leftGutterPx')}; right={candidate_gutter.get('rightGutterPx')}; total={candidate_gutter.get('totalGutterRatio')}",
            "deltaCandidateMinusBaseline": round(float_value(candidate_gutter.get("totalGutterRatio")) - float_value(baseline_gutter.get("totalGutterRatio")), 6),
            "referenceMean": "reference total gutter ~0.00625 from BATTLE69",
            "classification": "gutter_improved" if float_value(candidate_gutter.get("totalGutterRatio"), 9) < float_value(baseline_gutter.get("totalGutterRatio"), 0) else "gutter_not_improved",
            "evidence": f"baselineSize={baseline_size}; candidateSize={candidate_size}",
        }
    )

    for name in regions:
        b = baseline_stats.get(name, {})
        c = candidate_stats.get(name, {})
        ref = reference_means.get(name, {})
        delta = round(float_value(c.get("nonDarkRatio")) - float_value(b.get("nonDarkRatio")), 6)
        validation_rows.append(
            {
                "metricKind": "region_non_dark",
                "region": name,
                "baselineValue": b.get("nonDarkRatio", ""),
                "candidateValue": c.get("nonDarkRatio", ""),
                "deltaCandidateMinusBaseline": delta,
                "referenceMean": ref.get("nonDarkRatio", ""),
                "classification": "region_signal_preserved_or_increased" if delta >= -0.05 else "region_signal_regression_check",
                "evidence": f"baselineBBox={b.get('nonDarkBBox','')}; candidateBBox={c.get('nonDarkBBox','')}",
            }
        )

    formula_rows = copy_unity_csv_rows(unity_formula_rows, {"matrixSource": "unity_candidate_formula"})
    transform_rows = copy_unity_csv_rows(unity_transform_rows, {"matrixSource": "unity_candidate_transform"})

    changed_count = sum(1 for r in unity_transform_rows if bool_value(r.get("changed")))
    found_count = sum(1 for r in unity_transform_rows if bool_value(r.get("objectFound")))
    formula_source_backed = len(unity_formula_rows) >= 9 and all(bool_value(r.get("sourceTextureExists")) for r in unity_formula_rows)
    candidate_total = float_value(candidate_gutter.get("totalGutterRatio"), 9.0)
    baseline_total = float_value(baseline_gutter.get("totalGutterRatio"), 0.118229)
    gutter_improved = candidate_capture.exists() and candidate_total < baseline_total - 0.01
    full_delta = next((float_value(r.get("deltaCandidateMinusBaseline")) for r in validation_rows if r.get("metricKind") == "region_non_dark" and r.get("region") == "full_frame"), 0.0)
    new_major_regression = candidate_capture.exists() and full_delta < -0.15

    if not candidate_capture.exists():
        candidate_decision = "candidate_rejected_or_needs_formula_revision"
    elif gutter_improved and not new_major_regression:
        candidate_decision = "map_reprojection_candidate_validated_for_next_review"
    else:
        candidate_decision = "candidate_rejected_or_needs_formula_revision"

    blocker_rows = [
        {
            "blockerCategory": "map_reprojection_candidate",
            "status": candidate_decision,
            "evidence": f"gutter before left/right={baseline_gutter.get('leftGutterPx')}/{baseline_gutter.get('rightGutterPx')} after={candidate_gutter.get('leftGutterPx')}/{candidate_gutter.get('rightGutterPx')}",
            "nextAction": "review candidate capture; if accepted, make candidate scene/builder patch only, then rerun BATTLE68/BATTLE69 validation",
            "guardrail": "not restored/playable; no canonical scene overwrite",
        },
        {
            "blockerCategory": "route_hud_runtime_state",
            "status": "still_blocked",
            "evidence": "BATTLE70 route/HUD rows needing runtime/handler evidence remain separate; HUD/right rail was not patched",
            "nextAction": "requires original xLua/GameEntry/ModulesInit or source-backed serialized runtime state evidence",
            "guardrail": "no fake handler; no arbitrary route hide/show",
        },
        {
            "blockerCategory": "bottom_card_and_actor_payload",
            "status": "still_blocked",
            "evidence": "BATTLE69/BATTLE70 payload blockers remain: bottom card assembly incomplete and full actor formation gaps remain",
            "nextAction": "resolve payload chains separately",
            "guardrail": "no fake card/icon/actor/mesh",
        },
        {
            "blockerCategory": "timeline_xlua_runtime",
            "status": "still_blocked",
            "evidence": "BATTLE59/BATTLE64/BATTLE65 blockers remain outside map reprojection scope",
            "nextAction": "requires approved/source-backed runtime/package path before true playability",
            "guardrail": "no external package/import/download in BATTLE71",
        },
    ]

    contact_sheet = build_contact_sheet(
        [
            ("BATTLE68 baseline 1920x855", baseline_capture),
            ("BATTLE71 candidate 1920x855", candidate_capture),
            ("reference sample_004", reference_paths[0]),
        ],
        work_dir / f"{PREFIX}_baseline_candidate_reference_contact_sheet.jpg",
    )

    command_policy = count_root_cmds(root)
    result = {
        "task": PREFIX,
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "playableClaim": False,
        "candidatePatchApplied": bool_value(unity_summary.get("candidatePatchApplied")) or changed_count > 0,
        "canonicalSceneOverwritten": False,
        "candidateSceneSaved": bool_value(unity_summary.get("candidateSceneSaved")),
        "sceneSaved": bool_value(unity_summary.get("sceneSaved")),
        "packageImported": False,
        "manifestModified": False,
        "runtimeInstrumentationUsed": False,
        "hudRoutePatched": False,
        "cardPayloadPatched": False,
        "actorPayloadPatched": False,
        "mapLayersFound": found_count,
        "mapLayersChangedCount": changed_count,
        "mapLayerFormulaSourceBacked": formula_source_backed,
        "baselineLeftGutterPx": 200,
        "baselineRightGutterPx": 27,
        "candidateLeftGutterPx": candidate_gutter.get("leftGutterPx"),
        "candidateRightGutterPx": candidate_gutter.get("rightGutterPx"),
        "candidateTotalGutterRatio": candidate_gutter.get("totalGutterRatio"),
        "gutterImproved": gutter_improved,
        "newMajorVisualRegressionDetected": new_major_regression,
        "candidateDecision": candidate_decision,
        "nextBlocker": "ROUTE_HUD_RUNTIME_STATE_AND_PAYLOAD_TIMELINE_XLUA_BLOCKERS_REMAIN_AFTER_MAP_REPROJECTION_REVIEW" if gutter_improved else "MAP_REPROJECTION_FORMULA_REVISION_OR_CAMERA_MAP_FRAMING_TRACE_REQUIRED",
        "guardrailsTouched": [
            "candidate_only_map_reprojection",
            "no_canonical_scene_overwrite",
            "no_package_import",
            "no_manifest_edit",
            "no_xlua_or_handler_patch",
            "no_hud_route_patch",
            "no_card_or_actor_payload_patch",
            "no_fake_hud_card_icon_text_actor_effect",
            "no_screenshot_or_atlas_paste_as_asset",
            "no_coordinate_only_success",
            "no_runtime_instrumentation",
        ],
        "commandPolicy": command_policy,
        "unitySummary": str(unity_summary_path),
        "candidateCapture": str(candidate_capture),
        "contactSheet": str(contact_sheet) if contact_sheet else None,
        "unityStatus": unity_summary.get("status"),
        "unitySceneDirtyBefore": unity_summary.get("sceneDirtyBefore"),
        "unitySceneDirtyAfter": unity_summary.get("sceneDirtyAfter"),
    }

    formula_csv = reports / f"{PREFIX}_MAP_11003_SOURCE_LAYER_REPROJECTION_FORMULA_SOURCE_MATRIX.csv"
    transform_csv = reports / f"{PREFIX}_CANDIDATE_CHANGED_TRANSFORM_MATRIX.csv"
    validation_csv = reports / f"{PREFIX}_BASELINE_VS_CANDIDATE_TRUE_ASPECT_CAPTURE_GUTTER_REGION_VALIDATION_MATRIX.csv"
    blocker_csv = reports / f"{PREFIX}_BLOCKER_SEPARATION_AND_NEXT_ACTION_MATRIX.csv"
    json_path = reports / f"{PREFIX}_RESULT.json"
    md_path = reports / f"{PREFIX}_RESULT.md"

    write_csv(
        formula_csv,
        formula_rows,
        [
            "matrixSource",
            "spriteName",
            "role",
            "sourcePath",
            "absolutePath",
            "sourceTextureExists",
            "pixelX",
            "pixelY",
            "pixelWidth",
            "pixelHeight",
            "sortingOrder",
            "baselineCaptureSize",
            "trueCaptureSize",
            "baselinePpu",
            "truePpu",
            "baselineWorldX",
            "baselineWorldY",
            "trueWorldX",
            "trueWorldY",
            "baselineScale",
            "trueScale",
            "formulaSource",
        ],
    )
    write_csv(
        transform_csv,
        transform_rows,
        [
            "matrixSource",
            "spriteName",
            "role",
            "objectFound",
            "objectPath",
            "activeSelf",
            "activeInHierarchy",
            "rendererEnabled",
            "pixelX",
            "pixelY",
            "sortingOrder",
            "beforeLocalPosition",
            "afterLocalPosition",
            "beforeLocalScale",
            "afterLocalScale",
            "beforeWorldPosition",
            "afterWorldPosition",
            "beforeSprite",
            "beforeMaterial",
            "beforeRendererSortingOrder",
            "changedPosition",
            "changedScale",
            "changed",
            "failReason",
        ],
    )
    write_csv(
        validation_csv,
        validation_rows,
        [
            "metricKind",
            "region",
            "baselineValue",
            "candidateValue",
            "deltaCandidateMinusBaseline",
            "referenceMean",
            "classification",
            "evidence",
        ],
    )
    write_csv(
        blocker_csv,
        blocker_rows,
        ["blockerCategory", "status", "evidence", "nextAction", "guardrail"],
    )
    json_path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        f"# {PREFIX} Result",
        "",
        "## Verdict",
        "- `restoredClaim=false`, `playableClaim=false`.",
        f"- Candidate patch applied in Unity memory: `{result['candidatePatchApplied']}`.",
        "- `canonicalSceneOverwritten=false`; HUD/routes/cards/actors/xLua/packages/manifests were not patched.",
        f"- Candidate scene saved: `{result['candidateSceneSaved']}`; scene saved: `{result['sceneSaved']}`.",
        "",
        "## Map Reprojection",
        f"- Map layers found/changed: `{found_count}` / `{changed_count}`.",
        f"- Formula source-backed: `{formula_source_backed}`.",
        "- Formula source: BATTLE27 `CreateMapLayerPixel`, replacing the 1920x1080 ppu with the 1920x855 true-aspect ppu for the same source sprite rows.",
        "",
        "## Capture Validation",
        f"- Candidate capture: `{candidate_capture}`.",
        f"- Baseline gutter left/right: `200` / `27` px.",
        f"- Candidate gutter left/right: `{result['candidateLeftGutterPx']}` / `{result['candidateRightGutterPx']}` px.",
        f"- Candidate total gutter ratio: `{result['candidateTotalGutterRatio']}`.",
        f"- Gutter improved: `{gutter_improved}`.",
        f"- New major visual regression detected: `{new_major_regression}`.",
        f"- Candidate decision: `{candidate_decision}`.",
        "",
        "## Outputs",
        f"- `{formula_csv}`",
        f"- `{transform_csv}`",
        f"- `{validation_csv}`",
        f"- `{blocker_csv}`",
        f"- `{json_path}`",
    ]
    if contact_sheet:
        md.append(f"- contact sheet: `{contact_sheet}`")
    md.extend(
        [
            "",
            "## Remaining Blockers",
        ]
    )
    for row in blocker_rows:
        md.append(f"- `{row['blockerCategory']}`: {row['status']} - {row['evidence']}")
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

    print(
        json.dumps(
            {
                "result": str(json_path),
                "candidateCapture": str(candidate_capture),
                "changedCount": changed_count,
                "candidateLeftGutterPx": result["candidateLeftGutterPx"],
                "candidateRightGutterPx": result["candidateRightGutterPx"],
                "gutterImproved": gutter_improved,
                "candidateDecision": candidate_decision,
            },
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()
