# BATTLE_44 Trace Original Button MonoScript And TargetGraphic Serialization Result

**최종 playable battle screen은 아직 아니다.** BATTLE44는 원본 `battle_ext_prefabs`의 Button `m_TargetGraphic` PPtr를 추적하고, BATTLE43 후보 scene에 원본 Button root/targetGraphic 매핑만 적용했다. fake onClick handler는 추가하지 않았다.

## Verdict
- visual_status: `failed_original_target_graphic_mapping_still_not_raycast_ready`
- final screen claim: `false`
- Unity exit code: `0`
- reference video available: `False` (`C:\Users\godho\Downloads\플레이.mp4`)
- auxiliary reference video available: `True` (`C:\Users\godho\Downloads\참고.mp4`)
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION_CONTACT_SHEET.jpg`

## Original Serialization Evidence
- original Button MonoBehaviour count traced: `33`
- patch-eligible battle Button count: `20`
- Empty4Raycast targetGraphic count: `7`
- Image/YouYouImage targetGraphic count: `26`
- type evidence counts: `{'Button': '33', 'Image': '306', 'Empty4Raycast': '7', 'GraphicRaycaster': '14', 'Mask': '8', 'RectMask2D': '14', 'TextMeshProUGUI': '69'}`
- evidence CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_44_ORIGINAL_BUTTON_TARGET_GRAPHIC_EVIDENCE.csv`

## Candidate Patch Validation
- matched/applied Button mappings: `20` / `14`
- Empty4Raycast added: `7`
- Empty4Raycast after/reopen: `7` / `2`
- missing scripts before/reopen: `1208` / `1213`
- stale BATTLE43 heuristic Buttons removed: `6`
- Button reopen: `14`
- raycast-ready Button after/reopen: `0` / `0`
- raycast failure reasons: `{'no_graphic_hits_at_target_center': 5}`
- Mask/RectMask2D reopen: `0` / `0`
- TMP/Text reopen: `0` / `0`
- BATTLE43→BATTLE44 capture similarity: `{'available': True, 'meanAbsDiff': 0.0, 'pixelCorrelation': 1.0}`

## Blocker
- Original Button root/targetGraphic mapping did not produce raycast-ready controls.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION_RESULT.json`
- evidence CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_44_ORIGINAL_BUTTON_TARGET_GRAPHIC_EVIDENCE.csv`
- patch manifest CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_44_ORIGINAL_BUTTON_TARGET_GRAPHIC_PATCH_MANIFEST.csv`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION_UNITY.json`
- Unity rows CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION_COMPONENTS.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle44OriginalButtonTargetGraphicCandidate_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE`
