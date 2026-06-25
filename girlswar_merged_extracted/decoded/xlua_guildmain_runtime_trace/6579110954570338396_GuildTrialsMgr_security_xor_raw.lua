local h=require('DataNode/DataTable/Create/activity/DTPrimeSpecPrivilegeDBModel')
local u=require("DataNode/DataTable/Create/guild/DTGuildTrialsBaseDBModel")
local l=require("DataNode/DataTable/Create/guild/DTGuildTrialsDBModel")
local s=require("DataNode/DataTable/Create/guild/DTGuildTrialsMapsDBModel")
local i=require("DataNode/DataTable/Create/guild/DTGuildTrialsAwardDBModel")
local n=require("DataNode/DataTable/Create/monster/DTMonsterDBModel")
local d=require('DataNode/DataTable/Create/model/DTmodelDBModel')
local r=require("DataNode/DataTable/Create/constant/DTBattleDBModel")
local e={
}
e.EMapBoxTabType={
chapter=1,
map=2,
}
function e:Init()
ModulesInit.GuildTrialsMgr:Reset()
end
function e:Dispose()
end
function e:Reset()
self.chapterDid=0;
self.stage=0;
self.fightCount=0;
self.fightTotalCount=0;
self.maxChapterLv=0;
self.nextResetTime=0;
self.nextFightRecoverTime=0;
self.receiveChapterAwardLvs={};
self.receiveChapterAwardLvMaps={}
self.maps={};
self.mapTabs={};
self.effectEventDids={};
self.effectEventDidMaps={};
self.yesterdayChapterDid=0
self.yesterdayPass=false
self.yesterdayStage=0
self.mapBoxes={};
self.mapBoxeMaps={}
self.mapBoxeRedMaps={}
self.mLastReqTimeStamp=0
self.isOpenGuildTrials=false
self.GuildTrialsTipStatus=false
self.guildTrialsLv=0
self.guildTrialsMapId=0
self.guildTrialsMapDid=0
end
function e:GetGuildTrialsTipsStatus()
return self.GuildTrialsTipStatus
end
function e:SetGuildTrialsTipsStatus(e)
self.GuildTrialsTipStatus=e
end
function e:ReqGuildTrialsInfo()
if not GameFunction.IsFunctionUnLock(GameFunctionType.GuildTrials,false)then
return{}
end
if Time.realtimeSinceStartup-self.mLastReqTimeStamp<0.1 then
return{}
end
self.mLastReqTimeStamp=Time.realtimeSinceStartup
if ModulesInit.GuideMgr.isGuide then
return NetManager.Send(ProtoId.PRT_GUILD_TRIAL_INFO_REQ,{guide=true})
else
return NetManager.Send(ProtoId.PRT_GUILD_TRIAL_INFO_REQ)
end
end
function e:syncGuildTrialsInfoData(e)
if e.chapterDid~=nil then
self.chapterDid=e.chapterDid
end
if e.stage~=nil then
self.stage=e.stage
end
if e.fightCount~=nil then
self.fightCount=e.fightCount
end
if e.fightTotalCount~=nil then
self.fightTotalCount=e.fightTotalCount
end
if e.maxChapterLv~=nil then
self.maxChapterLv=e.maxChapterLv
end
if e.nextResetTime~=nil then
self.nextResetTime=e.nextResetTime
end
if e.nextFightRecoverTime~=nil then
self.nextFightRecoverTime=e.nextFightRecoverTime
end
if e.receiveChapterAwardLvs~=nil then
self.receiveChapterAwardLvs=e.receiveChapterAwardLvs
self.receiveChapterAwardLvMaps={}
for t,e in ipairs(self.receiveChapterAwardLvs)do
self.receiveChapterAwardLvMaps[e]=e
end
end
if e.maps~=nil then
self.maps=e.maps
self.mapTabs={}
for t,e in ipairs(self.maps)do
self.mapTabs[e.mapDid]=e
end
end
if e.effectEventDids~=nil then
self.effectEventDids=e.effectEventDids
self.effectEventDidMaps={}
for t,e in ipairs(self.effectEventDids)do
self.effectEventDidMaps[e]=e
end
end
if e.yesterdayChapterDid~=nil then
self.yesterdayChapterDid=e.yesterdayChapterDid
end
if e.yesterdayPass~=nil then
self.yesterdayPass=e.yesterdayPass
end
if e.yesterdayStage~=nil then
self.yesterdayStage=e.yesterdayStage
end
EventSystem.SendEvent(CommonEventId.OnRespGuildTrialsInfo)
end
function e:reqGuildTrialsMapBox()
return NetManager.Send(ProtoId.PRT_GUILD_TRIAL_MAP_BOX_REQ)
end
function e:syncGuildTrialsMapBoxData(t)
if t.mapBoxes~=nil then
self.mapBoxes=t.mapBoxes
self.mapBoxeMaps={}
self.mapBoxeRedMaps={}
for a,t in ipairs(self.mapBoxes)do
e:handleGuildTrialsSingleMapBoxDataByMapBox(t)
end
EventSystem.SendEvent(CommonEventId.OnRespGuildTrialsMapBox)
end
end
function e:reqGuildTrialsSingleMapBox(e)
local e={
mapId=e,
}
return NetManager.Send(ProtoId.PRT_GUILD_TRIAL_MAP_BOX_ONE_REQ,e)
end
function e:syncGuildTrialsSingleMapBoxData(t)
local t=t.mapBox
e:handleGuildTrialsSingleMapBoxDataByMapBox(t)
EventSystem.SendEvent(CommonEventId.OnRespGuildTrialsSingleMapBox,t)
end
function e:handleGuildTrialsSingleMapBoxDataByMapBox(e)
self.mapBoxeMaps[e.mapDid]=e
if e.endTime<=TimeUtil.GetServerTimeStamp()then
self.mapBoxeRedMaps[e.mapDid]=false
else
self.mapBoxeRedMaps[e.mapDid]=true
local t=e.boxes
for a=1,#t do
if t[a].playerId==PlayerMgr.PlayerInfo.uid then
self.mapBoxeRedMaps[e.mapDid]=false
break
end
end
end
end
function e:reqGuildTrialsMapBoxAward(e,t)
return NetManager.Send(ProtoId.PRT_GUILD_TRIAL_MAP_BOX_AWARD_REQ,{mapId=e,boxIdx=t})
end
function e:syncGuildTrialsMapBoxAwardData(e)
if e.mapId~=nil and e.boxInfo~=nil then
local t=nil
for o,a in pairs(self.mapBoxeMaps)do
if a.mapId==e.mapId then
t=a
local t=a.boxes
for a=1,#t do
if t[a].boxIdx==e.boxInfo.boxIdx then
t[a]=e.boxInfo
break
end
end
break
end
end
if t then
for o,a in ipairs(self.mapBoxes)do
if a.mapId==e.mapId then
a.boxes=t.boxes
break
end
end
self.mapBoxeRedMaps[t.mapDid]=false
EventSystem.SendEvent(CommonEventId.OnRespGuildTrialsMapBoxAward,e)
end
end
end
function e:reqGuildTrialsFightRecord()
return NetManager.Send(ProtoId.PRT_GUILD_TRIAL_FIGHT_RECORD_REQ)
end
function e:syncGuildTrialsFightRecordData(e)
end
function e:reqGuildTrialsHelpList()
return NetManager.Send(ProtoId.PRT_GUILD_TRIAL_HELP_LIST_REQ)
end
function e:syncGuildTrialsHelpListData(e)
self.helpInfo=e
EventSystem.SendEvent(CommonEventId.OnRespGuildTrialsHelpList,e)
end
function e:reqGuildTrialsSendHelp(e)
return NetManager.Send(ProtoId.PRT_GUILD_TRIAL_HELP_REQ,{playerId=e})
end
function e:syncGuildTrialsSendHelpData(e)
if e and self.helpInfo then
local t=self.helpInfo.helpList or{}
for o,a in ipairs(t)do
if a.playerId==e.help.playerId then
t[o]=e.help
break
end
end
end
EventSystem.SendEvent(CommonEventId.OnRespGuildTrialsSendHelp,e)
end
function e:reqGuildTrialsHelpRecord()
return NetManager.Send(ProtoId.PRT_GUILD_TRIAL_HELP_RECORD_REQ)
end
function e:syncGuildTrialsHelpRecordData(e)
end
function e:reqGuildTrialsPlayerRank()
return NetManager.Send(ProtoId.PRT_GUILD_TRIAL_PLAYER_RANK_REQ)
end
function e:syncGuildTrialsPlayerRankData(e)
if e.rankList~=nil then
end
if e.selfRank~=nil then
end
end
function e:reqGuildTrialsGuildRank()
return NetManager.Send(ProtoId.PRT_GUILD_TRIAL_GUILD_RANK_REQ)
end
function e:syncGuildTrialsGuildRankData(e)
if e.rankList~=nil then
end
if e.selfRank~=nil then
end
end
function e:reqGuildTrialsPassAward(e)
return NetManager.Send(ProtoId.PRT_GUILD_TRIAL_PASS_AWARD_REQ,{chapterLv=e})
end
function e:syncGuildTrialsPassAwardData(e)
if e.receiveChapterAwardLvs~=nil then
self.receiveChapterAwardLvs=e.receiveChapterAwardLvs
self.receiveChapterAwardLvMaps={}
for t,e in ipairs(self.receiveChapterAwardLvs)do
self.receiveChapterAwardLvMaps[e]=e
end
end
EventSystem.SendEvent(CommonEventId.OnRespGuildTrialsPassAward)
end
function e:reqGuildTrialsFastFight(e,t)
return NetManager.Send(ProtoId.PRT_GUILD_TRIAL_FAST_FIGHT_REQ,{mapId=e,Lv=t,count=1})
end
function e:syncGuildTrialsFastFightData(e)
if e.mapId~=nil then
end
if e.score~=nil then
end
EventSystem.SendEvent(CommonEventId.OnRespGuildTrialsFastFightData,e)
end
function e:hasMapBoxAwardByMapId(e)
if self.mapBoxeRedMaps[e]==true then
return true
end
return false
end
function e:SetHasMapBoxAwardByMapId(e,t)
self.mapBoxeRedMaps[e]=t
end
function e:getMapBoxServerData(e)
if self.mapBoxeMaps[e]then
return self.mapBoxeMaps[e]
end
return nil
end
function e:getMapBoxServerDataById(t)
for a,e in pairs(self.mapBoxeMaps)do
if e.mapId==t then
return e
end
end
return nil
end
function e:getAllMapBoxServerData()
return self.mapBoxeMaps
end
function e:getGuildTrialsBaseCfg()
return u.GetEntity(1)
end
function e:getGuildTrialsById(e)
return l.GetEntity(e)
end
function e:getGuildTrialsMapsById(e)
return s.GetEntity(e)
end
function e:getGuildTrialsAwardById(e)
return i.GetEntity(e)
end
function e:getGuildTrialsAwardList()
local o={}
local t=i.GetList()
for t,a in pairs(t)do
local t=4
if e.receiveChapterAwardLvMaps[a.id]then
t=3
elseif e.maxChapterLv>=a.id then
t=1
else
t=2
end
local e={
sortId=t,
cfg=a
}
table.insert(o,e)
end
table.sort(o,function(t,e)
if t.sortId==e.sortId then
return t.cfg.id<e.cfg.id
end
return t.sortId<e.sortId
end)
return o
end
function e:GetGuildTrialsNum()
local e=self.fightTotalCount-self.fightCount
return e
end
function e:GetGuildTrialsShowFightNum()
local e=e:getGuildTrialsBaseCfg().challengeNum
local t=0
local a=ModulesInit.MonthCardNewManager:IsActiveSmallCard()or ModulesInit.MonthCardNewManager:IsActiveFreeCard()
if a then
local e=h.GetEntity(1)
t=e.guildTrialFightCount
end
e=e+t
return e
end
function e:GetGuildTrialsMonsCfg(e)
local e=n.GetEntity(e)
return e
end
function e:GetGuildTrialsMonsModelCfg(e)
local e=n.GetEntity(e)
local e=d.GetEntity(e.modelID)
return e
end
function e:getTrialEventsDescTab(t)
local e=e:getGuildTrialsById(t)
local t=string.split(e.trialEventsDesc,":")
local e=e.trialEvents
return t,e
end
function e:GetGuildTrialsBoxData(t)
local a={}
a,t=e:GetGuildTrialsBoxDataByChapterAndStage(e.yesterdayChapterDid,e.yesterdayStage,1,a,t)
a,t=e:GetGuildTrialsBoxDataByChapterAndStage(e.chapterDid,e.stage,2,a,t)
return a,t
end
function e:GetGuildTrialsBoxDataByChapterAndStage(t,o,n,i,a)
local o=e:GetGuildTrialsLevelData(t,o)
if o and#o>0 then
table.insert(i,{tabType=e.EMapBoxTabType.chapter,day=n,chapterDid=t})
a[t]=a[t]or false
if a[t]==false then
for a=1,#o do
table.insert(i,{tabType=e.EMapBoxTabType.map,day=n,chapterDid=t,index=a,mapDid=o[a]})
end
end
end
return i,a
end
function e:GetGuildTrialsLevelData(t,a)
local e=e:getGuildTrialsById(t)
local t={}
if e then
if a>=1 then
for a=1,#e.stageOne do
table.insert(t,e.stageOne[a])
end
end
if a>=2 then
for a=1,#e.stageTwo do
table.insert(t,e.stageTwo[a])
end
end
end
return t
end
function e:ReqGuildTrialsFightBefore(e,t,o)
local a=false
if ModulesInit.GuideMgr.isGuide then
a=true
end
local a={
mapId=e,
Lv=t,
guide=a,
}
local a=NetManager.Send(ProtoId.PRT_GUILD_TRIAL_FIGHT_BEFORE_REQ,a)
if a then
a.onCompleted=function(i,a)
ModulesInit.GuildTrialsMgr:EnterBattle(a,e,o,t)
end
end
end
function e:EnterBattle(i,o,t,a)
e.guildTrialsMapId=o
e.guildTrialsMapDid=t
e.guildTrialsLv=a
local o=i.beforeInfo
local i=""
local h=1
local e=s.GetEntity(t)
local t=0
if a==1 then
t=e.monsterLists1[e.heroIdx]
elseif a==2 then
t=e.monsterLists1[e.heroIdx]
elseif a==3 then
t=e.monsterLists1[e.heroIdx]
end
if t~=0 then
local e=n.GetEntity(t)
local t=0
if e then
i=GameTools.GetLocalize(e.monName,LanguageCategory.LangBattle)or""
t=e.modelID
local e=UIUtil.GetPlayerHead(t)
if e then
h=e.id
end
end
end
local e=ModulesInit.GuildTrialsMgr:GetGuildMapPrefabID()
DynamicModuleRes.BattlePrevDownLoadByBattleInfo(e,o,function()
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonLoading,{style=LoadingStyle.Cloud,loadResFinish=function()
ViewMgr:clostEnableLayerView({UIFormId.UI_CommonLoading})
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_MonsDesc_View)
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_Main_View)
ModulesInit.ProcedureNormalBattle.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
ModulesInit.ProcedureNormalBattle.SetRightInfo(h,nil,i,0)
ModulesInit.ProcedureNormalBattle.MapPrefabId=e
ModulesInit.ProcedureNormalBattle.IsBattleTest=false
ModulesInit.ProcedureNormalBattle.IsAutoMode=false
ModulesInit.ProcedureNormalBattle.MapId=o.MapId
ModulesInit.ProcedureNormalBattle.BattleType=BattleType.guildTrials
ModulesInit.ProcedureNormalBattle.curProcedureBattle=ModulesInit.ProcedureNormalBattle:DefaultBattle()
ModulesInit.ProcedureNormalBattle.FightBeforeData=o
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.NormalBattle)
end})
end)
end
function e:ClearBattleData()
end
function e:ReqGuildTrialsFight()
local t=false
if ModulesInit.GuideMgr.isGuide then
t=true
end
local a=FightDataReportMgr:GetBattleInfo()
return NetManager.Send(ProtoId.PRT_GUILD_TRIAL_FIGHT_REQ,{battleInfo=a,mapId=e.guildTrialsMapId,Lv=e.guildTrialsLv,guide=t})
end
function e:syncGuildTrialsFight(e)
if e.invalid==true then
EventSystem.SendEvent(CommonEventId.OnSkipGuide2)
ModulesInit.GuildTrialsMgr:GoBack()
return
end
local t=ModulesInit.ExpeditionManager.FightClearInfo
if e.killMonsterCount>0 then
local a={}
if e.award and e.award.rewardThings then
local e=e.award.rewardThings
for t=1,#e do
local o=e[t].thingDid
local e=e[t].thingCount
local e={o,e}
table.insert(a,e)
end
end
t.drops=a
t.score=e.score
t.killMonsterCount=e.killMonsterCount
t.totalMonsterCount=e.totalMonsterCount
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTrials_BattleSuc_View,t)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,t)
end
end
function e:GetGuildMapPrefabID()
return r.GetEntity(BattleType.guildTrials).prefabId
end
function e:EnterView()
if e:CheckEnterCondition(true)then
e:ReqAndEnterView()
return true
end
return false
end
function e:CheckEnterCondition(e)
if GameFunction.IsFunctionUnLock(GameFunctionType.GuildTrials,e)==false then
return false
end
if PlayerMgr.PlayerInfo.guildId<=0 then
UIUtil.ShowCommonTips(GameTools.GetLocalize("guildTrials_desc_42",LanguageCategory.LangCommon))
return false
end
return true
end
function e:ReqAndEnterView()
local e=ModulesInit.GuildTrialsMgr:ReqGuildTrialsInfo()
e.onCompleted=function(e,e)
EventSystem.SendEvent(CommonEventId.OnEventNextGuide,{event="ON_CLICK_GUILDSHILIAN"})
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTrials_Main_View)
end
end
function e:GoBack()
if GameEntry.UI:IsExists(UIFormId.UI_NormalBattleSkipView)then
GameTools.CloseUIForm(UIFormId.UI_NormalBattleSkipView)
end
e.isForm=true
GameEntry.CameraCtrl:ResetMainCameraPos()
GameEntry.UI:OpenUIForm(
UIFormId.UI_CommonLoading,
{
style=LoadingStyle.Cloud,
loadResFinish=function()
GameEntry.CameraCtrl:ResetMainCameraPos()
ModulesInit.GuildTrialsMgr.isOpenGuildTrials=true
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
end
})
end
function e:BattleBackGuildTrialsView()
ModulesInit.GuildTrialsMgr.isOpenGuildTrials=false
if e:CheckEnterCondition(true)then
JumpMgr.OnGameJumpUIGuild({forbidViewList={UIFormId.UI_CommonLoading}})
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTrials_Main_View,{reqInfo=true})
else
EventSystem.SendEvent(CommonEventId.OnSkipGuide2)
JumpMgr.OnGameJumpUIMain({forbidViewList={UIFormId.UI_CommonLoading}})
EventSystem.SendEvent(CommonEventId.PlayLoadingCloudAni)
end
end
function e:CheckNewAwardReset()
local t=math.ceil(TimeUtil.serverTimeStep)
local e=e:getGuildTrialsBaseCfg().newAwardReset
local e=TimeUtil.String2ToTimeStamp(e)
if t>=e then
return true
end
return false
end
return e 
