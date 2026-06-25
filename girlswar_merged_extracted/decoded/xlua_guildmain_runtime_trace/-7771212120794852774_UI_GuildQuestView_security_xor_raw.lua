local w=require('DataNode/DataTable/Create/guild/DTGuildQuestDBModel')
local d={
kWeek=1,
kAll=2
}
local r=0
local l=0
local o=d.kWeek
local i={}
local n={}
local s={}
local a={}
local h=0
local u=false
local c=false
local f=1
local m=100
function OnInit(t,e)
btn_fanhui.onClick:AddListener(
function()
GameTools.CloseUIForm(UIFormId.UI_GuildQuestView)
end
)
btn_tanhao.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="guildOffice"})
end
)
btn_shop.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_ShopMain,{type=PROTO_ENUM.ENUM_SHOP_TYPE.SHOP_GUILD})
end
)
toggle1.onClick:AddListener(
function()
SelectQuestView(d.kWeek)
end
)
toggle2.onClick:AddListener(
function()
SelectQuestView(d.kAll)
end
)
local e={}
e.mPadding1=110
e.mPadding2=0
e.mColumnOrRowCount=4
e.mItemWidthOrHeight=130
weekScroll:InitListView(0,e,OnGetWeekItemByIndex)
local e={}
e.mPadding1=110
e.mPadding2=0
e.mColumnOrRowCount=4
e.mItemWidthOrHeight=130
allScroll:InitListView(0,e,OnGetAllItemByIndex)
GameTools:ChangeSkeletonGraphic(t:Find("right/spine"),"Assets/Download/RolePrefabsAndRes/StoryPrefabAndRes/1041_1/1041_1.prefab")
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.NewDay,OnEventNewDay)
EventSystem.AddListener(CommonEventId.OnRespGuildQuestInfo,OnRespGuildQuestInfo)
EventSystem.AddListener(CommonEventId.OnRespGuildQuestWeekAward,OnRespGuildQuestWeekAward)
EventSystem.AddListener(CommonEventId.OnRespGuildQuestAllAward,OnRespGuildQuestAllAward)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.AddListener(CommonEventId.RedPointInfoChange,RefreshRedView)
EventSystem.AddListener(CommonEventId.OnEventActInfoChange,OnEventActInfoChange)
LuaUtils.SetActive(spine_review_node.transform,false)
LuaUtils.SetActive(spine_node.transform,false)
if GameTools:IsReview()then
LuaUtils.SetActive(spine_review_node.transform,true)
else
LuaUtils.SetActive(spine_node.transform,true)
end
ModulesInit.GuildMgr:ReqGuildQuestInfo()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.NewDay,OnEventNewDay)
EventSystem.RemoveListener(CommonEventId.OnRespGuildQuestInfo,OnRespGuildQuestInfo)
EventSystem.RemoveListener(CommonEventId.OnRespGuildQuestWeekAward,OnRespGuildQuestWeekAward)
EventSystem.RemoveListener(CommonEventId.OnRespGuildQuestAllAward,OnRespGuildQuestAllAward)
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.RemoveListener(CommonEventId.RedPointInfoChange,RefreshRedView)
EventSystem.RemoveListener(CommonEventId.OnEventActInfoChange,OnEventActInfoChange)
end
function OnFormBack()
end
function OnRespGuildQuestInfo(e)
local o=e.finishedQuestId
local t=e.rewardQuestId
r=e.weekTaskTimestamp
l=e.weekContribution
f=e.round or 1
s={}
a={}
for e=1,#o do
s[o[e]]=o[e]
end
for e=1,#t do
a[t[e]]=t[e]
end
RefreshData()
RefreshView()
end
function RefreshData()
i={}
n={}
u=false
c=false
local e=w.GetList()
for t,e in ipairs(e)do
if e.isClose~=1 then
local t={}
t.config=e
t.id=e.id
if a[e.id]then
t.sort=0
else
if s[e.id]then
t.sort=2
else
t.sort=1
end
end
if e.questSort==1 then
if a[e.id]then
c=true
end
table.insert(n,t)
else
if e.needCount>m then
m=e.needCount
end
if a[e.id]then
u=true
end
table.insert(i,t)
end
end
end
table.sort(n,sortTabFuc)
table.sort(i,sortTabFuc)
end
function sortTabFuc(e,t)
if e.sort~=t.sort then
return e.sort<t.sort
else
if e.config.listNum~=t.config.listNum then
return e.config.listNum<t.config.listNum
else
return e.id<t.id
end
end
end
function OnRespGuildQuestWeekAward(e)
s[e.questId]=e.questId
a[e.questId]=nil
RefreshData()
RefreshView()
end
function OnRespGuildQuestAllAward(e)
s[e.questId]=e.questId
a[e.questId]=nil
RefreshData()
RefreshView()
end
function OnEventActInfoChange()
RefreshShopRedPoint()
end
function RefreshShopRedPoint()
local e=ModulesInit.ActBlackFridayMgr:HasPrivilege()
LuaUtils.SetActive(node_friday.transform,e)
end
function RefreshView()
LuaUtils.SetActive(p_week.transform,false)
LuaUtils.SetActive(p_all.transform,false)
RefreshToggleView()
RefreshRedView()
if o==d.kWeek then
LuaUtils.SetActive(p_week.transform,true)
RefreshWeekView()
else
LuaUtils.SetActive(p_all.transform,true)
RefreshAllView()
end
end
function RefreshToggleView()
for e=1,2 do
LuaUtils.SetActive(selfEnv["im_off_"..e].transform,e~=o)
LuaUtils.SetActive(selfEnv["im_on_"..e].transform,e==o)
end
end
function RefreshRedView()
LuaUtils.SetActive(RedDot_1.transform,u)
LuaUtils.SetActive(RedDot_2.transform,c)
RefreshShopRedPoint()
end
function RefreshWeekView()
LuaUtils.SetTextMeshText(text_week_score,l)
local e=l/m
if e>1 then
e=1
end
bg_week_jindutiao.fillAmount=e
LuaUtils.SetLocalPos(im_week_arrow.transform,130+e*725,56,0)
weekScroll:SetListItemCount(#i,true)
weekScroll:RefreshAllShownItem()
end
function RefreshAllView()
allScroll:SetListItemCount(#n,true)
allScroll:RefreshAllShownItem()
end
function OnGetWeekItemByIndex(t,e)
e=e+1
local t=t:NewListViewItem("item_branch")
local e=i[e]
SetItem(t.transform,e)
return t
end
function OnGetAllItemByIndex(t,e)
e=e+1
local t=t:NewListViewItem("item_branch")
local e=n[e]
SetItem(t.transform,e)
return t
end
function SetItem(e,a)
local t=a.config
local e=LuaUtils.GetLuaComBinder(e)
local e=e:GetComponents()
UIUtil.SetTextMeshTextForLocalize(e['text_message'],t.text,LanguageCategory.LangCommon,UIUtil.toBigNum(t.needCount))
local o=t.reward
if f==2 then
o=t.reward2
end
LuaUtils.SetTextMeshText(e['text_mun'],"x"..o[1][2])
local o=ModulesInit.BagManager:GetBaseInfo(o[1][1])
GameTools:SetImageSprite(e["im_icon"],o.icon,false)
LuaUtils.SetActive(e['btn_go'],false)
LuaUtils.SetActive(e['im_duigou'].transform,false)
LuaUtils.SetActive(e['btn_lingqu'],false)
if a.sort==1 then
LuaUtils.SetActive(e['btn_go'],true)
if t.jump==0 then
UIUtil.SetGray(e['btn_go'],true)
LuaUtils.SetChildLabelTextMeshText(e['btn_go'],'text',GameTools.GetLocalize('UI.Tower.Main.15',LanguageCategory.LangCommon))
else
UIUtil.SetGray(e['btn_go'],false)
LuaUtils.SetChildLabelTextMeshText(e['btn_go'],'text',GameTools.GetLocalize('UI.Access.03',LanguageCategory.LangCommon))
end
elseif a.sort==2 then
LuaUtils.SetActive(e['im_duigou'].transform,true)
elseif a.sort==0 then
LuaUtils.SetActive(e['btn_lingqu'],true)
end
LuaUtils.GetUIEventListener(e['btn_go']).onClick=function()
if t.jump>0 then
JumpMgr:OnJumpUI(t.jump)
end
end
LuaUtils.GetUIEventListener(e['btn_lingqu']).onClick=function()
local e=function()
if t.questSort==1 then
ModulesInit.GuildMgr:ReqGuildQuestAllAward(t.id)
else
ModulesInit.GuildMgr:ReqGuildQuestWeekAward(t.id)
end
end
e()
end
end
function SelectQuestView(e)
if o==e then
return
end
o=e
RefreshView()
end
function OnEventNewDay()
GameTools.CloseUIForm(UIFormId.UI_GuildQuestView)
end
function OnUpdate()
h=h-Time.deltaTime
if h>0 then
return
end
h=1
UpdateFreeTime()
end
function UpdateFreeTime()
if r and r>0 then
local e=r/1000-TimeUtil.GetServerTimeStamp()
if e>0 then
LuaUtils.SetLabelText(text_week_left_time,GameTools.GetLocalize("tips.common_101",LanguageCategory.LangCommon,TimeUtil.toDHMSStr2(e,true)))
else
LuaUtils.SetActive(text_week_left_time.transform,false)
GameTools.CloseUIForm(UIFormId.UI_GuildQuestView)
end
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

