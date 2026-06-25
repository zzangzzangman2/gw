# MainInterface Button Navigation Trace

Generated: 2026-06-25 KST

## Verdict

Active clickable MainInterface button 24개를 원본 RectTransform hierarchy, click validation, decoded xLua handler, UI module TextAsset, UI prefab root evidence 기준으로 매핑했다. 화면에 디버그 overlay는 추가하지 않고, navigation harness는 report/JSON/log만 남긴다.

`wanfaBtn` 4개는 이름만으로는 구분되지 않아 기존 handler join이 모두 `onBtnAdventure`로 붙는다. 원본 `InitRightNode()` hierarchy evidence에 따라 item별 handler를 보정했다: item_1 Adventure, item_2 Jingji, item_3 Limit, item_4 ActJump.

## Counts

| Metric | Count |
| --- | ---: |
| Active clickable buttons | `24` |
| Evidence-resolved buttons | `22` |
| Target prefab resolved buttons | `6` |
| Unknown buttons | `2` |
| Harness connected buttons | `24` |

## Active Button Navigation Map

| Button | Component pathID | Parent | Sibling | Handler | Target key | UIForm | Prefab bundle | Confidence |
| --- | --- | --- | ---: | --- | --- | --- | --- | --- |
| `wanfaBtn` | `-1368142340573859670` | `UI_Main_wanfa_item_1` | `8` | `onBtnAdventure` | `jump.OnGameJumpUIAdventure` | `UI_AdventureInterface` | `download/ui/uiprefabandres/adventure_ext_prefabs.assetbundle` | `handler_and_jump_target` |
| `btn_baiqipao` | `-1664502759550802495` | `liaotian` | `4` | `onChat` | `event.CommonEventId.OnShowChatView` | `` | `` | `event_target_unknown` |
| `btn_jiantou1` | `-3325906521697426660` | `mask` | `0` | `onBtnLeft` | `local.changeBg.previous` | `` | `` | `local_action` |
| `btn_act` | `-3568137785440752602` | `btn_act_5` | `4` | `inline_UI_MainPageActItem` | `runtime.ActMgr.CheckJumpViewById` | `` | `` | `handler_runtime_target` |
| `wanfaBtn` | `-3657107032362470042` | `UI_Main_wanfa_item_2` | `8` | `onBtnJinji` | `jump.OnGameJumpUIJingjiRoot` | `UI_JingjiFrame_View` | `download/ui/uiprefabandres/jingjiframe_ext_prefabs.assetbundle` | `handler_and_jump_target` |
| `btn_head` | `-384152171734761225` | `im_mask` | `0` | `onBtnHead` | `ui.UI_SystemSet` | `UI_SystemSet` | `download/ui/uiprefabandres/maininterface.assetbundle` | `direct_ui_form` |
| `UI_bg` | `-4307678747511824550` | `UI_MainInterface` | `0` | `unknown` | `unknown` | `` | `` | `unknown` |
| `wanfaBtn` | `-5329947491786617253` | `UI_Main_wanfa_item_3` | `8` | `onBtnLimit` | `runtime.MainPageLimitMgr.LimitClickHandler` | `` | `` | `handler_runtime_target` |
| `btnToggle5` | `-6120225511886839045` | `toggle_node` | `1` | `onBtnGuild` | `jump.OnGameJumpUIGuild` | `UI_GuildMainView` | `download/ui/uiprefabandres/guild_ext_prefabs.assetbundle` | `handler_and_jump_target` |
| `btn_jia` | `-7281142146625083404` | `UI_currency` | `1` | `onBtnAddHoly` | `runtime.ActMgr.CheckJumpViewById.301` | `` | `` | `handler_runtime_target` |
| `btn_act` | `-7481061962792381934` | `btn_face_item_7` | `4` | `inline_UI_MainPageActItem` | `runtime.ActMgr.CheckJumpViewById` | `` | `` | `handler_runtime_target` |
| `p_chat_private_head` | `-8804151756104759869` | `im_mask` | `0` | `unknown` | `unknown` | `` | `` | `unknown` |
| `wanfaBtn` | `1037335828034283471` | `UI_Main_wanfa_item_4` | `8` | `onBtnActJump` | `runtime.ActMgr.JumpViewById` | `` | `` | `handler_runtime_target` |
| `autoHelper_Root` | `2191740874683137950` | `UI_MainInterface` | `12` | `autoHelper_Root_touch` | `ui.UI_AutoHelper_Main` | `UI_AutoHelper_Main` | `` | `direct_ui_form_touch` |
| `worldwanfaBtn` | `3284133529664903522` | `wanfaWorldNode` | `0` | `onBtnWorld` | `jump.OnGameJumpUIIdle` | `` | `` | `handler_only_target_unknown` |
| `btn_huodong3` | `3330313982570494710` | `btn_huodong3` | `2` | `btn_huodong3_toggle` | `local.toggle_activity_banner_desc` | `` | `` | `local_action` |
| `btn_watch` | `4133205024024200070` | `topBtnGroup` | `4` | `onBtnWatch` | `local.playWatchAction` | `` | `` | `local_action` |
| `bg_juese` | `4730878405889040423` | `left` | `0` | `onBtnHead` | `ui.UI_SystemSet` | `UI_SystemSet` | `download/ui/uiprefabandres/maininterface.assetbundle` | `direct_ui_form` |
| `btn_temporary_buff` | `4965781024685974967` | `left` | `4` | `OnBtnOpenTemporaryBuffView` | `ui.UI_ActGroupPhoto_Gold_Buff` | `UI_ActGroupPhoto_Gold_Buff` | `` | `direct_ui_form` |
| `btn_jiantou2` | `5988663256395336278` | `mask` | `1` | `onBtnRight` | `local.changeBg.next` | `` | `` | `local_action` |
| `btn_download` | `6415220684686472273` | `left` | `2` | `OnShowBgDownload` | `event.CommonEventId.OnShowBgDownload` | `UI_PlayBgDownload` | `download/ui/uiprefabandres/playdownload.assetbundle` | `event_candidate_ui_form` |
| `btn_jia` | `7055630172268697173` | `UI_currency` | `1` | `onBtnAddGold` | `ui.UI_GoldChange` | `UI_GoldChange` | `` | `direct_ui_form` |
| `funhandbook_Btn` | `8528581955237474686` | `im_funhandbook_bg` | `2` | `onBtnFunHandBook` | `ui.UI_FunctionHandBook_Root` | `UI_FunctionHandBook_Root` | `` | `direct_ui_form` |
| `faceGiftNode` | `9152972273217061488` | `left` | `10` | `inline_faceGiftNode` | `runtime.ActMgr.CheckJumpViewById.FaceGiftManager.ACT_ID` | `` | `` | `handler_runtime_target` |

