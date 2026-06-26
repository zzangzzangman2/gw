# MAININTERFACE_140_LOCAL_CAPSTONE_ARM64_DISASSEMBLY_OF_UI_DEPTH_AND_UISPINECTR_NO_PATCH

Generated: 2026-06-26T04:26:09

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

- Instruction trace CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_140_capstone_arm64_instruction_trace.csv`
- Formula/binding findings CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_140_static_formula_and_binding_findings.csv`

