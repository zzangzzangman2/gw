from __future__ import annotations

import csv
import json
import math
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageStat


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
REPORTS = BASE / "reports" / "maininterface"
RESTORE_REPORTS = PROJECT / "Assets" / "RestoreData" / "reports"
REFERENCE = Path(r"C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png")
UI126_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui126_oldroot_hero1005_candidate_1680x720.png"
UI127_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui127_oldroot_bg1005_runtime_candidate_1680x720.png"
UI127_CLICK_CSV = RESTORE_REPORTS / "maininterface_127_oldroot_bg1005_click_validation.csv"
UI127_CLICK_JSON = RESTORE_REPORTS / "maininterface_127_oldroot_bg1005_click_validation_summary.json"
UI126_CLICK_JSON = RESTORE_REPORTS / "maininterface_126_oldroot_click_validation_summary.json"

OUT_EVIDENCE = REPORTS / "MAININTERFACE_127_runtime_state_evidence.csv"
OUT_DIFF = REPORTS / "MAININTERFACE_127_reference_diff_regions.csv"
OUT_CONTACT = REPORTS / "MAININTERFACE_127_REFERENCE_DIFF_CONTACT.png"
OUT_JSON = RESTORE_REPORTS / "maininterface_127_oldroot_runtime_state_trace.json"
OUT_MD = REPORTS / "MAININTERFACE_127_OLDROOT_BACKGROUND_RUNTIME_RESOURCE_AND_LAYER_STATE_RECONSTRUCTION_RESULT.md"


REGIONS = {
    "full": (0, 0, 1680, 720),
    "top_bar": (0, 0, 1680, 110),
    "left_lobby": (0, 100, 430, 640),
    "center_hero": (360, 40, 1180, 690),
    "right_cluster": (1180, 70, 1680, 610),
    "bottom_nav": (0, 580, 1680, 720),
}


def image(path: Path) -> Image.Image:
    return Image.open(path).convert("RGB")


def resize_to_ref(img: Image.Image, ref: Image.Image) -> Image.Image:
    if img.size == ref.size:
        return img
    return img.resize(ref.size, Image.Resampling.LANCZOS)


def correlation(a: Image.Image, b: Image.Image) -> float:
    pa = list(a.getdata())
    pb = list(b.getdata())
    n = len(pa) * 3
    if n == 0:
        return 0.0
    av = sum(sum(px) for px in pa) / n
    bv = sum(sum(px) for px in pb) / n
    num = 0.0
    da = 0.0
    db = 0.0
    for xa, xb in zip(pa, pb):
        for ca, cb in zip(xa, xb):
            va = ca - av
            vb = cb - bv
            num += va * vb
            da += va * va
            db += vb * vb
    if da <= 0 or db <= 0:
        return 0.0
    return num / math.sqrt(da * db)


def diff_rows() -> list[dict]:
    ref = image(REFERENCE).resize((1680, 720), Image.Resampling.LANCZOS)
    rows: list[dict] = []
    captures = [
        ("ui126_old_root_candidate", UI126_CAPTURE),
        ("ui127_oldroot_bg1005_candidate", UI127_CAPTURE),
    ]
    for label, path in captures:
        if not path.exists():
            continue
        cap = resize_to_ref(image(path), ref)
        for region, box in REGIONS.items():
            r = ref.crop(box)
            c = cap.crop(box)
            diff = ImageChops.difference(r, c)
            stat = ImageStat.Stat(diff)
            mean = sum(stat.mean) / (255.0 * 3.0)
            rms = math.sqrt(sum(v * v for v in stat.rms) / 3.0) / 255.0
            changed = sum(1 for px in diff.getdata() if max(px) >= 30) / float(diff.width * diff.height)
            rows.append(
                {
                    "captureLabel": label,
                    "region": region,
                    "meanAbsDiff": round(mean, 6),
                    "rmsDiff": round(rms, 6),
                    "changedPixelRatio30": round(changed, 6),
                    "pixelCorrelation": round(correlation(r, c), 6),
                    "capturePath": str(path),
                }
            )
    return rows


