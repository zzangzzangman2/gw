# CHARACTER_63_UNRESOLVED_ACTOR_BUNDLE_LOCAL_EVIDENCE_RESCAN_NO_NETWORK_NO_FAKE_RESULT

- generatedBy: `_restore_tools/scripts/build_character_63_unresolved_actor_bundle_local_evidence_rescan.py`
- generatedAtUtc: `2026-06-25T20:35:36.860280+00:00`
- workspace: `C:\Users\godho\Downloads\girlswar`
- sceneModified: `False`
- networkUsed: `False`
- fakeDataCreated: `False`
- proposalWritten: `False`

## Summary

- actorsChecked: `1036, 1100112, 1100113, 1100121, 1100122, 1100123, 1100131, 1100132, 1100133`
- statusCounts: `{'versionfile_or_cdn_index_only_not_local': 1, 'not_resolved_from_local_evidence': 8}`
- newResolvedLoadableLocalBundles: `0`
- newLocalParentBundleContainerMatches: `0`
- versionfileOnlyRows: `1`
- stillUnresolvedRows: `9`

## Actor Chain Matrix

| actorId | side | wave | slot | datatable | modelId | prefabId | expected actor bundle | final status | reason |
|---:|---|---:|---:|---|---:|---:|---|---|---|
| 1036 | our |  | 1 | DTHeroEntity | 1036 | 1036 | `download/roleprefabsandres/battleprefabandres/1036.assetbundle` | `versionfile_or_cdn_index_only_not_local` | Exact actor bundle is listed in local versionfile/CDNVersionFile evidence but no local bundle file or clean slice exists. |
| 1100112 | enemy | 1 | 2 |  |  |  | `` | `not_resolved_from_local_evidence` | No source-backed hero/monster -> model -> prefab actor bundle chain exists for this payload id. |
| 1100113 | enemy | 1 | 3 |  |  |  | `` | `not_resolved_from_local_evidence` | No source-backed hero/monster -> model -> prefab actor bundle chain exists for this payload id. |
| 1100121 | enemy | 2 | 1 |  |  |  | `` | `not_resolved_from_local_evidence` | No source-backed hero/monster -> model -> prefab actor bundle chain exists for this payload id. |
| 1100122 | enemy | 2 | 2 |  |  |  | `` | `not_resolved_from_local_evidence` | No source-backed hero/monster -> model -> prefab actor bundle chain exists for this payload id. |
| 1100123 | enemy | 2 | 3 |  |  |  | `` | `not_resolved_from_local_evidence` | No source-backed hero/monster -> model -> prefab actor bundle chain exists for this payload id. |
| 1100131 | enemy | 3 | 1 |  |  |  | `` | `not_resolved_from_local_evidence` | No source-backed hero/monster -> model -> prefab actor bundle chain exists for this payload id. |
| 1100132 | enemy | 3 | 2 |  |  |  | `` | `not_resolved_from_local_evidence` | No source-backed hero/monster -> model -> prefab actor bundle chain exists for this payload id. |
| 1100133 | enemy | 3 | 3 |  |  |  | `` | `not_resolved_from_local_evidence` | No source-backed hero/monster -> model -> prefab actor bundle chain exists for this payload id. |

## Key Findings

- `1036` retains an authoritative DTHero -> DTmodel -> prefab chain, but the exact expected battle actor bundle is not local.
- `1036` exact bundle has versionfile/CDNVersionFile evidence only; same-filename role painting and skill bundles are not actor bundle aliases.
- Enemy payload instance ids still have no authoritative DTMonster/DTHero -> DTmodel -> prefab chain in local evidence.
- Weak skill/model references on unresolved enemy skill rows are recorded as context only and are not promoted to actor aliases.
- Speedline BATTLE61/BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED inputs were read and left unchanged.

## Outputs

- JSON: `reports/characters/CHARACTER_63_UNRESOLVED_ACTOR_BUNDLE_LOCAL_EVIDENCE_RESCAN_NO_NETWORK_NO_FAKE_RESULT.json`
- Chain CSV: `reports/characters/CHARACTER_63_UNRESOLVED_ACTOR_BUNDLE_LOCAL_EVIDENCE_RESCAN_NO_NETWORK_NO_FAKE_RESULT_CHAIN_MATRIX.csv`
- Evidence CSV: `reports/characters/CHARACTER_63_UNRESOLVED_ACTOR_BUNDLE_LOCAL_EVIDENCE_RESCAN_NO_NETWORK_NO_FAKE_RESULT_LOCAL_EVIDENCE_CLASSIFICATION_MATRIX.csv`
- Blocker CSV: `reports/characters/CHARACTER_63_UNRESOLVED_ACTOR_BUNDLE_LOCAL_EVIDENCE_RESCAN_NO_NETWORK_NO_FAKE_RESULT_BLOCKER_NEXT_ACTION_MATRIX.csv`

## Command Policy

- rootCmdCount: `1`
- rootCmdFiles: `['00_COMMAND_CENTER.cmd']`
- restoreToolsDirectCmdCount: `0`
- policyOk: `True`

## Next Blocker

- Full actor payload still requires the exact 1036 battle actor bundle or approved acquisition, plus authoritative DTMonster/DTHero->DTmodel->prefab chains or source-backed aliases for unresolved enemy payload instance ids.
