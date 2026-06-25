# Battle Skill/Effect Streaming Probe Result

## Outputs
- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_SKILL_EFFECT_STREAMING_PROBE.json`
- CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_SKILL_EFFECT_STREAMING_PROBE.csv`
- Scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\BattleSkillEffectStreamingProbe.unity`
- Unity bundle probe JSON: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_SKILL_EFFECT_STREAMING_UNITY_BUNDLE_PROBE.json`
- Unity batchmode success: `True`

## Counts
- Skill ids: `20`
- Bundle candidates: `7`
- Bundle load success/fail: `4/3`
- Loadable effect prefab candidates: `68`
- Matching timeline prefab candidates: `16`
- Instantiated scene markers: `4`

## Skill Rows
| skillId | owners | lua | skill | timeline | bundles | exists | load ok | load fail | timeline prefabs | effect prefabs | unresolved |
| ---: | --- | ---: | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| 1001401 | enemy:1100131;enemy:1100132;enemy:1100133 | 0 | False | False | 0 | 0 | 0 | 0 | 0 | 0 | bundle_candidates_missing_or_path_normalize_unresolved |
| 1001403 | enemy:1100131;enemy:1100132;enemy:1100133 | 0 | False | False | 0 | 0 | 0 | 0 | 0 | 0 | bundle_candidates_missing_or_path_normalize_unresolved |
| 1002101 | our:1002 | 2 | True | True | 1 | 1 | 1 | 0 | 4 | 17 |  |
| 1002201 | our:1002 | 2 | True | True | 2 | 1 | 1 | 1 | 4 | 17 |  |
| 1002301 | our:1002 | 2 | True | True | 2 | 1 | 1 | 1 | 4 | 17 |  |
| 1012101 | enemy:1100111;enemy:1100112;enemy:1100113;enemy:1100121;enemy:1100122;enemy:1100123;enemy:1100131;enemy:1100131;enemy:1100132;enemy:1100132;enemy:1100133;enemy:1100133 | 2 | True | True | 1 | 1 | 1 | 0 | 4 | 18 |  |
| 1012201 | enemy:1100111;enemy:1100112;enemy:1100113;enemy:1100121;enemy:1100122;enemy:1100123 | 2 | True | True | 2 | 1 | 1 | 1 | 4 | 18 |  |
| 1012301 | enemy:1100111;enemy:1100112;enemy:1100113;enemy:1100121;enemy:1100122;enemy:1100123 | 2 | True | True | 2 | 1 | 1 | 1 | 4 | 18 |  |
| 1012401 | enemy:1100111;enemy:1100112;enemy:1100113;enemy:1100121;enemy:1100122;enemy:1100123 | 0 | False | False | 0 | 0 | 0 | 0 | 0 | 0 | bundle_candidates_missing_or_path_normalize_unresolved |
| 1012403 | enemy:1100111;enemy:1100112;enemy:1100113;enemy:1100121;enemy:1100122;enemy:1100123 | 0 | False | False | 0 | 0 | 0 | 0 | 0 | 0 | bundle_candidates_missing_or_path_normalize_unresolved |
| 1034101 | our:1034 | 2 | True | True | 1 | 1 | 1 | 0 | 4 | 16 |  |
| 1034201 | our:1034 | 2 | True | True | 2 | 1 | 1 | 1 | 4 | 16 |  |
| 1034301 | our:1034 | 2 | True | True | 2 | 1 | 1 | 1 | 4 | 16 |  |
| 1034401 | our:1034 | 0 | False | False | 0 | 0 | 0 | 0 | 0 | 0 | bundle_candidates_missing_or_path_normalize_unresolved |
| 1034402 | our:1034 | 2 | False | False | 0 | 0 | 0 | 0 | 0 | 0 | bundle_candidates_missing_or_path_normalize_unresolved |
| 1036101 | our:1036 | 2 | True | True | 1 | 1 | 1 | 0 | 4 | 17 |  |
| 1036201 | our:1036 | 2 | True | True | 2 | 1 | 1 | 1 | 4 | 17 |  |
| 1036301 | our:1036 | 2 | True | True | 2 | 1 | 1 | 1 | 4 | 17 |  |
| 1036401 | our:1036 | 0 | False | False | 0 | 0 | 0 | 0 | 0 | 0 | bundle_candidates_missing_or_path_normalize_unresolved |
| 1036402 | our:1036 | 2 | False | False | 0 | 0 | 0 | 0 | 0 | 0 | bundle_candidates_missing_or_path_normalize_unresolved |

## Bundle Probe
| bundle | exists | load | assets | GameObject | Texture2D | Material | TextAsset | timeline prefabs | loadable prefabs | instantiate | reason |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |
| download/commonprefabsandres/skilleffect/commonskillprefabsandres1/pinkspeedline.assetbundle | False | False | 0 | 0 | 0 | 0 | 0 | 0 | 0 | False | file_not_found |
| download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle | False | False | 0 | 0 | 0 | 0 | 0 | 0 | 0 | False | file_not_found |
| download/commonprefabsandres/skilleffect/commonskillprefabsandres1/yellospeedline.assetbundle | False | False | 0 | 0 | 0 | 0 | 0 | 0 | 0 | False | file_not_found |
| download/skillprefabsandres/1002.assetbundle | True | True | 37 | 17 | 2 | 14 | 0 | 4 | 17 | True |  |
| download/skillprefabsandres/1012.assetbundle | True | True | 58 | 18 | 10 | 24 | 0 | 4 | 18 | True |  |
| download/skillprefabsandres/1034.assetbundle | True | True | 39 | 16 | 0 | 18 | 0 | 4 | 16 | True |  |
| download/skillprefabsandres/1036.assetbundle | True | True | 39 | 17 | 2 | 12 | 0 | 4 | 17 | True |  |

## Script Evidence
- Flow manifest: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_RUNTIME_FLOW_MANIFEST.json`
- Prototype skills CSV: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_PROTOTYPE_SKILLS.csv`
- BATTLE_14 recommendation: `loadable skill effect를 flow scene에 attach`.
