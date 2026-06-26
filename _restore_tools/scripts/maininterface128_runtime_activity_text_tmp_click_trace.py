from __future__ import annotations

import csv
import json
import math
import re
from datetime import datetime
from pathlib import Path

import UnityPy
from PIL import Image, ImageChops, ImageDraw, ImageStat


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
REPORTS = BASE / "reports" / "maininterface"
RESTORE_REPORTS = PROJECT / "Assets" / "RestoreData" / "reports"
REFERENCE = Path(r"C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png")

DATAMGR_BUNDLE = (
    BASE
    / "girlswar_merged_extracted"
    / "extracted"
    / "unity"
    / "clean_unityfs_slices"
    / "download"
    / "xlualogic"
    / "datanode"
    / "datamanager"
    / "datamgr.assetbundle"
)

XLUA_DIR = BASE / "girlswar_merged_extracted" / "decoded" / "xlua"
MAINPAGE = XLUA_DIR / "-6351603197391775840_UI_MainPage_security_xor_raw.lua"
ACTITEM = XLUA_DIR / "-8694572285188909557_UI_MainPageActItem_security_xor_raw.lua"
FACEACTITEM = XLUA_DIR / "-7919191389644174794_UI_MainPageFaceActItem_security_xor_raw.lua"

UI126_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui126_oldroot_hero1005_candidate_1680x720.png"
UI127_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui127_oldroot_bg1005_runtime_candidate_1680x720.png"
UI128_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui128_oldroot_runtime_activity_text_tmp_click_candidate_1680x720.png"

UI126_CLICK_JSON = RESTORE_REPORTS / "maininterface_126_oldroot_click_validation_summary.json"
UI127_CLICK_JSON = RESTORE_REPORTS / "maininterface_127_oldroot_bg1005_click_validation_summary.json"
UI128_CLICK_JSON = RESTORE_REPORTS / "maininterface_128_oldroot_runtime_activity_text_tmp_click_validation_summary.json"
UI128_CLICK_CSV = RESTORE_REPORTS / "maininterface_128_oldroot_runtime_activity_text_tmp_click_validation.csv"

OUT_MD = REPORTS / "MAININTERFACE_128_OLDROOT_RUNTIME_ACTIVITY_TEXT_TMP_AND_CLICK_LAYER_RECONSTRUCTION_RESULT.md"
OUT_JSON = RESTORE_REPORTS / "maininterface_128_oldroot_runtime_activity_text_tmp_click_trace.json"
OUT_EVIDENCE = REPORTS / "MAININTERFACE_128_runtime_activity_text_tmp_click_evidence.csv"
OUT_ACTIVITY = REPORTS / "MAININTERFACE_128_runtime_activity_slot_candidates.csv"
OUT_DIFF = REPORTS / "MAININTERFACE_128_reference_diff_regions.csv"
OUT_CONTACT = REPORTS / "MAININTERFACE_128_REFERENCE_DIFF_CONTACT.png"

XOR_SCALE = bytes.fromhex("2D 42 26 37 17 FE 09 A5 5A 13 29 2D C9 3A 37 25 FE B9 A5 A9 13 AB")

REGIONS = {
    "full": (0, 0, 1680, 720),
    "top_bar": (0, 0, 1680, 110),
    "left_lobby": (0, 100, 430, 640),
    "center_hero": (360, 40, 1180, 690),
    "right_activity_chat": (960, 80, 1680, 720),
    "right_activity_stack": (960, 560, 1500, 720),
    "bottom_nav": (0, 580, 1680, 720),
}


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8-sig", errors="replace")


def decode_datamgr_textassets() -> dict[str, str]:
    decoded: dict[str, str] = {}
    env = UnityPy.load(DATAMGR_BUNDLE.read_bytes())
    for obj in env.objects:
        if obj.type.name != "TextAsset":
            continue
        data = obj.read()
        name = getattr(data, "m_Name", "")
        if name not in {"ActMgr", "ActCfgData"}:
            continue
        payload = getattr(data, "m_Script", b"")
        raw = payload.encode("utf-8", "surrogateescape") if isinstance(payload, str) else bytes(payload)
        out = bytes(byte ^ XOR_SCALE[i % len(XOR_SCALE)] for i, byte in enumerate(raw))
        decoded[name] = out.decode("utf-8", errors="replace")
    return decoded


