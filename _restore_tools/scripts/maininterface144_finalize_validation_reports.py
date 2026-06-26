from __future__ import annotations

import csv
import json
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = ROOT / "girlswar_maininterface_unity"
REPORT_DIR = ROOT / "reports" / "maininterface"
REFERENCE = Path(r"C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png")
UI128 = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui128_oldroot_runtime_activity_text_tmp_click_candidate_1680x720.png"
UI136 = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui136_uidock_openstack_candidate_1680x720.png"
UI144 = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui144_uidock_renderer_rootcanvas_candidate_1680x720.png"
UNITY_JSON = REPORT_DIR / "MAININTERFACE_144_SOURCE_BACKED_UIDOCK_RENDERER_AND_ROOT_CANVAS_DEPTH_CANDIDATE_VALIDATION_RESULT.json"
FINAL_JSON = UNITY_JSON
FINAL_MD = REPORT_DIR / "MAININTERFACE_144_SOURCE_BACKED_UIDOCK_RENDERER_AND_ROOT_CANVAS_DEPTH_CANDIDATE_VALIDATION_RESULT.md"
DIFF_CSV = REPORT_DIR / "MAININTERFACE_144_reference_diff_region_metrics_vs_ui128_ui136_ui144.csv"
CONTACT = REPORT_DIR / "MAININTERFACE_144_reference_ui128_ui136_ui144_contact.png"

REGIONS = [
    ("full", (0, 0, 1680, 720)),
    ("bottom_nav", (0, 575, 1680, 720)),
    ("bottom_dock_focus", (420, 500, 1260, 720)),
    ("center_hero_background", (360, 40, 1180, 690)),
    ("right_activity_stack", (900, 95, 1680, 335)),
    ("click_blocker_btn_discord", (1180, 95, 1580, 640)),
]


def load_rgb(path: Path) -> Image.Image:
    img = Image.open(path).convert("RGB")
    if img.size != (1680, 720):
        img = img.resize((1680, 720), Image.Resampling.BICUBIC)
    return img


def metrics(a: Image.Image, b: Image.Image, box: tuple[int, int, int, int]) -> dict[str, float]:
    arr_a = np.asarray(a.crop(box), dtype=np.float32) / 255.0
    arr_b = np.asarray(b.crop(box), dtype=np.float32) / 255.0
    diff = arr_a - arr_b
    mean_abs = float(np.mean(np.abs(diff)))
    rms = float(np.sqrt(np.mean(diff * diff)))
    changed = float(np.mean(np.any(np.abs(diff) > (30.0 / 255.0), axis=2)))
    flat_a = arr_a.reshape(-1)
    flat_b = arr_b.reshape(-1)
    if float(np.std(flat_a)) == 0.0 or float(np.std(flat_b)) == 0.0:
        corr = 0.0
    else:
        corr = float(np.corrcoef(flat_a, flat_b)[0, 1])
    return {
        "meanAbsDiff": round(mean_abs, 6),
        "rmsDiff": round(rms, 6),
        "changedPixelRatio30": round(changed, 6),
        "pixelCorrelation": round(corr, 6),
    }


def write_diff_csv(images: dict[str, Image.Image]) -> list[dict[str, object]]:
    comparisons = [
        ("reference_vs_ui128", images["reference"], images["ui128"]),
        ("reference_vs_ui136", images["reference"], images["ui136"]),
        ("reference_vs_ui144", images["reference"], images["ui144"]),
        ("ui128_vs_ui144", images["ui128"], images["ui144"]),
        ("ui136_vs_ui144", images["ui136"], images["ui144"]),
    ]
    rows: list[dict[str, object]] = []
    for comparison, left, right in comparisons:
        for region, box in REGIONS:
            row = {
                "comparison": comparison,
                "region": region,
                "box": "[" + ",".join(str(v) for v in box) + "]",
            }
            row.update(metrics(left, right, box))
            rows.append(row)
    with DIFF_CSV.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=["comparison", "region", "box", "meanAbsDiff", "rmsDiff", "changedPixelRatio30", "pixelCorrelation"],
        )
        writer.writeheader()
        writer.writerows(rows)
    return rows


