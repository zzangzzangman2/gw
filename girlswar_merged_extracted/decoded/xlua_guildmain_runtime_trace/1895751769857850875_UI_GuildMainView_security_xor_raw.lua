local I=require('DataNode/DataTable/Create/help/DTHelpDBModel')
local U=require("DataNode/DataTable/Create/guild/DTGreatBossDBModel")
local T=require('Common/cs_coroutine')
local s=ModulesInit.CSGuildWarManager:GetGuildWarDBCfg()
local C=math.abs
local l=false
local O=false
local c=true
local p=nil
local h=""
local w=false
local m=false
local y=false
local r=nil
local e=nil
local D=false
local e=nil
local L=nil
local R=nil
local n=nil
local S=5
local k=0
local g=0
local i=nil
local A=nil
local N=Vector2(3000,0)
local H=Vector2(-3000,0)
local b=nil
local t={
[1]={actType="actType1"},
[2]={actType="actType2"},
[3]={actType="actType3"},
[4]={actType="actType4"}
}
local j=nil
local d=nil
local t=nil
local a={}
local f={}
local E=nil
local z=nil
local u=false
local o=nil
local v=false
local x=nil
local _=nil
local q=true
function OnInit(o,e)
z=LuaUtils.GetRectTransformWidth(gonggaoMask)/2
E=-z
btn_close.onClick:AddListener(
function()
if not GameEntry.UI:IsExists(UIFormId.UI_MainPage)then
GameEntry.UI:OpenUIForm(UIFormId.UI_MainPage)
end
GameTools.CloseUIForm(UIFormId.UI_GuildMainView)
end
)
btn_1.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_ShopMain,{type=PROTO_ENUM.ENUM_SHOP_TYPE.SHOP_GUILD})
end
)
LuaUtils.SetActive(btn_1.transform,GameTools:IsReview()==false)
btn_2.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildRankView)
end
)
btn_3.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildMemberView)
end
)
btn_5.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildGiftView)
end
)
btn_6.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildQuestView)
end
)
btn_biangeng.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildChangeNameView)
end
)
btn_zhaomu.onClick:AddListener(
function()
if PlayerMgr.PlayerInfo.guildPos~=PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER
and PlayerMgr.PlayerInfo.guildPos~=PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER_DEPUTY then
UIUtil.ShowCommonTipsForLocalize('UI.guild.Manage.59')
return
end
if ModulesInit.GuildMgr.recruitCD>TimeUtil.serverMillTimeStamp then
UIUtil.ShowCommonTipsForLocalize('UI.guild.Tips.28')
return
end
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildRecruit)
end
)
btn_shezhi.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildManageView)
end
)
btn_gonggao.onClick:AddListener(
function()
ToggleShowNotice()
end
)
btn_bangzhu.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="Guild"})
end
)
self:AddBtnClickListener(btn_wanfa1.transform:GetComponent(typeof(CS.UnityEngine.UI.Button)),
function()
EventSystem.SendEvent(CommonEventId.OnEventNextGuide,{event="ON_CLICK_GUILDSKYCITY"})
ModulesInit.PhotoArtistMgr:setRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.SkyCityHelpId)
ModulesInit.SkyCityMgr:EnterSkyCity(nil,{from=UIFormId.UI_GuildMainView})
EventSystem.SendEvent(CommonEventId.NewShowInfoChange)
end)
llv_skycity_self_city:InitListView(0,OnGetCityItemByIndex)
btn_sky_city_box.onClick:AddListener(
function()
if ModulesInit.GuideMgr.isGuide then
return
end
local e={}
for t=1,#Constant.citywar_show_awards do
local t={
itemDid=Constant.citywar_show_awards[t],
count=0,
}
table.insert(e,t)
end
local e={
itemArr=e,
worldPos=btn_sky_city_box.transform.position,
offset=50,
priorPageArr={EHintPageDir.Up},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
}
UIUtil.ShowBoxTip(e)
end
)
local e=LuaUtils.GetLuaComBinder(btn_wanfa2.transform)
local e=e:GetComponents()
e["titan_bg"].onClick:AddListener(
function()
ModulesInit.TitanMgr:EnterTitan(false)
end
)
e["titan_boxicon"].onClick:AddListener(
function()
local t={}
for e=1,#Constant.titans_show_awards do
local e={
itemDid=Constant.titans_show_awards[e],
count=0,
}
table.insert(t,e)
end
local e={
itemArr=t,
worldPos=e["titan_boxicon"].transform.position,
offset=50,
priorPageArr={EHintPageDir.Up},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
}
UIUtil.ShowBoxTip(e)
end
)
e["btn_titan_set"].onClick:AddListener(
function()
if t then
GameEntry.UI:OpenUIForm(UIFormId.UI_TitanIdleSetView,{titanServerInfo=t})
end
end
)
self:AddBtnClickListener(btn_wanfa3.transform:GetComponent(typeof(CS.UnityEngine.UI.Button)),
function()
ModulesInit.PhotoArtistMgr:setRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.TournamentHelpId)
if ModulesInit.CSGuildWarManager:GuildWarIsUnlock()then
ModulesInit.CSGuildWarManager:Enter()
end
EventSystem.SendEvent(CommonEventId.NewShowInfoChange)
end
)
local e=btn_wanfa3:GetComponents()
e["box"].onClick:AddListener(
function()
local t={}
for e=1,#Constant.guildBattle_show_awards do
local e={
itemDid=Constant.guildBattle_show_awards[e],
count=0,
}
table.insert(t,e)
end
local e={
itemArr=t,
worldPos=e["box"].transform.position,
offset=50,
priorPageArr={EHintPageDir.Up},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
}
UIUtil.ShowBoxTip(e)
end
)
self:AddBtnClickListener(btn_wanfa8.transform:GetComponent(typeof(CS.UnityEngine.UI.Button)),
function()
ModulesInit.GreatBossMgr:ClickEnterGame()
end
)
local t=btn_wanfa8:GetComponents()
t["box"].onClick:AddListener(
function()
local e={}
for t=1,#Constant.greatboss_show_awards do
local t={
itemDid=Constant.greatboss_show_awards[t],
count=0,
}
table.insert(e,t)
end
local e={
itemArr=e,
worldPos=t["box"].transform.position,
offset=50,
priorPageArr={EHintPageDir.Up},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
}
UIUtil.ShowBoxTip(e)
end
)
self:AddBtnClickListener(btn_wanfa4.transform:GetComponent(typeof(CS.UnityEngine.UI.Button)),
function()
ModulesInit.GuildTrialsMgr:EnterView()
end
)
local e=btn_wanfa4:GetComponents()
e["box"].onClick:AddListener(
function()
if ModulesInit.GuideMgr.isGuide then
return
end
local t={}
for e=1,#Constant.guildTrials_show_awards do
local e={
itemDid=Constant.guildTrials_show_awards[e],
count=0,
}
table.insert(t,e)
end
local e={
itemArr=t,
worldPos=e["box"].transform.position,
offset=50,
priorPageArr={EHintPageDir.Up},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
}
UIUtil.ShowGuildBoxTip2(e)
end
)
e["btn_actHelp"].onClick:AddListener(
function()
local t=GameTools.GetLocalize("hyakuniti_bigenemy_double",LanguageCategory.LangCommon)
local e={
worldPos=e["btn_actHelp"].transform.position,
hintDes=t,
offset=10,
priorPageArr={EHintPageDir.Down},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
textSizeType=EHintSizeType.Standard
}
UIUtil.ShowHint(e)
end
)
if GameEntry.IsReview then
LuaUtils.SetActive(btn_wanfa6.transform,false)
LuaUtils.SetActive(btn_wanfa7.transform,false)
LuaUtils.SetActive(btn_wanfa9.transform,false)
end
self:AddBtnClickListener(btn_wanfa6.transform:GetComponent(typeof(CS.UnityEngine.UI.Button)),
function()
ModulesInit.DragonBoatMgr:EnterView()
end
)
local e=btn_wanfa6:GetComponents()
e["btn_actHelp"].onClick:AddListener(function()
local t=GameTools.GetLocalize("hyakuniti_huachuan_double",LanguageCategory.LangCommon)
local e={
worldPos=e["btn_actHelp"].transform.position,
hintDes=t,
}
UIUtil.ShowHint(e)
end)
e["box"].onClick:AddListener(
function()
local t={}
for e=1,#Constant.dragon_boat_show_awards do
local e={
itemDid=Constant.dragon_boat_show_awards[e],
count=0,
}
table.insert(t,e)
end
local e={
itemArr=t,
worldPos=e["box"].transform.position,
offset=50,
priorPageArr={EHintPageDir.Up},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
}
UIUtil.ShowBoxTip(e)
end
)
btn_dargonBoat_help.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="huachuan"})
end
)
self:AddBtnClickListener(btn_wanfa7.transform:GetComponent(typeof(CS.UnityEngine.UI.Button)),
function()
if ModulesInit.FullServerBattleMgr:isShowPreheat()then
UIUtil.ShowCommonTips(GameTools.GetLocalize("SourceWorldSeasonPrTips",LanguageCategory.LangCommon))
return
end
if ModulesInit.FullServerBattleMgr:IsEnterFSB()then
ModulesInit.PhotoArtistMgr:setRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.FSBHelpId)
end
ModulesInit.FullServerBattleMgr:enterFSBMMain()
end)
btn_skycity_help.onClick:AddListener(
function()
if ModulesInit.SkyCityMgr.skyState==nil then return end
if GameFunction:CheckNewDrawPoolServerByData5()then
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="Sky.CityData4",isOpen=ModulesInit.SkyCityMgr.skyState.type==PROTO_ENUM.ENUM_GVG_TYPE.GVG_CROSS_SERVER})
else
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="Sky.City",isOpen=ModulesInit.SkyCityMgr.skyState.type==PROTO_ENUM.ENUM_GVG_TYPE.GVG_CROSS_SERVER})
end
end
)
self:AddBtnClickListener(btn_wanfa9.transform:GetComponent(typeof(CS.UnityEngine.UI.Button)),
function()
if ModulesInit.FullServerBattleYearMgr:IsEnterFSB()then
ModulesInit.PhotoArtistMgr:setRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.FSBYHelpId)
end
ModulesInit.FullServerBattleYearMgr:enterFSBMMain()
end)
local e=LuaUtils.GetLuaComBinder(btn_wanfa10.transform)
local e=e:GetComponents()
e["lingtu_bg"].onClick:AddListener(
function()
ModulesInit.GuildTerritoryMgr:EnterGuildTerritoryMainView(nil,true)
end
)
e["btn_lingtu_set"].onClick:AddListener(
function()
ModulesInit.GuildTerritoryMgr:EnterGuildTerritoryMainView(nil,true)
end
)
e["btn_lingtu_help"].onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="UI_GuildTerritory_Main_Help"})
end
)
e["lingtu_boxicon"].onClick:AddListener(
function()
local a={}
local t=ModulesInit.GuildTerritoryMgr:GetRadarBaseCfg()
if t then
local e=t.showAwards
for t=1,#e do
local e={
itemDid=e[t],
count=0,
}
table.insert(a,e)
end
end
local e={
itemArr=a,
worldPos=e["lingtu_boxicon"].transform.position,
offset=50,
priorPageArr={EHintPageDir.Up},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
}
UIUtil.ShowBoxTip(e)
end
)
btn_titan_help.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="Titans"})
end
)
btn_guildbattle_help.onClick:AddListener(
function()
if ModulesInit.CSGuildWarManager.GuildWarStatusInfo==nil then return end
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="Tournament",isOpen=ModulesInit.CSGuildWarManager.GuildWarStatusInfo.warType==PROTO_ENUM.ENUM_GUILD_WAR_TYPE.WAR_CS_SERVER})
end
)
btn_guildTrials_help.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="guildTrials"})
end
)
btn_amulet_help.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="amulet"})
end
)
btn_fsb_help.onClick:AddListener(
function()
if ModulesInit.FullServerBattleMgr:isShowPreheat()then
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="fsb_help_sign_SeasonPr",isOpen=true})
else
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="fsb_help_sign",isOpen=true})
end
end
)
btn_fsb_box.onClick:AddListener(
function()
if ModulesInit.FullServerBattleMgr:IsCanReqServer()and not ModulesInit.FullServerBattleMgr:isShowPreheat()then
local t=ModulesInit.FullServerBattleMgr:getCfg()
local e={}
for a=1,#t.rewardDisplay do
local t={
itemDid=t.rewardDisplay[a][1],
count=0,
}
table.insert(e,t)
end
local e={
itemArr=e,
worldPos=btn_fsb_box.transform.position,
offset=50,
priorPageArr={EHintPageDir.Up},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
}
UIUtil.ShowBoxTip(e)
else
local e={
worldPos=btn_fsb_box.transform.position,
hintDes=GameTools.GetLocalize("fsb_not_open_award_tips"),
offset=10,
priorPageArr={EHintPageDir.Up},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
textSizeType=EHintSizeType.Standard
}
UIUtil.ShowHint(e)
end
end
)
btn_fsby_help.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="SourceWorldAnnual_Help_sign",isOpen=true})
end
)
btn_fsby_box.onClick:AddListener(
function()
local t=ModulesInit.FullServerBattleYearMgr:getCfg()
local e={}
for a=1,#t.rewardDisplay do
local t={
itemDid=t.rewardDisplay[a][1],
count=0,
}
table.insert(e,t)
end
local e={
itemArr=e,
worldPos=btn_fsby_box.transform.position,
offset=50,
priorPageArr={EHintPageDir.Up},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
}
UIUtil.ShowBoxTip(e)
end
)
btn_greatboss_help.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="GreatBoss"})
end
)
UIUtil.AddTouchEvent(
btn_jiantou_left,
function(e)
h=EMoveingDir.Left
end,
function(e)
h=EMoveingDir.Stop
end
)
UIUtil.AddTouchEvent(
btn_jiantou_right,
function(e)
h=EMoveingDir.Right
end,
function(e)
h=EMoveingDir.Stop
end
)
if GameTools:IsReview()then
end
if GameEntry.IsCommittee then
LuaUtils.SetActive(btn_5.transform,false)
LuaUtils.SetLocalPos(root_wanfa.transform,100,0,0)
LuaUtils.SetRectTransformSizeDelta(root_wanfa.transform,540,600)
end
b=o:GetComponent(typeof(CS.UnityEngine.Animator))
if not IsNil(b)then
b.keepAnimatorControllerStateOnDisable=true
end
end
function OnOpen(e)
EventSystem.SendEvent(CommonEventId.RedPointInfoChange)
EventSystem.SendEvent(CommonEventId.NewShowInfoChange)
EventSystem.AddListener(CommonEventId.GuildInfoChange,OnEventGuildInfoChange)
EventSystem.AddListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.AddListener(CommonEventId.OnGuildPosChange,OnGuildPosChange)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.AddListener(CommonEventId.RedPointInfoChange,RefreshRedPoint)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.OnPlayInfoChange,OnPlayInfoChange)
EventSystem.AddListener(CommonEventId.OnEventRewardViewClose,OnEventRewardViewClose)
EventSystem.AddListener(CommonEventId.GuildWarStageSync,OnGuildWarStageSync)
EventSystem.AddListener(CommonEventId.SKY_ALL_CITY_STATE_CHANGE,RefreshSkyCityInfo)
EventSystem.AddListener(CommonEventId.OnEventRefreshTitanInfo,OnEventRefreshTitanInfo)
EventSystem.AddListener(CommonEventId.OnRespGuildTrialsInfo,OnRespGuildTrialsInfo)
EventSystem.AddListener(CommonEventId.NewShowInfoChange,onNewShowChange)
EventSystem.AddListener(CommonEventId.SKY_STATE_CHANGE,RefreshRedPoint)
EventSystem.AddListener(CommonEventId.NewDay,OnNewDay)
EventSystem.AddListener(CommonEventId.SendGuildRecruitChat,OnSendGuildRecruitChat)
EventSystem.AddListener(CommonEventId.OnEventActInfoChange,OnEventActInfoChange)
EventSystem.AddListener(CommonEventId.OnClosePhotoArtist,OnClosePhotoArtist)
EventSystem.AddListener(CommonEventId.OnBoatRespEntranceInfo,OnBoatRespEntranceInfo)
EventSystem.AddListener(CommonEventId.OnPlayCurrencyRefresh,OnPlayCurrencyRefresh)
EventSystem.AddListener(ModulesInit.FullServerBattleMgr.FSB_STATE_CHANGE,OnFsbStateChange)
EventSystem.AddListener(CommonEventId.OnFSBPreheatOpen,OnFsbStateChange)
EventSystem.AddListener(CommonEventId.OnEventTitanDescInfo,OnEventTitanDescInfo)
EventSystem.AddListener(CommonEventId.OnGreatBossInfoRefreshEvent,OnGreatBossInfoRefreshEvent)
EventSystem.AddListener(CommonEventId.OnLuaViewChange,OnLuaViewChange)
l=false
O=false
p=nil
h=""
w=false
m=false
y=false
D=false
t=nil
o=nil
q=true
k=0
StopExitGuildSequence()
LuaUtils.SetActive(btn_biangeng.transform,false)
LuaUtils.SetActive(btn_shezhi.transform,false)
LuaUtils.SetActive(btn_zhaomu.transform,false)
LuaUtils.SetLabelText(text_guild_name,"")
LuaUtils.SetTextMeshText(text_guild_id,"")
LuaUtils.SetTextMeshText(text_guild_renshu,"")
LuaUtils.SetTextMeshText(text_level_num,"")
LuaUtils.SetImageFillAmount(im_level_jindutiao,0)
LuaUtils.SetTextMeshText(text_level_max,"")
LuaUtils.SetLabelText(text_notice_message,"")
LuaUtils.SetActive(node_gonggao.transform,false)
local e=ContentWanfa.gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
e:SetLayoutVertical()
LuaUtils.RebuildLayout(ContentWanfa.transform)
UIUtil.setScrollViewAutoByContainerSize(root_wanfa,true)
llv_skycity_self_city:SetListItemCount(0)
RefreshRedPoint()
onNewShowChange()
RefreshTitanInfo()
local e=ModulesInit.CSGuildWarManager:SendGuildWarStatusInfoRequest()
e.onCompleted=function()
UpdateGuildWarTapStyle()
end
A=nil
ModulesInit.GreatBossMgr:ReqGreatBossInfoMust()
RefreshGuildTrials()
RefreshDragonBoatInfo()
local e=ContentWanfa.transform:GetComponent(typeof(CS.UnityEngine.UI.HorizontalLayoutGroup))
local t=ContentWanfa.transform:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
t.enabled=true
e.enabled=true
ModulesInit.FullServerBattleMgr:getFSBState(true)
local e=I.GetEntity(ModulesInit.PhotoArtistMgr.FirstUI.GuildHelpId)
if not ModulesInit.PhotoArtistMgr:getDataById(e.helpImage)then
u=true
end
ModulesInit.PhotoArtistMgr:checkIDShowUI(ModulesInit.PhotoArtistMgr.FirstUI.GuildHelpId)
ModulesInit.GuildMgr:ReqGuildEnter()
ModulesInit.FullServerBattleYearMgr:getFSBState(true)
LuaUtils.SetActive(btn_wanfa3.transform,GameEntry.IsReview==false)
LuaUtils.SetActive(btn_wanfa7.transform,GameEntry.IsReview==false)
LuaUtils.SetActive(btn_wanfa1.transform,GameEntry.IsReview==false)
LuaUtils.SetActive(btn_wanfa4.transform,GameEntry.IsReview==false)
LuaUtils.SetActive(btn_wanfa7.transform,GameTools:IsReview()==false)
LuaUtils.SetActive(btn_wanfa9.transform,GameTools:IsReview()==false)
if GameEntry.IsReview then
local a,e,t=LuaUtils.GetLocalPos(btn_wanfa2.transform)
LuaUtils.SetLocalPos(btn_wanfa2.transform,0,e,t)
end
RefreshActTip()
OnFsbStateChange()
EventSystem.SendEvent(CommonEventId.NewShowInfoChange)
g=Time.realtimeSinceStartup+1
LuaUtils.SetActive(btn_wanfa8.transform,GameEntry.IsReview==false and ModulesInit.GreatBossMgr:GreatBossIsOpen())
LuaUtils.SetActive(btn_wanfa10.transform,GameTools:IsReview()==false and GameFunction.IsFunctionUnLock(GameFunctionType.GuildTerritory,false))
if not u then
ModulesInit.GuideMgr:CheckRadar_Enter_Guide()
end
end
function OnClose()
v=false
u=false
if i then
i:Stop()
i=nil
end
if n then
n:Stop()
n=nil
end
l=false
EventSystem.RemoveListener(CommonEventId.GuildInfoChange,OnEventGuildInfoChange)
EventSystem.RemoveListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.RemoveListener(CommonEventId.OnGuildPosChange,OnGuildPosChange)
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.RemoveListener(CommonEventId.RedPointInfoChange,RefreshRedPoint)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.OnPlayInfoChange,OnPlayInfoChange)
EventSystem.RemoveListener(CommonEventId.OnEventRewardViewClose,OnEventRewardViewClose)
EventSystem.RemoveListener(CommonEventId.GuildWarStageSync,OnGuildWarStageSync)
EventSystem.RemoveListener(CommonEventId.SKY_ALL_CITY_STATE_CHANGE,RefreshSkyCityInfo)
EventSystem.RemoveListener(CommonEventId.OnEventRefreshTitanInfo,OnEventRefreshTitanInfo)
EventSystem.RemoveListener(CommonEventId.OnRespGuildTrialsInfo,OnRespGuildTrialsInfo)
EventSystem.RemoveListener(CommonEventId.NewShowInfoChange,onNewShowChange)
EventSystem.RemoveListener(CommonEventId.SKY_STATE_CHANGE,RefreshRedPoint)
EventSystem.RemoveListener(CommonEventId.NewDay,OnNewDay)
EventSystem.RemoveListener(CommonEventId.SendGuildRecruitChat,OnSendGuildRecruitChat)
EventSystem.RemoveListener(CommonEventId.OnEventActInfoChange,OnEventActInfoChange)
EventSystem.RemoveListener(CommonEventId.OnClosePhotoArtist,OnClosePhotoArtist)
EventSystem.RemoveListener(CommonEventId.OnBoatRespEntranceInfo,OnBoatRespEntranceInfo)
EventSystem.RemoveListener(CommonEventId.OnPlayCurrencyRefresh,OnPlayCurrencyRefresh)
EventSystem.RemoveListener(ModulesInit.FullServerBattleMgr.FSB_STATE_CHANGE,OnFsbStateChange)
EventSystem.RemoveListener(CommonEventId.OnFSBPreheatOpen,OnFsbStateChange)
EventSystem.RemoveListener(CommonEventId.OnEventTitanDescInfo,OnEventTitanDescInfo)
EventSystem.RemoveListener(CommonEventId.OnGreatBossInfoRefreshEvent,OnGreatBossInfoRefreshEvent)
EventSystem.RemoveListener(CommonEventId.OnLuaViewChange,OnLuaViewChange)
StopNoticePopSequence()
StopExitGuildSequence()
c=true
OnStopNoticeSequence()
ResetSkyCityStatus()
end
function OnStopNoticeCoroutine()
if j then
T.stop(j)
j=nil
end
end
function OnBeforeDestroy()
end
function OnUpdate()
if q==false then
return
end
e=root_wanfa
L=e.viewport
R=e.content
if h==EMoveingDir.Left then
if UIUtil.isScrollRectStart(e)==false then
e.velocity=N
end
elseif h==EMoveingDir.Right then
if UIUtil.isScrollRectEnd(e)==false then
e.velocity=H
end
else
if(C(e.velocity.x))<=1 then
if y==true then
y=false
RefreshArrow()
end
else
if y==false then
y=true
RefreshArrow()
end
end
end
if Time.realtimeSinceStartup>k+S then
k=Time.realtimeSinceStartup
UpdateFunc()
end
if Time.realtimeSinceStartup>g+1 then
g=Time.realtimeSinceStartup
UpdateCountDown()
end
end
function Refresh()
if l==false or ModulesInit.GuildMgr.guildInfo==nil then
return
end
LuaUtils.SetActive(btn_biangeng.transform,ModulesInit.GuildMgr:checkCanManageGuild(ModulesInit.GuildMgr.EGuildManageType.CHANGE_NAME))
LuaUtils.SetActive(btn_shezhi.transform,ModulesInit.GuildMgr:checkShowManageBtn())
LuaUtils.SetActive(btn_zhaomu.transform,ModulesInit.GuildMgr:checkShowManageBtn())
GameTools:SetImageSprite(bg_huizhang.transform,ModulesInit.GuildMgr:getGuildIconBg(ModulesInit.GuildMgr.guildInfo.bg),false)
GameTools:SetImageSprite(im_huizhang.transform,ModulesInit.GuildMgr:getGuildFg(ModulesInit.GuildMgr.guildInfo.fg),false)
LuaUtils.SetLabelText(text_guild_name,ModulesInit.GuildMgr.guildInfo.name)
LuaUtils.SetTextMeshText(text_guild_id,GameTools.GetLocalize("UI.guild.Main.01",LanguageCategory.LangCommon,ModulesInit.GuildMgr.guildInfo.guildId))
LuaUtils.SetTextMeshText(
text_guild_renshu,
GameTools.GetLocalize("UI.guild.Main.02",LanguageCategory.LangCommon,ModulesInit.GuildMgr.guildInfo.curMemCount,ModulesInit.GuildMgr.guildInfo.maxMemCount)
)
LuaUtils.SetTextMeshText(text_level_num,GameTools.GetLocalize("UI.guild.Main.03",LanguageCategory.LangCommon,ModulesInit.GuildMgr.guildInfo.level))
if ModulesInit.GuildMgr:isMaxLevel()then
LuaUtils.SetImageFillAmount(im_level_jindutiao,1)
LuaUtils.SetTextMeshText(text_level_max,GameTools.GetLocalize("UI.Soul.Main.08",LanguageCategory.LangCommon))
else
local e=ModulesInit.GuildMgr:getGuildMaxExpByLevel(ModulesInit.GuildMgr.guildInfo.level)
LuaUtils.SetImageFillAmount(im_level_jindutiao,ModulesInit.GuildMgr.guildInfo.exp/e)
LuaUtils.SetTextMeshText(text_level_max,GameTools.GetLocalize("UI.guild.Main.04",LanguageCategory.LangCommon,ModulesInit.GuildMgr.guildInfo.exp,e))
end
local e=ModulesInit.GuildMgr:getGuildNotice(ModulesInit.GuildMgr.guildInfo.notice)
LuaUtils.SetLabelText(text_notice_message,e)
SetShowNotice()
RefreshRedPoint()
onNewShowChange()
RefreshTitanInfo()
UpdateRecruitBtnCD()
end
function UpdateGonggaoTipsSize()
T.start(function()
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
local e=text_notice_message.transform:GetComponent(typeof(CS.UnityEngine.RectTransform))
local e=e.rect.height
local t=0
if e>=92 and e<276 then
t=55+e
elseif e<92 then
t=127
elseif e>276 then
t=127*3
end
LuaUtils.SetRectTransformSizeDelta(gonggao_ditu.transform,gonggao_ditu.rect.width,t)
end)
end
function UpdateGonggaoTipsSize2()
if not c then
return
end
OnStopNoticeSequence()
d=CS.DG.Tweening.DOTween.Sequence()
d:AppendInterval(1)
d:AppendCallback(
function()
if ModulesInit.GuildMgr.guildInfo and ModulesInit.GuildMgr.guildInfo.notice then
c=false
local e=ModulesInit.GuildMgr:getGuildNotice(ModulesInit.GuildMgr.guildInfo.notice)
LuaUtils.SetLabelText(text_notice,e)
if text_notice then
local e=LuaUtils.GetRectLabelTextWidth(text_notice)
LuaUtils.SetLocalPos(text_notice.transform,z)
LuaUtils.DrawMarqueeMove(text_notice.transform,E-e,0,0,15,function()
if not c then
c=true
UpdateGonggaoTipsSize2()
end
end)
end
end
end
)
end
function OnStopNoticeSequence()
if d then
d:Kill()
d=nil
end
end
function RefreshArrow()
if UIUtil.isScrollRectStart(root_wanfa)~=w then
w=w==false
UIUtil.SetGray(btn_jiantou_left.transform,w)
end
if UIUtil.isScrollRectEnd(root_wanfa)~=m then
m=m==false
UIUtil.SetGray(btn_jiantou_right.transform,m)
end
end
function OnPlayCurrencyRefresh()
RefreshRedPoint()
end
function RefreshRedPoint()
if
RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GUILD_TREASURE)or RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GUILD_GIFT_NORMAL)or
RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GUILD_GIFT_ADVANCE)
then
LuaUtils.SetActive(rd_gift_box.transform,true)
else
LuaUtils.SetActive(rd_gift_box.transform,false)
end
if GameEntry.IsCommittee then
LuaUtils.SetActive(rd_gift_box.transform,false)
end
LuaUtils.SetActive(rd_shezhi.transform,RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GUILD_APPLY))
LuaUtils.SetActive(rd_wanfa_1.transform,RedPointMgr:checkSkyCityRedPoint())
LuaUtils.SetActive(p_skycity_award_red.transform,RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GVG_RED))
LuaUtils.SetActive(rd_wanfa_2.transform,RedPointMgr:checkTitanRedPoint())
LuaUtils.SetActive(rd_shiwusuo.transform,RedPointMgr:checkGuildOfficeRedPoint())
LuaUtils.SetActive(rd_wanfa_4.transform,RedPointMgr:checkGuildTrialsRedPoint())
LuaUtils.SetChildActive(btn_wanfa3.transform,'new_no_open/bg_msg/RedDot',RedPointMgr:checkCSGuildWarRedPoint())
LuaUtils.SetActive(btn_wanfa3.transform,GameTools:IsReview()==false)
LuaUtils.SetActive(btn_wanfa1.transform,GameTools:IsReview()==false)
LuaUtils.SetActive(rd_dragonBoat.transform,RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.DRAGON_BOAT))
LuaUtils.SetActive(p_fsb_red.transform,ModulesInit.FullServerBattleMgr:IsCanReqServer()and RedPointMgr:CheckFSBRedPoint()or RedPointMgr:CheckFSBTaskRedPoint())
LuaUtils.SetActive(p_fsby_red.transform,RedPointMgr:CheckFSBYRedPoint()or RedPointMgr:CheckFSBYTaskRedPoint()or ModulesInit.FullServerBattleYearMgr:CheckFSBYChooseProcessRedPoint())
LuaUtils.SetActive(p_lingtu_red.transform,ModulesInit.GuildTerritoryMgr:IsActHaveRed())
RefreshShopRedPoint()
RefreshGreatBossRedTran()
end
function RefreshShopRedPoint()
local e=ModulesInit.ActBlackFridayMgr:HasPrivilege()
LuaUtils.SetActive(node_friday.transform,e)
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.SHOP_GUILD_RED)and e==false then
LuaUtils.SetChildActive(btn_1.transform,'RedDot',true)
else
LuaUtils.SetChildActive(btn_1.transform,'RedDot',false)
end
end
function OnEventActInfoChange()
RefreshShopRedPoint()
OnFsbyStateChange()
end
function OnClosePhotoArtist(e)
if e and e.helpId and e.helpId==ModulesInit.PhotoArtistMgr.FirstUI.GuildHelpId and u then
u=false
ModulesInit.GuideMgr:CheckGuideByGuildMain()
ModulesInit.GuideMgr:CheckRadar_Enter_Guide()
local t=ContentWanfa.transform:GetComponent(typeof(CS.UnityEngine.UI.HorizontalLayoutGroup))
local e=ContentWanfa.transform:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
if ModulesInit.GuideMgr.isGuide then
e.enabled=false
t.enabled=false
else
e.enabled=true
t.enabled=true
end
end
end
function OnBoatRespEntranceInfo(e)
o=e and e.proto
RefreshDragonBoatInfo()
RefreshBoatImageNew()
end
function OnAmuletStoveInfoChange()
end
function RefreshActTip()
local e=btn_wanfa4:GetComponents()
local t,a=ModulesInit.ActGoldWeekManager:IsOpenDouble(82)
LuaUtils.SetActive(e["im_actTip"].transform,t)
local t=ModulesInit.ActGoldWeekManager:IsShowTip(82)
LuaUtils.SetActive(e["btn_actHelp"].transform,t)
local e=btn_wanfa6:GetComponents()
local t,a=ModulesInit.ActGoldWeekManager:IsOpenDouble(151)
LuaUtils.SetActive(e["im_actTip"].transform,t)
local t=ModulesInit.ActGoldWeekManager:IsShowTip(151)
LuaUtils.SetActive(e["btn_actHelp"].transform,t)
end
function OnNewDay()
RefreshActTip()
end
function onNewShowChange()
LuaUtils.SetActive(im_new_1.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.Guild)and
ModulesInit.PhotoArtistMgr:checkRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.SkyCityHelpId)then
if ModulesInit.GuildMgr:CheckNewShow(ModulesInit.PhotoArtistMgr.FirstUI.SkyCityHelpId)then
ModulesInit.GuildMgr:SetNewShow(ModulesInit.PhotoArtistMgr.FirstUI.SkyCityHelpId)
end
end
LuaUtils.SetActive(im_new_7.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.Guild)and ModulesInit.FullServerBattleMgr:IsEnterFSB()and
ModulesInit.PhotoArtistMgr:checkRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.FSBHelpId)then
if ModulesInit.GuildMgr:CheckNewShow(ModulesInit.PhotoArtistMgr.FirstUI.FSBHelpId)then
ModulesInit.GuildMgr:SetNewShow(ModulesInit.PhotoArtistMgr.FirstUI.FSBHelpId)
end
end
LuaUtils.SetActive(im_new_2.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.Titans)then
if ModulesInit.GuildMgr:CheckNewShow(ModulesInit.PhotoArtistMgr.FirstUI.TitansHelpId)then
ModulesInit.GuildMgr:SetNewShow(ModulesInit.PhotoArtistMgr.FirstUI.TitansHelpId)
end
end
LuaUtils.SetActive(im_new_3.transform,false)
if ModulesInit.CSGuildWarManager:GuildWarIsUnlock(true)and PlayerMgr.PlayerInfo.guildId>0 and
ModulesInit.PhotoArtistMgr:checkRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.TournamentHelpId)then
if ModulesInit.GuildMgr:CheckNewShow(ModulesInit.PhotoArtistMgr.FirstUI.TournamentHelpId)then
ModulesInit.GuildMgr:SetNewShow(ModulesInit.PhotoArtistMgr.FirstUI.TournamentHelpId)
end
end
LuaUtils.SetActive(im_new_4.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.GuildTrials)and PlayerMgr.PlayerInfo.guildId>0 then
if ModulesInit.GuildMgr:CheckNewShow(ModulesInit.PhotoArtistMgr.FirstUI.guildTrialsHelpId)then
ModulesInit.GuildMgr:SetNewShow(ModulesInit.PhotoArtistMgr.FirstUI.guildTrialsHelpId)
end
end
RefreshBoatImageNew()
end
function RefreshBoatImageNew()
LuaUtils.SetActive(im_new_6.transform,false)
if o
and o.state~=PROTO_ENUM.ENUM_BOAT_STATE.ENUM_CLOSE
and GameFunction.IsFunctionUnLock(GameFunctionType.Guild)
and PlayerMgr.PlayerInfo.guildId>0
and ModulesInit.GuildMgr:CheckNewShow(ModulesInit.PhotoArtistMgr.NEW_ID.DragonBoat)then
ModulesInit.GuildMgr:SetNewShow(ModulesInit.PhotoArtistMgr.FirstUI.DragonBoat)
end
end
function OnEventGuildInfoChange()
if l==false then
l=true
end
Refresh()
end
function ShowNoticeInDuration()
end
function ToggleShowNotice()
SetShowNotice(O==false)
end
function SetShowNotice(e)
LuaUtils.SetActive(node_gonggao.transform,true)
UpdateGonggaoTipsSize2()
end
function StopNoticePopSequence()
if p~=nil then
p:Kill()
p=nil
end
end
function OnGuildLeave(e)
EventSystem.SendEvent(CommonEventId.OnSkipGuide2)
StopExitGuildSequence()
GameTools.CloseUIForm(UIFormId.UI_GuildMainView)
ModulesInit.GuildMgr.guildInfo=nil
JumpMgr.OnGameJumpUIMain()
end
function OnGuildPosChange()
Refresh()
end
function OnEventNetReconnectSuccess()
ModulesInit.GuildMgr:ReqGuildEnter()
end
function OnPlayInfoChange()
if PlayerMgr.PlayerInfo.guildId<=0 then
StopExitGuildSequence()
r=CS.DG.Tweening.DOTween.Sequence()
r:AppendInterval(1)
r:AppendCallback(
function()
EventSystem.SendEvent(CommonEventId.OnGuildLeave,{exitType=PROTO_ENUM.ENUM_MANAGE_ACTION.QUIT})
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Tips.16",LanguageCategory.LangCommon))
r=nil
end
)
end
end
function OnEventRewardViewClose()
end
function StopExitGuildSequence()
if r then
r:Kill()
r=nil
end
end
function OnGetItemByIndex(e,e)
end
function OnGuildWarStageSync()
UpdateGuildWarTapStyle()
end
function UpdateGuildWarTapStyle()
if not ModulesInit.CSGuildWarManager:GuildWarIsUnlock()then
return
end
local n=btn_wanfa3.transform
if n then
local e=LuaUtils.GetLuaComBinder(n)
local e=e:GetComponents()
if ModulesInit.CSGuildWarManager.GuildWarStatusInfo then
local a=ModulesInit.CSGuildWarManager:GetGuildWarStage()
local t=""
local o=TimeUtil.timeStampToDateWithAreaTimeZone(ModulesInit.CSGuildWarManager.GuildWarStatusInfo.statusOverTime)
local o=string.format("%02d:%02d",o.hour,o.minute)
if a==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.MATCHING then
local e=string.format("%02d:%02d",TimeUtil.GetAreaTimeZoneHourStr(s.matchTime[1]),s.matchTime[2])
t=GameTools.GetLocalize("UI.guildBattle.main.01",LanguageCategory.LangCommon,e,o)
elseif a==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.FIGHTING then
local e=string.format("%02d:%02d",TimeUtil.GetAreaTimeZoneHourStr(s.battleStartTime[1]),s.battleStartTime[2])
t=GameTools.GetLocalize("UI.guildBattle.main.03",LanguageCategory.LangCommon,e,o)
elseif a==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.PREPARE or a==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.COLLECTION then
local e=string.format("%02d:%02d",TimeUtil.GetAreaTimeZoneHourStr(s.readyTime[1]),s.readyTime[2])
t=GameTools.GetLocalize("UI.guildBattle.main.02",LanguageCategory.LangCommon,e,o)
elseif a==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.STOP then
local e=string.format("%02d:%02d",TimeUtil.GetAreaTimeZoneHourStr(s.nextDayEndTime[1]),s.nextDayEndTime[2])
t=GameTools.GetLocalize("UI.guildBattle.main.04",LanguageCategory.LangCommon,e,o)
end
if t~=""then
t=t..TimeUtil.getAreaTimeZoneSignStr()
end
LuaUtils.SetTextMeshText(e["text_time"],t)
local o=ModulesInit.CSGuildWarManager:GetGuildWarStage()
local t=nil
if o==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.NOT_OPEN then
t='tips.common_1'
elseif o==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.STOP then
t='tips.common_44'
elseif o==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.MATCHING then
t='tips.common_45'
elseif o==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.PREPARE or o==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.COLLECTION then
t='tips.common_46'
elseif o==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.FIGHTING then
t='tips.common_47'
end
if i then
i:Stop()
i=nil
end
local o=true
if a~=PROTO_ENUM.ENUM_GUILD_WAR_STATUS.NOT_OPEN and a~=PROTO_ENUM.ENUM_GUILD_WAR_STATUS.MATCHING then
o=ModulesInit.CSGuildWarManager:GuildIsBye()
end
if o then
LuaUtils.SetActive(e["txt_no_open_msg2"].transform,true)
LuaUtils.SetActive(e["txt_no_open_msg"].transform,false)
LuaUtils.SetActive(e["txt_no_open_time"].transform,false)
LuaUtils.SetChildActive(n,'new_no_open/bg_msg/RedDot',false)
else
LuaUtils.SetActive(e["txt_no_open_msg2"].transform,false)
LuaUtils.SetActive(e["txt_no_open_msg"].transform,true)
LuaUtils.SetActive(e["txt_no_open_time"].transform,true)
UIUtil.SetTextMeshTextForLocalize(e["txt_no_open_msg"],t)
local t=ModulesInit.CSGuildWarManager:GetGuildWarCountDown()
i=ModulesInit.TimeActionMgr:CreateTimeAction()
i:Init(
0,
1,
t,
nil,
function(t)
LuaUtils.SetLabelText(e["txt_no_open_time"],TimeUtil.toDHMSStr2(t))
end,
nil
):Run()
end
end
end
LuaUtils.SetChildActive(n,'new_no_open/bg_msg/RedDot',RedPointMgr:checkCSGuildWarRedPoint())
end
function OnGreatBossInfoRefreshEvent()
UpdateGuildGreatBossStyle()
end
function OnLuaViewChange()
local e=ViewMgr:checkIsTopShowView(self.UIFormId)
q=e
end
function UpdateGuildGreatBossStyle()
if ModulesInit.GreatBossMgr:GreatBossIsOpen()==false then
return
end
local i=btn_wanfa8.transform
if i then
local e=LuaUtils.GetLuaComBinder(i)
local o=e:GetComponents()
A=ModulesInit.GreatBossMgr.status
local t=U.GetEntity(1)
local a=nil
local e=nil
LuaUtils.SetActive(o["im_battle"].transform,ModulesInit.GreatBossMgr.status==ModulesInit.GreatBossMgr.StatusType.Battle)
if ModulesInit.GreatBossMgr.status==ModulesInit.GreatBossMgr.StatusType.Close or
ModulesInit.GreatBossMgr.status==ModulesInit.GreatBossMgr.StatusType.UpGrade then
a='tips.common_1'
e=GameTools.GetLocalize("tips.common_1",LanguageCategory.LangCommon)
elseif ModulesInit.GreatBossMgr.status==ModulesInit.GreatBossMgr.StatusType.Init then
a='UI.greatBoss.main.06'
e=GameTools.GetLocalize("UI.greatBoss.main.05",LanguageCategory.LangCommon,"00:00:00",t.initDataTime)
elseif ModulesInit.GreatBossMgr.status==ModulesInit.GreatBossMgr.StatusType.Open then
a='tips.common_45'
e=GameTools.GetLocalize("UI.greatBoss.main.01",LanguageCategory.LangCommon,t.initDataTime,t.readyTime)
elseif ModulesInit.GreatBossMgr.status==ModulesInit.GreatBossMgr.StatusType.Prepare then
a='tips.common_46'
e=GameTools.GetLocalize("UI.greatBoss.main.02",LanguageCategory.LangCommon,t.readyTime,t.startTime)
elseif ModulesInit.GreatBossMgr.status==ModulesInit.GreatBossMgr.StatusType.Battle then
a='tips.common_47'
e=GameTools.GetLocalize("UI.greatBoss.main.03",LanguageCategory.LangCommon,t.startTime,t.endTime)
elseif ModulesInit.GreatBossMgr.status==ModulesInit.GreatBossMgr.StatusType.Over then
a='tips.common_44'
e=GameTools.GetLocalize("UI.greatBoss.main.04",LanguageCategory.LangCommon,t.endTime,"00:00:00")
end
if not ModulesInit.GreatBossMgr.isCanJoin then
e=GameTools.GetLocalize("ui_greatboss_root_7",LanguageCategory.LangCommon)
end
LuaUtils.SetTextMeshText(o["text_time"],e)
UIUtil.SetTextMeshTextForLocalize(o["txt_no_open_msg"],a)
_=o["txt_no_open_time"]
end
x=i
RefreshGreatBossRedTran()
end
function RefreshGreatBossRedTran()
if x==nil then
return
end
local e=ModulesInit.GreatBossMgr.isCanJoin and ModulesInit.GreatBossMgr:CheckShopRed()
and(ModulesInit.GreatBossMgr.status==ModulesInit.GreatBossMgr.StatusType.Prepare or ModulesInit.GreatBossMgr.status==ModulesInit.GreatBossMgr.StatusType.Battle)
LuaUtils.SetChildActive(x,'new_no_open/bg_msg/RedDot',e)
end
function RefreshTitanInfo()
local e=LuaUtils.GetLuaComBinder(btn_wanfa2.transform)
local e=e:GetComponents()
LuaUtils.SetActive(e["btn_titan_set"].transform,false)
LuaUtils.SetActive(e["titan_status"].transform,false)
LuaUtils.SetActive(e["titan_boss_info"].transform,false)
local a,i,o=GameFunction.IsFunctionUnLock(GameFunctionType.Titans)
if a and PlayerMgr.PlayerInfo.guildId>0 then
if t then
LuaUtils.SetActive(e["titan_status"].transform,true)
if t.status==PROTO_ENUM.ENUM_TITANS_STATUS.TT_STATUS_CLOSE then
LuaUtils.SetActive(e["btn_titan_set"].transform,true)
LuaUtils.SetTextMeshText(e["txt_titan_status"],GameTools.GetLocalize("tips.common_9",LanguageCategory.LangCommon))
elseif t.status==PROTO_ENUM.ENUM_TITANS_STATUS.TT_STATUS_PREPARE then
LuaUtils.SetActive(e["btn_titan_set"].transform,true)
LuaUtils.SetTextMeshText(e["txt_titan_status"],GameTools.GetLocalize("tips.common_7",LanguageCategory.LangCommon))
elseif t.status==PROTO_ENUM.ENUM_TITANS_STATUS.TT_STATUS_BATTLE then
LuaUtils.SetActive(e["titan_boss_info"].transform,true)
local a=ModulesInit.TitanMgr:GetTitanBossProfileCfgData(t.profileDid)
local a=GameTools.GetLocalize(a.bossName,LanguageCategory.LangCommon)
LuaUtils.SetTextMeshText(e["titan_boss_name"],GameTools.GetLocalize("tips.common_13",LanguageCategory.LangCommon,a,t.level))
LuaUtils.SetTextMeshText(e["txt_titan_status"],GameTools.GetLocalize("tips.common_8",LanguageCategory.LangCommon))
end
if t.idleType==PROTO_ENUM.ENUM_TITANS_IDLE_TYPE.TT_IDLE_TYPE_NONE then
LuaUtils.SetTextMeshText(e["txt_titan_idle_state"],GameTools.GetLocalize("tips.common_10",LanguageCategory.LangCommon))
elseif t.idleType==PROTO_ENUM.ENUM_TITANS_IDLE_TYPE.TT_IDLE_TYPE_NOR then
LuaUtils.SetTextMeshText(e["txt_titan_idle_state"],GameTools.GetLocalize("tips.common_11",LanguageCategory.LangCommon))
elseif t.idleType==PROTO_ENUM.ENUM_TITANS_IDLE_TYPE.TT_IDLE_TYPE_ADV then
LuaUtils.SetTextMeshText(e["txt_titan_idle_state"],GameTools.GetLocalize("tips.common_12",LanguageCategory.LangCommon))
end
end
else
if a==false then
LuaUtils.SetActive(e["titan_boss_info"].transform,true)
LuaUtils.SetTextMeshText(e["titan_boss_name"],o)
end
end
end
function RefreshAmuletInfo()
end
function OnEventRefreshTitanInfo(e)
ReqTitanDescInfoAndRefresh()
RefreshTitanInfo()
end
function RefreshGuildTrials()
ModulesInit.GuildTrialsMgr:ReqGuildTrialsInfo()
end
function RefreshDragonBoatInfo()
if o then
if o.state==PROTO_ENUM.ENUM_BOAT_STATE.ENUM_CLOSE then
local e=TimeUtil.timeStampToDateWithServerZone(o.stateOverTime/1000)
LuaUtils.SetTextMeshText(txt_dargonBoat_status,GameTools.GetLocalize("DragonBoatDesc_48",LanguageCategory.LangCommon))
LuaUtils.SetTextMeshText(txt_dragonBoat_desc,GameTools.GetLocalize("DragonBoatDesc_49",LanguageCategory.LangCommon,e.month,e.day))
else
local e=GameTools.GetLocalize("DragonBoatDesc_25",LanguageCategory.LangCommon)..GameTools.GetLocalize("DragonBoatDesc_26",LanguageCategory.LangCommon)
LuaUtils.SetTextMeshText(txt_dragonBoat_desc,e)
if o.state==PROTO_ENUM.ENUM_BOAT_STATE.ENUM_PREPARE then
LuaUtils.SetTextMeshText(txt_dargonBoat_status,GameTools.GetLocalize("DragonBoatDesc_22",LanguageCategory.LangCommon))
elseif o.state==PROTO_ENUM.ENUM_BOAT_STATE.ENUM_SAILING then
LuaUtils.SetTextMeshText(txt_dargonBoat_status,GameTools.GetLocalize("DragonBoatDesc_23",LanguageCategory.LangCommon))
elseif o.state==PROTO_ENUM.ENUM_BOAT_STATE.ENUM_FINISH then
LuaUtils.SetTextMeshText(txt_dargonBoat_status,GameTools.GetLocalize("DragonBoatDesc_24",LanguageCategory.LangCommon))
end
end
else
LuaUtils.SetTextMeshText(txt_dargonBoat_status,"")
LuaUtils.SetTextMeshText(txt_dragonBoat_desc,"")
LuaUtils.SetActive(rd_dragonBoat.transform,false)
end
LuaUtils.SetActive(rd_dragonBoat.transform,RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.DRAGON_BOAT))
end
function OnRespGuildTrialsInfo()
local e=btn_wanfa4:GetComponents()
local t=ModulesInit.GuildTrialsMgr:GetGuildTrialsNum()
if t<=0 then
LuaUtils.SetTextMeshText(e["txt_no_open_msg"],GameTools.GetLocalize("guildTrials_desc_1",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(e["txt_no_open_msg"],GameTools.GetLocalize("guildTrials_desc_2",LanguageCategory.LangCommon))
end
LuaUtils.SetTextMeshText(e["text_time_1"],t)
end
function ResetSkyCityStatus()
local e=LuaUtils.GetLuaComBinder(btn_wanfa1.transform)
local e=e:GetComponents()
LuaUtils.SetActive(e["p_no_open"].transform,false)
LuaUtils.SetActive(e["p_no_open2"].transform,false)
LuaUtils.SetActive(e["p_open"].transform,false)
LuaUtils.SetActive(e["p_curr_state"].transform,true)
LuaUtils.SetActive(e["txt_curr_status_time"].transform,false)
SetHeFu(e,false)
end
function RefreshSkyCityInfo()
if ModulesInit.SkyCityMgr.skyState==nil then return end
if not v then
v=true
ModulesInit.GuideMgr:CheckGuideByGuildMain2()
local t=ContentWanfa.transform:GetComponent(typeof(CS.UnityEngine.UI.HorizontalLayoutGroup))
local e=ContentWanfa.transform:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
if ModulesInit.GuideMgr.unit==ModulesInit.GuideMgr.EGuideCfg.GuildSkyCity and ModulesInit.GuideMgr.isGuide then
e.enabled=false
t.enabled=false
else
e.enabled=true
t.enabled=true
end
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="OPEN_GUILDMAIN_SUC"})
end
ResetSkyCityStatus()
local e=LuaUtils.GetLuaComBinder(btn_wanfa1.transform)
local e=e:GetComponents()
if ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_UPGRADE then
SetHeFu(e,true,ModulesInit.SkyCityMgr.skyState.upgradeOverSecond)
end
if ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_NOT_OPEN
or ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_WAITING
or ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_UPGRADE
or ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_FETCH_DATA
or ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_STOP then
local t=GameTools.GetLocalize("sky_city_stop",LanguageCategory.LangCommon)
LuaUtils.SetTextMeshText(e["tmp_curr_status"],t)
LuaUtils.SetLabelText(e["txt_curr_status_time"],"")
local t=true
if ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_NOT_OPEN
or ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_WAITING then
local o=Constant.citywar_openNum
local a=o<=ModulesInit.SkyCityMgr.skyState.guildCount
if not a then
local a=GameTools.GetLocalize("sky_city_pre_guild_count",LanguageCategory.LangCommon,o)
LuaUtils.SetTextMeshText(e["tmp_pre_open_msg"],a)
t=false
end
LuaUtils.SetActive(e["tmp_pre_open_msg"].transform,not a)
local a=ModulesInit.SkyCityMgr:getEndLeftTime(ModulesInit.SkyCityMgr.skyState.startTime)
if a>0 then
local a=TimeUtil.toDHMSStr2(a)
local a=GameTools.GetLocalize("sky_city_pre_open_time",LanguageCategory.LangCommon,a)
LuaUtils.SetTextMeshText(e["tmp_pre_open_time"],a)
t=false
end
LuaUtils.SetActive(e["tmp_pre_open_time"].transform,a>0)
elseif ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_STOP then
t=false
end
if t then
LuaUtils.SetActive(e["p_no_open2"].transform,true)
local t=TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_declareStartHour,Constant.citywar_declareStartMinute).."-"..TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_declareEndHour,Constant.citywar_declareEndMinute)..TimeUtil.getAreaTimeZoneSignStr()
local n=GameTools.GetLocalize("sky_city_declear_period",LanguageCategory.LangCommon,"")
local a=t
local t=TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_battleStartHour,Constant.citywar_battleStartMinute).."-"..TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_battleEndHour,Constant.citywar_battleEndMinute)..TimeUtil.getAreaTimeZoneSignStr()
local i=GameTools.GetLocalize("sky_city_battle_period",LanguageCategory.LangCommon,"")
local o=t
LuaUtils.SetTextMeshText(e["text_no_open_title1"],n)
LuaUtils.SetTextMeshText(e["text_no_open_time1"],a)
local a=e["text_no_open_title1"].preferredWidth
local t=e["text_no_open_title1"].transform.localPosition
LuaUtils.SetLocalPos(e["text_no_open_time1"].transform,t.x+a+5,t.y,0)
LuaUtils.SetTextMeshText(e["text_no_open_title2"],i)
LuaUtils.SetTextMeshText(e["text_no_open_time2"],o)
local a=e["text_no_open_title2"].preferredWidth
local t=e["text_no_open_title2"].transform.localPosition
LuaUtils.SetLocalPos(e["text_no_open_time2"].transform,t.x+a+5,t.y,0)
else
LuaUtils.SetActive(e["p_no_open"].transform,true)
end
if ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_STOP then
LuaUtils.SetActive(e["p_no_open"].transform,false)
LuaUtils.SetActive(e["p_no_open2"].transform,false)
end
else
LuaUtils.SetActive(e["p_open"].transform,true)
LuaUtils.SetActive(e["p_no_fight"].transform,false)
LuaUtils.SetActive(e["p_fight"].transform,false)
LuaUtils.SetActive(e["txt_curr_status_time"].transform,true)
local i=""
local t=""
local n=""
local o=""
local h=""
local s=""
if ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_PREPARE then
LuaUtils.SetActive(e["p_no_fight"].transform,true)
i=GameTools.GetLocalize("sky_city_declearing",LanguageCategory.LangCommon)
t=TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_declareStartHour,Constant.citywar_declareStartMinute).."-"..TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_declareEndHour,Constant.citywar_declareEndMinute)..TimeUtil.getAreaTimeZoneSignStr()
local e=TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_battleStartHour,Constant.citywar_battleStartMinute).."-"..TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_battleEndHour,Constant.citywar_battleEndMinute)..TimeUtil.getAreaTimeZoneSignStr()
n=GameTools.GetLocalize("sky_city_battle_period",LanguageCategory.LangCommon,"")
o=e
elseif ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_FIGHTING then
i=GameTools.GetLocalize("sky_city_fighting",LanguageCategory.LangCommon)
t=TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_battleStartHour,Constant.citywar_battleStartMinute).."-"..TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_battleEndHour,Constant.citywar_battleEndMinute)..TimeUtil.getAreaTimeZoneSignStr()
LuaUtils.SetActive(e["p_fight"].transform,true)
a,f=ModulesInit.SkyCityMgr:getSelfRelationCity()
local t={}
for o,e in ipairs(a or{})do
local a=f[e.cityId]
if a~=ModulesInit.SkyCityMgr.CITY_TYPE.OWNER and e.status~=PROTO_ENUM.ENUM_CITY_STATUS.CITY_STATUS_BULLY_DECLARED and e.status~=PROTO_ENUM.ENUM_CITY_STATUS.CITY_STATUS_BULLY_FIGHTING then
table.insert(t,e)
end
end
a=t
if#a==llv_skycity_self_city.ItemTotalCount then
llv_skycity_self_city:RefreshAllShownItem()
else
llv_skycity_self_city:SetListItemCount(#a)
end
elseif ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_BULLY_FIGHTING then
i=GameTools.GetLocalize("sky_city_haoh_battleing",LanguageCategory.LangCommon)
t=TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_bullyBattleStartHour,Constant.citywar_bullyBattleStartMinute).."-"..TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_bullyBattleEndHour,Constant.citywar_bullyBattleEndMinute)..TimeUtil.getAreaTimeZoneSignStr()
LuaUtils.SetActive(e["p_fight"].transform,true)
a,f=ModulesInit.SkyCityMgr:getSelfRelationCity()
local t={}
for o,e in ipairs(a or{})do
local a=f[e.cityId]
if a~=ModulesInit.SkyCityMgr.CITY_TYPE.OWNER and e.status==PROTO_ENUM.ENUM_CITY_STATUS.CITY_STATUS_BULLY_FIGHTING then
table.insert(t,e)
end
end
a=t
if#a==llv_skycity_self_city.ItemTotalCount then
llv_skycity_self_city:RefreshAllShownItem()
else
llv_skycity_self_city:SetListItemCount(#a)
end
elseif ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_GIVEUP then
LuaUtils.SetActive(e["p_no_fight"].transform,true)
i=GameTools.GetLocalize("sky_city_give_up_ing",LanguageCategory.LangCommon)
t=TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_preStartHour,Constant.citywar_preStartMinute).."-"..TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_preEndHour,Constant.citywar_preEndMinute)..TimeUtil.getAreaTimeZoneSignStr()
local e=TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_declareStartHour,Constant.citywar_declareStartMinute).."-"..TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_declareEndHour,Constant.citywar_declareEndMinute)..TimeUtil.getAreaTimeZoneSignStr()
n=GameTools.GetLocalize("sky_city_declear_period",LanguageCategory.LangCommon,"")
o=e
local e=TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_battleStartHour,Constant.citywar_battleStartMinute).."-"..TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_battleEndHour,Constant.citywar_battleEndMinute)..TimeUtil.getAreaTimeZoneSignStr()
h=GameTools.GetLocalize("sky_city_battle_period",LanguageCategory.LangCommon,"")
s=e
elseif ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_ENDING then
LuaUtils.SetActive(e["p_no_fight"].transform,true)
i=GameTools.GetLocalize("sky_city_stop",LanguageCategory.LangCommon)
t=""
local e=TimeUtil.GetServerTimeStamp()
e=math.floor(e)
local t,t=ModulesInit.SkyCityMgr:getTodayGiveUpTime()
local a,t=ModulesInit.SkyCityMgr:getTodyDeclearTime()
local a,i=ModulesInit.SkyCityMgr:getTodyFightTime()
if e>t and e<a then
local e=TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_battleStartHour,Constant.citywar_battleStartMinute).."-"..TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_battleEndHour,Constant.citywar_battleEndMinute)..TimeUtil.getAreaTimeZoneSignStr()
n=GameTools.GetLocalize("sky_city_battle_period",LanguageCategory.LangCommon,"")
o=e
else
local e=TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_declareStartHour,Constant.citywar_declareStartMinute).."-"..TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_declareEndHour,Constant.citywar_declareEndMinute)..TimeUtil.getAreaTimeZoneSignStr()
n=GameTools.GetLocalize("sky_city_declear_period",LanguageCategory.LangCommon,"")
o=e
local e=TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_battleStartHour,Constant.citywar_battleStartMinute).."-"..TimeUtil.GetAreaTimeZoneHourMinuteStr(Constant.citywar_battleEndHour,Constant.citywar_battleEndMinute)..TimeUtil.getAreaTimeZoneSignStr()
h=GameTools.GetLocalize("sky_city_battle_period",LanguageCategory.LangCommon,"")
s=e
end
end
LuaUtils.SetTextMeshText(e["text_time1"],n)
LuaUtils.SetTextMeshText(e["text_title_time1"],o)
local a=e["text_time1"].preferredWidth
local a=e["text_time1"].transform.position
LuaUtils.SetTextMeshText(e["text_title2"],h)
LuaUtils.SetTextMeshText(e["text_title_time2"],s)
local a=e["text_title2"].preferredWidth
local a=e["text_title2"].transform.position
LuaUtils.SetActive(e["p_text1"].transform,o~="")
LuaUtils.SetActive(e["p_text2"].transform,s~="")
LuaUtils.SetTextMeshText(e["tmp_curr_status"],i)
LuaUtils.SetLabelText(e["txt_curr_status_time"],t)
LuaUtils.SetActive(e["txt_curr_status_time"].transform,t~="")
end
end
function SetHeFu(e,e,e)
end
function OnGetCityItemByIndex(e,t)
t=t+1
local e=e:NewListViewItem("cityitem")
if e.IsInitHandlerCalled==false then
local t=LuaUtils.GetLuaComBinder(e.transform)
local t=t:GetComponents()
e.BiComs=t
e.BiComs["btn_city"].onClick:AddListener(handler(e,function(e)
local e=e.UserObjectData
local e=a[e]
ModulesInit.SkyCityMgr:EnterSkyCity(e.cityId,{from=UIFormId.UI_GuildMainView})
end))
e.IsInitHandlerCalled=true
end
e.UserObjectData=t
local t=a[t]
local a=ModulesInit.SkyCityMgr:getSkyInfoById(t.cityId)
LuaUtils.SetTextMeshText(e.BiComs["tmp_city_name"],GameTools.GetLocalize(a.skyCityName,LanguageCategory.LangCommon))
GameTools:SetImageSprite(e.BiComs["im_city"],"UIGuild/"..a.UIskyCityIcon)
local a=f[t.cityId]
if a==ModulesInit.SkyCityMgr.CITY_TYPE.DEF then
LuaUtils.SetActive(e.BiComs["im_city_state"].transform,true)
if t.status==PROTO_ENUM.ENUM_CITY_STATUS.CITY_STATUS_BULLY_DECLARED or t.status==PROTO_ENUM.ENUM_CITY_STATUS.CITY_STATUS_BULLY_FIGHTING then
GameTools:SetImageSprite(e.BiComs["im_city_state"],"UIGuild/jtcz_xzjs13",true)
else
GameTools:SetImageSprite(e.BiComs["im_city_state"],"UIGuild/jtcz_xzjs9",true)
end
elseif a==ModulesInit.SkyCityMgr.CITY_TYPE.ACT then
LuaUtils.SetActive(e.BiComs["im_city_state"].transform,true)
local a=ModulesInit.SkyCityMgr:getProtectLeftTime(t.protectEndTime)
if t.status==PROTO_ENUM.ENUM_CITY_STATUS.CITY_STATUS_NORMAL and a>0 then
GameTools:SetImageSprite(e.BiComs["im_city_state"],"UIGuild/jtcz_xzjs12",true)
else
if t.status==PROTO_ENUM.ENUM_CITY_STATUS.CITY_STATUS_BULLY_DECLARED or t.status==PROTO_ENUM.ENUM_CITY_STATUS.CITY_STATUS_BULLY_FIGHTING then
GameTools:SetImageSprite(e.BiComs["im_city_state"],"UIGuild/jtcz_xzjs14",true)
else
GameTools:SetImageSprite(e.BiComs["im_city_state"],"UIGuild/jtcz_xzjs8",true)
end
end
else
LuaUtils.SetActive(e.BiComs["im_city_state"].transform,false)
end
return e
end
function CheckSkyCityAndRefreshStatus()
ModulesInit.SkyCityMgr:CheckSkyCityAndRefreshStatus()
end
function CheckFSBAndRefreshStatus()
if GameTools:IsReview()then
LuaUtils.SetActive(btn_wanfa7.transform,false)
return
end
if ModulesInit.FullServerBattleMgr:isShowPreheat()then
LuaUtils.SetActive(btn_wanfa7.transform,true)
return
end
if not ModulesInit.FullServerBattleMgr:IsCanReqServer()then
LuaUtils.SetActive(btn_wanfa7.transform,false)
return
end
if ModulesInit.FullServerBattleMgr.FSBInfo==nil then
LuaUtils.SetActive(btn_wanfa7.transform,false)
return
end
if ModulesInit.FullServerBattleMgr:IsCanEnterSignView()==false then
LuaUtils.SetActive(btn_wanfa7.transform,false)
return
end
LuaUtils.SetActive(btn_wanfa7.transform,true)
local e=LuaUtils.GetLuaComBinder(btn_wanfa7.transform)
local n=e:GetComponents()
local e=ModulesInit.FullServerBattleMgr
local i=e.FSBInfo.statusOverTime-e:GetCalcTimeStamp()
i=math.max(i,0)
local o=TimeUtil.toDHMSStr2(i)
local t=""
local a=""
if ModulesInit.FullServerBattleMgr.FSBInfo.status==PROTO_ENUM.ENUM_FSB_STATUS.FSB_NOT_OPEN then
if e:IsCanEnterSignView()then
t="sourceWorldPageDisplay_25"
a=o
else
t="fsb_open_dates"
local e=e.FSBInfo.serverEnterTime-e:GetCalcTimeStamp()
e=math.max(e,0)
a=TimeUtil.toDHMSStr2(e)
end
elseif e.FSBInfo.status==PROTO_ENUM.ENUM_FSB_STATUS.FSB_SIGN then
t="sourceWorldPageDisplay_3"
a=o
elseif e.FSBInfo.status==PROTO_ENUM.ENUM_FSB_STATUS.FSB_NORMAL_WAIT then
t="sourceWorldPageDisplay_20"
local e=e:getEarlyEntryToFightOffsetTime()
o=TimeUtil.toDHMSStr2(i+e)
a=o
elseif e.FSBInfo.status==PROTO_ENUM.ENUM_FSB_STATUS.FSB_NORMAL_REVIEW then
t="sourceWorldPageDisplay_20"
a=o
elseif e.FSBInfo.status==PROTO_ENUM.ENUM_FSB_STATUS.FSB_NORMAL_RUNNING then
t="sourceWorldPageDisplay_21"
a=o
elseif e.FSBInfo.status==PROTO_ENUM.ENUM_FSB_STATUS.FSB_NORMAL_END then
t="fsb_game_end"
elseif e.FSBInfo.status==PROTO_ENUM.ENUM_FSB_STATUS.FSB_REST then
t="sourceWorldPageDisplay_25"
a=o
end
LuaUtils.SetTextMeshText(n["text_no_open_title1"],string.format("%s%s",GameTools.GetLocalize(t,LanguageCategory.LangCommon,""),a))
LuaUtils.SetTextMeshText(n["text_no_open_time1"],"")
LuaUtils.SetActive(n["im_fsb_battle"].transform,e.FSBInfo.status==PROTO_ENUM.ENUM_FSB_STATUS.FSB_NORMAL_RUNNING)
end
function UpdateSkyCityCountDown()
if ModulesInit.SkyCityMgr.skyState==nil then
return
end
RefreshSkyCityInfo()
end
function UpdateFunc()
CheckSkyCityAndRefreshStatus()
UpdateTitanFunc()
UpdateDoDragonBoatFunc()
OnFsbStateChange()
OnFsbyStateChange()
end
function UpdateCountDown()
UpdateTitanLeftTime()
CheckFSBAndRefreshStatus()
UpdateSkyCityCountDown()
CheckFSBYAndRefreshStatus()
UpdateGreatBossCountDown()
UpdateLingtuRefreshLeftTime()
end
function UpdateLingtuRefreshLeftTime()
local e=0
local o=TimeUtil.GetServerTimeStamp()
local t=PlayerMgr.PlayerExtInfo.guildRadarLevel or 0
local a=ModulesInit.GuildTerritoryMgr:GetRadarLevelCfgByDid(t)
local t=a and a.refreshExtTime<=t
if t then
e=TimeUtil.GetTodayTimeStep(12,0)
if e<o then
e=TimeUtil.GetTodayTimeStep(24,0)
end
else
e=TimeUtil.GetTodayTimeStep(24,0)
end
local e=math.max(0,e-o)
LuaUtils.SetLabelText(txt_lingtu_left_time,TimeUtil.toDHMSStr2(e))
end
function UpdateGreatBossCountDown()
if ModulesInit.GreatBossMgr:GreatBossIsOpen()==false then
return
end
local e=((ModulesInit.GreatBossMgr.statusEndMS-TimeUtil:GetServerMillTimeStamp())/1000)+1
e=math.max(0,e)
if _ then
LuaUtils.SetLabelText(_,TimeUtil.toDHMSStr2(e))
end
if e<=0 then
ModulesInit.GreatBossMgr:ReqGreatBossInfoMust()
end
end
function UpdateTitanFunc()
UpdateDoTitanFunc()
end
function UpdateDoTitanFunc()
local e,a,a=GameFunction.IsFunctionUnLock(GameFunctionType.Titans)
if e and PlayerMgr.PlayerInfo.guildId>0 then
if t==nil
or t.status==PROTO_ENUM.ENUM_TITANS_STATUS.TT_STATUS_BATTLE
or t.leftTime-TimeUtil.GetServerMillTimeStamp()<0
then
ReqTitanDescInfoAndRefresh()
end
end
end
function ReqTitanDescInfoAndRefresh()
ModulesInit.TitanMgr:ReqTitanDescInfo()
end
function OnEventTitanDescInfo(e)
t=e.desc
RefreshTitanInfo()
UpdateTitanLeftTime()
end
function UpdateDoDragonBoatFunc()
if GameTools:IsReview()then
return
end
if GameFunction.IsFunctionUnLock(GameFunctionType.Guild,true)==false then
return
end
if PlayerMgr.PlayerInfo.guildId>0 then
if o==nil or o.stateOverTime-TimeUtil.GetServerMillTimeStamp()<0 then
ModulesInit.DragonBoatMgr:ReqBoatEntranceInfo()
end
end
end
function UpdateTitanLeftTime()
local e=LuaUtils.GetLuaComBinder(btn_wanfa2.transform)
local e=e:GetComponents()
if t then
local t=math.max(0,(t.leftTime-TimeUtil.GetServerMillTimeStamp())/EDigit.Thousand)
LuaUtils.SetLabelText(e["txt_titan_left_time"],TimeUtil.toDHMSStr2(t))
else
LuaUtils.SetLabelText(e["txt_titan_left_time"],"")
end
end
function OnSendGuildRecruitChat()
UpdateRecruitBtnCD()
end
function UpdateRecruitBtnCD()
if n then
n:Stop()
n=nil
end
local e=math.floor((ModulesInit.GuildMgr.recruitCD-TimeUtil.serverMillTimeStamp)/1000)
if e>0 then
n=ModulesInit.TimeActionMgr:CreateTimeAction()
n:Init(0,1,e,nil,function(e)
LuaUtils.SetChildLabelTextWrap(btn_zhaomu.transform,'text',GameTools.GetLocalize('UI.guild.Tips.30',LanguageCategory.LangCommon,TimeUtil.TimestampToDate2(e)))
end,
function()
LuaUtils.SetChildLabelTextWrap(btn_zhaomu.transform,'text','')
end):Run()
else
LuaUtils.SetChildLabelTextWrap(btn_zhaomu.transform,'text','')
end
end
function OnFsbStateChange()
local e=LuaUtils.GetLuaComBinder(btn_wanfa7.transform)
local e=e:GetComponents()
if ModulesInit.FullServerBattleMgr:isShowPreheat()then
LuaUtils.SetTextMeshText(e["tmp_curr_status"],GameTools.GetLocalize("tips.common_7"))
LuaUtils.SetActive(e["txt_curr_status_time"].transform,false)
LuaUtils.SetTextMeshText(e["text_no_open_title1"],GameTools.GetLocalize("tips.common_124"))
LuaUtils.SetTextMeshText(e["text_no_open_time1"],"")
LuaUtils.SetActive(e["img_award_preheat"].transform,true)
LuaUtils.SetActive(btn_fsb_help.transform,true)
return
end
LuaUtils.SetActive(e["img_award_preheat"].transform,false)
if not ModulesInit.FullServerBattleMgr:IsCanReqServer()then
local a=""
local o=""
local t=""
a=GameTools.GetLocalize("fsb_no_open_tips")
t=GameTools.GetLocalize("fsb_no_open_desc1")
LuaUtils.SetTextMeshText(e["tmp_curr_status"],a)
LuaUtils.SetLabelText(e["txt_curr_status_time"],o)
LuaUtils.SetActive(e["txt_curr_status_time"].transform,o~="")
if t~=""then
LuaUtils.SetTextMeshText(e["text_no_open_title1"],t)
LuaUtils.SetTextMeshText(e["text_no_open_time1"],"")
end
LuaUtils.SetActive(btn_fsb_help.transform,false)
else
if ModulesInit.FullServerBattleMgr.FSBInfo==nil then return end
LuaUtils.SetActive(btn_fsb_help.transform,true)
LuaUtils.SetActive(e["img_award_cup"].transform,false)
LuaUtils.SetActive(e["img_award_cup2"].transform,false)
local a
local t=ModulesInit.FullServerBattleMgr.loginShowInfo
if t then
if t.cupType==1 then
LuaUtils.SetActive(e["img_award_cup"].transform,true)
a="fsb_matchesbrave_brave"
else
LuaUtils.SetActive(e["img_award_cup2"].transform,true)
a="fsb_matchesbrave_king"
end
LuaUtils.SetTextMeshText(e["text_type_cup"],GameTools.GetLocalize(a,LanguageCategory.LangCommon,t.bigSeason,t.raceNum))
end
local t=ModulesInit.FullServerBattleMgr:getCfg()
local n=string.format("%02d:%02d-%02d:%02d",t.applicationTime[1],t.applicationTime[2],t.deadline[1],t.deadline[2])
local t=string.format("%02d:%02d-%02d:%02d",t.competitionOpen[1],t.competitionOpen[2],t.endingTime[1],t.endingTime[2])
local i=GameTools.GetLocalize("fsb_sign_tip")
local t=GameTools.GetLocalize("fsb_battle_tip")
local t=""
local a=""
local o=""
if ModulesInit.FullServerBattleMgr.FSBInfo.status==PROTO_ENUM.ENUM_FSB_STATUS.FSB_NOT_OPEN then
if ModulesInit.FullServerBattleMgr:IsCanEnterSignView()then
t=GameTools.GetLocalize("fsb_armistice_tips")
else
t=GameTools.GetLocalize("fsb_no_open_tips")
end
elseif ModulesInit.FullServerBattleMgr.FSBInfo.status==PROTO_ENUM.ENUM_FSB_STATUS.FSB_SIGN then
t=i
a=n
elseif ModulesInit.FullServerBattleMgr.FSBInfo.status==PROTO_ENUM.ENUM_FSB_STATUS.FSB_NORMAL_WAIT then
t=GameTools.GetLocalize("fsb_prepare_tips")
elseif ModulesInit.FullServerBattleMgr.FSBInfo.status==PROTO_ENUM.ENUM_FSB_STATUS.FSB_NORMAL_REVIEW then
t=GameTools.GetLocalize("fsb_prepare_tips")
elseif ModulesInit.FullServerBattleMgr.FSBInfo.status==PROTO_ENUM.ENUM_FSB_STATUS.FSB_NORMAL_RUNNING then
t=GameTools.GetLocalize("fsb_battle_doing_tips")
elseif ModulesInit.FullServerBattleMgr.FSBInfo.status==PROTO_ENUM.ENUM_FSB_STATUS.FSB_NORMAL_END then
t=GameTools.GetLocalize("fsb_battle_end_tips")
elseif ModulesInit.FullServerBattleMgr.FSBInfo.status==PROTO_ENUM.ENUM_FSB_STATUS.FSB_REST then
t=GameTools.GetLocalize("fsb_armistice_tips")
end
LuaUtils.SetTextMeshText(e["tmp_curr_status"],t)
LuaUtils.SetLabelText(e["txt_curr_status_time"],a)
LuaUtils.SetActive(e["txt_curr_status_time"].transform,a~="")
if o~=""then
LuaUtils.SetTextMeshText(e["text_no_open_title1"],o)
LuaUtils.SetTextMeshText(e["text_no_open_time1"],"")
else
LuaUtils.SetTextMeshText(e["text_no_open_title1"],"")
end
CheckFSBAndRefreshStatus()
end
end
function OnFsbyStateChange()
local e=LuaUtils.GetLuaComBinder(btn_wanfa9.transform)
local t=e:GetComponents()
local e=ModulesInit.FullServerBattleYearMgr:IsOpen()
LuaUtils.SetActive(btn_wanfa9.transform,e)
if e then
if ModulesInit.FullServerBattleYearMgr.FSBInfo==nil then return end
local e=""
local a=""
if ModulesInit.FullServerBattleYearMgr.FSBInfo.stage==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_SIGN then
e=GameTools.GetLocalize("fsby_sign_stage")
elseif ModulesInit.FullServerBattleYearMgr.FSBInfo.stage==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_1_1
or ModulesInit.FullServerBattleYearMgr.FSBInfo.stage==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_1_2 then
e=GameTools.GetLocalize("fsby_group_stage")
elseif ModulesInit.FullServerBattleYearMgr.FSBInfo.stage==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_2_1
or ModulesInit.FullServerBattleYearMgr.FSBInfo.stage==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_2_2 then
e=GameTools.GetLocalize("fsby_eighth_stage")
elseif ModulesInit.FullServerBattleYearMgr.FSBInfo.stage==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_3_1
or ModulesInit.FullServerBattleYearMgr.FSBInfo.stage==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_3_2 then
e=GameTools.GetLocalize("fsby_quarter_stage")
elseif ModulesInit.FullServerBattleYearMgr.FSBInfo.stage==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_4_1
or ModulesInit.FullServerBattleYearMgr.FSBInfo.stage==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_4_2 then
e=GameTools.GetLocalize("fsby_semifinal_stage")
elseif ModulesInit.FullServerBattleYearMgr.FSBInfo.stage==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_5_1 then
e=GameTools.GetLocalize("fsby_final_stage")
elseif ModulesInit.FullServerBattleYearMgr.FSBInfo.stage==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_END then
e=GameTools.GetLocalize("fsby_fight_end")
end
LuaUtils.SetTextMeshText(t["tmp_curr_status"],e)
LuaUtils.SetActive(t["txt_curr_status_time"].transform,a~="")
CheckFSBYAndRefreshStatus()
end
end
function CheckFSBYAndRefreshStatus()
if not ModulesInit.FullServerBattleYearMgr:IsOpen()then
LuaUtils.SetActive(btn_wanfa9.transform,false)
return
end
if ModulesInit.FullServerBattleYearMgr.FSBInfo==nil then return end
local e=LuaUtils.GetLuaComBinder(btn_wanfa9.transform)
local i=e:GetComponents()
local a=ModulesInit.FullServerBattleYearMgr
local t=a.FSBInfo.stage
local e
local o=0
if t==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_SIGN then
e=a:getStageInfo(t)
o=a.FSBInfo.statusOverTime
elseif t==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_1_1 or t==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_1_2 then
e=a:getStageInfo(PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_1_2)
o=e.timestamp+(24*60*60)
elseif t==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_2_1 or t==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_2_2 then
e=a:getStageInfo(PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_2_2)
o=e.timestamp+(24*60*60)
elseif t==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_3_1 or t==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_3_2 then
e=a:getStageInfo(PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_3_2)
o=e.timestamp+(24*60*60)
elseif t==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_4_1 or t==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_4_2 then
e=a:getStageInfo(PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_4_2)
o=e.timestamp+(24*60*60)
elseif t==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_5_1 then
e=a:getStageInfo(PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_5_1)
o=e.timestamp+(24*60*60)
elseif t==PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_END then
e=nil
end
local t=""
local n="fsby_stage_end_left_time"
if e then
local e=o-a:GetCalcTimeStamp()
e=math.max(e,0)
local e=TimeUtil.toDHMSStr2(e)
t=GameTools.GetLocalize(n,LanguageCategory.LangCommon,e)
end
LuaUtils.SetTextMeshText(i["text_no_open_title1"],t)
LuaUtils.SetTextMeshText(i["text_no_open_time1"],"")
LuaUtils.SetActive(i["im_fsby_battle"].transform,ModulesInit.FullServerBattleYearMgr.FSBInfo.isGuildJoin==true and ModulesInit.FullServerBattleYearMgr.FSBInfo.status==PROTO_ENUM.ENUM_FSBY_STATUS.FSBY_STATUS_RACE_RUN)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

