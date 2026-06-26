# BATTLE_46 Trace GraphicRaycaster EventCamera ScreenSpace And Blockers Result

**최종 playable battle screen은 아직 아니다.** BATTLE46는 BATTLE45 후보를 저장 후 reopen 기준으로 열고, original targetGraphic 중심 좌표에서 Canvas/GraphicRaycaster/eventCamera/worldCamera/RectTransformUtility/CanvasGroup/CanvasRenderer 조건을 분리했다.

## Verdict
- visual_status: `registered_rect_valid_targets_blocked_by_graphic_depth_minus_one`
- final screen claim: `false`
- Unity exit code: `0`
- reference video available: `False` (`C:\Users\godho\Downloads\플레이.mp4`)
- auxiliary reference video available: `True` (`C:\Users\godho\Downloads\참고.mp4`)
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_CONTACT_SHEET.jpg`

## Reopen Counts
- Button probes / registry included / raycast-ready: `14` / `10` / `0`
- hit-positive samples: `0`
- reopen counts: `{'canvas': 18, 'graphicRaycaster': 9, 'image': 232, 'graphic': 239, 'activeGraphic': 62, 'button': 14, 'empty4Raycast': 7, 'mask': 0, 'rectMask2D': 0, 'text': 0, 'tmp': 0, 'missingScript': 1208}`
- raycast reasons: `{'no_graphic_hits_at_target_center': 14}`

## Screen-Space And Camera Split
- RectContains eventCamera at event center: `14`
- RectContains null camera at event center: `0`
- RectContains null camera at null center: `14`
- RectContains Camera.main: `0`
- RectContains capture camera: `14`
- Graphic.Raycast(eventCamera) passing samples: `10`
- target Graphic depth == -1 samples: `14`
- worldCamera disabled / target cull / CanvasGroup blocked: `0` / `0` / `0`

## Patch Decision
- Unity patch decision: `all_button_targets_have_graphic_depth_minus_one; GraphicRaycaster excludes these despite registry and rect passing`
- Report blocker: All Button target Graphics have depth -1 after reopen, so Unity GraphicRaycaster excludes them even though registry, RectTransformUtility, CanvasGroup, and many Graphic.Raycast checks pass.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_UNITY.json`
- component CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_COMPONENTS.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle46GraphicRaycasterEventCameraScreenSpaceCandidate_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_47_TRACE_CANVAS_RENDER_DEPTH_REBUILD_AND_GRAPHICRAYCASTER_SORT_INTERNALS`