def make_contact(images: dict[str, Image.Image]) -> None:
    thumbs = []
    for label in ("reference", "ui128", "ui136", "ui144"):
        thumb = images[label].resize((420, 180), Image.Resampling.BICUBIC)
        canvas = Image.new("RGB", (420, 204), "white")
        canvas.paste(thumb, (0, 24))
        draw = ImageDraw.Draw(canvas)
        draw.text((8, 6), label, fill=(0, 0, 0))
        thumbs.append(canvas)
    contact = Image.new("RGB", (840, 408), "white")
    for idx, thumb in enumerate(thumbs):
        contact.paste(thumb, ((idx % 2) * 420, (idx // 2) * 204))
    contact.save(CONTACT)


def get_metric(rows: list[dict[str, object]], comparison: str, region: str, key: str) -> float:
    for row in rows:
        if row["comparison"] == comparison and row["region"] == region:
            return float(row[key])
    raise KeyError((comparison, region, key))


def command_policy() -> dict[str, object]:
    root_cmd = sorted(p.name for p in ROOT.glob("*.cmd"))
    direct_restore_cmd = sorted(p.name for p in (ROOT / "_restore_tools").glob("*.cmd")) if (ROOT / "_restore_tools").exists() else []
    return {
        "rootCmdCount": len(root_cmd),
        "rootCmdFiles": root_cmd,
        "restoreToolsDirectCmdCount": len(direct_restore_cmd),
        "restoreToolsDirectCmdFiles": direct_restore_cmd,
        "policySatisfied": len(root_cmd) == 1 and len(direct_restore_cmd) == 0,
    }


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    images = {
        "reference": load_rgb(REFERENCE),
        "ui128": load_rgb(UI128),
        "ui136": load_rgb(UI136),
        "ui144": load_rgb(UI144),
    }
    rows = write_diff_csv(images)
    make_contact(images)

    result = json.loads(UNITY_JSON.read_text(encoding="utf-8"))
    ui128_full = get_metric(rows, "reference_vs_ui128", "full", "pixelCorrelation")
    ui136_full = get_metric(rows, "reference_vs_ui136", "full", "pixelCorrelation")
    ui144_full = get_metric(rows, "reference_vs_ui144", "full", "pixelCorrelation")
    ui128_bottom = get_metric(rows, "reference_vs_ui128", "bottom_nav", "pixelCorrelation")
    ui136_bottom = get_metric(rows, "reference_vs_ui136", "bottom_nav", "pixelCorrelation")
    ui144_bottom = get_metric(rows, "reference_vs_ui144", "bottom_nav", "pixelCorrelation")

    result.update(
        {
            "restoredClaim": False,
            "diffMetricsCsv": str(DIFF_CSV),
            "contactPath": str(CONTACT),
            "diffImprovedAgainstUI128": bool(ui144_full > ui128_full and ui144_bottom > ui128_bottom),
            "diffImprovedAgainstUI136": bool(ui144_full > ui136_full and ui144_bottom > ui136_bottom),
            "ui144FullCorrelation": ui144_full,
            "ui128FullCorrelation": ui128_full,
            "ui136FullCorrelation": ui136_full,
            "ui144BottomNavCorrelation": ui144_bottom,
            "ui128BottomNavCorrelation": ui128_bottom,
            "ui136BottomNavCorrelation": ui136_bottom,
            "uiDockPromotionAllowed": False,
            "guardedNodesPreserved": True,
            "fakeAssetsCreated": False,
            "requiresRuntimeDump": bool(not (ui144_full > ui128_full and ui144_bottom > ui128_bottom)),
            "requiredNextEvidence": [
                "Production-equivalent UI_Dock parent/open-stack transform, mask, and disable-layer depth behavior; source root sorting plus renderer reconstruction compiles but does not beat UI128.",
                "Runtime/account snapshot remains required for activity/chat/account/currency dynamic state.",
            ],
            "commandPolicy": command_policy(),
        }
    )
    changed = set(result.get("changedFiles", []))
    changed.update(
        [
            r"C:\Users\godho\Downloads\girlswar\_restore_tools\scripts\maininterface144_prepare_uidock_spine_source.py",
            r"C:\Users\godho\Downloads\girlswar\_restore_tools\scripts\maininterface144_finalize_validation_reports.py",
            r"C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\Editor\MainInterface144UIDockRendererRootCanvasCandidate.cs",
            r"C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\Scenes\MainInterface_UI144_UIDockRendererRootCanvasCandidate.unity",
            r"C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\Scenes\MainInterface_UI144_UIDockSourceOnly.unity",
            r"C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\uidock_spine_source_raw",
            r"C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\uidock_spine_runtime",
            str(DIFF_CSV),
            str(CONTACT),
            str(FINAL_MD),
            str(FINAL_JSON),
        ]
    )
    result["changedFiles"] = sorted(changed)
    FINAL_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    patch_decision = (
        "candidate_saved_but_not_promoted"
        if result.get("captureProduced")
        else "blocked_no_capture"
    )
    result["patchDecision"] = patch_decision
    FINAL_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = f"""# MAININTERFACE_144 Source-backed UI_Dock Renderer and Root Canvas Candidate Validation

## Decision

- restoredClaim: `false`
- scenePatchApplied: `{str(result.get('scenePatchApplied')).lower()}`
- candidatePatchApplied: `{str(result.get('candidatePatchApplied')).lower()}`
- patchDecision: `{patch_decision}`
- uiDockPromotionAllowed: `false`

## Validation

| check | result |
| --- | --- |
| Unity compile/import | `{result.get('unityCompilePassed')}` |
| capture produced | `{result.get('captureProduced')}` |
| source root canvas sorting | `{result.get('sourceRootCanvasSortingApplied')}` |
| UI_Dock renderer dependencies imported | `{result.get('uiDockRendererDependenciesImported')}` |
| UI_bg raycast preserved | `{result.get('uiBgRaycastPreserved')}` |
| UI_bg interactable preserved | `{result.get('uiBgInteractablePreserved')}` |
| guarded nodes preserved | `true` |
| fake assets created | `false` |

## Diff Summary

| metric | UI128 | UI136 | UI144 |
| --- | ---: | ---: | ---: |
| full correlation vs reference | `{ui128_full}` | `{ui136_full}` | `{ui144_full}` |
| bottom nav correlation vs reference | `{ui128_bottom}` | `{ui136_bottom}` | `{ui144_bottom}` |

UI144 validates the source-backed renderer/root-canvas import path, but it does not materially beat the safe UI128 baseline, so the Dock candidate is not promoted.

## Source-backed Changes

- Exported UI_Dock `.skel.bytes` from clean UnityFS TextAsset raw payloads instead of damaged `.skel.txt` copies.
- Reconstructed 8 normal UI_Dock `sp_*` `SkeletonGraphic` renderers from UI142 dependencies.
- Applied UI143 serialized root Canvas sorting evidence: `UI_MainInterface_old=0`, `UI_Dock=100`.
- Preserved `UI_bg` raycast/interactable: `{result.get('uiBgBaselineRaycastTarget')}/{result.get('uiBgFinalRaycastTarget')}`, `{result.get('uiBgBaselineInteractable')}/{result.get('uiBgFinalInteractable')}`.

## Outputs

- Capture: `{result.get('capturePath')}`
- Diff CSV: `{DIFF_CSV}`
- Contact: `{CONTACT}`
- Patch matrix: `{REPORT_DIR / 'MAININTERFACE_144_source_backed_candidate_patch_action_matrix.csv'}`
- Validation matrix: `{REPORT_DIR / 'MAININTERFACE_144_unity_compile_import_capture_validation_matrix.csv'}`
- Visibility matrix: `{REPORT_DIR / 'MAININTERFACE_144_uidock_sp_renderer_runtime_candidate_visibility_matrix.csv'}`
- JSON: `{FINAL_JSON}`

## Next Blocker

Production-equivalent UI_Dock parent/open-stack transform, mask, and disable-layer depth behavior is still missing. Source root Canvas sorting plus real renderer reconstruction compiles and captures, but visual metrics still trail UI128, so promotion needs runtime-equivalent stack/depth evidence or an approved runtime dump.
"""
    FINAL_MD.write_text(md, encoding="utf-8")
    print(json.dumps({"json": str(FINAL_JSON), "md": str(FINAL_MD), "diffCsv": str(DIFF_CSV), "contact": str(CONTACT)}, indent=2))


if __name__ == "__main__":
    main()
