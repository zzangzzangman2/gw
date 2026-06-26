# BATTLE_49 Validate Real Click Input And Handler Binding Result

**최종 playable battle screen은 아직 아니다.** BATTLE49는 BATTLE48 ready 좌표로 `EventSystem.RaycastAll`, `GraphicRaycaster.Raycast`, `ExecuteEvents` pointerDown/up/click/submit 경로와 Button handler binding을 검증했다. 직접 `GraphicRaycaster` hit와 `ExecuteEvents` receiver path는 살아났지만, `EventSystem.RaycastAll` target inclusion은 아직 `0`이다.

## Verdict
- visual_status: `real_click_path_reaches_buttons_but_gameplay_handlers_missing`
- final screen claim: `false`
- Unity exit code: `0`
- reference video available: `False` (`C:\Users\godho\Downloads\플레이.mp4`)
- auxiliary reference video available: `True` (`C:\Users\godho\Downloads\참고.mp4`)
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_CONTACT_SHEET.jpg`

## Click Path
- rows / GraphicRaycaster target included / EventSystem target included: `5` / `5` / `0`
- ExecuteEvents click receiver / click path validated: `5` / `5`
- known onClick listener rows / gameplay handler bound rows: `0` / `0`
- total parent missing MonoBehaviours across rows: `34`
- blocker counts: `{'click_path_reaches_button_but_no_bound_gameplay_handler': 5}`

## Handler Binding
- BATTLE44 original Button/targetGraphic PPtr evidence is connected in the row CSV.
- Current restored scene validates the direct GraphicRaycaster + ExecuteEvents Button receiver path; EventSystem.RaycastAll remains incomplete when `eventTargetIncludedCount == 0`.
- Gameplay/Lua/IL2CPP handler binding remains missing unless `gameplayHandlerBoundRows > 0`.
- Local playable payload manifest available: `True`; use only after handler binding is restored, as a local subset validation aid.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_UNITY.json`
- component CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_COMPONENTS.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle49RealClickInputHandlerValidation_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS`
