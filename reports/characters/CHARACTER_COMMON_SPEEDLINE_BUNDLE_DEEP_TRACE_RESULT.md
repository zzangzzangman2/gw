# CHARACTER_COMMON_SPEEDLINE_BUNDLE_DEEP_TRACE_RESULT

- generatedBy: `_restore_tools/scripts/build_character_common_speedline_bundle_deep_trace.py`
- generatedAtUtc: `2026-06-25T20:14:20.425218+00:00`
- workspace: `C:\Users\godho\Downloads\girlswar`
- classification: `no_fake_resource_source_backed_trace`
- networkAccessUsed: `False`
- unitySceneModified: `False`
- fakeResourceMappingUsed: `False`

## Summary

- speedlineStatusCounts: `{'resolved_loadable_local_bundle': 3}`
- resourceUpdateProposalWritten: `True`
- affectedSkillRows: `26`
- skillRowsProposedLoadable: `8`

## Speedline Matrix

| speedline | final status | exact child bundle | resolved local bundle | evidence |
|---|---|---|---|---|
| pink | `resolved_loadable_local_bundle` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/pinkspeedline.assetbundle` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1.assetbundle` | parentLocal=True; parentObjectHit=True; assetPathHits=3; names=pinkspeedline |
| red | `resolved_loadable_local_bundle` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1.assetbundle` | parentLocal=True; parentObjectHit=True; assetPathHits=11; names=redspeedline|redspeedlines02|redspeedlinesshu|redspeedlinesshu1|redspeedlinesxie |
| yello | `resolved_loadable_local_bundle` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/yellospeedline.assetbundle` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1.assetbundle` | parentLocal=True; parentObjectHit=True; assetPathHits=4; names=yellospeedline|yellospeedline_heng|yellospeedlinesshu |

## Exact vs Parent Bundle Finding

- The three exact child `.assetbundle` dependency strings from the manifest are not present as local standalone bundles.
- Source-backed local resolution is the parent bundle `download/commonprefabsandres/skilleffect/commonskillprefabsandres1.assetbundle`.
- The parent bundle is present in assetbundle/versionfile indexes and the clean UnityFS slice can be inspected.
- UnityPy inspection finds matching speedline object/container names inside the parent bundle.
- `yellospeedline` is treated as authoritative source spelling. `yellow` spelling is not used as an alias.

## Affected Skill Rows

| side | wave | owner | skillDid | prefabId | current | proposed | affected exact bundles | blocker |
|---|---:|---:|---:|---:|---|---|---|---|
| our |  | 1036 | 1036201 | 1036201 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains not_fetchable_local: 1036 actor bundle is present in CDNVersionFile but absent locally; CDN acquisition trace found no asset CDN build rule |
| our |  | 1036 | 1036301 | 1036301 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/yellospeedline.assetbundle` | actor remains not_fetchable_local: 1036 actor bundle is present in CDNVersionFile but absent locally; CDN acquisition trace found no asset CDN build rule |
| our |  | 1036 | 1036301 | 1036351 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/yellospeedline.assetbundle` | actor remains not_fetchable_local: 1036 actor bundle is present in CDNVersionFile but absent locally; CDN acquisition trace found no asset CDN build rule |
| our |  | 1002 | 1002201 | 1002201 | `loadable_with_unresolved_common_resource_deps` | `loadable` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/pinkspeedline.assetbundle` |  |
| our |  | 1002 | 1002301 | 1002301 | `loadable_with_unresolved_common_resource_deps` | `loadable` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/pinkspeedline.assetbundle` |  |
| our |  | 1002 | 1002301 | 1002351 | `loadable_with_unresolved_common_resource_deps` | `loadable` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/pinkspeedline.assetbundle` |  |
| our |  | 1034 | 1034201 | 1034201 | `loadable_with_unresolved_common_resource_deps` | `loadable` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/yellospeedline.assetbundle` |  |
| our |  | 1034 | 1034301 | 1034351 | `loadable_with_unresolved_common_resource_deps` | `loadable` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/yellospeedline.assetbundle` |  |
| enemy | 1 | 1100111 | 1012201 | 1012201 | `loadable_with_unresolved_common_resource_deps` | `loadable` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` |  |
| enemy | 1 | 1100111 | 1012301 | 1012301 | `loadable_with_unresolved_common_resource_deps` | `loadable` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` |  |
| enemy | 1 | 1100111 | 1012301 | 1012351 | `loadable_with_unresolved_common_resource_deps` | `loadable` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` |  |
| enemy | 1 | 1100112 | 1012201 | 1012201 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains unresolved_enemy_payload_instance: payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 1 | 1100112 | 1012301 | 1012301 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains unresolved_enemy_payload_instance: payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 1 | 1100112 | 1012301 | 1012351 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains unresolved_enemy_payload_instance: payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 1 | 1100113 | 1012201 | 1012201 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains unresolved_enemy_payload_instance: payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 1 | 1100113 | 1012301 | 1012301 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains unresolved_enemy_payload_instance: payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 1 | 1100113 | 1012301 | 1012351 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains unresolved_enemy_payload_instance: payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 2 | 1100121 | 1012201 | 1012201 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains unresolved_enemy_payload_instance: payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 2 | 1100121 | 1012301 | 1012301 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains unresolved_enemy_payload_instance: payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 2 | 1100121 | 1012301 | 1012351 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains unresolved_enemy_payload_instance: payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 2 | 1100122 | 1012201 | 1012201 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains unresolved_enemy_payload_instance: payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 2 | 1100122 | 1012301 | 1012301 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains unresolved_enemy_payload_instance: payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 2 | 1100122 | 1012301 | 1012351 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains unresolved_enemy_payload_instance: payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 2 | 1100123 | 1012201 | 1012201 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains unresolved_enemy_payload_instance: payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 2 | 1100123 | 1012301 | 1012301 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains unresolved_enemy_payload_instance: payload enemy id has no authoritative DTMonster_* row or alias in local evidence |
| enemy | 2 | 1100123 | 1012301 | 1012351 | `data_only_missing_actor` | `data_only_missing_actor` | `download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle` | actor remains unresolved_enemy_payload_instance: payload enemy id has no authoritative DTMonster_* row or alias in local evidence |

## Proposal

- proposalJson: `reports/battle/BATTLE_LOCAL_PLAYABLE_PAYLOAD_RESOURCE_UPDATE_PROPOSAL_FROM_SPEEDLINE_TRACE.json`
- proposalCsv: `reports/battle/BATTLE_LOCAL_PLAYABLE_PAYLOAD_RESOURCE_UPDATE_PROPOSAL_FROM_SPEEDLINE_TRACE.csv`
- The proposal is source-backed and does not overwrite `BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST`.
- It is only a common speedline resource-dependency update, not a full original payload restore claim.

## Command Policy

- rootCmdCount: `1`
- rootCmdFiles: `['00_COMMAND_CENTER.cmd']`
- restoreToolsDirectCmdCount: `0`
- policyOk: `True`

## Next Blockers

- Battle worker must apply the proposal to treat exact speedline manifest dependency strings as objects inside the source-backed parent bundle.
- Full original payload remains blocked by 1036 actor not_fetchable_local and unresolved enemy payload actor mappings.
- No source-backed yellow spelling alias was used; yellospeedline remains the authoritative local evidence string.
