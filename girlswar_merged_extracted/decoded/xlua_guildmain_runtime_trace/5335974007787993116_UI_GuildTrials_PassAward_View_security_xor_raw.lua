local o=ModulesInit.GuildTrialsMgr
local t={}
local n={}
local s=0
function OnInit(e,e)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_PassAward_View)
end)
ScrollView:InitListView(0,OnGetItemByIndex)
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.OnRespGuildTrialsPassAward,OnRespGuildTrialsPassAward)
Refresh(true)
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.OnRespGuildTrialsPassAward,OnRespGuildTrialsPassAward)
end
function OnEventNetReconnectSuccess()
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_PassAward_View)
end
function OnRespGuildTrialsPassAward()
Refresh()
end
function Refresh(e)
RefreshData()
ScrollView:SetListItemCount(#t)
ScrollView:RefreshAllShownItem()
if e then
ScrollView:MovePanelToItemIndex(0)
end
end
function RefreshData()
s=o.maxChapterLv
t=o:getGuildTrialsAwardList()
n=o.receiveChapterAwardLvMaps
end
function OnGetItemByIndex(a,e)
e=e+1
local o=t[e].cfg
local t=a:NewListViewItem("item")
local a=LuaUtils.GetLuaComBinder(t.transform)
local a=a:GetComponents()
RefreshPassAwardInfo(a,o,e)
return t
end
function RefreshPassAwardInfo(e,t,a)
if e==nil or t==nil then
return
end
LuaUtils.SetTextMeshText(e["text_reward_name"],GameTools.GetLocalize(t.name,LanguageCategory.LangCommon,t.id))
LuaUtils.SetLabelText(e["text_reward_desc"],GameTools.GetLocalize(t.desc,LanguageCategory.LangCommon,t.id))
for a=1,3 do
LuaUtils.SetActive(e["itemCell"..a].transform,false)
if t.award[a]then
LuaUtils.SetActive(e["itemCell"..a].transform,true)
local o={
thingDid=t.award[a][1],
offset=45
}
UIUtil.SetItemCell(e["itemCell"..a].transform,{itemDid=t.award[a][1],count=t.award[a][2]},o)
end
end
LuaUtils.SetActive(e["yilinquImg"].transform,false)
LuaUtils.SetActive(e["btn_lingqu"].transform,false)
if n[t.id]then
LuaUtils.SetActive(e["yilinquImg"].transform,true)
else
LuaUtils.SetActive(e["btn_lingqu"].transform,true)
if s<t.id then
UIUtil.SetGray(e["btn_lingqu"].transform,true)
else
UIUtil.SetGray(e["btn_lingqu"].transform,false)
end
end
e["btn_lingqu"].onClick:RemoveAllListeners()
e["btn_lingqu"].onClick:AddListener(function()
if n[i]then
UIUtil.ShowCommonTips(GameTools.GetLocalize("guildTrials_desc_48",LanguageCategory.LangCommon))
elseif s<t.id then
UIUtil.ShowCommonTips(GameTools.GetLocalize("guildTrials_desc_49",LanguageCategory.LangCommon))
else
o:reqGuildTrialsPassAward(t.id)
end
end)
end
function OnBeforeDestroy()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

