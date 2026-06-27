# BATTLE_90_PLAYMODE_BOOTSTRAP

## Default PlayMode Visual Lane

- status: `playmode_bootstrap_entered_battle`
- result: `reports/battle/BATTLE_90_PLAYMODE_BOOTSTRAP_RESULT.json`
- capture: `reports/battle/BATTLE_90_PLAYMODE_BOOTSTRAP_CAPTURE.png`
- scene: `girlswar_battle_unity/Assets/Scenes/Battle90PlayModeLuaBootstrap.unity`
- capture size: `1280x570`
- visual tuning: `battle90-reference-scale-v4`
- actors: `attach=8`, `prefab=8`, `spine=8`, `missingAsset=0`
- reference visual-only extras: `1025->1025`, `1050->1050`
- current visual fallbacks: `4` (`1036` still resolves through `1034`; enemy variants still use monster model fallback)
- source skill prefab attempts: `72` instantiated, `0` renderable world effects after cutin/world-art suppression
- latest visual overlap metric: `maxOverlap=0.4255`, `overlapPairs=4`, `minCenterPx=79.79`

Latest capture check: the bad full-size `rolebigsetpainting` portrait is gone from the battlefield, and the magenta/material-broken test actors were removed from the live visual lineup. The current Play Mode proof intentionally uses only source-backed SD actors that render cleanly in this restoration pass: payload actors `1036/1002/1034`, enemy actors `3001/3006`, and extra visual-only source actors `1025/1050`.

## Naver Lounge Character Matching

- public source inspected: `https://game.naver.com/lounge/girlwars/board/34?page=1&order=new`
- source scrape: `reports/battle/NAVER_LOUNGE_GIRL_ART_BOARD34_TITLES.json`
- match outputs: `reports/battle/NAVER_LOUNGE_CHARACTER_MATCHES.json`, `reports/battle/NAVER_LOUNGE_CHARACTER_MATCHES.csv`
- public rows matched: `114 / 114`
- rows with local battle actor bundles: `41`
- rows with local name/head/art but no local battle actor bundle: `73`
- detail pages require lounge join in the current browser session, so this pass used only publicly visible board-list titles and local extracted data.

Important boundary: `battleprefabandres` bundle existence is not enough to guarantee current Play Mode material correctness. Test inserts for `1005`, `1029`, and `1037` loaded as SD prefabs but produced magenta/material-broken battlefield quads in this restoration lane. They remain mapped in the CSV/JSON, but they are not used in the live reference lineup until their material/atlas binding is fixed.

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
- reference visual-only extras: `1025->1025`, `1050->1050`

## What Changed

- Removed the battlefield fallback that used `rolebigsetpainting`/large character art as an actor substitute. Normal battle actors now stay on `battleprefabandres` SD Spine/prefab assets only.
- Added source skill prefab loading diagnostics and Timeline package support, while suppressing world-space cutin/portrait renderers so full-screen art cannot leak into normal battlefield placement.
- Added battlehead sprites to the temporary HUD cards/top badges from extracted `battlehead*.png` files.
- Added a visual-only actor attach path. It reuses the real SD actor loader but does not register the actor into the replay target dictionary, so extra lineup proof actors do not affect attack target selection.
- Added source-backed extra lineup actors `1025` and `1050` for visual testing against the Naver/local character map.
- Added the Naver Lounge character match JSON/CSV and a battlehead contact sheet for follow-up extraction choices.

## Current Boundary / SOS

This is still not a perfect original-client battle replay.

1. `1036` still has no local `download/roleprefabsandres/battleprefabandres/1036.assetbundle`, so it falls back visually to `1034` while preserving the `1036` skill family for skill lookup.
2. `1005`, `1029`, and `1037` are matched and their battle bundles exist, but the current Play Mode restoration renders them with broken magenta material/backdrop artifacts. Their atlas/material binding needs a focused fix before using them in the live lineup.
3. The HUD is still a temporary Play Mode overlay, not the original `UI_NormalBattle` route.
4. Source skill prefabs instantiate and are tracked, but the original Timeline/Playable graph is still blocked by missing `YouYou.SkillPlayable.*` behaviours; current visible attacks remain a bridge.
5. Enemy `1100112/1100113` still resolve through the source-backed base monster row `1100110 -> model_3006`.

Next useful work: fix the SD prefab material/atlas binding for matched-but-broken actor IDs, then replace the temporary HUD and skill bridge with source UI/Timeline playback.
