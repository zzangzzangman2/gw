# Battle AssetBundle / Spine Loading Plan

## Outputs
- Load map: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_ASSETBUNDLE_LOAD_MAP.json`
- Actor candidates: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_08_ACTOR_LOAD_CANDIDATES.csv`
- Enemy datatable candidates: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_08_ENEMY_DATATABLE_CANDIDATES.csv`
- Map candidates: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_08_MAP_CANDIDATES.csv`
- Skill candidates: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_08_SKILL_BUNDLE_CANDIDATES.csv`
- Missing classification: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_08_MISSING_CLASSIFICATION.csv`

## Summary
- Actor loadable: `3` / `12`
- Our actor loadable: `2` / `3`
- Enemy ids resolved through K/O monster tables: `1` / `9`
- Enemy candidate bundles existing: `1` / `9`
- Map candidate rows: `10`
- Skill candidates: `24`; skill rows found/missing: `42` / `22`
- Remaining missing classification: `{'listed_in_cdn_versionfile_not_extracted': 1, 'path_normalize_issue': 3}`

## Actor Load Candidates
| side | heroDid | model | prefab | exists | loadStatus | skeletonData | atlas | texture |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| our | 1036 | 1036 | 1036 | False | listed_in_cdn_versionfile_not_extracted |  |  |  |
| our | 1002 | 1002 | 1002 | True | loadable_spine_bundle | extracted/unity/bundles/b_a11e4439fd9a0a50/textassets/1665224429881118700_1002.skel.txt | extracted/unity/bundles/b_a11e4439fd9a0a50/textassets/3373340142783789617_1002.atlas.txt | extracted/unity/bundles/b_a11e4439fd9a0a50/images/T/2058673591951818171_1002.png |
| our | 1034 | 1034 | 1034 | True | loadable_spine_bundle | extracted/unity/bundles/b_da97dc9c8e06fcb3/textassets/-3260164475778644329_1034.skel.txt | extracted/unity/bundles/b_da97dc9c8e06fcb3/textassets/9008888806324543472_1034.atlas.txt | extracted/unity/bundles/b_da97dc9c8e06fcb3/images/T/-8601115882506527001_1034.png |
| enemy | 1100111 | 3001 | 3001 | True | loadable_spine_bundle | extracted/unity/bundles/b_5a764c3b78a2386a/textassets/-756768513637643680_3001.skel.txt | extracted/unity/bundles/b_5a764c3b78a2386a/textassets/-3102365806415234313_3001.atlas.txt | extracted/unity/bundles/b_5a764c3b78a2386a/images/T/-9168546056666942066_3001.png |
| enemy | 1100112 |  |  | False | not_loadable_yet |  |  |  |
| enemy | 1100113 |  |  | False | not_loadable_yet |  |  |  |
| enemy | 1100121 |  |  | False | not_loadable_yet |  |  |  |
| enemy | 1100122 |  |  | False | not_loadable_yet |  |  |  |
| enemy | 1100123 |  |  | False | not_loadable_yet |  |  |  |
| enemy | 1100131 |  |  | False | not_loadable_yet |  |  |  |
| enemy | 1100132 |  |  | False | not_loadable_yet |  |  |  |
| enemy | 1100133 |  |  | False | not_loadable_yet |  |  |  |

## Enemy Datatable Reinforcement
| heroDid | candidateTable | candidateModelId | candidatePrefabId | candidateBundle | candidateBundleExists | candidateStatus |
| --- | --- | --- | --- | --- | --- | --- |
| 1100111 | DTMonster_K | 3001 | 3001 | download/roleprefabsandres/battleprefabandres/3001.assetbundle | True | resolved_via_monster_variant_table |
| 1100112 |  |  |  |  | False | payload_derived_monster_id_not_found_in_extracted_DTMonster_KO |
| 1100113 |  |  |  |  | False | payload_derived_monster_id_not_found_in_extracted_DTMonster_KO |
| 1100121 |  |  |  |  | False | payload_derived_monster_id_not_found_in_extracted_DTMonster_KO |
| 1100122 |  |  |  |  | False | payload_derived_monster_id_not_found_in_extracted_DTMonster_KO |
| 1100123 |  |  |  |  | False | payload_derived_monster_id_not_found_in_extracted_DTMonster_KO |
| 1100131 |  |  |  |  | False | payload_derived_monster_id_not_found_in_extracted_DTMonster_KO |
| 1100132 |  |  |  |  | False | payload_derived_monster_id_not_found_in_extracted_DTMonster_KO |
| 1100133 |  |  |  |  | False | payload_derived_monster_id_not_found_in_extracted_DTMonster_KO |

