# GirlsWar Character Roster

Generated from original datatable/Lua/AssetBundle evidence only. No fake character, card, or skill data is introduced.

## Scope
- Payload: `reports/battle/BATTLE_TEST_PAYLOAD.json`
- Current manifest compared: `reports/battle/BATTLE_PROTOTYPE_MANIFEST.json`
- Actor rule: `heroDid -> DTHero/DTMonster_*Entity.modelID -> DTmodel.prefabId -> roleprefabsandres/battleprefabandres/<prefabId>.assetbundle`
- Skill rule: `skillDid -> DTSkillAct.prefabId -> LuaUtils.GetSysprefabData(prefabId).AssetPath -> BattleTimelineResMap[AssetPath]`

## Actor Summary
- Actors in payload: `12`
- Loadable Spine actor bundles: `3` / `12`

| side | wave | heroDid | table | modelId | prefabId | bundleExists | loadStatus |
| --- | --- | ---: | --- | ---: | ---: | --- | --- |
| our |  | 1036 | DTHeroEntity | 1036 | 1036 | False | bundle_not_in_extracted_assetbundle_index |
| our |  | 1002 | DTHeroEntity | 1002 | 1002 | True | loadable_spine_bundle |
| our |  | 1034 | DTHeroEntity | 1034 | 1034 | True | loadable_spine_bundle |
| enemy | 1 | 1100111 | DTMonster_KEntity | 3001 | 3001 | True | loadable_spine_bundle |
| enemy | 1 | 1100112 |  |  |  | False | missing_model_or_prefab |
| enemy | 1 | 1100113 |  |  |  | False | missing_model_or_prefab |
| enemy | 2 | 1100121 |  |  |  | False | missing_model_or_prefab |
| enemy | 2 | 1100122 |  |  |  | False | missing_model_or_prefab |
| enemy | 2 | 1100123 |  |  |  | False | missing_model_or_prefab |
| enemy | 3 | 1100131 |  |  |  | False | missing_model_or_prefab |
| enemy | 3 | 1100132 |  |  |  | False | missing_model_or_prefab |
| enemy | 3 | 1100133 |  |  |  | False | missing_model_or_prefab |

## Skill Summary
- Skill rows including fast prefab variants: `61`
- Timeline-resolved rows: `39` / `61`
- Unique gap skillDids: `1001401, 1001403, 1012401, 1012403, 1034401, 1034402, 1036401, 1036402`

