# MAININTERFACE 136 Trace UIDock Open Stack Bottom Nav Candidate Result

Generated: 2026-06-26T03:50:56

## Verdict

- restoredClaim: `false`
- sceneSaved: `True`
- dockCandidateApplied: `True`
- dockDefaultStateApplied: `True`
- matchedToggleCount: `7`
- onOffMismatchCount: `0`
- patchDecision: `candidate_uidock_openstack_sibling_form_applied_no_back_layer_no_dock_coordinate_patch`
- productionPatchApplied: `false`
- Painting_1005_back promotion: `false`

## Evidence

- `UI_Dock` is a MainInterface UI form from `DTSysUIFormEntityTableData` and source RectTransform root `7409970622389811116`.
- Decoded `UI_Dock.lua` defaults to `DOCK_TYPE.MAIN_PAGE`, activates the form except story-guide exception, runs `initTab()`, and opens `UI_MainPage` for the MAIN_PAGE tab.
- UI136 therefore probes old-root `UI_MainInterface_old` plus a source-built `UI_Dock` sibling form. It does not import coordinates from old `node_bottom/toogles`.
- UI135 `Painting_1005_back` remains excluded because its zero-offset probe worsened reference correlation.
- UI_bg_raycast_preserved: `True` (baseline `True`, final `True`); interactable preserved: `True` (baseline `True`, final `True`).

## Metrics

- UI128 bottom_nav corr: `0.395621`
- UI136 bottom_nav corr: `0.120721`
- delta: `-0.2749`
- metrics CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_136_bottom_nav_region_metrics.csv`
- contact PNG: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_136_REFERENCE_DIFF_CONTACT.png`

## Click Validation

- total/active/clickable/blocked: `55 / 45 / 43 / 2`
- click CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_136_uidock_click_validation.csv`
- click JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_136_uidock_click_validation_summary.json`

## Outputs

- source/open-stack trace CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_136_uidock_source_open_stack_trace.csv`
- old-root vs UI_Dock matrix CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_136_oldroot_bottom_nav_vs_uidock_evidence_matrix.csv`
- candidate scene probe CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_136_uidock_candidate_scene_probe.csv`
- candidate capture: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui136_uidock_openstack_candidate_1680x720.png`
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_136_TRACE_UIDOCK_OPEN_STACK_BOTTOM_NAV_CANDIDATE_NO_BACK_LAYER_PROMOTION_RESULT.json`

## Command Policy

- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- policyOk: `True`

## Next Blocker

- Activity/account snapshot is still required before activity slot/text/icon/spine state can be reconstructed.
- Exact production layer/order validation is still required before promoting UI_Dock candidate into restored state.
