# BATTLE_88 — M2 headless battle: progress

Generated: 2026-06-26 KST. Harness: `Assets/Editor/GirlsWarLuaBootstrapMilestone2.cs`.
Result JSON: `reports/battle/BATTLE_88_M2_HEADLESS_BATTLE_RESULT.json`.

## 2026-06-27 UPDATE — `battleEntered=true` ACHIEVED ✅

The headless run now reports `battleEntered=true`, `failedStage=""`, `error=""`. The real
`ProcedureNormalBattle_OnEnter` runs to completion offline (InitBattleInfo -> teams +
data tables loaded -> LoadScene callback -> LoadMaps/LoadBattleUI3D/LoadAutoMode/
LoadGameSpeed/LoadGameFastSkill), and the harness pumps 120 update ticks with no error.

Fixes that closed the gap from the old `PNB:740` stop (this session):
1. **Data wiring** — `OnEnter(a)` never stores its arg. Set `PNB.FightPlayData=info`
   (+`IsFightPlay=true`) before OnEnter (PNB == module table `e/t`), mirroring the game's
   `PlayFightClientReplay`. InitBattleInfo then takes the `InitDataWithFightPlayData` branch
   -> `e.BattleType=info.battleType` (=1). Confirmed `DTBattleDBModel.GetEntity(1)`
   self-populates offline (isLoadIO false -> InitRequire -> `DTBattleEntityTableData` row
   id=1 `campaign`); the worried "2nd blocker" needed no flag.
2. **stdlib extensions** — require `Common/StringUtil` then `Common/TableUtil` (install
   `string.split`/`table.deepCopy`/... onto the std libs; battle code calls them).
3. **GameEntry stub** — added `Scene` (LoadScene **invokes its callback** = the real battle
   setup) and `Lua`; `Pool.GameObjectSpawn` now accepts the 3-arg `(id,parent,cb)` form but
   does NOT invoke the cb (those configure VIEW objects via CS calls; M3 view lane).
4. **SaveMgr stub** (pure-lua, returns caller defaults = no saved prefs) + **`PlayerMgr.
   PlayerInfo.uid`** set to `ourPlayerId` so the prefs loaders' `string.format('%d_...',uid)`
   works instead of choking on the NOOP.

### NEXT — drive the wave/round replay to a BattleResult
`battleEntered=true` means we ENTERED; the fight is not yet replayed. `PNB` has no
`OnUpdate` (the harness pump hits the NOOP fallback), and `e.curProcedureBattle` is nil
(we didn't call `PNB:DefaultBattle()`), so the round loop hasn't started. The real start is
event-driven (`OnBattleUILoadComplete` -> begin), which never fires headless. To replay:
- set `e.curProcedureBattle = PNB:DefaultBattle()` (as `PlayFightClientReplay` does),
- find/drive the function that begins wave/bigRound/smallRound processing of `actionData`,
- iterate run->blocker->fix until a BattleResult is produced and HP/rounds match the data.

---
(History below is the pre-2026-06-27 state, kept for reference.)

## How far it runs now (real, validator-style)

The harness drives the real game Lua this far, in batchmode:

1. xLua VM boots, custom loader indexes decoded Lua. ✅
2. Permissive `_G` (absorbing NOOP) replaces the strict `Common/Global` guard. ✅
3. Framework globals required & live: JsonUtil, GameTools, GameInit, CommonEventId,
   EventSystem, ModulesInit, PlayerMgr. ✅
4. **`require('ProcedureNormalBattle')` succeeds — all 329 battle modules load.** ✅
5. `JsonUtil.decode(BATTLE_TEST_PAYLOAD)` works (pure-lua Common/json). ✅
6. **`ProcedureNormalBattle_OnEnter(battleInfo)` executes into the real entry body**,
   past event registration, to **line ~828** (the BGM branch). ✅ (executing real logic)

7. C# `YouYou.GameEntry` subsystem stub added (Time/UI/Pool/Audio/Procedure/Camera/Effect/
   Resource/Instance/Video; object returns hand back the Lua NOOP). Direct
   `CS.YouYou.GameEntry.*` accesses now resolve. ✅
