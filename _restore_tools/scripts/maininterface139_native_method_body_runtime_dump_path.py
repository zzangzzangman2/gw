#!/usr/bin/env python3
from __future__ import annotations

import csv
import hashlib
import json
import re
import shutil
import struct
from datetime import datetime
from pathlib import Path
from typing import Any


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = ROOT / "reports" / "maininterface"
IL2CPP_DUMP = ROOT / "girlswar_merged_extracted" / "extracted" / "il2cpp_dump"
DUMP_CS = IL2CPP_DUMP / "dump.cs"
IL2CPP_H = IL2CPP_DUMP / "il2cpp.h"
SCRIPT_JSON = IL2CPP_DUMP / "script.json"
STRING_JSON = IL2CPP_DUMP / "stringliteral.json"
LIBIL2CPP = ROOT / "il2cpp_native" / "libil2cpp.so"
METADATA = ROOT / "il2cpp_native" / "global-metadata.dat"
ASM_TRACE = ROOT / "il2cpp_native" / "il2cpp_xlua_target_disassembly.asm"
UI136_PROBE = REPORT_DIR / "MAININTERFACE_136_uidock_candidate_scene_probe.csv"
UI138_UIMGR = REPORT_DIR / "MAININTERFACE_138_uimanager_canvashelper_methods_fields_callsites.csv"
UI138_UISPINE = REPORT_DIR / "MAININTERFACE_138_uispinectr_sp_runtime_component_trace.csv"

TASK = "MAININTERFACE_139_NATIVE_METHOD_BODY_OR_RUNTIME_DUMP_PATH_FOR_UI_DEPTH_AND_UISPINECTR_NO_PATCH"
RESULT_MD = REPORT_DIR / f"{TASK}_RESULT.md"
RESULT_JSON = REPORT_DIR / f"{TASK}_RESULT.json"
NATIVE_CSV = REPORT_DIR / "MAININTERFACE_139_native_method_body_rva_symbol_recovery_evidence.csv"
DEPTH_CSV = REPORT_DIR / "MAININTERFACE_139_ui_depth_formula_recovery_decision_matrix.csv"
UISPINE_CSV = REPORT_DIR / "MAININTERFACE_139_uispinectr_runtime_binding_recovery_decision_matrix.csv"
RUNTIME_CSV = REPORT_DIR / "MAININTERFACE_139_approved_runtime_dump_plan_blocker_matrix.csv"

TARGET_CLASSES = {
    "YouYouUIManager",
    "AbstractUIManager",
    "UIManager",
    "UIManager2",
    "UISetActiveManager",
    "UIFormBase",
    "UIGroup",
    "UILayer",
    "UILayerOld",
    "YouYouCanvasHelper",
    "UISpineCtr",
    "YouYouYouYouUIManagerWrap",
    "YouYouYouYouCanvasHelperWrap",
    "YouYouUISpineCtrWrap",
}

