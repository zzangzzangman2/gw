# Character Resource Gap Deep Trace

Generated from local datatable/Lua/AssetBundle/versionfile evidence only. No fake mappings were introduced.

## 1036 Actor Bundle
- Classification: `present_in_versionfile_but_not_extracted`
- Desired bundle: `download/roleprefabsandres/battleprefabandres/1036.assetbundle`
- Versionfile exact rows: `1`
- Extracted assetbundle index exact rows: `0`
- Exact local files: `0`

Conclusion: CDNVersionFile lists the exact battle actor bundle, but no exact merged_content file, clean_unityfs_slice, or assetbundles.csv row exists in this local extraction.

## Enemy Payload Alias
- Classification: `still_unresolved`
- Payload enemy rows: `9`
- DTMapsWave rows for mapId `11001`: `5`
- Stage candidate monster ids: `1100110, 1100510, 1100511, 1100512, 1100513`

Conclusion: Payload enemy ids after 1100111 look like mapId+wave+slot instance ids, but normal campaign generation and HeroCtrl lookup use monsterLists/heroDid directly. No authoritative alias from these payload ids to DTMapsWave monster ids was found.

| wave | pos | payloadHeroDid | formulaLike | directTables | status |
| ---: | ---: | ---: | --- | --- | --- |
| 1 | 1 | 1100111 | True | DTMonster_KEntity, DTMonster_OEntity | direct_monster_row_resolved |
| 1 | 2 | 1100112 | True |  | still_unresolved_payload_instance_id |
| 1 | 3 | 1100113 | True |  | still_unresolved_payload_instance_id |
| 2 | 1 | 1100121 | True |  | still_unresolved_payload_instance_id |
| 2 | 2 | 1100122 | True |  | still_unresolved_payload_instance_id |
| 2 | 3 | 1100123 | True |  | still_unresolved_payload_instance_id |
| 3 | 1 | 1100131 | True |  | still_unresolved_payload_instance_id |
| 3 | 2 | 1100132 | True |  | still_unresolved_payload_instance_id |
| 3 | 3 | 1100133 | True |  | still_unresolved_payload_instance_id |

## Stage Wave Rows
| table | rowId | wave | monsterLists | newMonsterLists | name |
| --- | ---: | ---: | --- | --- | --- |
| DTMapsWaveEntity | 1 | 1 | [0, 1100110, 0, 0, 0, 0] | [0, 1100110, 0, 0, 0, 0] | heroname_1003 |
| DTMapsWave_FEntity | 1 | 1 | [0, 1100110, 0, 0, 0, 0] | [0, 1100110, 0, 0, 0, 0] | heroname_1003 |
| DTMapsWave_GEntity | 1 | 1 | [0, 1100110, 0, 0, 0, 0] | [0, 1100110, 0, 0, 0, 0] | heroname_1003 |
| DTMapsWave_HEntity | 1 | 1 | [0, 1100110, 0, 0, 0, 0] | [0, 1100110, 0, 0, 0, 0] | heroname_1003 |
| DTMapsWave_KEntity | 1 | 1 | [0, 1100510, 0, 1100512, 1100513, 1100511] | [0, 1100510, 0, 1100512, 1100513, 1100511] | heroname_1019 |

## Evidence
- Embedded FightPlay payload/decode: `girlswar_merged_extracted/decoded/xlua_battle/download_xlualogic_modules_procedure/-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua`
- Normal campaign maps wave flow: `girlswar_merged_extracted/decoded/xlua_battle/download_xlualogic_modules_battle/7184371722040177329_CampainBBData_security_xor_raw.lua`
- Monster-list formation builder: `girlswar_merged_extracted/decoded/xlua_battle/download_xlualogic_modules_battle/2075196316440867225_BattleBeforeDataUtil_security_xor_raw.lua`
- HeroCtrl monster lookup: `girlswar_merged_extracted/decoded/xlua_battle/download_xlualogic_modules_battle/-2133702496468653963_HeroCtrl_security_xor_raw.lua`

## Outputs
- JSON: `reports/characters/CHARACTER_RESOURCE_GAP_DEEP_TRACE.json`
- 1036 resource CSV: `reports/characters/CHARACTER_RESOURCE_GAP_DEEP_TRACE_1036_RESOURCE.csv`
- enemy alias CSV: `reports/characters/CHARACTER_RESOURCE_GAP_DEEP_TRACE_ENEMY_ALIAS.csv`
