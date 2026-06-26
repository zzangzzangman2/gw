from __future__ import annotations

import csv
import json
import math
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Any

from PIL import Image, ImageChops, ImageDraw, ImageStat


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
REPORTS = BASE / "reports" / "maininterface"
REFERENCE = Path(r"C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png")
CANDIDATE = BASE / "girlswar_maininterface_unity" / "Assets" / "RestoreCaptures" / "maininterface_ui128_oldroot_runtime_activity_text_tmp_click_candidate_1680x720.png"

UI128_RESULT = REPORTS / "MAININTERFACE_128_OLDROOT_RUNTIME_ACTIVITY_TEXT_TMP_AND_CLICK_LAYER_RECONSTRUCTION_RESULT.md"
UI129_RESULT = REPORTS / "MAININTERFACE_129_TRACE_RUNTIME_ACCOUNT_ACTIVITY_SNAPSHOT_LOCALIZATION_FONT_BINDING_RESULT.md"
UI130_RESULT = REPORTS / "MAININTERFACE_130_RUNTIME_ACTIVITY_SNAPSHOT_IMPORT_REPLAY_PIPELINE_NO_FAKE_PATCH_RESULT.md"
UI128_ACTIVITY = REPORTS / "MAININTERFACE_128_runtime_activity_slot_candidates.csv"
UI128_EVIDENCE = REPORTS / "MAININTERFACE_128_runtime_activity_text_tmp_click_evidence.csv"

OUT_PREFIX = "MAININTERFACE_131_REFERENCE_DIFF_ROOT_CAUSE_AND_SOURCE_BACKED_PATCH_MATRIX_NO_FAKE_PATCH"
OUT_MD = REPORTS / f"{OUT_PREFIX}_RESULT.md"
OUT_JSON = REPORTS / f"{OUT_PREFIX}_RESULT.json"
OUT_MATRIX = REPORTS / "MAININTERFACE_131_reference_diff_root_cause_matrix.csv"
OUT_PATCH_PLAN = REPORTS / "MAININTERFACE_131_source_backed_static_patch_plan_NO_SCENE_PATCH.md"
OUT_CONTACT = REPORTS / "MAININTERFACE_131_REFERENCE_DIFF_CONTACT.png"

REGIONS = {
    "full": (0, 0, 1680, 720),
    "top_bar": (0, 0, 1680, 118),
    "left_lobby": (0, 95, 420, 620),
    "center_hero_background": (360, 40, 1180, 690),
    "right_icon_chat": (880, 60, 1680, 560),
    "right_activity_stack": (900, 95, 1680, 335),
    "chat_bubble": (1030, 215, 1565, 410),
    "bottom_nav": (0, 575, 1680, 720),
    "click_blocker_ui_bg_touch": (0, 0, 1680, 720),
    "click_blocker_btn_discord": (1180, 95, 1580, 640),
}


def image(path: Path) -> Image.Image:
    return Image.open(path).convert("RGB")


def resize_to_ref(img: Image.Image, ref: Image.Image) -> Image.Image:
    if img.size == ref.size:
        return img
    return img.resize(ref.size, Image.Resampling.LANCZOS)


def correlation(a: Image.Image, b: Image.Image) -> float:
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


def region_metrics() -> dict[str, dict[str, Any]]:
    ref = image(REFERENCE).resize((1680, 720), Image.Resampling.LANCZOS)
    cand = resize_to_ref(image(CANDIDATE), ref)
    metrics: dict[str, dict[str, Any]] = {}
    for name, box in REGIONS.items():
        ref_crop = ref.crop(box)
        cand_crop = cand.crop(box)
        diff = ImageChops.difference(ref_crop, cand_crop)
        stat = ImageStat.Stat(diff)
        mean = sum(stat.mean) / (255.0 * 3.0)
        rms = math.sqrt(sum(value * value for value in stat.rms) / 3.0) / 255.0
        changed = sum(1 for px in diff.getdata() if max(px) >= 30) / float(diff.width * diff.height)
        metrics[name] = {
            "region": name,
            "box": box,
            "meanAbsDiff": round(mean, 6),
            "rmsDiff": round(rms, 6),
            "changedPixelRatio30": round(changed, 6),
            "pixelCorrelation": round(correlation(ref_crop, cand_crop), 6),
        }
    return metrics


