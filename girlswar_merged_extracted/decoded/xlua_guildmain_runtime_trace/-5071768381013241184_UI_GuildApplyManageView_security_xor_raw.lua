local e={}
function OnInit(e,e)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildApplyManageView)
end)
local e={}
e.mPadding1=0
e.mPadding2=0
e.mColumnOrRowCount=1
e.mItemWidthOrHeight=1090
ScrollView:InitListView(0,e,OnGetItemByIndex)
end
function OnOpen(t)
EventSystem.AddListener(CommonEventId.OnRespGuildApplyList,OnRespGuildApplyList)
EventSystem.AddListener(CommonEventId.OnRespGuildApplyApprove,OnRespGuildApplyApprove)
EventSystem.AddListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
e={}
Refresh()
ModulesInit.GuildMgr:ReqGuildApplyList()
end
function OnFormBack()
ModulesInit.GuildMgr:ReqGuildApplyList()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnRespGuildApplyList,OnRespGuildApplyList)
EventSystem.RemoveListener(CommonEventId.OnRespGuildApplyApprove,OnRespGuildApplyApprove)
EventSystem.RemoveListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
end
function OnBeforeDestroy()
end
function Refresh()
ScrollView:SetListItemCount(#e)
ScrollView:RefreshAllShownItem()
LuaUtils.SetActive(text_empty.transform,#e<=0)
end
function OnGetItemByIndex(t,i)
i=i+1

local a=t:NewListViewItem("gonghui1")
local t=LuaUtils.GetLuaComBinder(a.transform)
local t=t:GetComponents()
local o=e[i]
UIUtil.SetPlayerIconFrame(t["head_yuan150"],
{head=o.head,
headFrame=o.headFrame,
playerId=o.playerId,
})
LuaUtils.SetTextMeshText(t["text_lv"],GameTools.GetLocalize("UI.guild.Main.03",LanguageCategory.LangCommon,o.level))
LuaUtils.SetLabelText(t["text_name"],o.name)
LuaUtils.SetTextMeshText(t["text_fight"],UIUtil.NumTrim(o.fightValue))
UIUtil.SetMarqueeWithOption(t["mask_marquee"].transform,t["text_desc"],PlayerMgr:getPlayerSign(o.sign))
if a.IsInitHandlerCalled==false then
t["btn_jujue"].onClick:AddListener(handler(a,function(t)
local t=t.UserObjectData
local e=e[t]
local e={
targetId=e.playerId,
state=PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_DISAGREE
}
ModulesInit.GuildMgr:ReqGuildApplyApprove(e)
end))
t["btn_jieshou"].onClick:AddListener(handler(a,function(t)
local t=t.UserObjectData
local e=e[t]
local e={
targetId=e.playerId,
state=PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_AGREE
}
ModulesInit.GuildMgr:ReqGuildApplyApprove(e)
end))
local t=LuaUtils.GetLuaComBinder(t["head_yuan150"].transform)
local t=t:GetComponents()
t["btn_head"].onClick:AddListener(handler(a,function(t)
local t=t.UserObjectData
local e=e[t]
if e then
UIUtil.showPlayerInfo(e.playerId,UserAccountInfo.serverId)
end
end))
a.IsInitHandlerCalled=true
end
a.UserObjectData=i
return a
end
function OnRespGuildApplyList(t)
e=t.applys
Refresh()
end
function OnRespGuildApplyApprove(a)
for t=1,#e do
if e[t].playerId==a.targetId then
if a.state==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_AGREE then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.16",LanguageCategory.LangCommon,e[t].name))
table.remove(e,t)
elseif a.state==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_DISAGREE then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.62",LanguageCategory.LangCommon,e[t].name))
table.remove(e,t)
end
break
end
end
Refresh()
end
function OnGuildLeave()
GameTools.CloseUIForm(UIFormId.UI_GuildApplyManageView)
end
function OnEventNetReconnectSuccess()
ModulesInit.GuildMgr:ReqGuildApplyList()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

