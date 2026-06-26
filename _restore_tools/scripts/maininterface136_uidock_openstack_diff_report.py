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
CAPTURE_UI136 = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui136_uidock_openstack_candidate_1680x720.png"
UNITY_JSON = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_136_uidock_openstack_candidate_summary.json"
CLICK_JSON = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_136_uidock_click_validation_summary.json"
CLICK_CSV = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_136_uidock_click_validation.csv"
SCENE_PROBE_CSV = REPORT_DIR / "MAININTERFACE_136_uidock_candidate_scene_probe.csv"
UI131_JSON = REPORT_DIR / "MAININTERFACE_131_REFERENCE_DIFF_ROOT_CAUSE_AND_SOURCE_BACKED_PATCH_MATRIX_NO_FAKE_PATCH_RESULT.json"
UI134_BOTTOM_CSV = REPORT_DIR / "MAININTERFACE_134_bottom_nav_source_animator_runtime_state_evidence.csv"
UI135_JSON = REPORT_DIR / "MAININTERFACE_135_APPLY_SOURCE_BACKED_HERO1005_HOMEPARA_AND_BACK_FRONT_LAYER_CANDIDATE_CAPTURE_NO_DOCK_PATCH_RESULT.json"

PREFIX = "MAININTERFACE_136_TRACE_UIDOCK_OPEN_STACK_BOTTOM_NAV_CANDIDATE_NO_BACK_LAYER_PROMOTION"
RESULT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
RESULT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
SOURCE_TRACE_CSV = REPORT_DIR / "MAININTERFACE_136_uidock_source_open_stack_trace.csv"
MATRIX_CSV = REPORT_DIR / "MAININTERFACE_136_oldroot_bottom_nav_vs_uidock_evidence_matrix.csv"
REGION_CSV = REPORT_DIR / "MAININTERFACE_136_bottom_nav_region_metrics.csv"
CONTACT_PNG = REPORT_DIR / "MAININTERFACE_136_REFERENCE_DIFF_CONTACT.png"


