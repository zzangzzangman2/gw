# BATTLE_38 Match Actor Scale Camera Timing And Battle Scene Context To Clip05 Result

**원본 clip05 actor motion/layout/timing은 아직 재현 안 됐다.** BATTLE38은 `플레이.mp4` 485.0-487.0s sequence와 runtime actor sequence를 비교했지만, actor-only context라 clip05 전투 화면으로 볼 수 없다.

## Verdict
- visual_status: `failed_battle_scene_context_map_hud_missing`
- final screen claim: `false`
- reference video used: `True` (`플레이.mp4` 485.0-487.0s, frames `6`)
- actor motion/layout/timing replayed: `False`
- Unity exit code: `0`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_CONTACT_SHEET.jpg`

## Layout / Context Comparison
- reference actor boxes: `181`
- runtime actor boxes: `16`
- actor center gap norm: `0.020345`
- runtime/reference actor area ratio: `0.227836`
- runtime has battle map/HUD: `False` / `False`
- BATTLE29 context map layers/cards: `10` / `3`

## Runtime Actor Evidence
- mesh hash changed actors: `3` / `3`
- AnimationState SetAnimation success: `3` / `3`
- shader rebind applied: `4`
- magenta pixel ratio: `0.000387`

## Evidence Notes
- Lua/formation/camera/timing evidence rows: `80`
- Existing BATTLE29 map/HUD/card context and BATTLE37 actor runtime are separate; joining them needs evidence-backed scene context, not coordinate-only placement.

## Blocker
- Actor runtime motion exists, but BATTLE38 remains actor-only: original map/HUD/context from clip05 is not attached to the runtime actor scene.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05.json`
- Unity probe JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_UNITY.json`
- actor bounds CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_ACTOR_BOUNDS.csv`
- comparison CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_COMPARISON.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle38MatchActorScaleCameraTimingAndBattleSceneContextToClip05_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE`
