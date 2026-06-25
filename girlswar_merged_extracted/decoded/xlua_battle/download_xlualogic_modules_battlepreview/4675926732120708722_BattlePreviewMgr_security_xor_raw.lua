local e=require("DataNode/DataTable/Create/model/DTmodelDBModel")
local l=require("DataNode/DataTable/Create/monster/DTMonsterDBModel")
local s=require("DataNode/DataTable/Create/monster/DTMonsterAttrDBModel")
local d=require("DataNode/DataTable/Create/skillAct/DTBattlePreviewDBModel")
local h=require("DataNode/DataTable/Create/skillAct/DTBattlePreviewDetailDBModel")
local o=require('DataNode/DataTable/Create/skillAct/DTSkillActDBModel')
local r=require("Modules/Battle/BattleUtil")
local e={
isNewPlayerBattle=false,
skipShowInterval=3,
}
local a=6
e.EOperType={
FireSkill=1,
Substitute=2,
Talk=3,
InstantSkill=4,
PlayBgMusic=5,
}
e.EAttackResultType={
damage=1,
heroState=2,
heroDid=3,
AddHp=4,
heroDeadState=5,
}
e.EHeroState={
None=0,
MustDie=1,
Kneel=2,
}
e.EHeroDeadState={
None=0,
MustDieOnAttacked=1,
KneelOnDie=2,
KneelOnDieAndAudio=3,
}
e.EPreviewState={
None=0,
Ready=1,
Running=2,
Over=3,
}
e.ESceneCutType={
None=0,
Blur=1,
Black=2,
White=3,
White_Change=4,
}
function e:Init()
end
function e:Reset()
self.previewState=e.EPreviewState.None
self.mapDid=0
self.completeCallback=nil
self.mMapData=nil
self.mBattlePreviewDetailList={}
self.mIndex=0
self.isForm=false
self.skipShowStartTime=0
end
function e:Dispose()
self:Reset()
end
function e:StartNewPlayerBattle(e)
self:StartBattle(920001,e)
local e=self:GetNewPlayerBattleKey()
SaveMgr.SetBoolByAccServerId(e,nil,true)
end
function e:GetInNewPlayerBattle()
return self.isNewPlayerBattle
end
function e:SetInNewPlayerBattle(e)
self.isNewPlayerBattle=e
end
function e:CheckNewPlayerBattle()
if ModulesInit.GuideMgr.isOpenGuide==false then
return false
end
local e=self:GetNewPlayerBattleKey()
local e=SaveMgr.GetBoolByAccServerId(e,nil,false)
if e==true then
return false
end
return true
end
function e:GetNewPlayerBattleKey()
local e="battle_new_player_"
return e
end
function e:StartBattle(e,t)
if GameEntry.UI:IsExists(UIFormId.UI_Global)==false then
GameEntry.UI:OpenUIForm(UIFormId.UI_Global)
end
DynamicModuleRes.BattlePreviewDownLoad(e,function()
GameEntry.UI:OpenUIForm(
UIFormId.UI_CommonLoading,
{
style=LoadingStyle.Black,
loadResFinish=function()
self:EnterBattle(e,t)
end
}
)
end,BattleType.skillPreview)
end
function e:EnterBattle(t,a)
self:Reset()
self:ChangeState(e.EPreviewState.Ready)
self.mapDid=t
self.completeCallback=a
self.mBattlePreviewDetailList=self:ReadBattleDetailData(t)
self.mMapData=self:GetPreviewMapCfgData(t)
local a=GameTools.GetLocalize(self.mMapData.leftName,LanguageCategory.LangBattle)or""
local e=GameTools.GetLocalize(self.mMapData.rightName,LanguageCategory.LangBattle)or""
ModulesInit.ProcedureNormalBattle.MapPrefabId=self.mMapData.mapPrefabId
ModulesInit.ProcedureNormalBattle.MapId=t
ModulesInit.ProcedureNormalBattle.IsBattleTest=false
ModulesInit.ProcedureNormalBattle.IsAutoMode=true
ModulesInit.ProcedureNormalBattle.BattleType=BattleType.skillPreview
ModulesInit.ProcedureNormalBattle.openLoading=false
ModulesInit.ProcedureNormalBattle.IsShowDreamBlackImg=true
ModulesInit.ProcedureNormalBattle.IsPlayHeroDyingAudio=true
ModulesInit.ProcedureNormalBattle.IsHideHeadBarOnDying=true
ModulesInit.ProcedureNormalBattle.IsOpenPlayMusic=false
ModulesInit.ProcedureNormalBattle.IsPlayBattleEndAudio=false
ModulesInit.ProcedureNormalBattle.curProcedureBattle=ModulesInit.ProcedureNormalBattle:DefaultBattle()
ModulesInit.ProcedureNormalBattle.SetLeftInfo(nil,self.mMapData.leftIcon,a,0)
ModulesInit.ProcedureNormalBattle.SetRightInfo(nil,self.mMapData.rightIcon,e,0)
ModulesInit.ProcedureNormalBattle.SetNeedMirrorScaleX(self.mMapData.needMirrorScaleX==1)
ModulesInit.ProcedureNormalBattle.SetShowOperMenu(false)
ModulesInit.ProcedureNormalBattle.SetOpenBattleBeginAnim(false)
ModulesInit.ProcedureNormalBattle.SetOpenShowHeadContainer(false)
ModulesInit.ProcedureNormalBattle.SetBattleRunInMode(EBattleRunInMode.OurTeam)
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.NormalBattle)
end
function e:StartExcutePreview()
if self.previewState==e.EPreviewState.Ready then
self:ChangeState(e.EPreviewState.Running)
self:ExcuteNextPreview()
end
end
function e:ChangeState(e)
self.previewState=e
end
function e:ExcuteNextPreview()
if self.previewState~=e.EPreviewState.Running then
return
end
local a=self.mIndex+1
local t=self.mBattlePreviewDetailList[a]
if t then
self.mIndex=a
local a=true
if t.operType~=e.EOperType.Talk then
GameTools:sendRecordStep(t.id)
end
if t.operType==e.EOperType.FireSkill then
self:StartFireSkill(t,function()
self:ExcuteNextPreview()
end)
elseif t.operType==e.EOperType.Substitute then
self:StartSubstitute(t,function()
self:ExcuteNextPreview()
end)
elseif t.operType==e.EOperType.Talk then
EventSystem.SendEvent(CommonEventId.OnBattleShowPreviewBtn,{showState="hide"})
EventSystem.SendEvent(CommonEventId.Skill_BattleUI_Hide,{ShowOrHideType=CS.MyCommonEnum.ShowOrHideType.Immediately,FadeIn=0,FadeOut=0})
local e=true
if self:HasNextPreviewData()==false then
e=false
end
self:StartTalk(t,e,function()
EventSystem.SendEvent(CommonEventId.Skill_BattleUI_Show,{ShowOrHideType=CS.MyCommonEnum.ShowOrHideType.Immediately,FadeIn=0.1,FadeOut=0.1})
EventSystem.SendEvent(CommonEventId.OnBattleShowPreviewBtn,{showState="check"})
self:ExcuteNextPreview()
end)
elseif t.operType==e.EOperType.InstantSkill then
self:StartInstantSkill(t,function()
self:ExcuteNextPreview()
end)
elseif t.operType==e.EOperType.PlayBgMusic then
self:StartPlayBgMusic(t,function()
self:ExcuteNextPreview()
end)
else
a=false
self:ExcuteNextPreview()
end
if a
and t.operType~=e.EOperType.PlayBgMusic then
if t.audioId and t.audioId>0 then
GameTools:PlayAudioLua(t.audioId)
end
end
else
self:ExcuteAllPreviewComplete()
end
end
function e:HasNextPreviewData()
local e=self.mIndex+1
local e=self.mBattlePreviewDetailList[e]
if e then
return true
else
return false
end
end
function e:SkipAllPreview()
self:ExcuteAllPreviewComplete()
end
function e:ExcuteAllPreviewComplete()
if self.previewState==e.EPreviewState.Over then
return
end
self:ChangeState(e.EPreviewState.Over)
self.isForm=true
GameEntry.UI:OpenUIForm(
UIFormId.UI_CommonLoading,
{
style=LoadingStyle.Black,
blackAnimType=ELoadingBlackAnimType.LongLong,
loadResFinish=function()
EventSystem.SendEvent(CommonEventId.PlayLoadingCloudAni)
UIUtil.CheckCloseUIForm(UIFormId.UI_BattlePreviewTalk)
ModulesInit.ProcedureNormalBattle.isBattleEnd=true
ModulesInit.ProcedureNormalBattle.FinalBattleEnd()
ModulesInit.ProcedureNormalBattle.StopAllCoroutine()
ModulesInit.ProcedureNormalBattle.Dispose()
if self.completeCallback then
EventSystem.SendEvent(CommonEventId.Skill_BattleUI_Hide,{ShowOrHideType=CS.MyCommonEnum.ShowOrHideType.Immediately,FadeIn=0,FadeOut=0})
self.completeCallback()
else
GameEntry.Procedure:ChangeState(CS.YouYou.ProcedureState.MainCity)
end
end
}
)
end
function e:StartFireSkill(a,e)
local t=a.skillId
local o=o.GetEntity(t)
if o==nil then
GameInit.LogError("战斗预览 释放技能找不到技能 预览详细id=%s ",tostring(a.id))
if e then
e()
end
return
end
local n=a.attackStation
local t=self:GetHeroByStationId(n)
local s,i=self:GetDefData(a)
if t then
local a=nil
if t.CurrPetTransform then
a=2
end
local a=r:GetSkillPrefabId(o,a,t.symphonyDid)
ModulesInit.ProcedureNormalBattle.SetCurrAttackHeroId(t.HeroId)
t:SetEffectBeforeAttack()
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(s)
for e=1,#i do
local e=i[e]
local t=e.hero
if t then
if e.damage then
t.HurtNumType=EBattleHurtNumType.ChangeGui
t:Hurt(e.damage,0,o.segment,o.type,false)
end
if e.heroDeadState then
t:SetHeroPreviewDeadState(e.heroDeadState)
end
end
end
ModulesInit.ProcedureNormalBattle.PlayTimeLinenPreview(a,function()
for e=1,#i do
local t=i[e]
local e=t.HeroId
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e then
e:SetHpAndRefreshUI(t.hpAfterAction)
end
end
local t=self:GetHeroByStationId(n)
if t then
t:SetEffectAfterAttack()
end
if e then
e()
end
end)
else
GameInit.LogError("战斗预览 释放技能找不到攻击者 预览详细id=%s 攻击站位=%s",tostring(a.id),tostring(n))
if e then
e()
end
end
end
function e:StartSubstitute(t,o)
local e={}
for a=1,a do
local t=t["leftStation"..a]
local a={
heroId=0,
heroDid=0,
position=a,
isOurTeam=true,
}
self:handleSingleSubstituteData(true,a,t,e)
end
for a=1,a do
local t=t["rightStation"..a]
local a={
heroId=0,
heroDid=0,
position=a,
isOurTeam=false,
}
self:handleSingleSubstituteData(false,a,t,e)
end
local t=math.max(0.1,t.actionDuration)
ModulesInit.ProcedureNormalBattle.PreviewPlaySubstituteInPreview(t,e,o)
end
function e:StartTalk(t,a,e)
if#t.talkDataList>0 then
GameEntry.UI:OpenUIForm(UIFormId.UI_BattlePreviewTalk,{talkContents=t.talkDataList,isCloseTalkView=a,callback=function()
if e then
e()
end
end})
else
if e then
e()
end
end
end
function e:StartInstantSkill(t,i)
local o={}
for e=1,a do
local t=t["leftStation"..e]
local t=self:handleSingleInstantSkillData(true,e,t)
if#t>0 then
local e=self:GetHeroByStationId(e)
if e then
local e={
heroId=e.HeroId,
defActionList=t,
}
table.insert(o,e)
end
end
end
for e=1,a do
local t=t["rightStation"..e]
local t=self:handleSingleInstantSkillData(false,e,t)
if#t>0 then
local e=self:GetHeroByStationId(-e)
if e then
local e={
heroId=e.HeroId,
defActionList=t,
}
table.insert(o,e)
end
end
end
local e=math.max(0.1,t.actionDuration)
ModulesInit.ProcedureNormalBattle.PlayInstantSkillInPreview(e,o,i)
end
function e:StartPlayBgMusic(e,t)
if e.audioId==-1 then
GameEntry.Audio:StopBGM()
else
GameTools:SwitchBGMFadeOutLua(e.audioId)
end
if t then
t()
end
end
function e:GetHeroIdByPosition(a,t,e)
if a then
if t then
return-e-10000
else
return-e-20000
end
else
if t then
return-e
else
return-e-100
end
end
end
function e:GetPositionDataByHeroId(t,e)
local t=self:GetPreviewMapCfgData(t)
if t==nil then
return nil
end
local a
if e<-20000 then
local e=-e-20000
local t=t.leftSubstitute
a=t[e]
elseif e<-10000 then
stationId=-e-10000
local e=t.leftFirstFormaiton
a=e[stationId]
elseif e<-100 then
stationId=-e-100
local e=t.rightSubstitute
a=e[stationId]
else
stationId=-e
local e=t.rightFirstFormaiton
a=e[stationId]
end
return a
end
function e:GetHeroEntranceTypeByHeroId(e,t)
local e=self:GetPositionDataByHeroId(e,t)
if e then
return e[2]or 0
else
return 0
end
end
function e:IsHasPetByHeroId(t,e)
local e=self:GetPositionDataByHeroId(t,e)
if e then
return e[3]or 0
else
return 0
end
end
function e:GetSubstituePositionData(e,o,a)
local e=self:GetPreviewMapCfgData(e)
if e==nil then
return nil
end
local t
if o then
local e=e.leftSubstitute
t=e[a]
else
local e=e.rightSubstitute
t=e[a]
end
return t
end
function e:GetHeroByStationId(t)
local e
if t>0 then
e=ModulesInit.ProcedureNormalBattle.GetHeroCtrlByStation(true,t)
else
e=ModulesInit.ProcedureNormalBattle.GetHeroCtrlByStation(false,math.abs(t))
end
return e
end
function e:GetDefData(o)
local e={}
local t={}
for a=1,a do
local o=o["leftStation"..a]
self:handleSingleDefData(true,a,o,e,t)
end
for a=1,a do
local o=o["rightStation"..a]
self:handleSingleDefData(false,a,o,e,t)
end
return e,t
end
function e:handleSingleDefData(a,s,o,n,i)
local t={
HeroId=0,
hero=nil,
hpAfterAction=0,
damage=0,
heroDeadState=e.EHeroDeadState.None
}
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrlByStation(a,s)
if a then
t.HeroId=a.HeroId
t.hero=a
for i=1,#o do
local o=o[i]
if o[1]==e.EAttackResultType.damage then
t.damage=o[2]
t.hpAfterAction=math.max(0,a.HeroBattleInfo:GetCurrHP()-t.damage)
elseif o[1]==e.EAttackResultType.heroDeadState then
t.heroDeadState=o[2]
end
end
if t.damage>0 then
table.insert(n,a)
table.insert(i,t)
end
end
end
function e:handleSingleSubstituteData(a,t,o,n)
local i=ModulesInit.ProcedureNormalBattle.GetHeroCtrlByStation(a,t.position)
if i==nil then
for i=1,#o do
local o=o[i]
if o[1]==e.EAttackResultType.heroDid then
local o=o[2]
local e=self:GetSubstituePositionData(self.mapDid,a,o)
if e then
t.heroId=self:GetHeroIdByPosition(a,false,o)
t.heroDid=e[1]or 0
end
end
end
if t.heroDid>0 then
table.insert(n,t)
end
end
end
function e:handleSingleInstantSkillData(a,o,e)
local t={}
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrlByStation(a,o)
if a then
for a=1,#e do
local e=e[a]
if e[1]>0 then
table.insert(t,e)
end
end
end
return t
end
function e:ReadBattleDetailData(e)
local e=self:GetPreviewMapCfgData(e)
local e=e.previewId
local e=self:GetPreviewDetailListCfgData(e)
return e
end
function e:GetFormationList(e)
local e=self:GetPreviewMapCfgData(e)
local t=e.leftFirstFormaiton
local a={}
for e=1,g_BattleTeamMaxCount do
local t=t[e]
if t then
local t=t[1]
if t~=0 then
local e={heroId=self:GetHeroIdByPosition(true,true,e),heroDid=t,position=e}
table.add(a,e)
end
end
end
return a
end
function e:GetFormationMaxHp(t)
local e=0
local t=self:GetFormationList(t)
for a=1,#t do
local t=t[a].heroDid
local t=self:GetMonsterAttrCfgData(t)
e=e+t.hp
end
return e
end
function e:IsEffectMonster(e,t)
local e=self:GetPreviewMapCfgData(e)
if e==nil then
return false
end
local e=e.monsterEffect
for a=1,#e do
if t==e[a]then
return true
end
end
return false
end
function e:GetMonsterLists(e)
local e=self:GetPreviewMapCfgData(e)
local t=e.rightFirstFormaiton
local e={}
for a=1,g_BattleTeamMaxCount do
local t=t[a]
if t then
local t=t[1]
table.add(e,t)
else
table.add(e,0)
end
end
return e
end
function e:GetHeroDataByHeroDid(e)
return self:CreateHeroData(e)
end
function e:GetHeroCfgData(e)
return self:GetMonsterCfgData(e)
end
function e:GetMonsterCfgData(e)
local e=l.GetEntity(e)
return e
end
function e:GetMonsterAttrCfgData(e)
local e=s.GetEntity(e)
return e
end
function e:GetPreviewMapCfgData(e)
local e=d.GetEntity(e)
return e
end
function e:GetPreviewDetailListCfgData(i)
local t={}
local a=h.GetList()
for e=1,#a do
local o=a[e]
if o.previewId==i then
table.insert(t,a[e])
end
end
local i={}
local a={}
local function n()
if#a>0 then
local e={
operType=e.EOperType.Talk,
talkDataList=a
}
table.insert(i,e)
a={}
end
end
for o=1,#t do
if t[o].operType==e.EOperType.Talk then
table.insert(a,t[o])
else
n()
table.insert(i,t[o])
end
end
n()
return i
end
function e:GetPreviewDetailHeroList(o)
local t={}
local e=h.GetList()
for a=1,#e do
local e=e[a]
if e.previewId==o and e.heroDid>0 then
t[e.heroDid]=true
end
end
local e={}
for t,a in pairs(t)do
table.insert(e,t)
end
return e
end
function e:CreateHeroData(e)
local a=self:GetHeroCfgData(e)
local t=self:GetMonsterCfgData(e)
local o=s.GetEntity(e)
local e={
heroId=0,
heroDid=0,
curHp=0,
curMp=0,
maxHp=0,
maxMp=0,
soul=nil,
commonSouls={},
prof=1,
fight=0,
status=0,
attribute={},
skills={},
star=1,
rankLevel=1,
rankStars={},
starMap=0,
starNum=0,
lockLevel=0,
jade=0,
jadeExp=0,
isCanLockUp=false,
loverGrade=0,
loverLevel=0,
loverExp=0,
chip=0,
equipIds={},
underwearIds={},
activeTime=0
}
e.maxHp=t.hp
e.maxMp=Constant.battle_fury_max
e.prof=a.profession
e.fight=t.monValue
e.star=a.star
e.rankLevel=t.rankLevel
local t={
id=HeroAttrId.first,
value=o.first
}
table.insert(e.attribute,t)
return e
end
return e

