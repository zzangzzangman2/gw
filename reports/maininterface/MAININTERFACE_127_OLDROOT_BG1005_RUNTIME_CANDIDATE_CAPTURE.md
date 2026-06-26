# MAININTERFACE_127_OLDROOT_BG1005_RUNTIME_CANDIDATE_CAPTURE

- generatedAt: 2026-06-26 01:49:37
- status: `ui127_oldroot_bg1005_runtime_candidate_capture_generated`
- restoredClaim: `false`
- rootRectId: `2475216337245998118`
- scene: `Assets/Scenes/MainInterface_UI126_OldRootReferenceCandidate.unity`
- capture: `Assets/RestoreCaptures/maininterface_ui127_oldroot_bg1005_runtime_candidate_1680x720.png`
- heroParentPath: `Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface_old__2475216337245998118/UI_heroSpine__-2739654541028205496`
- backgroundPath: `Canvas_MainInterface_1280x720/MainInterface_Root_From_RectTransform_CSV/UI_MainInterface_old__2475216337245998118/UI_bg__-3280973633984018659`
- backgroundSpritePath: `Assets/RestoredSprites/maininterface/runtime_dynamic/runtime_UI_bg_noalphabg_PaintingBG_1005.png`
- visiblePixelCount: `1209600`, uniqueColorCount: `272383`, bounds: `0,0 - 1679,719`
- click total/active/clickable/blocked: `55 / 45 / 43 / 2`
- click CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_127_oldroot_bg1005_click_validation.csv`
- click JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_127_oldroot_bg1005_click_validation_summary.json`

## Decisions
- Built the same old-root candidate scene, preserving the UI124 real Hero1005 SkeletonGraphic mount.
- Applied only the source-backed normal-home background runtime candidate: UI_MainPage refreshMiddle calls UIUtil.GetPaintingBg(heroId) then GameTools:LoadSpriteWithFullPath(UI_bg,e,true); hero1005 resolves to noalphabg_PaintingBG_1005.
- Did not hide node_act_btn placeholders because UI_MainPage refreshMainAct depends on ActMgr:GetActInMain runtime/server data that is not reconstructed yet.
- Did not hide btn_discord: its decoded SetActive(false) evidence is inside the GameTools:IsReview() branch, while the reference still shows normal task/lobby elements such as node_renwu.
- No hide was applied to zhuye_di1/zhuye_bian, right, node_middle, wanfaWorldNode, or worldwanfaBtn.

## Verdict
- Candidate capture only. This does not mark MainInterface restored.
