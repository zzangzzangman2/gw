# MainInterface GuildMain Runtime Lua/XLua Initialization Trace Result

Generated: 2026-06-25 18:47:40 KST

## Verdict

Not normal. `UI_GuildMain` still renders as a large white/bright panel; this pass did not apply a visual fix because no serialized+Lua evidence was strong enough to safely change active/color/mask/material state.

## Visual Comparison

| Metric | 107 baseline | 108 trace |
| --- | ---: | ---: |
| Whiteish visible ratio | `0.8171147704124451` | `0.8171147704124451` |
| Large white visible Images | `19` | `19` |
| White no-sprite Images | `78` | `78` |
| Missing Image sprites | `152` | `152` |
| Missing script objects | `881` | `881` |

## Runtime Evidence Summary

- Raw guild TextAssets extracted: `75`
- Decoded guild Lua-like TextAssets: `75`
- Script candidates with GuildMain/runtime UI evidence: `84`
- Blocker-to-runtime candidate rows: `56`
- High-confidence blocker rows: `23`
- Confidence split: `{'high': 23, 'medium': 32, 'unresolved': 1}`
- Evidence-based fix applied: `0`

## Focused GuildMainView Runtime Initialization

| Line | Evidence | Interpretation |
| ---: | --- | --- |
| `48` | `function OnInit(o,e)` | Registers button handlers and initial width/mask state. |
| `49` | `z=LuaUtils.GetRectTransformWidth(gonggaoMask)/2` | gonggao mask width is read at runtime for marquee offsets. |
| `64` | `LuaUtils.SetActive(btn_1.transform,GameTools:IsReview()==false)` | Review branch changes visible buttons. |
| `284` | `LuaUtils.SetActive(btn_wanfa6.transform,false)` | Wanfa buttons are runtime-gated by review/function/data state. |
| `285` | `LuaUtils.SetActive(btn_wanfa7.transform,false)` | Wanfa buttons are runtime-gated by review/function/data state. |
| `286` | `LuaUtils.SetActive(btn_wanfa9.transform,false)` | Wanfa buttons are runtime-gated by review/function/data state. |
| `508` | `if GameTools:IsReview()then` | Review branch changes visible buttons. |
| `510` | `if GameEntry.IsCommittee then` | Committee/review branch changes root_wanfa position/size and visible buttons. |
| `512` | `LuaUtils.SetLocalPos(root_wanfa.transform,100,0,0)` | Runtime UI state evidence. |
| `513` | `LuaUtils.SetRectTransformSizeDelta(root_wanfa.transform,540,600)` | Runtime UI state evidence. |
| `520` | `function OnOpen(e)` | Runtime initialization entry for data, events, content layout, active state, and red points. |
| `568` | `LuaUtils.SetImageFillAmount(im_level_jindutiao,0)` | Progress bar visual state is data-bound. |
| `571` | `LuaUtils.SetActive(node_gonggao.transform,false)` | Notice panel active state is runtime-controlled. |
| `572` | `local e=ContentWanfa.gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))` | ContentWanfa layout components are enabled at runtime, not just serialized prefab state. |
| `574` | `LuaUtils.RebuildLayout(ContentWanfa.transform)` | Forces layout rebuild for the wanfa cluster. |
| `575` | `UIUtil.setScrollViewAutoByContainerSize(root_wanfa,true)` | ScrollRect/content sizing is runtime-controlled. |
| `600` | `LuaUtils.SetActive(btn_wanfa3.transform,GameEntry.IsReview==false)` | Wanfa buttons are runtime-gated by review/function/data state. |
| `601` | `LuaUtils.SetActive(btn_wanfa7.transform,GameEntry.IsReview==false)` | Wanfa buttons are runtime-gated by review/function/data state. |
| `602` | `LuaUtils.SetActive(btn_wanfa1.transform,GameEntry.IsReview==false)` | Wanfa buttons are runtime-gated by review/function/data state. |
| `603` | `LuaUtils.SetActive(btn_wanfa4.transform,GameEntry.IsReview==false)` | Wanfa buttons are runtime-gated by review/function/data state. |
| `604` | `LuaUtils.SetActive(btn_wanfa7.transform,GameTools:IsReview()==false)` | Wanfa buttons are runtime-gated by review/function/data state. |
| `605` | `LuaUtils.SetActive(btn_wanfa9.transform,GameTools:IsReview()==false)` | Wanfa buttons are runtime-gated by review/function/data state. |
| `614` | `LuaUtils.SetActive(btn_wanfa8.transform,GameEntry.IsReview==false and ModulesInit.GreatBossMgr:GreatBossIsOpen())` | Wanfa buttons are runtime-gated by review/function/data state. |
| `615` | `LuaUtils.SetActive(btn_wanfa10.transform,GameTools:IsReview()==false and GameFunction.IsFunctionUnLock(GameFunctionType.GuildTerritory,false))` | Wanfa buttons are runtime-gated by review/function/data state. |
| `715` | `GameTools:SetImageSprite(bg_huizhang.transform,ModulesInit.GuildMgr:getGuildIconBg(ModulesInit.GuildMgr.guildInfo.bg),false)` | Guild emblem sprites are runtime-bound from guild data. |
| `716` | `GameTools:SetImageSprite(im_huizhang.transform,ModulesInit.GuildMgr:getGuildFg(ModulesInit.GuildMgr.guildInfo.fg),false)` | Guild foreground emblem is runtime-bound. |
| `725` | `LuaUtils.SetImageFillAmount(im_level_jindutiao,1)` | Progress bar visual state is data-bound. |
| `729` | `LuaUtils.SetImageFillAmount(im_level_jindutiao,ModulesInit.GuildMgr.guildInfo.exp/e)` | Progress bar visual state is data-bound. |
| `756` | `function UpdateGonggaoTipsSize2()` | Notice mask/marquee is runtime-driven. |
| `775` | `UpdateGonggaoTipsSize2()` | Notice mask/marquee is runtime-driven. |
| `796` | `UIUtil.SetGray(btn_jiantou_right.transform,m)` | Arrow visual state is controlled by scroll position. |
| `811` | `if GameEntry.IsCommittee then` | Committee/review branch changes root_wanfa position/size and visible buttons. |
| `821` | `LuaUtils.SetActive(btn_wanfa3.transform,GameTools:IsReview()==false)` | Wanfa buttons are runtime-gated by review/function/data state. |
| `822` | `LuaUtils.SetActive(btn_wanfa1.transform,GameTools:IsReview()==false)` | Wanfa buttons are runtime-gated by review/function/data state. |
| `939` | `LuaUtils.SetActive(node_gonggao.transform,true)` | Notice panel active state is runtime-controlled. |
| `940` | `UpdateGonggaoTipsSize2()` | Notice mask/marquee is runtime-driven. |
| `1443` | `if GameTools:IsReview()then` | Review branch changes visible buttons. |
| `1444` | `LuaUtils.SetActive(btn_wanfa7.transform,false)` | Wanfa buttons are runtime-gated by review/function/data state. |
| `1448` | `LuaUtils.SetActive(btn_wanfa7.transform,true)` | Wanfa buttons are runtime-gated by review/function/data state. |
| `1452` | `LuaUtils.SetActive(btn_wanfa7.transform,false)` | Wanfa buttons are runtime-gated by review/function/data state. |

