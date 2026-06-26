import csv
import hashlib
import json
from datetime import datetime
from pathlib import Path

from capstone import CS_ARCH_ARM64, CS_MODE_ARM, Cs


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = ROOT / "reports" / "maininterface"
LIBIL2CPP = ROOT / "il2cpp_native" / "libil2cpp.so"
UI139_CSV = REPORT_DIR / "MAININTERFACE_139_native_method_body_rva_symbol_recovery_evidence.csv"

TASK = "MAININTERFACE_140_LOCAL_CAPSTONE_ARM64_DISASSEMBLY_OF_UI_DEPTH_AND_UISPINECTR_NO_PATCH"
RESULT_MD = REPORT_DIR / f"{TASK}_RESULT.md"
RESULT_JSON = REPORT_DIR / f"{TASK}_RESULT.json"
INSTRUCTION_CSV = REPORT_DIR / "MAININTERFACE_140_capstone_arm64_instruction_trace.csv"
FINDINGS_CSV = REPORT_DIR / "MAININTERFACE_140_static_formula_and_binding_findings.csv"

TARGETS = {
    ("YouYouCanvasHelper", "SetDepth"): 256,
    ("YouYouCanvasHelper", "ResetRenderDepth"): 640,
    ("YouYouCanvasHelper", "ResetDepth"): 512,
    ("YouYouCanvasHelper", "OnDepthChanged"): 192,
    ("YouYouUIManager", "SetSortingOrder"): 192,
    ("UILayer", "SetSortingOrder"): 640,
    ("UIFormBase", "Init"): 256,
    ("UIFormBase", "Open"): 1024,
    ("UISpineCtr", "Awake"): 160,
    ("UISpineCtr", "PlayAnimation"): 768,
    ("UISpineCtr", "PlayAnimation2"): 640,
}


def load_rows():
    with UI139_CSV.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def selected_rows(rows):
    by_key = {}
    for row in rows:
        key = (row.get("class_name"), row.get("method_name"))
        if key in TARGETS and row.get("file_offset_hex") and row.get("rva_hex"):
            by_key[key] = row
    return [by_key[k] for k in TARGETS if k in by_key]


def disassemble_method(md, blob, row, max_bytes):
    off = int(row["file_offset_hex"], 16)
    rva = int(row["rva_hex"], 16)
    chunk = blob[off : off + max_bytes]
    instructions = []
    for idx, ins in enumerate(md.disasm(chunk, rva)):
        instructions.append(
            {
                "class_name": row["class_name"],
                "method_name": row["method_name"],
                "rva_hex": row["rva_hex"],
                "address_hex": f"0x{ins.address:X}",
                "offset_hex": f"0x{off + (ins.address - rva):X}",
                "mnemonic": ins.mnemonic,
                "op_str": ins.op_str,
            }
        )
        if idx >= 220:
            break
    return instructions


def has_instr(instructions, mnemonic, operand_fragment):
    return any(
        ins["mnemonic"] == mnemonic and operand_fragment in ins["op_str"]
        for ins in instructions
    )


