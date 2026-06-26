# CONTROL_TOWER_STATUS_20260626_044917

Generated: 2026-06-26 04:49:17 KST

## Control Tower Summary

- Active restore goal is not complete.
- UI142 completed and closed the UI_Dock renderer dependency chain.
- Control tower ran UI143 source-only root Canvas/depth trace directly.
- UI144 has been delegated to the UI worker for source-backed Unity candidate validation.
- No APK/emulator/runtime instrumentation has been executed.
- Battle and character/data statuses are unchanged from the previous control report.

## UI143 Source-Only Depth Evidence

New outputs:

- `_restore_tools/scripts/maininterface143_source_root_canvas_sorting_trace.py`
- `reports/maininterface/MAININTERFACE_143_SOURCE_ONLY_ROOT_CANVAS_SORTING_FOR_DISABLEUILAYER_FORMS_NO_PATCH_RESULT.md`
- `reports/maininterface/MAININTERFACE_143_SOURCE_ONLY_ROOT_CANVAS_SORTING_FOR_DISABLEUILAYER_FORMS_NO_PATCH_RESULT.json`
- `reports/maininterface/MAININTERFACE_143_native_canvas_components_under_uidock_mainpage_roots.csv`
- `reports/maininterface/MAININTERFACE_143_root_form_serialized_component_matrix.csv`
- `reports/maininterface/MAININTERFACE_143_depth_input_source_availability_decision_matrix.csv`

Key result:

- `rootCanvasSortingRecovered=true`
- `requiresRuntimeDumpForDepth=false`
- `requiresRuntimeValidationForDepth=true`
- `uiDockPromotionAllowed=false`
- `scenePatchApplied=false`
- `candidatePatchApplied=false`

Recovered serialized source root Canvas sorting values from `download/ui/uiprefabandres/maininterface.assetbundle`:

- `UI_MainInterface=0`
- `UI_MainInterface_old=0`
- `UI_Dock=100`
- `UI_Dock_old=100`

Native Canvas evidence:

- 64 Canvas-family rows under target roots.
- 38 native `Canvas` components under target roots.
- Root Canvas rows:
  - `UI_MainInterface`: `m_RenderMode=1`, `m_OverrideSorting=False`, `m_SortingOrder=0`
  - `UI_MainInterface_old`: `m_RenderMode=1`, `m_OverrideSorting=False`, `m_SortingOrder=0`
  - `UI_Dock`: `m_RenderMode=1`, `m_OverrideSorting=False`, `m_SortingOrder=100`
  - `UI_Dock_old`: `m_RenderMode=1`, `m_OverrideSorting=False`, `m_SortingOrder=100`

Root serialized component evidence:

- Root components do not expose `UIFormBase.CurrCanvas`, `Depth`, or `GroupId`.
- Root prefab components are LuaForm-like, page helper, GraphicRaycaster-like, and UI action helper types.
- This fits UI140/UI141: `DisableUILayer=1` forms bypass group cursor sorting, so prefab root Canvas sorting is now the strongest source-only candidate for disabled-layer form depth.

Interpretation:

- The previous blocker was too broad. Runtime dump is no longer the first required step for depth.
- Next gate is a Unity candidate validation using source values:
  - `UI_MainInterface sortingOrder=0`
  - `UI_Dock sortingOrder=100`
- Runtime dump is still useful only if source-backed candidate behavior contradicts expected production depth.

## UI142 Renderer Evidence Still Applies

Renderer-only dependency chain is closed:

- `rendererDependencyChainRecovered=true`
- `skeletonDataAssetsResolved=true`
- `materialsResolved=true`
- `texturesOrAtlasResolved=true`
- `unityProjectSpineRuntimeAvailable=true`
- `futureSourceBackedRendererPatchFeasible=true`

UI142 dependency matrix:

- 80 dependency rows.
- All 80 are `resolved_object`.
- Types: `Material=40`, `MonoBehaviour=16`, `TextAsset=16`, `Texture2D=8`.

Normal `UI_Dock` renderer nodes:

- `sp_mainpage`
- `sp_camp`
- `sp_bag`
- `sp_expedition`
- `sp_adventureInterface`
- `sp_guild`
- `sp_maincity`
- `spine_xiaoshou`

Control:

- `dianjigq1` remains no-renderer.

## UI144 Delegation

Sent to UI worker thread:

- `MAININTERFACE_144_SOURCE_BACKED_UIDOCK_RENDERER_AND_ROOT_CANVAS_DEPTH_CANDIDATE_VALIDATION`

UI144 allowed scope:

- May patch a Unity candidate/editor reconstruction only if every change is source-backed by UI142/UI143.
- Must use root Canvas sorting:
  - `UI_MainInterface=0`
  - `UI_Dock=100`
- Must use real UI_Dock `sp_*` renderer dependencies from UI142.
- Must run Unity compile/import validation.
- Must produce capture/diff if candidate builds.

UI144 forbidden:

- fake HUD/card/icon/text/spine
- screenshot/atlas/whole-atlas/transparent overlay
- coordinate-only success
- hiding guarded zhuye/route/world/activity/discord/account/chat nodes
- altering `UI_bg` raycast/interactable
- `Painting_1005_back` promotion
- APK/emulator/runtime instrumentation
- external package/tool install
- battle/character implementation edits

## Current Recommended Path

Wait for UI144:

- If UI144 compile/import/capture succeeds and diff improves, continue toward source-backed MainInterface patch validation.
- If UI144 fails or worsens capture, preserve the failed candidate evidence and then decide whether runtime dump is necessary.

No goal-complete claim is allowed until reference-aligned main UI and playable battle are verified.
