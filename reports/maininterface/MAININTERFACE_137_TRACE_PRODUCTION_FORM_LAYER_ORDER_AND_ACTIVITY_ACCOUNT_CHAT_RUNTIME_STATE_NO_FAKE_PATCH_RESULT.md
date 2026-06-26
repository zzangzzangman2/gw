# MAININTERFACE 137 Trace Production Form Layer Order And Runtime State Result

Generated: 2026-06-26T04:00:44

## Verdict

- restoredClaim: `false`
- patchDecision: `trace_only_no_patch`
- scenePatchApplied: `false`
- candidatePatchApplied: `false`
- UI_Dock sibling promotion: `false`

## Why No Patch

UI_Dock form/open-stack evidence is strong, but UI136 source-built sibling capture worsened reference metrics and still lacks runtime UIManager canvas depth, form group, animator, mask, and UISpineCtr renderer semantics.

## Key Findings

- UI_Dock/UI_MainPage are source-backed `DTSysUIForm` rows, but the raw table fields alone do not recover final canvas sorting/group semantics.
- Decoded `UI_Dock` proves default `DOCK_TYPE.MAIN_PAGE`, `initTab()`, `OpenUIForm(UI_MainPage)`, and `UI_Dock_in/out` animator calls.
- UI136 already applied default on/off state correctly, but `sp_*` rows in the source-built candidate have no real `SkeletonGraphic`/`UISpineCtr` runtime renderer, so Dock visual state is incomplete.
- UI136 worsened correlation: full `0.424216` -> `0.210779`, bottom_nav `0.395621` -> `0.120721`.
- Activity, face activity, chat, account/profile, and currency states remain runtime snapshot dependent.

## Outputs

- production form/open-stack CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_137_production_form_layer_order_open_stack_evidence.csv`
- activity/account/chat decision matrix CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_137_activity_account_chat_runtime_state_decision_matrix.csv`
- mask/stencil/canvas/sorting/animator CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_137_mask_stencil_canvas_sorting_animator_evidence.csv`
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_137_TRACE_PRODUCTION_FORM_LAYER_ORDER_AND_ACTIVITY_ACCOUNT_CHAT_RUNTIME_STATE_NO_FAKE_PATCH_RESULT.json`

## Guardrails

- Did not carry UI135 `Painting_1005_back`.
- Did not alter `UI_bg` raycast/interactable.
- Did not hide `btn_discord`, activity slots, route/world nodes, `zhuye_di1`, or `zhuye_bian`.
- Did not create fake panels/icons/text/spines or paste screenshots/whole atlases.

## Command Policy

- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- policyOk: `True`

## Next Blocker

- Need a runtime UIManager/CanvasHelper form-depth dump or executable original UI stack probe before changing UI_Dock layer/order.
- Need a real UI130-compatible activity/account/chat snapshot before changing activity/chat/top visible state.
