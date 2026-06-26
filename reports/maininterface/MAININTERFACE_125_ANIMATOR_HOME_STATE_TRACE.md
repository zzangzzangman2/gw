# MAININTERFACE_125_ANIMATOR_HOME_STATE_TRACE

- generatedAt: 2026-06-26 01:31:19
- restoredClaim: false
- source main bundle: `C:/Users/godho/Downloads/girlswar/girlswar_merged_extracted/extracted/unity/clean_unityfs_slices/download/ui/uiprefabandres/maininterface.assetbundle`
- source animator bundle: `C:/Users/godho/Downloads/girlswar/girlswar_merged_extracted/extracted/unity/clean_unityfs_slices/download/ui/uiprefabandres/maininterface_ext_4.assetbundle`
- binding CSV: `Assets/RestoreData/reports/maininterface_125_animator_home_state_bindings.csv`
- json: `Assets/RestoreData/maininterface_125_animator_home_state_trace.json`
- routeRelatedBindingCount: 0

## Conclusions
- UI_MainInterface controller and clips are in maininterface_ext_4.assetbundle.
- Lua UI_MainPage OnOpen plays UI_MainInterface_in, then UI_MainInterface_idle on the stopPlayEnterAnim branch; UI hide/show plays out/in.
- Unity AnimationUtility did not expose normal curve paths for the assetbundle-loaded compressed/generic clips. UnityPy finds 42 generic bindings, so this is an Editor API limitation rather than proof that the clips are empty.
- Animator.StringToHash comparison resolved 6 generic binding path hashes to prefab transform paths.
- Original prefab UI_MainInterface has Animator=True, controller=UI_MainInterface, Canvas.overrideSorting=False, Canvas.sortingOrder=0, CanvasGroup.alpha=1.

## Controller Evidence

## Prefab Evidence
- `UI_MainInterface` activeSelf=True, hasAnimator=True, animatorController=`UI_MainInterface`, Canvas.overrideSorting=False, Canvas.sortingOrder=0, CanvasGroup.alpha=1

## Route Binding Rows
- None found by Unity `AnimationUtility.GetCurveBindings` / `GetObjectReferenceCurveBindings`.

## Generic Binding Path Hash Resolution
- hashUnsigned=2853304615 path=`bg_dibu` includesRoot=False routeRelated=False
- hashUnsigned=2053629800 path=`left` includesRoot=False routeRelated=False
- hashUnsigned=2138030896 path=`mask` includesRoot=False routeRelated=False
- hashUnsigned=2314173485 path=`mask/btn_jiantou1` includesRoot=False routeRelated=False
- hashUnsigned=283520407 path=`mask/btn_jiantou2` includesRoot=False routeRelated=False
- hashUnsigned=3033167124 path=`right` includesRoot=False routeRelated=True

## Patch Decision
- No active/sibling/canvas patch is applied by this trace tool.
- Hiding `right`, `node_middle`, `wanfaWorldNode`, or `worldwanfaBtn` remains unsupported unless another authoritative Lua/prefab/DT/runtime source is found.
