# BATTLE_50 Trace Original Lua IL2CPP Button Handler Binding And Missing Scripts Result

**최종 playable battle screen은 아직 아니다.** BATTLE50은 BATTLE49의 5개 ready button에 대해 원본 Lua handler, 원본 Button/targetGraphic PPtr, restored scene missing component chain, EventSystem.RaycastAll 원인을 분리했다.

## Verdict
- visual_status: `original_lua_handlers_traced_but_missing_bridge_and_eventsystem_registration_block_patch`
- final screen claim: `false`
- patch decision: `blocked_no_patch`
- Unity exit code: `0`
- reference video available: `False` (`C:\Users\godho\Downloads\플레이.mp4`)
- auxiliary reference video available: `True` (`C:\Users\godho\Downloads\참고.mp4`)

## Handler Evidence
- `btnAuto`: `UI_NormalBattle` lines `86-110`, `btnAuto.onClick:AddListener`, calls `ChangeToAuto(true)` or `ChangeToManual()`.
- `btnBuff`: `UI_NormalBattle` lines `180-184`, `btnBuff.onClick:AddListener`, calls `ShowBuffView(f==false)`.
- `btnTwoSpeed`: `UI_NormalBattle` lines `111-131`, calls `ModulesInit.ProcedureNormalBattle.SetGameSpeed()`.
- `btnFastSkill`: `UI_NormalBattle` lines `132-146`, calls `ChangeGameFastSkill()` and `CheckFastSkill()`.
- `btn_box`: `UI_BattleBoxPage` lines `162-178`, requires `CS.YouYou.UIEventListener` and assigns `s.onClick=function()`.
- `UI_Battle3DUI` lines `3-20` require `UI_BattleBoxPage:GetComponent(typeof(CS.YouYou.LuaUnit)):Init/Open`.

## Current Restored Blockers
- direct GraphicRaycaster target included: `5` / `5`
- EventSystem target included: `0` / `5`
- EventSystem target after raycaster toggle probe: `0` / `5`
- source-backed handler evidence rows: `6`
- known restored UnityEvent/EventTrigger rows: `0` / `0`
- missing MonoBehaviours on button/parents total: `34`
- EventSystem root-cause counts: `{'raycaster_manager_registration_missing_while_direct_graphicraycaster_hits': 5}`

## Patch Decision
- `blocked_no_patch`: original Lua handler path is identified, but the restored scene lacks the source-backed bridge components that execute Lua `OnInit`/`Open` and bind runtime listeners.
- Candidate binding must restore `CS.YouYou.LuaUnit` / Lua binding lifecycle and `CS.YouYou.UIEventListener` where original Lua requires it. Fake `onClick` or fake gameplay handler was not added.
- `BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST` remains a local subset runtime aid only after handler binding is restored.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_RESULT.json`
- EventSystem CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_EVENTSYSTEM.csv`
- handler CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_HANDLERS.csv`
- missing chain CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_MISSING_CHAIN.csv`
- button summary CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_BUTTONS.csv`
- decoded Lua dir: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_50_DECODED_MAINCITY_LUA`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle50OriginalLuaIl2cppButtonHandlerTrace_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION`
