# Control Tower Status - 2026-06-26 04:02:54 KST

## Scope

- Project root: `C:\Users\godho\Downloads\girlswar`
- Primary restore target: main/lobby UI matched to the attached reference image.
- Secondary visual reference: `C:\Users\godho\Downloads\참고.mp4`
- Battle restore scope: real playable/source-backed actors and data only. No fake HUD, fake character, fake handler, screenshot paste, or external xLua import without explicit user approval.

## Worker State

- Control tower: active.
- UI worker `019eff6c-a02a-7f73-9ffb-74456322d1ce`: idle after UI137.
- Battle worker `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`: idle after BATTLE59.
- Character/data worker `019eff6d-307b-7532-8b1d-7105b18cd6b7`: idle after unresolved enemy trace.

## Reference Video

- `참고.mp4` was analyzed as auxiliary visual/motion reference only.
- Metadata: about 121.28 seconds, 1280x570, 30 fps.
- Outputs:
  - `reports\video_reference\REFERENCE_MP4_RESTORE_NOTES_20260626_024037.md`
  - `reports\video_reference\reference_overview_10s_contact.jpg`
  - `reports\video_reference\reference_frames\frame_000s.jpg` through `frame_120s.jpg`
- `플레이.mp4` is still missing.

## Battle State

- BATTLE57 restored source-backed battle actors from local assetbundle evidence.
  - 3/3 visible, rendered, and pixel-verified.
  - No fake mesh or placeholder actor used.
- BATTLE58 found battle raycast buttons alive, but original handler binding unavailable.
  - UnityEvent/onClick count: 0.
  - UIEventListener delegate count: 0.
  - Lua lifecycle/handler count: 0.
- BATTLE59 result: `blocked_no_patch`.
  - Outputs:
    - `reports\battle\BATTLE_59_AUDIT_LOCAL_SOURCE_BACKED_XLUA_RUNTIME_RECOVERY_FEASIBILITY_AND_BOOTSTRAP_REQUIREMENTS_NO_STUB_NO_EXTERNAL_RESULT.md`
    - `reports\battle\BATTLE_59_AUDIT_LOCAL_SOURCE_BACKED_XLUA_RUNTIME_RECOVERY_FEASIBILITY_AND_BOOTSTRAP_REQUIREMENTS_NO_STUB_NO_EXTERNAL_RESULT.json`
    - `_XLUA_RUNTIME_AVAILABILITY_EVIDENCE.csv`
    - `_GAMEENTRY_LUAMANAGER_MODULESINIT_BOOTSTRAP_REQUIREMENT_GRAPH.csv`
    - `_ORIGINAL_HANDLER_BINDING_FEASIBILITY_DECISION_MATRIX.csv`
    - `_FULL_PAYLOAD_BLOCKER_SEPARATION.csv`
  - Source-backed importable editor xLua runtime candidates: 0.
  - Executable xLua runtime recovered locally: false.
  - GameEntry/LuaManager bootstrap recovered locally: false.
  - Current boundary: battle handler/runtime restoration requires original xLua runtime, or explicit user approval for external xLua plus remaining payload-gap work.

## Character/Data State

- Local playable payload manifest was generated.
  - Actor loadable: 3/12.
  - Loadable actor payloads: our `1002`, our `1034`, enemy `1100111 -> prefab/model 3001`.
  - `1036`: `not_fetchable_local`.
  - Unresolved enemy payload instances: `1100112`, `1100113`, `1100121`, `1100122`, `1100123`, `1100131`, `1100132`, `1100133`.
- Deep unresolved enemy trace completed.
  - Outputs:
    - `reports\characters\CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_RESULT.md`
    - `reports\characters\CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_RESULT.json`
    - `reports\characters\CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_RESULT.csv`
  - Target status counts: `not_resolved_from_local_evidence = 8`.
  - Source-backed update proposals: 0.
  - Control `1100111` remains valid:
    - `DTMonster_KEntity` / `DTMonster_OEntity`.
    - modelId/prefabId `3001`.
    - bundle `download/roleprefabsandres/battleprefabandres/3001.assetbundle`.
    - bundle exists locally.
  - One raw little-endian integer hit in `il2cpp_native/global-metadata.dat` is weak evidence only, not a mapping.

