local l=require('DataNode/DataTable/Create/player/DTPushSetDBModel')
local d={
NORMAL=1,
PUSH=2
}
local e={
PERSON_CHAT=1,
GUILD_MAIL=2,
COST_GEM=3,
COLSE_SHOW_NAME=4,
}
local r={
[e.PERSON_CHAT]={im_person_chat_on,im_person_chat_off,btn_person_chat},
[e.GUILD_MAIL]={im_guild_mail_on,im_guild_mail_off,btn_guild_mail},
[e.COST_GEM]={im_cost_gem_on,im_cost_gem_off,btn_cost_gem},
[e.COLSE_SHOW_NAME]={im_clos_show_name_on,im_clos_show_name_off,btn_closShowName}
}
local n=1
local t
local o
local a
local i
local s
local h={}
function OnInit(e,e)
Image.onClick:AddListener(closeUI)
btn_fanhui.onClick:AddListener(closeUI)
btn_baocun.onClick:AddListener(btnSave)
for e=d.NORMAL,d.PUSH do
selfEnv["toggle"..e].onValueChanged:AddListener(handler(e,changeTab))
end
llv_pushList:InitListView(0,OnGetItemByIndex)
for t,e in ipairs(r)do
e[3].onClick:AddListener(handler(t,changeValue))
end
end
function OnOpen(e)
n=1
o=PlayerMgr:GetPlayerSetValue(PROTO_ENUM.ENUM_SETTING_ID.SID_PUSH_CHAT)
a=PlayerMgr:GetPlayerSetValue(PROTO_ENUM.ENUM_SETTING_ID.SID_PUSH_GUILD_MAIL)
i=PlayerMgr:GetPlayerSetValue(PROTO_ENUM.ENUM_SETTING_ID.SID_COST_HC_TIPS)
s=PlayerMgr:GetPlayerSetValue(PROTO_ENUM.ENUM_SETTING_ID.SID_CLOSE_GUILD_GIFT_SHOW_NAME)
LuaUtils.SetToggleValue(selfEnv["toggle"..n],true)
refreshView()
end
function OnClose()
LuaUtils.SetToggleValue(selfEnv["toggle1"],true)
t=nil
end
function OnBeforeDestroy()
end
function refreshView()
LuaUtils.SetActive(p_nolRoot.transform,n==1)
LuaUtils.SetActive(p_pushRoot.transform,n==2)
if n==1 then
refreshNorView()
else
refreshPushView()
end
end
function refreshNorView()
setToggle(e.PERSON_CHAT,o)
setToggle(e.GUILD_MAIL,a)
setToggle(e.COST_GEM,i)
setToggle(e.COLSE_SHOW_NAME,s)
end
function refreshPushView()
if t==nil then
t=l.GetList()
for t,e in ipairs(t or{})do
local t=PlayerMgr:GetPlayerSetValue(e.id)
h[e.id]=t
end
end
llv_pushList:SetListItemCount(#t)
llv_pushList:RefreshAllShownItem()
end
function setToggle(e,t)
local e=r[e]
LuaUtils.SetActive(e[1].transform,t)
LuaUtils.SetActive(e[2].transform,not t)
end
function changeTab(t,e)
if e then
n=t
refreshView()
end
end
function OnGetItemByIndex(e,a)
a=a+1
local e=e:NewListViewItem("set1")
if e.IsInitHandlerCalled==false then
local a=LuaUtils.GetLuaComBinder(e.transform)
local a=a:GetComponents()
e.BiComs=a
e.BiComs["btnSet"].onClick:AddListener(handler(e,function(e)
local e=e.UserObjectData
local t=t[e]
h[t.id]=not h[t.id]
llv_pushList:RefreshItemByItemIndex(e-1)
end))
e.IsInitHandlerCalled=true
end
local t=t[a]
LuaUtils.SetLabelText(e.BiComs["text_name"],GameTools.GetLocalize(t.pushName,LanguageCategory.LangCommon))
local o=getTimeStr(t.pushTime[1][1])..":"..getTimeStr(t.pushTime[1][2])
if#t.pushTime>1 then
for e=2,#t.pushTime do
o=o..","..getTimeStr(t.pushTime[e][1])..":"..getTimeStr(t.pushTime[e][2])
end
end
LuaUtils.SetLabelText(e.BiComs["text_time"],o)
local t=h[t.id]
LuaUtils.SetActive(e.BiComs["im_kai"].transform,t)
LuaUtils.SetActive(e.BiComs["im_guan"].transform,not t)
e.UserObjectData=a
return e
end
function getTimeStr(e)
if e<10 then
return"0"..e
end
return""..e
end
function changeValue(t)
if t==e.PERSON_CHAT then
o=not o
elseif t==e.GUILD_MAIL then
a=not a
elseif t==e.COST_GEM then
i=not i
elseif t==e.COLSE_SHOW_NAME then
s=not s
end
refreshNorView()
end
function btnSave()
local e={}
if o~=PlayerMgr:GetPlayerSetValue(PROTO_ENUM.ENUM_SETTING_ID.SID_PUSH_CHAT)then
local t=o and 1 or 0
table.insert(e,{id=PROTO_ENUM.ENUM_SETTING_ID.SID_PUSH_CHAT,value=t})
end
if a~=PlayerMgr:GetPlayerSetValue(PROTO_ENUM.ENUM_SETTING_ID.SID_PUSH_GUILD_MAIL)then
local t=a and 1 or 0
table.insert(e,{id=PROTO_ENUM.ENUM_SETTING_ID.SID_PUSH_GUILD_MAIL,value=t})
end
if i~=PlayerMgr:GetPlayerSetValue(PROTO_ENUM.ENUM_SETTING_ID.SID_COST_HC_TIPS)then
local t=i and 1 or 0
table.insert(e,{id=PROTO_ENUM.ENUM_SETTING_ID.SID_COST_HC_TIPS,value=t})
end
if s~=PlayerMgr:GetPlayerSetValue(PROTO_ENUM.ENUM_SETTING_ID.SID_CLOSE_GUILD_GIFT_SHOW_NAME)then
local t=s and 1 or 0
table.insert(e,{id=PROTO_ENUM.ENUM_SETTING_ID.SID_CLOSE_GUILD_GIFT_SHOW_NAME,value=t})
end
for a,t in pairs(h or{})do
local o=PlayerMgr:GetPlayerSetValue(a)
if t~=o then
local t=t and 1 or 0
table.insert(e,{id=a,value=t})
end
end
if#e>0 then
local e=PlayerMgr:sendSetting(e)
e.onCompleted=function()
closeUI()
end
else
closeUI()
end
end
function closeUI()
GameTools.CloseUIForm(UIFormId.UI_NormalSet)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

