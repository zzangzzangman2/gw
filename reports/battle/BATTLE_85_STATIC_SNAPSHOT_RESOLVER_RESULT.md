# BATTLE_85_STATIC_SNAPSHOT_RESOLVER_RESULT

Generated: 2026-06-26 KST
Follows: `reports/STATIC_SNAPSHOT_RECOVERY_FINDING_20260626.md`, BATTLE_84 (filled snapshot consumer).

## What this pass did

Built `_restore_tools/scripts/control_tower_static_snapshot_resolver.py` and ran it to
fill `runtimeValue` in the B75 battle field checklist from the ORIGINAL extracted
RectTransform index `girlswar_merged_extracted/indexes/ui_recttransforms.csv` only.

Output filled snapshot: `girlswar_battle_unity/Assets/RestoreData/battle/BATTLE_84_ORIGINAL_RUNTIME_SNAPSHOT_FILLED.json`
Provenance: `reports/battle/BATTLE_85_STATIC_SNAPSHOT_RESOLVER_PROVENANCE.csv`

## Validator result (official)

`control_tower_validate_runtime_snapshot_packets.py --battle-template <FILLED>`:

| metric | before | after |
| --- | ---: | ---: |
| expectedFields | 7337 | 7337 |
| filledRuntimeValues | 0 | **427** |
| missingRuntimeValues | 7337 | **6910** |
| placeholderRuntimeValues | 0 | **0** |
| templateMode (empty template) | True | **False** |
| blockingReason | "battle runtime values are not filled" | "battle snapshot needs source/approval review before patch" |

First time the battle packet holds source-backed runtime values. No fake/placeholder
values were introduced (placeholderRuntimeValues = 0). The packet left the empty-template
state and entered the source/review state.

## Filled categories (all CSV-provenanced)

- `rect_transform`: 366 (anchorMin/Max, anchoredPosition, sizeDelta, pivot, localScale)
- `sibling_order`: 61 (siblingIndex derived from father child_ids order)

## Guardrail discipline (why only 427, not the optimistic 80-90%)

The finding doc estimated ~80-90% statically derivable. That estimate conflated
"this category has a static source somewhere" with "this exact row can be auto-filled
safely." Under the project's no-wrong-value rule, this pass only filled a row when the
node's leaf name resolved to an UNAMBIGUOUS original geometry (exactly one original node
with that name, or all same-named nodes sharing identical geometry). That is the correct,
conservative line. The 6,910 residual breaks down as:

1. **Ambiguous geometry** — leaf name maps to multiple original nodes with different
   geometry (cannot pick one without a hierarchy crosswalk). Recoverable later by mapping
   the reconstruction node's ORIGINAL prefab path, not just its leaf name.
2. **Not in the RectTransform index** — `tmp_autosize_font_material` (997),
   `mask_rectmask_stencil_material` (411), `graphic_image_button_raycast` (1780),
   `component_rehydration` (132). These ARE static but live in other extractions
   (TMP/text fields, component/material tables, sprite atlas), not in ui_recttransforms.csv.
3. **Genuinely runtime/handler** — `active_chain` (942), `handler_lua_lifecycle` (148),
   `battle_payload_related_ui` (52). Active state depends on Lua SetActive logic; handler
   binding needs the form Lua / GameEntry lifecycle.

## Conclusion

Static recovery is real and now demonstrated end-to-end with a validator-confirmed,
zero-fake flip — but the safe auto-fillable fraction from a single index is ~6%, not 80%.
Reaching the rest is still static (no live runtime dump needed) but requires more
extraction lanes, in priority order:

1. **Original-prefab hierarchy crosswalk**: map each reconstruction node
   (e.g. `Battle29BoundHeroCard_*/imgMask`) to its ORIGINAL prefab path so ambiguous
   leaf names resolve uniquely. Unlocks most of bucket (1) in rect_transform/sibling.
2. **TMP/text + font index**: extract text/fontSize/fontAsset/autosize from the original
   UI prefab TextMeshPro components -> fills `tmp_autosize_font_material` (997).
3. **Component/mask/material index**: extract Mask/RectMask2D/stencil/material/sprite from
   the original prefab -> fills `mask_*` (411) and most of `graphic_*` (1780).
4. **UI_NormalBattle form Lua decode** (noted gap): per-node active/refresh logic for
   `active_chain` (942) and `handler_lua_lifecycle` (148).

Account/server content (chat, currency, redpoint, payload) remains genuinely runtime and
does not block structural restore.
