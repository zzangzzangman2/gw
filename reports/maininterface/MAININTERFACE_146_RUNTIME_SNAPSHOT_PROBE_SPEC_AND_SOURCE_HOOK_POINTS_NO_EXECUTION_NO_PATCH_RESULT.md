# MAININTERFACE_146 Runtime Snapshot Probe Spec And Source Hook Points

## Decision

- restoredClaim: `false`
- scenePatchApplied: `false`
- runtimeInstrumentationExecuted: `false`
- snapshotValuesInvented: `false`
- staticPatchPossibleWithoutRuntime: `false`
- approvalRequiredForRuntimeDump: `true`

## Snapshot Scope

- Required runtime fields: `197`
- Static-known identity fields: `8`
- Template written: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_146_runtime_snapshot_template.json`

The template contains only source-known identity values and `null` placeholders for runtime values. No fake activity, text, icon, parent, depth, mask, or raycast value was invented.

## Hook Point Summary

- `GameEntry.UI:OpenUIForm` / `YouYouUIManager.OpenUIForm`: form open order, group path, parent instance.
- `UIFormBase.Open`: `CurrCanvas.sortingOrder`, `Depth`, `GroupId`, `DisableUILayer`.
- `YouYouCanvasHelper.SetDepth` / `ResetRenderDepth`: local `m_Depth` and effective child Canvas/SkeletonGraphic sorting.
- `UI_Dock.OnOpen`, `UI_Dock.initTab`, `UI_Dock.setCurrView`: default MAIN_PAGE tab, Dock active state, UI_MainPage open.
- `UI_MainPage.OnOpen`: activity/chat/account/currency refresh entry.
- UI130 replay script: accepts filled snapshot later; still refuses fake defaults.

## Outputs

- Required field matrix: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_146_runtime_snapshot_required_field_matrix.csv`
- Hook point matrix: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_146_source_hook_point_observable_field_matrix.csv`
- Approval path matrix: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_146_approval_level_capture_path_decision_matrix.csv`
- Runtime snapshot template: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_146_runtime_snapshot_template.json`
- Static-known vs runtime-missing matrix: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_146_static_known_vs_runtime_missing_patch_decision_matrix.csv`
- JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_146_RUNTIME_SNAPSHOT_PROBE_SPEC_AND_SOURCE_HOOK_POINTS_NO_EXECUTION_NO_PATCH_RESULT.json`

## Next Blocker

Need approved real runtime snapshot/dump for UI_Dock/UI_MainPage form parent/group/depth/CanvasHelper cascade plus UI130-compatible dynamic activity/account/chat/currency values.
