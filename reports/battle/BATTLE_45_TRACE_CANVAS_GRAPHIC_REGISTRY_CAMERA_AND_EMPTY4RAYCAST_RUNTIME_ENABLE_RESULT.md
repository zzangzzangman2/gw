# BATTLE_45 Trace Canvas GraphicRegistry Camera And Empty4Raycast Runtime Enable Result

**최종 playable battle screen은 아직 아니다.** BATTLE45는 `Empty4Raycast` MonoScript persistence를 전용 파일로 분리해 검증하고, Canvas/GraphicRaycaster/EventSystem/eventCamera/GraphicRegistry/raycast 조건을 targetGraphic 중심 좌표 기준으로 추적했다.

## Verdict
- visual_status: `empty4raycast_persists_and_registry_includes_targets_but_raycast_still_misses`
- final screen claim: `false`
- Unity exit code: `0`
- reference video available: `False` (`C:\Users\godho\Downloads\플레이.mp4`)
- auxiliary reference video available: `True` (`C:\Users\godho\Downloads\참고.mp4`)
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE_CONTACT_SHEET.jpg`

## Empty4Raycast Persistence
- MonoScript path: `Assets/Scripts/Empty4Raycast.cs`
- MonoScript guid: `b43ea56e6bf10cd4ab0af9f864433dcf`
- MonoScript class: `UnityEngine.UI.Empty4Raycast`
- Empty4Raycast before/after/reopen: `0` / `7` / `7`
- missing scripts before/reopen: `1208` / `1208`
- scene YAML summary: `{'sceneExists': True, 'empty4RaycastIdentifierCount': 7, 'empty4RaycastScriptGuidCount': 7, 'missingScriptFileId0Count': 1089, 'oldEditorClassIdentifierPatternCount': 7}`

## Registry And Raycast
- Button before/after/reopen: `10` / `14` / `14`
- registry target included after/reopen: `10` / `10`
- raycast-ready Button after/reopen: `0` / `0`
- row raycast reasons: `{'no_graphic_hits_at_target_center': 20}`
- Mask/RectMask2D reopen: `0` / `0`
- TMP/Text reopen: `0` / `0`
- BATTLE44→BATTLE45 capture similarity: `{'available': True, 'meanAbsDiff': 0.0, 'pixelCorrelation': 1.0}`

## Blocker
- Targets enter GraphicRegistry after reopen, but GraphicRaycaster still does not hit them at target centers.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE_UNITY.json`
- component CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE_COMPONENTS.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle45Empty4RaycastRegistryCandidate_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS`
