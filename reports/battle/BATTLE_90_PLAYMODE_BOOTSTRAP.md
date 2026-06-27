# BATTLE_90_PLAYMODE_BOOTSTRAP

## Default PlayMode Visual Lane

- status: `playmode_bootstrap_entered_battle`
- result: `reports/battle/BATTLE_90_PLAYMODE_BOOTSTRAP_RESULT.json`
- capture: `reports/battle/BATTLE_90_PLAYMODE_BOOTSTRAP_CAPTURE.png`
- scene: `girlswar_battle_unity/Assets/Scenes/Battle90PlayModeLuaBootstrap.unity`
- capture size: `1280x570`
- visual tuning: `battle90-source-hud-v1`
- active lineup: payload 3v3 only, no visual-only extras
- actors: `attach=6`, `prefab=5`, `spine=5`, `missingAsset=1`
- missing exact actor: `1036` (`DTHero`/`DTmodel` say model/prefab `1036`, but local `battleprefabandres/1036` is absent)
- visual fallbacks: `3` enemy monster model resolves
- enemy monster rows: `exact=1` (`1100111 -> 1100111/model_3001`), `baseFallback=2` (`1100112/1100113 -> 1100110/model_3006`), `missingExactRow=2`
- source skill prefabs: `72` instantiated, `72` directors played, `72` renderable source-backed common effects, `0` playable-loaded resources
- source common effects: `72` attached from `commonprefabsandres/skilleffect/commonskillprefabsandres1.assetbundle`
- latest visual overlap metric: `maxOverlap=0`, `overlapPairs=0`, `minCenterPx=162.5`
- source-backed HUD overlay: `44` images, `32` source sprites from `PersistentHudSprites/BATTLE42`, `5` skill slots, `2` locked empty slots, `2` HP gauges, `1` damage number (`1303`)
- missing script / no script asset log count in latest PlayMode log: `0`

Latest capture check: the bad full-size `rolebigsetpainting` portrait is gone from the battlefield, and `1025/1050` visual-only proof actors are removed from the live lineup. `1036` is no longer faked through `1034`; it is counted as a missing exact actor so the replay can continue without showing the wrong character.

## Naver Lounge Character Matching

- public source inspected: `https://game.naver.com/lounge/girlwars/board/34?page=1&order=new`
- source scrape: `reports/characters/naver_lounge_art/NAVER_LOUNGE_GIRLWARS_ART_FEED_20260627.json`
- image candidate outputs: `reports/characters/naver_lounge_art/NAVER_LOUNGE_GIRLWARS_ART_MATCH_20260627.json`, `reports/characters/naver_lounge_art/NAVER_LOUNGE_GIRLWARS_ART_MATCH_20260627.csv`
- public rows collected: `114 / 114`
- local art candidates compared: `335` (`T_ditu`/`Painting` images from extracted bundles)
- automatic visual match confidence: `strong=0`, `medium=3`, `candidate=111`
- important boundary: this is a reference/candidate matrix for manual follow-up, not an authoritative character-ID map yet. The next pass should use higher-grade visual embedding or manual review before importing actors from it.

Important boundary: `1025` and `1050` are valid matched/source-backed extraction candidates, but they are not active battle actors in the current U0-B 3v3 proof lane. They should be re-added only through the payload or a dedicated roster-expansion test, not as visual-only extras.

## Real Attack Task Probe

- result: `reports/battle/BATTLE_90_REAL_ATTACK_PROBE_RESULT.json`
- capture: `reports/battle/BATTLE_90_REAL_ATTACK_PROBE_CAPTURE.png`
- status: `playmode_bootstrap_entered_battle`
- errors: `0`
- frames pumped: `900`
- battle end: `isBattleEnd=true`
- full-round proof: `finalBattleEndCount=1`
- real attack proof: `attackMgrAddTask=29`, `attackMgrExecuteTask=29`, `heroNormal=22`, `heroBig=7`
- runtime preview proof: `runtimePreview=29`, `runtimePreviewMiss=0`
- source skill proof: `29` instantiated, `29` renderable source-backed common effects, `0` playable-loaded resources
- source-backed HUD proof: `32` source sprites, `5` skill slots, `2` locked empty slots, `1` damage number (`1303`)
- actors: `attach=6`, `prefab=5`, `spine=5`, `missingAsset=1`
- enemy monster rows: `exact=1`, `baseFallback=2`, `missingExactRow=2`
- overlap: `maxOverlap=0`, `overlapPairs=0`
- missing script / no script asset log count in latest RealAttack log: `0`

## What Changed

- Removed the battlefield fallback that used `rolebigsetpainting`/large character art as an actor substitute. Normal battle actors now stay on `battleprefabandres` SD Spine/prefab assets only.
- Removed the `ReferenceLineupExtraActorIds` path and the visual-only actor attach path, so `1025/1050` no longer get inserted beside the payload actors.
- Stopped the fake non-monster fallback chain (`1036 -> 1034/1002`). Missing exact actor assets are now counted as `missingAsset` and not drawn as another character.
- Split the `YouYou.SkillPlayable.*` and `YouYou.CommonPlayable.*` stubs into Unity file-name-matched script assets, including `PlayVideoTrack` and `SimulateAtkHit*`, so Timeline prefab logs no longer report missing referenced scripts.
- Added a source-backed common skill-effect bridge: when the original skill prefab has no renderers, it attaches the matching `pinkspeedline`/`redspeedline`/`yellospeedline` prefab from the aggregate common effect bundle. This moves `runtimeSourceSkillPrefabRenderableCount` from `0` to `72` in PlayMode and `29` in RealAttack.
- Added separate `skinMissingActorCount` and `skinVisualFallbackCount` counters so missing assets and real visual fallbacks do not collapse into the same number.
- Split runtime monster model diagnostics into exact/base-fallback/missing-exact-row counters. `1100111` is exact; `1100112/1100113` remain visible through the source-backed `1100110 -> model_3006` group row and are no longer presented as exact matches.
- Rebuilt the temporary Play Mode HUD overlay with source-backed BATTLE42 UI sprites: original HP bar/button/card-frame assets, top battlehead badges, bottom card-head portraits, locked empty slots, and a visible `1303` damage popup.
- Added the Naver Lounge source-art feed scrape and pHash candidate match matrix for follow-up extraction choices.

## Current Boundary / SOS

This is still not a perfect original-client battle replay.

1. `1036` still has no local `download/roleprefabsandres/battleprefabandres/1036.assetbundle`, so it is intentionally missing/invisible instead of being faked with `1034`.
2. `1005`, `1029`, and `1037` are matched and their battle bundles exist, but the current Play Mode restoration renders them with broken magenta material/backdrop artifacts. Their atlas/material binding needs a focused fix before using them in the live lineup.
3. The HUD is now source-sprite-backed, but it is still a Play Mode overlay approximation, not the original `UI_NormalBattle` route.
4. Source skill prefabs instantiate and visible source-backed common speedline effects now render, but `runtimeSourceSkillPrefabPlayableLoadCount` is still `0`; the next blocker is implementing the original Playable/ResourceLoad behaviours or decoding their serialized resource fields so the exact Timeline-authored effects play without the bridge.
5. Enemy `1100112/1100113` still resolve through the source-backed base monster row `1100110 -> model_3006`.

Next useful work: import/find the exact `1036` SD battle bundle, then fix material/atlas binding for matched-but-broken actor IDs before expanding the roster beyond the 3v3 payload.
