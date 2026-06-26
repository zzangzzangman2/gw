# CONTROL_TOWER_STATUS_20260626_023013

## Scope

- Project: `C:\Users\godho\Downloads\girlswar`
- Overall status: not final restored.
- Main reference image: `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png`
- `C:\Users\godho\Downloads\참고.mp4`: auxiliary reference only.
- `C:\Users\godho\Downloads\플레이.mp4`: still missing.

## MainInterface Current State

Latest completed task:
- `MAININTERFACE_130_RUNTIME_ACTIVITY_SNAPSHOT_IMPORT_REPLAY_PIPELINE_NO_FAKE_PATCH`

Verdict:
- `restoredClaim=false`
- No scene visual patch.
- Runtime snapshot replay pipeline exists and correctly refuses fake defaults.
- Default template replay status: `blocked_missing_runtime_snapshot_fields`
- Candidate patch allowed: `false`

Important outputs:
- `reports\maininterface\MAININTERFACE_130_RUNTIME_ACTIVITY_SNAPSHOT_IMPORT_REPLAY_PIPELINE_NO_FAKE_PATCH_RESULT.md`
- `reports\maininterface\MAININTERFACE_130_RUNTIME_ACTIVITY_SNAPSHOT_IMPORT_REPLAY_PIPELINE_NO_FAKE_PATCH_RESULT.json`
- `reports\maininterface\MAININTERFACE_130_runtime_activity_snapshot_template.json`
- `reports\maininterface\MAININTERFACE_130_runtime_activity_snapshot_replay_result.md`
- `reports\maininterface\MAININTERFACE_130_runtime_activity_snapshot_replay_result.json`
- `reports\maininterface\MAININTERFACE_130_replayable_fields.csv`
- `_restore_tools\scripts\maininterface130_runtime_activity_snapshot_replay.py`

Main UI blocker:
- Real `ActMgr.activitys` plus account/server runtime fields are required before activity slots/text/spines can be source-backed.
- Missing fields include `activitys`, `playerInfo.level`, `playerInfo.vip`, redpoint ids, review flags, guide state, server time, and client callback outputs.

Guardrails remain:
- No arbitrary `node_act_btn/btn_act_*` hide.
- No `btn_discord` review hide.
- No `UI_bg` raycast-off.
- No fake icon/text/spine.
- No screenshot or whole-atlas paste.

## Battle Current State

Latest completed task:
- `BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK`

Verdict:
- `isFinalRestoredBattleScreen=false`
- `visual_status=blocked_missing_xlua_runtime_modulesinit_bootstrap_no_fake_handler_patch`
- `patchDecision=blocked_no_patch`
- xLua runtime in restored Unity project:
  - `XLua.LuaEnv=false`
  - `XLua.LuaTable=false`
  - `XLua.LuaFunction=false`
- `YouYou.GameEntry=false`
- `YouYou.LuaManager=false`
- Listener bound count: `0`
- Lua lifecycle executed count: `0`
- Handler execution: `blocked_missing_xlua_runtime_and_modulesinit_bootstrap`

Important outputs:
- `reports\battle\BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_RESULT.md`
- `reports\battle\BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_RESULT.json`
- `reports\battle\BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_BUTTONS.csv`
- `reports\battle\BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_RUNTIME_DEPENDENCY_SCHEMA.csv`
- `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_TYPES.csv`
- `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_EDITMODE.json`

Carryover correction:
- BATTLE52 top-level result JSON has a summary inconsistency: `sourceBackedBridgeStillPresent` is null.
- The edit-mode JSON is the better evidence for bridge persistence:
  - `luaFormCount=1`
  - `luaUnitCount=2`
  - `luaComBinderCount=1`
  - `uiEventListenerCount=1`
- Therefore the current interpretation is: BATTLE51 bridge stubs persist, but they cannot execute original Lua because executable xLua/GameEntry/LuaManager bootstrap is missing.

Input plumbing note:
- BATTLE51 showed forced `RaycasterManager` registration can make `EventSystem` target inclusion `5/5`.
- BATTLE52 edit probe shows hit counts `0`, likely a probe mismatch/depth-registration regression and not the primary blocker.
- Primary blocker for gameplay remains xLua/GameEntry/LuaManager/ModulesInit bootstrap absence.

Button-level BATTLE52 blockers:
- `btnAuto`: needs `XLua.LuaEnv`, `GameEntry.Lua/LuaManager.LoadUIScript`, `ModulesInit.ProcedureNormalBattle`, `GameFunction/GameFunctionType`, `ModulesInit.PhotoArtistMgr`, `LuaUtils`
- `btnBuff`: needs `XLua.LuaEnv`, `GameEntry.Lua/LuaManager.LoadUIScript`, `LuaUtils`, `ModulesInit.ProcedureNormalBattle:GetAllBuffIconShowMap`
- `btnTwoSpeed`: needs `XLua.LuaEnv`, `GameEntry.Lua/LuaManager.LoadUIScript`, `ModulesInit.ProcedureNormalBattle`, `SaveMgr`, `PlayerMgr`, `GameTools`, `SetTimeScaleType`, `LuaUtils`
- `btnFastSkill`: needs `XLua.LuaEnv`, `GameEntry.Lua/LuaManager.LoadUIScript`, `ModulesInit.ProcedureNormalBattle`, `SaveMgr`, `PlayerMgr`, `GameFunction/GameFunctionType`, `LuaUtils`
- `btn_box`: needs `XLua.LuaEnv`, `UI_Battle3DUI`/`UI_BattleBoxPage` LuaUnit lifecycle, `LuaComponentBinder.GetComponents`, `ModulesInit.ProcedureNormalBattle.dropBoxData/GetWaveData`, `UIUtil`, `DOTween`, `GameEntry.CameraCtrl`

## BATTLE53 Delegated

`BATTLE_53_RESTORE_OR_IMPORT_SOURCE_BACKED_XLUA_RUNTIME_AND_MODULESINIT_BOOTSTRAP_OR_ACCEPT_BLOCK` has been sent to the battle worker.

BATTLE53 objective:
- Inventory local/source-backed xLua runtime import candidates.
- Classify candidates as importable editor runtime, type-signature-only, native-player-only, external package requiring approval, or not found.
- Do not download or install external xLua without explicit approval.
- If no local source-backed runtime exists, accept block as `accepted_block_no_source_backed_xlua_runtime_available_locally`.
- Preserve `isFinalRestoredBattleScreen=false`.

## Command Policy

Latest checked:
- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- root command file: `00_COMMAND_CENTER.cmd`

## Next Actions

1. Poll BATTLE53 artifacts.
2. If BATTLE53 finds a local executable source-backed xLua runtime candidate, review import plan before patching gameplay.
3. If BATTLE53 finds only IL2CPP dump/DummyDll/native player artifacts, accept block and ask for original runtime source/binary or explicit approval to try a non-source-backed xLua package.
4. Keep main UI blocked until a real account/server runtime snapshot is provided and passes UI130 replay.
