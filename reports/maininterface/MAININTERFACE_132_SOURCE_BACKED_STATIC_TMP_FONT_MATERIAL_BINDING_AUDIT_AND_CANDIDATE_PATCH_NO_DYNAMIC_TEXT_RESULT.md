# MAININTERFACE_132_SOURCE_BACKED_STATIC_TMP_FONT_MATERIAL_BINDING_AUDIT_AND_CANDIDATE_PATCH_NO_DYNAMIC_TEXT_RESULT

## Verdict

- restoredClaim: `false`
- candidatePatchApplied: `false`
- scenePatchApplied: `false`
- status: `blocked_no_patch_static_tmp_bindings_already_bound_or_no_unambiguous_static_patch_targets`
- noPatchReason: No source-backed dynamic text edits are allowed. Static TMP material candidates are already using matched source-backed shared/static-probe materials, so UI132 has no new material patch to apply.

## Audit Counts

- total text nodes: `80`
- visible text nodes: `27`
- static_source_identified: `7`
- dynamic_runtime_snapshot_required: `62`
- guardrail_blocked: `0`
- unknown_needs_probe: `11`
- static TMP evidence rows: `7`
- static TMP already bound: `7`
- static TMP unmatched: `0`

## Guardrails

- Dynamic activity/face/chat/account/player/currency labels were excluded from patch targets.
- `btn_discord` review hide, `UI_bg` raycast-off, `node_act_btn/btn_act_*` hide, route/world/zhuye hides remain forbidden.
- No fake text, screenshot paste, whole atlas, or coordinate-only alignment was used.

## Outputs

- node audit CSV: `C:/Users/godho/Downloads/girlswar/reports/maininterface/MAININTERFACE_132_tmp_text_node_audit.csv`
- material binding evidence CSV: `C:/Users/godho/Downloads/girlswar/reports/maininterface/MAININTERFACE_132_static_tmp_material_binding_evidence.csv`
- result JSON: `C:/Users/godho/Downloads/girlswar/reports/maininterface/MAININTERFACE_132_SOURCE_BACKED_STATIC_TMP_FONT_MATERIAL_BINDING_AUDIT_AND_CANDIDATE_PATCH_NO_DYNAMIC_TEXT_RESULT.json`

## Command Policy

- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