def read_json(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(path.open("w", encoding="utf-8", newline=""), fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def write_csv_safe(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow({key: row.get(key, "") for key in fieldnames})


def command_policy() -> dict[str, Any]:
    root_cmd = len(list(ROOT.glob("*.cmd")))
    direct = len(list((ROOT / "_restore_tools").glob("*.cmd")))
    return {
        "rootCmdCount": root_cmd,
        "restoreToolsDirectCmdCount": direct,
        "policyOk": root_cmd == 1 and direct == 0,
    }


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
        "box": json.dumps(box, separators=(",", ":")),
        "meanAbsDiff": round(mean_abs, 6),
        "rmsDiff": round(rms, 6),
        "changedPixelRatio30": round(changed30, 6),
        "pixelCorrelation": round(corr_rgb(left, right), 6),
    }


def load_region_boxes() -> dict[str, list[int]]:
    ui131 = read_json(UI131_JSON)
    boxes = {}
    for name, data in ui131.get("regionMetrics", {}).items():
        if isinstance(data, dict) and "box" in data:
            boxes[name] = data["box"]
    boxes.setdefault("full", [0, 0, 1680, 720])
    boxes.setdefault("bottom_nav", [0, 500, 1680, 720])
    boxes.setdefault("right_activity_stack", [900, 95, 1680, 335])
    boxes.setdefault("center_hero_background", [360, 40, 1180, 690])
    boxes.setdefault("click_blocker_btn_discord", [1160, 0, 1680, 260])
    boxes.setdefault("bottom_dock_focus", [420, 500, 1260, 720])
    return boxes


def load_images() -> tuple[Image.Image, Image.Image, Image.Image] | None:
    if not (REFERENCE.exists() and BASELINE_UI128.exists() and CAPTURE_UI136.exists()):
        return None
    ref = Image.open(REFERENCE).convert("RGB")
    base = Image.open(BASELINE_UI128).convert("RGB")
    cand = Image.open(CAPTURE_UI136).convert("RGB")
    if ref.size != cand.size:
        ref = ref.resize(cand.size, Image.Resampling.LANCZOS)
    if base.size != cand.size:
        base = base.resize(cand.size, Image.Resampling.LANCZOS)
    return ref, base, cand


def write_source_trace() -> list[dict[str, Any]]:
    rows = [
        {
            "evidence_kind": "datatable_form",
            "source": r"girlswar_merged_extracted\extracted\unity\bundles\b_118e2d32692e66cc\textassets\7179387777078280832_DTSysUIFormEntityTableData.txt",
            "target": "UI_Dock",
            "line_or_path": "175",
            "excerpt": "{248,\"Dock\",\"UI_Dock\",...,\"UIPrefabAndRes/MainInterface/Prefabs/UI_Dock\",...,\"MainInterface\"}",
            "source_backed_interpretation": "UI_Dock is a first-class MainInterface UI form/prefab, not an invented strip.",
            "candidate_action": "build source root 7409970622389811116 as separate form candidate",
        },
        {
            "evidence_kind": "rect_root",
            "source": r"girlswar_maininterface_unity\Assets\RestoreData\maininterface_rects.csv",
            "target": "UI_Dock",
            "line_or_path": "path_id=7409970622389811116; game_object_id=-2739981314955153384",
            "excerpt": "UI_Dock active root, father_id=0",
            "source_backed_interpretation": "MainInterfaceSceneBuilder can build the UI_Dock root independently from source RectTransform data.",
            "candidate_action": "copy source-built UI_Dock root into old-root candidate as sibling form",
        },
        {
            "evidence_kind": "lua_component",
            "source": r"girlswar_maininterface_unity\Assets\RestoreData\maininterface_components.csv",
            "target": "UI_Dock",
            "line_or_path": "owner_game_object_id=-2739981314955153384",
            "excerpt": "/Download/xLuaLogic/Modules/MainInterface/UI_Dock.bytes",
            "source_backed_interpretation": "The UI_Dock prefab owns the decoded UI_Dock Lua component.",
            "candidate_action": "use decoded UI_Dock.lua to derive default state only",
        },
        {
            "evidence_kind": "decoded_lua",
            "source": r"girlswar_merged_extracted\decoded\xlua\-4615102950863731052_UI_Dock_security_xor_raw.lua",
            "target": "default_tab",
            "line_or_path": "67",
            "excerpt": "e=a and a.tabIndex or DOCK_TYPE.MAIN_PAGE",
            "source_backed_interpretation": "Without passed tabIndex, UI_Dock opens on MAIN_PAGE.",
            "candidate_action": "apply MAIN_PAGE selected state",
        },
        {
            "evidence_kind": "decoded_lua",
            "source": r"girlswar_merged_extracted\decoded\xlua\-4615102950863731052_UI_Dock_security_xor_raw.lua",
            "target": "initTab",
            "line_or_path": "138-149",
            "excerpt": "LuaUtils.SetActive(d[t][1].transform,e); LuaUtils.SetActive(d[t][2].transform,not e); PlayAnimation A/B",
            "source_backed_interpretation": "Selected dock tab uses *_on active and *_off inactive; other tabs invert that state.",
            "candidate_action": "set main_on true/main_off false; other *_on false/*_off true",
        },
        {
            "evidence_kind": "decoded_lua",
            "source": r"girlswar_merged_extracted\decoded\xlua\-4615102950863731052_UI_Dock_security_xor_raw.lua",
            "target": "open_stack",
            "line_or_path": "250-286",
            "excerpt": "if e==DOCK_TYPE.MAIN_PAGE then GameEntry.UI:OpenUIForm(UIFormId.UI_MainPage,t)",
            "source_backed_interpretation": "UI_Dock and UI_MainPage are an open-stack pair in normal main-page default.",
            "candidate_action": "combine old-root UI_MainInterface_old candidate with UI_Dock sibling",
        },
        {
            "evidence_kind": "decoded_lua",
            "source": r"girlswar_merged_extracted\decoded\xlua\-4615102950863731052_UI_Dock_security_xor_raw.lua",
            "target": "show_hide_animator",
            "line_or_path": "575-580",
            "excerpt": "LuaUtils.AnimtorPlay(UI_Dock,\"UI_Dock_out\"/\"UI_Dock_in\",0,0)",
            "source_backed_interpretation": "Dock has its own show/hide animation lane; not evidence for hiding old-root route/activity nodes.",
            "candidate_action": "do not patch unrelated nodes",
        },
        {
            "evidence_kind": "guardrail",
            "source": r"reports\maininterface\MAININTERFACE_135_*.json",
            "target": "Painting_1005_back",
            "line_or_path": "backLayerVisualVerdict",
            "excerpt": "do_not_promote_current_back_layer_mount_without_original_prefab_transform_order",
            "source_backed_interpretation": "Back layer source exists but current mount worsens diff and must not be carried into UI136.",
            "candidate_action": "mount Hero1005 main Painting_1005 only",
        },
    ]
    write_csv_safe(
        SOURCE_TRACE_CSV,
        rows,
        [
            "evidence_kind",
            "source",
            "target",
            "line_or_path",
            "excerpt",
            "source_backed_interpretation",
            "candidate_action",
        ],
    )
    return rows


def write_matrix() -> list[dict[str, Any]]:
    rows = [
        {
            "item": "old-root right/shop/mail/friends/ranking cluster",
            "oldroot_evidence": "present in UI133 bottom probe; UI_MainPage handlers/static labels exist",
            "uidock_evidence": "not the UI_Dock form; remains part of UI_MainPage old-root candidate",
            "classification": "keep_oldroot_no_patch",
            "decision": "do not hide or replace",
        },
        {
            "item": "old-root node_bottom/toogles/btnToggle*",
            "oldroot_evidence": "UI_MainPage has bindings/handlers but current old-root candidate does not expose active new-root strip",
            "uidock_evidence": "UI_Dock has independent DOCK_TYPE MAIN_PAGE..MAIN_CITY mapping and source root",
            "classification": "uidock_open_stack_candidate_stronger",
            "decision": "probe UI_Dock sibling form instead of importing node_bottom coordinates",
        },
        {
            "item": "UI_Dock MAIN_PAGE selected tab",
            "oldroot_evidence": "not represented by old-root alone",
            "uidock_evidence": "UI_Dock.lua line 67 defaults to MAIN_PAGE; initTab lines 138-149 toggles on/off",
            "classification": "source_backed_candidate_patch_applied",
            "decision": "main_on active/main_off inactive; other off nodes active",
        },
        {
            "item": "UI_Dock icons/spines/sprites",
            "oldroot_evidence": "old-root uses separate right/bottom/social buttons",
            "uidock_evidence": "source prefab/bindings/restored sprites and SP_Dock assets exist",
            "classification": "source_asset_prefab_driven",
            "decision": "use source-built hierarchy only; no fake icons/text",
        },
        {
            "item": "activity stack and face activity",
            "oldroot_evidence": "requires ActMgr runtime snapshot from UI129/UI130",
            "uidock_evidence": "UI_Dock does not solve activity server list",
            "classification": "requires_runtime_snapshot",
            "decision": "no activity slot hide/text/icon/spine patch",
        },
        {
            "item": "Hero1005 back layer",
            "oldroot_evidence": "UI135 zero-offset mount worsened full/hero correlation",
            "uidock_evidence": "not part of UI_Dock task",
            "classification": "source_backed_static_patch_not_allowed_by_guardrail",
            "decision": "do not include Painting_1005_back in UI136 candidate",
        },
    ]
    write_csv_safe(
        MATRIX_CSV,
        rows,
        ["item", "oldroot_evidence", "uidock_evidence", "classification", "decision"],
    )
    return rows


def write_metrics_and_contact() -> dict[str, Any]:
    images = load_images()
    if images is None:
        write_csv_safe(
            REGION_CSV,
            [],
            ["comparison", "region", "box", "meanAbsDiff", "rmsDiff", "changedPixelRatio30", "pixelCorrelation"],
        )
        return {"available": False, "reason": "reference/baseline/candidate capture missing"}

    ref, base, cand = images
    boxes = load_region_boxes()
    regions = ["full", "bottom_nav", "bottom_dock_focus", "center_hero_background", "right_activity_stack", "click_blocker_btn_discord"]
    rows: list[dict[str, Any]] = []
    metrics: dict[str, dict[str, Any]] = {}
    for comparison, left, right in (
        ("reference_vs_ui128", ref, base),
        ("reference_vs_ui136", ref, cand),
        ("ui128_vs_ui136", base, cand),
    ):
        for region in regions:
            metric = metric_for(left, right, boxes[region])
            row = {"comparison": comparison, "region": region, **metric}
            rows.append(row)
            metrics[f"{comparison}:{region}"] = metric
    write_csv_safe(
        REGION_CSV,
        rows,
        ["comparison", "region", "box", "meanAbsDiff", "rmsDiff", "changedPixelRatio30", "pixelCorrelation"],
    )

    diff = ImageChops.difference(ref, cand)
    diff = ImageChops.multiply(diff, Image.new("RGB", diff.size, (4, 4, 4)))
    base_diff = ImageChops.difference(base, cand)
    base_diff = ImageChops.multiply(base_diff, Image.new("RGB", base_diff.size, (4, 4, 4)))
    thumb_w = 420
    thumb_h = int(ref.height * thumb_w / ref.width)
    panels = [("reference", ref), ("ui128 baseline", base), ("ui136 candidate", cand), ("ref vs ui136 diff", diff)]
    sheet = Image.new("RGB", (thumb_w * 4, thumb_h + 360), (24, 24, 24))
    for idx, (title, image) in enumerate(panels):
        panel = image.resize((thumb_w, thumb_h), Image.Resampling.LANCZOS)
        draw = ImageDraw.Draw(panel)
        draw.rectangle((0, 0, thumb_w, 24), fill=(0, 0, 0))
        draw.text((8, 6), title, fill=(255, 255, 255))
        sheet.paste(panel, (idx * thumb_w, 0))

    for idx, region in enumerate(["bottom_nav", "bottom_dock_focus", "center_hero_background", "right_activity_stack"]):
        box = boxes[region]
        block = Image.new("RGB", (thumb_w, 340), (18, 18, 18))
        draw = ImageDraw.Draw(block)
        draw.text((6, 4), region, fill=(255, 255, 255))
        block.paste(ref.crop(tuple(box)).resize((thumb_w, 150), Image.Resampling.LANCZOS), (0, 24))
        block.paste(cand.crop(tuple(box)).resize((thumb_w, 150), Image.Resampling.LANCZOS), (0, 184))
        draw.text((6, 166), "reference above / ui136 below", fill=(230, 230, 230))
        sheet.paste(block, (idx * thumb_w, thumb_h + 10))

    strip = base_diff.resize((thumb_w, thumb_h), Image.Resampling.LANCZOS)
    draw = ImageDraw.Draw(strip)
    draw.rectangle((0, 0, thumb_w, 24), fill=(0, 0, 0))
    draw.text((8, 6), "ui128 vs ui136 diff", fill=(255, 255, 255))
    sheet.paste(strip.crop((0, 0, thumb_w, min(80, thumb_h))), (thumb_w * 3, thumb_h + 270))
    CONTACT_PNG.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT_PNG)
    return {"available": True, "metrics": metrics}


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    unity = read_json(UNITY_JSON)
    click = read_json(CLICK_JSON)
    ui135 = read_json(UI135_JSON)
    source_rows = write_source_trace()
    matrix_rows = write_matrix()
    metric_result = write_metrics_and_contact()
    scene_probe_rows = read_csv(SCENE_PROBE_CSV)
    ui134_rows = read_csv(UI134_BOTTOM_CSV)
    policy = command_policy()

    dock_rows = [r for r in scene_probe_rows if r.get("category", "").startswith("uidock")]
    default_rows = [r for r in scene_probe_rows if r.get("category") == "lua_initTab_default_state"]
    click_summary = {
        "totalButtons": click.get("totalButtons"),
        "activeButtons": click.get("activeButtons"),
        "activeInteractableButtons": click.get("activeInteractableButtons"),
        "raycastClickableButtons": click.get("raycastClickableButtons"),
        "raycastBlockedButtons": click.get("raycastBlockedButtons"),
        "csv": str(CLICK_CSV),
        "json": str(CLICK_JSON),
    }
    metrics = metric_result.get("metrics", {})
    baseline_bottom = metrics.get("reference_vs_ui128:bottom_nav", {})
    candidate_bottom = metrics.get("reference_vs_ui136:bottom_nav", {})
    bottom_delta = None
    if baseline_bottom and candidate_bottom:
        bottom_delta = round(candidate_bottom["pixelCorrelation"] - baseline_bottom["pixelCorrelation"], 6)

    result = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "task": PREFIX,
        "restoredClaim": False,
        "sceneSaved": bool(unity.get("sceneSaved")),
        "candidatePatchApplied": bool(unity.get("candidatePatchApplied")),
        "dockCandidateApplied": bool(unity.get("dockCandidateApplied")),
        "dockDefaultStateApplied": bool(unity.get("dockDefaultStateApplied")),
        "matchedToggleCount": unity.get("matchedToggleCount", 0),
        "onOffMismatchCount": unity.get("onOffMismatchCount", 0),
        "productionPatchApplied": False,
        "patchDecision": unity.get("patchDecision", "blocked_or_unity_not_run"),
        "unityStatus": unity.get("status", ""),
        "reference": str(REFERENCE),
        "baselineCapture": str(BASELINE_UI128),
        "candidateCapture": str(CAPTURE_UI136),
        "contactPng": str(CONTACT_PNG) if CONTACT_PNG.exists() else "",
        "sourceTraceCsv": str(SOURCE_TRACE_CSV),
        "evidenceMatrixCsv": str(MATRIX_CSV),
        "sceneProbeCsv": str(SCENE_PROBE_CSV),
        "bottomNavMetricsCsv": str(REGION_CSV),
        "clickSummary": click_summary,
        "sourceTraceRows": len(source_rows),
        "matrixRows": len(matrix_rows),
        "ui134BottomEvidenceRows": len(ui134_rows),
        "uidockSceneRows": len(dock_rows),
        "defaultStateRows": len(default_rows),
        "uiBgGuardrail": {
            "uiBgHadImage": unity.get("uiBgHadImage"),
            "baselineRaycastTarget": unity.get("uiBgBaselineRaycastTarget"),
            "finalRaycastTarget": unity.get("uiBgFinalRaycastTarget"),
            "UI_bg_raycast_preserved": unity.get("uiBgRaycastPreserved"),
            "uiBgHadButton": unity.get("uiBgHadButton"),
            "baselineInteractable": unity.get("uiBgBaselineInteractable"),
            "finalInteractable": unity.get("uiBgFinalInteractable"),
            "UI_bg_interactable_preserved": unity.get("uiBgInteractablePreserved"),
            "note": unity.get("uiBgPreserveNote", ""),
        },
        "bottomNavCorrelationDeltaUi136MinusUi128": bottom_delta,
        "metricResult": metric_result,
        "ui135BackLayerGuardrail": ui135.get("backLayerVisualVerdict", {}),
        "commandPolicy": policy,
        "nextBlocker": "UI_Dock open-stack can be probed as source-built candidate, but activity/account snapshot and exact production UI layer ordering still block final restored claim.",
    }
    RESULT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# MAININTERFACE 136 Trace UIDock Open Stack Bottom Nav Candidate Result",
        "",
        f"Generated: {result['generatedAt']}",
        "",
        "## Verdict",
        "",
        f"- restoredClaim: `false`",
        f"- sceneSaved: `{result['sceneSaved']}`",
        f"- dockCandidateApplied: `{result['dockCandidateApplied']}`",
        f"- dockDefaultStateApplied: `{result['dockDefaultStateApplied']}`",
        f"- matchedToggleCount: `{result['matchedToggleCount']}`",
        f"- onOffMismatchCount: `{result['onOffMismatchCount']}`",
        f"- patchDecision: `{result['patchDecision']}`",
        "- productionPatchApplied: `false`",
        "- Painting_1005_back promotion: `false`",
        "",
        "## Evidence",
        "",
        "- `UI_Dock` is a MainInterface UI form from `DTSysUIFormEntityTableData` and source RectTransform root `7409970622389811116`.",
        "- Decoded `UI_Dock.lua` defaults to `DOCK_TYPE.MAIN_PAGE`, activates the form except story-guide exception, runs `initTab()`, and opens `UI_MainPage` for the MAIN_PAGE tab.",
        "- UI136 therefore probes old-root `UI_MainInterface_old` plus a source-built `UI_Dock` sibling form. It does not import coordinates from old `node_bottom/toogles`.",
        "- UI135 `Painting_1005_back` remains excluded because its zero-offset probe worsened reference correlation.",
        f"- UI_bg_raycast_preserved: `{result['uiBgGuardrail']['UI_bg_raycast_preserved']}` "
        f"(baseline `{result['uiBgGuardrail']['baselineRaycastTarget']}`, final `{result['uiBgGuardrail']['finalRaycastTarget']}`); "
        f"interactable preserved: `{result['uiBgGuardrail']['UI_bg_interactable_preserved']}` "
        f"(baseline `{result['uiBgGuardrail']['baselineInteractable']}`, final `{result['uiBgGuardrail']['finalInteractable']}`).",
        "",
        "## Metrics",
        "",
    ]
    if metric_result.get("available"):
        md.extend(
            [
                f"- UI128 bottom_nav corr: `{baseline_bottom.get('pixelCorrelation')}`",
                f"- UI136 bottom_nav corr: `{candidate_bottom.get('pixelCorrelation')}`",
                f"- delta: `{bottom_delta}`",
                f"- metrics CSV: `{REGION_CSV}`",
                f"- contact PNG: `{CONTACT_PNG}`",
            ]
        )
    else:
        md.append(f"- metrics unavailable: `{metric_result.get('reason')}`")
    md.extend(
        [
            "",
            "## Click Validation",
            "",
            f"- total/active/clickable/blocked: `{click_summary.get('totalButtons')} / {click_summary.get('activeButtons')} / {click_summary.get('raycastClickableButtons')} / {click_summary.get('raycastBlockedButtons')}`",
            f"- click CSV: `{CLICK_CSV}`",
            f"- click JSON: `{CLICK_JSON}`",
            "",
            "## Outputs",
            "",
            f"- source/open-stack trace CSV: `{SOURCE_TRACE_CSV}`",
            f"- old-root vs UI_Dock matrix CSV: `{MATRIX_CSV}`",
            f"- candidate scene probe CSV: `{SCENE_PROBE_CSV}`",
            f"- candidate capture: `{CAPTURE_UI136}`",
            f"- result JSON: `{RESULT_JSON}`",
            "",
            "## Command Policy",
            "",
            f"- root `.cmd` count: `{policy['rootCmdCount']}`",
            f"- `_restore_tools` direct `.cmd` count: `{policy['restoreToolsDirectCmdCount']}`",
            f"- policyOk: `{policy['policyOk']}`",
            "",
            "## Next Blocker",
            "",
            "- Activity/account snapshot is still required before activity slot/text/icon/spine state can be reconstructed.",
            "- Exact production layer/order validation is still required before promoting UI_Dock candidate into restored state.",
        ]
    )
    RESULT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
