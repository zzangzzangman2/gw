local n=true
local i=1
local a=1
local s=nil
local t={}
local e={}
function OnInit(e,e)
Image.onClick:AddListener(function()
CloseSelfUI()
end)
btn_queding.onClick:AddListener(function()
if n then
OnBtnChangeIcon()
else
CloseSelfUI()
HandleConfirmSuccessCallback()
end
end)
local e={}
e.mPadding1=0
e.mPadding2=0
e.mColumnOrRowCount=1
e.mItemWidthOrHeight=135
ScrollViewIcon:InitListView(0,e,OnGetIconByIndex)
local e={}
e.mPadding1=0
e.mPadding2=0
e.mColumnOrRowCount=1
e.mItemWidthOrHeight=135
ScrollViewIconBg:InitListView(0,e,OnGetIconBgByIndex)
end
function OnOpen(o)
EventSystem.AddListener(CommonEventId.GuildRespChangeIcon,OnEventGuildRespChangeIcon)
EventSystem.AddListener(CommonEventId.OnGuildLeave,OnGuildLeave)
o=o or{}
s=o.completeCallback
local s=o.iconId or 1
local h=o.iconBgId or 1
if type(o.isRealSetMode)=="boolean"then
n=o.isRealSetMode
else
n=true
end
if n==true then
if ModulesInit.GuildMgr.guildInfo then
s=ModulesInit.GuildMgr.guildInfo.fg
h=ModulesInit.GuildMgr.guildInfo.bg
end
end
t=ModulesInit.GuildMgr:getAllGuildIcon()
e=ModulesInit.GuildMgr:getAllGuildIconBg()
i=1
a=1
for e=1,#t do
if t[e].id==s then
i=e
break
end
end
for t=1,#e do
if e[t].id==h then
a=t
break
end
end
ScrollViewIcon:SetListItemCount(#t)
ScrollViewIconBg:SetListItemCount(#e)
Refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.GuildRespChangeIcon,OnEventGuildRespChangeIcon)
EventSystem.RemoveListener(CommonEventId.OnGuildLeave,OnGuildLeave)
end
function OnBeforeDestroy()
end
function Refresh()
ScrollViewIconBg:RefreshAllShownItem()
ScrollViewIcon:RefreshAllShownItem()
local t=t[i]
GameTools:SetImageSprite(im_huizhang_show,ModulesInit.GuildMgr:getGuildFg(t.id),false)
local e=e[a]
GameTools:SetImageSprite(bg_huizhang_show,ModulesInit.GuildMgr:getGuildIconBg(e.id),false)
end
function OnGetIconByIndex(e,a)
a=a+1

local e=e:NewListViewItem("node_item_icon")
local o=LuaUtils.GetLuaComBinder(e.transform)
local o=o:GetComponents()
local n=t[a]
GameTools:SetImageSprite(o["im_huizhang"],ModulesInit.GuildMgr:getGuildFg(n.id),false)
LuaUtils.SetActive(o["im_xuanzhong"].transform,i==a)
if e.IsInitHandlerCalled==false then
o["btn_wenzhang_icon"].onClick:AddListener(handler(e,function(e)
local e=e.UserObjectData
local t=t[e]
local a=1
if ModulesInit.GuildMgr.guildInfo then
a=ModulesInit.GuildMgr.guildInfo.level
end
if a>=t.needLv then
i=e
Refresh()
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Join.25",LanguageCategory.LangCommon,t.needLv))
end
end))
e.IsInitHandlerCalled=true
end
e.UserObjectData=a
return e
end
function OnGetIconBgByIndex(o,t)
t=t+1

local o=o:NewListViewItem("node_item_bg")
local i=LuaUtils.GetLuaComBinder(o.transform)
local i=i:GetComponents()
local n=e[t]
GameTools:SetImageSprite(i["bg_huizhang"],ModulesInit.GuildMgr:getGuildIconBg(n.id),false)
LuaUtils.SetActive(i["im_xuanzhong"].transform,a==t)
if o.IsInitHandlerCalled==false then
i["btn_wenzhang_bg"].onClick:AddListener(handler(o,function(t)
local t=t.UserObjectData
local o=e[t]
local e=1
if ModulesInit.GuildMgr.guildInfo then
e=ModulesInit.GuildMgr.guildInfo.level
end
if e>=o.needLv then
a=t
Refresh()
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Join.25",LanguageCategory.LangCommon,o.needLv))
end
end))
o.IsInitHandlerCalled=true
end
o.UserObjectData=t
return o
end
function OnBtnChangeIcon()

local t=t[i]
local e=e[a]
if ModulesInit.GuildMgr.guildInfo then
if t.id==ModulesInit.GuildMgr.guildInfo.fg and e.id==ModulesInit.GuildMgr.guildInfo.bg then
CloseSelfUI()
return
end
end
local e={
fg=t.id,
bg=e.id
}
ModulesInit.GuildMgr:ReqGuildChangeIcon(e)
end
function OnEventGuildRespChangeIcon()
CloseSelfUI()
HandleConfirmSuccessCallback()
end
function HandleConfirmSuccessCallback()
if s then
local t=t[i]
local e=e[a]
local a=t and t.id or 1
local e=t and e.id or 1
s({iconId=a,iconBgId=e})
end
end
function CloseSelfUI()
GameTools.CloseUIForm(UIFormId.UI_GuildIconSetView)
end
function OnGuildLeave()
CloseSelfUI()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

