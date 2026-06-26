# MAININTERFACE_126_REFERENCE_SCREEN_OPEN_STACK_AND_PREFAB_ID_TRACE_RESULT

## Verdict

Restored claim remains `false`. UI126 identifies `UI_MainInterface_old` as a strong original prefab/open-stack candidate for the reference screen, but the old-root candidate capture is still not a match.

## Key Evidence

- `UI_MainInterface_old` and `UI_MainInterface` both contain the `UI_MainPage.bytes` Lua component and the `UI_MainInterface` Animator controller.
- The current new-root reconstruction contains `right/node_middle/wanfaWorldNode/worldwanfaBtn`; reference does not show that route/world cluster.
- `UI_MainInterface_old` has matching families for right chat/social buttons, right activity icon stack, left task/story/banner nodes, profile/currency clusters, and bottom navigation.
- UI126 old-root candidate was captured with the real UI124 Hero1005 SkeletonGraphic asset path; no whole `Painting_1005.png` Image was used.

## Click Validation

- old-root candidate total/active/clickable/blocked: `55 / 44 / 43 / 1`
- click CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_126_oldroot_click_validation.csv`
- click JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_126_oldroot_click_validation_summary.json`
- active blocked click evidence:
  - `btn_discord__-4707263110286473242` top=`Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface_old__2475216337245998118/right__-7547578691690053275/node_act_btn__-2702129779362243929/btn_act_12__2652907961449290088/btn_act__6358558666799476393`

## Diff Summary

| capture | region | mean abs diff | rms diff | changed >=30 | correlation |
| --- | --- | ---: | ---: | ---: | ---: |
| `ui124_new_root` | `full` | `0.265278` | `0.343341` | `0.860502` | `0.188564` |
| `ui124_new_root` | `top_bar` | `0.291487` | `0.380424` | `0.875696` | `0.110685` |
| `ui124_new_root` | `left_lobby` | `0.270011` | `0.347993` | `0.880997` | `0.162509` |
| `ui124_new_root` | `center_hero` | `0.256085` | `0.3327` | `0.853481` | `0.18055` |
| `ui124_new_root` | `right_cluster` | `0.266764` | `0.345988` | `0.832856` | `0.149644` |
| `ui124_new_root` | `bottom_nav` | `0.281403` | `0.350866` | `0.910804` | `0.061431` |
| `ui126_old_root_candidate` | `full` | `0.317361` | `0.411613` | `0.804619` | `0.394` |
| `ui126_old_root_candidate` | `top_bar` | `0.378911` | `0.466287` | `0.927752` | `0.254962` |
| `ui126_old_root_candidate` | `left_lobby` | `0.358582` | `0.444211` | `0.862859` | `0.27576` |
| `ui126_old_root_candidate` | `center_hero` | `0.275788` | `0.37231` | `0.734761` | `0.453861` |
| `ui126_old_root_candidate` | `right_cluster` | `0.317282` | `0.404411` | `0.833205` | `0.444489` |
| `ui126_old_root_candidate` | `bottom_nav` | `0.320367` | `0.426794` | `0.733498` | `0.408792` |

## Files

- element candidates: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_126_reference_element_candidates.csv`
- Lua/open-stack candidates: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_126_lua_open_stack_candidates.csv`
- prefab root candidates: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_126_prefab_root_candidates.csv`
- diff regions: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_126_reference_diff_regions.csv`
- old-root click CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_126_oldroot_click_validation.csv`
- old-root click JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_126_oldroot_click_validation_summary.json`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_126_REFERENCE_DIFF_CONTACT.png`
- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_126_reference_screen_open_stack_trace.json`

## Patch Decision

No production/restored-scene patch was applied. The only Unity patch is a separate old-root candidate capture scene/tool plus a builder overload that preserves the default root behavior.
