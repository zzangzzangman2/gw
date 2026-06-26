#!/usr/bin/env python3
from __future__ import annotations

import csv
import json
import math
from datetime import datetime
from pathlib import Path
from typing import Any

from PIL import Image, ImageChops, ImageDraw, ImageStat


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = ROOT / "girlswar_maininterface_unity"
REPORT_DIR = ROOT / "reports" / "maininterface"
REFERENCE = Path(r"C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png")
BASELINE_UI128 = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui128_oldroot_runtime_activity_text_tmp_click_candidate_1680x720.png"
CAPTURE_UI135 = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui135_hero1005_homepara_backfront_candidate_1680x720.png"
UNITY_JSON = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_135_hero1005_homepara_backfront_candidate_summary.json"
CLICK_JSON = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_135_click_validation_summary.json"
CLICK_CSV = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_135_click_validation.csv"
TRANSFORM_CSV = REPORT_DIR / "MAININTERFACE_135_hero_transform_before_after.csv"
LAYER_CSV = REPORT_DIR / "MAININTERFACE_135_back_front_layer_evidence_probe.csv"
UI131_JSON = REPORT_DIR / "MAININTERFACE_131_REFERENCE_DIFF_ROOT_CAUSE_AND_SOURCE_BACKED_PATCH_MATRIX_NO_FAKE_PATCH_RESULT.json"

PREFIX = "MAININTERFACE_135_APPLY_SOURCE_BACKED_HERO1005_HOMEPARA_AND_BACK_FRONT_LAYER_CANDIDATE_CAPTURE_NO_DOCK_PATCH"
RESULT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
RESULT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
REGION_CSV = REPORT_DIR / "MAININTERFACE_135_reference_diff_regions.csv"
CONTACT_PNG = REPORT_DIR / "MAININTERFACE_135_REFERENCE_DIFF_CONTACT.png"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def corr_rgb(a: Image.Image, b: Image.Image) -> float:
    pa = list(a.convert("RGB").getdata())
    pb = list(b.convert("RGB").getdata())
    n = len(pa) * 3
    if n == 0:
        return 0.0
    avg_a = sum(sum(px) for px in pa) / n
    avg_b = sum(sum(px) for px in pb) / n
    num = den_a = den_b = 0.0
    for left, right in zip(pa, pb):
        for ca, cb in zip(left, right):
            va = ca - avg_a
            vb = cb - avg_b
            num += va * vb
            den_a += va * va
            den_b += vb * vb
    if den_a <= 0 or den_b <= 0:
        return 0.0
    return num / math.sqrt(den_a * den_b)


def metric_for(a: Image.Image, b: Image.Image, box: list[int]) -> dict[str, Any]:
    left = a.crop(tuple(box)).convert("RGB")
    right = b.crop(tuple(box)).convert("RGB")
    diff = ImageChops.difference(left, right)
    stat = ImageStat.Stat(diff)
    mean_abs = sum(stat.mean) / (3 * 255.0)
    rms = math.sqrt(sum(v * v for v in stat.rms) / 3.0) / 255.0
    total = left.size[0] * left.size[1]
    changed30 = sum(1 for px in diff.getdata() if max(px) >= 30) / float(total) if total else 0.0
    return {
        "box": box,
        "meanAbsDiff": round(mean_abs, 6),
        "rmsDiff": round(rms, 6),
        "changedPixelRatio30": round(changed30, 6),
        "pixelCorrelation": round(corr_rgb(left, right), 6),
    }


def load_images() -> tuple[Image.Image, Image.Image, Image.Image]:
    ref = Image.open(REFERENCE).convert("RGB")
    base = Image.open(BASELINE_UI128).convert("RGB")
    cand = Image.open(CAPTURE_UI135).convert("RGB")
    if ref.size != cand.size:
        ref = ref.resize(cand.size, Image.Resampling.LANCZOS)
    if base.size != cand.size:
        base = base.resize(cand.size, Image.Resampling.LANCZOS)
    return ref, base, cand


def command_policy() -> dict[str, Any]:
    root_cmd = len(list(ROOT.glob("*.cmd")))
    direct = len(list((ROOT / "_restore_tools").glob("*.cmd")))
    return {
        "rootCmdCount": root_cmd,
        "restoreToolsDirectCmdCount": direct,
        "policyOk": root_cmd == 1 and direct == 0,
    }


