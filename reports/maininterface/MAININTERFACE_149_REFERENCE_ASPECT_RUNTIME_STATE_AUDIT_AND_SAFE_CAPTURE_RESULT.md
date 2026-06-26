# MAININTERFACE 149 Reference Aspect Runtime State Audit And Safe Capture

Generated: 2026-06-26 09:59:38

## Verdict

- restoredClaim: `False`
- candidatePatchApplied: `True`
- productionPatchApplied: `False`
- status: `ui149_reference_aspect_audit_complete`

Default root remains a route/world state. Old-root + source-backed Hero1005/BG1005 is the safer home candidate, but runtime UI_Dock/depth/activity/chat/account state is still required before promotion.

## Reference Aspect

- reference: `1180x526` / `2.243346`
- previous candidate captures were `1680x720` / `2.333333`; UI149 emits reference-aspect captures at `1180x526`.

## Variant Metrics

| variant | capture | corr | meanAbsDiff | changed30 | routeActive | homeActive | TMP autosize | nonzero stencil | SkeletonGraphic |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `default_root_route_state` | `Assets/RestoreCaptures/maininterface_ui149_default_root_reference_aspect_1180x526.png` | 0.195456 | 0.26157 | 0.751714 | 12 | 25 | 0 | 0 | 0 |
| `oldroot_home_safe_candidate` | `Assets/RestoreCaptures/maininterface_ui149_oldroot_home_reference_aspect_1180x526.png` | 0.431487 | 0.206433 | 0.571246 | 0 | 178 | 0 | 0 | 1 |

## Root Cause

- The default scene root is still a source CSV route/world state; active route nodes are preserved by the builder and are not a sibling-order or clipping bug.
- The reference is a home/lobby state. `UI_MainInterface_old` plus BG1005/Hero1005 is the best static candidate, but it still lacks runtime UI_Dock parent/depth/mask/open-stack and dynamic activity/chat/account/currency values.
- CanvasScaler is now audited separately from the capture aspect: the generated Canvas still uses `ScaleWithScreenSize`, while UI149 only changes the validation render target to the attached reference size.
- TMP autosize/material and mask/stencil rows are exported so text scale and clipping can be checked without guessing dynamic labels.

## Outputs

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_149_reference_aspect_audit_result.json`
- node audit CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_149_reference_audit_nodes.csv`
- TMP audit CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_149_reference_audit_tmp.csv`
- mask/stencil CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_149_reference_audit_mask_stencil.csv`
- SkeletonGraphic CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_149_reference_audit_skeletongraphic.csv`
- decision matrix CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_149_reference_audit_decision_matrix.csv`

## Next Blocker

Need an approved original-runtime UI snapshot/dump for UI_Dock/UI_MainPage parent/depth/mask/open-stack and UI130-compatible activity/account/chat/currency fields before promoting the old-root candidate as restored.
