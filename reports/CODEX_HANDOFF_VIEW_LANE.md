# Codex Handoff — Offline Battle VIEW / Visual Lane

Self-contained. You (Codex) own the **view/visual half** of making GirlsWar's battle play
offline. Claude owns the logic/core half (xLua harness + headless battle). Work in parallel;
push to `main`; do not edit the other lane's files.

Repo: `C:\Users\godho\Downloads\girlswar`  •  remote `github.com/zzangzzangman2/gw.git`
Unity: `C:\Program Files\Unity\Hub\Editor\6000.4.9f1` (batchmode `-nographics`, no GUI).
Battle Unity project: `girlswar_battle_unity`.

## Context (already done — read these)

- `reports/OFFLINE_BATTLE_RUNTIME_PLAN.md` — overall plan & milestones.
- `reports/battle/BATTLE_87_M2_SCOPE_AND_STUB_WORKLIST.md` — native surface + closure.
- The battle is a **data-driven replay**, not a sim: server pre-resolves the fight; the
  client animates `actionData`. A full sample battle is embedded in
  `decoded/.../ProcedureNormalBattle...lua` line 589, and `BATTLE_TEST_PAYLOAD.json`
  (`girlswar_battle_unity/Assets/RestoreData/battle/`) has the battleInfo shape.
- M1 done: xLua vendored (`Assets/XLua`, `Plugins/x86_64/xlua.dll`), VM boots, custom
  loader resolves decoded Lua (`Assets/Scripts/GirlsWar/GirlsWarLuaLoader.cs`).
- Decoded Lua: run `python _restore_tools/scripts/decode_all_xlualogic.py` first if
  `girlswar_merged_extracted/decoded/xlua_all/` is absent (it is gitignored, reproducible).

## File ownership (avoid collisions)

- **Claude owns**: `Assets/Editor/GirlsWarLuaBootstrapMilestone2.cs`, and
  `Assets/Scripts/GirlsWar/YouYouStubs/{GameEntry,MacroDefine,ProcedureState,AsyncLoadManager,LuaUtils}.cs`
  (Claude creates these as minimal/no-op so headless runs; do not edit them — extend via
  partial classes if you must add view behavior).
- **You (Codex) own**:
  - `Assets/Scripts/GirlsWar/YouYouStubs/{LuaUnit,LuaHeroSprite,ScrollScene,TimelineEffect}.cs`
    (create these; start as compile-OK no-ops, then fill for M3).
  - `Assets/Scripts/GirlsWar/View/` (new) — your actor/skeleton/effect playback code.
  - `_restore_tools/scripts/build_battle_asset_manifest.py` (new) — your data/asset manifest.
- Shared: if you need a method on a Claude-owned stub, add it as a `partial class` in your
  own file under `YouYouStubs/` (e.g. `LuaUtils.View.cs`). Never edit Claude's file.

## Your tasks

### T1 — Offline data-table load path (unblock data)
Many `DataNode/DataTable/Create/*DBModel` modules branch on `GameInit.ServerLoadTable`
(server) vs an IO-load path. Confirm the **offline IO-load path** populates the tables
without a server. Write `reports/battle/BATTLE_DATATABLE_OFFLINE_LOAD_AUDIT.md`:
which DT*DBModel the battle closure needs (see `analyze_battle_lua_closure.py`), and whether
each self-populates offline or needs a flag set. If a flag is needed (e.g.
`GameInit.ClientIsSupportIOLoad=true`), record it for Claude's harness.

### T2 — Sample-battle asset manifest
For the embedded sample battle heroes/enemies (heroDid 1036, 1002, 1034, 1100111..1100133),
map each to: actor assetbundle, Spine skeleton/atlas/textures, and skill/timeline assets
already extracted locally. Use `reports/characters/GIRLSWAR_CHARACTER_CATALOG.json`,
`girlswar_merged_extracted/indexes/{assetbundles,unity_objects,unity_images}.csv`. Output
`girlswar_battle_unity/Assets/RestoreData/battle/BATTLE_SAMPLE_ASSET_MANIFEST.json`
(heroDid -> bundle paths + skeletonDataAsset + atlas + textures), and note any missing
(e.g. 1036 actor bundle was flagged missing in older char reports — confirm).

### T3 — View stubs (compile-OK no-ops first)
Create `LuaUnit.cs`, `LuaHeroSprite.cs`, `ScrollScene.cs`, `TimelineEffect.cs` under
`YouYouStubs/`, namespace `YouYou`, with the members the battle Lua calls (grep the decoded
Lua for `LuaHeroSprite.`, `ScrollScene.`, `TimelineEffect.`, `:` method calls). No-op bodies
that return sane defaults so the project compiles and headless battle runs. Verify with:
`Unity.exe -quit -batchmode -nographics -projectPath girlswar_battle_unity -logFile <log>`
and confirm `error CS` count is 0.

### T4 — M3 visual replay (after Claude's headless M2 passes)
Drive Spine `SkeletonAnimation` playback + skill `TimelineEffect` from `actionData`
(actionType 1/2/3 semantics: decode from `BattleManager`/state-machine Lua in
`decoded/xlua_battle/download_xlualogic_modules_battle/`). Hook HP/round HUD. Goal: one full
sample battle is watchable and matches the data. Wire `LuaHeroSprite`/`ScrollScene`/
`TimelineEffect` to real Spine actors + DOTween (add DOTween package; it's free).

## Guardrails (hard)

- Replay the REAL battle data; never fabricate a result or fake an animation outcome.
- A view call may be no-op ONLY if it can't affect battle logic. M3 must show real assets.
- Don't delete originals/decoded Lua/evidence. Headless batch verify first.
- Commit + push each working step to `main` with a clear message. Keep root CMD count = 1.

## Verify / report

Each task writes a `reports/battle/BATTLE_*_RESULT.(md|json)` with a real pass/fail.
Coordinate via commit messages; if you touch a shared contract, note it in
`reports/OFFLINE_BATTLE_RUNTIME_PLAN.md`.