## Confirmed UI Form Evidence

- `7179387777078280832_DTSysUIFormEntityTableData.txt:146` {219,"军团主页","UI_GuildMainView","1",0,0,"UIPrefabAndRes/Guild_Ext_Prefabs/Prefabs/UI_GuildMain","UIPrefabAndRes/Guild_Ext_Prefabs/Prefabs/UI_GuildMain","UIPrefabAndRes/Guild_Ext_Prefabs/Prefabs/UI_GuildMain","UIPrefabAndRes/Guild_Ext_Prefabs/Prefabs/UI_GuildMain","0","0","0","TRUE","0",9999,"Guild","","Assets/Download/ArtSources/UISpriteRes/UIGuild",""},

## Decoded Guild Module Candidates

| Script | Bundle | Keyword hits | Runtime UI calls | Key evidence |
| --- | --- | ---: | ---: | --- |
| `UI_GuildMainView` | `download/xlualogic/modules/guild.assetbundle` | `257` | `162` | L2:local U=require("DataNode/DataTable/Create/guild/DTGreatBossDBModel") \| L4:local s=ModulesInit.CSGuildWarManager:GetGuildWarDBCfg() \| L49:z=LuaUtils.GetRectTransformWidth(gonggaoMask)/2 \| L54:GameEntry.UI:OpenUIFor |
| `UI_GuildWarMain` | `download/xlualogic/modules/csguildwar.assetbundle` | `103` | `91` | L2:local d=require("Modules/CSGuildWar/PlayerListView") \| L18:local e=ModulesInit.CSGuildWarManager \| L19:local a=ModulesInit.GuildMgr \| L20:local a=e:GetGuildWarDBCfg() \| L32:GameTools.CloseUIForm(UIFormId.UI_GuildW |
| `UI_GuildWarEmbattle` | `download/xlualogic/modules/csguildwar.assetbundle` | `8` | `64` | L33:local v=ModulesInit.CSGuildWarManager \| L76:GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="houbu"}) \| L79:GameTools.CloseUIForm(UIFormId.UI_GuildWarEmbattle) \| L107:GameTools.CloseUIForm(UIFormId.UI_GuildWarEmb |
| `UI_GuildTerritory_TeamBattle` | `download/xlualogic/modules/guildterritory.assetbundle` | `5` | `63` | L42:formationNoList={PROTO_ENUM.FormationNO.FN_GUILDRADAR,}, \| L76:GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="houbu"}) \| L109:GameEntry.UI:OpenUIForm(UIFormId.UI_PhotoArtistView,{helpId="arena.xianshou"}) \| L22 |
| `GuildWarBigMap` | `download/xlualogic/modules/csguildwar.assetbundle` | `24` | `46` | L3:local e=Class("GuildWarBigMap",{}) \| L19:self.CFG=ModulesInit.CSGuildWarManager:GetGuildWarDBCfg() \| L20:self.mapCtr=self.transform:GetComponent(typeof(CS.YouYou.GuildWarMapCtr)) \| L34:self:OnGuildWarBattleInfoSync |
| `UI_GuildTrials_EmBattle_View` | `download/xlualogic/modules/guildtrials.assetbundle` | `3` | `45` | L37:formationNoList={PROTO_ENUM.FormationNO.FN_GUILD_TRIAL,PROTO_ENUM.FormationNO.FN_GUILD_TRIAL_ALTER}, \| L52:GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="houbu"}) \| L56:GameTools.CloseUIForm(UIFormId.UI_GuildTri |
| `UI_GuildWarEmbattleForDef` | `download/xlualogic/modules/csguildwar.assetbundle` | `3` | `45` | L35:formationNoList={PROTO_ENUM.FormationNO.FN_GUILD_WAR_DEF,PROTO_ENUM.FormationNO.FN_GUILD_WAR_DEF_ALTER}, \| L50:GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="houbu"}) \| L54:GameTools.CloseUIForm(UIFormId.UI_Guil |
| `UI_GuildTrials_Rank_View` | `download/xlualogic/modules/guildtrials.assetbundle` | `37` | `44` | L1:local i=ModulesInit.GuildTrialsMgr \| L9:GameTools.CloseUIForm(UIFormId.UI_GuildTrials_Rank_View) \| L16:local t=i:reqGuildTrialsPlayerRank() \| L28:local e=i:reqGuildTrialsGuildRank() \| L36:guildScrollView:InitListV |
| `UI_GuildWarBattleGround` | `download/xlualogic/modules/csguildwar.assetbundle` | `47` | `41` | L2:local m=require("Modules/CSGuildWar/GuildWarBigMap") \| L15:local e=ModulesInit.CSGuildWarManager \| L16:local r=e:GetGuildWarDBCfg() \| L21:[PROTO_ENUM.ENUM_GUILD_WAR_STATUS.PREPARE]=OnPrepareStage, \| L22:[PROTO_ENU |
| `UI_GuildTerritory_TeamDispatch` | `download/xlualogic/modules/guildterritory.assetbundle` | `3` | `38` | L11:local _=ModulesInit.GuildTerritoryMgr \| L54:GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="houbu"}) \| L780:UIUtil.ShowCommonTipsForLocalize('UI_GuildTerritory_teamEmpty') |
| `UI_GuildWarWin` | `download/xlualogic/modules/csguildwar.assetbundle` | `4` | `38` | L26:local n=ModulesInit.CSGuildWarManager \| L30:GameEntry.UI:OpenUIForm(UIFormId.UI_ArenaStatistical,v) \| L36:GameTools.CloseUIForm(UIFormId.UI_GuildWarWin) \| L146:LuaUtils.AnimtorPlay(e,"guildwar_win_hero_damage",0,0 |
| `UI_GuildGiftView` | `download/xlualogic/modules/guild.assetbundle` | `85` | `37` | L31:GameTools.CloseUIForm(UIFormId.UI_GuildGiftView) \| L41:ModulesInit.GuildMgr:ReqGuildGiftBox() \| L43:local t=ModulesInit.GuildMgr:getGuildTreasureData(f) \| L64:titleName1=GameTools.GetLocalize("guild_box_accuracy_g |
| `UI_GuildTrials_DrillBox_View` | `download/xlualogic/modules/guildtrials.assetbundle` | `37` | `36` | L1:local e=ModulesInit.GuildTrialsMgr \| L28:GameTools.CloseUIForm(UIFormId.UI_GuildTrials_DrillBox_View,true) \| L34:EventSystem.AddListener(CommonEventId.OnRespGuildTrialsInfo,OnRespGuildTrialsInfo) \| L35:EventSystem. |
| `UI_GuildJoinListNewView` | `download/xlualogic/modules/guild.assetbundle` | `111` | `35` | L2:GuildPage="GuildPage", \| L17:local s=n.GuildPage \| L29:ModulesInit.GuildMgr:ReqGuildRecommandRmdList(r) \| L32:GameTools.CloseUIForm(UIFormId.UI_GuildJoinListNewView) \| L36:GameEntry.UI:OpenUIForm(UIFormId.UI_Guild |
| `UI_GuildJoinListView` | `download/xlualogic/modules/guild.assetbundle` | `97` | `32` | L2:GuildPage="GuildPage", \| L11:local n=i.GuildPage \| L18:filterGuild() \| L21:GameTools.CloseUIForm(UIFormId.UI_GuildJoinListView) \| L25:GameEntry.UI:OpenUIForm(UIFormId.UI_GuildSearchView) \| L28:local e=ModulesInit |
| `CSGuildWarRecord` | `download/xlualogic/modules/csguildwar.assetbundle` | `1` | `31` | L28:GameEntry.UI:OpenUIForm(UIFormId.UI_ArenaRecordShare) |
| `territory_player_airship` | `download/xlualogic/modules/guildterritory.assetbundle` | `5` | `30` | L1:local e=ModulesInit.GuildTerritoryMgr \| L144:EventSystem.SendEvent(CommonEventId.OnGuildRadarAirshipBattleFinish,s,e) \| L146:EventSystem.SendEvent(CommonEventId.OnGuildRadarAirshipReturnFinish,s) \| L284:LuaUtils.An |
| `UI_GuildWarNoOpenForFirst` | `download/xlualogic/modules/csguildwar.assetbundle` | `19` | `25` | L9:local t=ModulesInit.CSGuildWarManager \| L10:local e=ModulesInit.GuildMgr \| L11:local r=t:GetGuildWarDBCfg() \| L19:GameTools.CloseUIForm(UIFormId.UI_GuildWarNoOpenForFirst) \| L23:if t:GuildFirstTimeJoinAwardIsGeted |
| `UI_GuildWarRank` | `download/xlualogic/modules/csguildwar.assetbundle` | `10` | `24` | L10:local e=ModulesInit.CSGuildWarManager \| L11:local s=e:GetGuildWarDBCfg() \| L18:GameTools.CloseUIForm(UIFormId.UI_GuildWarRank) \| L40:local i=e:GetGuildWarStage() \| L48:if not e:GuildIsCanJoin()or \| L49:e:GetGuil |
| `UI_GuildTrials_BattleSuc_View` | `download/xlualogic/modules/guildtrials.assetbundle` | `6` | `23` | L31:GameEntry.UI:OpenUIForm(UIFormId.UI_BattleStatistical,l) \| L44:ModulesInit.GuildTrialsMgr:GoBack() \| L45:GameTools.CloseUIForm(UIFormId.UI_GuildTrials_BattleSuc_View) \| L96:LuaUtils.SetLabelText(text_progress,Game |

## Blocker Mapping

| Blocker | Path hint | Confidence | Candidate script | Evidence | Reason |
| --- | --- | --- | --- | --- | --- |
| `gonggao_mask` | `middle/node_gonggao/gongao_bg/gonggaoMask` | `high` | `UI_GuildMainView` | L49:z=LuaUtils.GetRectTransformWidth(gonggaoMask)/2 \| L571:LuaUtils.SetActive(node_gonggao.transform,false) \| L939:LuaUtils.SetActive(node_gonggao.transform,true) \| L940:UpdateGonggaoTipsSize2() | keyword appears near runtime UI call |
| `right_buttons` | `right/btn_*` | `high` | `UI_GuildMainView` | L682:elseif h==EMoveingDir.Right then \| L796:UIUtil.SetGray(btn_jiantou_right.transform,m) | keyword appears near runtime UI call |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `high` | `UI_GuildMainView` | L194:e["box"].onClick:AddListener( \| L220:t["box"].onClick:AddListener( \| L246:e["box"].onClick:AddListener( \| L807:LuaUtils.SetActive(rd_gift_box.transform,true) \| L809:LuaUtils.SetActive(rd_gift_box.transform,false) \| L812:LuaUtils.SetActive(rd_gift_box | keyword appears near runtime UI call |
| `wanfa_button_backgrounds` | `btn_wanfa*/bg_ditu` | `high` | `UI_GuildMainView` | L119:self:AddBtnClickListener(btn_wanfa1.transform:GetComponent(typeof(CS.UnityEngine.UI.Button)), \| L150:local e=LuaUtils.GetLuaComBinder(btn_wanfa2.transform) \| L184:self:AddBtnClickListener(btn_wanfa3.transform:GetComponent(typeof(CS.UnityEngine.UI.Button | keyword appears near runtime UI call |
| `wanfa_viewport_mask` | `middle/root_wanfa/Viewport/UIMask` | `high` | `UI_GuildMainView` | L49:z=LuaUtils.GetRectTransformWidth(gonggaoMask)/2 \| L512:LuaUtils.SetLocalPos(root_wanfa.transform,100,0,0) \| L513:LuaUtils.SetRectTransformSizeDelta(root_wanfa.transform,540,600) \| L572:local e=ContentWanfa.gameObject:GetComponent(typeof(CS.UnityEngine.U | keyword appears near runtime UI call |
| `middle_guild_tmqj` | `middle/Image/guild_tmqj` | `high` | `-6351603197391775840_UI_MainPage_security_xor_raw.lua` | L1327:function refreshRightMiddleView() | keyword appears near runtime UI call |
| `middle_guild_tmqj` | `middle/Image/guild_tmqj` | `high` | `2102292922432672894_UI_JingjiFrame_View_security_xor_raw.lua` | L94:local e=d:Find("middle/wenquanPannel") | keyword appears near runtime UI call |
| `middle_guild_tmqj` | `middle/Image/guild_tmqj` | `high` | `UI_GuildTerritory_Radar` | L45:LuaUtils.SetLocalPos(middle_img_bg.transform,0,0,0) | keyword appears near runtime UI call |
| `right_buttons` | `right/btn_*` | `high` | `-6351603197391775840_UI_MainPage_security_xor_raw.lua` | L108:btn_right.onClick:AddListener(onBtnRight) \| L122:local e=e:Find("right/node_bottom/toogles/toggle3") \| L1327:function refreshRightMiddleView() \| L1461:function refreshRightBottomView() \| L1634:LuaUtils.SetActive(btn_right.transform,#PlayerMgr.mainShow | keyword appears near runtime UI call |
| `right_buttons` | `right/btn_*` | `high` | `UI_GameGuildBoxInfoView` | L92:LuaUtils.SetActive(im_jiantou_right.transform,false) | keyword appears near runtime UI call |
| `right_buttons` | `right/btn_*` | `high` | `UI_GuildWarBattleGround` | L115:LuaUtils.SetActive(node_rightbot,false) \| L148:LuaUtils.SetActive(node_rightbot,true) | keyword appears near runtime UI call |
| `right_buttons` | `right/btn_*` | `high` | `map_task_info_tips` | L46:s=right_root.transform:GetComponent(typeof(CS.UnityEngine.Animator)) | keyword appears near runtime UI call |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `high` | `-4615102950863731052_UI_Dock_security_xor_raw.lua` | L471:if not e and RedPointMgr:checkCampUnderwearBoxGift()then | keyword appears near runtime UI call |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `high` | `UI_GuildGiftView` | L162:LuaUtils.SetActive(text_box_left_time.transform,false) \| L230:LuaUtils.SetActive(text_box_left_time.transform,true) \| L232:LuaUtils.SetActive(text_box_left_time.transform,false) \| L319:UIUtil.RefreshRedPoint2(rd_box,g) \| L855:elseif e=="guild_gift_box | keyword appears near runtime UI call |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `high` | `UI_GuildTrials_DrillBox_View` | L27:LuaUtils.SetActive(ScrollViewBox.transform,false) \| L28:GameTools.CloseUIForm(UIFormId.UI_GuildTrials_DrillBox_View,true) \| L53:LuaUtils.SetActive(ScrollViewBox.transform,true) \| L54:ForceResetBoxDataAndRefreshView() \| L71:UIUtil.RefreshScrollView(Scro | keyword appears near runtime UI call |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `high` | `UI_GuildWarMain` | L214:function UpdateFirstJoinBoxStatu() \| L272:LuaUtils.SetActive(boxRoot,false) \| L582:LuaUtils.SetActive(boxRoot,true) | keyword appears near runtime UI call |
| `wanfa_button_backgrounds` | `btn_wanfa*/bg_ditu` | `high` | `UI_GuildGiftView` | L283:LuaUtils.SetActive(bg_ditu_1.transform,false) \| L284:LuaUtils.SetActive(bg_ditu_2.transform,false) \| L286:LuaUtils.SetActive(bg_ditu_1.transform,true) \| L288:LuaUtils.SetActive(bg_ditu_2.transform,true) | keyword appears near runtime UI call |
| `wanfa_viewport_mask` | `middle/root_wanfa/Viewport/UIMask` | `high` | `-4615102950863731052_UI_Dock_security_xor_raw.lua` | L134:LuaUtils.SetActive(show_mask.transform,false) \| L427:LuaUtils.SetActive(show_mask.transform,true) \| L428:local t=show_mask.transform:GetComponent(typeof(CS.UnityEngine.CanvasGroup)) \| L435:LuaUtils.SetActive(show_mask.transform,false) | keyword appears near runtime UI call |
| `wanfa_viewport_mask` | `middle/root_wanfa/Viewport/UIMask` | `high` | `-5664616251800369604_UI_Adventure_RootView_security_xor_raw.lua` | L499:local a=root_wanfa.transform.rect | keyword appears near runtime UI call |
| `wanfa_viewport_mask` | `middle/root_wanfa/Viewport/UIMask` | `high` | `-6351603197391775840_UI_MainPage_security_xor_raw.lua` | L210:LuaUtils.SetActive(guide_mask.transform,false) \| L288:LuaUtils.SetActive(guide_mask.transform,false) \| L293:LuaUtils.SetActive(guide_mask.transform,true) \| L451:LuaUtils.SetActive(guide_mask.transform,e) \| L457:LuaUtils.SetActive(guide_mask.transform, | keyword appears near runtime UI call |
| `wanfa_viewport_mask` | `middle/root_wanfa/Viewport/UIMask` | `high` | `UI_GuildTerritory_Radar` | L47:LuaUtils.SetActive(img_mask.transform,false) \| L99:LuaUtils.SetActive(img_mask.transform,true) \| L107:LuaUtils.SetActive(img_mask.transform,false) | keyword appears near runtime UI call |
| `wanfa_viewport_mask` | `middle/root_wanfa/Viewport/UIMask` | `high` | `UI_GuildTrials_DrillBox_View` | L52:LuaUtils.SetActive(btn_mask.transform,false) \| L451:LuaUtils.SetActive(btn_mask.transform,true) \| L471:LuaUtils.SetActive(btn_mask.transform,false) \| L507:LuaUtils.SetActive(btn_mask.transform,false) | keyword appears near runtime UI call |
| `wanfa_viewport_mask` | `middle/root_wanfa/Viewport/UIMask` | `high` | `UI_GuildWarNoOpenForFirst` | L72:UIUtil.SetMarqueeWithDesc(mask_notice,text_notice_desc,100,e,false,true) | keyword appears near runtime UI call |
| `middle_guild_tmqj` | `middle/Image/guild_tmqj` | `medium` | `-7116734803677859758_UI_AdventureInterface_security_xor_raw.lua` | L123:priorArrowArr={EHintArrowAlign.Vertical_Middle}, | keyword match only |
| `middle_guild_tmqj` | `middle/Image/guild_tmqj` | `medium` | `UI_GameGuildBoxInfoView` | L27:EHintArrowAlign.Vertical_Middle, | keyword match only |
| `right_buttons` | `right/btn_*` | `medium` | `CSGuildWarManager` | L89:ModulesInit.ProcedureNormalBattle.SetRightInfo(e.head,nil,e.name,e.level) \| L112:ModulesInit.ProcedureNormalBattle.SetRightInfo(e.headId,t,e.name,e.level) | keyword match only |
| `right_buttons` | `right/btn_*` | `medium` | `GuildTerritoryMgr` | L668:ModulesInit.ProcedureNormalBattle.SetRightInfo(nil,o,t,0) | keyword match only |
| `right_buttons` | `right/btn_*` | `medium` | `GuildTrialsMgr` | L447:ModulesInit.ProcedureNormalBattle.SetRightInfo(h,nil,i,0) | keyword match only |
| `right_buttons` | `right/btn_*` | `medium` | `UI_GuildGiftView` | L445:priorPageArr={EHintPageDir.Right}, | keyword match only |
| `right_buttons` | `right/btn_*` | `medium` | `UI_GuildQuestView` | L56:GameTools:ChangeSkeletonGraphic(t:Find("right/spine"),"Assets/Download/RolePrefabsAndRes/StoryPrefabAndRes/1041_1/1041_1.prefab") | keyword match only |
| `right_buttons` | `right/btn_*` | `medium` | `UI_GuildTrials_MonsDesc_View` | L197:RefreshRightDescView() \| L199:function RefreshRightDescView() | keyword match only |
| `right_buttons` | `right/btn_*` | `medium` | `territory_player_airship` | L176:local t=CS.UnityEngine.Vector2.SignedAngle(Vector2.right,Vector2(t.x,t.y))+90 \| L212:local n=CS.UnityEngine.Vector2.SignedAngle(Vector2.right,Vector2(n.x,n.y)) | keyword match only |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `medium` | `-6351603197391775840_UI_MainPage_security_xor_raw.lua` | L2710:UIUtil.ShowMessageBox( \| L2718:buttons=MessageBoxButtons.OKCancel, | keyword match only |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `medium` | `412370137018619402_UI_SystemSet_security_xor_raw.lua` | L231:UIUtil.ShowMessageBox({ \| L236:buttons=MessageBoxButtons.OKCancel, \| L270:end,UIUtil.ShowMessageBox) | keyword match only |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `medium` | `CSGuildWarManager` | L306:function e:SendGuildWarNoFitstBoxInfoRequest() \| L307:return NetManager.Send(ProtoId.PRT_GUILD_WAR_BOX_REQ) \| L309:function e:OnGuildWarNoFirstBoxInfoResponse(e) \| L312:self.GuildWarStatusInfo.myBoxes=e.myBoxes \| L314:function e:SendGuildWarGetBoxRequ | keyword match only |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `medium` | `GuildMgr` | L210:UIUtil.ShowMessageBox({ \| L229:buttons=MessageBoxButtons.OKCancel, \| L457:buttons=MessageBoxButtons.OKCancel, \| L462:UIUtil.ShowMessageBox(e) \| L515:function e:ReqGuildGiftBox() | keyword match only |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `medium` | `GuildTrialsMgr` | L11:e.EMapBoxTabType={ \| L37:self.mapBoxes={}; \| L38:self.mapBoxeMaps={} \| L39:self.mapBoxeRedMaps={} \| L121:function e:reqGuildTrialsMapBox() \| L122:return NetManager.Send(ProtoId.PRT_GUILD_TRIAL_MAP_BOX_REQ) \| L124:function e:syncGuildTrialsMapBoxData( | keyword match only |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `medium` | `UI_GameGuildBoxInfoView` | L33:GameTools.CloseUIForm(UIFormId.UI_GameGuildBoxInfoView) \| L38:EventSystem.AddListener(CommonEventId.OnEventGameGuildBoxShow,OnEventGameGuildBoxShow) \| L44:OnEventGameGuildBoxShow(e) \| L48:EventSystem.RemoveListener(CommonEventId.OnEventGameGuildBoxShow, | keyword match only |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `medium` | `UI_GuildMemberView` | L13:UIUtil.ShowMessageBox({ \| L17:buttons=MessageBoxButtons.OK, \| L25:UIUtil.ShowMessageBox({ \| L34:buttons=MessageBoxButtons.OKCancel, \| L44:UIUtil.ShowMessageBox({ \| L49:buttons=MessageBoxButtons.OKCancel, | keyword match only |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `medium` | `UI_GuildTerritory_TeamBattle` | L144:buttons=MessageBoxButtons.OKCancel, \| L150:UIUtil.ShowMessageBox(e) | keyword match only |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `medium` | `UI_GuildTrials_Main_View` | L30:shilianBoxBtn.onClick:AddListener(function() \| L31:local e=e:reqGuildTrialsMapBox() \| L34:GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTrials_DrillBox_View,{}) \| L143:LuaUtils.SetChildActive(shilianBoxBtn.transform,"red",false) \| L144:if RedPointMgr:checkS | keyword match only |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `medium` | `UI_GuildTrials_MonsDesc_View` | L346:buttons=MessageBoxButtons.OKCancel, \| L356:UIUtil.ShowMessageBox(e) | keyword match only |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `medium` | `UI_GuildWarBattleGround` | L77:EventSystem.SendEvent(CommonEventId.ShowItemDelayTip,{overTime=TimeUtil.GetServerTimeStamp()+10,sourceType=PROTO_ENUM.ENUM_AWARD_SOURCE_TYPE.AST_BOX_WEEK_BOX}) | keyword match only |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `medium` | `UI_GuildWarBoxRewardGet` | L5:GameTools.CloseUIForm(UIFormId.UI_GuildWarBoxRewardGet) \| L10:ModulesInit.CSGuildWarManager:SendGuildWarGetNoFitstBoxRequest() \| L11:GameTools.CloseUIForm(UIFormId.UI_GuildWarBoxRewardGet) \| L17:local t=ModulesInit.CSGuildWarManager.GuildWarStatusInfo.my | keyword match only |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `medium` | `UI_GuildWarEmbattle` | L124:buttons=MessageBoxButtons.OKCancel, \| L130:UIUtil.ShowMessageBox(e) | keyword match only |
| `wanfa_box_icons` | `wjczbx3 / Boxicon / box` | `medium` | `UI_GuildWarNoOpenForFirst` | L26:local e=t:SendGuildWarGetBoxRequest() \| L28:UpdateFirstJoinBoxStatu() \| L75:UpdateFirstJoinBoxStatu() \| L95:function UpdateFirstJoinBoxStatu() | keyword match only |
| `wanfa_button_backgrounds` | `btn_wanfa*/bg_ditu` | `medium` | `UI_GameGuildBoxInfoView` | L141:uiRect=bg_ditu.transform.rect, \| L174:bg_ditu.transform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal,e) | keyword match only |
| `wanfa_viewport_mask` | `middle/root_wanfa/Viewport/UIMask` | `medium` | `UI_GuildApplyManageView` | L53:UIUtil.SetMarqueeWithOption(t["mask_marquee"].transform,t["text_desc"],PlayerMgr:getPlayerSign(o.sign)) | keyword match only |
| `wanfa_viewport_mask` | `middle/root_wanfa/Viewport/UIMask` | `medium` | `UI_GuildGiftView` | L398:UIUtil.SetMarqueeWithDesc(e["mask_marquee"].transform,e["text_tiaojian2"],100,n,false,false,true) | keyword match only |
| `wanfa_viewport_mask` | `middle/root_wanfa/Viewport/UIMask` | `medium` | `UI_GuildJoinListNewView` | L237:UIUtil.SetMarqueeWithOption(t["mask_marquee"].transform,t["text_desc"],e) \| L400:local t=ScrollViewRank:GetItemCornerPosInViewPort(t,CS.SuperScrollView.ItemCornerEnum.LeftBottom).y; \| L401:if(t+ScrollViewRank.ViewPortSize>=40)then | keyword match only |
| `wanfa_viewport_mask` | `middle/root_wanfa/Viewport/UIMask` | `medium` | `UI_GuildJoinListView` | L212:UIUtil.SetMarqueeWithOption(t["mask_marquee"].transform,t["text_desc"],e) | keyword match only |
| `wanfa_viewport_mask` | `middle/root_wanfa/Viewport/UIMask` | `medium` | `UI_GuildManageView` | L128:UIUtil.SetMarqueeWithDesc(mask_notice,text_notice_desc,100,e,false,true) \| L131:UIUtil.SetMarqueeWithDesc(mask_recruit_notice,text_recruit_notice_desc,100,e,false,true) | keyword match only |
| `wanfa_viewport_mask` | `middle/root_wanfa/Viewport/UIMask` | `medium` | `UI_GuildTerritory_Main` | L70:btn_transfer_mask.onClick:AddListener(function() | keyword match only |
| `wanfa_viewport_mask` | `middle/root_wanfa/Viewport/UIMask` | `medium` | `UI_GuildTerritory_MyInfo` | L33:UIUtil.SetMarqueeWithDesc(mask_marquee,text_desc,100,PlayerMgr:getPlayerSign(e.sign)) | keyword match only |
| `wanfa_viewport_mask` | `middle/root_wanfa/Viewport/UIMask` | `medium` | `map_task_info_tips` | L29:btn_click_mask.onClick:AddListener(function() | keyword match only |
| `bg_beijingtu` | `bg_beijingtu/noalphabg_BG_Guid` | `unresolved` | `` |  | no decoded Lua line directly referenced this blocker term |

## IL2CPP / XLua Runtime API Evidence

- `dump.cs:440020` `UI_GuildMainView` -> public const int UI_GuildMainView = 219;
- `dump.cs:495106` `public class YouYouImage : Image` -> public class YouYouImage : Image // TypeDefIndex: 9469
- `dump.cs:514934` `public class UIMask : Mask` -> public class UIMask : Mask, IUpdateComponent // TypeDefIndex: 9958
- `dump.cs:504096` `SetImageSprite(YouYouImage` -> public static void SetImageSprite(YouYouImage image, string spriteName, bool isSetNativeSize = True) { }
- `dump.cs:504409` `SetImageColor(Image` -> public static void SetImageColor(Image img, float r, float g, float b, float a) { }
- `dump.cs:504478` `SetCanvasAlpha(CanvasGroup` -> public static void SetCanvasAlpha(CanvasGroup canvas, float alpha) { }
- `dump.cs:504211` `LoadMaterialAsset(string` -> public static void LoadMaterialAsset(string path, BaseAction<Material> onComplete) { }
- `dump.cs:495137` `LoadSpriteWithFullPath(string` -> public void LoadSpriteWithFullPath(string path, bool setNativeSize = True, BaseAction onComplete) { }
- `dump.cs:504264` `LoadSpriteWithFullPath(string` -> public static Sprite LoadSpriteWithFullPath(string path) { }
- `dump.cs:506352` `LoadSpriteWithFullPath(string` -> internal Sprite LoadSpriteWithFullPath(string path) { }
- `stringliteral.json:23843` `LoadSpriteWithFullPath` -> "value": "LoadSpriteWithFullPath",
- `stringliteral.json:40455` `LoadSpriteWithFullPath` -> "value": "YouYouImage.LoadSpriteWithFullPath() error! obj = null. spriteName = ",
- `stringliteral.json:53627` `LoadSpriteWithFullPath` -> "value": "invalid arguments to YouYou.YouYouImage.LoadSpriteWithFullPath!",
- `stringliteral.json:23819` `LoadMaterialAsset` -> "value": "LoadMaterialAsset",
- `stringliteral.json:31631` `SetImageColor` -> "value": "SetImageColor",
- `stringliteral.json:31451` `SetCanvasAlpha` -> "value": "SetCanvasAlpha",
- `stringliteral.json:53375` `SetCanvasAlpha` -> "value": "invalid arguments to YouYou.LuaUtils.SetCanvasAlpha!",
- `stringliteral.json:31643` `SetImageSprite` -> "value": "SetImageSprite",

## Guide / Runtime Object Evidence

- Guide rows confirm `UIForm 219` references internal GuildMain wanfa guide button names, including `guide_btn_wanfa1`, `guide_btn_wanfa4`, `guide_btn_wanfa5`, and `guide_btn_wanfa10`.
- `-6486429589706850514_DTGuide_IOSEntityTableData.txt:307` {47002,47,{0},"","","",0,219,"guide_btn_wanfa4",1,1,0,0,"","","",0,0,0,2,"0.5",1,0,"","ON_CLICK_GUILDSHILIAN","",0,0,0,{},0,"",0,0,0,0,0,"noviceguidebubble100202",0,0,3,{347,-196},"","",0,0,{47,48}},
- `-6486429589706850514_DTGuide_IOSEntityTableData.txt:312` {48001,48,{0},"","","",0,219,"guide_btn_wanfa5",1,1,0,0,"","","",0,0,0,2,"0.7",0,0,"","ON_CLICK_GUILDBINFU","",0,0,0,{},0,"",0,0,0,0,0,"noviceguidebubble100206",0,0,4,{-151,-205},"","",0,0,{48}},
- `-8490977536866472334_DTGuide_M_IOSEntityTableData.txt:296` {47002,47,{0},"","","",0,219,"guide_btn_wanfa4",1,1,0,0,"","","",0,0,0,2,"0.5",1,0,"","ON_CLICK_GUILDSHILIAN","",0,0,0,{},0,"",0,0,0,0,0,"noviceguidebubble100202",0,0,3,{347,-196},"","",0,0,{47,48}},
- `-8490977536866472334_DTGuide_M_IOSEntityTableData.txt:301` {48001,48,{0},"","","",0,219,"guide_btn_wanfa5",1,1,0,0,"","","",0,0,0,2,"0.7",0,0,"","ON_CLICK_GUILDBINFU","",0,0,0,{},0,"",0,0,0,0,0,"noviceguidebubble100206",0,0,4,{-151,-205},"","",0,0,{48}},
- `1615573197188881463_DTGuide_KEntityTableData.txt:242` {33001,33,{0},219,"",0,0,0,0,"","","",0,0,0,2,"0.5",0,0,"","",0,{},0,"","",0,0,0,0,0,0,"",0,0,"",0,0,0,"noviceguidebubble100201","noviceguideTitle100003",1,0,0,"",0,0,0,{0},{33,34},{"isInPage(219)"}},
- `1615573197188881463_DTGuide_KEntityTableData.txt:243` {33002,33,{0},219,"guide_btn_wanfa4",1,1,0,0,"","","",0,0,0,2,"0.5",1,0,"","ON_CLICK_GUILDSHILIAN",0,{},0,"","",0,0,0,0,0,0,"",0,0,"",0,0,0,"","",0,0,0,"noviceguidebubble100202",0,0,3,{347,-196},{33,34},{"isInPage(219)"}},
- `1615573197188881463_DTGuide_KEntityTableData.txt:373` {99002,99,{0},219,"guide_btn_close",1,1,0,0,"","","",0,0,0,2,"0.6",1,0,"","",0,{},0,"","",0,0,0,0,0,0,"",0,0,"",0,0,0,"","",0,0,0,"",0,0,0,{0},{99},{"isInPage(219)"}},
- `1615573197188881463_DTGuide_KEntityTableData.txt:635` {470001,470,{0},219,"",0,0,0,0,"","","",0,0,0,1,"OPEN_GUILDMAIN_SUC",1,0,"","",0,{},0,"","",0,0,0,0,0,0,"",0,0,"",0,0,0,"noviceguidebubble470101","noviceguideTitle470101",1,0,0,"",0,0,0,{0},{470,471},{"isInPage(219)"}},
- `1615573197188881463_DTGuide_KEntityTableData.txt:636` {470002,470,{0},219,"guide_btn_wanfa1",1,1,0,0,"","","",0,0,0,2,"0.5",1,0,"","ON_CLICK_GUILDSKYCITY",0,{},0,"","",0,0,0,0,0,0,"",0,0,"",0,0,0,"","",0,0,0,"noviceguidebubble470102",0,0,4,{-192,-175},{470,471},{"isInPage(219)"}},
- `1615573197188881463_DTGuide_KEntityTableData.txt:758` {1007001,1007,{0},219,"guide_btn_wanfa10",1,1,37,1,"","","",0,0,0,2,"0.5",0,0,"","",0,{},0,"","",0,0,0,0,0,0,"",0,0,"",0,0,0,"","",0,0,0,"UI.UI_Radar_Guide13",0,0,2,{322,116},{1007},{"isInPage(219)"}},
- `913961286868333702_DTGuide_K_IOSEntityTableData.txt:296` {47002,47,{0},"","","",0,219,"guide_btn_wanfa4",1,1,0,0,"","","",0,0,0,2,"0.5",1,0,"","ON_CLICK_GUILDSHILIAN","",0,0,0,{},0,"",0,0,0,0,0,"noviceguidebubble100202",0,0,3,{347,-196},"","",0,0,{47,48}},
- `913961286868333702_DTGuide_K_IOSEntityTableData.txt:301` {48001,48,{0},"","","",0,219,"guide_btn_wanfa5",1,1,0,0,"","","",0,0,0,2,"0.7",0,0,"","ON_CLICK_GUILDBINFU","",0,0,0,{},0,"",0,0,0,0,0,"noviceguidebubble100206",0,0,4,{-151,-205},"","",0,0,{48}},

## Interpretation

- `UI_GuildMainView` is confirmed as form id `219`, module `Guild`, prefab `UI_GuildMain`, sprite resource `UIGuild`.
- Runtime API evidence confirms XLua exposes `LuaUtils.SetImageSprite`, `SetImageColor`, `SetCanvasAlpha`, `LoadSpriteWithFullPath`, `LoadMaterialAsset`, and custom `YouYouImage`/`UIMask` paths.
- The remaining white panel is still best classified as runtime/custom initialization missing, not a coordinate issue and not solved by blind sprite joins.
- No active/color/mask/material override was applied because decoded evidence did not yet prove a concrete state change for the top white paths.

## Verification

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_guildmain_runtime_lua_xlua_initialization_trace.json`
- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_guildmain_runtime_lua_xlua_initialization_trace.csv`
- Raw TextAsset CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\guildmain_runtime_lua_xlua_raw_textassets.csv`
- Decode attempts CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\guildmain_runtime_lua_xlua_decode_attempts.csv`
- 107 capture reused for visual baseline: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\guildmain_white_panel_trace\UI_GuildMain_1680x720.png`
- Click validation generatedAt: `2026-06-25 18:47:04`
- Active / clickable / blocked / invoked: `24` / `24` / `0` / `24`

## Next Recommendation

Next: `GuildMain custom component/type reconstruction for YouYouImage and missing MonoBehaviour bindings`.
