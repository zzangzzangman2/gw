local n={
GuildPage="GuildPage",
RankPage="RankPage",
}
local a={
None=0,
WaitRelease=1,
WaitLoad=2,
}
local m=false
local r=true
local h=false
local i={}
local e={}
local e=nil
local t={}
local s=n.GuildPage
local l=0
local e=0
local d=0
local o=true
local o=a.None
local c=false
local u=nil
function OnInit(t,t)
Image.onClick:AddListener(function()
if h then
h=false
ModulesInit.GuildMgr:ReqGuildRecommandRmdList(r)
else
c=true
GameTools.CloseUIForm(UIFormId.UI_GuildJoinListNewView)
end
end)
btn_sousuo.onClick:AddListener(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildSearchView)
end)
btn_chuangjian.onClick:AddListener(function()
local e=ModulesInit.GuildMgr:ReqCreateGuildConsume()
e.onCompleted=function(t,e)
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildCreateView,{consumeCount=e.consumeCount})
end
end)
btn_guild.onClick:AddListener(function()
ChangePage(n.GuildPage)
end)
btn_rank.onClick:AddListener(function()
ChangePage(n.RankPage)
end)
btn_shuaxin.onClick:AddListener(
function()
if e>TimeUtil.GetServerTimeStamp()then
return
end
ModulesInit.GuildMgr:ReqGuildRecommandRmdList(not r,function(t)
e=TimeUtil.GetServerTimeStamp()+3
SaveMgr:SetStringForKey("guild_recommand_list_refresh_time",tostring(e))
RefreshLeftTime()
end)
end
)
toggle.onValueChanged:AddListener(
function(e)
r=e
ModulesInit.GuildMgr:ReqGuildRecommandRmdList(not r)
end
)
local e={}
e.mPadding1=0
e.mPadding2=0
e.mColumnOrRowCount=1
e.mItemWidthOrHeight=1090
ScrollView:InitListView(0,e,OnGetItemByIndex)
ScrollViewRank:InitListView(0,OnGetRankItemByIndex)
ScrollViewRank.mOnBeginDragAction=function()
OnRankScollBeginDrag()
end
ScrollViewRank.mOnDragingAction=function()
OnRankScollDrag()
end
ScrollViewRank.mOnEndDragAction=function()
OnRankScollEndDrag()
end
end
function OnOpen(n)
u=n
EventSystem.AddListener(CommonEventId.OnRespGuildRecommandAllList,OnRespGuildRecommandAllList)
EventSystem.AddListener(CommonEventId.OnRespGuildRecommandRmdList,OnRespGuildRecommandRmdList)
EventSystem.AddListener(CommonEventId.OnRespGuildRecommandRankList,OnRespGuildRecommandRankList)
EventSystem.AddListener(CommonEventId.OnRespGuildApply,OnRespGuildApply)
EventSystem.AddListener(CommonEventId.OnRespGuildSearch,OnRespGuildSearch)
EventSystem.AddListener(CommonEventId.GuildCloseEntrance,onEventGuildCloseEntrance)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
c=false
o=a.None
h=false
i={}
t={}
l=0
e=SaveMgr.GetStringForKey("guild_recommand_list_refresh_time")
e=tonumber(e)or 0
LuaUtils.SetToggleValue(toggle,r)
ModulesInit.GuildMgr:ReqGuildRecommandAllList(not r)
SaveMgr.SetBoolForKey("GuideInviteFirstShow",true)
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="OPEN_GUILDJOINLIST_SUC"})
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnRespGuildRecommandRmdList,OnRespGuildRecommandRmdList)
EventSystem.RemoveListener(CommonEventId.OnRespGuildRecommandAllList,OnRespGuildRecommandAllList)
EventSystem.RemoveListener(CommonEventId.OnRespGuildRecommandRankList,OnRespGuildRecommandRankList)
EventSystem.RemoveListener(CommonEventId.OnRespGuildApply,OnRespGuildApply)
EventSystem.RemoveListener(CommonEventId.OnRespGuildSearch,OnRespGuildSearch)
EventSystem.RemoveListener(CommonEventId.GuildCloseEntrance,onEventGuildCloseEntrance)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
if u then
if u.callback then
u.callback(u.sender,c)
end
end
end
function OnBeforeDestroy()
end
function OnUpdate()
l=l-Time.deltaTime
if l>0 then
return
end
l=1
RefreshLeftTime()
end
function RefreshLeftTime()
local e=e-TimeUtil.GetServerTimeStamp()
if e<=0 then
UIUtil.SetGray(btn_shuaxin.transform,false)
LuaUtils.SetTextMeshText(text_shuaxin,GameTools.GetLocalize("UI.guild.Tips.27",LanguageCategory.LangCommon))
else
UIUtil.SetGray(btn_shuaxin.transform,true)
LuaUtils.SetTextMeshText(text_shuaxin,GameTools.GetLocalize("UI.Arena.Main.17",LanguageCategory.LangCommon,math.ceil(e)))
end
end
function refresh()
RefreshState()
LuaUtils.SetActive(join_root.transform,false)
LuaUtils.SetActive(rank_root.transform,false)
if s==n.GuildPage then
LuaUtils.SetActive(join_root.transform,true)
refreshGuildInfoPage()
elseif s==n.RankPage then
LuaUtils.SetActive(rank_root.transform,true)
refreshRankPage()
end
RefreshLeftTime()
end
function refreshGuildInfoPage()
ScrollView:SetListItemCount(#i)
ScrollView:RefreshAllShownItem()
if m then
m=false
ScrollView:MovePanelToItemIndex(0,0)
end
LuaUtils.SetActive(toggle.transform,h==false)
LuaUtils.SetActive(btn_sousuo.transform,h==false)
LuaUtils.SetActive(btn_chuangjian.transform,h==false)
LuaUtils.SetActive(btn_shuaxin.transform,h==false)
if h==false then
LuaUtils.SetTextMeshText(text_title,GameTools.GetLocalize("UI.guild.Join.01",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(text_title,GameTools.GetLocalize("UI.guild.Join.24",LanguageCategory.LangCommon))
end
end
function refreshRankPage()
if d==0 then
ScrollViewRank:SetListItemCount(#t)
ScrollViewRank:RefreshAllShownItem()
else
ScrollViewRank:SetListItemCount(#t+1)
ScrollViewRank:RefreshAllShownItem()
end
end
function RefreshState()
LuaUtils.SetActive(im_guild_on.transform,false)
LuaUtils.SetActive(im_guild_off.transform,false)
LuaUtils.SetActive(im_rank_on.transform,false)
LuaUtils.SetActive(im_rank_off.transform,false)
if s==n.GuildPage then
LuaUtils.SetActive(im_guild_on.transform,true)
LuaUtils.SetActive(im_rank_off.transform,true)
elseif s==n.RankPage then
LuaUtils.SetActive(im_rank_on.transform,true)
LuaUtils.SetActive(im_guild_off.transform,true)
end
end
function OnGetItemByIndex(e,n)
n=n+1
local a=e:NewListViewItem("gonghui1")
local e=LuaUtils.GetLuaComBinder(a.transform)
local t=e:GetComponents()
local e=i[n]
GameTools:SetImageSprite(t["bg_huizhang"],ModulesInit.GuildMgr:getGuildIconBg(e.bg),false)
GameTools:SetImageSprite(t["im_huizhang"],ModulesInit.GuildMgr:getGuildFg(e.fg),false)
local o=GameTools.GetLocalize("UI.guild.Main.03",LanguageCategory.LangCommon,e.level)
LuaUtils.SetLabelText(t["text_juntuanname"],e.name..tostring("（ID：")..e.guildId..tostring("）"))
LuaUtils.SetLabelText(t["text_power"],UIUtil.toBigNum(e.fight))
LuaUtils.SetLabelText(t["text_juntuanrenshu"],e.curMemCount.."/"..e.maxMemCount)
LuaUtils.SetLabelText(t["text_level"],o)
if e.applyState==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_WAIT_APPROVE then
UIUtil.SetGray(t["btn_shenqing"].transform,true)
LuaUtils.SetTextMeshText(t["text_shenqing"],GameTools.GetLocalize("UI.guild.Join.28",LanguageCategory.LangCommon))
else
local a,o=ModulesInit.GuildMgr:checkApplyGuild(e)
UIUtil.SetGray(t["btn_shenqing"].transform,a==false)
if e.joinNeedApprove==true then
LuaUtils.SetTextMeshText(t["text_shenqing"],GameTools.GetLocalize("UI.guild.Join.11",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(t["text_shenqing"],GameTools.GetLocalize("UI.dragon.TeamList.05",LanguageCategory.LangCommon))
end
end
local s=GameTools.GetLocalize("UI.guild.Tips.22",LanguageCategory.LangCommon)
local o=""
if e.joinFightLimit>0 then
if e.joinNeedApprove==true then
o=GameTools.GetLocalize("UI.guild.Tips.23",LanguageCategory.LangCommon,UIUtil.NumTrim(e.joinFightLimit))
else
o=GameTools.GetLocalize("UI.guild.Tips.24",LanguageCategory.LangCommon,UIUtil.NumTrim(e.joinFightLimit))
end
else
if e.joinNeedApprove==true then
o=GameTools.GetLocalize("UI.guild.Tips.25",LanguageCategory.LangCommon)
else
o=GameTools.GetLocalize("UI.guild.Tips.26",LanguageCategory.LangCommon)
end
end
LuaUtils.SetLabelText(t["text_tiaojian"],s..o)
local e=ModulesInit.GuildMgr:getGuildRecruitNotice(e.notice)
UIUtil.SetMarqueeWithOption(t["mask_marquee"].transform,t["text_desc"],e)
if a.IsInitHandlerCalled==false then
t["btn_duihua"].onClick:AddListener(handler(a,function(e)
local e=e.UserObjectData
local e=i[e]
if e.leaderId==PlayerMgr.PlayerInfo.uid then
UIUtil.ShowCommonTips("UI.guild.Join.07",LanguageCategory.LangCommon)
else
local e={
icon=e.leaderHead,
name=e.leaderName,
frame=e.leaderHeadFrame,
playerId=e.leaderId,
}
UIUtil.showPrivateChat(e,UserAccountInfo.serverId)
end
end))
t["btn_shenqing"].onClick:AddListener(handler(a,function(e)
local e=e.UserObjectData
local e=i[e]
if e.applyState==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_WAIT_APPROVE then
return
end
local a,t=ModulesInit.GuildMgr:checkApplyGuild(e)
if a==false then
ModulesInit.GuildMgr:ShowGuildNameErrorTip(t)
return
end
local t={
guildId=e.guildId
}
ModulesInit.GuildMgr:ReqGuildApply(t,e.joinNeedApprove)
end))
t["btn_guild_detail"].onClick:AddListener(handler(a,function(e)
local e=e.UserObjectData
local e=i[e]
local e={
guildId=e.guildId,
serverId=UserAccountInfo.serverId
}
NetManager.Send(ProtoId.PRT_GUILD_SNAPSHOT_REQ,e)
end))
a.IsInitHandlerCalled=true
end
a.UserObjectData=n
return a
end
function OnGetRankItemByIndex(e,a)
a=a+1
if a==#t+1 then
local e=e:NewListViewItem("gonghui_jindi_2")
RefreshRankLoadingTip(e)
return e
end
local i=t[a]
local e=e:NewListViewItem("gonghui_jindi")
local o=LuaUtils.GetLuaComBinder(e.transform)
local o=o:GetComponents()
RefreshRankInfo(o,i)
if e.IsInitHandlerCalled==false then
o["btn_guild_detail"].onClick:AddListener(handler(e,function(e)
local e=e.UserObjectData
local e=t[e]
local e={
guildId=e.guildId,
serverId=UserAccountInfo.serverId
}
NetManager.Send(ProtoId.PRT_GUILD_SNAPSHOT_REQ,e)
end))
o["btn_shenqing"].onClick:AddListener(handler(e,function(e)
local e=e.UserObjectData
local e=t[e]
if e.applyState==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_WAIT_APPROVE then
return
end
local a,t=ModulesInit.GuildMgr:checkApplyGuild(e)
if a==false then
ModulesInit.GuildMgr:ShowGuildNameErrorTip(t)
return
end
local t={
guildId=e.guildId
}
ModulesInit.GuildMgr:ReqGuildApply(t,e.joinNeedApprove)
end))
e.IsInitHandlerCalled=true
end
e.UserObjectData=a
return e
end
function RefreshRankLoadingTip(e)
if e==nil then
return
end
local e=LuaUtils.GetLuaComBinder(e.transform)
local e=e:GetComponents()
if o==a.None then
LuaUtils.SetActive(e["gonghui_jindi_2"].transform,false)
elseif o==a.WaitRelease then
LuaUtils.SetActive(e["gonghui_jindi_2"].transform,true)
LuaUtils.SetLabelText(e["text_load_refresh"],GameTools.GetLocalize("UI.guild.Main.29",LanguageCategory.LangCommon))
elseif o==a.WaitLoad then
LuaUtils.SetActive(e["gonghui_jindi_2"].transform,true)
LuaUtils.SetLabelText(e["text_load_refresh"],GameTools.GetLocalize("UI.guild.Main.30",LanguageCategory.LangCommon))
end
end
function RefreshRankInfo(e,t)
if e==nil or t==nil then
return
end
if t.rankNo>=1 and t.rankNo<=3 then
LuaUtils.SetActive(e["im_qizi"].transform,true)
LuaUtils.SetActive(e["text_paiming_num"].transform,false)
GameTools:SetImageSprite(e["im_qizi"],UIUtil.getRankIcon(t.rankNo),false)
else
LuaUtils.SetActive(e["im_qizi"].transform,false)
LuaUtils.SetActive(e["text_paiming_num"].transform,true)
LuaUtils.SetTextMeshText(e["text_paiming_num"],t.rankNo)
end
if t.type=="empty"then
LuaUtils.SetActive(e["node_empty"].transform,true)
LuaUtils.SetActive(e["node_have"].transform,false)
else
LuaUtils.SetActive(e["node_empty"].transform,false)
LuaUtils.SetActive(e["node_have"].transform,true)
GameTools:SetImageSprite(e["bg_huizhang"],ModulesInit.GuildMgr:getGuildIconBg(t.bg),false)
GameTools:SetImageSprite(e["im_huizhang"],ModulesInit.GuildMgr:getGuildFg(t.fg),false)
local a=GameTools.GetLocalize("UI.guild.Main.03",LanguageCategory.LangCommon,t.level)
LuaUtils.SetLabelText(e["text_juntuanname"],t.name..tostring("（")..a..tostring("）"))
LuaUtils.SetLabelText(e["text_juntuanlv"],tostring("ID：")..t.guildId)
LuaUtils.SetLabelText(e["text_zhanli"],GameTools.GetLocalize("UI.guild.Join.30",LanguageCategory.LangCommon,UIUtil.NumTrim(t.fight)))
LuaUtils.SetLabelText(e["text_juntuanrenshu"],t.curMemCount.."/"..t.maxMemCount)
if t.applyState==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_WAIT_APPROVE then
UIUtil.SetGray(e["btn_shenqing"].transform,true)
LuaUtils.SetTextMeshText(e["text_shenqing"],GameTools.GetLocalize("UI.guild.Join.28",LanguageCategory.LangCommon))
else
local a,o=ModulesInit.GuildMgr:checkApplyGuild(t)
UIUtil.SetGray(e["btn_shenqing"].transform,a==false)
if t.joinNeedApprove==true then
LuaUtils.SetTextMeshText(e["text_shenqing"],GameTools.GetLocalize("UI.guild.Join.11",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(e["text_shenqing"],GameTools.GetLocalize("UI.dragon.TeamList.05",LanguageCategory.LangCommon))
end
end
end
end
function OnRankScollBeginDrag()
end
function OnRankScollDrag()
if d==0 then
return
end
if o~=a.None and o~=a.WaitRelease then
return
end
local e=ScrollViewRank:GetShownItemByItemIndex(#t)
if e==nil then
return
end
local t=ScrollViewRank:GetShownItemByItemIndex(#t-1)
if t==nil then
return
end
local t=ScrollViewRank:GetItemCornerPosInViewPort(t,CS.SuperScrollView.ItemCornerEnum.LeftBottom).y;
if(t+ScrollViewRank.ViewPortSize>=40)then
if(o~=a.None)then
return
end
o=a.WaitRelease
RefreshRankLoadingTip(e)
else
if(o~=a.WaitRelease)then
return
end
o=a.None
RefreshRankLoadingTip(e)
end
end
function OnRankScollEndDrag()
if d==0 then
return
end
if o~=a.None and o~=a.WaitRelease then
return
end
local e=ScrollViewRank:GetShownItemByItemIndex(#t)
if e==nil then
return
end
ScrollViewRank:OnItemSizeChanged(e.ItemIndex);
if(o~=a.WaitRelease)then
return
end
o=a.WaitLoad
RefreshRankLoadingTip(e)
ModulesInit.GuildMgr:ReqGuildRecommandRankList(d)
end
function OnRespGuildRecommandAllList(e)
if e.tab==1 then
s=n.GuildPage
else
s=n.RankPage
end
i=e.guilds
for a=1,#e.rankList do
if e.rankList[a].rankNo and e.rankList[a].rankNo>0 then
if not t[e.rankList[a].rankNo]then
t[e.rankList[a].rankNo]=e.rankList[a]
end
end
end
d=e.rankPage
refresh()
end
function OnRespGuildRecommandRmdList(e)
i=e.guilds
m=true
refresh()
end
function OnRespGuildRecommandRankList(e)
d=e.rankPage
for a=1,#e.guilds do
if e.guilds[a].rankNo and e.guilds[a].rankNo>0 then
if not t[e.guilds[a].rankNo]then
t[e.guilds[a].rankNo]=e.guilds[a]
end
end
end
if o==a.WaitLoad then
o=a.None
end
if d==0 then
ScrollViewRank:SetListItemCount(#t,false)
ScrollViewRank:RefreshAllShownItem()
else
ScrollViewRank:SetListItemCount(#t+1,false)
ScrollViewRank:RefreshAllShownItem()
end
end
function OnRespGuildApply(e)
local a=0
for t=1,#i do
local t=i[t]
if e.guildId==t.guildId then
local o=e.guildId
t.applyState=e.state
if e.state==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_WAIT_APPROVE then
elseif e.state==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_AGREE then
a=1
end
break
end
end
for o=1,#t do
local t=t[o]
if e.guildId==t.guildId then
local o=e.guildId
t.applyState=e.state
if e.state==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_WAIT_APPROVE then
elseif e.state==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_AGREE then
a=1
end
break
end
end
refresh()
if a==1 then
EventSystem.SendEvent(CommonEventId.GuildCloseEntrance)
JumpMgr.OnGameJumpUIGuild()
end
end
function OnRespGuildSearch(e)
if e.guildInfo~=nil then
h=true
i={}
table.insert(i,e.guildInfo)
refresh()
end
end
function onEventGuildCloseEntrance()
GameTools.CloseUIForm(UIFormId.UI_GuildJoinListNewView)
end
function OnEventNetReconnectSuccess()
ModulesInit.GuildMgr:ReqGuildRecommandAllList(not r)
end
function ChangePage(e)
if s==e then
return
end
DoChangePage(e)
end
function DoChangePage(e)
s=e
refresh(true)
end
function CheckReqInfo()
if s==n.GuildPage then
if#i<=0 then
ModulesInit.GuildMgr:ReqGuildRecommandList()
end
elseif s==n.RankPage then
if#t<=0 then
ModulesInit.GuildMgr:ReqGuildRecommandRankList()
end
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

