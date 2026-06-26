# BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK Result

**최종 playable battle screen은 아직 아니다.** BATTLE52는 원본 xLua/GameEntry/LuaManager/ModulesInit 런타임 체인을 끝까지 추적했지만, 현재 복원 Unity 프로젝트에는 실행 가능한 xLua/GameEntry/LuaManager bootstrap이 없어 원본 Lua closure binding을 진행하지 않았다.

## Verdict
- visual_status: `blocked_missing_xlua_runtime_modulesinit_bootstrap_no_fake_handler_patch`
- final screen claim: `false`
- patch decision: `blocked_no_patch`
- Unity edit exit code: `0`
- Unity PlayMode exit code: `-999`
- reference video available: `False` (`C:\Users\godho\Downloads\플레이.mp4`)
- auxiliary reference video available: `True` (`C:\Users\godho\Downloads\참고.mp4`)

## Runtime Availability
- xLua LuaEnv/LuaTable/LuaFunction in restored Unity project: `False` / `False` / `False`
- GameEntry/LuaManager in restored Unity project: `False` / `False`
- actual xLua runtime/package/native plugin assets under `girlswar_battle_unity/Assets`: `0`
- xLua string matches found by Unity probe are self/probe files only: `Assets/Editor/Battle52ConnectXluaRuntimeGameEntryModulesInitEditor.cs | Assets/Editor/Battle52ConnectXluaRuntimeGameEntryModulesInitEditor.cs.meta`
- BATTLE51 bridge still present: LuaForm/LuaUnit/LuaComBinder/UIEventListener = `1` / `2` / `1` / `1`
- original evidence confirms the missing chain: `GameEntry.Lua -> YouYou.LuaManager -> XLua.LuaEnv -> LoadUIScript -> LuaForm/LuaUnit delegates -> decoded UI OnInit/Open`.

## Input Plumbing
- BATTLE51 carryover EventSystem-before/direct/forced target inclusion: `0` / `5` / `5`
- BATTLE52 edit-mode EventSystem/direct/forced target inclusion: `0` / `0` / `0`
- after GraphicRaycaster toggle target inclusion: `0`
- PlayMode target inclusion: `0`
- BATTLE52 edit-mode raycast rows are non-authoritative for hit readiness because Unity logged `EventSystem.current` unknown in batch context; BATTLE51 direct/forced input evidence remains the authoritative carryover.
- edit RaycasterManager before: `typeFound=true | count=0 | `
- PlayMode RaycasterManager: ``

## Handler Binding
- listener bound count: `0`
- Lua lifecycle executed count: `0`
- handler execution: `blocked_missing_xlua_runtime_and_modulesinit_bootstrap`
- no fake `Button.onClick`, fake `UIEventListener` delegate, fake gameplay handler, or fake overlay was added.

## Button Rows
- `btnAuto`: lifecycle/listener/edit/play/forced/direct = `False` / `False` / `False` / `False` / `True` / `True`, blocker=`blocked_missing_xlua_runtime_and_modulesinit_bootstrap`
- `btnBuff`: lifecycle/listener/edit/play/forced/direct = `False` / `False` / `False` / `False` / `True` / `True`, blocker=`blocked_missing_xlua_runtime_and_modulesinit_bootstrap`
- `btnTwoSpeed`: lifecycle/listener/edit/play/forced/direct = `False` / `False` / `False` / `False` / `True` / `True`, blocker=`blocked_missing_xlua_runtime_and_modulesinit_bootstrap`
- `btnFastSkill`: lifecycle/listener/edit/play/forced/direct = `False` / `False` / `False` / `False` / `True` / `True`, blocker=`blocked_missing_xlua_runtime_and_modulesinit_bootstrap`
- `btn_box`: lifecycle/listener/edit/play/forced/direct = `False` / `False` / `False` / `False` / `True` / `True`, blocker=`blocked_missing_xlua_runtime_and_modulesinit_bootstrap`

## Runtime Dependency Schema
- schema CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_RUNTIME_DEPENDENCY_SCHEMA.csv`
- schema JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_RUNTIME_DEPENDENCY_SCHEMA.json`
- type CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_TYPES.csv`
- key blocker: `blocked_missing_xlua_runtime`; even source-backed bridge fields cannot execute decoded `UI_NormalBattle`, `UI_Battle3DUI`, or `UI_BattleBoxPage` without `XLua.LuaEnv`, `GameEntry.Lua`, and `LuaManager.LoadUIScript`.

## Payload Manifest Use
- local playable manifest available: `True`
- use only after real source-backed handler binding; it is not full payload or final restore evidence.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_RESULT.json`
- buttons CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_BUTTONS.csv`
- runtime dependency schema CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_RUNTIME_DEPENDENCY_SCHEMA.csv`
- edit rows CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_EDITMODE.csv`
- PlayMode rows CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_PLAYMODE.csv`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_53_RESTORE_OR_IMPORT_SOURCE_BACKED_XLUA_RUNTIME_AND_MODULESINIT_BOOTSTRAP_OR_ACCEPT_BLOCK`
