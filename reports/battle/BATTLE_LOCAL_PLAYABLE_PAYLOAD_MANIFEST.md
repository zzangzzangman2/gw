# BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST

- Classification: `local_playable_subset_only_not_full_payload`
- Authoritative payload: `reports/battle/BATTLE_TEST_PAYLOAD.json`
- Output JSON: `reports/battle/BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.json`
- Output CSV: `reports/battle/BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.csv`

## Summary
- Actors loadable: `3` / `12`
- Skill timeline rows resolved: `39` / `61`
- Resource-complete loadable skill rows: `4`
- Timeline rows with unresolved common deps: `8`
- Actor statuses: `{'not_fetchable_local': 1, 'loadable': 3, 'unresolved_enemy_payload_instance': 8}`
- Skill statuses: `{'data_only_missing_actor': 27, 'passive_no_timeline': 22, 'loadable': 4, 'loadable_with_unresolved_common_resource_deps': 8}`
- Resource statuses: `{'loadable': 8, 'not_fetchable_local': 1, 'unresolved_missing_common_bundle': 3}`

## Actor Rows
| side | wave | slot | heroDid | heroId | prefabId | bundle | status | reason |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- | --- |
| our |  | 1 | 1036 | 51469 | 1036 | `download/roleprefabsandres/battleprefabandres/1036.assetbundle` | `not_fetchable_local` | 1036 actor bundle is present in CDNVersionFile but absent locally; CDN acquisition trace found no asset CDN build rule |
| our |  | 2 | 1002 | 50870 | 1002 | `download/roleprefabsandres/battleprefabandres/1002.assetbundle` | `loadable` | actor bundle and spine evidence exist locally |
| our |  | 3 | 1034 | 50874 | 1034 | `download/roleprefabsandres/battleprefabandres/1034.assetbundle` | `loadable` | actor bundle and spine evidence exist locally |
| enemy | 1 | 1 | 1100111 | -1 | 3001 | `download/roleprefabsandres/battleprefabandres/3001.assetbundle` | `loadable` | actor bundle and spine evidence exist locally |
| enemy | 1 | 2 | 1100112 | -2 |  | `` | `unresolved_enemy_payload_instance` | payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 1 | 3 | 1100113 | -3 |  | `` | `unresolved_enemy_payload_instance` | payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 2 | 1 | 1100121 | -1 |  | `` | `unresolved_enemy_payload_instance` | payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 2 | 2 | 1100122 | -2 |  | `` | `unresolved_enemy_payload_instance` | payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 2 | 3 | 1100123 | -3 |  | `` | `unresolved_enemy_payload_instance` | payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 3 | 1 | 1100131 | -1 |  | `` | `unresolved_enemy_payload_instance` | payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 3 | 2 | 1100132 | -2 |  | `` | `unresolved_enemy_payload_instance` | payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 3 | 3 | 1100133 | -3 |  | `` | `unresolved_enemy_payload_instance` | payload enemy id has no authoritative DTMonster_* row or alias in local evidence |

