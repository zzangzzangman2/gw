# CONTROL_TOWER_UNIFIED_PRE_RUNTIME_APPROVAL_PACKET_20260626_093259

## Purpose

This packet consolidates the current MainInterface, Battle, and Character blockers into one pre-runtime approval checklist.

Creation of this file does not grant approval and does not execute instrumentation. It is a control-tower handoff artifact for the next safe step.

## Safety State

- Runtime executed by this packet: `false`
- Scene patched by this packet: `false`
- Package imported by this packet: `false`
- External xLua imported by this packet: `false`
- Fake values allowed: `false`
- Coordinate-only patch allowed: `false`

## Source Artifacts

- Battle result: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_75_ORIGINAL_RUNTIME_SNAPSHOT_APPROVAL_PACKET_FOR_UI_NORMALBATTLE_ROUTE_TMP_MASK_HANDLER_AFTER_B74_NO_EXECUTION_NO_PATCH_RESULT.json`
- Battle approval template: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_75_ORIGINAL_RUNTIME_SNAPSHOT_APPROVAL_PACKET_FOR_UI_NORMALBATTLE_ROUTE_TMP_MASK_HANDLER_AFTER_B74_NO_EXECUTION_NO_PATCH_APPROVAL_PACKET_TEMPLATE.json`
- Battle hook matrix: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_75_ORIGINAL_RUNTIME_SNAPSHOT_APPROVAL_PACKET_FOR_UI_NORMALBATTLE_ROUTE_TMP_MASK_HANDLER_AFTER_B74_NO_EXECUTION_NO_PATCH_HOOK_SOURCE_CANDIDATE_MATRIX.csv`
- MainInterface result: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_148_RUNTIME_SNAPSHOT_APPROVAL_PACKET_AND_STATIC_FIELD_EXHAUSTION_NO_RUNTIME_NO_PATCH_RESULT.json`
- MainInterface approval template: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_148_RUNTIME_SNAPSHOT_APPROVAL_PACKET_AND_STATIC_FIELD_EXHAUSTION_NO_RUNTIME_NO_PATCH_approval_packet_template.json`
- Character result: `C:\Users\godho\Downloads\girlswar\reports\characters\CHARACTER_66_UNRESOLVED_ENEMY_ID_SOURCE_ALIAS_TRACE_NO_NETWORK_NO_PROMOTION_RESULT.json`
- Control gate: `C:\Users\godho\Downloads\girlswar\reports\CONTROL_TOWER_RUNTIME_APPROVAL_GATE_20260626_072517.md`

## Battle Approval Scope

- B75 deduplicated runtime fields: `7337`
- Required fields: `5133`
- Component rehydration fields: `2204`
- Handler/lifecycle fields: `148`
- Hook candidates: `12`
- Source-backed static patch candidates now: `0`

Battle approval would allow observing original `UI_NormalBattle` runtime state only:

- route active state after original `Open` / `Refresh` lifecycle;
- sibling order and right rail button state;
- TMP font/material/autosize and mask/stencil/component rehydration state;
- original Lua/GameEntry/ModulesInit handler lifecycle and button delegate binding state.

This scope does not approve external xLua import, package edits, fake handlers, or canonical scene overwrite.

## MainInterface Approval Scope

- UI148 required runtime fields: `197`
- Static known fields: `8`
- Statically inferable new fields: `0`
- Forbidden guess fields: `197`

MainInterface approval would allow observing:

- `UI_Dock` / `UI_MainPage` parent/group/depth/form stack;
- root Canvas, CanvasGroup, and `YouYouCanvasHelper` depth cascade;
- guarded route/world/zhuye/activity/chat/account/currency active and sibling state;
- `UI_bg` raycast/interactable state;
- runtime TMP/material/mask/stencil renderer state.

This scope does not approve arbitrary hiding of guarded nodes or fake dynamic account/activity values.

## Character Input Needed

CHARACTER66 still has no source-backed alias promotion path:

- Unresolved ids: `1100112`, `1100113`, `1100121`, `1100122`, `1100123`, `1100131`, `1100132`, `1100133`
- Source hits found: `1095`
- Source-backed aliases found: `0`

Needed evidence:

- authoritative DTMonster/DTmodel actor-chain evidence;
- explicit source alias rule for unresolved payload ids;
- missing exact `1036` battle actor bundle or source-backed equivalent.

## Allowed After Explicit Approval

- Collect original runtime snapshot or dump values for UI148 and B75 packet fields.
- Use captured values to decide source-backed scene/UI patches.
- Validate patched candidate captures against the reference image and `참고.mp4` as auxiliary evidence.

## Still Forbidden Without Separate Approval

- APK or emulator runtime instrumentation beyond the approved snapshot scope.
- External xLua import or package/manifest modification.
- Fake HUD/card/icon/text/spine/effect/actor/handler creation.
- Screenshot or atlas paste restoration.
- Coordinate-only success claim.

## Recommended Approval Text

`Approve original runtime snapshot/dump for UI148 and B75 approval packets only. Do not import external xLua, do not modify packages/manifests, do not create fake handlers/assets, and do not overwrite canonical scenes without a separate patch review.`
