# BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH Result

**최종 playable battle screen은 아직 아니다.** BATTLE56 audits the source actor bundles and the current saved scene actor render refs; it does not import external packages or save a scene patch.

## Verdict
- visual_status: `actor_prefab_source_import_gap_audit_complete_no_scene_patch`
- final screen claim: `false`
- patch decision: `blocked_no_patch`
- scene saved: `false`
- source-backed patch available now: `false`
- next blocker: `SOURCE_BACKED_ACTOR_PREFAB_IMPORT_PIPELINE_REQUIRED_OR_REUSE_BATTLE37_RUNTIME_IN_SCENE_BUILDER`

## Source Bundle Audit
- actor prefab rows: `3`
- bundle load / prefab load: `3` / `3`
- live prefab mesh-ready rows: `3`
- SkeletonAnimation / SkeletonData rows: `3` / `3`
- project-imported prefab rows: `0`
- total live prefab mesh vertices: `2626`

## Current Scene Gap
- current scene actor rows: `3`
- scene mesh-ready rows: `0`
- scene material-ready rows: `0`
- import gap counts: `{'assetbundle_runtime_references_not_persisted_in_saved_scene': 3}`
- Interpretation: BATTLE39/BATTLE51 saved scene actors retained Transform/MeshRenderer shell components, but AssetBundle mesh/material references did not persist as project assets after reopen.
- Build-chain link: the actor scene builder instantiated live AssetBundle prefabs successfully, but did not create persistent project assets for the Spine SkeletonDataAsset, generated mesh, atlas materials, or texture/shader dependencies.

## Dependency Split
- dependency rows: `58`
- actor bundle asset type counts: `{'UnityEngine.TextAsset': 6, 'UnityEngine.Texture2D': 3, 'Spine.Unity.SpineAtlasAsset': 3, 'UnityEngine.Material': 5, 'Spine.Unity.SkeletonDataAsset': 3, 'UnityEngine.GameObject': 6}`
- material rows / texture rows / text rows: `5` / `3` / `6`
- shader bundle shader rows: `31`

## Decision
- No candidate scene patch was saved because the available source-backed fix is not a small MeshRenderer PPtr assignment. The original render path is Spine `SkeletonAnimation` + `SkeletonDataAsset` + atlas/material/shader, and those references must be imported into project assets or rebuilt by a source-backed scene builder before they can persist.
- Replacing actors with flat sprites, whole atlas pages, dummy meshes, or copied screenshots remains forbidden.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH_RESULT.json`
- actor prefab audit CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH_ACTOR_PREFAB_AUDIT.csv`
- renderer/material/shader dependency CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH_RENDERER_MATERIAL_SHADER_DEPENDENCIES.csv`
- current scene actor CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH_CURRENT_SCENE_ACTORS.csv`
- Unity log: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH_UNITY.log`

## Command Policy
- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- `플레이.mp4`: `missing`
- `참고.mp4`: `available, auxiliary only`
