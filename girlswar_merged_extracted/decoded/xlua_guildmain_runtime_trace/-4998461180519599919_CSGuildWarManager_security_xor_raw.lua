local n=require("DataNode/DataTable/Create/guildBattle/DTGuildBattleDBModel")
local o=require("Modules/CSGuildWar/GuildWarBattleController")
local a=require('DataNode/DataTable/Create/constant/DTBattleDBModel')
local s=table.add
local e={
AttrTime=1,
Score=2
}
local i=0
local e={
QUEST_NOT_ACTIVE=0,
QUEST_ACTIVE=1,
QUEST_AWARDED=2
}
local e={
GuildWarDBCfg=nil,
GuildWarStatusInfo=nil,
CurReqActivePlauerInfo=nil,
CurReqBattleGroundInfo=nil,
CurReqRankInfos=nil,
CurReqTaskAwardInfo=nil,
CurReqPlayerRecord=nil,
CurReqBattleRecord=nil,
CurFightInfo=nil,
Playback=nil,
isMapForm=false
}
local t={
CommonEventId.OnEventNetReconnectSuccess,
CommonEventId.OnEventRespError,
}
function e:Init()
for e=1,#t do
EventSystem.AddListener(t[e],handler(t[e],function(t,e)
ModulesInit.CSGuildWarManager:OnEventHandler(t,e)
end))
end
end
function e:Dispose()
for e=1,#t do
EventSystem.RemoveListener(t[e],handler(t[e],function(e,t)
ModulesInit.CSGuildWarManager:OnEventHandler(e,t)
end))
end
end
function e:OnEventHandler(e,t)
if e==CommonEventId.OnEventNetReconnectSuccess then
if(GameEntry.Procedure.CurrProcedureState==CS.YouYou.ProcedureState.NormalBattle
and ModulesInit.ProcedureNormalBattle.BattleType==BattleType.unionCraft)and
GameEntry.UI:IsExists(UIFormId.UI_GuildWarWin)then
GameEntry.UI:CloseUIForm(UIFormId.UI_GuildWarWin)
self:EnterWarProcedure()
end
elseif e==CommonEventId.OnEventRespError then
if(GameEntry.Procedure.CurrProcedureState==CS.YouYou.ProcedureState.NormalBattle
and ModulesInit.ProcedureNormalBattle.BattleType==BattleType.unionCraft)
or GameEntry.UI:IsExists(UIFormId.UI_NormalBattleSkipView)
then
if GameEntry.UI:IsExists(UIFormId.UI_GuildWarWin)then
GameEntry.UI:CloseUIForm(UIFormId.UI_GuildWarWin)
end
self:EnterWarProcedure()
return
end
end
end
function e:GuildWarIsUnlock(e)
if PlayerMgr.PlayerInfo.guildId>0 then
return true
end
if not e then
UIUtil.ShowCommonTipsForLocalize('UI.Chat.Main.11')
end
return false
end
function e:GetBattleCtr()
return o
end
function e:GetMapPrefabID()
return a.GetEntity(BattleType.unionCraft).prefabId
end
function e:ToPlayback(o,t,e)
local a=self:GetMapPrefabID()
local a={[8]={a}}
DynamicModuleRes.CheckResAndDownload(a,function()
self.CurPlaybackParty1Info=t
self.CurPlaybackParty2Info=e
ModulesInit.ProcedureNormalBattle.SetLeftInfo(t.head,nil,t.name,t.level)
ModulesInit.ProcedureNormalBattle.SetRightInfo(e.head,nil,e.name,e.level)
ModulesInit.ProcedureNormalBattle.MapPrefabId=self:GetMapPrefabID()
ModulesInit.ProcedureNormalBattle.IsBattleTest=false
ModulesInit.ProcedureNormalBattle.BattleType=BattleType.unionCraft
ModulesInit.ProcedureNormalBattle.curProcedureBattle=ModulesInit.ProcedureNormalBattle:DefaultBattle()
ModulesInit.ProcedureNormalBattle.FightPlayData=o
ModulesInit.ProcedureNormalBattle.IsFightPlay=true
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.NormalBattle)
end)
end
function e:EnterBattle(e)
if not self.CurStartBattleResult then
GameEntry.LogError('战斗数据为null,检查回包')
return
end
local t=DynamicModuleRes.GetFightHeroDids(self.CurStartBattleResult.fightInfo.fight)
t[8]={self:GetMapPrefabID()}
DynamicModuleRes.CheckResAndDownload(t,function()
ModulesInit.ProcedureNormalBattle.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
local t=nil
if not e.headId then
t=e.headPath
end
ModulesInit.ProcedureNormalBattle.SetRightInfo(e.headId,t,e.name,e.level)
ModulesInit.ProcedureNormalBattle.MapPrefabId=self:GetMapPrefabID()
ModulesInit.ProcedureNormalBattle.IsBattleTest=false
ModulesInit.ProcedureNormalBattle.BattleType=BattleType.unionCraft
ModulesInit.ProcedureNormalBattle.curProcedureBattle=ModulesInit.ProcedureNormalBattle:DefaultBattle()
ModulesInit.ProcedureNormalBattle.FightPlayData=self.CurStartBattleResult.fightInfo.fight
ModulesInit.ProcedureNormalBattle.IsFightPlay=false
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.NormalBattle)
end)
end
function e:Enter()
if not ModulesInit.GuildMgr.guildInfo then
EventSystem.AddListener(CommonEventId.GuildInfoChange,self.RequestGuildInfoAndOpenGuildWarView,self)
ModulesInit.GuildMgr:ReqGuildEnter()
return
end
self:OpenMainView()
end
function e:RequestGuildInfoAndOpenGuildWarView()
self:OpenMainView()
EventSystem.RemoveListener(CommonEventId.GuildInfoChange,self.RequestGuildInfoAndOpenGuildWarView,self)
end
function e:OpenMainView()
local e=self:SendGuildWarStatusInfoRequest()
e.onCompleted=function()
if(not self:ActivityIsOpen()or self:GuildIsFirstTimeJoin())and self:GetGuildWarStage()==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.NOT_OPEN then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarNoOpenForFirst)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarMain)
end
end
end
function e:EnterNotRequest()
if(not self:ActivityIsOpen()or self:GuildIsFirstTimeJoin())and self:GetGuildWarStage()==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.NOT_OPEN then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarNoOpenForFirst)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarMain)
end
end
function e:EnterWarProcedure(e)
if self.CurReqBattleGroundInfo then
local e=self:SendEnterBattleGroundRequest(self.CurReqBattleGroundInfo.battleGroundId)
e.onCompleted=function()
if GameEntry.UI:IsExists(UIFormId.UI_GuildWarMain)then
GameTools.CloseUIForm(UIFormId.UI_GuildWarMain)
end
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.War)
end
end
end
function e:ExitWarProcedure()
self.isMapForm=true
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
end
function e:OpenMap()
local e=self:GetBattleCtr()
e:Init()
e:Start()
end
function e:CloseMap()
o:Close()
end
function e:GetGuildWarDBCfg()
if not self.GuildWarDBCfg then
self.GuildWarDBCfg=n.GetEntity(1)
end
return self.GuildWarDBCfg
end
function e:GetGuildWarStage()
return self.GuildWarStatusInfo.status
end
function e:GetGuildWarCountDown()
if TimeUtil.serverTimeStep<=self.GuildWarStatusInfo.statusOverTime then
return self.GuildWarStatusInfo.statusOverTime-TimeUtil.serverTimeStep
end
return 0
end
function e:ActivityIsOpen()
local e=self:GetGuildWarStage()
return e~=PROTO_ENUM.ENUM_GUILD_WAR_STATUS.NOT_OPEN
end
function e:GuildFirstTimeJoinAwardIsGeted()
return self.GuildWarStatusInfo.firstJoinAward
end
function e:GuildIsFirstTimeJoin()
return self.GuildWarStatusInfo.guildFirstJoin
end
function e:GuildIsCanJoin()
return self.GuildWarStatusInfo.curGuildStageJoin or false
end
function e:GuildIsCanJoinForNextSeason()
return self.GuildWarStatusInfo.nextGuildStageJoin or false
end
function e:SelfIsCanJoin()
return self.GuildWarStatusInfo.curSelfStageJoin
end
function e:GuildIsBye()
local e=self:GetGuildWarStage()
if e~=PROTO_ENUM.ENUM_GUILD_WAR_STATUS.NOT_OPEN and e~=PROTO_ENUM.ENUM_GUILD_WAR_STATUS.MATCHING then
if self.GuildWarStatusInfo.wheelSpace~=nil then
return self.GuildWarStatusInfo.wheelSpace
end
end
GameEntry.LogError("此阶段不能调用这个函数:GuildIsBye")
end
function e:GetIsTodayFirstEnter()
end
function e:GetCurSeasonRecord()
end
function e:GetRankListInfo()
return self.CurReqRankInfos
end
function e:TaskAwardIsCanGet()
for t,e in pairs(self.CurReqTaskAwardInfo.questList)do
if e.status==PROTO_ENUM.ENUM_GUILD_WAR_QUEST_STATUS.QUEST_ACTIVE then
return true
end
end
return false
end
function e:GetTaskAwardInfo(t)
for a,e in pairs(self.CurReqTaskAwardInfo.questList)do
if e.questDid==t then
return e
end
end
return nil
end
function e:GetPlayerInfo(a,t)
for a,e in pairs(a.ownerInfo.players)do
if e.playerId==t then
return e
end
end
for a,e in pairs(a.targetInfo.players)do
if e.playerId==t then
return e
end
end
return nil
end
function e:PlayerIsUnderAttack(e)
if TimeUtil.serverTimeStep-e.lastDefTime<i then
return true
end
return false
end
function e:PlayerIsResurrection(e)
if e.curHp==0 and e.rebornStampTime>TimeUtil.serverTimeStep then
return true
end
return false
end
function e:CompareBattleInfo(e,a)
local n={}
for t=1,#e.players do
local e=e.players[t]
local t=a.players[t]
local a=false
if#e.heros~=#t.heros then
a=true
else
for o=1,#e.heros do
local i=e.heros[o]
local e=t.heros[o]
if i.curHp~=e.curHp or i.heroDid~=e.heroDid then
a=true
break
end
end
end
if e.playerId==t.playerId then
if e.curHp~=t.curHp or
e.gainGrade~=t.gainGrade or
e.leftGrade~=t.leftGrade or
e.online~=t.online or
e.lastDefTime~=t.lastDefTime or
a then
s(n,t)
end
end
end
return n
end
function e.OnUpdate()
o:Update()
end
function e:SendGuildWarStatusInfoRequest()
self.reqWarStatusInfoTime=TimeUtil.GetServerTimeStamp()
return NetManager.Send(ProtoId.PRT_GUILD_WAR_STATUS_REQ)
end
function e:OnSendGuildWarInfoResponse(e)
self.GuildWarStatusInfo=e
end
function e:SendGuildWarNoFitstBoxInfoRequest()
return NetManager.Send(ProtoId.PRT_GUILD_WAR_BOX_REQ)
end
function e:OnGuildWarNoFirstBoxInfoResponse(e)
self.GuildWarStatusInfo.curScore=e.curScore
self.GuildWarStatusInfo.curMyScore=e.curMyScore
self.GuildWarStatusInfo.myBoxes=e.myBoxes
end
function e:SendGuildWarGetBoxRequest()
return NetManager.Send(ProtoId.PRT_GUILD_WAR_FIRST_JOIN_AWARD_REQ)
end
function e:OnGuildWarGetBoxResponse(e)
self.GuildWarStatusInfo.firstJoinAward=true
end
function e:SendGuildWarGetNoFitstBoxRequest()
return NetManager.Send(ProtoId.PRT_GUILD_WAR_BOX_AWARD_REQ)
end
function e:OnGuildWarGetNoFitstBoxResponse(e)
EventSystem.SendEvent(CommonEventId.GuildWarGetBoxAwardSucess)
end
function e:SendGuildActivePlayerRequest(e)
return NetManager.Send(ProtoId.PRT_GUILD_WAR_ACTIVE_PLAYER_REQ,{curSeason=e})
end
function e:OnGuildActivePlayerResponse(e)
self.CurReqActivePlauerInfo=e
end
function e:SendGuildWarBattleGroundInfoRequest(e)
return NetManager.Send(ProtoId.PRT_GUILD_WAR_BATTLE_GROUND_INFO_REQ,{battleGroundId=e})
end
function e:OnGuildWarBattleGroundInfoResponse(e)
self.CurReqBattleGroundInfo=e
end
function e:SendEnterBattleGroundRequest(e)
return NetManager.Send(ProtoId.PRT_GUILD_WAR_BATTLE_GROUND_ENTER_REQ,{battleGroundId=e})
end
function e:OnEnterBattleGroundResponse(e)
self.CurBattleInfo=e
EventSystem.SendEvent(CommonEventId.GuildWarBattleInfoSync)
end
function e:SendStartBattleRequest(o,t,e,a)
self:SaveEnemyInfo(a)
ModulesInit.FormationManager:IntegrationFormationData(t,e)
return NetManager.Send(
ProtoId.PRT_GUILD_WAR_FIGHT_REQ,
{
battleGroundId=o,
positions=t,
alterPositions=e,
targetPlayerId=a
}
)
end
function e:OnStartBattleResponse(e)
self.CurStartBattleResult=e
end
function e:SearchEnemyInfo(a)
if self.CurBattleInfo and self.CurBattleInfo.targetInfo and self.CurBattleInfo.targetInfo.players then
local e=self.CurBattleInfo.targetInfo.players
for t=1,#e do
if e[t].playerId==a then
return e[t]
end
end
end
end
function e:SaveEnemyInfo(e)
local e=self:SearchEnemyInfo(e)
self.lastEmemyInfo=table.deepCopy(e)
end
function e:GetLastBattleEnemyInfo()
return self.lastEmemyInfo
end
function e:SendSeePlayerRecordRequest(e,t)
return NetManager.Send(ProtoId.PRT_GUILD_WAR_PLAYER_BATTLE_RECORD_REQ,{battleGroundId=e,playerId=t})
end
function e:OnSeePlayerRecordResponse(e)
self.CurReqPlayerRecord=e
end
function e:SendSeeBattleRecordRequest(e)
return NetManager.Send(ProtoId.PRT_GUILD_WAR_BATTLE_RECORD_REQ,{battleGroundId=e,playerId=playerId})
end
function e:OnSeeBattleRecordResponse(e)
self.CurReqBattleRecord=e
end
function e:SendSeeBattleInfoRequest(e)
return NetManager.Send(ProtoId.PRT_GUILD_WAR_BATTLE_WATCH_REQ,{battleId=e})
end
function e:OnSeeBattleInfoResponse(e)
self.Playback=e
end
function e:SendPlayerQuestAwardRequest()
return NetManager.Send(ProtoId.PRT_GUILD_WAR_PLAYER_QUEST_REQ)
end
function e:OnPlayerQuestAwardResponse(e)
self.CurReqTaskAwardInfo=e
end
function e:SendGetQuestAwardRequest(e)
return NetManager.Send(ProtoId.PRT_GUILD_WAR_PLAYER_QUEST_AWARD_REQ,{questDid=e})
end
function e:OnGetQuestAwardResponse(e)
for e,t in pairs(e.quests)do
for e=1,#self.CurReqTaskAwardInfo.questList do
local a=self.CurReqTaskAwardInfo.questList[e]
if a.questDid==t.questDid then
self.CurReqTaskAwardInfo.questList[e]=t
end
end
end
EventSystem.SendEvent(CommonEventId.GuildWarGetTaskAwardSuccess)
end
function e:SendGuildWarRankInfoRequest(e)
return NetManager.Send(ProtoId.PRT_GUILD_WAR_GRADE_RANK_REQ,{battleGroundId=e})
end
function e:OnGuildWarRankInfoResponse(e)
self.CurReqRankInfos=e
end
function e:SendGuildWarBuffRecordRequest()
return NetManager.Send(ProtoId.PRT_GUILD_WAR_INSPIRE_RECORD_REQ)
end
function e:OnGuildWarBuffRecordResponse(e)
self.CurBuffRecordInfos=e
if not self.GuildWarStatusInfo.guildInspireCount then
self.GuildWarStatusInfo.guildInspireCount=0
end
self.GuildWarStatusInfo.guildInspireCount=#self.CurBuffRecordInfos.name
end
function e:SendGuildWarBuffRequest()
return NetManager.Send(ProtoId.PRT_GUILD_WAR_INSPIRE_REQ)
end
function e:OnGuildWarBuffResponse(e)
if not self.GuildWarStatusInfo.selfInspireCount then
self.GuildWarStatusInfo.selfInspireCount=0
end
self.GuildWarStatusInfo.selfInspireCount=self.GuildWarStatusInfo.selfInspireCount+1
if not self.GuildWarStatusInfo.guildInspireCount then
self.GuildWarStatusInfo.guildInspireCount=0
end
self.GuildWarStatusInfo.guildInspireCount=self.GuildWarStatusInfo.guildInspireCount+1
EventSystem.SendEvent(CommonEventId.GuildWarBuffSync)
end
function e:OnGuildWarStageSync(e)
if not self.GuildWarStatusInfo then
self.GuildWarStatusInfo={}
end
local e=function()
local e=self:SendGuildWarStatusInfoRequest()
e.onCompleted=function()
self:GetBattleCtr():OnGuildWarStageSync()
EventSystem.SendEvent(CommonEventId.GuildWarStageSync)
end
end
if self.reqWarStatusInfoTime and TimeUtil.GetServerTimeStamp()-self.reqWarStatusInfoTime<=0.5 then
self:StopReqWarStatusInfoSequence()
self.mGetWishesInfoSequence=CS.DG.Tweening.DOTween.Sequence()
self.mGetWishesInfoSequence:AppendInterval(0.5)
self.mGetWishesInfoSequence:AppendCallback(function()
self.mGetWishesInfoSequence=nil
e()
end)
else
e()
end
end
function e:StopReqWarStatusInfoSequence()
if self.mGetWishesInfoSequence then
self.mGetWishesInfoSequence:Kill()
self.mGetWishesInfoSequence=nil
end
end
return e

