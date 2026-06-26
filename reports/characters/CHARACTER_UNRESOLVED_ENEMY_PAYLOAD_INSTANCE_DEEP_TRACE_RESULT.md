# CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_RESULT

- Scope: unresolved enemy payload instance ids only; no fake mapping.
- Target ids: `1100112, 1100113, 1100121, 1100122, 1100123, 1100131, 1100132, 1100133`
- Control id: `1100111`
- Target status counts: `{'not_resolved_from_local_evidence': 8}`
- Source-backed update proposals: `0`
- Proposal files written: `False`
- Command policy: root `.cmd` `1`, `_restore_tools` direct `.cmd` `0` -> `ok`

## Final Status By Payload Id
| wave | pos | payloadHeroDid | previousLocalStatus | finalStatus | directTables | modelId | prefabId | bundle | note |
| ---: | ---: | ---: | --- | --- | --- | --- | --- | --- | --- |
| 1 | 2 | 1100112 | `unresolved_enemy_payload_instance` | `not_resolved_from_local_evidence` | `` | `` | `` | `` | No direct DTMonster*/DTmodel actor chain was found for this payload id. |
| 1 | 3 | 1100113 | `unresolved_enemy_payload_instance` | `not_resolved_from_local_evidence` | `` | `` | `` | `` | No direct DTMonster*/DTmodel actor chain was found for this payload id. |
| 2 | 1 | 1100121 | `unresolved_enemy_payload_instance` | `not_resolved_from_local_evidence` | `` | `` | `` | `` | No direct DTMonster*/DTmodel actor chain was found for this payload id. |
| 2 | 2 | 1100122 | `unresolved_enemy_payload_instance` | `not_resolved_from_local_evidence` | `` | `` | `` | `` | No direct DTMonster*/DTmodel actor chain was found for this payload id. |
| 2 | 3 | 1100123 | `unresolved_enemy_payload_instance` | `not_resolved_from_local_evidence` | `` | `` | `` | `` | No direct DTMonster*/DTmodel actor chain was found for this payload id. |
| 3 | 1 | 1100131 | `unresolved_enemy_payload_instance` | `not_resolved_from_local_evidence` | `` | `` | `` | `` | No direct DTMonster*/DTmodel actor chain was found for this payload id. |
| 3 | 2 | 1100132 | `unresolved_enemy_payload_instance` | `not_resolved_from_local_evidence` | `` | `` | `` | `` | No direct DTMonster*/DTmodel actor chain was found for this payload id. |
| 3 | 3 | 1100133 | `unresolved_enemy_payload_instance` | `not_resolved_from_local_evidence` | `` | `` | `` | `` | No direct DTMonster*/DTmodel actor chain was found for this payload id. |

## Skill / Timeline Impact
| payloadHeroDid | skillImpact | affectedSkillStatusCounts |
| ---: | --- | --- |
| 1100112 | `no_change_existing_actor_unresolved` | `{'data_only_missing_actor': 4, 'passive_no_timeline': 2}` |
| 1100113 | `no_change_existing_actor_unresolved` | `{'data_only_missing_actor': 4, 'passive_no_timeline': 2}` |
| 1100121 | `no_change_existing_actor_unresolved` | `{'data_only_missing_actor': 4, 'passive_no_timeline': 2}` |
| 1100122 | `no_change_existing_actor_unresolved` | `{'data_only_missing_actor': 4, 'passive_no_timeline': 2}` |
| 1100123 | `no_change_existing_actor_unresolved` | `{'data_only_missing_actor': 4, 'passive_no_timeline': 2}` |
| 1100131 | `no_change_existing_actor_unresolved` | `{'data_only_missing_actor': 1, 'passive_no_timeline': 2}` |
| 1100132 | `no_change_existing_actor_unresolved` | `{'data_only_missing_actor': 1, 'passive_no_timeline': 2}` |
| 1100133 | `no_change_existing_actor_unresolved` | `{'data_only_missing_actor': 1, 'passive_no_timeline': 2}` |

## Control Path: 1100111
| table | modelId | prefabId | bundle | exists |
| --- | ---: | ---: | --- | --- |
| DTMonster_KEntity | 3001 | 3001 | `download/roleprefabsandres/battleprefabandres/3001.assetbundle` | `True` |
| DTMonster_OEntity | 3001 | 3001 | `download/roleprefabsandres/battleprefabandres/3001.assetbundle` | `True` |

## Stage/Wave Context
- DTMapsWave rows for mapId `11001`: `5`
- These rows are context only unless code/data explicitly aliases payload instance ids to their monsterLists.

| table | rowId | wave | monsterLists | newMonsterLists | name |
| --- | ---: | ---: | --- | --- | --- |
| DTMapsWaveEntity | 1 | 1 | `[0, 1100110, 0, 0, 0, 0]` | `[0, 1100110, 0, 0, 0, 0]` | heroname_1003 |
| DTMapsWave_FEntity | 1 | 1 | `[0, 1100110, 0, 0, 0, 0]` | `[0, 1100110, 0, 0, 0, 0]` | heroname_1003 |
| DTMapsWave_GEntity | 1 | 1 | `[0, 1100110, 0, 0, 0, 0]` | `[0, 1100110, 0, 0, 0, 0]` | heroname_1003 |
| DTMapsWave_HEntity | 1 | 1 | `[0, 1100110, 0, 0, 0, 0]` | `[0, 1100110, 0, 0, 0, 0]` | heroname_1003 |
| DTMapsWave_KEntity | 1 | 1 | `[0, 1100510, 0, 1100512, 1100513, 1100511]` | `[0, 1100510, 0, 1100512, 1100513, 1100511]` | heroname_1019 |

## Search Coverage
- Monster tables: `DTMonsterEntity, DTMonster_FEntity, DTMonster_GEntity, DTMonster_HEntity, DTMonster_KEntity, DTMonster_OEntity`
- Stage/battle tables: `DTMapsWaveEntity, DTMapsWave_FEntity, DTMapsWave_GEntity, DTMapsWave_HEntity, DTMapsWave_KEntity, DTBattleAttrEntity, DTBattleEntity, DTBattlePreviewDetailEntity, DTBattlePreviewEntity, DTBattleTestPetAttrEntity, DTBattleTestPetEntity, DTBattleTestTreasureEntity, DTBattleZoneEntity`
- Decoded Lua roots: `girlswar_merged_extracted/decoded/xlua_battle, girlswar_merged_extracted/decoded/xlua_guildmain_runtime_trace`
- IL2CPP/global-metadata/libil2cpp and AssetInfo/AssetGuid restore indexes were scanned for string/raw-int refs; hits are weak evidence only and not mapping evidence.

## Next Blockers
- No unresolved enemy payload instance can be promoted without a source-backed DTMonster/DTmodel/prefab/bundle chain or an authoritative code/data alias.
- The formula-like ids mapId+wave+slot are payload instance ids unless local code/data proves otherwise.
- 1036 actor remains not_fetchable_local; this trace does not change 1036.

## Outputs
- JSON: `reports/characters/CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_RESULT.json`
- CSV: `reports/characters/CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_RESULT.csv`
- Proposal JSON/CSV: not written unless source-backed actor status changes exist.