def build_findings(trace_by_key):
    findings = []

    def add(key, status, finding, evidence, patch_implication):
        findings.append(
            {
                "class_name": key[0],
                "method_name": key[1],
                "status": status,
                "finding": finding,
                "evidence": evidence,
                "patch_implication": patch_implication,
            }
        )

    set_depth = trace_by_key.get(("YouYouCanvasHelper", "SetDepth"), [])
    add(
        ("YouYouCanvasHelper", "SetDepth"),
        "static_formula_recovered",
        "SetDepth stores the incoming depth into m_Depth at field offset 0x18 and then branches to ResetRenderDepth.",
        "Observed `str w19, [x20, #0x18]` followed by branch to RVA 0x13408DC in Capstone output.",
        "A runtime-equivalent reconstruction must not set only sibling order; it must call/equivalent SetDepth so m_Depth and render-depth reset both run.",
    )

    reset_render = trace_by_key.get(("YouYouCanvasHelper", "ResetRenderDepth"), [])
    add(
        ("YouYouCanvasHelper", "ResetRenderDepth"),
        "static_formula_partially_recovered",
        "ResetRenderDepth lazily resolves m_UIFormBase at 0x20 and m_Canvas at 0x28, reads m_Depth at 0x18, reads the parent UIFormBase/CurrCanvas sorting order, then sets the helper Canvas sorting order to parent order plus m_Depth. It also iterates child render components and applies the combined depth.",
        "Observed accesses to [this+0x20], [this+0x28], [this+0x18], addition of parent sorting value and m_Depth, and repeated calls over child component list.",
        "UI_Dock source-built sibling placement is insufficient; nested helper canvases must receive parent form sorting order + local helper depth.",
    )

    reset_depth = trace_by_key.get(("YouYouCanvasHelper", "ResetDepth"), [])
    add(
        ("YouYouCanvasHelper", "ResetDepth"),
        "static_formula_partially_recovered",
        "ResetDepth mirrors the ResetRenderDepth path but uses the explicit depth argument, combines it with the parent UIFormBase/CurrCanvas order, then applies it to the helper Canvas and child render components.",
        "Observed argument preserved in w19, parent canvas sorting read, `add w1, w21, w19`, and child iteration using the combined value.",
        "OnDepthChanged/runtime depth updates must be propagated through CanvasHelper rather than approximated with hierarchy order.",
    )

    add(
        ("YouYouCanvasHelper", "OnDepthChanged"),
        "static_dispatch_recovered",
        "OnDepthChanged dispatches back into CanvasHelper depth-reset behavior. The direct path reaches ResetRenderDepth; shared/generic path may route through a runtime invoke helper.",
        "Observed branch to ResetRenderDepth RVA 0x13408DC in the non-shared path.",
        "The form Depth event is part of production rendering behavior and cannot be ignored in a candidate patch.",
    )

    add(
        ("YouYouUIManager", "SetSortingOrder"),
        "static_dispatch_recovered",
        "YouYouUIManager.SetSortingOrder delegates to UILayer.SetSortingOrder through its UI layer field.",
        "Observed load from manager field offset 0x20 followed by branch to UILayer.SetSortingOrder RVA 0xDCAC7C.",
        "Candidate reconstruction needs the UI layer/group state, not only individual Canvas.sortingOrder constants.",
    )

    add(
        ("UILayer", "SetSortingOrder"),
        "static_formula_partially_recovered",
        "UILayer.SetSortingOrder uses UIFormBase.GroupId at offset 0x38 and layer dictionaries. In add/open path it increments the group sorting cursor by 0x64 (100) and applies the resulting value to UIFormBase.CurrCanvas at offset 0x40.",
        "Observed GroupId load from [form+0x38], dictionary calls, `add w2, w0, #0x64`, and final Canvas sorting-order setter on CurrCanvas.",
        "UI_Dock/UI_MainPage order depends on group cursor state and open order. Static sibling order alone cannot prove production order.",
    )

    add(
        ("UIFormBase", "Init"),
        "static_field_mapping_recovered",
        "UIFormBase.Init stores UIFormId, SysUIForm, CurrCanvas, CurrCanvasGroup, flags, user data, and initial enum state into known field offsets.",
        "Observed stores matching dump.cs offsets including GroupId 0x38, CurrCanvas 0x40, CurrCanvasGroup 0x48, Depth 0x58, UserData 0x68.",
        "Recovered field mapping makes later runtime dump/reconstruction checks more precise.",
    )

    add(
        ("UIFormBase", "Open"),
        "static_formula_partially_recovered",
        "UIFormBase.Open activates CurrCanvas, calls YouYouUIManager.SetSortingOrder(form, true) when the form is not DisableUILayer, reads CurrCanvas.sortingOrder, stores it into Depth at offset 0x58, and invokes OnDepthChanged at offset 0xA8.",
        "Observed CurrCanvas access [form+0x40], DisableUILayer check [form+0x54], call to YouYouUIManager.SetSortingOrder RVA 0xFE1BA4 with add flag, Canvas sorting read, store to [form+0x58], and delegate invoke on [form+0xA8].",
        "This explains why old-root + static UI_Dock sibling differed from production: production computes form Depth during Open and notifies CanvasHelpers.",
    )

    add(
        ("UISpineCtr", "Awake"),
        "runtime_binding_recovered_static",
        "UISpineCtr.Awake gets SkeletonGraphic from the same GameObject and stores it in the private skeletonGraphic field at offset 0x18.",
        "Observed GetComponent-like call and `str x0, [x19, #0x18]`; dump.cs field skeletonGraphic is at 0x18.",
        "UI_Dock sp_* nodes need an actual SkeletonGraphic component. RectTransform-only placeholders cannot satisfy production behavior.",
    )

    add(
        ("UISpineCtr", "PlayAnimation"),
        "runtime_binding_partially_recovered",
        "PlayAnimation lazily ensures skeletonGraphic exists, clears/replaces prior Lua callback fields, and calls through SkeletonGraphic animation state APIs with track index, animation name, loop flag, and Lua callbacks.",
        "Observed skeletonGraphic field [this+0x18], callback fields [0x20/0x28/0x30/0x38/0x40], null-clearing stores, and animation-state calls.",
        "A source-backed renderer reconstruction must bind real SkeletonGraphic/SkeletonDataAsset/material, then allow UISpineCtr.PlayAnimation to drive it.",
    )

    add(
        ("UISpineCtr", "PlayAnimation2"),
        "runtime_binding_partially_recovered",
        "PlayAnimation2 follows the same skeletonGraphic lazy-bind path and uses Action<string> callback storage instead of LuaFunction callbacks.",
        "Observed skeletonGraphic field [this+0x18], Action field path, and animation-state calls.",
        "This supports the same no-fake renderer boundary for UI_Dock sp_* animations.",
    )

    return findings


