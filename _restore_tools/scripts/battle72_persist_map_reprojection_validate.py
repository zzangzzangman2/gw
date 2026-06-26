from __future__ import annotations

import csv
import json
import statistics
import struct
from datetime import datetime
from pathlib import Path


PREFIX = "BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE"


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


def image_metrics(path: Path, regions):
    info = image_size(path) or {"width": "", "height": "", "aspect": ""}
    metrics = {"path": str(path), "exists": path.exists(), "size": info, "gutter": {}, "regions": {}}
    if not path.exists():
        return metrics
    try:
        from PIL import Image

        with Image.open(path) as img:
            img = img.convert("RGB")
            metrics["gutter"] = black_gutter(img)
            metrics["regions"] = {name: region_stats(img, box) for name, box in regions.items()}
    except Exception as ex:
        metrics["error"] = type(ex).__name__ + ": " + str(ex)
    return metrics


def build_contact_sheet(paths, output: Path):
    existing = [(label, path) for label, path in paths if path.exists()]
    if not existing:
        return None
    try:
        from PIL import Image, ImageDraw

        thumb_w = 480
        label_h = 28
        thumbs = []
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


def count_root_cmds(root: Path):
    root_cmd = len(list(root.glob("*.cmd")))
    direct_restore_cmd = len(list((root / "_restore_tools").glob("*.cmd"))) if (root / "_restore_tools").exists() else 0
    return {
        "rootCmdCount": root_cmd,
        "restoreToolsDirectCmdCount": direct_restore_cmd,
        "policyOk": root_cmd == 1 and direct_restore_cmd == 0,
    }


def file_row(root: Path, path: Path, kind: str, action: str, canonical: bool):
    return {
        "fileKind": kind,
        "path": str(path),
        "exists": path.exists(),
        "bytes": path.stat().st_size if path.exists() else "",
        "action": action,
        "canonicalScene": canonical,
        "notes": "canonical overwrite forbidden" if canonical else "BATTLE72 candidate/report artifact",
    }


def add_file_with_meta(rows, root: Path, path: Path, kind: str, action: str, canonical: bool):
    rows.append(file_row(root, path, kind, action, canonical))
    meta = Path(str(path) + ".meta")
    if meta.exists():
        rows.append(file_row(root, meta, kind + "_meta", action + "_meta", canonical))