## Main UI State

### UI134

- Decoded `UIUtil.GetPlayerBigSpineAll`.
- `homePara[1]` is scale.
- `homePara[2]` is `Painting_<id>` child local x.
- `homePara[3]` is child local y.
- Optional `homePara[4]` is horizontal flip.
- This applies to the `Painting_<id>` child under `paintingGroup`, not the `UI_heroSpine` parent.
- Hero1005 homePara is `[1,0,0]`: scale 1, x 0, y 0, no flip.

### UI135

- Hero1005 source-backed homePara application was a no-op because the actual `Painting_1005` child was already localPosition `0,0,0` and scale `1,1,1`.
- `Painting_1005_back` source atlas/skel/png exists and animation `A` exists, but the zero-offset candidate mount worsened reference metrics.
- `Painting_1005_front` complete source triplet is missing.
- Metrics:
  - UI128 vs reference full corr: `0.424216`.
  - UI128 hero corr: `0.475187`.
  - UI135 vs reference full corr: `0.153161`.
  - UI135 hero corr: `0.034676`.
- Decision: do not promote or carry current `Painting_1005_back` mount unless original transform/order/mask evidence appears.

### UI136

- Task: `MAININTERFACE_136_TRACE_UIDOCK_OPEN_STACK_BOTTOM_NAV_CANDIDATE_NO_BACK_LAYER_PROMOTION`.
- Result:
  - `restoredClaim=false`.
  - `sceneSaved=true`.
  - `candidatePatchApplied=true`.
  - `dockCandidateApplied=true`.
  - `productionPatchApplied=false`.
  - `UI_bg_raycast_preserved=true`.
  - `dockDefaultStateApplied=true`.
  - matched toggle count: 7.
  - on/off mismatch count: 0.
- Strong source evidence exists for the `UI_Dock` open stack and default `DOCK_TYPE.MAIN_PAGE`.
- Actual hierarchy uses `im_on/im_off`, not Lua variable names `main_on/main_off`; binding id patch was applied in candidate.
- `sp_*` animation was `not_applicable_no_skeleton_component`; candidate did not recover real `SkeletonGraphic`/`UISpineCtr` runtime rendering.
- Metrics worsened:
  - UI128 bottom_nav corr: `0.395621`.
  - UI136 bottom_nav corr: `0.120721`.
  - Delta: `-0.2749`.
  - UI128 full corr: `0.424216`.
  - UI136 full corr: `0.210779`.
- Decision: `UI_Dock` open-stack evidence is strong, but current static/source-built sibling mount is not a promotion candidate.

### UI137

- Task: `MAININTERFACE_137_TRACE_PRODUCTION_FORM_LAYER_ORDER_AND_ACTIVITY_ACCOUNT_CHAT_RUNTIME_STATE_NO_FAKE_PATCH`.
- Result:
  - `restoredClaim=false`.
  - `scenePatchApplied=false`.
  - `candidatePatchApplied=false`.
  - `patchDecision=trace_only_no_patch`.
  - `uiDockSiblingPromotionAllowed=false`.
- Outputs:
  - `reports\maininterface\MAININTERFACE_137_TRACE_PRODUCTION_FORM_LAYER_ORDER_AND_ACTIVITY_ACCOUNT_CHAT_RUNTIME_STATE_NO_FAKE_PATCH_RESULT.md`
  - `reports\maininterface\MAININTERFACE_137_TRACE_PRODUCTION_FORM_LAYER_ORDER_AND_ACTIVITY_ACCOUNT_CHAT_RUNTIME_STATE_NO_FAKE_PATCH_RESULT.json`
  - `reports\maininterface\MAININTERFACE_137_production_form_layer_order_open_stack_evidence.csv`
  - `reports\maininterface\MAININTERFACE_137_activity_account_chat_runtime_state_decision_matrix.csv`
  - `reports\maininterface\MAININTERFACE_137_mask_stencil_canvas_sorting_animator_evidence.csv`
