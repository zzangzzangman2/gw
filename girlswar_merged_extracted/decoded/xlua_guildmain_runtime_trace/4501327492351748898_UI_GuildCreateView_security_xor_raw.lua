local e=1
local t=1
local a=0
function OnInit(a,a)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildCreateView)
end)
inputAcc.onValueChanged:AddListener(function(e)
if e then

local t,e=string.truncateChar(e,ModulesInit.GuildMgr.GuildNameMaxLength)
if e>ModulesInit.GuildMgr.GuildNameMaxLength then
inputAcc.text=t
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Main.26",LanguageCategory.LangCommon))
end
end
end)
inputAcc.onEndEdit:AddListener(function(e)
if e then

end
end)
btn_chuangjian.onClick:AddListener(function()
onBtnCreateGuild()
end)
btn_shezhi.onClick:AddListener(function()
local e={
isRealSetMode=false,
iconId=t,
iconBgId=e,
completeCallback=function(a)
t=a.iconId or t
e=a.iconBgId or e
refresh()
end
}
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildIconSetView,e)
end)
end
function OnOpen(o)
EventSystem.AddListener(CommonEventId.GuildCloseEntrance,onEventGuildCloseEntrance)
EventSystem.AddListener(CommonEventId.OnPlayCurrencyRefresh,refresh)
a=o.consumeCount or Constant.guild_create_diamond_expensive[2]
e=1
t=1
inputAcc.text=""
inputAcc.placeholder.text=GameTools.GetLocalize("UI.guild.Main.20",LanguageCategory.LangCommon)
LuaUtils.SetTextMeshText(text_num,a)
refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.GuildCloseEntrance,onEventGuildCloseEntrance)
EventSystem.RemoveListener(CommonEventId.OnPlayCurrencyRefresh,refresh)
end
function OnBeforeDestroy()
end
function refresh()
GameTools:SetImageSprite(bg_huizhang,ModulesInit.GuildMgr:getGuildIconBg(e),false)
GameTools:SetImageSprite(im_huizhang,ModulesInit.GuildMgr:getGuildFg(t),false)
local e=Color.white
if PlayerMgr:getCurrencyCount(Constant.guild_create_diamond_expensive[1])<a then
e=Color.red
end
text_num.color=e
end
function onBtnCreateGuild()

local o=inputAcc.text or""
local i,n=ModulesInit.GuildMgr:checkCreateGuild(o,a)
if i==false then
ModulesInit.GuildMgr:ShowGuildNameErrorTip(n)
return
end
PlayerMgr.CheckCostHCTips(a,function()
local e={
name=o,
bg=e,
fg=t,
consumeCount=a
}
local e=ModulesInit.GuildMgr:ReqCreateGuild(e)
e.onCompleted=function()
EventSystem.SendEvent(CommonEventId.GuildCloseEntrance)
JumpMgr.OnGameJumpUIGuild()
end
end)
end
function onEventGuildCloseEntrance()
GameTools.CloseUIForm(UIFormId.UI_GuildCreateView)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

