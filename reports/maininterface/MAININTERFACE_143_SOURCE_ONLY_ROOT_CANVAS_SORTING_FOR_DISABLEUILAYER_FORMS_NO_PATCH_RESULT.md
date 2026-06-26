# MAININTERFACE_143_SOURCE_ONLY_ROOT_CANVAS_SORTING_FOR_DISABLEUILAYER_FORMS_NO_PATCH

## Decision
- restoredClaim: false
- scenePatchApplied: false
- candidatePatchApplied: false
- patchDecision: trace_only_no_patch
- nativeCanvasRowsUnderTargetRoots: 64
- nativeCanvasComponentsUnderTargetRoots: 38
- rootCanvasSortingRecovered: true
- rootUIFormBaseDepthFieldsSerialized: false
- requiresRuntimeDumpForDepth: false
- requiresRuntimeValidationForDepth: true
- uiDockPromotionAllowed: false

## Findings
- Native Canvas-family components were found under target source roots; inspect the CSV before promoting any depth value.
- Root serialized components do not expose `UIFormBase.CurrCanvas`, `Depth`, or `GroupId`; prefab roots mainly expose LuaForm/page helper/GraphicRaycaster style data.
- Source root Canvas sorting values were recovered: UI_Dock=100, UI_Dock_old=100, UI_MainInterface=0, UI_MainInterface_old=0.
- No scene/candidate patch was made.

## Outputs
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_143_native_canvas_components_under_uidock_mainpage_roots.csv`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_143_root_form_serialized_component_matrix.csv`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_143_depth_input_source_availability_decision_matrix.csv`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_143_SOURCE_ONLY_ROOT_CANVAS_SORTING_FOR_DISABLEUILAYER_FORMS_NO_PATCH_RESULT.json`

## Next Blocker
- Next gate is a Unity candidate compile/import/capture validation using the recovered source root Canvas sorting values and UI142 renderer dependencies. Runtime dump is only required if source-backed candidate validation contradicts the expected depth behavior.