8. Generalized permissive `__index` fallback (chains class metatables) + audio/BGM path
   skipped (headless). ✅
9. **OnEnter -> `InitBattleInfo` (line ~832 -> 740): now processing the REAL battleInfo.** ✅

Current stop (NEW KIND — data wiring, not framework): `InitBattleInfo:740`
`i.GetEntity(e.BattleType)` returns nil -> error branch concatenates `e.BattleType`
(also nil). Two real data issues:
- `e.BattleType` is not wired from our payload (`battleType=1`) — OnEnter's data flow
  (FightPlayData -> BattleType) needs to be set before InitBattleInfo.
- `DTBattleDBModel.GetEntity(1)` needs the data table POPULATED offline (the IO-load path;
  this is Codex handoff task T1).

**Significance:** framework neutralization (the hard, generic part) is essentially done —
execution runs deep into real battle logic. The remaining blockers are DATA WIRING
(feed battleType/battleInfo correctly + ensure DT*DBModel self-populate offline), which is
well-scoped and overlaps Codex's T1 data-table audit.

## Fixes landed to get here

- Path-aware custom loader (resolves leaf collisions across decoded trees).
- `decode_all_xlualogic.py`: classify each TextAsset by which of {raw, XOR} reads more like
  Lua (not the brittle A-EV magic) — fixes data-table-plaintext vs module-encrypted.
- xLua `LuaDLL.lua_tostring`: always UTF-8 (the game Lua has CJK; `PtrToStringAnsi` threw).
- Absorbing-NOOP permissive `_G` (survives index/call/compare/arith/concat).
- Don't clobber self-assigning globals (JsonUtil returns `true`).
- `BuildPatchMgr` logic stub (route JSON to pure-lua; version compare = 0).
- Permissive `__index` fallback on real framework modules (missing native methods -> NOOP).

## Next step (DATA WIRING — framework stubbing is done)

1. Wire `e.BattleType` (and the rest of FightPlayData) from the passed battleInfo in
   OnEnter before InitBattleInfo runs. Trace how the original OnEnter stores `a` ->
   FightPlayData -> BattleType (PNB ~line 785+, and InitBattleInfo ~700+).
2. Ensure `DTBattleDBModel` (and the other DT*DBModel the battle reads) self-populate via
   the offline IO-load path (Codex handoff T1: `GameInit` flags like ServerLoadTable=false /
   ClientIsSupportIOLoad). `i.GetEntity(1)` must return the normal-battle row.
3. Then iterate the wave/round replay to a BattleResult; flip `battleEntered=true`.

## (done) GameEntry C# stub

The battle uses `CS.YouYou.GameEntry.<Subsystem>:<Method>()` directly (and via real modules
like GameTools). The global `GameEntry` is already a permissive NOOP, but the DIRECT
`CS.YouYou.GameEntry` needs a real C# type. Build `YouYouStubs/GameEntry.cs` with the
observed subsystems as no-ops: `Time` (RemoveTimeActionByName/AddTimeAction...), `UI`
(OpenUIForm/CloseUIForm/IsExists/SetSortingOrder), `Pool` (GameObjectSpawn/Despawn),
`Audio` (StopAudio/StopBGM/StopAllAudio/PauseBGM/GetBGMCurrAudioEventId), `Procedure`
(ChangeState/CurrProcedureState), `CameraCtrl` (MainCamera/UICamera/CameraMaskChangeColor),
`Effect` (ShowUIEffect/ShowBuffEffect), `Resource` (ResourceManager), `Instance` (UI3DRoot),
plus props `AppVer`, `IsReview`, `IsCommittee`.

Key design: methods that return objects the Lua then calls (e.g. `UI:OpenUIForm` -> form)
should return the harness's Lua NOOP (pass the cached `LuaTable` into the stub) so
`form:GetXxx()` chains stay no-crash. Then keep iterating run->blocker->fill until
`battleEntered=true` and the wave/round replay advances to a BattleResult.

Most of the remaining surface is view/UI/audio (no-op for headless). The battle LOGIC
(damage/round replay) is data-driven and already loaded — the work is neutralizing the
view/native surface, not implementing game rules.