## Evidence Notes

- `wanfaBtn` `-1368142340573859670`: UI_MainPage line 2826: JumpMgr.OnGameJumpUIAdventure(); UI_Dock lines 274-275 open UI_AdventureInterface
  - Correction: `hierarchy override: UI_Main_wanfa_item_1 wanfaBtn`
  - Handler binding: `e["wanfaBtn"].onClick:AddListener(onBtnAdventure)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/right(6922878451781464554)/node_middle(9056630568254389742)/UI_Main_wanfa_item_1(51920382737909704)/wanfaBtn(1986840053565196790)`
- `btn_baiqipao` `-1664502759550802495`: UI_MainPage lines 2597-2608 send CommonEventId.OnShowChatView with chat payload
  - Handler binding: `btn_baiqipao.onClick:AddListener(onChat)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/left(-7709903567246479490)/liaotian(5395517689795111462)/btn_baiqipao(-524215810688394471)`
- `btn_jiantou1` `-3325906521697426660`: UI_MainPage lines 2786-2790 call changeBg(1); no page navigation
  - Handler binding: `btn_left.onClick:AddListener(onBtnLeft)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/mask(-9138204023542992015)/btn_jiantou1(-4297991356429001013)`
- `btn_act` `-3568137785440752602`: UI_MainPageActItem lines 24-35 choose actId/mainPageTouchJumpId then UI_ActRallyRoot or ActMgr:CheckJumpViewById
  - Handler binding: `self._bicoms["btn_act"].onClick:AddListener(function(e)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/right(6922878451781464554)/node_act_btn(-6697018699563164382)/btn_act_5(-1716593492458519915)/btn_act(6156200035339212182)`
- `wanfaBtn` `-3657107032362470042`: UI_MainPage line 2842: JumpMgr.OnGameJumpUIJingjiRoot(); UI_JingjiFrame_View module/root are indexed
  - Correction: `hierarchy override: UI_Main_wanfa_item_2 wanfaBtn`
  - Handler binding: `e["wanfaBtn"].onClick:AddListener(onBtnAdventure)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/right(6922878451781464554)/node_middle(9056630568254389742)/UI_Main_wanfa_item_2(-3930377403474185176)/wanfaBtn(840801985878816193)`
