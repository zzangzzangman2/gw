# BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH Result

## Verdict
- `restoredClaim=false`, `playableClaim=false`.
- `patchApplied=false`; no scene/package/manifest/xLua/handler/runtime mutation was performed.
- True capture used: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle68TrueReferenceAspectNoSceneSave_1920x855.png`.
- True capture aspect: `2.245614`.
- Black gutter detected: `True` (`left=200`, `right=27`).

## Mismatch Summary
- Route/HUD mismatch rows: `3`.
- Bottom card mismatch rows: `1`.
- Actor payload blocked rows: `9`.
- TMP/mask rows reviewed: `81`.
- Safe patch candidate categories recorded, not applied: `2`.

## Blocker Split
- `true_aspect_capture_available`: solved_for_validation - C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle68TrueReferenceAspectNoSceneSave_1920x855.png aspect=2.245614; sceneSaved=False
- `wrong_render_framing_black_gutters`: needs_source_backed_camera_viewrect_or_map_framing_trace - {"leftGutterPx": 200, "rightGutterPx": 27, "leftGutterNorm": 0.104167, "rightGutterNorm": 0.014063, "totalGutterRatio": 0.118229, "detected": true}
- `route_hud_layout`: pending_patch_candidate_after_source_delta - Top HUD/right rail regions differ in true aspect comparison; BATTLE54 route rows identify root_top/root_opra/TopCenter candidates.
- `bottom_card_payload_and_layout`: blocked_by_payload_plus_layout - active card rows=3; 1036 source-known missing bundle rows=1
- `actor_payload_full_formation`: blocked_by_payload - ready actors=3; source-known missing=1; unresolved enemies=8
- `timeline_xlua_runtime`: blocked_separate - ready skill rows=12; blocked skill rows=49; xLua/GameEntry handler runtime remains unavailable.
- `tmp_mask_source_validation`: review_only - TMP rows=65; mask rows=16

## Outputs
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH_TRUE_CAPTURE_IMAGE_REGION_AND_BLACK_GUTTER_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH_REFERENCE_VS_TRUE_CAPTURE_NORMALIZED_LAYOUT_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH_SOURCE_ROUTE_CARD_ACTOR_TMP_MASK_EVIDENCE_JOIN_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH_BLOCKER_SEPARATION_AND_NEXT_ACTION_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH_RESULT.json`
- analysis contact sheet: `C:\Users\godho\Downloads\girlswar\work\battle69_true_aspect_validation\BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH_reference_vs_true_capture_contact_sheet.jpg`

## Command Policy
- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- policy ok: `True`
