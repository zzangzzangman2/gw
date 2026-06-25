local h=require("DataNode/DataManager/DataMgr/DataUtil")
local a={
}
local e=a
local i=""
local n=1
local o=1
function a.SendPlaybackRequestWithFight(e)
return NetManager.Send(ProtoId.PRT_FIGHT_PLAYBACK_REQ,{recordId=e})
end
function a.SetPlayerInfo(a,e,t)
i=a
n=e
o=t
end
function a.OnFightPlayback(e)
if GameEntry.UI:IsExists(UIFormId.UI_ChapterAndLevelViewOfK)then
GameTools.CloseUIForm(UIFormId.UI_ChapterAndLevelViewOfK)
end
if GameEntry.UI:IsExists(UIFormId.UI_EliteAdventure)then
GameTools.CloseUIForm(UIFormId.UI_EliteAdventure)
end
ModulesInit.ExpeditionManager:LeaveBigMap()
ModulesInit.ExpeditionManager:SetPlayback()
TowerMgr:setIsPlayBack(true)
GameTools.CloseUIForm(UIFormId.UI_Embattle)
GameTools.CloseUIForm(UIFormId.UI_BattleRecord)
local t=e.fightInfo.battleType
local s=e.fightInfo.mapId
if t==BattleType.trial then
local e=h:GetTowerRow(e.fightInfo.mapId)
if e then
ModulesInit.ProcedureNormalBattle.SetLeftInfo(n,nil,i,o)
ModulesInit.ProcedureNormalBattle.SetRightInfo(nil,e.Icon,GameTools.GetLocalize(e.mosterName,LanguageCategory.LangBattle),e.level)
end
elseif t==BattleType.campaign or t==BattleType.elite then
ModulesInit.ProcedureNormalBattle.SetLeftInfo(n,nil,i,o)
end
local a=DynamicModuleRes.GetFightHeroDids(e.fightInfo,t)
if t==PROTO_ENUM.ENUM_FIGHT_TYPE.PVE_TOWER_FIGHT then
local e=h:GetTowerRow(s)
a[8]={e.battlePrefabId}
elseif t==PROTO_ENUM.ENUM_FIGHT_TYPE.PVE_MAP_FIGHT then
local e=require("DataNode/DataTable/Create/maps/DTMapsDBModel")
local e=e.GetEntity(s)
a[8]={e.prefabId}
end
DynamicModuleRes.CheckResAndDownload(
a,
function()
ModulesInit.ProcedureNormalBattle.IsBattleTest=false
ModulesInit.ProcedureNormalBattle.BattleType=e.fightInfo.battleType
ModulesInit.ProcedureNormalBattle.MapId=e.fightInfo.mapId
ModulesInit.ProcedureNormalBattle.curProcedureBattle=ModulesInit.ProcedureNormalBattle:DefaultBattle()
ModulesInit.ProcedureNormalBattle.FightPlayStar=e.star
ModulesInit.ProcedureNormalBattle.FightPlayData=e.fightInfo
ModulesInit.ProcedureNormalBattle.IsFightPlay=true
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.NormalBattle)
end
,e.fightInfo.battleType)
end
return a 