## Map 11001 Candidates
| mapId | assetType | name | width | height | output |
| --- | --- | --- | --- | --- | --- |
| 11001 | Sprite | Map_11001_3 | 1920 | 304 | extracted/unity/bundles/b_0155ef2a953f53b0/images/S/-8432961922530428540_Map_11001_3.png |
| 11001 | Sprite | Map_11001_1_4 | 259 | 150 | extracted/unity/bundles/b_0155ef2a953f53b0/images/S/-7882005510638080185_Map_11001_1_4.png |
| 11001 | Sprite | Map_11001_1_1 | 468 | 95 | extracted/unity/bundles/b_0155ef2a953f53b0/images/S/-7352335555518323793_Map_11001_1_1.png |
| 11001 | Sprite | Map_11001_5_1 | 495 | 439 | extracted/unity/bundles/b_0155ef2a953f53b0/images/S/-4891563928384609105_Map_11001_5_1.png |
| 11001 | Texture2D | sactx-0-2048x2048-ETC2-Map_11001_1-2ccb5b85 | 2048 | 2048 | extracted/unity/bundles/b_0155ef2a953f53b0/images/T/-3924175387751401445_sactx-0-2048x2048-ETC2-Map_11001_1-2ccb5b85.png |
| 11001 | Sprite | Map_11001_4 | 702 | 350 | extracted/unity/bundles/b_0155ef2a953f53b0/images/S/-3259072823952439402_Map_11001_4.png |
| 11001 | Sprite | Map_11001_2 | 1920 | 669 | extracted/unity/bundles/b_0155ef2a953f53b0/images/S/-2857215938594995045_Map_11001_2.png |
| 11001 | Sprite | Map_11001_5_2 | 121 | 240 | extracted/unity/bundles/b_0155ef2a953f53b0/images/S/5490800349379579821_Map_11001_5_2.png |
| 11001 | Sprite | Map_11001_1_2 | 351 | 135 | extracted/unity/bundles/b_0155ef2a953f53b0/images/S/6425347890655533317_Map_11001_1_2.png |
| 11001 | Sprite | Map_11001_1_3 | 486 | 152 | extracted/unity/bundles/b_0155ef2a953f53b0/images/S/6810977601385818246_Map_11001_1_3.png |

## Skill Candidate Snapshot
| skillDid | skillFound | prefabId | timelineFound | normalizedBundle | bundleExists | normalizeNote |
| --- | --- | --- | --- | --- | --- | --- |
| 1036101 | True | 1036101 | True | download/skillprefabsandres/1036.assetbundle | True | as_listed |
| 1036201 | True | 1036201 | True | download/skillprefabsandres/1036.assetbundle | True | as_listed |
| 1036301 | True | 1036301 | True | download/skillprefabsandres/1036.assetbundle | True | as_listed |
| 1036301 | True | 1036351 | True | download/skillprefabsandres/1036.assetbundle | True | as_listed |
| 1036401 | False |  | False |  | False | not_found |
| 1036402 | False |  | False |  | False | not_found |
| 1002101 | True | 1002101 | True | download/skillprefabsandres/1002.assetbundle | True | as_listed |
| 1002201 | True | 1002201 | True | download/skillprefabsandres/1002.assetbundle | True | as_listed |
| 1002301 | True | 1002301 | True | download/skillprefabsandres/1002.assetbundle | True | as_listed |
| 1002301 | True | 1002351 | True | download/skillprefabsandres/1002.assetbundle | True | as_listed |
| 1034101 | True | 1034101 | True | download/skillprefabsandres/1034.assetbundle | True | as_listed |
| 1034201 | True | 1034201 | True | download/skillprefabsandres/1034.assetbundle | True | as_listed |
| 1034301 | True | 1034301 | True | download/skillprefabsandres/1034.assetbundle | True | as_listed |
| 1034301 | True | 1034351 | True | download/skillprefabsandres/1034.assetbundle | True | as_listed |
| 1034401 | False |  | False |  | False | not_found |
| 1034402 | False |  | False |  | False | not_found |
| 1012101 | True | 1012101 | True | download/skillprefabsandres/1012.assetbundle | True | as_listed |
| 1012201 | True | 1012201 | True | download/skillprefabsandres/1012.assetbundle | True | as_listed |
| 1012301 | True | 1012301 | True | download/skillprefabsandres/1012.assetbundle | True | as_listed |
| 1012301 | True | 1012351 | True | download/skillprefabsandres/1012.assetbundle | True | as_listed |
| 1012401 | False |  | False |  | False | not_found |
| 1012403 | False |  | False |  | False | not_found |
| 1001401 | False |  | False |  | False | not_found |
| 1001403 | False |  | False |  | False | not_found |

## Missing Bundle Classification
| kind | bundle | normalizedBundle | existsAfterNormalize | classification |
| --- | --- | --- | --- | --- |
| actor_spine | download/roleprefabsandres/battleprefabandres/1036.assetbundle | download/roleprefabsandres/battleprefabandres/1036.assetbundle | False | listed_in_cdn_versionfile_not_extracted |
| timeline_prefab_dep | download/commonprefabsandres/skilleffect/commonskillprefabsandres1/pinkspeedline.assetbundle | download/commonprefabsandres/skilleffect/commonskillprefabsandres1.assetbundle | True | path_normalize_issue |
| timeline_prefab_dep | download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle | download/commonprefabsandres/skilleffect/commonskillprefabsandres1.assetbundle | True | path_normalize_issue |
| timeline_prefab_dep | download/commonprefabsandres/skilleffect/commonskillprefabsandres1/yellospeedline.assetbundle | download/commonprefabsandres/skilleffect/commonskillprefabsandres1.assetbundle | True | path_normalize_issue |
