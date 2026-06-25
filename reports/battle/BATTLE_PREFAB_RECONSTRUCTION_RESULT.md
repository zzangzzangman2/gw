# Battle Prefab Reconstruction Result

## Outputs
- Runtime scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\BattleRuntimeStreamingReconstruction.unity`
- Runtime manifest: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_RUNTIME_STREAMING_MANIFEST.json`
- Hierarchy JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_PREFAB_HIERARCHY_DUMP.json`
- Hierarchy CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_PREFAB_HIERARCHY_DUMP.csv`
- Unity batchmode success: `True`

## Counts
- Instantiated runtime prefabs: `3`
- Missing placeholders: `9`
- Dumped hierarchy objects: `3`
- Dumped components: `12`
- Renderers: `3`
- Skeleton evidence assets: `9`

## Runtime Actors
| side | heroDid | bundle | prefabAsset | status | reason |
| --- | --- | --- | --- | --- | --- |
| our | 1036 | download/roleprefabsandres/battleprefabandres/1036.assetbundle |  | placeholder | listed_in_cdn_versionfile_not_extracted |
| our | 1002 | download/roleprefabsandres/battleprefabandres/1002.assetbundle | assets/download/roleprefabsandres/battleprefabandres/1002/hero_1002.prefab | runtime_prefab |  |
| our | 1034 | download/roleprefabsandres/battleprefabandres/1034.assetbundle | assets/download/roleprefabsandres/battleprefabandres/1034/hero_1034.prefab | runtime_prefab |  |
| enemy | 1100111 | download/roleprefabsandres/battleprefabandres/3001.assetbundle | assets/download/roleprefabsandres/battleprefabandres/3001/hero_3001.prefab | runtime_prefab |  |
| enemy | 1100112 |  |  | placeholder | not_loadable_yet |
| enemy | 1100113 |  |  | placeholder | not_loadable_yet |
| enemy | 1100121 |  |  | placeholder | not_loadable_yet |
| enemy | 1100122 |  |  | placeholder | not_loadable_yet |
| enemy | 1100123 |  |  | placeholder | not_loadable_yet |
| enemy | 1100131 |  |  | placeholder | not_loadable_yet |
| enemy | 1100132 |  |  | placeholder | not_loadable_yet |
| enemy | 1100133 |  |  | placeholder | not_loadable_yet |

## Hierarchy Sample
| bundleId | asset | path | components | renderer | materials | textures |
| --- | --- | --- | --- | --- | --- | --- |
| 1002 | assets/download/roleprefabsandres/battleprefabandres/1002/hero_1002.prefab | Reconstructed_our_1002 | Transform;MeshFilter;MeshRenderer;MissingScript | MeshRenderer | 1002_Material | 1002 |
| 1034 | assets/download/roleprefabsandres/battleprefabandres/1034/hero_1034.prefab | Reconstructed_our_1034 | Transform;MeshFilter;MeshRenderer;MissingScript | MeshRenderer | 1034_Material;1034_Material-Screen | 1034;1034 |
| 1100111 | assets/download/roleprefabsandres/battleprefabandres/3001/hero_3001.prefab | Reconstructed_enemy_1100111 | Transform;MeshFilter;MeshRenderer;MissingScript | MeshRenderer | 3001_Material | 3001 |

## BATTLE_12 Recommendation
- Connect battle Lua/IL2CPP flow to the runtime loader before skills/effects: actor and map streaming are now proven, so wiring ProcedureNormalBattle payload into the loader unlocks a playable battle shell faster.
