# BATTLE_71_CANDIDATE_ONLY_MAP_11003_TRUE_ASPECT_REPROJECTION_AND_CAPTURE_VALIDATE_NO_CANONICAL_SCENE_OVERWRITE Result

## Verdict
- `restoredClaim=false`, `playableClaim=false`.
- Candidate patch applied in Unity memory: `True`.
- `canonicalSceneOverwritten=false`; HUD/routes/cards/actors/xLua/packages/manifests were not patched.
- Candidate scene saved: `False`; scene saved: `False`.

## Map Reprojection
- Map layers found/changed: `9` / `9`.
- Formula source-backed: `True`.
- Formula source: BATTLE27 `CreateMapLayerPixel`, replacing the 1920x1080 ppu with the 1920x855 true-aspect ppu for the same source sprite rows.

## Capture Validation
- Candidate capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle71Map11003TrueAspectReprojectionCandidate_1920x855.png`.
- Baseline gutter left/right: `200` / `27` px.
- Candidate gutter left/right: `0` / `0` px.
- Candidate total gutter ratio: `0.0`.
- Gutter improved: `True`.
- New major visual regression detected: `False`.
- Candidate decision: `map_reprojection_candidate_validated_for_next_review`.

## Outputs
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_71_CANDIDATE_ONLY_MAP_11003_TRUE_ASPECT_REPROJECTION_AND_CAPTURE_VALIDATE_NO_CANONICAL_SCENE_OVERWRITE_MAP_11003_SOURCE_LAYER_REPROJECTION_FORMULA_SOURCE_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_71_CANDIDATE_ONLY_MAP_11003_TRUE_ASPECT_REPROJECTION_AND_CAPTURE_VALIDATE_NO_CANONICAL_SCENE_OVERWRITE_CANDIDATE_CHANGED_TRANSFORM_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_71_CANDIDATE_ONLY_MAP_11003_TRUE_ASPECT_REPROJECTION_AND_CAPTURE_VALIDATE_NO_CANONICAL_SCENE_OVERWRITE_BASELINE_VS_CANDIDATE_TRUE_ASPECT_CAPTURE_GUTTER_REGION_VALIDATION_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_71_CANDIDATE_ONLY_MAP_11003_TRUE_ASPECT_REPROJECTION_AND_CAPTURE_VALIDATE_NO_CANONICAL_SCENE_OVERWRITE_BLOCKER_SEPARATION_AND_NEXT_ACTION_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_71_CANDIDATE_ONLY_MAP_11003_TRUE_ASPECT_REPROJECTION_AND_CAPTURE_VALIDATE_NO_CANONICAL_SCENE_OVERWRITE_RESULT.json`
- contact sheet: `C:\Users\godho\Downloads\girlswar\work\battle71_map_reprojection\BATTLE_71_CANDIDATE_ONLY_MAP_11003_TRUE_ASPECT_REPROJECTION_AND_CAPTURE_VALIDATE_NO_CANONICAL_SCENE_OVERWRITE_baseline_candidate_reference_contact_sheet.jpg`

## Remaining Blockers
- `map_reprojection_candidate`: map_reprojection_candidate_validated_for_next_review - gutter before left/right=200/27 after=0/0
- `route_hud_runtime_state`: still_blocked - BATTLE70 route/HUD rows needing runtime/handler evidence remain separate; HUD/right rail was not patched
- `bottom_card_and_actor_payload`: still_blocked - BATTLE69/BATTLE70 payload blockers remain: bottom card assembly incomplete and full actor formation gaps remain
- `timeline_xlua_runtime`: still_blocked - BATTLE59/BATTLE64/BATTLE65 blockers remain outside map reprojection scope

## Command Policy
- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- policy ok: `True`