TARGET_METHODS = {
    "YouYouUIManager": {
        "Init",
        "GetUIGroup",
        "SetSortingOrder",
        "OpenUIForm",
        "_OpenUIForm",
        "CloseUIForm",
        "_CloseUIForm",
        "ShowUIForm",
        "HideUIForm",
        "NormalFormCanvasScaler",
        "FullFormCanvasScaler",
        "GetLastUILayer",
        "GetLastEnableUILayer",
        "GetLastEnableUILayerByGroupId",
    },
    "AbstractUIManager": {"OpenUIForm", "OpenUI", "CheckAndIsFull", "CloseUIForm", "GetLastUILayer", "GetLastEnableUILayer", "GetLastEnableUILayerByGroupId"},
    "UIManager": {"OpenUIForm", "OpenUI", "OnShowUI", "OnHideUI", "OnCloseUIForm", "YieldCloseUIForm", "GetSubtopUIFormId"},
    "UIManager2": {"OnShowUI", "OnHideUI", "OnCloseUIForm", "YieldCloseUIForm", "GetSubtopUIFormId"},
    "UISetActiveManager": {"OnShowUI", "OnHideUI", "OnCloseUIForm", "YieldCloseUIForm", "GetSubtopUIFormId"},
    "UILayer": {"Init", "SetSortingOrder", "GetUIGroup"},
    "UILayerOld": {"SetSortingOrder"},
    "UIFormBase": {"Init", "Open", "Close", "ToClose", "ToClose2", "add_OnDepthChanged", "remove_OnDepthChanged", "OnSetActive", "OnOpen", "OnClose"},
    "YouYouCanvasHelper": {"Start", "OnOpenHandler", "OnCloseHandler", "OnDepthChanged", "ResetDepth", "ResetRenderDepth", "SetDepth", "get_Depth"},
    "UISpineCtr": {"Awake", "SetTimeScale", "SetToSetupPose", "ClearTracks", "ClearComplete", "PlayAnimation", "AddAnimation", "PlayAnimation2", "StopAnimation", "SetAlpha", "SetOpacity", "GetCurrentName", "SetAnimSkipDelta", "SetSkipByPass", "OnDestroy"},
    "YouYouYouYouUIManagerWrap": {"_m_OpenUIForm", "_m__OpenUIForm", "_m_CloseUIForm", "_m__CloseUIForm", "_m_SetSortingOrder", "_m_GetUIGroup"},
    "YouYouYouYouCanvasHelperWrap": {"_m_SetDepth", "_m_ResetDepth", "_m_ResetRenderDepth", "_m_OnDepthChanged", "_m_OnOpenHandler", "_m_OnCloseHandler"},
    "YouYouUISpineCtrWrap": {"_m_PlayAnimation", "_m_PlayAnimation2", "_m_SetToSetupPose", "_m_ClearTracks", "_m_ClearComplete"},
}


def read_text(path: Path) -> str:
    if not path.exists():
        return ""
    return path.read_text(encoding="utf-8-sig", errors="replace")


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


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


def command_policy() -> dict[str, Any]:
    root_cmd = len(list(ROOT.glob("*.cmd")))
    direct_cmd = len(list((ROOT / "_restore_tools").glob("*.cmd")))
    return {"rootCmdCount": root_cmd, "restoreToolsDirectCmdCount": direct_cmd, "policyOk": root_cmd == 1 and direct_cmd == 0}


def tool_availability() -> dict[str, str]:
    tools = ["ilspycmd", "dotnet", "python", "adb", "frida", "objdump", "readelf", "llvm-objdump", "ghidraRun", "analyzeHeadless", "Cpp2IL", "Il2CppDumper"]
    return {tool: shutil.which(tool) or "" for tool in tools}


def elf_load_segments(path: Path) -> list[dict[str, int]]:
    data = path.read_bytes()[:0x1000]
    if data[:4] != b"\x7fELF":
        return []
    if data[4] != 2 or data[5] != 1:
        return []
    e_phoff = struct.unpack_from("<Q", data, 0x20)[0]
    e_phentsize = struct.unpack_from("<H", data, 0x36)[0]
    e_phnum = struct.unpack_from("<H", data, 0x38)[0]
    full = path.read_bytes()
    rows: list[dict[str, int]] = []
    for i in range(e_phnum):
        off = e_phoff + i * e_phentsize
        p_type = struct.unpack_from("<I", full, off)[0]
        if p_type != 1:
            continue
        p_offset = struct.unpack_from("<Q", full, off + 0x08)[0]
        p_vaddr = struct.unpack_from("<Q", full, off + 0x10)[0]
        p_filesz = struct.unpack_from("<Q", full, off + 0x20)[0]
        p_memsz = struct.unpack_from("<Q", full, off + 0x28)[0]
        rows.append({"p_offset": p_offset, "p_vaddr": p_vaddr, "p_filesz": p_filesz, "p_memsz": p_memsz})
    return rows


