# BATTLE_43 Validate Mask Stencil TMP Button And Runtime Formation Skill Binding Result

**최종 playable battle screen은 아직 아니다.** BATTLE43는 BATTLE42의 persistent HUD 위에서 mask/stencil, TMP/text, button/raycast, actor/formation/skill binding을 검증했고, 시각 fake 없이 interaction plumbing 최소 패치만 적용했다.

## Verdict
- visual_status: `failed_button_raycast_context_not_ready`
- final screen claim: `false`
- Unity exit code: `0`
- reference video available: `False` (`C:\Users\godho\Downloads\플레이.mp4`)
- auxiliary reference video available: `True` (`C:\Users\godho\Downloads\참고.mp4`)
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_CONTACT_SHEET.jpg`

## Component Validation
- GraphicRaycaster before/reopen: `0` / `9`
- Button before/reopen: `0` / `10`
- raycast-ready Button after/reopen: `0` / `0`
- raycast failure reasons: `{'no_graphic_hits_at_button_center': 20}`, all zero-hit centers: `True`
- Mask/RectMask2D reopen: `0` / `0`
- TMP/Text reopen: `0` / `0`
- missing scripts reopen: `1208`
- BATTLE42→BATTLE43 capture similarity: `{'available': True, 'meanAbsDiff': 0.0, 'pixelCorrelation': 1.0}`

## Runtime Binding Evidence
- payload map/battle/waves: `11001` / `1` / `3`
- payload heroes: `1036, 1002, 1034`
- relevant resource bundles: `13`, missing: `4`
- missing bundles sample: `['download/roleprefabsandres/battleprefabandres/1036.assetbundle', 'download/commonprefabsandres/skilleffect/commonskillprefabsandres1/pinkspeedline.assetbundle', 'download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle', 'download/commonprefabsandres/skilleffect/commonskillprefabsandres1/yellospeedline.assetbundle']`

## Blocker
- BATTLE43 did not produce persistent raycast-ready button candidates. Mask/RectMask2D are still absent. TMP/Text are still absent.

## Minimal Patch Plan
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_43_MINIMAL_PLAYABLE_CONTEXT_PATCH_PLAN.md`

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_UNITY.json`
- components CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_COMPONENTS.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle43PlayableContextValidationCandidate_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION`