- `btn_head` `-384152171734761225`: UI_MainPage lines 2679-2680: GameEntry.UI:OpenUIForm(UIFormId.UI_SystemSet)
  - Handler binding: `btn_head.onClick:AddListener(onBtnHead)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/left(-7709903567246479490)/bg_juese(8924767933396413025)/head_yuan150(-3481527396824609616)/im_mask(7191594683930153885)/btn_head(-1793161656856365654)`
- `UI_bg` `-4307678747511824550`: No decoded Lua handler/target evidence resolved for this active button.
  - Hierarchy: `UI_MainInterface(5568884429252053541)/UI_bg(-7723620072473078182)`
- `wanfaBtn` `-5329947491786617253`: UI_MainPage lines 2857-2861 call MainPageLimitMgr:checkCanShowLimitPage() then LimitClickHandler(t)
  - Correction: `hierarchy override: UI_Main_wanfa_item_3 wanfaBtn`
  - Handler binding: `e["wanfaBtn"].onClick:AddListener(onBtnAdventure)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/right(6922878451781464554)/node_middle(9056630568254389742)/UI_Main_wanfa_item_3(1745568030950951925)/wanfaBtn(7344258773029800384)`
- `btnToggle5` `-6120225511886839045`: UI_MainPage lines 2912-2913 call JumpMgr.OnGameJumpUIGuild(); UI_Dock lines 277-278 open UI_GuildMainView
  - Handler binding: `btnToggle5.onClick:AddListener(onBtnGuild)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/right(6922878451781464554)/node_bottom(-4278720413118513639)/toogles(3866169621397050666)/toggle5(4700239085922634030)/toggle_node(-5378092167677093850)/btnToggle5(2076358912804206005)`
- `btn_jia` `-7281142146625083404`: UI_MainPage lines 2740-2741: ActMgr:CheckJumpViewById(301)
  - Handler binding: `btn_jia_holy.onClick:AddListener(onBtnAddHoly)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/right(6922878451781464554)/UI_currency(80910812660760128)/btn_jia(-6796115180463095428)`
- `btn_act` `-7481061962792381934`: UI_MainPageActItem lines 24-35 choose actId/mainPageTouchJumpId then UI_ActRallyRoot or ActMgr:CheckJumpViewById
  - Handler binding: `self._bicoms["btn_act"].onClick:AddListener(function(e)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/left(-7709903567246479490)/left_node_face_btn(1861898826191704551)/btn_face_item_7(8780490937826274486)/btn_act(592699714808975310)`
- `p_chat_private_head` `-8804151756104759869`: No decoded Lua handler/target evidence resolved for this active button.
  - Hierarchy: `UI_MainInterface(5568884429252053541)/left(-7709903567246479490)/liaotian(5395517689795111462)/p_chat_private(2083186999486108191)/head_yuan150(-1074189520482543941)/im_mask(-4317103581640901762)/p_chat_private_head(3355289806251441275)`
- `wanfaBtn` `1037335828034283471`: UI_MainPage lines 2863-2866 call MainPageLimitMgr:GetCanMainActivityJump() then ActMgr:JumpViewById(activityId)
  - Correction: `hierarchy override: UI_Main_wanfa_item_4 wanfaBtn`
  - Handler binding: `e["wanfaBtn"].onClick:AddListener(onBtnAdventure)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/right(6922878451781464554)/node_middle(9056630568254389742)/UI_Main_wanfa_item_4(7836085562230756963)/wanfaBtn(-2510216933665100986)`
- `autoHelper_Root` `2191740874683137950`: UI_MainPage touch handlers are bound at OnInit; lines 2935-2937 open UI_AutoHelper_Main on click-up path
  - Handler binding: `UIUtil.AddTouchEventMulti(autoHelper_Root.transform,onClickDownAutoHelper,onClickUpAutoHelper,OnBeginDragAutoHelper,onDragingAutoHelper,OnEndDragAutoHelper)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/autoHelper_Root(-7066683132857930382)`
- `worldwanfaBtn` `3284133529664903522`: UI_MainPage lines 2896-2897 call JumpMgr.OnGameJumpUIIdle(); target UIFormId was not found in decoded Lua
  - Handler binding: `worldwanfaBtn.onClick:AddListener(onBtnWorld)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/right(6922878451781464554)/node_middle(9056630568254389742)/wanfaWorldNode(-3820167396480157270)/worldwanfaBtn(3512211464843089861)`
