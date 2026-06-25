local e={}
local i=1
local o=1
local n=0
function OnInit(e,e)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildMemberView)
end)
btn_tuichu.onClick:AddListener(function()
local e=function()
if PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER
and ModulesInit.GuildMgr.guildInfo.curMemCount>1 then
UIUtil.ShowMessageBox({
onOkBtnClick=function()
end,
text=GameTools.GetLocalize("UI.guild.Tips.18",LanguageCategory.LangCommon),
buttons=MessageBoxButtons.OK,
okBtnContent=GameTools.GetLocalize('UI.guild.Tips.19'),
})
else
local e="UI.guild.Tips.15"
if ModulesInit.GuildMgr.quitCD<=0 then
e="UI.guild.Tips.15_1"
end
UIUtil.ShowMessageBox({
onOkBtnClick=function()
local e={
actionType=PROTO_ENUM.ENUM_MANAGE_ACTION.QUIT,
targetId=PlayerMgr.PlayerInfo.uid
}
ModulesInit.GuildMgr:ReqGuildManage(e)
end,
text=GameTools.GetLocalize(e,LanguageCategory.LangCommon,ModulesInit.GuildMgr:getJoinGuildLeftTime()),
buttons=MessageBoxButtons.OKCancel,
okBtnContent=GameTools.GetLocalize('UI.guild.Manage.64'),
cancelBtnContext=GameTools.GetLocalize('UI.guild.Manage.65'),
})
end
end
if ModulesInit.FullServerBattleYearMgr:IsOpen()then
local t=NetManager.SendEmpty(ProtoId.PRT_FSBY_INFO_REQ)
t.onCompleted=function(a,t)
if t.stage>PROTO_ENUM.ENUM_FSBY_STAGE.ENUM_FSBY_STAGE_SIGN then
UIUtil.ShowMessageBox({
onOkBtnClick=function()
e()
end,
text=GameTools.GetLocalize("fsby_quit_guild_tips",LanguageCategory.LangCommon),
buttons=MessageBoxButtons.OKCancel,
})
else
e()
end
end
else
e()
end
end)
btn_sort_up.onClick:AddListener(function()
ClickBtnSortView(1)
end)
btn_sort_drop.onClick:AddListener(function()
ClickBtnSortView(2)
end)
toggle1.onValueChanged:AddListener(function(e)
if e then
ShowTaggleViewByIndex(1)
end
end)
toggle2.onValueChanged:AddListener(function(e)
if e then
ShowTaggleViewByIndex(2)
end
end)
toggle3.onValueChanged:AddListener(function(e)
if e then
ShowTaggleViewByIndex(3)
end
end)
local e={}
e.mPadding1=0
e.mPadding2=0
e.mColumnOrRowCount=2
e.mItemWidthOrHeight=420
ScrollView:InitListView(0,e,OnGetItemByIndex)
end
function OnOpen(t)
EventSystem.AddListener(CommonEventId.OnRespGuildMemberList,OnRespGuildMemberList)
EventSystem.AddListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.AddListener(CommonEventId.OnGuildPosChange,OnGuildPosChange)
EventSystem.AddListener(CommonEventId.OnRespGuildManage,OnRespGuildManage)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
local t=SaveMgr.GetIntByAccServerIdPlayerUid("GUIDEMEMBERSOURT","",1)
i=t
o=1
e={}
LuaUtils.SetToggleValue(toggle1,true)
ModulesInit.GuildMgr:ReqGuildMemberList()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnRespGuildMemberList,OnRespGuildMemberList)
EventSystem.RemoveListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.RemoveListener(CommonEventId.OnGuildPosChange,OnGuildPosChange)
EventSystem.RemoveListener(CommonEventId.OnRespGuildManage,OnRespGuildManage)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
o=1
n=0
end
function OnBeforeDestroy()
end
function Refresh()
RefreshSortBtnStatus()
ShowTaggleViewByIndex(o)
end
function RefreshScrollView()
ScrollView:SetListItemCount(#e)
ScrollView:RefreshAllShownItem()
end
function RefreshSortBtnStatus()
LuaUtils.SetActive(sort_up_light.transform,false)
LuaUtils.SetActive(sort_drop_light.transform,false)
if i==1 then
LuaUtils.SetActive(sort_up_light.transform,true)
else
LuaUtils.SetActive(sort_drop_light.transform,true)
end
end
function OnGetItemByIndex(t,i)
i=i+1

local o=t:NewListViewItem("juese1")
local t=LuaUtils.GetLuaComBinder(o.transform)
local t=t:GetComponents()
local a=e[i]
if a==nil then
return
end
UIUtil.SetPlayerIconFrame(t["head_yuan150"],
{head=a.head,
headFrame=a.headFrame,
playerId=a.memberId,
severId=UserAccountInfo.serverId,
})
LuaUtils.SetActive(t["text_level_time_2"].transform,false)
LuaUtils.SetActive(t["text_level_time"].transform,false)
if a.logoutTime==0 then
LuaUtils.SetActive(t["text_level_time_2"].transform,true)
LuaUtils.SetTextMeshText(t["text_level_time_2"],UIUtil.GetDeepGreenTichText(GameTools.GetLocalize("UI.guild.Main.27",LanguageCategory.LangCommon)))
else
LuaUtils.SetActive(t["text_level_time"].transform,true)
local e=TimeUtil.GetServerTimeStamp()-a.logoutTime/1000
if e<=0 then
LuaUtils.SetTextMeshText(t["text_level_time"],UIUtil.GetDeepGreenTichText(GameTools.GetLocalize("UI.guild.Main.27",LanguageCategory.LangCommon)))
else
LuaUtils.SetTextMeshText(t["text_level_time"],UIUtil.GetOrangeTichText(GameTools.GetLocalize("UI.guild.Main.28",LanguageCategory.LangCommon,TimeUtil.toDHMSStr4(e))))
end
end
LuaUtils.SetTextMeshText(t["text_lv"],GameTools.GetLocalize("UI.guild.Main.03",LanguageCategory.LangCommon,a.level))
LuaUtils.SetLabelText(t["text_name"],a.name)
LuaUtils.SetLabelText(t["text_gongxiandu"],GameTools.GetLocalize("UI.guild.Manage.40",LanguageCategory.LangCommon,a.weekContribution))
UIUtil.setGuildPosData(t,a.postion)
if o.IsInitHandlerCalled==false then
o.IsInitHandlerCalled=true
t["btn_pannel"].onClick:AddListener(handler(o,function(t)
local t=t.UserObjectData
local e=e[t]
if e then
n=t-1
UIUtil.showPlayerInfo(e.memberId,UserAccountInfo.serverId,true)
end
end))
end
o.UserObjectData=i
return o
end
function OnRespGuildMemberList(t)
local t=t.members
e={}
for a=1,#t do
table.insert(e,t[a])
end
SortGuildMemberList(e)
Refresh()
end
function SortGuildMemberList(a)
if i==1 then
if o==1 then
table.sort(a,function(t,e)
if t.logoutTime~=e.logoutTime then
if t.logoutTime==0 and e.logoutTime~=0 then
return true
end
if t.logoutTime~=0 and e.logoutTime==0 then
return false
end
return t.logoutTime>e.logoutTime
end
if t.postion~=e.postion then
return t.postion>e.postion
end
if t.weekContribution~=e.weekContribution then
return t.weekContribution>e.weekContribution
end
if t.level~=e.level then
return t.level>e.level
end
return t.memberId<e.memberId
end)
elseif o==2 then
table.sort(a,function(t,e)
if t.postion~=e.postion then
return t.postion>e.postion
end
if t.weekContribution~=e.weekContribution then
return t.weekContribution>e.weekContribution
end
if t.level~=e.level then
return t.level>e.level
end
return t.memberId<e.memberId
end)
else
table.sort(a,function(t,e)
if t.weekContribution~=e.weekContribution then
return t.weekContribution>e.weekContribution
end
if t.postion~=e.postion then
return t.postion>e.postion
end
if t.level~=e.level then
return t.level>e.level
end
return t.memberId<e.memberId
end)
end
else
if o==1 then
table.sort(a,function(e,t)
if e.logoutTime~=t.logoutTime then
if e.logoutTime==0 and t.logoutTime~=0 then
return false
end
if e.logoutTime~=0 and t.logoutTime==0 then
return true
end
return e.logoutTime<t.logoutTime
end
if e.postion~=t.postion then
return e.postion<t.postion
end
if e.weekContribution~=t.weekContribution then
return e.weekContribution<t.weekContribution
end
if e.level~=t.level then
return e.level<t.level
end
return e.memberId<t.memberId
end)
elseif o==2 then
table.sort(a,function(t,e)
if t.postion~=e.postion then
return t.postion<e.postion
end
if t.weekContribution~=e.weekContribution then
return t.weekContribution<e.weekContribution
end
if t.level~=e.level then
return t.level<e.level
end
return t.memberId<e.memberId
end)
else
table.sort(a,function(e,t)
if e.weekContribution~=t.weekContribution then
return e.weekContribution<t.weekContribution
end
if e.postion~=t.postion then
return e.postion<t.postion
end
if e.level~=t.level then
return e.level<t.level
end
return e.memberId<t.memberId
end)
end
end
return a
end
function OnGuildLeave()
GameTools.CloseUIForm(UIFormId.UI_GuildMemberView)
end
function OnGuildPosChange()
ModulesInit.GuildMgr:ReqGuildMemberList()
end
function OnRespGuildManage(t)
local a=t.actionType
local i=t.targetId
local s=t.targetGuildPos
for t=1,#e do
local o=e[t]
if o.memberId==i then
if a==PROTO_ENUM.ENUM_MANAGE_ACTION.KICK then
table.remove(e,t)
elseif a==PROTO_ENUM.ENUM_MANAGE_ACTION.QUIT then
EventSystem.SendEvent(CommonEventId.OnGuildLeave,{exitType=PROTO_ENUM.ENUM_MANAGE_ACTION.QUIT})
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Tips.16",LanguageCategory.LangCommon))
return
else
o.postion=s
end
break;
end
end
for t=1,#e do
local e=e[t]
if e.memberId==PlayerMgr.PlayerInfo.uid then
e.postion=PlayerMgr.PlayerInfo.guildPos
break;
end
end
SortGuildMemberList(e)
Refresh()
ScrollView:MovePanelToItemIndex(n)
end
function ClickBtnSortView(e)
if i==e then
return
end
i=e
SaveMgr.SetIntByAccServerIdPlayerUid("GUIDEMEMBERSOURT","",i)
SortView()
end
function ShowTaggleViewByIndex(t)
o=t
SortGuildMemberList(e)
RefreshScrollView()
end
function SortView()
RefreshSortBtnStatus()
SortGuildMemberList(e)
RefreshScrollView()
end
function OnEventNetReconnectSuccess()
ModulesInit.GuildMgr:ReqGuildMemberList()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

