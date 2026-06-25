# BATTLE_39 Attach Runtime Actors To Map11003 HUD Context With Evidence Result

**원본 clip05 actor motion/layout/timing + map/HUD context는 아직 재현 안 됐다.** BATTLE39는 BATTLE29 map_11003/HUD/card object가 있는 scene에 runtime actor 3명을 붙였지만, 최종 capture에는 clip05/BATTLE29의 HUD/card regions가 camera-visible하지 않고 actor placement도 original runtime verified가 아니다.

## Verdict
- visual_status: `failed_hud_context_not_camera_visible_in_candidate_capture`
- final screen claim: `false`
- reference video used: `True` (`플레이.mp4` 485.0-487.0s, frames `6`)
- actor motion/layout/timing + map/HUD context replayed: `False`
- placement original runtime verified: `False`
- Unity exit code: `0`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_CONTACT_SHEET.jpg`

## Context Attach
- base BATTLE29 scene opened: `True`
- map/HUD/cards present: `True` / `True` / `True`
- camera-visible HUD/cards: `False`
- disabled old BATTLE27 actor roots: `3`
- map source: `BATTLE29_map_11003_layers`
- HUD/card source: `BATTLE29_ui_normalbattle_and_hero_card_context`
- actor placement source: `BATTLE_RUNTIME_FLOW_MANIFEST_coordinates; mapId_11001_payload_on_clip05_map11003_visual_context`
- actor placement evidence status: `candidate_not_original_runtime_verified`

## Clip05 Comparison
- reference actor boxes: `181`
- runtime actor boxes: `18`
- actor center gap norm: `0.499238`
- runtime/reference actor area ratio: `0.042839`
- mesh hash changed actors: `3` / `3`
- AnimationState SetAnimation success: `3` / `3`
- magenta pixel ratio: `0.025204`
- HUD visibility reason: `BATTLE39 capture does not match BATTLE29/clip05 HUD/card visible regions; scene object presence is not camera-visible HUD.`

## Evidence Notes
- Lua/formation/camera/HUD evidence rows: `120`
- BATTLE29 map/HUD/card context is useful evidence, but its card placement is already marked inferred.
- BATTLE39 did not use fake HUD, fake motion, or debug labels in final capture.

## Blocker
- BATTLE29 HUD/card objects exist in the candidate scene, but final BATTLE39 capture does not show the clip05/BATTLE29 top/bottom/right HUD/card regions; this is a scene-object/camera-render visibility false positive.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE.json`
- Unity probe JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_UNITY.json`
- actor bounds CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_ACTOR_BOUNDS.csv`
- comparison CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_COMPARISON.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle39RuntimeActorsMap11003HudContext_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT`
