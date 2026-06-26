# CONTROL_TOWER_STATUS_20260626_050303

Generated: 2026-06-26 05:03:03 KST

## Control Tower Summary

- Active restore goal is not complete.
- UI144 completed source-backed Unity candidate validation.
- UI144 proves the real UI_Dock `sp_*` renderer import path works, but the candidate is not promoted because it still trails the safer UI128 reference metric baseline.
- Runtime dump/snapshot evidence is again required, now narrowed to production-equivalent UI_Dock parent/open-stack transform, mask, disable-layer depth behavior, and dynamic activity/chat/account/currency state.
- No APK/emulator/runtime instrumentation has been executed.
- Battle and character/data statuses are unchanged from previous control reports.

## UI144 Result

Primary outputs:

- `reports/maininterface/MAININTERFACE_144_SOURCE_BACKED_UIDOCK_RENDERER_AND_ROOT_CANVAS_DEPTH_CANDIDATE_VALIDATION_RESULT.md`
- `reports/maininterface/MAININTERFACE_144_SOURCE_BACKED_UIDOCK_RENDERER_AND_ROOT_CANVAS_DEPTH_CANDIDATE_VALIDATION_RESULT.json`
- `reports/maininterface/MAININTERFACE_144_reference_diff_region_metrics_vs_ui128_ui136_ui144.csv`
- `reports/maininterface/MAININTERFACE_144_reference_ui128_ui136_ui144_contact.png`
- `reports/maininterface/MAININTERFACE_144_source_backed_candidate_patch_action_matrix.csv`
- `reports/maininterface/MAININTERFACE_144_unity_compile_import_capture_validation_matrix.csv`
- `reports/maininterface/MAININTERFACE_144_uidock_sp_renderer_runtime_candidate_visibility_matrix.csv`
- `girlswar_maininterface_unity/Assets/RestoreCaptures/maininterface_ui144_uidock_renderer_rootcanvas_candidate_1680x720.png`

Key JSON result:

- `restoredClaim=false`
- `scenePatchApplied=true`
- `candidatePatchApplied=true`
- `patchDecision=candidate_saved_but_not_promoted`
- `sourceRootCanvasSortingApplied=true`
- `uiDockRendererDependenciesImported=true`
- `unityCompilePassed=true`
- `captureProduced=true`
- `diffImprovedAgainstUI128=false`
- `diffImprovedAgainstUI136=true`
- `uiDockPromotionAllowed=false`
- `uiBgRaycastPreserved=true`
- `guardedNodesPreserved=true`
- `fakeAssetsCreated=false`
- `requiresRuntimeDump=true`

UI144 capture:

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui144_uidock_renderer_rootcanvas_candidate_1680x720.png`
- Size: 1680x720
- Visible pixels: 1,209,600
- Unique colors: 237,169

## What UI144 Closed

- Damaged `.skel.txt` copies were replaced with raw clean-UnityFS `TextAsset` payload extraction for UI_Dock skeletons.
- `SP_Dock_1..7` and `spine_xiaoshou` imported into Unity as source-backed runtime Spine assets.
- Normal UI_Dock renderers attached as real `SkeletonGraphic` components:
  - `sp_mainpage`
  - `sp_camp`
  - `sp_bag`
  - `sp_expedition`
  - `sp_adventureInterface`
  - `sp_guild`
  - `sp_maincity`
  - `spine_xiaoshou`
- `dianjigq1` remains no-renderer.
- UI143 serialized root Canvas sorting was applied:
  - `UI_MainInterface_old=0`
  - `UI_Dock=100`
- `UI_bg` raycast/interactable guardrails were preserved.

## Diff Decision

Same-region pixel correlation versus the reference:

- Full screen:
  - UI128: `0.425589`
  - UI136: `0.211486`
  - UI144: `0.239859`
- Bottom nav:
  - UI128: `0.397542`
  - UI136: `0.121337`
  - UI144: `0.189647`
- Bottom Dock focus:
  - UI128: `0.519585`
  - UI136: `0.084202`
  - UI144: `0.165702`

Interpretation:

- UI144 is a real improvement over UI136 for Dock renderer reconstruction.
- UI144 still does not materially beat UI128 and therefore must not be promoted to the main restored UI.
- The current visual mismatch is no longer explained by missing Dock renderer dependencies alone.

## Current Main UI Blocker

Next required evidence:

- Production-equivalent `UI_Dock` parent/open-stack transform.
- Runtime-equivalent mask/stencil relationship around the Dock and route/world/activity nodes.
- Disable-layer depth behavior beyond source root Canvas sorting.
- Runtime/account snapshot for dynamic state:
  - activity/chat/account/currency visibility
  - route/world cluster active state
  - home normal-state overlays

Runtime dump is now justified by failed source-backed candidate promotion, but it must remain scoped and approved before any Android/emulator/APK/runtime instrumentation is attempted.

## Battle / Character Status

Unchanged:

- Battle actors visible/rendering source-backed 3/3.
- Battle HUD/raycast alive, but no original handler binding.
- No executable/importable xLua runtime locally.
- Battle final restored/playable screen is still false.
- Loadable character/actor manifest remains `1002`, `1034`, enemy `1100111 -> prefab/model 3001`.
- `1036` and several wave enemy payloads remain unresolved locally.

## Recommended Next Path

1. Preserve UI144 candidate as failed-to-promote evidence.
2. Do not merge/promote UI144 over UI128.
3. Ask user approval before any runtime instrumentation/emulator/APK dump.
4. If approval is granted, collect the minimal runtime state needed for UI_Dock open-stack parent/depth/mask and dynamic home-state visibility.
5. If runtime instrumentation is not approved, continue static source tracing for UI_Dock parent/open-stack and Lua home-state decisions, but treat it as lower confidence than runtime state.

No goal-complete claim is allowed until reference-aligned main UI and playable battle are both verified.
