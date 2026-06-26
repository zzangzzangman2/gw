#!/usr/bin/env python3
from __future__ import annotations

import csv
import json
import re
from datetime import datetime
from pathlib import Path
from typing import Any


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = ROOT / "girlswar_maininterface_unity"
REPORT_DIR = ROOT / "reports" / "maininterface"
RESTORE = PROJECT / "Assets" / "RestoreData"
RESTORE_REPORTS = RESTORE / "reports"
XLUA = ROOT / "girlswar_merged_extracted" / "decoded" / "xlua"
IL2CPP = ROOT / "girlswar_merged_extracted" / "extracted" / "il2cpp_dump"

TASK = "MAININTERFACE_137_TRACE_PRODUCTION_FORM_LAYER_ORDER_AND_ACTIVITY_ACCOUNT_CHAT_RUNTIME_STATE_NO_FAKE_PATCH"
RESULT_MD = REPORT_DIR / f"{TASK}_RESULT.md"
RESULT_JSON = REPORT_DIR / f"{TASK}_RESULT.json"
FORM_CSV = REPORT_DIR / "MAININTERFACE_137_production_form_layer_order_open_stack_evidence.csv"
STATE_CSV = REPORT_DIR / "MAININTERFACE_137_activity_account_chat_runtime_state_decision_matrix.csv"
LAYER_CSV = REPORT_DIR / "MAININTERFACE_137_mask_stencil_canvas_sorting_animator_evidence.csv"

UI_MAIN = XLUA / "-6351603197391775840_UI_MainPage_security_xor_raw.lua"
UI_DOCK = XLUA / "-4615102950863731052_UI_Dock_security_xor_raw.lua"
DT_FORM = ROOT / "girlswar_merged_extracted" / "extracted" / "unity" / "bundles" / "b_118e2d32692e66cc" / "textassets" / "7179387777078280832_DTSysUIFormEntityTableData.txt"
UI136_JSON = REPORT_DIR / "MAININTERFACE_136_TRACE_UIDOCK_OPEN_STACK_BOTTOM_NAV_CANDIDATE_NO_BACK_LAYER_PROMOTION_RESULT.json"
UI136_SCENE = REPORT_DIR / "MAININTERFACE_136_uidock_candidate_scene_probe.csv"
UI136_METRICS = REPORT_DIR / "MAININTERFACE_136_bottom_nav_region_metrics.csv"
UI129_MD = REPORT_DIR / "MAININTERFACE_129_TRACE_RUNTIME_ACCOUNT_ACTIVITY_SNAPSHOT_LOCALIZATION_FONT_BINDING_RESULT.md"
UI130_JSON = REPORT_DIR / "MAININTERFACE_130_RUNTIME_ACTIVITY_SNAPSHOT_IMPORT_REPLAY_PIPELINE_NO_FAKE_PATCH_RESULT.json"


def read_lines(path: Path) -> list[str]:
    return path.read_text(encoding="utf-8-sig", errors="replace").splitlines()


def snippet(path: Path, start: int, end: int) -> str:
    lines = read_lines(path)
    parts = []
    for idx in range(start, min(end, len(lines)) + 1):
        parts.append(f"L{idx}:{lines[idx - 1]}")
    return " | ".join(parts)


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for row in rows:
            writer.writerow({field: row.get(field, "") for field in fields})


