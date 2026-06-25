function OnInit(e,e)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildMailView)
end)
inputAcc.onValueChanged:AddListener(function(e)
if e then

local t,e=string.truncateChar(e,ModulesInit.GuildMgr.GuildMailMaxLength)
if e>ModulesInit.GuildMgr.GuildMailMaxLength then
inputAcc.text=t
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.37",LanguageCategory.LangCommon,ModulesInit.GuildMgr.GuildMailMaxLength))
end
Refresh()
end
end)
inputAcc.onEndEdit:AddListener(function(e)
if e then

Refresh()
end
end)
btn_songxin.onClick:AddListener(function()
onBtnSendMail()
end)
btn_quxiao.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildMailView)
end)
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.OnGuildRespMail,OnEventGuildRespMail)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.AddListener(CommonEventId.OnGuildLeave,OnGuildLeave)
inputAcc.text=""
inputAcc.placeholder.text=GameTools.GetLocalize("UI.guild.Manage.32",LanguageCategory.LangCommon,ModulesInit.GuildMgr.GuildMailMaxLength)
Refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnGuildRespMail,OnEventGuildRespMail)
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.RemoveListener(CommonEventId.OnGuildLeave,OnGuildLeave)
end
function OnBeforeDestroy()
end
function Refresh()
end
function OnUpdate()
local e=ModulesInit.GuildMgr.availableSendMailTimestamp/1000-TimeUtil.GetServerTimeStamp()
if e<0 then
LuaUtils.SetActive(btn_songxin.transform,true)
LuaUtils.SetActive(grey_time.transform,false)
else
LuaUtils.SetActive(btn_songxin.transform,false)
LuaUtils.SetActive(grey_time.transform,true)
LuaUtils.SetTextMeshText(text_left_time,TimeUtil.toDHMSStr2(e))
end
end
function onBtnSendMail()
local e=inputAcc.text or""
if string.trim(inputAcc.text)==""then
e=""
end
if e==""then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.34",LanguageCategory.LangCommon))
return
end
local a,t=string.str2List(e)
if t>ModulesInit.GuildMgr.GuildMailMaxLength then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.37",LanguageCategory.LangCommon,ModulesInit.GuildMgr.GuildMailMaxLength))
local t,a=string.truncateChar(e,ModulesInit.GuildMgr.GuildMailMaxLength)
e=t
end
local e={
content=e,
}
ModulesInit.GuildMgr:ReqGuildSetMail(e)
end
function OnEventGuildRespMail(e)
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.33",LanguageCategory.LangCommon))
GameTools.CloseUIForm(UIFormId.UI_GuildMailView)
Refresh()
end
function OnGuildLeave()
GameTools.CloseUIForm(UIFormId.UI_GuildMailView)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

