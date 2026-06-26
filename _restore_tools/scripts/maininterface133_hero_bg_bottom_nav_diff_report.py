#!/usr/bin/env python3
from __future__ import annotations

import csv
import json
import math
from collections import Counter
from datetime import datetime
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageStat


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = ROOT / "reports" / "maininterface"
PROJECT = ROOT / "girlswar_maininterface_unity"
REFERENCE = Path(r"C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png")
CANDIDATE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui128_oldroot_runtime_activity_text_tmp_click_candidate_1680x720.png"
UI131_JSON = REPORT_DIR / "MAININTERFACE_131_REFERENCE_DIFF_ROOT_CAUSE_AND_SOURCE_BACKED_PATCH_MATRIX_NO_FAKE_PATCH_RESULT.json"
PROBE_JSON = REPORT_DIR / "MAININTERFACE_133_unity_probe_summary.json"
HERO_BG_CSV = REPORT_DIR / "MAININTERFACE_133_hero_bg_probe.csv"
BOTTOM_NAV_CSV = REPORT_DIR / "MAININTERFACE_133_bottom_nav_probe.csv"

PREFIX = "MAININTERFACE_133_HOME_HEROSPINE_BG_BOTTOM_NAV_RUNTIME_LAYOUT_PROBE_NO_COORDINATE_PATCH"
RESULT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
RESULT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
REGION_CSV = REPORT_DIR / "MAININTERFACE_133_reference_diff_regions.csv"
CONTACT_PNG = REPORT_DIR / "MAININTERFACE_133_REFERENCE_DIFF_CONTACT.png"


def read_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv_rows(path: Path) -> list[dict]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def corr_rgb(a: Image.Image, b: Image.Image) -> float:
    pixels_a = list(a.getdata())
    pixels_b = list(b.getdata())
    n = len(pixels_a) * 3
    if n == 0:
        return 0.0
    avg_a = sum(sum(px) for px in pixels_a) / n
    avg_b = sum(sum(px) for px in pixels_b) / n
    num = den_a = den_b = 0.0
    for left, right in zip(pixels_a, pixels_b):
        for ca, cb in zip(left, right):
            va = ca - avg_a
            vb = cb - avg_b
            num += va * vb
            den_a += va * va
            den_b += vb * vb
    if den_a <= 0.0 or den_b <= 0.0:
        return 0.0
    return num / math.sqrt(den_a * den_b)


def metric_for(ref: Image.Image, cand: Image.Image, box: list[int]) -> dict:
    r = ref.crop(tuple(box)).convert("RGB")
    c = cand.crop(tuple(box)).convert("RGB")
    diff = ImageChops.difference(r, c)
    stat = ImageStat.Stat(diff)
    mean_abs = sum(stat.mean) / (3 * 255.0)
    rms = math.sqrt(sum(v * v for v in stat.rms) / 3.0) / 255.0
    total = r.size[0] * r.size[1]
    changed30 = sum(1 for px in diff.getdata() if max(px) >= 30) / float(total) if total else 0.0
    return {
        "box": box,
        "meanAbsDiff": round(mean_abs, 6),
        "rmsDiff": round(rms, 6),
        "changedPixelRatio30": round(changed30, 6),
        "pixelCorrelation": round(corr_rgb(r, c), 6),
    }


