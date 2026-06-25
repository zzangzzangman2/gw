local s=require('DataNode/DataTable/Create/guildBattle/DTGuildBattleTaskDBModel')
local e=require('Common/cs_coroutine')
local t={
QUEST_NOT_ACTIVE=0,
QUEST_ACTIVE=1,
QUEST_AWARDED=2
}
local d={
AttrTime=1,
Score=2,
winCount=3
}
local e={
TYPE1=1,
TYPE2=2
}
local c={
'UI.guildBattle.award.11',
'UI.guildBattle.award.12',
'UI.guildBattle.award.13'
}
local u=nil
local n={}
local i={}
local h=e.TYPE1
local a,r=nil,nil
local o=ModulesInit.CSGuildWarManager
local l=o:GetGuildWarDBCfg()
function OnInit(t,t)
u={
[e.TYPE1]=SetTap1,
[e.TYPE2]=SetTap2
}
a=p_zhouhuoyue1:GetComponents()
r=p_zhouhuoyue2:GetComponents()
bg.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarAwards)
end)
toggle1.onValueChanged:AddListener(function(t)
if t then
h=e.TYPE1
UpdateContent()
end
end)
toggle2.onValueChanged:AddListener(function(t)
if t then
h=e.TYPE2
UpdateContent()
end
end)
a['btn_yijian'].onClick:AddListener(function()
OneKey()
end)
a['uiScroll']:InitListView(-1,GetItemByIndex1)
r['uiScroll']:InitListView(-1,GetItemByIndex2)
local e=GameTools.GetLocalize("UI_guildwar_awards_1",LanguageCategory.LangCommon)
e=TimeUtil.AreaTimeStrFormat(e)
LuaUtils.SetLabelText(text_tishi1,e)
end
function OnOpen(t)
LuaUtils.SetToggleValue(toggle1,true)
h=e.TYPE1
if PlayerMgr:CheckIsNewPlayerByLevelOptimize()then
h=e.TYPE2
LuaUtils.SetActive(toggle1.transform,false)
end
UpdateContent()
EventSystem.AddListener(CommonEventId.GuildWarGetTaskAwardSuccess,OnGuildWarGetTaskAwardSuccess)
end
function UpdateContent()
u[h]()
end
function SetTap1()
LuaUtils.SetActive(p_zhouhuoyue1.transform,true)
LuaUtils.SetActive(p_zhouhuoyue2.transform,false)
local e=p_zhouhuoyue1:GetComponents()
n={}
local e=s.GetList()
for t=1,#e do
table.add(n,e[t].id)
end
table.sort(n,function(a,n)
local e=o:GetTaskAwardInfo(a)
local i=o:GetTaskAwardInfo(n)
local o=s.GetEntity(a)
local n=s.GetEntity(n)
local a=t.QUEST_NOT_ACTIVE
if e then
if e.status==t.QUEST_AWARDED then
a=1
elseif e.status==t.QUEST_NOT_ACTIVE then
a=2
else
a=3
end
end
local e=t.QUEST_NOT_ACTIVE
if i then
if i.status==t.QUEST_AWARDED then
e=1
elseif i.status==t.QUEST_NOT_ACTIVE then
e=2
else
e=3
end
end
if a~=e then
return a>e
end
if o.type~=n.type then
return o.type<n.type
end
return o.id<n.id
end)
a['uiScroll']:SetListItemCount(#n,true)
a['uiScroll']:RefreshAllShownItem()
a['uiScroll']:MovePanelToItemIndex(0,0)
UpdateOneKeyBtn()
end
function SetTap2()
LuaUtils.SetActive(p_zhouhuoyue1.transform,false)
LuaUtils.SetActive(p_zhouhuoyue2.transform,true)
i={}
table.add(i,l.winAward)
table.add(i,l.drawAward)
table.add(i,l.loseAward)
r['uiScroll']:SetListItemCount(#i,true)
r['uiScroll']:RefreshAllShownItem()
r['uiScroll']:MovePanelToItemIndex(0,0)
end
function GetItemByIndex1(a,e)
if e<0 then
return nil
end
local h=a:NewListViewItem("bg_1")
local e=n[e+1]
local a=s.GetEntity(e)
if a then
local e=LuaUtils.GetLuaComBinder(h.transform)
local e=e:GetComponents()
local i=o:GetTaskAwardInfo(a.id)
local n=t.QUEST_NOT_ACTIVE
if i then
n=i.status
end
local s=0
if i then
s=i.progress
end
LuaUtils.SetLabelText(e['text_title'],GetTaskConditionStr(a))
LuaUtils.SetLabelTextWrap(e['text_num'],s,a.num)
LuaUtils.SetChildrenActive(e['grid'],false)
for t=1,#a.award do
local a=a.award[t]
local t=UIUtil.GetChild(e['grid'],t-1)
if not t then
t=LuaUtils.Instantiate(e['itemCell'])
LuaUtils.SetParent(t,e['grid'])
LuaUtils.SetLocalScale(t,1,1,1)
local e,a,o=LuaUtils.GetLocalPos(t)
LuaUtils.SetLocalPos(t,e,a,0)
end
LuaUtils.SetActive(t,true)
local e={
thingDid=a[1],
offset=45,
}
UIUtil.SetItemCell(t,{itemDid=a[1],count=a[2]},e)
end
if n==t.QUEST_NOT_ACTIVE then
LuaUtils.SetActive(e['btn_weidacheng'],true)
LuaUtils.SetActive(e['text_yilingqu'],false)
LuaUtils.SetActive(e['btn_lingqu'],false)
elseif n==t.QUEST_ACTIVE then
LuaUtils.SetActive(e['btn_weidacheng'],false)
LuaUtils.SetActive(e['text_yilingqu'],false)
LuaUtils.SetActive(e['btn_lingqu'],true)
elseif n==t.QUEST_AWARDED then
LuaUtils.SetActive(e['btn_weidacheng'],false)
LuaUtils.SetActive(e['text_yilingqu'],true)
LuaUtils.SetActive(e['btn_lingqu'],false)
end
LuaUtils.GetUIEventListener(e['btn_lingqu']).onClick=function()
o:SendGetQuestAwardRequest(a.id)
end
end
return h
end
function GetItemByIndex2(e,o)
if o<0 then
return nil
end
local n=e:NewListViewItem("bg_1")
local e=i[o+1]
if e then
local t=LuaUtils.GetLuaComBinder(n.transform)
local t=t:GetComponents()
for o=1,#e do
local a=e[o]
local e=UIUtil.GetChild(t['grid'],o-1)
if not e then
e=LuaUtils.Instantiate(t['itemCell'])
LuaUtils.SetParent(e,t['grid'])
LuaUtils.SetLocalScale(e,1,1,1)
local t,a,o=LuaUtils.GetLocalPos(e)
LuaUtils.SetLocalPos(e,t,a,0)
end
LuaUtils.SetActive(e,true)
local t={
thingDid=a[1],
offset=45,
}
UIUtil.SetItemCell(e,{itemDid=a[1],count=a[2]},t)
end
UIUtil.SetLabelTextForLocalize(t['text_title'],c[o+1])
end
return n
end
function GetTaskConditionStr(e)
if e.type==d.AttrTime then
return GameTools.GetLocalize('UI.guildBattle.award.05',LanguageCategory.LangCommon,e.num)
elseif e.type==d.Score then
return GameTools.GetLocalize('UI.guildBattle.award.04',LanguageCategory.LangCommon,e.num)
elseif e.type==d.winCount then
return GameTools.GetLocalize('UI.guildBattle.award.19',LanguageCategory.LangCommon,e.num)
else
return""
end
end
function UpdateOneKeyBtn()
local e=true
for i,a in pairs(n)do
local a=s.GetEntity(a)
local o=o:GetTaskAwardInfo(a.id)
local a=t.QUEST_NOT_ACTIVE
if o then
a=o.status
end
if a==t.QUEST_ACTIVE then
e=false
break
end
end
UIUtil.SetGray(a['btn_yijian'].transform,e)
end
function OneKey()
o:SendGetQuestAwardRequest(0)
end
function OnGuildWarGetTaskAwardSuccess()
UpdateContent()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.GuildWarGetTaskAwardSuccess,OnGuildWarGetTaskAwardSuccess)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

