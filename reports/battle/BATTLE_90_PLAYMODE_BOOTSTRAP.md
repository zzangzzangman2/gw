# BATTLE_90_PLAYMODE_BOOTSTRAP

## Default PlayMode Visual Lane

- status: `playmode_bootstrap_entered_battle`
- Unity exit code: `0`
- scene: `girlswar_battle_unity/Assets/Scenes/Battle90PlayModeLuaBootstrap.unity`
- result: `reports/battle/BATTLE_90_PLAYMODE_BOOTSTRAP_RESULT.json`
- capture: `reports/battle/BATTLE_90_PLAYMODE_BOOTSTRAP_CAPTURE.png`
- sequence sheet: `reports/battle/BATTLE_90_PLAYMODE_BOOTSTRAP_SEQUENCE_SHEET.jpg`
- Play Mode entered: `true`
- `GameEntry.Procedure.ChangeState`: `NormalBattle`
- `battleEntered`: `true`
- frames pumped: `240`
- Lua index count: `17326`
- visual actors/renderers: `6` / `6`
- runtime actors: `attach=6`, `prefab=6`, `spine=6`, `quadFallback=0`, `missingAsset=0`
- source-backed monster visuals: `runtimeMonsterModelResolve=3`
- attack preview proof: `runtimePreview=72`, `runtimePreviewDone=72`, `runtimePreviewMiss=0`
- source-backed skill hit proof: `sourceSkillSpec=72`, `timelineBlocked=72`, `hitEffect=72`
- last skill spec: `actor=1036 resolved=1034 action=2 skill=1034101 prefab=1034101 bundle=download/skillprefabsandres/1034.assetbundle`
- capture size: `1280x570`
- sequence captures: `6`
- visual tuning: `battle90-no-overlap-v2`, `mapWidthUnits=12.85/centered-three-lane/no-overlap-scale`
- visual actor overlap metric: `maxOverlap=0`, `overlapPairs=0`, `minCenterPx=139.81`
- capture non-dark sample count: `2565`

## Real Attack Task Probe

- menu/execute method: `GirlsWar.Battle90PlayModeLuaBootstrapEditor.VerifyRealAttackProbe`
- result: `reports/battle/BATTLE_90_REAL_ATTACK_PROBE_RESULT.json`
- capture: `reports/battle/BATTLE_90_REAL_ATTACK_PROBE_CAPTURE.png`
- sequence sheet: `reports/battle/BATTLE_90_REAL_ATTACK_PROBE_SEQUENCE_SHEET.jpg`
- Unity exit code: `0`
- `useAttackTaskPreview`: `false`
- frames pumped: `900`
- `battleEntered`: `true`
- errors: `0`
- full-round proof: `bigBegin=20`, `bigEnd=20`, `smallBegin=20`, `smallEnd=40`, `finalBattleEnd=1`, `isBattleEnd=true`, `coroutinePending=0`
- real attack proof: `mgrAddTask=29`, `mgrExecute=29`, `mgrExecuteNormal=22`, `heroBig=7`, `heroNormal=22`, `realAttackPreview=29`, `realAttackPreviewMiss=0`
- runtime preview proof: `runtimePreview=29`, `runtimePreviewDone=29`, `runtimePreviewMiss=0`
- source-backed skill hit proof: `sourceSkillSpec=29`, `timelineBlocked=29`, `hitEffect=29`
- skill family trace: own `1002/1034` skills and enemy `1012` skills resolve to `download/skillprefabsandres/{family}.assetbundle`; tier-3 attacks also record fast prefabs such as `1002351`, `1034351`, and `1012351`
- visual tuning: `battle90-no-overlap-v2`, `mapWidthUnits=12.85/centered-three-lane/no-overlap-scale`
- visual actor overlap metric: `maxOverlap=0`, `overlapPairs=0`, `minCenterPx=141.1`
- sequence captures: `6`
- source-backed monster model proof: `runtimeMonsterModelResolve=3`, last resolve `1100113 -> 1100110/DTMonster_KEntityTableData/model_3006`

## What Changed

