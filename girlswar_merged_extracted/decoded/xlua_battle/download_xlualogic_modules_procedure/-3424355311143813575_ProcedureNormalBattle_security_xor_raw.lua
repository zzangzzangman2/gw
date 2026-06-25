local e=1
if(GameInit.IsClient)then
require"Modules/Battle/BattleSkillEffectManager"
end
require"Modules/Battle/BattleTeam"
require"Modules/Battle/HeroCtrl"
require"Modules/Battle/HeroBattleInfo"
require"Modules/Battle/HeroSkillInfo"
require"Modules/Battle/HeroBuffInfo"
require"Modules/Battle/HeroBuffValueInfo"
require"Modules/Battle/BattleEffectInfo"
local _=require("Modules/Battle/BattleDeadHero")
local x=require("Modules/Battle/BattleAttackTaskMgr")
local d=require("Modules/Battle/BattleUtil")
local z=require("Modules/Battle/BaseProcedureBattle")
local s=require("DataNode/DataManager/DataMgr/DataUtil")
local i=require("DataNode/DataTable/Create/constant/DTBattleDBModel")
local w=require("DataNode/DataTable/Create/maps/DTMapsDBModel")
local j=require('DataNode/DataTable/Create/activity/DTCarnivalMapDBModel')
local y=require("DataNode/DataTable/Create/skillAct/DTSkillActDBModel")
local k=require("Modules/Battle/BattleBgEffectMgr")
local q=require("Modules/Battle/Formula")
local v=nil
local f=nil
local p=false
local h
if(GameInit.IsClient)then
h=require("Common/cs_coroutine")
f=require("Modules/Battle/BattleResPreloadMgr")
else
h=require("Common/cs_coroutine_server")
end
local m=table.add
local e=string.split
local r,l=0,0
local c,u=0,0
local g={
DTSkillPasDBModel,
DTBuffDBModel,
DTUnderWearSuitDBModel,
DTTreasureSkillDBModel,
DTTreasureStrengDBModel,
}
local n=1
local b=2
local t={
}
local e=t
function t.ResetData()
e.timerList={}
e.IsFightPlay=false
e.FightPlayStar=0
e.FightPlayData=nil
e.FightPlay_CurrWave=nil
e.FightBeforeData=nil
e.FightBefore_CurrWave=nil
e.IsRandomSeedFromFightBefore=false
e.GameSpeed=1
e.GameFastSkill=false
e.GameFastSkillPlayFirstAnimMap={}
e.BattleType=nil
e.MapId=0
e.MapPrefabId=0
e.CurrDTMap=nil
e.CurrTowerRow=nil
e.CurrMazeMonGroupRow=nil
e.CurrGuildCrusadeBandit=nil
e.CurrBattleRow=nil
e.CurrMapsWaves=nil
e.CurrMapsWavesIndex=0
e.MaxMapsWave=1
e.HeroDic={}
e.OurTeam=nil
e.EnemyTeam=nil
e.DeadHeroMap={}
e.CurrAttackTeam=nil
e.OurTeamSetting=nil
e.EnemyTeamSetting=nil
e.ReadyTeamCount=0
e.OurTeamIsRuning=false
e.OurTeamFirstAttack=true
e.IsFirstBattleTeamReady=false
e.IsBattleTest=false
e.IsOurTeamAttack=false
e.CurrAttackHeroId=0
e.CurrBeAttackHeroIdTableDic={}
e.BattleCenterTransform=nil
e.OurCenterTransform=nil
e.EnemyCenterTransform=nil
e.EnemyCenterTransformPosX=0
e.EnemyCenterTransformPosY=0
e.EnemyCenterTransformPosZ=0
e.DynamicCenterHelper=nil
e.CameraCtrlOldPos=nil
e.CameraCtrlOriginalOrthographicSize=0
e.CameraCtrlCurrOrthographicSize=0
e.OnePixelRatio=0
e.TestBattleType=0
e.CurrIsAttacking=false
e.CurrSkillMinStopTime=0
e.CurrTimelineEffectAttackPointCount=0
e.CurrAttackCauseHeroDie=false
e.BattleRounding=false
e.Explosiveing=false
e.CurrSkillAttackType=0
e.MaxBattleBigRound=0
e.CurrBattleBigRound=0
e.CurrBattleSmallRound=0
e.mBattle1V1SmallStartRound=0
e.IsBattleBigAttacking=false
e.IsBattleSmallAttacking=false
e.IsBattlePetAttacking=false
e.DyingStateHeroLastTime=0
e.IsAutoMode=false
e.IsSkipBattle=false
e.NextRoundChangeToManual=false
e.SelectFireHero=nil
e.FireEffectTrans=nil
e.FireEffectFocusTrans=nil
e.ScenePrefabTrans=nil
e.ScrollSceneCtrl=nil
e.ScenePrefabVisible=false
e.CameraIsShake=false
e.curProcedureBattle=nil
e.battleHeroInitColor=nil
e.idleMonsterList={}
e.enemyLocking=false
e.IsFormBigMap=false
e.IsBattleRoundBeginAddBuffing=false
e.IsBattleRoundBeginAddAfterBuffing=false
e.openLoading=true
e.isBattleEnd=false
e.isAlreadyShowBattleEnd=false
e.IsBattleBeginEffect=false
e.relics={}
e.mazeAttribute={}
e.willTriggerRelicDids={}
e.dicePosition=0
e.mvpHeroDid=0
e.coroutine_WaitBeginBattle=nil
e.coroutine_BattleRoundBeginAddBuff=nil
e.coroutine_BattleRoundBeginAddAfterBuff=nil
e.coroutine_BattleAllBigRoundBegin=nil
e.coroutine_BattleSmallRoundBegin=nil
e.coroutine_1v1MaxTurn=nil
e.tweenerTable={}
e.mirrorScaleX=1
e.needMirrorScaleX=false
e.showOperMenu=true
e.autoExitGuideBattle=true
e.IsOpenReliveAnim=true
e.IsOpenBattleBeginAnim=true
e.leftInfo=nil
e.rightInfo=nil
e.framesAfterRefreshTipScale=-1
e.framesAfterRefreshBlack=-1
e.MAX_FRAMES_BLACK=100
e.MAX_FRAMES_TIP_SCALE=30
e.IsAutoCloseSkipView=true
e.IsShowDreamBlackImg=false
e.IsPlaySuppleRunAudio=false
e.IsPlayHeroDyingAudio=false
e.IsHideHeadBarOnDying=false
e.IsOpenPlayMusic=true
e.IsRespBattleInfo=false
e.IsRespBattleSuc=false
e.isFirstChallenge=false
e.IsOpenCurBattleCheck=false
e.BattleCheckType=FightCheckType.none
e.isTimeLine=false
e.CurRemoveHeroId=0
e.IsInLevelTestMode=false
e.IsTestMode=false
e.IsSaveLog=false
e.IsOpenReadOperCommond=false
e.AttackTaskMgr=nil
e.BgEffectMgr=nil
e.PlayerIndexMap={}
e.BossHeroId=0
e.BattleMode=EBattleMode.formation6v6
e.OpenPosition=EBattleOpenPosition[e.BattleMode]
e.HitNumSpriteMap={}
e.IsOpenShowHeadContainer=true
e.mBattleRunInMode=EBattleRunInMode.None
e.IsCloseMusicInEnd=true
e.IsHideBattleUIInStart=false
e.IsPlayBattleEndAudio=true
e.BattleResultReqCount=0
e.EnterMapsWavesIndex=0
e.battleDataType=""
e.showHeadBar=true
e.heroDeadMap={}
e.mLastReqBattleTimeStamp=0
e.openSkipFromOut=true
e.dropBoxData={}
e.mBattleUI3D=nil
e.musicBgId=0
e.battleSettingInEditor=nil
e.skillCount=0
e.stakeType=0
e.stakeFightParamMap={}
e.audioTimeStampMap={}
e.buffStaticsDamageMap={}
end
t.ResetData()
function t.SetLeftInfo(t,a,i,o,n)
e.leftInfo={headId=t,headPath=a,name=i,level=o,headFrame=n}
end
function t.SetRightInfo(i,n,o,t,a)
e.rightInfo={headId=i,headPath=n,name=o,level=t,headFrame=a}
end
function t.SetNeedMirrorScaleX(t)
e.needMirrorScaleX=t
end
function t.SetShowOperMenu(t)
e.showOperMenu=t
end
function t.SetAutoExitGuideBattle(t)
e.autoExitGuideBattle=t
end
function t.Init()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.AddEventListener()
end
function t:GetMirrorScaleX()
if e.BattleType==BattleType.dragonWar or e.needMirrorScaleX==true then
e.mirrorScaleX=-1
else
e.mirrorScaleX=1
end
return e.mirrorScaleX
end
function t.AddHeroCtrl(t)
e.HeroDic[t.HeroId]=t
end
function t.GetHeroCtrl(t)
return e.HeroDic[t]
end
function t.GetHeroCtrlIsTarget(t)
local t=e.GetHeroCtrl(t)
if t and e.CheckTargetCondition(t)then
return t
end
return nil
end
function t.GetHeroCtrlByStation(o,a)
local t=nil
if o then
t=e.OurTeam:GetHeroCtrlByStation(a)
else
t=e.EnemyTeam:GetHeroCtrlByStation(a)
end
return t
end
function t.RemoveHeroCtrl(t)
for a,e in pairs(e.CurrBeAttackHeroIdTableDic)do
for a=#e,1,-1 do
if(e[a]==t)then
table.remove(e,a)
break
end
end
end
if(ModulesInit.ProcedureNormalBattle.IsBattleTest==false)then
if(e.FightPlayData==nil)then
FightDataReportMgr:AddStatisticOnCurrWave(e.HeroDic[t])
elseif(GameInit.IsClient==false and e.FightPlayData)then
FightDataReportMgr:VerifyStatistic(e.FightPlayData,e.CurrMapsWavesIndex,e.HeroDic[t])
end
end
e.HeroDic[t]=nil
e.heroDeadMap[t]=true
end
function t.AddEventListener()
EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_OnEnter,e.ProcedureNormalBattle_OnEnter)
EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_OnLeave,e.ProcedureNormalBattle_OnLeave)
EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_TestBattle,e.ProcedureNormalBattle_TestBattle)
EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_SetCurrAttackHeroId,e.OnSetCurrAttackHeroId)
EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_SetCurrBeAttackHeroId,e.OnSetCurrBeAttackHeroId)
EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_SetStaticTarget,e.OnSetStaticTarget)
EventSystem.AddListener(CommonEventId.TestBattleSceneHeroMove,e.TestBattleSceneHeroMove)
EventSystem.AddListener(CommonEventId.OnCreateNameFinish,e.OnCreateNameFinish)
end
function t.TestBattleSceneHeroMove(t)
if(t)then
e.OurTeam:ChangeToRun()
else
e.OurTeam:ChangeToIdle(ChangeToIdleType.NormalIdle,function()
end)
end
end
function t.OnSetCurrAttackHeroId(t)
if(t==-1)then
e.IsOurTeamAttack=true
elseif(t==-2)then
e.IsOurTeamAttack=false
else
e.CurrAttackHeroId=t.Value
if(e.OurTeam:GetHeroCtrl(e.CurrAttackHeroId)~=nil or e.OurTeam:GetPetCtrl(e.CurrAttackHeroId)~=nil)then
e.IsOurTeamAttack=true
else
e.IsOurTeamAttack=false
end
end
end
function t.SetCurrAttackHeroId(t)
e.CurrAttackHeroId=t
if(e.OurTeam:GetHeroCtrl(e.CurrAttackHeroId)~=nil or e.OurTeam:GetPetCtrl(e.CurrAttackHeroId)~=nil)then
e.IsOurTeamAttack=true
else
e.IsOurTeamAttack=false
end
end
function t.SetCurrAttackTeamByTeamId(t)
e.CurrAttackHeroId=nil
if e.OurTeam.TeamId==t then
e.IsOurTeamAttack=true
else
e.IsOurTeamAttack=false
end
end
function t.OnSetCurrBeAttackHeroId(t)
local a={}
for o=0,t.Count-1 do
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
a[#a+1]=t[o]
end
e.CurrBeAttackHeroIdTableDic[0]=a
end
function t.SetCurrBeAttackHeroCtrl(a,t)
t=t==nil and 0 or t
if(a==nil)then
e.CurrBeAttackHeroIdTableDic[t]={}
return
end
local o={}
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
o[#o+1]=a.HeroId
e.CurrBeAttackHeroIdTableDic[t]=o
end
function t.SetCurrBeAttackHeroCtrls(a,t)
t=t==nil and 0 or t
if(a==nil)then
return
end
local o={}
local i=#a
for t=1,i do
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
o[#o+1]=a[t].HeroId
end
e.CurrBeAttackHeroIdTableDic[t]=o
end
function t.SetCurrBeAttackHeroCtrlsAndHeroCtrl(o,i,a)
a=a==nil and 0 or a
local t={}
if(i~=nil)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
t[#t+1]=i.HeroId
end
if(o~=nil)then
local e=#o
for e=1,e do
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
t[#t+1]=o[e].HeroId
end
end
e.CurrBeAttackHeroIdTableDic[a]=t
end
function t.GetBeAttackHeroIdTable(t)
t=t==nil and 0 or t
local e=e.CurrBeAttackHeroIdTableDic[t]or{}
return e
end
function t.GetBeAttackHeroTable(a)
local t={}
local a=e.GetBeAttackHeroIdTable(a)
if(a)then
for o=1,#a do
t[#t+1]=e.HeroDic[a[o]]
end
end
return t
end
function t.OnSetStaticTarget(t)
e.BattleCenterTransform=t.ObjectParam1
e.OurCenterTransform=t.ObjectParam2
e.EnemyCenterTransform=t.ObjectParam3
e.EnemyCenterTransformPosX,e.EnemyCenterTransformPosY,e.EnemyCenterTransformPosZ=LuaUtils.GetLocalPos(e.EnemyCenterTransform)
e.EnemyCenterTransformPosX=e.EnemyCenterTransformPosX*e.mirrorScaleX
e.OurTeamSetting=t.ObjectParam4
e.EnemyTeamSetting=t.ObjectParam5
e.DynamicCenterHelper=t.ObjectParam10
end
function t.OpenTestBattleUI()
if e.BattleType==BattleType.campaign then
if(e.IsBattleTest)then
EventSystem.SendEvent(CommonEventId.PlayLoadingCloudAni)
end
elseif e.BattleType==BattleType.idle then
end
end
function t.OnCreateNameFinish()
p=true
end
function t.OnKillDragonCountDownFinish()
end
function t.OnShowHeadBar(t)
if e.IsBattleTest then
e.showHeadBar=t
end
end
function t.BeginFightPlayWithServer(t)
e.FightPlayData=t
e.IsSkipBattle=true
e.IsAutoMode=true
e.IsFightPlay=true
e.InitBattleInfo()
if e.curProcedureBattle then
e.curProcedureBattle:OnInit(e)
end
e.LoadPlayerHeros(e.FightPlayData.ourTeamFormation,e.FightPlayData.ourTeamFormationAlter,e.FightPlayData.ourHeros,e.FightPlayData.ourPets)
e.LoadEnemyPlayerHeros(e.FightPlay_CurrWave.enemyTeamFormation,e.FightPlay_CurrWave.enemyTeamFormationAlter,e.FightPlay_CurrWave.enemyHeros,e.FightPlay_CurrWave.enemyPets)
end
function t.BeginBattleWithServer(t)
e.FightBeforeData=t
e.IsSkipBattle=true
e.IsAutoMode=true
e.IsFightPlay=false
e.InitBattleInfo()
if e.curProcedureBattle then
e.curProcedureBattle:OnInit(e)
end
e.LoadTeam()
end
function t.InitDataWithFightPlayData(t)
local a=table.deepCopy(t)
e.ResortTeamFormation(t)
e.BattleType=t.battleType
e.MapId=t.mapId
if t.ourExt and t.ourExt.accType then
e.battleDataType=t.ourExt.accType or""
else
e.battleDataType=""
end
e.CurrMapsWavesIndex=e.CurrMapsWavesIndex+1
e.FightPlay_CurrWave=t.waveData[e.CurrMapsWavesIndex]
e.MaxMapsWave=#t.waveData
RandomMgr.seed=t.randomSeed
FightDataReportMgr:InitReport(e.BattleType,e.MapId,RandomMgr.seed,t.ourPlayerId,t.enemyPlayerId,a)
e.SetBattleTeamTotalFirstValue(t)
e.InitSupplementHerosData(t,e.FightPlay_CurrWave)
e.stakeType=t.stakeType
e.InitStakeParams(t.stakeParams)
end
function t.InitDataWithFightBeforeData(t)
local a=table.deepCopy(t)
e.ResortTeamFormation(t)
e.BattleType=t.battleType
e.MapId=t.mapId
if t.ourExt and t.ourExt.accType then
e.battleDataType=t.ourExt.accType or""
else
e.battleDataType=""
end
e.CurrMapsWavesIndex=e.CurrMapsWavesIndex+1
e.FightBefore_CurrWave=e.FightBeforeData.waveData[e.CurrMapsWavesIndex]
e.MaxMapsWave=#t.waveData
if GameInit.DebugLog and e.IsOpenReadOperCommond then
e.FightPlay_CurrWave=e.FightBefore_CurrWave
end
if e.IsRandomSeedFromFightBefore then
RandomMgr.seed=t.randomSeed
else
RandomMgr:InitSpeed()
end
FightDataReportMgr:InitReport(e.BattleType,e.MapId,RandomMgr.seed,t.ourPlayerId,t.enemyPlayerId,a)
FightDataReportMgr:AddWave(e.CurrMapsWavesIndex)
e.SetBattleTeamTotalFirstValue(t)
e.InitSupplementHerosData(t,e.FightBefore_CurrWave)
e.stakeType=t.stakeType
e.InitStakeParams(t.stakeParams)
end
function t.InitStakeParams(t)
e.stakeFightParamMap={}
if t then
for a=1,#t do
local t=t[a]
e.stakeFightParamMap[t.key]=t.value
end
end
end
function t.ResortTeamFormation(e)
if e==nil then
return
end
local function n(e)
table.sort(e,function(e,t)
return e.position<t.position
end)
end
local function t(e,a)
for t=1,#e do
local o=e[t].heroId
a[o]=e[t]
end
end
local a=e.ourTeamFormation
local o={}
if a then
n(a)
t(a,o)
end
local a=e.ourTeamFormationAlter
if a then
t(a,o)
end
local a=e.ourHeros
for e=1,#a do
local e=a[e]
local t=o[e.heroId]
if t then
e.positionInFormation=t.position
else
e.positionInFormation=0
end
end
local i={}
local e=e.waveData
if e then
for a=1,#e do
local o=e[a].enemyTeamFormation
if o then
n(o)
t(o,i)
end
local o=e[a].enemyTeamFormationAlter
if o then
t(o,i)
end
local e=e[a].enemyHeros
for t=1,#e do
local e=e[t]
local t=i[e.heroId]
if t then
e.positionInFormation=t.position
else
e.positionInFormation=0
end
end
end
end
end
function t.InitDataWithEmptyData()
RandomMgr:InitSpeed()
FightDataReportMgr:InitReport(e.BattleType,e.MapId,RandomMgr.seed,PlayerMgr.PlayerInfo.uid,0,nil)
e.MaxMapsWave=1
e.SetBattleTeamTotalFirstValue(nil)
FightDataReportMgr:SetBattleTeamTotalFirstValue(e.OurTeam.TotalFirstValue,e.EnemyTeam.TotalFirstValue)
end
function t.InitSupplementHerosData(a,t)
e.OurTeam:InitSupplementHerosData(a.ourTeamFormation,a.ourHeros)
e.EnemyTeam:InitSupplementHerosData(t.enemyTeamFormation,t.enemyHeros)
end
function t.BeginBattleWithClient(t,a)
e.BattleType=t
e.IsSkipBattle=true
e.IsAutoMode=true
e.IsFightPlay=false
e.InitBattleInfo()
if e.curProcedureBattle then
e.curProcedureBattle:OnInit(e)
end
e.LoadMaps()
end
function t.BeginBattleWithServer_FightPlay()
local t='{"battleInfo":{"ourHeros":[{"heroDid":1036,"status":2,"rankLevel":3,"heroId":51469,"skills":[{"skillType":1,"skillDid":1036101},{"skillType":1,"skillDid":1036201},{"skillType":1,"skillDid":1036301},{"skillType":2,"skillDid":1036401},{"skillType":2,"skillDid":1036402},{"skillType":2,"skillDid":0}],"curMp":1000,"soul":{"soulType":8,"soulLevel":1,"soulClass":4,"soulExp":0},"playerId":48044,"underwearDids":[],"lockLevel":1,"attribute":[{"value":1040392,"id":1},{"value":127864,"id":2},{"value":45400,"id":3},{"value":1000,"id":4},{"value":5570,"id":5},{"value":3000,"id":6},{"value":2785,"id":7},{"value":3000,"id":8},{"value":3000,"id":9},{"value":1500,"id":10},{"value":21000,"id":11},{"value":3000,"id":12},{"value":3000,"id":13},{"value":3000,"id":14},{"value":3000,"id":18},{"value":3000,"id":19},{"value":6000,"id":23},{"value":6000,"id":24},{"value":5500,"id":26},{"value":186,"id":27}],"curHp":1040392,"commonSouls":[{"soulType":9,"soulLevel":1,"soulClass":5,"soulExp":0},{"soulType":10,"soulLevel":1,"soulClass":5,"soulExp":0}]},{"heroDid":1002,"status":2,"rankLevel":1,"heroId":50870,"skills":[{"skillType":1,"skillDid":1002101},{"skillType":1,"skillDid":1002201},{"skillType":1,"skillDid":1002301},{"skillType":2,"skillDid":0},{"skillType":2,"skillDid":0},{"skillType":2,"skillDid":0}],"curMp":1000,"soul":{"soulType":7,"soulLevel":1,"soulClass":4,"soulExp":0},"playerId":48044,"underwearDids":[],"lockLevel":1,"attribute":[{"value":636907,"id":1},{"value":68399,"id":2},{"value":27077,"id":3},{"value":1000,"id":4},{"value":3000,"id":5},{"value":3000,"id":6},{"value":1500,"id":7},{"value":3000,"id":8},{"value":4670,"id":9},{"value":1500,"id":10},{"value":3000,"id":11},{"value":3000,"id":12},{"value":3835,"id":13},{"value":3000,"id":14},{"value":3000,"id":18},{"value":3000,"id":19},{"value":6000,"id":23},{"value":6000,"id":24},{"value":5500,"id":26},{"value":11,"id":27}],"curHp":636907,"commonSouls":[{"soulType":9,"soulLevel":1,"soulClass":5,"soulExp":0},{"soulType":10,"soulLevel":1,"soulClass":5,"soulExp":0}]},{"heroDid":1034,"status":2,"rankLevel":3,"heroId":50874,"skills":[{"skillType":1,"skillDid":1034101},{"skillType":1,"skillDid":1034201},{"skillType":1,"skillDid":1034301},{"skillType":2,"skillDid":1034401},{"skillType":2,"skillDid":1034402},{"skillType":2,"skillDid":0}],"curMp":1000,"soul":{"soulType":4,"soulLevel":1,"soulClass":2,"soulExp":0},"playerId":48044,"underwearDids":[],"lockLevel":1,"attribute":[{"value":1123327,"id":1},{"value":110537,"id":2},{"value":52627,"id":3},{"value":1000,"id":4},{"value":3000,"id":5},{"value":3000,"id":6},{"value":1500,"id":7},{"value":5570,"id":8},{"value":3000,"id":9},{"value":2785,"id":10},{"value":3000,"id":11},{"value":21000,"id":12},{"value":3000,"id":13},{"value":3000,"id":14},{"value":3000,"id":18},{"value":3000,"id":19},{"value":6000,"id":23},{"value":6000,"id":24},{"value":5500,"id":26},{"value":186,"id":27}],"curHp":1123327,"commonSouls":[{"soulType":9,"soulLevel":1,"soulClass":5,"soulExp":0},{"soulType":10,"soulLevel":1,"soulClass":5,"soulExp":0}]}],"battleType":1,"ourPlayerId":48044,"ourTeamFormation":[{"formationId":68744,"position":1,"heroId":51469},{"formationId":65137,"position":2,"heroId":50870},{"formationId":68745,"position":3,"heroId":50874},{"heroId":0,"position":4},{"heroId":0,"position":5},{"heroId":0,"position":6}],"randomSeed":445106,"waveData":[{"waveNo":1,"enemyTeamFormation":[{"formationId":0,"heroDid":1100111,"position":1,"firstValue":0,"heroId":-1},{"formationId":0,"heroDid":1100112,"position":2,"firstValue":0,"heroId":-2},{"formationId":0,"heroDid":1100113,"position":3,"firstValue":0,"heroId":-3}],"bigRoundData":[{"bigRoundNo":1,"smallRoundData":[{"actionData":[{"heroId":51469,"actionType":3,"fireHeroId":0},{"heroId":50870,"actionType":3,"fireHeroId":0},{"heroId":50874,"actionType":3,"fireHeroId":0},{"heroId":50874,"actionType":2,"fireHeroId":-1},{"heroId":50870,"actionType":2,"fireHeroId":-1},{"heroId":51469,"actionType":2,"fireHeroId":-1}],"smallRoundNo":1},{"actionData":[{"heroId":-1,"actionType":3,"fireHeroId":0},{"heroId":-2,"actionType":3,"fireHeroId":0},{"heroId":-3,"actionType":3,"fireHeroId":0},{"heroId":-1,"actionType":1,"fireHeroId":-1},{"heroId":-2,"actionType":1,"fireHeroId":-1},{"heroId":-3,"actionType":1,"fireHeroId":-1},{"heroId":-1,"actionType":2,"fireHeroId":-1},{"heroId":-2,"actionType":2,"fireHeroId":-1},{"heroId":-3,"actionType":2,"fireHeroId":-1}],"smallRoundNo":2}]},{"bigRoundNo":2,"smallRoundData":[{"actionData":[{"heroId":50874,"actionType":1,"fireHeroId":-1},{"heroId":50870,"actionType":1,"fireHeroId":-1},{"heroId":51469,"actionType":1,"fireHeroId":-1},{"heroId":50874,"actionType":2,"fireHeroId":-2},{"heroId":50870,"actionType":2,"fireHeroId":-2},{"heroId":51469,"actionType":2,"fireHeroId":-2}],"smallRoundNo":1},{"actionData":[{"heroId":-2,"actionType":2,"fireHeroId":-2},{"heroId":-3,"actionType":2,"fireHeroId":-2}],"smallRoundNo":2}]},{"bigRoundNo":3,"smallRoundData":[{"actionData":[{"heroId":51469,"actionType":3,"fireHeroId":0},{"heroId":50870,"actionType":3,"fireHeroId":0},{"heroId":50874,"actionType":3,"fireHeroId":0},{"heroId":50870,"actionType":2,"fireHeroId":-2},{"heroId":50874,"actionType":2,"fireHeroId":-2},{"heroId":51469,"actionType":2,"fireHeroId":-2}],"smallRoundNo":1},{"actionData":[{"heroId":-3,"actionType":3,"fireHeroId":0},{"heroId":-3,"actionType":2,"fireHeroId":-3}],"smallRoundNo":2}]},{"bigRoundNo":4,"smallRoundData":[{"actionData":[{"heroId":50870,"actionType":2,"fireHeroId":-3},{"heroId":50874,"actionType":2,"fireHeroId":-3},{"heroId":51469,"actionType":2,"fireHeroId":-3}],"smallRoundNo":1},{"actionData":[{"heroId":-3,"actionType":1,"fireHeroId":-3},{"heroId":-3,"actionType":2,"fireHeroId":-3}],"smallRoundNo":2}]},{"bigRoundNo":5,"smallRoundData":[{"actionData":[{"heroId":51469,"actionType":3,"fireHeroId":0},{"heroId":50870,"actionType":3,"fireHeroId":0},{"heroId":50874,"actionType":3,"fireHeroId":0},{"heroId":50870,"actionType":2,"fireHeroId":-3},{"heroId":50874,"actionType":2,"fireHeroId":-3},{"heroId":51469,"actionType":2,"fireHeroId":-3}],"smallRoundNo":1}]}],"heroStatistics":[{"healHp":0,"rankLevel":2,"heroId":-1,"dmg":1122389,"controllRate":0,"curMp":330,"isOurHero":false,"heroDid":1100111,"playerId":0,"lockLevel":1,"hpRate":0,"curHp":0,"outputDmg":52568},{"healHp":0,"rankLevel":2,"heroId":-2,"dmg":976705,"controllRate":0,"curMp":1000,"isOurHero":false,"heroDid":1100112,"playerId":0,"lockLevel":1,"hpRate":0,"curHp":0,"outputDmg":55534},{"healHp":0,"rankLevel":2,"heroId":-3,"dmg":941372,"controllRate":0,"curMp":550,"isOurHero":false,"heroDid":1100113,"playerId":0,"lockLevel":1,"hpRate":0,"curHp":0,"outputDmg":102510},{"healHp":136798,"rankLevel":3,"heroId":50874,"dmg":42128,"controllRate":0,"curMp":1000,"isOurHero":true,"heroDid":1034,"playerId":48044,"lockLevel":1,"hpRate":9742,"curHp":1094375,"outputDmg":1220467},{"healHp":136798,"rankLevel":3,"heroId":51469,"dmg":47162,"controllRate":0,"curMp":1000,"isOurHero":true,"heroDid":1036,"playerId":48044,"lockLevel":1,"hpRate":9812,"curHp":1020833,"outputDmg":1578262},{"healHp":136798,"rankLevel":1,"heroId":50870,"dmg":121322,"controllRate":0,"curMp":738,"isOurHero":true,"heroDid":1002,"playerId":48044,"lockLevel":1,"hpRate":9441,"curHp":601310,"outputDmg":241737}],"enemyHeros":[{"heroDid":1100111,"rankLevel":2,"heroId":-1,"skills":[{"skillType":1,"skillDid":1012101},{"skillType":1,"skillDid":1012201},{"skillType":1,"skillDid":1012301},{"skillType":2,"skillDid":1012401},{"skillType":2,"skillDid":1012403}],"curMp":1000,"soul":{"soulClass":4,"soulLevel":1,"soulType":7},"lockLevel":1,"attribute":[{"value":917880,"id":1},{"value":1000,"id":4},{"value":26006,"id":2},{"value":19348,"id":3},{"value":4670,"id":5},{"value":3000,"id":6},{"value":2335,"id":7},{"value":8000,"id":8},{"value":3000,"id":9},{"value":1500,"id":10},{"value":3000,"id":11},{"value":3000,"id":12},{"value":3000,"id":13},{"value":3000,"id":14},{"value":0,"id":15},{"value":0,"id":16},{"value":0,"id":17},{"value":3000,"id":18},{"value":3000,"id":19},{"value":0,"id":20},{"value":0,"id":21},{"id":22},{"value":0,"id":23},{"value":0,"id":24},{"value":0,"id":26},{"value":1,"id":27}],"curHp":917880,"playerId":0},{"heroDid":1100112,"rankLevel":2,"heroId":-2,"skills":[{"skillType":1,"skillDid":1012101},{"skillType":1,"skillDid":1012201},{"skillType":1,"skillDid":1012301},{"skillType":2,"skillDid":1012401},{"skillType":2,"skillDid":1012403}],"curMp":1000,"soul":{"soulClass":4,"soulLevel":1,"soulType":7},"lockLevel":1,"attribute":[{"value":917880,"id":1},{"value":1000,"id":4},{"value":26006,"id":2},{"value":20302,"id":3},{"value":3000,"id":5},{"value":3000,"id":6},{"value":1500,"id":7},{"value":8000,"id":8},{"value":4670,"id":9},{"value":1500,"id":10},{"value":3000,"id":11},{"value":3000,"id":12},{"value":3835,"id":13},{"value":3000,"id":14},{"value":0,"id":15},{"value":0,"id":16},{"value":0,"id":17},{"value":3000,"id":18},{"value":3000,"id":19},{"value":0,"id":20},{"value":0,"id":21},{"id":22},{"value":0,"id":23},{"value":0,"id":24},{"value":0,"id":26},{"value":1,"id":27}],"curHp":917880,"playerId":0},{"heroDid":1100113,"rankLevel":2,"heroId":-3,"skills":[{"skillType":1,"skillDid":1012101},{"skillType":1,"skillDid":1012201},{"skillType":1,"skillDid":1012301},{"skillType":2,"skillDid":1012401},{"skillType":2,"skillDid":1012403}],"curMp":1000,"soul":{"soulClass":4,"soulLevel":1,"soulType":7},"lockLevel":1,"attribute":[{"value":917880,"id":1},{"value":1000,"id":4},{"value":26006,"id":2},{"value":29717,"id":3},{"value":3000,"id":5},{"value":3000,"id":6},{"value":1500,"id":7},{"value":8670,"id":8},{"value":3000,"id":9},{"value":2335,"id":10},{"value":3000,"id":11},{"value":3000,"id":12},{"value":3000,"id":13},{"value":3000,"id":14},{"value":0,"id":15},{"value":0,"id":16},{"value":0,"id":17},{"value":3000,"id":18},{"value":3000,"id":19},{"value":0,"id":20},{"value":0,"id":21},{"id":22},{"value":0,"id":23},{"value":0,"id":24},{"value":0,"id":26},{"value":1,"id":27}],"curHp":917880,"playerId":0}]},{"waveNo":2,"enemyTeamFormation":[{"formationId":0,"heroDid":1100121,"position":1,"firstValue":0,"heroId":-1},{"formationId":0,"heroDid":1100122,"position":2,"firstValue":0,"heroId":-2},{"formationId":0,"heroDid":1100123,"position":3,"firstValue":0,"heroId":-3}],"bigRoundData":[{"bigRoundNo":1,"smallRoundData":[{"actionData":[{"heroId":51469,"actionType":3,"fireHeroId":0},{"heroId":50870,"actionType":3,"fireHeroId":0},{"heroId":50874,"actionType":3,"fireHeroId":0},{"heroId":50874,"actionType":1,"fireHeroId":-1},{"heroId":51469,"actionType":1,"fireHeroId":-1},{"heroId":50874,"actionType":2,"fireHeroId":-1},{"heroId":50870,"actionType":2,"fireHeroId":-2},{"heroId":51469,"actionType":2,"fireHeroId":-2}],"smallRoundNo":1},{"actionData":[{"heroId":-2,"actionType":3,"fireHeroId":0},{"heroId":-3,"actionType":3,"fireHeroId":0},{"heroId":-2,"actionType":1,"fireHeroId":-2},{"heroId":-3,"actionType":1,"fireHeroId":-2},{"heroId":-2,"actionType":2,"fireHeroId":-2},{"heroId":-3,"actionType":2,"fireHeroId":-2}],"smallRoundNo":2}]},{"bigRoundNo":2,"smallRoundData":[{"actionData":[{"heroId":50874,"actionType":2,"fireHeroId":-2},{"heroId":50870,"actionType":2,"fireHeroId":-2},{"heroId":51469,"actionType":2,"fireHeroId":-2}],"smallRoundNo":1},{"actionData":[{"heroId":-3,"actionType":2,"fireHeroId":-3}],"smallRoundNo":2}]},{"bigRoundNo":3,"smallRoundData":[{"actionData":[{"heroId":51469,"actionType":3,"fireHeroId":0},{"heroId":50870,"actionType":3,"fireHeroId":0},{"heroId":50874,"actionType":3,"fireHeroId":0},{"heroId":50870,"actionType":2,"fireHeroId":-3},{"heroId":51469,"actionType":2,"fireHeroId":-3},{"heroId":50874,"actionType":2,"fireHeroId":-3}],"smallRoundNo":1}]}],"heroStatistics":[{"healHp":0,"rankLevel":2,"heroId":-1,"dmg":1006453,"controllRate":0,"curMp":1000,"isOurHero":false,"heroDid":1100121,"playerId":0,"lockLevel":1,"hpRate":0,"curHp":0,"outputDmg":0},{"healHp":0,"rankLevel":2,"heroId":-2,"dmg":982156,"controllRate":0,"curMp":450,"isOurHero":false,"heroDid":1100122,"playerId":0,"lockLevel":1,"hpRate":0,"curHp":0,"outputDmg":52568},{"healHp":0,"rankLevel":2,"heroId":-3,"dmg":1114899,"controllRate":0,"curMp":810,"isOurHero":false,"heroDid":1100123,"playerId":0,"lockLevel":1,"hpRate":0,"curHp":0,"outputDmg":62893},{"healHp":136798,"rankLevel":3,"heroId":50874,"dmg":59232,"controllRate":0,"curMp":1000,"isOurHero":true,"heroDid":1034,"playerId":48044,"lockLevel":1,"hpRate":9534,"curHp":1071031,"outputDmg":2530165},{"healHp":136798,"rankLevel":3,"heroId":51469,"dmg":82129,"controllRate":0,"curMp":851,"isOurHero":true,"heroDid":1036,"playerId":48044,"lockLevel":1,"hpRate":9385,"curHp":976506,"outputDmg":3182981},{"healHp":136798,"rankLevel":1,"heroId":50870,"dmg":184712,"controllRate":0,"curMp":1000,"isOurHero":true,"heroDid":1002,"playerId":48044,"lockLevel":1,"hpRate":8298,"curHp":528560,"outputDmg":430828}],"enemyHeros":[{"heroDid":1100121,"rankLevel":2,"heroId":-1,"skills":[{"skillType":1,"skillDid":1012101},{"skillType":1,"skillDid":1012201},{"skillType":1,"skillDid":1012301},{"skillType":2,"skillDid":1012401},{"skillType":2,"skillDid":1012403}],"curMp":1000,"soul":{"soulClass":4,"soulLevel":0,"soulType":7},"lockLevel":1,"attribute":[{"value":917880,"id":1},{"value":1000,"id":4},{"value":26006,"id":2},{"value":29717,"id":3},{"value":3000,"id":5},{"value":3000,"id":6},{"value":1500,"id":7},{"value":4670,"id":8},{"value":3000,"id":9},{"value":2335,"id":10},{"value":3000,"id":11},{"value":3000,"id":12},{"value":3000,"id":13},{"value":3000,"id":14},{"value":0,"id":15},{"value":0,"id":16},{"value":0,"id":17},{"value":3000,"id":18},{"value":3000,"id":19},{"value":0,"id":20},{"value":0,"id":21},{"id":22},{"value":0,"id":23},{"value":0,"id":24},{"value":0,"id":26},{"value":1,"id":27}],"curHp":917880,"playerId":0},{"heroDid":1100122,"rankLevel":2,"heroId":-2,"skills":[{"skillType":1,"skillDid":1012101},{"skillType":1,"skillDid":1012201},{"skillType":1,"skillDid":1012301},{"skillType":2,"skillDid":1012401},{"skillType":2,"skillDid":1012403}],"curMp":1000,"soul":{"soulClass":4,"soulLevel":0,"soulType":7},"lockLevel":1,"attribute":[{"value":917880,"id":1},{"value":1000,"id":4},{"value":26006,"id":2},{"value":29717,"id":3},{"value":3000,"id":5},{"value":3000,"id":6},{"value":1500,"id":7},{"value":4670,"id":8},{"value":3000,"id":9},{"value":2335,"id":10},{"value":3000,"id":11},{"value":3000,"id":12},{"value":3000,"id":13},{"value":3000,"id":14},{"value":0,"id":15},{"value":0,"id":16},{"value":0,"id":17},{"value":3000,"id":18},{"value":3000,"id":19},{"value":0,"id":20},{"value":0,"id":21},{"id":22},{"value":0,"id":23},{"value":0,"id":24},{"value":0,"id":26},{"value":1,"id":27}],"curHp":917880,"playerId":0},{"heroDid":1100123,"rankLevel":2,"heroId":-3,"skills":[{"skillType":1,"skillDid":1012101},{"skillType":1,"skillDid":1012201},{"skillType":1,"skillDid":1012301},{"skillType":2,"skillDid":1012401},{"skillType":2,"skillDid":1012403}],"curMp":1000,"soul":{"soulClass":4,"soulLevel":0,"soulType":7},"lockLevel":1,"attribute":[{"value":917880,"id":1},{"value":1000,"id":4},{"value":26006,"id":2},{"value":27087,"id":3},{"value":4670,"id":5},{"value":3000,"id":6},{"value":2335,"id":7},{"value":3000,"id":8},{"value":3000,"id":9},{"value":1500,"id":10},{"value":3000,"id":11},{"value":3000,"id":12},{"value":3000,"id":13},{"value":3000,"id":14},{"value":0,"id":15},{"value":0,"id":16},{"value":0,"id":17},{"value":3000,"id":18},{"value":3000,"id":19},{"value":0,"id":20},{"value":0,"id":21},{"id":22},{"value":0,"id":23},{"value":0,"id":24},{"value":0,"id":26},{"value":1,"id":27}],"curHp":917880,"playerId":0}]},{"waveNo":3,"enemyTeamFormation":[{"formationId":0,"heroDid":1100131,"position":1,"firstValue":0,"heroId":-1},{"formationId":0,"heroDid":1100132,"position":2,"firstValue":0,"heroId":-2},{"formationId":0,"heroDid":1100133,"position":3,"firstValue":0,"heroId":-3}],"bigRoundData":[{"bigRoundNo":1,"smallRoundData":[{"actionData":[{"heroId":51469,"actionType":3,"fireHeroId":0},{"heroId":50870,"actionType":3,"fireHeroId":0},{"heroId":50874,"actionType":3,"fireHeroId":0},{"heroId":50874,"actionType":2,"fireHeroId":-1},{"heroId":50870,"actionType":2,"fireHeroId":-1},{"heroId":51469,"actionType":2,"fireHeroId":-1}],"smallRoundNo":1},{"actionData":[{"heroId":-1,"actionType":3,"fireHeroId":0},{"heroId":-2,"actionType":3,"fireHeroId":0},{"heroId":-3,"actionType":3,"fireHeroId":0},{"heroId":-1,"actionType":2,"fireHeroId":-1},{"heroId":-2,"actionType":2,"fireHeroId":-1},{"heroId":-3,"actionType":2,"fireHeroId":-1}],"smallRoundNo":2}]},{"bigRoundNo":2,"smallRoundData":[{"actionData":[{"heroId":50870,"actionType":2,"fireHeroId":-1},{"heroId":50874,"actionType":2,"fireHeroId":-1},{"heroId":51469,"actionType":2,"fireHeroId":-1}],"smallRoundNo":1},{"actionData":[{"heroId":-2,"actionType":2,"fireHeroId":-2},{"heroId":-3,"actionType":2,"fireHeroId":-2}],"smallRoundNo":2}]},{"bigRoundNo":3,"smallRoundData":[{"actionData":[{"heroId":51469,"actionType":3,"fireHeroId":0},{"heroId":50870,"actionType":3,"fireHeroId":0},{"heroId":50874,"actionType":3,"fireHeroId":0},{"heroId":51469,"actionType":2,"fireHeroId":-2},{"heroId":50874,"actionType":2,"fireHeroId":-2},{"heroId":50870,"actionType":2,"fireHeroId":-3}],"smallRoundNo":1},{"actionData":[{"heroId":-3,"actionType":3,"fireHeroId":0},{"heroId":-3,"actionType":2,"fireHeroId":-3}],"smallRoundNo":2}]},{"bigRoundNo":4,"smallRoundData":[{"actionData":[{"heroId":50874,"actionType":2,"fireHeroId":-3},{"heroId":50870,"actionType":2,"fireHeroId":-3},{"heroId":51469,"actionType":2,"fireHeroId":-3}],"smallRoundNo":1},{"actionData":[{"heroId":-3,"actionType":2,"fireHeroId":-3}],"smallRoundNo":2}]},{"bigRoundNo":5,"smallRoundData":[{"actionData":[{"heroId":51469,"actionType":3,"fireHeroId":0},{"heroId":50870,"actionType":3,"fireHeroId":0},{"heroId":50874,"actionType":3,"fireHeroId":0},{"heroId":50874,"actionType":2,"fireHeroId":-3}],"smallRoundNo":1}]}],"heroStatistics":[{"healHp":0,"rankLevel":2,"heroId":-1,"dmg":1174352,"controllRate":0,"curMp":970,"isOurHero":false,"heroDid":1100131,"playerId":0,"lockLevel":1,"hpRate":0,"curHp":0,"outputDmg":9477},{"healHp":0,"rankLevel":2,"heroId":-2,"dmg":1021752,"controllRate":0,"curMp":1000,"isOurHero":false,"heroDid":1100132,"playerId":0,"lockLevel":1,"hpRate":0,"curHp":0,"outputDmg":17323},{"healHp":0,"rankLevel":2,"heroId":-3,"dmg":1136919,"controllRate":0,"curMp":1000,"isOurHero":false,"heroDid":1100133,"playerId":0,"lockLevel":1,"hpRate":0,"curHp":0,"outputDmg":34646},{"healHp":136798,"rankLevel":3,"heroId":50874,"dmg":59232,"controllRate":0,"curMp":1000,"isOurHero":true,"heroDid":1034,"playerId":48044,"lockLevel":1,"hpRate":9534,"curHp":1071031,"outputDmg":4306289},{"healHp":136798,"rankLevel":3,"heroId":51469,"dmg":143575,"controllRate":0,"curMp":1000,"isOurHero":true,"heroDid":1036,"playerId":48044,"lockLevel":1,"hpRate":8675,"curHp":902580,"outputDmg":4459154},{"healHp":136798,"rankLevel":1,"heroId":50870,"dmg":184712,"controllRate":0,"curMp":1000,"isOurHero":true,"heroDid":1002,"playerId":48044,"lockLevel":1,"hpRate":8298,"curHp":528560,"outputDmg":711554}],"enemyHeros":[{"heroDid":1100131,"rankLevel":2,"heroId":-1,"skills":[{"skillType":1,"skillDid":1012101},{"skillType":1,"skillDid":1012101},{"skillType":1,"skillDid":0},{"skillType":2,"skillDid":1001401},{"skillType":2,"skillDid":1001403}],"curMp":1000,"soul":{"soulClass":4,"soulLevel":0,"soulType":7},"lockLevel":1,"attribute":[{"value":917880,"id":1},{"value":1000,"id":4},{"value":26006,"id":2},{"value":28423,"id":3},{"value":3000,"id":5},{"value":3000,"id":6},{"value":1500,"id":7},{"value":3000,"id":8},{"value":4670,"id":9},{"value":1500,"id":10},{"value":3000,"id":11},{"value":3000,"id":12},{"value":3835,"id":13},{"value":3000,"id":14},{"value":0,"id":15},{"value":0,"id":16},{"value":0,"id":17},{"value":3000,"id":18},{"value":3000,"id":19},{"value":0,"id":20},{"value":0,"id":21},{"id":22},{"value":0,"id":23},{"value":0,"id":24},{"value":0,"id":26},{"value":1,"id":27}],"curHp":917880,"playerId":0},{"heroDid":1100132,"rankLevel":2,"heroId":-2,"skills":[{"skillType":1,"skillDid":1012101},{"skillType":1,"skillDid":1012101},{"skillType":1,"skillDid":0},{"skillType":2,"skillDid":1001401},{"skillType":2,"skillDid":1001403}],"curMp":1000,"soul":{"soulClass":4,"soulLevel":0,"soulType":7},"lockLevel":1,"attribute":[{"value":917880,"id":1},{"value":1000,"id":4},{"value":26006,"id":2},{"value":28423,"id":3},{"value":3000,"id":5},{"value":3000,"id":6},{"value":1500,"id":7},{"value":3000,"id":8},{"value":4670,"id":9},{"value":1500,"id":10},{"value":3000,"id":11},{"value":3000,"id":12},{"value":3835,"id":13},{"value":3000,"id":14},{"value":0,"id":15},{"value":0,"id":16},{"value":0,"id":17},{"value":3000,"id":18},{"value":3000,"id":19},{"value":0,"id":20},{"value":0,"id":21},{"id":22},{"value":0,"id":23},{"value":0,"id":24},{"value":0,"id":26},{"value":1,"id":27}],"curHp":917880,"playerId":0},{"heroDid":1100133,"rankLevel":2,"heroId":-3,"skills":[{"skillType":1,"skillDid":1012101},{"skillType":1,"skillDid":1012101},{"skillType":1,"skillDid":0},{"skillType":2,"skillDid":1001401},{"skillType":2,"skillDid":1001403}],"curMp":1000,"soul":{"soulClass":4,"soulLevel":0,"soulType":7},"lockLevel":1,"attribute":[{"value":917880,"id":1},{"value":1000,"id":4},{"value":26006,"id":2},{"value":28423,"id":3},{"value":3000,"id":5},{"value":3000,"id":6},{"value":1500,"id":7},{"value":3000,"id":8},{"value":4670,"id":9},{"value":1500,"id":10},{"value":3000,"id":11},{"value":3000,"id":12},{"value":3835,"id":13},{"value":3000,"id":14},{"value":0,"id":15},{"value":0,"id":16},{"value":0,"id":17},{"value":3000,"id":18},{"value":3000,"id":19},{"value":0,"id":20},{"value":0,"id":21},{"id":22},{"value":0,"id":23},{"value":0,"id":24},{"value":0,"id":26},{"value":1,"id":27}],"curHp":917880,"playerId":0}]}],"mapId":11001,"fightResult":1,"enemyPlayerId":0}}'
e.FightPlayData=JsonUtil.decode(t).battleInfo
end
function t.GetFileData(e)
local e=LuaUtils.GetFileText(e)
if e==""then

return
end
local e=JsonUtil.decode(e)
return e
end
function t.GetFileStr(e)
local e=LuaUtils.GetFileText(e)
if e==""then

return
end
return e
end
function t.PlayFightClientBattleWithFile(t,a,o)
local t=e.GetFileData(t)
e.PlayFightClientBattle(t,a,o)
end
function t.PlayFightClientBattle(o,a,n)
local t=o.battleType
local i=i.GetEntity(t).prefabId
e.MapPrefabId=i
e.IsBattleTest=false
e.BattleType=t
e.IsTestMode=true
e.curProcedureBattle=ModulesInit.ProcedureNormalBattle:DefaultBattle()
e.FightBeforeData=o
e.IsFightPlay=false
e.IsAutoMode=true
e.IsRandomSeedFromFightBefore=a or false
if a==true then
e.BattleCheckType=FightCheckType.ClientBattle2
e.IsOpenReadOperCommond=n
else
e.BattleCheckType=FightCheckType.ClientBattle
end
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.NormalBattle)
end
function t.PlayLastFightPlay()
local t=LuaUtils.GetFileText("last_battle_report.txt")
if t==""then

return
end
local t=JsonUtil.decode(t)
e.PlayFightClientReplay(t)
end
function t.PlayFightClientReplayWithFile(t)
local t=e.GetFileData(t)
e.PlayFightClientReplay(t)
end
function t.PlayFightClientReplay(t)
local a=t.battleType
local o=i.GetEntity(a).prefabId
e.MapPrefabId=o
e.IsBattleTest=false
e.IsTestMode=true
e.BattleType=a
e.curProcedureBattle=ModulesInit.ProcedureNormalBattle:DefaultBattle()
e.FightPlayData=t
e.IsFightPlay=true
e.BattleCheckType=FightCheckType.ClientReplay
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.NormalBattle)
end
function t.PlayFightServerBattleWithFile(a,t)
local a=e.GetFileData(a)
e.PlayFightServerBattle(a,t)
end
function t.PlayFightServerBattle(o,t)
local a=os.clock()
GameInit.IsClient=false
GameInit.IsBattlePlayVerify=false
ModulesInit.ProcedureNormalBattle.IsOpenCurBattleCheck=true
FightDataReportMgr:Dispose()
FightLogMgr:StartRecordLog(FightLogType.fightWithserver)
if t==true then
e.BattleCheckType=FightCheckType.ServerBattle2
else
e.BattleCheckType=FightCheckType.ServerBattle
end
e.IsRandomSeedFromFightBefore=t or false
ModulesInit.ProcedureNormalBattle.BeginBattleWithServer(table.deepCopy(o))
ModulesInit.ProcedureNormalBattle.Exit()
GameInit.IsClient=true
GameInit.IsBattlePlayVerify=false
local e=os.clock()

return ret
end
function t.PlayFightServerCheckWithFile(t)
local t=e.GetFileData(t)
e.PlayFightServerCheck(t)
end
function t.PlayFightServerCheck(a)
local t=os.clock()
GameInit.IsClient=false
GameInit.IsBattlePlayVerify=false
ModulesInit.ProcedureNormalBattle.IsOpenCurBattleCheck=true
FightDataReportMgr:Dispose()
FightLogMgr:StartRecordLog(FightLogType.fightWithserver)
e.BattleCheckType=FightCheckType.ServerCheck
ModulesInit.ProcedureNormalBattle.BeginFightPlayWithServer(table.deepCopy(a))
local e=FightDataReportMgr.isValid

local a=FightDataReportMgr.isValidByFury

ModulesInit.ProcedureNormalBattle.Exit()
GameInit.IsClient=true
GameInit.IsBattlePlayVerify=false
local a=os.clock()

return e
end
function t.CheckSaveLog()
if GameInit.DebugLog and e.BattleCheckType~=FightCheckType.none then
return true
end
return false
end
function t.InitBattleInfo()
e.isAlreadyShowBattleEnd=false
e.isBattleEnd=false
FightDataReportMgr:Init()
e.AttackTaskMgr=x:Create()
if GameInit.IsClient then
e.BgEffectMgr=k:Create()
end
e.InitBattleTeam()
if(e.FightPlayData)then
e.InitDataWithFightPlayData(e.FightPlayData)
elseif e.FightBeforeData then
e.InitDataWithFightBeforeData(e.FightBeforeData)
else
e.InitDataWithEmptyData()
end
v=ModulesInit.ProcedureNormalBattle.GetMonsterCfgData()
e.EnterMapsWavesIndex=1
if e.BattleType==BattleType.flower then
e.BattleMode=EBattleMode.formation1v1
else
e.BattleMode=EBattleMode.formation6v6
end
e.OpenPosition=EBattleOpenPosition[e.BattleMode]
e.CurrBattleRow=i.GetEntity(e.BattleType)
if(e.CurrBattleRow==nil)then
GameInit.LogError("玩法不存在 "..e.BattleType)
return
end
if e.IsStakeFight()then
e.MaxtattleBigRound=e.IsStakeFightMaxRound()
else
e.MaxBattleBigRound=e.CurrBattleRow.maxTurn
end
e.InitPlayerIndex()
end
function t.InitPlayerIndex()
e.PlayerIndexMap={}
if GameInit.IsClient==false or ModulesInit.ProcedureNormalBattle.IsSkipBattle then
return
end
if e.BattleType==BattleType.dragonWar then
if ModulesInit.KillDragonsManager.CurFightInfo
and ModulesInit.KillDragonsManager.CurFightInfo.resultShow
and ModulesInit.KillDragonsManager.CurFightInfo.resultShow.roomMember
then
local a=ModulesInit.KillDragonsManager.CurFightInfo.resultShow.roomMember
for t=1,#a do
local a=a[t]
e.PlayerIndexMap[a.playerId]=t
end
end
end
end
function t.IsHeroShowDarkEffect(t,a)
if GameInit.IsClient==false or ModulesInit.ProcedureNormalBattle.IsSkipBattle then
return 0
end
if e.BattleType==BattleType.elite then
if a==true then
local e=d.GetEliteMapsWaveData(e.MapId,e.CurrMapsWavesIndex)
local e=e and e.monsterEffect or{}
local e=e[t+1]or 0
return e
end
end
return 0
end
function t.GetPlayerIndexByPlayerId(t)
return e.PlayerIndexMap[t]or 0
end
function t.ProcedureNormalBattle_OnEnter(a)
if ModulesInit.ExpeditionManager.isStayBigMap then
ModulesInit.ExpeditionManager:LeaveBigMap()
end
ApplyQSBattle()
for e=1,#g do
g[e].GetList()
end
CS.UnityEngine.Application.targetFrameRate=GetBattleFrameRate()

ModulesInit.BattleSkillEffectManager.AddEventListener()
EventSystem.AddListener(CommonEventId.OnPlayDamagePoint,e.OnPlayDamagePoint)
EventSystem.AddListener(CommonEventId.OnBattleUILoadComplete,e.OnBattleUILoadComplete)
EventSystem.AddListener(CommonEventId.OnClickScreen,e.OnClickCallBack)
EventSystem.AddListener(CommonEventId.OnScrollSceneMoveComplete,e.OnScrollSceneMoveComplete)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,e.OnEventNetReconnectSuccess)
EventSystem.SendEvent(CommonEventId.OnShowOrHideHurtNumContainer,true)
EventSystem.AddListener(CommonEventId.OnBattleEndUIShowComplete,e.OnBattleEndUIShowComplete)
EventSystem.AddListener(CommonEventId.OnEventRespError,e.OnEventRespError)
EventSystem.AddListener(CommonEventId.KillDragonCountDownFinish,e.OnKillDragonCountDownFinish)
EventSystem.AddListener(CommonEventId.ProcedureNormalBattle_ShowHeadBar,e.OnShowHeadBar)
if GameInit.CheckOpenCurBattleLogRecordAndCheck()==true and e.BattleType~=BattleType.skillPreview then
e.IsOpenCurBattleCheck=true
FightLogMgr:StartRecordLog(FightLogType.fightWithclient)
end
CameraMgr:SetSceneType(CameraMgr.ESceneType.NormalBattle)
if e.IsOpenPlayMusic==true then
if e.musicBgId and e.musicBgId>0 then
GameTools:SwitchBGMFadeOutLua(e.musicBgId)
else
if e.BattleType==BattleType.idle then
elseif e.BattleType==BattleType.dragonWar then
GameTools:SwitchBGMFadeOutLua(114)
elseif e.BattleType==BattleType.campaign then
local e=w.GetEntity(e.MapId)
if e then
if e.subType==2 then
GameTools:SwitchBGMFadeOutLua(136)
else
GameTools:SwitchBGMFadeOutLua(104)
end
end
else
GameTools:SwitchBGMFadeOutLua(104)
end
end
end
e.InitBattleInfo()
e.LoadFireEffect()
if not e.IsFormBigMap and e.openLoading then
if not GameEntry.UI:IsExists(UIFormId.UI_CommonLoading)then
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonLoading,{style=LoadingStyle.Cloud})
end
end
e.openLoading=true
GameEntry.Scene:LoadScene(
e.IsBattleTest and SysSceneId.GameScene_TestBattle or SysSceneId.GameScene_NormalBattle,
false,
function()
e.CameraCtrlReset()
e.CameraCtrlOldPos=GameEntry.CameraCtrl.transform.position
e.CameraCtrlOriginalOrthographicSize=OG_DESIGN_SIZE*OGAdjustSizeRate
e.CameraCtrlCurrOrthographicSize=e.CameraCtrlOriginalOrthographicSize
local a=GameEntry.CameraCtrl.MainCamera:WorldToScreenPoint(Vector3.zero)
a=a+Vector3(1,0,0)
local a=GameEntry.CameraCtrl.MainCamera:ScreenToWorldPoint(a)
e.OnePixelRatio=a.x
GameEntry.UI:OpenUIForm(UIFormId.UI_Global)
if e.curProcedureBattle then
e.curProcedureBattle:OnInit(e)
end
if(not e.IsBattleTest)then
e.LoadAutoMode()
e.LoadGameSpeed()
e.LoadGameFastSkill()
e.LoadMaps()
e.LoadBattleUI3D()
t:AddManualSelfSkillRes()
else
e.LoadTestMaps()
end
e.OpenTestBattleUI()
end
)
if GameInit.IsClient then
ErrInfoCollectMgr:AddInfo("default","ProcedureEnter",{time=GameTools:GetCurrTime(),procedure="NormalBattle"})
end
end
function t.CameraCtrlReset()
if e.isBattleEnd or e.IsSkipBattle then
return
end
e.DoCameraCtrlReset()
end
function t.DoCameraCtrlReset()
if GameInit.IsClient==false then
return
end
if IsNil(GameEntry.CameraCtrl)then
return
end
if(GameEntry.Procedure.CurrProcedureState~=CS.YouYou.ProcedureState.NormalBattle and GameEntry.Procedure.CurrProcedureState~=CS.YouYou.ProcedureState.TestBattle)
then
return
end
CameraMgr:SetCameraPosition(CameraMgr.ESceneType.NormalBattle,Vector3(0,0,-50))
CameraMgr:SetCameraLocalEulerAngles(CameraMgr.ESceneType.NormalBattle,Vector3.zero)
GameEntry.CameraCtrl:ResetMainCameraPos()
CameraMgr:SetCameraOrthographic(CameraMgr.ESceneType.NormalBattle,true)
CameraMgr:SetCameraOrthographicSize(CameraMgr.ESceneType.NormalBattle,OG_DESIGN_SIZE*OGAdjustSizeRate)
GameEntry.CameraCtrl:RadialBlurSetActive(false)
end
function t.ProcedureNormalBattle_OnLeave()
if IsQualityMap then
ApplyQSMap()
else
ApplyQSUI()
end
if GameInit.IsClient then
f:ClearAll()
end
CS.UnityEngine.Application.targetFrameRate=GetUIFrameRate()

ModulesInit.BattleSkillEffectManager.RemoveEventListener()
EventSystem.RemoveListener(CommonEventId.OnPlayDamagePoint,e.OnPlayDamagePoint)
EventSystem.RemoveListener(CommonEventId.OnBattleUILoadComplete,e.OnBattleUILoadComplete)
EventSystem.RemoveListener(CommonEventId.OnClickScreen,e.OnClickCallBack)
EventSystem.RemoveListener(CommonEventId.OnScrollSceneMoveComplete,e.OnScrollSceneMoveComplete)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,e.OnEventNetReconnectSuccess)
EventSystem.SendEvent(CommonEventId.OnShowOrHideHurtNumContainer,false)
EventSystem.RemoveListener(CommonEventId.OnBattleEndUIShowComplete,e.OnBattleEndUIShowComplete)
EventSystem.RemoveListener(CommonEventId.OnEventRespError,e.OnEventRespError)
EventSystem.RemoveListener(CommonEventId.KillDragonCountDownFinish,e.OnKillDragonCountDownFinish)
EventSystem.RemoveListener(CommonEventId.ProcedureNormalBattle_ShowHeadBar,e.OnShowHeadBar)
e.Exit()
EventSystem.SendEvent(CommonEventId.OnEventCloseFlowerJump)
end
function t.LoadGameSpeed()
ModulesInit.ProcedureNormalBattle.GameSpeed=1
if PlayerMgr.PlayerInfo and PlayerMgr.PlayerInfo.uid then
ModulesInit.ProcedureNormalBattle.GameSpeed=SaveMgr.GetFloatForKey(string.format("%d_GameSpeed%s",PlayerMgr.PlayerInfo.uid,e.BattleType),1)
end
if ModulesInit.ProcedureNormalBattle.GameSpeed==1 then
GameTools:SetTimeScale(SetTimeScaleType.Battle,1.2)
else
GameTools:SetTimeScale(SetTimeScaleType.Battle,1.6)
end
end
function t.SetGameSpeed()
ModulesInit.ProcedureNormalBattle.GameSpeed=ModulesInit.ProcedureNormalBattle.GameSpeed+0.5
if(ModulesInit.ProcedureNormalBattle.GameSpeed==2)then
ModulesInit.ProcedureNormalBattle.GameSpeed=1
end
SaveMgr.SetFloatForKey(string.format("%d_GameSpeed%s",PlayerMgr.PlayerInfo.uid,e.BattleType),ModulesInit.ProcedureNormalBattle.GameSpeed)
if ModulesInit.ProcedureNormalBattle.GameSpeed==1 then
GameTools:SetTimeScale(SetTimeScaleType.Battle,1.2)
else
GameTools:SetTimeScale(SetTimeScaleType.Battle,1.6)
end
end
function t.LoadGameFastSkill()
ModulesInit.ProcedureNormalBattle.GameFastSkill=false
if PlayerMgr.PlayerInfo and PlayerMgr.PlayerInfo.uid then
local t=SaveMgr.GetFloatForKey(string.format("%d_GameFastSkill",PlayerMgr.PlayerInfo.uid),0)
if t==0 then
if(GameFunction.IsFunctionUnLock(GameFunctionType.BattleFastSkill))then
e.SetGameFastSkill(true)
else
ModulesInit.ProcedureNormalBattle.GameFastSkill=false
end
else
if t==1 then
ModulesInit.ProcedureNormalBattle.GameFastSkill=false
else
ModulesInit.ProcedureNormalBattle.GameFastSkill=true
end
end
end
end
function t.ChangeGameFastSkill()
local t=ModulesInit.ProcedureNormalBattle.GameFastSkill==false
e.SetGameFastSkill(t)
end
function t.SetGameFastSkill(e)
ModulesInit.ProcedureNormalBattle.GameFastSkill=e
local e=1
if ModulesInit.ProcedureNormalBattle.GameFastSkill then
e=2
end
SaveMgr.SetFloatForKey(string.format("%d_GameFastSkill",PlayerMgr.PlayerInfo.uid),e)
end
function t.SetGameFastSkillPlayFirstAnim(t,e)
if e~=nil then
ModulesInit.ProcedureNormalBattle.GameFastSkillPlayFirstAnimMap[e]=t
if t then
local t=TimeUtil.GetCurLocalTime()
SaveMgr.SetStringForKey(string.format("%d_%d_GameFastSkillPlayFirstAnim",PlayerMgr.PlayerInfo.uid,e),t)
end
end
end
function t.GetGameFastSkillPlayFirstAnim(e)
if e~=nil then
if ModulesInit.ProcedureNormalBattle.GameFastSkillPlayFirstAnimMap[e]==nil then
local t=SaveMgr.GetStringForKey(string.format("%d_%d_GameFastSkillPlayFirstAnim",PlayerMgr.PlayerInfo.uid,e),"")
local a=TimeUtil.GetCurLocalTime()
if t~=""and TimeUtil.checkSameDay(a,tonumber(t))==true then
ModulesInit.ProcedureNormalBattle.GameFastSkillPlayFirstAnimMap[e]=true
else
ModulesInit.ProcedureNormalBattle.GameFastSkillPlayFirstAnimMap[e]=false
end
end
return ModulesInit.ProcedureNormalBattle.GameFastSkillPlayFirstAnimMap[e]
else
return true
end
end
function t.CheckDoGameFastSkillPlayFirstAnim(t)
if GameInit.IsClient then
if e.GetGameFastSkillPlayFirstAnim(t)then
return false
else
e.SetGameFastSkillPlayFirstAnim(true,t)
return true
end
end
return false
end
function t.PauseGame()
GameTools:SetTimeScale(SetTimeScaleType.Battle,0)
GameEntry.Video:Pause()
end
function t.ResumeGame()
GameTools:SetTimeScale(SetTimeScaleType.Battle,ModulesInit.ProcedureNormalBattle.GameSpeed)
GameEntry.Video:Play()
end
function t.GetBattleHeroInitColor()
if(e.battleHeroInitColor==nil)then
return Color.white
end
return e.battleHeroInitColor
end
function t.LoadTestMaps()
GameTools:PoolGameObjectSpawn(
11001,
nil,
function(t,a,a)
if(e.CurrBattleRow.PreloadMapItemCount==1)then
t.position=Vector3(0,0,100)
else
t.position=Vector3(-13,0,100)
end
e.ScenePrefabTrans=t
e.ScrollSceneCtrl=t:GetComponent(typeof(CS.YouYou.ScrollScene))
e.ScrollSceneCtrl:SetPreloadCount(e.CurrBattleRow.PreloadMapItemCount)
e.ShowScenePrefabTrans(true)
end
)
end
function t.LoadMaps()
local t=0
if e.BattleType==BattleType.arena
or e.BattleType==BattleType.WarOfAttrition
or e.BattleType==BattleType.islandEscort
or e.BattleType==BattleType.friendArena
or e.BattleType==BattleType.spaceArena
or e.BattleType==BattleType.flower
or e.BattleType==BattleType.unionCraft
or e.BattleType==BattleType.dragonWar
or e.BattleType==BattleType.cityWar
or e.BattleType==BattleType.richMan
or e.BattleType==BattleType.skillPreview
or e.BattleType==BattleType.waterMelon
or e.BattleType==BattleType.guildBossPersonal
or e.BattleType==BattleType.guildBossGuild
or e.BattleType==BattleType.mineBattle
or e.BattleType==BattleType.burningBuild
then
t=e.MapPrefabId
elseif e.BattleType==BattleType.trial then
e.CurrTowerRow=s:GetTowerRow(e.MapId)
if GameTools:IsReview()then
t=11002
else
t=e.CurrTowerRow.battlePrefabId
end
elseif e.BattleType==BattleType.maze then
e.CurrMazeMonGroupRow=ModulesInit.MazeMgr:GetMazeMonsterCfgData(e.MapId)
t=e.MapPrefabId
elseif e.BattleType==BattleType.guide then
t=e.MapPrefabId
elseif e.BattleType==BattleType.skillPreview then
t=e.MapPrefabId
elseif e.BattleType==BattleType.thiefCrusade then
e.CurrGuildCrusadeBandit=s:GetGuildCrusadeBanditCfg(e.MapId)
t=e.MapPrefabId
elseif e.BattleType==BattleType.campaign or e.BattleType==BattleType.idle then
e.CurrDTMap=w.GetEntity(e.MapId)
e.battleHeroInitColor=Color(e.CurrDTMap.HeroInitColor_R/255,e.CurrDTMap.HeroInitColor_G/255,e.CurrDTMap.HeroInitColor_B/255,1)
t=e.CurrDTMap.prefabId
elseif e.BattleType==BattleType.elite then
e.CurrDTMap=d:GetEliteMapData(e.MapId)
e.battleHeroInitColor=Color(e.CurrDTMap.HeroInitColor_R/255,e.CurrDTMap.HeroInitColor_G/255,e.CurrDTMap.HeroInitColor_B/255,1)
t=e.CurrDTMap.prefabId
elseif e.BattleType==BattleType.carnival then
e.CurrDTMap=j.GetEntity(e.MapId)
e.battleHeroInitColor=Color(e.CurrDTMap.HeroInitColor_R/255,e.CurrDTMap.HeroInitColor_G/255,e.CurrDTMap.HeroInitColor_B/255,1)
t=e.CurrDTMap.prefabId
elseif e.BattleType==BattleType.newCarnival then
local a=require('DataNode/DataTable/Create/activity/DTNewHandCarnivalMapDBModel')
e.CurrDTMap=a.GetEntity(e.MapId)
e.battleHeroInitColor=Color(e.CurrDTMap.HeroInitColor_R/255,e.CurrDTMap.HeroInitColor_G/255,e.CurrDTMap.HeroInitColor_B/255,1)
t=e.CurrDTMap.prefabId
elseif e.BattleType==BattleType.bigBoss then
t=e.MapPrefabId
elseif e.BattleType==BattleType.guildTrials then
t=e.MapPrefabId
elseif e.BattleType==BattleType.SpringRain then
t=e.MapPrefabId
elseif e.BattleType==BattleType.selfMarryBoss then
t=e.MapPrefabId
elseif e.BattleType==BattleType.GoldHoliday then
local a=require('DataNode/DataTable/Create/activity/DTGoldHolidayMapDBModel')
e.CurrDTMap=a.GetEntity(e.MapId)
e.battleHeroInitColor=Color(e.CurrDTMap.HeroInitColor_R/255,e.CurrDTMap.HeroInitColor_G/255,e.CurrDTMap.HeroInitColor_B/255,1)
t=e.CurrDTMap.prefabId
elseif e.BattleType==BattleType.urBossFight then
t=e.MapPrefabId
elseif e.BattleType==BattleType.urBackBossFight then
t=e.MapPrefabId
elseif e.BattleType==BattleType.urTestFight then
t=e.MapPrefabId
elseif e.BattleType==BattleType.Inspiration then
t=e.MapPrefabId
elseif e.BattleType==BattleType.selfMarryBack then
t=e.MapPrefabId
elseif e.BattleType==BattleType.lrBossFight then
t=e.MapPrefabId
elseif e.BattleType==BattleType.lrTestFight then
t=e.MapPrefabId
elseif e.BattleType==BattleType.girlChallenge then
t=e.MapPrefabId
elseif e.BattleType==BattleType.GuildRadar then
t=e.MapPrefabId
else
GameEntry.LogError("未定义")
end
if(t>0 and not e.IsSkipBattle)then
GameTools:PoolGameObjectSpawn(
t,
nil,
function(t,a,a)
if e.CurrBattleRow==nil then
if GameInit.IsClient then
local e="CurrBattleRow is null. battletype = "..tostring(e.BattleType).." battleEnd = "..tostring(e.isBattleEnd).." isAlreadyShowBattleEnd = "..tostring(e.isAlreadyShowBattleEnd)
ErrInfoCollectMgr:AddInfo("BattleLoadMap","",e)
GameEntry.LogError("BattleFix this.CurrBattleRow == nil")
end
end
t.position=Vector3(0,0,100)
e.ScenePrefabTrans=t
e.ScrollSceneCtrl=t:GetComponent(typeof(CS.YouYou.ScrollScene))
e.ScrollSceneCtrl:SetPreloadCount(e.CurrBattleRow.PreloadMapItemCount)
e.ShowScenePrefabTrans(true)
if e.OurTeamSetting==nil or e.EnemyTeamSetting==nil then
return
end
e.LoadTeam()
end
)
else
e.LoadTeam()
end
end
function t.ShowScenePrefabTrans(t)
if e.ScenePrefabTrans then
e.ScenePrefabVisible=t
LuaUtils.SetActive(e.ScenePrefabTrans,t)
end
end
function t.LoadBattleUI3D()
e.RemoveBattleUI3D()
GameTools:PoolGameObjectSpawn(
SysPrefabId.BattleUI3D,
nil,
function(t,a,o)
e.mBattleUI3D=t
LuaUtils.SetLocalPos(t,0,0,0)
LuaUtils.SetLocalScale(t,1,1,1)
LuaUtils.SetParent(t,GameEntry.Instance.UI3DRoot.transform)
local t=GameEntry.Instance.UI3DRoot:GetComponent(typeof(CS.UnityEngine.Canvas))
t.worldCamera=GameEntry.CameraCtrl.MainCamera
local e=e.mBattleUI3D:GetComponent(typeof(CS.YouYou.LuaUnit))
if a then
e:Init({})
end
e:Open()
end
)
end
function t.RemoveBattleUI3D()
if e.mBattleUI3D~=nil then
local t=e.mBattleUI3D:GetComponent(typeof(CS.YouYou.LuaUnit))
t:Close()
GameEntry.Pool:GameObjectDespawn(e.mBattleUI3D)
e.mBattleUI3D=nil
end
end
function t.LoadTeam()
if(e.FightPlayData)then
e.LoadPlayerHeros(e.FightPlayData.ourTeamFormation,e.FightPlayData.ourTeamFormationAlter,e.FightPlayData.ourHeros,e.FightPlayData.ourPets)
e.LoadEnemyPlayerHeros(e.FightPlay_CurrWave.enemyTeamFormation,e.FightPlay_CurrWave.enemyTeamFormationAlter,e.FightPlay_CurrWave.enemyHeros,e.FightPlay_CurrWave.enemyPets)
elseif(e.FightBeforeData)then
e.LoadPlayerHeros(e.FightBeforeData.ourTeamFormation,e.FightBeforeData.ourTeamFormationAlter,e.FightBeforeData.ourHeros,e.FightBeforeData.ourPets)
e.LoadEnemyPlayerHeros(e.FightBefore_CurrWave.enemyTeamFormation,e.FightBefore_CurrWave.enemyTeamFormationAlter,e.FightBefore_CurrWave.enemyHeros,e.FightBefore_CurrWave.enemyPets)
else
e.LoadPlayerHeros()
e.LoadMapMonster()
end
end
function t.LoadTeamTreasure(e,t)
e:LoadTeamTreasure(t)
end
function t.GetHerosByTowFormation(a,o)
local t={}
t=e.GetHerosFromFormation(a,t)
t=e.GetHerosFromFormation(o,t)
return t
end
function t.GetHerosFromFormation(e,t)
if e then
for a=1,#e do
local e=e[a]
if e.heroId~=0 then
local e=HeroMgr:GetHeroDataByHeroId(e.heroId)
table.insert(t,e)
end
end
end
return t
end
function t.ProcedureNormalBattle_TestBattle(t)
e.OurTeam.IsKillOpponent=false
e.EnemyTeam.IsKillOpponent=false
e.TestBattleType=t
if(e.TestBattleType==0)then
e.CheckFirstAttackTeam()
elseif(e.TestBattleType==1)then
e.OurTeam:TeamAttack()
elseif(e.TestBattleType==2)then
e.EnemyTeam:TeamAttack()
end
end
function t.InitBattleTeam()
e.ReadyTeamCount=0
e.CurrMapsWavesIndex=0
e.IsFirstBattleTeamReady=false
e.OurTeam=BattleTeam:New()
e.OurTeam:Init()
e.OurTeam.TeamId=1
e.EnemyTeam=BattleTeam:New()
e.EnemyTeam:Init()
e.EnemyTeam.TeamId=2
e.OurTeam.OpponentTeam=e.EnemyTeam
e.EnemyTeam.OpponentTeam=e.OurTeam
e.OurTeam.OnBattleTeamReady=e.OnBattleTeamReady
e.EnemyTeam.OnBattleTeamReady=e.OnBattleTeamReady
end
function t.SetOurTeamAllAliveState()
if e.OurTeam then
e.OurTeam:SetAllPlayerReliveState()
end
end
function t.SetOpenReliveAnim(t)
e.IsOpenReliveAnim=t
end
function t.SetOpenBattleBeginAnim(t)
e.IsOpenBattleBeginAnim=t
end
function t.SetBattleRunInMode(t)
e.mBattleRunInMode=t
end
function t.SetOpenShowHeadContainer(t)
e.IsOpenShowHeadContainer=t
end
function t.ReliveOurTeamAll()
if e.OurTeam then
e.OurTeam:ReliveAllPlayers()
end
end
function t.EnterBigSKillState(t)
if e.OurTeam then
e.SetSkillAttackType(EBattleSkillAttackType.BigSkillAttacking)
e.OurTeam:EnterBigSKillState(t)
end
end
function t.PlayNormalSkillAttackWithPos(t)
if e.OurTeam then
e.OurTeam:PlayNormalSkillAttackWithPos(t)
end
end
function t.PlaySmallSkillAttackWithPos(t)
if e.OurTeam then
e.OurTeam:PlaySmallSkillAttackWithPos(t)
end
end
function t.PlayBigSkillAttackWithPos(t)
e.SetSkillAttackType(EBattleSkillAttackType.BigSkillAttacking)
if e.OurTeam then
e.OurTeam:PlayBigSkillAttackWithPos(t)
end
end
function t.PlayTeamAllHeroActionDone()
e.BattleRoundEndCheckBuff()
end
function t.BattleBigSKillEnter(t)
if e.OurTeam then
e.OurTeam:BattleBigSKillEnter(t)
end
end
function t.SetRoundHeroDieStatus(t)
if e.OurTeam then
e.OurTeam:SetRoundHeroDieStatus(t)
end
end
function t.SetRoundHeroRelive(t)
if e.OurTeam then
e.OurTeam:SetRoundHeroRelive(t)
end
end
function t.SetRoundCanTriggerSmallSkill(t)
if e.OurTeam then
e.OurTeam:SetRoundCanTriggerSmallSkill(t)
end
end
function t.SetTriggerSmallSkillStatus(t)
if e.OurTeam then
e.OurTeam:SetTriggerSmallSkillStatus(t)
end
end
function t.SetChaChaSureSmallSkill(t)
if e.OurTeam then
e.OurTeam:SetChaChaSureSmallSkill(t)
end
end
function t.CheckThreeBattleSpecial()
end
function t.SupplementPositionWithFormation(t)
if e.OurTeam then
for a=1,#t do
local t=t[a]
e.OurTeam:SupplementPositionWithHero(t,t.position)
end
end
end
function t.SupplementPositionWithHero(t,a)
if e.OurTeam then
e.OurTeam:SupplementPositionWithHero(t,a)
end
end
function t.SetOurTeamIsAttack()
if e.OurTeam then
e.CurrAttackTeam=e.OurTeam
end
end
function t.SetOurTeamBigAttackWaiting(t)
if e.OurTeam then
e.OurTeam:SetBigAttackWaiting(t)
end
end
function t.SetEnemyTeamBigAttackWaiting(t)
if e.EnemyTeam then
e.EnemyTeam:SetBigAttackWaiting(t)
end
end
function t.SetOurSuppleMaxHp(t)
if e.OurTeam then
e.OurTeam:SetSuppleMaxHp(t)
end
end
function t.SetEnemySuppleMaxHp(t)
if e.EnemyTeam then
e.EnemyTeam:SetSuppleMaxHp(t)
end
end
function t.SetCurrAttackHeroIdByHeroDid(a)
local e=e.OurTeam:GetHeroCtrlByDid(a)
if e then
t.SetCurrAttackHeroId(e.HeroId)
end
end
function t.SetBattleTeamTotalFirstValue(t)
if(t)then
e.OurTeam.TotalFirstValue=t.ourFirstValue
e.EnemyTeam.TotalFirstValue=t.enemyFirstValue
return
end
e.OurTeam.TotalFirstValue=PlayerMgr.PlayerInfo.firstValue
e.EnemyTeam.TotalFirstValue=6
end
function t.LoadMapMonster()
e.CurrMapsWavesIndex=e.CurrMapsWavesIndex+1
FightDataReportMgr:AddWave(e.CurrMapsWavesIndex)
EventSystem.SendEvent(CommonEventId.OnLoadNormalBattleMonster)
local t={}
local i={}
if e.BattleType==BattleType.idle then
e.idleMonsterList={}
local e=w.GetEntity(e.MapId)
local n=e.monsterLists
local s=#n
local e=ModulesInit.FormationManager:GetCurEmbattleByFormationNO(PROTO_ENUM.FormationNO.FN_IDLE)
if not e then
e=ModulesInit.FormationManager:GetCurEmbattleByFormationNO(PROTO_ENUM.FormationNO.FN_MAIN)
end
local a={}
for t=1,#e do
if e[t].heroId and e[t].heroId~=0 then
m(a,e[t])
end
end
local e=#a-RandomMgr:GetBattleRandomWithRange(0,2)
if e<=0 then
e=1
end
local o=nil
table.sort(a,function(e,t)
local e=HeroMgr:GetHeroDataByHeroId(e.heroId)
local t=HeroMgr:GetHeroDataByHeroId(t.heroId)
return e.fight<t.fight
end)
o=a[1]
for a=1,6 do
if a<=e then
local e=RandomMgr:GetBattleRandomWithRange(1,s)
local e=n[e]
local a=o.heroId
m(t,e)
m(i,a)
else
m(t,0)
m(i,0)
end
end
elseif e.BattleType==BattleType.trial then
t=s:GetMapWaveMonster(e.CurrTowerRow)
elseif e.BattleType==BattleType.maze then
local e=ModulesInit.ProcedureNormalBattle.ServerMonsterData.npcArr
t=ModulesInit.MazeMgr:GetFilterNpcIdArr(e)
elseif e.BattleType==BattleType.guide then
t=ModulesInit.GuideMgr:GetMonsterLists(e.MapId)
elseif e.BattleType==BattleType.skillPreview then
t=ModulesInit.BattlePreviewMgr:GetMonsterLists(e.MapId)
elseif e.BattleType==BattleType.thiefCrusade then
t=e.CurrGuildCrusadeBandit.monsters
elseif e.BattleType==BattleType.elite then
e.CurrMapsWaves=d.GetEliteMapAllWave(e.MapId)
local a=e.CurrMapsWaves[e.CurrMapsWavesIndex]
t=a.monsterLists
if e.FightPlayData==nil then
e.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
end
e.SetRightInfo(0,a.Icon,GameTools.GetLocalize(a.Name,LanguageCategory.LangBattle),a.level,"UILEliteAdventure/IC_touxiangkuang")
EventSystem.SendEvent(CommonEventId.ExpeditionMonsterInfoUpdate)
elseif e.BattleType==BattleType.carnival then
e.CurrMapsWaves=s.GetCarnivalMapsWave(e.MapId)
local a=e.CurrMapsWaves[e.CurrMapsWavesIndex]
t=a.monsterLists
if e.FightPlayData==nil then
e.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
end
e.SetRightInfo(0,a.Icon,GameTools.GetLocalize(a.Name,LanguageCategory.LangBattle),a.level,"UILEliteAdventure/IC_touxiangkuang")
EventSystem.SendEvent(CommonEventId.ExpeditionMonsterInfoUpdate)
elseif e.BattleType==BattleType.newCarnival then
e.CurrMapsWaves=s.GetCarnivalNewMapsWave(e.MapId)
local a=e.CurrMapsWaves[e.CurrMapsWavesIndex]
t=a.monsterLists
if e.FightPlayData==nil then
e.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
end
e.SetRightInfo(0,a.Icon,GameTools.GetLocalize(a.Name,LanguageCategory.LangBattle),a.level,"UILEliteAdventure/IC_touxiangkuang")
EventSystem.SendEvent(CommonEventId.ExpeditionMonsterInfoUpdate)
elseif e.BattleType==BattleType.GoldHoliday then
e.CurrMapsWaves=s.GetGoldHolidayMapsWave(e.MapId)
local a=e.CurrMapsWaves[e.CurrMapsWavesIndex]
t=a.monsterLists
if e.FightPlayData==nil then
e.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
end
e.SetRightInfo(0,a.Icon,GameTools.GetLocalize(a.Name,LanguageCategory.LangBattle),a.level,"UILEliteAdventure/IC_touxiangkuang")
EventSystem.SendEvent(CommonEventId.ExpeditionMonsterInfoUpdate)
elseif e.BattleType==BattleType.campaign then
e.CurrMapsWaves=s.GetMapsWave(e.MapId,ModulesInit.ProcedureNormalBattle.BattleType)
local a=e.CurrMapsWaves[e.CurrMapsWavesIndex]
t=s:GetMapWaveMonster(a)
e.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
e.SetRightInfo(0,a.Icon,GameTools.GetLocalize(a.Name,LanguageCategory.LangBattle),a.level)
EventSystem.SendEvent(CommonEventId.ExpeditionMonsterInfoUpdate)
else
e.CurrMapsWaves=s.GetMapsWave(e.MapId,ModulesInit.ProcedureNormalBattle.BattleType)
local a=e.CurrMapsWaves[e.CurrMapsWavesIndex]
t=a.monsterLists
e.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
e.SetRightInfo(0,a.Icon,GameTools.GetLocalize(a.Name,LanguageCategory.LangBattle),a.level)
EventSystem.SendEvent(CommonEventId.ExpeditionMonsterInfoUpdate)
end
local a=table.count(t)
if(a~=6)then
GameInit.LogError("关卡数据配置错误 MapId %d",e.MapId)
return
end
local o=0
for a=1,a do
local e=t[a]
if(e>0)then
o=o+1
end
end
e.StopCoroutine()
e.EnemyTeam.MaxHeroCount=o
e.EnemyTeam:Reset()
e.OurTeam:ResetHeroDataWhenNextWave()
e.EnemyTeam:ResetHeroDataWhenNextWave()
for a=1,a do
local t=t[a]
local o=i[a]
if o~=0 then
e.LoadMonster(tonumber(t),a-1,tonumber(o))
else
e.LoadMonster(tonumber(t),a-1)
end
end
end
function t.IsEffectMonster(t)
if(not e.CurrMapsWaves)then
return false
end
local e=e.CurrMapsWaves[e.CurrMapsWavesIndex]
if(e.monsterEffect and#e.monsterEffect==6)then
if(e.monsterEffect[t+1]==1)then
return true
end
end
return false
end
function t.LoadMonster(i,n,s)
if(i==0)then
return
end
if e.BattleType~=BattleType.idle then
local t=v.GetEntity(i)
if(t==nil)then
GameInit.LogError("关卡数据配置错误 MapId %d monsterId %d",e.MapId,i)
end
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local t={}
t.monsterId=i
t.battleStationIndex=n
t.battleStationTransform=e.EnemyTeamSetting:GetBattleStationByIndex(n)
t.isSupplementHero=false
GameTools:PoolGameObjectSpawn(
SysPrefabId.HeroCtrl,
t,
function(a,i,o)
local t=a:GetComponent(typeof(CS.YouYou.LuaHeroSprite))
t.IsMonster=true
t.BaseHeroID=o.monsterId
t.HeroID=(o.battleStationIndex+1)*-1
t.IdleData=s
t.IsOurHero=false
t.BattleStationIndex=o.battleStationIndex
t.IsSupplementHero=o.isSupplementHero
a:SetParent(o.battleStationTransform)
a.transform.localPosition=Vector3.zero
a.localEulerAngles=Vector3.zero
LuaUtils.SetLayer(a,LayerName.Role)
table.add(e.idleMonsterList,a)
LuaUtils.SetLocalScale(a,ModulesInit.ProcedureNormalBattle.mirrorScaleX,1,1)
if(not i)then
t:OnOpen()
end
end
)
else
local t=HeroCtrl:Create()
t:InitViewWith(false,i,(n+1)*-1,nil,nil,s)
t.IsMonster=true
t.battleStationIndex=n
t:OnOpen()
if t:IsPet()then
e.EnemyTeam:AddPetCtrl(t)
else
e.EnemyTeam:AddHeroCtrl(t)
end
end
end
function t.LoadPlayerHeros(t,a,i,o)
if(GameInit.IsClient)then
if(t==nil)then
if e.BattleType==BattleType.idle then
t,a=ModulesInit.FormationManager:GetBothFormationPosition(PROTO_ENUM.FormationNO.FN_IDLE)
elseif e.BattleType==BattleType.arena or
e.BattleType==BattleType.WarOfAttrition or
e.BattleType==BattleType.islandEscort or
e.BattleType==BattleType.friendArena or
e.BattleType==BattleType.spaceArena or
e.BattleType==BattleType.flower or
e.BattleType==BattleType.unionCraft or
e.BattleType==BattleType.cityWar or
e.BattleType==BattleType.richMan or
e.BattleType==BattleType.waterMelon or
e.BattleType==BattleType.guildBossPersonal or
e.BattleType==BattleType.guildBossGuild or
e.BattleType==BattleType.urBackBossFight or
e.BattleType==BattleType.selfMarryBack or
e.BattleType==BattleType.mineBattle or
e.BattleType==BattleType.burningBuild or
e.BattleType==BattleType.girlChallenge or
e.BattleType==BattleType.GuildRadar or
e.BattleType==BattleType.greatBoss then
t=e.FightPlayData.ourTeamFormation
a=e.FightPlayData.ourTeamFormationAlter
elseif e.BattleType==BattleType.trial then
t,a=TowerMgr:GetFormationDataWithHeroNum(e.CurrTowerRow.heroNum)
elseif e.BattleType==BattleType.maze then
local e=ModulesInit.MazeMgr:GetFormationList()
t={}
a=nil
for a,e in ipairs(e)do
if e.heroDid~=0 then
local e={heroId=a,heroDid=e.heroDid,position=e.position}
table.add(t,e)
end
end
elseif e.BattleType==BattleType.guide then
t=ModulesInit.GuideMgr:GetFormationList(e.MapId)
a=nil
elseif e.BattleType==BattleType.skillPreview then
t=ModulesInit.BattlePreviewMgr:GetFormationList(e.MapId)
a=nil
elseif e.BattleType==BattleType.thiefCrusade then
t,a=ModulesInit.FormationManager:GetBothFormationPosition(PROTO_ENUM.FormationNO.FN_MAIN)
else
t,a=ModulesInit.FormationManager:GetBothFormationPosition(PROTO_ENUM.FormationNO.FN_MAIN)
end
end
end
if(e.FightPlayData==nil)then
FightDataReportMgr:SetOurTeamFormation(t)
FightDataReportMgr:SetOurTeamFormationAlter(a)
end
local n=0
if t then
for e=1,#t do
local e=t[e]
if e.heroId~=0 then
n=n+1
end
end
end
local function h(a)
if t then
for e=1,#t do
local e=t[e]
if e.heroId~=0 and e.position==a then
if(e.heroDid==nil)then
local t=HeroMgr:GetHeroDataByHeroId(e.heroId)
if(t)then
e.heroDid=t.heroDid
end
end
return e
end
end
end
return nil
end
local s=false
if e.mBattleRunInMode==EBattleRunInMode.OurTeam or e.mBattleRunInMode==EBattleRunInMode.BothTeam then
s=true
end
if i==nil then
i=e.GetHerosByTowFormation(t,a)
end
e.LoadTeamTreasure(e.OurTeam,i)
e.OurTeam.MaxHeroCount=n
if o then
for t=1,#o do
local t=o[t]
local a={heroDid=t.heroDid,heroId=t.heroId}
local t=e.GetTransIndexByStation(t.pos)
e.LoadPlayerHero(a,t,true,nil,nil,false)
end
end
for a=1,6 do
local t=h(a)
if t and t.heroId~=0 then
local t={heroDid=t.heroDid,heroId=t.heroId}
e.LoadPlayerHero(t,a-1,true,nil,nil,s)
end
end
end
function t.LoadEnemyPlayerHeros(t,n,i,o)
if(GameInit.IsClient==false)then
if(e.FightPlayData==nil)then
FightDataReportMgr:SetEnemyTeamFormationOnCurrWave(t)
FightDataReportMgr:SetEnemyTeamFormationAlterOnCurrWave(n)
end
end
EventSystem.SendEvent(CommonEventId.OnLoadNormalBattleMonster)
local a=0
for e=1,#t do
local t=t[e]
local e=t.heroId
if e==0 then
e=t.heroDid
end
if e~=0 then
a=a+1
end
end
local function h(a)
for e=1,#t do
local e=t[e]
if e.position==a then
return e
end
end
return nil
end
e.StopCoroutine()
e.EnemyTeam.MaxHeroCount=a
e.BossHeroId=0
e.EnemyTeam:Reset()
e.OurTeam:ResetHeroDataWhenNextWave()
e.EnemyTeam:ResetHeroDataWhenNextWave()
if GameInit.IsClient and e.IsSkipBattle==false then
if e.BattleType==BattleType.campaign then
e.CurrMapsWaves=s.GetMapsWave(e.MapId,ModulesInit.ProcedureNormalBattle.BattleType)
local t=e.CurrMapsWaves[e.CurrMapsWavesIndex]
if e.FightPlayData==nil then
e.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
end
e.SetRightInfo(0,t.Icon,GameTools.GetLocalize(t.Name,LanguageCategory.LangBattle),t.level)
EventSystem.SendEvent(CommonEventId.ExpeditionMonsterInfoUpdate)
elseif e.BattleType==BattleType.elite then
e.CurrMapsWaves=d.GetEliteMapAllWave(e.MapId)
local t=e.CurrMapsWaves[e.CurrMapsWavesIndex]
if e.FightPlayData==nil then
e.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
end
e.SetRightInfo(0,t.Icon,GameTools.GetLocalize(t.Name,LanguageCategory.LangBattle),t.level,"UILEliteAdventure/IC_touxiangkuang")
EventSystem.SendEvent(CommonEventId.ExpeditionMonsterInfoUpdate)
elseif e.BattleType==BattleType.carnival then
e.CurrMapsWaves=s.GetCarnivalMapsWave(e.MapId)
local t=e.CurrMapsWaves[e.CurrMapsWavesIndex]
if e.FightPlayData==nil then
e.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
end
e.SetRightInfo(0,t.Icon,GameTools.GetLocalize(t.Name,LanguageCategory.LangBattle),t.level,"UILEliteAdventure/IC_touxiangkuang")
EventSystem.SendEvent(CommonEventId.ExpeditionMonsterInfoUpdate)
elseif e.BattleType==BattleType.newCarnival then
e.CurrMapsWaves=s.GetCarnivalNewMapsWave(e.MapId)
local t=e.CurrMapsWaves[e.CurrMapsWavesIndex]
if e.FightPlayData==nil then
e.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
end
e.SetRightInfo(0,t.Icon,GameTools.GetLocalize(t.Name,LanguageCategory.LangBattle),t.level,"UILEliteAdventure/IC_touxiangkuang")
EventSystem.SendEvent(CommonEventId.ExpeditionMonsterInfoUpdate)
elseif e.BattleType==BattleType.GoldHoliday then
e.CurrMapsWaves=s.GetGoldHolidayMapsWave(e.MapId)
local t=e.CurrMapsWaves[e.CurrMapsWavesIndex]
if e.FightPlayData==nil then
e.SetLeftInfo(PlayerMgr.PlayerInfo.head,nil,PlayerMgr.PlayerInfo.name,PlayerMgr.PlayerInfo.level)
end
e.SetRightInfo(0,t.Icon,GameTools.GetLocalize(t.Name,LanguageCategory.LangBattle),t.level,"UILEliteAdventure/IC_touxiangkuang")
EventSystem.SendEvent(CommonEventId.ExpeditionMonsterInfoUpdate)
end
end
if i==nil then
i=e.GetHerosByTowFormation(t,n)
end
e.LoadTeamTreasure(e.EnemyTeam,i)
local a=false
if e.mBattleRunInMode==EBattleRunInMode.OurTeam or e.mBattleRunInMode==EBattleRunInMode.BothTeam then
a=true
end
if o then
for t=1,#o do
local t=o[t]
local a={heroDid=t.heroDid,heroId=t.heroId}
local t=e.GetTransIndexByStation(t.pos)
e.LoadPlayerHero(a,t,false,nil,nil,false)
end
end
for o=1,6 do
local t=h(o)
if t and t.heroId~=0 then
local i={heroDid=t.heroDid,heroId=t.heroId}
e.LoadPlayerHero(i,o-1,false,nil,nil,a)
if e.EnemyTeam.MaxHeroCount==1 then
e.BossHeroId=t.heroId
end
end
end
end
function t.LoadPlayerHero(h,n,i,s,r,a)
s=s or false
a=a or false
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local t={}
t.protoData=h
t.battleStationIndex=n
t.isSupplementHero=s
t.isScreenOut=a
if(i)then
t.battleStationTransform=e.OurTeamSetting:GetBattleStationByIndex(n)
else
t.battleStationTransform=e.EnemyTeamSetting:GetBattleStationByIndex(n)
end
GameTools:PoolGameObjectSpawn(
SysPrefabId.HeroCtrl,
t,
function(a,n,t)
local o=a:GetComponent(typeof(CS.YouYou.LuaHeroSprite))
o.IsMonster=false
o.BaseHeroID=t.protoData.heroDid
o.HeroID=t.protoData.heroId
o.IsOurHero=i
o.BattleStationIndex=t.battleStationIndex
o.IsSupplementHero=t.isSupplementHero
a:SetParent(t.battleStationTransform)
if(t.isSupplementHero or t.isScreenOut)then
LuaUtils.SetLocalPos(a.transform,0,0,-15)
else
LuaUtils.SetLocalPos(a.transform,0,0,0)
end
LuaUtils.SetLocalScale(a,ModulesInit.ProcedureNormalBattle.mirrorScaleX,1,1)
a.localEulerAngles=Vector3.zero
if(not n)then
o:OnOpen()
end
if r==true then
local e=a.transform.position
GameEntry.Effect:ShowEffect(SysEffectId.ResurgenceHeroEffect,EffectKeepType.AutoRelease,e.x,e.y,e.z)
end
if e.BattleMode==EBattleMode.formation1v1 then
e.Set1v1HeadInfo(i,t.protoData.heroDid)
end
end
)
else
local t=HeroCtrl:Create()
t:InitViewWith(i,h.heroDid,h.heroId,nil,nil,0)
t.IsMonster=false
t.battleStationIndex=n
t.IsSupplementHero=s
t:OnOpen()
if(i)then
if t:IsPet()then
e.OurTeam:AddPetCtrl(t)
else
e.OurTeam:AddHeroCtrl(t)
end
else
if t:IsPet()then
e.EnemyTeam:AddPetCtrl(t)
else
e.EnemyTeam:AddHeroCtrl(t)
end
end
end
end
function t.OnBattleTeamReady(t)
if(e.OurTeamIsRuning)then
e.EnemyTeam:ShowOrHideHeadBarView(false)
return
end
e.ReadyTeamCount=e.ReadyTeamCount+1
if(e.ReadyTeamCount==2)then
if(not e.IsFirstBattleTeamReady)then
e.IsFirstBattleTeamReady=true
e.FirstBattleTeamReady()
else
e.AfterBattleTeamReady()
end
end
end
function t.FirstBattleTeamReady()
if(GameInit.IsClient)then
if e.BattleType==BattleType.idle then
e.OnBattleUILoadComplete()
else
if(e.IsSkipBattle)then
e.AfterBattleTeamReady()
else
GameEntry.UI:OpenUIForm(e.IsBattleTest and UIFormId.UI_TestBattle or UIFormId.UI_NormalBattle,{showOperMenu=e.showOperMenu})
end
end
else
e.AfterBattleTeamReady()
end
end
function t.OnBattleUILoadComplete()
local t=function()
if e.BattleType==BattleType.idle then
if e.IsFormBigMap then
e.IsFormBigMap=false
end
else
EventSystem.SendEvent(CommonEventId.PlayLoadingCloudAni)
end
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="BATTLE_START"})
e.AfterBattleTeamReady()
end
if e.curProcedureBattle then
e.curProcedureBattle:PreLoad()
e.coroutine_WaitBeginBattle=h.start(
function()
while not e.curProcedureBattle:GetIsCloseLoadingAndBeginBattle()do
coroutine.yield(CS.UnityEngine.WaitForSeconds(0.1))
end
t()
end
)
else
t()
end
end
function t.GuideAfterBattleReady()
e.AfterBattleTeamReady()
end
function t.AfterBattleTeamReady()
if(GameInit.IsClient)and ModulesInit.GuideMgr.isGuide and
(ModulesInit.GuideMgr.guideId==ModulesInit.GuideMgr.SpeacalId.FirstBattleRedy or
ModulesInit.GuideMgr.guideId==ModulesInit.GuideMgr.SpeacalId.ThreeBattleRedy
)then
return
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(e.BattleType==BattleType.idle)then
if(e.CurrMapsWavesIndex==1)then
e.EnemyTeam:ShowOrHideHeadBarView(false)
end
end

