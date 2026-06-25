local e=nil
function OnInit(t,t)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildInfoView)
end)
btn_siliao.onClick:AddListener(function()
if e and e.leaderId==PlayerMgr.PlayerInfo.uid then
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
end)
btn_queren.onClick:AddListener(function()
local e=e
local a,t=ModulesInit.GuildMgr:checkApplyGuild(e)
if a==false then
ModulesInit.GuildMgr:ShowGuildNameErrorTip(t)
return
end
local t={
guildId=e.guildId
}
ModulesInit.GuildMgr:ReqGuildApply(t,e.joinNeedApprove)
end)
end
function OnOpen(t)
e=t.guildInfo
EventSystem.AddListener(CommonEventId.OnRespGuildApply,OnRespGuildApply)
EventSystem.AddListener(CommonEventId.GuildCloseEntrance,onEventGuildCloseEntrance)
Refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnRespGuildApply,OnRespGuildApply)
EventSystem.RemoveListener(CommonEventId.GuildCloseEntrance,onEventGuildCloseEntrance)
end
function OnBeforeDestroy()
end
function Refresh()
if e==nil then
return
end
local e=e
GameTools:SetImageSprite(bg_huizhang,ModulesInit.GuildMgr:getGuildIconBg(e.bg),false)
GameTools:SetImageSprite(im_huizhang,ModulesInit.GuildMgr:getGuildFg(e.fg),false)
LuaUtils.SetLabelText(text_juntuanname,e.name)
LuaUtils.SetLabelText(text_juntuanlv,GameTools.GetLocalize("UI.guild.Main.03",LanguageCategory.LangCommon,e.level))
LuaUtils.SetLabelText(text_juntuanrenshu,GameTools.GetLocalize("UI.guild.Main.02",LanguageCategory.LangCommon,e.curMemCount,e.maxMemCount))
LuaUtils.SetLabelText(text_leader_name,GameTools.GetLocalize("UI.guild.Join.29",LanguageCategory.LangCommon,e.leaderName))
LuaUtils.SetLabelText(text_zhanli,GameTools.GetLocalize("UI.guild.Join.30",LanguageCategory.LangCommon,UIUtil.NumTrim(e.fight)))
LuaUtils.SetLabelText(text_message,ModulesInit.GuildMgr:getGuildNotice(e.notice))
local t=""
if e.joinFightLimit>0 then
t=UIUtil.NumTrim(e.joinFightLimit)
else
t=GameTools.GetLocalize("UI.guild.Join.09",LanguageCategory.LangCommon)
end
LuaUtils.SetLabelText(text_tiaojian,GameTools.GetLocalize("UI.guild.Join.31",LanguageCategory.LangCommon,t))
if e.applyState==PROTO_ENUM.ENUM_APPLY_STATE.GUILD_APPLY_WAIT_APPROVE then
UIUtil.SetGray(btn_queren.transform,true)
LuaUtils.SetTextMeshText(text_queren,GameTools.GetLocalize("UI.guild.Join.28",LanguageCategory.LangCommon))
else
UIUtil.SetGray(btn_queren.transform,false)
LuaUtils.SetTextMeshText(text_queren,GameTools.GetLocalize("UI.guild.Join.32",LanguageCategory.LangCommon))
end
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
GameTools.CloseUIForm(UIFormId.UI_GuildInfoView)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