- Key findings:
  - `UI_Dock` and `UI_MainPage` are source-backed `DTSysUIForm` rows.
  - Raw table fields do not recover final canvas sorting, form group, or runtime depth semantics.
  - Decoded `UI_Dock` proves default `DOCK_TYPE.MAIN_PAGE`, `initTab`, `OpenUIForm(UI_MainPage)`, and `UI_Dock_in/out`.
  - Decoded `UI_MainPage.OnOpen` refreshes runtime data and plays `UI_MainInterface_in/idle`.
  - Production path uses `GameEntry.UI:OpenUIForm`, `ViewMgr:clostEnableLayerView`, `YouYouUIManager.OpenUIForm/GetUIGroup`, `YouYouCanvasHelper.SetDepth/ResetRenderDepth/OnDepthChanged`, `NormalFormCanvasScaler`, and `FullFormCanvasScaler`.
  - UI136 static copy does not execute those runtime paths.
  - `UI_Dock sp_*` are only `RectTransform` objects in the source-built candidate, with no real runtime `SkeletonGraphic`/`UISpineCtr` renderer.
  - Activity/account/chat/top data remain runtime snapshot dependent:
    - activity slots depend on `ActMgr:GetActInMain`, server show/open state, player level/vip, and redpoint callbacks.
    - face activity depends on `ActMgr:GetActInMainFace`, `FaceGiftManager`, server timestamps, localized name, and icon.
    - chat depends on `ChatMgr.LastChatType`, `ChatMgr:getMsgListByType`, guild/private peer payload.
    - profile/top depends on `PlayerMgr.PlayerInfo`, `FormationManager`, and `BagManager`.
    - currency depends on `BagManager`.
  - `btn_discord` has review-branch evidence, but no review hide is allowed without explicit proof.
- Guardrails held:
  - no `UI_bg` raycast/interactable change.
  - no `btn_discord` hide.
  - no fake activity/account/chat patch.
  - no `Painting_1005_back` promotion.
  - no route/world/zhuye hiding.

## Current Decision Boundary

- Main UI cannot honestly promote UI136 static dock placement because reference metrics worsened and runtime form/canvas/renderer semantics are still missing.
- Main UI next evidence required:
  - Runtime or locally reconstructed `YouYouUIManager` / `YouYouCanvasHelper` form group and canvas depth algorithm for `UI_Dock` and `UI_MainPage`.
  - Runtime `UISpineCtr` / `sp_*` renderer reconstruction path, or the original component execution path.
  - UI130-compatible real snapshot for activity/account/chat/profile/currency state.
- Battle next evidence required:
  - Original xLua runtime and GameEntry/LuaManager bootstrap, or explicit user approval for external xLua plus remaining payload-gap handling.
- Character/data next evidence required:
  - New local source evidence for unresolved enemy payload instances and `1036`, if any exists outside the already scanned set.

## Recommended Next Action

- Delegate `MAININTERFACE_138_TRACE_UI_MANAGER_CANVASHELPER_AND_UISPINECTR_RUNTIME_ALGORITHM_OR_LOCAL_EXECUTABLE_PROBE_NO_PATCH`.
- Purpose:
  - Inspect IL2CPP/DummyDll/script metadata, global metadata/native strings, xLua wraps, and serialized components for `YouYouUIManager`, `YouYouCanvasHelper`, `UISpineCtr`, form depth/group/canvas scaler algorithms, and local executable runtime-dump feasibility.
  - Produce evidence only unless a source-backed runtime-equivalent path is proven.
- Expected outputs:
  - `reports\maininterface\MAININTERFACE_138_TRACE_UI_MANAGER_CANVASHELPER_AND_UISPINECTR_RUNTIME_ALGORITHM_OR_LOCAL_EXECUTABLE_PROBE_NO_PATCH_RESULT.md`
  - `reports\maininterface\MAININTERFACE_138_TRACE_UI_MANAGER_CANVASHELPER_AND_UISPINECTR_RUNTIME_ALGORITHM_OR_LOCAL_EXECUTABLE_PROBE_NO_PATCH_RESULT.json`
  - CSV evidence for UIManager/CanvasHelper method/field traces.
  - CSV evidence for UISpineCtr serialized/runtime component traces.
  - CSV decision matrix for local executable/runtime dump feasibility.