def snippet(text: str, marker: str, before: int = 240, after: int = 900) -> str:
    idx = text.find(marker)
    if idx < 0:
        return ""
    return " ".join(text[max(0, idx - before) : idx + after].split())


def function_snippet(text: str, marker: str, max_chars: int = 1600) -> str:
    idx = text.find(marker)
    if idx < 0:
        return ""
    return " ".join(text[idx : idx + max_chars].split())


def read_json(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: list[dict], fieldnames: list[str] | None = None) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if not fieldnames:
        fieldnames = list(rows[0].keys()) if rows else ["empty"]
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


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


def diff_rows() -> list[dict]:
    ref = image(REFERENCE).resize((1680, 720), Image.Resampling.LANCZOS)
    rows: list[dict] = []
    captures = [
        ("ui126_old_root_candidate", UI126_CAPTURE),
        ("ui127_oldroot_bg1005_candidate", UI127_CAPTURE),
        ("ui128_oldroot_activity_text_tmp_click_candidate", UI128_CAPTURE),
    ]
    for label, path in captures:
        if not path.exists():
            continue
        cap = resize_to_ref(image(path), ref)
        for region, box in REGIONS.items():
            ref_crop = ref.crop(box)
            cap_crop = cap.crop(box)
            diff = ImageChops.difference(ref_crop, cap_crop)
            stat = ImageStat.Stat(diff)
            mean = sum(stat.mean) / (255.0 * 3.0)
            rms = math.sqrt(sum(value * value for value in stat.rms) / 3.0) / 255.0
            changed = sum(1 for px in diff.getdata() if max(px) >= 30) / float(diff.width * diff.height)
            rows.append(
                {
                    "captureLabel": label,
                    "region": region,
                    "meanAbsDiff": round(mean, 6),
                    "rmsDiff": round(rms, 6),
                    "changedPixelRatio30": round(changed, 6),
                    "pixelCorrelation": round(correlation(ref_crop, cap_crop), 6),
                    "capturePath": str(path),
                }
            )
    return rows


def make_contact() -> None:
    ref = image(REFERENCE).resize((1680, 720), Image.Resampling.LANCZOS)
    panels = []
    for label, path in [
        ("reference", REFERENCE),
        ("UI126 old-root", UI126_CAPTURE),
        ("UI127 BG1005", UI127_CAPTURE),
        ("UI128 trace candidate", UI128_CAPTURE),
    ]:
        if not path.exists():
            continue
        panel = resize_to_ref(image(path), ref).resize((420, 180), Image.Resampling.LANCZOS)
        draw = ImageDraw.Draw(panel)
        draw.rectangle((0, 0, 420, 26), fill=(0, 0, 0))
        draw.text((8, 7), label, fill=(255, 255, 255))
        panels.append(panel)
    if not panels:
        return
    contact = Image.new("RGB", (420 * len(panels), 180), (0, 0, 0))
    for idx, panel in enumerate(panels):
        contact.paste(panel, (420 * idx, 0))
    OUT_CONTACT.parent.mkdir(parents=True, exist_ok=True)
    contact.save(OUT_CONTACT)


