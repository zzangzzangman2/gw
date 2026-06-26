# MAININTERFACE_142_SOURCE_RENDERER_RECONSTRUCTION_FEASIBILITY_NO_PATCH

## Decision
- restoredClaim: false
- scenePatchApplied: false
- candidatePatchApplied: false
- patchDecision: trace_only_no_patch
- rendererDependencyChainRecovered: true
- skeletonDataAssetsResolved: true
- materialsResolved: true
- texturesOrAtlasResolved: true
- unityProjectSpineRuntimeAvailable: true
- futureSourceBackedRendererPatchFeasible: true
- rendererPatchAllowedNow: false
- uiDockPromotionAllowed: false
- requiresRuntimeDumpForDepth: true

## Findings
- Normal `UI_Dock` source bindings for `sp_mainpage`, `sp_camp`, `sp_bag`, `sp_expedition`, `sp_adventureInterface`, `sp_guild`, `sp_maincity`, and `spine_xiaoshou` resolve to real `SkeletonGraphic + UISpineCtr` components. `dianjigq1` remains a no-renderer control.
- `SkeletonGraphic` serialized fields are readable from `maininterface.assetbundle`: starting animation/loop, `skeletonDataAsset`, material refs, `m_RaycastTarget`, `m_Maskable`, color, mesh generator settings, and blend material refs are captured in the component matrix.
- `SkeletonDataAsset` refs resolve through `maininterface_external_dependencies.csv` to local bundles: dock icons mostly use `maininterface_ext_1.assetbundle`; `spine_xiaoshou` uses `guide.assetbundle`.
- The common `m_Material` refs resolve to `download/commonprefabsandres/spinematandshaders.assetbundle`; atlas-specific materials/textures resolve in their owning skeleton bundles.
- The Unity reconstruction project contains the Spine runtime source and SkeletonGraphic materials/shaders needed for a future source-backed renderer import path.
- This does not allow UI_Dock promotion yet: UI140/UI141 depth evidence still requires the runtime/default parent `CurrCanvas.sortingOrder` for `DisableUILayer=1` forms, and UI136 showed simple sibling mounting worsens the reference diff.

## Row Counts
- renderer component field matrix: 9
- dependency resolution matrix: 80
- project feasibility matrix: 9
- future patch/blocker matrix: 3

## Outputs
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_142_uidock_normal_sp_renderer_component_field_matrix.csv`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_142_skeletondata_material_atlas_texture_dependency_resolution_matrix.csv`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_142_unity_project_spine_runtime_import_feasibility_matrix.csv`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_142_future_patch_proposal_vs_blocker_decision_matrix.csv`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_142_SOURCE_RENDERER_RECONSTRUCTION_FEASIBILITY_NO_PATCH_RESULT.json`

## Next Blocker
Need runtime or source-backed `UI_Dock`/`UI_MainPage` parent `CurrCanvas.sortingOrder`/depth for `DisableUILayer=1` forms, then a Unity compile/import validation pass for the now-traced source renderer dependencies. No scene/candidate patch was made.
