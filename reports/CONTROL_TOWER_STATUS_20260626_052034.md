# CONTROL_TOWER_STATUS_20260626_052034

Generated: 2026-06-26 05:20:34 KST

## Control Tower Summary

- Active restore goal is not complete.
- UI145 is complete and confirms no further source-backed static UI parent/mask/depth patch is available without runtime evidence.
- BATTLE60, CHARACTER_COMMON_SPEEDLINE, and BATTLE61 are complete.
- Local battle subset skill/resource evidence improved: common speedline gaps are source-backed resolved in a separate speedline-resolved manifest variant.
- Canonical `BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.*` was not overwritten.
- No APK/emulator/runtime instrumentation was executed.
- No xLua/runtime handler binding was added.

## UI Status

Latest UI result:

- `reports/maininterface/MAININTERFACE_145_STATIC_UIDOCK_OPENSTACK_PARENT_MASK_DEPTH_TRACE_NO_PATCH_RESULT.md`
- `reports/maininterface/MAININTERFACE_145_STATIC_UIDOCK_OPENSTACK_PARENT_MASK_DEPTH_TRACE_NO_PATCH_RESULT.json`

UI145 conclusions:

- `UI_Dock`, `UI_Dock_old`, `UI_MainInterface`, and `UI_MainInterface_old` are separate source prefab roots with `father_id=0`.
- Static source does not prove `UI_Dock` should be reparented under `UI_MainInterface_old`.
- Direct `Mask` / `RectMask2D` rows under Dock roots: `0`.
- Dock component-chain evidence exists for Canvas / CanvasGroup / CanvasRenderer / GraphicRaycaster / SkeletonGraphic style rows.
- `UI_Dock=100` source Canvas sorting is known, but exact runtime `CurrCanvas.sortingOrder`, `Depth`, and `OnDepthChanged` cascade remain unresolved.

Current UI blocker:

- Runtime-equivalent `UI_Dock` / `UI_MainPage` form parent/group object path.
- Effective root Canvas sorting and `UIFormBase.Depth`.
- `YouYouCanvasHelper.OnDepthChanged` cascade for `DisableUILayer=1`.
- Active runtime mask/stencil state, if any.
- UI130-compatible runtime/account snapshot for activity/chat/account/currency/route/world home state.

No UI restored claim is allowed.

## Battle Skill/Resource Progress

### BATTLE60

Outputs:

- `reports/battle/BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH_RESULT.md`
- `reports/battle/BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH_RESULT.json`
- `reports/battle/BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH_SKILL_TIMELINE_SOURCE_LOAD_VALIDATION.csv`
- `reports/battle/BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH_SKILL_PREFAB_COMPONENT_DEPENDENCY_REFS.csv`
- `reports/battle/BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH_BLOCKER_SEPARATION_MATRIX.csv`

Result:

- `restoredClaim=false`
- `playableClaim=false`
- `sceneSaved=false`
- `handlerBindingApplied=false`
- `xLuaRuntimeUsed=false`
- `sourceBackedSkillRowsChecked=12`
- `resourceCompleteSkillRowsVerified=4`
- `missingCommonDependencyRows=8`
- clean UnityFS bundle/asset/instantiate success: `12/12/12`

Important fix:

- `merged_content` skill files have `SyS` headers and are not directly readable by Unity AssetBundle API.
- BATTLE60 switched to clean UnityFS slices, matching the working BATTLE57 actor rehydrate path.

### Speedline Trace

Outputs:

- `reports/characters/CHARACTER_COMMON_SPEEDLINE_BUNDLE_DEEP_TRACE_RESULT.md`
- `reports/characters/CHARACTER_COMMON_SPEEDLINE_BUNDLE_DEEP_TRACE_RESULT.json`
- `reports/characters/CHARACTER_COMMON_SPEEDLINE_BUNDLE_DEEP_TRACE_RESULT.csv`
- `reports/characters/CHARACTER_COMMON_SPEEDLINE_AFFECTED_SKILL_ROWS.csv`
- `reports/battle/BATTLE_LOCAL_PLAYABLE_PAYLOAD_RESOURCE_UPDATE_PROPOSAL_FROM_SPEEDLINE_TRACE.json`
- `reports/battle/BATTLE_LOCAL_PLAYABLE_PAYLOAD_RESOURCE_UPDATE_PROPOSAL_FROM_SPEEDLINE_TRACE.csv`

