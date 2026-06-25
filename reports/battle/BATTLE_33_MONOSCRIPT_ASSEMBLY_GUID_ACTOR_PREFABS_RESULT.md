# BATTLE_33 MonoScript Assembly GUID Actor Prefabs Result

**아직 원본 clip05 actor motion 재현 아님.** 다만 actor prefab의 `m_Script` assembly binding 원인은 닫혔다.

## Verdict
- visual_status: `failed_actor_render_still_magenta_after_monoscript_binding_fixed`
- final screen claim: `false`
- reference video sequence: `플레이.mp4` 485.0-487.0s, frames `6`
- actor motion replayed: `False`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS_CONTACT_SHEET.jpg`

## MonoScript Binding
- MonoBehaviour trace rows: `12`
- `spine-unity.dll` MonoBehaviour rows: `12`
- actor `SkeletonAnimation` MonoBehaviour rows: `3`
- MissingScript before/after: `3` / `0`
- MissingScript reduction: `3`
- SkeletonAnimation components resolved after shim: `3`
- idle replay call success: `3`

## Actor Script PPtrs
- `1002` `Hero_1002` MonoBehaviour `-1973848794011561530` m_Script `fileID=0 pathID=9202454401006530641` -> `Spine.Unity.SkeletonAnimation` assembly `spine-unity.dll`, animation `ult`, loop `0`, skeletonDataAsset `{'m_FileID': 0, 'm_PathID': 5410798655350692559}`
- `1034` `Hero_1034` MonoBehaviour `-6761371301451957790` m_Script `fileID=0 pathID=9202454401006530641` -> `Spine.Unity.SkeletonAnimation` assembly `spine-unity.dll`, animation `skill1`, loop `0`, skeletonDataAsset `{'m_FileID': 0, 'm_PathID': 3214316990278771306}`
- `1100111` `Hero_3001` MonoBehaviour `6497674388930808486` m_Script `fileID=0 pathID=9202454401006530641` -> `Spine.Unity.SkeletonAnimation` assembly `spine-unity.dll`, animation `attack`, loop `0`, skeletonDataAsset `{'m_FileID': 0, 'm_PathID': -5838307213355684488}`

## Remaining Visual Blocker
- magenta pixel ratio: `0.073207`
- MonoScript binding is fixed, but the capture remains a static/magenta actor mesh and does not match the moving clip05 actors.
- Shader bundle and Spine shader names are present; next work must reconstruct real SkeletonData/AnimationState/mesh update and render compatibility, not fake motion.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS.json`
- components CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS_COMPONENTS.csv`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS_CONTACT_SHEET.jpg`

## Next Blocker
- `BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS`
