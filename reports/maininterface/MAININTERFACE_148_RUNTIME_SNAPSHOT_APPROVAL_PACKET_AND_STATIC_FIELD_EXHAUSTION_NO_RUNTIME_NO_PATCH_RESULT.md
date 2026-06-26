# MAININTERFACE_148 Runtime Snapshot Approval Packet And Static Field Exhaustion

Generated: 2026-06-26T06:24:11

## Verdict

- restoredClaim: `false`
- scenePatchApplied: `false`
- runtimeInstrumentationExecuted: `false`
- snapshotValuesInvented: `false`
- staticPatchApplied: `false`
- approvalRequiredForRuntimeDump: `true`

## Field Exhaustion

- Required runtime / forbidden-to-guess fields: `197`
- Already statically known identity fields: `8`
- Static partial fields that still require runtime effective values: `16`
- Newly exhausted static patchable fields in UI148: `0`

No new source-backed static scene patch was found. The remaining fields are observable only from a real runtime snapshot/dump or a user-supplied real snapshot. Static values such as source form id, prefab path, `DisableUILayer`, and serialized Canvas sorting are already accounted for, but they do not decide effective production parent/depth/render order.

## Approval Packet Scope

The compact approval packet groups the capture into:

1. `UI_Dock` / `UI_MainPage` parent, group, depth, Canvas, and form stack.
2. `YouYouCanvasHelper` local/effective depth cascade.
3. Guarded route/world/zhuye/activity/chat/top/UI_bg active, sibling, canvas, and raycast state.
4. UI130-compatible activity/account/chat/currency/redpoint/localization/resource state.
5. Runtime TMP/font/material/mask/stencil renderer state.

## Risk Summary

- UI_Dock/root Canvas renderer reconstruction is source-backed but not promotable without runtime parent/depth.
- Route/world and guarded nodes remain no-hide/no-reorder.
- Activity/chat/account/currency values remain no-fake and UI130 snapshot-gated.
- UI_bg raycast/interactable remains unchanged unless real runtime evidence says otherwise.
- Aspect remains a comparison contributor, not a static patch lane.

## Outputs

- Minimal checklist CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_148_RUNTIME_SNAPSHOT_APPROVAL_PACKET_AND_STATIC_FIELD_EXHAUSTION_NO_RUNTIME_NO_PATCH_minimal_runtime_snapshot_field_checklist.csv`
- Static/runtime classification CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_148_RUNTIME_SNAPSHOT_APPROVAL_PACKET_AND_STATIC_FIELD_EXHAUSTION_NO_RUNTIME_NO_PATCH_static_known_vs_runtime_required_classification_matrix.csv`
- Mismatch risk matrix CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_148_RUNTIME_SNAPSHOT_APPROVAL_PACKET_AND_STATIC_FIELD_EXHAUSTION_NO_RUNTIME_NO_PATCH_mismatch_unblocked_by_field_risk_matrix.csv`
- Approval packet JSON/template: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_148_RUNTIME_SNAPSHOT_APPROVAL_PACKET_AND_STATIC_FIELD_EXHAUSTION_NO_RUNTIME_NO_PATCH_approval_packet_template.json`
- Result JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_148_RUNTIME_SNAPSHOT_APPROVAL_PACKET_AND_STATIC_FIELD_EXHAUSTION_NO_RUNTIME_NO_PATCH_RESULT.json`

## Next Blocker

Need explicit approval and a safe original-runtime target, or a real user-supplied filled snapshot, to populate the UI148 packet fields. Until then, `staticPatchPossibleWithoutRuntime=false`.

## Command Policy

- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- policySatisfied: `True`