| skillDid | owner | prefabField | prefabId | timeline | bundleExists | status |
| ---: | ---: | --- | ---: | --- | --- | --- |
| 1036101 | 1036 | prefabId | 1036101 | SkillPrefabsAndRes/1036/1036101.prefab | True | timeline_resolved |
| 1036201 | 1036 | prefabId | 1036201 | SkillPrefabsAndRes/1036/1036201.prefab | True | timeline_resolved |
| 1036301 | 1036 | prefabId | 1036301 | SkillPrefabsAndRes/1036/1036301.prefab | True | timeline_resolved |
| 1036301 | 1036 | fastPrefabId | 1036351 | SkillPrefabsAndRes/1036/1036351.prefab | True | timeline_resolved |
| 1036401 | 1036 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1036402 | 1036 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1002101 | 1002 | prefabId | 1002101 | SkillPrefabsAndRes/1002/1002101.prefab | True | timeline_resolved |
| 1002201 | 1002 | prefabId | 1002201 | SkillPrefabsAndRes/1002/1002201.prefab | True | timeline_resolved |
| 1002301 | 1002 | prefabId | 1002301 | SkillPrefabsAndRes/1002/1002301.prefab | True | timeline_resolved |
| 1002301 | 1002 | fastPrefabId | 1002351 | SkillPrefabsAndRes/1002/1002351.prefab | True | timeline_resolved |
| 1034101 | 1034 | prefabId | 1034101 | SkillPrefabsAndRes/1034/1034101.prefab | True | timeline_resolved |
| 1034201 | 1034 | prefabId | 1034201 | SkillPrefabsAndRes/1034/1034201.prefab | True | timeline_resolved |
| 1034301 | 1034 | prefabId | 1034301 | SkillPrefabsAndRes/1034/1034301.prefab | True | timeline_resolved |
| 1034301 | 1034 | fastPrefabId | 1034351 | SkillPrefabsAndRes/1034/1034351.prefab | True | timeline_resolved |
| 1034401 | 1034 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1034402 | 1034 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1012101 | 1100111 | prefabId | 1012101 | SkillPrefabsAndRes/1012/1012101.prefab | True | timeline_resolved |
| 1012201 | 1100111 | prefabId | 1012201 | SkillPrefabsAndRes/1012/1012201.prefab | True | timeline_resolved |
| 1012301 | 1100111 | prefabId | 1012301 | SkillPrefabsAndRes/1012/1012301.prefab | True | timeline_resolved |
| 1012301 | 1100111 | fastPrefabId | 1012351 | SkillPrefabsAndRes/1012/1012351.prefab | True | timeline_resolved |
| 1012401 | 1100111 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1012403 | 1100111 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1012101 | 1100112 | prefabId | 1012101 | SkillPrefabsAndRes/1012/1012101.prefab | True | timeline_resolved |
| 1012201 | 1100112 | prefabId | 1012201 | SkillPrefabsAndRes/1012/1012201.prefab | True | timeline_resolved |
| 1012301 | 1100112 | prefabId | 1012301 | SkillPrefabsAndRes/1012/1012301.prefab | True | timeline_resolved |
| 1012301 | 1100112 | fastPrefabId | 1012351 | SkillPrefabsAndRes/1012/1012351.prefab | True | timeline_resolved |
| 1012401 | 1100112 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1012403 | 1100112 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1012101 | 1100113 | prefabId | 1012101 | SkillPrefabsAndRes/1012/1012101.prefab | True | timeline_resolved |
| 1012201 | 1100113 | prefabId | 1012201 | SkillPrefabsAndRes/1012/1012201.prefab | True | timeline_resolved |
| 1012301 | 1100113 | prefabId | 1012301 | SkillPrefabsAndRes/1012/1012301.prefab | True | timeline_resolved |
| 1012301 | 1100113 | fastPrefabId | 1012351 | SkillPrefabsAndRes/1012/1012351.prefab | True | timeline_resolved |
| 1012401 | 1100113 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1012403 | 1100113 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1012101 | 1100121 | prefabId | 1012101 | SkillPrefabsAndRes/1012/1012101.prefab | True | timeline_resolved |
| 1012201 | 1100121 | prefabId | 1012201 | SkillPrefabsAndRes/1012/1012201.prefab | True | timeline_resolved |
| 1012301 | 1100121 | prefabId | 1012301 | SkillPrefabsAndRes/1012/1012301.prefab | True | timeline_resolved |
| 1012301 | 1100121 | fastPrefabId | 1012351 | SkillPrefabsAndRes/1012/1012351.prefab | True | timeline_resolved |
| 1012401 | 1100121 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1012403 | 1100121 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1012101 | 1100122 | prefabId | 1012101 | SkillPrefabsAndRes/1012/1012101.prefab | True | timeline_resolved |
| 1012201 | 1100122 | prefabId | 1012201 | SkillPrefabsAndRes/1012/1012201.prefab | True | timeline_resolved |
| 1012301 | 1100122 | prefabId | 1012301 | SkillPrefabsAndRes/1012/1012301.prefab | True | timeline_resolved |
| 1012301 | 1100122 | fastPrefabId | 1012351 | SkillPrefabsAndRes/1012/1012351.prefab | True | timeline_resolved |
| 1012401 | 1100122 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1012403 | 1100122 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1012101 | 1100123 | prefabId | 1012101 | SkillPrefabsAndRes/1012/1012101.prefab | True | timeline_resolved |
| 1012201 | 1100123 | prefabId | 1012201 | SkillPrefabsAndRes/1012/1012201.prefab | True | timeline_resolved |
| 1012301 | 1100123 | prefabId | 1012301 | SkillPrefabsAndRes/1012/1012301.prefab | True | timeline_resolved |
| 1012301 | 1100123 | fastPrefabId | 1012351 | SkillPrefabsAndRes/1012/1012351.prefab | True | timeline_resolved |
| 1012401 | 1100123 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1012403 | 1100123 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1012101 | 1100131 | prefabId | 1012101 | SkillPrefabsAndRes/1012/1012101.prefab | True | timeline_resolved |
| 1001401 | 1100131 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1001403 | 1100131 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1012101 | 1100132 | prefabId | 1012101 | SkillPrefabsAndRes/1012/1012101.prefab | True | timeline_resolved |
| 1001401 | 1100132 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1001403 | 1100132 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1012101 | 1100133 | prefabId | 1012101 | SkillPrefabsAndRes/1012/1012101.prefab | True | timeline_resolved |
| 1001401 | 1100133 |  |  |  | False | missing_DTSkillAct_prefab_mapping |
| 1001403 | 1100133 |  |  |  | False | missing_DTSkillAct_prefab_mapping |

## Evidence Files
- `HeroCtrl`: `girlswar_merged_extracted/decoded/xlua_battle/download_xlualogic_modules_battle/-2133702496468653963_HeroCtrl_security_xor_raw.lua`
- `BattleResPreloadMgr`: `girlswar_merged_extracted/decoded/xlua_battle/download_xlualogic_modules_battle/4144069477662196776_BattleResPreloadMgr_security_xor_raw.lua`
- `BattleTimelineResMap`: `girlswar_merged_extracted/decoded/xlua_battle/download_xlualogic_modules_battle/7799402437590767611_BattleTimelineResMap_security_xor_raw.lua`
- `DTSysPrefab` direct decode report: `reports/characters/DTSYSPREFAB_DIRECT_DECODE_REPORT.json`

## Outputs
- JSON: `reports/characters/GIRLSWAR_CHARACTER_ROSTER.json`
- Actor CSV: `reports/characters/GIRLSWAR_CHARACTER_ROSTER_ACTORS.csv`
- Skill CSV: `reports/characters/GIRLSWAR_CHARACTER_ROSTER_SKILLS.csv`
- Gap JSON: `reports/characters/GIRLSWAR_CHARACTER_GAP_REPORT.json`
- Gap report: `reports/characters/GIRLSWAR_CHARACTER_GAP_REPORT.md`
- DTSysPrefab report: `reports/characters/DTSYSPREFAB_DIRECT_DECODE_REPORT.md`
