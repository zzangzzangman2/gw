# MAININTERFACE_128_OLDROOT_RUNTIME_ACTIVITY_TEXT_TMP_CLICK_CANDIDATE_CAPTURE

- generatedAt: 2026-06-26 02:08:14
- status: `ui128_oldroot_runtime_activity_text_tmp_click_candidate_capture_generated`
- restoredClaim: `false`
- rootRectId: `2475216337245998118`
- scene: `Assets/Scenes/MainInterface_UI126_OldRootReferenceCandidate.unity`
- capture: `Assets/RestoreCaptures/maininterface_ui128_oldroot_runtime_activity_text_tmp_click_candidate_1680x720.png`
- heroParentPath: `Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface_old__2475216337245998118/UI_heroSpine__-2739654541028205496`
- backgroundPath: `Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface_old__2475216337245998118/UI_bg__-3280973633984018659`
- backgroundSpritePath: `Assets/RestoredSprites/maininterface/runtime_dynamic/runtime_UI_bg_noalphabg_PaintingBG_1005.png`
- visiblePixelCount: `1209600`, uniqueColorCount: `272383`, bounds: `0,0 - 1679,719`
- click total/active/clickable/blocked: `55 / 45 / 43 / 2`
- click CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_128_oldroot_runtime_activity_text_tmp_click_validation.csv`
- click JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_128_oldroot_runtime_activity_text_tmp_click_validation_summary.json`

## Decisions
- Rebuilt the old-root candidate scene with the UI127 source-backed BG1005 runtime state and preserved UI124 real Hero1005 SkeletonGraphic.
- No additional visual patch was applied for activity icons/text/TMP because ActMgr:GetActInMain and GetActInMainFace depend on server/account runtime activity lists.
- Did not hide node_act_btn/btn_act_*: decoded UI_MainPage refreshMainAct first disables all p items, then enables only ActMgr:GetActInMain results; those results are not reconstructed.
- Did not alter UI_bg raycast/interactable state: original old-root UI_bg has an empty Button and no Lua listener, but no source-backed runtime raycast-off evidence was found.
- Did not hide btn_discord: its SetActive(false) evidence remains limited to GameTools:IsReview(), while the reference keeps normal home/task elements.
- No hide was applied to zhuye_di1/zhuye_bian, right, node_middle, wanfaWorldNode, or worldwanfaBtn.

## Verdict
- Candidate capture only. This does not mark MainInterface restored.
