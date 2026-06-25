# 아직 원본 전투 HUD 아님

BATTLE_25 ran the Sprite atlas texture/runtime binding probe and compared the capture to `플레이.mp4` clip05 around 486s.

## Visual Verdict
- visual_status: `failed_missing_battle_scene_actors_skill_cards_runtime_camera`
- matches_clip05_motion_sequence: `False`
- partial_original_hud_visible: `True`
- complete_video_matching_battle_ui: `False`
- final capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleHudSpriteAtlasTextureRuntimeBindingClip05_1680x720.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_25_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05_CONTACT_SHEET.jpg`
- visible sprite sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_25_VISIBLE_HUD_SPRITE_TEXTURE_SHEET.jpg`

## Why It Still Fails
- active visible sprite rows with blank texture: `0`
- large active blank-texture rows: `0`
- active visible extracted sprite bindings: `46`
- extracted sprite texture bind count: `290`
- extracted sprite texture bound visible count: `47`
- suspicious canvas/scale rows: `83`
- capture nearWhiteRatio: `0.0002777777777777778`
- capture nearBlackRatio: `0.6722619047619047`
- clip05 Lua active-state fix count: `246`
- canvas fix count: `8`

## Key Interpretation
- BATTLE_25 fixed the visible blank sprite texture problem for the main top/right HUD pieces.
- The capture is now a partial original HUD, not the white/debug placeholder from the rejected screenshot.
- It is still not the original battle screen because the video shows battle background, moving actors, bottom skill cards, and combat motion.
- `root_buff` was hidden only as a capture-time active-state probe, not as a proven final restore.
- The center dark grid/panel is not accepted as real battle gameplay.

## Representative Bound Sprite Rows
- `ba_xuecao_bg` `283x96` `download/artsources/uispriteres/uibattle.assetbundle` `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/imgBG`
- `ba_xuecao_bg4` `89x90` `download/artsources/uispriteres/uibattle.assetbundle` `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/im_mask`
- `battlehead1001` `89x90` `download/artsources/uispriteres/uiheroheadbattle.assetbundle` `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/im_mask/imgPlayerHeadIcon`
- `Image_blank` `2x2` `download/artsources/uispriteres/uicommonother.assetbundle` `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/imgPlayerHPBG`
- `ba_xuecao_bg1` `279x30` `download/artsources/uispriteres/uibattle.assetbundle` `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/imgPlayerHPBG/bg`
- `ba_xuecao_bg5` `279x30` `download/artsources/uispriteres/uibattle.assetbundle` `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/imgPlayerHPBG/imgPlayerHP_Red`
- `ba_xuecao_bg3` `279x30` `download/artsources/uispriteres/uibattle.assetbundle` `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/imgPlayerHPBG/imgPlayerHP`
- `guanzhi_maozi1` `142x89` `download/artsources/uispriteres/uicommonother.assetbundle` `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/bg_guanzhi`
- `UI_up` `41x47` `download/artsources/uispriteres/uicommonother.assetbundle` `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/img_yazhi`
- `ba_xuecao_bg` `283x96` `download/artsources/uispriteres/uibattle.assetbundle` `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/EnemyInfo/imgBG`
- `ba_xuecao_bg4` `89x90` `download/artsources/uispriteres/uibattle.assetbundle` `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/EnemyInfo/im_mask`
- `battlehead1002` `89x90` `download/artsources/uispriteres/uiheroheadbattle.assetbundle` `BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/EnemyInfo/im_mask/imgPlayerHeadIcon`

## Lua Evidence
- `ProcedureNormalBattle` passes `{showOperMenu=e.showOperMenu}` to `UI_NormalBattle`; SetLeftInfo/SetRightInfo only store data.
- BATTLE_25 still does not reconstruct the full runtime battle scene, actor placement, or bottom skill-card data flow.
- evidence hit count: `120`

## Next Blocker
- `BATTLE_26_RESTORE_BATTLE_SCENE_ACTORS_SKILL_CARDS_AND_RUNTIME_CAMERA`

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_HUD_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05_RESULT.json`
- Unity JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05.json`
- components CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05_COMPONENTS.csv`