- `btn_huodong3` `3330313982570494710`: UI_MainPage lines 2120-2142 anonymous btn_huodong3 listener toggles banner desc nodes; no page navigation
  - Handler binding: `a["btn_huodong3"].onClick:AddListener(`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/left(-7709903567246479490)/leftbannerNode(-5279177717507701307)/huodong3(-6610370912035301878)/Viewport(4940853044098671873)/Content(-2208969483977481988)/btn_huodong3(6337183432698321669)/btn_huodong3(8701171759318614374)`
- `btn_watch` `4133205024024200070`: UI_MainPage lines 2725-2735 call playWatchAction() and FunctionHandBook check; no direct page open
  - Handler binding: `btn_watch.onClick:AddListener(onBtnWatch)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/left(-7709903567246479490)/topBtnGroup(-7712490274125866640)/btn_watch(5992350593342672181)`
- `bg_juese` `4730878405889040423`: UI_MainPage lines 2679-2680: GameEntry.UI:OpenUIForm(UIFormId.UI_SystemSet)
  - Handler binding: `bg_juese.onClick:AddListener(onBtnHead)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/left(-7709903567246479490)/bg_juese(8924767933396413025)`
- `btn_temporary_buff` `4965781024685974967`: UI_MainPage lines 3116-3117: GameEntry.UI:OpenUIForm(UIFormId.UI_ActGroupPhoto_Gold_Buff)
  - Handler binding: `btn_temporary_buff.onClick:AddListener(OnBtnOpenTemporaryBuffView)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/left(-7709903567246479490)/btn_temporary_buff(-4503624219808831110)`
- `btn_jiantou2` `5988663256395336278`: UI_MainPage lines 2792-2796 call changeBg(-1); no page navigation
  - Handler binding: `btn_right.onClick:AddListener(onBtnRight)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/mask(-9138204023542992015)/btn_jiantou2(1516559955701054074)`
- `btn_download` `6415220684686472273`: UI_MainPage lines 2809-2810 send CommonEventId.OnShowBgDownload; line 753 checks UI_PlayBgDownload existence
  - Handler binding: `btn_download.onClick:AddListener(OnShowBgDownload)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/left(-7709903567246479490)/btn_download(7328067398302382935)`
- `btn_jia` `7055630172268697173`: UI_MainPage lines 2737-2738: GameEntry.UI:OpenUIForm(UIFormId.UI_GoldChange)
  - Handler binding: `btn_jia_gold.onClick:AddListener(onBtnAddGold)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/right(6922878451781464554)/UI_currency(668535029315576181)/btn_jia(-800376319068591096)`
- `funhandbook_Btn` `8528581955237474686`: UI_MainPage lines 2767-2770 request FunctionHandBookMgr info then OpenUIForm(UI_FunctionHandBook_Root)
  - Handler binding: `funhandbook_Btn.onClick:AddListener(onBtnFunHandBook)`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/left(-7709903567246479490)/funcsBtnOpt(-957505502039124638)/im_funhandbook_bg(7845553199416412129)/funhandbook_Btn(8842433322768858449)`
- `faceGiftNode` `9152972273217061488`: UI_MainPage lines 157-158 call ActMgr:CheckJumpViewById(ModulesInit.FaceGiftManager.ACT_ID,{isOpenFrame=true})
  - Handler binding: `faceGiftNode.onClick:AddListener(function()`
  - Hierarchy: `UI_MainInterface(5568884429252053541)/left(-7709903567246479490)/faceGiftNode(2915645714390258269)`

## Generated Files

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_button_navigation_map.json`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_button_navigation_map.csv`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_BUTTON_NAVIGATION_TRACE.md`

## Final Verification

| Check | Result | Evidence |
| --- | --- | --- |
| Scene build | `success` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_button_navigation_build.log` |
| Graphics capture | `success` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png` visiblePixels=`1201679` |
| Click validation generatedAt | `2026-06-25 17:42:59` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_click_validation_summary.json` |
| Active / clickable | `24` / `24` | blocked=`0`, invoked=`24` |
| Navigation harness log lines | `24` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_button_navigation_click_validation.log` |
| Harness connected buttons | `24` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_button_navigation_map.json` |
| Target load probe | `5` loadable unique targets | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_navigation_target_load_probe.json` |

Harness note: the router only records original-evidence target keys and confirmed prefab/bundle candidates. It does not create fake pages and does not draw an overlay on the restored MainInterface scene.
