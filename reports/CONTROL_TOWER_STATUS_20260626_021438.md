# CONTROL_TOWER_STATUS_20260626_021438

## Scope

- Project: `C:\Users\godho\Downloads\girlswar`
- Control tower remains active.
- Battle worker: `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`
- UI worker: `019eff6c-a02a-7f73-9ffb-74456322d1ce`
- Character/data worker: `019eff6d-307b-7532-8b1d-7105b18cd6b7`

## Current Restored Claims

- Main interface restored claim: `false`
- Battle playable/restored claim: `false`
- Do not call either restored from the current evidence.

## Latest Completed Inputs

Battle latest completed:

- `reports\battle\BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_RESULT.md`

UI latest completed:

- `reports\maininterface\MAININTERFACE_128_OLDROOT_RUNTIME_ACTIVITY_TEXT_TMP_AND_CLICK_LAYER_RECONSTRUCTION_RESULT.md`

Current in-progress tasks:

- `BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION`
- `MAININTERFACE_129_TRACE_RUNTIME_ACCOUNT_ACTIVITY_SNAPSHOT_LOCALIZATION_FONT_BINDING`

No official `BATTLE_51*` or `MAININTERFACE_129*` report files existed at this checkpoint.

## BATTLE51 In-Progress Evidence

Observed from battle worker and current files:

- Battle worker corrected the original bridge chain:
  - `UI_NormalBattle` panel bridge is original `YouYou.LuaForm`, not `YouYou.LuaUnit`.
  - `UI_Battle3DUI` / `UI_BattleBoxPage` use `YouYou.LuaUnit`.
  - `box_item` uses `LuaComponentBinder.LuaComBinder`.
  - `btn_box` uses `YouYou.UIEventListener`.
- BATTLE18/BATTLE50 evidence gives original type ids:
  - `LuaComponentBinder.LuaComBinder` pathId `1924290018182821150`
  - `YouYou.LuaUnit` pathId `3319520142972745523`
  - `YouYou.UIEventListener` pathId `-6333827617915679503`
- Current restored stub was updated:
  - `girlswar_battle_unity\Assets\Scripts\BattleUIComponentTypeStubs.cs`
  - Adds/keeps `YouYou.LuaCom`, `LuaComGroup`, `UIEventListener`, `LuaForm`, `LuaUnit`, `GuideNode`, and `LuaComponentBinder.LuaComBinder`.
  - `UIEventListener` has an `Action onClick` and `IPointerClickHandler` implementation.
  - `LuaForm`/`LuaUnit` expose `LuaScriptPath`, `luaScript`, and `m_LuaComGroups`.
  - `LuaUnit.Init/Open` only mark flags; they do not execute xLua/gameplay.

Interpretation:

- This is a source-backed bridge/stub preparation, not a fake gameplay handler.
- It can help narrow the next blocker, but full handler execution still requires real Lua lifecycle / xLua / `ModulesInit.ProcedureNormalBattle` runtime.
- BATTLE51 must still prove whether `RaycasterManager` registration recovers in runtime/PlayMode and whether listener binding is real.

## UI129 In-Progress Evidence

Observed from UI worker:

- UI129 is building a structured audit script to classify local snapshot candidates instead of dumping raw `rg` output.
- The worker confirmed static localization evidence:
  - `DTLangCommon` contains Korean mappings for `activityname_1004..1008` and `activityname_4100`.
- Interpretation:
  - Localization tables can translate a selected activity id.
  - They do not prove which activity id is active.
  - Actual active slots still require `ActMgr.activitys` / server/account snapshot / redpoint / player level-vip state.

UI129 should produce:

- snapshot candidate CSV
- active reconstruction possible/impossible verdict
- required snapshot schema if no authoritative runtime snapshot exists

## Command Policy

- Root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- Policy remains OK.

## Next Control Actions

1. Poll for `reports\battle\BATTLE_51*`.
2. Poll for `reports\maininterface\MAININTERFACE_129*`.
3. If BATTLE51 proves source-backed bridge plus `EventSystem.RaycastAll`, dispatch local playable subset validation.
4. If BATTLE51 still lacks xLua/runtime objects, dispatch the next task to trace `LuaForm/LuaUnit` lifecycle and `ModulesInit` runtime requirements.
5. If UI129 finds a real activity/account snapshot, dispatch source-backed slot/text reconstruction.
6. If UI129 finds no snapshot, preserve a required snapshot schema and avoid fake slot/text patches.
