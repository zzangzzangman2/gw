# BATTLE_30 Hero Card Runtime Layout And Actor Animation Trace

This is not a final restored battle screen. It verifies BATTLE_29 against the `플레이.mp4` clip05 485.0-487.0s sequence.

## Verdict
- visual_status: `failed_actor_motion_runtime_replay_missing`
- final screen claim: `false`
- reference frames: `6`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_30_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE_CONTACT_SHEET.jpg`

## Actor/Card Layout Gap
- reference actor boxes: `145`
- capture actor boxes: `20`
- actor center gap norm: `0.13673`
- actor area scale ratio: `0.36319`
- reference card boxes: `13`
- capture card boxes: `20`
- card center gap norm: `0.09079`
- card area scale ratio: `3.12097`

## Animation Replay Evidence
- runtime actor slots: `12`
- loadable actor prefabs: `3`
- missing actor slots: `9`
- skeleton evidence assets: `9`
- Lua animation/timeline evidence lines: `80`
- blocker: Spine/SkeletonData assets and actor prefabs exist for 3 actors, but prefab MissingScript/animation-state runtime class and Lua HeroCtrl timeline replay are not reconstructed; 9 actor slots still lack loadable prefabs.

## Loadable Actors
- `our` heroDid `1002` model `1002` bundle `download/roleprefabsandres/battleprefabandres/1002.assetbundle`
- `our` heroDid `1034` model `1034` bundle `download/roleprefabsandres/battleprefabandres/1034.assetbundle`
- `enemy` heroDid `1100111` model `3001` bundle `download/roleprefabsandres/battleprefabandres/3001.assetbundle`

## Missing Actor Slots
- `our` heroDid `1036` model `1036` reason `listed_in_cdn_versionfile_not_extracted`
- `enemy` heroDid `1100112` model `` reason `not_loadable_yet`
- `enemy` heroDid `1100113` model `` reason `not_loadable_yet`
- `enemy` heroDid `1100121` model `` reason `not_loadable_yet`
- `enemy` heroDid `1100122` model `` reason `not_loadable_yet`
- `enemy` heroDid `1100123` model `` reason `not_loadable_yet`
- `enemy` heroDid `1100131` model `` reason `not_loadable_yet`
- `enemy` heroDid `1100132` model `` reason `not_loadable_yet`
- `enemy` heroDid `1100133` model `` reason `not_loadable_yet`

## Outputs
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE_RESULT.json`
- Unity data JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE.json`
- layout gaps CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE_GAPS.csv`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_30_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE_CONTACT_SHEET.jpg`

## Next Blocker
- `BATTLE_31_ATTACH_LOADABLE_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE`
