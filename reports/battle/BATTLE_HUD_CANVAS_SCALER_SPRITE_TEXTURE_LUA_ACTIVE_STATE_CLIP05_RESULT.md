# 아직 원본 전투 HUD 아님

BATTLE_24 ran the Canvas/Scaler/Sprite.texture/Lua-state probe and compared the capture to `플레이.mp4` clip05 around 486s.

## Visual Verdict
- visual_status: `failed_sprite_texture_blank_canvas_scale_lua_runtime_binding_missing`
- matches_clip05_motion_sequence: `False`
- camera_visible_original_hud: `False`
- final capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleHudCanvasScalerSpriteTextureLuaStateClip05_1680x720.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_24_CANVAS_SCALER_SPRITE_TEXTURE_LUA_STATE_CLIP05_CONTACT_SHEET.jpg`
- visible sprite sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_24_VISIBLE_HUD_SPRITE_TEXTURE_SHEET.jpg`

## Why It Still Fails
- active visible sprite rows with blank texture: `46`
- large active blank-texture rows: `6`
- suspicious canvas/scale rows: `83`
- capture nearWhiteRatio: `0.1421164021164021`
- capture nearBlackRatio: `0.5926984126984127`
- clip05 Lua active-state fix count: `246`
- canvas fix count: `8`

## Key Interpretation
- The BATTLE_24 capture is cleaner than BATTLE_23 but still not the original battle screen.
- `root_buff` was hidden only as a capture-time active-state probe, not as a proven final restore.
- Most active visible sprites still have a sprite name but no texture name/size, so Unity is drawing white/default shapes.
- The clip05 video has real battle background, characters, bottom skill cards, and right controls; this capture still does not.

## Representative Blank Texture Rows
- `ba_xuecao_bg` `0.001067` `BattleHudCanvasScalerSpriteTextureLuaStateClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/imgBG`
- `ba_xuecao_bg4` `0` `BattleHudCanvasScalerSpriteTextureLuaStateClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/im_mask`
- `battlehead1001` `0` `BattleHudCanvasScalerSpriteTextureLuaStateClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/im_mask/imgPlayerHeadIcon`
- `Image_blank` `0` `BattleHudCanvasScalerSpriteTextureLuaStateClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/imgPlayerHPBG`
- `ba_xuecao_bg1` `0` `BattleHudCanvasScalerSpriteTextureLuaStateClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/imgPlayerHPBG/bg`
- `ba_xuecao_bg5` `0` `BattleHudCanvasScalerSpriteTextureLuaStateClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/imgPlayerHPBG/imgPlayerHP_Red`
- `ba_xuecao_bg3` `0` `BattleHudCanvasScalerSpriteTextureLuaStateClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/imgPlayerHPBG/imgPlayerHP`
- `guanzhi_maozi1` `0` `BattleHudCanvasScalerSpriteTextureLuaStateClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/bg_guanzhi`
- `UI_up` `0.000467` `BattleHudCanvasScalerSpriteTextureLuaStateClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/PlayerInfo/img_yazhi`
- `ba_xuecao_bg` `0.000986` `BattleHudCanvasScalerSpriteTextureLuaStateClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/EnemyInfo/imgBG`
- `ba_xuecao_bg4` `0` `BattleHudCanvasScalerSpriteTextureLuaStateClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/EnemyInfo/im_mask`
- `battlehead1002` `0` `BattleHudCanvasScalerSpriteTextureLuaStateClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/root_top/TopCenter/EnemyInfo/im_mask/imgPlayerHeadIcon`

## Lua Evidence
- `ProcedureNormalBattle` passes `{showOperMenu=e.showOperMenu}` to `UI_NormalBattle`; SetLeftInfo/SetRightInfo only store data.
- BATTLE_24 did not find enough UI_NormalBattle runtime binding to safely assign head/skill/buff sprites.
- evidence hit count: `120`

## Next Blocker
- `BATTLE_25_RESOLVE_SPRITE_TEXTURE_ATLAS_AND_UI_NORMALBATTLE_RUNTIME_BINDING`

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_HUD_CANVAS_SCALER_SPRITE_TEXTURE_LUA_ACTIVE_STATE_CLIP05_RESULT.json`
- Unity JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_CANVAS_SCALER_SPRITE_TEXTURE_LUA_ACTIVE_STATE_CLIP05.json`
- components CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_CANVAS_SCALER_SPRITE_TEXTURE_LUA_ACTIVE_STATE_CLIP05_COMPONENTS.csv`
