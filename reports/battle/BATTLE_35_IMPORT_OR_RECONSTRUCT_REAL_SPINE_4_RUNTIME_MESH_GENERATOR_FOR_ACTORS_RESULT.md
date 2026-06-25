# BATTLE_35 Import Or Reconstruct Real Spine 4 Runtime Mesh Generator For Actors Result

**아직 원본 clip05 actor motion 재현 아님.** vendor Spine 4 runtime import/probe를 시도했지만, clip05 485.0-487.0s actor motion 성공 판정에는 도달하지 않았다.

## Verdict
- visual_status: `failed_spine_shader_or_runtime_mesh_still_magenta`
- final screen claim: `false`
- reference video sequence: `플레이.mp4` 485.0-487.0s, frames `6`
- actor motion replayed: `False`
- Unity exit code: `0`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_CONTACT_SHEET.jpg`

## Runtime Import / Probe
- imported runtime files: `174`
- imported runtime bytes: `1318977`
- real runtime present: `True`
- runtime type presence: `{'SkeletonAnimation': True, 'SkeletonRenderer': True, 'SkeletonDataAsset': True, 'MeshGenerator': True, 'SkeletonBinary': True, 'AnimationState': True, 'AtlasAttachmentLoader': True, 'realRuntimePresent': True}`
- SkeletonAnimation components: `3`
- AnimationState SetAnimation success: `3` / `3`
- real mesh updated count: `0` / `3`
- magenta pixel ratio: `0.068621`

## Skel / Atlas / Texture Evidence
- SkeletonData trace rows: `3`
- expected animation exact match in `.skel`: `2` / `3`
- `1002` model `1002`: skel `1002.skel` bytes `862131`, expected `ult` present `True`, atlas regions `252`, material `1002_Material`, texture `1002(1024x512)`
- `1034` model `1034`: skel `1034.skel` bytes `820748`, expected `skill1` present `True`, atlas regions `185`, material `1034_Material`, texture `1034(2048x1024)`
- `1100111` model `3001`: skel `3001.skel` bytes `160467`, expected `attack` present `False`, atlas regions `41`, material `3001_Material`, texture `3001(512x512)`

## Blocker
- Real Spine runtime types are present, but the original AssetBundle actor instances did not show a changed mesh after AnimationState/LateUpdate probe.
- Magenta/static rendering was not hidden with arbitrary material, and no fake actor motion was generated.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS.json`
- trace CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_COMPONENTS.csv`
- Unity probe JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_UNITY.json`
- Unity component CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_UNITY_COMPONENTS.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle35RealSpineRuntimeMeshGeneratorProbe_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_CONTACT_SHEET.jpg`

## Next Blocker
- `BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING`
