# BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH Result

## Verdict
- `restoredClaim=false`, `playableClaim=false`.
- `patchApplied=false`; candidate scene was opened for audit only and not saved.
- BATTLE72 map reprojection remains `validated_persisted_battle72`.

## Reviewed Counts
- HUD nodes reviewed: `353`.
- Right rail nodes reviewed: `293`.
- TMP rows reviewed: `0`.
- Mask/stencil rows reviewed: `0`.
- Sibling/order rows reviewed: `353`.

## Decision
- Safe source-backed static patch candidates: `0`.
- Runtime snapshot required rows: `269`.
- Handler/xLua required rows: `94`.
- Forbidden guess rows: `1`.
- Minimal runtime snapshot fields: `5334`.

## Blocker
- HUD/right rail active state, on/off children, skip/pause/speed/fast-skill state, TMP text values, and mask/stencil behavior remain owned by runtime `UI_NormalBattle` / `ModulesInit.ProcedureNormalBattle` or require an original runtime snapshot.
- No coordinate-only route/HUD patch is source-backed after BATTLE72.

## Outputs
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH_CANDIDATE_SCENE_HUD_RIGHT_RAIL_COMPONENT_STATE_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH_SOURCE_OWNERSHIP_AND_HANDLER_TRACE_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH_ACTIVE_SIBLING_ORDER_MASK_STENCIL_TMP_AUTOSIZE_DECISION_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH_MINIMAL_RUNTIME_SNAPSHOT_FIELD_SPEC.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH_PATCH_CANDIDATE_VS_BLOCKER_DECISION_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH_RESULT.json`

## Command Policy
- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- policy ok: `True`
