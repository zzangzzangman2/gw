# BATTLE_87 — M2 scope & stub work-list (headless battle)

Generated: 2026-06-26 KST
Follows M1 (`BATTLE_86`, runtime boots). Tool: `_restore_tools/scripts/analyze_battle_lua_closure.py`.

## M2 goal

Feed `BATTLE_TEST_PAYLOAD.json` (battleInfo) to `ProcedureNormalBattle_OnEnter`, run the
battle state machine to completion **headless** (no visuals), produce a BattleResult with
no error. This is the "B is real / actually playable" proof.

## Static closure (single pass, no Unity round-trips)

Transitive `require()` closure from `ProcedureNormalBattle`:
- **modules resolved: 329, missing: 0** — every Lua dependency is decoded and resolvable
  by the custom loader. No further decode needed for the battle path.

## Native surface to stub (small)

`CS.YouYou.*` distinct classes = **8**:
| class | role | M2 (headless) |
| --- | --- | --- |
| GameEntry | framework root (Event/Resource/Time/UI/...) | functional-minimal |
| MacroDefine | constants/macros | constants |
| ProcedureState | state enum/registry | enum/minimal |
| AsyncLoadManager | async asset load | stub (sync/no-op callbacks) |
| LuaUnit | view component base | no-op |
| LuaHeroSprite | hero actor view | no-op (M3 fills) |
| ScrollScene | scene scroll/camera | no-op (M3) |
| TimelineEffect | skill/timeline FX | no-op (M3) |

Plus: standard `CS.UnityEngine.*` (Application, RuntimePlatform, WaitForSeconds, Canvas —
real Unity), `CS.DG.Tweening` (DOTween; needed mainly for M3 visuals), `CS.XXTEAUtil`.

Native-bound global `LuaUtils` (459 refs in il2cpp; no Lua file) — surface is almost all
VIEW manipulation, so headless stubs are no-ops:
`SetActive(300), SetLocalPos(30), SetLocalScale(29), SetChildActive(29),
SetTextMeshText(27), SetImageSprite(13), SetParent(9), GetLocalPos(9), Instantiate(6),
AnimtorPlay(6), GetLuaComBinder(7), GetInstanceID(6), ...`. Only `Instantiate`,
`GetLuaComBinder`, `GetInstanceID`, `GetFileText`, `GetSysprefabData` may need real-ish
returns; the rest are no-ops for logic.

## Global bootstrap mechanism

`common/Global.lua` installs a STRICT-global guard: `setmetatable(_G, {__index/__newindex})`
that errors on access/write of an undeclared global (declared via `GLDeclare`). So the
harness order is:
1. boot LuaEnv + custom loader (M1, done)
2. bind native stub globals: `LuaUtils`, `GameEntry`, `MacroDefine`, `CS` access, etc.
3. `require("Common/Global")` (installs the guard) — declare natives via GLDeclare/rawset
4. `require` Lua-side globals: `JsonUtil`, `GameTools`, `GameInit`, `CommonEventId`,
   `EventSystem`, `ModulesInit`, `PlayerMgr` (all have Lua files)
5. `ModulesInit` -> `ProcedureNormalBattle.ProcedureNormalBattle_OnEnter(battleInfo)`
6. pump coroutines/update until battle end; read BattleResult.

## Work split (per OFFLINE_BATTLE_RUNTIME_PLAN.md)

- **Claude (logic/core)**: harness + bootstrap sequence; stub GameEntry (Event/Time/Resource
  minimal), MacroDefine, ProcedureState, AsyncLoadManager, LuaUtils (no-op view + real
  accessors), JsonUtil bridge; drive run-iterate until headless battle completes.
- **Codex (data/visual)**: confirm DT*DBModel IO-load path populates offline; actor/skeleton/
  skill-timeline load manifest for sample heroes; M3 view stubs (LuaHeroSprite, ScrollScene,
  TimelineEffect, DOTween) once headless passes.

Stub location: `girlswar_battle_unity/Assets/Scripts/GirlsWar/YouYouStubs/` (one file per
class; claim by creating the file first). Harness: `Assets/Editor/GirlsWarLuaBootstrapMilestone2.cs`,
writes `reports/battle/BATTLE_88_M2_HEADLESS_BATTLE_RESULT.json` with a real pass/fail.

## Guardrails

Replay the real battle data; never fabricate a battle result. No-op a view call only when
it cannot affect logic. Headless batch verification first; commit + push each working step.
