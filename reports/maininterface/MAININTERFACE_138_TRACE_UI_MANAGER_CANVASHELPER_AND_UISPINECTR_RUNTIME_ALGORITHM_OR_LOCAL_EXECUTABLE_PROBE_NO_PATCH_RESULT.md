# MAININTERFACE_138_TRACE_UI_MANAGER_CANVASHELPER_AND_UISPINECTR_RUNTIME_ALGORITHM_OR_LOCAL_EXECUTABLE_PROBE_NO_PATCH

Generated: 2026-06-26T04:10:35

## Decision
- restoredClaim: false
- scenePatchApplied: false
- candidatePatchApplied: false
- patchDecision: trace_only_no_patch
- runtimeEquivalentDepthRecovered: false
- uiDockPromotionAllowed: false
- uiSpineRendererRecovered: false
- localRuntimeDumpFeasible: conditionally_feasible_with_apk_or_native_probe_but_not_currently_configured

## Findings
- `YouYouUIManager`, `AbstractUIManager`, `UIFormBase`, `UIGroup`, `UILayer`, and `YouYouCanvasHelper` signatures/fields are recoverable from DummyDll. They prove the production stack uses UI form groups, BaseOrder, UIFormBase.Depth, Canvas, CanvasGroup, and CanvasHelper depth handlers rather than plain sibling placement.
- `YouYouCanvasHelper` has `m_Depth`, `m_UIFormBase`, `m_Canvas`, `m_Raycaster`, plus `OnOpenHandler`, `OnCloseHandler`, `OnDepthChanged`, `ResetDepth`, `ResetRenderDepth`, and `SetDepth`. DummyDll does not expose method bodies, so sorting/depth formulas are not recovered.
- `UISpineCtr` contains a private `SkeletonGraphic` field and `PlayAnimation/PlayAnimation2/SetToSetupPose/ClearTracks` methods. `UI_Dock.initTab()` requires this component on each `sp_*` node.
- UI136 candidate rows still show Dock `sp_*` nodes as RectTransform-only, so the runtime renderer is not recovered. Source bindings and serialized components prove what is missing; they do not justify a fake renderer.
- A local APK, `libil2cpp.so`, and `global-metadata.dat` exist, but there is no current safe/local runtime dump path configured in this task. Live dump is feasible only with an approved Android runtime/instrumentation path or a later native-method-body recovery pass.

## Outputs
- UIManager/CanvasHelper evidence rows: 423
- UISpineCtr/sp evidence rows: 84
- Runtime feasibility rows: 5

## Next Blocker
Recover actual `YouYouUIManager`/`YouYouCanvasHelper` method bodies or run a safe original-runtime dump for `UI_Dock` + `UI_MainPage` form group, BaseOrder, form Depth, Canvas sortingOrder, masks/stencils, and `UISpineCtr` SkeletonGraphic bindings. Without that, UI_Dock promotion remains blocked.
