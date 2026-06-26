# BATTLE_48 Trace Sort Order Display And Hit Occlusion After Depth Rebuild Result

**최종 playable battle screen은 아직 아니다.** BATTLE48는 depth가 살아난 BATTLE47 후보에서 Unity `GraphicRaycaster.Raycast` 내부 조건을 mirror trace로 재현하고, 여러 pointer 좌표계를 비교했다.

## Verdict
- visual_status: `raycast_ready_candidate_found_after_sort_display_trace`
- final screen claim: `false`
- Unity exit code: `0`
- reference video available: `False` (`C:\Users\godho\Downloads\플레이.mp4`)
- auxiliary reference video available: `True` (`C:\Users\godho\Downloads\참고.mp4`)
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_CONTACT_SHEET.jpg`

## Reopen Mirror Summary
- summary/detail rows: `168` / `3924`
- reopen raycast-ready / unity-hit-positive / mirror-target-candidate: `15` / `15` / `15`
- reopen pixelRect contains / target depth>=0: `50` / `60`
- primary failures: `{'target_hit': 15, 'no_mirror_candidates': 35, 'event_camera_pixelrect_reject': 34}`
- target detail rejection counts: `{'final_candidate': 15, 'rect_not_contains': 15, 'event_camera_pixelrect_reject': 25, 'raycastTarget_false': 5}`
- point ready counts: `{'eventCamera_worldToScreen': 5, 'b47_before_open_baseline': 5, 'viewport_pixelRect': 5}`
- depth rebuild render used `640x480`, matching `eventCamera.pixelRect`; 1920/capture-scaled pointer candidates did not hit.

## Patch Decision
- Unity patch decision: `candidate_point_hits_without_fake_overlay_validate_input_next`
- Report blocker: At least one original targetGraphic receives a GraphicRaycaster hit after reopen, but real input/click validation and reference alignment remain incomplete.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_UNITY.json`
- target-point CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_TARGET_POINTS.csv`
- registered-graphics CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_REGISTERED_GRAPHICS.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle48SortOrderDisplayHitOcclusionTrace_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING`
