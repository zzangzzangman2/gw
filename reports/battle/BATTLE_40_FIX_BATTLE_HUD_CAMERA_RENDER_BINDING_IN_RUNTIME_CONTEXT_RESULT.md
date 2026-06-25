# BATTLE_40 Fix Battle HUD Camera Render Binding In Runtime Context Result

**원본 clip05 actor motion/layout/timing + map/HUD context는 아직 재현 안 됐다.** BATTLE40는 HUD Canvas가 이미 ScreenSpaceCamera/worldCamera에 묶여 있음을 확인했지만, 재오픈된 runtime context에서 resolved Graphic/Image가 0이라 최종 capture에 HUD/card가 렌더되지 않는다.

## Verdict
- visual_status: `failed_hud_graphic_components_missing_after_scene_reload`
- final screen claim: `false`
- reference video used: `True` (`플레이.mp4` 485.0-487.0s)
- camera-visible HUD/cards: `False`
- actor motion/layout/timing + map/HUD context replayed: `False`
- Unity exit code: `0`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_CONTACT_SHEET.jpg`

## HUD Camera Binding
- canvas fix count: `0`
- extracted sprite/texture rebind count: `0`
- resolved active Graphic rows: `0`
- resolved Image rows: `0`
- after ScreenSpaceCamera canvas rows: `18`
- before/after Image texture rows: `0` / `0`
- after active graphic count: `0`
- HUD visibility reason: `HUD/card regions still do not match BATTLE29/clip05 reference visibility.`
- top/bottom/right zone votes: `2`

## Actor Context Gate
- reference/runtime actor boxes: `181` / `0`
- actor center gap norm: `None`
- runtime/reference actor area ratio: `None`
- actor placement remains candidate unless original formation/camera runtime binding is traced.

## Diagnostics
- canvas CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_CANVAS_DIFF.csv`
- components CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_COMPONENTS.csv`
- actor bounds CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_ACTOR_BOUNDS.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle40HudCameraRenderBindingRuntimeContext_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_CONTACT_SHEET.jpg`

## Blocker
- HUD canvases are already ScreenSpaceCamera/worldCamera-bound, but the reopened BATTLE39/BATTLE40 scene has zero resolved active Graphic/Image rows; the issue is runtime UI component/sprite texture persistence, not only camera render binding.

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE`
