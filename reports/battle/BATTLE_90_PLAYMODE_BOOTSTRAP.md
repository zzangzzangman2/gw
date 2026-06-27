# BATTLE_90_PLAYMODE_BOOTSTRAP

- status: `playmode_bootstrap_entered_battle`
- Unity exit code: `0`
- scene: `girlswar_battle_unity/Assets/Scenes/Battle90PlayModeLuaBootstrap.unity`
- result: `reports/battle/BATTLE_90_PLAYMODE_BOOTSTRAP_RESULT.json`
- Play Mode entered: `true`
- `GameEntry.Procedure.ChangeState`: `NormalBattle`
- `battleEntered`: `true`
- frames pumped: `240`
- Lua index count: `17326`
- capture: `reports/battle/BATTLE_90_PLAYMODE_BOOTSTRAP_CAPTURE.png`
- visual actors/renderers: `6` / `6`
- visual actor screen area: `0.345776`
- capture non-dark sample count: `1540`
- trace: `ProcedureNormalBattle_OnEnter;LoadPlayerHeros;LoadPlayerHero;LoadPlayerHero;LoadPlayerHero;LoadEnemyPlayerHeros;LoadPlayerHero;OnBattleTeamReady;OnBattleTeamReady;FirstBattleTeamReady;AfterBattleTeamReady;CheckBattleBegin;BattleBegin;CheckFirstAttackTeam;CheckRelic;BattleFightSuppress;BattleRoundBeginAddTreasure;BattleRoundBeginAddBuff;BattleRoundBeginAddBuffComplete;BattleAllBigRoundBegin;BattleBigRoundBegin;BattleSmallRoundBegin;BattleRoundExplosive;BattleRoundExplosiveComplete;BattleRoundEndCheckBuff;BattleRoundEndCheckBuffComplete;StartAttackTask;...`
- diag: `loadPlayerHero=6 loadEnemy=1 teamReady=2 firstReady=1 afterReady=1 battleBegin=1 bigRound=1 currBigRound=1 attackPreviewMode=true defineLoadOk=true enumSnapshot=skillSmall=2/skillEndPet=5/actionNormal=2 firstValueDefault=2 firstRateDefault=0 spineAnimationGuard=6 heroViewBridge=6 skinRuntime=6 skinSpine=6 skinVisualFallback=4 monsterFallback=2 readyTeams=2 ourCur=3 enemyCur=3 firstShortcut=1 beginBuffShortcut=1 allBigShortcut=1 smallRoundShortcut=1 attackTaskShortcut=12 attackTaskGuard=1 attackActions=72 attackPreview=72 attackPreviewMiss=0 pnbStartAttack=13 runtimeAttach=6 runtimePrefab=6 runtimeSpine=6 runtimeVisualFallback=4 runtimeQuadFallback=0 runtimeMissingAsset=0 runtimeMonsterModelResolve=3 runtimePreview=72 runtimePreviewDone=72 runtimePreviewMiss=0 visualActors=6 visualRenderers=6 visualScreenArea=0.345776 captureNonDark=1540`

## Real Attack Task Probe

- menu/execute method: `GirlsWar.Battle90PlayModeLuaBootstrapEditor.VerifyRealAttackProbe`
- result: `reports/battle/BATTLE_90_REAL_ATTACK_PROBE_RESULT.json`
- capture: `reports/battle/BATTLE_90_REAL_ATTACK_PROBE_CAPTURE.png`
- Unity exit code: `0`
- `useAttackTaskPreview`: `false`
- frames pumped: `900`
- `battleEntered`: `true`
- errors: `0`
- full-round proof: `bigBegin=20`, `bigEnd=20`, `smallBegin=20`, `smallEnd=40`, `finalBattleEnd=1`, `isBattleEnd=true`, `coroutinePending=0`
- real attack proof: `mgrAddTask=29`, `mgrExecuteNormal=22`, `heroNormal=22`, `realAttackPreview=29`, `waitUntilReady=289`
- source-backed monster model proof: `runtimeMonsterModelResolve=3`, last resolve `1100113 -> 1100110/DTMonster_KEntityTableData/model_3006`
- visual actor screen area: `0.271197`

## What Changed

