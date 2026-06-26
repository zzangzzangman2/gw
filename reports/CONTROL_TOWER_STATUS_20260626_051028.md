# CONTROL_TOWER_STATUS_20260626_051028

Generated: 2026-06-26 05:10:28 KST

## Control Tower Summary

- Active restore goal is not complete.
- UI145 completed as a no-patch static trace after UI144.
- UI144 remains preserved as failed-to-promote evidence: real UI_Dock renderer reconstruction works, but the visual candidate still trails UI128.
- UI145 confirms there is no static source proof that `UI_Dock` should be reparented under `UI_MainInterface_old`.
- UI145 also confirms direct `Mask` / `RectMask2D` evidence under Dock roots is absent; the remaining UI blocker is effective runtime form parent/depth/canvas cascade plus dynamic account/activity state.
- No APK/emulator/runtime instrumentation has been executed.
- BATTLE60 and CHARACTER_COMMON_SPEEDLINE are now running in worker threads to narrow skill/timeline/resource gaps while UI runtime evidence remains blocked.

## UI145 Result

Primary outputs:

- `reports/maininterface/MAININTERFACE_145_STATIC_UIDOCK_OPENSTACK_PARENT_MASK_DEPTH_TRACE_NO_PATCH_RESULT.md`
- `reports/maininterface/MAININTERFACE_145_STATIC_UIDOCK_OPENSTACK_PARENT_MASK_DEPTH_TRACE_NO_PATCH_RESULT.json`
- `reports/maininterface/MAININTERFACE_145_uidock_parent_openstack_source_evidence_matrix.csv`
- `reports/maininterface/MAININTERFACE_145_uidock_mask_stencil_canvasgroup_component_chain_matrix.csv`
- `reports/maininterface/MAININTERFACE_145_disableuilayer_root_canvas_depth_reconciliation_matrix.csv`
- `reports/maininterface/MAININTERFACE_145_dynamic_home_state_static_vs_runtime_blocker_matrix.csv`
- `reports/maininterface/MAININTERFACE_145_next_action_decision_matrix.csv`
- `_restore_tools/scripts/maininterface145_static_uidock_openstack_parent_mask_depth_trace.py`

Key JSON result:

- `restoredClaim=false`
- `scenePatchApplied=false`
- `candidatePatchApplied=false`
- `ui144Promoted=false`
- `staticParentEvidenceFound=true`
- `staticMaskStencilEvidenceFound=true`
- `staticDepthBehaviorReconciled=false`
- `staticPatchPossibleWithoutRuntime=false`
- `requiresRuntimeDump=true`
- `requiresRuntimeSnapshot=true`

Important nuance:

- `staticMaskStencilEvidenceFound=true` means relevant Canvas / CanvasGroup / CanvasRenderer / GraphicRaycaster / SkeletonGraphic component-chain evidence was found.
- It does not mean a direct source `Mask` or `RectMask2D` was found. UI145 found `0` direct `Mask` / `RectMask2D` rows under normal/old Dock roots.

## UI Root / Parent Finding

UI145 fixed the current static parent conclusion:

- `UI_Dock`, `UI_Dock_old`, `UI_MainInterface`, and `UI_MainInterface_old` are separate serialized prefab roots with `father_id=0`.
- Static source does not prove `UI_Dock` should be a child of `UI_MainInterface_old`.
- `DTSysUIForm` and decoded `UI_Dock` Lua continue to support a global `GameEntry.UI:OpenUIForm` stack.
- `UI_Dock` opens first with default `DOCK_TYPE.MAIN_PAGE`, then opens `UI_MainPage`.

Therefore:

- Do not patch Dock parent/sibling/mask statically.
- Do not promote UI144.
- Do not hide guarded zhuye/right/world/activity/discord/account/chat nodes without source proof.

## Current Main UI Blocker

Required evidence now narrowed to runtime-equivalent state:

- `UI_Dock` / `UI_MainPage` form parent and group object path.
- Effective root Canvas sorting order and `UIFormBase.Depth`.
- `YouYouCanvasHelper.OnDepthChanged` cascade behavior for `DisableUILayer=1`.
- Active runtime mask/stencil state, if any.
- UI130-compatible runtime/account snapshot for activity, chat, account, currency, route/world cluster, and home normal-state overlays.

Without that evidence, `staticPatchPossibleWithoutRuntime=false`.

## Battle / Character Status

Current proven battle state:

- BATTLE57 actor rendering remains source-backed and visible for `1002`, `1034`, and enemy `3001`: `3/3`.
- BATTLE58 HUD/button input path remains alive enough for raycast validation, but original handlers are not bound.
- BATTLE59 found no local source-backed executable xLua/GameEntry/LuaManager runtime candidate:
  - `sourceBackedImportableEditorRuntimeCandidates=0`
  - `executableXluaRuntimeAvailable=false`
  - `gameEntryLuaManagerBootstrapAvailable=false`
  - `handlerBindingApplied=false`

Current payload state:

- Actors: `loadable 3/12`
- Skills: `loadable 4`, `loadable_with_unresolved_common_resource_deps 8`, `data_only_missing_actor 27`, `passive_no_timeline 22`
- Missing common resource deps: pink/red/yello speedline bundles
- `1036` remains `not_fetchable_local`
- enemy ids `1100112`, `1100113`, `1100121`, `1100122`, `1100123`, `1100131`, `1100132`, `1100133` remain unresolved from local evidence

Active follow-up worker tasks:

- BATTLE60: `BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH`
- Character/resource: `CHARACTER_COMMON_SPEEDLINE_BUNDLE_DEEP_TRACE_NO_FAKE_RESOURCE`

## Recommended Next Path

1. Wait for BATTLE60 and speedline trace outputs, then fold their skill/resource conclusions into the next control report.
2. Do not perform static UI parent/mask patch from UI145; it is explicitly unsupported.
3. Do not claim main UI restored or battle playable.
4. If the user approves runtime instrumentation later, keep it minimal and scoped to UI form parent/depth/mask snapshot and xLua/GameEntry handler feasibility.
5. Until approval exists, continue source-only narrowing of battle skill resources and payload gaps.

No goal-complete claim is allowed until reference-aligned main UI and source-backed playable battle are both verified.
