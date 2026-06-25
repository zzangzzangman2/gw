# BATTLE_32 Actor Spine Runtime Class Idle Motion Replay Result

**아직 원본 clip05 actor motion 재현 아님.** Spine runtime class/shader proxy를 검증했지만 `플레이.mp4` 485~487초의 actor motion은 재생되지 않았다.

## Verdict
- visual_status: `failed_spine_shader_or_runtime_mesh_still_magenta`
- final screen claim: `false`
- reference video sequence: `플레이.mp4` 485.0-487.0s, frames `6`
- actor motion replayed: `False`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_CONTACT_SHEET.jpg`

## Runtime Class / Shader Probe
- MissingScript before/after: `3` / `3`
- MissingScript reduction: `0`
- SkeletonAnimation components resolved: `0`
- idle replay call success: `0`
- shader fallback applied: `0`
- magenta pixel ratio: `0.073207`
- shader dependency loaded: `True`
- shader dependency status: `loaded`

## Actor Details
- `our` heroDid `1002` model `1002`: missingScript `1`, SkeletonAnimation `0`, idleReplay `False`, shaderFix `0`, idleInSkelBytes `False`, atlas `1002.png`
- `our` heroDid `1034` model `1034`: missingScript `1`, SkeletonAnimation `0`, idleReplay `False`, shaderFix `0`, idleInSkelBytes `False`, atlas `1034.png`
- `enemy` heroDid `1100111` model `3001`: missingScript `1`, SkeletonAnimation `0`, idleReplay `False`, shaderFix `0`, idleInSkelBytes `False`, atlas `3001.png`

## Blocker
- Spine runtime proxy/shader evidence was probed, but original clip05 actor idle/motion is still not reproduced. The remaining blocker is MonoScript assembly/type binding if SkeletonAnimation did not resolve, otherwise real SkeletonData/AnimationState reconstruction from .skel.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY.json`
- Unity probe JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_UNITY.json`
- component CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_COMPONENTS.csv`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle32ActorSpineRuntimeClassIdleMotionReplay_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_CONTACT_SHEET.jpg`

## Next Blocker
- `BATTLE_33_DEEP_TRACE_MONOSCRIPT_ASSEMBLY_GUID_FOR_ACTOR_PREFABS`
