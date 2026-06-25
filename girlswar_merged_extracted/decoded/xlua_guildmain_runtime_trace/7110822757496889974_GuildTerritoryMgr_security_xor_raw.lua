local a=require('DataNode/DataTable/Create/guild/DTGuildTerritoryMapDBModel')
local s=require('DataNode/DataTable/Create/guild/DTGuildTerritoryBaseDBModel')
local i=require('DataNode/DataTable/Create/guild/DTGuildRadarBaseDBModel')
local e=require('DataNode/DataTable/Create/guild/DTGuildRadarArmyDBModel')
local h=require('DataNode/DataTable/Create/guild/DTGuildRadarLevelDBModel')
local o=require('DataNode/DataTable/Create/guild/DTGuildRadarMonsterDBModel')
local l=require('DataNode/DataTable/Create/guild/DTGuildRadarMissionIDDBModel')
local r=require('DataNode/DataTable/Create/airship/DTAirShipAtlasDBModel')
local n=require("DataNode/DataTable/Create/monster/DTMonsterDBModel")
local d=require("DataNode/DataTable/Create/constant/DTBattleDBModel")
local t=nil
local e={
tileWidth=360,
tileHeight=180,
halfW=360*0.5,
halfH=180*0.5,
offsetX=30,
offsetY=40,
curExp=0,
curLevel=0,
nextRefreshTime=0,
lastTaskNum=0,
nextTransferTime=0,
buildingInfoMap={},
airshipInfoMap={},
myTaskInfoMap={},
otherTaskInfoMap={},
tipLogs={},
mapPosUnitMapIdMap={},
radarMissionQualityMap={},
isOpenGuildTerritory=false,
recordFoucsTaskId=nil,
localServerTime=0,
isReturnGuildMainView=false
}
e.ERadarEventType={
None=0,
Monster=1,
Collect=2,
Rescue=3,
Fight=4,
Assess=5,
Army=6,
}
e.EAirshipState={
None=0,
GoTo=1,
Battle=2,
Return=3,
Finish=4,
}
function e.Init()
e:InitData()
e:ResetData()
end
function e:InitData()
self.mapPosUnitMapIdMap={}
local e=a.GetList()
for t,e in ipairs(e)do
local t=e.pos[1]
local a=e.pos[2]
if self.mapPosUnitMapIdMap[t]==nil then
self.mapPosUnitMapIdMap[t]={}
end
self.mapPosUnitMapIdMap[t][a]=e.id
end
self.radarMissionQualityMap={
[1]={strKey="Radar_mission_color_01",color="ffffff",weightIcon="UIGuildTerritory/tmld_gailv01"},
[2]={strKey="Radar_mission_color_02",color="1bcd2c",weightIcon="UIGuildTerritory/tmld_gailv02"},
[3]={strKey="Radar_mission_color_03",color="4dbaff",weightIcon="UIGuildTerritory/tmld_gailv03"},
[4]={strKey="Radar_mission_color_04",color="ef68f2",weightIcon="UIGuildTerritory/tmld_gailv04"},
[5]={strKey="Radar_mission_color_05",color="ffc90d",weightIcon="UIGuildTerritory/tmld_gailv05"},
[6]={strKey="Radar_mission_color_06",color="ff4141",weightIcon="UIGuildTerritory/tmld_gailv06"},
}
self.sxMax=self:GetMapBaseCfg().mapScaleMax
self.sxMin=self:GetMapBaseCfg().mapScaleMin
self.localServerTime=0
end
function e:GetLocalServerTime()
return math.floor(e.localServerTime)
end
function e:ResetData()
self:ResetMapData()
end
function e:ResetMapData()
self.curExp=0
self.curLevel=0
self.nextRefreshTime=0
self.lastTaskNum=0
self.nextTransferTime=0
self.buildingInfoMap={}
self.airshipInfoMap={}
self.myTaskInfoMap={}
self.otherTaskInfoMap={}
self.tipLogs={}
self.isGuideSelectTask=false
self.isTestShowMapTitle=false
self.isReturnGuildMainView=false
end
function e:GetAirshipStateIcon(e)
if e==self.EAirshipState.GoTo then
return"UIGuildTerritory/slg_bt_xingshi"
elseif e==self.EAirshipState.Battle then
return"UIGuildTerritory/slg_bt_jiaohuo"
else
return"UIGuildTerritory/slg_bt_fanhui"
end
return""
end
function e:IsActHaveRed()
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.PLAYER_GUILD_RADAR_TASK_CAN_REWARD)then
return true
end
if e:CheckMainViewFirstOpenRed()then
return true
end
return false
end
function e:CheckMainViewFirstOpenRed()
local e=TimeUtil.GetServerToDHMS().day
local t=SaveMgr.GetStringForKey("GuildTerritory_Main_First_Open","")
return not(t==tostring(e))
end
function e:ClearMainViewFirstOpenRed()
if e:CheckMainViewFirstOpenRed()then
local e=TimeUtil.GetServerToDHMS().day
SaveMgr.SetStringForKey("GuildTerritory_Main_First_Open",tostring(e))
RedPointMgr:doNotify()
end
end
function e:GetMapBaseCfg()
return s.GetEntity(1)
end
function e:GetTerritoryMapCfgList()
return a.GetList()
end
function e:GetTerritoryMapCfgByDid(e)
return a.GetEntity(e)
end
function e:GetRadarBaseCfg()
return i.GetEntity(1)
end
function e:GetRadarMissionCfgByDid(e)
return l.GetEntity(e)
end
function e:GetRadarMonsterCfgByDid(e)
return o.GetEntity(e)
end
function e:GetRadarLevelCfgByDid(e)
return h.GetEntity(e)
end
function e:GetRadarMonsterCfgByDid(e)
return o.GetEntity(e)
end
function e:GetAirShipCfg(e)
return r.GetEntity(e)
end
function e:GetAirShipTime(o,a,t)
local i=o[1]
local n=o[2]
local o=a[1]
local a=a[2]
local a=math.sqrt(self:Pow(o-i,2)+self:Pow(a-n,2));
local a=math.ceil(a);
if t==nil then
local e=e:GetRadarBaseCfg()
t=e.airSpeed
end
local e=(a/(t/10000));
return math.ceil(e)
end
function e:Pow(t,e)
if e<0 then
t=1/t
e=-e
end
local a=1
local t={t}
while e>0 do
if e%2==1 then
a=a*t[1]
end
t[1]=t[1]*t[1]
e=math.floor(e/2)
end
return a
end
function e:GetRadarMissionNameAndQuality(e)
if e==nil then
return""
end
local t=GameTools.GetLocalize(e.name,LanguageCategory.LangCommon)
if self.radarMissionQualityMap and self.radarMissionQualityMap[e.quality]then
local e=self.radarMissionQualityMap[e.quality]
t=t.." <color=#"..e.color..">"..GameTools.GetLocalize(e.strKey,LanguageCategory.LangCommon).."</color>"
end
return t
end
function e:GetPosIdByMapPos(e,t)
if self.mapPosUnitMapIdMap[e]~=nil and self.mapPosUnitMapIdMap[e][t]~=nil then
return self.mapPosUnitMapIdMap[e][t]
end
return-1
end
function e:GetSelfBuildingMapPos()
local t=PlayerMgr.PlayerInfo.uid
local t=e:GetBuildingInfoByPlayerId(t)
if t==nil then
return 0,0
end
local e=e:GetTerritoryMapCfgByDid(t.posId)
if e==nil then
return 0,0
end
return e.pos[1],e.pos[2]
end
function e:GetSelfBuildingUILocalPos()
local t,e=self:GetSelfBuildingMapPos()
local t,e=self:MapPos2UILocalPos(t,e)
return t,e
end
function e:SetTransUILocalPos(i,e,o)
local e=self:GetTerritoryMapCfgByDid(e)
local t,a=0,0
if o==true then
t,a=self:GetRadarEventUILocalPos(e.pos[1],e.pos[2])
else
t,a=self:MapPos2UILocalPos(e.pos[1],e.pos[2])
end
LuaUtils.SetLocalPos(i.transform,t,a,0)
end
function e:MapPos2UILocalPos(a,t)
local e=(a-t)*self.halfW
local t=(a+t)*self.halfH
e=e+self.offsetX
t=t+self.offsetY
return e,t
end
function e:GetRadarEventUILocalPos(t,e)
local t,e=self:MapPos2UILocalPos(t,e)
e=e-self.halfH
return t,e
end
function e:UILocalPos2MapPos(t,e)
t=t-self.offsetX
e=e-self.offsetY
local a=(t/self.halfW+e/self.halfH)*0.5
local o=(e/self.halfH-t/self.halfW)*0.5
local a=math.floor(a)
local o=math.floor(o)
local i=nil
local n,r=-1,-1
for h=-1,1 do
for s=-1,1 do
local a=a+h
local o=o+s
local s=(a-o)*self.halfW
local h=(a+o)*self.halfH
local l=math.abs(t-s)/self.halfW
local d=math.abs(e-h)/self.halfH
if l+d<=1.001 then
return a,o
end
local t=t-s
local e=e-h
local e=t*t+e*e
if i==nil or e<i then
i=e
n=a
r=o
end
end
end
return n,r
end
function e:InstantiateCreateLuaUnit(e,t)
local e=LuaUtils.Instantiate(e.transform)
LuaUtils.SetParent(e,t)
LuaUtils.SetLocalPos(e,0,0,0)
LuaUtils.SetActive(e,true)
return e:GetComponent(typeof(CS.YouYou.LuaUnit))
end
function e:IsPointInScreenShowRect(e)
local t=GameEntry.CameraCtrl.UICamera
local e=t:WorldToScreenPoint(Vector3(e.x,e.y,0))
local e=Vector2(e.x,e.y)
local t=CS.UnityEngine.Screen.width
local a=CS.UnityEngine.Screen.height
local i=t*0.5
local o=a*0.5
local t=t*0.5
local a=a*0.5
if e.x>=t-i and e.x<=t+i and
e.y>=a-o and e.y<=a+o then
return true
else
return false
end
end
function e:GetBuildingInfoByPlayerId(e)
if self.buildingInfoMap[e]then
return self.buildingInfoMap[e]
end
return nil
end
function e:GetAirshipInfoByRadarEventId(e)
if self.airshipInfoMap[e]then
return self.airshipInfoMap[e]
end
return nil
end
function e:GetRadarEventInfoByRadarEventId(e)
if self.myTaskInfoMap[e]then
return self.myTaskInfoMap[e]
end
return nil
end
function e:GetOtherRadarEventInfoByRadarEventId(e)
if self.otherTaskInfoMap[e]then
return self.otherTaskInfoMap[e]
end
return nil
end
function e:GetRadarEventInfoByPosId(a)
local t=nil
if self.myTaskInfoMap then
for o,e in pairs(self.myTaskInfoMap)do
if e.posId==a then
t=e
break
end
end
end
return t
end
function e:IsHaveCanRewardRadarEvent()
local e={}
for a,t in pairs(self.myTaskInfoMap or{})do
if t.status==PROTO_ENUM.PRT_TASK_STATUS.FINISH then
table.insert(e,t)
end
end
return#e>0,e
end
function e:IsHaveCanRewardGuideRadarEvent()
local t,a=e:IsHaveCanRewardRadarEvent()
if not t then
return false
end
for a,t in ipairs(a)do
if e:CheckIsGuideTask(t,true)then
return true
end
end
return false
end
function e:CheckIsGuideTask(e,t)
if t then
return e.status==PROTO_ENUM.PRT_TASK_STATUS.FINISH
else
local e=self:GetRadarMissionCfgByDid(e.taskDid)
if e.battleType==3 or e.battleType==2 then
return true
end
end
return false
end
function e:EnterGuildTerritoryMainView(t,a,o)
if not(PlayerMgr.PlayerInfo.guildId and PlayerMgr.PlayerInfo.guildId>0)then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UICollectiblesHeroBorrow2",LanguageCategory.LangCommon))
return
end
if not GameFunction.IsFunctionUnLock(GameFunctionType.GuildTerritory,true)then
return
end
DynamicModuleRes.GuildTerritoryMainUIDownaload(function()
local e=e:OnReqGuildRadarInfo()
e.onCompleted=function(e,e)
if GameEntry.UI:IsExists(UIFormId.UI_GuildMainView)then
GameEntry.UI:CloseUIForm(UIFormId.UI_GuildMainView)
end
self.isReturnGuildMainView=false
if GameEntry.UI:IsExists(UIFormId.UI_GuildTerritory_Main)then
GameEntry.UI:CloseUIForm(UIFormId.UI_GuildTerritory_Main)
end
self.isReturnGuildMainView=a
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTerritory_Main,o)
if t then
t()
end
end
end)
end
function e:OnShowPlayerInfo(e)
if t~=nil then
UIUtil.showPlayerInfo(100441402)
else
UIUtil.showPlayerInfo(e)
end
end
function e:OnReqGuildRadarInfo()
if t~=nil then
return t:TestOnReqGuildRadarInfo()
else
return NetManager.Send(ProtoId.PRT_GUILD_RADAR_INFO_REQ)
end
end
function e:OnRespGuildRadarInfo(e)
self.myTaskInfoMap={}
self.airshipInfoMap={}
self.buildingInfoMap={}
self.otherTaskInfoMap={}
if e~=nil then
self.curExp=e.curExp
self.curLevel=e.curLevel
self.nextRefreshTime=e.nextRefreshTime
self.lastTaskNum=e.lastTaskNum
self.nextTransferTime=e.nextTransferTime
if e.bases then
for t=1,#e.bases do
local e=e.bases[t]
self.buildingInfoMap[e.playerId]=e
end
end
if e.ships then
for t=1,#e.ships do
local e=e.ships[t]
self.airshipInfoMap[e.targetTaskId]=e
end
end
if e.tasks then
for t=1,#e.tasks do
local e=e.tasks[t]
self.myTaskInfoMap[e.taskId]=e
end
end
if e.otherTasks then
for t=1,#e.otherTasks do
local e=e.otherTasks[t]
self.otherTaskInfoMap[e.taskId]=e
end
end
end
EventSystem.SendEvent(CommonEventId.OnRespGuildRadarInfo)
end
function e:OnReqGuildRadarTransfer(e)
if t~=nil then
return t:TestOnReqGuildRadarTransfer(e)
else
return NetManager.Send(ProtoId.PRT_GUILD_RADAR_TRANSFER_REQ,{posId=e})
end
end
function e:OnRespGuildRadarTransfer(e)
if e~=nil then
local t=e.base
self.nextTransferTime=e.nextTransferTime
self.buildingInfoMap[t.playerId]=t
self.myTaskInfoMap={}
if e.tasks then
for t=1,#e.tasks do
local e=e.tasks[t]
self.myTaskInfoMap[e.taskId]=e
end
end
end
EventSystem.SendEvent(CommonEventId.OnRespGuildRadarTransfer)
end
function e:OnGuildRadarTransferNotify(e)
local t=nil
if e~=nil then
local e=e.base
t=e.playerId
self.buildingInfoMap[e.playerId]=e
end
EventSystem.SendEvent(CommonEventId.OnGuildRadarTransferNotify,t)
end
function e:OnGuildRadarPlayerQuitNotify(e)
local t=nil
if e~=nil then
self.buildingInfoMap[e.playerId]=nil
t=e.playerId
end
EventSystem.SendEvent(CommonEventId.OnGuildRadarPlayerQuitNotify,t)
end
function e:OnReqGuildRadarDispatchShip(e,a,o)
if t~=nil then
return t:TestOnReqGuildRadarDispatchShip(e,a)
else
return NetManager.Send(ProtoId.PRT_GUILD_RADAR_DISPATCH_SHIP_REQ,{
taskId=e,
positions=a,
summonPetFormation=o,
})
end
end
function e:OnRespGuildRadarDispatchShip(e)
if e~=nil then
local t=e.ship
if t then
self.airshipInfoMap[t.targetTaskId]=t
end
local t=e.task
if t then
self.myTaskInfoMap[t.taskId]=t
end
local e=e.beforeInfo
if e~=nil then
end
end
EventSystem.SendEvent(CommonEventId.OnRespGuildRadarDispatchShip,e)
end
function e:OnReqGuildRadarDispatchFinish()
if t~=nil then
return t:TestOnReqGuildRadarDispatchFinish()
else
return NetManager.Send(ProtoId.PRT_GUILD_RADAR_DISPATCH_FINISH_REQ)
end
end
function e:OnRespGuildRadarDispatchFinish(e)
if e~=nil then
local e=e.taskIds
if e then
for t=1,#e do
local e=e[t]
local e=self.myTaskInfoMap[e]
if e then
e.status=1
end
end
end
end
EventSystem.SendEvent(CommonEventId.OnRespGuildRadarDispatchFinish,e.taskIds)
end
function e:OnReqGuildRadarAllExistAirship()
if t~=nil then
return t:TestOnReqGuildRadarAllExistAirship()
else
return NetManager.Send(ProtoId.PRT_GUILD_RADAR_ALL_EXIST_AIRSHIP_REQ)
end
end
function e:OnRespGuildRadarAllExistAirship(e)
if e~=nil then
local t=e.taskIds
if t then
local e={}
for a,o in pairs(self.airshipInfoMap)do
if table.find(t,a)==false then
table.insert(e,a)
end
end
for t=1,#e do
local e=e[t]
self.airshipInfoMap[e]=nil
end
end
end
EventSystem.SendEvent(CommonEventId.OnRespGuildRadarAllExistAirship)
end
function e:OnReqGuildRadarGetTaskReward(e)
if t~=nil then
return t:TestOnReqGuildRadarGetTaskReward(e)
else
return NetManager.Send(ProtoId.PRT_GUILD_RADAR_GET_TASK_REWARD_REQ,{taskId=e})
end
end
function e:OnRespGuildRadarGetTaskReward(e)
local a=false
local t=0
if e~=nil then
t=self.curLevel
self.curExp=e.curExp
self.curLevel=e.curLevel
a=self.curLevel>t
self.myTaskInfoMap={}
if e.tasks then
for t=1,#e.tasks do
local e=e.tasks[t]
self.myTaskInfoMap[e.taskId]=e
end
end
end
EventSystem.SendEvent(CommonEventId.OnRespGuildRadarGetTaskReward,a,e,t,self.curLevel)
end
function e:OnSyncGuildRadarOtherTaskComplete(e)
EventSystem.SendEvent(CommonEventId.OnSyncGuildRadarOtherTaskComplete,{logData=e.tipLog})
end
function e:EnterTeamArrayView(t)
local o=t.taskId
local i=t.taskDid
local a,h=e:GetSelfBuildingMapPos()
local s=e:GetTerritoryMapCfgByDid(t.posId).pos
local s=e:GetAirShipTime({a,h},s)
local a=self:GetRadarMissionCfgByDid(i)
if a.battleType==1 then
local i=self:GetRadarMonsterCfgByDid(a.id)
local a={
formationNO=PROTO_ENUM.FormationNO.FN_GUILDRADAR,
isUsed=true,
positions={}
}
for e=1,6 do
local t=i.monsterList[e]
local o=n.GetEntity(t)
if o then
a.positions[e]={
formationId=0,
position=e,
heroId=0,
heroDid=t
}
end
end
DynamicModuleRes.EmbattlePrevDownLoad(true,a,nil,nil,function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTerritory_TeamBattle,{
isNpc=true,
enemyFormaData=a,
onStartBattle=function(a)
local e=e:OnReqGuildRadarDispatchShip(o,a.positions,a.summonPetFormation)
e.onCompleted=function(o,e)
self.recordFoucsTaskId=t.taskId
self:OnEnterBattle(e,i,a.positions)
end
end
})
end)
else
local e={
taskUseTime=s,
onStartBattle=function(t)
local e=e:OnReqGuildRadarDispatchShip(o,t.positions)
e.onCompleted=function(e,e)
GameTools.CloseUIForm(UIFormId.UI_GuildTerritory_TeamDispatch)
end
end
}
DynamicModuleRes.EmbattlePrevDownLoad(false,nil,nil,nil,function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTerritory_TeamDispatch,e)
end)
end
end
function e:OnEnterBattle(e,t,a)
if e.notTrueBattle==false then
if not e.beforeInfo then
self.recordFoucsTaskId=nil
GameEntry.LogError("战斗数据为null,检查回包")
return
end
self.curFightInfo=e
local a=DynamicModuleRes.GetFightHeroDids(e.beforeInfo)
a[8]={self:GetBattleMapPrefabID()}
DynamicModuleRes.CheckResAndDownload(
a,
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonLoading,{style=LoadingStyle.Cloud,loadResFinish=function()
ViewMgr:clostEnableLayerView({UIFormId.UI_CommonLoading})
GameTools.CloseUIForm(UIFormId.UI_GuildTerritory_TeamBattle)
ModulesInit.ProcedureNormalBattle.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
local o=t.headIcon
local a=0
for e=1,#t.monsterList do
if t.monsterList[e]~=0 then
a=t.monsterList[e]
break
end
end
local t=n.GetEntity(a)
local t=GameTools.GetLocalize(t.monName,LanguageCategory.LangBattle)
ModulesInit.ProcedureNormalBattle.SetRightInfo(nil,o,t,0)
ModulesInit.ProcedureNormalBattle.MapPrefabId=self:GetBattleMapPrefabID()
ModulesInit.ProcedureNormalBattle.IsBattleTest=false
ModulesInit.ProcedureNormalBattle.BattleType=BattleType.GuildRadar
ModulesInit.ProcedureNormalBattle.curProcedureBattle=ModulesInit.ProcedureNormalBattle:DefaultBattle()
ModulesInit.ProcedureNormalBattle.FightPlayData=e.beforeInfo
ModulesInit.ProcedureNormalBattle.IsFightPlay=false
ModulesInit.ProcedureNormalBattle.openLoading=false
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.NormalBattle)
end})
end
)
else
GameTools.CloseUIForm(UIFormId.UI_GuildTerritory_TeamBattle)
local i=0
local o=0
if a then
for e=1,#a do
local t=a[e]
local e=t.heroId
if e>0 then
local e=HeroMgr:GetHeroDataByHeroId(t.heroId)
if e then
if o<=0 or i<e.fight then
i=e.fight
o=t.heroDid
end
end
end
end
end
local e={notTrueBattle=true,mvpHeroDid=o,taskId=e.taskId}
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTerritory_Victory,e)
end
end
function e:GetBattleMapPrefabID()
return d.GetEntity(BattleType.GuildRadar).prefabId
end
function e:GetTmpHerosList()
local t=HeroMgr:GetActiviedHeroData()
local e={}
for a,t in pairs(t)do
if not self:IsUpHero(t.heroId)then
table.insert(e,t)
end
end
return e
end
function e:IsUpHero(t)
for a,e in pairs(self.airshipInfoMap)do
for a,e in pairs(e.heroIds)do
if e==t then
return true
end
end
end
return false
end
function e:GoBack()
if GameEntry.UI:IsExists(UIFormId.UI_NormalBattleSkipView)then
GameTools.CloseUIForm(UIFormId.UI_NormalBattleSkipView)
end
GameEntry.UI:OpenUIForm(
UIFormId.UI_CommonLoading,
{
style=LoadingStyle.Cloud,
loadResFinish=function()
self.isOpenGuildTerritory=true
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
end
})
end
function e:BattleBackGuildTerritoryView()
JumpMgr.OnGameJumpUIMain()
if self.isOpenGuildTerritory then
EventSystem.SendEvent(CommonEventId.PlayLoadingCloudAni)
end
self.isOpenGuildTerritory=false
self:EnterGuildTerritoryMainView(nil,self.isReturnGuildMainView,{initFoucsTaskId=self.recordFoucsTaskId})
self.recordFoucsTaskId=nil
end
return e 
