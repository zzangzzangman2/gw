local e=ModulesInit.GuildTerritoryMgr
local l=nil
local v=nil
local q=nil
local t=nil
local d={}
local n={}
local i={}
local x=1000
local y=0
local o=nil
local a=nil
local w=0
local m=false
local r=0
local s=nil
local h=nil
local k={}
local f=nil
local c=false
local j=0.2
local p=0
local u=nil
local b=0
local g=true
function OnInit(a,a)
btn_close.onClick:AddListener(function()
CloseUI()
end)
btn_shuoming.onClick:AddListener(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="UI_GuildTerritory_Main_Help"})
end)
InitButton()
t=UI_GuildTerritory_Map:GetComponent(typeof(CS.YouYou.LuaUnit))
t:Init()
o=map_task_info_tips:GetComponent(typeof(CS.YouYou.LuaUnit))
o:Init()
airship_list_scroll:InitListView(0,OnGetAirShipListItemByIndex)
u=UI_GuildTerritory_LogTips.transform:GetComponent(typeof(CS.YouYou.LuaUnit))
u:Init()
btn_TestShowMapTitle.onClick:AddListener(function()
if GameInit.IsEditor then
e.isTestShowMapTitle=not e.isTestShowMapTitle
SetTestShowMapTitle()
if e.isTestShowMapTitle then
t.scriptEnv.CrateTileMap()
else
t.scriptEnv.RemoveAllTile()
end
end
end)
end
function InitButton()
btn_pos.onClick:AddListener(function()
HideRransferNodeTrans()
t.scriptEnv.OnFocusMyBuilding(true)
end)
btn_city.onClick:AddListener(function()
HideRransferNodeTrans()
PlayerCityMgr:EnterView()
end)
btn_task.onClick:AddListener(function()
HideRransferNodeTrans()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTerritory_Radar)
end)
btn_transfer.onClick:AddListener(function()
OnClickTransferBtn()
HideRransferNodeTrans()
end)
btn_transfer_mask.onClick:AddListener(function()
HideRransferNodeTrans()
end)
end
function OnOpen(a)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.AddListener(CommonEventId.NewDay,OnEventNewDay)
EventSystem.AddListener(CommonEventId.RedPointInfoChange,RedPointInfoChange)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(SysEventId.OnZoom,OnZoom)
EventSystem.AddListener(SysEventId.OnClick,OnClick)
EventSystem.AddListener(SysEventId.OnEndDrag,OnEndDrag)
EventSystem.AddListener(SysEventId.OnBeginDrag,OnBeginDrag)
EventSystem.AddListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.AddListener(CommonEventId.OnRespGuildRadarInfo,OnRespGuildRadarInfo)
EventSystem.AddListener(CommonEventId.OnRespGuildRadarTransfer,OnRespGuildRadarTransfer)
EventSystem.AddListener(CommonEventId.OnGuildRadarTransferNotify,OnGuildRadarTransferNotify)
EventSystem.AddListener(CommonEventId.OnGuildRadarPlayerQuitNotify,OnGuildRadarPlayerQuitNotify)
EventSystem.AddListener(CommonEventId.OnRespGuildRadarDispatchShip,OnRespGuildRadarDispatchShip)
EventSystem.AddListener(CommonEventId.OnRespGuildRadarDispatchFinish,OnRespGuildRadarDispatchFinish)
EventSystem.AddListener(CommonEventId.OnRespGuildRadarAllExistAirship,OnRespGuildRadarAllExistAirship)
EventSystem.AddListener(CommonEventId.OnRespGuildRadarGetTaskReward,OnRespGuildRadarGetTaskReward)
EventSystem.AddListener(CommonEventId.OnGuildRadarAirshipBattleFinish,OnGuildRadarAirshipBattleFinish)
EventSystem.AddListener(CommonEventId.OnGuildRadarAirshipReturnFinish,OnGuildRadarAirshipReturnFinish)
EventSystem.AddListener(CommonEventId.OnClickGuildRadarTaskInMap,OnClickGuildRadarTaskInMap)
EventSystem.AddListener(CommonEventId.OnLuaViewChange,OnLuaViewChange)
EventSystem.AddListener(CommonEventId.OnPlayerCityChangeSkin,OnPlayerCityChangeSkin)
b=Time.time
InitData()
HideRransferNodeTrans()
LuaUtils.SetActive(rewardFinish_tips.transform,false)
InitRewardFinishTipsItemToPool()
t:Open({parentScriptEnv=selfEnv})
o:Open({parentScriptEnv=selfEnv})
RefreshView(true)
InitFocusPos(a)
e:ClearMainViewFirstOpenRed()
u:Open({})
SetUnGuildTerritoryVibe02Show(true)
UIUtil.DelayCall(self.UIFormId,0.5,function()
if ModulesInit.GuideMgr.isGuide then
if ModulesInit.GuideMgr.unit==ModulesInit.GuideMgr.EGuideCfg.Radar_Enter_Guide then
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="OPEN_UI_RADAR_MAIN_SUC"})
end
else
ModulesInit.GuideMgr:CheckRadar_RewardBack_Guide()
end
end)
SetTestShowMapTitle()
end
function OnClose()
UIUtil.StopSequence(self.UIFormId)
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.RemoveListener(CommonEventId.NewDay,OnEventNewDay)
EventSystem.RemoveListener(CommonEventId.RedPointInfoChange,RedPointInfoChange)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(SysEventId.OnZoom,OnZoom)
EventSystem.RemoveListener(SysEventId.OnClick,OnClick)
EventSystem.RemoveListener(SysEventId.OnEndDrag,OnEndDrag)
EventSystem.RemoveListener(SysEventId.OnBeginDrag,OnBeginDrag)
EventSystem.RemoveListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.RemoveListener(CommonEventId.OnRespGuildRadarInfo,OnRespGuildRadarInfo)
EventSystem.RemoveListener(CommonEventId.OnRespGuildRadarTransfer,OnRespGuildRadarTransfer)
EventSystem.RemoveListener(CommonEventId.OnGuildRadarTransferNotify,OnGuildRadarTransferNotify)
EventSystem.RemoveListener(CommonEventId.OnGuildRadarPlayerQuitNotify,OnGuildRadarPlayerQuitNotify)
EventSystem.RemoveListener(CommonEventId.OnRespGuildRadarDispatchShip,OnRespGuildRadarDispatchShip)
EventSystem.RemoveListener(CommonEventId.OnRespGuildRadarDispatchFinish,OnRespGuildRadarDispatchFinish)
EventSystem.RemoveListener(CommonEventId.OnRespGuildRadarAllExistAirship,OnRespGuildRadarAllExistAirship)
EventSystem.RemoveListener(CommonEventId.OnRespGuildRadarGetTaskReward,OnRespGuildRadarGetTaskReward)
EventSystem.RemoveListener(CommonEventId.OnGuildRadarAirshipBattleFinish,OnGuildRadarAirshipBattleFinish)
EventSystem.RemoveListener(CommonEventId.OnGuildRadarAirshipReturnFinish,OnGuildRadarAirshipReturnFinish)
EventSystem.RemoveListener(CommonEventId.OnClickGuildRadarTaskInMap,OnClickGuildRadarTaskInMap)
EventSystem.RemoveListener(CommonEventId.OnLuaViewChange,OnLuaViewChange)
EventSystem.RemoveListener(CommonEventId.OnPlayerCityChangeSkin,OnPlayerCityChangeSkin)
StopRespDelaySeq1Sequence()
StopRespDelaySeq2Sequence()
ClearRewardFinishTipsItemToPool()
d={}
t:Close()
o:Close()
a=nil
if l then
l.initData=false
end
u:Close()
end
function OnFormBack()
HideRransferNodeTrans()
end
function InitData()
r=0
v=e:GetRadarBaseCfg()
q=e:GetMapBaseCfg()
d={}
w=0
m=false
k={}
local t=e.myTaskInfoMap or{}
for t,e in pairs(t)do
if e and e.state==1 then
table.insert(k,t)
end
end
f=e.nextRefreshTime
c=false
p=Time.realtimeSinceStartup
y=0
e.localServerTime=TimeUtil.GetServerTimeStamp()
g=true
end
function InitFocusPos(e)
if e and e.initFoucsTaskId and e.initFoucsTaskId~=0 then
local e=t.scriptEnv.OnFocusClickSelectTaskBuilding(e.initFoucsTaskId)
if e then
return
end
end
t.scriptEnv.OnFocusMyBuilding()
end
function RefreshView(e)
RedPointInfoChange()
RefreshAirShipList()
t:Refresh()
o:Refresh()
end
function OnCheckShowRewardFinishTips()
if d and#d>0 then
local e=table.remove(d,1)
DoShowRewardFinishTips(e)
end
end
function DoShowRewardFinishTips(o)
if o==nil then
return
end
local t=o.taskDid
local i=e:GetRadarMissionCfgByDid(t)
if i==nil then
return
end
y=TimeUtil.GetServerMillTimeStamp()
local t=GetRewardFinishTipsTransItem()
t:DOKill()
local s=PlayerMgr.PlayerInfo
local a=LuaUtils.GetLuaComBinder(t.transform)
local a=a:GetComponents()
UIUtil.SetPlayerIconFrame(a["my_head_yuan150"],{head=s.head,headFrame=s.headFrame})
LuaUtils.SetTextMeshText(a["text_my_name"],s.name)
if o.isWin==true then
LuaUtils.SetTextMeshText(a["text_state"],GameTools.GetLocalize("UI_GuildTerritory_19",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(a["text_state"],GameTools.GetLocalize("UI_GuildTerritory_20",LanguageCategory.LangCommon))
end
LuaUtils.SetImageSprite(a["btn_npc_head"],i.headIcon,true)
local e=e:GetRadarMissionNameAndQuality(i)
LuaUtils.SetTextMeshText(a["text_npc_name"],e)
LuaUtils.SetActive(t,true)
t.transform:DOLocalMoveX(0,1.2):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(function()
n[t]=nil
RemoveRewardFinishTipsItemToPool(t.transform)
end)
GameTools:PlayAudioLua(336)
end
function InitRewardFinishTipsItemToPool()
n={}
i={}
local e=LuaUtils.GetChildrenCount(rewardFinish_tips_root.transform)
for e=1,e do
local e=LuaUtils.GetChild(rewardFinish_tips_root.transform,e-1)
if e then
RemoveRewardFinishTipsItemToPool(e)
end
end
end
function GetRewardFinishTipsTransItem()
local e=nil
if i==nil or#i<=0 then
e=LuaUtils.Instantiate(rewardFinish_tips.transform)
LuaUtils.SetParent(e.transform,rewardFinish_tips_root.transform)
else
e=table.remove(i,#i)
end
local t=LuaUtils.GetChildrenCount(rewardFinish_tips_root.transform)
LuaUtils.SetSiblingIndex(e.transform,t-1)
LuaUtils.SetLocalScale(e.transform,1,1,1)
LuaUtils.SetLocalPos(e.transform,Vector3(0,206,0))
if n==nil then
n={}
end
n[e]=true
return e.transform
end
function RemoveRewardFinishTipsItemToPool(e)
if e==nil then
return
end
if i==nil then
i={}
end
e:DOKill()
LuaUtils.SetActive(e,false)
table.insert(i,e)
end
function ClearRewardFinishTipsItemToPool()
for e,t in pairs(n)do
RemoveRewardFinishTipsItemToPool(e.transform)
end
n=nil
i=nil
end
function RefreshAirShipList()
a={}
local e=e.airshipInfoMap
if e then
for t,e in pairs(e)do
if e then
table.insert(a,e)
end
end
end
local e=v and v.airNum or 0
LuaUtils.SetTextMeshText(airship_num,#a.."/"..e)
UIUtil.RefreshScrollView(airship_list_scroll,#a,false)
RefreshAirshipListTime()
LuaUtils.SetActive(airship_list.transform,#a>0)
if#a>0 then
UIUtil.RefreshScrollViewHorizontalLayoutVertical(airship_list_scroll,265,70,#a)
end
end
function OnGetAirShipListItemByIndex(o,n)
n=n+1
local o=o:NewListViewItem("item")
local i=LuaUtils.GetLuaComBinder(o.transform)
local i=i:GetComponents()
if o.IsInitHandlerCalled==false then
o.IsInitHandlerCalled=true
i["btn_click"].onClick:AddListener(handler(o,function(e)
local e=e.UserObjectData
if e==nil then
return
end
local e=a[e.index]
if e~=nil and t~=nil then
t.scriptEnv.OnFocusAirShipByTaskId(e.targetTaskId,true)
end
HideRransferNodeTrans()
end))
end
local t=a[n]
o.UserObjectData={index=n,coms=i,trans=o.transform,curState=e.EAirshipState.None}
local t=e:GetRadarEventInfoByRadarEventId(t.targetTaskId)
if t==nil then
return o
end
local e=e:GetRadarMissionCfgByDid(t.taskDid)
if e==nil then
return o
end
local t="UIGuildTerritory/tmld_renwudi"..e.quality
LuaUtils.SetImageSprite(i["img_bg"],t)
LuaUtils.SetImageSprite(i["img_icon"],e.icon)
LuaUtils.SetTextMeshText(i["text_name"],GameTools.GetLocalize(e.name,LanguageCategory.LangCommon))
return o
end
function RefreshAirshipListTime()
local t=e:GetLocalServerTime()
local t=UIUtil.GetListViewAllItem(airship_list_scroll)
for o,t in pairs(t)do
if t.gameObject.activeSelf then
local o=t.UserObjectData
if o~=nil then
local s=o.coms
local a=a[o.index]
local n=""
local t=e.EAirshipState.None
local i=e:GetLocalServerTime()
if i<a.flyAwayOverTime then
t=e.EAirshipState.GoTo
local e=a.flyAwayOverTime-i
n=TimeUtil.toDHMSStr2(e)
elseif i<a.battleOverTime then
t=e.EAirshipState.Battle
local o="UI_GuildTerritory_04"
local t=e:GetRadarEventInfoByRadarEventId(a.targetTaskId)
if t~=nil then
local t=e:GetRadarMissionCfgByDid(t.taskDid)
if t~=nil then
if t.taskEnumerate==e.ERadarEventType.Collect then
o="UI_GuildTerritory_03"
end
end
end
n=GameTools.GetLocalize(o,LanguageCategory.LangCommon)
else
t=e.EAirshipState.Return
local e=a.flyOffOverTime-i
if e<0 then
e=0
end
n=TimeUtil.toDHMSStr2(e)
end
LuaUtils.SetTextMeshText(s["text_time"],n)
if o.curState~=t then
local e=e:GetAirshipStateIcon(t)
LuaUtils.SetImageSprite(s["img_stateIcon"],e,true)
end
o.curState=t
end
end
end
end
function SetUnGuildTerritoryVibe02Show(e)
LuaUtils.SetActive(un_GuildTerritory_vibe02.transform,e)
end
function OnClickSelectTask(e)
o.scriptEnv.SetTaskId(e)
o.scriptEnv.PlayOpenAnim()
end
function SetEventSelectNodeShow(e,a)
t.scriptEnv.SetEventSelectNodeShow(e,a)
end
local a=false
function OnClickSelectBlankMapCell(n,o,i,e)
w=n
RefreshisTransferBtnShow()
LuaUtils.SetActive(player_transfer_root.transform,true)
if t then
t.scriptEnv.SetTransferNode(true,i,e)
end
local e=player_transfer_node.parent.transform:InverseTransformPoint(o)
LuaUtils.SetLocalPos(player_transfer_node.transform,e.x,e.y,0)
a=true
end
function RefreshisTransferBtnShow()
local t=e.nextTransferTime and e.nextTransferTime or 0
m=t>=e:GetLocalServerTime()
UIUtil.SetGray(btn_transfer.transform,m,true)
LuaUtils.SetActive(text_transfer_time.transform,m)
end
function UpdateTransferCdLeftTime()
local t=e.nextTransferTime and e.nextTransferTime or 0
local a=t>=e:GetLocalServerTime()
if a~=m then
RefreshisTransferBtnShow()
end
if a==false then
return
end
local e=t-e:GetLocalServerTime()
if e<=0 then
e=0
end
LuaUtils.SetTextMeshText(text_transfer_time,GameTools.GetLocalize("UI_GuildTerritory_05",LanguageCategory.LangCommon,TimeUtil.toDHMSStr5(e)))
end
function HideRransferNodeTrans()
if a==false then
return
end
a=false
if t then
t.scriptEnv.SetTransferNode(false)
end
LuaUtils.SetActive(player_transfer_root.transform,false)
end
function OnClickTransferBtn()
if w<=0 then
return
end
local t=e.nextTransferTime and e.nextTransferTime or 0
if t>=e:GetLocalServerTime()then
return
end
local a=e.airshipInfoMap or{}
local t=false
for a,e in pairs(a)do
if e~=nil then
t=true
break
end
end
if t then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI_GuildTerritory_06",LanguageCategory.LangCommon))
return
end
e:OnReqGuildRadarTransfer(w)
end
function OnUpdate()
local a=TimeUtil.GetServerTimeStamp()
local i=e:GetLocalServerTime()
if i<a then
e.localServerTime=a
end
if t then
t.scriptEnv.OnUpdate()
end
u.scriptEnv.OnUpdate()
if y+x<TimeUtil.GetServerMillTimeStamp()then
OnCheckShowRewardFinishTips()
end
r=r-Time.deltaTime
if r>0 then
return
end
r=r+0.5
if f~=nil and f<=e:GetLocalServerTime()then
f=nil
c=true
end
if c==true then
OnReqGuildRadarInfo()
end
RefreshAirshipListTime()
o.scriptEnv.OnUpdateSec()
UpdateTransferCdLeftTime()
end
function CloseUI()
GameTools.CloseUIForm(self.UIFormId)
if e.isReturnGuildMainView==true then
if GameEntry.UI:IsExists(UIFormId.UI_GuildMainView)==false then
if PlayerMgr.PlayerInfo.guildId~=nil and PlayerMgr.PlayerInfo.guildId>0 then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildMainView)
end
end
end
e.isReturnGuildMainView=false
end
function OnReqGuildRadarInfo()
local e=OnReqGuildRadarInfoMust()
if e==false then
c=true
else
c=false
end
end
function OnReqGuildRadarInfoMust()
local t=Time.realtimeSinceStartup-p
if t>=j then
p=Time.realtimeSinceStartup
local e=e:OnReqGuildRadarInfo()
if e.sendResult==NetManager.ESendInfoResult.ok then
return true
else
return false
end
else
return false
end
end
function OnEventNewDay()
OnReqGuildRadarInfo()
end
function OnEventNetReconnectSuccess()
OnReqGuildRadarInfo()
end
function RedPointInfoChange()
LuaUtils.SetActive(red_task.transform,RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.PLAYER_GUILD_RADAR_TASK_CAN_REWARD))
end
function OnGuildLeave()
CloseUI()
end
function OnZoom(e)
if g and t then
t.scriptEnv.OnZoom(e)
end
end
function OnClick()
if t then
t.scriptEnv.ClearZoomData()
end
end
function OnEndDrag()
if t then
t.scriptEnv.ClearZoomData()
end
end
function OnBeginDrag()
if t then
t.scriptEnv.ClearZoomData()
end
end
function OnClickGuildRadarTaskInMap(e)
OnClickSelectTask(e.taskId)
t.scriptEnv.OnFocusClickSelectTaskBuilding(e.taskId)
end
function OnRespGuildRadarInfo()
RefreshView()
f=e.nextRefreshTime
end
function OnRespGuildRadarTransfer()
if t then
t.scriptEnv.OnRespGuildRadarTransfer()
end
end
function OnGuildRadarTransferNotify(e)
if t then
t.scriptEnv.OnGuildRadarTransferNotify(e)
end
end
function OnGuildRadarPlayerQuitNotify(e)
if t then
t.scriptEnv.OnGuildRadarPlayerQuitNotify(e)
end
end
function OnRespGuildRadarDispatchShip(e)
local e=e.ship
if e then
RefreshAirShipList()
t.scriptEnv.RefreshCrateAirship(e.targetTaskId)
t.scriptEnv.RefreshCrateRadarEvent(e.targetTaskId)
end
end
function OnRespGuildRadarDispatchFinish(e)
StopRespDelaySeq1Sequence()
if t then
t.scriptEnv.RefreshCrateAllRadarEvent()
end
o.scriptEnv.CheckTaskTipsShow()
ModulesInit.GuideMgr:CheckRadar_RewardBack_Guide()
end
function OnLuaViewChange()
local e=ViewMgr:checkIsTopShowView(self.UIFormId)
g=e
if e then
if Time.time-b>0.2 then
b=Time.time
ModulesInit.GuideMgr:CheckRadar_RewardBack_Guide()
end
end
end
function OnRespGuildRadarAllExistAirship()
StopRespDelaySeq2Sequence()
if t then
t.scriptEnv.RefreshCrateAllAirship()
end
RefreshAirShipList()
end
function OnRespGuildRadarGetTaskReward(e,e,e,e)
t.scriptEnv.RefreshCrateAllRadarEvent()
end
function OnGuildRadarAirshipBattleFinish(t,a)
if l then
l:OnGuildRadarAirshipBattleFinish(t)
end
local t=e:GetRadarEventInfoByRadarEventId(t)
if t then
local e=t.taskDid
table.insert(d,{taskDid=e,isWin=a})
end
s=CS.DG.Tweening.DOTween.Sequence()
s:AppendInterval(3)
s:AppendCallback(function()
s=nil
e:OnReqGuildRadarDispatchFinish()
end)
end
function OnGuildRadarAirshipReturnFinish(t)
if l then
l:OnGuildRadarAirshipReturnFinish(t)
end
h=CS.DG.Tweening.DOTween.Sequence()
h:AppendInterval(3)
h:AppendCallback(function()
h=nil
e:OnReqGuildRadarAllExistAirship()
end)
end
function OnPlayerCityChangeSkin(o)
local a=PlayerMgr.PlayerInfo.uid
local e=e:GetBuildingInfoByPlayerId(a)
if e~=nil then
e.skinId=o.skinId
if t then
t.scriptEnv.OnGuildRadarRefreshBuildingInfo(a)
end
end
end
function StopRespDelaySeq1Sequence()
if s~=nil then
s:Kill()
s=nil
end
end
function StopRespDelaySeq2Sequence()
if h~=nil then
h:Kill()
h=nil
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end
function SetTestShowMapTitle()
LuaUtils.SetActive(btn_TestShowMapTitle.transform,GameInit.IsEditor)
if GameInit.IsEditor then
UIUtil.SetGray(btn_TestShowMapTitle.transform,not e.isTestShowMapTitle)
end
end 