def rva_to_file_offset(rva: int, segments: list[dict[str, int]], file_size: int) -> int | None:
    for seg in segments:
        start = seg["p_vaddr"]
        end = start + seg["p_filesz"]
        if start <= rva < end:
            return seg["p_offset"] + (rva - start)
    if 0 <= rva < file_size:
        return rva
    return None


def method_name_from_signature(signature: str) -> str:
    sig = signature.split("(")[0].strip()
    sig = sig.replace(".ctor", "ctor")
    tokens = sig.split()
    if not tokens:
        return ""
    return tokens[-1].split(".")[-1]


def parse_dump_methods() -> list[dict[str, Any]]:
    lines = read_text(DUMP_CS).splitlines()
    segments = elf_load_segments(LIBIL2CPP) if LIBIL2CPP.exists() else []
    lib_size = LIBIL2CPP.stat().st_size if LIBIL2CPP.exists() else 0
    lib_bytes = LIBIL2CPP.read_bytes() if LIBIL2CPP.exists() else b""
    rows: list[dict[str, Any]] = []
    current_class = ""
    current_namespace = ""
    pending_rva: tuple[int, str] | None = None
    class_rx = re.compile(r"^(?:public|private|internal|protected)?\s*(?:sealed\s+)?(?:abstract\s+)?(?:class|struct)\s+([A-Za-z0-9_<>.]+)")
    rva_rx = re.compile(r"// RVA:\s*(0x[0-9A-Fa-f]+)\s+Offset:\s*(0x[0-9A-Fa-f]+)\s+VA:\s*(0x[0-9A-Fa-f]+)")
    for idx, line in enumerate(lines, 1):
        stripped = line.strip()
        if stripped.startswith("// Namespace:"):
            current_namespace = stripped.replace("// Namespace:", "").strip()
        cm = class_rx.search(stripped)
        if cm:
            current_class = cm.group(1).split(".")[-1]
        rm = rva_rx.search(stripped)
        if rm:
            pending_rva = (int(rm.group(1), 16), stripped)
            continue
        if pending_rva and ("(" in stripped and ")" in stripped and stripped.endswith("{ }")):
            rva, rva_line = pending_rva
            pending_rva = None
            method_name = method_name_from_signature(stripped)
            if current_class not in TARGET_CLASSES:
                continue
            wanted = TARGET_METHODS.get(current_class, set())
            if wanted and method_name not in wanted:
                continue
            file_offset = rva_to_file_offset(rva, segments, lib_size)
            sample = b""
            if file_offset is not None and lib_bytes and 0 <= file_offset < len(lib_bytes):
                sample = lib_bytes[file_offset : min(file_offset + 96, len(lib_bytes))]
            prologue = sample[:32].hex(" ")
            sample_sha = hashlib.sha256(sample).hexdigest() if sample else ""
            rows.append(
                {
                    "class_name": current_class,
                    "namespace": current_namespace,
                    "method_name": method_name,
                    "signature": stripped,
                    "dump_cs_line": idx,
                    "rva_hex": f"0x{rva:X}",
                    "dump_rva_line": rva_line,
                    "libil2cpp_path": str(LIBIL2CPP),
                    "file_offset_hex": f"0x{file_offset:X}" if file_offset is not None else "",
                    "raw_bytes_available": bool(sample),
                    "raw_bytes_sha256_96": sample_sha,
                    "raw_bytes_first32": prologue,
                    "method_body_status": "native_bytes_available_no_local_disassembler" if sample else "rva_not_mapped",
                    "formula_recovery_status": "not_recovered",
                    "evidence_note": "dump.cs has RVA/signature only; raw ARM64 bytes can be read from libil2cpp.so, but no local disassembler/lifter is available in PATH and no formula was proven.",
                }
            )
    return rows