Result:

- `pinkspeedline`: `resolved_loadable_local_bundle`
- `redspeedline`: `resolved_loadable_local_bundle`
- `yellospeedline`: `resolved_loadable_local_bundle`
- Exact child dependency strings are not standalone local bundles.
- Source-backed resolved parent bundle:
  - `download/commonprefabsandres/skilleffect/commonskillprefabsandres1.assetbundle`
- Parent bundle contains matching speedline prefab/container objects.
- `yellow` spelling was not used; source spelling remains `yello`.
- Proposal: 3 resource updates, 8 local subset skill promotions.

### BATTLE61

Outputs:

- `reports/battle/BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED.md`
- `reports/battle/BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED.json`
- `reports/battle/BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED.csv`
- `reports/battle/BATTLE_61_APPLY_SPEEDLINE_RESOURCE_UPDATE_PROPOSAL_TO_LOCAL_PLAYABLE_MANIFEST_AND_REVALIDATE_NO_XLUA_NO_HANDLER_PATCH_RESULT.md`
- `reports/battle/BATTLE_61_APPLY_SPEEDLINE_RESOURCE_UPDATE_PROPOSAL_TO_LOCAL_PLAYABLE_MANIFEST_AND_REVALIDATE_NO_XLUA_NO_HANDLER_PATCH_RESULT.json`
- `reports/battle/BATTLE_61_APPLY_SPEEDLINE_RESOURCE_UPDATE_PROPOSAL_TO_LOCAL_PLAYABLE_MANIFEST_AND_REVALIDATE_NO_XLUA_NO_HANDLER_PATCH_BEFORE_AFTER_STATUS_COUNTS.csv`
- `reports/battle/BATTLE_61_APPLY_SPEEDLINE_RESOURCE_UPDATE_PROPOSAL_TO_LOCAL_PLAYABLE_MANIFEST_AND_REVALIDATE_NO_XLUA_NO_HANDLER_PATCH_APPLIED_PROPOSAL_ROWS_AND_UNCHANGED_ACTOR_BLOCKERS.csv`
- `reports/battle/BATTLE_61_APPLY_SPEEDLINE_RESOURCE_UPDATE_PROPOSAL_TO_LOCAL_PLAYABLE_MANIFEST_AND_REVALIDATE_NO_XLUA_NO_HANDLER_PATCH_LOCAL_SUBSET_SKILL_RESOURCE_COMPLETENESS_VALIDATION.csv`

Result:

- `sourceBackedProposalApplied=true`
- `manifestVariantWritten=true`
- `canonicalManifestOverwritten=false`
- `sourceBackedSkillRowsChecked=12`
- local subset resource-complete skill rows: `4 -> 12`
- missing common dependency rows: `8 -> 0`
- skill status `loadable`: `4 -> 12`
- actor blockers unchanged.

## Current Battle Blocker

Battle is still not playable.

Remaining blockers:

- Original xLua/GameEntry/LuaManager runtime required for source-backed handlers.
- `1036` actor bundle remains `not_fetchable_local`.
- Enemy ids remain unresolved from local evidence:
  - `1100112`
  - `1100113`
  - `1100121`
  - `1100122`
  - `1100123`
  - `1100131`
  - `1100132`
  - `1100133`

Current strongest local playable subset evidence:

- Actors source-backed visible: `1002`, `1034`, enemy `3001`.
- Skill/timeline local subset resource completeness after speedline resolution: `12/12`.
- No handler/runtime claim.

## Recommended Next Path

1. Preserve `BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED.*` as the current source-backed local subset manifest variant.
2. Do not overwrite canonical manifest until the user or next control decision explicitly asks for canonical promotion.
3. Main UI remains blocked on runtime snapshot/dump evidence.
4. Battle remains blocked on original xLua/GameEntry handler runtime and full payload actor gaps.
5. If runtime work is approved later, scope it tightly:
   - UI form parent/depth/mask snapshot.
   - xLua/GameEntry/LuaManager handler feasibility.

No goal-complete claim is allowed until reference-aligned main UI and source-backed playable battle are both verified.
