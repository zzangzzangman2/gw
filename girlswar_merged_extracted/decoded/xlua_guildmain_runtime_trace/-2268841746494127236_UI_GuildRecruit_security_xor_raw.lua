function OnInit(e,e)
Image.onClick:AddListener(
function()
GameTools.CloseUIForm(UIFormId.UI_GuildRecruit)
end
)
inputAcc.onValueChanged:AddListener(
function(e)
if e then

if e==""then
RefreshInput(false,true)
end
local e,t=string.truncateChar(e,ModulesInit.GuildMgr.GuildRecruitNoticeMaxLength)
if t>ModulesInit.GuildMgr.GuildRecruitNoticeMaxLength then
inputAcc.text=e
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.30",LanguageCategory.LangCommon,ModulesInit.GuildMgr.GuildRecruitNoticeMaxLength))
end
Refresh()
end
end
)
inputAcc.onEndEdit:AddListener(
function(e)
if e then

RefreshInput(false)
Refresh()
end
end
)
local t=inputAcc:GetComponent(typeof(CS.UnityEngine.EventSystems.EventTrigger))
local e=CS.UnityEngine.EventSystems.EventTrigger.Entry()
e.eventID=CS.UnityEngine.EventSystems.EventTriggerType.Select
e.callback:AddListener(
function()
RefreshInput(false,true)
Refresh()
end
)
t.triggers:Add(e)
btn_queren.onClick:AddListener(
function()
onBtnChangeNotice()
end
)
btn_quxiao.onClick:AddListener(
function()
GameTools.CloseUIForm(UIFormId.UI_GuildRecruit)
end
)
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.OnGuildLeave,OnGuildLeave)
RefreshInput(true)
Refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnGuildLeave,OnGuildLeave)
end
function OnBeforeDestroy()
end
function Refresh()
local e=0
if inputAcc.text~=""then
local a,t=string.str2List(inputAcc.text)
e=t
else
local a,t=string.str2List(inputAcc.placeholder.text)
e=t
end
LuaUtils.SetLabelText(text_zishu,GameTools.GetLocalize("UI.guild.Manage.25",LanguageCategory.LangCommon,e,ModulesInit.GuildMgr.GuildRecruitNoticeMaxLength))
end
function RefreshInput(a,e)
if e==nil then
e=false
end
local t=""
if ModulesInit.GuildMgr.guildInfo then
t=ModulesInit.GuildMgr.guildInfo.recruitChat
end
if a then
inputAcc.text=t
end
if inputAcc.text==""and e==false then
local e=ModulesInit.GuildMgr:getGuildRecruitNotice(t)
if inputAcc.placeholder.text~=e then
inputAcc.placeholder.text=e
end
else
if inputAcc.placeholder.text~=""then
inputAcc.placeholder.text=""
end
end
end
function onBtnChangeNotice()
local e=inputAcc.text or""
local t=e:match("^[%s]*(.-)[%s]*$")
if e==""or#t==0 then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.27",LanguageCategory.LangCommon))
return
end
local a,t=string.str2List(e)
if t>ModulesInit.GuildMgr.GuildRecruitNoticeMaxLength then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Manage.30",LanguageCategory.LangCommon,ModulesInit.GuildMgr.GuildRecruitNoticeMaxLength))
local t,a=string.truncateChar(e,ModulesInit.GuildMgr.GuildRecruitNoticeMaxLength)
e=t
end
local e={
recruitMsg=e
}
local e=ModulesInit.GuildMgr:ReqGuildSetRecruitChatNotice(e)
e.onCompleted=function()
UIUtil.ShowCommonTips(GameTools.GetLocalize("tips.common_257"))
GameTools.CloseUIForm(UIFormId.UI_GuildRecruit)
end
end
function OnGuildLeave()
GameTools.CloseUIForm(UIFormId.UI_GuildRecruit)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

