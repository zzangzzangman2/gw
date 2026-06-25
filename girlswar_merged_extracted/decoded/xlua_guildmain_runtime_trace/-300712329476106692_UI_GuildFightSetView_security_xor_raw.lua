local e=true
function OnInit(t,t)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildFightSetView)
end)
inputAcc.onValueChanged:AddListener(function(e)
if e then

if e==""then
return
end
local t=tonumber(e)
if type(t)~="number"then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.49",LanguageCategory.LangCommon))
local e=string.convertToNumStr(e)
inputAcc.text=e
else
local t,e=string.truncateChar(e,ModulesInit.GuildMgr.GuildFightCondMaxLength)
if e>ModulesInit.GuildMgr.GuildFightCondMaxLength then
inputAcc.text=t
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.53",LanguageCategory.LangCommon))
end
end
end
end)
toggle.onValueChanged:AddListener(
function(t)
e=t

end
)
btn_queren.onClick:AddListener(function()
onBtnChangeFight()
end)
btn_quxiao.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildFightSetView)
end)
end
function OnOpen(t)
EventSystem.AddListener(CommonEventId.OnEventGuildRespLimit,OnEventGuildRespLimit)
EventSystem.AddListener(CommonEventId.OnGuildLeave,OnGuildLeave)
inputAcc.placeholder.text=GameTools.GetLocalize("UI.guild.Manage.51",LanguageCategory.LangCommon)
if ModulesInit.GuildMgr.guildInfo then
if ModulesInit.GuildMgr.guildInfo.joinFightLimit>0 then
inputAcc.text=tostring(ModulesInit.GuildMgr.guildInfo.joinFightLimit)
else
inputAcc.text=""
end
e=ModulesInit.GuildMgr.guildInfo.joinNeedApprove
else
inputAcc.text=""
e=true
end
LuaUtils.SetToggleValue(toggle,e)
Refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnEventGuildRespLimit,OnEventGuildRespLimit)
EventSystem.RemoveListener(CommonEventId.OnGuildLeave,OnGuildLeave)
end
function OnBeforeDestroy()
end
function Refresh()
end
function onBtnChangeFight()
local t=inputAcc.text or""
if ModulesInit.GuildMgr.guildInfo then
if ModulesInit.GuildMgr.guildInfo.joinFightLimit==tonumber(t)
and ModulesInit.GuildMgr.guildInfo.joinNeedApprove==e then
GameTools.CloseUIForm(UIFormId.UI_GuildFightSetView)
return
end
end
if t==""then
t="0"
end
local t=tonumber(t)
if type(t)~="number"then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.49",LanguageCategory.LangCommon))
inputAcc.text=""
return
end
local o,a=string.str2List(tostring(t))
if a>ModulesInit.GuildMgr.GuildFightCondMaxLength then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.53",LanguageCategory.LangCommon))
return
end
local e={
fight=t,
needApprove=e
}
ModulesInit.GuildMgr:ReqGuildJoinCond(e)
end
function OnEventGuildRespLimit(e)
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.52",LanguageCategory.LangCommon))
GameTools.CloseUIForm(UIFormId.UI_GuildFightSetView)
end
function OnGuildLeave()
GameTools.CloseUIForm(UIFormId.UI_GuildFightSetView)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

