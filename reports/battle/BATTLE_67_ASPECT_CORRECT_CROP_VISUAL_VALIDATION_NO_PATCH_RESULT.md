# BATTLE_67_ASPECT_CORRECT_CROP_VISUAL_VALIDATION_NO_PATCH Result

## Verdict
- `restoredClaim=false`, `playableClaim=false`.
- No scene/package/manifest/xLua/handler/HUD/card/actor/effect patch was applied.
- Analysis-only crop/guide images were generated from existing captures; this is not a true runtime reference-aspect capture.
- Reference aspect: `2.2456`.
- Content rect used for 1920x1080 captures: `x=0, y=112 (exact 112.4973), w=1920, h=855`.

## Generated Visual Evidence
- Contact sheet: `C:\Users\godho\Downloads\girlswar\work\battle67_aspect_correct_crop\BATTLE_67_ASPECT_CORRECT_CROP_VISUAL_VALIDATION_NO_PATCH_reference_vs_candidate_contact_sheet.jpg`
- BATTLE57 guide: `C:\Users\godho\Downloads\girlswar\work\battle67_aspect_correct_crop\battle57_full_reference_aspect_guide_1920x1080.jpg`
- BATTLE57 content crop: `C:\Users\godho\Downloads\girlswar\work\battle67_aspect_correct_crop\battle57_full_reference_aspect_content_rect_1920x855.png`
- BATTLE57 actor diff crop: `C:\Users\godho\Downloads\girlswar\work\battle67_aspect_correct_crop\battle57_actor_diff_reference_aspect_content_rect_1920x855.png`

## Actor Position Finding
- Source-backed local subset actor rows analyzed: `3`.
- Actor centers inside broad reference side bands after content-rect normalization: `1/3`.
- This remains local-subset proof only; it does not close the full actor/card payload blocker.

## Route/Card/TMP/Mask Evidence
- Focused source rows exported: `240`.
- These rows preserve active state, sibling order, anchors, scale, payload status, TMP text, and mask evidence for later source-backed patching.
- No field was changed from these rows in this task.

## Next Blocker
- `TRUE_REFERENCE_ASPECT_CAPTURE_OR_SOURCE_BACKED_VIEWRECT_REQUIRED_BEFORE_LAYOUT_PATCH`.
- Cropped 16:9 screenshots are useful diagnostic evidence, but final coordinate/layout changes need a true reference-aspect capture or source-backed view rect/canvas proof.

## Outputs
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_67_ASPECT_CORRECT_CROP_VISUAL_VALIDATION_NO_PATCH_IMAGE_CROP_AND_SIGNAL_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_67_ASPECT_CORRECT_CROP_VISUAL_VALIDATION_NO_PATCH_ACTOR_CONTENT_RECT_POSITION_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_67_ASPECT_CORRECT_CROP_VISUAL_VALIDATION_NO_PATCH_FOCUSED_ROUTE_CARD_TMP_MASK_ROWS.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_67_ASPECT_CORRECT_CROP_VISUAL_VALIDATION_NO_PATCH_DECISION_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_67_ASPECT_CORRECT_CROP_VISUAL_VALIDATION_NO_PATCH_RESULT.json`

## Command Policy
- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- policy ok: `True`