def existing_artifact_rows() -> list[dict[str, Any]]:
    files = [DUMP_CS, IL2CPP_H, SCRIPT_JSON, STRING_JSON, IL2CPP_DUMP / "il2cppdumper.log", LIBIL2CPP, METADATA, ASM_TRACE]
    rows = []
    for path in files:
        rows.append(
            {
                "class_name": "",
                "namespace": "",
                "method_name": "",
                "signature": "",
                "dump_cs_line": "",
                "rva_hex": "",
                "dump_rva_line": "",
                "libil2cpp_path": str(path),
                "file_offset_hex": "",
                "raw_bytes_available": path.exists(),
                "raw_bytes_sha256_96": "",
                "raw_bytes_first32": "",
                "method_body_status": "artifact_present" if path.exists() else "missing",
                "formula_recovery_status": "supporting_artifact_only",
                "evidence_note": f"local artifact exists={path.exists()} size={path.stat().st_size if path.exists() else ''}",
            }
        )
    return rows


def depth_matrix(native_rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    def status_for(cls: str, method: str) -> str:
        hit = any(r["class_name"] == cls and r["method_name"] == method and r["raw_bytes_available"] for r in native_rows)
        return "native_bytes_available_formula_not_recovered" if hit else "missing_static_body"

    return [
        {
            "target": "UIManager form group selection / parent assignment",
            "static_evidence": "DTSysUIForm rows + AbstractUIManager.OpenUIForm/OpenUI RVAs + YouYouUIManager.GetUIGroup + UIGroup.Id/BaseOrder/Group fields",
            "native_status": f"{status_for('AbstractUIManager','OpenUIForm')}; {status_for('AbstractUIManager','OpenUI')}; {status_for('YouYouUIManager','GetUIGroup')}",
            "formula_recovered": False,
            "scene_patch_allowed": False,
            "decision": "blocked_native_formula_or_runtime_dump_required",
            "next_evidence": "OpenUI/OpenUIForm body or live dump of UI_Dock/UI_MainPage parent group and GroupId",
        },
        {
            "target": "UIGroup BaseOrder semantics",
            "static_evidence": "UIGroup has Id/BaseOrder/Group; UILayer has m_UILayerDic and m_UIGroupDic",
            "native_status": status_for("UILayer", "Init") + "; " + status_for("UILayer", "SetSortingOrder"),
            "formula_recovered": False,
            "scene_patch_allowed": False,
            "decision": "blocked_sorting_formula_not_recovered",
            "next_evidence": "UILayer.Init and SetSortingOrder body or runtime group BaseOrder dump",
        },
        {
            "target": "UIFormBase.Depth computation/update",
            "static_evidence": "UIFormBase has Depth backing field and OnDepthChanged event; YouYouCanvasHelper subscribes via handlers",
            "native_status": status_for("UIFormBase", "Init") + "; " + status_for("UIFormBase", "Open") + "; " + status_for("UIFormBase", "add_OnDepthChanged"),
            "formula_recovered": False,
            "scene_patch_allowed": False,
            "decision": "blocked_depth_update_path_not_recovered",
            "next_evidence": "UIFormBase.Init/Open body and runtime Depth values for both forms",
        },
        {
            "target": "Canvas sortingOrder / renderer depth cascade",
            "static_evidence": "YouYouCanvasHelper has m_Depth/m_UIFormBase/m_Canvas/m_Raycaster and SetDepth/ResetRenderDepth/OnDepthChanged RVAs",
            "native_status": status_for("YouYouCanvasHelper", "SetDepth") + "; " + status_for("YouYouCanvasHelper", "ResetRenderDepth") + "; " + status_for("YouYouCanvasHelper", "OnDepthChanged"),
            "formula_recovered": False,
            "scene_patch_allowed": False,
            "decision": "blocked_canvas_renderer_cascade_formula_not_recovered",
            "next_evidence": "SetDepth/ResetRenderDepth body or live dump of Canvas.sortingOrder, child Canvas, SkeletonGraphic, UIParticle order",
        },
        {
            "target": "Normal/Full form CanvasScaler behavior",
            "static_evidence": "YouYouUIManager.NormalFormCanvasScaler and FullFormCanvasScaler RVAs exist",
            "native_status": status_for("YouYouUIManager", "NormalFormCanvasScaler") + "; " + status_for("YouYouUIManager", "FullFormCanvasScaler"),
            "formula_recovered": False,
            "scene_patch_allowed": False,
            "decision": "blocked_scaler_formula_not_recovered",
            "next_evidence": "CanvasScaler body or runtime CanvasScaler dump for UI_MainPage/UI_Dock",
        },
    ]


def uispine_matrix(native_rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    probe_rows = read_csv(UI136_PROBE)
    sp_probe = [r for r in probe_rows if r.get("name", "").startswith("sp_")]
    rect_only = sum(1 for r in sp_probe if r.get("componentTypes", "") == "RectTransform")
    native_methods = {r["method_name"] for r in native_rows if r["class_name"] == "UISpineCtr" and r["raw_bytes_available"]}
    return [
        {
            "target": "UISpineCtr component lifecycle",
            "static_evidence": "UISpineCtr has private SkeletonGraphic field and Awake/PlayAnimation methods with native RVAs",
            "native_status": f"methods_with_raw_bytes={','.join(sorted(native_methods))}",
            "runtime_binding_recovered": False,
            "scene_patch_allowed": False,
            "decision": "blocked_native_body_or_runtime_dump_required",
            "next_evidence": "Awake/PlayAnimation body or runtime dump of skeletonGraphic field and animation state",
        },
        {
            "target": "UI_Dock sp_* candidate state",
            "static_evidence": f"UI136 probe sp_* count={len(sp_probe)} rectTransformOnly={rect_only}",
            "native_status": "candidate_missing_UISpineCtr_SkeletonGraphic_components",
            "runtime_binding_recovered": False,
            "scene_patch_allowed": False,
            "decision": "blocked_no_fake_spine",
            "next_evidence": "source-backed SkeletonGraphic/SkeletonDataAsset/material binding for UI_Dock sp_* or original runtime dump",
        },
        {
            "target": "PlayAnimation A/B semantics",
            "static_evidence": "UI_Dock.initTab calls PlayAnimation(0,'A',true) for selected and 'B' for unselected",
            "native_status": "native PlayAnimation bytes available but not disassembled",
            "runtime_binding_recovered": False,
            "scene_patch_allowed": False,
            "decision": "blocked_animation_driver_not_recovered",
            "next_evidence": "UISpineCtr.PlayAnimation body or live dump after initTab showing TrackEntry, SkeletonDataAsset, material",
        },
    ]


def runtime_plan_matrix() -> list[dict[str, Any]]:
    tools = tool_availability()
    return [
        {
            "path": "static_native_method_body_lift",
            "local_inputs": f"{LIBIL2CPP}; {METADATA}; {DUMP_CS}",
            "local_tools_available": f"python={bool(tools['python'])}; objdump={bool(tools['objdump'])}; readelf={bool(tools['readelf'])}; ghidra={bool(tools['ghidraRun'] or tools['analyzeHeadless'])}; Cpp2IL={bool(tools['Cpp2IL'])}",
            "would_execute_runtime": False,
            "requires_user_approval": False,
            "allowed_now": True,
            "expected_output": "RVA/file-offset/raw bytes only with current tools; formulas need disassembler/lifter not present",
            "blocker_or_approval": "Need local disassembler/lifter artifact/tool or user-approved tool install/use to lift ARM64 method bodies.",
        },
        {
            "path": "original_apk_runtime_dump",
            "local_inputs": str(ROOT / "girlswar_merged_extracted" / "split_apks" / "com.girlwars.kr.apk"),
            "local_tools_available": f"adb={bool(tools['adb'])}; frida={bool(tools['frida'])}",
            "would_execute_runtime": True,
            "requires_user_approval": True,
            "allowed_now": False,
            "expected_output": "UI_Dock/UI_MainPage group, BaseOrder, Depth, Canvas.sortingOrder, masks/stencils, CanvasScaler, UISpineCtr skeletonGraphic/SkeletonDataAsset/material",
            "blocker_or_approval": "Requires explicit approval to launch original APK on a device/emulator and attach a dump/instrumentation path; adb/frida not currently available in PATH.",
        },
        {
            "path": "unity_candidate_editor_probe",
            "local_inputs": str(ROOT / "girlswar_maininterface_unity"),
            "local_tools_available": "Unity project exists; original YouYouUIManager runtime not present/executed",
            "would_execute_runtime": False,
            "requires_user_approval": False,
            "allowed_now": True,
            "expected_output": "static rebuilt candidate state only",
            "blocker_or_approval": "Insufficient for production-equivalent UI depth/UISpineCtr because UI136 already worsened metrics.",
        },
        {
            "path": "external_xlua_or_package_import",
            "local_inputs": "none",
            "local_tools_available": "not used",
            "would_execute_runtime": True,
            "requires_user_approval": True,
            "allowed_now": False,
            "expected_output": "potential original xLua/UI stack bootstrap only if approved and implemented",
            "blocker_or_approval": "Forbidden by task unless explicitly approved.",
        },
    ]


def make_markdown(payload: dict[str, Any]) -> str:
    return f"""# {TASK}

Generated: {payload['generatedAt']}

## Decision
- restoredClaim: false
- scenePatchApplied: false
- candidatePatchApplied: false
- patchDecision: {payload['patchDecision']}
- nativeMethodBodiesRecovered: false
- uiDepthFormulaRecovered: false
- uiSpineRuntimeBindingRecovered: false
- runtimeDumpExecuted: false
- runtimeDumpPlanAvailable: true
- requiresUserApproval: true, for any original APK/emulator/runtime instrumentation path

## Static Recovery
- Local Il2CppDumper artifacts exist: `dump.cs`, `il2cpp.h`, `script.json`, `stringliteral.json`, DummyDll, `libil2cpp.so`, and `global-metadata.dat`.
- `dump.cs` provides RVAs and signatures for the target UI methods, and raw native bytes can be mapped from `libil2cpp.so`.
- No local disassembler/lifter is available in PATH (`objdump/readelf/Ghidra/Cpp2IL/frida/adb` not available), so raw ARM64 bytes did not become a proven formula.
- Existing `il2cpp_xlua_target_disassembly.asm` is for prior xLua/XXTEA targets, not the UI depth or UISpineCtr methods.

## Formula Status
- UI form group/depth/canvas formulas: not recovered.
- UISpineCtr runtime binding/animation behavior: not recovered.
- UI_Dock promotion remains blocked; no scene or candidate patch was applied.

## Exact Next Blocker
Either provide/approve a local ARM64 native method-body lifting path for the listed RVAs, or approve a safe original APK runtime dump environment. Runtime approval text is in the JSON under `requiredApprovalText`.
"""


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    native_rows = existing_artifact_rows() + parse_dump_methods()
    depth_rows = depth_matrix(native_rows)
    uispine_rows = uispine_matrix(native_rows)
    runtime_rows = runtime_plan_matrix()

    native_fields = [
        "class_name",
        "namespace",
        "method_name",
        "signature",
        "dump_cs_line",
        "rva_hex",
        "dump_rva_line",
        "libil2cpp_path",
        "file_offset_hex",
        "raw_bytes_available",
        "raw_bytes_sha256_96",
        "raw_bytes_first32",
        "method_body_status",
        "formula_recovery_status",
        "evidence_note",
    ]
    matrix_fields = ["target", "static_evidence", "native_status", "formula_recovered", "scene_patch_allowed", "decision", "next_evidence"]
    uispine_fields = ["target", "static_evidence", "native_status", "runtime_binding_recovered", "scene_patch_allowed", "decision", "next_evidence"]
    runtime_fields = ["path", "local_inputs", "local_tools_available", "would_execute_runtime", "requires_user_approval", "allowed_now", "expected_output", "blocker_or_approval"]

    write_csv(NATIVE_CSV, native_rows, native_fields)
    write_csv(DEPTH_CSV, depth_rows, matrix_fields)
    write_csv(UISPINE_CSV, uispine_rows, uispine_fields)
    write_csv(RUNTIME_CSV, runtime_rows, runtime_fields)

    payload: dict[str, Any] = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "task": TASK,
        "restoredClaim": False,
        "scenePatchApplied": False,
        "candidatePatchApplied": False,
        "patchDecision": "trace_only_no_patch",
        "nativeMethodBodiesRecovered": False,
        "uiDepthFormulaRecovered": False,
        "uiSpineRuntimeBindingRecovered": False,
        "runtimeDumpExecuted": False,
        "runtimeDumpPlanAvailable": True,
        "requiresUserApproval": True,
        "requiredApprovalText": "Approve launching/instrumenting the original APK on a local Android device/emulator, or approve use/installation of a native ARM64 IL2CPP disassembler/lifter, to dump UI_Dock/UI_MainPage form group/BaseOrder/Depth/Canvas.sortingOrder/mask-stencil/CanvasScaler and UISpineCtr SkeletonGraphic/SkeletonDataAsset/material bindings.",
        "requiredNextEvidence": [
            "Disassembled/lifted bodies for UILayer.SetSortingOrder, AbstractUIManager.OpenUI/OpenUIForm, UIFormBase.Init/Open, YouYouCanvasHelper.SetDepth/ResetRenderDepth/OnDepthChanged, and UISpineCtr.Awake/PlayAnimation",
            "Or original runtime dump of UI_Dock and UI_MainPage after OnOpen/initTab with form GroupId, UIGroup.BaseOrder, UIFormBase.Depth, Canvas.sortingOrder, CanvasScaler, masks/stencils, active state, and UISpineCtr skeletonGraphic binding",
            "UI130-compatible activity/account/chat snapshot remains separately required before dynamic labels/icons can be changed",
        ],
        "guardrailsTouched": {
            "sceneOrCandidatePatched": False,
            "uiBgRaycastInteractableAltered": False,
            "btnDiscordReviewHideApplied": False,
            "activitySlotsHiddenOrFaked": False,
            "routeWorldZhuyeNodesHidden": False,
            "painting1005BackPromoted": False,
            "fakeHudIconTextSpineCreated": False,
            "androidOrEmulatorRuntimeExecuted": False,
            "externalToolOrPackageInstalled": False,
        },
        "localToolAvailability": tool_availability(),
        "rowCounts": {
            "nativeMethodEvidence": len(native_rows),
            "uiDepthFormulaMatrix": len(depth_rows),
            "uiSpineRuntimeBindingMatrix": len(uispine_rows),
            "runtimeDumpPlanMatrix": len(runtime_rows),
        },
        "csvs": {
            "nativeMethodBodyRvaSymbolRecoveryEvidence": str(NATIVE_CSV),
            "uiDepthFormulaRecoveryDecisionMatrix": str(DEPTH_CSV),
            "uispinectrRuntimeBindingRecoveryDecisionMatrix": str(UISPINE_CSV),
            "approvedRuntimeDumpPlanBlockerMatrix": str(RUNTIME_CSV),
        },
        "commandPolicy": command_policy(),
    }
    write_json(RESULT_JSON, payload)
    RESULT_MD.write_text(make_markdown(payload), encoding="utf-8")


if __name__ == "__main__":
    main()
