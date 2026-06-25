function OnInit(e,e)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildSearchView)
end)
inputAcc.onValueChanged:AddListener(function(e)
if e then

if e==""then
return
end
local t=tonumber(e)
if type(t)~="number"then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Join.21",LanguageCategory.LangCommon))
local e=string.convertToNumStr(e)
inputAcc.text=e
else
local t,e=string.truncateChar(e,ModulesInit.GuildMgr.GuildIdMaxLength)
if e>ModulesInit.GuildMgr.GuildIdMaxLength then
inputAcc.text=t
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.60",LanguageCategory.LangCommon,ModulesInit.GuildMgr.GuildIdMaxLength))
end
end
end
end)
btn_sousuo.onClick:AddListener(function()
onBtnSearchGuild()
end)
btn_quxiao.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildSearchView)
end)
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.OnRespGuildSearch,OnRespGuildSearch)
inputAcc.text=""
inputAcc.placeholder.text=GameTools.GetLocalize("UI.guild.Join.23",LanguageCategory.LangCommon)
refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnRespGuildSearch,OnRespGuildSearch)
end
function OnBeforeDestroy()
end
function refresh()
end
function onBtnSearchGuild()
local e=inputAcc.text or""
if e==""then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Join.20",LanguageCategory.LangCommon))
return
end
local e=tonumber(e)
if type(e)~="number"then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Join.21",LanguageCategory.LangCommon))
inputAcc.text=""
return
end
local a,t=string.str2List(tostring(e))
if t>ModulesInit.GuildMgr.GuildIdMaxLength then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.60",LanguageCategory.LangCommon,ModulesInit.GuildMgr.GuildIdMaxLength))
return
end
local e={
guildId=e
}
ModulesInit.GuildMgr:ReqSearchGuild(e)
end
function OnRespGuildSearch(e)
if e.guildInfo~=nil then
GameTools.CloseUIForm(UIFormId.UI_GuildSearchView)
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Join.22",LanguageCategory.LangCommon))
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

