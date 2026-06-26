# MAININTERFACE_127_OLDROOT_BACKGROUND_RUNTIME_RESOURCE_AND_LAYER_STATE_RECONSTRUCTION_RESULT

## Verdict

Restored claim remains `false`. UI127 applies a candidate-only old-root background runtime reconstruction and improves the visual state, but it is still not a reference match.

## Candidate Patch

- Applied to old-root candidate scene only: activate `UI_MainInterface_old/UI_bg` and bind `runtime_UI_bg_noalphabg_PaintingBG_1005.png`.
- Preserved UI124 real Hero1005 `SkeletonGraphic`; no `Painting_1005.png` whole Image was used.
- Did not hide `node_act_btn`, `btn_act_*`, `btn_discord`, `zhuye_di1`, `zhuye_bian`, `right/node_middle`, `wanfaWorldNode`, or `worldwanfaBtn`.

## Evidence

- `oldroot_background_black_cause`: UI_MainInterface_old/UI_bg is prefab inactive with ready BG_changjing_2 sprite; UI126 old-root candidate did not activate it, causing transparent/black capture background. Decision: `candidate_patch_applied`.
- `normal_home_background_runtime`: Normal home branch calls UIUtil.GetPlayerBigSpineAll(i, UI_heroSpine, 'homePara') then local e=UIUtil.GetPaintingBg(i) and GameTools:LoadSpriteWithFullPath(UI_bg,e,true). Decision: `source_backed_candidate`.
- `activity_placeholder_runtime`: refreshMainAct first SetActive(false) for all p items, then enables only ActMgr:GetActInMain entries; UI_MainPageActItem:Refresh sets text and loads tbSpine/mainPageSpineId via UIUtil.GetSpinePrefabFromPool. Decision: `blocked_no_patch`.
- `btn_discord_layer_blocker`: btn_discord SetActive(false) appears only inside GameTools:IsReview() branch; reference still shows normal task/lobby elements that the same branch would hide. UI127 click validation still has btn_discord topped by right/node_act_btn/btn_act_12. Decision: `blocked_no_patch`.
- `ui_bg_click_validation`: old-root UI_bg has an original Button component with empty persistent calls and no Lua AddListener; activating it adds one active blocked row under UI_touchSpine. Decision: `blocked_no_patch`.
- `zhuye_route_visibility_guardrail`: zhuye_di1/zhuye_bian are original pre-clipping attachments; no UI127 patch hides them. new-root route/world cluster also not hidden in production. Decision: `guardrail_preserved`.

## Click Validation

- UI126 old-root total/active/clickable/blocked: `55 / 44 / 43 / 1`
- UI127 BG1005 total/active/clickable/blocked: `55 / 45 / 43 / 2`
- UI127 active blocked rows:
  - `btn_discord__-4707263110286473242` top=`Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface_old__2475216337245998118/right__-7547578691690053275/node_act_btn__-2702129779362243929/btn_act_12__2652907961449290088/btn_act__6358558666799476393`
  - `UI_bg__-3280973633984018659` top=`Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface_old__2475216337245998118/UI_touchSpine__-318661959714136002`

## Diff Summary

| capture | region | mean abs diff | rms diff | changed >=30 | correlation |
| --- | --- | ---: | ---: | ---: | ---: |
| `ui126_old_root_candidate` | `full` | `0.317361` | `0.411613` | `0.804619` | `0.394045` |
| `ui126_old_root_candidate` | `top_bar` | `0.391122` | `0.477068` | `0.937316` | `0.276555` |
| `ui126_old_root_candidate` | `left_lobby` | `0.36073` | `0.442433` | `0.880512` | `0.27857` |
| `ui126_old_root_candidate` | `center_hero` | `0.272582` | `0.373222` | `0.715867` | `0.432135` |
| `ui126_old_root_candidate` | `right_cluster` | `0.305863` | `0.391056` | `0.831404` | `0.481581` |
| `ui126_old_root_candidate` | `bottom_nav` | `0.335393` | `0.442335` | `0.756429` | `0.345429` |
| `ui127_oldroot_bg1005_candidate` | `full` | `0.209078` | `0.293563` | `0.70151` | `0.424216` |
| `ui127_oldroot_bg1005_candidate` | `top_bar` | `0.259423` | `0.34665` | `0.845276` | `0.27287` |
| `ui127_oldroot_bg1005_candidate` | `left_lobby` | `0.235589` | `0.319403` | `0.760603` | `0.306586` |
| `ui127_oldroot_bg1005_candidate` | `center_hero` | `0.184641` | `0.27079` | `0.61333` | `0.475187` |
| `ui127_oldroot_bg1005_candidate` | `right_cluster` | `0.220839` | `0.301872` | `0.738659` | `0.448055` |
| `ui127_oldroot_bg1005_candidate` | `bottom_nav` | `0.192609` | `0.271701` | `0.689141` | `0.384463` |

## Files

- capture: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui127_oldroot_bg1005_runtime_candidate_1680x720.png`
- contact sheet: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_127_REFERENCE_DIFF_CONTACT.png`
- evidence CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_127_runtime_state_evidence.csv`
- diff CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_127_reference_diff_regions.csv`
- click CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_127_oldroot_bg1005_click_validation.csv`
- click JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_127_oldroot_bg1005_click_validation_summary.json`
- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_127_oldroot_runtime_state_trace.json`

## Next Blockers

- Reconstruct `ActMgr:GetActInMain` account/server data or a source-backed snapshot before changing `node_act_btn/btn_act_*` active states.
- Resolve old-root text/font/TMP material state; current candidate has placeholder/garbled activity labels.
- Find non-review runtime evidence for social/forum button state or layout/sibling evidence for `btn_discord` vs `btn_act_12`.
- Decide whether `UI_bg` original empty Button should be non-interactable/raycast-disabled at runtime; current evidence only proves empty persistent calls and no Lua listener.
