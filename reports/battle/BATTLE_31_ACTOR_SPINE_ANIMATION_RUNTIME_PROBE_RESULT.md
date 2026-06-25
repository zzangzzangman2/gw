# BATTLE_31 Actor Spine Animation Runtime Probe Result

**아직 원본 clip05 actor motion 재현 아님.** 3개 actor prefab은 로드/instantiate되지만, 원본 Spine runtime class와 Lua `HeroCtrl`/timeline replay가 아직 연결되지 않았다.

## Verdict
- visual_status: `failed_missing_spine_animation_runtime_class`
- final screen claim: `false`
- reference video sequence: `플레이.mp4` 485.0-487.0s, frames `6`
- actor motion replayed: `False`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_CONTACT_SHEET.jpg`

## Unity Actor Probe
- bundle load success: `3`
- prefab instantiate success: `3`
- component rows: `3`
- missing scripts: `3`
- skeleton-like assets: `12`
- animation candidate assets: `0`
- timeline candidate assets: `0`

## Actor Details
- `our` heroDid `1002` model `1002`: loaded `True`, instantiated `True`, missingScript `1`, skeletonAssets `4`, skelBytes `868704`, atlasFirstLine `1002.png`
- `our` heroDid `1034` model `1034`: loaded `True`, instantiated `True`, missingScript `1`, skeletonAssets `4`, skelBytes `832584`, atlasFirstLine `1034.png`
- `enemy` heroDid `1100111` model `3001`: loaded `True`, instantiated `True`, missingScript `1`, skeletonAssets `4`, skelBytes `162468`, atlasFirstLine `3001.png`

## Runtime Class / Lua Evidence
- Lua evidence lines: `80`
- IL2CPP string hits: `53`
- runtime class candidates: `Spine.Unity.SkeletonAnimation`, `SkeletonRenderer`, `SkeletonMecanim`, `SkeletonDataAsset`, `Spine.AnimationState`, `BattleTimeline/SetTimelineEffect`

## Blocker
- 3개 actor prefab은 로드/instantiate되지만 원본 Spine SkeletonAnimation/SkeletonDataAsset runtime class와 HeroCtrl/Timeline animation-state replay가 연결되지 않아 clip05 actor motion이 재현되지 않는다.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE.json`
- Unity probe JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_UNITY.json`
- component CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_COMPONENTS.csv`
- static probe capture: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle31ActorSpineAnimationRuntimeProbe_1920x1080.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_CONTACT_SHEET.jpg`

## Next Blocker
- `BATTLE_32_RESOLVE_BATTLE_ACTOR_SPINE_RUNTIME_CLASS_AND_IDLE_MOTION_REPLAY`