def make_contact(metrics: dict[str, dict[str, Any]]) -> None:
    ref = image(REFERENCE).resize((1680, 720), Image.Resampling.LANCZOS)
    cand = resize_to_ref(image(CANDIDATE), ref)
    diff = ImageChops.difference(ref, cand)
    heat = diff.convert("L").point(lambda px: min(255, px * 3)).convert("RGB")
    panels = [
        ("reference", ref),
        ("ui128 old-root candidate", cand),
        ("diff heat x3", heat),
    ]
    width, height = 560, 240
    contact = Image.new("RGB", (width * len(panels), height), (0, 0, 0))
    for idx, (label, panel_img) in enumerate(panels):
        panel = panel_img.resize((width, height), Image.Resampling.LANCZOS)
        draw = ImageDraw.Draw(panel)
        draw.rectangle((0, 0, width, 26), fill=(0, 0, 0))
        draw.text((8, 7), label, fill=(255, 255, 255))
        if idx == 2:
            draw.text((8, 31), f"full corr {metrics['full']['pixelCorrelation']} / MAD {metrics['full']['meanAbsDiff']}", fill=(255, 255, 255))
        contact.paste(panel, (width * idx, 0))
    OUT_CONTACT.parent.mkdir(parents=True, exist_ok=True)
    contact.save(OUT_CONTACT)


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fields: list[str] = []
    for row in rows:
        for key in row:
            if key not in fields:
                fields.append(key)
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def metric_text(metrics: dict[str, dict[str, Any]], region: str) -> str:
    m = metrics[region]
    return f"corr={m['pixelCorrelation']}; meanAbsDiff={m['meanAbsDiff']}; changed30={m['changedPixelRatio30']}"


