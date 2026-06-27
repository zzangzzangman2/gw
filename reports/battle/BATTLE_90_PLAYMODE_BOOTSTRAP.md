# BATTLE_90_PLAYMODE_BOOTSTRAP

## Default PlayMode Visual Lane

- status: `playmode_bootstrap_entered_battle`
- result: `reports/battle/BATTLE_90_PLAYMODE_BOOTSTRAP_RESULT.json`
- capture: `reports/battle/BATTLE_90_PLAYMODE_BOOTSTRAP_CAPTURE.png`
- scene: `girlswar_battle_unity/Assets/Scenes/Battle90PlayModeLuaBootstrap.unity`
- capture size: `1280x570`
- visual tuning: `battle90-reference-scale-v4`
- active lineup: payload 3v3 only, no visual-only extras
- actors: `attach=6`, `prefab=5`, `spine=5`, `missingAsset=1`
- missing exact actor: `1036` (`DTHero`/`DTmodel` say model/prefab `1036`, but local `battleprefabandres/1036` is absent)
- visual fallbacks: `3` enemy monster model resolves (`1100111 -> 3001`, `1100112/1100113 -> 3006`)
- source skill prefabs: `72` instantiated, `72` directors played, `0` renderable world effects, `0` playable-loaded resources
- latest visual overlap metric: `maxOverlap=0`, `overlapPairs=0`, `minCenterPx=162.5`
- missing script / no script asset log count in latest PlayMode log: `0`

Latest capture check: the bad full-size `rolebigsetpainting` portrait is gone from the battlefield, and `1025/1050` visual-only proof actors are removed from the live lineup. `1036` is no longer faked through `1034`; it is counted as a missing exact actor so the replay can continue without showing the wrong character.

## Naver Lounge Character Matching

- public source inspected: `https://game.naver.com/lounge/girlwars/board/34?page=1&order=new`
- source scrape: `reports/battle/NAVER_LOUNGE_GIRL_ART_BOARD34_TITLES.json`
- match outputs: `reports/battle/NAVER_LOUNGE_CHARACTER_MATCHES.json`, `reports/battle/NAVER_LOUNGE_CHARACTER_MATCHES.csv`
- public rows matched: `114 / 114`
- rows with local battle actor bundles: `41`
- rows with local name/head/art but no local battle actor bundle: `73`
- detail pages require lounge join in the current browser session, so this pass used only publicly visible board-list titles and local extracted data.

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
- actors: `attach=6`, `prefab=5`, `spine=5`, `missingAsset=1`
- overlap: `maxOverlap=0`, `overlapPairs=0`
- missing script / no script asset log count in latest RealAttack log: `0`

## What Changed

- Removed the battlefield fallback that used `rolebigsetpainting`/large character art as an actor substitute. Normal battle actors now stay on `battleprefabandres` SD Spine/prefab assets only.
- Removed the `ReferenceLineupExtraActorIds` path and the visual-only actor attach path, so `1025/1050` no longer get inserted beside the payload actors.
- Stopped the fake non-monster fallback chain (`1036 -> 1034/1002`). Missing exact actor assets are now counted as `missingAsset` and not drawn as another character.
- Split the `YouYou.SkillPlayable.*` and `YouYou.CommonPlayable.*` stubs into Unity file-name-matched script assets, including `PlayVideoTrack` and `SimulateAtkHit*`, so Timeline prefab logs no longer report missing referenced scripts.
- Added separate `skinMissingActorCount` and `skinVisualFallbackCount` counters so missing assets and real visual fallbacks do not collapse into the same number.
- Added battlehead sprites to the temporary HUD cards/top badges from extracted `battlehead*.png` files.
- Added the Naver Lounge character match JSON/CSV and a battlehead contact sheet for follow-up extraction choices.

## Current Boundary / SOS

This is still not a perfect original-client battle replay.

1. `1036` still has no local `download/roleprefabsandres/battleprefabandres/1036.assetbundle`, so it is intentionally missing/invisible instead of being faked with `1034`.
2. `1005`, `1029`, and `1037` are matched and their battle bundles exist, but the current Play Mode restoration renders them with broken magenta material/backdrop artifacts. Their atlas/material binding needs a focused fix before using them in the live lineup.
3. The HUD is still a temporary Play Mode overlay, not the original `UI_NormalBattle` route.
4. Source skill prefabs instantiate and their directors play, but visible source world effects remain `renderable=0`; the next blocker is implementing the original Playable/ResourceLoad behaviours or decoding their serialized resource fields, not missing class binding.
5. Enemy `1100112/1100113` still resolve through the source-backed base monster row `1100110 -> model_3006`.

Next useful work: import/find the exact `1036` SD battle bundle, then fix material/atlas binding for matched-but-broken actor IDs before expanding the roster beyond the 3v3 payload.