- Added a runtime `BattlePlayModeBootstrap` MonoBehaviour that reuses the M2 Lua data wiring in Unity Play Mode client mode.
- Added a BATTLE90 editor runner that creates/opens a dedicated scene, enters Play Mode, waits for the bootstrap result, and exits with a real process code.
- Extended `YouYou.GameEntry` stubs so Lua `cs_coroutine` can use a real MonoBehaviour coroutine host and `Procedure.ChangeState` is observable.
- Added minimal Play Mode view stubs for `GameEntry.Pool`, `LuaHeroSprite`, `LuaUtils`, and station transforms so original Lua reaches actual `ProcedureNormalBattle_OnEnter` and team load calls.
- Bridged opened `LuaHeroSprite` instances into the original Lua `HeroCtrl` lifecycle, so both teams reach ready state (`ourCur=3`, `enemyCur=3`, `teamReady=2`).
- Added `BattleRuntimeSpineActorFactory`, which attaches source-backed battle actor prefabs from local AssetBundles in Play Mode.
- Replaced the `HeroCtrl.LoadSkin` placeholder mesh with runtime actor prefab attachment: 6/6 actors now have `Spine.Unity.SkeletonAnimation`, 6/6 come from battle prefab AssetBundles, and 0 fall back to textured quads.
- Routed the 72 FightPlay action entries observed by the guarded attack-task path into frame-based Spine actor preview pulses; validation now shows `runtimePreview=72`, `runtimePreviewDone=72`, `runtimePreviewMiss=0`.
- Added a Play Mode visual stage: map background, orthographic battle camera, formation station positions, actor depth normalization, and a verification capture written to `reports/battle/BATTLE_90_PLAYMODE_BOOTSTRAP_CAPTURE.png`.
- Spread Play Mode actor placement into readable 3v3 lanes and reduced runtime actor scale so validation captures no longer stack all six actors in the center.
- Added a Play Mode-only monster-data fallback for battle payload enemy IDs such as `1100112 -> 1100110`, including the stage-base form needed by later replay wave instance ids.
- Added a source-backed monster visual resolver that reads local `DTMonster_K/OEntityTableData.bigd` rows and maps replay payload enemies to their row `modelID` battle prefabs. Current proof: `1100111 -> model_3001`, `1100112/1100113 -> 1100110/DTMonster_KEntityTableData/model_3006`.
- Added Play Mode-only shortcuts for missing Unity/UI surfaces: inline coroutine pumping, immediate `TimeActionMgr`, battle-start UI bypass, minimal pet placeholders, begin-buff/big-round/small-round/attack-task guards.
- Added an alternate Real Attack Task Probe run that disables the guarded `StartAttackTask` preview shortcut and records `ProcedureNormalBattle`, `BattleTeam`, `AttackTaskMgr`, and `HeroCtrl` counters.
- Upgraded the Real Attack Task Probe to use a lightweight frame coroutine scheduler for Lua `cs_coroutine`, with `WaitUntil(predicate)` tokens pumped from Play Mode frames.
- Limited the guarded big/small round shortcuts to the default visual lane; the Real Attack Task Probe now runs the original `BattleAllBigRoundBegin` and `BattleSmallRoundBegin` coroutine flow.
- Loaded `Common/Define` under a guarded client flag so battle enums are real numbers in Play Mode (`SmallSkillAttacking=2`, `SmallRoundEndPetHelpSkillAttacking=5`, `SmallRoundStartTeamAttacking=6`, `NormalOrSmallSkill=2`).
- Added Play Mode-only guards for offline gaps exposed by the real path: `LuaUtils.IsNull`, global `WaitUntil`, nil `TotalFirstValue`, empty attack command queues, and Spine wrapper `invisible`/animation calls on raw C# `SkeletonAnimation`.

## Current Boundary

BATTLE90 now proves two lanes. The default visual lane can enter real battle Lua, materialize 6 hero controllers, attach 6 real Spine actor prefab instances, render those actors on a map-backed battle camera, resolve the first-wave monster data fallback, resolve all three visible enemy models through local `.bigd` monster rows, reach `BattleBegin`, enter big/small round flow, enumerate 72 FightPlay action entries, and drive all 72 into actor preview motion without Unity errors.

The Real Attack Task Probe lane now runs with `useAttackTaskPreview=false` and reaches the original full-round coroutine path: `BattleAllBigRoundBegin` / `BattleSmallRoundBegin` are no longer shortcut in that lane, `WaitUntil` is honored by the frame scheduler, 20 big rounds and 40 small-round halves complete, `FinalBattleEnd` fires once, `isBattleEnd=true`, and coroutine pending count finishes at 0. The real `AttackTaskMgr` path now adds 29 tasks, executes 22 normal tasks, and routes 29 real-path attack previews without Unity errors.

It still does not claim full original battle playback. The actor surface is now real Spine/prefab-backed and FightPlay actions cause visible actor pulses. The previous weak enemy visual duplication (`1100112/1100113 -> 1100111`) is gone; those slots now use the same `.bigd` base-row fallback already used by the Lua data path (`1100112/1100113 -> 1100110 -> model_3006`). That means they are no longer arbitrary copies, but exact per-instance monster rows for `1100112/1100113` are still absent in local K/O `.bigd` tables. The remaining local actor gap is `1036 -> 1034` because `download/roleprefabsandres/battleprefabandres/1036.assetbundle` is still not present locally. The default visual lane still uses the guarded attack-task preview after 12 shortcut passes. The real attack lane now completes the full round loop, but skill/timeline effects are still represented by actor preview pulses and Play Mode guards rather than original skill prefab/timeline playback. Next work should continue with:

1. Exact actor asset frontier: acquire/import `download/roleprefabsandres/battleprefabandres/1036.assetbundle`; keep searching only for authoritative per-instance enemy rows/aliases if production data has visuals beyond the current `1100110 -> model_3006` source fallback.
2. Attack timeline frontier: continue from `BATTLE_90_REAL_ATTACK_PROBE_RESULT.json`; replace the remaining actor preview pulse bridge with original skill prefab/timeline playback and completion callbacks.
3. Data hardening: keep the `110011x -> 1100110` data fallback aligned with local `.bigd` K/O rows; if a future source exposes direct `1100112/1100113` rows, prefer those over the base fallback.
