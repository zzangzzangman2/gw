# BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH Result

**Playable/restored claim remains false.** BATTLE60 validates only source-backed local subset skill/timeline AssetBundle chain loadability; it does not bind xLua handlers or save a scene.

## Verdict
- restoredClaim: `false`
- playableClaim: `false`
- sceneSaved: `false`
- handlerBindingApplied: `false`
- xLuaRuntimeUsed: `false`
- nextBlocker: `original_xlua_runtime_required_for_handlers_and_full_payload_actor_common_speedline_gaps`

## Skill Chain
- source-backed skill rows checked: `12`
- resource-complete skill rows verified: `4` / `4`
- missing common dependency rows: `8`
- skillTimelineChainVerifiedForResourceCompleteSubset: `true`
- bundle/asset/instantiate success rows: `12` / `12` / `12`

## Separated Blockers
- `original_xlua_runtime_required_for_handlers` remains from BATTLE59.
- `full_payload_actor_gaps_1036_and_unresolved_enemies` remains from payload/character trace.
- `common_speedline_resource_gaps_if_still_missing` remains for pink/red/yellow speedline rows.

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH_RESULT.json`
- skill timeline validation CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH_SKILL_TIMELINE_SOURCE_LOAD_VALIDATION.csv`
- skill prefab component/dependency refs CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH_SKILL_PREFAB_COMPONENT_DEPENDENCY_REFS.csv`
- blocker separation matrix CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH_BLOCKER_SEPARATION_MATRIX.csv`

## Command Policy
- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- `플레이.mp4`: `missing`
- `참고.mp4`: `available, auxiliary only`
