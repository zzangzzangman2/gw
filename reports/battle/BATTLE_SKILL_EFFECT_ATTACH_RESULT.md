# Battle Skill Effect Attach Result

## Outputs
- Attach manifest: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_FLOW_SKILL_EFFECT_ATTACH_MANIFEST.json`
- Unity result: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_FLOW_SKILL_EFFECT_ATTACH_RESULT.json`
- Scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\BattleRuntimeFlowSkillEffectAttach.unity`
- Unity batchmode success: `True`

## Counts
- Known skill ids: `20`
- Loadable attachments: `12`
- Unresolved skills: `8`
- Unique skill/effect bundles: `4`
- Loaded bundles: `4`
- Instantiated effect prefabs success/fail: `12/0`

## Attached Effects
| skillId | owner | bundle | prefabAsset | instantiate | reason |
| ---: | --- | --- | --- | --- | --- |
| 1002101 | our:1002 | download/skillprefabsandres/1002.assetbundle | assets/download/skillprefabsandres/1002/1002101.prefab | True |  |
| 1002201 | our:1002 | download/skillprefabsandres/1002.assetbundle | assets/download/skillprefabsandres/1002/1002201.prefab | True |  |
| 1002301 | our:1002 | download/skillprefabsandres/1002.assetbundle | assets/download/skillprefabsandres/1002/1002301.prefab | True |  |
| 1012101 | enemy:1100111 | download/skillprefabsandres/1012.assetbundle | assets/download/skillprefabsandres/1012/1012101.prefab | True |  |
| 1012201 | enemy:1100111 | download/skillprefabsandres/1012.assetbundle | assets/download/skillprefabsandres/1012/1012201.prefab | True |  |
| 1012301 | enemy:1100111 | download/skillprefabsandres/1012.assetbundle | assets/download/skillprefabsandres/1012/1012301.prefab | True |  |
| 1034101 | our:1034 | download/skillprefabsandres/1034.assetbundle | assets/download/skillprefabsandres/1034/1034101.prefab | True |  |
| 1034201 | our:1034 | download/skillprefabsandres/1034.assetbundle | assets/download/skillprefabsandres/1034/1034201.prefab | True |  |
| 1034301 | our:1034 | download/skillprefabsandres/1034.assetbundle | assets/download/skillprefabsandres/1034/1034301.prefab | True |  |
| 1036101 | our:1036 | download/skillprefabsandres/1036.assetbundle | assets/download/skillprefabsandres/1036/1036101.prefab | True |  |
| 1036201 | our:1036 | download/skillprefabsandres/1036.assetbundle | assets/download/skillprefabsandres/1036/1036201.prefab | True |  |
| 1036301 | our:1036 | download/skillprefabsandres/1036.assetbundle | assets/download/skillprefabsandres/1036/1036301.prefab | True |  |

## Unresolved Skills
| skillId | reason | owners |
| ---: | --- | --- |
| 1001401 | bundle_candidates_missing_or_path_normalize_unresolved | enemy:1100131;enemy:1100132;enemy:1100133 |
| 1001403 | bundle_candidates_missing_or_path_normalize_unresolved | enemy:1100131;enemy:1100132;enemy:1100133 |
| 1012401 | bundle_candidates_missing_or_path_normalize_unresolved | enemy:1100111;enemy:1100112;enemy:1100113;enemy:1100121;enemy:1100122;enemy:1100123 |
| 1012403 | bundle_candidates_missing_or_path_normalize_unresolved | enemy:1100111;enemy:1100112;enemy:1100113;enemy:1100121;enemy:1100122;enemy:1100123 |
| 1034401 | bundle_candidates_missing_or_path_normalize_unresolved | our:1034 |
| 1034402 | bundle_candidates_missing_or_path_normalize_unresolved | our:1034 |
| 1036401 | bundle_candidates_missing_or_path_normalize_unresolved | our:1036 |
| 1036402 | bundle_candidates_missing_or_path_normalize_unresolved | our:1036 |

## Notes
- This scene attaches only original loadable prefab/effect evidence. It does not invent AI, target selection, timing, damage, or skill animation logic.
- BATTLE_15 should close common effect dependencies or add playable/timeline markers before any battle UI/HUD work.