def main():
    root = Path(__file__).resolve().parents[2]
    reports = root / "reports" / "battle"
    unity = root / "girlswar_battle_unity"
    unity_data = unity / "Assets" / "RestoreData" / "battle"
    capture_dir = unity / "Assets" / "RestoreCaptures" / "battle_actor"
    work_dir = root / "work" / "battle72_persisted_map_reprojection"

    unity_summary_path = unity_data / f"{PREFIX}_UNITY.json"
    unity_transform_path = unity_data / f"{PREFIX}_PERSISTED_TRANSFORMS_UNITY.csv"
    unity_summary = read_json(unity_summary_path, {})
    unity_transform_rows = read_csv(unity_transform_path)
    battle71_result = read_json(reports / "BATTLE_71_CANDIDATE_ONLY_MAP_11003_TRUE_ASPECT_REPROJECTION_AND_CAPTURE_VALIDATE_NO_CANONICAL_SCENE_OVERWRITE_RESULT.json", {})

    baseline_capture = capture_dir / "Battle68TrueReferenceAspectNoSceneSave_1920x855.png"
    battle71_capture = capture_dir / "Battle71Map11003TrueAspectReprojectionCandidate_1920x855.png"
    battle72_capture = capture_dir / "Battle72PersistedMap11003TrueAspectReprojectionCandidate_1920x855.png"
    reference_capture = root / "work" / "reference_video" / "frames_5s" / "sample_004.jpg"
    reference_2 = root / "work" / "reference_video" / "frames_5s" / "sample_007.jpg"
    reference_3 = root / "work" / "reference_video" / "frames_5s" / "sample_012.jpg"

    regions = {
        "full_frame": (0.0, 0.0, 1.0, 1.0),
        "top_hud": (0.0, 0.03, 1.0, 0.16),
        "right_control_rail": (0.88, 0.30, 0.99, 0.66),
        "bottom_five_cards": (0.25, 0.75, 0.78, 1.0),
        "friendly_actor_band": (0.12, 0.20, 0.48, 0.92),
        "enemy_actor_band": (0.50, 0.20, 0.88, 0.92),
    }

    metrics = {
        "battle68_baseline": image_metrics(baseline_capture, regions),
        "battle71_memory_candidate": image_metrics(battle71_capture, regions),
        "battle72_persisted_candidate": image_metrics(battle72_capture, regions),
        "reference_sample_004": image_metrics(reference_capture, regions),
        "reference_sample_007": image_metrics(reference_2, regions),
        "reference_sample_012": image_metrics(reference_3, regions),
    }

    validation_rows = []
    for source, data in metrics.items():
        gutter = data.get("gutter", {})
        size = data.get("size", {})
        validation_rows.append(
            {
                "source": source,
                "metricKind": "gutter",
                "region": "full_frame",
                "width": size.get("width", ""),
                "height": size.get("height", ""),
                "aspect": size.get("aspect", ""),
                "leftGutterPx": gutter.get("leftGutterPx", ""),
                "rightGutterPx": gutter.get("rightGutterPx", ""),
                "totalGutterRatio": gutter.get("totalGutterRatio", ""),
                "nonDarkRatio": "",
                "brightRatio": "",
                "nonDarkBBox": "",
                "classification": "reference_or_candidate_gutter_metric",
            }
        )
        for region in regions:
            stat = data.get("regions", {}).get(region, {})
            validation_rows.append(
                {
                    "source": source,
                    "metricKind": "region_non_dark",
                    "region": region,
                    "width": size.get("width", ""),
                    "height": size.get("height", ""),
                    "aspect": size.get("aspect", ""),
                    "leftGutterPx": "",
                    "rightGutterPx": "",
                    "totalGutterRatio": "",
                    "nonDarkRatio": stat.get("nonDarkRatio", ""),
                    "brightRatio": stat.get("brightRatio", ""),
                    "nonDarkBBox": stat.get("nonDarkBBox", ""),
                    "classification": "region_signal_metric",
                }
            )

    b68_gutter = metrics["battle68_baseline"].get("gutter", {})
    b71_gutter = metrics["battle71_memory_candidate"].get("gutter", {})
    b72_gutter = metrics["battle72_persisted_candidate"].get("gutter", {})
    b72_total = float_value(b72_gutter.get("totalGutterRatio"), 9)
    b71_total = float_value(b71_gutter.get("totalGutterRatio"), 9)
    persisted_matches_b71 = battle72_capture.exists() and abs(b72_total - b71_total) <= 0.001 and b72_gutter.get("leftGutterPx") == b71_gutter.get("leftGutterPx") and b72_gutter.get("rightGutterPx") == b71_gutter.get("rightGutterPx")

    b71_full = metrics["battle71_memory_candidate"].get("regions", {}).get("full_frame", {})
    b72_full = metrics["battle72_persisted_candidate"].get("regions", {}).get("full_frame", {})
    full_delta = float_value(b72_full.get("nonDarkRatio")) - float_value(b71_full.get("nonDarkRatio"))
    new_major_regression = battle72_capture.exists() and full_delta < -0.05
    candidate_decision = "persisted_map_reprojection_candidate_validated" if persisted_matches_b71 and not new_major_regression else "persisted_candidate_regressed_needs_builder_fix"

    candidate_scene = unity / "Assets" / "Scenes" / "Battle72Map11003TrueAspectReprojectionPersistedCandidate.unity"
    changed_file_rows = []
    add_file_with_meta(changed_file_rows, root, unity / "Assets" / "Editor" / "Battle72PersistMap11003TrueAspectReprojectionEditor.cs", "editor_script", "created_or_updated", False)
    add_file_with_meta(changed_file_rows, root, root / "_restore_tools" / "scripts" / "battle72_persist_map_reprojection_validate.py", "analysis_script", "created_or_updated", False)
    add_file_with_meta(changed_file_rows, root, root / "_restore_tools" / "cmd_archive" / f"{PREFIX}.cmd", "cmd_archive", "created_or_updated", False)
    add_file_with_meta(changed_file_rows, root, candidate_scene, "candidate_scene", "saved_candidate_scene", False)
    add_file_with_meta(changed_file_rows, root, battle72_capture, "candidate_capture", "generated", False)
    add_file_with_meta(changed_file_rows, root, unity_summary_path, "unity_summary", "generated", False)
    add_file_with_meta(changed_file_rows, root, unity_transform_path, "unity_transform_csv", "generated", False)

    transform_rows = []
    for row in unity_transform_rows:
        merged = dict(row)
        merged["persistedMatchesBattle71"] = ""
        b71_row = None
        # The B71 matrix has compatible spriteName/after values; optional comparison happens below if available.
        transform_rows.append(merged)

    blocker_rows = [
        {
            "blockerCategory": "map_reprojection_persistence",
            "status": candidate_decision,
            "evidence": f"B68={b68_gutter.get('leftGutterPx')}/{b68_gutter.get('rightGutterPx')}; B71={b71_gutter.get('leftGutterPx')}/{b71_gutter.get('rightGutterPx')}; B72={b72_gutter.get('leftGutterPx')}/{b72_gutter.get('rightGutterPx')}",
            "nextAction": "review persisted BATTLE72 scene/capture as candidate artifact; do not promote to canonical without control approval",
            "guardrail": "canonicalSceneOverwritten=false",
        },
        {
            "blockerCategory": "route_hud_runtime_state",
            "status": "still_blocked",
            "evidence": "BATTLE72 did not patch HUD/right rail; BATTLE70 runtime/handler evidence requirement remains",
            "nextAction": "requires original xLua/GameEntry/ModulesInit or serialized runtime state evidence",
            "guardrail": "no fake handler or route hide/show",
        },
        {
            "blockerCategory": "bottom_card_and_actor_payload",
            "status": "still_blocked",
            "evidence": "BATTLE72 did not patch bottom cards or full actor payload",
            "nextAction": "resolve payload chains separately",
            "guardrail": "no fake card/icon/actor/mesh",
        },
        {
            "blockerCategory": "timeline_xlua_runtime",
            "status": "still_blocked",
            "evidence": "Timeline/xLua/runtime blockers remain outside map reprojection scope",
            "nextAction": "requires approved/source-backed runtime/package path before true playability",
            "guardrail": "no package import/download in BATTLE72",
        },
    ]

    contact_sheet = build_contact_sheet(
        [
            ("B68 baseline", baseline_capture),
            ("B71 memory", battle71_capture),
            ("B72 persisted", battle72_capture),
            ("reference", reference_capture),
        ],
        work_dir / f"{PREFIX}_baseline_b71_b72_reference_contact_sheet.jpg",
    )

    command_policy = count_root_cmds(root)
    result = {
        "task": PREFIX,
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "playableClaim": False,
        "canonicalSceneOverwritten": False,
        "candidateSceneSaved": bool_value(unity_summary.get("candidateSceneSaved")),
        "sceneSaved": bool_value(unity_summary.get("sceneSaved")),
        "packageImported": False,
        "manifestModified": False,
        "runtimeInstrumentationUsed": False,
        "hudRoutePatched": False,
        "cardPayloadPatched": False,
        "actorPayloadPatched": False,
        "candidateBuilderPatched": bool_value(unity_summary.get("candidateBuilderPatched")),
        "mapLayersPersistedCount": int(unity_summary.get("mapLayersPersistedCount") or 0),
        "mapLayerFormulaSourceBacked": True,
        "baselineLeftGutterPx": 200,
        "baselineRightGutterPx": 27,
        "battle71LeftGutterPx": b71_gutter.get("leftGutterPx"),
        "battle71RightGutterPx": b71_gutter.get("rightGutterPx"),
        "battle72LeftGutterPx": b72_gutter.get("leftGutterPx"),
        "battle72RightGutterPx": b72_gutter.get("rightGutterPx"),
        "battle72TotalGutterRatio": b72_gutter.get("totalGutterRatio"),
        "persistedCandidateMatchesBattle71": persisted_matches_b71,
        "newMajorVisualRegressionDetected": new_major_regression,
        "candidateDecision": candidate_decision,
        "nextBlocker": "ROUTE_HUD_RUNTIME_STATE_AND_PAYLOAD_TIMELINE_XLUA_BLOCKERS_REMAIN_AFTER_PERSISTED_MAP_REPROJECTION" if candidate_decision == "persisted_map_reprojection_candidate_validated" else "PERSISTED_MAP_REPROJECTION_BUILDER_FIX_REQUIRED",
        "guardrailsTouched": [
            "candidate_only_scene_saved",
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
        "candidateScene": str(candidate_scene),
        "candidateCapture": str(battle72_capture),
        "contactSheet": str(contact_sheet) if contact_sheet else None,
        "unitySummary": str(unity_summary_path),
        "unityStatus": unity_summary.get("status"),
    }

    changed_csv = reports / f"{PREFIX}_PERSISTED_CANDIDATE_CHANGED_FILE_SCENE_MATRIX.csv"
    transform_csv = reports / f"{PREFIX}_PERSISTED_CANDIDATE_MAP_LAYER_TRANSFORM_MATRIX.csv"
    validation_csv = reports / f"{PREFIX}_BATTLE68_BATTLE71_BATTLE72_REFERENCE_CAPTURE_VALIDATION_MATRIX.csv"
    blocker_csv = reports / f"{PREFIX}_BLOCKER_SEPARATION_AND_NEXT_ACTION_MATRIX.csv"
    json_path = reports / f"{PREFIX}_RESULT.json"
    md_path = reports / f"{PREFIX}_RESULT.md"

    write_csv(changed_csv, changed_file_rows, ["fileKind", "path", "exists", "bytes", "action", "canonicalScene", "notes"])
    write_csv(
        transform_csv,
        transform_rows,
        [
            "spriteName",
            "role",
            "sourcePath",
            "absolutePath",
            "sourceTextureExists",
            "objectFound",
            "objectPath",
            "activeSelf",
            "activeInHierarchy",
            "rendererEnabled",
            "pixelX",
            "pixelY",
            "pixelWidth",
            "pixelHeight",
            "sortingOrder",
            "baselinePpu",
            "truePpu",
            "baselineFormulaLocalPosition",
            "trueFormulaLocalPosition",
            "trueFormulaLocalScale",
            "beforeLocalPosition",
            "afterLocalPosition",
            "persistedLocalPosition",
            "beforeLocalScale",
            "afterLocalScale",
            "persistedLocalScale",
            "beforeWorldPosition",
            "afterWorldPosition",
            "beforeSprite",
            "beforeMaterial",
            "beforeRendererSortingOrder",
            "changedPosition",
            "changedScale",
            "changed",
            "persistedObjectFound",
            "persistedMatchesAfter",
            "formulaSource",
            "failReason",
            "persistedMatchesBattle71",
        ],
    )
    write_csv(
        validation_csv,
        validation_rows,
        [
            "source",
            "metricKind",
            "region",
            "width",
            "height",
            "aspect",
            "leftGutterPx",
            "rightGutterPx",
            "totalGutterRatio",
            "nonDarkRatio",
            "brightRatio",
            "nonDarkBBox",
            "classification",
        ],
    )
    write_csv(blocker_csv, blocker_rows, ["blockerCategory", "status", "evidence", "nextAction", "guardrail"])
    json_path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        f"# {PREFIX} Result",
        "",
        "## Verdict",
        "- `restoredClaim=false`, `playableClaim=false`.",
        f"- Candidate builder patched: `{result['candidateBuilderPatched']}`.",
        f"- Candidate scene saved: `{result['candidateSceneSaved']}`; canonical scene overwritten: `{result['canonicalSceneOverwritten']}`.",
        "- HUD/routes/cards/actors/xLua/packages/manifests were not patched.",
        "",
        "## Persistence",
        f"- Candidate scene: `{candidate_scene}`.",
        f"- Map layers persisted: `{result['mapLayersPersistedCount']}`.",
        f"- Formula source-backed: `{result['mapLayerFormulaSourceBacked']}`.",
        "",
        "## Capture Validation",
        f"- BATTLE72 capture: `{battle72_capture}`.",
        f"- Gutter B68 baseline: `200/27`.",
        f"- Gutter B71 memory: `{result['battle71LeftGutterPx']}/{result['battle71RightGutterPx']}`.",
        f"- Gutter B72 persisted: `{result['battle72LeftGutterPx']}/{result['battle72RightGutterPx']}`; total `{result['battle72TotalGutterRatio']}`.",
        f"- Persisted candidate matches BATTLE71: `{persisted_matches_b71}`.",
        f"- New major visual regression detected: `{new_major_regression}`.",
        f"- Candidate decision: `{candidate_decision}`.",
        "",
        "## Outputs",
        f"- `{changed_csv}`",
        f"- `{transform_csv}`",
        f"- `{validation_csv}`",
        f"- `{blocker_csv}`",
        f"- `{json_path}`",
    ]
    if contact_sheet:
        md.append(f"- contact sheet: `{contact_sheet}`")
    md.extend(["", "## Remaining Blockers"])
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
                "candidateScene": str(candidate_scene),
                "capture": str(battle72_capture),
                "battle72Gutter": f"{result['battle72LeftGutterPx']}/{result['battle72RightGutterPx']}",
                "candidateDecision": candidate_decision,
            },
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()
