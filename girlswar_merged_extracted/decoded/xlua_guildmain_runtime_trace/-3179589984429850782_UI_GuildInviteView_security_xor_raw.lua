local e=nil
local t=nil
local a=false
function OnInit(i,o)
t=o
Image.onClick:AddListener(function()
a=true
GameTools.CloseUIForm(UIFormId.UI_GuildInviteView)
end)
btn_quxiao.onClick:AddListener(function()
local e={
guildId=e.guildId,
serverId=UserAccountInfo.serverId
}
NetManager.Send(ProtoId.PRT_GUILD_SNAPSHOT_REQ,e)
end)
btn_queren.onClick:AddListener(function()
local e=e
local t,a=ModulesInit.GuildMgr:checkApplyGuild(e)
if t==false then
ModulesInit.GuildMgr:ShowGuildNameErrorTip(a)
return
end
local t={
guildId=e.guildId
}
ModulesInit.GuildMgr:ReqGuildApply(t,e.joinNeedApprove)
end)
end
function OnOpen(o)
t=o
EventSystem.AddListener(CommonEventId.GuildCloseEntrance,onEventGuildCloseEntrance)
EventSystem.AddListener(CommonEventId.OnGuildRespInvite,OnGuildRespInvite)
EventSystem.AddListener(CommonEventId.OnRespGuildApply,OnRespGuildApply)
e=o.proto.guild
a=false
Refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.GuildCloseEntrance,onEventGuildCloseEntrance)
EventSystem.RemoveListener(CommonEventId.OnGuildRespInvite,OnGuildRespInvite)
EventSystem.RemoveListener(CommonEventId.OnRespGuildApply,OnRespGuildApply)
if t then
if t.callback then
t.callback(t.sender,a)
end
end
end
function OnBeforeDestroy()
end
function Refresh()
UIUtil.SetPlayerIconFrame(head_yuan150,
{
head=e.leaderHead,
headFrame=e.leaderHeadFrame,
playerId=e.leaderId,
})
GameTools:SetImageSprite(bg_huizhang,ModulesInit.GuildMgr:getGuildIconBg(e.bg),false)
GameTools:SetImageSprite(im_huizhang,ModulesInit.GuildMgr:getGuildFg(e.fg),false)
LuaUtils.SetLabelText(text_name,e.name)
local e=GameTools.GetLocalize("UI.guild.Join.34",LanguageCategory.LangCommon)
if math.random()<0.5 then
e=GameTools.GetLocalize("UI.guild.Join.35",LanguageCategory.LangCommon)
end
LuaUtils.SetLabelText(text_message,e)
end
function OnGuildRespInvite(t)
e=t.proto.guild
Refresh()
end
function OnRespGuildApply(t)
local a=t.guildId
if a~=e.guildId then
return
end
if t.state==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_WAIT_APPROVE then
e.applyState=t.state
Refresh()
elseif t.state==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_AGREE then
EventSystem.SendEvent(CommonEventId.GuildCloseEntrance)
JumpMgr.OnGameJumpUIGuild()
end
end
function onEventGuildCloseEntrance()
GameTools.CloseUIForm(UIFormId.UI_GuildInviteView)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

