function OnInit(e,e)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildChangeNameView)
end)
inputAcc.onValueChanged:AddListener(function(e)
if e then

end
end)
inputAcc.onEndEdit:AddListener(function(e)
if e then

local t,e=string.truncateChar(e,ModulesInit.GuildMgr.GuildNameMaxLength)
if e>ModulesInit.GuildMgr.GuildNameMaxLength then
inputAcc.text=t
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Main.26",LanguageCategory.LangCommon))
end
end
end)
btn_queren.onClick:AddListener(function()
OnBtnChangeName()
end)
btn_quxiao.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildChangeNameView)
end)
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.GuildNameChange,OnEventGuildNameChange)
EventSystem.AddListener(CommonEventId.OnGuildLeave,OnGuildLeave)
inputAcc.text=""
inputAcc.placeholder.text=GameTools.GetLocalize("UI.guild.Main.20",LanguageCategory.LangCommon)
LuaUtils.SetTextMeshText(text_num,Constant.guild_rename_diamond[2])
Refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.GuildNameChange,OnEventGuildNameChange)
EventSystem.RemoveListener(CommonEventId.OnGuildLeave,OnGuildLeave)
end
function OnBeforeDestroy()
end
function Refresh()
local e=Color.white
if PlayerMgr:getCurrencyCount(Constant.guild_rename_diamond[1])<Constant.guild_rename_diamond[2]then
e=DefaultColor.red
end
text_num.color=e
end
function OnBtnChangeName()

local e=inputAcc.text or""
local t,a=ModulesInit.GuildMgr:checkChangeName(e)
if t==false then
ModulesInit.GuildMgr:ShowGuildNameErrorTip(a)
return
end
local e={
name=e,
}
ModulesInit.GuildMgr:ReqGuildChangeName(e)
end
function OnEventGuildNameChange()
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Main.23",LanguageCategory.LangCommon))
GameTools.CloseUIForm(UIFormId.UI_GuildChangeNameView)
end
function OnGuildLeave()
GameTools.CloseUIForm(UIFormId.UI_GuildChangeNameView)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

