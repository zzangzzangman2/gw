# BATTLE_89_CODEX_VIEW_STUBS_RESULT

Generated: 2026-06-26T16:30:10.059Z

## Result

- pass: `true`
- compile error CS count: `0`
- batchmode exited successfully: `true`
- compile log: `reports/battle/BATTLE_89_CODEX_VIEW_STUB_COMPILE.log`

## Stubs

- `girlswar_battle_unity/Assets/Scripts/LuaUnit.cs`
- `girlswar_battle_unity/Assets/Scripts/GirlsWar/YouYouStubs/LuaUnit.cs`
- `girlswar_battle_unity/Assets/Scripts/GirlsWar/YouYouStubs/LuaHeroSprite.cs`
- `girlswar_battle_unity/Assets/Scripts/GirlsWar/YouYouStubs/ScrollScene.cs`
- `girlswar_battle_unity/Assets/Scripts/GirlsWar/YouYouStubs/TimelineEffect.cs`

## Notes

- YouYou.LuaUnit already existed at Assets/Scripts/LuaUnit.cs, so YouYouStubs/LuaUnit.cs is a marker to avoid duplicate class definitions.
- TimelineEffect includes PlayTimeLine, Pause, Resume, Stop, GoToPoint, AttackPointCount, CurrPlayableDirector, IsAutoPlay, and OnStopped for battle Lua calls.
- ScrollScene includes SetPreloadCount and Move for BattleBgEffectMgr calls.
