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
- visual actor screen area: `0.299325`
- capture non-dark sample count: `1539`
- trace: `ProcedureNormalBattle_OnEnter;LoadPlayerHeros;LoadPlayerHero;LoadPlayerHero;LoadPlayerHero;LoadEnemyPlayerHeros;LoadPlayerHero;OnBattleTeamReady;OnBattleTeamReady;FirstBattleTeamReady;AfterBattleTeamReady;CheckBattleBegin;BattleBegin;CheckFirstAttackTeam;CheckRelic;BattleFightSuppress;BattleRoundBeginAddTreasure;BattleRoundBeginAddBuff;BattleRoundBeginAddBuffComplete;BattleAllBigRoundBegin;BattleBigRoundBegin;BattleSmallRoundBegin;BattleRoundExplosive;BattleRoundExplosiveComplete;BattleRoundEndCheckBuff;BattleRoundEndCheckBuffComplete;StartAttackTask;...`
- diag: `loadPlayerHero=6 loadEnemy=1 teamReady=2 firstReady=1 afterReady=1 battleBegin=1 bigRound=1 currBigRound=1 heroViewBridge=6 skinStub=0 skinRuntime=6 skinSpine=6 skinQuadFallback=0 skinVisualFallback=3 monsterFallback=6 readyTeams=2 ourCur=3 enemyCur=3 firstShortcut=1 beginBuffShortcut=1 allBigShortcut=1 smallRoundShortcut=1 attackTaskShortcut=12 attackTaskGuard=1 attackActions=72 attackPreview=72 attackPreviewMiss=0 coroutineInline=1 runtimeAttach=6 runtimePrefab=6 runtimeSpine=6 runtimeVisualFallback=3 runtimeQuadFallback=0 runtimeMissingAsset=0 runtimePreview=72 runtimePreviewDone=72 runtimePreviewMiss=0 visualActors=6 visualRenderers=6 visualScreenArea=0.299325 captureNonDark=1539`

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

## Current Boundary

BATTLE90 now proves the Play Mode lane can enter real battle Lua, materialize 6 hero controllers, attach 6 real Spine actor prefab instances, render those actors on a map-backed battle camera, resolve the first-wave monster data fallback, reach `BattleBegin`, enter big/small round flow, enumerate 72 FightPlay action entries, and drive all 72 into actor preview motion without Unity errors.

It still does not claim full original battle playback. The actor surface is now real Spine/prefab-backed and FightPlay actions cause visible actor pulses, but 3 actor slots use visual fallback mappings (`1036 -> 1034`, `1100112/1100113 -> 1100111`) because the exact battle actor assets are not local/imported. The current attack task path is also still guarded after 12 shortcut passes because real skill timeline playback and completion callbacks are not reconstructed yet. Next work should continue with:

1. Exact actor asset frontier: acquire/import `download/roleprefabsandres/battleprefabandres/1036.assetbundle` and authoritative enemy instance visuals for `1100112/1100113`.
2. Attack timeline frontier: replace the guarded `StartAttackTask` shortcut with real skill prefab/timeline playback and completion callbacks.
3. Data hardening: keep the `110011x -> 1100110` data fallback only if it matches the encrypted `.bigd` source of truth, otherwise load the real monster rows.
