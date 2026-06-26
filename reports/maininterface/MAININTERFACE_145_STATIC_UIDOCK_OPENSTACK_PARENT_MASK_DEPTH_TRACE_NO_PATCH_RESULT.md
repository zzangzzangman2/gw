# MAININTERFACE_145 Static UI_Dock Open-stack Parent Mask Depth Trace

## Decision

- restoredClaim: `false`
- scenePatchApplied: `false`
- candidatePatchApplied: `false`
- ui144Promoted: `false`
- staticPatchPossibleWithoutRuntime: `false`
- requiresRuntimeDump: `true`
- requiresRuntimeSnapshot: `true`

## Key Findings

- `UI_Dock`, `UI_Dock_old`, `UI_MainInterface`, and `UI_MainInterface_old` are serialized as separate prefab roots with `father_id=0`; no static source row proves `UI_Dock` should be a child of `UI_MainInterface_old`.
- `DTSysUIForm` and decoded `UI_Dock` Lua continue to support a global `GameEntry.UI:OpenUIForm` stack: `UI_Dock` default `DOCK_TYPE.MAIN_PAGE` then opens `UI_MainPage`.
- UI_Dock source root has Canvas/CanvasGroup evidence and serialized `m_SortingOrder=100`, but UI140/141 still require runtime parent form depth and `OnDepthChanged` cascade for exact rendered order.
- UI_Dock subtree component scan found `704` relevant Canvas/CanvasGroup/raycast/renderer rows and `0` direct `Mask`/`RectMask2D` rows under normal/old Dock roots.
- UI144 closed real Dock renderer reconstruction, but parent/open-stack/mask-depth behavior remains the blocker because UI144 still trails UI128.

## Static Patch Feasibility

No new static scene patch is allowed. The available static evidence does not recover the production UI root/group parent, the effective `CurrCanvas.sortingOrder`/`Depth`, or the runtime mask/stencil state for `DisableUILayer=1` forms. Activity/chat/account/currency state still requires a runtime/account snapshot.

## Outputs

- Parent/open-stack matrix: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_145_uidock_parent_openstack_source_evidence_matrix.csv`
- Mask/stencil/CanvasGroup matrix: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_145_uidock_mask_stencil_canvasgroup_component_chain_matrix.csv`
- DisableUILayer/depth reconciliation: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_145_disableuilayer_root_canvas_depth_reconciliation_matrix.csv`
- Dynamic blocker matrix: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_145_dynamic_home_state_static_vs_runtime_blocker_matrix.csv`
- Next action matrix: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_145_next_action_decision_matrix.csv`
- JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_145_STATIC_UIDOCK_OPENSTACK_PARENT_MASK_DEPTH_TRACE_NO_PATCH_RESULT.json`

## Exact Next Blocker

Need runtime-equivalent evidence for `UI_Dock` and `UI_MainPage` form parent/group object path, root Canvas sorting/Depth, `YouYouCanvasHelper.OnDepthChanged` cascade, and active mask/stencil state. Separately, UI130-compatible runtime snapshot is required for activity/chat/account/currency dynamic home state.
