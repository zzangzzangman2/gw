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
- visual actor screen area: `0.146486`
- capture non-dark sample count: `1548`
- trace: `ProcedureNormalBattle_OnEnter;LoadPlayerHeros;LoadPlayerHero;LoadPlayerHero;LoadPlayerHero;LoadEnemyPlayerHeros;LoadPlayerHero;OnBattleTeamReady;OnBattleTeamReady;FirstBattleTeamReady;AfterBattleTeamReady;CheckBattleBegin;BattleBegin;CheckFirstAttackTeam;CheckRelic;BattleFightSuppress;BattleRoundBeginAddTreasure;BattleRoundBeginAddBuff;BattleRoundBeginAddBuffComplete;BattleAllBigRoundBegin;BattleBigRoundBegin;BattleSmallRoundBegin;BattleRoundExplosive;BattleRoundExplosiveComplete;BattleRoundEndCheckBuff;BattleRoundEndCheckBuffComplete;StartAttackTask;...`
- diag: `loadPlayerHero=6 loadEnemy=1 teamReady=2 firstReady=1 afterReady=1 battleBegin=1 bigRound=1 currBigRound=1 attackPreviewMode=true defineLoadOk=true enumSnapshot=skillSmall=2/skillEndPet=5/actionNormal=2 firstValueDefault=2 firstRateDefault=0 spineAnimationGuard=6 heroViewBridge=6 skinRuntime=6 skinSpine=6 skinVisualFallback=3 monsterFallback=2 readyTeams=2 ourCur=3 enemyCur=3 firstShortcut=1 beginBuffShortcut=1 allBigShortcut=1 smallRoundShortcut=1 attackTaskShortcut=12 attackTaskGuard=1 attackActions=72 attackPreview=72 attackPreviewMiss=0 pnbStartAttack=13 runtimeAttach=6 runtimePrefab=6 runtimeSpine=6 runtimePreview=72 runtimePreviewDone=72 runtimePreviewMiss=0 visualActors=6 visualRenderers=6 visualScreenArea=0.146486 captureNonDark=1548`

## Real Attack Task Probe

- menu/execute method: `GirlsWar.Battle90PlayModeLuaBootstrapEditor.VerifyRealAttackProbe`
- result: `reports/battle/BATTLE_90_REAL_ATTACK_PROBE_RESULT.json`
- capture: `reports/battle/BATTLE_90_REAL_ATTACK_PROBE_CAPTURE.png`
- Unity exit code: `0`
- `useAttackTaskPreview`: `false`
- frames pumped: `360`
- `battleEntered`: `true`
- errors: `0`
- attack task proof: `pnbStartAttack=4`, `pnbAddAttack=3`, `pnbGetAttack=6`, `mgrAddTask=3`, `mgrExecuteTask=3`, `mgrExecuteNormal=3`, `mgrTaskComplete=3`, `heroNormal=3`, `realAttackPreview=3`
- current last task boundary: `pnbGetAttackLast=manual=false task=nil skill=5`

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
- Added a Play Mode-only monster-data fallback for battle payload enemy IDs like `1100111 -> 1100110`.
- Added Play Mode-only shortcuts for missing Unity/UI surfaces: inline coroutine pumping, immediate `TimeActionMgr`, battle-start UI bypass, minimal pet placeholders, begin-buff/big-round/small-round/attack-task guards.
- Added an alternate Real Attack Task Probe run that disables the guarded `StartAttackTask` preview shortcut and records `ProcedureNormalBattle`, `BattleTeam`, `AttackTaskMgr`, and `HeroCtrl` counters.
- Loaded `Common/Define` under a guarded client flag so battle enums are real numbers in Play Mode (`SmallSkillAttacking=2`, `SmallRoundEndPetHelpSkillAttacking=5`, `SmallRoundStartTeamAttacking=6`, `NormalOrSmallSkill=2`).
- Added Play Mode-only guards for offline gaps exposed by the real path: `LuaUtils.IsNull`, global `WaitUntil`, nil `TotalFirstValue`, and Spine wrapper `invisible`/animation calls on raw C# `SkeletonAnimation`.

## Current Boundary

BATTLE90 now proves two lanes. The default visual lane can enter real battle Lua, materialize 6 hero controllers, attach 6 real Spine actor prefab instances, render those actors on a map-backed battle camera, resolve the first-wave monster data fallback, reach `BattleBegin`, enter big/small round flow, enumerate 72 FightPlay action entries, and drive all 72 into actor preview motion without Unity errors.

The Real Attack Task Probe lane now runs with `useAttackTaskPreview=false` and reaches the real `AttackTaskMgr` path: three normal attack tasks are added, executed, completed, and routed through `HeroCtrl.NormalAttack` into actor preview pulses. This is a material step beyond the guarded 72-action visual preview path.

It still does not claim full original battle playback. The actor surface is now real Spine/prefab-backed and FightPlay actions cause visible actor pulses, but 3 actor slots use visual fallback mappings (`1036 -> 1034`, `1100112/1100113 -> 1100111`) because the exact battle actor assets are not local/imported. The default visual lane still uses the guarded attack-task preview after 12 shortcut passes. The real attack lane currently advances through normal attacks only and ends the observed probe at a nil next task for `skill=5`, so pet/help/end-of-small-round task reconstruction remains the next frontier. Next work should continue with:

1. Exact actor asset frontier: acquire/import `download/roleprefabsandres/battleprefabandres/1036.assetbundle` and authoritative enemy instance visuals for `1100112/1100113`.
2. Attack timeline frontier: continue from `BATTLE_90_REAL_ATTACK_PROBE_RESULT.json`; reconstruct the `skill=5` follow-up task source after the 3 normal tasks and then replace the guarded default shortcut with real skill prefab/timeline playback and completion callbacks.
3. Data hardening: keep the `110011x -> 1100110` data fallback only if it matches the encrypted `.bigd` source of truth, otherwise load the real monster rows.
