# 아직 원본 전투 HUD 아님

BATTLE_23 loaded missing HUD external dependencies and compared the result against the `플레이.mp4` clip05 normal battle sequence around 486s.

## Visual Verdict
- visual_status: `failed_missing_runtime_binding`
- matches_clip05_static_hud_layout: `False`
- camera_visible_original_hud: `False`
- placeholder_block_visible: `True`
- component_placeholder_block_visible: `False`
- large_white_bands_visible: `True`
- debug_or_path_label_visible: `False`
- visible_original_sprite_count: `174`
- visible_placeholder_block_count: `0`
- nearWhiteRatio: `0.6486904761904762`

## External Dependency Load
- dependency bundles: `8/8` loaded
- failed dependency bundles: `0`

## Video Gate
- reference_video_used: `true`
- clip05 sequence extracted: `True`
- reference sequence: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_23_PLAY_VIDEO_NORMAL_BATTLE_REFERENCE_486S_SEQUENCE.jpg`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_23_EXTERNAL_DEPENDENCY_LOAD_CLIP05_CONTACT_SHEET.jpg`

## Failure/Blocker
- If the contact sheet still does not visually resemble clip05, this stage remains failed even when Unity reports visible graphics.
- top/bottom/right occupancy is not accepted when caused by placeholder/default graphics.
- nextBlocker: `BATTLE_24_CUSTOM_YOUYOUIMAGE_RUNTIME_LUA_BINDING_TRACE`

## Outputs
- Unity JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_EXTERNAL_DEPENDENCY_LOAD_CLIP05_VISUAL.json`
- Components CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_EXTERNAL_DEPENDENCY_LOAD_CLIP05_VISUAL_COMPONENTS.csv`
- Capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleHudExternalDependencyLoadClip05_1680x720.png`
- Report JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_HUD_EXTERNAL_DEPENDENCY_LOAD_CLIP05_VISUAL_RESULT.json`
