# BATTLE_42 Rebuild Persistent Battle HUD Image Components From Original Prefab PPtr And Sprites Result

**최종 playable battle screen은 아직 아니다.** BATTLE42는 BATTLE41 blocker였던 scene reload 후 `Image/Graphic = 0` 문제를 original sprite marker evidence 기반 persistent Unity `Image` + imported `Sprite` asset으로 재구성하는 실험 패치다.

## Verdict
- visual_status: `failed_persistent_hud_images_survive_scene_reload_but_clip05_playable_context_not_restored`
- final screen claim: `false`
- reference video used: `False` (`C:\Users\godho\Downloads\플레이.mp4` missing)
- auxiliary reference video available: `True` (`C:\Users\godho\Downloads\참고.mp4`)
- camera-visible HUD/cards: `True`
- Unity exit code: `0`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES_CONTACT_SHEET.jpg`

## Persistent HUD Rebuild
- original sprite marker rows: `232`
- reconstructed Image components: `232`
- imported persistent Sprite assets: `76`
- before Image/Graphic/active Graphic: `0` / `0` / `0`
- after Image/Graphic/active Graphic: `232` / `232` / `56`
- reopened Image/Graphic/active Graphic: `232` / `232` / `56`
- reopened Image with Sprite/Texture: `232` / `232`
- missing scripts before/after/reopen: `1208` / `1208` / `1208`

## Evidence Interpretation
- BATTLE41 confirmed BATTLE29 fresh runtime `Image.sprite` state did not survive scene reload.
- BATTLE42 binds from persisted `BattleHudExtractedSpriteBindingMarker25` rows: original sprite name, source bundle, pathId, and extracted PNG path.
- PNGs are imported under `Assets/RestoreData/battle/PersistentHudSprites/BATTLE42` as Unity Sprite assets, then assigned to real `UnityEngine.UI.Image` components.
- Existing missing-script components are not treated as success and remain a separate MonoScript/PPtr gap.

## Blocker
- Persistent Image/Sprite components now survive scene reopen, but capture/contact sheet is not a final playable clip05 match and runtime text/button/mask/actor/skill flow is still incomplete.

## Manifest Gap
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_42_CHARACTER_SKILL_FORMATION_MANIFEST_GAP.md`

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES_UNITY.json`
- components CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES_COMPONENTS.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle42PersistentBattleHudImagesFromOriginalSpriteEvidence_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING`