def read_json(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def blocked_clicks(path: Path) -> list[dict]:
    if not path.exists():
        return []
    rows = []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        for row in csv.DictReader(f):
            if (
                row.get("activeInHierarchy") == "True"
                and row.get("interactable") == "True"
                and row.get("raycastClickable") == "False"
            ):
                rows.append(row)
    return rows


def evidence_rows() -> list[dict]:
    return [
        {
            "topic": "oldroot_background_black_cause",
            "source": "RestoreData maininterface_rects/sprite_map + UI126 capture",
            "evidence": "UI_MainInterface_old/UI_bg is prefab inactive with ready BG_changjing_2 sprite; UI126 old-root candidate did not activate it, causing transparent/black capture background.",
            "decision": "candidate_patch_applied",
            "patch": "Activate old-root UI_bg and bind noalphabg_PaintingBG_1005 only in UI127 candidate scene.",
        },
        {
            "topic": "normal_home_background_runtime",
            "source": "decoded UI_MainPage refreshMiddle lines 1543-1560",
            "evidence": "Normal home branch calls UIUtil.GetPlayerBigSpineAll(i, UI_heroSpine, 'homePara') then local e=UIUtil.GetPaintingBg(i) and GameTools:LoadSpriteWithFullPath(UI_bg,e,true).",
            "decision": "source_backed_candidate",
            "patch": "Use existing runtime_dynamic runtime_UI_bg_noalphabg_PaintingBG_1005.png, derived from hero1005 PaintingBG_1005 source.",
        },
        {
            "topic": "activity_placeholder_runtime",
            "source": "decoded UI_MainPage refreshMainAct + UI_MainPageActItem",
            "evidence": "refreshMainAct first SetActive(false) for all p items, then enables only ActMgr:GetActInMain entries; UI_MainPageActItem:Refresh sets text and loads tbSpine/mainPageSpineId via UIUtil.GetSpinePrefabFromPool.",
            "decision": "blocked_no_patch",
            "patch": "No candidate hide of node_act_btn/btn_act_*; runtime/server activity list is not reconstructed.",
        },
        {
            "topic": "btn_discord_layer_blocker",
            "source": "decoded UI_MainPage OnInit and UI127 click validation",
            "evidence": "btn_discord SetActive(false) appears only inside GameTools:IsReview() branch; reference still shows normal task/lobby elements that the same branch would hide. UI127 click validation still has btn_discord topped by right/node_act_btn/btn_act_12.",
            "decision": "blocked_no_patch",
            "patch": "No btn_discord hide until non-review runtime condition or layout/sibling evidence is found.",
        },
        {
            "topic": "ui_bg_click_validation",
            "source": "maininterface_buttons.csv + UI127 click validation",
            "evidence": "old-root UI_bg has an original Button component with empty persistent calls and no Lua AddListener; activating it adds one active blocked row under UI_touchSpine.",
            "decision": "blocked_no_patch",
            "patch": "No click-only raycast/interactable patch without source evidence for runtime Button/raycast state.",
        },
        {
            "topic": "zhuye_route_visibility_guardrail",
            "source": "UI121/UI122 evidence",
            "evidence": "zhuye_di1/zhuye_bian are original pre-clipping attachments; no UI127 patch hides them. new-root route/world cluster also not hidden in production.",
            "decision": "guardrail_preserved",
            "patch": "No zhuye/right/node_middle/wanfaWorldNode/worldwanfaBtn arbitrary hide.",
        },
    ]


def write_csv(path: Path, rows: list[dict]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if not rows:
        path.write_text("", encoding="utf-8")
        return
    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)


def make_contact() -> None:
    ref = image(REFERENCE).resize((1680, 720), Image.Resampling.LANCZOS)
    panels = []
    for label, path in [
        ("reference", REFERENCE),
        ("UI126 old-root", UI126_CAPTURE),
        ("UI127 old-root BG1005", UI127_CAPTURE),
    ]:
        if not path.exists():
            continue
        img = image(path)
        img = resize_to_ref(img, ref)
        panel = img.resize((560, 240), Image.Resampling.LANCZOS)
        draw = ImageDraw.Draw(panel)
        draw.rectangle((0, 0, 560, 32), fill=(0, 0, 0))
        draw.text((10, 9), label, fill=(255, 255, 255))
        panels.append(panel)
    contact = Image.new("RGB", (560 * len(panels), 240), (0, 0, 0))
    for i, panel in enumerate(panels):
        contact.paste(panel, (560 * i, 0))
    OUT_CONTACT.parent.mkdir(parents=True, exist_ok=True)
    contact.save(OUT_CONTACT)


def main() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    RESTORE_REPORTS.mkdir(parents=True, exist_ok=True)
    diffs = diff_rows()
    evidence = evidence_rows()
    click126 = read_json(UI126_CLICK_JSON)
    click127 = read_json(UI127_CLICK_JSON)
    blocked127 = blocked_clicks(UI127_CLICK_CSV)
    make_contact()
    write_csv(OUT_DIFF, diffs)
    write_csv(OUT_EVIDENCE, evidence)

    summary = {
        "generatedAt": "2026-06-26",
        "restoredClaim": False,
        "reference": str(REFERENCE),
        "ui126Capture": str(UI126_CAPTURE),
        "ui127Capture": str(UI127_CAPTURE),
        "contactSheet": str(OUT_CONTACT),
        "ui126ClickSummary": click126,
        "ui127ClickSummary": click127,
        "ui127BlockedClicks": blocked127,
        "evidenceCsv": str(OUT_EVIDENCE),
        "diffCsv": str(OUT_DIFF),
        "conclusion": "UI127 fixes the old-root black background in a source-backed candidate scene, but reference restoration remains false because activity/runtime placeholders, text/font state, and layer/click blockers remain unresolved.",
    }
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# MAININTERFACE_127_OLDROOT_BACKGROUND_RUNTIME_RESOURCE_AND_LAYER_STATE_RECONSTRUCTION_RESULT",
        "",
        "## Verdict",
        "",
        "Restored claim remains `false`. UI127 applies a candidate-only old-root background runtime reconstruction and improves the visual state, but it is still not a reference match.",
        "",
        "## Candidate Patch",
        "",
        "- Applied to old-root candidate scene only: activate `UI_MainInterface_old/UI_bg` and bind `runtime_UI_bg_noalphabg_PaintingBG_1005.png`.",
        "- Preserved UI124 real Hero1005 `SkeletonGraphic`; no `Painting_1005.png` whole Image was used.",
        "- Did not hide `node_act_btn`, `btn_act_*`, `btn_discord`, `zhuye_di1`, `zhuye_bian`, `right/node_middle`, `wanfaWorldNode`, or `worldwanfaBtn`.",
        "",
        "## Evidence",
        "",
    ]
    for row in evidence:
        md.append(f"- `{row['topic']}`: {row['evidence']} Decision: `{row['decision']}`.")
    md.extend(
        [
            "",
            "## Click Validation",
            "",
            f"- UI126 old-root total/active/clickable/blocked: `{click126.get('totalButtons','')} / {click126.get('activeButtons','')} / {click126.get('raycastClickableButtons','')} / {click126.get('raycastBlockedButtons','')}`",
            f"- UI127 BG1005 total/active/clickable/blocked: `{click127.get('totalButtons','')} / {click127.get('activeButtons','')} / {click127.get('raycastClickableButtons','')} / {click127.get('raycastBlockedButtons','')}`",
        ]
    )
    if blocked127:
        md.append("- UI127 active blocked rows:")
        for row in blocked127:
            md.append(f"  - `{row.get('buttonName','')}` top=`{row.get('raycastTopObject','')}`")
    md.extend(
        [
            "",
            "## Diff Summary",
            "",
            "| capture | region | mean abs diff | rms diff | changed >=30 | correlation |",
            "| --- | --- | ---: | ---: | ---: | ---: |",
        ]
    )
    for row in diffs:
        md.append(
            f"| `{row['captureLabel']}` | `{row['region']}` | `{row['meanAbsDiff']}` | `{row['rmsDiff']}` | `{row['changedPixelRatio30']}` | `{row['pixelCorrelation']}` |"
        )
    md.extend(
        [
            "",
            "## Files",
            "",
            f"- capture: `{UI127_CAPTURE}`",
            f"- contact sheet: `{OUT_CONTACT}`",
            f"- evidence CSV: `{OUT_EVIDENCE}`",
            f"- diff CSV: `{OUT_DIFF}`",
            f"- click CSV: `{UI127_CLICK_CSV}`",
            f"- click JSON: `{UI127_CLICK_JSON}`",
            f"- JSON: `{OUT_JSON}`",
            "",
            "## Next Blockers",
            "",
            "- Reconstruct `ActMgr:GetActInMain` account/server data or a source-backed snapshot before changing `node_act_btn/btn_act_*` active states.",
            "- Resolve old-root text/font/TMP material state; current candidate has placeholder/garbled activity labels.",
            "- Find non-review runtime evidence for social/forum button state or layout/sibling evidence for `btn_discord` vs `btn_act_12`.",
            "- Decide whether `UI_bg` original empty Button should be non-interactable/raycast-disabled at runtime; current evidence only proves empty persistent calls and no Lua listener.",
        ]
    )
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps(summary, ensure_ascii=True, indent=2))


if __name__ == "__main__":
    main()
