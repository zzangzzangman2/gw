# BATTLE_89 — M2 server-mode synchronous battle replay: progress

Generated 2026-06-27 KST. Harness method: `GirlsWarLuaBootstrapMilestone2.RunServerReplay`.
Result JSON: `reports/battle/BATTLE_89_M2_SERVER_REPLAY_RESULT.json`.

## Why a second path (vs BATTLE_88 `Run` / battleEntered=true)

The battle is a coroutine + timer + WaitForSeconds driven **animation playback** engine.
In a headless `-executeMethod` batch run, Unity does not pump frames/coroutines, so the
**client** replay (`cs_coroutine` -> `GameEntry.Instance:StartCoroutine`) never advances —
`Run`'s `battleEntered=true` means OnEnter completed, but the wave/round replay never ran.

Key find: `ProcedureNormalBattle` top picks the coroutine driver by mode —
`if GameInit.IsClient then h=require'Common/cs_coroutine' else h=require'Common/cs_coroutine_server'`.
`cs_coroutine_server.start = function(fn) fn() end` runs coroutines **synchronously**. So the
**server/verify path (`GameInit.IsClient=false`) runs the whole replay synchronously, headless**,
and skips the entire view/animation surface (`if GameInit.IsClient==false ... return`).
That is the logic-only path `RunServerReplay` drives via `PNB.BeginFightPlayWithServer(battleInfo)`
(what `PlayFightServerCheck` calls; we call it directly to keep state inspectable — the public
entry's `Exit()` wipes team/round state before we can read it).

## Blockers fixed this pass (each was a real run -> error -> fix loop)

1. **`Common/Class` not loaded** -> global `Class` was the permissive NOOP -> `HeroCtrl=Class(...)`
   became NOOP -> every hero mis-classified (`IsPet()` -> NOOP truthy) -> teams never reach
   ready. Fix: `require('Common/Class')` before the battle modules load. (`BattleTeam` was fine
   because it's a plain table, not Class-based — that masked the issue.)
2. **`ModulesInit.ProcedureNormalBattle` = NOOP** -> `PlayFightServerCheck`/battle dispatch via
   `ModulesInit.ProcedureNormalBattle.X` all no-op'd (chainTrace = NOCHAIN). Fix: bind it to the
   required PNB table (`rawset(ModulesInit,'ProcedureNormalBattle',PNB)`).
3. **`HeroMgr` missing** -> `ourTeamFormation` entries carry only `heroId` (no `heroDid`);
   `LoadPlayerHeros` fills `heroDid` via `HeroMgr:GetHeroDataByHeroId`, and `HeroCtrl:OnOpen`
   needs a valid `heroDid` for `DTHeroRow`. Fix: build a heroId->hero lookup from the payload's
   `ourHeros`/`enemyHeros` (which pair heroId<->heroDid).
4. **`GameInit.IsClient` defaulted true** (init/GameInit.lua) -> client view code ran headless and
   spun. Fix: force `IsClient=false` before modules load AND re-assert right before entry.
5. **`ipairs(NOOP)` infinite loop** — Lua 5.3 `ipairs` reads `t[i]` through `__index`; NOOP
   returned NOOP forever (e.g. `HeroBattleInfo.SetHeroSkill`'s `for _ in ipairs(e.underwearSuits)`).
   Fix: NOOP `__index` returns **nil for numeric keys** (ipairs terminates at 1) while still
   chaining for field/method keys.
6. **Data-table IO-load** — large tables (monster/...) default `isLoadIO=true` and read `.bigd`
   binary IO at an unprovisioned path -> `GetEntity` crashed on a nil `DataTableHeader`. The game
   flips them to inline-Lua mode when `GameTools.ClientIsSupportIOLoad()==false` (this is exactly
   the Codex T1 flag). Fix: force that flag false + flip every loaded DB model's `isLoadIO` field.
7. **`GameTools.GetLocalize`** gsub'd a NOOP language template (display only). Fix: return the key
   as a string.
8. Safety: an instruction-count `debug.sethook` converts any runaway headless loop into a traceback
   instead of hanging the batch run.

## How far it runs now

`BeginFightPlayWithServer` -> `InitBattleInfo` (teams + data tables) -> **our 3 heroes load FULLY**
as real `HeroCtrl` objects (DTHeroRow config + `SetHeroSkill` + attributes from payload) -> enemy
load begins.

## Current frontier (next blocker — DATA SEMANTICS, not framework)

`HeroCtrl:OnOpen:834` indexes a nil `DTMonsterRow`: enemy `heroDid` `1100111/1100112/1100113`
have **no row** in the inline `DTMonsterEntityTableData` (it has the group base `1100110`, ending
in 0; enemy dids end in 1/2/3 = positions in the group). Two possibilities to resolve next:
- the inline Lua monster table is a partial set and the `.bigd` (in
  `girlswar_merged_extracted/extracted/config_zips/.../monster/DTMonsterEntityTableData.bigd`) has
  the per-position rows -> provision/parse the `.bigd` IO path instead of inline; OR
- enemy `heroDid` maps to a monster config id by a transform (e.g. group base `// 10 * 10`).
  Inspect how the original enemy/monster load resolves the config id before `OnOpen`.

After enemy heroes load: both teams reach ready -> `BattleBegin` -> `BattleAllBigRoundBegin` (a
`for` over `MaxBattleBigRound`, run synchronously in skip mode) -> per-smallRound `actionData`
processing (Formula damage, buffs) -> `FinalBattleEnd` -> `FightDataReportMgr.isValid`. That round
loop is the remaining body of M2.

## Strategic note

- This path validates the **logic** (does the recorded `actionData` replay to the recorded result)
  and produces no visuals. It is a long tail: monster-data semantics, then the full
  round/skill/buff/damage processing.
- The **watchable** battle (the user's actual goal) is the M3 view lane: run in Unity **Play Mode**
  (coroutines/timers/animations tick over real frames) with Spine actors. That is a separate, larger
  effort and overlaps `reports/CODEX_HANDOFF_VIEW_LANE.md`.

## Reproduce

```
& "C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe" -quit -batchmode -nographics `
  -projectPath girlswar_battle_unity `
  -executeMethod GirlsWar.GirlsWarLuaBootstrapMilestone2.RunServerReplay `
  -logFile reports\battle\BATTLE_89_M2_SERVER_REPLAY.log
# result: reports\battle\BATTLE_89_M2_SERVER_REPLAY_RESULT.json (PROBE/chainTrace/error)
```
