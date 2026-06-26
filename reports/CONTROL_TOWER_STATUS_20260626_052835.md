# CONTROL_TOWER_STATUS_20260626_052835

Generated: 2026-06-26 05:28:35 KST

## Control Tower Summary

- Active restore goal is not complete.
- UI146 is complete. It produced the no-execution runtime snapshot/probe contract needed before any MainInterface patch decision.
- BATTLE62 is complete. It confirms the local subset skill AssetBundles can load and instantiate, but they produce no meaningful visual signal in the diagnostic camera without the original runtime/handler context.
- Character speedline resolution and BATTLE61 remain the strongest source-backed local subset resource baseline.
- No APK/emulator/original-runtime instrumentation was executed.
- No xLua/runtime handler binding was added.
- No restored UI or playable battle claim is allowed.

## UI Status

Latest UI result:

- `reports/maininterface/MAININTERFACE_146_RUNTIME_SNAPSHOT_PROBE_SPEC_AND_SOURCE_HOOK_POINTS_NO_EXECUTION_NO_PATCH_RESULT.md`
- `reports/maininterface/MAININTERFACE_146_RUNTIME_SNAPSHOT_PROBE_SPEC_AND_SOURCE_HOOK_POINTS_NO_EXECUTION_NO_PATCH_RESULT.json`
- `reports/maininterface/MAININTERFACE_146_runtime_snapshot_template.json`

UI146 result:

- `restoredClaim=false`
- `scenePatchApplied=false`
- `runtimeInstrumentationExecuted=false`
- `snapshotValuesInvented=false`
- `runtimeSnapshotTemplateWritten=true`
- `requiredRuntimeFieldsCount=197`
- `staticKnownFieldsCount=8`
- `approvalRequiredForRuntimeDump=true`
- `staticPatchPossibleWithoutRuntime=false`

Important hook points identified for a later approved runtime snapshot:

- `GameEntry.UI:OpenUIForm` / `YouYouUIManager.OpenUIForm`
- `UIFormBase.Open`
- `YouYouCanvasHelper.SetDepth` / `ResetRenderDepth`
- `UI_Dock.OnOpen`, `UI_Dock.initTab`, `UI_Dock.setCurrView`
- `UI_MainPage.OnOpen`
- UI130 replay import path for a filled snapshot

Current UI blocker:

- Need approved real runtime snapshot/dump for `UI_Dock` / `UI_MainPage` production parent/group/depth/CanvasHelper cascade.
- Need UI130-compatible runtime activity/account/chat/currency values.
- The guarded nodes and `UI_bg` raycast/interactable state remain forbidden to guess.

No source-backed static MainInterface patch is currently justified.

## Battle Status

### Source-backed local subset baseline

- Actors source-backed visible from BATTLE57: `1002`, `1034`, enemy `3001`.
- Speedline-resolved manifest variant from BATTLE61 keeps local subset skill resources complete: `12/12`.
- Canonical `BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.*` was not overwritten.

### BATTLE62

Latest battle result:

- `reports/battle/BATTLE_62_LOCAL_SUBSET_SOURCE_BACKED_SKILL_ACTIVATION_PROBE_NO_XLUA_NO_ORIGINAL_HANDLER_CLAIM_RESULT.md`
- `reports/battle/BATTLE_62_LOCAL_SUBSET_SOURCE_BACKED_SKILL_ACTIVATION_PROBE_NO_XLUA_NO_ORIGINAL_HANDLER_CLAIM_RESULT.json`
- `reports/battle/BATTLE_62_LOCAL_SUBSET_SOURCE_BACKED_SKILL_ACTIVATION_PROBE_NO_XLUA_NO_ORIGINAL_HANDLER_CLAIM_SKILL_ACTIVATION_PROBE_MATRIX.csv`
- `reports/battle/BATTLE_62_LOCAL_SUBSET_SOURCE_BACKED_SKILL_ACTIVATION_PROBE_NO_XLUA_NO_ORIGINAL_HANDLER_CLAIM_ACTOR_TARGET_ANCHOR_CONTEXT.csv`
- `reports/battle/BATTLE_62_LOCAL_SUBSET_SOURCE_BACKED_SKILL_ACTIVATION_PROBE_NO_XLUA_NO_ORIGINAL_HANDLER_CLAIM_DEPENDENCY_RUNTIME_COMPONENT_BLOCKERS.csv`
- `reports/battle/BATTLE_62_LOCAL_SUBSET_SOURCE_BACKED_SKILL_ACTIVATION_PROBE_NO_XLUA_NO_ORIGINAL_HANDLER_CLAIM_CANDIDATE_CLASSIFICATION_NEXT_ACTION.csv`

BATTLE62 result:

- `restoredClaim=false`
- `playableClaim=false`
- `originalHandlerBindingClaim=false`
- `sceneSaved=false`
- `xLuaRuntimeUsed=false`
- `sourceBackedSkillRowsChecked=12`
- `skillPrefabsLoaded=12`
- `skillPrefabsInstantiated=12`
- `skillRowsWithVisualSignal=0`
- `actorsVisibleDuringProbe=3`
- `diagnosticCaptureProduced=false`
- `sourceBackedSkillActivationProbeFeasible=true`

BATTLE62 classification:

- All 12 rows are `skill_asset_load_only_no_visual_signal`.
- The probe is useful as source-backed asset load evidence only.
- It is not original handler restoration and not final playability.

Observed runtime/editor issue:

- Unity logged `PlayableAsset type mismatch: TimelineAsset does not inherit from PlayableAsset` during `PlayableDirector.Evaluate`.
- This points the next investigation toward timeline asset type/binding/exposed-reference/runtime BattleManager requirements instead of raw AssetBundle availability.

## Remaining Battle Blockers

- Original xLua/GameEntry/LuaManager runtime remains required for true source-backed input/playability.
- Full payload actor gaps remain unchanged:
  - `1036` actor is still `not_fetchable_local`.
  - Enemy ids unresolved from local evidence:
    - `1100112`
    - `1100113`
    - `1100121`
    - `1100122`
    - `1100123`
    - `1100131`
    - `1100132`
    - `1100133`
- Skill prefabs now load/instantiate, but visual activation is blocked by missing original runtime/timeline binding context.

## Recommended Next Path

1. Battle next: trace the 12 local subset skill prefabs at the `PlayableDirector` / `TimelineAsset` / exposed-reference / binding level and classify what original runtime objects are required for visible activation.
2. Character next: continue source-only actor bundle resolution for `1036` and unresolved enemy ids, keeping local evidence separate from versionfile/CDN-only evidence.
3. UI next: do not patch MainInterface until a real approved runtime snapshot fills the UI146 template.
4. Preserve `BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED.*` as the current source-backed local subset manifest variant.

No goal-complete claim is allowed until reference-aligned MainInterface and a source-backed playable battle are both verified.
