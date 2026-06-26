# MAININTERFACE_128_OLDROOT_RUNTIME_ACTIVITY_TEXT_TMP_AND_CLICK_LAYER_RECONSTRUCTION_RESULT

## Verdict

Restored claim remains `false`. UI128 regenerated the old-root candidate capture and click validation, but did not apply a new visual patch because the remaining activity icon/text/TMP state depends on runtime server/account data.

## Runtime Activity Evidence

- `UI_MainPage` defines main activity wrappers for `btn_act_1..btn_act_8`; prefab `btn_act_*` placeholders beyond that are not authoritative normal-home state.
- `refreshMainAct()` first disables all wrapped activity items, then enables only flattened `ActMgr:GetActInMain()` entries.
- `ActMgr:GetActInMain()` selects up to five dynamic system groups: charge `1004`, recruit `1005`, welfare `1006`, activity `1007`, rally `1008`.
- `ActMgr:IsActShowInMain()` depends on `ActMgr.activitys`, server `show`, `IsOpen`, player VIP/level, redpoint/client callbacks, and review state.
- `UI_MainPageActItem:Refresh()` replaces prefab labels with `GameTools.GetLocalize(...)`, `ActCfgData.mainPageName/getActNewName`, and `mainPageSpineId/tbSpine`.

## Click Blockers

UI128 click total/active/clickable/blocked: `55 / 45 / 43 / 2`.

- `UI_bg__-3280973633984018659` top=`Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface_old__2475216337245998118/UI_touchSpine__-318661959714136002`
- `btn_discord__-4707263110286473242` top=`Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface_old__2475216337245998118/right__-7547578691690053275/node_act_btn__-2702129779362243929/btn_act_12__2652907961449290088/btn_act__6358558666799476393`

`UI_bg` was not changed to raycast/interactable off: it has an original empty Button and no Lua listener found, but no runtime source evidence was found that disables the Button/raycast. `UI_touchSpine` is explicitly active in the normal home branch.

`btn_discord` was not hidden: the only hide evidence remains inside `GameTools:IsReview()`, which also hides normal home/task/social elements and does not match the reference state.

## Diff

- ui126_old_root_candidate: correlation `0.394045`, meanAbsDiff `0.317361`, changed>=30 `0.804619`
- ui127_oldroot_bg1005_candidate: correlation `0.424216`, meanAbsDiff `0.209078`, changed>=30 `0.70151`
- ui128_oldroot_activity_text_tmp_click_candidate: correlation `0.424216`, meanAbsDiff `0.209078`, changed>=30 `0.70151`

## Command Policy

- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`

## Outputs

- capture: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui128_oldroot_runtime_activity_text_tmp_click_candidate_1680x720.png`
- contact: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_128_REFERENCE_DIFF_CONTACT.png`
- diff CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_128_reference_diff_regions.csv`
- evidence CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_128_runtime_activity_text_tmp_click_evidence.csv`
- activity CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_128_runtime_activity_slot_candidates.csv`
- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_128_oldroot_runtime_activity_text_tmp_click_trace.json`

## Next Blocker

Need a real runtime/server/account snapshot or replay evidence for `ActMgr.activitys`, `PlayerMgr.PlayerInfo`, redpoint state, and localization/font material binding. Without that, hiding or replacing activity slots/text would be a guess.
