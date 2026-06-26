# MAININTERFACE_144 Source-backed UI_Dock Renderer and Root Canvas Candidate Validation

## Decision

- restoredClaim: `false`
- scenePatchApplied: `true`
- candidatePatchApplied: `true`
- patchDecision: `candidate_saved_but_not_promoted`
- uiDockPromotionAllowed: `false`

## Validation

| check | result |
| --- | --- |
| Unity compile/import | `True` |
| capture produced | `True` |
| source root canvas sorting | `True` |
| UI_Dock renderer dependencies imported | `True` |
| UI_bg raycast preserved | `True` |
| UI_bg interactable preserved | `True` |
| guarded nodes preserved | `true` |
| fake assets created | `false` |

## Diff Summary

| metric | UI128 | UI136 | UI144 |
| --- | ---: | ---: | ---: |
| full correlation vs reference | `0.425589` | `0.211486` | `0.239859` |
| bottom nav correlation vs reference | `0.397542` | `0.121337` | `0.189647` |

UI144 validates the source-backed renderer/root-canvas import path, but it does not materially beat the safe UI128 baseline, so the Dock candidate is not promoted.

## Source-backed Changes

- Exported UI_Dock `.skel.bytes` from clean UnityFS TextAsset raw payloads instead of damaged `.skel.txt` copies.
- Reconstructed 8 normal UI_Dock `sp_*` `SkeletonGraphic` renderers from UI142 dependencies.
- Applied UI143 serialized root Canvas sorting evidence: `UI_MainInterface_old=0`, `UI_Dock=100`.
- Preserved `UI_bg` raycast/interactable: `True/True`, `True/True`.

## Outputs

- Capture: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui144_uidock_renderer_rootcanvas_candidate_1680x720.png`
- Diff CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_144_reference_diff_region_metrics_vs_ui128_ui136_ui144.csv`
- Contact: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_144_reference_ui128_ui136_ui144_contact.png`
- Patch matrix: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_144_source_backed_candidate_patch_action_matrix.csv`
- Validation matrix: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_144_unity_compile_import_capture_validation_matrix.csv`
- Visibility matrix: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_144_uidock_sp_renderer_runtime_candidate_visibility_matrix.csv`
- JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_144_SOURCE_BACKED_UIDOCK_RENDERER_AND_ROOT_CANVAS_DEPTH_CANDIDATE_VALIDATION_RESULT.json`

## Next Blocker

Production-equivalent UI_Dock parent/open-stack transform, mask, and disable-layer depth behavior is still missing. Source root Canvas sorting plus real renderer reconstruction compiles and captures, but visual metrics still trail UI128, so promotion needs runtime-equivalent stack/depth evidence or an approved runtime dump.