## Skill / Timeline Rows
| side | wave | ownerHeroDid | ownerActorStatus | skillLocalStatuses | resolved prefabIds | missing deps |
| --- | ---: | ---: | --- | --- | --- | --- |
| enemy | 1 | 1100111 | `loadable` | `{'loadable': 1, 'loadable_with_unresolved_common_resource_deps': 3, 'passive_no_timeline': 2}` | `1012101, 1012201, 1012301, 1012351` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` |
| enemy | 1 | 1100112 | `unresolved_enemy_payload_instance` | `{'data_only_missing_actor': 4, 'passive_no_timeline': 2}` | `1012101, 1012201, 1012301, 1012351` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` |
| enemy | 1 | 1100113 | `unresolved_enemy_payload_instance` | `{'data_only_missing_actor': 4, 'passive_no_timeline': 2}` | `1012101, 1012201, 1012301, 1012351` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` |
| enemy | 2 | 1100121 | `unresolved_enemy_payload_instance` | `{'data_only_missing_actor': 4, 'passive_no_timeline': 2}` | `1012101, 1012201, 1012301, 1012351` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` |
| enemy | 2 | 1100122 | `unresolved_enemy_payload_instance` | `{'data_only_missing_actor': 4, 'passive_no_timeline': 2}` | `1012101, 1012201, 1012301, 1012351` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` |
| enemy | 2 | 1100123 | `unresolved_enemy_payload_instance` | `{'data_only_missing_actor': 4, 'passive_no_timeline': 2}` | `1012101, 1012201, 1012301, 1012351` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` |
| enemy | 3 | 1100131 | `unresolved_enemy_payload_instance` | `{'data_only_missing_actor': 1, 'passive_no_timeline': 2}` | `1012101` | `` |
| enemy | 3 | 1100132 | `unresolved_enemy_payload_instance` | `{'data_only_missing_actor': 1, 'passive_no_timeline': 2}` | `1012101` | `` |
| enemy | 3 | 1100133 | `unresolved_enemy_payload_instance` | `{'data_only_missing_actor': 1, 'passive_no_timeline': 2}` | `1012101` | `` |
| our |  | 1002 | `loadable` | `{'loadable': 1, 'loadable_with_unresolved_common_resource_deps': 3}` | `1002101, 1002201, 1002301, 1002351` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/pinkspeedline.assetbundle` |
| our |  | 1034 | `loadable` | `{'loadable': 2, 'loadable_with_unresolved_common_resource_deps': 2, 'passive_no_timeline': 2}` | `1034101, 1034201, 1034301, 1034351` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/yellospeedline.assetbundle` |
| our |  | 1036 | `not_fetchable_local` | `{'data_only_missing_actor': 4, 'passive_no_timeline': 2}` | `1036101, 1036201, 1036301, 1036351` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle, download/commonprefabsandres/skilleffect/commonskillprefabsandres1/yellospeedline.assetbundle` |

## Resource Gaps
| kind | bundle | exists | status | referencedBy |
| --- | --- | --- | --- | --- |
| actor_bundle | `download/roleprefabsandres/battleprefabandres/1036.assetbundle` | `False` | `not_fetchable_local` | our:1036 |
| timeline_prefab_dep | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/pinkspeedline.assetbundle` | `False` | `unresolved_missing_common_bundle` | timeline:1002201, timeline:1002301, timeline:1002351 |
| timeline_prefab_dep | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | `False` | `unresolved_missing_common_bundle` | timeline:1012201, timeline:1012301, timeline:1012351, timeline:1036201 |
| timeline_prefab_dep | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/yellospeedline.assetbundle` | `False` | `unresolved_missing_common_bundle` | timeline:1034201, timeline:1034351, timeline:1036301, timeline:1036351 |

## Minimal Playable Local Subset
- Purpose: debug/interaction/runtime validation subset only; this is not a full original payload replacement and not a full restore claim
- Original our heroes retained: `[1002, 1034]`
- Original enemy wave rows retained: `[(1, [1100111])]`
- Timeline skill rows retained: `12`
- Resource-complete timeline skill rows: `4`
- Strict resource-complete skill prefabIds: `[1002101, 1034101, 1034301, 1012101]`

This subset is only for local interaction/runtime validation. It is not a full original payload replacement and must not be reported as a full restore.

## Next Blockers
- Full original payload execution still requires the missing 1036 actor battle bundle or an authoritative asset CDN acquisition path.
- Full original payload execution still requires authoritative mappings for unresolved enemy payload instance ids 1100112/1100113/1100121/1100122/1100123/1100131/1100132/1100133.
- Common timeline dependency bundles such as pink/red/yellow speedline remain unresolved where reported; they were not guessed or replaced.
- The local playable subset is for interaction/runtime validation only, not a full restore claim or replacement for the authoritative embedded BATTLE_TEST_PAYLOAD.

## Source Rules
- No Unity scene was modified.
- No fake actor/card/skill mapping was introduced.
- No Git commit/push was performed.
