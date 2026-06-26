# CHARACTER_66_UNRESOLVED_ENEMY_ID_SOURCE_ALIAS_TRACE_NO_NETWORK_NO_PROMOTION_RESULT

- generatedBy: `_restore_tools/scripts/build_character_66_unresolved_enemy_id_source_alias_trace.py`
- generatedAtUtc: `2026-06-25T21:33:45.567702+00:00`
- networkUsed: `False`
- filesCopied: `False`
- filesImported: `False`
- sceneModified: `False`
- aliasesPromoted: `False`
- proposalWritten: `False`

## Summary

- unresolvedIdsChecked: `1100112, 1100113, 1100121, 1100122, 1100123, 1100131, 1100132, 1100133`
- sourceHitsFound: `1095`
- sourceBackedAliasesFound: `0`
- hitClassificationCounts: `{'authoritative_monster_row': 2, 'weak/name-only/not promotable': 162, 'formation/payload instance id': 44, 'UI/text-only/reference-only': 887}`
- sourceAreaCounts: `{'datatable_monster': 8, 'decoded_lua': 69, 'decoded_payload_flow': 44, 'other_local_source': 86, 'il2cpp_native_strings': 1, 'prior_report_or_derived_manifest': 887}`

## Alias Decision Matrix

| targetId | finalStatus | authoritative monster rows | payload hits | weak/ref hits | decision | reason |
|---:|---|---:|---:|---:|---|---|
| 1100112 | `still_unresolved_no_source_backed_alias` | 0 | 5 | 116 | `do_not_promote` | Hits are payload/formation/context only; no DTMonster row, DTmodel chain, or explicit alias rule. |
| 1100113 | `still_unresolved_no_source_backed_alias` | 0 | 5 | 116 | `do_not_promote` | Hits are payload/formation/context only; no DTMonster row, DTmodel chain, or explicit alias rule. |
| 1100121 | `still_unresolved_no_source_backed_alias` | 0 | 5 | 116 | `do_not_promote` | Hits are payload/formation/context only; no DTMonster row, DTmodel chain, or explicit alias rule. |
| 1100122 | `still_unresolved_no_source_backed_alias` | 0 | 5 | 116 | `do_not_promote` | Hits are payload/formation/context only; no DTMonster row, DTmodel chain, or explicit alias rule. |
| 1100123 | `still_unresolved_no_source_backed_alias` | 0 | 5 | 116 | `do_not_promote` | Hits are payload/formation/context only; no DTMonster row, DTmodel chain, or explicit alias rule. |
| 1100131 | `still_unresolved_no_source_backed_alias` | 0 | 5 | 116 | `do_not_promote` | Hits are payload/formation/context only; no DTMonster row, DTmodel chain, or explicit alias rule. |
| 1100132 | `still_unresolved_no_source_backed_alias` | 0 | 5 | 116 | `do_not_promote` | Hits are payload/formation/context only; no DTMonster row, DTmodel chain, or explicit alias rule. |
| 1100133 | `still_unresolved_no_source_backed_alias` | 0 | 5 | 116 | `do_not_promote` | Hits are payload/formation/context only; no DTMonster row, DTmodel chain, or explicit alias rule. |

## Key Findings

- No unresolved enemy id has a direct authoritative DTMonster row or DTmodel/prefab actor chain in this trace.
- Hits for unresolved ids are payload/formation context, derived reports/manifests, skill ownership rows, or weak string references.
- Same-family/base rows such as `1100111` and model `3001` remain control/context only; no source rule maps unresolved payload ids to them.
- No replacement with `3001` was promoted.

## Outputs

- JSON: `reports/characters/CHARACTER_66_UNRESOLVED_ENEMY_ID_SOURCE_ALIAS_TRACE_NO_NETWORK_NO_PROMOTION_RESULT.json`
- Source hit CSV: `reports/characters/CHARACTER_66_UNRESOLVED_ENEMY_ID_SOURCE_ALIAS_TRACE_NO_NETWORK_NO_PROMOTION_RESULT_UNRESOLVED_ENEMY_ID_SOURCE_HIT_MATRIX.csv`
- Decision CSV: `reports/characters/CHARACTER_66_UNRESOLVED_ENEMY_ID_SOURCE_ALIAS_TRACE_NO_NETWORK_NO_PROMOTION_RESULT_ALIAS_PROMOTION_DECISION_MATRIX.csv`
- Proposal JSON: ``

## Command Policy

- rootCmdCount: `1`
- rootCmdFiles: `['00_COMMAND_CENTER.cmd']`
- restoreToolsDirectCmdCount: `0`
- policyOk: `True`

## Next Blocker

- Unresolved enemy payload ids need an authoritative DTMonster/DTmodel actor chain or explicit source alias rule; current hits remain payload/formation context or weak references.