def make_contact(ref: Image.Image, cand: Image.Image, regions: dict[str, dict]) -> None:
    ref = ref.convert("RGB")
    cand = cand.convert("RGB")
    diff = ImageChops.difference(ref, cand)
    diff = ImageChops.multiply(diff, Image.new("RGB", diff.size, (3, 3, 3)))

    thumb_w = 560
    thumb_h = int(ref.height * thumb_w / ref.width)
    panels = []
    for title, img in (("reference", ref), ("candidate_ui128", cand), ("amplified_diff", diff)):
        t = img.resize((thumb_w, thumb_h), Image.Resampling.LANCZOS)
        draw = ImageDraw.Draw(t)
        draw.rectangle((0, 0, thumb_w, 22), fill=(0, 0, 0))
        draw.text((8, 5), title, fill=(255, 255, 255))
        panels.append(t)
    sheet = Image.new("RGB", (thumb_w * 3, thumb_h + 260), (28, 28, 28))
    for i, p in enumerate(panels):
        sheet.paste(p, (thumb_w * i, 0))

    crop_w = 420
    y = thumb_h + 10
    crop_regions = ["center_hero_background", "bottom_nav", "right_icon_chat", "click_blocker_btn_discord"]
    x = 0
    for name in crop_regions:
        box = regions[name]["box"]
        crop_ref = ref.crop(tuple(box)).resize((crop_w, 110), Image.Resampling.LANCZOS)
        crop_cand = cand.crop(tuple(box)).resize((crop_w, 110), Image.Resampling.LANCZOS)
        crop_diff = ImageChops.difference(ref.crop(tuple(box)).convert("RGB"), cand.crop(tuple(box)).convert("RGB"))
        crop_diff = ImageChops.multiply(crop_diff, Image.new("RGB", crop_diff.size, (3, 3, 3))).resize((crop_w, 110), Image.Resampling.LANCZOS)
        block = Image.new("RGB", (crop_w, 240), (20, 20, 20))
        d = ImageDraw.Draw(block)
        d.text((6, 4), name, fill=(255, 255, 255))
        block.paste(crop_ref, (0, 22))
        block.paste(crop_cand, (0, 132))
        d.text((6, 112), "candidate below", fill=(230, 230, 230))
        d.text((6, 222), "diff amplified in full panel", fill=(230, 230, 230))
        sheet.paste(block, (x, y))
        x += crop_w
    sheet.save(CONTACT_PNG)


def write_region_csv(metrics: dict[str, dict]) -> None:
    with REGION_CSV.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=["region", "box", "meanAbsDiff", "rmsDiff", "changedPixelRatio30", "pixelCorrelation"],
        )
        writer.writeheader()
        for name, metric in metrics.items():
            writer.writerow(
                {
                    "region": name,
                    "box": json.dumps(metric["box"], separators=(",", ":")),
                    "meanAbsDiff": metric["meanAbsDiff"],
                    "rmsDiff": metric["rmsDiff"],
                    "changedPixelRatio30": metric["changedPixelRatio30"],
                    "pixelCorrelation": metric["pixelCorrelation"],
                }
            )


def command_policy() -> dict:
    root_cmd = len(list(ROOT.glob("*.cmd")))
    restore_direct_cmd = len(list((ROOT / "_restore_tools").glob("*.cmd")))
    return {
        "rootCmdCount": root_cmd,
        "restoreToolsDirectCmdCount": restore_direct_cmd,
        "policyOk": root_cmd == 1 and restore_direct_cmd == 0,
    }


