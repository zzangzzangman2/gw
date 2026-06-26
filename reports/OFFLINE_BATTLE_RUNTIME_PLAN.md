# Offline Battle Runtime — Plan & Work Split (Claude + Codex)

Generated: 2026-06-26 KST
Goal: make GirlsWar **actually playable offline** = run a real battle from decoded Lua,
no live server. This is the runtime track (the static scene-cosmetic track is a dead end
for playability).

## Why this is feasible (scouted, evidence-backed)

- The battle is **data-driven replay, not simulation**: the server pre-resolves the whole
  fight and sends `actionData` (per-round action sequence) + `heroStatistics` (final dmg/hp).
  A complete real battle is hardcoded in `ProcedureNormalBattle` line 589
  (`e.FightPlayData = JsonUtil.decode(t).battleInfo`). So **no damage-formula / RNG reversing
  is needed** to replay a battle — the outcome is in the data.
- Inputs all present: `BATTLE_TEST_PAYLOAD.json` (battleInfo shape), 131-hero catalog,
  38 actor bundles (incl. 1036/1002/1034 from the sample), Spine runtime (vendored),
  skill/timeline assets extracted.
- Native surface is BOUNDED: mostly Unity/DOTween/TMP/Spine (available) + a finite
  `CS.YouYou.*` set (GameEntry, LuaManager, ProcedureState, LuaUnit, YouYouImage,
  TimelineEffect, ScrollScene, EventSystem, JsonUtil) + plain enums (CS.MyCommonEnum.*).
- require() mapping is safe: 4,492 decoded Lua files have globally-unique leaf names;
  4,357 distinct require paths resolve by leaf.

## The real gap

Nobody stood up the Lua VM. Battle52 confirmed `xluaRuntimeAvailable=False`,
`GameEntry=False`, `LuaManager=False` — only empty type stubs existed. The work is:
**boot xLua, then stub-implement CS.YouYou.* until ProcedureNormalBattle runs the battle.**
Method: run -> hit a missing CS API -> implement it -> repeat (the Lua tells us exactly
what it needs).

## Milestones

- **M1 — VM boots + loader resolves decoded Lua.** (foundation; in progress)
  - xLua vendored at `girlswar_battle_unity/Assets/XLua` + `Plugins/x86_64/xlua.dll`.
  - `Assets/Scripts/GirlsWar/GirlsWarLuaLoader.cs` (custom require -> decoded files).
  - `Assets/Editor/GirlsWarLuaBootstrapMilestone1.cs` (batch entry, writes
    `reports/battle/BATTLE_86_XLUA_BOOTSTRAP_M1_RESULT.json`).
  - DONE when probeRequireOk=true (a data-table module loads).
- **M2 — headless battle logic runs.** Feed the embedded/`BATTLE_TEST_PAYLOAD` battleInfo
  to `ProcedureNormalBattle_OnEnter`, run the state machine to completion, emit the result.
  No visuals. DONE when a battle plays start->end and produces a BattleResult without error.
  This is the "B is real" proof.
- **M3 — visual replay.** Spine actors + skill/timeline effects animate the actionData;
  HUD shows HP/round. DONE when one full battle is watchable and matches the data.

## Work split (disjoint, both push to main per project rule)

**Claude (runtime core / logic lane):**
1. M1 bootstrap + loader (this commit).
2. xLua bridge config: `[LuaCallCSharp]`/`[CSharpCallLua]` lists; reflection-mode first,
   codegen later if perf needs.
3. Stub the LOGIC-side CS.YouYou.* the battle Lua hits at boot/OnEnter: GameEntry,
   LuaManager, EventSystem, JsonUtil, DataTable loaders (DTSysUIForm/DTBattleDBModel are
   plain Lua tables -> load via the same loader), ProcedureState enums, cs_coroutine.
4. Drive M2: iterate run->missing-API->stub until ProcedureNormalBattle reaches battle end.

**Codex (data + asset/visual lane):**
1. Verify the decoded data-table Lua modules (DT*DBModel) load and self-populate (many
   call `GameInit.ServerLoadTable` else IO-load — confirm the IO-load path works offline).
2. Map each sample hero/enemy (heroDid 1036/1002/1034/1100111...) to its actor bundle +
   Spine skeleton + skill timeline assets already extracted; produce a load manifest.
3. M3 visual layer: SkeletonAnimation playback + skill/TimelineEffect hookup driven by
   actionData (actionType 1/2/3 = ?; decode from BattleManager/state machine Lua).
4. Stub the RENDER-side CS.YouYou.* (YouYouImage, TimelineEffect, ScrollScene, GameEntry.Video).

**Shared contracts (avoid collisions):**
- All new C# runtime under `girlswar_battle_unity/Assets/Scripts/GirlsWar/` (Claude owns
  core/, Codex owns visual/). xLua bridge config in `GirlsWar/Bridge/`.
- CS.YouYou.* stubs: namespace `YouYou`, one file per class, in `GirlsWar/YouYouStubs/`.
  Claim a class by creating its file first; check before adding.
- battleInfo source of truth: `BATTLE_TEST_PAYLOAD.json` (and the line-589 embed as fallback).
- Each milestone writes `reports/battle/BATTLE_8x_*_RESULT.json` with a real pass/fail.

## Guardrails (same as restore rules)

- No fake battle results — replay the real data; if a value is unknown, leave it and log it.
- Don't delete original evidence / decoded Lua.
- Headless batch verification first (`-batchmode -nographics`), visuals after.
- Commit + push each working step to `main`.

## Dependencies obtained

- xLua (Tencent, MIT) cloned; runtime (Src + Resources + x86_64/xlua.dll) vendored into
  the battle project. Codegen Editor folder omitted for now (reflection mode boots fine).
