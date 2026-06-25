# Battle AssetBundle Streaming Probe Result

## Outputs
- Scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\BattleAssetBundleStreamingProbe.unity`
- Result JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_ASSETBUNDLE_STREAMING_PROBE.json`
- Result CSV: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_ASSETBUNDLE_STREAMING_PROBE.csv`
- Unity log: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_10_UNITY_ASSETBUNDLE_STREAMING.log`
- Unity batchmode success: `True`

## Summary
- Probe load success: `4`
- Probe load fail: `0`
- Prefab instantiate success: `3`
- Texture fallback markers: `0`

## Bundle Results
| kind | id | bundle | file | load | asset count | GameObject | Texture2D | Sprite | Material | TextAsset | instantiate | fallback | reason |
| --- | --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- | --- |
| actor | 1002 | download/roleprefabsandres/battleprefabandres/1002.assetbundle | True | True | 9 | 2 | 1 | 0 | 2 | 2 | True | False |  |
| actor | 1034 | download/roleprefabsandres/battleprefabandres/1034.assetbundle | True | True | 9 | 2 | 1 | 0 | 2 | 2 | True | False |  |
| actor | 1100111 | download/roleprefabsandres/battleprefabandres/3001.assetbundle | True | True | 8 | 2 | 1 | 0 | 1 | 2 | True | False |  |
| map | 11001 | download/artsources/map/battlemap/map_11001/map_11001_1.assetbundle | True | True | 9 | 0 | 0 | 9 | 0 | 0 | False | False |  |

## Classification
- If Unity direct streaming fails later on another machine, keep the BATTLE_09 extracted texture fallback path.
- Current fastest next step: `BATTLE_11_BUILD_EXTRACTED_PREFAB_RECONSTRUCTION`, because direct AssetBundle streaming loaded the bundles and exposed names/types; full Spine runtime import is still a larger compatibility task.

## BATTLE_11 Recommendation
- Build extracted-prefab reconstruction for the streamed actor bundles, using loaded GameObject names plus copied skel/atlas/texture evidence.
