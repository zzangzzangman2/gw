# BATTLE_SAMPLE_ASSET_MANIFEST_RESULT

Generated: 2026-06-26T16:26:40.609846+00:00
Manifest: `girlswar_battle_unity/Assets/RestoreData/battle/BATTLE_SAMPLE_ASSET_MANIFEST.json`

## Summary

- pass: `true`
- actor count: `12`
- loadable actor ids: `[1002, 1034, 1100111]`
- unresolved/missing actor ids: `[1036, 1100112, 1100113, 1100121, 1100122, 1100123, 1100131, 1100132, 1100133]`
- status counts: `{'loadable': 3, 'not_fetchable_local': 1, 'unresolved_enemy_payload_instance': 8}`

## Actors

| heroDid | side | model/prefab | actor bundle | status | skeleton | atlas | texture count | missing |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `1036` | `our` | `1036/1036` | `download/roleprefabsandres/battleprefabandres/1036.assetbundle` | `not_fetchable_local` | `` | `` | `1` | `actor_bundle_missing_from_assetbundle_index, spine_skeleton_missing, spine_atlas_missing` |
| `1002` | `our` | `1002/1002` | `download/roleprefabsandres/battleprefabandres/1002.assetbundle` | `loadable` | `extracted/unity/bundles/b_a11e4439fd9a0a50/textassets/1665224429881118700_1002.skel.txt` | `extracted/unity/bundles/b_a11e4439fd9a0a50/textassets/3373340142783789617_1002.atlas.txt` | `1` | `` |
| `1034` | `our` | `1034/1034` | `download/roleprefabsandres/battleprefabandres/1034.assetbundle` | `loadable` | `extracted/unity/bundles/b_da97dc9c8e06fcb3/textassets/-3260164475778644329_1034.skel.txt` | `extracted/unity/bundles/b_da97dc9c8e06fcb3/textassets/9008888806324543472_1034.atlas.txt` | `1` | `` |
| `1100111` | `enemy` | `3001/3001` | `download/roleprefabsandres/battleprefabandres/3001.assetbundle` | `loadable` | `extracted/unity/bundles/b_5a764c3b78a2386a/textassets/-756768513637643680_3001.skel.txt` | `extracted/unity/bundles/b_5a764c3b78a2386a/textassets/-3102365806415234313_3001.atlas.txt` | `1` | `` |
| `1100112` | `enemy` | `/` | `` | `unresolved_enemy_payload_instance` | `` | `` | `0` | `actor_bundle_unresolved, spine_skeleton_missing, spine_atlas_missing, spine_texture_missing` |
| `1100113` | `enemy` | `/` | `` | `unresolved_enemy_payload_instance` | `` | `` | `0` | `actor_bundle_unresolved, spine_skeleton_missing, spine_atlas_missing, spine_texture_missing` |
| `1100121` | `enemy` | `/` | `` | `unresolved_enemy_payload_instance` | `` | `` | `0` | `actor_bundle_unresolved, spine_skeleton_missing, spine_atlas_missing, spine_texture_missing` |
| `1100122` | `enemy` | `/` | `` | `unresolved_enemy_payload_instance` | `` | `` | `0` | `actor_bundle_unresolved, spine_skeleton_missing, spine_atlas_missing, spine_texture_missing` |
| `1100123` | `enemy` | `/` | `` | `unresolved_enemy_payload_instance` | `` | `` | `0` | `actor_bundle_unresolved, spine_skeleton_missing, spine_atlas_missing, spine_texture_missing` |
| `1100131` | `enemy` | `/` | `` | `unresolved_enemy_payload_instance` | `` | `` | `0` | `actor_bundle_unresolved, spine_skeleton_missing, spine_atlas_missing, spine_texture_missing` |
| `1100132` | `enemy` | `/` | `` | `unresolved_enemy_payload_instance` | `` | `` | `0` | `actor_bundle_unresolved, spine_skeleton_missing, spine_atlas_missing, spine_texture_missing` |
| `1100133` | `enemy` | `/` | `` | `unresolved_enemy_payload_instance` | `` | `` | `0` | `actor_bundle_unresolved, spine_skeleton_missing, spine_atlas_missing, spine_texture_missing` |

## Findings

- 1036 actor bundle remains missing locally, but its skill timeline rows resolve as data-only because owner actor is unavailable.
- 1002, 1034, and enemy 1100111/3001 have loadable actor bundles with skeleton, atlas, and texture evidence.
- Enemy payload ids 1100112, 1100113, 1100121, 1100122, 1100123, 1100131, 1100132, and 1100133 remain unresolved actor instances in local source evidence.
