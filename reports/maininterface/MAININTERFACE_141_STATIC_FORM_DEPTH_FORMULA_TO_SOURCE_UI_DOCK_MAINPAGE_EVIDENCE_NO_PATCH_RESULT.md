# MAININTERFACE_141_STATIC_FORM_DEPTH_FORMULA_TO_SOURCE_UI_DOCK_MAINPAGE_EVIDENCE_NO_PATCH

Generated: 2026-06-26T04:33:40

## Decision
- restoredClaim: false
- scenePatchApplied: false
- candidatePatchApplied: false
- patchDecision: trace_only_no_patch
- exactFormSortingRecovered: false
- exactCanvasHelperDepthRecovered: false
- uiDockSpineRendererBindingRecovered: false
- uiDockPromotionAllowed: false
- requiresRuntimeDump: true

## Findings
- UI140 formula was applied to local source evidence only; no scene/candidate patch was made.
- `DTSysUIForm` rows are source-backed: `UI_Dock=248`, `UI_MainPage=249`, both `UiGroupId=1`, both `DisableUILayer=1`.
- Because UI140 shows `UIFormBase.Open` only calls `SetSortingOrder(form,true)` when the form is not `DisableUILayer`, exact form sorting is still not derivable from the group cursor alone. The source does not expose the runtime `CurrCanvas.sortingOrder` defaults or the UI manager group object state for these disabled-layer forms.
- `YouYouCanvasHelper` components with `m_Depth` exist in the source bundle and can be enumerated, but exact rendered depth still needs parent form sorting order.
- UI_Dock `sp_*` source objects include real `SkeletonGraphic`/`UISpineCtr` evidence for several bindings, while the UI136 candidate still has RectTransform-only `sp_*` placeholders. Reconstructing the renderer without the exact source binding/depth chain remains unsafe.

## Row Counts
- DTSysUIForm/formula matrix: 2
- UILayer/BaseOrder matrix: 5
- CanvasHelper matrix: 15
- UI_Dock sp binding matrix: 31

## Next Blocker
Need a source-backed or runtime-dumped `UI_Dock`/`UI_MainPage` `CurrCanvas.sortingOrder`/parent form depth state for `DisableUILayer=1` forms, plus an exact UI_Dock `sp_*` SkeletonGraphic/SkeletonDataAsset/material reconstruction path. Until both are proven together, UI_Dock promotion stays blocked.
