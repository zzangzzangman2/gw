# CHARACTER_65_FULL_BATTLE_PAYLOAD_ROSTER_AND_BUNDLE_GAP_MATRIX_NO_NETWORK_NO_IMPORT_RESULT

- generatedBy: `_restore_tools/scripts/build_character_65_full_battle_payload_roster_gap_matrix.py`
- generatedAtUtc: `2026-06-25T21:24:09.344014+00:00`
- networkUsed: `False`
- filesCopied: `False`
- filesImported: `False`
- sceneModified: `False`
- weakMatchesPromoted: `False`
- proposalWritten: `True`

## Summary

- battleListRows: `73`
- actorRows: `12`
- skillRows: `61`
- readyLocalRows: `15`
- sourceKnownMissingBundleRows: `11`
- unresolvedSourceChainRows: `47`
- notPromotableWeakMatchRows: `10`
- actorCandidateStatusCounts: `{'source_known_missing_bundle': 1, 'ready_local': 3, 'unresolved_source_chain': 8}`
- skillCandidateStatusCounts: `{'source_known_missing_bundle': 10, 'ready_local': 12, 'unresolved_source_chain': 39}`

## Actor/Card Roster

| status | side | wave | slot | id | model | prefab | bundle | battle visibility |
|---|---|---:|---:|---:|---:|---:|---|---|
| `source_known_missing_bundle` | our |  | 1 | 1036 | 1036 | 1036 | `download/roleprefabsandres/battleprefabandres/1036.assetbundle` | card_source_known_actor_missing_bundle |
| `ready_local` | our |  | 2 | 1002 | 1002 | 1002 | `download/roleprefabsandres/battleprefabandres/1002.assetbundle` | source_backed_visible_local_subset |
| `ready_local` | our |  | 3 | 1034 | 1034 | 1034 | `download/roleprefabsandres/battleprefabandres/1034.assetbundle` | source_backed_visible_local_subset |
| `ready_local` | enemy | 1 | 1 | 1100111 | 3001 | 3001 | `download/roleprefabsandres/battleprefabandres/3001.assetbundle` | source_backed_visible_local_subset |
| `unresolved_source_chain` | enemy | 1 | 2 | 1100112 |  |  | `` | unresolved_actor_not_placed |
| `unresolved_source_chain` | enemy | 1 | 3 | 1100113 |  |  | `` | unresolved_actor_not_placed |
| `unresolved_source_chain` | enemy | 2 | 1 | 1100121 |  |  | `` | unresolved_actor_not_placed |
| `unresolved_source_chain` | enemy | 2 | 2 | 1100122 |  |  | `` | unresolved_actor_not_placed |
| `unresolved_source_chain` | enemy | 2 | 3 | 1100123 |  |  | `` | unresolved_actor_not_placed |
| `unresolved_source_chain` | enemy | 3 | 1 | 1100131 |  |  | `` | unresolved_actor_not_placed |
| `unresolved_source_chain` | enemy | 3 | 2 | 1100132 |  |  | `` | unresolved_actor_not_placed |
| `unresolved_source_chain` | enemy | 3 | 3 | 1100133 |  |  | `` | unresolved_actor_not_placed |

## Key Conclusions

- Ready local actor rows remain exactly `1002`, `1034`, and enemy `1100111 -> model/prefab 3001`.
- `1036` is source-known but missing exact battle actor bundle; CHARACTER64 weak same-name files are not actor bundle matches.
- Enemy ids `1100112`, `1100113`, `1100121`, `1100122`, `1100123`, `1100131`, `1100132`, `1100133` remain unresolved source chains.
- Skill rows are retained in the full matrix, but rows whose owner actor is missing/unresolved are not ready battle-list runtime rows.
- BATTLE64 Timeline/xLua/runtime binding blockers remain even for ready local skill assets.

## Outputs

- JSON: `reports/characters/CHARACTER_65_FULL_BATTLE_PAYLOAD_ROSTER_AND_BUNDLE_GAP_MATRIX_NO_NETWORK_NO_IMPORT_RESULT.json`
- Actor/card CSV: `reports/characters/CHARACTER_65_FULL_BATTLE_PAYLOAD_ROSTER_AND_BUNDLE_GAP_MATRIX_NO_NETWORK_NO_IMPORT_RESULT_FULL_BATTLE_ACTOR_CARD_ROSTER_MATRIX.csv`
- Skill/timeline/effect CSV: `reports/characters/CHARACTER_65_FULL_BATTLE_PAYLOAD_ROSTER_AND_BUNDLE_GAP_MATRIX_NO_NETWORK_NO_IMPORT_RESULT_SKILL_TIMELINE_EFFECT_PAYLOAD_MATRIX.csv`
- Readiness/gap CSV: `reports/characters/CHARACTER_65_FULL_BATTLE_PAYLOAD_ROSTER_AND_BUNDLE_GAP_MATRIX_NO_NETWORK_NO_IMPORT_RESULT_LOCAL_BUNDLE_READINESS_AND_GAP_MATRIX.csv`
- Proposal JSON: `reports/battle/BATTLE_FULL_PAYLOAD_LIST_CANDIDATE_PROPOSAL_FROM_CHARACTER65_ROSTER_GAP_MATRIX.json`

## Command Policy

- rootCmdCount: `1`
- rootCmdFiles: `['00_COMMAND_CENTER.cmd']`
- restoreToolsDirectCmdCount: `0`
- policyOk: `True`

## Next Blocker

- Full payload battle list cannot be promoted to ready until exact 1036 battle actor bundle is acquired locally and unresolved enemy payload ids receive authoritative actor chains/source-backed aliases; visual activation still needs Timeline/xLua runtime context.