def write_region_csv(rows: list[dict[str, Any]]) -> None:
    with REGION_CSV.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "comparison",
                "region",
                "box",
                "meanAbsDiff",
                "rmsDiff",
                "changedPixelRatio30",
                "pixelCorrelation",
            ],
        )
        writer.writeheader()
        for row in rows:
            writer.writerow(
                {
                    **row,
                    "box": json.dumps(row["box"], separators=(",", ":")),
                }
            )


def make_contact(ref: Image.Image, base: Image.Image, cand: Image.Image, regions: dict[str, dict[str, Any]]) -> None:
    diff_ref = ImageChops.difference(ref, cand)
    diff_ref = ImageChops.multiply(diff_ref, Image.new("RGB", diff_ref.size, (3, 3, 3)))
    diff_base = ImageChops.difference(base, cand)
    diff_base = ImageChops.multiply(diff_base, Image.new("RGB", diff_base.size, (4, 4, 4)))

    thumb_w = 420
    thumb_h = int(ref.height * thumb_w / ref.width)
    panels = [
        ("reference", ref),
        ("ui128 baseline", base),
        ("ui135 candidate", cand),
        ("ref vs ui135 diff", diff_ref),
    ]
    sheet = Image.new("RGB", (thumb_w * 4, thumb_h + 330), (24, 24, 24))
    for idx, (title, image) in enumerate(panels):
        panel = image.resize((thumb_w, thumb_h), Image.Resampling.LANCZOS)
        draw = ImageDraw.Draw(panel)
        draw.rectangle((0, 0, thumb_w, 24), fill=(0, 0, 0))
        draw.text((8, 6), title, fill=(255, 255, 255))
        sheet.paste(panel, (idx * thumb_w, 0))

    crop_regions = ["center_hero_background", "chat_bubble", "right_activity_stack", "bottom_nav"]
    crop_w = 420
    crop_h = 150
    y = thumb_h + 10
    for idx, region in enumerate(crop_regions):
        box = regions[region]["box"]
        block = Image.new("RGB", (crop_w, 320), (18, 18, 18))
        draw = ImageDraw.Draw(block)
        draw.text((6, 4), region, fill=(255, 255, 255))
        block.paste(ref.crop(tuple(box)).resize((crop_w, crop_h), Image.Resampling.LANCZOS), (0, 24))
        block.paste(cand.crop(tuple(box)).resize((crop_w, crop_h), Image.Resampling.LANCZOS), (0, 174))
        draw.text((6, 156), "reference above / ui135 below", fill=(230, 230, 230))
        sheet.paste(block, (idx * crop_w, y))

    # Baseline-to-candidate difference is tucked into the lower-right strip for quick regression spotting.
    strip = diff_base.resize((thumb_w, thumb_h), Image.Resampling.LANCZOS)
    draw = ImageDraw.Draw(strip)
    draw.rectangle((0, 0, thumb_w, 24), fill=(0, 0, 0))
    draw.text((8, 6), "ui128 vs ui135 diff", fill=(255, 255, 255))
    # Keep this in a separate file-wide panel replacement if height permits.
    sheet.paste(strip.crop((0, 0, thumb_w, min(80, thumb_h))), (thumb_w * 3, thumb_h + 245))
    CONTACT_PNG.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT_PNG)


def summarize_transforms(rows: list[dict[str, str]]) -> dict[str, Any]:
    main_after = [r for r in rows if r.get("phase") == "after_homepara_apply" and r.get("name") == "Painting_1005"]
    existing = [r for r in rows if r.get("phase") == "existing_candidate_before_rebuild" and "Painting_1005" in r.get("name", "")]
    return {
        "rows": len(rows),
        "existingCandidatePaintingRows": len(existing),
        "afterHomeParaRows": len(main_after),
        "homeParaAppliedAsNoop": bool(
            main_after
            and main_after[0].get("localPosition") == "0,0,0"
            and main_after[0].get("localScale") == "1,1,1"
        ),
        "afterHomeParaRow": main_after[0] if main_after else {},
    }


