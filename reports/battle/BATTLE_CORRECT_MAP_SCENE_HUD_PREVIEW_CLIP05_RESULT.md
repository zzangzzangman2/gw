# BATTLE_27 Correct Map Scene HUD Preview

This is not a final restored battle screen. It replaces the rejected debug/text-heavy capture with a video-matched map preview and carries over the BATTLE_25 original HUD sprite binding.

## Verdict
- visual_status: `improved_correct_map_and_hud_preview_not_final`
- reference video: `C:\Users\godho\Downloads\플레이.mp4` clip05 around 486s
- chosen map evidence: `map_11003` from BATTLE_26 video similarity
- runtime flow manifest mapId: `11001`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleCorrectMapSceneHudPreviewClip05_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_27_CORRECT_MAP_SCENE_HUD_PREVIEW_CLIP05_CONTACT_SHEET.jpg`

## Screen Gate
- capture exists: `True`
- nearWhiteRatio: `0.000265`
- nearBlackRatio: `0.071402`
- magentaRatio: `0.000238`
- visiblePixelRatio: `0.91336`
- finalCaptureHasLargeWhiteBlocks: `False`
- finalCaptureHasMagentaMissingShader: `False`
- debugTextExpectedVisible: `False`
- disabledNonHudTextCount: `0`

## Restored Evidence Used
- correctMapLayersLoaded: `True`
- mapLayerCreatedCount: `10`
- runtimeActorSlots: `12`
- runtimeActorInstantiatedCount: `3`
- runtimeActorEnabledRendererCount: `3`
- runtimeActorEnabledGraphicCount: `0`
- runtimeActorSpineComponentCount: `0`
- runtimeActorMaterialFallbackCount: `4`
- runtimeActorRenderOrderFixCount: `3`
- runtimeActorAtlasTextureAssignCount: `0`
- runtimeActorAtlasTextureBoundMaterialCount: `4`

## Map Layers
- `11003.assetbundle` role `original_battlemap_prefab_scene_bundle` created `True` world `0x0`
- `Map_11003_11` role `pixel_space_sky_mountain_strip_from_video_1920x1080` created `True` world `15.55556x2.231482`
- `Map_11003_5` role `pixel_space_background_buildings_from_video_1920x1080` created `True` world `17.77778x4.009259`
- `Map_11003_4_2` role `pixel_space_center_house_from_original_prefab_name_bg4_2` created `True` world `9.351851x3.861111`
- `Map_11003_4_1` role `pixel_space_center_house_curtain_from_original_prefab_name_bg4_1` created `True` world `3.037037x1.064815`
- `Map_11003_3` role `pixel_space_midground_debris_from_video_1920x1080` created `True` world `17.77778x2.518518`
- `Map_11003_2` role `pixel_space_stone_floor_video_best_match` created `True` world `17.77778x5.546296`
- `Map_11003_1_3` role `pixel_space_bottom_foreground_from_original_prefab_name_bg1_3` created `True` world `4.722222x1.583333`
- `Map_11003_1_4` role `pixel_space_bottom_foreground_from_original_prefab_name_bg1_4` created `True` world `5.694445x1.37037`
- `Map_11003_1_1` role `pixel_space_bottom_foreground_from_original_prefab_name_bg1_1` created `True` world `3.351852x1.62037`

## Actor Slots
- `our` wave `0` slot `1` model `1036` instantiated `False` renderers `0` graphics `0` atlasLoaded `False` atlasAssign `0` atlasBound `0` reason `listed_in_cdn_versionfile_not_extracted`
- `our` wave `0` slot `2` model `1002` instantiated `True` renderers `1` graphics `0` atlasLoaded `True` atlasAssign `0` atlasBound `1` reason ``
- `our` wave `0` slot `3` model `1034` instantiated `True` renderers `1` graphics `0` atlasLoaded `True` atlasAssign `0` atlasBound `2` reason ``
- `enemy` wave `1` slot `1` model `3001` instantiated `True` renderers `1` graphics `0` atlasLoaded `True` atlasAssign `0` atlasBound `1` reason ``
- `enemy` wave `1` slot `2` model `1100112` instantiated `False` renderers `0` graphics `0` atlasLoaded `False` atlasAssign `0` atlasBound `0` reason `not_loadable_yet`
- `enemy` wave `1` slot `3` model `1100113` instantiated `False` renderers `0` graphics `0` atlasLoaded `False` atlasAssign `0` atlasBound `0` reason `not_loadable_yet`
- `enemy` wave `2` slot `1` model `1100121` instantiated `False` renderers `0` graphics `0` atlasLoaded `False` atlasAssign `0` atlasBound `0` reason `not_loadable_yet`
- `enemy` wave `2` slot `2` model `1100122` instantiated `False` renderers `0` graphics `0` atlasLoaded `False` atlasAssign `0` atlasBound `0` reason `not_loadable_yet`
- `enemy` wave `2` slot `3` model `1100123` instantiated `False` renderers `0` graphics `0` atlasLoaded `False` atlasAssign `0` atlasBound `0` reason `not_loadable_yet`
- `enemy` wave `3` slot `1` model `1100131` instantiated `False` renderers `0` graphics `0` atlasLoaded `False` atlasAssign `0` atlasBound `0` reason `not_loadable_yet`
- `enemy` wave `3` slot `2` model `1100132` instantiated `False` renderers `0` graphics `0` atlasLoaded `False` atlasAssign `0` atlasBound `0` reason `not_loadable_yet`
- `enemy` wave `3` slot `3` model `1100133` instantiated `False` renderers `0` graphics `0` atlasLoaded `False` atlasAssign `0` atlasBound `0` reason `not_loadable_yet`

## Why This Still Is Not Final
- single Unity capture does not prove battle motion/animation against play.mp4
- bottom skill-card runtime binding is still not proven
- runtime flow manifest says mapId=11001 but video evidence prefers map_11003, so the source mismatch must be resolved

## Next Blocker
- `BATTLE_28_RESTORE_BATTLE_ACTOR_SPINE_RUNTIME_MOTION_AND_BOTTOM_SKILL_CARDS`

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_CORRECT_MAP_SCENE_HUD_PREVIEW_CLIP05_RESULT.json`
- Unity JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_CORRECT_MAP_SCENE_HUD_PREVIEW_CLIP05.json`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_27_CORRECT_MAP_SCENE_HUD_PREVIEW_CLIP05_CONTACT_SHEET.jpg`
