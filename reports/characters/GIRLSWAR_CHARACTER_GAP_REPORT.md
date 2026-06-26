# GirlsWar Character Gap Report

## Current Manifest / Payload Gaps
- Actor gaps: `9` / `12`
- Skill gap rows: `22` / `61`

## Actor Gaps
| side | wave | heroDid | tableFound | modelId | prefabId | bundle | status |
| --- | --- | ---: | --- | ---: | ---: | --- | --- |
| our |  | 1036 | True | 1036 | 1036 | download/roleprefabsandres/battleprefabandres/1036.assetbundle | bundle_not_in_extracted_assetbundle_index |
| enemy | 1 | 1100112 | False |  |  |  | missing_model_or_prefab |
| enemy | 1 | 1100113 | False |  |  |  | missing_model_or_prefab |
| enemy | 2 | 1100121 | False |  |  |  | missing_model_or_prefab |
| enemy | 2 | 1100122 | False |  |  |  | missing_model_or_prefab |
| enemy | 2 | 1100123 | False |  |  |  | missing_model_or_prefab |
| enemy | 3 | 1100131 | False |  |  |  | missing_model_or_prefab |
| enemy | 3 | 1100132 | False |  |  |  | missing_model_or_prefab |
| enemy | 3 | 1100133 | False |  |  |  | missing_model_or_prefab |

## Skill Gaps
| skillDid | owner | skillType | actFound | passiveFound | status |
| ---: | ---: | ---: | --- | --- | --- |
| 1036401 | 1036 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1036402 | 1036 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1034401 | 1034 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1034402 | 1034 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1012401 | 1100111 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1012403 | 1100111 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1012401 | 1100112 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1012403 | 1100112 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1012401 | 1100113 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1012403 | 1100113 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1012401 | 1100121 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1012403 | 1100121 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1012401 | 1100122 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1012403 | 1100122 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1012401 | 1100123 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1012403 | 1100123 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1001401 | 1100131 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1001403 | 1100131 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1001401 | 1100132 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1001403 | 1100132 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1001401 | 1100133 | 2 | False | True | missing_DTSkillAct_prefab_mapping |
| 1001403 | 1100133 | 2 | False | True | missing_DTSkillAct_prefab_mapping |

## Improvements Over Current Manifest
- Variant monster tables resolve these previously missing manifest actors:
  - `1100111` via `DTMonster_KEntity` -> prefab `3001` -> `download/roleprefabsandres/battleprefabandres/3001.assetbundle`
- No additional skill rows improved over the current manifest.

## Next Blockers
- Only enemy 1100111 resolves to a loadable actor bundle through extracted DTMonster_* variant tables; enemy 1100112/1100113/1100121/1100122/1100123/1100131/1100132/1100133 remain missing in all decoded non-Attr DTMonster*Entity tables with modelID fields (DTMonsterEntity, DTMonster_FEntity, DTMonster_GEntity, DTMonster_HEntity, DTMonster_KEntity, DTMonster_OEntity).
- Our hero 1036 maps to battle prefab 1036, but download/roleprefabsandres/battleprefabandres/1036.assetbundle is not in the extracted assetbundle index even though skill bundle 1036 exists.
- skillType=2 ids 1036401/1036402/1034401/1034402/1012401/1012403/1001401/1001403 do not resolve through DTSkillAct timeline prefab mapping; several are passive-style rows and should not be used as active timeline prefab ids without additional battle Lua evidence.
- DTSysPrefab direct raw decode is now available through sys.assetbundle get_raw_data() -> gzip -> FlatBuffers. Remaining DTSysPrefab work is to wire more non-battle prefab categories if needed.

## Deep Trace Addendum
- `reports/characters/CHARACTER_RESOURCE_GAP_DEEP_TRACE.md` classifies hero 1036 actor bundle as `present_in_versionfile_but_not_extracted`.
- `reports/characters/CHARACTER_1036_CDN_ACQUISITION_TRACE.md` classifies the same 1036 actor bundle as `not_fetchable_from_local_evidence`: the CDNVersionFile row is present, exact local files are absent, no asset CDN base URL/build rule was proven, and no HEAD/GET/download was executed.
- The same deep trace classifies enemy payload ids `1100112/1100113/1100121/1100122/1100123/1100131/1100132/1100133` as `still_unresolved_payload_instance_id`; no authoritative alias from those payload ids to DTMapsWave monster ids was found.
