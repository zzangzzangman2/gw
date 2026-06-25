local o={}
local a=nil
function OnInit(e,e)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildRankView)
end)
btn_duihua.onClick:AddListener(function()
if a==nil then
return
end
if a.leaderId==PlayerMgr.PlayerInfo.uid then
UIUtil.ShowCommonTips("UI.guild.Join.07",LanguageCategory.LangCommon)
else
local e={
icon=a.leaderHead,
name=a.leaderName,
frame=a.leaderHeadFrame,
playerId=a.leaderId,
}
UIUtil.showPrivateChat(e,UserAccountInfo.serverId)
end
end)
local e={}
e.mPadding1=0
e.mPadding2=0
e.mColumnOrRowCount=1
e.mItemWidthOrHeight=1097
ScrollView:InitListView(0,e,OnGetItemByIndex)
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.OnGuildRespRankList,OnGuildRespRankList)
EventSystem.AddListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.OnRespGuildApply,OnRespGuildApply)
o={}
a=nil
LuaUtils.SetActive(gonghui_myself.transform,false)
LuaUtils.SetActive(gonghui_myself_empy.transform,false)
Refresh()
ModulesInit.GuildMgr:ReqGuildRankList()
end
function OnFormBack()
ModulesInit.GuildMgr:ReqGuildRankList()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnGuildRespRankList,OnGuildRespRankList)
EventSystem.RemoveListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.OnRespGuildApply,OnRespGuildApply)
end
function OnBeforeDestroy()
end
function Refresh()
ScrollView:SetListItemCount(#o)
ScrollView:RefreshAllShownItem()
RefreshMyselfRank()
end
function RefreshMyselfRank()
LuaUtils.SetActive(gonghui_myself.transform,a~=nil)
LuaUtils.SetActive(gonghui_myself_empy.transform,a==nil)
if a~=nil then
local e=LuaUtils.GetLuaComBinder(gonghui_myself.transform)
local e=e:GetComponents()
RefreshRankInfo(e,a)
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
LuaUtils.SetLabelText(e["text_wanjianame"],t.leaderName)
LuaUtils.SetActive(e["btn_duihua"].transform,t.leaderId~=PlayerMgr.PlayerInfo.uid)
end
end
function OnGetItemByIndex(e,t)
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
function OnGuildRespRankList(e)
a=e.selfRank
o={}
for t=1,ModulesInit.GuildMgr.GuildMaxRankCount do
if e.guilds[t]~=nil then
table.insert(o,e.guilds[t])
else
table.insert(o,{rankNo=t,type="empty"})
end
end
Refresh()
end
function OnGuildLeave()
GameTools.CloseUIForm(UIFormId.UI_GuildRankView)
end
function OnEventNetReconnectSuccess()
ModulesInit.GuildMgr:ReqGuildRankList()
end
function OnRespGuildApply(t)
for e=1,#o do
local e=o[e]
if t.guildId==e.guildId then
e.applyState=t.state
break
end
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

