local t=ModulesInit.GuildTerritoryMgr
local e=nil
local a=false
local i=0
function OnInit(t,t)
e=Content.transform
i=infoScrollView.transform.sizeDelta.y
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.OnSyncGuildRadarOtherTaskComplete,OnSyncGuildRadarOtherTaskComplete)
t.tipLogs={}
a=false
OnRefresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnSyncGuildRadarOtherTaskComplete,OnSyncGuildRadarOtherTaskComplete)
UIUtil.StopSequence("RebuildAllLogLayout")
LuaUtils.DestroyImmediateChildren(e)
t.tipLogs={}
end
function OnBeforeDestroy()
end
function OnUpdate()
if a and mItemTrans.gameObject.activeInHierarchy then
RefreshAllLogData()
end
end
function OnRefresh()
RefreshAllLogData()
end
function RefreshAllLogData()
LuaUtils.SetChildrenActive(e,false)
e.anchoredPosition=Vector2(0,0)
e.sizeDelta=Vector2(e.sizeDelta.x,0)
LuaUtils.SetActive(mItemTrans,#t.tipLogs>0)
for e=1,#t.tipLogs do
OnAddLog(t.tipLogs[e],false,e)
end
a=false
end
function OnAddLog(o,i,a)
if i then
table.insert(t.tipLogs,o)
a=#t.tipLogs
end
local t=UIUtil.GetChild(e,a-1)
if not t then
t=LuaUtils.Instantiate(info_item.transform)
LuaUtils.SetParent(t,e)
end
LuaUtils.SetActive(t,true)
local e=SetLogItem(t,o)
local e=RebuildAllLogLayout(e)
t.anchoredPosition=Vector2(0,-e)
end
function SetLogItem(e,a)
local o=LuaUtils.GetLuaComBinder(e)
local o=o:GetComponents()
local i=a.name.."  "
local a=t:GetRadarMissionCfgByDid(a.tipTaskDid)
local t="  "..t:GetRadarMissionNameAndQuality(a).."  "
LuaUtils.SetTextMeshText(o["text_title"],GameTools.GetLocalize("UI_GuildTerritory_01",LanguageCategory.LangCommon,i,t))
CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(o["text_title"].transform)
CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(e)
return e.transform.sizeDelta.y
end
function RebuildAllLogLayout(a)
local o=e.sizeDelta.y
e.sizeDelta=Vector2(e.sizeDelta.x,a+e.sizeDelta.y)
UIUtil.StopSequence("RebuildAllLogLayout")
UIUtil.DelayCall("RebuildAllLogLayout",0.01,function()
local a=math.max(0,e.sizeDelta.y-i)
e.anchoredPosition=Vector2(0,a)
LuaUtils.SetActive(mItemTrans,#t.tipLogs>0)
end)
return o
end
function OnSyncGuildRadarOtherTaskComplete(e)
LuaUtils.SetActive(mItemTrans,true)
if mItemTrans.gameObject.activeInHierarchy then
OnAddLog(e.logData,true)
else
a=true
table.insert(t.tipLogs,e.logData)
end
end 