def md_link(path: Path) -> str:
    return str(path)


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    ui131 = read_json(UI131_JSON)
    probe = read_json(PROBE_JSON)
    hero_rows = read_csv_rows(HERO_BG_CSV)
    bottom_rows = read_csv_rows(BOTTOM_NAV_CSV)

    ref = Image.open(REFERENCE)
    cand = Image.open(CANDIDATE)
    if cand.size != ref.size:
        ref = ref.resize(cand.size, Image.Resampling.LANCZOS)

    region_boxes = {name: value["box"] for name, value in ui131["regionMetrics"].items()}
    keep_regions = [
        "full",
        "center_hero_background",
        "bottom_nav",
        "right_icon_chat",
        "click_blocker_ui_bg_touch",
        "click_blocker_btn_discord",
    ]
    metrics = {name: {"region": name, **metric_for(ref, cand, region_boxes[name])} for name in keep_regions}
    write_region_csv(metrics)
    make_contact(ref, cand, ui131["regionMetrics"])

    hero_decisions = Counter(r["source_backed_decision"] for r in hero_rows)
    bottom_decisions = Counter(r["source_backed_decision"] for r in bottom_rows)
    key_hero = [
        {
            "name": r["name"],
            "decision": r["source_backed_decision"],
            "active": r["active_in_hierarchy"],
            "sibling": r["sibling_index"],
            "components": r["component_types"],
            "raycast": r["graphic_raycast_target"],
            "sprite": r["image_sprite"],
            "screenRect": r["screen_rect"],
            "anchoredPosition": r["anchored_position"],
            "sizeDelta": r["size_delta"],
            "localScale": r["local_scale"],
        }
        for r in hero_rows
        if any(token in r["path"] for token in ["UI_bg", "UI_heroSpine", "Restore_Hero1005", "Painting_1005", "UI_touchSpine"])
    ]
    key_bottom = [
        {
            "name": r["name"],
            "path": r["path"],
            "decision": r["source_backed_decision"],
            "active": r["active_in_hierarchy"],
            "button": r["has_button"],
            "interactable": r["button_interactable"],
            "raycast": r["graphic_raycast_target"],
            "sprite": r["image_sprite"],
            "text": r["text_sample"],
            "screenRect": r["screen_rect"],
        }
        for r in bottom_rows
    ]

    result = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "task": "MAININTERFACE_133_HOME_HEROSPINE_BG_BOTTOM_NAV_RUNTIME_LAYOUT_PROBE_NO_COORDINATE_PATCH",
        "restoredClaim": False,
        "scenePatchApplied": False,
        "candidatePatchApplied": False,
        "reference": str(REFERENCE),
        "candidate": str(CANDIDATE),
        "unityProbeSummary": probe,
        "regionMetrics": metrics,
        "contact": str(CONTACT_PNG),
        "heroBgProbeCsv": str(HERO_BG_CSV),
        "bottomNavProbeCsv": str(BOTTOM_NAV_CSV),
        "regionDiffCsv": str(REGION_CSV),
        "heroDecisionCounts": dict(hero_decisions),
        "bottomDecisionCounts": dict(bottom_decisions),
        "keyHeroBgRows": key_hero,
        "keyBottomRows": key_bottom,
        "patchDecision": {
            "decision": "no_scene_patch",
            "reason": (
                "Hero1005/BG1005 have source-backed asset selection and live SkeletonGraphic/BG binding, "
                "but no decoded UIUtil/homePara transform rule or bottom nav Animator/canvas order rule was found. "
                "Coordinate-only layout changes and dynamic activity/bottom text edits remain forbidden."
            ),
        },
        "nextBlocker": [
            "Decode or recover UIUtil.GetPlayerBigSpineAll transform semantics for homePara before moving/scaling Hero1005.",
            "Recover old-root bottom navigation runtime/Animator state or original open-stack layer proof before applying bottom strip/order patches.",
            "Runtime activity/account snapshot remains required before activity slot/icon/text visibility changes.",
        ],
        "changedFiles": [
            str(PROJECT / "Assets" / "Editor" / "MainInterface133HeroBgBottomNavLayoutProbe.cs"),
            str(PROJECT / "Assets" / "Editor" / "MainInterface133HeroBgBottomNavLayoutProbe.cs.meta"),
            str(ROOT / "_restore_tools" / "scripts" / "maininterface133_hero_bg_bottom_nav_diff_report.py"),
            str(PROBE_JSON),
            str(HERO_BG_CSV),
            str(BOTTOM_NAV_CSV),
            str(REGION_CSV),
            str(CONTACT_PNG),
            str(RESULT_JSON),
            str(RESULT_MD),
        ],
        "commandPolicy": command_policy(),
    }

    RESULT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# MAININTERFACE 133 Home HeroSpine BG Bottom Nav Runtime Layout Probe Result",
        "",
        f"Generated: {result['generatedAt']}",
        "",
        "## Verdict",
        "",
        "- restoredClaim: false",
        "- scenePatchApplied: false",
        "- candidatePatchApplied: false",
        "- patchDecision: no_scene_patch",
        "",
        "UI133 did not apply a coordinate/layout patch. The candidate already has the source-backed Hero1005 SkeletonGraphic and BG1005 binding, but the missing evidence is still runtime layout semantics: `UIUtil.GetPlayerBigSpineAll(..., \"homePara\")` transform handling and old-root bottom navigation Animator/canvas/layer state.",
        "",
        "## Region Diff",
        "",
        "| region | corr | meanAbsDiff | changed30 |",
        "| --- | ---: | ---: | ---: |",
    ]
    for name in keep_regions:
        m = metrics[name]
        md.append(f"| {name} | {m['pixelCorrelation']:.6f} | {m['meanAbsDiff']:.6f} | {m['changedPixelRatio30']:.6f} |")

    md += [
        "",
        "## Hero/BG Probe",
        "",
        f"- Probe rows: {probe.get('heroBgRows')}",
        f"- Hero SkeletonGraphic rows: {probe.get('heroSkeletonRows')}",
        f"- UI_bg raycast targets: {probe.get('uiBgRaycastTargets')}",
        f"- UI_touchSpine active rows: {probe.get('uiTouchSpineActiveRows')}",
        "",
        "Key observations:",
        "- `UI_bg` is active, sibling index 0, uses `runtime_UI_bg_noalphabg_PaintingBG_1005`, and remains a raycast target. No source-backed raycast-off evidence was found, so it was not changed.",
        "- `UI_heroSpine` is active at sibling index 1, with `Restore_Hero1005_Painting_1005_UI126` below it as a real `SkeletonGraphic`; the SkeletonGraphic itself has raycast disabled.",
        "- `UI_touchSpine` is active at sibling index 2 and raycast-enabled, matching the known default home branch evidence that activates `UI_touchSpine`.",
        "- `homePara=[1,0,0]` remains source-backed from DTmodelEntity, but its scale/x/y application could not be proven from decoded UIUtil, so no hero transform patch was applied.",
        "",
        "## Bottom Nav Probe",
        "",
        f"- Probe rows: {probe.get('bottomNavRows')}",
        f"- Active rows: {probe.get('activeBottomNavRows')}",
        f"- Active interactable buttons: {probe.get('activeBottomButtons')}",
        "",
        "Key observations:",
        "- The old-root candidate does not expose the new-root `node_bottom/toogles/btnToggle*` stack as an active bottom strip in this candidate scene.",
        "- The lower/right navigation candidates currently visible are old-root buttons such as shop/mail/friends/ranking and left banner/download entries; they are not enough to justify a static bottom-strip layer patch.",
        "- Activity slot, face activity, and dynamic text/icon/spine edits remain blocked by the missing runtime snapshot pipeline from UI130.",
        "",
        "## Outputs",
        "",
        f"- JSON: `{md_link(RESULT_JSON)}`",
        f"- Hero/BG probe CSV: `{md_link(HERO_BG_CSV)}`",
        f"- Bottom nav probe CSV: `{md_link(BOTTOM_NAV_CSV)}`",
        f"- Region diff CSV: `{md_link(REGION_CSV)}`",
        f"- Contact PNG: `{md_link(CONTACT_PNG)}`",
        "",
        "## Changed Files",
        "",
    ]
    for changed in result["changedFiles"]:
        md.append(f"- `{changed}`")
    md += [
        "",
        "## Command Policy",
        "",
        f"- root `.cmd` count: {result['commandPolicy']['rootCmdCount']}",
        f"- `_restore_tools` direct `.cmd` count: {result['commandPolicy']['restoreToolsDirectCmdCount']}",
        f"- policyOk: {str(result['commandPolicy']['policyOk']).lower()}",
        "",
        "## Next Blocker",
        "",
    ]
    for blocker in result["nextBlocker"]:
        md.append(f"- {blocker}")
    RESULT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
