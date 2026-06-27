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
- trace: `ProcedureNormalBattle_OnEnter;LoadPlayerHeros;LoadPlayerHero;LoadPlayerHero;LoadPlayerHero;LoadEnemyPlayerHeros;LoadPlayerHero;`
- diag: `loadPlayerHero=6 loadEnemy=1 teamReady=0 battleBegin=0 bigRound=0 currBigRound=0`

## What Changed

- Added a runtime `BattlePlayModeBootstrap` MonoBehaviour that reuses the M2 Lua data wiring in Unity Play Mode client mode.
- Added a BATTLE90 editor runner that creates/opens a dedicated scene, enters Play Mode, waits for the bootstrap result, and exits with a real process code.
- Extended `YouYou.GameEntry` stubs so Lua `cs_coroutine` can use a real MonoBehaviour coroutine host and `Procedure.ChangeState` is observable.
- Added minimal Play Mode view stubs for `GameEntry.Pool`, `LuaHeroSprite`, `LuaUtils`, and station transforms so original Lua reaches actual `ProcedureNormalBattle_OnEnter` and team load calls.

## Current Boundary

BATTLE90 proves the watchable-battle lane now has a Play Mode entry harness with real frame pumping. It does not claim full battle playback yet: `teamReady=0` because the placeholder `LuaHeroSprite` does not yet run the original actor/Spine lifecycle that marks teams ready and drives `BattleBegin`.

Next work should continue with the handoff order:

1. P2 data frontier: verify enemy monster `heroDid` mapping / `.bigd` IO when the real actor lifecycle reaches `HeroCtrl:OnOpen`.
2. P3 visual frontier: replace placeholder actor spawn with the real Spine-backed actor prefab/lifecycle so team readiness and battle rounds advance on frames.