def matrix_rows(metrics: dict[str, dict[str, Any]]) -> list[dict[str, Any]]:
    rows = [
        {
            "item": "activity stack count/position/icons/text",
            "region": "right_activity_stack",
            "referenceObservation": "Reference shows a compact right/top activity cluster with a small set of localized icons.",
            "candidateObservation": "Candidate shows many circular placeholder activity buttons and repeated placeholder text across upper/right screen.",
            "diffMetric": metric_text(metrics, "right_activity_stack"),
            "classification": "requires_runtime_snapshot",
            "rootCause": "UI_MainPage wraps btn_act_1..8, but refreshMainAct disables all and enables only ActMgr:GetActInMain runtime results. UI130 has no activitys/player/redpoint/callback snapshot.",
            "sourceEvidence": "UI128 GetActInMain/GetAllActInfo/IsActShowInMain evidence; UI129 canDriveGetActInMain=0; UI130 replay blocked_missing_runtime_snapshot_fields.",
            "patchDecision": "No scene patch. Do not hide, relabel, or replace activity slots without UI130 replay success.",
            "allowedWithoutSnapshot": "false",
            "nextAction": "Import real activitys/playerInfo/redPoint/client callback snapshot and rerun UI130 replayer.",
            "guardrail": "node_act_btn/btn_act_* arbitrary hide forbidden",
        },
        {
            "item": "face activity row",
            "region": "right_icon_chat",
            "referenceObservation": "Reference has event/social/right-side activity icons integrated with chat and right controls.",
            "candidateObservation": "Candidate keeps placeholder/incorrect face/activity elements; no source-backed face activity ids.",
            "diffMetric": metric_text(metrics, "right_icon_chat"),
            "classification": "requires_runtime_snapshot",
            "rootCause": "UI_MainPage face wrappers btn_face_item_1..7 are enabled by ActMgr:GetActInMainFace; UI130 added faceActivitys but template is empty and blocked.",
            "sourceEvidence": "UI128 face_activity_slots and UI_MainPageFaceActItem:Refresh evidence; UI130 missing faceActivitys.",
            "patchDecision": "No face activity hide/text/icon/spine patch.",
            "allowedWithoutSnapshot": "false",
            "nextAction": "Capture/construct faceActivitys runtime snapshot, then replay.",
            "guardrail": "fake face activity labels/icons forbidden",
        },
        {
            "item": "right icon cluster non-activity buttons",
            "region": "right_icon_chat",
            "referenceObservation": "Reference right cluster includes social/friend/mail/rank/shop-style controls and event entries in coherent layers.",
            "candidateObservation": "Candidate has some old-root controls closer to reference, but activity placeholders occlude/shift the cluster.",
            "diffMetric": metric_text(metrics, "right_icon_chat"),
            "classification": "needs_unity_runtime_probe",
            "rootCause": "Some buttons are static old-root prefab nodes, but their final sibling/canvas/raycast relationship is obscured by unresolved runtime activity layer.",
            "sourceEvidence": "UI126 old-root closer to reference; UI128 btn_discord blocked by btn_act_12 top graphic.",
            "patchDecision": "Candidate plan only: after activity replay, probe sibling/canvas order for non-activity right controls. Do not use review hide.",
            "allowedWithoutSnapshot": "conditional_probe_only",
            "nextAction": "Unity runtime probe of old-root right cluster after UI130 snapshot replay gives authoritative activity layer.",
            "guardrail": "btn_discord review hide forbidden",
        },
        {
            "item": "bottom navigation",
            "region": "bottom_nav",
            "referenceObservation": "Reference bottom nav has a pink/white base strip and seven localized icon buttons.",
            "candidateObservation": "Candidate bottom nav is incomplete/occluded; some labels/icons are present but not in final reference layout.",
            "diffMetric": metric_text(metrics, "bottom_nav"),
            "classification": "needs_unity_runtime_probe",
            "rootCause": "Bottom buttons are likely static old-root prefab nodes, but current candidate lacks final layer/order/background strip behavior.",
            "sourceEvidence": "Old-root candidate improved global correlation; TMP/static font evidence exists, but no final sibling/canvas/order proof for bottom strip.",
            "patchDecision": "No patch in UI131. Candidate plan: probe old-root bottom node active state, Animator binding, and Canvas order before static patch.",
            "allowedWithoutSnapshot": "probe_only",
            "nextAction": "Unity hierarchy/Animator/runtime probe for bottom nav nodes and static sprite bindings.",
            "guardrail": "coordinate-only nav alignment forbidden",
        },
        {
            "item": "chat bubble and chat text",
            "region": "chat_bubble",
            "referenceObservation": "Reference shows populated chat/social bubble with player names and messages.",
            "candidateObservation": "Candidate shows placeholder chat card/text such as dfadsfadsf and non-reference bubble content.",
            "diffMetric": metric_text(metrics, "chat_bubble"),
            "classification": "requires_runtime_snapshot",
            "rootCause": "Chat content/player names/server messages are runtime data; static prefab placeholder text is not authoritative.",
            "sourceEvidence": "UI129 runtime/account/server snapshot search found no usable account/chat snapshot; TMP evidence only gives material/font binding.",
            "patchDecision": "No fake chat text patch. Static bubble layout can be probed separately, but text remains runtime.",
            "allowedWithoutSnapshot": "false_for_text",
            "nextAction": "Find chat/account/message runtime snapshot or log if visual text must match.",
            "guardrail": "fake text forbidden",
        },
        {
            "item": "top profile/currencies",
            "region": "top_bar",
            "referenceObservation": "Reference has profile level/name/power and currency amounts filled with localized/numeric text.",
            "candidateObservation": "Candidate has garbled/blank/placeholder top values and mismatched icon layering.",
            "diffMetric": metric_text(metrics, "top_bar"),
            "classification": "requires_runtime_snapshot",
            "rootCause": "Player level/name/power/currency values need PlayerMgr/account/resource snapshot; static font evidence does not provide values.",
            "sourceEvidence": "UI129 found no PlayerMgr.PlayerInfo/account snapshot; UI130 requires playerInfo level/vip and runtime fields.",
            "patchDecision": "No fake value patch. Font/material binding may be patched only after text nodes are source-identified.",
            "allowedWithoutSnapshot": "false_for_values",
            "nextAction": "Obtain player/account/currency snapshot or authoritative replay log.",
            "guardrail": "fake HUD numbers forbidden",
        },
        {
            "item": "hero1005 spine/background",
            "region": "center_hero_background",
            "referenceObservation": "Reference and candidate both use the night/moon room background and Hero1005, but framing/opacity/layer fit still differs.",
            "candidateObservation": "Candidate has real Hero1005 SkeletonGraphic and BG1005 but larger/overlaid differently than reference.",
            "diffMetric": metric_text(metrics, "center_hero_background"),
            "classification": "needs_unity_runtime_probe",
            "rootCause": "Hero mount is source-backed, but homePara transform semantics, SkeletonGraphic material/alpha, and old-root sibling/canvas order still need runtime/prefab proof.",
            "sourceEvidence": "UI124 Hero1005 real Spine mount; UI127 BG1005 source-backed candidate; UI128 no new visual patch.",
            "patchDecision": "Candidate plan only: probe UIUtil.GetPlayerBigSpineAll homePara transform and SkeletonGraphic canvas/material settings. No coordinate-only patch.",
            "allowedWithoutSnapshot": "probe_only",
            "nextAction": "Unity/prefab probe for homePara scale/position and SkeletonGraphic layer/material against Painting_1005 prefab evidence.",
            "guardrail": "Painting_1005 whole image paste forbidden",
        },
        {
            "item": "text/TMP/font material",
            "region": "full",
            "referenceObservation": "Reference Korean labels render cleanly with original font/material styling.",
            "candidateObservation": "Candidate contains garbled, placeholder, or oversized text in several UI clusters.",
            "diffMetric": metric_text(metrics, "full"),
            "classification": "source_backed_static_patch_possible",
            "rootCause": "Original TMP material/font assets and DTLangCommon static mappings are available, but visible runtime label keys still depend on activity/account/chat data.",
            "sourceEvidence": "UI129 DTLangCommon maps activityname_1004..1008 and Funtionname_10025/10056; maininterface_tmp_shared_materials.csv maps riyu/EPM materials to original objects.",
            "patchDecision": "Patch plan only: audit/apply original TMP material/font binding for static labels already source-identified. Do not set dynamic labels.",
            "allowedWithoutSnapshot": "true_for_static_binding_only",
            "nextAction": "Build a static TMP material binding candidate for known static labels, with before/after text metrics and no invented strings.",
            "guardrail": "visible dynamic labels cannot be invented",
        },
        {
            "item": "UI_bg click blocker",
            "region": "click_blocker_ui_bg_touch",
            "referenceObservation": "Reference expects hero/background touch area behavior, not necessarily background button click-through.",
            "candidateObservation": "UI128 click validation reports UI_bg blocked by UI_touchSpine top object.",
            "diffMetric": metric_text(metrics, "click_blocker_ui_bg_touch"),
            "classification": "already_matches_or_low_priority",
            "rootCause": "UI_touchSpine is explicitly activated in normal home branch; no evidence runtime disables UI_bg Button/raycast.",
            "sourceEvidence": "UI128 UI_bg click blocker evidence and UI_touchSpine SetActive evidence.",
            "patchDecision": "No patch. Treat as diagnosed and lower priority unless later click target requirements prove otherwise.",
            "allowedWithoutSnapshot": "false",
            "nextAction": "Keep as known click diagnostic; do not disable UI_bg raycast without source evidence.",
            "guardrail": "UI_bg raycast-off forbidden",
        },
        {
            "item": "btn_discord click blocker",
            "region": "click_blocker_btn_discord",
            "referenceObservation": "Reference right-side social buttons should be clickable when visible.",
            "candidateObservation": "btn_discord center is blocked by right/node_act_btn/btn_act_12/btn_act top graphic.",
            "diffMetric": metric_text(metrics, "click_blocker_btn_discord"),
            "classification": "source_backed_static_patch_not_allowed_by_guardrail",
            "rootCause": "The only found hide evidence for btn_discord is review branch, while blocker is caused by unresolved activity layer. Hiding activity slot or discord would violate current guardrails.",
            "sourceEvidence": "UI128 btn_discord evidence; review branch hides several normal-home elements and is not reference state.",
            "patchDecision": "No patch until activity runtime replay clarifies btn_act_12 active/layer state.",
            "allowedWithoutSnapshot": "false",
            "nextAction": "Resolve activity layer through UI130 snapshot, then re-run click validation.",
            "guardrail": "btn_discord review hide and node_act_btn arbitrary hide forbidden",
        },
        {
            "item": "zhuye_di1/zhuye_bian and route/world guardrail nodes",
            "region": "left_lobby",
            "referenceObservation": "Reference includes original home/lobby decorative framing and route/world state must not be guessed.",
            "candidateObservation": "Some old route/world/decoration nodes remain unresolved from previous work.",
            "diffMetric": metric_text(metrics, "left_lobby"),
            "classification": "source_backed_static_patch_not_allowed_by_guardrail",
            "rootCause": "UI121 confirmed zhuye_di1/zhuye_bian as pre-clipping attachments; right/node_middle/wanfaWorldNode/worldwanfaBtn hide remains unsupported.",
            "sourceEvidence": "Prior guardrail carried through UI128/UI129/UI130.",
            "patchDecision": "No hide patch. Only source-backed runtime active/sibling/canvas evidence can change them.",
            "allowedWithoutSnapshot": "false",
            "nextAction": "Keep guardrail in next handoff; search only source-backed Animator/Lua/runtime evidence.",
            "guardrail": "zhuye_di1/zhuye_bian/right node/route-world arbitrary hide forbidden",
        },
    ]
    return rows