def blocked_clicks(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    return [
        row
        for row in rows
        if row.get("activeInHierarchy") == "True"
        and row.get("interactable") == "True"
        and row.get("raycastClickable") == "False"
    ]


def command_policy() -> dict:
    root_cmd = list(BASE.glob("*.cmd"))
    direct_tools_cmd = list((BASE / "_restore_tools").glob("*.cmd"))
    return {
        "rootCmdCount": len(root_cmd),
        "rootCmdFiles": [str(path) for path in root_cmd],
        "restoreToolsDirectCmdCount": len(direct_tools_cmd),
        "restoreToolsDirectCmdFiles": [str(path) for path in direct_tools_cmd],
    }


def activity_rows(act_mgr: str, act_cfg: str) -> list[dict]:
    mainpage = read_text(MAINPAGE)
    actitem = read_text(ACTITEM)
    faceitem = read_text(FACEACTITEM)
    return [
        {
            "topic": "main_activity_slots",
            "source": str(MAINPAGE),
            "evidence": "le table contains btn_act_1 through btn_act_8; InitActBtn creates UI_MainPageActItem wrappers for those p items.",
            "runtimeDecision": "slots_known_but_active_items_unknown",
            "blocker": "Active slot count and act ids require ActMgr:GetActInMain runtime result.",
            "snippet": snippet(mainpage, "local le={", 0, 520),
        },
        {
            "topic": "face_activity_slots",
            "source": str(MAINPAGE),
            "evidence": "ue table contains btn_face_item_1 through btn_face_item_7; refreshFaceAct enables only ActMgr:GetActInMainFace results.",
            "runtimeDecision": "slots_known_but_active_items_unknown",
            "blocker": "Active face activity rows require ActMgr:GetActInMainFace runtime result.",
            "snippet": snippet(mainpage, "local ue={", 0, 520),
        },
        {
            "topic": "GetActInMain",
            "source": str(DATAMGR_BUNDLE),
            "evidence": "ActMgr:GetActInMain builds up to five system groups: charge, recruit, welfare, activity, rally.",
            "runtimeDecision": "server_snapshot_required",
            "blocker": "It starts from ActMgr:GetAllActInfo(true), which iterates ActMgr.activitys from runtime server data.",
            "snippet": function_snippet(act_mgr, "function ActMgr:GetActInMain()", 1600),
        },
        {
            "topic": "IsActShowInMain",
            "source": str(DATAMGR_BUNDLE),
            "evidence": "Show filtering checks review mode, server show flag, IsOpen, player VIP/level, and optional client showInMainFunc.",
            "runtimeDecision": "server_account_snapshot_required",
            "blocker": "Requires ActMgr.activitys, PlayerMgr.PlayerInfo, RedPointMgr, and activity client functions.",
            "snippet": function_snippet(act_mgr, "function ActMgr:IsActShowInMain", 1200),
        },
        {
            "topic": "UI_MainPageActItem Refresh",
            "source": str(ACTITEM),
            "evidence": "Refresh uses actInfo.tbSpine/name, ActCfgData mainPageName/mainPageSpineId overrides, and UIUtil.GetSpinePrefabFromPool.",
            "runtimeDecision": "placeholder_text_not_authoritative",
            "blocker": "Static prefab labels cannot determine final text or icon spine.",
            "snippet": function_snippet(actitem, "function e:Refresh", 1500),
        },
        {
            "topic": "UI_MainPageFaceActItem Refresh",
            "source": str(FACEACTITEM),
            "evidence": "Face activity labels and timers are runtime-updated; some ids show txt_act_leftTime.",
            "runtimeDecision": "placeholder_text_not_authoritative",
            "blocker": "Need runtime act id and manager state to know label/time.",
            "snippet": function_snippet(faceitem, "function e:Refresh", 1600),
        },
        {
            "topic": "ActCfgData mainPage override",
            "source": str(DATAMGR_BUNDLE),
            "evidence": "ActCfgData has mainPageName/mainPageSpineId overrides, e.g. act 414 maps mainPageName activityname_4100 and mainPageSpineId 104140000.",
            "runtimeDecision": "static_override_available_for_selected_act_only",
            "blocker": "The selected activity id still comes from ActMgr runtime/server list.",
            "snippet": snippet(act_cfg, "mainPageSpineId", 900, 1000),
        },
    ]


def evidence_rows(act_mgr: str, act_cfg: str, blocked: list[dict[str, str]]) -> list[dict]:
    mainpage = read_text(MAINPAGE)
    rows = activity_rows(act_mgr, act_cfg)
    rows.extend(
        [
            {
                "topic": "UI_bg click blocker",
                "source": "maininterface_buttons.csv + decoded UI_MainPage + UI128 click validation",
                "evidence": "old-root UI_bg has an original empty Button. Decoded UI_MainPage loads a sprite into UI_bg but no UI_bg AddListener was found. UI_touchSpine is explicitly activated in the normal home branch.",
                "runtimeDecision": "no_click_patch",
                "blocker": "No source-backed evidence found that runtime disables UI_bg Button/raycast; UI_touchSpine top hit is plausible home interaction layer.",
                "snippet": snippet(mainpage, "LuaUtils.SetActive(UI_touchSpine.transform,true)", 250, 450),
            },
            {
                "topic": "btn_discord click blocker",
                "source": "decoded UI_MainPage + UI128 click validation",
                "evidence": "btn_discord has a non-review onClick listener; SetActive(false) is only inside GameTools:IsReview(). UI128 blocker is caused by right/node_act_btn/btn_act_12 top graphic.",
                "runtimeDecision": "no_hide_patch",
                "blocker": "Review branch hide is not valid for reference normal home; activity layer state still needs runtime ActMgr evidence.",
                "snippet": snippet(mainpage, "btn_discord.onClick:AddListener", 450, 350),
            },
            {
                "topic": "review_branch_guardrail",
                "source": str(MAINPAGE),
                "evidence": "GameTools:IsReview() hides btn_qinmi, node_renwu, btn_twitter, btn_discord, btn_beijing, btn_naver, toggle3, mian_wanfa_item_3, and mian_wanfa_item_4 together.",
                "runtimeDecision": "not_reference_state",
                "blocker": "Reference still shows normal home/task/social style elements, so this branch cannot be used as a targeted btn_discord fix.",
                "snippet": snippet(mainpage, "if GameTools:IsReview()then", 0, 650),
            },
            {
                "topic": "active_blocked_clicks",
                "source": str(UI128_CLICK_CSV),
                "evidence": "; ".join(
                    f"{row.get('buttonName')} topped by {row.get('raycastTopObject')}" for row in blocked
                ),
                "runtimeDecision": "diagnosed_no_visual_patch",
                "blocker": "Blocked rows are evidence for unresolved runtime layers, not enough to justify arbitrary sibling/hide/raycast edits.",
                "snippet": "",
            },
            {
                "topic": "guardrails_preserved",
                "source": "UI128 candidate build method",
                "evidence": "Hero1005 SkeletonGraphic and BG1005 candidate are preserved. No hide applied to zhuye_di1, zhuye_bian, right/node_middle, wanfaWorldNode, worldwanfaBtn, route/world nodes, or node_act_btn/btn_act_*.",
                "runtimeDecision": "candidate_only_no_restored_claim",
                "blocker": "Reference mismatch remains unresolved.",
                "snippet": "",
            },
        ]
    )
    return rows


def main() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    RESTORE_REPORTS.mkdir(parents=True, exist_ok=True)

    decoded = decode_datamgr_textassets()
    act_mgr = decoded.get("ActMgr", "")
    act_cfg = decoded.get("ActCfgData", "")
    click_rows = read_csv(UI128_CLICK_CSV)
    blocked = blocked_clicks(click_rows)
    diffs = diff_rows()
    make_contact()

    evidence = evidence_rows(act_mgr, act_cfg, blocked)
    activities = activity_rows(act_mgr, act_cfg)
    write_csv(OUT_EVIDENCE, evidence)
    write_csv(OUT_ACTIVITY, activities)
    write_csv(OUT_DIFF, diffs)

    command = command_policy()
    click126 = read_json(UI126_CLICK_JSON)
    click127 = read_json(UI127_CLICK_JSON)
    click128 = read_json(UI128_CLICK_JSON)
    full_rows = [row for row in diffs if row.get("region") == "full"]

    summary = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "reference": str(REFERENCE),
        "capture": str(UI128_CAPTURE),
        "contact": str(OUT_CONTACT),
        "actMgrDecodedFrom": str(DATAMGR_BUNDLE),
        "actCfgDataDecodedFrom": str(DATAMGR_BUNDLE),
        "evidenceCsv": str(OUT_EVIDENCE),
        "activityCsv": str(OUT_ACTIVITY),
        "diffCsv": str(OUT_DIFF),
        "clickValidationCsv": str(UI128_CLICK_CSV),
        "click126": click126,
        "click127": click127,
        "click128": click128,
        "blockedClicks128": blocked,
        "fullDiffRows": full_rows,
        "commandPolicy": command,
        "candidatePatchApplied": False,
        "candidateCaptureRegenerated": UI128_CAPTURE.exists(),
        "blocker": "ActMgr:GetActInMain/GetActInMainFace require runtime server/account activity state; text/icon/TMP placeholders cannot be resolved from prefab alone.",
    }
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    full_line = ""
    for row in full_rows:
        full_line += (
            f"- {row['captureLabel']}: correlation `{row['pixelCorrelation']}`, "
            f"meanAbsDiff `{row['meanAbsDiff']}`, changed>=30 `{row['changedPixelRatio30']}`\n"
        )

    blocked_lines = "\n".join(
        f"- `{row.get('buttonName')}` top=`{row.get('raycastTopObject')}`"
        for row in blocked
    ) or "- none"

    md = f"""# MAININTERFACE_128_OLDROOT_RUNTIME_ACTIVITY_TEXT_TMP_AND_CLICK_LAYER_RECONSTRUCTION_RESULT

## Verdict

Restored claim remains `false`. UI128 regenerated the old-root candidate capture and click validation, but did not apply a new visual patch because the remaining activity icon/text/TMP state depends on runtime server/account data.

## Runtime Activity Evidence

- `UI_MainPage` defines main activity wrappers for `btn_act_1..btn_act_8`; prefab `btn_act_*` placeholders beyond that are not authoritative normal-home state.
- `refreshMainAct()` first disables all wrapped activity items, then enables only flattened `ActMgr:GetActInMain()` entries.
- `ActMgr:GetActInMain()` selects up to five dynamic system groups: charge `1004`, recruit `1005`, welfare `1006`, activity `1007`, rally `1008`.
- `ActMgr:IsActShowInMain()` depends on `ActMgr.activitys`, server `show`, `IsOpen`, player VIP/level, redpoint/client callbacks, and review state.
- `UI_MainPageActItem:Refresh()` replaces prefab labels with `GameTools.GetLocalize(...)`, `ActCfgData.mainPageName/getActNewName`, and `mainPageSpineId/tbSpine`.

## Click Blockers

UI128 click total/active/clickable/blocked: `{click128.get('totalButtons', '')} / {click128.get('activeButtons', '')} / {click128.get('raycastClickableButtons', '')} / {click128.get('raycastBlockedButtons', '')}`.

{blocked_lines}

`UI_bg` was not changed to raycast/interactable off: it has an original empty Button and no Lua listener found, but no runtime source evidence was found that disables the Button/raycast. `UI_touchSpine` is explicitly active in the normal home branch.

`btn_discord` was not hidden: the only hide evidence remains inside `GameTools:IsReview()`, which also hides normal home/task/social elements and does not match the reference state.

## Diff

{full_line.strip()}

## Command Policy

- root `.cmd` count: `{command['rootCmdCount']}`
- `_restore_tools` direct `.cmd` count: `{command['restoreToolsDirectCmdCount']}`

## Outputs

- capture: `{UI128_CAPTURE}`
- contact: `{OUT_CONTACT}`
- diff CSV: `{OUT_DIFF}`
- evidence CSV: `{OUT_EVIDENCE}`
- activity CSV: `{OUT_ACTIVITY}`
- JSON: `{OUT_JSON}`

## Next Blocker

Need a real runtime/server/account snapshot or replay evidence for `ActMgr.activitys`, `PlayerMgr.PlayerInfo`, redpoint state, and localization/font material binding. Without that, hiding or replacing activity slots/text would be a guess.
"""
    OUT_MD.write_text(md, encoding="utf-8")


if __name__ == "__main__":
    main()
