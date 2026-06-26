# BATTLE_88 — M2 headless battle: progress

Generated: 2026-06-26 KST. Harness: `Assets/Editor/GirlsWarLuaBootstrapMilestone2.cs`.
Result JSON: `reports/battle/BATTLE_88_M2_HEADLESS_BATTLE_RESULT.json`.

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

Current stop: `GameTools.SwitchBGMFadeOutLua` -> `CS.YouYou.GameEntry.Time:RemoveTimeActionByName`
— a DIRECT `CS.YouYou.GameEntry` access with no C# type behind it yet.

## Fixes landed to get here

- Path-aware custom loader (resolves leaf collisions across decoded trees).
- `decode_all_xlualogic.py`: classify each TextAsset by which of {raw, XOR} reads more like
  Lua (not the brittle A-EV magic) — fixes data-table-plaintext vs module-encrypted.
- xLua `LuaDLL.lua_tostring`: always UTF-8 (the game Lua has CJK; `PtrToStringAnsi` threw).
- Absorbing-NOOP permissive `_G` (survives index/call/compare/arith/concat).
- Don't clobber self-assigning globals (JsonUtil returns `true`).
- `BuildPatchMgr` logic stub (route JSON to pure-lua; version compare = 0).
- Permissive `__index` fallback on real framework modules (missing native methods -> NOOP).

## Next step (the GameEntry C# stub)

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