def summarize_layers(rows: list[dict[str, str]]) -> dict[str, Any]:
    return {
        "rows": len(rows),
        "mountedLayers": [r.get("baseName", "") for r in rows if r.get("mounted") == "True"],
        "missingLayers": [r.get("baseName", "") for r in rows if r.get("sourceExists") == "False"],
        "backMounted": any(r.get("baseName") == "Painting_1005_back" and r.get("mounted") == "True" for r in rows),
        "frontMounted": any(r.get("baseName") == "Painting_1005_front" and r.get("mounted") == "True" for r in rows),
    }


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    unity = read_json(UNITY_JSON)
    click = read_json(CLICK_JSON) if CLICK_JSON.exists() else {}
    transforms = read_csv(TRANSFORM_CSV)
    layers = read_csv(LAYER_CSV)
    ui131 = read_json(UI131_JSON)
    ref, base, cand = load_images()

    region_boxes = {k: v["box"] for k, v in ui131["regionMetrics"].items()}
    keep = ["full", "center_hero_background", "chat_bubble", "right_activity_stack", "bottom_nav", "click_blocker_btn_discord"]
    rows: list[dict[str, Any]] = []
    metrics: dict[str, dict[str, Any]] = {}
    for comparison, left, right in (
        ("reference_vs_ui128", ref, base),
        ("reference_vs_ui135", ref, cand),
        ("ui128_vs_ui135", base, cand),
    ):
        for name in keep:
            metric = metric_for(left, right, region_boxes[name])
            rows.append({"comparison": comparison, "region": name, **metric})
            metrics[f"{comparison}:{name}"] = metric
    write_region_csv(rows)
    make_contact(ref, base, cand, ui131["regionMetrics"])

    transform_summary = summarize_transforms(transforms)
    layer_summary = summarize_layers(layers)
    policy = command_policy()
    result = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "task": PREFIX,
        "restoredClaim": False,
        "sceneSaved": unity.get("sceneSaved", False),
        "scenePatchApplied": True,
        "candidatePatchApplied": True,
        "productionPatchApplied": False,
        "patchDecision": unity.get("patchDecision", ""),
        "unityStatus": unity.get("status", ""),
        "capture": str(CAPTURE_UI135),
        "baselineCapture": str(BASELINE_UI128),
        "reference": str(REFERENCE),
        "contact": str(CONTACT_PNG),
        "regionDiffCsv": str(REGION_CSV),
        "heroTransformCsv": str(TRANSFORM_CSV),
        "backFrontLayerCsv": str(LAYER_CSV),
        "clickSummary": click,
        "transformSummary": transform_summary,
        "layerSummary": layer_summary,
        "backLayerVisualVerdict": {
            "candidateMounted": layer_summary["backMounted"],
            "referenceCorrelationDeltaFull": round(
                metrics["reference_vs_ui135:full"]["pixelCorrelation"]
                - metrics["reference_vs_ui128:full"]["pixelCorrelation"],
                6,
            ),
            "referenceCorrelationDeltaHero": round(
                metrics["reference_vs_ui135:center_hero_background"]["pixelCorrelation"]
                - metrics["reference_vs_ui128:center_hero_background"]["pixelCorrelation"],
                6,
            ),
            "decision": "do_not_promote_current_back_layer_mount_without_original_prefab_transform_order",
            "reason": "The source-backed back layer exists and renders, but the current zero-offset SkeletonGraphic probe substantially worsens full and hero-region reference metrics, indicating overpaint/order/transform mismatch.",
        },
        "metrics": metrics,
        "guardrail": {
            "bottomDockTouched": False,
            "activitySlotsTouched": False,
            "btnDiscordTouched": False,
            "uiBgRaycastChanged": False,
            "routeWorldNodesTouched": False,
            "wholeAtlasOrScreenshotPaste": False,
        },
        "commandPolicy": policy,
        "changedFiles": [
            str(ROOT / "girlswar_maininterface_unity" / "Assets" / "Editor" / "MainInterface135Hero1005HomeParaBackFrontCandidate.cs"),
            str(ROOT / "girlswar_maininterface_unity" / "Assets" / "Scenes" / "MainInterface_UI135_Hero1005HomeParaBackFrontCandidate.unity"),
            str(CAPTURE_UI135),
            str(UNITY_JSON),
            str(CLICK_JSON),
            str(CLICK_CSV),
            str(TRANSFORM_CSV),
            str(LAYER_CSV),
            str(REGION_CSV),
            str(CONTACT_PNG),
            str(RESULT_JSON),
            str(RESULT_MD),
        ],
        "nextBlocker": [
            "Reference remains mismatched; activity/account snapshot and UI_Dock open-stack candidate are still separate blockers.",
            "Painting_1005_back is source-backed and mounted in UI135 candidate, but current zero-offset mount overpaints the scene; original prefab child transform/order evidence is required before any promotion.",
            "Painting_1005_front source triplet is absent, so no front layer was created.",
        ],
    }
    RESULT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    full135 = metrics["reference_vs_ui135:full"]
    full128 = metrics["reference_vs_ui128:full"]
    hero135 = metrics["reference_vs_ui135:center_hero_background"]
    hero128 = metrics["reference_vs_ui128:center_hero_background"]
    md = [
        "# MAININTERFACE 135 Apply Source-Backed Hero1005 HomePara And Back/Front Layer Candidate Capture Result",
        "",
        f"Generated: {result['generatedAt']}",
        "",
        "## Verdict",
        "",
        "- restoredClaim: `false`",
        "- sceneSaved: `" + str(result["sceneSaved"]) + "`",
        "- candidatePatchApplied: `true`",
        "- productionPatchApplied: `false`",
        "- patchDecision: `" + result["patchDecision"] + "`",
        "",
        "UI135 applies only the decoded UIUtil Hero1005 lane. It does not touch bottom nav/UI_Dock, activity stack, chat/account/currency text, btn_discord, UI_bg raycast/interactable, or route/world nodes.",
        "",
        "## Hero HomePara",
        "",
        "- Existing UI128 candidate already had the Hero1005 child at local position `0,0,0` and scale `1,1,1`.",
        "- UI135 rebuilt the old-root candidate with actual child name `Painting_1005` and applied decoded `homePara=[1,0,0]` to that child, not the `UI_heroSpine` parent.",
        "- Result: no coordinate adjustment was introduced; this is a source-backed semantic no-op for Hero1005.",
        "",
        "## Back/Front Probe",
        "",
        "- `Painting_1005_back`: source atlas/skel/png exists, animation `A` exists, mounted as real `SkeletonGraphic` behind main.",
        "- `Painting_1005`: source atlas/skel/png exists, animation `A` exists, mounted as real `SkeletonGraphic` main layer.",
        "- `Painting_1005_front`: complete source triplet not found, so no front layer was created.",
        "- No whole atlas Image, flat sprite substitute, fake spine, or screenshot paste was used.",
        "- Visual verdict: the back layer probe renders, but it overpaints/worsens the reference metrics; do not promote this mount without original prefab transform/order evidence.",
        "",
        "## Diff",
        "",
        "| comparison | full corr | full meanAbsDiff | hero corr | hero meanAbsDiff |",
        "| --- | ---: | ---: | ---: | ---: |",
        f"| UI128 vs reference | {full128['pixelCorrelation']:.6f} | {full128['meanAbsDiff']:.6f} | {hero128['pixelCorrelation']:.6f} | {hero128['meanAbsDiff']:.6f} |",
        f"| UI135 vs reference | {full135['pixelCorrelation']:.6f} | {full135['meanAbsDiff']:.6f} | {hero135['pixelCorrelation']:.6f} | {hero135['meanAbsDiff']:.6f} |",
        "",
        "## Click Validation",
        "",
        f"- total/active/clickable/blocked: `{click.get('totalButtons')} / {click.get('activeButtons')} / {click.get('raycastClickableButtons')} / {click.get('raycastBlockedButtons')}`",
        f"- click CSV: `{CLICK_CSV}`",
        f"- click JSON: `{CLICK_JSON}`",
        "",
        "## Outputs",
        "",
        f"- capture: `{CAPTURE_UI135}`",
        f"- contact PNG: `{CONTACT_PNG}`",
        f"- region diff CSV: `{REGION_CSV}`",
        f"- hero transform CSV: `{TRANSFORM_CSV}`",
        f"- back/front layer CSV: `{LAYER_CSV}`",
        f"- JSON: `{RESULT_JSON}`",
        "",
        "## Command Policy",
        "",
        f"- root `.cmd` count: `{policy['rootCmdCount']}`",
        f"- `_restore_tools` direct `.cmd` count: `{policy['restoreToolsDirectCmdCount']}`",
        f"- policyOk: `{policy['policyOk']}`",
        "",
        "## Next Blocker",
        "",
        "- UI_Dock/bottom nav open-stack remains separate and was not patched here.",
        "- Activity/account runtime snapshot is still required before activity/text/icon/spine changes.",
        "- Back layer is now a source-backed candidate, but final restored claim remains false until full reference match and click validation converge.",
    ]
    RESULT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
