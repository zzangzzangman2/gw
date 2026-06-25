local e=ModulesInit.GuildTrialsMgr
local t={}
function OnInit(e,e)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_RescueRecode_View)
end)
ScrollView:InitListView(0,OnGetItemByIndex)
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
t={}
local e=e.recoreds
local a=nil
for o=1,#e do
local e=e[o]
e.timeDay=TimeUtil.timeStampToYMD(e.time)
if a and a~=e.timeDay then
table.insert(t,{type=1,record=e})
table.insert(t,{type=2,record=e})
table.insert(t,{type=3,record=e})
elseif not a then
table.insert(t,{type=2,record=e})
table.insert(t,{type=3,record=e})
elseif a and a==e.timeDay then
table.insert(t,{type=3,record=e})
end
a=e.timeDay
end
Refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
t={}
end
function OnEventNetReconnectSuccess()
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_RescueRecode_View)
end
function Refresh()
LuaUtils.SetActive(ScrollView.transform,false)
LuaUtils.SetActive(bg_empty.transform,false)
if#t>0 then
LuaUtils.SetActive(ScrollView.transform,true)
else
LuaUtils.SetActive(bg_empty.transform,true)
end
ScrollView:SetListItemCount(#t)
ScrollView:RefreshAllShownItem()
ScrollView:MovePanelToItemIndex(0)
end
function OnGetItemByIndex(a,e)
e=e+1
local t=t[e]
local e=a:NewListViewItem("item")
local a=LuaUtils.GetLuaComBinder(e.transform)
local a=a:GetComponents()
RefreshReCoredeInfo(a,t)
return e
end
function RefreshReCoredeInfo(t,e)
if t==nil or e==nil then
return
end
if e.type==1 then
LuaUtils.SetTextMeshText(t["text_recode_desc"],"")
elseif e.type==2 then
LuaUtils.SetTextMeshText(t["text_recode_desc"],e.record.timeDay)
elseif e.type==3 then
if e.record.giveOrGet then
LuaUtils.SetTextMeshText(t["text_recode_desc"],GameTools.GetLocalize("guildTrials_desc_28",LanguageCategory.LangCommon,e.record.playerName))
else
LuaUtils.SetTextMeshText(t["text_recode_desc"],GameTools.GetLocalize("guildTrials_desc_29",LanguageCategory.LangCommon,e.record.playerName))
end
end
end
function OnBeforeDestroy()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

