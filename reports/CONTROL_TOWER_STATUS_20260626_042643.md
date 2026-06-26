# Control Tower Status - 2026-06-26 04:26:43 KST

## Purpose

Update after finding local Python `capstone` and `elftools` modules. This changes the UI139 boundary: ARM64 disassembly is now available without installing or downloading a new tool, and without running APK/emulator instrumentation.

## New UI140 Result

- Task: `MAININTERFACE_140_LOCAL_CAPSTONE_ARM64_DISASSEMBLY_OF_UI_DEPTH_AND_UISPINECTR_NO_PATCH`
- Result:
  - `restoredClaim=false`
  - `scenePatchApplied=false`
  - `candidatePatchApplied=false`
  - `patchDecision=trace_only_no_patch`
  - `capstoneAvailable=true`
  - `arm64DisassemblyRecovered=true`
  - `uiDepthFormulaRecovered=partial_static_formula_recovered_requires_runtime_validation`
  - `uiSpineRuntimeBindingRecovered=partial_static_binding_recovered_requires_source_scene_components`
  - `uiDockPromotionAllowed=false`
  - `runtimeDumpExecuted=false`
- Outputs:
  - `reports\maininterface\MAININTERFACE_140_LOCAL_CAPSTONE_ARM64_DISASSEMBLY_OF_UI_DEPTH_AND_UISPINECTR_NO_PATCH_RESULT.md`
  - `reports\maininterface\MAININTERFACE_140_LOCAL_CAPSTONE_ARM64_DISASSEMBLY_OF_UI_DEPTH_AND_UISPINECTR_NO_PATCH_RESULT.json`
  - `reports\maininterface\MAININTERFACE_140_capstone_arm64_instruction_trace.csv`
  - `reports\maininterface\MAININTERFACE_140_static_formula_and_binding_findings.csv`
  - `_restore_tools\scripts\maininterface140_capstone_arm64_disassemble_ui_depth_uispinectr.py`
- Row counts:
  - target methods: 11
  - instruction rows: 1285
  - findings: 11
- Command policy verified:
  - project root `.cmd`: 1 (`00_COMMAND_CENTER.cmd`)
  - `_restore_tools` direct `.cmd`: 0

## UI140 Recovered Facts

- `YouYouCanvasHelper.SetDepth(int depth)`:
  - stores `depth` into `m_Depth` at offset `0x18`
  - branches to `ResetRenderDepth`
- `YouYouCanvasHelper.ResetRenderDepth`:
  - lazily resolves `m_UIFormBase` at `0x20`
  - lazily resolves `m_Canvas` at `0x28`
  - reads `m_Depth` at `0x18`
  - reads parent `UIFormBase.CurrCanvas.sortingOrder`
  - applies `parent sorting order + local depth` to helper Canvas and child render components
- `YouYouUIManager.SetSortingOrder`:
  - delegates to `UILayer.SetSortingOrder`
- `UILayer.SetSortingOrder(form, true)`:
  - reads `UIFormBase.GroupId` at offset `0x38`
  - uses layer/group dictionaries
  - increments the group sorting cursor by `0x64` / `100`
  - applies the resulting value to `UIFormBase.CurrCanvas.sortingOrder`
- `UIFormBase.Open`:
  - activates `CurrCanvas`
  - calls `YouYouUIManager.SetSortingOrder(form, true)` when not `DisableUILayer`
  - reads back `CurrCanvas.sortingOrder`
  - stores it into `Depth` at offset `0x58`
  - invokes `OnDepthChanged` at offset `0xA8`
- `UISpineCtr.Awake`:
  - gets a real `SkeletonGraphic` component from the same GameObject
  - stores it at offset `0x18`
- `UISpineCtr.PlayAnimation` / `PlayAnimation2`:
  - require the real `SkeletonGraphic` path
  - clear/replace callback fields
  - call through SkeletonGraphic animation-state APIs

## Updated Root Cause

The production main UI is not a sibling-order layout. It is:

`UIManager -> UILayer group cursor -> UIFormBase.CurrCanvas.sortingOrder -> UIFormBase.Depth -> YouYouCanvasHelper parent+local depth -> nested Canvas/SkeletonGraphic render order`

UI136 static `UI_Dock` sibling placement worsened metrics because it skipped this runtime depth chain.

## Remaining UI Evidence Needed

- Source-backed `UI_Dock` and `UI_MainPage`:
  - `DTSysUIForm` group id / layer group
  - production open order
  - initial group cursor/BaseOrder/default sorting state
  - CanvasHelper serialized `m_Depth` values
  - actual `sp_*` `UISpineCtr` + `SkeletonGraphic` + `SkeletonDataAsset` + material bindings
- UI130-compatible runtime account/activity/chat/profile/currency snapshot remains required for dynamic labels/icons.

## Recommended Next UI Task

- `MAININTERFACE_141_STATIC_FORM_DEPTH_FORMULA_TO_SOURCE_UI_DOCK_MAINPAGE_EVIDENCE_NO_PATCH`
- Purpose:
  - Apply the recovered UI140 formula to local source evidence only.
  - Decide whether exact `UI_Dock`/`UI_MainPage` sorting order and `sp_*` renderer bindings can be reconstructed without runtime dump.
  - No scene/candidate patch unless the exact source-backed group/open-order/depth/binding chain is proven.

## Battle Boundary

- Battle remains at BATTLE59:
  - no source-backed importable editor xLua runtime
  - no executable local xLua runtime
  - no GameEntry/LuaManager bootstrap
- Original handler/runtime restoration still requires original xLua runtime or explicit user approval for external xLua plus payload-gap handling.

## Character/Data Boundary

- Loadable battle actors remain 3/12:
  - our `1002`
  - our `1034`
  - enemy `1100111 -> prefab/model 3001`
- `1036` remains `not_fetchable_local`.
- Eight unresolved enemy payload IDs remain unresolved from local evidence.

## Guardrails

- No scene patch.
- No candidate patch.
- No APK/emulator/runtime execution.
- No external tool/package install.
- No `UI_bg` raycast/interactable change.
- No fake HUD/icon/text/spine.
- No route/world/zhuye/activity/chat/account hide.
- No `Painting_1005_back` promotion.

