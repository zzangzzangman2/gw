# MAININTERFACE_131_REFERENCE_DIFF_ROOT_CAUSE_AND_SOURCE_BACKED_PATCH_MATRIX_NO_FAKE_PATCH_RESULT

## Verdict

`restoredClaim=false`. UI131 applied no scene patch. It decomposed the reference-vs-UI128 candidate mismatch into a root-cause matrix and identified only one snapshot-free static patch lane: TMP/font material binding for already source-identified static labels.

## Diff Summary

- `full`: corr `0.424216`, meanAbsDiff `0.209078`, changed30 `0.70151`
- `top_bar`: corr `0.24431`, meanAbsDiff `0.264475`, changed30 `0.844476`
- `center_hero_background`: corr `0.475187`, meanAbsDiff `0.184641`, changed30 `0.61333`
- `right_activity_stack`: corr `0.17393`, meanAbsDiff `0.247383`, changed30 `0.787842`
- `chat_bubble`: corr `0.559898`, meanAbsDiff `0.176602`, changed30 `0.661452`
- `bottom_nav`: corr `0.395621`, meanAbsDiff `0.190902`, changed30 `0.68305`

Contact sheet: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_131_REFERENCE_DIFF_CONTACT.png`

## Classification Counts

- `already_matches_or_low_priority`: `1`
- `needs_unity_runtime_probe`: `3`
- `requires_runtime_snapshot`: `4`
- `source_backed_static_patch_not_allowed_by_guardrail`: `2`
- `source_backed_static_patch_possible`: `1`

## Requires Runtime Snapshot

- `activity stack count/position/icons/text`: No scene patch. Do not hide, relabel, or replace activity slots without UI130 replay success.
- `face activity row`: No face activity hide/text/icon/spine patch.
- `chat bubble and chat text`: No fake chat text patch. Static bubble layout can be probed separately, but text remains runtime.
- `top profile/currencies`: No fake value patch. Font/material binding may be patched only after text nodes are source-identified.

## Static Patch Possible Without Snapshot

- `text/TMP/font material`: Patch plan only: audit/apply original TMP material/font binding for static labels already source-identified. Do not set dynamic labels.

This is candidate-plan only. It does not permit activity slot hide/label/icon/spine edits, chat text, top currency values, or fake HUD strings.

## Needs Unity Runtime Probe

- `right icon cluster non-activity buttons`: Candidate plan only: after activity replay, probe sibling/canvas order for non-activity right controls. Do not use review hide.
- `bottom navigation`: No patch in UI131. Candidate plan: probe old-root bottom node active state, Animator binding, and Canvas order before static patch.
- `hero1005 spine/background`: Candidate plan only: probe UIUtil.GetPlayerBigSpineAll homePara transform and SkeletonGraphic canvas/material settings. No coordinate-only patch.

## Guardrail-Blocked Static Patch

- `btn_discord click blocker`: No patch until activity runtime replay clarifies btn_act_12 active/layer state.
- `zhuye_di1/zhuye_bian and route/world guardrail nodes`: No hide patch. Only source-backed runtime active/sibling/canvas evidence can change them.

## Low Priority / Already Diagnosed

- `UI_bg click blocker`: No patch. Treat as diagnosed and lower priority unless later click target requirements prove otherwise.

## Outputs

- matrix CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_131_reference_diff_root_cause_matrix.csv`
- result JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_131_REFERENCE_DIFF_ROOT_CAUSE_AND_SOURCE_BACKED_PATCH_MATRIX_NO_FAKE_PATCH_RESULT.json`
- patch plan MD: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_131_source_backed_static_patch_plan_NO_SCENE_PATCH.md`
- contact PNG: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_131_REFERENCE_DIFF_CONTACT.png`

## Command Policy

- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