def read_json(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def command_policy() -> dict[str, Any]:
    root_cmd = len(list(ROOT.glob("*.cmd")))
    direct_cmd = len(list((ROOT / "_restore_tools").glob("*.cmd")))
    return {
        "rootCmdCount": root_cmd,
        "restoreToolsDirectCmdCount": direct_cmd,
        "policyOk": root_cmd == 1 and direct_cmd == 0,
    }


def find_line(path: Path, pattern: str) -> list[int]:
    regex = re.compile(pattern)
    hits = []
    for i, line in enumerate(read_lines(path), 1):
        if regex.search(line):
            hits.append(i)
    return hits


def dt_form_rows() -> list[dict[str, Any]]:
    rows = []
    if not DT_FORM.exists():
        return rows
    for line_no, line in enumerate(read_lines(DT_FORM), 1):
        if "UI_Dock" not in line and "UI_MainPage" not in line:
            continue
        inner = line.strip()
        if inner.startswith("{") and inner.endswith("},"):
            inner = inner[1:-2]
        elif inner.startswith("{") and inner.endswith("}"):
            inner = inner[1:-1]
        try:
            parsed = next(csv.reader([inner]))
        except Exception:
            parsed = []
        form_id = parsed[0] if len(parsed) > 0 else ""
        cn_name = parsed[1] if len(parsed) > 1 else ""
        form_name = parsed[2] if len(parsed) > 2 else ""
        module = parsed[16] if len(parsed) > 16 else ""
        flags = "|".join(parsed[3:6]) if len(parsed) >= 6 else ""
        prefab = parsed[6] if len(parsed) > 6 else ""
        rows.append(
            {
                "evidence_kind": "DTSysUIFormEntityTableData",
                "source": str(DT_FORM),
                "line": line_no,
                "target": form_name,
                "form_id": form_id,
                "module": module,
                "raw_flags_3_5": flags,
                "path_or_symbol": prefab,
                "snippet": line,
                "interpretation": "form is source-backed; raw flag semantics are not fully decoded, so this table alone is not sufficient to derive final canvas/sorting order",
                "patch_decision": "trace_only_no_patch",
            }
        )
    return rows


def collect_il2cpp_refs() -> list[dict[str, Any]]:
    wanted = [
        ("script_method", "YouYouUIManager.OpenUIForm", "YouYouYouYouUIManagerWrap._m_OpenUIForm"),
        ("script_method", "YouYouUIManager.CloseUIForm", "YouYouYouYouUIManagerWrap._m_CloseUIForm"),
        ("script_method", "YouYouUIManager.ShowUIForm", "YouYouYouYouUIManagerWrap._m_ShowUIForm"),
        ("script_method", "YouYouUIManager.HideUIForm", "YouYouYouYouUIManagerWrap._m_HideUIForm"),
        ("script_method", "YouYouUIManager.GetUIGroup", "YouYouYouYouUIManagerWrap._m_GetUIGroup"),
        ("script_method", "YouYouUIManager.NormalFormCanvasScaler", "YouYouYouYouUIManagerWrap._m_NormalFormCanvasScaler"),
        ("script_method", "YouYouUIManager.FullFormCanvasScaler", "YouYouYouYouUIManagerWrap._m_FullFormCanvasScaler"),
        ("script_method", "YouYouCanvasHelper.SetDepth", "YouYouYouYouCanvasHelperWrap._m_SetDepth"),
        ("script_method", "YouYouCanvasHelper.ResetRenderDepth", "YouYouYouYouCanvasHelperWrap._m_ResetRenderDepth"),
        ("script_method", "YouYouCanvasHelper.OnDepthChanged", "YouYouYouYouCanvasHelperWrap._m_OnDepthChanged"),
        ("script_method", "YouYouCanvasHelper.OnOpenHandler", "YouYouYouYouCanvasHelperWrap._m_OnOpenHandler"),
    ]
    rows: list[dict[str, Any]] = []
    script = IL2CPP / "script.json"
    if not script.exists():
        return rows
    seen: set[str] = set()
    with script.open("r", encoding="utf-8", errors="replace") as f:
        for line_no, line in enumerate(f, 1):
            for kind, target, needle in wanted:
                if needle in line and target not in seen:
                    seen.add(target)
                    rows.append(
                        {
                            "evidence_kind": kind,
                            "source": str(script),
                            "line": line_no,
                            "target": target,
                            "form_id": "",
                            "module": "IL2CPP",
                            "raw_flags_3_5": "",
                            "path_or_symbol": needle,
                            "snippet": line.strip(),
                            "interpretation": "native UI manager/canvas helper methods exist; UI136 direct GameObject copy does not execute these runtime paths",
                            "patch_decision": "needs_runtime_ui_manager_probe",
                        }
                    )
                    break
            if len(seen) == len(wanted):
                break
    return rows


def form_evidence() -> list[dict[str, Any]]:
    rows = []
    rows.extend(dt_form_rows())
    rows.extend(
        [
            {
                "evidence_kind": "decoded_lua",
                "source": str(UI_DOCK),
                "line": "44-80",
                "target": "UI_Dock.OnOpen",
                "form_id": "UIFormId.UI_Dock",
                "module": "MainInterface",
                "raw_flags_3_5": "",
                "path_or_symbol": "OnOpen/default MAIN_PAGE/initEnterTab",
                "snippet": snippet(UI_DOCK, 44, 80),
                "interpretation": "UI_Dock is opened through its Lua lifecycle, event listeners, default tab, CheckBagTip/RefreshRedPoint; direct sibling copy only approximates a subset",
                "patch_decision": "trace_only_no_patch",
            },
            {
                "evidence_kind": "decoded_lua",
                "source": str(UI_DOCK),
                "line": "138-149",
                "target": "UI_Dock.initTab",
                "form_id": "UIFormId.UI_Dock",
                "module": "MainInterface",
                "raw_flags_3_5": "",
                "path_or_symbol": "DOCK_TYPE on/off + UISpineCtr PlayAnimation",
                "snippet": snippet(UI_DOCK, 138, 149),
                "interpretation": "UI136 now applies the on/off active state, but source-built scene lacks real UISpineCtr/SkeletonGraphic on sp_* rows, so animation/material runtime remains missing",
                "patch_decision": "blocked_no_patch_missing_runtime_spine_component",
            },
            {
                "evidence_kind": "decoded_lua",
                "source": str(UI_DOCK),
                "line": "250-286",
                "target": "UI_Dock.setCurrView",
                "form_id": "UIFormId.UI_Dock",
                "module": "MainInterface",
                "raw_flags_3_5": "",
                "path_or_symbol": "OpenUIForm(UI_MainPage)",
                "snippet": snippet(UI_DOCK, 250, 286),
                "interpretation": "production stack opens current view through GameEntry.UI after closing enabled layer views; direct old-root+UI_Dock copy does not exercise this UIManager stack",
                "patch_decision": "needs_runtime_ui_manager_probe",
            },
            {
                "evidence_kind": "decoded_lua",
                "source": str(UI_MAIN),
                "line": "223-310",
                "target": "UI_MainPage.OnOpen",
                "form_id": "UIFormId.UI_MainPage",
                "module": "MainInterface",
                "raw_flags_3_5": "",
                "path_or_symbol": "OnOpen refresh + UI_MainInterface_in",
                "snippet": snippet(UI_MAIN, 223, 310),
                "interpretation": "UI_MainPage refreshes runtime data and plays UI_MainInterface_in/idle; UI128 candidate does not reproduce all runtime data and UI136 should not promote a visual-only composite",
                "patch_decision": "trace_only_no_patch",
            },
            {
                "evidence_kind": "decoded_lua",
                "source": str(UI_DOCK),
                "line": "575-580",
                "target": "UI_Dock.Animator",
                "form_id": "UIFormId.UI_Dock",
                "module": "MainInterface",
                "raw_flags_3_5": "",
                "path_or_symbol": "UI_Dock_in/out",
                "snippet": snippet(UI_DOCK, 575, 580),
                "interpretation": "Dock has a separate show/hide animator lane; UI136 static capture does not prove correct animation state, mask, or final anchored layout",
                "patch_decision": "needs_unity_runtime_probe_no_scene_patch",
            },
        ]
    )
    rows.extend(collect_il2cpp_refs())
    ui136 = read_json(UI136_JSON)
    metrics = ui136.get("metricResult", {}).get("metrics", {})
    rows.append(
        {
            "evidence_kind": "ui136_metric",
            "source": str(UI136_JSON),
            "line": "",
            "target": "UI_Dock sibling candidate",
            "form_id": "",
            "module": "MainInterface",
            "raw_flags_3_5": "",
            "path_or_symbol": "reference_vs_ui128/ui136 bottom_nav",
            "snippet": f"UI128 bottom_nav corr={metrics.get('reference_vs_ui128:bottom_nav', {}).get('pixelCorrelation')}; UI136 bottom_nav corr={metrics.get('reference_vs_ui136:bottom_nav', {}).get('pixelCorrelation')}",
            "interpretation": "source-built sibling mount is empirically worse and must not be promoted",
            "patch_decision": "do_not_promote_ui136_uidock_sibling",
        }
    )
    return rows


def state_matrix() -> list[dict[str, Any]]:
    rows = [
        {
            "item": "main activity slots node_act_btn/btn_act_1..8",
            "source": str(UI_MAIN),
            "line_or_range": "1021-1046",
            "evidence": snippet(UI_MAIN, 1021, 1046),
            "runtime_dependencies": "ActMgr:GetActInMain(); ActMgr.activitys; server show/open state; player level/vip; redpoint/client callbacks",
            "classification": "requires_runtime_snapshot",
            "patch_decision": "no_patch_no_hide_no_label_icon_spine_change",
        },
        {
            "item": "face activity btn_face_item_1..7 and faceGiftNode",
            "source": str(UI_MAIN),
            "line_or_range": "1047-1108",
            "evidence": snippet(UI_MAIN, 1047, 1108),
            "runtime_dependencies": "ActMgr:GetActInMainFace(); FaceGiftManager active gift; server timestamps; localized name/icon",
            "classification": "requires_runtime_snapshot",
            "patch_decision": "no_patch_no_hide_no_label_icon_spine_change",
        },
        {
            "item": "chat bubble/list text",
            "source": str(UI_MAIN),
            "line_or_range": "2360-2402",
            "evidence": snippet(UI_MAIN, 2360, 2402),
            "runtime_dependencies": "ChatMgr.LastChatType; ChatMgr:getMsgListByType; PlayerMgr.PlayerInfo.guildId; private chat peer payload",
            "classification": "requires_runtime_snapshot",
            "patch_decision": "no_fake_chat_text_patch",
        },
        {
            "item": "top profile/level/vip/name/fight/officer",
            "source": str(UI_MAIN),
            "line_or_range": "1148-1173",
            "evidence": snippet(UI_MAIN, 1148, 1173),
            "runtime_dependencies": "PlayerMgr.PlayerInfo head/headFrame/level/name/vip/officer; FormationManager; BagManager EXP",
            "classification": "requires_runtime_snapshot",
            "patch_decision": "no_fake_account_value_patch",
        },
        {
            "item": "gold/holy currency values and icons",
            "source": str(UI_MAIN),
            "line_or_range": "1299-1322",
            "evidence": snippet(UI_MAIN, 1299, 1322),
            "runtime_dependencies": "BagManager currency counts/base info; currency item icon data",
            "classification": "requires_runtime_snapshot",
            "patch_decision": "no_fake_currency_patch",
        },
        {
            "item": "btn_discord",
            "source": str(UI_MAIN),
            "line_or_range": "115-126,153-155",
            "evidence": snippet(UI_MAIN, 115, 126) + " | " + snippet(UI_MAIN, 153, 155),
            "runtime_dependencies": "GameTools:IsReview() review branch",
            "classification": "source_backed_static_patch_not_allowed_by_guardrail",
            "patch_decision": "no_review_hide_patch",
        },
        {
            "item": "right non-activity buttons shop/mail/friends/rank/task",
            "source": str(UI_MAIN),
            "line_or_range": "1122-1138",
            "evidence": snippet(UI_MAIN, 1122, 1138),
            "runtime_dependencies": "GameTools:IsReview(); GameEntry.IsCommittee; GameFunction unlock state",
            "classification": "requires_runtime_snapshot_or_review_function_state",
            "patch_decision": "no_hide_without_snapshot",
        },
        {
            "item": "UI_bg raycast/interactable",
            "source": str(UI136_JSON),
            "line_or_range": "uiBgGuardrail",
            "evidence": json.dumps(read_json(UI136_JSON).get("uiBgGuardrail", {}), ensure_ascii=False),
            "runtime_dependencies": "none for UI137; guardrail says preserve",
            "classification": "already_diagnosed_guardrail_preserved",
            "patch_decision": "no_change",
        },
        {
            "item": "route/world nodes and zhuye_di1/zhuye_bian",
            "source": "reports/maininterface/UI121-UI136 guardrails",
            "line_or_range": "",
            "evidence": "No new source-backed SetActive/sibling/canvas evidence found in UI137 that permits hiding these nodes.",
            "runtime_dependencies": "unknown production stack/route state",
            "classification": "source_backed_static_patch_not_allowed_by_guardrail",
            "patch_decision": "no_hide_no_patch",
        },
    ]
    return rows


def layer_evidence() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    scene_rows = read_csv(UI136_SCENE)
    for row in scene_rows:
        cat = row.get("category", "")
        name = row.get("name", "")
        if cat in {"uidock_root", "lua_initTab_default_state", "ui_bg_guardrail"} or name.startswith("sp_") or "mask" in name.lower() or "Canvas" in row.get("componentTypes", ""):
            rows.append(
                {
                    "evidence_kind": "ui136_scene_probe",
                    "source": str(UI136_SCENE),
                    "target": name,
                    "path": row.get("hierarchyPath", ""),
                    "component_types": row.get("componentTypes", ""),
                    "active_state": f"activeSelf={row.get('activeSelf','')}; activeInHierarchy={row.get('activeInHierarchy','')}",
                    "rect_or_canvas": f"anchored={row.get('anchoredPosition','')}; size={row.get('sizeDelta','')}; scale={row.get('localScale','')}; sibling={row.get('siblingIndex','')}",
                    "snippet": row.get("note", ""),
                    "interpretation": "UI136 candidate scene evidence",
                    "patch_decision": "trace_only_no_patch",
                }
            )
    for path, source_label in [
        (RESTORE / "maininterface_canvas_groups.csv", "canvas_group_source"),
        (RESTORE / "maininterface_components.csv", "component_source"),
        (RESTORE_REPORTS / "maininterface_125_animator_home_state_bindings.csv", "animator_binding_source"),
        (RESTORE_REPORTS / "maininterface_visual_gap_evidence.csv", "visual_gap_source"),
    ]:
        if not path.exists():
            continue
        for row in read_csv(path)[:5000]:
            blob = " ".join(str(v) for v in row.values())
            if not re.search(r"UI_Dock|UI_MainInterface_old|Canvas|Mask|RectMask|Animator|UI_Dock_in|UI_Dock_out|sp_mainpage|sp_camp|sp_bag", blob, re.I):
                continue
            rows.append(
                {
                    "evidence_kind": source_label,
                    "source": str(path),
                    "target": row.get("game_object_name") or row.get("target") or row.get("path") or row.get("name") or "",
                    "path": row.get("hierarchy_path") or row.get("path") or row.get("prefab_path") or "",
                    "component_types": row.get("kind") or row.get("componentTypes") or row.get("type") or "",
                    "active_state": row.get("active_self") or row.get("active_chain") or row.get("active_or_state") or "",
                    "rect_or_canvas": json.dumps(row, ensure_ascii=False)[:500],
                    "snippet": row.get("excerpt") or row.get("note") or "",
                    "interpretation": "source artifact confirms component/prefab/animator presence, but not final UIManager canvas depth unless runtime manager path is executed",
                    "patch_decision": "trace_only_no_patch",
                }
            )
            if len(rows) > 300:
                break
    rows.append(
        {
            "evidence_kind": "diagnosis",
            "source": str(UI136_SCENE),
            "target": "UI_Dock sp_*",
            "path": "UI_Dock_OpenStack_UI136/.../sp_mainpage..sp_maincity",
            "component_types": "RectTransform only in source-built candidate; no SkeletonGraphic",
            "active_state": "initTab on/off applied; spine animation not applicable",
            "rect_or_canvas": "",
            "snippet": "UI136 default rows record spineAnimationState=not_applicable_no_skeleton_component",
            "interpretation": "current builder does not reconstruct original UISpineCtr runtime renderer, so Dock visual/animation cannot be promoted from this capture",
            "patch_decision": "blocked_no_patch_missing_uidock_spine_runtime_renderer",
        }
    )
    return rows


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    form_rows = form_evidence()
    state_rows = state_matrix()
    layer_rows = layer_evidence()
    write_csv(
        FORM_CSV,
        form_rows,
        ["evidence_kind", "source", "line", "target", "form_id", "module", "raw_flags_3_5", "path_or_symbol", "snippet", "interpretation", "patch_decision"],
    )
    write_csv(
        STATE_CSV,
        state_rows,
        ["item", "source", "line_or_range", "evidence", "runtime_dependencies", "classification", "patch_decision"],
    )
    write_csv(
        LAYER_CSV,
        layer_rows,
        ["evidence_kind", "source", "target", "path", "component_types", "active_state", "rect_or_canvas", "snippet", "interpretation", "patch_decision"],
    )
    ui136 = read_json(UI136_JSON)
    metrics = ui136.get("metricResult", {}).get("metrics", {})
    policy = command_policy()
    result = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "task": TASK,
        "restoredClaim": False,
        "scenePatchApplied": False,
        "candidatePatchApplied": False,
        "patchDecision": "trace_only_no_patch",
        "uiDockSiblingPromotionAllowed": False,
        "reasonNoPatch": "UI_Dock form/open-stack evidence is strong, but UI136 source-built sibling capture worsened reference metrics and still lacks runtime UIManager canvas depth, form group, animator, mask, and UISpineCtr renderer semantics.",
        "ui136Metrics": {
            "ui128FullCorr": metrics.get("reference_vs_ui128:full", {}).get("pixelCorrelation"),
            "ui136FullCorr": metrics.get("reference_vs_ui136:full", {}).get("pixelCorrelation"),
            "ui128BottomNavCorr": metrics.get("reference_vs_ui128:bottom_nav", {}).get("pixelCorrelation"),
            "ui136BottomNavCorr": metrics.get("reference_vs_ui136:bottom_nav", {}).get("pixelCorrelation"),
        },
        "csvs": {
            "productionFormLayerOrderOpenStack": str(FORM_CSV),
            "activityAccountChatRuntimeStateDecisionMatrix": str(STATE_CSV),
            "maskStencilCanvasSortingAnimatorEvidence": str(LAYER_CSV),
        },
        "rowCounts": {
            "formEvidence": len(form_rows),
            "stateMatrix": len(state_rows),
            "layerEvidence": len(layer_rows),
        },
        "requiredNextEvidence": [
            "runtime UIManager/YouYouCanvasHelper form group/canvas depth dump for UI_Dock and UI_MainPage",
            "runtime UISpineCtr/sp_* renderer reconstruction or original component execution path",
            "real activity/account/chat snapshot accepted by UI130 replay pipeline",
        ],
        "guardrails": {
            "uiBgRaycastInteractableChanged": False,
            "btnDiscordReviewHideApplied": False,
            "activitySlotsHiddenOrFaked": False,
            "painting1005BackCarriedOver": False,
            "routeWorldZhuyeNodesHidden": False,
        },
        "commandPolicy": policy,
    }
    RESULT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    md = [
        "# MAININTERFACE 137 Trace Production Form Layer Order And Runtime State Result",
        "",
        f"Generated: {result['generatedAt']}",
        "",
        "## Verdict",
        "",
        "- restoredClaim: `false`",
        "- patchDecision: `trace_only_no_patch`",
        "- scenePatchApplied: `false`",
        "- candidatePatchApplied: `false`",
        "- UI_Dock sibling promotion: `false`",
        "",
        "## Why No Patch",
        "",
        result["reasonNoPatch"],
        "",
        "## Key Findings",
        "",
        f"- UI_Dock/UI_MainPage are source-backed `DTSysUIForm` rows, but the raw table fields alone do not recover final canvas sorting/group semantics.",
        f"- Decoded `UI_Dock` proves default `DOCK_TYPE.MAIN_PAGE`, `initTab()`, `OpenUIForm(UI_MainPage)`, and `UI_Dock_in/out` animator calls.",
        f"- UI136 already applied default on/off state correctly, but `sp_*` rows in the source-built candidate have no real `SkeletonGraphic`/`UISpineCtr` runtime renderer, so Dock visual state is incomplete.",
        f"- UI136 worsened correlation: full `{result['ui136Metrics']['ui128FullCorr']}` -> `{result['ui136Metrics']['ui136FullCorr']}`, bottom_nav `{result['ui136Metrics']['ui128BottomNavCorr']}` -> `{result['ui136Metrics']['ui136BottomNavCorr']}`.",
        "- Activity, face activity, chat, account/profile, and currency states remain runtime snapshot dependent.",
        "",
        "## Outputs",
        "",
        f"- production form/open-stack CSV: `{FORM_CSV}`",
        f"- activity/account/chat decision matrix CSV: `{STATE_CSV}`",
        f"- mask/stencil/canvas/sorting/animator CSV: `{LAYER_CSV}`",
        f"- result JSON: `{RESULT_JSON}`",
        "",
        "## Guardrails",
        "",
        "- Did not carry UI135 `Painting_1005_back`.",
        "- Did not alter `UI_bg` raycast/interactable.",
        "- Did not hide `btn_discord`, activity slots, route/world nodes, `zhuye_di1`, or `zhuye_bian`.",
        "- Did not create fake panels/icons/text/spines or paste screenshots/whole atlases.",
        "",
        "## Command Policy",
        "",
        f"- root `.cmd` count: `{policy['rootCmdCount']}`",
        f"- `_restore_tools` direct `.cmd` count: `{policy['restoreToolsDirectCmdCount']}`",
        f"- policyOk: `{policy['policyOk']}`",
        "",
        "## Next Blocker",
        "",
        "- Need a runtime UIManager/CanvasHelper form-depth dump or executable original UI stack probe before changing UI_Dock layer/order.",
        "- Need a real UI130-compatible activity/account/chat snapshot before changing activity/chat/top visible state.",
    ]
    RESULT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
