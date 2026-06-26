# BATTLE_47 Fix Graphic Depth And Raycast Candidate Registration Result

**최종 playable battle screen은 아직 아니다.** BATTLE47는 BATTLE46 후보의 original Button targetGraphic 14개를 대상으로 `Graphic.depth`, `CanvasRenderer.absoluteDepth`, registry 포함 여부, `GraphicRaycaster.Raycast`, `Graphic.Raycast`, rect contains를 rebuild phase별로 추적했다.

## Verdict
- visual_status: `graphic_depth_restored_but_raycast_still_not_ready`
- final screen claim: `false`
- Unity exit code: `0`
- reference video available: `False` (`C:\Users\godho\Downloads\플레이.mp4`)
- auxiliary reference video available: `True` (`C:\Users\godho\Downloads\참고.mp4`)
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION_CONTACT_SHEET.jpg`

## Phase Summary
- after camera render probes/depth>=0/absoluteDepth>=0/registry/ready/baselineReady: `14` / `10` / `10` / `10` / `0` / `0`
- reopen after dirty+rebuild+render+resetAspect probes/depth>=0/absoluteDepth>=0/registry/ready/baselineReady: `14` / `10` / `10` / `10` / `0` / `0`
- reopen Graphic.Raycast / rect contains / hit-positive / baseline-hit-positive: `10` / `14` / `0` / `0`
- raycast reasons: `{'no_hits_depth_minus_one': 100, 'no_hits': 40}`
- Unity patch decision: `depth_restored_but_raycast_still_blocked_by_sort_display_or_hit_order`

## Blocker
- Some target depths are non-negative after rebuild/render, but GraphicRaycaster still does not hit original targets.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION_UNITY.json`
- component CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION_COMPONENTS.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle47GraphicDepthRaycastCandidateRegistration_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_47_FIX_GRAPHIC_DEPTH_AND_RAYCAST_CANDIDATE_REGISTRATION_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD`
