# CONTROL_TOWER_STATUS_20260626_043413

Generated: 2026-06-26 04:34:13 KST

## Control Tower Summary

- Active goal is still not complete.
- UI worker completed `MAININTERFACE_141_STATIC_FORM_DEPTH_FORMULA_TO_SOURCE_UI_DOCK_MAINPAGE_EVIDENCE_NO_PATCH`.
- No scene or candidate patch was applied by UI141.
- Battle worker remains unchanged since BATTLE59.
- Character/data worker remains unchanged since unresolved enemy deep trace.

## UI141 Result

Primary outputs:

- `reports/maininterface/MAININTERFACE_141_STATIC_FORM_DEPTH_FORMULA_TO_SOURCE_UI_DOCK_MAINPAGE_EVIDENCE_NO_PATCH_RESULT.md`
- `reports/maininterface/MAININTERFACE_141_STATIC_FORM_DEPTH_FORMULA_TO_SOURCE_UI_DOCK_MAINPAGE_EVIDENCE_NO_PATCH_RESULT.json`
- `reports/maininterface/MAININTERFACE_141_dtsysuiform_field_decode_formula_input_matrix.csv`
- `reports/maininterface/MAININTERFACE_141_uilayer_group_cursor_baseorder_source_availability_matrix.csv`
- `reports/maininterface/MAININTERFACE_141_canvashelper_serialized_depth_evidence_matrix.csv`
- `reports/maininterface/MAININTERFACE_141_uidock_sp_uispinectr_skeletongraphic_binding_evidence_matrix.csv`
- `_restore_tools/scripts/maininterface141_static_form_depth_formula_to_source_uidock_mainpage.py`

Final JSON fields:

- `restoredClaim=false`
- `scenePatchApplied=false`
- `candidatePatchApplied=false`
- `patchDecision=trace_only_no_patch`
- `exactFormSortingRecovered=false`
- `exactCanvasHelperDepthRecovered=false`
- `uiDockSpineRendererBindingRecovered=false`
- `uiDockPromotionAllowed=false`
- `requiresRuntimeDump=true`

Guardrails remained clean:

- No `UI_bg` raycast/interactable change.
- No zhuye/route/world/activity/discord/account/chat hide.
- No `Painting_1005_back` promotion.
- No fake HUD/icon/text/spine.
- No Android/emulator runtime execution.
- No external package/tool install.
- Command policy stayed valid: root `.cmd` count 1, `_restore_tools` direct `.cmd` count 0.

## New Evidence Fixed By UI141

`DTSysUIForm` rows are source-backed:

- `UI_Dock`: form id `248`, `UiGroupId=1`, `DisableUILayer=1`, `IsLock=1`, asset path `UIPrefabAndRes/MainInterface/Prefabs/UI_Dock`.
- `UI_MainPage`: form id `249`, `UiGroupId=1`, `DisableUILayer=1`, `IsLock=0`, asset path `UIPrefabAndRes/MainInterface/Prefabs/UI_MainInterface`.

Important consequence:

- UI140 showed `UIFormBase.Open` calls `SetSortingOrder(form,true)` only when the form is not `DisableUILayer`.
- Because both `UI_Dock` and `UI_MainPage` decode as `DisableUILayer=1`, the group cursor formula alone cannot produce exact `CurrCanvas.sortingOrder`.
- Missing input is the runtime/default `CurrCanvas.sortingOrder` or parent form depth for these disabled-layer forms.

CanvasHelper evidence:

- Source bundle `download/ui/uiprefabandres/maininterface.assetbundle` contains 15 `YouYouCanvasHelper` entries.
- `m_Depth` values were recovered directly through local UnityPy:
  - many `bgBtn` helpers have `m_Depth=-1`
  - `im_juese` and `im_juese (1)` have `m_Depth=1`
- Exact rendered depth is still partial because formula is `parent UIFormBase.CurrCanvas.sortingOrder + m_Depth`, and parent sorting is not recovered.

UI_Dock spine evidence:

- Source bundle has real normal `UI_Dock` spine bindings with `SkeletonGraphic + UISpineCtr` for:
  - `sp_mainpage`
  - `sp_camp`
  - `sp_bag`
  - `sp_expedition`
  - `sp_adventureInterface`
  - `sp_guild`
  - `sp_maincity`
  - `spine_xiaoshou`
- Example details:
  - `sp_mainpage`: `SkeletonGraphic`, `UISpineCtr`, skeletonDataAsset pathID `9141383861460370126`, material pathID `4191673546758847426`, starting animation `A`.
  - `sp_maincity`: `SkeletonGraphic`, `UISpineCtr`, skeletonDataAsset pathID `2535488780058187540`, material pathID `4191673546758847426`, starting animation `animation`.
  - `spine_xiaoshou`: `SkeletonGraphic`, `UISpineCtr`, skeletonDataAsset pathID `-300655369511109608`, material pathID `1869315399850166803`, starting animation `B`.
- UI136 candidate still has RectTransform-only `sp_*` placeholders.
- Therefore renderer source exists, but promotion remains blocked until renderer reconstruction and exact depth stack are proven together.

## Current UI Blocker

UI formula is now known, and serialized local depths are partly known, but exact home UI reconstruction is blocked by this combined requirement:

1. Source-backed or runtime-dumped `UI_Dock` / `UI_MainPage` `CurrCanvas.sortingOrder` or parent form depth for `DisableUILayer=1` forms.
2. Exact UI_Dock `sp_*` `SkeletonGraphic` / `SkeletonDataAsset` / material reconstruction path tied to the same depth chain.
3. Existing dynamic UI snapshot gaps still separate: account/activity/chat labels/icons remain UI130-compatible runtime state issues.

## Battle Status

Unchanged since BATTLE59:

- Local source-backed actors visible/rendering: 3/3 for currently loadable actor set.
- HUD/raycast alive, but no original handler binding recovered.
- xLua runtime candidate remains unavailable locally.
- `sourceBackedBootstrapApplied=false`
- `handlerBindingApplied=false`
- `isFinalRestoredBattleScreen=false`

Main blocker:

- Original xLua runtime or explicit approval for external xLua/runtime integration, plus remaining local payload gaps.

## Character/Data Status

Unchanged:

- Loadable actors in local manifest: `1002`, `1034`, enemy `1100111 -> prefab/model 3001`.
- `1036` remains `not_fetchable_local`.
- Enemy instance ids `1100112`, `1100113`, `1100121`, `1100122`, `1100123`, `1100131`, `1100132`, `1100133` remain unresolved from local evidence.

## Recommended Next Step

Do not patch UI_Dock promotion yet.

Next UI task should be one of:

1. `MAININTERFACE_142_SOURCE_RENDERER_RECONSTRUCTION_FEASIBILITY_NO_PATCH`: use UI141 binding pathIDs to determine if exact `SkeletonGraphic`, `SkeletonDataAsset`, material, atlas/texture dependencies, and UI_Dock normal/old root mapping can be reconstructed in Unity without runtime execution. Still no patch unless all dependencies and depth input are closed.
2. Ask user approval for safe original runtime/APK/emulator instrumentation to dump disabled-layer `CurrCanvas.sortingOrder`, UI group state, CanvasHelper final sorting, and `UISpineCtr` renderer state.

Control recommendation:

- Prefer UI142 no-patch renderer-dependency closure first, because UI141 found concrete source pathIDs. This may reduce the runtime dump scope to only `CurrCanvas.sortingOrder` / parent depth.
