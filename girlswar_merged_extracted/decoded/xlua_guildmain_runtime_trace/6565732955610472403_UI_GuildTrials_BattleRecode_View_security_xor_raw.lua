local o=require('DataNode/DataTable/Create/hero/DTHeroDBModel')
local i=ModulesInit.GuildTrialsMgr
local e={}
local e={}
function OnInit(e,e)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_BattleRecode_View)
end)
ScrollView:InitListView(0,OnGetItemByIndex)
end
function OnOpen(t)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
e=t.records
Refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
end
function OnEventNetReconnectSuccess()
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_BattleRecode_View)
end
function Refresh()
LuaUtils.SetActive(ScrollView.transform,false)
LuaUtils.SetActive(bg_empty.transform,false)
if#e>0 then
LuaUtils.SetActive(ScrollView.transform,true)
else
LuaUtils.SetActive(bg_empty.transform,true)
end
ScrollView:SetListItemCount(#e)
ScrollView:RefreshAllShownItem()
ScrollView:MovePanelToItemIndex(0)
end
function OnGetItemByIndex(o,t)
t=t+1
local a=e[t]
local e=o:NewListViewItem("item")
local t=LuaUtils.GetLuaComBinder(e.transform)
local t=t:GetComponents()
RefreshRecodeInfo(t,a)
return e
end
function RefreshRecodeInfo(t,e)
if t==nil or e==nil then
return
end
local a=i:getGuildTrialsMapsById(e.mapDid)
local a=a.heroDid
local a=o.GetEntity(a)
local a=GameTools.GetLocalize(a.heroName,LanguageCategory.LangBattle)
local e=GameTools.GetLocalize("guildTrials_desc_21",LanguageCategory.LangCommon,e.playerName,a,e.score)
LuaUtils.SetTextMeshText(t["text_zhanbao_desc"],e)
end
function OnBeforeDestroy()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