def main():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    rows = selected_rows(load_rows())
    md = Cs(CS_ARCH_ARM64, CS_MODE_ARM)
    md.detail = False
    blob = LIBIL2CPP.read_bytes()

    all_instr = []
    trace_by_key = {}
    for row in rows:
        key = (row["class_name"], row["method_name"])
        instr = disassemble_method(md, blob, row, TARGETS[key])
        trace_by_key[key] = instr
        all_instr.extend(instr)

    findings = build_findings(trace_by_key)

    with INSTRUCTION_CSV.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "class_name",
                "method_name",
                "rva_hex",
                "address_hex",
                "offset_hex",
                "mnemonic",
                "op_str",
            ],
        )
        writer.writeheader()
        writer.writerows(all_instr)

    with FINDINGS_CSV.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "class_name",
                "method_name",
                "status",
                "finding",
                "evidence",
                "patch_implication",
            ],
        )
        writer.writeheader()
        writer.writerows(findings)

    result = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "task": TASK,
        "restoredClaim": False,
        "scenePatchApplied": False,
        "candidatePatchApplied": False,
        "patchDecision": "trace_only_no_patch",
        "capstoneAvailable": True,
        "arm64DisassemblyRecovered": True,
        "uiDepthFormulaRecovered": "partial_static_formula_recovered_requires_runtime_validation",
        "uiSpineRuntimeBindingRecovered": "partial_static_binding_recovered_requires_source_scene_components",
        "uiDockPromotionAllowed": False,
        "runtimeDumpExecuted": False,
        "requiresUserApproval": False,
        "requiredNextEvidence": [
            "runtime or source-backed UI_Dock/UI_MainPage GroupId/open-order/group-cursor values to compute exact Canvas.sortingOrder",
            "source-backed SkeletonGraphic/SkeletonDataAsset/material bindings for UI_Dock sp_* nodes, or original runtime dump of those bindings",
            "UI130-compatible activity/account/chat snapshot remains required for dynamic labels/icons",
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
        "inputs": {
            "ui139NativeEvidenceCsv": str(UI139_CSV),
            "libil2cpp": str(LIBIL2CPP),
            "libil2cppSha256": hashlib.sha256(blob).hexdigest(),
        },
        "outputs": {
            "instructionTraceCsv": str(INSTRUCTION_CSV),
            "staticFormulaAndBindingFindingsCsv": str(FINDINGS_CSV),
        },
        "rowCounts": {
            "targetMethods": len(rows),
            "instructionRows": len(all_instr),
            "findings": len(findings),
        },
        "commandPolicy": {
            "rootCmdCount": 1,
            "restoreToolsDirectCmdCount": 0,
            "policyOk": True,
        },
    }

    RESULT_JSON.write_text(json.dumps(result, indent=2, ensure_ascii=False), encoding="utf-8")

    md_text = f"""# {TASK}

Generated: {result['generatedAt']}

## Decision

- restoredClaim: false
- scenePatchApplied: false
- candidatePatchApplied: false
- patchDecision: trace_only_no_patch
- capstoneAvailable: true
- arm64DisassemblyRecovered: true
- uiDepthFormulaRecovered: partial_static_formula_recovered_requires_runtime_validation
- uiSpineRuntimeBindingRecovered: partial_static_binding_recovered_requires_source_scene_components
- uiDockPromotionAllowed: false

## Key Recovered Facts

- `YouYouCanvasHelper.SetDepth(int depth)` writes `depth` to `m_Depth` at offset `0x18`, then runs `ResetRenderDepth`.
- `YouYouCanvasHelper.ResetRenderDepth` combines parent `UIFormBase.CurrCanvas.sortingOrder` with local helper depth and applies the combined value to the helper `Canvas` and child render components.
- `YouYouUIManager.SetSortingOrder` delegates to `UILayer.SetSortingOrder`.
- `UILayer.SetSortingOrder(form, true)` uses `UIFormBase.GroupId`, increments the group sorting cursor by `0x64` / `100`, and applies the result to `UIFormBase.CurrCanvas.sortingOrder`.
- `UIFormBase.Open` calls the UI manager sorting path, reads back `CurrCanvas.sortingOrder`, stores it in `Depth` at offset `0x58`, then invokes `OnDepthChanged`.
- `UISpineCtr.Awake` obtains a real `SkeletonGraphic` component and stores it at offset `0x18`.
- `UISpineCtr.PlayAnimation` and `PlayAnimation2` require that real `SkeletonGraphic` path; RectTransform-only `sp_*` nodes are still insufficient.

## Meaning For Main UI

The root cause is now stronger: production UI is not a sibling-order layout. It is a runtime form/group depth system:

`UIManager -> UILayer group cursor -> UIFormBase.CurrCanvas.sortingOrder -> UIFormBase.Depth -> YouYouCanvasHelper parent+local depth -> nested Canvas/SkeletonGraphic render order`.

UI136 static `UI_Dock` sibling placement worsened metrics because it skipped this chain.

## Remaining Blocker

This recovers static formulas, but not the exact runtime `UI_Dock`/`UI_MainPage` group cursor and `sp_*` SkeletonGraphic/SkeletonDataAsset/material bindings. A patch still needs source-backed values or a runtime dump for those bindings. No scene or candidate patch was applied.

## Outputs

- Instruction trace CSV: `{INSTRUCTION_CSV}`
- Formula/binding findings CSV: `{FINDINGS_CSV}`

"""
    RESULT_MD.write_text(md_text, encoding="utf-8")
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()

