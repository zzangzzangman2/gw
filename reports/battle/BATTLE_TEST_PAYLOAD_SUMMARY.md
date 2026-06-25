# Battle Test Payload Summary

## Source Evidence
- Procedure Lua: `girlswar_merged_extracted/decoded/xlua_battle/download_xlualogic_modules_procedure/-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua`
- Function line: `588`
- Embedded JSON line: `589`
- Decode assignment line: `590`

## Top-Level Values
- mapId: `11001`
- battleType: `1`
- randomSeed: `445106`
- fightResult: `1`
- waveCount: `3`

## Our Formation
| position | heroId | heroDid |
|---:|---:|---:|
| 1 | 51469 | 1036 |
| 2 | 50870 | 1002 |
| 3 | 50874 | 1034 |
| 4 | 0 |  |
| 5 | 0 |  |
| 6 | 0 |  |

## Enemy Waves
| wave | enemy heroDids | big rounds |
|---:|---|---:|
| 1 | `1100111, 1100112, 1100113` | 5 |
| 2 | `1100121, 1100122, 1100123` | 3 |
| 3 | `1100131, 1100132, 1100133` | 5 |

## Skills
- Unique payload skill ids: `20`
- Skill ids: `1001401, 1001403, 1002101, 1002201, 1002301, 1012101, 1012201, 1012301, 1012401, 1012403, 1034101, 1034201, 1034301, 1034401, 1034402, 1036101, 1036201, 1036301, 1036401, 1036402`

## Verification Snapshot
- Bundle references: `11/15` exist in assetbundle index.
- Skill datatable joins: `33` ok, `22` missing.
- Timeline prefab joins: `42` ok, `0` missing.