- Changed BATTLE90 visual capture from the old `1280x720` rocky-map framing to the reference-video aspect `1280x570`.
- Replaced the old `Map_11001` rocky background with extracted `Map_11003` layers (`Map_11003_2`, `Map_11003_3`, `Map_11003_5`), matching the reference battle-map family previously identified by BATTLE26 as the top video match.
- Added a lightweight reference battle HUD overlay in the BATTLE90 Play Mode camera: top HP/energy bars, `VS`, right AUTO/speed buttons, and bottom skill-card slots.
- Reworked formation placement for the reference-video battle framing, keeping actors readable while moving them closer to the original 1280x570 battle composition.
- Expanded the `Map_11003` layer width to the 1280x570 camera framing, reducing the brown side margins that made actors feel squeezed.
- Added the `battle90-no-overlap-v2` visual layout: centered three-lane 3v3 positions, smaller per-actor Spine scales for large mounted/monster bodies, and shorter capped attack dash distance so attack frames no longer shove actors into each other.
- Added per-actor screen rect diagnostics, max-overlap metrics, min center distance, and world/screen position summaries to the result JSON.
- Added sequence capture output for both default PlayMode and RealAttackProbe runs, so motion is verified as multiple frames instead of a single idle/final screenshot.
- Upgraded actor preview motion from a small pulse to an attack dash toward the opposing side.
- Added runtime hit slash and hit pulse effects at the nearest opposing actor, so real-path `HeroCtrl.BigAttack` / `HeroCtrl.NormalAttack` previews show visible hit frames.
- Added a source-backed skill preview resolver for the known local `skillprefabsandres` families: own hero `1002`, own hero `1034`/`1036`, and enemy monster `1012`. The runtime now records effective skill IDs such as `1002101`, `1034301`, and `1012301`, plus tier-3 fast prefab IDs where present.
- Split the runtime hit bridge by skill family: `1002` uses a blue-white slash, `1034` uses a gold cleave, and enemy `1012` uses a red arc. This is still a bridge, but it is no longer a single generic slash for every character.
- Added skill-spec diagnostics to both result JSONs: source-backed resolve count, blocked Timeline count, hit-effect count, last skill summary, and a compact trace of the first 16 resolved attacks.
- Added cleanup of stale sequence PNGs at the start of each BATTLE90 editor run to keep reports from mixing old frame captures.

## Current Boundary / SOS

BATTLE90 is much closer to the supplied reference video now: it uses the same `1280x570` battle aspect, the `Map_11003` reference map family, a visible battle HUD frame, 6 real Spine/prefab-backed actors, source-backed enemy monster visual resolution, and frame-sequence captures showing dash/slash attack moments. The latest no-overlap visual pass verifies `visualMaxOverlap=0` and `visualOverlapPairs=0` in both Default PlayMode and RealAttackProbe. RealAttackProbe also completes the original full-round coroutine path with 29 real attack previews, 29 source-backed skill specs, 29 hit effects, and no Unity errors.

This is still not a perfect original-client battle replay. The remaining gaps are:

1. `1036` still resolves through `1034` because the exact local bundle `download/roleprefabsandres/battleprefabandres/1036.assetbundle` is still absent.
2. The BATTLE90 HUD is a Play Mode overlay aligned to the reference view, not the fully live original `UI_NormalBattle` prefab/canvas route.
3. The hit/slash motion is a source-ID-aware runtime bridge driven by real Lua attack events. It resolves the local skill prefab family and prefab ID, but it does not play the original skill prefab Timeline/effect graph yet.
4. `1100112/1100113` enemy rows still use the source-backed base-row fallback `1100110 -> model_3006`; direct per-instance rows have not been found in local K/O `.bigd` tables.

Reference video baseline: `Downloads/참고.mp4`.

Next work should target exact source playback, not cosmetic tuning:

1. Acquire/import exact `1036.assetbundle` or prove it is unavailable from authoritative CDN/versionfile evidence.
2. Replace the source-ID-aware runtime slash bridge with original skill prefab/timeline playback and completion callbacks. The next hard blocker is the original `PlayableDirector`/TimelineAsset binding bridge for the loaded skill prefabs.
3. Reuse the source-backed `UI_NormalBattle`/skill-card canvas route inside the BATTLE90 Play Mode camera instead of the temporary overlay.
4. Keep the `Map_11003` 1280x570 capture gate and sequence sheets as the visual regression baseline against `Downloads/참고.mp4`.
