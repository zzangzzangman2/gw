# MAININTERFACE_147 Reference Aspect Capture Root-cause Consolidation

Generated: 2026-06-26T06:11:10

## Verdict

- restoredClaim: `false`
- scenePatchApplied: `false`
- runtimeInstrumentationExecuted: `false`
- snapshotValuesInvented: `false`
- staticPatchPossibleWithoutRuntime: `false`
- approvalRequiredForRuntimeDump: `true`

## Aspect Finding

- Attached reference image: `1180x526`, aspect `2.2433`
- `참고.mp4`: `1280x570`, aspect `2.2456`
- Latest MainInterface candidate captures are mostly `1680x720`, aspect `2.3333`.

The reference image and video agree on a wide `~2.24:1` home layout class. Current MainInterface candidates are slightly wider, about `4.01%` over the attached reference. This is a real comparison/framing contributor, but it does not explain the remaining UI mismatch by itself: UI128 still beats UI144 after source-backed Dock renderer/root Canvas reconstruction, and the unresolved differences map to runtime form stack/depth plus dynamic activity/account/chat/currency state.

## Root-cause Split

| cause | decision |
| --- | --- |
| aspect/capture framing | contributor; normalize future comparisons to `~2.24:1`, no coordinate patch |
| source root/form stack | runtime snapshot required for `UI_Dock`/`UI_MainPage` parent/group/depth |
| route/world active/sibling | runtime/source active-state proof required; guarded nodes stay untouched |
| activity/account/chat/currency | UI130-compatible runtime snapshot required |
| TMP/font/material/mask | static TMP lane already exhausted; runtime mask/stencil and dynamic labels still missing |

## Metrics Context

- UI128 safe old-root baseline full correlation: `0.425589`
- UI136 source-built Dock sibling full correlation: `0.211486`
- UI144 source-backed Dock renderer/root Canvas full correlation: `0.239859`

UI144 proves the renderer import path, but it still trails UI128 and is not promoted.

## Outputs

- Capture aspect matrix: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_147_REFERENCE_ASPECT_CAPTURE_ROOTCAUSE_CONSOLIDATION_NO_PATCH_reference_vs_candidate_capture_aspect_matrix.csv`
- Visible mismatch/runtime matrix: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_147_REFERENCE_ASPECT_CAPTURE_ROOTCAUSE_CONSOLIDATION_NO_PATCH_visible_mismatch_vs_runtime_snapshot_required_matrix.csv`
- Root-cause decision matrix: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_147_REFERENCE_ASPECT_CAPTURE_ROOTCAUSE_CONSOLIDATION_NO_PATCH_root_cause_next_action_decision_matrix.csv`
- JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_147_REFERENCE_ASPECT_CAPTURE_ROOTCAUSE_CONSOLIDATION_NO_PATCH_RESULT.json`

## Next Blocker

Need approved real runtime snapshot/dump for `UI_Dock`/`UI_MainPage` form parent/group/depth/`YouYouCanvasHelper` cascade and UI130-compatible dynamic activity/account/chat/currency values. Future visual comparisons should also be normalized to the `~2.24:1` reference view rect before any coordinate judgment.

## Command Policy

- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- policySatisfied: `True`
