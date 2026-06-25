# Battle Runtime Flow Link Result

## Outputs
- Flow manifest: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_RUNTIME_FLOW_MANIFEST.json`
- Flow scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\BattleRuntimeFlowPrototype.unity`
- Unity batchmode success: `True`

## Flow Counts
- mapId: `11001`
- battleType: `1`
- randomSeed: `445106`
- Actor slots: `12`
- Loadable runtime prefabs: `3`
- Missing placeholders: `9`
- Procedure evidence count: `11`
- Known skill ids: `20`

## Procedure Evidence
| label | line | file | snippet |
| --- | ---: | --- | --- |
| BeginFightPlayWithServer | 425 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua | `function t.BeginFightPlayWithServer(t)` |
| LoadPlayerHeros call | 434 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua | `e.LoadPlayerHeros(e.FightPlayData.ourTeamFormation,e.FightPlayData.ourTeamFormationAlter,e.FightPlayData.ourHeros,e.FightPlayData.ourPets)` |
| LoadEnemyPlayerHeros call | 435 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua | `e.LoadEnemyPlayerHeros(e.FightPlay_CurrWave.enemyTeamFormation,e.FightPlay_CurrWave.enemyTeamFormationAlter,e.FightPlay_CurrWave.enemyHeros,e.FightPlay_CurrWave.enemyPets)` |
| BeginBattleWithServer | 437 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua | `function t.BeginBattleWithServer(t)` |
| ResortTeamFormation call | 450 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua | `e.ResortTeamFormation(t)` |
| MapId assignment | 452 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua | `e.MapId=t.mapId` |
| Random seed assignment | 461 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua | `RandomMgr.seed=t.randomSeed` |
| ResortTeamFormation function | 505 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua | `function t.ResortTeamFormation(e)` |
| BeginBattleWithServer_FightPlay | 588 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua | `function t.BeginBattleWithServer_FightPlay()` |
| FightPlay begin dispatch | 676 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua | `ModulesInit.ProcedureNormalBattle.BeginBattleWithServer(table.deepCopy(o))` |
| FightPlay load dispatch | 696 | C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua_battle\download_xlualogic_modules_procedure\-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua | `ModulesInit.ProcedureNormalBattle.BeginFightPlayWithServer(table.deepCopy(a))` |

## Actor Slots
| side | wave | slot | heroDid | heroId | modelId | prefab | status | reason |
| --- | ---: | ---: | --- | ---: | --- | --- | --- | --- |
| our | 0 | 1 | 1036 | 51469 | 1036 | 1036 | placeholder | listed_in_cdn_versionfile_not_extracted |
| our | 0 | 2 | 1002 | 50870 | 1002 | 1002 | runtime_prefab |  |
| our | 0 | 3 | 1034 | 50874 | 1034 | 1034 | runtime_prefab |  |
| enemy | 1 | 1 | 1100111 | -1 | 3001 | 3001 | runtime_prefab |  |
| enemy | 1 | 2 | 1100112 | -2 | 1100112 |  | placeholder | not_loadable_yet |
| enemy | 1 | 3 | 1100113 | -3 | 1100113 |  | placeholder | not_loadable_yet |
| enemy | 2 | 1 | 1100121 | -1 | 1100121 |  | placeholder | not_loadable_yet |
| enemy | 2 | 2 | 1100122 | -2 | 1100122 |  | placeholder | not_loadable_yet |
| enemy | 2 | 3 | 1100123 | -3 | 1100123 |  | placeholder | not_loadable_yet |
| enemy | 3 | 1 | 1100131 | -1 | 1100131 |  | placeholder | not_loadable_yet |
| enemy | 3 | 2 | 1100132 | -2 | 1100132 |  | placeholder | not_loadable_yet |
| enemy | 3 | 3 | 1100133 | -3 | 1100133 |  | placeholder | not_loadable_yet |

## Next BATTLE_13
- Recommend `skills/effects bundle streaming`: skill ids are already present in the flow manifest and effect/timeline bundle indexing is closer to battle implementation than HUD integration.
