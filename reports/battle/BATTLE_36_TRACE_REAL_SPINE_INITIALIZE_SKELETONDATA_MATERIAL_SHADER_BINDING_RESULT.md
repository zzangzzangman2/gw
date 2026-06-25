# BATTLE_36 Trace Real Spine Initialize SkeletonData Material Shader Binding Result

**원본 clip05 actor motion은 아직 재현 안 됐다.** clip05 485.0-487.0s sequence를 기준으로, 현재 probe는 최종 전투 화면이나 원본 actor motion 성공으로 볼 수 없다.

## Verdict
- visual_status: `failed_mesh_updates_but_shader_material_render_still_magenta`
- final screen claim: `false`
- reference video used: `True` (`플레이.mp4` 485.0-487.0s, frames `6`)
- actor motion replayed: `False`
- Unity exit code: `0`
- capture magenta ratio: `0.071884`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_CONTACT_SHEET.jpg`

## Runtime State
- real runtime present: `True`
- SkeletonAnimation components: `3` / `3`
- Initialize called / valid: `3` / `3`
- SkeletonData null count: `0`
- MeshGenerator non-null count: `3`
- AnimationState SetAnimation success: `3` / `3`
- Update(float) called: `3` / `3`
- mesh hash changed actors: `3` / `3`
- unsupported shader material count: `17`

## Actor Trace
- `1002` model `1002`: anim used `ult`, SkeletonData `1002_SkeletonData`, bones/slots/anims `96`/`246`/`23`, expected in runtime `True`, mesh hash changes `11`, status `mesh_changes_after_update_float_but_clip05_motion_not_verified`
- `1034` model `1034`: anim used `skill1`, SkeletonData `1034_SkeletonData`, bones/slots/anims `187`/`113`/`24`, expected in runtime `True`, mesh hash changes `11`, status `mesh_changes_after_update_float_but_clip05_motion_not_verified`
- `1100111` model `3001`: anim used `attack`, SkeletonData `3001_SkeletonData`, bones/slots/anims `56`/`28`/`20`, expected in runtime `True`, mesh hash changes `11`, status `mesh_changes_after_update_float_but_clip05_motion_not_verified`

## Blocker
- Mesh changes are present, but the capture still contains magenta render evidence from shader/material binding.
- Magenta/static output was not hidden by arbitrary material, and no fake animation was generated.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING.json`
- Unity probe JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_UNITY.json`
- component CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_COMPONENTS.csv`
- actor CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_ACTORS.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle36TraceRealSpineInitializeSkeletonDataMaterialShaderBinding_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_CONTACT_SHEET.jpg`

## Command Policy Check
- root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next Blocker
- `BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES`
