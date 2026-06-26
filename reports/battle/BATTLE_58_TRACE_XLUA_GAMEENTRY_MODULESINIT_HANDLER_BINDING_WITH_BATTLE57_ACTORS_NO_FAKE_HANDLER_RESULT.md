# BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER Result

**최종 playable battle screen은 아직 아니다.** BATTLE58 audits BATTLE57 actor-ready candidate input/handler binding and traces original xLua/GameEntry/ModulesInit requirements without fake handlers.

## Verdict
- visual_status: `blocked_missing_xlua_gameentry_modulesinit_bootstrap_no_fake_handler_patch`
- final screen claim: `false`
- patch decision: `blocked_no_patch`
- scene saved: `false`
- handler binding applied: `false`
- next blocker: `SOURCE_BACKED_XLUA_GAMEENTRY_LUAMANAGER_RUNTIME_REQUIRED_FOR_ORIGINAL_HANDLER_BINDING_AND_FULL_PAYLOAD_GAPS`

## Button Audit
- active/interactable rows: `5` / `5`
- direct GraphicRaycaster target included: `5` / `5`
- EventSystem target before/forced: `0` / `5`
- known onClick rows: `0`
- UIEventListener present/delegate rows: `1` / `0`
- handler-bound rows: `0`

## Runtime Trace
- xLua runtime available in restored Unity project: `false`
- GameEntry/LuaManager available: `false` / `false`
- Lua lifecycle executed rows: `0`
- source trace rows: `26`
- dependency graph rows: `22`

## Decision
- No source-backed binding was applied. The original handler functions are traced, but the executable bootstrap is still absent: `XLua.LuaEnv`, `GameEntry.Lua`, `LuaManager.LoadUIScript`, and initialized `ModulesInit.ProcedureNormalBattle` are not available in the restored Unity project.
- BATTLE57 actor rendering remains source-backed and valid, but actor visibility is not a gameplay handler or full payload proof.
- Full payload remains separate: local actors are a subset only, with missing actor/common skill dependency gaps recorded.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_RESULT.json`
- HUD/button handler audit CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_HUD_BUTTON_HANDLER_AUDIT.csv`
- click validation CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_CLICK_VALIDATION.csv`
- xLua/GameEntry/ModulesInit source trace CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_XLUA_GAMEENTRY_MODULESINIT_SOURCE_TRACE.csv`
- Lua dependency graph CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_LUA_DEPENDENCY_GRAPH.csv`
- full payload gaps CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_FULL_PAYLOAD_GAPS.csv`

## Command Policy
- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- `플레이.mp4`: `missing`
- `참고.mp4`: `available, auxiliary only`
