# Battle HUD Visual Sanity Rebase To Play Video Result

## Verdict First
- visual_status: `failed_missing_runtime_binding`
- matches_clip05_static_hud_layout: `False`
- camera_visible_hud: `True`
- camera_visible_original_hud: `False`
- black_or_blank_capture: `False`
- default_white_ui_blocks_visible: `True`
- placeholder_block_visible: `True`
- top/bottom/right zone false positive: `True`
- debug_overlay_visible: `False`
- next_blocker: `BATTLE_21_BATTLE_HUD_RUNTIME_BINDING_AND_SPRITE_PPTR_VISUAL_TRACE`

## Required Fields
- reference_video_used: `True`
- top/bottom/right HUD zones present: `True` / `True` / `True`
- top/bottom/right zone false positive because placeholder graphics cover zones.
- capture_visualization_fix_applied: `True`

## Outputs
- Reference normal battle sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_20_PLAY_VIDEO_NORMAL_BATTLE_REFERENCE_486S.jpg`
- Capture after visual sanity: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleHudVisualSanity_1680x720.png`
- Contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_20_HUD_VISUAL_SANITY_CONTACT_SHEET.jpg`
- Report JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_HUD_VISUAL_SANITY_REBASE_TO_PLAY_VIDEO_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_VISUAL_SANITY_REBASE_TO_PLAY_VIDEO_RESULT.json`
- Unity batchmode success: `True`

## BATTLE_19 Reclassification
- Debug/evidence text screen is a visual failure, not a restored HUD.
- Black capture after suppressing roots is a visual failure, not acceptable output.
- BATTLE_20 treats BATTLE_19 as needing Canvas/camera/runtime visual sanity before button handler work.

## Clip 05 Reference
- Source video: `C:\Users\godho\Downloads\플레이.mp4`
- Clip 05: `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_05_0486s.mp4`
- Frame window: `486.0s-488.5s`
- Expected persistent zones: top HP/VS, bottom actor/skill cards, right vertical controls.

## Unity Scene / Camera / Canvas Dump Summary
- scene: `C:/Users/godho/Downloads/girlswar/girlswar_battle_unity/Assets\..\Assets/Scenes/BattleHudVisualSanity.unity`
- hud_root_found / active_hud_roots: `True` / `2`
- canvas_count / hud_canvas_count: `12` / `12`
- active_graphic_count: `268`
- resolved_sprite_count_from_BATTLE19: `223`
- visible_original_sprite_count: `0`
- capture stats mean/nonBlackRatio: `177.219` / `0.90401`
- capture nearWhiteRatio: `0.65896`

## Root Cause Classification
- capture_visualization_fix_applied: Canvas renderMode/worldCamera was adjusted for capture only and recorded
- default_white_ui_blocks_visible: camera now sees live HUD hierarchy, but unresolved sprite/PPtr/material data renders as large white Image blocks; this is not original battle HUD quality.
- top/bottom/right zone flags are false positives because placeholder/default graphics cover those zones without matching clip05 HUD sprites or shapes.

## Next BATTLE_21 Recommendation
- `BATTLE_21_BATTLE_HUD_RUNTIME_BINDING_AND_SPRITE_PPTR_VISUAL_TRACE`
