# BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE Result

## Verdict
- `restoredClaim=false`, `playableClaim=false`.
- Candidate builder patched: `True`.
- Candidate scene saved: `True`; canonical scene overwritten: `False`.
- HUD/routes/cards/actors/xLua/packages/manifests were not patched.

## Persistence
- Candidate scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\Battle72Map11003TrueAspectReprojectionPersistedCandidate.unity`.
- Map layers persisted: `9`.
- Formula source-backed: `True`.

## Capture Validation
- BATTLE72 capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle72PersistedMap11003TrueAspectReprojectionCandidate_1920x855.png`.
- Gutter B68 baseline: `200/27`.
- Gutter B71 memory: `0/0`.
- Gutter B72 persisted: `0/0`; total `0.0`.
- Persisted candidate matches BATTLE71: `True`.
- New major visual regression detected: `False`.
- Candidate decision: `persisted_map_reprojection_candidate_validated`.

## Outputs
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE_PERSISTED_CANDIDATE_CHANGED_FILE_SCENE_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE_PERSISTED_CANDIDATE_MAP_LAYER_TRANSFORM_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE_BATTLE68_BATTLE71_BATTLE72_REFERENCE_CAPTURE_VALIDATION_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE_BLOCKER_SEPARATION_AND_NEXT_ACTION_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE_RESULT.json`
- contact sheet: `C:\Users\godho\Downloads\girlswar\work\battle72_persisted_map_reprojection\BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE_baseline_b71_b72_reference_contact_sheet.jpg`

## Remaining Blockers
- `map_reprojection_persistence`: persisted_map_reprojection_candidate_validated - B68=200/27; B71=0/0; B72=0/0
- `route_hud_runtime_state`: still_blocked - BATTLE72 did not patch HUD/right rail; BATTLE70 runtime/handler evidence requirement remains
- `bottom_card_and_actor_payload`: still_blocked - BATTLE72 did not patch bottom cards or full actor payload
- `timeline_xlua_runtime`: still_blocked - Timeline/xLua/runtime blockers remain outside map reprojection scope

## Command Policy
- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- policy ok: `True`
