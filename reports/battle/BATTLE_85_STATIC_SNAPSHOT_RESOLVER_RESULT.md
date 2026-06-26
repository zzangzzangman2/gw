# BATTLE_85_STATIC_SNAPSHOT_RESOLVER_RESULT

Generated: 2026-06-26 KST
Follows: `reports/STATIC_SNAPSHOT_RECOVERY_FINDING_20260626.md`, BATTLE_84 (filled snapshot consumer).

## What this pass did

Built `_restore_tools/scripts/control_tower_static_snapshot_resolver.py` (v2) and ran it
to fill `runtimeValue` in the B75 battle field checklist from ORIGINAL extracted indexes.

Lane-1 crosswalk (the key upgrade over v1): each B75 objectPath is matched to an original
node by reconstructing every original node's full path via `father_id` chains, then taking
the LONGEST trailing path-suffix of the B75 path that uniquely matches an original
full-path suffix. This anchors reconstruction-specific parents on preserved original
ancestors (`root_battle/BottomCenter/HeroListContainer/.../imgMask`). v1 (leaf-name only)
resolved 58/390 rect nodes; v2 resolves 383/390.

Output filled snapshot: `girlswar_battle_unity/Assets/RestoreData/battle/BATTLE_84_ORIGINAL_RUNTIME_SNAPSHOT_FILLED.json`
Provenance: `reports/battle/BATTLE_85_STATIC_SNAPSHOT_RESOLVER_PROVENANCE.csv`

## Validator result (official)

`control_tower_validate_runtime_snapshot_packets.py --battle-template <FILLED>`:

| metric | before | v1 | v2 (this) |
| --- | ---: | ---: | ---: |
| expectedFields | 7337 | 7337 | 7337 |
| filledRuntimeValues | 0 | 427 | **2681** |
| missingRuntimeValues | 7337 | 6910 | **4656** |
| placeholderRuntimeValues | 0 | 0 | **0** |
| templateMode (empty template) | True | False | **False** |

No fake/placeholder values introduced (placeholderRuntimeValues = 0). All filled values
carry `staticSource` provenance (origin index + bundle + path_id + suffix-match length).

## Filled categories (all index-provenanced)

- `rect_transform`: **2298 / 2356** (anchorMin/Max, anchoredPosition, sizeDelta, pivot, localScale)
- `sibling_order`: **383 / 390** (siblingIndex from father child_ids order)

These two categories are essentially closed (97% / 98%).

## Lane 2 (text) deliberately NOT filled

`ui_texts.csv` `m_text` mixes real display text with effect/material param strings
(`EPM_wuxiaoguo_dongtai`, `riyu_zi_dazei`, ...) and has CJK encoding corruption.
Filling `text` from it would violate the no-fake/no-garbage guardrail, so it is skipped.
Real display text must come from the lane-3 component extraction (the node's actual TMP
component), not this index.

## Honest residual (4656) and how to close it

The finding doc's ~80-90% conflated "category has a static source somewhere" with "this
row is safely auto-fillable." v2 closes the two categories that the existing indexes fully
support. The remaining 4656 need NEW static extractions (still no live runtime dump):

1. **Component/mask/material/sprite index (lane 3)** — `graphic_image_button_raycast`
   (1780), `mask_rectmask_stencil_material` (411), `component_rehydration` (132),
   `tmp_*` font metrics (~933). The existing `unity_objects.csv` has component type +
   path_id but NO component->GameObject link, so a UnityPy re-parse of the raw bundles is
   required to emit per-GameObject component lists, sprite/material refs, and mask flags.
2. **UI_NormalBattle form Lua decode (lane 4)** — `active_chain` (942),
   `handler_lua_lifecycle` (148). The form script was not in the decoded batch; decode it
   with the same xor pipeline used for UI_Dock/UI_MainPage.
3. **Genuinely runtime/account** — `battle_payload_related_ui` (52) and similar content
   (chat, currency, redpoint). Not layout; does not block structural restore.

Lane 3/4 tooling feasibility is being assessed separately (UnityPy availability + raw
bundle presence + the existing decode script).
