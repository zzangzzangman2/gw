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
- trace: `ProcedureNormalBattle_OnEnter;LoadPlayerHeros;LoadPlayerHero;LoadPlayerHero;LoadPlayerHero;LoadEnemyPlayerHeros;LoadPlayerHero;OnBattleTeamReady;OnBattleTeamReady;FirstBattleTeamReady;AfterBattleTeamReady;CheckBattleBegin;BattleBegin;CheckFirstAttackTeam;CheckRelic;BattleFightSuppress;BattleRoundBeginAddTreasure;BattleRoundBeginAddBuff;BattleRoundBeginAddBuffComplete;BattleAllBigRoundBegin;BattleBigRoundBegin;BattleSmallRoundBegin;BattleRoundExplosive;BattleRoundExplosiveComplete;BattleRoundEndCheckBuff;BattleRoundEndCheckBuffComplete;StartAttackTask;...`
- diag: `loadPlayerHero=6 loadEnemy=1 teamReady=2 firstReady=1 afterReady=1 battleBegin=1 bigRound=1 currBigRound=1 heroViewBridge=6 skinStub=6 monsterFallback=6 readyTeams=2 ourCur=3 enemyCur=3 firstShortcut=1 beginBuffShortcut=1 allBigShortcut=1 smallRoundShortcut=1 attackTaskShortcut=12 attackTaskGuard=1 attackActions=72 coroutineInline=1`

## What Changed

- Added a runtime `BattlePlayModeBootstrap` MonoBehaviour that reuses the M2 Lua data wiring in Unity Play Mode client mode.
- Added a BATTLE90 editor runner that creates/opens a dedicated scene, enters Play Mode, waits for the bootstrap result, and exits with a real process code.
- Extended `YouYou.GameEntry` stubs so Lua `cs_coroutine` can use a real MonoBehaviour coroutine host and `Procedure.ChangeState` is observable.
- Added minimal Play Mode view stubs for `GameEntry.Pool`, `LuaHeroSprite`, `LuaUtils`, and station transforms so original Lua reaches actual `ProcedureNormalBattle_OnEnter` and team load calls.
- Bridged opened `LuaHeroSprite` instances into the original Lua `HeroCtrl` lifecycle, so both teams reach ready state (`ourCur=3`, `enemyCur=3`, `teamReady=2`).
- Added a Play Mode-only monster-data fallback for battle payload enemy IDs like `1100111 -> 1100110`.
- Added Play Mode-only shortcuts for missing Unity/UI surfaces: inline coroutine pumping, immediate `TimeActionMgr`, battle-start UI bypass, minimal skin/pet placeholders, begin-buff/big-round/small-round/attack-task guards.

## Current Boundary

BATTLE90 now proves the Play Mode lane can enter real battle Lua, materialize 6 hero controllers, resolve the first-wave monster data fallback, reach `BattleBegin`, enter big/small round flow, and enumerate 72 FightPlay action entries without Unity errors.

It still does not claim full watchable battle playback. The current attack task path is guarded after 12 shortcut passes because real Spine/timeline/prefab surfaces are still placeholders. Next work should continue with:

1. P3 visual frontier: replace placeholder `LoadSkin`/`LoadPet` with the real Spine-backed actor prefab/lifecycle.
2. Attack timeline frontier: replace the guarded `StartAttackTask` shortcut with real skill prefab/timeline playback and completion callbacks.
3. Data hardening: keep the `110011x -> 1100110` fallback only if it matches the encrypted `.bigd` source of truth, otherwise load the real monster rows.
