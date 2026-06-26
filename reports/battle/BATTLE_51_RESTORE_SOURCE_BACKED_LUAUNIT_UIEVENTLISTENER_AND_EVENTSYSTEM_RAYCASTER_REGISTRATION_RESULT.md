# BATTLE_51 Restore Source Backed LuaUnit UIEventListener And EventSystem Raycaster Registration Result

**최종 playable battle screen은 아직 아니다.** BATTLE51은 원본 prefab typetree에 근거해 Lua bridge 후보 컴포넌트를 최소 복원하고, `EventSystem.RaycastAll` 0 원인을 RaycasterManager 등록/lifecycle 쪽으로 분리했다.

## Verdict
- visual_status: `source_backed_lua_bridge_candidate_restored_eventsystem_forced_registration_validated_but_xlua_runtime_missing`
- final screen claim: `false`
- patch decision: `candidate_bridge_patch_no_fake_handler`
- Unity exit code: `0`
- reference video available: `False` (`C:\Users\godho\Downloads\플레이.mp4`)
- auxiliary reference video available: `True` (`C:\Users\godho\Downloads\참고.mp4`)

## Source-Backed Bridge Patch
- `UI_NormalBattle`: original root `YouYou.LuaForm`, script pathId `8347263561838679580`, `LuaScriptPath=/Download/xLuaLogic/Modules/MainCity/UI_NormalBattle.bytes`.
- `UI_Battle3DUI`: original root `YouYou.LuaUnit`, script pathId `3319520142972745523`, `LuaScriptPath=/Download/xLuaLogic/Modules/MainCity/UI_Battle3DUI.bytes`.
- `UI_BattleBoxPage`: original `YouYou.LuaUnit`, script pathId `3319520142972745523`, `LuaScriptPath=/Download/xLuaLogic/Modules/MainCity/UI_BattleBoxPage.bytes`.
- `box_item`: original `LuaComponentBinder.LuaComBinder`, script pathId `1924290018182821150`, `LuaComs=sp_box Type25; btn_box Type4`.
- `btn_box`: original `YouYou.UIEventListener`, script pathId `-6333827617915679503`.
- bridge rows / added rows: `9` / `5`.

## Input Plumbing
- direct GraphicRaycaster target included: `5` / `5`
- EventSystem target included before forced registration: `0` / `5`
- EventSystem target included after forced RaycasterManager registration: `5` / `5`
- RaycasterManager editor before: `typeFound=true | count=0 | `
- RaycasterManager forced: `typeFound=true | count=9 | BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle:UnityEngine.UI.GraphicRaycaster:enabled=True:active=True ; BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/BottomCenter/HeroListContainer/Battle29BoundHeroCard_3_1034/HeadBar/imgHPBG:UnityEngine.UI.GraphicRaycaster:enabled=True:active=True ; BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle:UnityEngine.UI.GraphicRaycaster:enabled=True:active=True ; BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle:UnityEngine.UI.GraphicRaycaster:enabled=True:active=True ; BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/BottomCenter/HeroListContainer/Battle29BoundHeroCard_1_1036/HeadBar/imgHPBG:UnityEngine.UI.GraphicRaycaster:enabled=True:active=True ; BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage/pop_Content:UnityEngine.UI.GraphicRaycaster:enabled=True:active=True ; BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage/pop_Content/box_item:UnityEngine.UI.GraphicRaycaster:enabled=True:active=True ; BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui:UnityEngine.UI.GraphicRaycaster:enabled=True:active=True ; BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_battle/BottomCenter/HeroListContainer/Battle29BoundHeroCard_2_1002/HeadBar/imgHPBG:UnityEngine.UI.GraphicRaycaster:enabled=True:active=True`
- PlayMode probe: `not_entered_in_b51_batch; forced RaycasterManager registration used as lifecycle-equivalent probe`

## Handler Binding
- known restored Button listener rows: `0`
- UIEventListener delegate rows: `0`
- Lua lifecycle executed rows: `0`
- blocker: `The source-backed bridge components and LuaScriptPath/ComBinder fields are present, but no xLua/GameEntry/ModulesInit runtime executed UI_NormalBattle/UI_Battle3DUI/UI_BattleBoxPage OnInit/Open, so no original closures are bound.`

## Button Rows
- `btnAuto`: event before/forced/direct = `False` / `True` / `True`, handler=`UI_NormalBattle:86-110 ChangeToAuto(true)/ChangeToManual`, execution=`blocked_no_xlua_gameentry_modulesinit_runtime`
- `btnBuff`: event before/forced/direct = `False` / `True` / `True`, handler=`UI_NormalBattle:180-184 ShowBuffView(f==false)`, execution=`blocked_no_xlua_gameentry_modulesinit_runtime`
- `btnTwoSpeed`: event before/forced/direct = `False` / `True` / `True`, handler=`UI_NormalBattle:111-131 SetGameSpeed`, execution=`blocked_no_xlua_gameentry_modulesinit_runtime`
- `btnFastSkill`: event before/forced/direct = `False` / `True` / `True`, handler=`UI_NormalBattle:132-146 ChangeGameFastSkill/CheckFastSkill`, execution=`blocked_no_xlua_gameentry_modulesinit_runtime`
- `btn_box`: event before/forced/direct = `False` / `True` / `True`, handler=`UI_BattleBoxPage:162-178 UIEventListener.onClick showFlyAction/RecycleBoxInstance`, execution=`blocked_no_xlua_gameentry_modulesinit_runtime`

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_RESULT.json`
- components CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_COMPONENTS.csv`
- bridge CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_BRIDGE.csv`
- original bridge CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_ORIGINAL_BRIDGE_COMPONENTS.csv`
- button CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_BUTTONS.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle51LuaBridgeRaycasterRegistrationCandidate_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK`
