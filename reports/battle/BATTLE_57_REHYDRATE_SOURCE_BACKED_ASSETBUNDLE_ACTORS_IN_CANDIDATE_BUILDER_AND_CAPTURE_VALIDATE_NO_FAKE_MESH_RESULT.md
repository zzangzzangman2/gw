# BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH Result

**최종 playable battle screen은 아직 아니다.** BATTLE57 validates source-backed AssetBundle actor rehydration in the battle HUD/map candidate builder without fake meshes or fake handlers.

## Verdict
- visual_status: `source_backed_assetbundle_actor_runtime_rehydrate_pixels_validated_playable_false`
- final screen claim: `false`
- patch decision: `candidate_runtime_rehydrate_patch_no_fake_mesh`
- scene saved: `true`
- runtime rehydrate used: `true`
- source-backed persistent import used: `false`
- fake mesh used: `false`
- next blocker: `XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_AND_FULL_PAYLOAD_GAPS_REMAIN`

## Rehydration Mapping
- source-backed rehydrated actors: `3`
- disabled old hollow shell rows: `3`
- bundle loaded / prefab instantiated: `3` / `3`
- animation state set rows: `3`

## Render And Visibility
- renderer rows: `3`
- mesh non-null rows / mesh vertices: `3` / `2630`
- material-ready rows: `3`
- unsupported shader rows after rebind: `0`
- visibility rows mesh/material/frustum/pixel signal: `3` / `3` / `3` / `3`
- actor on/off diff sampled pixels: `12732`

## Interpretation
- This is not a whole-atlas or dummy mesh replacement. The actor instances come from the original local AssetBundles and preserve the original Spine `SkeletonAnimation`, `SkeletonDataAsset`, atlas material, texture, and animation state path.
- Persistent project asset import was not attempted in this pass. The candidate scene was saved as a builder artifact, but actor render validity is proven by runtime rehydration while source bundles remain loaded, not by reopen-persistent MeshRenderer PPtrs.
- HUD/button Lua handler binding remains blocked by the previous xLua/GameEntry/ModulesInit issue, so playable remains false.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_RESULT.json`
- mapping CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_REHYDRATION_MAPPING.csv`
- renderer/material/shader CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_RENDERERS.csv`
- actor visibility CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_VISIBILITY.csv`
- candidate capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle57RuntimeRehydratedAssetBundleActorsCandidate_1920x1080.png`
- actor-hidden baseline: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle57RuntimeRehydratedAssetBundleActorsCandidate_without_actors_1920x1080.png`
- actor diff mask: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle57RuntimeRehydratedAssetBundleActorsCandidate_actor_diff_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_CONTACT_SHEET.jpg`

## Command Policy
- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- `플레이.mp4`: `missing`
- `참고.mp4`: `available, auxiliary only`
