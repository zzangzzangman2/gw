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

| metric | before | v1 | v2 | v3 (final, all lanes) |
| --- | ---: | ---: | ---: | ---: |
| expectedFields | 7337 | 7337 | 7337 | 7337 |
| filledRuntimeValues | 0 | 427 | 2681 | **5422** |
| missingRuntimeValues | 7337 | 6910 | 4656 | **1915** |
| placeholderRuntimeValues | 0 | 0 | 0 | **0** |
| values with mojibake | - | - | - | **0** |
| templateMode (empty template) | True | False | False | **False** |

**74% of the battle checklist is now source-backed**, zero fake/placeholder/garbage values.
Every filled value carries `staticSource` provenance (origin index + bundle + path_id).

## All four lanes executed

- **Lane 1 — crosswalk (rect + sibling)**: longest-suffix father_id crosswalk.
  `rect_transform` **2298 / 2356**, `sibling_order` **383 / 390**.
- **Lane 3 — component index**: built `_restore_tools/scripts/build_ui_component_index.py`
  -> `girlswar_merged_extracted/indexes/ui_components.csv` (118,953 GameObject rows from
  the pre-exported `structure.jsonl.gz` typetrees, joined GameObject->components). Joined
  to each node by `rect.game_object_id == component.go_path_id` (exact, no re-matching).
  Fills `graphic_image_button_raycast` **777** (graphicEnabled, raycastTarget,
  buttonInteractable, imageSprite, graphicMaterial, showMaskGraphic),
  `mask_rectmask_stencil_material` **361** (hasMask, maskType, maskEnabled),
  `tmp_autosize_font_material` **609** (fontSize/min/max, enableAutoSizing,
  characterSpacing, fontAsset, tmpEnabled, tmpMaterial, tmpRaycastTarget, tmpColor),
  `component_rehydration` **130** (componentTypes, missingScriptCount).
- **Lane 4 — UI_NormalBattle form Lua decode**: added `maincity.assetbundle` to
  `battle_extract_decode_xlua.py` TARGETS and decoded the full UI_NormalBattle form family
  (6 files, e.g. `decoded/xlua_battle/download_xlualogic_modules_maincity/874003978109174219_UI_NormalBattle_security_xor_raw.lua`).
  `active_chain` **842** filled from the original prefab serialized `game_object_active`
  (activeSelf / activeInHierarchy / parentActiveChain via the father chain).
- **Lane 2 — text: deliberately NOT filled** (both `ui_texts.csv` and the typetree
  `m_text` have CJK encoding corruption + effect-param noise; would break the no-garbage
  guardrail). Font metrics ARE filled; only the display-text strings are withheld.

### Note on active_chain provenance

`activeSelf`/`activeInHierarchy` are filled from the ORIGINAL prefab serialized active
flag, not a live runtime snapshot. The decoded UI_NormalBattle form Lua shows many nodes
are toggled BOTH true and false at different lifecycle points (e.g. btnPause true x7 /
false x11), so a single steady-state value cannot be derived from Lua — the prefab
serialized flag is the correct deterministic default. The decoded form Lua is delivered as
the source for the next refinement (per-state active + handler binding), not auto-filled.

## Honest residual (1915)

- `graphic_image_button_raycast` ~1003 — buttonTargetGraphicPath, tmpAlpha, and graphic
  fields on nodes whose graphic is not a plain Image; need finer per-component resolution.
- `tmp_autosize_font_material` ~324 — tmpAlpha and a few unmatched metrics.
- `handler_lua_lifecycle` 148 — genuinely needs handler binding parsed from the now-decoded
  UI_NormalBattle form Lua (next step), not a runtime dump.
- `other_runtime_state` 113, `active_chain` ~100 (component `enabled`), `rect_transform` 58
  (the ambiguous nodes), `mask` 50, `battle_payload_related_ui` 30 (runtime/account),
  `canvas` 16, `sibling` 7, `component_rehydration` 2.

None of the residual requires a live runtime dump for STRUCTURE; the account/content slice
(payload, chat, currency) is genuinely runtime and does not block the structural restore.
