local e=ModulesInit.GuildTerritoryMgr
local l=nil
local o=nil
local i=0
local a={}
local t=nil
local n=nil
local h=true
local r=true
local d=require("Common/cs_coroutine")
local s
local u={
xMax=1,
xMin=2,
yMax=3,
yMin=4,
}
function OnInit(e,e)
btn_close.onClick:AddListener(function()
CloseUI()
end)
btn_shuoming.onClick:AddListener(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="UI_GuildRadar_Main_Help"})
end)
InitButton()
end
function InitButton()
btn_onekey.onClick:AddListener(function()
e:OnReqGuildRadarGetTaskReward(0)
end)
btn_closeTips.onClick:AddListener(function()
CancelSelectTask()
end)
end
function OnOpen(t)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.AddListener(CommonEventId.RedPointInfoChange,RedPointInfoChange)
EventSystem.AddListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.AddListener(CommonEventId.OnRespGuildRadarInfo,OnRespGuildRadarInfo)
EventSystem.AddListener(CommonEventId.OnGuildRadarPlayerQuitNotify,OnGuildRadarPlayerQuitNotify)
EventSystem.AddListener(CommonEventId.OnRespGuildRadarDispatchShip,OnRespGuildRadarDispatchShip)
EventSystem.AddListener(CommonEventId.OnRespGuildRadarDispatchFinish,OnRespGuildRadarDispatchFinish)
EventSystem.AddListener(CommonEventId.OnRespGuildRadarAllExistAirship,OnRespGuildRadarAllExistAirship)
EventSystem.AddListener(CommonEventId.OnRespGuildRadarGetTaskReward,OnRespGuildRadarGetTaskReward)
LuaUtils.SetLocalPos(middle_img_bg.transform,0,0,0)
LuaUtils.SetActive(radar_task_tips.transform,false)
LuaUtils.SetActive(img_mask.transform,false)
InitData()
CalculateMyOffset()
RefreshView(true)
if ModulesInit.GuideMgr.isGuide then
if e.isGuideSelectTask then
UIUtil.DelayCall(self.UIFormId,0.5,function()
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="OPEN_UI_RADAR_WAIT_EFF_SUC"})
end)
else
if ModulesInit.GuideMgr.unit==ModulesInit.GuideMgr.EGuideCfg.Radar_Enter_Guide then
GameInit.LogError('同盟雷达引导-未获取到指定的引导类型的任务！')
end
end
end
end
function OnClose()
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.RemoveListener(CommonEventId.RedPointInfoChange,RedPointInfoChange)
EventSystem.RemoveListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.RemoveListener(CommonEventId.OnRespGuildRadarInfo,OnRespGuildRadarInfo)
EventSystem.RemoveListener(CommonEventId.OnGuildRadarPlayerQuitNotify,OnGuildRadarPlayerQuitNotify)
EventSystem.RemoveListener(CommonEventId.OnRespGuildRadarDispatchShip,OnRespGuildRadarDispatchShip)
EventSystem.RemoveListener(CommonEventId.OnRespGuildRadarDispatchFinish,OnRespGuildRadarDispatchFinish)
EventSystem.RemoveListener(CommonEventId.OnRespGuildRadarAllExistAirship,OnRespGuildRadarAllExistAirship)
EventSystem.RemoveListener(CommonEventId.OnRespGuildRadarGetTaskReward,OnRespGuildRadarGetTaskReward)
n:Close()
StopMyCoroutine()
RemoveAllRadarEvent()
UIUtil.StopSequence(UIFormId.UI_GuildTerritory_Radar)
end
function InitData()
e.isGuideSelectTask=false
i=0
l=e:GetRadarBaseCfg()
o=e:GetMapBaseCfg()
t=nil
h=true
n=radar_task_tips.transform:GetComponent(typeof(CS.YouYou.LuaUnit))
n:Open()
end
function RefreshView(e)
SetLevelData()
RefreshCrateAllRadarEvent()
RefreshOneKeyBtn()
if r then
PlayOnebyOne()
r=false
end
h=false
end
function PlayOnebyOne()
LuaUtils.SetActive(img_mask.transform,true)
s=d.start(
function()
for t,e in pairs(a)do
LuaUtils.SetActive(e.transform,true)
e.scriptEnv.PlayItemEffect(1)
coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
end
LuaUtils.SetActive(img_mask.transform,false)
end)
end
function SetLevelData()
local a=e.curLevel
local t=ModulesInit.GuildTerritoryMgr:GetRadarLevelCfgByDid(a)
LuaUtils.SetTextMeshText(text_level,"Lv."..tostring(t.level))
local o=ModulesInit.GuildTerritoryMgr:GetRadarLevelCfgByDid(a+1)
local a=slider_exp.transform:GetComponent(typeof(CS.UnityEngine.UI.Slider))
if o==nil then
a.value=1
LuaUtils.SetTextMeshText(text_exp,GameTools.GetLocalize("UI_GuildTerritory_16",LanguageCategory.LangCommon))
else
a.value=e.curExp/t.levelUpExp
LuaUtils.SetTextMeshText(text_exp,tostring(e.curExp).."/"..tostring(t.levelUpExp))
end
RefreshProbability(t)
end
function RefreshProbability(e)
local t=e and e.normalEventsWeight or{}
for o=1,#t do
local e=LuaUtils.GetChild(probability_root.transform,o-1)
if not e then
e=LuaUtils.Instantiate(probability_item.transform)
LuaUtils.SetParent(e,probability_root.transform)
end
LuaUtils.SetActive(e,true)
local e=LuaUtils.GetLuaComBinder(e)
local a=e:GetComponents()
local e=t[o]
LuaUtils.SetTextMeshText(a["text_fill"],e[2].."%")
local t=ModulesInit.GuildTerritoryMgr.radarMissionQualityMap[e[1]].weightIcon
LuaUtils.SetImageSprite(a["img_fill"],t)
LuaUtils.SetImageFillAmount(a["img_fill"],e[2]/100)
end
local e=LuaUtils.GetChildrenCount(probability_root.transform)
for e=#t+1,e do
local e=LuaUtils.GetChild(probability_root.transform,e-1)
if IsNil(e)==false then
LuaUtils.SetActive(e,false)
end
end
end
function RefreshOneKeyBtn()
local t=false
for a,e in pairs(e.myTaskInfoMap)do
if e.status==PROTO_ENUM.PRT_TASK_STATUS.FINISH then
t=true
break
end
end
LuaUtils.SetActive(btn_onekey.transform,t)
end
function RefreshCrateAllRadarEvent()
e.isGuideSelectTask=false
local t=e.myTaskInfoMap or{}
local e={}
for a,o in pairs(a)do
if t[a]==nil then
e[a]=true
end
end
for t,a in pairs(t)do
RefreshCrateRadarEvent(t)
e[t]=nil
end
for e,t in pairs(e)do
if t then
RemoveRadarEvent(e)
end
end
local e=GetSortItemList()
for t=1,#e do
e[t].transform:SetAsFirstSibling()
end
end
function GetSortItemList()
local t={}
for a,e in pairs(a)do
table.insert(t,e)
end
table.sort(t,function(e,t)
if e.transform.position.y~=t.transform.position.y then
return e.transform.position.y<t.transform.position.y
else
return e.transform.position.x<t.transform.position.x
end
end)
return t
end
function RefreshCrateRadarEvent(o)
local i=e:GetRadarEventInfoByRadarEventId(o)
if i==nil and a[o]==nil then
return
end
local e=nil
if a[o]==nil then
e=CreateRadarEvent()
a[o]=e
if r then
LuaUtils.SetActive(e.transform,false)
elseif not h then
e.scriptEnv.PlayItemEffect(2)
end
SetItemPos(i,e.transform)
else
e=a[o]
end
if i==nil then
RemoveRadarEvent(o)
return
end
e:Refresh({taskId=o,isSelect=(o==t)})
end
function CreateRadarEvent()
local e=e:InstantiateCreateLuaUnit(radar_task_item.transform,task_item_parent.transform)
e:Init()
local t={parentScriptEnv=selfEnv,playerPosTrans=player_pos}
e:Open(t)
return e
end
function RemoveRadarEvent(t)
local e=a[t]
if e==nil then
return
end
e.scriptEnv.PlayItemEffect(3)
a[t]=nil
UIUtil.DelayCall(UIFormId.UI_GuildTerritory_Radar,0.4,function()
if not IsNil(e)then
e:Close()
GameObject.Destroy(e.gameObject)
end
end)
end
function RemoveAllRadarEvent()
for t,e in pairs(a)do
e:Close()
GameObject.Destroy(e.gameObject)
end
a={}
end
function StopMyCoroutine()
if s then
d.stop(s)
s=nil
end
end
function LocalSelectPos()
local o=Vector3.zero
if t~=nil and a[t]~=nil then
local e=a[t]
local t=select_pos.transform.localPosition
local e=e.transform.localPosition
o=Vector3(t.x-e.x,t.y-e.y,0)
end
middle_img_bg.transform:DOLocalMove(o,0.5):SetEase(CS.DG.Tweening.Ease.OutCubic):OnComplete(
function()
end)
end
function OnClickTransformBtn(a,e)
if t==nil or e~=t then
local a=t
t=e
if a~=nil then
RefreshCrateRadarEvent(a)
end
RefreshCrateRadarEvent(t)
local e=radar_task_tips:GetComponent(typeof(CS.UnityEngine.Animator))
if radar_task_tips.gameObject.activeSelf==false then
LuaUtils.SetActive(radar_task_tips.transform,true)
LuaUtils.AnimtorPlay(e,"un_GuildTerritory_act04",0,0)
end
n:Refresh(t)
LocalSelectPos()
end
end
function CancelSelectTask()
local e=t
t=nil
LuaUtils.SetActive(radar_task_tips.transform,false)
LocalSelectPos()
RefreshCrateRadarEvent(e)
end
function OnUpdate()
i=i-Time.deltaTime
if i>0 then
return
end
i=1
UpdateLingtuRefreshLeftTime()
end
function UpdateLingtuRefreshLeftTime()
local t=0
local a=e:GetLocalServerTime()
local e=e.curLevel
local o=ModulesInit.GuildTerritoryMgr:GetRadarLevelCfgByDid(e)
local e=o and o.refreshExtTime<=e
if e then
t=TimeUtil.GetTodayTimeStep(12,0)
if t<a then
t=TimeUtil.GetTodayTimeStep(24,0)
end
else
t=TimeUtil.GetTodayTimeStep(24,0)
end
local e=math.max(0,t-a)
LuaUtils.SetLabelTextWrap(text_nextTime,TimeUtil.toDHMSStr2(e))
end
function CloseUI()
GameTools.CloseUIForm(self.UIFormId)
end
function RedPointInfoChange()
end
function OnGuildLeave()
CloseUI()
end
function OnRespGuildRadarInfo()
RefreshView()
end
function OnGuildRadarPlayerQuitNotify(e)
CloseUI()
end
function OnRespGuildRadarDispatchShip(e)
end
function OnRespGuildRadarDispatchFinish(e)
if t~=nil then
for a,e in pairs(e)do
if e==t then
CancelSelectTask()
break
end
end
end
RefreshView()
end
function OnRespGuildRadarAllExistAirship()
end
function OnRespGuildRadarGetTaskReward(t,e,o,a)
if t then
UIUtil.forceShowUI(UIFormId.UI_GuildTerritory_LvUp,{oldLevel=o,newLevel=a,closeCallback=function()
ShowDrops(e)
end})
else
ShowDrops(e)
end
RefreshView()
end
function ShowDrops(e)
if#e.drops>0 then
UIUtil.ShowAwardWithServerData(e.drops,function()
RefreshView()
end)
else
RefreshView()
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end
local d
local s
local n
local h
local o=1120
local i=444
local a=4740
local r=2780
local l=a/o
local u=r/i
local t=50
function CalculateMyOffset()
local t=e:GetRadarBaseCfg().refreshDistance[2]
d=(e.tileWidth*t*2)/a
s=(e.tileHeight*t*2)/r
local a,t=e:GetSelfBuildingMapPos()
n,h=e:MapPos2UILocalPos(a,t)
end
function SetItemPos(a,o)
local t=e:GetTerritoryMapCfgByDid(a.posId)
local i,t=t.pos[1],t.pos[2]
local e,t=e:MapPos2UILocalPos(i,t)
local t,e=e-n,t-h
local i=(t/l)/d
local t=(e/u)/s
local e=player_pos.localPosition
local t,e=e.x+i,e.y+t
t,e=CheckOutSidePos(e,t,a.taskId)
t,e=CheckNearPos(t,e)
LuaUtils.SetLocalPos(o.transform,t,e,0)
end
function CheckOutSidePos(t,a,e)
local e=10
if a>o+e then
a=o+e
elseif a<-e then
a=-e
end
if t>i+e then
t=i+e
elseif t<-e then
t=-e
end
return a,t
end
function CheckNearPos(a,e)
local o=GetSortItemList()
for i=#o,1,-1 do
local o=o[i]
local i=o.transform.localPosition
local o=a-i.x
local i=e-i.y
if math.abs(o)<t and math.abs(i)<t then
if o>0 then
a=a+t
else
a=a-t
end
if i>0 then
e=e+t
else
e=e-t
end
end
end
return a,e
end 
