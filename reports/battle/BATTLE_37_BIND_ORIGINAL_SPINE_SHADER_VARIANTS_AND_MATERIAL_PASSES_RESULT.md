# BATTLE_37 Bind Original Spine Shader Variants And Material Passes Result

**원본 clip05 actor motion은 아직 재현 안 됐다.** shader/material rebind probe를 수행했지만, clip05 485.0-487.0s 전체 전투 actor motion/layout/timing 성공으로 보지 않는다.

## Verdict
- visual_status: `failed_clip05_actor_motion_layout_not_yet_matched_after_shader_binding`
- final screen claim: `false`
- reference video used: `True` (`플레이.mp4` 485.0-487.0s, frames `6`)
- actor motion replayed: `False`
- Unity exit code: `0`
- capture magenta ratio: `0.000387`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_CONTACT_SHEET.jpg`

## Shader / Material Binding
- unsupported shader/material before: `5`
- unsupported shader/material after: `0`
- same-name supported project shader count: `5`
- evidence-backed shader rebind applied: `5`
- mesh hash changed actors: `3` / `3`
- AnimationState SetAnimation success: `3` / `3`

## Actor Summary
- `1002` model `1002`: anim `ult`, mesh hash changes `11`, shader rebinds `2`, status `mesh_changes_after_same_name_spine_shader_rebind_but_clip05_motion_not_verified`
- `1034` model `1034`: anim `skill1`, mesh hash changes `11`, shader rebinds `2`, status `mesh_changes_after_same_name_spine_shader_rebind_but_clip05_motion_not_verified`
- `1100111` model `3001`: anim `attack`, mesh hash changes `11`, shader rebinds `1`, status `mesh_changes_after_same_name_spine_shader_rebind_but_clip05_motion_not_verified`

## Blocker
- Shader/pass binding improved actor rendering evidence, but clip05 full actor layout/motion/timing is not yet matched.
- No fake material, fake actor motion, or debug overlay was accepted as final output.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES.json`
- Unity probe JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_UNITY.json`
- material CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_MATERIALS.csv`
- component CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_COMPONENTS.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle37BindOriginalSpineShaderVariantsAndMaterialPasses_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05`