def command_policy() -> dict[str, Any]:
    root_cmd = list(BASE.glob("*.cmd"))
    direct_tools_cmd = list((BASE / "_restore_tools").glob("*.cmd"))
    return {
        "rootCmdCount": len(root_cmd),
        "rootCmdFiles": [str(path) for path in root_cmd],
        "restoreToolsDirectCmdCount": len(direct_tools_cmd),
        "restoreToolsDirectCmdFiles": [str(path) for path in direct_tools_cmd],
    }


def write_reports(metrics: dict[str, dict[str, Any]], rows: list[dict[str, Any]]) -> None:
    write_csv(OUT_MATRIX, rows)
    counts = Counter(row["classification"] for row in rows)
    command = command_policy()
    static_possible = [row for row in rows if row["classification"] == "source_backed_static_patch_possible"]
    probe_needed = [row for row in rows if row["classification"] == "needs_unity_runtime_probe"]
    blocked = [row for row in rows if row["classification"] in {"requires_runtime_snapshot", "source_backed_static_patch_not_allowed_by_guardrail"}]
    result = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "candidatePatchApplied": False,
        "scenePatchApplied": False,
        "reference": str(REFERENCE),
        "candidate": str(CANDIDATE),
        "contact": str(OUT_CONTACT),
        "matrixCsv": str(OUT_MATRIX),
        "patchPlanMd": str(OUT_PATCH_PLAN),
        "regionMetrics": metrics,
        "classificationCounts": dict(counts),
        "staticPatchPossibleItems": [row["item"] for row in static_possible],
        "unityProbeNeededItems": [row["item"] for row in probe_needed],
        "blockedOrGuardedItems": [row["item"] for row in blocked],
        "commandPolicy": command,
        "inputs": {
            "ui128Result": str(UI128_RESULT),
            "ui128ActivityCsv": str(UI128_ACTIVITY),
            "ui128EvidenceCsv": str(UI128_EVIDENCE),
            "ui129Result": str(UI129_RESULT),
            "ui130Result": str(UI130_RESULT),
        },
    }
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    def lines_for(classification: str) -> str:
        selected = [row for row in rows if row["classification"] == classification]
        return "\n".join(f"- `{row['item']}`: {row['patchDecision']}" for row in selected) or "- none"

    metrics_lines = "\n".join(
        f"- `{name}`: corr `{m['pixelCorrelation']}`, meanAbsDiff `{m['meanAbsDiff']}`, changed30 `{m['changedPixelRatio30']}`"
        for name, m in metrics.items()
        if name in ["full", "top_bar", "right_activity_stack", "chat_bubble", "bottom_nav", "center_hero_background"]
    )
    count_lines = "\n".join(f"- `{key}`: `{value}`" for key, value in sorted(counts.items()))
    md = f"""# {OUT_PREFIX}_RESULT

## Verdict

`restoredClaim=false`. UI131 applied no scene patch. It decomposed the reference-vs-UI128 candidate mismatch into a root-cause matrix and identified only one snapshot-free static patch lane: TMP/font material binding for already source-identified static labels.

## Diff Summary

{metrics_lines}

Contact sheet: `{OUT_CONTACT}`

## Classification Counts

{count_lines}

## Requires Runtime Snapshot

{lines_for('requires_runtime_snapshot')}

## Static Patch Possible Without Snapshot

{lines_for('source_backed_static_patch_possible')}

This is candidate-plan only. It does not permit activity slot hide/label/icon/spine edits, chat text, top currency values, or fake HUD strings.

## Needs Unity Runtime Probe

{lines_for('needs_unity_runtime_probe')}

## Guardrail-Blocked Static Patch

{lines_for('source_backed_static_patch_not_allowed_by_guardrail')}

## Low Priority / Already Diagnosed

{lines_for('already_matches_or_low_priority')}

## Outputs

- matrix CSV: `{OUT_MATRIX}`
- result JSON: `{OUT_JSON}`
- patch plan MD: `{OUT_PATCH_PLAN}`
- contact PNG: `{OUT_CONTACT}`

## Command Policy

- root `.cmd` count: `{command['rootCmdCount']}`
- `_restore_tools` direct `.cmd` count: `{command['restoreToolsDirectCmdCount']}`
"""
    OUT_MD.write_text(md, encoding="utf-8")

    plan = f"""# MAININTERFACE_131 Source-Backed Static Patch Plan (No Scene Patch Applied)

## Allowed Candidate Lane

Only `text/TMP/font material` is classified as `source_backed_static_patch_possible`, and only for static labels whose original text node and material binding are already source-identified.

## Required Before Any Patch

- Build a node-level list of static text objects, excluding activity slots, chat/runtime names/messages, player/account/currency values, and any server-driven label.
- Join those nodes to `maininterface_tmp_shared_materials.csv` and DTLangCommon/static Lua evidence.
- Run a candidate-only scene after material binding, then capture/diff/click validate.

## Explicitly Not Allowed

- Activity slot hide/label/icon/spine changes before UI130 snapshot replay succeeds.
- `btn_discord` review hide.
- `UI_bg` raycast/interactable off.
- Fake chat/top currency/player/account text.
- Coordinate-only bottom nav/hero alignment.
- Screenshot or whole-atlas paste.

No UI131 scene patch was applied.
"""
    OUT_PATCH_PLAN.write_text(plan, encoding="utf-8")


def main() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    metrics = region_metrics()
    make_contact(metrics)
    rows = matrix_rows(metrics)
    write_reports(metrics, rows)


if __name__ == "__main__":
    main()
