from __future__ import annotations

import csv
import json
import math
from datetime import datetime
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


PREFIX = "BATTLE_67_ASPECT_CORRECT_CROP_VISUAL_VALIDATION_NO_PATCH"


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


def count_root_cmds(root: Path):
    return {
        "rootCmdCount": len(list(root.glob("*.cmd"))),
        "restoreToolsDirectCmdCount": len(list((root / "_restore_tools").glob("*.cmd")))
        if (root / "_restore_tools").exists()
        else 0,
    }


def content_rect(width: int, height: int, reference_aspect: float):
    exact_height = width / reference_aspect
    crop_height = int(round(exact_height))
    crop_height = min(crop_height, height)
    exact_top = (height - exact_height) / 2.0
    top = max(0, (height - crop_height) // 2)
    bottom = top + crop_height
    return {
        "x": 0,
        "yExact": round(exact_top, 4),
        "y": top,
        "width": width,
        "height": crop_height,
        "bottom": bottom,
        "extraVerticalPixelsExact": round(height - exact_height, 4),
        "extraVerticalPixelsInt": height - crop_height,
        "normalizedY": round(top / height, 6) if height else None,
        "normalizedHeight": round(crop_height / height, 6) if height else None,
    }


def parse_pixel_rect(value: str):
    if not value:
        return None
    try:
        vals = [float(v) for v in value.replace(",", "/").split("/") if v != ""]
    except ValueError:
        return None
    if len(vals) != 4:
        return None
    x1, y1, x2, y2 = vals
    return {"x1": x1, "y1": y1, "x2": x2, "y2": y2}


def rect_center(rect):
    return ((rect["x1"] + rect["x2"]) / 2.0, (rect["y1"] + rect["y2"]) / 2.0)


def clip_rect_to_content(rect, crop):
    clipped = {
        "x1": max(rect["x1"], crop["x"]),
        "y1": max(rect["y1"], crop["y"]),
        "x2": min(rect["x2"], crop["x"] + crop["width"]),
        "y2": min(rect["y2"], crop["bottom"]),
    }
    if clipped["x2"] <= clipped["x1"] or clipped["y2"] <= clipped["y1"]:
        return None
    return clipped


def in_band(x_norm, y_norm, side: str):
    if side == "our":
        return 0.18 <= x_norm <= 0.45 and 0.25 <= y_norm <= 0.86
    if side == "enemy":
        return 0.55 <= x_norm <= 0.82 and 0.25 <= y_norm <= 0.82
    return False


def signal_metrics(image: Image.Image):
    rgba = image.convert("RGBA")
    total = rgba.width * rgba.height
    non_dark = 0
    min_x = min_y = None
    max_x = max_y = None
    for y in range(rgba.height):
        for x in range(rgba.width):
            r, g, b, a = rgba.getpixel((x, y))
            if a > 0 and max(r, g, b) > 12:
                non_dark += 1
                min_x = x if min_x is None else min(min_x, x)
                min_y = y if min_y is None else min(min_y, y)
                max_x = x if max_x is None else max(max_x, x)
                max_y = y if max_y is None else max(max_y, y)
    bbox = "" if min_x is None else f"{min_x}/{min_y}/{max_x}/{max_y}"
    return {
        "nonDarkPixels": non_dark,
        "nonDarkRatio": round(non_dark / total, 8) if total else 0,
        "nonDarkBBox": bbox,
    }


def add_label(draw: ImageDraw.ImageDraw, xy, text: str):
    try:
        font = ImageFont.truetype("arial.ttf", 18)
    except Exception:
        font = ImageFont.load_default()
    x, y = xy
    draw.rectangle((x, y, x + max(260, len(text) * 10), y + 26), fill=(0, 0, 0, 180))
    draw.text((x + 8, y + 5), text, fill=(255, 255, 255), font=font)


def save_guided_image(image: Image.Image, crop, out_path: Path, label: str):
    rgba = image.convert("RGBA")
    overlay = Image.new("RGBA", rgba.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    if crop["y"] > 0:
        draw.rectangle((0, 0, rgba.width, crop["y"]), fill=(0, 0, 0, 108))
    if crop["bottom"] < rgba.height:
        draw.rectangle((0, crop["bottom"], rgba.width, rgba.height), fill=(0, 0, 0, 108))
    draw.rectangle(
        (crop["x"], crop["y"], crop["x"] + crop["width"] - 1, crop["bottom"] - 1),
        outline=(255, 72, 48, 255),
        width=5,
    )
    add_label(draw, (18, 18), label)
    out = Image.alpha_composite(rgba, overlay).convert("RGB")
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out.save(out_path, quality=92)


def thumb_with_label(path: Path, label: str, width: int = 640):
    image = Image.open(path).convert("RGB")
    ratio = width / image.width
    height = int(round(image.height * ratio))
    image = image.resize((width, height), Image.Resampling.LANCZOS)
    canvas = Image.new("RGB", (width, height + 32), (18, 18, 18))
    canvas.paste(image, (0, 32))
    draw = ImageDraw.Draw(canvas)
    add_label(draw, (6, 3), label)
    return canvas


def make_contact_sheet(items, out_path: Path):
    thumbs = [thumb_with_label(path, label) for label, path in items if path.exists()]
    if not thumbs:
        return None
    cols = 2
    rows = math.ceil(len(thumbs) / cols)
    cell_w = max(t.width for t in thumbs)
    cell_h = max(t.height for t in thumbs)
    sheet = Image.new("RGB", (cols * cell_w, rows * cell_h), (30, 30, 30))
    for i, thumb in enumerate(thumbs):
        x = (i % cols) * cell_w
        y = (i // cols) * cell_h
        sheet.paste(thumb, (x, y))
    out_path.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(out_path, quality=92)
    return out_path


def route_focus_rows(rows, cards, tmp_rows, mask_rows):
    focused = []
    route_patterns = [
        "root_battle/root_top",
        "root_battle/BottomCenter",
        "root_battle/Right",
        "root_battle/right",
        "TopCenter",
        "HeroListContainer",
    ]
    for row in rows:
        path = row.get("path", "")
        if any(p in path for p in route_patterns):
            focused.append(("route", row))
    for row in cards:
        focused.append(("hero_card", row))
    for row in tmp_rows:
        path = row.get("path", "")
        if "root_top" in path or "HeroListContainer" in path or "BottomCenter" in path:
            focused.append(("tmp_text", row))
    for row in mask_rows:
        path = row.get("path", "")
        if "root_top" in path or "HeroListContainer" in path or "BottomCenter" in path:
            focused.append(("mask", row))
    out = []
    for kind, row in focused[:240]:
        out.append(
            {
                "kind": kind,
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
                "text": row.get("text", ""),
                "payloadHeroDid": row.get("payloadHeroDid", ""),
                "payloadLocalStatus": row.get("payloadLocalStatus", ""),
                "hasMaskComponent": row.get("hasMaskComponent", ""),
                "evidence": row.get("evidence", ""),
            }
        )
    return out


def main():
    root = Path(__file__).resolve().parents[2]
    reports = root / "reports" / "battle"
    work = root / "work" / "battle67_aspect_correct_crop"
    work.mkdir(parents=True, exist_ok=True)

    b66 = read_json(reports / "BATTLE_66_ASPECT_CORRECT_VIEWRECT_ROUTE_HUD_CARD_ACTOR_LAYOUT_VALIDATION_NO_PATCH_RESULT.json", {})
    ref = read_json(root / "reports" / "video_reference" / "REFERENCE_MP4_VISUAL_CHECKPOINT_MATRIX_20260626_060212.json", {})
    reference_aspect = float(b66.get("referenceAspect") or (ref.get("source") or {}).get("videoAspect") or 2.2456)

    capture_dir = root / "girlswar_battle_unity" / "Assets" / "RestoreCaptures" / "battle_actor"
    captures = [
        ("battle57_full", capture_dir / "Battle57RuntimeRehydratedAssetBundleActorsCandidate_1920x1080.png"),
        ("battle57_without_actors", capture_dir / "Battle57RuntimeRehydratedAssetBundleActorsCandidate_without_actors_1920x1080.png"),
        ("battle57_actor_diff", capture_dir / "Battle57RuntimeRehydratedAssetBundleActorsCandidate_actor_diff_1920x1080.png"),
        ("battle51_bridge", capture_dir / "Battle51LuaBridgeRaycasterRegistrationCandidate_1920x1080.png"),
    ]

    image_rows = []
    output_images = {}
    crop_ref = None
    for label, path in captures:
        if not path.exists():
            image_rows.append({"label": label, "sourcePath": str(path), "exists": False})
            continue
        img = Image.open(path)
        crop = content_rect(img.width, img.height, reference_aspect)
        if crop_ref is None:
            crop_ref = crop
        crop_box = (crop["x"], crop["y"], crop["x"] + crop["width"], crop["bottom"])
        cropped = img.crop(crop_box).convert("RGB")
        crop_path = work / f"{label}_reference_aspect_content_rect_{crop['width']}x{crop['height']}.png"
        guide_path = work / f"{label}_reference_aspect_guide_{img.width}x{img.height}.jpg"
        cropped.save(crop_path)
        save_guided_image(img, crop, guide_path, f"{label}: red box = ~2.24:1 content rect")
        full_metrics = signal_metrics(img)
        crop_metrics = signal_metrics(cropped)
        output_images[f"{label}Crop"] = str(crop_path)
        output_images[f"{label}Guide"] = str(guide_path)
        image_rows.append(
            {
                "label": label,
                "sourcePath": str(path),
                "exists": True,
                "width": img.width,
                "height": img.height,
                "aspect": round(img.width / img.height, 6),
                "referenceAspect": reference_aspect,
                "cropX": crop["x"],
                "cropYExact": crop["yExact"],
                "cropY": crop["y"],
                "cropWidth": crop["width"],
                "cropHeight": crop["height"],
                "cropBottom": crop["bottom"],
                "extraVerticalPixelsExact": crop["extraVerticalPixelsExact"],
                "extraVerticalPixelsInt": crop["extraVerticalPixelsInt"],
                "cropPath": str(crop_path),
                "guidePath": str(guide_path),
                "fullNonDarkPixels": full_metrics["nonDarkPixels"],
                "fullNonDarkRatio": full_metrics["nonDarkRatio"],
                "fullNonDarkBBox": full_metrics["nonDarkBBox"],
                "cropNonDarkPixels": crop_metrics["nonDarkPixels"],
                "cropNonDarkRatio": crop_metrics["nonDarkRatio"],
                "cropNonDarkBBox": crop_metrics["nonDarkBBox"],
                "mutation": "analysis_outputs_only_no_scene_or_asset_patch",
            }
        )

    reference_frames = root / "work" / "reference_video" / "frames_5s"
    contact_items = [
        ("reference sample_004 normal battle", reference_frames / "sample_004.jpg"),
        ("reference sample_007 normal battle", reference_frames / "sample_007.jpg"),
        ("reference sample_012 normal battle", reference_frames / "sample_012.jpg"),
    ]
    if "battle57_fullGuide" in output_images:
        contact_items.append(("candidate B57 full with content rect", Path(output_images["battle57_fullGuide"])))
    if "battle57_fullCrop" in output_images:
        contact_items.append(("candidate B57 content rect crop", Path(output_images["battle57_fullCrop"])))
    if "battle57_actor_diffCrop" in output_images:
        contact_items.append(("candidate B57 actor diff crop", Path(output_images["battle57_actor_diffCrop"])))
    contact_sheet = make_contact_sheet(contact_items, work / f"{PREFIX}_reference_vs_candidate_contact_sheet.jpg")
    if contact_sheet:
        output_images["contactSheet"] = str(contact_sheet)

    visibility = read_csv(
        root
        / "girlswar_battle_unity"
        / "Assets"
        / "RestoreData"
        / "battle"
        / "BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_VISIBILITY.csv"
    )
    actor_rows = []
    if crop_ref:
        for row in visibility:
            rect = parse_pixel_rect(row.get("actorPixelRect", ""))
            if not rect:
                continue
            cx, cy = rect_center(rect)
            clipped = clip_rect_to_content(rect, crop_ref)
            content_cx = cx / crop_ref["width"]
            content_cy = (cy - crop_ref["y"]) / crop_ref["height"]
            side = row.get("side", "")
            actor_rows.append(
                {
                    "side": side,
                    "wave": row.get("wave", ""),
                    "slot": row.get("slot", ""),
                    "heroDid": row.get("heroDid", ""),
                    "modelId": row.get("modelId", ""),
                    "bundle": row.get("bundle", ""),
                    "capturePixelSignal": row.get("capturePixelSignal", ""),
                    "actorPixelRectFull": row.get("actorPixelRect", ""),
                    "fullCenterNormX": round(cx / crop_ref["width"], 6),
                    "fullCenterNormY": round(cy / 1080.0, 6),
                    "contentCenterNormX": round(content_cx, 6),
                    "contentCenterNormY": round(content_cy, 6),
                    "intersectsContentRect": clipped is not None,
                    "centerInsideReferenceBand": in_band(content_cx, content_cy, side),
                    "referenceBand": "our x=0.18-0.45 y=0.25-0.86; enemy x=0.55-0.82 y=0.25-0.82",
                    "interpretation": "source-backed local subset actor; not full formation proof",
                }
            )

    routes = read_csv(reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_ROUTES.csv")
    cards = read_csv(reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_HERO_CARDS.csv")
    tmp_rows = read_csv(reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_TMP_TEXT.csv")
    mask_rows = read_csv(reports / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_MASKS.csv")
    focused_rows = route_focus_rows(routes, cards, tmp_rows, mask_rows)

    decision_rows = [
        {
            "decision": "aspect_correct_crop_generated",
            "recommended": True,
            "why": "A visual crop/guide now exists for the 2.24:1 reference content rect without mutating the Unity scene.",
            "patchAllowedNow": False,
            "nextAction": "use crop artifacts to separate visible aspect error from payload/route/runtime gaps",
        },
        {
            "decision": "do_not_claim_real_aspect_capture_yet",
            "recommended": True,
            "why": "Cropping an existing 16:9 capture is analysis evidence, not a true reference-aspect GameView/camera capture.",
            "patchAllowedNow": False,
            "nextAction": "produce a source-backed reference-aspect render/capture before coordinate patching",
        },
        {
            "decision": "full_actor_card_payload_still_required",
            "recommended": True,
            "why": "BATTLE57 actor visibility is only a local subset; bottom card payload still lacks the complete source-backed five-card/1036 state.",
            "patchAllowedNow": False,
            "nextAction": "continue exact 1036 and unresolved enemy/source payload tracing",
        },
        {
            "decision": "route_tmp_mask_patch_deferred",
            "recommended": True,
            "why": "Focused route/TMP/mask rows are exported, but field changes need source-backed runtime or exact prefab evidence.",
            "patchAllowedNow": False,
            "nextAction": "derive exact route active/sibling/mask/TMP deltas only after aspect-correct capture/source evidence",
        },
    ]

    image_csv = reports / f"{PREFIX}_IMAGE_CROP_AND_SIGNAL_MATRIX.csv"
    actor_csv = reports / f"{PREFIX}_ACTOR_CONTENT_RECT_POSITION_MATRIX.csv"
    focused_csv = reports / f"{PREFIX}_FOCUSED_ROUTE_CARD_TMP_MASK_ROWS.csv"
    decision_csv = reports / f"{PREFIX}_DECISION_MATRIX.csv"
    json_path = reports / f"{PREFIX}_RESULT.json"
    md_path = reports / f"{PREFIX}_RESULT.md"

    write_csv(
        image_csv,
        image_rows,
        [
            "label",
            "sourcePath",
            "exists",
            "width",
            "height",
            "aspect",
            "referenceAspect",
            "cropX",
            "cropYExact",
            "cropY",
            "cropWidth",
            "cropHeight",
            "cropBottom",
            "extraVerticalPixelsExact",
            "extraVerticalPixelsInt",
            "cropPath",
            "guidePath",
            "fullNonDarkPixels",
            "fullNonDarkRatio",
            "fullNonDarkBBox",
            "cropNonDarkPixels",
            "cropNonDarkRatio",
            "cropNonDarkBBox",
            "mutation",
        ],
    )
    write_csv(
        actor_csv,
        actor_rows,
        [
            "side",
            "wave",
            "slot",
            "heroDid",
            "modelId",
            "bundle",
            "capturePixelSignal",
            "actorPixelRectFull",
            "fullCenterNormX",
            "fullCenterNormY",
            "contentCenterNormX",
            "contentCenterNormY",
            "intersectsContentRect",
            "centerInsideReferenceBand",
            "referenceBand",
            "interpretation",
        ],
    )
    write_csv(
        focused_csv,
        focused_rows,
        [
            "kind",
            "path",
            "activeSelf",
            "activeInHierarchy",
            "siblingIndex",
            "siblingCount",
            "anchoredPosition",
            "localPosition",
            "localScale",
            "sizeDelta",
            "anchorMin",
            "anchorMax",
            "warning",
            "text",
            "payloadHeroDid",
            "payloadLocalStatus",
            "hasMaskComponent",
            "evidence",
        ],
    )
    write_csv(decision_csv, decision_rows, ["decision", "recommended", "why", "patchAllowedNow", "nextAction"])

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
        "contentRect": crop_ref,
        "analysisOnlyCropGenerated": True,
        "trueReferenceAspectRuntimeCaptureGenerated": False,
        "imageRows": len(image_rows),
        "actorRows": len(actor_rows),
        "actorCentersInsideReferenceBand": sum(1 for r in actor_rows if str(r.get("centerInsideReferenceBand")) == "True"),
        "focusedRouteCardTmpMaskRows": len(focused_rows),
        "outputs": {
            "imageCropAndSignalMatrix": str(image_csv),
            "actorContentRectPositionMatrix": str(actor_csv),
            "focusedRouteCardTmpMaskRows": str(focused_csv),
            "decisionMatrix": str(decision_csv),
            "json": str(json_path),
            "markdown": str(md_path),
            **output_images,
        },
        "guardrails": {
            "noSceneSave": True,
            "noPackageImport": True,
            "noManifestEdit": True,
            "noRuntimeInstrumentation": True,
            "noXluaOrHandlerPatch": True,
            "noFakeHudCardIconTextActorEffect": True,
            "noScreenshotOrAtlasPaste": True,
            "noCoordinateOnlySuccess": True,
        },
        "commandPolicy": {
            **command_policy,
            "policyOk": command_policy["rootCmdCount"] == 1 and command_policy["restoreToolsDirectCmdCount"] == 0,
        },
        "nextBlocker": "TRUE_REFERENCE_ASPECT_CAPTURE_OR_SOURCE_BACKED_VIEWRECT_REQUIRED_BEFORE_LAYOUT_PATCH",
    }
    json_path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        f"# {PREFIX} Result",
        "",
        "## Verdict",
        "- `restoredClaim=false`, `playableClaim=false`.",
        "- No scene/package/manifest/xLua/handler/HUD/card/actor/effect patch was applied.",
        "- Analysis-only crop/guide images were generated from existing captures; this is not a true runtime reference-aspect capture.",
        f"- Reference aspect: `{reference_aspect}`.",
    ]
    if crop_ref:
        md.append(
            f"- Content rect used for 1920x1080 captures: `x={crop_ref['x']}, y={crop_ref['y']} "
            f"(exact {crop_ref['yExact']}), w={crop_ref['width']}, h={crop_ref['height']}`."
        )
    md += [
        "",
        "## Generated Visual Evidence",
        f"- Contact sheet: `{output_images.get('contactSheet', '')}`",
        f"- BATTLE57 guide: `{output_images.get('battle57_fullGuide', '')}`",
        f"- BATTLE57 content crop: `{output_images.get('battle57_fullCrop', '')}`",
        f"- BATTLE57 actor diff crop: `{output_images.get('battle57_actor_diffCrop', '')}`",
        "",
        "## Actor Position Finding",
        f"- Source-backed local subset actor rows analyzed: `{len(actor_rows)}`.",
        f"- Actor centers inside broad reference side bands after content-rect normalization: `{result['actorCentersInsideReferenceBand']}/{len(actor_rows)}`.",
        "- This remains local-subset proof only; it does not close the full actor/card payload blocker.",
        "",
        "## Route/Card/TMP/Mask Evidence",
        f"- Focused source rows exported: `{len(focused_rows)}`.",
        "- These rows preserve active state, sibling order, anchors, scale, payload status, TMP text, and mask evidence for later source-backed patching.",
        "- No field was changed from these rows in this task.",
        "",
        "## Next Blocker",
        "- `TRUE_REFERENCE_ASPECT_CAPTURE_OR_SOURCE_BACKED_VIEWRECT_REQUIRED_BEFORE_LAYOUT_PATCH`.",
        "- Cropped 16:9 screenshots are useful diagnostic evidence, but final coordinate/layout changes need a true reference-aspect capture or source-backed view rect/canvas proof.",
        "",
        "## Outputs",
        f"- `{image_csv}`",
        f"- `{actor_csv}`",
        f"- `{focused_csv}`",
        f"- `{decision_csv}`",
        f"- `{json_path}`",
        "",
        "## Command Policy",
        f"- root `.cmd` count: `{command_policy['rootCmdCount']}`",
        f"- `_restore_tools` direct `.cmd` count: `{command_policy['restoreToolsDirectCmdCount']}`",
        f"- policy ok: `{result['commandPolicy']['policyOk']}`",
    ]
    md_path.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps({"result": str(json_path), "markdown": str(md_path), "contactSheet": output_images.get("contactSheet")}, ensure_ascii=False))


if __name__ == "__main__":
    main()