e.OurTeam:PrintHerosState()

e.EnemyTeam:PrintHerosState()
if(e.CurrMapsWavesIndex==1 and e.IsOpenBattleBeginAnim)then
if
e.BattleType==BattleType.campaign
or e.BattleType==BattleType.elite
or e.BattleType==BattleType.carnival
or e.BattleType==BattleType.newCarnival
or e.BattleType==BattleType.bigBoss
or e.BattleType==BattleType.waterMelon
or e.BattleType==BattleType.trial
or e.BattleType==BattleType.arena
or e.BattleType==BattleType.WarOfAttrition
or e.BattleType==BattleType.islandEscort
or e.BattleType==BattleType.friendArena
or e.BattleType==BattleType.spaceArena
or e.BattleType==BattleType.flower
or e.BattleType==BattleType.unionCraft
or e.BattleType==BattleType.dragonWar
or e.BattleType==BattleType.maze
or e.BattleType==BattleType.guide
or e.BattleType==BattleType.thiefCrusade
or e.BattleType==BattleType.cityWar
or e.BattleType==BattleType.richMan
or e.BattleType==BattleType.guildBossPersonal
or e.BattleType==BattleType.guildBossGuild
or e.BattleType==BattleType.skillPreview
or e.BattleType==BattleType.guildTrials
or e.BattleType==BattleType.SpringRain
or e.BattleType==BattleType.selfMarryBoss
or e.BattleType==BattleType.GoldHoliday
or e.BattleType==BattleType.Inspiration
or e.BattleType==BattleType.mineBattle
or e.BattleType==BattleType.urBossFight
or e.BattleType==BattleType.urBackBossFight
or e.BattleType==BattleType.urTestFight
or e.BattleType==BattleType.fsbFight
or e.BattleType==BattleType.fsbyFight
or e.BattleType==BattleType.selfMarryBack
or e.BattleType==BattleType.burningBuild
or e.BattleType==BattleType.greatBoss
or e.BattleType==BattleType.lrBossFight
or e.BattleType==BattleType.lrTestFight
or e.BattleType==BattleType.girlChallenge
or e.BattleType==BattleType.GuildRadar
then
if(GameInit.IsClient and not e.IsSkipBattle)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=ModulesInit.TimeActionMgr.CreateTimeAction()
e.AddTimer(t)
t:Init(
0,
0.5,
1,
nil,
nil,
function()
e.RemoveTimer(t)
EventSystem.SendEvent(CommonEventId.OnShowBattleStart,true)
local t=ModulesInit.TimeActionMgr.CreateTimeAction()
e.AddTimer(t)
t:Init(
0,
1.56,
1,
nil,
nil,
function()
e.RemoveTimer(t)
EventSystem.SendEvent(CommonEventId.OnShowBattleStart,false)
end
):Run()
local t=ModulesInit.TimeActionMgr.CreateTimeAction()
e.AddTimer(t)
t:Init(
0,
0.8,
1,
nil,
nil,
function()
e.RemoveTimer(t)
e.CheckBattleBegin()
end
):Run()
end
):Run()
else
e.CheckBattleBegin()
end
else
if e.curProcedureBattle then
e.curProcedureBattle:AfterBattleTeamReady()
end
end
else
e.CheckBattleBegin()
end
end
function t.CheckBattleBegin()
if e.IsSkipBattle==false and e.mBattleRunInMode>EBattleRunInMode.None then
if(e.coroutine_BattleRunin)then
h.stop(e.coroutine_BattleRunin)
e.coroutine_BattleRunin=nil
end
e.coroutine_BattleRunin=h.start(
function()
if e.OurTeam and(e.mBattleRunInMode==EBattleRunInMode.OurTeam or e.mBattleRunInMode==EBattleRunInMode.BothTeam)then
e.OurTeam:AllHeroRunInBattle()
end
if e.EnemyTeam and(e.mBattleRunInMode==EBattleRunInMode.EnemyTeam or e.mBattleRunInMode==EBattleRunInMode.BothTeam)then
e.EnemyTeam:AllHeroRunInBattle()
end
if(not e.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.WaitForSeconds(1.5))
end
e.BattleBegin()
e.coroutine_BattleRunin=nil
end
)
else
e.BattleBegin()
end
end
function t.DisposeBattleTeam()
for a,t in pairs(e.HeroDic)do
t:OnClose(true)
end
e.HeroDic={}
if(e.OurTeam)then
e.OurTeam:Dispose()
e.OurTeam=nil
end
if(e.EnemyTeam)then
e.EnemyTeam:Dispose()
e.EnemyTeam=nil
end
end
function t.ResetEnemyTeamPos()
LuaUtils.SetLocalPos(e.EnemyCenterTransform,e.EnemyCenterTransformPosX,e.EnemyCenterTransformPosY,e.EnemyCenterTransformPosZ)
end
function t.SetEnemyTeamPos(t,a)
local t=t*a
LuaUtils.SetLocalPos(e.EnemyCenterTransform,e.EnemyCenterTransformPosX+t,e.EnemyCenterTransformPosY,e.EnemyCenterTransformPosZ)
end
function t.AddEmptyStatisticOnCurrWave(t)
e.OurTeam:AddEmptyStatisticOnCurrWave(true,t==EBattleSuppleHeroStaticsResult.IsOurZeroHp)
e.EnemyTeam:AddEmptyStatisticOnCurrWave(false,t==EBattleSuppleHeroStaticsResult.IsEnmeyZeroHp)
end
function t.ChangeHasNextWaves()
if(e.FightPlayData)then
e.CurrMapsWavesIndex=e.CurrMapsWavesIndex+1
e.FightPlay_CurrWave=e.FightPlayData.waveData[e.CurrMapsWavesIndex]
if(e.FightPlay_CurrWave==nil)then
e.FinalBattleEnd()
return
end
else
if(e.FightBeforeData)then
e.CurrMapsWavesIndex=e.CurrMapsWavesIndex+1
e.FightBefore_CurrWave=e.FightBeforeData.waveData[e.CurrMapsWavesIndex]
if GameInit.DebugLog and e.IsOpenReadOperCommond then
e.FightPlay_CurrWave=e.FightBefore_CurrWave
end
if(e.FightBefore_CurrWave==nil)then
e.FinalBattleEnd()
return
end
else
if e.BattleType~=BattleType.idle then
if e.BattleType==BattleType.campaign
or e.BattleType==BattleType.elite
or e.BattleType==BattleType.carnival
or e.BattleType==BattleType.newCarnival
or e.BattleType==BattleType.GoldHoliday then
if(e.CurrMapsWavesIndex==#e.CurrMapsWaves)then
e.FinalBattleEnd()
return
end
elseif e.BattleType==BattleType.trial
or e.BattleType==BattleType.maze
or e.BattleType==BattleType.guide
or e.BattleType==BattleType.thiefCrusade
or e.BattleType==BattleType.SpringRain
or e.BattleType==BattleType.selfMarryBoss
or e.BattleType==BattleType.arena
or e.BattleType==BattleType.WarOfAttrition
or e.BattleType==BattleType.islandEscort
or e.BattleType==BattleType.friendArena
or e.BattleType==BattleType.spaceArena
or e.BattleType==BattleType.flower
or e.BattleType==BattleType.unionCraft
or e.BattleType==BattleType.cityWar
or e.BattleType==BattleType.richMan
or e.BattleType==BattleType.skillPreview
or e.BattleType==BattleType.dragonWar
or e.BattleType==BattleType.bigBoss
or e.BattleType==BattleType.waterMelon
or e.BattleType==BattleType.guildBossPersonal
or e.BattleType==BattleType.guildBossGuild
or e.BattleType==BattleType.guildTrials
or e.BattleType==BattleType.mineBattle
or e.BattleType==BattleType.urBossFight
or e.BattleType==BattleType.Inspiration
or e.BattleType==BattleType.urBackBossFight
or e.BattleType==BattleType.urTestFight
or e.BattleType==BattleType.fsbFight
or e.BattleType==BattleType.fsbyFight
or e.BattleType==BattleType.selfMarryBack
or e.BattleType==BattleType.burningBuild
or e.BattleType==BattleType.greatBoss
or e.BattleType==BattleType.lrBossFight
or e.BattleType==BattleType.lrTestFight
or e.BattleType==BattleType.girlChallenge
or e.BattleType==BattleType.GuildRadar
then
e.FinalBattleEnd()
return
end
else
e.OurTeam:HpHealthToMax()
end
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if e.OurTeam then
e.OurTeam:ClearAllHeroControlBuff()
end
if e.EnemyTeam then
e.EnemyTeam:ClearAllHeroControlBuff()
end
e.OurTeam:HideAllEffectStatusAndShowMask()
if e.EnemyTeam then
e.EnemyTeam:SetCampionBuffId(0)
end
e.AttackTaskMgr:ResetData()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local t=ModulesInit.TimeActionMgr.CreateTimeAction()
e.AddTimer(t)
t:Init(
0,
0.5,
1,
nil,
nil,
function()
e.RemoveTimer(t)
if(e.OurTeam==nil)then
return
end
e.enemyLocking=true
EventSystem.SendEvent(CommonEventId.EnemyLocking,true)
e.OurTeamIsRuning=true
e.SetCurBgEffectAnimRun(3)
e.OurTeam:ChangeToRun()
e.OurTeam:ShowOrHideHeadBarView(false)
e.OurTeam:HideHeroInRun()
ModulesInit.GlobalBattleEffectMgr.ShowAllEffect(false)
e.SetEnemyTeamPos(3,10)
local t=LuaUtils.DoTweenDLocalPosMoveX(
e.EnemyCenterTransform,
e.EnemyCenterTransformPosX,
3,
function()
EventSystem.SendEvent(CommonEventId.OnEnemyCenterPosReset)
e.StartNextBattle()
end
)
ModulesInit.ProcedureNormalBattle.AddTweener(t)
e.ScrollSceneCtrl:Move(true,3)
e.ReadyTeamCount=1
e.LoadNextWaveEnemy()
end
):Run()
else
e.ReadyTeamCount=1
e.LoadNextWaveEnemy()
if e.curProcedureBattle then
e.curProcedureBattle:OnNextWaves()
end
e.OurTeam:ChangeToIdle(ChangeToIdleType.NormalIdle,function()
e.OnBattleTeamReady(nil)
end)
end
end
function t.LoadNextWaveEnemy()
if(e.FightPlayData)then
e.LoadEnemyPlayerHeros(e.FightPlay_CurrWave.enemyTeamFormation,e.FightPlay_CurrWave.enemyTeamFormationAlter,e.FightPlay_CurrWave.enemyHeros,e.FightPlay_CurrWave.enemyPets)
elseif(e.FightBeforeData)then
FightDataReportMgr:AddWave(e.CurrMapsWavesIndex)
e.LoadEnemyPlayerHeros(e.FightBefore_CurrWave.enemyTeamFormation,e.FightBefore_CurrWave.enemyTeamFormationAlter,e.FightBefore_CurrWave.enemyHeros,e.FightBefore_CurrWave.enemyPets)
else
e.LoadMapMonster()
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
EventSystem.SendEvent(CommonEventId.OnEventBattleNextWaveEnemy)
end
end
function t.OnScrollSceneMoveComplete()
end
function t.StartNextBattle()
if e.OurTeam==nil then
return
end
if e.curProcedureBattle then
e.curProcedureBattle:OnNextWaves()
end
e.OurTeamIsRuning=false
e.SetCurEffectAnimIdle()
e.OurTeam:ChangeToIdle(ChangeToIdleType.NormalIdle,function()
e.StartNextBattleAfterIdle()
end)
end
function t.StartNextBattleAfterIdle()
e.OnBattleTeamReady(nil)
e.OurTeam:ShowHeroAfterRun()
e.OurTeam:ShowOrHideHeadBarView(true)
e.EnemyTeam:ShowOrHideHeadBarView(true)
ModulesInit.GlobalBattleEffectMgr.ShowAllEffect(true)
e.enemyLocking=false
EventSystem.SendEvent(CommonEventId.EnemyLocking,false)
if ModulesInit.ProcedureNormalBattle.CurrMapsWavesIndex==2 then
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="BATTLE_TWO_MEET"})
end
if ModulesInit.ProcedureNormalBattle.CurrMapsWavesIndex==3 then
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="BATTLE_THREE_EET"})
end
e.EnterMapsWavesIndex=ModulesInit.ProcedureNormalBattle.CurrMapsWavesIndex
end
function t.OnEventNetReconnectSuccess()
local a=TimeUtil.GetServerMillTimeStamp()-e.mLastReqBattleTimeStamp
local t=false
if a>5000 then
t=true
end
e.mLastReqBattleTimeStamp=TimeUtil.GetServerMillTimeStamp()
if e.IsRespBattleInfo then
local o=function()
if GameEntry.UI:IsExists(UIFormId.UI_BattleVictory)then
return
end
local e=ModulesInit.ExpeditionManager.FightClearState
local t=ModulesInit.ExpeditionManager.FightClearInfo
if e then
PlayerMgr:AddFuncOpenTips()
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="FIGHT_BATTLE_VICTORY"})
ModulesInit.FormationManager:CopyFormationDataToServer(PROTO_ENUM.FormationNO.FN_MAIN,PROTO_ENUM.FormationNO.FN_IDLE)
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleVictory,t)
end
end
local u=function()
if GameEntry.UI:IsExists(UIFormId.UI_TowerVictory)then
return
end
ModulesInit.ProcedureClimbingTower.isForm=true
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
end
local function a(a)
if ModulesInit.ExpeditionManager:MapIsThrough(e.MapId)then
o()
else
if a==false and e.BattleResultReqCount>0 and t then
e.BattleResultReqCount=e.BattleResultReqCount-1
FightDataReportMgr:SendFightManualRequest()
else
e.IsRespBattleInfo=false
local e=ModulesInit.ExpeditionManager.FightClearState
if e==false then
local e=ModulesInit.ExpeditionManager.FightClearInfo
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,e)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonLoading,{style=LoadingStyle.Black,blackAnimType=ELoadingBlackAnimType.Short,loadResFinish=function()
ModulesInit.ExpeditionManager:BackBigMap()
if ModulesInit.GuideMgr.isGuide then
EventSystem.SendEvent(CommonEventId.OnSkipGuide2)
end
end})
end
end
end
end
local function m(t)
if PlayerMgr.PlayerExtInfo.maxMapElite>=e.MapId then
ModulesInit.EliteMgr:GoBack()
else
if t==false and e.BattleResultReqCount>0 then
e.BattleResultReqCount=e.BattleResultReqCount-1
ModulesInit.EliteMgr:SendFightManualRequest()
else
e.IsRespBattleInfo=false
local e=ModulesInit.ExpeditionManager.FightClearState
if e==false then
local e=ModulesInit.ExpeditionManager.FightClearInfo
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,e)
else
ModulesInit.EliteMgr:GoBack()
end
end
end
end
local function h(t)
if ModulesInit.ActBurningBuildMgr.mapId>=e.MapId then
ModulesInit.ActBurningBuildMgr.isForm=true
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
else
if t==false and e.BattleResultReqCount>0 then
e.BattleResultReqCount=e.BattleResultReqCount-1
ModulesInit.ActBurningBuildMgr:SendFightManualRequest()
else
e.IsRespBattleInfo=false
local e=ModulesInit.ExpeditionManager.FightClearState
if e==false then
local e=ModulesInit.ExpeditionManager.FightClearInfo
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,e)
else
ModulesInit.ActBurningBuildMgr.isForm=true
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
end
end
end
end
local function l(t)
if ModulesInit.ActCarnivalManager:GetCanMaxThroughMapId()>=e.MapId then
ModulesInit.ActCarnivalManager:GoBack()
else
if t==false and e.BattleResultReqCount>0 then
e.BattleResultReqCount=e.BattleResultReqCount-1
ModulesInit.ActCarnivalManager:SendFightManualRequest()
else
e.IsRespBattleInfo=false
ModulesInit.ActCarnivalManager:GoBack()
end
end
end
local function c(t)
if ModulesInit.ActCarnivalNewManager:GetCanMaxThroughMapId()>=e.MapId then
ModulesInit.ActCarnivalNewManager:GoBack()
else
if t==false and e.BattleResultReqCount>0 then
e.BattleResultReqCount=e.BattleResultReqCount-1
ModulesInit.ActCarnivalNewManager:SendFightManualRequest()
else
e.IsRespBattleInfo=false
ModulesInit.ActCarnivalNewManager:GoBack()
end
end
end
local function w(t)
local a,o=ModulesInit.ActGoldHolidayMgr:GetCanMaxThroughMapId(ModulesInit.ActGoldHolidayMgr.isOpenGoldHoliday)
if(a>=e.MapId or o)then
ModulesInit.ActGoldHolidayMgr:GoBack()
else
if t==false and e.BattleResultReqCount>0 then
e.BattleResultReqCount=e.BattleResultReqCount-1
ModulesInit.ActGoldHolidayMgr:SendFightManualRequest()
else
e.IsRespBattleInfo=false
ModulesInit.ActGoldHolidayMgr:GoBack()
end
end
end
local function s(t)
if t==false and e.BattleResultReqCount>0 then
e.BattleResultReqCount=e.BattleResultReqCount-1
ModulesInit.ActSpringRainMgr:SendFightRequest()
else
e.IsRespBattleInfo=false
ModulesInit.ActSpringRainMgr:GoBack()
end
end
local function d(t)
ModulesInit.ActURBossMgr:CheckBattelReConnect(function(a)
if a then
if t==false and e.BattleResultReqCount>0 then
e.BattleResultReqCount=e.BattleResultReqCount-1
ModulesInit.ActURBossMgr:RequestBossFight()
else
e.IsRespBattleInfo=false
ModulesInit.ActURBossMgr:GoBack()
end
else
ModulesInit.ActURBossMgr:GoBack()
end
end)
end
local function r(t)
ModulesInit.ActURTestMgr:CheckBattelReConnect(function(a)
if a then
if t==false and e.BattleResultReqCount>0 then
e.BattleResultReqCount=e.BattleResultReqCount-1
ModulesInit.ActURTestMgr:RequestTestFight()
else
e.IsRespBattleInfo=false
ModulesInit.ActURTestMgr:GoBack()
end
else
ModulesInit.ActURTestMgr:GoBack()
end
end)
end
local function f(t)
ModulesInit.ActLRBossMgr:CheckBattelReConnect(function(a)
if a then
if t==false and e.BattleResultReqCount>0 then
e.BattleResultReqCount=e.BattleResultReqCount-1
ModulesInit.ActLRBossMgr:RequestBossFight()
else
e.IsRespBattleInfo=false
ModulesInit.ActLRBossMgr:GoBack()
end
else
ModulesInit.ActLRBossMgr:GoBack()
end
end)
end
local function n(a)
ModulesInit.ActLRTestMgr:CheckBattelReConnect(function(t)
if t then
if a==false and e.BattleResultReqCount>0 then
e.BattleResultReqCount=e.BattleResultReqCount-1
ModulesInit.ActLRTestMgr:RequestTestFight()
else
e.IsRespBattleInfo=false
ModulesInit.ActLRTestMgr:GoBack()
end
else
ModulesInit.ActLRTestMgr:GoBack()
end
end)
end
local function o(t)
if t==false and e.BattleResultReqCount>0 then
e.BattleResultReqCount=e.BattleResultReqCount-1
ModulesInit.InspirationMgr:RequestFight()
else
e.IsRespBattleInfo=false
ModulesInit.InspirationMgr:GoBack()
end
end
local function i(t)
if PlayerMgr.PlayerInfo.maxTowerMap>=e.MapId then
u()
else
if t==false and e.BattleResultReqCount>0 then
e.BattleResultReqCount=e.BattleResultReqCount-1
FightDataReportMgr:SendFightManualRequest()
else
e.IsRespBattleInfo=false
local e=ModulesInit.ExpeditionManager.FightClearState
if e==false then
local e=ModulesInit.ExpeditionManager.FightClearInfo
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,e)
else
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.Tower)
end
end
end
end
local y=function()
if GameEntry.UI:IsExists(UIFormId.UI_BattleVictory)then
return
end
local e=ModulesInit.ExpeditionManager.FightClearInfo
PlayerMgr:AddFuncOpenTips()
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="FIGHT_BATTLE_VICTORY"})
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleVictory,e)
end
local function u(t)
if ModulesInit.GuideMgr.isGuide and ModulesInit.GuideMgr.unit==ModulesInit.GuideMgr.EGuideCfg.EarthChapter_1_1 then
if t==false and e.BattleResultReqCount>0 then
e.BattleResultReqCount=e.BattleResultReqCount-1
FightDataReportMgr:SendFighGuideFinalRequest()
else
EventSystem.SendEvent(CommonEventId.OnSkipGuide2)
e.IsRespBattleInfo=false
y()
end
end
end
local function t(t)
if t==false and e.BattleResultReqCount>0 then
e.BattleResultReqCount=e.BattleResultReqCount-1
ModulesInit.GuildTrialsMgr:ReqGuildTrialsFight()
else
e.IsRespBattleInfo=false
ModulesInit.GuildTrialsMgr:GoBack()
end
end
if not e.IsRespBattleSuc then
if e.BattleType==BattleType.campaign then
a(false)
elseif e.BattleType==BattleType.elite then
m(false)
elseif e.BattleType==BattleType.burningBuild then
h(false)
elseif e.BattleType==BattleType.carnival then
l(false)
elseif e.BattleType==BattleType.newCarnival then
c(false)
elseif e.BattleType==BattleType.SpringRain then
s(false)
elseif e.BattleType==BattleType.trial then
i(false)
elseif e.BattleType==BattleType.guide then
u(false)
elseif e.BattleType==BattleType.guildTrials then
t(false)
elseif e.BattleType==BattleType.GoldHoliday then
w(false)
elseif e.BattleType==BattleType.urBossFight then
d(false)
elseif e.BattleType==BattleType.urTestFight then
r(false)
elseif e.BattleType==BattleType.Inspiration then
o(false)
elseif e.BattleType==BattleType.lrBossFight then
f(false)
elseif e.BattleType==BattleType.lrTestFight then
n(false)
end
else
if e.BattleType==BattleType.campaign then
a(true)
elseif e.BattleType==BattleType.elite then
m(true)
elseif e.BattleType==BattleType.burningBuild then
h(true)
elseif e.BattleType==BattleType.carnival then
l(true)
elseif e.BattleType==BattleType.newCarnival then
c(true)
elseif e.BattleType==BattleType.SpringRain then
s(true)
elseif e.BattleType==BattleType.trial then
i(true)
elseif e.BattleType==BattleType.guide then
u(true)
elseif e.BattleType==BattleType.guildTrials then
t(true)
elseif e.BattleType==BattleType.GoldHoliday then
w(true)
elseif e.BattleType==BattleType.urBossFight then
d(true)
elseif e.BattleType==BattleType.urTestFight then
r(true)
elseif e.BattleType==BattleType.Inspiration then
o(false)
elseif e.BattleType==BattleType.lrBossFight then
f(true)
elseif e.BattleType==BattleType.lrTestFight then
n(true)
end
end
end
end
function t.OnEventRespError(t)
if e.BattleType==BattleType.campaign then
if t.protoCode==ProtoId.PRT_FIGHT_MANUAL_REQ then

