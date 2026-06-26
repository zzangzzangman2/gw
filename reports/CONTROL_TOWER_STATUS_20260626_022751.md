# CONTROL_TOWER_STATUS_20260626_022751

## Scope

- Project: `C:\Users\godho\Downloads\girlswar`
- Control status: not final restored.
- Main reference image: `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png`
- `C:\Users\godho\Downloads\참고.mp4`: auxiliary reference only.
- `C:\Users\godho\Downloads\플레이.mp4`: still missing.

## Latest MainInterface Status

`MAININTERFACE_130_RUNTIME_ACTIVITY_SNAPSHOT_IMPORT_REPLAY_PIPELINE_NO_FAKE_PATCH` is complete.

Key result:
- `restoredClaim=false`
- No scene visual patch was applied.
- Runtime snapshot replay pipeline exists at `_restore_tools\scripts\maininterface130_runtime_activity_snapshot_replay.py`.
- Default template replay correctly fails with `blocked_missing_runtime_snapshot_fields`.
- Candidate patch is not allowed until real server/account/runtime snapshot data is provided.

Important outputs:
- `reports\maininterface\MAININTERFACE_130_RUNTIME_ACTIVITY_SNAPSHOT_IMPORT_REPLAY_PIPELINE_NO_FAKE_PATCH_RESULT.md`
- `reports\maininterface\MAININTERFACE_130_RUNTIME_ACTIVITY_SNAPSHOT_IMPORT_REPLAY_PIPELINE_NO_FAKE_PATCH_RESULT.json`
- `reports\maininterface\MAININTERFACE_130_runtime_activity_snapshot_template.json`
- `reports\maininterface\MAININTERFACE_130_runtime_activity_snapshot_replay_result.md`
- `reports\maininterface\MAININTERFACE_130_runtime_activity_snapshot_replay_result.json`
- `reports\maininterface\MAININTERFACE_130_replayable_fields.csv`

Missing fields blocking source-backed activity reconstruction:
- `activitys`
- `playerInfo.level`
- `playerInfo.vip`
- `redPointState.serverRedPointIds`
- review flags
- guide state
- server time fields
- client callback outputs for show/open/name/jump decisions

Guardrail: no activity-slot hide, no `btn_discord` review-hide, no `UI_bg` raycast-off, no fake icon/text/spine, no screenshot/whole-atlas patch.

## Latest Battle Status

`BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION` is complete.

Key result:
- `isFinalRestoredBattleScreen=false`
- `patchDecision=candidate_bridge_patch_no_fake_handler`
- Source-backed bridge candidates survive reopen:
  - `YouYou.LuaForm=1`
  - `YouYou.LuaUnit=2`
  - `LuaComponentBinder.LuaComBinder=1`
  - `YouYou.UIEventListener=1`
- Direct `GraphicRaycaster` target included: `5/5`
- `EventSystem.RaycastAll` before forced registration: `0/5`
- `EventSystem.RaycastAll` after forced `RaycasterManager` registration: `5/5`
- Restored Button listener rows: `0`
- UIEventListener delegate rows: `0`
- Lua lifecycle executed rows: `0`

Important outputs:
- `reports\battle\BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_RESULT.md`
- `reports\battle\BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_RESULT.json`
- `reports\battle\BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_BUTTONS.csv`
- `reports\battle\BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_ORIGINAL_BRIDGE_COMPONENTS.csv`
- `girlswar_battle_unity\Assets\Scenes\Battle51LuaBridgeRaycasterRegistrationCandidate.unity`
- `girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle51LuaBridgeRaycasterRegistrationCandidate_1920x1080.png`

Current battle blocker:
- `BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK`

Early BATTLE52 thread findings before artifact output:
- Original IL2CPP evidence includes `XLua.LuaEnv`, `YouYou.GameEntry.Lua`, `YouYou.LuaManager`, `YouYou.LuaForm`, `YouYou.LuaUnit`, `YouYou.UIEventListener`, and `LuaComponentBinder.LuaComBinder`.
- Current `girlswar_battle_unity\Assets` appears not to contain the actual xLua runtime package/native plugin.
- `ModulesInit.ProcedureNormalBattle` appears to require Lua module graph binding, not just a single C# procedure type.
- BATTLE52 artifact files have not been created yet as of this report.

## Worker Threads

- UI worker `019eff6c-a02a-7f73-9ffb-74456322d1ce`: UI130 completed.
- Battle worker `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`: BATTLE52 in progress; checkpoint follow-up sent to prioritize blocked report output if PlayMode probe takes too long.
- Character/data worker `019eff6d-307b-7532-8b1d-7105b18cd6b7`: local playable payload manifest complete; use only after source-backed handler binding executes.

## Command Policy

- Root `.cmd` count must remain `1`: `00_COMMAND_CENTER.cmd`
- `_restore_tools` direct `.cmd` count must remain `0`
- Archive wrappers under `_restore_tools\cmd_archive` are allowed.

Latest checked values:
- root `.cmd`: `1`
- `_restore_tools` direct `.cmd`: `0`

## Next Actions

1. Poll BATTLE52 artifacts.
2. If BATTLE52 confirms missing xLua runtime/package, decide whether to reconstruct/import a source-backed xLua runtime bridge or stop at dependency schema.
3. If BATTLE52 proves PlayMode RaycasterManager registers naturally, separate input-plumbing blocker from xLua/lifecycle blocker.
4. Do not claim final battle restore until original handler path, EventSystem input, and minimal runtime handler execution are verified.
5. Do not claim main UI restore until a real activity/account runtime snapshot passes UI130 replay and reference/click validation.
