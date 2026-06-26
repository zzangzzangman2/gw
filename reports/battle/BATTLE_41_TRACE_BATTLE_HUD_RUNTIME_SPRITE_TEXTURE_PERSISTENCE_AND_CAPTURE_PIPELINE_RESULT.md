# BATTLE_41 Trace Battle HUD Runtime Sprite Texture Persistence And Capture Pipeline Result

**원본 clip05 actor motion/layout/timing + map/HUD context는 아직 재현 안 됐다.** BATTLE41은 BATTLE29 생성 직후 HUD/card Image 수치와 저장 scene 재오픈 수치를 비교했고, runtime `Texture2D.LoadImage`/`Sprite.Create`/`Image.sprite` 상태가 scene reload 뒤 persistent UI Graphic으로 남지 않는다는 쪽으로 좁혔다.

## Verdict
- visual_status: `failed_runtime_ui_graphic_image_components_not_serialized_after_scene_reload`
- final screen claim: `false`
- reference video used: `True` (`플레이.mp4` 485.0-487.0s)
- camera-visible HUD/cards: `False`
- Unity exit code: `0`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE_CONTACT_SHEET.jpg`

## Persistence Trace
- BATTLE29 fresh bound hero cards: `3`
- BATTLE29 fresh visible card Image count: `51`
- BATTLE29 fresh extracted sprite binds: `57`
- BATTLE29 saved scene reopen Graphic/Image: `0` / `0`
- BATTLE40 saved scene reopen Graphic/Image: `0` / `0`
- BATTLE41 save→reopen Graphic/Image: `0` / `0`
- image-like/card-related transform rows: `3868`
- runtime texture code evidence rows: `47`

## Evidence Interpretation
- BATTLE29 build code uses `Texture2D.LoadImage`, `Sprite.Create`, and assigns `image.sprite` on runtime objects.
- Those created Texture2D/Sprite objects are not imported persistent Unity assets, so reopened scenes have transform/canvas evidence but no resolved Image/Graphic render component.
- The next fix must rebuild persistent, evidence-backed HUD Image components and sprites from original prefab/PPtr/sprite evidence, not paste a captured HUD image.

## Blocker
- BATTLE29 fresh build reports visible Image/card sprites, but saved scene reopen has 0 resolved Image/Graphic components; Texture2D.LoadImage/Sprite.Create/Image.sprite state is runtime-only and not persistent.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE.json`
- Unity probe JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE_UNITY.json`
- components CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE_COMPONENTS.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle41HudRuntimeSpriteTexturePersistenceTrace_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES`
