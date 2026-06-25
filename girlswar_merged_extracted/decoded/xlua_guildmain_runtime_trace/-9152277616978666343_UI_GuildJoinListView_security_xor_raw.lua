local i={
GuildPage="GuildPage",
RankPage="RankPage",
}
local h=true
local s=false
local a={}
local d={}
local r=nil
local o={}
local n=i.GuildPage
local t=0
local e=0
function OnInit(t,t)
Image.onClick:AddListener(function()
if s then
s=false
filterGuild()
refresh()
else
GameTools.CloseUIForm(UIFormId.UI_GuildJoinListView)
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
ChangePage(i.GuildPage)
end)
btn_rank.onClick:AddListener(function()
ChangePage(i.RankPage)
end)
btn_shuaxin.onClick:AddListener(
function()
if e>TimeUtil.GetServerTimeStamp()then
return
end
ModulesInit.GuildMgr:ReqGuildRecommandList(function(t)
e=TimeUtil.GetServerTimeStamp()+3
SaveMgr:SetStringForKey("guild_recommand_list_refresh_time",tostring(e))
RefreshLeftTime()
end)
end
)
toggle.onValueChanged:AddListener(
function(e)
h=e

filterGuild()
refresh()
end
)
local e={}
e.mPadding1=0
e.mPadding2=0
e.mColumnOrRowCount=1
e.mItemWidthOrHeight=1090
ScrollView:InitListView(0,e,OnGetItemByIndex)
local e={}
e.mPadding1=0
e.mPadding2=0
e.mColumnOrRowCount=1
e.mItemWidthOrHeight=1097
ScrollViewRank:InitListView(0,e,OnGetRankItemByIndex)
end
function OnOpen(r)
EventSystem.AddListener(CommonEventId.OnRespGuildRecommandList,OnRespGuildRecommandList)
EventSystem.AddListener(CommonEventId.OnRespGuildApply,OnRespGuildApply)
EventSystem.AddListener(CommonEventId.OnRespGuildSearch,OnRespGuildSearch)
EventSystem.AddListener(CommonEventId.GuildCloseEntrance,onEventGuildCloseEntrance)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.OnGuildRespRankList,OnGuildRespRankList)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
if PlayerMgr.guildId and PlayerMgr.guildId>0 then
h=true
else
h=false
end
s=false
a={}
o={}
n=i.GuildPage
t=0
e=SaveMgr.GetStringForKey("guild_recommand_list_refresh_time")
e=tonumber(e)or 0
LuaUtils.SetToggleValue(toggle,h)
refresh()
ModulesInit.GuildMgr:ReqGuildRecommandList()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnRespGuildRecommandList,OnRespGuildRecommandList)
EventSystem.RemoveListener(CommonEventId.OnRespGuildApply,OnRespGuildApply)
EventSystem.RemoveListener(CommonEventId.OnRespGuildSearch,OnRespGuildSearch)
EventSystem.RemoveListener(CommonEventId.GuildCloseEntrance,onEventGuildCloseEntrance)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.OnGuildRespRankList,OnGuildRespRankList)
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
StopNoticePopSequence()
end
function OnBeforeDestroy()
end
function OnUpdate()
t=t-Time.deltaTime
if t>0 then
return
end
t=1
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
if n==i.GuildPage then
LuaUtils.SetActive(join_root.transform,true)
refreshGuildInfoPage()
elseif n==i.RankPage then
LuaUtils.SetActive(rank_root.transform,true)
refreshRankPage()
end
RefreshLeftTime()
end
function refreshGuildInfoPage()
ScrollView:SetListItemCount(#a)
ScrollView:RefreshAllShownItem()
LuaUtils.SetActive(toggle.transform,s==false)
LuaUtils.SetActive(btn_sousuo.transform,s==false)
LuaUtils.SetActive(btn_chuangjian.transform,s==false)
LuaUtils.SetActive(btn_shuaxin.transform,s==false)
if s==false then
LuaUtils.SetTextMeshText(text_title,GameTools.GetLocalize("UI.guild.Join.01",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(text_title,GameTools.GetLocalize("UI.guild.Join.24",LanguageCategory.LangCommon))
end
end
function refreshRankPage()
ScrollViewRank:SetListItemCount(#o)
ScrollViewRank:RefreshAllShownItem()
end
function RefreshState()
LuaUtils.SetActive(im_guild_on.transform,false)
LuaUtils.SetActive(im_guild_off.transform,false)
LuaUtils.SetActive(im_rank_on.transform,false)
LuaUtils.SetActive(im_rank_off.transform,false)
if n==i.GuildPage then
LuaUtils.SetActive(im_guild_on.transform,true)
LuaUtils.SetActive(im_rank_off.transform,true)
elseif n==i.RankPage then
LuaUtils.SetActive(im_rank_on.transform,true)
LuaUtils.SetActive(im_guild_off.transform,true)
end
end
function OnGetItemByIndex(e,n)
n=n+1

local o=e:NewListViewItem("gonghui1")
local e=LuaUtils.GetLuaComBinder(o.transform)
local t=e:GetComponents()
local e=a[n]
GameTools:SetImageSprite(t["bg_huizhang"],ModulesInit.GuildMgr:getGuildIconBg(e.bg),false)
GameTools:SetImageSprite(t["im_huizhang"],ModulesInit.GuildMgr:getGuildFg(e.fg),false)
local i=GameTools.GetLocalize("UI.guild.Main.03",LanguageCategory.LangCommon,e.level)
LuaUtils.SetLabelText(t["text_juntuanname"],e.name..tostring("（ID：")..e.guildId..tostring("）"))
LuaUtils.SetLabelText(t["text_power"],UIUtil.toBigNum(e.fight))
LuaUtils.SetLabelText(t["text_juntuanrenshu"],e.curMemCount.."/"..e.maxMemCount)
LuaUtils.SetLabelText(t["text_level"],i)
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
local i=""
if e.joinFightLimit>0 then
if e.joinNeedApprove==true then
i=GameTools.GetLocalize("UI.guild.Tips.23",LanguageCategory.LangCommon,UIUtil.NumTrim(e.joinFightLimit))
else
i=GameTools.GetLocalize("UI.guild.Tips.24",LanguageCategory.LangCommon,UIUtil.NumTrim(e.joinFightLimit))
end
else
if e.joinNeedApprove==true then
i=GameTools.GetLocalize("UI.guild.Tips.25",LanguageCategory.LangCommon)
else
i=GameTools.GetLocalize("UI.guild.Tips.26",LanguageCategory.LangCommon)
end
end
LuaUtils.SetLabelText(t["text_tiaojian"],s..i)
local e=ModulesInit.GuildMgr:getGuildRecruitNotice(e.notice)
UIUtil.SetMarqueeWithOption(t["mask_marquee"].transform,t["text_desc"],e)
if o.IsInitHandlerCalled==false then
t["btn_duihua"].onClick:AddListener(handler(o,function(e)
local e=e.UserObjectData
local e=a[e]
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
t["btn_shenqing"].onClick:AddListener(handler(o,function(e)
local e=e.UserObjectData
local e=a[e]
if e.applyState==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_WAIT_APPROVE then
return
end
local t,a=ModulesInit.GuildMgr:checkApplyGuild(e)
if t==false then
ModulesInit.GuildMgr:ShowGuildNameErrorTip(a)
return
end
local t={
guildId=e.guildId
}
ModulesInit.GuildMgr:ReqGuildApply(t,e.joinNeedApprove)
end))
t["btn_guild_detail"].onClick:AddListener(handler(o,function(e)
local e=e.UserObjectData
local e=a[e]
local e={
guildId=e.guildId,
serverId=UserAccountInfo.serverId
}
NetManager.Send(ProtoId.PRT_GUILD_SNAPSHOT_REQ,e)
end))
o.IsInitHandlerCalled=true
end
o.UserObjectData=n
return o
end
function OnGetRankItemByIndex(e,t)
t=t+1

local i=o[t]
local e=e:NewListViewItem("gonghui_jindi")
local a=LuaUtils.GetLuaComBinder(e.transform)
local a=a:GetComponents()
RefreshRankInfo(a,i)
if e.IsInitHandlerCalled==false then
a["btn_duihua"].onClick:AddListener(handler(e,function(e)
local e=e.UserObjectData
local e=o[e]
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
a["btn_guild_detail"].onClick:AddListener(handler(e,function(e)
local e=e.UserObjectData
local e=o[e]
local e={
guildId=e.guildId,
serverId=UserAccountInfo.serverId
}
NetManager.Send(ProtoId.PRT_GUILD_SNAPSHOT_REQ,e)
end))
a["btn_guild_detail2"].onClick:AddListener(handler(e,function(e)
local e=e.UserObjectData
local e=o[e]
local e={
guildId=e.guildId,
serverId=UserAccountInfo.serverId
}
NetManager.Send(ProtoId.PRT_GUILD_SNAPSHOT_REQ,e)
end))
e.IsInitHandlerCalled=true
end
e.UserObjectData=t
return e
end
function OnGuildRespRankList(t)
o={}
for e=1,ModulesInit.GuildMgr.GuildMaxRankCount do
if t.guilds[e]~=nil then
table.insert(o,t.guilds[e])
else
table.insert(o,{rankNo=e,type="empty"})
end
end
refresh()
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
LuaUtils.SetLabelText(e["text_wanjianame"],t.leaderName)
LuaUtils.SetActive(e["btn_duihua"].transform,t.leaderId~=PlayerMgr.PlayerInfo.uid)
end
end
function OnRespGuildRecommandList(e)
d=e.guilds
filterGuild()
StopNoticePopSequence()
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(0.1)
e:AppendCallback(function()
refresh()
end)
r=e
end
function StopNoticePopSequence()
if r~=nil then
r:Kill()
r=nil
end
end
function OnRespGuildApply(e)
for t=1,#a do
local t=a[t]
if e.guildId==t.guildId then
local a=e.guildId
t.applyState=e.state
refresh()
if e.state==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_WAIT_APPROVE then
elseif e.state==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_AGREE then
EventSystem.SendEvent(CommonEventId.GuildCloseEntrance)
JumpMgr.OnGameJumpUIGuild()
end
break
end
end
end
function filterGuild()
if h then
a={}
for e=1,#d do
local e=d[e]
if e.curMemCount<e.maxMemCount then
table.insert(a,e)
end
end
else
a=d
end
table.sort(a,function(t,e)
if t.level~=e.level then
return t.level>e.level
end
local a=t.maxMemCount-t.curMemCount
local o=e.maxMemCount-e.curMemCount
if a~=o then
return a>o
end
return t.guildId<e.guildId
end)
end
function OnRespGuildSearch(e)
if e.guildInfo~=nil then
s=true
a={}
table.insert(a,e.guildInfo)
refresh()
end
end
function onEventGuildCloseEntrance()
GameTools.CloseUIForm(UIFormId.UI_GuildJoinListView)
end
function OnEventNetReconnectSuccess()
ModulesInit.GuildMgr:ReqGuildRecommandList()
end
function ChangePage(e)
if n==e then
return
end
DoChangePage(e)
end
function DoChangePage(e)
n=e
CheckReqInfo()
refresh(true)
end
function CheckReqInfo()
if n==i.GuildPage then
if#a<=0 then
ModulesInit.GuildMgr:ReqGuildRecommandList()
end
elseif n==i.RankPage then
if#o<=0 then
ModulesInit.GuildMgr:ReqGuildRankList()
end
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

