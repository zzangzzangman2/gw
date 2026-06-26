# Control Tower Status - 2026-06-26 03:54 KST

## Current State
- Project: `C:\Users\godho\Downloads\girlswar`
- `참고.mp4`: analyzed as auxiliary visual/motion reference only
- `플레이.mp4`: missing
- root `.cmd`: `1`
- `_restore_tools` direct `.cmd`: `0`
- Final restore claim: still forbidden

## Video Reference
- Outputs:
  - `reports\video_reference\REFERENCE_MP4_RESTORE_NOTES_20260626_024037.md`
  - `reports\video_reference\reference_overview_10s_contact.jpg`
  - `reports\video_reference\reference_frames\frame_000s.jpg` through `frame_120s.jpg`
- Metadata: about 121.28s, 1280x570, 30fps
- Use: visual/motion/layout reference only, not runtime/account/xLua evidence

## Battle
### BATTLE59 Completed
- Result:
  - `patchDecision=blocked_no_patch`
  - `sceneSaved=false`
  - `sourceBackedBootstrapApplied=false`
  - `handlerBindingApplied=false`
  - `isFinalRestoredBattleScreen=false`
- Evidence:
  - Source-backed importable editor xLua runtime candidates: `0`
  - Executable xLua runtime available: `false`
  - GameEntry/LuaManager executable bootstrap available: `false`
  - BATTLE57 carryover: source-backed actors/render/pixel signal `3/3`
  - BATTLE58 carryover: direct raycast `5/5`, forced EventSystem `5/5`, handler bound `0`, Lua lifecycle `0`
- Decision boundary:
  - `requires_original_xlua_runtime_or_user_approved_external_xlua_and_full_payload_gaps`
  - No fake handlers, dummy Lua, stub GameEntry/LuaManager, or no-op success handlers.
  - No external xLua/package import without explicit user approval.

## MainInterface UI
### UI136 Completed
- Main output:
  - `reports\maininterface\MAININTERFACE_136_TRACE_UIDOCK_OPEN_STACK_BOTTOM_NAV_CANDIDATE_NO_BACK_LAYER_PROMOTION_RESULT.md`
  - `reports\maininterface\MAININTERFACE_136_TRACE_UIDOCK_OPEN_STACK_BOTTOM_NAV_CANDIDATE_NO_BACK_LAYER_PROMOTION_RESULT.json`
  - `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui136_uidock_openstack_candidate_1680x720.png`
- Result:
  - `restoredClaim=false`
  - `sceneSaved=true`
  - `candidatePatchApplied=true`
  - `dockCandidateApplied=true`
  - `productionPatchApplied=false`
  - `patchDecision=candidate_uidock_openstack_sibling_form_applied_no_back_layer_no_dock_coordinate_patch`
- Guardrail checks:
  - `UI_bg_raycast_preserved=true`
  - baseline/final raycast: `true / true`
  - baseline/final interactable: `true / true`
  - UI135 `Painting_1005_back` was not carried forward.
- Dock default-state check:
  - `dockDefaultStateApplied=true`
  - `matchedToggleCount=7`
  - `onOffMismatchCount=0`
  - `toggle1/im_on=true`, `toggle1/im_off=false`
  - `toggle2..7/im_on=false`, `im_off=true`
  - `sp_*` animation recorded as `not_applicable_no_skeleton_component` where no real SkeletonGraphic component existed.
- Metrics:
  - UI128 bottom_nav corr: `0.395621`
  - UI136 bottom_nav corr: `0.120721`
  - Delta: `-0.2749`
  - UI128 full corr: `0.424216`
  - UI136 full corr: `0.210779`
  - Click validation: `55 / 45 / 43 / 2`
- Interpretation:
  - `UI_Dock` open-stack source evidence is strong.
  - The current source-built sibling mount is not a promotion candidate because visual/reference metrics worsen sharply.
  - Exact production form layer/order/animation/mask evidence is still required.

## Character / Payload Data
### Unresolved Enemy Deep Trace Completed
- Main output:
  - `reports\characters\CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_RESULT.md`
  - `reports\characters\CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_RESULT.json`
  - `reports\characters\CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_RESULT.csv`
- Target ids:
  - `1100112`, `1100113`, `1100121`, `1100122`, `1100123`, `1100131`, `1100132`, `1100133`
- Result:
  - target status counts: `{'not_resolved_from_local_evidence': 8}`
  - source-backed update proposals: `0`
  - proposal files written: `false`
- Control path rechecked:
  - `1100111` resolves through `DTMonster_KEntity` / `DTMonster_OEntity`
  - `modelId 3001 -> prefabId 3001`
  - `download/roleprefabsandres/battleprefabandres/3001.assetbundle`
  - local bundle exists: `true`
- Skill/timeline impact:
  - No actor resolve changed.
  - Existing enemy rows remain `data_only_missing_actor` / `passive_no_timeline`.
- Weak evidence note:
  - One raw little-endian integer hit in `il2cpp_native/global-metadata.dat` was recorded as weak evidence only.
  - It is not mapping evidence and was not used for promotion.
- 1036:
  - unchanged: `not_fetchable_local`

## Active Worker Status
- UI worker: idle after UI136.
- Battle worker: idle after BATTLE59.
- Character/data worker: idle after unresolved enemy deep trace.

## Next Decision Points
1. UI: trace exact production form layer/order and activity/account/chat runtime snapshot before any UI_Dock or activity-state promotion.
2. UI: do not hide activity/chat/account/route/world nodes or `btn_discord`; do not change `UI_bg` raycast/interactable without source evidence.
3. Battle: no further playable-restore claim without original xLua runtime or explicit approval for external xLua, plus full payload resource gaps.
4. Data: unresolved enemy ids stay unresolved until a DTMonster/DTmodel/prefab/bundle chain or authoritative alias is found.