GameEntry.UI:OpenUIForm(UIFormId.UI_CommonLoading,{style=LoadingStyle.Black,blackAnimType=ELoadingBlackAnimType.Short,loadResFinish=function()
ModulesInit.ExpeditionManager:BackBigMap()
end})
e.IsRespBattleInfo=false
end
elseif e.BattleType==BattleType.elite then
if t.protoCode==ProtoId.PRT_MAP_ELITE_FIGHT_REQ then
ModulesInit.EliteMgr:GoBack()
e.IsRespBattleInfo=false
end
elseif e.BattleType==BattleType.burningBuild then
if t.protoCode==ProtoId.PRT_BURNING_MAP_FIGHT_REQ then
ModulesInit.ActBurningBuildMgr:GoBack()
e.IsRespBattleInfo=false
end
elseif e.BattleType==BattleType.carnival then
if t.protoCode==ProtoId.PRT_CARNIVAL_FIGHT_REQ then
ModulesInit.ActCarnivalManager:GoBack()
e.IsRespBattleInfo=false
end
elseif e.BattleType==BattleType.newCarnival then
if t.protoCode==ProtoId.PRT_CARNIVAL_NEW_FIGHT_REQ then
ModulesInit.ActCarnivalNewManager:GoBack()
e.IsRespBattleInfo=false
end
elseif e.BattleType==BattleType.GoldHoliday then
if t.protoCode==ProtoId.PRT_GOLD_HOLIDAY_FIGHT_REQ then
ModulesInit.ActGoldHolidayMgr:GoBack()
e.IsRespBattleInfo=false
end
elseif e.BattleType==BattleType.trial then
if t.protoCode==ProtoId.PRT_FIGHT_MANUAL_REQ then
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.Tower)
e.IsRespBattleInfo=false
end
elseif e.BattleType==BattleType.guildTrials then
if t.protoCode==ProtoId.PRT_GUILD_TRIAL_FIGHT_REQ then
ModulesInit.GuildTrialsMgr:GoBack()
e.IsRespBattleInfo=false
end
elseif e.BattleType==BattleType.SpringRain then
if t.protoCode==ProtoId.PRT_SPRING_RAIN_FIGHT_REQ then
ModulesInit.ActSpringRainMgr:GoBack()
e.IsRespBattleInfo=false
end
elseif e.BattleType==BattleType.urBossFight then
if t.protoCode==ProtoId.PRT_UR_BOSS_FIGHT_REQ then
ModulesInit.ActURBossMgr:GoBack()
e.IsRespBattleInfo=false
end
elseif e.BattleType==BattleType.urTestFight then
if t.protoCode==ProtoId.PRT_UR_TEST_FIGHT_REQ then
ModulesInit.ActURTestMgr:GoBack()
e.IsRespBattleInfo=false
end
elseif e.BattleType==BattleType.Inspiration then
if t.protoCode==ProtoId.PRT_INSPIRATION_EVENT_FIGHT_REQ then
ModulesInit.InspirationMgr:GoBack()
e.IsRespBattleInfo=false
end
elseif e.BattleType==BattleType.lrBossFight then
if t.protoCode==ProtoId.PRT_UR2_BOSS_FIGHT_REQ then
ModulesInit.ActLRBossMgr:GoBack()
e.IsRespBattleInfo=false
end
elseif e.BattleType==BattleType.lrTestFight then
if t.protoCode==ProtoId.PRT_UR2_TEST_FIGHT_REQ then
ModulesInit.ActLRTestMgr:GoBack()
e.IsRespBattleInfo=false
end
end
end
function t.BattleBegin()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if e.curProcedureBattle then
e.curProcedureBattle:OnBattleStart()
end
e.CurrBattleBigRound=1
e.mBattle1V1SmallStartRound=0
e.isBattleEnd=false
e.CheckFirstAttackTeam()
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="BATTLE_READY"})
end
function t.CreateTreatureData()
e.OurTeam:AddTeamTreasure()
e.EnemyTeam:AddTeamTreasure()
end
function t.CheckFirstAttackTeam()
if(e.OurTeam==nil)then
return
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=e.GetOfficerData()
e.OurTeam:SetFirstAddRate(t.addFirstValue1)
e.EnemyTeam:SetFirstAddRate(t.addFirstValue2)
e.OurTeam:SetOfficer(t.officerTeam1)
e.EnemyTeam:SetOfficer(t.officerTeam2)
if e.FightPlayData==nil and e.FightBeforeData==nil
or e.BattleMode==EBattleMode.formation1v1 then
local t=e.OurTeam:GetFirst()
e.OurTeam.TotalFirstValue=t
local t=e.EnemyTeam:GetFirst()
e.EnemyTeam.TotalFirstValue=t
end
r=e.OurTeam:GetTotalFirstValueWithRate()
l=e.EnemyTeam:GetTotalFirstValueWithRate()
e.OurTeam:ShowFirst()
e.EnemyTeam:ShowFirst()
e.OurTeam.TeamId=1
e.EnemyTeam.TeamId=2
c=e.OurTeam:GetFighting()
u=e.EnemyTeam:GetFighting()
if(r>l)then
e.OurTeamFirstAttack=true
elseif(r<l)then
e.OurTeamFirstAttack=false
else
if r+l<=0 then
local t=RandomMgr:GetBattleRandomWithRange(0,100)
if t<50 then
e.OurTeamFirstAttack=true
else
e.OurTeamFirstAttack=false
end
else
local t=RandomMgr:GetBattleRandomWithRange(0,(r+l))
if(t<r)then
e.OurTeamFirstAttack=true
else
e.OurTeamFirstAttack=false
end
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrAttackTeam=e.OurTeamFirstAttack and e.OurTeam or e.EnemyTeam
e.CheckRelic()
if(GameInit.IsClient)and e.BattleType==BattleType.campaign and e.CurrBattleBigRound==1
and(ModulesInit.EarthMgr:GetCurRunningMapId()==11004)then
e.SetChaChaSureSmallSkill(true)
end
end
function t.GetOfficerData()
local i=0
local o=0
local t=0
local a=0
if d.CheckOpenOfficerInBattle()then
t=e.GetOfficerByTeamId(1)
a=e.GetOfficerByTeamId(2)
if t>a then
i=d.GetOfficerAddFirstValue(t)
elseif t<a then
o=d.GetOfficerAddFirstValue(a)
end
i=i/100
o=o/100
end
return{
officerTeam1=t,
officerTeam2=a,
addFirstValue1=i,
addFirstValue2=o,
}
end
function t.GetOfficerByTeamId(a)
local t
if(e.FightPlayData)then
t=e.FightPlayData
elseif(e.FightBeforeData)then
t=e.FightBeforeData
end
local e=0
if t then
if a==1 then
if t.ourExt then
e=t.ourExt.officer or 0
end
else
if t.enemyExt then
e=t.enemyExt.officer or 0
end
end
end
return e
end
function t.GetIsOurTeamAttack()
if(e.CurrAttackTeam and e.CurrAttackTeam.TeamId==1)then
return true
end
return false
end
function t.IsAttackTeam(t)
if(e.CurrAttackTeam and e.CurrAttackTeam.TeamId==t)then
return true
end
return false
end
function t.GetBattleTeamByTeamId(t)
if e.OurTeam and e.OurTeam.TeamId==t then
return e.OurTeam
elseif e.EnemyTeam and e.EnemyTeam.TeamId==t then
return e.EnemyTeam
end
end
function t.CheckRelic()
if(e.BattleType==BattleType.maze)then
e.BattleRoundRelic()
else
e.BattleFightSuppress()
end
end
function t.TriggerRelic(o)
if(e.willTriggerRelicDids)then
for a,t in ipairs(e.willTriggerRelicDids)do
local t=s:GetRelicCfg(t)
local a=ModulesInit.BattleRelicMgr.GetRelicScript(t.scriptId)
if(a.GetTriggerTime()==o)then
a.DoAction(e.OurTeam,t)
end
end
end
end
function t.GetRelicCountWithColor(a)
local t=0
if(e.relics)then
for o,e in ipairs(e.relics)do
local e=s:GetRelicCfg(e.relicDid)
if(e.color==a)then
t=t+1
end
end
end
return t
end
function t.GetFightWinNumber(t)
if(e.relics)then
for a,e in ipairs(e.relics)do
if(e.relicDid==t)then
return e.fightWinNumber
end
end
end
return 0
end
function t.BattleRoundRelic()
if(e.FightPlayData)then
if e.FightPlayData.ourExt then
e.dicePosition=e.FightPlayData.ourExt.dicePosition
e.relics=e.FightPlayData.ourExt.relics
end
if e.FightPlayData.enemyExt then
e.mazeAttribute=e.FightPlayData.enemyExt.attribute
else
e.mazeAttribute={}
end
elseif(e.FightBeforeData)then
if e.FightBeforeData.ourExt then
e.dicePosition=e.FightBeforeData.ourExt.dicePosition
e.relics=e.FightBeforeData.ourExt.relics
end
if e.FightBeforeData.enemyExt then
e.mazeAttribute=e.FightBeforeData.enemyExt.attribute
else
e.mazeAttribute={}
end
else
e.dicePosition=ModulesInit.MazeMgr.dicePosition
if(ModulesInit.MazeMgr.mazeInfo)then
e.relics=ModulesInit.MazeMgr.mazeInfo.relics
end
e.mazeAttribute=ModulesInit.ProcedureNormalBattle.ServerMonsterData.attribute
FightDataReportMgr:SetOurExt(e.relics,e.dicePosition,nil,nil)
FightDataReportMgr:SetEnemyExt(nil,nil,e.mazeAttribute,nil)
end
if(e.relics)then
for t,o in ipairs(e.relics)do
local a=s:GetRelicCfg(o.relicDid)
local t=ModulesInit.BattleRelicMgr.GetRelicScript(a.scriptId)
if(t)then
if(t.GetTriggerTime()==RelicTriggerTime.now)then

t.DoAction(e.OurTeam,a)
else
m(e.willTriggerRelicDids,o.relicDid)
end
end
end
end
if(e.mazeAttribute and#e.mazeAttribute>0)then
for a,t in ipairs(e.EnemyTeam.HeroCtrls)do
t:AddBuff(t,60118,-1,e.mazeAttribute)
end
end
e.BattleFightSuppress()
end
function t.GetFightSuppressAttr()
local a
local t
if(e.FightPlayData)then
if(e.FightPlayData.ourExt
and e.FightPlayData.ourExt.isSuppress==true
and e.FightPlayData.ourExt.suppressRatio
and e.FightPlayData.ourExt.playerLevel
)then
t=s:GetFightSuppress(e.BattleType,e.FightPlayData.ourExt.playerLevel,e.FightPlayData.ourExt.suppressRatio)
if(t)then
a=t.attr
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
elseif(e.FightBeforeData)then
if(e.FightBeforeData.ourExt
and e.FightBeforeData.ourExt.isSuppress==true
and e.FightBeforeData.ourExt.suppressRatio
and e.FightBeforeData.ourExt.playerLevel
)then
t=s:GetFightSuppress(e.BattleType,e.FightBeforeData.ourExt.playerLevel,e.FightBeforeData.ourExt.suppressRatio)
if(t)then
a=t.attr
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
else
if(e.BattleType==BattleType.campaign or e.BattleType==BattleType.elite)then
if(e.CurrDTMap.suppress==1)then
local o=PlayerMgr.PlayerInfo.level-e.CurrDTMap.proposalLv
FightDataReportMgr:SetOurExt(nil,nil,nil,o,PlayerMgr.PlayerInfo.level)
t=s:GetFightSuppress(e.BattleType,PlayerMgr.PlayerInfo.level,o)
if(t)then
a=t.attr
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
elseif(e.BattleType==BattleType.trial)then
if(e.CurrTowerRow.suppress==1)then
local o=math.max(OneMillion,math.floor((e.OurTeam:GetFighting()/e.CurrTowerRow.score)*OneMillion))
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
FightDataReportMgr:SetOurExt(nil,nil,nil,o,PlayerMgr.PlayerInfo.level)
t=s:GetFightSuppress(e.BattleType,PlayerMgr.PlayerInfo.level,o)
if(t)then
a=t.attr
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
end
return a
end
function t.BattleFightSuppress()
local t=e.GetFightSuppressAttr()
if(t)then
for a,e in ipairs(e.EnemyTeam.HeroCtrls)do
e:AddBuff(e,t[1],t[2],{t[3],t[4]})
end
end
if(not e.FightPlayData and e.FightBeforeData==nil)then
if(e.BattleType==BattleType.campaign
or e.BattleType==BattleType.elite
or e.BattleType==BattleType.trial
or e.BattleType==BattleType.thiefCrusade
or e.BattleType==BattleType.idle
)then
local t=ActMgr:CheckHeroBuffIsOpen()
local a=s:GetNewHeroBuffCfg(t)
if(a)then
local t=0
if(e.BattleType==BattleType.campaign)then
t=a.idleAtkBuff
elseif(e.BattleType==BattleType.elite)then
t=a.eliteBuff
elseif(e.BattleType==BattleType.trial)then
t=a.towerAtkBuff
elseif(e.BattleType==BattleType.thiefCrusade)then
t=a.crusadeAtkBuff
end
for a,e in ipairs(e.OurTeam.HeroCtrls)do
local t={buffId=99997,round=-1,overlap=1,args={t}}
table.add(e.enterBuffs,t)
FightDataReportMgr:AddOurHerosEnterBuffs(e.HeroId,t)
end
end
end
end
e.BattleRoundBeginAddTreasure()
end
function t.BattleRoundBeginAddTreasure()
local t=false
if(e.CurrMapsWavesIndex<=1)then
t=e.OurTeam:AddTreasure()
end
local a=e.EnemyTeam:AddTreasure()
if t==false then
t=a
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false and t)then
local t=ModulesInit.TimeActionMgr.CreateTimeAction()
e.AddTimer(t)
t:Init(
0,
b,
1,
nil,
nil,
function()
e.RemoveTimer(t)
e.BattleRoundBeginAddBuff()
end
):Run()
else
e.BattleRoundBeginAddBuff()
end
end
function t.BeginPetSkillAttack(t,a)
e.CurrAttackTeam:ResetPetRoundIsAttack(false)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrAttackTeam:BeginPetAttack(t,a)
end
function t.BattleRoundBeginPetHelpSkillComplete()
e.IsBattlePetAttacking=false
end
function t.SmallRoundStartTeamAttack(t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.SetSkillAttackType(EBattleSkillAttackType.SmallRoundStartTeamAttacking)
e.CurrAttackTeam:BeginTeamAttack(BuffTriggerTime.smallRoundStartTeamAttack)
end
function t.SmallRoundStartTeamAttackComplete()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.SetSkillAttackType(EBattleSkillAttackType.None)
e.BattleRoundBigSkill()
if(e.GetIsOurTeamAttack())then
e.CheckBattleRoundBigAndSmallSkillStatus()
e.framesAfterRefreshTipScale=0
e.framesAfterRefreshBlack=0
end
end
function t.BattleRoundBeginAddBuff()
if e.BgEffectMgr then
e.BgEffectMgr:SetAutoRunning(false)
end
if(e.coroutine_BattleRoundBeginAddBuff)then
h.stop(e.coroutine_BattleRoundBeginAddBuff)
e.coroutine_BattleRoundBeginAddBuff=nil
end
if(e.CurrMapsWavesIndex>1)then
e.IsBattleRoundBeginAddBuffing=false
e.coroutine_BattleRoundBeginAddBuff=h.start(
function()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
local t=true
if e.CurrAttackTeam.TeamId~=e.EnemyTeam.TeamId then
e.CurrAttackTeam=e.CurrAttackTeam.OpponentTeam
t=false
end
e.CurrAttackTeam.OnTeamBattleRoundBeginAddBuffComplete=function()
e.IsBattleRoundBeginAddBuffing=true
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrAttackTeam:BattleRoundBeginAddPetFrontBuff()
e.CurrAttackTeam:BattleRoundBeginAddFrontBuff()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.SetSkillAttackType(EBattleSkillAttackType.BattleBeginPetHelpSkillAttacking)
e.IsBattlePetAttacking=true
e.BeginPetSkillAttack()
if(not e.IsSkipBattle)then
coroutine.yield(WaitUntil(function()
return e.IsBattlePetAttacking==false
end))
end
e.SetSkillAttackType(EBattleSkillAttackType.None)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrAttackTeam:BattleRoundBeginAddAfterBuff()
e.ResortAndShowBgEffect()
if(not e.IsSkipBattle)then
coroutine.yield(WaitUntil(function()
return e.IsBattleRoundBeginAddBuffing
end))
end
if t==false then
e.CurrAttackTeam=e.CurrAttackTeam.OpponentTeam
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.BattleRoundBeginAddBuffComplete()
e.coroutine_BattleRoundBeginAddBuff=nil
end
)
return
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.IsBattleRoundBeginAddBuffing=false
e.coroutine_BattleRoundBeginAddBuff=h.start(
function()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrAttackTeam:BattleRoundBeginAddPetFrontBuff()
e.CurrAttackTeam:BattleRoundBeginAddFrontBuff()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrAttackTeam=e.CurrAttackTeam.OpponentTeam
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrAttackTeam:BattleRoundBeginAddPetFrontBuff()
e.CurrAttackTeam:BattleRoundBeginAddFrontBuff()
if(not e.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
end
e.CurrAttackTeam=e.CurrAttackTeam.OpponentTeam
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.SetSkillAttackType(EBattleSkillAttackType.BattleBeginPetHelpSkillAttacking)
e.IsBattlePetAttacking=true
e.BeginPetSkillAttack(BuffTriggerTime.battleBeginPetHelpSkill,true)
if(not e.IsSkipBattle)then
coroutine.yield(WaitUntil(function()
return e.IsBattlePetAttacking==false
end))
end
e.SetSkillAttackType(EBattleSkillAttackType.None)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrAttackTeam=e.CurrAttackTeam.OpponentTeam
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.IsBattlePetAttacking=true
e.SetSkillAttackType(EBattleSkillAttackType.BattleBeginPetHelpSkillAttacking)
e.BeginPetSkillAttack(BuffTriggerTime.battleBeginPetHelpSkill,true)
if(not e.IsSkipBattle)then
coroutine.yield(WaitUntil(function()
return e.IsBattlePetAttacking==false
end))
end
e.SetSkillAttackType(EBattleSkillAttackType.None)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrAttackTeam=e.CurrAttackTeam.OpponentTeam
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.IsBattleRoundBeginAddBuffing=false
e.CurrAttackTeam.OnTeamBattleRoundBeginAddBuffComplete=function()
e.IsBattleRoundBeginAddBuffing=true
end
e.CurrAttackTeam:BattleRoundBeginAddAfterBuff()
e.ResortAndShowBgEffect()
if(not e.IsSkipBattle)then
coroutine.yield(WaitUntil(function()
return e.IsBattleRoundBeginAddBuffing
end))
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrAttackTeam=e.CurrAttackTeam.OpponentTeam
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrAttackTeam.OnTeamBattleRoundBeginAddBuffComplete=function()
e.IsBattleRoundBeginAddBuffing=true
end
e.IsBattleRoundBeginAddBuffing=false
e.CurrAttackTeam:BattleRoundBeginAddAfterBuff()
e.ResortAndShowBgEffect()
if(not e.IsSkipBattle)then
coroutine.yield(WaitUntil(function()
return e.IsBattleRoundBeginAddBuffing
end))
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrAttackTeam=e.CurrAttackTeam.OpponentTeam
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.BattleRoundBeginAddBuffComplete()
e.coroutine_BattleRoundBeginAddBuff=nil
end
)
end
function t.BattleRoundBeginAddBuffComplete()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


e.OurTeam:PrintHerosState()

e.EnemyTeam:PrintHerosState()
end
if e.BgEffectMgr then
e.BgEffectMgr:SetAutoRunning(true)
end
e.BattleAllBigRoundBegin()
end
function t.BattleAllBigRoundBegin()
e.RefreshHeroHud()
e.coroutine_BattleAllBigRoundBegin=h.start(
function()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
local t=e.MaxBattleBigRound
if e.BattleMode==EBattleMode.formation1v1 then
t=e.MaxBattleBigRound*6
end
for t=1,t do
e.IsBattleBigAttacking=true
e.BattleBigRoundBegin()
if(not e.IsSkipBattle)then
coroutine.yield(WaitUntil(function()
return e.IsBattleBigAttacking==false
end))
end
if(e.isBattleEnd)then
return
end
e.CurrBattleBigRound=e.CurrBattleBigRound+1
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.FinalBattleEnd(BattleEndType.OverRound)
end)
end
function t.BattleBigRoundBegin()
if e.BattleMode~=EBattleMode.formation1v1 then
EventSystem.SendEvent(CommonEventId.OnBattleBigRoundBegin)
end
if(e.FightPlayData==nil)then
FightDataReportMgr:AddBattleBigRoundOnCurrWave(e.CurrBattleBigRound)
end
if(e.NextRoundChangeToManual)then
e.IsAutoMode=false
EventSystem.SendEvent(CommonEventId.OnNextRoundChangeToManual)
end
e.NextRoundChangeToManual=false
e.Explosiveing=false
e.SetSkillAttackType(EBattleSkillAttackType.None)
e.IsBattleSmallAttacking=false
e.CurrBattleSmallRound=0
e.CurrIsAttacking=false
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


if e.OurTeamFirstAttack then

else

end
end
e.OurTeam:SetCurrRoundCanTriggerSmallSkill()
e.EnemyTeam:SetCurrRoundCanTriggerSmallSkill()
e.OurTeam:ResetExplosiveState()
e.EnemyTeam:ResetExplosiveState()
e.OurTeam:ResetHerosRoundIsAttack(true)
e.EnemyTeam:ResetHerosRoundIsAttack(true)
e.OurTeam:ResetHerosRoundIsAttack(false)
e.EnemyTeam:ResetHerosRoundIsAttack(false)
e.BattleSmallRoundBegin()
end
function t.BattleSmallRoundBegin()
if(e.coroutine_BattleSmallRoundBegin)then
h.stop(e.coroutine_BattleSmallRoundBegin)
e.coroutine_BattleSmallRoundBegin=nil
end
e.coroutine_BattleSmallRoundBegin=h.start(
function()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
e.IsBattleSmallAttacking=true

e.BattleRoundCheckResurgence()
if(not e.IsSkipBattle)then
coroutine.yield(WaitUntil(function()
return e.IsBattleSmallAttacking==false
end))
coroutine.yield(WaitUntil(function()
return Time.time>e.DyingStateHeroLastTime
end))
end
if(e.BattleType==BattleType.skillPreview)then
coroutine.yield(CS.UnityEngine.WaitForSeconds(1.5))
end
if(e.isBattleEnd)then
return
end
if(e.TestBattleType==0)then
e.CurrAttackTeam=e.CurrAttackTeam.OpponentTeam
e.CurrAttackTeam:SetCurrRoundCanTriggerSmallSkill()
e.CheckShowBattleTip(false)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="BATTLE_SMALL_ROUND_END"})
if GameInit.IsClient and ModulesInit.GuideMgr.isGuide and ModulesInit.GuideMgr.guideId==ModulesInit.GuideMgr.SpeacalId.ThrBattleBigSkill then
coroutine.yield(CS.UnityEngine.WaitForSeconds(2))
end
e.IsBattleSmallAttacking=true


e.BattleRoundCheckResurgence()
if(not e.IsSkipBattle)then
coroutine.yield(WaitUntil(function()
return e.IsBattleSmallAttacking==false
end))
coroutine.yield(WaitUntil(function()
return Time.time>e.DyingStateHeroLastTime
end))
end
e.CurrAttackTeam=e.CurrAttackTeam.OpponentTeam

e.SetSkillAttackType(EBattleSkillAttackType.PetFightSkillAttacking)
e.IsBattlePetAttacking=true

e.BeginPetSkillAttack()
if(not e.IsSkipBattle)then
coroutine.yield(WaitUntil(function()
return e.IsBattlePetAttacking==false
end))
end
if(e.isBattleEnd)then
return
end
e.CurrAttackTeam=e.CurrAttackTeam.OpponentTeam
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.IsBattlePetAttacking=true


e.BeginPetSkillAttack()
if(not e.IsSkipBattle)then
coroutine.yield(WaitUntil(function()
return e.IsBattlePetAttacking==false
end))
end
e.CurrAttackTeam=e.CurrAttackTeam.OpponentTeam

e.BattleBigRoundEnd()
end
end)
end
function t.PetFightSkillComplete()
if(e.CheckBattleEnd())then
e.BattleEnd()
return
end
e.IsBattlePetAttacking=false
end
function t.BattleRoundCheckResurgence()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if e.BattleMode==EBattleMode.formation1v1 then
if e.CurrAttackTeam:GetAllHerosCount()>0 and e.CurrAttackTeam.OpponentTeam:GetAllHerosCount()>0 then
e.mBattle1V1SmallStartRound=e.mBattle1V1SmallStartRound+1
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
EventSystem.SendEvent(CommonEventId.OnBattle1v1RoundChange)
end
end
local t=e.CurrAttackTeam:ResurgenceHero()
local a=#t
if(a>0)then
if(e.CurrAttackTeam.TeamId==2)then
e.SelectFireHero=nil
e.AutoSelectFireHero()
end
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="HERO_RELIVE"})
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false and e.IsOpenReliveAnim==true)then
for a,t in ipairs(t)do
if e.BattleType==BattleType.idle then
local e=t.HeroBattleInfo.MaxHP
e=math.floor(e)
t:HpHealthWithResurgence(e)
t.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.NormalIdle
t:ChangeStateUnCheckState(HeroState.Idle)
end
local e=t.transform.position
GameEntry.Effect:ShowEffect(SysEffectId.ResurgenceHeroEffect,
EffectKeepType.AutoRelease,e.x,e.y,e.z)
end
ModulesInit.BattleSkillEffectManager.ChangeBGColorFadeIn(Color.clear,Color(0,0,0,150/255),0.2)
local t=ModulesInit.TimeActionMgr.CreateTimeAction()
e.AddTimer(t)
t:Init(
1.3,
0,
1,
nil,
nil,
function()
e.RemoveTimer(t)
ModulesInit.BattleSkillEffectManager.ChangeBGColorFadeIn(Color(0,0,0,150/255),Color.clear,0.2)
e.BattleRoundCheckResurgenceComplete()
end
):Run()
else
e.BattleRoundCheckResurgenceComplete()
end
else
e.BattleRoundCheckResurgenceComplete()
end
end
function t.BattleRoundCheckResurgenceComplete()
if e.OurTeam==nil then
return
end
e.CurrBattleSmallRound=e.CurrBattleSmallRound+1
if(e.FightPlayData==nil)then
FightDataReportMgr:AddBattleSmallRoundOnCurrWave(e.CurrBattleSmallRound)
end
local t=e.StartBackToBattleField()
local a=e.StartSupplementPosition(t)
if a==false then
if t and ModulesInit.ProcedureNormalBattle.IsSkipBattle==false then
local t=ModulesInit.TimeActionMgr.CreateTimeAction()
e.AddTimer(t)
t:Init(
0,
ConstBattleRunInBattleDuration,
1,
nil,
nil,
function()
e.RemoveTimer(t)
e.SupplementPositionComplete()
end
):Run()
else
e.SupplementPositionComplete()
end
end
for t,e in pairs(e.HeroDic)do
e.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
end
end
function t.StartBackToBattleField()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=false
if e.CurrAttackTeam and e.CurrAttackTeam.TeamId and e.CurrAttackTeam.TeamId~=0 then
t=e.CurrAttackTeam:StartBackToBattleField()
end
return t
end
function t.SupplementPositionComplete()
if e.CurrAttackTeam.OpponentTeam:GetAllHerosCount()<=0 then
e.IsBattleSmallAttacking=false
else
e.BattleRoundBeginAddAfterBuff()
end
end
function t.StartSupplementPosition(o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=nil
if e.CurrAttackTeam and e.CurrAttackTeam.TeamId then
t=e.CurrAttackTeam.TeamId
end
local a=false
if t~=nil then
a=e.StartSupplementWithTeam(t,o)
end
return a
end
function t.StartSupplementWithTeam(n,s)
local a=false
local t=e.GetTeamFormation()
local i=t.ourTeamFormation
local r=t.ourTeamFormationAlter
local o=t.enemyTeamFormation
local h=t.enemyTeamFormationAlter
local t=e.GetTeamHerosByTeamId(n)
if n==1 then
if i then
a=e.StartSupplementPositionWithData(e.OurTeam,i,t,r,s)
end
else
if o then
a=e.StartSupplementPositionWithData(e.EnemyTeam,o,t,h,s)
end
end
return a
end
function t.StartSupplementPositionWithData(t,a,o,n,i)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(t:GetSuppleHeroCount()==0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
if(t:GetAllHerosCount()==e.GetOpenPositionCount())then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if e.BattleMode==EBattleMode.formation1v1 then
e.mBattle1V1SmallStartRound=1
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
EventSystem.SendEvent(CommonEventId.OnBattle1v1RoundChange)
end
t:SupplementPosition(a,o,n,i)
return true
end
function t.StartSupplementFightSuppress()
if e.GetIsOurTeamAttack()==false then
local t=e.GetFightSuppressAttr()
if(t)then
for a,e in ipairs(e.EnemyTeam.HeroCtrls)do
if e.IsBattleRoundBeginAddBuffing then
e:AddBuff(e,t[1],t[2],{t[3],t[4]})
end
end
end
end
e.StartSupplementBeginAddTreasure()
end
function t.StartSupplementBeginAddTreasure()
local t=e.CurrAttackTeam:AddTreasure()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false and t)then
local t=ModulesInit.TimeActionMgr.CreateTimeAction()
e.AddTimer(t)
t:Init(
0,
b,
1,
nil,
nil,
function()
e.RemoveTimer(t)
e.StartSupplementBeginAddFrontBuff()
end
):Run()
else
e.StartSupplementBeginAddFrontBuff()
end
end
function t.StartSupplementBeginAddFrontBuff()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrAttackTeam:BattleRoundBeginAddFrontBuff()
ModulesInit.ProcedureNormalBattle.BattleRoundBeginAddAfterBuff()
end
function t.BattleRoundBeginAddAfterBuff()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(e.coroutine_BattleRoundBeginAddAfterBuff)then
h.stop(e.coroutine_BattleRoundBeginAddAfterBuff)
e.coroutine_BattleRoundBeginAddAfterBuff=nil
end
e.IsBattleRoundBeginAddAfterBuffing=false
e.coroutine_BattleRoundBeginAddAfterBuff=h.start(
function()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
e.CurrAttackTeam.OnTeamBattleRoundBeginAddBuffComplete=function()
e.IsBattleRoundBeginAddAfterBuffing=true
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrAttackTeam:BattleRoundBeginAddAfterBuff()
if(not e.IsSkipBattle)then
coroutine.yield(WaitUntil(function()
return e.IsBattleRoundBeginAddAfterBuffing
end))
end
e.IsBattleRoundBeginAddAfterBuffing=false
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.ProcedureNormalBattle.BattleRoundBeginCheckBuff()
e.coroutine_BattleRoundBeginAddAfterBuff=nil
end
)
end
function t.GetOpenPositionCount()
local t=0
for a=1,#e.OpenPosition do
if e.OpenPosition[a]==true then
t=t+1
end
end
return t
end
function t.IsOpenPosition(t)
return e.OpenPosition[t]==true
end
function t.GetTeamFormation()
local i
local o
if e.FightPlayData then
i=e.FightPlayData.ourTeamFormation
o=e.FightPlayData.ourTeamFormationAlter
elseif e.FightBeforeData then
i=e.FightBeforeData.ourTeamFormation
o=e.FightBeforeData.ourTeamFormationAlter
end
local t
local a
if e.FightPlay_CurrWave then
t=e.FightPlay_CurrWave.enemyTeamFormation
a=e.FightPlay_CurrWave.enemyTeamFormationAlter
elseif e.FightBefore_CurrWave then
t=e.FightBefore_CurrWave.enemyTeamFormation
a=e.FightBefore_CurrWave.enemyTeamFormationAlter
end
return{
ourTeamFormation=i,
ourTeamFormationAlter=o,
enemyTeamFormation=t,
enemyTeamFormationAlter=a,
}
end
function t.GetTeamHerosByTeamId(t)
if t==1 then
local t
if e.FightPlayData then
t=e.FightPlayData.ourHeros
elseif e.FightBeforeData then
t=e.FightBeforeData.ourHeros
end
return t
else
local t
if e.FightPlay_CurrWave then
t=e.FightPlay_CurrWave.enemyHeros
elseif e.FightBefore_CurrWave then
t=e.FightBefore_CurrWave.enemyHeros
end
return t
end
end
function t.IsOurTeam(e)
if e==1 then
return true
else
return false
end
end
function t.BattleRoundBeginCheckBuff()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
EventSystem.SendEvent(CommonEventId.OnBattleRoundBeginCheckBuff,e.CurrAttackTeam.TeamId)
e.CurrAttackTeam:BattleRoundBeginAddFuryWithSoul()
local t=e.CurrAttackTeam:BattleRoundBeginCheckBuff()
if t and t>0 then
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local a=ModulesInit.TimeActionMgr.CreateTimeAction()
e.AddTimer(a)
a:Init(
0,
t,
1,
nil,
nil,
function()
e.RemoveTimer(a)
e.CheckIsOurTeamAtkAfterBattleRoundBeginCheckBuff()
end
):Run()
else
e.CheckIsOurTeamAtkAfterBattleRoundBeginCheckBuff()
end
else
e.CheckIsOurTeamAtkAfterBattleRoundBeginCheckBuff()
end
end
function t.CheckIsOurTeamAtkAfterBattleRoundBeginCheckBuff()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(e.GetIsOurTeamAttack())then
e.BattleRoundBeginChangeToIdle()
else
e.BattleRoundBeginChangeToIdle()
end
else
e.BattleRoundBeginChangeToIdle()
end
end
function t.BattleRoundBeginChangeToIdle()
if(e.CurrBattleRow.poseChange==0 and not e.GetIsOurTeamAttack())then
e.BattleRoundExplosive()
return
end
if(e.GetIsOurTeamAttack())then
if e.BattleType~=BattleType.idle or e.IsFightPlay then
if(not e.IsBattleBeginEffect and e.IsOpenShowHeadContainer==true)then
e.OurTeam:ShowOrHideBattleBeginEffect()
end
e.OurTeam:HideHeadMask()
end
end
local a=e.CurrAttackTeam:GetMaxChangeToIdleNeedTime()
e.CurrAttackTeam:ChangeToIdle(ChangeToIdleType.ChangeToFightIdle,function()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local t=ModulesInit.TimeActionMgr.CreateTimeAction()
e.AddTimer(t)
t:Init(
a,
0,
1,
nil,
nil,
function()
e.RemoveTimer(t)
e.BattleRoundExplosive()
end
):Run()
else
e.BattleRoundExplosive()
end
end)
end
function t.CheckBattleRoundBigAndSmallSkillStatus()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.OurTeam:CheckBattleRoundBigAndSmallSkillStatus()
end
function t.SkipBattle()
e.IsSkipBattle=true
e.ChangeToAuto(false)
end
function t.SetSkipBattle(t)
e.IsSkipBattle=t
end
function t.LoadAutoMode()
if PlayerMgr.PlayerInfo and PlayerMgr.PlayerInfo.uid then
local t=string.format("%d_AutoBattle%s",PlayerMgr.PlayerInfo.uid,e.BattleType)
if(SaveMgr.GetPlayerPrefsHasKey(t))then
e.IsAutoMode=SaveMgr.GetBoolForKey(t)
end
end
end
function t.ChangeToAuto(t)
e.IsAutoMode=true
e.NextRoundChangeToManual=false
e.SelectFireHero=nil
e.HideFireEffect()
if(t)then
SaveMgr.SetBoolForKey(string.format("%d_AutoBattle%s",PlayerMgr.PlayerInfo.uid,e.BattleType),true)
end
if(e.IsSkipBattle==false)then
EventSystem.SendEvent(CommonEventId.OnNormalBattle_ShowAutoTip,true)
end
if(not e.CurrIsAttacking and e.Explosiveing and e.GetIsOurTeamAttack())then
elseif(not e.CurrIsAttacking and e.IsSkillAttackType(EBattleSkillAttackType.BigSkillAttacking)and e.GetIsOurTeamAttack())then
e.BattleRounding=true
e.CurrAttackTeam:BeginHeroBigAttack()
elseif(not e.CurrIsAttacking and e.IsSkillAttackType(EBattleSkillAttackType.SmallSkillAttacking)and e.GetIsOurTeamAttack())then
e.BattleRounding=true
e.CurrAttackTeam:BeginHeroNormalAttack()
end
e.SetHeadIconTipScale(false)
e:SetGuideScaleView(false)
end
function t.ChangeToManual()
SaveMgr.SetBoolForKey(string.format("%d_AutoBattle%s",PlayerMgr.PlayerInfo.uid,e.BattleType),false)
if(e.NextRoundChangeToManual)then
EventSystem.SendEvent(CommonEventId.OnNormalBattle_ShowAutoTip,false)
return
end
if(e.BattleRounding)then
e.NextRoundChangeToManual=true
EventSystem.SendEvent(CommonEventId.OnNormalBattle_ShowAutoTip,false)
else
ModulesInit.ProcedureNormalBattle.IsAutoMode=false
end
e:CheckSetReadyHeadIconTipScale()
end
function t.BattleRoundExplosive()
if(e.OurTeam==nil)then
return
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.BattleRounding=true
e.Explosiveing=true
if(e.FightPlayData)then
e.CurrAttackTeam:BattleRoundBeginExplosive_FightPlay()
else
e.CurrAttackTeam:BattleRoundBeginExplosive()
end
end
function t.BattleRoundExplosiveComplete()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.Explosiveing=false
if(e.CurrAttackTeam:HasCanAttackHero()==false)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrAttackTeam:HideAllEffectStatusAndShowMask()
e.BattleRoundEndCheckBuff()
return
end
e.SmallRoundStartTeamAttack()
end
function t:SetHeadIconTipScale(t)
e.framesAfterRefreshTipScale=-1
if e.GetIsOurTeamAttack()then
if e.OurTeam then
e.OurTeam:SetHeadIconTipScale(t)
end
end
end
function t:SetGuideScaleView(t)
if(GameInit.IsClient)and(e.BattleType==BattleType.campaign or e.BattleType==BattleType.guide)and
ModulesInit.GuideMgr.isGuide and ModulesInit.GuideMgr:GetBattlleBlackShow()then
e.framesAfterRefreshBlack=-1
EventSystem.SendEvent(CommonEventId.OnSendBattleFouces,{isOpen=t})
else
e.framesAfterRefreshBlack=0
end
end
function t:CheckSetReadyHeadIconTipScale()
if e.OurTeam==nil or e.CurrAttackTeam==nil then
return
end
if e.IsAutoMode==false
and e.IsSkipBattle==false
and e.GetIsOurTeamAttack()
and(e.OurTeam:CheckHasCanBigAttackHero()or e.OurTeam:CheckHasCanNormalAttackHero())
then
e.framesAfterRefreshTipScale=0
end
end
function t:OnUpdate()
if e.framesAfterRefreshTipScale>=0 then
e.framesAfterRefreshTipScale=e.framesAfterRefreshTipScale+1
if e.framesAfterRefreshTipScale>e.MAX_FRAMES_TIP_SCALE then
e:SetHeadIconTipScale(true)
end
end
if e.framesAfterRefreshBlack>=0 then
e.framesAfterRefreshBlack=e.framesAfterRefreshBlack+1
if e.framesAfterRefreshBlack>e.MAX_FRAMES_BLACK then
e.framesAfterRefreshBlack=0
e:SetGuideScaleView(true)
end
end
if GameInit.IsClient then
if p==true then
if PlayerMgr and PlayerMgr.loginComplete then
EnterGameMgr:DoEnterGame()
p=false
end
end
if e.BgEffectMgr then
e.BgEffectMgr:OnUpdate()
end
end
end
function t.StartAttackTask(a,i)
e.StopAttackTaskCoroutine()
e.coroutine_AttackTask=h.start(
function()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(CS.UnityEngine.UnityEngine.WaitForEndOfFrame)
end
local o,t
if a then
local t={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
if e.CurrAttackTeam and e.CurrAttackTeam.OpponentTeam then
e.CurrAttackTeam:TriggerAllBuff(a,nil,nil,t)
e.CheckStartTask()
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(WaitUntil(function()
if ModulesInit.ProcedureNormalBattle.AttackTaskMgr then
return ModulesInit.ProcedureNormalBattle.AttackTaskMgr:IsWork()==false
else
return true
end
end))
end
end
end
if a==nil or i==true then
for a=1,36 do
if e.CurrAttackTeam==nil or e.CurrAttackTeam.CurrAttackHeroIndex==nil then
if GameInit.IsClient then
local e="CurrAttackHeroIndex is null. battletype = "..tostring(e.BattleType).." battleEnd = "..tostring(e.isBattleEnd).." isAlreadyShowBattleEnd = "..tostring(e.isAlreadyShowBattleEnd)
ErrInfoCollectMgr:AddInfo("BattleStartAttackTask","",e)
GameEntry.LogError("BattleFix StartAttackTask == nil")
end
end
o,t=e.GetAttackTask()
if t==nil then
break
end
e.AddAttackTask(t)
local a,t=e.GetNextWillAttackTask()
if t and not a then
e.AddNextSkillRes(t)
end
if(not ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
coroutine.yield(WaitUntil(function()
if ModulesInit.ProcedureNormalBattle.AttackTaskMgr then
return ModulesInit.ProcedureNormalBattle.AttackTaskMgr:IsWork()==false
else
return true
end
end))
end
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
break
end
end
end
if ModulesInit.ProcedureNormalBattle.isBattleEnd==false then
if e.IsSkillAttackType(EBattleSkillAttackType.BattleBeginPetHelpSkillAttacking)then
e.BattleRoundBeginPetHelpSkillComplete()
elseif e.IsSkillAttackType(EBattleSkillAttackType.PetFightSkillAttacking)then
e.PetFightSkillComplete()
elseif e.IsSkillAttackType(EBattleSkillAttackType.SmallRoundEndPetHelpSkillAttacking)then
e.SmallRoundEndPetHelpSkillComplete()
elseif e.IsSkillAttackType(EBattleSkillAttackType.SmallRoundStartTeamAttacking)then
e.SmallRoundStartTeamAttackComplete()
else
if o==true then
if e.IsSkillAttackType(EBattleSkillAttackType.BigSkillAttacking)then
e.HandleBigAttackManualComplete()
elseif e.IsSkillAttackType(EBattleSkillAttackType.SmallSkillAttacking)then
e.HandleNormalAttackManualComplete()
end
else
if e.IsSkillAttackType(EBattleSkillAttackType.BigSkillAttacking)then
ModulesInit.ProcedureNormalBattle.BattleRoundNormalSkill()
elseif e.IsSkillAttackType(EBattleSkillAttackType.SmallSkillAttacking)then
ModulesInit.ProcedureNormalBattle.BattleRoundEndCheckBuff()
end
end
end
end
end
)
end
function t.StopAttackTaskCoroutine()
if(e.coroutine_AttackTask)then
h.stop(e.coroutine_AttackTask)
e.coroutine_AttackTask=nil
end
end
function t.Stop1v1MaxTurnCoroutine()
if(e.coroutine_1v1MaxTurn)then
h.stop(e.coroutine_1v1MaxTurn)
e.coroutine_1v1MaxTurn=nil
end
end
function t.AddAttackTask(t)
if e.AttackTaskMgr then
e.AttackTaskMgr:AddTask(t)
end
end
function t.CheckStartTask()
if e.AttackTaskMgr then
e.AttackTaskMgr:CheckStartTask()
end
end
function t.GetAttackTaskBySkillDidAndHeroId(t,a,o)
if e.AttackTaskMgr then
return e.AttackTaskMgr:GetAttackTaskBySkillDidAndHeroId(t,a,o)
end
return nil
end
function t.GetAttackTaskBySkillDidAndTeamId(t,a)
if e.AttackTaskMgr then
return e.AttackTaskMgr:GetAttackTaskBySkillDidAndTeamId(t,a)
end
return nil
end
function t.ResumeAttackTask()
if e.AttackTaskMgr then
e.AttackTaskMgr:Resume()
end
end
function t.ShowBgEffect(t)
if e.BgEffectMgr then
e.BgEffectMgr:ShowBgEffect(t)
end
end
function t.HideBgEffect(t)
if e.BgEffectMgr then
e.BgEffectMgr:HideBgEffect(t)
end
end
function t.SetEffectMaterialPropertyFloat(o,t,a)
if e.BgEffectMgr then
e.BgEffectMgr:SetEffectMaterialPropertyFloat(o,t,a)
end
end
function t.ResortAndShowBgEffect()
if e.BgEffectMgr then
e.BgEffectMgr:ResortAndShowBgEffect()
end
end
function t.SetCurBgEffectAnimRun(t)
if e.BgEffectMgr then
e.BgEffectMgr:SetCurBgEffectAnimRun(t)
end
end
function t.SetCurEffectAnimIdle()
if e.BgEffectMgr then
e.BgEffectMgr:SetCurEffectAnimIdle()
end
end
function t.HandleBigAttackManualComplete()
e.OurTeam:CheckBattleEndWhenBigAttackManual()
end
function t.HandleNormalAttackManualComplete()
e.OurTeam:HandleNormalAttackManualComplete()
end
function t.HandleAttackTaskComplete()
if e.isAlreadyShowBattleEnd==true or e.isBattleEnd==true then
return
end
end
function t.GetAttackTask()
local t=nil
if e.IsSkillAttackType(EBattleSkillAttackType.BattleBeginPetHelpSkillAttacking)then
t=e.CurrAttackTeam:GetPetAttackTask(BuffTriggerTime.battleBeginPetHelpSkill)
return false,t
elseif e.IsSkillAttackType(EBattleSkillAttackType.PetFightSkillAttacking)then
t=e.CurrAttackTeam:GetPetAttackTask(BuffTriggerTime.bigRoundEndPetFightSkill)
return false,t
elseif e.IsSkillAttackType(EBattleSkillAttackType.SmallRoundEndPetHelpSkillAttacking)then
t=e.CurrAttackTeam:GetPetAttackTask(BuffTriggerTime.smallRoundEndPetHelpSkill)
return false,t
elseif e.IsSkillAttackType(EBattleSkillAttackType.BigSkillAttacking)then
if e.FightPlayData then
t=e.CurrAttackTeam:GetBigAttackTaskFightPlay()
return false,t
elseif GameInit.DebugLog and e.IsOpenReadOperCommond then
t=e.CurrAttackTeam:GetBigAttackTaskFightPlay()
return false,t
else
if e.GetIsOurTeamAttack()and e.IsAutoMode==false then
return true,e.CurrAttackTeam:PickBigAttackManualTask()
else
t=e.CurrAttackTeam:GetBigAttackTask()
return false,t
end
end
elseif e.IsSkillAttackType(EBattleSkillAttackType.SmallSkillAttacking)then
if(e.FightPlayData)then
t=e.CurrAttackTeam:GetNormalAttackTaskFightPlay()
return false,t
elseif GameInit.DebugLog and e.IsOpenReadOperCommond then
t=e.CurrAttackTeam:GetNormalAttackTaskFightPlay()
return false,t
else
if e.GetIsOurTeamAttack()and e.IsAutoMode==false then
t=e.CurrAttackTeam:GetHandNormalAttackTask()
return true,t
else
t=e.CurrAttackTeam:GetNormalAttackTask()
return false,t
end
end
end
end
function t.GetNextWillAttackTask()
local t=nil
if e.IsSkillAttackType(EBattleSkillAttackType.BigSkillAttacking)then
if e.FightPlayData then
t=e.CurrAttackTeam:GetNextWillBigAttackTaskFightPlay()
return false,t
elseif GameInit.DebugLog and e.IsOpenReadOperCommond then
t=e.CurrAttackTeam:GetNextWillBigAttackTaskFightPlay()
return false,t
else
if e.GetIsOurTeamAttack()and e.IsAutoMode==false then
return true,e.CurrAttackTeam:GetNextWillBigAttackManualTask()
else
t=e.CurrAttackTeam:GetBigAttackTask()
return false,t
end
end
elseif e.IsSkillAttackType(EBattleSkillAttackType.SmallSkillAttacking)then
if(e.FightPlayData)then
t=e.CurrAttackTeam:GetNextWillNormalAttackTaskFightPlay()
return false,t
elseif GameInit.DebugLog and e.IsOpenReadOperCommond then
t=e.CurrAttackTeam:GetNextWillNormalAttackTaskFightPlay()
return false,t
else
if e.GetIsOurTeamAttack()and e.IsAutoMode==false then
t=e.CurrAttackTeam:GetNextHandNormalAttackTask()
return true,t
else
t=e.CurrAttackTeam:GetNormalAttackTask()
return false,t
end
end
end
end
function t.BattleRoundBigSkill()
if(e.OurTeam==nil)then
return
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(e.CurrAttackTeam.OpponentTeam:IsAllFreeze())then
e.BattleRoundEndCheckBuff()
return
end
e.SetSkillAttackType(EBattleSkillAttackType.BigSkillAttacking)
if(e.FightPlayData)then
e.CurrAttackTeam:BeginHeroBigAttack_FightPlay()
elseif GameInit.DebugLog and e.IsOpenReadOperCommond then
e.CurrAttackTeam:BeginHeroBigAttack_FightPlay()
elseif e.BattleType==BattleType.skillPreview then
ModulesInit.BattlePreviewMgr:StartExcutePreview()
else
if(e.GetIsOurTeamAttack())then
if(not e.IsAutoMode)then
e.AutoSelectFireHero()
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="BIG_ATTACK_START_SUC"})
if(not e.CurrAttackTeam:HasCanBigAttackHero())then
e.BattleRoundNormalSkill()
else
e.CheckShowBattleTip(true,"bigSkill")
end
else
e.CurrAttackTeam:BeginHeroBigAttack()
end
else
e.CurrAttackTeam:BeginHeroBigAttack()
end
end
end
function t.EnterBattleRoundNormalSkill()
if(e.IsSkillAttackType(EBattleSkillAttackType.SmallSkillAttacking))then
return
end
if(e.FightPlayData==nil)then
e.CheckShowBattleTip(true,"normalSkill")
end
e.SetSkillAttackType(EBattleSkillAttackType.SmallSkillAttacking)
e.OurTeam:HideBigSkillStatus()
e.OurTeam:ResetHerosRoundIsAttack(false)
end
function t.CheckShowBattleTip(t,a)
if t then
if ModulesInit.ProcedureNormalBattle.IsSkipBattle==false
and e.GetIsOurTeamAttack()
and e.CurrAttackTeam:HasCanAttackHero()
and e.CurrAttackTeam.OpponentTeam:IsAllFreeze()==false
and e.IsOpenShowHeadContainer==true
then
EventSystem.SendEvent(CommonEventId.OnEventShowBattleTip,{isOpen=true,battleState=a})
end
else
EventSystem.SendEvent(CommonEventId.OnEventShowBattleTip,{isOpen=false})
end
end
function t.BattleRoundNormalSkill()
if(e.FightPlayData)then
e.EnterBattleRoundNormalSkill()
else
e.CheckShowBattleTip(true,"normalSkill")
end
e.SetSkillAttackType(EBattleSkillAttackType.SmallSkillAttacking)
e.OurTeam:ResetHerosRoundIsAttack(false)
e.EnemyTeam:ResetHerosRoundIsAttack(false)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(e.CurrAttackTeam.OpponentTeam:IsAllFreeze())then
e.BattleRoundEndCheckBuff()
return
end
if(e.FightPlayData)then
e.CurrAttackTeam:BeginHeroNormalAttack_FightPlay()
elseif GameInit.DebugLog and e.IsOpenReadOperCommond then
e.CurrAttackTeam:BeginHeroNormalAttack_FightPlay()
else
if(e.GetIsOurTeamAttack())then
if(not e.IsAutoMode)then
if(not e.CurrAttackTeam:CheckHasCanNormalAttackHero())then
e.BattleRoundEndCheckBuff()
end
else
e.CurrAttackTeam:BeginHeroNormalAttack()
end
else
e.CurrAttackTeam:BeginHeroNormalAttack()
end
end
end
function t.BattleRoundEndCheckBuff()
e.CurrAttackTeam:HideAllEffectStatusAndShowMask()
e.SetSkillAttackType(EBattleSkillAttackType.None)
e.BattleRounding=false
if(e.isBattleEnd)then
e.BattleRoundEndCheckBuffComplete()
return
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
EventSystem.SendEvent(CommonEventId.OnBattleRoundEndCheckBuff,e.CurrAttackTeam.TeamId)
local t=e.CurrAttackTeam:BattleRoundEndCheckBuff()
if e.OurTeam then
e.OurTeam:CheckSpecialBuffRound()
end
if e.EnemyTeam then
e.EnemyTeam:CheckSpecialBuffRound()
end
for t,e in pairs(e.HeroDic)do
e.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
end
if(t)then
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local t=ModulesInit.TimeActionMgr.CreateTimeAction()
e.AddTimer(t)
t:Init(
0,
1,
1,
nil,
nil,
function()
e.RemoveTimer(t)
e.BattleRoundEndCheckBuffComplete()
end
):Run()
else
e.BattleRoundEndCheckBuffComplete()
end
else
e.BattleRoundEndCheckBuffComplete()
end
end
function t.BattleRoundEndCheckBuffComplete()
if(ModulesInit.ProcedureNormalBattle.CheckBattleEnd())then
ModulesInit.ProcedureNormalBattle.BattleSmallRoundReadyEnd()
return
end
e.BattleSmallRoundEndPetHelpSkillAttack()
end
function t.BattleSmallRoundEndPetHelpSkillAttack()
e.SetSkillAttackType(EBattleSkillAttackType.SmallRoundEndPetHelpSkillAttacking)
e.BeginPetSkillAttack(BuffTriggerTime.smallRoundEndPetHelpSkill,true)
end
function t.SmallRoundEndPetHelpSkillComplete()
e.BattleSmallRoundReadyEnd()
end
function t.BattleSmallRoundReadyEnd()
e.SetSkillAttackType(EBattleSkillAttackType.None)
e.TriggerRelic(RelicTriggerTime.eachRoundEnd)
if e.BattleMode==EBattleMode.formation1v1 then
e.BattleCheck1v1MaxTurn()
else
e.BattleSmallRoundEnd()
end
end
function t.IsLastWave()
if e.CurrMapsWavesIndex==e.MaxMapsWave then
return true
end
return false
end
function t.BattleSmallRoundEnd()
if(e.CheckBattleEnd())then
e.BattleEnd()
return
end
e.IsBattleSmallAttacking=false
end
function t.BattleCheck1v1MaxTurn()
local t=e.OurTeam:IsAllDeath()
local a=e.EnemyTeam:IsAllDeath()
if t==false and a==false and e.mBattle1V1SmallStartRound>=e.MaxBattleBigRound*2 then
e.mBattle1V1SmallStartRound=0
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local a,t=e.CalculateBattleResultOnOverRound()
local t
if a then
t=e.EnemyTeam
else
t=e.OurTeam
end
if t then
e.Stop1v1MaxTurnCoroutine()
e.coroutine_1v1MaxTurn=h.start(
function()
EventSystem.SendEvent(CommonEventId.OnShowBattleTurnOver,true)
if not ModulesInit.ProcedureNormalBattle.IsSkipBattle then
coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
end
local a=t:HeroLeaveBattle()
if a and not ModulesInit.ProcedureNormalBattle.IsSkipBattle then
coroutine.yield(CS.UnityEngine.WaitForSeconds(2))
end
EventSystem.SendEvent(CommonEventId.OnShowBattleTurnOver,false)
t:AllHeroDead()
e.BattleSmallRoundEnd()
e.coroutine_1v1MaxTurn=nil
end
)
else
e.BattleSmallRoundEnd()
end
else
e.BattleSmallRoundEnd()
end
end
function t.BattleBigRoundEnd()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then
if(e.CurrAttackTeam)then

end

end
e.IsBattleBigAttacking=false
end
function t.RefreshHeroHud()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
for t,e in pairs(e.HeroDic)do
e:RefreshHeroHud()
end
end
function t.CheckBattleEnd()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


e.OurTeam:PrintHerosState()

e.EnemyTeam:PrintHerosState()
end
if(e.isBattleEnd)then
return true
end
if e.BattleMode==EBattleMode.formation1v1 then
return e.CheckBattleEndWithDead()
else
if e.IsLastWave()then
return e.CheckBattleEndContainTomb()
else
return e.CheckBattleEndWithDead()
end
end
end
function t.CheckBattleEndContainTomb()
if e.OurTeam:CheckTeamBattleEndContainTomb()then
e.isBattleEnd=true
return true
elseif e.EnemyTeam:CheckTeamBattleEndContainTomb()then
e.isBattleEnd=true
return true
else
return false
end
end
function t.CheckBattleEndWithDead()
if e.OurTeam:IsAllDeathContainSupple()then
e.isBattleEnd=true
return true
elseif e.EnemyTeam:IsAllDeathContainSupple()then
e.isBattleEnd=true
return true
else
return false
end
end
function t.BattleEnd()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
EventSystem.SendEvent(CommonEventId.OnEventBattleEnd)
end
e.TriggerRelic(RelicTriggerTime.battleEnd)
e.HideFireEffect()
if e.curProcedureBattle then
e.curProcedureBattle:OnCurWavasMonstersAllDeath()
end
if(e.FightPlayData==nil)then
for t,e in pairs(e.HeroDic)do
FightDataReportMgr:AddStatisticOnCurrWave(e)
end
end
if(e.BattleType~=BattleType.idle and e.OurTeam:IsAllDeathContainSupple())then
e.FinalBattleEnd()
return
end
if(GameInit.IsClient==false and e.FightPlayData)then
for a,t in pairs(e.HeroDic)do
FightDataReportMgr:VerifyStatistic(e.FightPlayData,e.CurrMapsWavesIndex,t)
end
end
e.ChangeHasNextWaves()
end
function t.CalculateBattleResultOnOverRound()

local a=false
local t=0
if e.IsPVE()then
a=false
t=0
else
local o=e.OurTeam:GetTotalHPPercent()
local i=e.EnemyTeam:GetTotalHPPercent()
if(o>i)then
a=true
t=1
elseif(o<i)then
a=false
t=0
else
if(c>u)then
a=true
t=1
elseif(c<u)then
a=false
t=0
else
local o=e.OurTeam:GetFirstPlayerId()
local e=e.EnemyTeam:GetFirstPlayerId()
if o<e then
a=true
t=1
else
a=false
t=0
end
end
end
end
return a,t
end
function t.FinalBattleEnd(a)

if(e.isAlreadyShowBattleEnd)then
return
end
e.isAlreadyShowBattleEnd=true
e.isBattleEnd=true
e:PrintBuffDamage()
if e.dropBoxData and#e.dropBoxData>0 then
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local t=ModulesInit.TimeActionMgr.CreateTimeAction()
e.AddTimer(t)
t:Init(
0,
1,
1,
nil,
nil,
function()
e.RemoveTimer(t)
e.DoFinalBattleEnd(a)
end
):Run()
else
e.DoFinalBattleEnd(a)
end
else
e.DoFinalBattleEnd(a)
end
end
function t.DoFinalBattleEnd(t)
if GameInit.IsClient then
e.mLastReqBattleTimeStamp=TimeUtil.GetServerMillTimeStamp()
end
e.DoCameraCtrlReset()
local i=false
local o=0
e.OurTeam:ClearAllGranBuff(false)
e.EnemyTeam:ClearAllGranBuff(false)
local a=EBattleSuppleHeroStaticsResult.None
if(t==BattleEndType.OverRound)then
if(e.FightPlayData==nil)then
for t,e in pairs(e.HeroDic)do
FightDataReportMgr:AddStatisticOnCurrWave(e)
end
end
if e.EnemyTeam:CheckTeamBattleEndContainTomb()then
i=true
o=1
elseif e.OurTeam:CheckTeamBattleEndContainTomb()then
i=false
o=0
else
i,o=e.CalculateBattleResultOnOverRound()
end
else
i=e.EnemyTeam:CheckTeamBattleEndContainTomb()
o=i and 1 or 0
end
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.campaign then
local t=e.CurrDTMap
if t==nil then
t=w.GetEntity(e.MapId)
end
local e=true
if t and t.checkFight==0 and e then
i=true
o=i and 1 or 0
end
elseif ModulesInit.ProcedureNormalBattle.BattleType==BattleType.girlChallenge then
i=true
o=1
end
if i then
a=EBattleSuppleHeroStaticsResult.IsEnmeyZeroHp
else
a=EBattleSuppleHeroStaticsResult.IsOurZeroHp
end
e.AddEmptyStatisticOnCurrWave(a)
if(e.FightPlayData==nil)then
FightDataReportMgr:SetAllHeroDeadByTeam(i==false)
end
if GameInit.IsClient then
if e.FightPlayData then
i=e.FightPlayData.fightResult==1
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if e.curProcedureBattle then
e.curProcedureBattle:OnBattleStop()
end
e.SetMVPHeroDId()
local t={
battleType=e.BattleType,
mapId=e.MapId,
battleInfo={}
}
if(GameInit.IsClient)then
GameTools:SetTimeScale(SetTimeScaleType.Battle,1)
if(e.BattleType==BattleType.campaign)then
local a={}
if ActMgr:IsOpen(ModulesInit.ActBoxWeekMgr.actId)then
for t=1,#e.CurrDTMap.firstDropBoxWeek do
table.insert(a,{e.CurrDTMap.firstDropBoxWeek[t][1],e.CurrDTMap.firstDropBoxWeek[t][2]})
end
end
if ActMgr:IsOpen(ModulesInit.ActLoveFiveBoxMgr.actId)then
for t=1,#e.CurrDTMap.firstDropLoveFiveBox do
table.insert(a,{e.CurrDTMap.firstDropLoveFiveBox[t][1],e.CurrDTMap.firstDropLoveFiveBox[t][2]})
end
end
if e.isFirstChallenge then
table.add(a,{Currency.Exp,s:GetMapFirstExp(e.CurrDTMap)})
table.add(a,{Currency.Gold,s:GetFirstGold(e.CurrDTMap)})
end
local e=s:GetMapFirstDrop(e.CurrDTMap)
for o=1,#e do
table.add(a,e[o])
end
t.drops=a
elseif(e.BattleType==BattleType.elite)then
if e.isFirstChallenge then
t.drops=e.CurrDTMap.firstDrop
end
elseif(e.BattleType==BattleType.carnival)then
if e.isFirstChallenge then
t.drops=e.CurrDTMap.firstDrop
end
elseif(e.BattleType==BattleType.newCarnival)then
if e.isFirstChallenge then
t.drops=e.CurrDTMap.firstDrop
end
elseif(e.BattleType==BattleType.GoldHoliday)then
if e.isFirstChallenge then
t.drops=e.CurrDTMap.firstDrop
end
elseif(e.BattleType==BattleType.trial)then
t.drops={}
end
end
if(GameInit.IsClient==false)then
if(e.FightPlayData)then
if e.FightPlayData.fightResult~=o then
FightDataReportMgr.isValid=false
end
if(FightDataReportMgr.isValid)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
else
FightDataReportMgr:SetMvpHeroDid(e.GetMVPHeroDId())
FightDataReportMgr:SetFightResult(o)
end
end
if(GameInit.IsClient)then
if e.IsCloseMusicInEnd then
GameEntry.Audio:StopBGM()
GameEntry.Audio:StopAllAudio()
end
if e.BattleType==BattleType.waterMelon or
e.BattleType==BattleType.flower or
e.BattleType==BattleType.mineBattle or
e.BattleType==BattleType.urBackBossFight or
e.BattleType==BattleType.selfMarryBack or
e.BattleType==BattleType.guildTrials then
else
if e.IsPlayBattleEndAudio then
if i then
GameTools:PlayAudioLua(345)
else
GameTools:PlayAudioLua(346)
end
end
end
e:SetGuideScaleView(false)
if(e.BattleType==BattleType.skillPreview)then
return
end
if(GameInit.IsClient and e.IsTestMode==true)then
t.IsTestMode=true
FightDataReportMgr:SetFightResult(o)
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,t)
return
end
if e.IsFightPlay then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
e.mvpHeroDid=a.mvpHeroDid
if a.battleType==BattleType.campaign
or e.BattleType==BattleType.elite
or e.BattleType==BattleType.trial
or e.BattleType==BattleType.maze
or e.BattleType==BattleType.guide
then
local h=a.ourTeamFormation
local s=a.ourTeamFormationAlter
local n={}
local o={}
for e=1,#a.waveData do
local e=a.waveData[e].heroStatistics
for t=1,#e do
local e=e[t]
if not o[e.heroId]then
o[e.heroId]=e
else
local t=o[e.heroId]
t.outputDmg=t.outputDmg+e.outputDmg
t.dmg=t.dmg+e.dmg
t.healHp=t.healHp+e.healHp
end
end
end
for a,e in pairs(o)do
table.add(n,e)
end
t={
formation1Data=h,
formation1AlterData=s,
battleInfo=n,
mvpHeroDid=a.mvpHeroDid,
star=e.FightPlayStar
}
if i then
local a=e.GetTeamFormation()
t.formationData=a
if(e.BattleType==BattleType.trial)then
GameEntry.UI:OpenUIForm(UIFormId.UI_TowerVictoryPlayback,t)
else
e.StopAllCoroutine()
GameEntry.UI:OpenUIForm(UIFormId.UI_PlaybackVictory,t)
end
else
if e.BattleType==BattleType.elite then
ModulesInit.EliteMgr:GoBack()
elseif e.BattleType==BattleType.carnival then
ModulesInit.ActCarnivalManager:GoBack()
elseif e.BattleType==BattleType.newCarnival then
ModulesInit.ActCarnivalNewManager:GoBack()
elseif e.BattleType==BattleType.GoldHoliday then
ModulesInit.ActGoldHolidayMgr:GoBack()
elseif e.BattleType==BattleType.guildTrials then
ModulesInit.GuildTrialsMgr:GoBack()
else
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonLoading,{style=LoadingStyle.Cloud,loadResFinish=function()
EventSystem.SendEvent(CommonEventId.PlayLoadingCloudAni)
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
end})
end
end
elseif a.battleType==BattleType.arena or a.battleType==BattleType.WarOfAttrition then
local o=ModulesInit.ArenaManager.CurPlaybackParty1Info
local f=a.ourHeros
local m=a.ourTeamFormation
local s=a.ourTeamFormationAlter
o.targetFirstValue=r
o.fightValue=c
local n=ModulesInit.ArenaManager.CurPlaybackParty2Info
local h=a.waveData[1].enemyHeros
local r=a.waveData[1].enemyTeamFormation
local d=a.waveData[1].enemyTeamFormationAlter
n.targetFirstValue=l
n.fightValue=u
t={
leftIsAttackers=true,
leftIsWin=i,
party1Info=o,
formation1Data=m,
formation1AlterData=s,
party2Info=n,
formation2Data=r,
formation2AlterData=d,
party1Heros=f,
party2Heros=h,
battleInfo=a.waveData[1].heroStatistics
}
local e=e.GetTeamFormation()
t.formationData=e
GameEntry.UI:OpenUIForm(UIFormId.UI_PlaybackResult,t)
elseif a.battleType==BattleType.islandEscort then
elseif a.battleType==BattleType.friendArena then
elseif a.battleType==BattleType.burningBuild then
local n=ModulesInit.ActBurningBuildMgr.CurPlaybackParty1Info
local h=a.ourHeros
local s=a.ourTeamFormation
local m=a.ourTeamFormationAlter
n.targetFirstValue=r
n.fightValue=c
local o=ModulesInit.ActBurningBuildMgr.CurPlaybackParty2Info
local d=a.waveData[1].enemyHeros
local c=a.waveData[1].enemyTeamFormation
local r=a.waveData[1].enemyTeamFormationAlter
o.targetFirstValue=l
o.fightValue=u
t={
leftIsAttackers=true,
leftIsWin=i,
party1Info=n,
formation1Data=s,
formation1AlterData=m,
party2Info=o,
formation2Data=c,
formation2AlterData=r,
party1Heros=h,
party2Heros=d,
battleInfo=a.waveData[1].heroStatistics
}
local e=e.GetTeamFormation()
t.formationData=e
GameEntry.UI:OpenUIForm(UIFormId.UI_PlaybackResult,t)
elseif a.battleType==BattleType.spaceArena then
local n=ModulesInit.CrossArenaManager.CurPlaybackParty1Info
local s=a.ourHeros
local h=a.ourTeamFormation
local d=a.ourTeamFormationAlter
n.targetFirstValue=r
n.fightValue=c
local o=ModulesInit.CrossArenaManager.CurPlaybackParty2Info
local r=a.waveData[1].enemyHeros
local m=a.waveData[1].enemyTeamFormation
local c=a.waveData[1].enemyTeamFormationAlter
o.targetFirstValue=l
o.fightValue=u
t={
leftIsAttackers=true,
leftIsWin=i,
party1Info=n,
formation1Data=h,
formation1AlterData=d,
party2Info=o,
formation2Data=m,
formation2AlterData=c,
party1Heros=s,
party2Heros=r,
battleInfo=a.waveData[1].heroStatistics
}
local e=e.GetTeamFormation()
t.formationData=e
GameEntry.UI:OpenUIForm(UIFormId.UI_PlaybackResult,t)
elseif a.battleType==BattleType.flower then
local e=ModulesInit.ProcedureNormalBattle.FightPlayData
local n=e.ourHeros
local a={}
a.targetFirstValue=r
a.fightValue=c
local s=e.waveData[1].enemyHeros
local a={}
a.targetFirstValue=l
a.fightValue=u
local a=ModulesInit.FlowerFightMgr.mFowerViewData
local o=a.fightType
t={
leftIsWin=i,
leftPlayerInfo=a.leftPlayerInfo,
rightPlayerInfo=a.rightPlayerInfo,
party1Heros=n,
party2Heros=s,
battleInfo=e.waveData[1].heroStatistics,
fightType=o,
}
GameEntry.UI:OpenUIForm(UIFormId.UI_FlowerFightBattleResult,t)
elseif a.battleType==BattleType.unionCraft then
local o=ModulesInit.CSGuildWarManager.CurPlaybackParty1Info
local s=a.ourHeros
local h=a.ourTeamFormation
local d=a.ourTeamFormationAlter
o.targetFirstValue=r
o.fightValue=c
local n=ModulesInit.CSGuildWarManager.CurPlaybackParty2Info
local r=a.waveData[1].enemyHeros
local c=a.waveData[1].enemyTeamFormation
local m=a.waveData[1].enemyTeamFormationAlter
n.targetFirstValue=l
n.fightValue=u
t={
leftIsAttackers=true,
leftIsWin=i,
party1Info=o,
formation1Data=h,
formation1AlterData=d,
party2Info=n,
formation2Data=c,
formation2AlterData=m,
party1Heros=s,
party2Heros=r,
battleInfo=a.waveData[1].heroStatistics
}
local e=e.GetTeamFormation()
t.formationData=e
GameEntry.UI:OpenUIForm(UIFormId.UI_PlaybackResult,t)
elseif a.battleType==BattleType.cityWar then
local o=ModulesInit.SkyCityMgr.CurPlaybackParty1Info
local f=a.ourHeros
local d=a.ourTeamFormation
local m=a.ourTeamFormationAlter
o.targetFirstValue=r
o.fightValue=c
local n=ModulesInit.SkyCityMgr.CurPlaybackParty2Info
local r=a.waveData[1].enemyHeros
local s=a.waveData[1].enemyTeamFormation
local h=a.waveData[1].enemyTeamFormationAlter
n.targetFirstValue=l
n.fightValue=u
t={
leftIsAttackers=true,
leftIsWin=i,
party1Info=o,
formation1Data=d,
formation1AlterData=m,
party2Info=n,
formation2Data=s,
formation2AlterData=h,
party1Heros=f,
party2Heros=r,
battleInfo=a.waveData[1].heroStatistics,
}
local e=e.GetTeamFormation()
t.formationData=e
GameEntry.UI:OpenUIForm(UIFormId.UI_SkyCityPlaybackResult,t)
elseif a.battleType==BattleType.richMan then
local o=ModulesInit.ActRichmanMgr.CurPlaybackParty1Info
local m=a.ourHeros
local f=a.ourTeamFormation
local d=a.ourTeamFormationAlter
o.targetFirstValue=r
o.fightValue=c
local n=ModulesInit.ActRichmanMgr.CurPlaybackParty2Info
local r=a.waveData[1].enemyHeros
local h=a.waveData[1].enemyTeamFormation
local s=a.waveData[1].enemyTeamFormationAlter
n.targetFirstValue=l
n.fightValue=u
t={
leftIsAttackers=true,
leftIsWin=i,
party1Info=o,
formation1Data=f,
formation1AlterData=d,
party2Info=n,
formation2Data=h,
formation2AlterData=s,
party1Heros=m,
party2Heros=r,
battleInfo=a.waveData[1].heroStatistics,
scoreCost=ModulesInit.ActRichmanMgr.scoreCost
}
local e=e.GetTeamFormation()
t.formationData=e
if i then
GameEntry.UI:OpenUIForm(UIFormId.UI_ActRichmanBattleVictory,t)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_ActRichmanBattleFailure,t)
end
end
else
FightDataReportMgr:SetMvpHeroDid(e.GetMVPHeroDId())
if e.BattleType==BattleType.campaign
or e.BattleType==BattleType.elite
or e.BattleType==BattleType.carnival
or e.BattleType==BattleType.newCarnival
or e.BattleType==BattleType.GoldHoliday
or e.BattleType==BattleType.bigBoss
or e.BattleType==BattleType.trial
or e.BattleType==BattleType.maze
or e.BattleType==BattleType.guide
or e.BattleType==BattleType.thiefCrusade
or e.BattleType==BattleType.guildTrials
or e.BattleType==BattleType.SpringRain
or e.BattleType==BattleType.selfMarryBoss
or e.BattleType==BattleType.urBossFight
or e.BattleType==BattleType.urTestFight
or e.BattleType==BattleType.Inspiration
or e.BattleType==BattleType.burningBuild
or e.BattleType==BattleType.lrBossFight
or e.BattleType==BattleType.lrTestFight
then
local s={}
local a={}
for e=1,#FightDataReportMgr.waveData do
local e=FightDataReportMgr.waveData[e].heroStatistics
if(e)then
for t=1,#e do
local e=e[t]
if not a[e.heroId]then
a[e.heroId]=e
else
local t=a[e.heroId]
t.outputDmg=t.outputDmg+e.outputDmg
t.dmg=t.dmg+e.dmg
t.healHp=t.healHp+e.healHp
end
end
end
end
for t,e in pairs(a)do
table.add(s,e)
end
local a=e.GetTeamFormation()
t.battleInfo=s
t.formationData=a
ModulesInit.ExpeditionManager:SetFightClearState(i)
ModulesInit.ExpeditionManager:SetFightClearInfo(t)
if i then
if e.BattleType==BattleType.campaign then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
FightDataReportMgr:SendFightManualRequest()
elseif e.BattleType==BattleType.elite then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.EliteMgr:SendFightManualRequest()
elseif e.BattleType==BattleType.burningBuild then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActBurningBuildMgr:SendFightManualRequest()
elseif e.BattleType==BattleType.carnival then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActCarnivalManager:SendFightManualRequest()
elseif e.BattleType==BattleType.newCarnival then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActCarnivalNewManager:SendFightManualRequest()
elseif e.BattleType==BattleType.GoldHoliday then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActGoldHolidayMgr:SendFightManualRequest()
elseif e.BattleType==BattleType.guildTrials then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.GuildTrialsMgr:ReqGuildTrialsFight()
elseif e.BattleType==BattleType.bigBoss then
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActBigBossMgr:CheckReqMazeFight()
elseif(e.BattleType==BattleType.trial)then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
FightDataReportMgr:SendFightManualRequest()
elseif(e.BattleType==BattleType.thiefCrusade)then
FightDataReportMgr:SetFightResult(o)
ModulesInit.CrusadeAgainstMgr.SendGuildThiefFightOver(FightDataReportMgr:GetBattleInfo())
elseif(e.BattleType==BattleType.maze)then
FightDataReportMgr:SetFightResult(o)
ModulesInit.MazeMgr:SendFightManualRequest()
if GameEntry.Procedure.CurrProcedureState==CS.YouYou.ProcedureState.MainCity then
ModulesInit.MazeMgr:ResetCamera()
end
elseif(e.BattleType==BattleType.guide)then
if e.autoExitGuideBattle==true then
ModulesInit.GuideMgr:LeaveBattle()
else
if GameInit.IsClient and ModulesInit.GuideMgr.isGuide and ModulesInit.GuideMgr.guideId==ModulesInit.GuideMgr.SpeacalId.RequestThrBattle then
e.IsRespBattleInfo=true
e.BattleResultReqCount=3
FightDataReportMgr:SetFightResult(o)
FightDataReportMgr:SendFighGuideFinalRequest()
end
end
elseif e.BattleType==BattleType.SpringRain then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActSpringRainMgr:SendFightRequest()
elseif e.BattleType==BattleType.selfMarryBoss then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActSelfMarryMgr:SendFightRequest()
elseif e.BattleType==BattleType.urBossFight then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActURBossMgr:RequestBossFight()
elseif e.BattleType==BattleType.urTestFight then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActURTestMgr:RequestTestFight()
elseif e.BattleType==BattleType.Inspiration then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.InspirationMgr:RequestFight()
elseif e.BattleType==BattleType.lrBossFight then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActLRBossMgr:RequestBossFight()
elseif e.BattleType==BattleType.lrTestFight then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActLRTestMgr:RequestTestFight()
elseif e.BattleType==BattleType.girlChallenge then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
e.mvpHeroDid=a.mvpHeroDid
t.battleInfo=a
local e=e.GetTeamFormation()
t.formationData=e
GameEntry.UI:OpenUIForm(UIFormId.UI_GirlChallenge_Win,t)
end
else
if(e.BattleType==BattleType.maze)then
FightDataReportMgr:SetFightResult(o)
ModulesInit.MazeMgr:SendFightManualRequest()
if GameEntry.Procedure.CurrProcedureState==CS.YouYou.ProcedureState.MainCity then
ModulesInit.MazeMgr:ResetCamera()
end
elseif e.BattleType==BattleType.bigBoss then
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActBigBossMgr:CheckReqMazeFight()
elseif e.BattleType==BattleType.guildTrials then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.GuildTrialsMgr:ReqGuildTrialsFight()
elseif(e.BattleType==BattleType.guide)then
if e.autoExitGuideBattle==true then
ModulesInit.GuideMgr:LeaveBattle()
end
elseif(e.BattleType==BattleType.thiefCrusade)then
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,t)
elseif e.BattleType==BattleType.campaign then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
FightDataReportMgr:SendFightManualRequest()
elseif e.BattleType==BattleType.elite then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.EliteMgr:SendFightManualRequest()
elseif e.BattleType==BattleType.burningBuild then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActBurningBuildMgr:SendFightManualRequest()
elseif(e.BattleType==BattleType.trial)then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
FightDataReportMgr:SendFightManualRequest()
elseif e.BattleType==BattleType.SpringRain then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActSpringRainMgr:SendFightRequest()
elseif e.BattleType==BattleType.selfMarryBoss then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActSelfMarryMgr:SendFightRequest()
elseif e.BattleType==BattleType.urBossFight then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActURBossMgr:RequestBossFight()
elseif e.BattleType==BattleType.urTestFight then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActURTestMgr:RequestTestFight()
elseif e.BattleType==BattleType.Inspiration then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.InspirationMgr:RequestFight()
elseif e.BattleType==BattleType.lrBossFight then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActLRBossMgr:RequestBossFight()
elseif e.BattleType==BattleType.lrTestFight then
e.IsRespBattleInfo=true
e.BattleResultReqCount=n
FightDataReportMgr:SetFightResult(o)
ModulesInit.ActLRTestMgr:RequestTestFight()
else
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,t)
end
end
elseif e.BattleType==BattleType.arena or e.BattleType==BattleType.WarOfAttrition then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
e.mvpHeroDid=a.mvpHeroDid
t.battleInfo=a.waveData[1].heroStatistics
local e=e.GetTeamFormation()
t.formationData=e
if i then
GameEntry.UI:OpenUIForm(UIFormId.UI_ArenaWin,t)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,t)
end
elseif e.BattleType==BattleType.islandEscort then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
e.mvpHeroDid=a.mvpHeroDid
t.battleInfo=a.waveData[1].heroStatistics
local e=e.GetTeamFormation()
t.formationData=e
if i then
GameEntry.UI:OpenUIForm(UIFormId.UI_ActIslandOrderWinView,t)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,t)
end
elseif e.BattleType==BattleType.friendArena then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
e.mvpHeroDid=a.mvpHeroDid
t.battleInfo=a.waveData[1].heroStatistics
local e=e.GetTeamFormation()
t.formationData=e
if i then
GameEntry.UI:OpenUIForm(UIFormId.UI_FriendBattleWin,t)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,t)
end
elseif e.BattleType==BattleType.waterMelon then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
e.mvpHeroDid=a.mvpHeroDid
t.battleInfo=a
local e=e.GetTeamFormation()
t.formationData=e
GameEntry.UI:OpenUIForm(UIFormId.UI_ActWatermelonResult,t)
elseif e.BattleType==BattleType.mineBattle then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
e.mvpHeroDid=a.mvpHeroDid
t.battleInfo=a
local e=e.GetTeamFormation()
t.formationData=e
if ModulesInit.MineMgr.isFightPlay then
ModulesInit.MineMgr:GoBack()
else
if i then
GameEntry.UI:OpenUIForm(UIFormId.UI_MineBattle_Victor_View,t)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_MineBattle_Failure_View,t)
end
end
elseif e.BattleType==BattleType.guildBossPersonal then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
e.mvpHeroDid=a.mvpHeroDid
t.battleInfo=a
local e=e.GetTeamFormation()
t.formationData=e
if i then
GameEntry.UI:OpenUIForm(UIFormId.UI_ActGuildBoss_Result_View,t)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,t)
end
elseif e.BattleType==BattleType.guildBossGuild then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
e.mvpHeroDid=a.mvpHeroDid
t.battleInfo=a
local e=e.GetTeamFormation()
t.formationData=e
GameEntry.UI:OpenUIForm(UIFormId.UI_ActGuildBoss_Result_View,t)
elseif e.BattleType==BattleType.urBackBossFight then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
e.mvpHeroDid=a.mvpHeroDid
t.battleInfo=a
local e=e.GetTeamFormation()
t.formationData=e
GameEntry.UI:OpenUIForm(UIFormId.UI_ActURBack_Boss_Victory,t)
elseif e.BattleType==BattleType.spaceArena then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
e.mvpHeroDid=a.mvpHeroDid
t.battleInfo=a.waveData[1].heroStatistics
local e=e.GetTeamFormation()
t.formationData=e
if i then
GameEntry.UI:OpenUIForm(UIFormId.UI_CrossArenaWin,t)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,t)
end
elseif e.BattleType==BattleType.flower then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
local s=a.ourHeros
local e={}
e.targetFirstValue=r
e.fightValue=c
local o=a.waveData[1].enemyHeros
local e={}
e.targetFirstValue=l
e.fightValue=u
local e=ModulesInit.FlowerFightMgr.mFowerViewData
local n=e.fightType
t={
leftIsWin=i,
leftPlayerInfo=e.leftPlayerInfo,
rightPlayerInfo=e.rightPlayerInfo,
party1Heros=s,
party2Heros=o,
battleInfo=a.waveData[1].heroStatistics,
fightType=n,
}
GameEntry.UI:OpenUIForm(UIFormId.UI_FlowerFightBattleResult,t)
elseif e.BattleType==BattleType.unionCraft then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
e.mvpHeroDid=a.mvpHeroDid
t.battleInfo=a.waveData[1].heroStatistics
local e=e.GetTeamFormation()
t.formationData=e
if i then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarWin,t)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,t)
end
elseif e.BattleType==BattleType.dragonWar then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
if(a)then
e.mvpHeroDid=a.mvpHeroDid
local o=a.ourHeros
t.battleInfo=a.waveData[1].heroStatistics
t.party1Heros=o
local e=e.GetTeamFormation()
t.formationData=e
if i then
GameEntry.UI:OpenUIForm(UIFormId.UI_KillDragonsWin,t)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,t)
end
end
elseif e.BattleType==BattleType.selfMarryBack then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
e.mvpHeroDid=a.mvpHeroDid
t.battleInfo=a
local e=e.GetTeamFormation()
t.formationData=e
GameEntry.UI:OpenUIForm(UIFormId.UI_ActSelfMarryBack_Boss_Victory,t)
elseif e.BattleType==BattleType.girlChallenge then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
e.mvpHeroDid=a.mvpHeroDid
t.battleInfo=a.waveData[1].heroStatistics
local e=e.GetTeamFormation()
t.formationData=e
GameEntry.UI:OpenUIForm(UIFormId.UI_GirlChallenge_Win,t)
elseif e.BattleType==BattleType.GuildRadar then
local a=ModulesInit.ProcedureNormalBattle.FightPlayData
e.mvpHeroDid=a.mvpHeroDid
t.battleInfo=a.waveData[1].heroStatistics
local e=e.GetTeamFormation()
t.formationData=e
if i then
t.taskId=ModulesInit.GuildTerritoryMgr.curFightInfo and ModulesInit.GuildTerritoryMgr.curFightInfo.taskId or 0
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTerritory_Victory,t)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_BattleFail,t)
end
end
end
end
end
function t.OnBattleEndUIShowComplete()
e.Dispose(false)
end
function t.GetBattleHerosWithTeamId(e,t,o,a,i)
local e=ModulesInit.ProcedureNormalBattle.GetBattleTeamByTeamId(e)
if e then
return ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeam(e,t,o,a,i)
end
return{}
end
function t.GetBattleHerosWithTeam(e,t,o,i,a)
if(t==BattleHeroType.ourAll)then
return e:GetAllHeros(a)
elseif(t==BattleHeroType.enemyAll)then
return e.OpponentTeam:GetAllHeros(a)
elseif(t==BattleHeroType.fFront)then
return e:GetFrontOrBackHeros(true)
elseif(t==BattleHeroType.fBack)then
return e:GetFrontOrBackHeros(false)
elseif(t==BattleHeroType.eAttrHigh)then
return e.OpponentTeam:GetHeroCtrlWithAttrId(i,o,true)
end
return nil
end
function t.GetBattleHerosByHeroModelId(t,e,o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,e)
local a={}
for t=1,#e do
if(e[t]:GetHeroModelId()==o)then
table.insert(a,e[t])
end
end
return a
end
function t.is1v1(t)
if e.BattleMode==EBattleMode.formation1v1 then
return true
else
local e=ModulesInit.ProcedureNormalBattle.GetOurCount(t)
local t=ModulesInit.ProcedureNormalBattle.GetEnemyCount(t)
if e==1 and t==1 then
return true
end
end
return false
end
function t.GetTotalHeroCount(e)
local t=ModulesInit.ProcedureNormalBattle.GetOurCount(e)
local e=ModulesInit.ProcedureNormalBattle.GetEnemyCount(e)
return t+e
end
function t.GetOurCount(e)
if e and e.CurrBattleTeam then
local e=e.CurrBattleTeam:GetAllHerosCountInBattle()
return e
end
return 0
end
function t.GetEnemyCount(e)
if e and e.CurrBattleTeam and e.CurrBattleTeam.OpponentTeam then
local e=e.CurrBattleTeam.OpponentTeam:GetAllHerosCountInBattle()
return e
end
return 0
end
function t.GetTeamCurrSepsisHPTotalValue(e)
if e and e.CurrBattleTeam then
return e.CurrBattleTeam:GetTeamCurrSepsisHPTotalValue()
end
return 0
end
function t.GetBattleHerosByTeamId(i,a,t)
t=t or{}
local o=t.isContainUsualState
local t=t.count or 1
local e=e.GetTeamsByTeamId(i)
if e then
if(a==BattleHeroType.ourAll)then
return e:GetAllHeros(o)
elseif(a==BattleHeroType.enemyAll)then
return e.OpponentTeam:GetAllHeros(o)
elseif(a==BattleHeroType.eRandom)then
return e.OpponentTeam:GetRandomHeros(t)
end
end
return nil
end
function t.GetTeamsByTeamId(t)
if e.OurTeam and e.OurTeam.TeamId==t then
return e.OurTeam
elseif e.EnemyTeam and e.EnemyTeam.TeamId==t then
return e.EnemyTeam
end
return nil
end
function t.GetBattleHeros(t,a,o,h,i,n,s)
local r=s and s.isContainUsualState
local l=s and s.isExludeSelf
if(a==BattleHeroType.self)then
return t
elseif(a==BattleHeroType.selfColumn)then
local e=t.battleStationColumn
local t=t.CurrBattleTeam
local e=t:GetHerosWithColumn(e)
return e
elseif(a==BattleHeroType.selfRow)then
local a=t.battleStationRow
local e=t.CurrBattleTeam
local e=e:GetHerosWithRow(a)
return e
elseif(a==BattleHeroType.ourAll)then
return t.CurrBattleTeam:GetAllHeros(r)
elseif(a==BattleHeroType.fFront)then
local e=t.CurrBattleTeam:GetFrontOrBackHeros(true)
if(#e==0)then
e=t.CurrBattleTeam:GetFrontOrBackHeros(false)
end
return e
elseif(a==BattleHeroType.fBack)then
local e=t.CurrBattleTeam:GetFrontOrBackHeros(false)
if(#e==0)then
e=t.CurrBattleTeam:GetFrontOrBackHeros(true)
end
return e
elseif(a==BattleHeroType.eFront)then
local e=t.CurrBattleTeam.OpponentTeam:GetFrontOrBackHeros(true)
if(#e==0)then
e=t.CurrBattleTeam.OpponentTeam:GetFrontOrBackHeros(false)
end
return e
elseif(a==BattleHeroType.eBack)then
local e=t.CurrBattleTeam.OpponentTeam:GetFrontOrBackHeros(false)
if(#e==0)then
e=t.CurrBattleTeam.OpponentTeam:GetFrontOrBackHeros(true)
end
return e
elseif(a==BattleHeroType.enemy)then
return e.GetBattleHeros_enemy(t)
elseif(a==BattleHeroType.enemyAll)then
return t.CurrBattleTeam.OpponentTeam:GetAllHeros(r)
elseif(a==BattleHeroType.fRandom)then
return t.CurrBattleTeam:GetManyRandomHeroExcludeHeroId(t.HeroId,o)
elseif(a==BattleHeroType.eRandom)then
return t.CurrBattleTeam.OpponentTeam:GetRandomHeros(o)
elseif(a==BattleHeroType.fAttrHigh)then
return t.CurrBattleTeam:GetHeroCtrlWithAttrId(h,o,true)
elseif(a==BattleHeroType.fAttrLow)then
return t.CurrBattleTeam:GetHeroCtrlWithAttrId(h,o,false)
elseif(a==BattleHeroType.eAttrLow)then
return t.CurrBattleTeam.OpponentTeam:GetHeroCtrlWithAttrId(h,o,false)
elseif(a==BattleHeroType.fAttrLowExcludeSelf)then
return t.CurrBattleTeam:GetHeroCtrlWithAttrIdWithExcludeHeroId(h,o,false,t.HeroId)
elseif(a==BattleHeroType.eColumn)then
return e.GetEnemyRandomColumn(t,n)
elseif(a==BattleHeroType.fHollow)then
local e=t
if(e~=nil)then
local a=e.battleStationColumn
local t=e.CurrBattleTeam
local o=t:GetHerosWithColumn(a,r)
local a=e.battleStationRow
local i=t:GetHerosWithRow(a,r)
local t={}
local a=#o
for i=1,a do
local a=o[i]
if(a.HeroId~=e.HeroId)then
t[#t+1]=a
end
end
a=#i
for a=1,a do
local a=i[a]
if(a.battleStationIndex==e.battleStationIndex-1 or a.battleStationIndex==e.battleStationIndex+1)then
t[#t+1]=a
end
end
return t
end
return{}
elseif(a==BattleHeroType.eAround)then
local e=t
if(e~=nil)then
local a=e.battleStationColumn
local t=e.CurrBattleTeam
local o=t:GetHerosWithColumn(a)
local a=e.battleStationRow
local i=t:GetHerosWithRow(a)
local t={}
local a=#o
for e=1,a do
local e=o[e]
if(e.HeroBattleInfo.CurrHP>0)then
t[#t+1]=e
end
end
a=#i
for a=1,a do
local a=i[a]
if(a.HeroBattleInfo.CurrHP>0)then
if(a.battleStationIndex==e.battleStationIndex-1 or a.battleStationIndex==e.battleStationIndex+1)then
t[#t+1]=a
end
end
end
return t
end
return{}
elseif(a==BattleHeroType.eHollow)then
local e=t
if(e~=nil)then
local a=e.battleStationColumn
local t=e.CurrBattleTeam
local a=t:GetHerosWithColumn(a)
local o=e.battleStationRow
local i=t:GetHerosWithRow(o)
local t={}
local o=#a
for i=1,o do
local a=a[i]
if(a.HeroId~=e.HeroId and a.HeroBattleInfo.CurrHP>0)then
t[#t+1]=a
end
end
o=#i
for a=1,o do
local a=i[a]
if(a.HeroId~=e.HeroId and a.HeroBattleInfo.CurrHP>0)then
if(a.battleStationIndex==e.battleStationIndex-1 or a.battleStationIndex==e.battleStationIndex+1)then
t[#t+1]=a
end
end
end
return t
end
return{}
elseif(a==BattleHeroType.eMinHp)then
local e=t.CurrBattleTeam.OpponentTeam:GetMinHpHero()
return e
elseif(a==BattleHeroType.eOneBack)then
local e=t.CurrBattleTeam.OpponentTeam:GetEnemyPriorityFromBack()
return e
elseif(a==BattleHeroType.eMaxFinalAtk)then
local e=t.CurrBattleTeam.OpponentTeam:GetMaxFinalAtk()
return e
elseif(a==BattleHeroType.eMinHpPercent)then
local a=t.CurrBattleTeam.OpponentTeam:GetMinHpPercentHero()
if a and a:CurrHPPer()>=1 then
a=e.GetBattleHeros_enemy(t)
end
return a
elseif(a==BattleHeroType.all)then
local t={}
for a,e in pairs(ModulesInit.ProcedureNormalBattle.HeroDic)do
if e:IsPet()==false then
table.insert(t,e)
end
end
return t
elseif(a==BattleHeroType.fMostDebuff)then
local e=t.HeroId
if l==false then
e=nil
end
local e=t.CurrBattleTeam:GetMostDebuffHero(e)
return e
elseif(a==BattleHeroType.eMostDebuff)then
local e=t.HeroId
if l==false then
e=nil
end
local e=t.CurrBattleTeam.OpponentTeam:GetMostDebuffHero(e)
return e
elseif(a==BattleHeroType.ePriorBack)then
local e=t.CurrBattleTeam.OpponentTeam:GetHerosPriorityFromBack(o)
return e
elseif(a==BattleHeroType.ourAllExcludeSelf)then
return t.CurrBattleTeam:GetAllHerosExcludeHero(t.HeroId)
elseif(a==BattleHeroType.eState)then
local n=e.GetForceAttackHero(t)
if o==1 then
if n then
return{n}
end
end
local a=t.CurrBattleTeam.OpponentTeam:GetAllHeroWithBuff(i,o)
if n then
local e=#a
if e>0 then
table.remove(a,e)
end
table.insert(a,1,n)
end
if#a<=0 then
local e=e.GetBattleHeros_enemy(t)
table.insert(a,e)
end
return a
elseif(a==BattleHeroType.fState)then
local e=t.CurrBattleTeam:GetAllHeroWithBuff(i,o)
if#e<=0 then
return t.CurrBattleTeam:GetRandomHeros(o)
end
return e
elseif(a==BattleHeroType.ourAllExcludeSelfWithBuffId)then
return t.CurrBattleTeam:GetAllHerosExcludeHeroWithBuff(t.HeroId,i,o)
elseif(a==BattleHeroType.enemyAllExcludeSelfWithBuffId)then
return t.CurrBattleTeam.OpponentTeam:GetAllHerosExcludeHeroWithBuff(t.HeroId,i,o)
elseif(a==BattleHeroType.eColumnWithBuff)then
local a=t.CurrBattleTeam.OpponentTeam:GetColomnWithBuffId(i)
if a==nil then
a=e.GetEnemyRandomColumn(t,n)
end
return a
elseif(a==BattleHeroType.ePriorBackMaxFinalAtk)then
return t.CurrBattleTeam.OpponentTeam:GetMaxFinalAtkByPriorBack()
elseif(a==BattleHeroType.fWithDebuffWithoutControl)then
return t.CurrBattleTeam:GetHeroArrWithBuff(false,false,o)
elseif(a==BattleHeroType.eColumnMinHpPercent)then
local a=t.CurrBattleTeam.OpponentTeam:GetMinHpPercentHeroArr(2)
local a=a[1]
local o=e.GetBattleHeros_enemy(t)
if(a and o and a:CurrHPPer()<o:CurrHPPer())then
return e.GetTargetColumn(a,n)
else
return e.GetEnemyRandomColumn(t,n)
end
return nil
elseif(a==BattleHeroType.eColumnMaxHpPercent)then
local a=t.CurrBattleTeam.OpponentTeam:GetMaxHpPercentHeroArr()
local a=a[1]
local o=e.GetBattleHeros_enemy(t)
if(a and o and a:CurrHPPer()>o:CurrHPPer())then
return e.GetTargetColumn(a,n)
else
return e.GetEnemyRandomColumn(t,n)
end
return nil
elseif(a==BattleHeroType.eMinHpPercentWithCount)then
local e=t.CurrBattleTeam.OpponentTeam:GetMinHpPercentHeroArr(o)
return e
elseif(a==BattleHeroType.eMaxHpPercentWithCount)then
local e=t.CurrBattleTeam.OpponentTeam:GetMaxHpPercentHeroArr(o)
return e
elseif(a==BattleHeroType.fMinHpPercentWithCount)then
local e=t.CurrBattleTeam:GetMinHpPercentHeroArr(o)
return e
elseif(a==BattleHeroType.fMaxHpPercentWithCount)then
local e=t.CurrBattleTeam:GetMaxHpPercentHeroArr(o)
return e
elseif(a==BattleHeroType.ourLeadersExcludeSelf)then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
local a={}
for t=1,#e do
if e[t]:IsCampionLeader()then
table.insert(a,e[t])
end
end
return a
elseif(a==BattleHeroType.eFrontMaxHpPercentWithCount)then
local e=t.CurrBattleTeam.OpponentTeam:GetFrontOrBackHeros(true)
if(#e==0)then
e=t.CurrBattleTeam.OpponentTeam:GetFrontOrBackHeros(false)
end
local e=d:GetMaxHpPercentHeroArrByHeroArr(e,o)
return e
elseif(a==BattleHeroType.eBackMaxHpPercentWithCount)then
local e=t.CurrBattleTeam.OpponentTeam:GetFrontOrBackHeros(false)
if(#e==0)then
e=t.CurrBattleTeam.OpponentTeam:GetFrontOrBackHeros(true)
end
local e=d:GetMaxHpPercentHeroArrByHeroArr(e,o)
return e
elseif(a==BattleHeroType.fRandomFuryNotFullExcludeSelf)then
local e=t.CurrBattleTeam:GetAllHerosExcludeHero(t.HeroId)
local e=d:GetNotFullFuryHero(e,o)
return e
elseif(a==BattleHeroType.eMaxAddHpInBigRound)then
local e=s.bigRound
local e=t.CurrBattleTeam.OpponentTeam:GetMaxAddHpHeroArr(o,e)
return e
elseif(a==BattleHeroType.eRandomEnemyWithBuff)then
local e=t.CurrBattleTeam.OpponentTeam:GetRandomHeroWithGranBuff(true,o)
return e
elseif(a==BattleHeroType.eRandomEnemyWithDebuff)then
local e=t.CurrBattleTeam.OpponentTeam:GetRandomHeroWithGranBuff(false,o)
return e
elseif(a==BattleHeroType.fRandomSepsisHp)then
local e=t.CurrBattleTeam:GetRandomHeroWithSepsisHp(o)
return e
elseif(a==BattleHeroType.eRandomSepsisHp)then
local e=t.CurrBattleTeam.OpponentTeam:GetRandomHeroWithSepsisHp(o)
return e
elseif(a==BattleHeroType.fMostSepsisHp)then
local e=t.CurrBattleTeam:GetMostHeroWithSepsisHp(o)
return e
elseif(a==BattleHeroType.eMostSepsisHp)then
local e=t.CurrBattleTeam.OpponentTeam:GetMostHeroWithSepsisHp(o)
return e
elseif(a==BattleHeroType.fWithoutBuff)then
local e=t.CurrBattleTeam:GetAllHerosWithoutBuff(i,o)
return e
elseif(a==BattleHeroType.eWithoutBuff)then
local e=t.CurrBattleTeam.OpponentTeam:GetAllHerosWithoutBuff(i,o)
return e
elseif(a==BattleHeroType.fFightPet)then
local e=t.CurrBattleTeam:GetTeamFightPet()
return e
elseif(a==BattleHeroType.fMostTotalDamage)then
local e=t.CurrBattleTeam:GetMostTotalDamage(o)
return e
elseif(a==BattleHeroType.eMostTotalDamage)then
local e=t.CurrBattleTeam.OpponentTeam:GetMostTotalDamage(o)
return e
elseif(a==BattleHeroType.eFrontMinHpPercentWithCount)then
local e=t.CurrBattleTeam.OpponentTeam:GetFrontOrBackHeros(true)
if(#e==0)then
e=t.CurrBattleTeam.OpponentTeam:GetFrontOrBackHeros(false)
end
local e=d:GetMinHpPercentHeroArr(e,o)
return e
elseif(a==BattleHeroType.eBackMinHpPercentWithCount)then
local e=t.CurrBattleTeam.OpponentTeam:GetFrontOrBackHeros(false)
if(#e==0)then
e=t.CurrBattleTeam.OpponentTeam:GetFrontOrBackHeros(true)
end
local e=d:GetMinHpPercentHeroArr(e,o)
return e
elseif(a==BattleHeroType.fMaxFinalAtk)then
local e=t.CurrBattleTeam:GetMaxFinalAtk()
return e
end
end
function t.GetEnemyRandomColumn(t,a)
local t=e.GetBattleHeros_enemy(t)
if(t~=nil)then
return e.GetTargetColumn(t,a)
end
return nil
end
function t.GetTargetColumn(e,t)
if(e~=nil)then
local a=e.battleStationColumn
if(t)then
a=t
end
local e=e.CurrBattleTeam
if(e)then
local e=e:GetHerosWithColumn(a)
return e
end
end
return nil
end
function t.GetSelectFireHeroId()
if(e.SelectFireHero==nil)then
return 0
end
return e.SelectFireHero.HeroId
end
function t.SetSelectFireHeroWithId(t)
if(t==0)then
e.SelectFireHero=nil
return
end
e.SelectFireHero=e.HeroDic[t]
end
function t.CheckTargetCondition(e)
if e~=nil
and e.HeroBattleInfo
and e.HeroBattleInfo.CurrHP>0
and e:IsUsualState()then
return true
end
return false
end
function t.GetForceAttackHero(t)
local t=t:GetForceAttackHeroId()
if t~=0 then
local a=e.GetHeroCtrl(t)
if e.CheckTargetCondition(a)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return a
end
end
end
function t.GetBattleHeros_enemy(t)
local e=e.GetBattleHeros_enemyFirst(t)
if e then
local e,t=e:GetConvertTarget()
if e then
local a=t.buffId
local t=e.HeroBattleInfo:GetBuff(a)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
if e and e.OnConvertTarget then
e.OnConvertTarget(t)
end
end
return e
end
end
return e
end
function t.GetBattleHeros_enemyFirst(t)
local a=t.CurrBattleTeam.OpponentTeam
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local o=e.GetForceAttackHero(t)
if o then
return o
end
if(t.IsSmallSkillAttacking and t.SmallSkillMustAtkFirstAtkSelfHero)then
local t=a:GetHeroCtrlWithId(t.FirstAtkSelfHeroId)
if e.CheckTargetCondition(t)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return t
end
end
if(e.IsPVE()and t:IsOurTeamAttack()and e.SelectFireHero~=nil)then
if e.CheckTargetCondition(e.SelectFireHero)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return e.SelectFireHero
end
end
local t=a:GetFrontOrBackHeros(true)
if(#t>0)then
t=e.GetTargetHeroListByTargetLevel(t,a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(e.IsPVE()and e.GetIsOurTeamAttack())then
return t[1]
else
return t[RandomMgr:GetBattleRandomWithRange(1,#t)]
end
else
t=a:GetFrontOrBackHeros(false)
if(#t>0)then
t=e.GetTargetHeroListByTargetLevel(t,a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(e.IsPVE()and e.GetIsOurTeamAttack())then
return t[1]
else
return t[RandomMgr:GetBattleRandomWithRange(1,#t)]
end
end
end
return nil
end
function t.GetTargetHeroListByTargetLevel(e,t)
if#e>1 then
if t:NeedCheckTargetLevel()then
table.sort(e,function(t,e)
if t.TargetLevel~=e.TargetLevel then
return t.TargetLevel<e.TargetLevel
end
return t.battleStationIndex<e.battleStationIndex
end)
local o=e[1].TargetLevel
local t={}
for a=1,#e do
if e[a].TargetLevel<=o then
table.insert(t,e[a])
else
break
end
end
return t
end
end
return e
end
function t.IsPVE()
return e.BattleType==BattleType.campaign
or e.BattleType==BattleType.elite
or e.BattleType==BattleType.carnival
or e.BattleType==BattleType.newCarnival
or e.BattleType==BattleType.GoldHoliday
or e.BattleType==BattleType.bigBoss
or e.BattleType==BattleType.waterMelon
or e.BattleType==BattleType.trial
or e.BattleType==BattleType.maze
or e.BattleType==BattleType.guide
or e.BattleType==BattleType.skillPreview
or e.BattleType==BattleType.idle
or e.BattleType==BattleType.thiefCrusade
or e.BattleType==BattleType.dragonWar
or e.BattleType==BattleType.guildBossPersonal
or e.BattleType==BattleType.guildBossGuild
or e.BattleType==BattleType.guildTrials
or e.BattleType==BattleType.SpringRain
or e.BattleType==BattleType.selfMarryBoss
or e.BattleType==BattleType.urBossFight
or e.BattleType==BattleType.urBackBossFight
or e.BattleType==BattleType.urTestFight
or e.BattleType==BattleType.Inspiration
or e.BattleType==BattleType.selfMarryBack
or e.BattleType==BattleType.burningBuild
or e.BattleType==BattleType.lrBossFight
or e.BattleType==BattleType.lrTestFight
or e.BattleType==BattleType.girlChallenge
or e.BattleType==BattleType.GuildRadar
end
function t.OnPlayDamagePoint(a)
local t=e.HeroDic[e.CurrAttackHeroId]
if(t)then
t:CheckAttackNeedHealthFury()
end
local t=e.CurrBeAttackHeroIdTableDic[a]
if(t)then
local o=#t
for o=1,o do
local e=e.HeroDic[t[o]]
if(e)then
e:PlayHurt(a)
end
end
end
end
function t.CheckHurtValue(t)
if(e.OurTeam==nil or e.EnemyTeam==nil)then
return
end
e.OurTeam:CheckHurtValue(function()
e.EnemyTeam:CheckHurtValue(function()
if t then
t()
end
end)
end)
end
function t.CheckHpHealth()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(e.OurTeam==nil or e.EnemyTeam==nil)then
return
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.OurTeam:CheckHpHealth()
e.EnemyTeam:CheckHpHealth()
end
function t.ResetHpHealthInTimeLine()
e.OurTeam:ResetHpHealthInTimeLine()
e.EnemyTeam:ResetHpHealthInTimeLine()
end
function t.ResetAttrValuesInCurAttack()
e.OurTeam:ResetAttrValuesInCurAttack()
e.EnemyTeam:ResetAttrValuesInCurAttack()
end
function t.CheckHeroDie(t)
if(ModulesInit.ProcedureNormalBattle.IsBattleTest)then
return
end
if(e.OurTeam==nil or e.EnemyTeam==nil)then
return
end
e.OurTeam:CheckHeroDie(function()
e.EnemyTeam:CheckHeroDie(function()
e.ResetBuffInCurAttack()
if t then
t()
end
end)
end)
end
function t.CheckHeroDieWhenWaiting()
if(ModulesInit.ProcedureNormalBattle.IsBattleTest)then
return
end
if(e.OurTeam==nil or e.EnemyTeam==nil)then
return
end
e.OurTeam:CheckHeroDieWhenWaiting()
e.EnemyTeam:CheckHeroDieWhenWaiting()
end
function t.ResetBuffInCurAttack()
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
if(e.OurTeam==nil or e.EnemyTeam==nil)then
return
end
e.OurTeam:ResetBuffInCurAttack()
e.EnemyTeam:ResetBuffInCurAttack()
end
function t.HurtToDeath()
if(e.CurrBeAttackHeroIdTableDic[0]==nil)then
return
end
for a,t in ipairs(e.CurrBeAttackHeroIdTableDic[0])do
local e=e.HeroDic[t]
if(e~=nil)then
e:ChangeDeathState()
end
end
end
function t.GetRemedyValue(e,t)
return t*(1+(Constant.battle_critical_rate+e.HeroBattleInfo.CriticalStrength+e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.criticalStrengthRateAdd))*MillionCoe)
end
function t.OnClickCallBack(t)
if(e.CurrIsAttacking)then
return
end
GameEntry.Lua:PlayerOnClick(
function(t)
local t=e.HeroDic[t]
if(t==nil)then
return
end
if(t.IsOurHero)then
return
end
if(t.battleStationRow==2)then
if(t.CurrBattleTeam:HasFirstRowHero())then
UIUtil.ShowCommonTips(GameTools.GetLocalize("tips.common_88",LanguageCategory.LangCommon))
return
end
end
if t:IsDeathOrWaitState()then
return false
end
if(t:IsNotUsualState())then
return
end
if(e.SelectFireHero and e.SelectFireHero.HeroId==t.HeroId)then
return
end
e.SelectFireHero=t
e.ShowFireEffect(true)
end
)
end
function t.OnClickJihuoCallBack(t)
local t=e.HeroDic[t]
if(t and e.SelectFireHero and e.SelectFireHero.HeroId==t.HeroId)then
return
end
e.SelectFireHero=t
e.ShowFireEffect(true)
end
function t.AutoSelectFireHero()
if(e.SelectFireHero==nil or(e.SelectFireHero.HeroBattleInfo~=nil and e.SelectFireHero.HeroBattleInfo.CurrHP<=0))then
e.SelectFireHero=e.EnemyTeam:AutoSelectFireHero()
e.ShowFireEffect(false)
end
end
function t.LoadFireEffect()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
GameTools:PoolGameObjectSpawn(
SysPrefabId.FireEffect,
nil,
function(t,a,a)
e.FireEffectTrans=t
e.FireEffectTrans.position=Vector3(0,10000,0)
end
)
GameTools:PoolGameObjectSpawn(
SysPrefabId.FireEffectFocus,
nil,
function(t,a,a)
e.FireEffectFocusTrans=t
LuaUtils.SetActive(e.FireEffectFocusTrans,false)
end
)
end
function t.UnLoadFireEffect()
if(e.FireEffectTrans~=nil)then
GameEntry.Pool:GameObjectDespawn(e.FireEffectTrans)
e.FireEffectTrans=nil
end
if(e.FireEffectFocusTrans~=nil)then
GameEntry.Pool:GameObjectDespawn(e.FireEffectFocusTrans)
e.FireEffectFocusTrans=nil
end
end
function t.ShowFireEffect(a)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
if(e.IsAutoMode)then
e.HideFireEffect()
return
end
if(IsNil(e.SelectFireHero))then
e.HideFireEffect()
return
end
local t=e.SelectFireHero:GetMiddlePointPos()
if(IsNil(t))then
e.HideFireEffect()
return
end
e.HideFireEffect()
if(a)then
if(not IsNil(e.FireEffectFocusTrans))then
e.FireEffectFocusTrans.position=t
LuaUtils.SetActive(e.FireEffectFocusTrans,true)
local a=ModulesInit.TimeActionMgr.CreateTimeAction()
a:Init(
0.2,
0,
1,
nil,
nil,
function()
if(not IsNil(e.FireEffectTrans))then
e.FireEffectTrans.position=t
end
end
):Run()
end
else
if(not IsNil(e.FireEffectTrans))then
e.FireEffectTrans.position=t
end
end
end
function t.HideFireEffect()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
if(not IsNil(e.FireEffectTrans))then
e.FireEffectTrans.position=Vector3(0,10000,0)
LuaUtils.SetActive(e.FireEffectFocusTrans,false)
end
end
function t.GetSkillChangeData(i,e,r,s,h,n,t,a,o)
return{
SkillChangeType=i,
SkillId=e,
beAttackHeroCtrls=r,
checkFunc=s,
skillType=h,
skillParam=n,
replacePrefabIndex=t,
completeCheckFunc=a,
replacePrefabSkillId=o
}
end
function t.SkillHurt(t,e,a,h,n,s,o)
if(e.HeroBattleInfo==nil)then
return
end
o=o or{}
if t.DisableDefRageInExSkill then
if(a.type==AttackType.BigSkill)then
o.openAddFury=false
e:SetDisableDefRage(true)
end
end
n=n==nil and 0 or n
s=s==nil and 0 or math.floor(s)
local i=0
local s=e:GetHurtValue(t,a.type,h,n,a,s,o)
local o=s.hurtValue
local h=s.criticalOrBlock
local h=s.isArmor
if(a.type==AttackType.BigSkill)then
e:Hurt(o,n,a.segment,AttackType.BigSkill,h)
i=math.min(o,e.HeroBattleInfo.CurrHP)
t:AddTotalDamage(i)
e:AddTotalBear(i)
elseif(a.type==AttackType.SmallSkill)then
e:Hurt(o,n,a.segment,AttackType.SmallSkill,h)
i=math.min(o,e.HeroBattleInfo.CurrHP)
t:AddTotalDamage(i)
e:AddTotalBear(i)
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.afterNormalOrSmallSkillAttacked,t,e)
elseif(a.type==AttackType.Normal)then
e:Hurt(o,n,a.segment,AttackType.Normal,h)
i=math.min(o,e.HeroBattleInfo.CurrHP)
t:AddTotalDamage(i)
e:AddTotalBear(i)
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.afterNormalOrSmallSkillAttacked,t,e)
elseif(a.type==AttackType.PetFightSkill or a.type==AttackType.PetHelpSkill)then
e:Hurt(o,n,a.segment,a.type,h)
i=math.min(o,e.HeroBattleInfo.CurrHP)
t:AddTotalDamage(i)
e:AddTotalBear(i)
end
local i=s.reduceHpValue
d:AddSepsisHpByHurt(t,e,i)
if(a.type~=AttackType.BigSkill)then
t:AddFuryWithSoul(SoulAddFuryType.atkRage)
end
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.afterAttacked,t,e,s)
if t.DisableDefRageInExSkill then
if(a.type==AttackType.BigSkill)then
e:SetDisableDefRage(false)
end
end
if((e.HeroBattleInfo.CurrHP-o)<=0)then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.kill)
if(e:IsUsualStateWithCheckKill())then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.realKill)
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.realKill)
t:FuryHealth(FuryHealthType.Kill)
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
end
return{o,true,s}
end
return{o,false,s}
end
function t.SkillHurtWithTeam(h,e,i,s,o,t,a)
if(e.HeroBattleInfo==nil)then
return
end
a=a or{}
o=o==nil and 0 or o
t=t==nil and 0 or math.floor(t)
local n=0
local a=q:GetTeamHurtValue(h,i.type,s,o,e,i,t,a)
local t=a.hurtValue
local s=a.criticalOrBlock
local s=a.isArmor
e:Hurt(t,o,i.segment,i.type,s)
n=math.min(t,e.HeroBattleInfo.CurrHP)
e:AddTotalBear(n)
if((e.HeroBattleInfo.CurrHP-t)<=0)then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.kill)
if(e:IsUsualStateWithCheckKill())then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.realKill)
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
end
return{t,true,a}
end
return{t,false,a}
end
function t.StealFury(a,t,o,i,s,n)
if t and t.HeroBattleInfo and t.HeroBattleInfo.CurrHP>0 then
local e=o
if n~=true then
e=math.min(o,t.HeroBattleInfo.CurrFury)
end
if(e>0)then
if i==EBattleSrcType.Buff then
a:AddFuryWithBuffImmediately(e)
t:ReduceFuryWithBuffImmediately(e)
else
a:AddFuryWithSkill(e)
t:ReduceFuryWithSkill(e,a,i,s)
end
end
return e
end
return 0
end
function t.KillHeroWithBuff(t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local e=e.HeroDic[t]
if(e==nil or e.HeroBattleInfo.CurrHP<=0)then
return
end
e:FuryHealth(FuryHealthType.Kill)
end
function t.DefaultBattle()
return z.New()
end
function t.AddFirstAtkOtherHeroEffect(t)
local e=e.HeroDic[t]
if(e~=nil)then
e:AddFirstAtkOtherHeroEffect()
end
end
function t.HeroResetPos()
for t,e in pairs(e.HeroDic)do
e:ResetPos()
end
end
function t.AddTimer(t)
m(e.timerList,t)
end
function t.RemoveTimer(o)
for t=#e.timerList,1,-1 do
local a=e.timerList[t]
if(a.Id==o.Id)then
table.remove(e.timerList,t)
break
end
end
end
function t.AddTweener(t)
m(e.tweenerTable,t)
end
function t.KillAllTweener()
for a,t in pairs(e.tweenerTable)do
if(t)then
t:Kill()
end
end
e.tweenerTable={}
end
function t.SetMVPHeroDId()
local a={}
for t=1,#FightDataReportMgr.waveData do
local t=FightDataReportMgr.waveData[t].heroStatistics
if(t)then
for o=1,#t do
local t=t[o]
if(t.isOurHero and e.IsPetByDid(t.heroDid)==false)then
if not a[t.heroId]then
a[t.heroId]=t.outputDmg
else
a[t.heroId]=a[t.heroId]+t.outputDmg
end
end
end
end
end
local o=0
local t=-1
for a,e in pairs(a)do
if(e>t)then
t=e
o=a
end
end
for t=1,#FightDataReportMgr.waveData do
local t=FightDataReportMgr.waveData[t].heroStatistics
if(t)then
for a=1,#t do
local t=t[a]
if(t.isOurHero)then
if(t.heroId==o)then
e.mvpHeroDid=t.heroDid
break
end
end
end
end
end
end
function t.GetMVPHeroDId()
return e.mvpHeroDid
end
function t.SetIsAutoCloseSkipView(t)
e.IsAutoCloseSkipView=t
end
function t.GetIsAutoCloseSkipView()
return e.IsAutoCloseSkipView
end
function t.StopAllCoroutine()
e.StopCoroutine()
e.OurTeam:StopCoroutine()
e.EnemyTeam:StopCoroutine()
end
function t.StopCoroutine()
if(e.coroutine_WaitBeginBattle)then
h.stop(e.coroutine_WaitBeginBattle)
e.coroutine_WaitBeginBattle=nil
end
if(e.coroutine_BattleRoundBeginAddBuff)then
h.stop(e.coroutine_BattleRoundBeginAddBuff)
e.coroutine_BattleRoundBeginAddBuff=nil
end
if(e.coroutine_BattleRoundBeginAddAfterBuff)then
h.stop(e.coroutine_BattleRoundBeginAddAfterBuff)
e.coroutine_BattleRoundBeginAddAfterBuff=nil
end
if(e.coroutine_BattleAllBigRoundBegin)then
h.stop(e.coroutine_BattleAllBigRoundBegin)
e.coroutine_BattleAllBigRoundBegin=nil
end
if(e.coroutine_BattleSmallRoundBegin)then
h.stop(e.coroutine_BattleSmallRoundBegin)
e.coroutine_BattleSmallRoundBegin=nil
end
e.Stop1v1MaxTurnCoroutine()
e.StopAttackTaskCoroutine()
end
function t.Dispose(a)
if(GameInit.IsClient)then
for a,t in pairs(e.timerList)do
t:Stop()
end
e.timerList={}
e.KillAllTweener()
EventSystem.SendEvent(CommonEventId.OnShowBattleStart,false)
EventSystem.SendEvent(CommonEventId.OnShowBattleTurnOver,false)
if(a)then
if(e.ScenePrefabTrans~=nil)then
e.ScrollSceneCtrl=nil
GameEntry.Pool:GameObjectDespawn(e.ScenePrefabTrans)
e.ScenePrefabTrans=nil
end
end
e.RemoveBattleUI3D()
e.UnLoadFireEffect()
ModulesInit.BattleSkillEffectManager.Dispose()
if e.BgEffectMgr then
e.BgEffectMgr:Dispose()
end
e.StopCoroutine()
end
e.DisposeBattleTeam()
e.RemoveAllDeadHero()
end
function t.ShowOrHideSpecialEffect(t)
if(e.OurTeam)then
e.OurTeam:ShowOrHideSpecialEffect(t)
end
if(e.EnemyTeam)then
e.EnemyTeam:ShowOrHideSpecialEffect(t)
end
end
function t.SetBattleEnd(t)
e.isBattleEnd=t
end
function t.Exit()

if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then
end
e.IsRespBattleInfo=false
e.BattleResultReqCount=0
e.IsRespBattleSuc=false
e.isBattleEnd=true
e.Dispose(true)
if(GameInit.IsClient)then
GameTools.CloseUIForm(e.IsBattleTest and UIFormId.UI_TestBattle or UIFormId.UI_NormalBattle)
GameTools.CloseUIForm(UIFormId.UI_Global)
GameTools.CloseUIForm(UIFormId.UI_Idle)
if GameEntry.UI:IsExists(UIFormId.UI_NormalBattleSkipView)and e.GetIsAutoCloseSkipView()then
GameTools.CloseUIForm(UIFormId.UI_NormalBattleSkipView)
end
GameEntry.Scene:UnLoadScene(nil)
e.ClearHitNumSprite()
end
if e.curProcedureBattle then
e.curProcedureBattle:Destroy()
end
if(GameInit.IsClient)and e.BattleType==BattleType.dragonWar then
GameEntry.Audio:StopBGM()
end
local t=e.IsOpenCurBattleCheck
local a=e.BattleCheckType
local o=e.IsSaveLog
e.ResetData()
e.CheckAndExcuteCurBattleLogCheck(t,a,o)
if GameInit.IsClient then
collectgarbage("collect")
end
end
function t.CloseBattleUI()
GameTools.CloseUIForm(e.IsBattleTest and UIFormId.UI_TestBattle or UIFormId.UI_NormalBattle)
end
function t.CheckAndExcuteCurBattleLogCheck(t,e,a)
if GameInit.CheckOpenCurBattleLogRecordAndCheck()then
if GameInit.DebugLog and t==true then
local t=false
if e==FightCheckType.ClientBattle then
FightLogMgr:PrintClientRecordLogByName("bbclient_log.txt")
FightDataReportMgr:CheckSaveFightPlayByName("bbclient_record.txt")
elseif e==FightCheckType.ClientBattle2 then
FightLogMgr:PrintClientRecordLogByName("bbclient2_log.txt")
FightDataReportMgr:CheckSaveFightPlayByName("bbclient2_record.txt")
elseif e==FightCheckType.ClientReplay then
FightLogMgr:PrintClientRecordLogByName("bbclient_replay_log.txt")
FightDataReportMgr:CheckSaveFightPlayByName("bbclient_replay_record.txt")
elseif e==FightCheckType.ServerBattle then
FightLogMgr:PrintServerRecordLogByName("bbserver_log.txt")
FightDataReportMgr:CheckSaveFightPlayByName("bbserver_record.txt")
t=true
elseif e==FightCheckType.ServerBattle2 then
FightLogMgr:PrintServerRecordLogByName("bbserver2_log.txt")
FightDataReportMgr:CheckSaveFightPlayByName("bbserver2_record.txt")
t=true
elseif e==FightCheckType.ServerCheck then
FightLogMgr:PrintServerRecordLogByName("bbsever_check_log.txt")
FightDataReportMgr:CheckSaveFightPlayByName("bbsever_check_record.txt")
t=true
end
FightDataReportMgr:CheckSaveFightPlayByName("last_battle_report.txt")
if GameInit.IsOpenMockBattleCheck and t==false then
if GameInit.IsEditor then
FightLogMgr:PrintClientRecordLog()
end
end

else

end
end
end
function t.BackupAllHeroBeforeTimeLine()
for t,e in pairs(e.HeroDic)do
e:BackupBeforeTimeLine()
end
end
function t.RestoreAllHeroAfterTimeLine()
for t,e in pairs(e.HeroDic)do
e:RestoreAfterTimeLine()
end
end
function t.GetRemoveHeroId()
e.CurRemoveHeroId=e.CurRemoveHeroId+1
return e.CurRemoveHeroId
end
function t.AddDeadHero(a)
if GameInit.IsClient then
local t=e.GetRemoveHeroId()
local a=_:Create(t,a)
a:OnOpen()
e.DeadHeroMap[t]=a
end
end
function t.RemoveDeadHero(t)
if GameInit.IsClient then
if e.DeadHeroMap[t]then
e.DeadHeroMap[t]:OnClose()
e.DeadHeroMap[t]=nil
end
end
end
function t.RemoveAllDeadHero()
if GameInit.IsClient then
for t,a in pairs(e.DeadHeroMap)do
e.RemoveDeadHero(t)
end
end
e.DeadHeroMap={}
end
function t.SetInLevelTestMode(t)
if GameInit.IsClient then
e.IsInLevelTestMode=t
e.IsTestMode=t
end
end
function t.SetSaveLog(t)
if GameInit.IsClient then
e.IsSaveLog=t
end
end
function t:AddManualSelfSkillRes()
if e.FightPlayData==nil and not e.IsAutoMode and not e.IsSkipBattle then
local t={}
for a,e in ipairs(e.OurTeam.HeroCtrls or{})do
table.insert(t,e.heroDid)
end
if GameInit.IsClient then
f:AsyncPreloadSelfAllRes(t)
end
end
end
function t.AddNextSkillRes(t)
local e=ModulesInit.ProcedureNormalBattle.HeroDic[t.heroId]
if e~=nil then
if t.actionType==1 then
local e=e.BigSkillId
local e=y.GetEntity(e)
if e then
if GameInit.IsClient then
f:AsyncPreloadSkillAllRes(e.prefabId,true)
end
end
elseif t.actionType==2 then
if e.CurrRoundCanTriggerSmallSkill then
drSkillAtc=y.GetEntity(e.SmallSkillId)
else
drSkillAtc=y.GetEntity(e.NormalSkillId)
end
if drSkillAtc then
if GameInit.IsClient then
f:AsyncPreloadSkillAllRes(drSkillAtc.prefabId,true)
end
end
end
end
end
function t.Set1v1HeadInfo(a,t)
local t=d:GetHeroHeadInfo(t)
if a then
local o=e.leftInfo and e.leftInfo.level or 0
local a=e.leftInfo and e.leftInfo.name or""
e.SetLeftInfo(t.headId,nil,a,o)
else
local o=e.rightInfo and e.rightInfo.level or 0
local a=e.rightInfo and e.rightInfo.name or""
e.SetRightInfo(t.headId,nil,a,o)
end
EventSystem.SendEvent(CommonEventId.ExpeditionMonsterInfoUpdate)
local t=e.OurTeam:GetFirst()
e.OurTeam.TotalFirstValue=t
e.OurTeam:ShowFirst()
local t=e.EnemyTeam:GetFirst()
e.EnemyTeam.TotalFirstValue=t
e.EnemyTeam:ShowFirst()
end
function t.GetBattle1V1SmallStartRound()
return e.mBattle1V1SmallStartRound
end
function t.GetHitNumSprite(t)
return e.HitNumSpriteMap[t]
end
function t.AddHitNumSprite(a,t)
e.HitNumSpriteMap[a]=t
end
function t.ClearHitNumSprite()
e.HitNumSpriteMap={}
end
function t.GetAllLackCount()
local t=0
if e.OurTeam then
t=e.OurTeam:GetLackCount()
end
local a=0
if e.EnemyTeam then
a=e.EnemyTeam:GetLackCount()
end
return t+a
end
function t.IsEveryTeamHasOneHero()
local t=0
if e.OurTeam then
t=e.OurTeam:GetAllHerosCount()
end
local a=0
if e.EnemyTeam then
a=e.EnemyTeam:GetAllHerosCount()
end
if t==1 and a==1 then
return true
end
return false
end
function t.GetBattleDataType()
local e=e.battleDataType
if GameInit.IsClient then
if e==""then
e=PlayerMgr.battleDataType
end
end
return e
end
function t.GetMonsterCfgData()
local e=e.GetBattleDataType()
return s.GetMonsterCfgDataByType(e,ModulesInit.ProcedureNormalBattle.BattleType)
end
function t.GetMonsterAttrCfgData()
local e=e.GetBattleDataType()
return s.GetMonsterAttrCfgDataByType(e,ModulesInit.ProcedureNormalBattle.BattleType)
end
function t.GetMapWaveCfgData()
local e=e.GetBattleDataType()
s.GetMapWaveCfgDataByType(e,ModulesInit.ProcedureNormalBattle.BattleType)
end
function t.GetAllHeroDeadCount()
local t=0
for e,e in pairs(e.heroDeadMap)do
t=t+1
end
return t
end
function t.GetWaveData()
if(e.FightBeforeData)then
local e=e.FightBeforeData.waveData
return e
end
return nil
end
function t.PlayTimeLinenPreview(t,a)
GameEntry.Pool:GameObjectSpawn(
t,
nil,
function(e,o,o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.BattleSkillEffectManager.CurrTimelineEffect=e:GetComponent(typeof(CS.YouYou.TimelineEffect))
BuildPatchMgr:PlayTimeLine(ModulesInit.BattleSkillEffectManager.CurrTimelineEffect)
f:PreloadMp4(t,function()
ModulesInit.ProcedureNormalBattle.ShowOrHideSpecialEffect(false)
ModulesInit.ProcedureNormalBattle.CurrTimelineEffectAttackPointCount=ModulesInit.BattleSkillEffectManager.CurrTimelineEffect.AttackPointCount
OpenOrCloseBloom(true)
ModulesInit.BattleSkillEffectManager.CurrTimelineEffect.OnStopped=function()
if GameTools:CheckRestartGameState()then
return
end
ModulesInit.BattleSkillEffectManager:StopCurVideo()
OpenOrCloseBloom(false)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if a then
a()
end
end
end)
end
)
end
function t.PreviewPlaySubstituteInPreview(o,a,t)
for e=1,#a do
local e=a[e]
ModulesInit.ProcedureNormalBattle.LoadPlayerHero(e,e.position-1,e.isOurTeam,true)
FightDataReportMgr:AddSupplementData(e.position,e.heroId)
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local a=ModulesInit.TimeActionMgr.CreateTimeAction()
e.AddTimer(a)
a:Init(
0,
o,
1,
nil,
nil,
function()
e.RemoveTimer(a)
if t then
t()
end
end
):Run()
else
if t then
t()
end
end
end
function t.PlayInstantSkillInPreview(o,t,a)
for a=1,#t do
local a=t[a]
local t=a.heroId
local t=e.GetHeroCtrl(t)
if t then
local e=a.defActionList
for a=1,#e do
local e=e[a]
if e[1]==ModulesInit.BattlePreviewMgr.EAttackResultType.damage then
t:RealHurtInpreview(e[2],e[2],HeroHurtType.hurtPoint)
elseif e[1]==ModulesInit.BattlePreviewMgr.EAttackResultType.heroDid then
elseif e[1]==ModulesInit.BattlePreviewMgr.EAttackResultType.heroState then
t:ChangePreviewState(e[2])
elseif e[1]==ModulesInit.BattlePreviewMgr.EAttackResultType.AddHp then
t:HpHealthInPreview(e[2],false)
elseif e[1]==ModulesInit.BattlePreviewMgr.EAttackResultType.heroDeadState then
t:SetHeroPreviewDeadState(e[2])
end
end
end
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local t=ModulesInit.TimeActionMgr.CreateTimeAction()
e.AddTimer(t)
t:Init(
0,
o,
1,
nil,
nil,
function()
e.RemoveTimer(t)
if a then
a()
end
end
):Run()
else
if a then
a()
end
end
end
function t.SetBgMusic(t)
e.musicBgId=t
end
function t.AddBuffToEnemysInEditor()
local e=ModulesInit.ProcedureNormalBattle.CurrAttackHeroId
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if a then
local e=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroIdTable(0)
local t=#e
for t=1,t do
local t=ModulesInit.ProcedureNormalBattle.HeroDic[e[t]]
if(t~=nil)then
local i=1005
local o=2
local e={1000}
t:AddBuff(a,i,o,e)
local e=ModulesInit.ProcedureNormalBattle.battleSettingInEditor
if e then
t:AddBuffEffectInEditor(e.BuffPrefab,e.BuffPosType,e.IsMirror,function()
end)
end
end
end
end
end
function t.RemoveAllHeroBuffEffectInEditor()
for t,e in pairs(e.HeroDic)do
if e.HeroBattleInfo then
e.HeroBattleInfo:DisposeBuff()
e:RemoveAllBuffEffectTrans()
end
end
end
function t.AddSkillFireCount()
e.skillCount=e.skillCount+1
return e.skillCount
end
function t.GetSkillFireCount()
return e.skillCount
end
function t.IsPetByBattleStationIndex(e)
if e>=6 then
return true
else
return false
end
end
function t.IsPetByDid(e)
if e>80000 and e<=90000 then
return true
else
return false
end
end
function t.IsPetByStation(e)
if e>100 then
return true
else
return false
end
end
function t.IsFightPetByBattleStationIndex(e)
if e==EBattlePetStationIndex.Fight then
return true
else
return false
end
end
function t.GetTransIndexByStation(t)
if e.IsPetByStation(t)then
if t==EBattlePetStation.Fight then
return EBattlePetStationIndex.Fight
elseif t==EBattlePetStation.Help1 then
return EBattlePetStationIndex.Help1
elseif t==EBattlePetStation.Help2 then
return EBattlePetStationIndex.Help2
end
else
return t
end
end
function t.SetSkillAttackType(t)
e.CurrSkillAttackType=t
end
function t.GetSkillAttackType(t)
return e.CurrSkillAttackType
end
function t.IsSkillAttackType(t)
return e.CurrSkillAttackType==t
end
function t.IsHeroSkillAttackState()
if e.IsSkillAttackType(EBattleSkillAttackType.BigSkillAttacking)
or e.IsSkillAttackType(EBattleSkillAttackType.SmallSkillAttacking)
or e.IsSkillAttackType(EBattleSkillAttackType.SmallRoundStartTeamAttacking)then
return true
end
return false
end
function t.ForbidAttack(t)
if e.BattleType==BattleType.arena then
if e.stakeType==t then
return true
end
end
return false
end
function t.IsStakeFight()
if e.BattleType==BattleType.arena then
if e.stakeType>0 then
return true
end
end
return false
end
function t.IsStakeFightMaxRound()
local e=e.GetStakeFightParam(EFakeBattleParamType.test_max_round)
if e==0 then
e=999999999
end
return e
end
function t.IsStakeFightUndead()
if e.IsStakeFight()then
local e=e.GetStakeFightParam(EFakeBattleParamType.test_undead)
if e==0 then
return false
else
return true
end
end
return false
end
function t.IsStakeFightOpenNewFury(t)
if e.IsStakeFight()then
local e=e.GetStakeFightParam(EFakeBattleParamType.isnew)
if e==0 then
return false
elseif e==3 then
return true
else
if e==1 and t==true then
return true
elseif e==2 and t==false then
return true
end
end
end
return false
end
function t.GetStakeFightParam(t)
if e.stakeFightParamMap[t]then
return e.stakeFightParamMap[t]
end
return 0
end
function t.GetSoulFuryValueInFakeFight(a,t)
if(t==SoulAddFuryType.startRage)then
return e.GetStakeFightParam(EFakeBattleParamType.test_talent_startRage)
elseif(t==SoulAddFuryType.roundRage)then
return 0
elseif(t==SoulAddFuryType.defRage)then
if a==1220 then
return e.GetStakeFightParam(EFakeBattleParamType.test_talent_defRage_1)
elseif a==1320 then
return e.GetStakeFightParam(EFakeBattleParamType.test_talent_defRage_2)
end
elseif(t==SoulAddFuryType.atkRage)then
return 0
elseif(t==SoulAddFuryType.deadRage)then
if a==1620 then
return e.GetStakeFightParam(EFakeBattleParamType.test_talent_deadRage_1)
elseif a==1720 then
return e.GetStakeFightParam(EFakeBattleParamType.test_talent_deadRage_2)
end
elseif(t==SoulAddFuryType.killRage)then
if a==1620 then
return e.GetStakeFightParam(EFakeBattleParamType.test_talent_killRage_1)
elseif a==1720 then
return e.GetStakeFightParam(EFakeBattleParamType.test_talent_killRage_2)
end
end
return 0
end
function t.GetTotalSmallRound()
return(ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-1)*2+ModulesInit.ProcedureNormalBattle.CurrBattleSmallRound
end
function t:GetTeamSkillArgs(t)
local e=nil
if ModulesInit.ProcedureNormalBattle.IsPVE()then
e=t.args
else
e=t.argsPvp
end
return e
end
function t:PlayAudioLua(t)
if e.IsSkipBattle==false and type(t)=="number"then
if e.audioTimeStampMap[t]==nil or Time.realtimeSinceStartup-e.audioTimeStampMap[t]>0.5 then
e.audioTimeStampMap[t]=Time.realtimeSinceStartup
GameTools:PlayAudioLua(t)
end
end
end
function t:GetAllBuffIconShowMap()
local a={}
for o,e in pairs(e.HeroDic)do
local t=e.battleStationIndex+1
if e.IsOurHero==false then
t=t*-1
end
if e:IsDeathState()==false then
a[t]={
heroId=o,
}
end
end
return a
end
function t.RecordBuffDamage(t,a,n)
if e.buffStaticsDamageMap[t]==nil then
e.buffStaticsDamageMap[t]={}
end
local o=e.buffStaticsDamageMap[t]
if o[a]==nil then
local i=e.GetHeroCtrl(t)
local e=0
if i then
e=i.heroDid
end
o[a]={
heroId=t,
heroDid=e,
buffId=a,
hurtValue=0
}
end
local e=o[a]
e.hurtValue=e.hurtValue+n
end
function t:PrintBuffDamage()
for t,e in pairs(e.buffStaticsDamageMap)do
for a,e in pairs(e)do
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
return t

