local d=require("Modules/Battle/FsmMachine")
local j=require("Modules/Battle/HeroState/IdleState")
local q=require("Modules/Battle/HeroState/RunState")
local z=require("Modules/Battle/HeroState/AttackState")
local E=require("Modules/Battle/HeroState/HurtState")
local _=require("Modules/Battle/HeroState/DeathState")
local T=require("Modules/Battle/HeroState/FreezeState")
local k=require("Modules/Battle/HeroState/DefenseState")
local x=require("Modules/Battle/HeroState/BeAttackState")
local g=require("Modules/Battle/HeroState/DyingState")
local v=require("Modules/Battle/HeroState/BlockState")
local p=require("Modules/Battle/HeroState/UndeadState")
local y=require("Modules/Battle/HeroState/LeaveState")
local l=require("Modules/Battle/HeroState/DeathWaitState")
local u=require("Modules/Battle/Formula")
local w=require("Modules/Battle/FormulaPet")
local e=require("Modules/Battle/BattleUtil")
local f=require('Modules/BattleBuffScript/BuffImmuneDamageConsumeMgr')
local b=require('Modules/BattleBuffScript/BuffLimitActionMgr')
local s=require("DataNode/DataTable/Create/hero/DTHeroDBModel")
local i=require("DataNode/DataTable/Create/skillAct/DTSkillActDBModel")
local m=require("DataNode/DataTable/Create/skillAct/DTSkillPasDBModel")
local n=require("DataNode/DataTable/Create/model/DTmodelDBModel")
local a=require("DataNode/DataManager/DataMgr/DataUtil")
local c=require("DataNode/DataTable/Create/soul/DTSoulDBModel")
local t=require("DataNode/DataTable/Create/skillAct/DTBuffDBModel")
local r=require('DataNode/DataTable/Create/summonPet/DTSummonPetDBModel')
local h=nil
if(GameInit.IsClient)then
h=require("Modules/Battle/BattleResPreloadMgr")
end
HeroCtrl=Class("HeroCtrl",{})
function HeroCtrl:Create()
local e=HeroCtrl:New()
e:Init()
return e
end
function HeroCtrl:Init()
self.transform=nil
self.mOpenUpdateHud=false
self:ResetData()
end
function HeroCtrl:ResetData()
self.battleStationIndex=0
self.battleStationRow=0
self.battleStationColumn=0
self.IsMonster=false
self.OriginalPos=nil
self.OriginalServerPos=0
self.heroDid=0
self.HeroId=0
self.PlayerId=0
self.IsOurHero=false
self.rankLevel=0
self.lockLevel=0
self.beAttackType=0
self.spineboy=nil
self.spineboyTransform=nil
self.topBone=nil
self.pointBone=nil
self.CurrFsm=nil
self.AnimLenDic={}
self.CurrBattleTeam=nil
self.mBigAttackCallback=nil
self.mNormalAttackCallback=nil
self.mPetFightAttackCallback=nil
self.CurrSkinTransform=nil
self.CurrMeshRenderer=nil
self.CurrMaterialProperty=nil
self.propertyTintColor=0
self.propertyDarkColor=0
self.shadowRenderer=nil
self.weaponTrans_1=nil
self.weaponTrans_2=nil
self.weaponTrans_3=nil
self.weaponTrans_4=nil
self.weaponTrans_5=nil
self.heroExtraEffect=nil
self.pet_weaponTrans_1=nil
self.pet_weaponTrans_2=nil
self.pet_weaponTrans_3=nil
self.pet_weaponTrans_4=nil
self.pet_weaponTrans_5=nil
self.petExtraEffect=nil
self.OnTimelineEffectPlayComplete=nil
self.SkillMode=SkillMode.Normal
self.DragonWarBigSkillList={}
self.DragonWarBigSkillIndex=1
self.FreezeBigSkill=false
self.ExBigSkillId=0
self.BigSkillId=0
self.NextBigSkillId=0
self.NextBigSkillCheckFunc=nil
self.BigSkillCompleteFunc=nil
self.NextBigSkillBeAttackHeroCtrls=nil
self.NextBigSkillParam=nil
self.NextBigSkillChangeCfgData=nil
self.CurrSkillChangeTimes=0
self.BigSkillPrefab=nil
self.SmallSkillId=0
self.NormalSkillId=0
self.NextNormalOrSmallSkillId=0
self.NextNormalOrSamllSkillParam=nil
self.NextSkillType=EBattleSkillType.SkillNomal
self.NextNormalOrSamllSkillChangeCfgData=nil
self.NextNormalOrSmallSkillCheckFunc=nil
self.NormalSkillPrefab=nil
self.PetFightSkillId=0
self.NextPetFightSkillId=0
self.NexPetFightSkillCheckFunc=nil
self.PetFightSkillCompleteFunc=nil
self.NextPetFightSkillBeAttackHeroCtrls=nil
self.NextPetFightSkillParam=nil
self.NextPetFightSkillChangeCfgData=nil
self.PetFightSkillPrefab=nil
self.HeadBarPoint=nil
self.MiddlePoint=nil
self.CurrHeadBarView=nil
self.CurrHud=nil
self.CurrHurtNum=nil
self.CurrHpHealthNum=nil
self.HudController=nil
self.Ready=false
self.DTMonsterRow=nil
self.HeroServerData=nil
self.DTHeroRow=nil
self.DTmodelRow=nil
self.PrefabId=0
self.haloPrefabId=0
self.NickName=nil
self.HeroBattleInfo=nil
self.profession=nil
self.camp=0
self.IsBattleRoundBeginAddBuffing=false
self.OnBattleRoundBeginAddBuffComplete=nil
self.WillHurtValueDic={}
self.willHurtQueue=nil
self.WillThornHurtValueQueue=nil
self.WillBloodValueQueue=nil
self.needHurtValue=0
self.hurtBeforeHP=0
self.needHurtArmorValue=0
self.hurtBeforeArmor=0
self.needChangeSepsisHP=0
self.hurtBeforeSepsisHP=0
self.hurtBeforeCurrMaxHP=0
self.hurtBeforeCurrSepsisHp=0
self.willBeHpHealth=0
self.willBeHpHealthCrt=false
self.hpHealthInTimeLine=0
self.hpHealthCrtInTimeLine=false
self.hpHealthForbidInTimeLine=false
self.hpHealthAbsorptInTimeLine=0
self.hpHealthThornInTimeLine=0
self.suckBloodInTimeLine=0
self.suckBloodCrtInTimeLine=false
self.WillHealthFuryValueDic={}
self.AttackNeedHealthFury=0
self.WillHealthFuryDic={}
self.WillHealthFuryValueWithSkipBattle=0
self.willNotUsualStateInTimeLine=false
self.PrevHurtCategory=0
self.PrevTotalHurtValue=0
self.HurtNumType=nil
self.IsBigSkillAttacking=false
self.IsPetSkillAttacking=false
self.HasBeenBigSkill=false
self.HasBeenExplosive=false
self.IsNormalAttacking=false
self.IsSmallSkillAttacking=false
self.CurrChangeToIdleType=ChangeToIdleType.NormalIdle
self.CertainlyTriggerSmallSkillRound=0
self.CurrRoundCanTriggerSmallSkill=false
self.HeroHeadItem=nil
self.OnHeroBigSkillAttack=nil
self.OnHeroSmallSkillAttack=nil
self.OnHeroNormalAttack=nil
self.OnPetFightSkillAttack=nil
self.OnHeroSkillAttackComplete=nil
self.OnHeroBeanStatCountChange=nil
self.OnAnyHeroAfterSufferDmg=nil
self.OnShowSpeedLine=nil
self.OnAnyHeroSkillBeAttack=nil
self.OnHPChange=nil
self.OnArmorChange=nil
self.OnFuryChange=nil
self.OnBeansStatFuryChange=nil
self.OnShowBeans=nil
self.OnCameraCtrlMoveing=nil
self.CurrRoundIsBigSkillAttack=false
self.CurrRoundIsNormalSkillAttack=false
self.CurrRoundIsPetFightSkillAttack=false
self.TotalDamage=0
self.TotalBear=0
self.TotalTreatment=0
self.TotalControllRate=0
self.soulId=0
self.soulRow=nil
self:SetHeroPoseType(HeroPoseType.none)
self.IsSupplementHero=false
self.isRunningToBattle=false
self.isLeavingToBattle=false
self.BuffAboutEffects={}
self.hideBar=false
self.hideShadow=false
self.FirstAtkSelfHeroId=0
self.FirstAtkOtherHeroEffect=nil
self.WillNotUsual=false
self.NotUsualType=0
self.CurrIsBlocking=false
self.CurrThornShowBuffId=0
self.ChangeToDefenseWhenAfterSmallSkill=false
self.normalOrSmallSkillAttackedTimes=0
self.SmallSkillMustAtkFirstAtkSelfHero=false
self.hurtLimit=0
self.ImmuneNormalAndSmallSkill=false
self.WillEndImmuneNormalAndSmallSkill=false
self.ImmuneControlBuff=false
self.ImmuneReduceFury=false
self.ImmuneDeBuff=false
self.ImmuneDeBuffWithBuffList={}
self.ImmuneBuffWithBuffList={}
self.ImmuneAfterDamageBuffList={}
self.ConvertTargetBuffList={}
self.reduceHpMaxRateInSkillActList={}
self.ImmuneResurgence=0
self.ImmuneResurgenceMap={}
self.ForbidSmallSkill=false
self.ForbidCritical=false
self.ForbidCriticalInCurAttack=false
self.IgnoreBlock=false
self.IgnoreInjureRes=false
self.SaveExplosiveData=List.New()
self.ImmuneBuffList={}
self.disableDefRage=false
self.WillAddFuryWithSkill=0
self.WillReduceFuryWithSkill=0
self.hurtWeightCount=0
self.currTotalHurt=0
self.enterBuffs={}
self.isHideHero=false
self.ChangeToIdleNeedTime=0
self.BeforeTimeLineWillBeHpHealth=0
self.BeforeTimeLineWillBeHpHealthCrt=false
self.BeforeTimeLineHurtBeforeHP=0
self.BeforeTimeLineHurtBeforeArmor=0
self.BeforeTimeLineWillHealthFuryValueWithSkipBattle=0
self.BeforeTimeLineNeedHurtValue=0
self.BeforeTimeLineNeedHurtArmorValue=0
self.BeforeTimeLineHurtBeforeSepsisHP=0
self.BeforeTimeLineHurtBeforeCurrMaxHP=0
self.BeforeTimeLineHurtBeforeCurrSepsisHp=0
self.BeforeTimeLineNeedChangeSepsisHP=0
self.BeforeTimeLineWillThornHurtValueQueue=nil
self.BeforeTimeLineHurtWeightCount=0
self.BeforeTimeLineAttackNeedHealthFury=0
self.BeforeTimeLineWillAddFuryWithSkill=0
self.BeforeTimeLineWillReduceFuryWithSkill=0
self.BeforeTimeLineWillBloodValueQueue=nil
self.BeforeTimeLinePrevHurtCategory=0
self.BeforeTimeLinePrevTotalHurtValue=0
self.BeforeTimeLineWillHurtValueDic={}
self.BeforeTimeLineWillHealthFuryDic={}
self.heroDeadTime=0
self.IsDeadInAnim=false
self.attackTask=nil
self.mCurSpineAnim=""
self.mUpdateHudLeftTime=0
self.mInOutTweener=nil
self.mIsEnterBattle=false
self.mBuffEffectMap={}
self.mBattleHurtType=EBattleHurtType.HurtHp
self.mDelayPlayBuffEffectSequenceArr={}
self.SkillAfterActions={}
self.addFrontBuffDone=false
self.effectBuffIdAfterTimeline=0
self.appearBattleBigRound=0
self.skillUseCountMap={}
self.IsMustCrit=false
self.IsBeMustCritOnce=false
self.isShowHeroCtrl=true
self.isShowHeroPetCtrl=true
self.isShowHeroHeadBar=true
self.forceAttackHeroId=0
self.forceAttackHeroIdByBuffId=0
self.mLastTiggerSkillSmall=false
self.mLastAttackHeroId=0
self.extraSoulMap={}
self.hasImmuneDamageBuff=false
self.immuneDamageWithConsume=false
self.resistFatalDamage=false
self.ImmuneDamage=false
self.spelicalHurtNumType=nil
self.ImmuneResumeFury=false
self.forbidHeal=false
self.forbidSpecialHealList={}
self.absorptionHealList={}
self.forbidBlood=false
self.mustBeDie=false
self.mOnDamagePointBuffIdEffectMap={}
self.ignoreShildByDamage=false
self.MustSmallSkill=false
self.mHpChainData={}
self.mHpChainDataInCurAttack={}
self.mDamageResList={}
self.mDamageConvertList={}
self.skillUseRecordMap={}
self.immuneActiveAtkReduceFuryWithCountArr={}
self.spineboyScale=1
self.mLastIsSmallSkillTotalSamllRound=0
self.mLastIsBigSkillTotalSmallRound=0
self.mLastIsNormalSkillTotalSmallRound=0
self.addTreasurefDone=false
self.leaderType=EBattleSkillAfterActionType.Normal
self.PetRoot=nil
self.CurrPetTransform=nil
self.spinePet=nil
self.CurrPetMeshRenderer=nil
self.CurrPetMaterialProperty=nil
self.heroPet=0
self.petPrefabId=0
self.previewHeroDeadState=0
self.symphonyDid=0
self.addHpInBigRoundMap={}
self.timerList={}
self.lastBigSkillTargetHeroIds={}
self.skillHurtRateAdd=nil
self.isUnderControlTransferSkin=false
self.mCurTransferSkinPrefabId=0
self.mRecordTransferSkinPrefabId=0
self.isTriggerSkillEndBuffForEver=false
self.isTriggerSkillEndBuff=false
self.isTriggerAllSkillAttackCompleteBuffForEver=false
self.isTriggerAllHeroLockHpForEver=false
self.treatureTipShowStartTime=0
self.DisableDefRageInExSkill=false
self.disableBlock=false
self.disableOtherHeal=false
self.disableOtherShield=false
self.energyConsumeCond=0
self.mIsPet=false
self.mIsFightPet=false
self.mOneAttackbuff=false
self.mPreviewHeroSpecialState=HeroSpecialState.None
self.mPreviewHeroSpecialStateBuffId=0
self.mWillHeroSpecialState=HeroSpecialState.None
self.mHeroSpecialState=HeroSpecialState.None
self.ImmuneThorn=false
self.entranceType=EBattleHeroEntranceType.None
self.ImmuneAvoidDeath=0
self.ImmuneAvoidDeathMap={}
self.ForbidExtraAttackMap={}
self.ForbidExtraAttack=false
self.ForbidEvadeMap={}
self.ForbidEvade=false
self.ForbidImmuneDamageMap={}
self.ForbidImmuneDamage=false
self.DamageToSepsissRateMap={}
self.DamageToSepsissRate=0
self.ImmuneLockHp=0
self.ImmuneLockHpMap={}
self.buffIdImmuneLockHp=0
self.TargetLevel=0
self.TargetLevelMap={}
self.minFinalAtk=-1
self.ImmuneSepsisHpBuffData=nil
self.ImmuneSepsisHpList={}
self.CurImmnuneSepsisHpPrefabId=0
self.ImmuneSepsisHpEffectPrefabId=0
self.mLockFuryBuffList={}
self.mHpShowData=nil
self.mCommonTweenerMap={}
self.mAttrMinValueBuffMap={}
self.mAttrMinValueMap={}
self.ImmortalBuffList={}
self.Immortal=false
self.sepsisReduceRateBuffList={}
self.sepsisRate=1
self.ignoreHealThronsBuffList={}
self.ignoreHealThrons=false
self.ignoreForbidHealBuffList={}
self.ignoreForbidHeal=false
self.healToSepsissRateList={}
self.healToSepsissRate=0
self.furyCostReduceList={}
self.mIsHeroEmptyHp=false
self.isDisableAttackFuryhealthInCurAttack=false
self.isDisableDefFuryhealthInCurAttack=false
self.DispelDisturbBuffList={}
self.AttackInvalid=false
self.AttackInvalidBuffList={}
self.needExplosiveSuit={}
self.canExplosiveSuit=false
self.attackForceRestraintTypeInCurAttack=EForceRestraintType.None
self.defForceRestraintTypeInCurAttack=EForceRestraintType.None
self.attackForceRestraintType=EForceRestraintType.None
self.defForceRestraintType=EForceRestraintType.None
self.forceRestraintTypeList={}
self.totalDamageInBigRoundMap={}
end
function HeroCtrl:InitViewWith(a,t,o,e,i,n)
self.IsOurHero=a
self.heroDid=t
self.HeroId=o
self.CurrMaterialProperty=i
self.IdleData=n
self.mIsPet=ModulesInit.ProcedureNormalBattle.IsPetByDid(self.heroDid)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
self.CurrPetMaterialProperty=CS.UnityEngine.MaterialPropertyBlock()
if(self.IsOurHero)then
if ModulesInit.ProcedureNormalBattle:GetMirrorScaleX()==-1 then
e.localEulerAngles=Vector3(120,-90,-90)
else
e.localEulerAngles=Vector3(60,-90,-90)
end
else
e.localEulerAngles=Vector3(120,-90,-90)
end
if self:IsPet()then
LuaUtils.SetLocalScale(e.transform,0.01,0.01,0.01)
else
LuaUtils.SetLocalScale(e.transform,1.5,4,1)
end
self.HeroRoot=self.transform:Find("HeroRoot")
self.PetRoot=self.transform:Find("PetRoot")
if(not IsNil(self.HeroRoot))then
LuaUtils.SetLocalPos(self.HeroRoot.transform,0,0,0)
end
if(not IsNil(self.PetRoot))then
LuaUtils.SetLocalPos(self.PetRoot.transform,0,0,0)
end
end
self:InitState()
self.OnHeroBigSkillAttack=function(e)
self:OnHeroBigSkillAttackCallBack(e)
end
self.OnHeroSmallSkillAttack=function(e)
self:OnHeroSmallSkillAttackCallBack(e)
end
self.OnHeroNormalAttack=function(e)
self:OnHeroNormalAttackCallBack(e)
end
self.OnPetFightSkillAttack=function(e)
self:OnPetFightSkillAttackCallBack(e)
end
self.OnHeroSkillAttackComplete=function(e)
self:OnHeroSkillAttackCompleteCallBack(e)
end
self.OnHeroBeanStatCountChange=function(e)
self:OnHeroBeanStatCountChangeCallBack(e)
end
self.OnAnyHeroAfterSufferDmg=function(e)
self:OnAnyHeroAfterSufferDmgCallBack(e)
end
self.OnShowSpeedLine=function(e)
self:OnShowSpeedLineCallBack(e)
end
self.OnAnyHeroSkillBeAttack=function(e)
self:OnAnyHeroSkillBeAttackCallBack(e)
end
self.OnCameraCtrlMoveing=function(e)
CameraMgr:OnCameraMoveing(CameraMgr.ESceneType.NormalBattle)
self:OnCameraCtrlMoveingCallBack(e)
end
end
function HeroCtrl:Dispose()
if(self.HeroBattleInfo~=nil)then
self.HeroBattleInfo:Dispose()
self.HeroBattleInfo=nil
end
if(self.WillThornHurtValueQueue~=nil)then
List.Clear(self.WillThornHurtValueQueue)
self.WillThornHurtValueQueue=nil
end
if(self.WillBloodValueQueue~=nil)then
List.Clear(self.WillBloodValueQueue)
self.WillBloodValueQueue=nil
end
self:ResetData()
end
function HeroCtrl:ResetHeroDataWhenNextWave()
self.NextBigSkillId=0
self.NextBigSkillCheckFunc=nil
self.BigSkillCompleteFunc=nil
self.NextBigSkillBeAttackHeroCtrl=nil
self.NextNormalOrSmallSkillId=0
self.NextNormalOrSamllSkillChangeCfgData=nil
self.NextBigSkillChangeCfgData=nil
self.NextSkillType=EBattleSkillType.SkillNomal
self.TotalDamage=0
self.TotalBear=0
self.TotalTreatment=0
self.TotalControllRate=0
end
function HeroCtrl:GetHeroId()
return self.HeroId
end
function HeroCtrl:GetHeroModelId()
if self.IsMonster then
local e=ModulesInit.ProcedureNormalBattle.GetMonsterCfgData()
local e=e.GetEntity(self.heroDid)
if e then
return e.modelID
end
else
local e=s.GetEntity(self.heroDid)
if e then
return e.modelID
end
end
end
function HeroCtrl:GetHeroRootDid()
local e=0
if self:IsMonsterRole()then
local t=ModulesInit.ProcedureNormalBattle.GetMonsterCfgData()
local t=t.GetEntity(self.heroDid)
if t then
e=t.modelID
end
else
e=self.heroDid
end
local e=s.GetEntity(e)
if e then
if e.baseHeroId==0 then
return self.heroDid
else
return e.baseHeroId
end
else
return self.heroDid
end
end
function HeroCtrl:IsCampionLeader()
return self.leaderType~=EBattleSkillAfterActionType.Normal
end
function HeroCtrl:GetHeroLeaderType()
return self.leaderType
end
function HeroCtrl:ReadHeroLeaderType()
if self.IsMonster then
return EBattleSkillAfterActionType.Normal
else
local e=s.GetEntity(self.heroDid)
if e then
return e.leaderType
end
end
end
function HeroCtrl:OnOpen()
EventSystem.AddListener(CommonEventId.OnHeroBigSkillAttack,self.OnHeroBigSkillAttack)
EventSystem.AddListener(CommonEventId.OnHeroSmallSkillAttack,self.OnHeroSmallSkillAttack)
EventSystem.AddListener(CommonEventId.OnHeroNormalAttack,self.OnHeroNormalAttack)
EventSystem.AddListener(CommonEventId.OnPetFightSkillAttack,self.OnPetFightSkillAttack)
EventSystem.AddListener(CommonEventId.OnHeroSkillAttackComplete,self.OnHeroSkillAttackComplete)
EventSystem.AddListener(CommonEventId.OnHeroBeanStatCountChange,self.OnHeroBeanStatCountChange)
EventSystem.AddListener(CommonEventId.OnAnyHeroAfterSufferDmg,self.OnAnyHeroAfterSufferDmg)
EventSystem.AddListener(CommonEventId.OnShowSpeedLine,self.OnShowSpeedLine)
EventSystem.AddListener(CommonEventId.OnCameraCtrlMoveing,self.OnCameraCtrlMoveing)
EventSystem.AddListener(CommonEventId.OnBattleHeroDeath,self.OnBattleHeroDeath,self)
EventSystem.AddListener(CommonEventId.OnEnemyCenterPosReset,self.OnEnemyCenterPosReset,self)
EventSystem.AddListener(CommonEventId.OnAnyHeroSkillBeAttack,self.OnAnyHeroSkillBeAttack)
EventSystem.AddListener(CommonEventId.OnBattleHeroFatalDmgBefore,self.OnBattleHeroFatalDmgBefore,self)
EventSystem.AddListener(CommonEventId.OnBattleHeroLockHp,self.OnBattleHeroLockHp,self)
EventSystem.AddListener(CommonEventId.OnBattleHeroAddBuff,self.OnBattleHeroAddBuff,self)
EventSystem.AddListener(CommonEventId.OnBattleHeroFakeDeath,self.OnBattleHeroFakeDeath,self)
local t=ModulesInit.ProcedureNormalBattle.GetMonsterCfgData()
self.Ready=false
self.mOpenUpdateHud=false
self.HeroBattleInfo=HeroBattleInfo:New(self)
self.appearBattleBigRound=math.max(1,ModulesInit.ProcedureNormalBattle.CurrBattleBigRound)
self.mIsFightPet=ModulesInit.ProcedureNormalBattle.IsFightPetByBattleStationIndex(self.battleStationIndex)
local o=nil
local i=nil
if(ModulesInit.ProcedureNormalBattle.IsBattleTest)then
self.symphonyDid=0
local o=self.heroDid
if self:IsPet()then
local e=r.GetEntity(self.heroDid)
o=e.modelID
end
if(GameInit.IsClient)then
local e=a:GetSymphony(self.heroDid)
if e then
self.symphonyDid=e.id
self.heroDid=e.heroId
o=e.modelID
end
end
self.DTmodelRow=n.GetEntity(o)
self.PrefabId=self.DTmodelRow.prefabId
self.petPrefabId=self.DTmodelRow.petPainting
self.haloPrefabId=self.DTmodelRow.haloPrefabId
if self.petPrefabId>0 then
self.heroPet=self.heroPet or 1
else
self.heroPet=0
end
local e=s.GetEntity(self.heroDid)
if e then
self.profession=e.profession
end
local e=91001001
local t=t.GetEntity(e)
local a=ModulesInit.ProcedureNormalBattle.GetMonsterAttrCfgData()
local e=a.GetEntity(e)
if t and e then
self.HeroBattleInfo:SetMonsterData(e)
end
else
if(self.IsMonster)then
if ModulesInit.ProcedureNormalBattle.BattleType~=BattleType.idle then
self.DTMonsterRow=t.GetEntity(self.heroDid)
if(not self.DTMonsterRow and GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.hideBar=self.DTMonsterRow.hideBar==1 and true or false
self.hideShadow=self.DTMonsterRow.hideShadow==1 and true or false
self.DTmodelRow=n.GetEntity(self.DTMonsterRow.modelID)
self.PrefabId=self.DTmodelRow.prefabId
self.petPrefabId=self.DTmodelRow.petPainting
self.haloPrefabId=self.DTmodelRow.haloPrefabId
if(GameInit.IsClient)then
self.NickName=GameEntry.Localization:GetString(self.DTMonsterRow.monName,CS.YouYou.YouYouLanguageCategory.LangBattle)
end
self.HeroBattleInfo:SetMonsterSkill(self.DTMonsterRow)
self:SetDragonWarBigSkillId()
local e=ModulesInit.ProcedureNormalBattle.GetMonsterAttrCfgData()
local e=e.GetEntity(self.heroDid)
self.profession=self.DTMonsterRow.profession
self.HeroBattleInfo.Level=self.DTMonsterRow.monLevel or 1
self.HeroBattleInfo:SetMonsterData(e)
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.maze then
local e=ModulesInit.MazeMgr:GetMonsterServerData(ModulesInit.ProcedureNormalBattle.ServerMonsterData.npcArr,self.battleStationIndex+1)
if e then
if e.curHp then
self.HeroBattleInfo.CurrHP=e.curHp
end
if e.curMp then
self.HeroBattleInfo.CurrFury=e.curMp
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
self.rankLevel=self.DTMonsterRow.rankLevel
self.lockLevel=self.DTMonsterRow.lockLevel
self.soulId=self.DTMonsterRow.soulId
self.soulRow=c.GetEntity(self.soulId)
if(ModulesInit.ProcedureNormalBattle.IsBattleTest==false)then
FightDataReportMgr:SetEnemyTeamFormationOnCurrWaveWithMonsterList(self.heroDid,self.HeroId,self.battleStationIndex+1)
self.PlayerId=0
FightDataReportMgr:AddEnemyHerosOnCurrWaveWithMonster(self,self.PlayerId)
end
if self:IsStakeFightOpenNewFury()==false then
self:AddFuryWithBaseSoul(SoulAddFuryType.startRage)
end
else
self.DTMonsterRow=t.GetEntity(self.heroDid)
if(not self.DTMonsterRow and GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.hideBar=self.DTMonsterRow.hideBar==1 and true or false
self.hideShadow=self.DTMonsterRow.hideShadow==1 and true or false
self.DTmodelRow=n.GetEntity(self.DTMonsterRow.modelID)
self.PrefabId=self.DTmodelRow.prefabId
self.petPrefabId=self.DTmodelRow.petPainting
self.haloPrefabId=self.DTmodelRow.haloPrefabId
self.soulId=self.DTMonsterRow.soulId
self.soulRow=c.GetEntity(self.soulId)
self.HeroBattleInfo:SetMonsterSkill(self.DTMonsterRow)
if(ModulesInit.ProcedureNormalBattle.IsBattleTest==false)then
FightDataReportMgr:SetEnemyTeamFormationOnCurrWaveWithMonsterList(self.heroDid,self.HeroId,self.battleStationIndex+1)
self.PlayerId=0
FightDataReportMgr:AddEnemyHerosOnCurrWaveWithMonster(self,self.PlayerId)
end
if self:IsStakeFightOpenNewFury()==false then
self:AddFuryWithBaseSoul(SoulAddFuryType.startRage)
end
self:SetDragonWarBigSkillId()
self.profession=self.DTMonsterRow.profession
local e=HeroMgr:GetHeroServerData(self.IdleData)
local t=table.deepCopy(e.attribute)
local e=#t
for e=1,e do
local e=t[e]
if e.id==HeroAttrId.hp then
local t=RandomMgr:GetBattleRandomWithRange(75,80)
e.value=math.floor(e.value*t*0.01)
elseif e.id==HeroAttrId.atk then
local t=RandomMgr:GetBattleRandomWithRange(30,35)
e.value=math.floor(e.value*t*0.01)
elseif e.id==HeroAttrId.def then
local t=RandomMgr:GetBattleRandomWithRange(40,50)
e.value=math.floor(e.value*t*0.01)
else
e.value=0
end
end
self.HeroBattleInfo.Level=PlayerMgr.PlayerInfo.level
self.HeroBattleInfo:SetHeroData(t)
self.rankLevel=self.DTMonsterRow.rankLevel
self.lockLevel=self.DTMonsterRow.lockLevel
end
if self.petPrefabId>0 then
if(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.skillPreview)then
self.heroPet=ModulesInit.BattlePreviewMgr:IsHasPetByHeroId(self.heroDid)
else
self.heroPet=1
end
end
self.HeroBattleInfo.curArmor=0
else
local e=1
if(ModulesInit.ProcedureNormalBattle.FightPlayData)then
if(self.IsOurHero)then
if self:IsPet()then
local e=HeroMgr:GetHeroServerDataWithHerosData(ModulesInit.ProcedureNormalBattle.FightPlayData.ourPets,self.HeroId)
self.HeroServerData=e
i=ModulesInit.ProcedureNormalBattle.FightPlayData.ourPetAttrs
else
local e=HeroMgr:GetHeroServerDataWithHerosData(ModulesInit.ProcedureNormalBattle.FightPlayData.ourHeros,self.HeroId)
self.HeroServerData=e
o=ModulesInit.ProcedureNormalBattle.FightPlayData.ourPetHeroAttrs
end
else
if self:IsPet()then
local e=HeroMgr:GetHeroServerDataWithHerosData(ModulesInit.ProcedureNormalBattle.FightPlay_CurrWave.enemyPets,self.HeroId)
self.HeroServerData=e
i=ModulesInit.ProcedureNormalBattle.FightPlay_CurrWave.enemyPetAttrs
else
local e=HeroMgr:GetHeroServerDataWithHerosData(ModulesInit.ProcedureNormalBattle.FightPlay_CurrWave.enemyHeros,self.HeroId)
self.HeroServerData=e
o=ModulesInit.ProcedureNormalBattle.FightPlay_CurrWave.enemyPetHeroAttrs
end
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.dragonWar then
self.DTMonsterRow=t.GetEntity(self.heroDid)
self.hideBar=self.DTMonsterRow.hideBar==0 and false or true
self.hideShadow=self.DTMonsterRow.hideShadow==0 and false or true
end
end
if self.HeroServerData then
self.PlayerId=self.HeroServerData.playerId
self.rankLevel=self.HeroServerData.rankLevel
end
self.soulId=self.HeroServerData.soulDid
e=self.HeroServerData.heroLevel
else
if(ModulesInit.ProcedureNormalBattle.FightBeforeData==nil)then
if(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.maze)then
self.HeroServerData=ModulesInit.MazeMgr:GetHeroDataByHeroDid(self.heroDid)
self.HeroServerData.heroId=self.HeroId
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.guide)then
self.HeroServerData=ModulesInit.GuideMgr:GetHeroDataByHeroDid(self.heroDid)
self.HeroServerData.heroId=self.HeroId
elseif(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.skillPreview)then
self.HeroServerData=ModulesInit.BattlePreviewMgr:GetHeroDataByHeroDid(self.heroDid)
self.HeroServerData.heroId=self.HeroId
else
self.HeroServerData=HeroMgr:GetHeroServerData(self.HeroId)
end
if PlayerMgr and PlayerMgr.PlayerInfo and PlayerMgr.PlayerInfo.uid then
self.PlayerId=PlayerMgr.PlayerInfo.uid
else
self.PlayerId=0
end
self.rankLevel=self.HeroServerData.rankLevel
self.lockLevel=self.HeroServerData.lockLevel
if self.HeroId>0 then
if PlayerMgr and PlayerMgr.PlayerInfo and PlayerMgr.PlayerInfo.level then
e=PlayerMgr.PlayerInfo.level or 1
else
e=PlayerMgr.PlayerInfo.level
end
else
local t=t.GetEntity(self.heroDid)
e=t.monLevel
end
else
if(self.IsOurHero)then
if self:IsPet()then
local e=HeroMgr:GetHeroServerDataWithHerosData(ModulesInit.ProcedureNormalBattle.FightBeforeData.ourPets,self.HeroId)
self.HeroServerData=e
i=ModulesInit.ProcedureNormalBattle.FightBeforeData.ourPetAttrs
else
local e=HeroMgr:GetHeroServerDataWithHerosData(ModulesInit.ProcedureNormalBattle.FightBeforeData.ourHeros,self.HeroId)
self.HeroServerData=e
o=ModulesInit.ProcedureNormalBattle.FightBeforeData.ourPetHeroAttrs
end
self.PlayerId=self.HeroServerData.playerId
self.rankLevel=self.HeroServerData.rankLevel
self.lockLevel=self.HeroServerData.lockLevel
self.soulId=self.HeroServerData.soulDid and self.HeroServerData.soulDid or 0
else
if self:IsPet()then
local e=HeroMgr:GetHeroServerDataWithHerosData(ModulesInit.ProcedureNormalBattle.FightBefore_CurrWave.enemyPets,self.HeroId)
self.HeroServerData=e
i=ModulesInit.ProcedureNormalBattle.FightBefore_CurrWave.enemyPetAttrs
else
local e=HeroMgr:GetHeroServerDataWithHerosData(ModulesInit.ProcedureNormalBattle.FightBefore_CurrWave.enemyHeros,self.HeroId)
self.HeroServerData=e
o=ModulesInit.ProcedureNormalBattle.FightBefore_CurrWave.enemyPetHeroAttrs
end
self.PlayerId=self.HeroServerData.playerId
self.rankLevel=self.HeroServerData.rankLevel
self.lockLevel=self.HeroServerData.lockLevel
self.soulId=self.HeroServerData.soulDid and self.HeroServerData.soulDid or 0
FightDataReportMgr:AddEnemyHerosOnCurrWave(self.HeroServerData)
end
e=self.HeroServerData.heroLevel
end
end
if self.HeroServerData then
local e=0
if(ModulesInit.ProcedureNormalBattle.FightBeforeData==nil
and ModulesInit.ProcedureNormalBattle.FightPlayData==nil)then
e=self.HeroServerData.fightSymphonyDid or 0
else
e=self.HeroServerData.symphonyDid or 0
end
self.symphonyDid=0
if e~=0 then
if(GameInit.IsClient)then
local t=ModulesInit.HeroSymphonyMgr:GetHeroSymphonyCfg(e)
if t.heroId==self.heroDid then
self.symphonyDid=e
end
end
end
end
if self:IsMonsterRole()then
self.DTMonsterRow=t.GetEntity(self.heroDid)
self.DTmodelRow=n.GetEntity(self.DTMonsterRow.modelID)
self.profession=self.DTMonsterRow.profession
self.soulId=self.DTMonsterRow.soulId
self.hideBar=self.DTMonsterRow.hideBar==1 and true or false
self.hideShadow=self.DTMonsterRow.hideShadow==1 and true or false
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if self:IsPet()then
local e=r.GetEntity(self.heroDid)
self.DTmodelRow=n.GetEntity(e.modelID)
self.profession=0
self.soulId=0
self.camp=0
else
self.DTHeroRow=s.GetEntity(self.heroDid)
if not self.DTHeroRow then
GameInit.LogError('战斗获取配置heroDid为空:'..tostring(ModulesInit.ProcedureNormalBattle.BattleType..'  '))
end
local e=self.DTHeroRow.modelID
if(GameInit.IsClient)then
local t=a:GetSymphony(self.symphonyDid)
if t then
e=t.modelID
end
end
self.DTmodelRow=n.GetEntity(e)
self.profession=self.DTHeroRow.profession
self.camp=self.DTHeroRow.camp
if(GameInit.IsClient)then
self.NickName=GameTools.GetLocalize(self.DTHeroRow.heroName,LanguageCategory.LangBattle)
end
end
end
self.PrefabId=self.DTmodelRow.prefabId
self.petPrefabId=self.DTmodelRow.petPainting
self.haloPrefabId=self.DTmodelRow.haloPrefabId
self.HeroBattleInfo.Level=e or 1
if self:IsPet()then
if i then
self.HeroBattleInfo:SetHeroData(i)
end
self.HeroBattleInfo:SetPetSkill(self.HeroServerData)
else
if(GameInit.IsClient
and ModulesInit.ProcedureNormalBattle.BattleType==BattleType.maze
and ModulesInit.ProcedureNormalBattle.FightPlayData==nil
and ModulesInit.ProcedureNormalBattle.FightBeforeData==nil)
then
local e=ModulesInit.MazeMgr:GetMazeHeroCfgData(self.heroDid,self.HeroServerData.rankLevel)
self.soulId=e.soulId
self.HeroBattleInfo:SetMonsterData(e)
if self.HeroServerData.curHp then
self.HeroBattleInfo.CurrHP=self.HeroServerData.curHp
end
if self.HeroServerData.curMp then
self.HeroBattleInfo.CurrFury=self.HeroServerData.curMp
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local e=a.GetHeroSkills(self.heroDid,self.HeroServerData.rankLevel,e.ExclusiveweaponsStar)
self.HeroServerData.skillMode=SkillMode.Normal
self.HeroServerData.skills=e
self.HeroBattleInfo:SetHeroSkill(self.HeroServerData)
elseif(GameInit.IsClient and ModulesInit.ProcedureNormalBattle.BattleType==BattleType.guide)then
local e=ModulesInit.GuideMgr:GetHeroCfgData(self.heroDid)
local t=ModulesInit.GuideMgr:GetMonsterAttrCfgData(self.heroDid)
self.soulId=e.soulId
self.HeroBattleInfo:SetMonsterData(t)
self.HeroBattleInfo:SetMonsterSkill(e)
elseif(GameInit.IsClient and ModulesInit.ProcedureNormalBattle.BattleType==BattleType.skillPreview)then
local e=ModulesInit.BattlePreviewMgr:GetHeroCfgData(self.heroDid)
local t=ModulesInit.BattlePreviewMgr:GetMonsterAttrCfgData(self.heroDid)
self.soulId=e.soulId
self.HeroBattleInfo:SetMonsterData(t)
self.HeroBattleInfo:SetMonsterSkill(e)
else
if(self.HeroId>0 and self.soulId==0)then
self.soulId=a:GetSoulIdWithLevelAndHeroDid(self.HeroServerData.lockLevel,self.HeroServerData.heroDid)
end
self.HeroBattleInfo:SetHeroData(self.HeroServerData.attribute)
if o then
self.HeroBattleInfo:SetHeroData(o)
end
self.HeroBattleInfo:SetHeroSkill(self.HeroServerData)
end
end
if self.HeroServerData then
if self.HeroServerData.curHp and self.HeroServerData.curHp>0 then
self.HeroBattleInfo.CurrHP=self.HeroServerData.curHp
end
if self.HeroServerData.curMp then
self.HeroBattleInfo.CurrFury=self.HeroServerData.curMp
end
if self.HeroServerData.curArmor then
self.HeroBattleInfo.curArmor=self.HeroServerData.curArmor
end
else
self.HeroBattleInfo.curArmor=0
end
if self.petPrefabId>0 then
if self.HeroId<=0 then
if(ModulesInit.ProcedureNormalBattle.BattleType==BattleType.skillPreview)then
self.heroPet=ModulesInit.BattlePreviewMgr:IsHasPetByHeroId(self.heroDid)
else
self.heroPet=1
end
else
if self.HeroServerData then
if(ModulesInit.ProcedureNormalBattle.FightBeforeData==nil
and ModulesInit.ProcedureNormalBattle.FightPlayData==nil)then
self.heroPet=self.HeroServerData.heroFightPet or 0
else
self.heroPet=self.HeroServerData.heroPet or 0
end
end
end
end
self.soulRow=c.GetEntity(self.soulId)
if(ModulesInit.ProcedureNormalBattle.FightPlayData==nil and self.IsOurHero and self:IsPet()==false)then
FightDataReportMgr:AddOurHeros(self.HeroServerData,self.PlayerId,self)
end
if self:IsStakeFightOpenNewFury()==false then
self:AddFuryWithBaseSoul(SoulAddFuryType.startRage)
end
self:SetDragonWarBigSkillId()
end
end
self.leaderType=self:ReadHeroLeaderType()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
self.OriginalPos=self.transform.position
end
self.battleStationRow=math.ceil((self.battleStationIndex+1)/3)
self.battleStationColumn=self.battleStationIndex%3+1
if(self.IsOurHero)then
self.OriginalServerPos=self.battleStationIndex*2
else
self.OriginalServerPos=self.battleStationIndex*2+1
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if self:IsPet()==false then
self.CurrHeadBarView=ModulesInit.UIGlobalManager.PopHeadBarView()
end
if self.CurrHeadBarView then
self:CheckShowHeadBar()
self.CurrHeadBarView:SetHP(self.HeroBattleInfo.CurrHP,self.HeroBattleInfo.CurrMaxHP,self.HeroBattleInfo.MaxHP)
self.CurrHeadBarView:SetFury(self.HeroBattleInfo.CurrFury,self.HeroBattleInfo.Fury)
self.CurrHeadBarView:SetProfession(self.profession)
self.CurrHeadBarView:ShowRage(false)
self.CurrHeadBarView:SetRage(0,1)
self:InitHeroPow()
local e=ModulesInit.ProcedureNormalBattle.GetPlayerIndexByPlayerId(self.PlayerId)
if type(e)=="number"and e>0 then
self.CurrHeadBarView:ShowPlayerIndex(true,e)
else
self.CurrHeadBarView:ShowPlayerIndex(false)
end
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.campaign and self.IsOurHero==false then
local e=a:GetKeyDarkType(ModulesInit.EarthMgr:GetCurRunningMapId(),self.heroDid)
self.CurrHeadBarView:SetKeyDark(e)
else
local e=ModulesInit.ProcedureNormalBattle.IsHeroShowDarkEffect(self.battleStationIndex,self.IsOurHero==false)
self.CurrHeadBarView:SetKeyDark(darkType)
end
end
self:CheckShowShadow()
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
self.CurrHud=ModulesInit.UIGlobalManager.PopHud()
self.CurrHurtNum=ModulesInit.UIGlobalManager.PopHurtNum()
self.CurrHpHealthNum=ModulesInit.UIGlobalManager.PopHurtNum()
if self:IsPet()==false then
ModulesInit.UIGlobalManager.PopTreasureContainer(function(e)
self.CurrTreasureContainer=e
self.CurrTreasureContainer:Open()
end)
end
end
self.WillThornHurtValueQueue=List.New()
self.WillBloodValueQueue=List.New()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if ModulesInit.ProcedureNormalBattle.IsSkipBattle==true then
self.mIsEnterBattle=true
self.IsBattleRoundBeginAddBuffing=true
end
if self.heroPet>0 and self.petPrefabId>0 then
self:LoadPet()
end
self:LoadSkin(self.PrefabId,true)
if self.haloPrefabId and self.haloPrefabId>0 then
self:LoadHaloEffect(self.haloPrefabId)
end
end
function HeroCtrl:OnClose(t)
self.Ready=false
EventSystem.RemoveListener(CommonEventId.OnHeroBigSkillAttack,self.OnHeroBigSkillAttack)
EventSystem.RemoveListener(CommonEventId.OnHeroSmallSkillAttack,self.OnHeroSmallSkillAttack)
EventSystem.RemoveListener(CommonEventId.OnHeroNormalAttack,self.OnHeroNormalAttack)
EventSystem.RemoveListener(CommonEventId.OnPetFightSkillAttack,self.OnPetFightSkillAttack)
EventSystem.RemoveListener(CommonEventId.OnHeroSkillAttackComplete,self.OnHeroSkillAttackComplete)
EventSystem.RemoveListener(CommonEventId.OnHeroBeanStatCountChange,self.OnHeroBeanStatCountChange)
EventSystem.RemoveListener(CommonEventId.OnAnyHeroAfterSufferDmg,self.OnAnyHeroAfterSufferDmg)
EventSystem.RemoveListener(CommonEventId.OnShowSpeedLine,self.OnShowSpeedLine)
EventSystem.RemoveListener(CommonEventId.OnCameraCtrlMoveing,self.OnCameraCtrlMoveing)
EventSystem.RemoveListener(CommonEventId.OnBattleHeroDeath,self.OnBattleHeroDeath,self)
EventSystem.RemoveListener(CommonEventId.OnEnemyCenterPosReset,self.OnEnemyCenterPosReset,self)
EventSystem.RemoveListener(CommonEventId.OnAnyHeroSkillBeAttack,self.OnAnyHeroSkillBeAttack)
EventSystem.RemoveListener(CommonEventId.OnBattleHeroFatalDmgBefore,self.OnBattleHeroFatalDmgBefore,self)
EventSystem.RemoveListener(CommonEventId.OnBattleHeroLockHp,self.OnBattleHeroLockHp,self)
EventSystem.RemoveListener(CommonEventId.OnBattleHeroAddBuff,self.OnBattleHeroAddBuff,self)
EventSystem.RemoveListener(CommonEventId.OnBattleHeroFakeDeath,self.OnBattleHeroFakeDeath,self)
self:SetHeroShowCtrl(true)
if GameInit.IsClient
and ModulesInit.ProcedureNormalBattle.isBattleEnd==false
and ModulesInit.ProcedureNormalBattle.isAlreadyShowBattleEnd==false
and not IsNil(self.CurrSkinTransform)
and ModulesInit.ProcedureNormalBattle.IsSkipBattle==false
and self.IsDeadInAnim==false
and self:IsIceSpecialState()==false
then
local t=math.max(0.3,self.heroDeadTime-Time.time)
local e=true
if(self.HeroBattleInfo:HasStrongControlBuff())then
e=false
end
local t={
heroId=self.HeroId,
heroDid=self.heroDid,
skin=self.CurrSkinTransform,
CurrMaterialProperty=self.CurrMaterialProperty,
CurrMeshRenderer=self.CurrMeshRenderer,
propertyTintColor=self.propertyTintColor,
lifeDuration=t,
footPointPos=self:GetFootPointPos(),
scale=self:GetDeathEffectScale(),
playDeadAnim=e,
petSkin=self.CurrPetTransform,
CurrPetMaterialProperty=self.CurrPetMaterialProperty,
CurrPetMeshRenderer=self.CurrPetMeshRenderer,
}
local e=LuaUtils.GetParent(self.transform)
if e~=nil then
self.CurrSkinTransform:SetParent(e)
if not IsNil(self.CurrPetTransform)then
self.CurrPetTransform:SetParent(e)
end
ModulesInit.ProcedureNormalBattle.AddDeadHero(t)
self.CurrSkinTransform=nil
self.CurrPetTransform=nil
end
end
if(not t)then
if(self.CurrBattleTeam~=nil)then
if self:IsPet()then
self.CurrBattleTeam:RemovePetCtrl(self.HeroId)
else
self.CurrBattleTeam:RemoveHeroCtrl(self.HeroId)
end
end
end
self:Despawn()
end
function HeroCtrl:OnBeforeDestroy()
self.transform=nil
end
function HeroCtrl:IsSuperArmor()
if(self.DTmodelRow and self.DTmodelRow.superArmor==1)then
return true
end
return false
end
function HeroCtrl:GetHeroModelId()
if(self.DTmodelRow)then
return self.DTmodelRow.id
end
return 0
end
function HeroCtrl:GetDeathEffectScale()
if(self.DTmodelRow)then
return self.DTmodelRow.deathEffectScale
end
return 1
end
function HeroCtrl:OnEnemyCenterPosReset()
if(not IsNil(self.transform))then
self.OriginalPos=self.transform.position
end
end
function HeroCtrl:ResetPos()
if(not IsNil(self.transform))then
self.transform.position=self.OriginalPos
end
self:SetFlipRoot(false)
if(not IsNil(self.HeroRoot))then
LuaUtils.SetLocalPos(self.HeroRoot.transform,0,0,0)
end
if(not IsNil(self.PetRoot))then
LuaUtils.SetLocalPos(self.PetRoot.transform,0,0,0)
end
self.CurrIsBlocking=false
self:SetThornShowBuffId(0)
self.isHideHero=false
self:ChangeColor(ModulesInit.ProcedureNormalBattle.GetBattleHeroInitColor())
self:ChangeShadowAlpha(1)
end
function HeroCtrl:SetFlipRoot(o)
if(not IsNil(self.transform))then
local e,t,a
e,t,a=LuaUtils.GetLocalScale(self.transform,e,t,a)
if o then
LuaUtils.SetLocalScale(self.transform,e,t,-math.abs(a))
else
LuaUtils.SetLocalScale(self.transform,e,t,math.abs(a))
end
end
end
function HeroCtrl:OnDragonWarSupplementRefreshUI()
if(self.IsSupplementHero)then
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
else
EventSystem.SendEvent(CommonEventId.OnBattleHeroSupplement,self)
end
end
end
function HeroCtrl:SetDragonWarBigSkillId()
if(self.SkillMode==SkillMode.DragonWar)then
self.BigSkillId=self.DragonWarBigSkillList[self.DragonWarBigSkillIndex]
self.DragonWarBigSkillIndex=self.DragonWarBigSkillIndex+1
if(self.DragonWarBigSkillIndex>#self.DragonWarBigSkillList)then
self.DragonWarBigSkillIndex=1
end
end
end
function HeroCtrl:OnDoAction(t,e)
if(t=="SetTimelineEffect")then
ModulesInit.BattleSkillEffectManager.CurrTimelineEffect=e
BuildPatchMgr:PlayTimeLine(ModulesInit.BattleSkillEffectManager.CurrTimelineEffect)
local e=e.transform.name
local e=string.gmatch(e,"(%d+).*")()
h:PreloadMp4(e,function()
end)
ModulesInit.BattleSkillEffectManager.CurrTimelineEffect.OnStopped=function()
if(ModulesInit.BattleSkillEffectManager.CurrTimelineEffect~=nil)then
ModulesInit.BattleSkillEffectManager.CurrTimelineEffect=nil
if(self.OnTimelineEffectPlayComplete~=nil)then
self.OnTimelineEffectPlayComplete()
end
end
end
elseif(t=="SetTimelineEffect_onComplete")then
self.OnTimelineEffectPlayComplete=e
elseif(t=="BigSkillID")then
self.BigSkillId=tonumber(e)
self.PetFightSkillId=tonumber(e)
elseif(t=="BigSkillPrefab")then
self.BigSkillPrefab=e
elseif(t=="NormalSkillID")then
self.SmallSkillId=tonumber(e)
self.PetFightSkillId=tonumber(e)
elseif(t=="NormalSkillPrefab")then
self.NormalSkillPrefab=e
elseif(t=="PetFightSkillPrefab")then
self.PetFightSkillPrefab=e
elseif(t=="battleStationIndex")then
self.battleStationIndex=e
self.battleStationRow=math.ceil((self.battleStationIndex+1)/3)
self.battleStationColumn=self.battleStationIndex%3+1
elseif(t=="HasPet")then
if e==true then
self.heroPet=1
else
self.heroPet=0
end
end
end
function HeroCtrl:GetPos()
return self.battleStationIndex+1
end
function HeroCtrl:Despawn()
self:UnLoadPet()
self:UnLoadSkin()
if(GameInit.IsClient)then
self:RemoveAllBuffEffectTrans()
self:StopDelaySequence()
self:StopInOutSequence()
self:KillAllTweener()
self:StopAllTimer()
self:KillAllCommonTweener()
if(self.CurrHeadBarView)then
self.CurrHeadBarView:Dispose()
end
ModulesInit.UIGlobalManager.PushHeadBarView(self.CurrHeadBarView)
ModulesInit.UIGlobalManager.PushHud(self.CurrHud)
ModulesInit.UIGlobalManager.PushHurtNum(self.CurrHurtNum)
ModulesInit.UIGlobalManager.PushHurtNum(self.CurrHpHealthNum)
if self.CurrTreasureContainer then
self.CurrTreasureContainer:Close()
ModulesInit.UIGlobalManager.PushTreasureContainer(self.CurrTreasureContainer)
self.CurrTreasureContainer=nil
end
self:RemoveFirstAtkOtherHeroEffect()
if(self.HeroHeadItem~=nil)then
self.HeroHeadItem:OnClose()
self.HeroHeadItem=nil
end
self:DisposeBuffAboutEffects()
if(not IsNil(self.transform))then
GameEntry.Pool:GameObjectDespawn(self.transform)
end
end
self:Dispose()
end
function HeroCtrl:SetHeroPoseType(e)
self.HeroPoseType=e
if(not IsNil(self.HudController))then
self.HudController:SetHeroPose(self.HeroPoseType)
end
end
function HeroCtrl:UnLoadPet()
if(not IsNil(self.CurrPetTransform))then
LuaUtils.SetActive(self.CurrPetTransform,true)
GameEntry.Pool:GameObjectDespawn(self.CurrPetTransform)
self.CurrPetTransform=nil
end
if not IsNil(self.CurrPetTransform)then
self.CurrPetTransform:DOKill()
end
self.spinePet=nil
self.pet_weaponTrans_1=nil
self.pet_weaponTrans_2=nil
self.pet_weaponTrans_3=nil
self.pet_weaponTrans_4=nil
self.pet_weaponTrans_5=nil
self.petExtraEffect=nil
self.CurrPetMeshRenderer=nil
end
function HeroCtrl:LoadPet()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
self:UnLoadPet()
GameEntry.Pool:GameObjectSpawn(
self.petPrefabId,
nil,
function(e,t,t)
self.CurrPetTransform=e
self.CurrPetTransform:SetParent(self.PetRoot.transform)
self.CurrPetTransform.localPosition=Vector3(0,0,0)
if self.IsOurHero then
if ModulesInit.ProcedureNormalBattle:GetMirrorScaleX()==-1 then
self.CurrPetTransform.localEulerAngles=Vector3(-1,-90,0)
else
self.CurrPetTransform.localEulerAngles=Vector3(1,-90,0)
end
else
self.CurrPetTransform.localEulerAngles=Vector3(-1,-90,0)
end
LuaUtils.SetLayer(self.CurrPetTransform,LayerName.Role)
self.spinePet=e:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
self.pet_weaponTrans_1=self.CurrPetTransform:Find("weapon_follow_1")
self.pet_weaponTrans_2=self.CurrPetTransform:Find("weapon_follow_2")
self.pet_weaponTrans_3=self.CurrPetTransform:Find("weapon_follow_3")
self.pet_weaponTrans_4=self.CurrPetTransform:Find("weapon_follow_4")
self.pet_weaponTrans_5=self.CurrPetTransform:Find("weapon_follow_5")
self.petExtraEffect=self.CurrPetTransform:Find("hero_extra_effect")
self:RefreshSpinePetScale()
self.CurrPetMeshRenderer=e:GetComponent(typeof(CS.UnityEngine.MeshRenderer))
self.CurrPetMeshRenderer.sortingOrder=0
end
)
end
function HeroCtrl:UnLoadSkin()
if(not IsNil(self.CurrSkinTransform))then
self:ChangeAlhpa(1)
LuaUtils.SetActive(self.CurrSkinTransform,true)
GameEntry.Pool:GameObjectDespawn(self.CurrSkinTransform)
self.CurrSkinTransform=nil
end
if not IsNil(self.spineboyTransform)then
self.spineboyTransform:DOKill()
end
self:SetSpineInvisible(false)
if(not IsNil(self.HudController))then
self.HudController:ResetLua()
self.HudController=nil
end
self.spineboy=nil
self.spineboyTransform=nil
self.topBone=nil
self.pointBone=nil
self.weaponTrans_1=nil
self.weaponTrans_2=nil
self.weaponTrans_3=nil
self.weaponTrans_4=nil
self.weaponTrans_5=nil
self.heroExtraEffect=nil
self.heroUIPetRoot=nil
self.CurrMeshRenderer=nil
end
function HeroCtrl:LoadSkin(e,a)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
self:UnLoadSkin()
GameTools:PoolGameObjectSpawn(
e,
nil,
function(e,t,t)
self.CurrSkinTransform=e
self.CurrSkinTransform:SetParent(self.HeroRoot.transform)
self.CurrSkinTransform.localPosition=Vector3.zero
self.CurrSkinTransform.localEulerAngles=Vector3(0,-90,0)
LuaUtils.SetLayer(self.CurrSkinTransform,LayerName.Role)
self.spineboy=e:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
self.spineboyTransform=self.spineboy.transform
self.topBone=self.spineboy.skeleton:FindBone("top")
self.pointBone=self.spineboy.skeleton:FindBone("point")
self.weaponTrans_1=self.CurrSkinTransform:Find("weapon_follow_1")
self.weaponTrans_2=self.CurrSkinTransform:Find("weapon_follow_2")
self.weaponTrans_3=self.CurrSkinTransform:Find("weapon_follow_3")
self.weaponTrans_4=self.CurrSkinTransform:Find("weapon_follow_4")
self.weaponTrans_5=self.CurrSkinTransform:Find("weapon_follow_5")
self.heroExtraEffect=self.CurrSkinTransform:Find("hero_extra_effect")
self.heroUIPetRoot=self.CurrSkinTransform:Find("pet_root")
if self.heroUIPetRoot then
LuaUtils.SetActive(self.heroUIPetRoot.transform,false)
end
self:RefreshSpineBoyScale()
self.CurrMeshRenderer=e:GetComponent(typeof(CS.UnityEngine.MeshRenderer))
self.CurrMeshRenderer.sortingOrder=0
self:SetHeroShowCtrl(true)
self:SetSpineInvisible(false)
self:SetAllHeroWeaponShow()
self.propertyTintColor=CS.UnityEngine.Shader.PropertyToID("_Color")
self.propertyDarkColor=CS.UnityEngine.Shader.PropertyToID("_Black")
self:ChangeColor(ModulesInit.ProcedureNormalBattle.GetBattleHeroInitColor())
self:ChangeShadowAlpha(1)
if self.CurrHeadBarView then
self.CurrHeadBarView:ChangeAlpha(1)
end
local e=self.spineboy.skeletonDataAsset:GetAnimationStateData().SkeletonData
local t=e:FindAnimation("strike")
if(t)then
self.AnimLenDic["strike"]=t.Duration
else
self.AnimLenDic["strike"]=0.1
end
local t=e:FindAnimation("strike2")
if(t)then
self.AnimLenDic["strike2"]=t.Duration
else
self.AnimLenDic["strike2"]=0.1
end
local t=e:FindAnimation("death")
if(t)then
self.AnimLenDic["death"]=t.Duration
end
local t=e:FindAnimation("change")
if(t)then
self.ChangeToIdleNeedTime=t.Duration
end
e=nil
self:PlayMonsterEffect()
self.Ready=true
self.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.NormalIdle
if(a and self.IsSupplementHero)then
local e=EBattleHeroEntranceType.RunIn
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.skillPreview then
local t=ModulesInit.ProcedureNormalBattle.MapId
e=ModulesInit.BattlePreviewMgr:GetHeroEntranceTypeByHeroId(t,self.HeroId)
end
if e==EBattleHeroEntranceType.LightEffectIn then
self:HeroEnterWithLightInBattle(true)
else
self:HeroRunInBattle(true)
end
else
self.mIsEnterBattle=true
if(self.CurrFsm.curStateEnum==HeroState.Run)then
self:SetSpineAnimation(0,"run",true)
elseif(self.CurrFsm.curStateEnum==HeroState.Leave)then
self:SetHeroLeave()
else
self.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.NormalIdle
self:SetHeroPoseType(HeroPoseType.none)
self:ChangeStateUnCheckState(HeroState.Idle)
end
end
self.HudController=self.transform:GetComponent(typeof(CS.YouYou.HeroHudController))
if(not IsNil(self.HudController)and not IsNil(self.CurrHurtNum)and not IsNil(self.CurrHpHealthNum)and not IsNil(self.CurrHeadBarView))then
local e=self.CurrHurtNum.transform:GetComponent(typeof(CS.YouYouFramework.Component.WordartUtiltiy))
local t=self.CurrHpHealthNum.transform:GetComponent(typeof(CS.YouYouFramework.Component.WordartUtiltiy))
self.HudController:InitLua(
ModulesInit.UIGlobalManager.HeadBarContainer,
ModulesInit.UIGlobalManager.HurtNumContainer,
self.spineboy,
self.CurrHeadBarView.transform,e,t,self.CurrHud,
self.hideBar,
"top","point",
Vector3(self.DTmodelRow.standHeadOffsetX,self.DTmodelRow.standHeadOffsetY,0),
Vector3(self.DTmodelRow.headOffsetX,self.DTmodelRow.headOffsetY,0),
Vector3(self.DTmodelRow.headOffsetX,self.DTmodelRow.defenseHeadOffsetY,0),
Vector3(self.DTmodelRow.middleOffsetX,self.DTmodelRow.middleOffsetY,0),
Vector3(self.DTmodelRow.legOffsetX,self.DTmodelRow.legOffsetY,0),
Vector3(0,50*CurrScreenHeightRatio,0),
Vector3(0,-50*CurrScreenHeightRatio,0)
)
end
end
)
end
function HeroCtrl:HeroRunInBattle(e)
self.isRunningToBattle=true
self:ChangeStateUnCheckState(HeroState.Run)
if ModulesInit.ProcedureNormalBattle.IsPlaySuppleRunAudio==true then
GameTools:PlayAudioLua(500)
end
self:StopInOutSequence()
local e=LuaUtils.DoTweenLocalPosMove(self.transform,0,0,0,ConstBattleRunInBattleDuration,function()
self.mInOutTweener=nil
self:HeroEnterBattleComplete(e)
end)
self.mInOutTweener=e
end
function HeroCtrl:HeroEnterWithLightInBattle(t)
self.isRunningToBattle=true
if not IsNil(self.transform)then
LuaUtils.SetLocalPos(self.transform,0,0,0)
LuaUtils.SetActive(self.transform,false)
end
if ModulesInit.ProcedureNormalBattle.IsPlaySuppleRunAudio==true then
GameTools:PlayAudioLua(2001)
end
local e=self:GetFootPointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.BattleLHQDCampainBuff,e.x,e.y+3,50,3,0,false,function()
end)
local e=ModulesInit.TimeActionMgr.CreateTimeAction()
self:AddTimer(e)
e:Init(
0,
0.5,
1,
nil,
nil,
function()
self:RemoveTimer(e)
if not IsNil(self.transform)then
LuaUtils.SetActive(self.transform,true)
end
self:HeroEnterBattleComplete(t)
end
):Run()
end
function HeroCtrl:HeroEnterInBattle(a,e)
self.isRunningToBattle=true
if not IsNil(self.transform)then
LuaUtils.SetLocalPos(self.transform,0,0,0)
LuaUtils.SetActive(self.transform,true)
end
if e and e>0 then
local t=self:GetFootPointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(e,t.x,t.y,50,3,0,false,function()
end)
end
self:HeroEnterBattleComplete(a)
end
function HeroCtrl:ShowBackBattleField(e)
self:ForceShowHero()
if self.entranceType==EBattleHeroEntranceType.SplitOut then
self:HeroEnterInBattle(false,SysPrefabId.BattleLWTSpitOutBuff)
elseif self.entranceType==EBattleHeroEntranceType.AutoOut then
self:HeroEnterInBattle(false)
elseif self.entranceType==EBattleHeroEntranceType.Quick then
self:HeroEnterInBattle(false)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if e and self.CurrBattleTeam then
self.CurrBattleTeam:DoHeroDieInTimeLine(self)
self.willNotUsualStateInTimeLine=false
end
end
else
if self.transform then
LuaUtils.SetLocalPos(self.transform,0,0,-15)
end
self:HeroRunInBattle(false)
end
self.entranceType=EBattleHeroEntranceType.None
end
function HeroCtrl:IsNotDeadType()
if self.NotUsualType==HeroState.Freeze
or self.NotUsualType==HeroState.DyingState then
return true
end
return false
end
function HeroCtrl:HeroEnterBattleComplete(e)
if self.HeroId~=0 and self.spineboyTransform~=nil then
self.OriginalPos=self.transform.position
self:ChangeState(HeroState.Idle,true)
self.isRunningToBattle=false
self.mIsEnterBattle=true
if e then
self.IsBattleRoundBeginAddBuffing=true
else
self.IsBattleRoundBeginAddBuffing=false
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if self.HeroBattleInfo then
self.HeroBattleInfo:PlayBattleAllBuffEffect()
self.HeroBattleInfo:PlayBattleAllBuffAddEffect(true)
end
end
if e then
if ModulesInit.ProcedureNormalBattle.BattleType~=BattleType.skillPreview then
self.CurrBattleTeam:OnSupplementHeroEnterBattleComplete()
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="HERO_SUPPORT_ENTER_FINISH"})
end
end
end
end
function HeroCtrl:HeroLeaveBattle()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
return false
end
if self.HeroBattleInfo==nil or self.HeroBattleInfo:HasStrongControlBuff()then
return false
end
if self.spineboyTransform==nil then
return false
end
self.isLeavingToBattle=true
self:ChangeStateUnCheckState(HeroState.Run)
local e,a,t
e,a,t=LuaUtils.GetLocalScale(self.spineboyTransform,e,a,t)
LuaUtils.SetLocalScale(self.spineboyTransform,-e,a,t)
self:StopInOutSequence()
local e=LuaUtils.DoTweenLocalPosMove(self.transform,0,0,-10,1.5,function()
self.mInOutTweener=nil
end)
self.mInOutTweener=e
return true
end
function HeroCtrl:SetSpineBoyScale(e,t)
self.spineboyScale=e
if t then
if self.spineboyTransform then
local e=self.spineboyTransform.localScale
local e=self:GetSpineBoyLogicScale()
self.spineboyTransform:DOKill()
self.spineboyTransform:DOScale(e,0.2):SetEase(CS.DG.Tweening.Ease.Linear)
end
else
self:RefreshSpineBoyScale()
end
end
function HeroCtrl:ResetSpineBoyScale()
self:SetSpineBoyScale(1)
end
function HeroCtrl:RefreshSpineBoyScale()
if self.spineboyTransform then
local e=self:GetSpineBoyLogicScale()
self.spineboyTransform.localScale=e
end
end
function HeroCtrl:RefreshSpinePetScale()
if self.CurrPetTransform then
local e=self:GetSpineBoyLogicScale()
self.CurrPetTransform.localScale=e
end
end
function HeroCtrl:GetSpineBoyLogicScale()
if self.DTmodelRow then
return Vector3.one*self.DTmodelRow.battleZoom*self.spineboyScale
end
return Vector3.one*self.spineboyScale
end
function HeroCtrl:StopInOutSequence()
if self.mInOutTweener~=nil then
self.mInOutTweener:Kill()
self.mInOutTweener=nil
end
end
function HeroCtrl:ChangeAlhpa(a,e)
e=e or EBattleHeroTargetType.All
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeroInitColor()
t.a=a
if e==EBattleHeroTargetType.HERO or e==EBattleHeroTargetType.All then
if(self.CurrMaterialProperty~=nil and self.CurrMeshRenderer~=nil)then
self.CurrMaterialProperty:SetColor(self.propertyTintColor,t)
self.CurrMeshRenderer:SetPropertyBlock(self.CurrMaterialProperty)
end
end
if e==EBattleHeroTargetType.PET or e==EBattleHeroTargetType.All then
if(self.CurrPetMaterialProperty~=nil and self.CurrPetMeshRenderer~=nil)then
self.CurrPetMaterialProperty:SetColor(self.propertyTintColor,t)
self.CurrPetMeshRenderer:SetPropertyBlock(self.CurrPetMaterialProperty)
end
end
end
function HeroCtrl:ChangeColor(t,e)
e=e or EBattleHeroTargetType.All
if e==EBattleHeroTargetType.HERO or e==EBattleHeroTargetType.All then
if(self.CurrMaterialProperty~=nil and self.CurrMeshRenderer~=nil)then
self.CurrMaterialProperty:SetColor(self.propertyTintColor,t)
self.CurrMeshRenderer:SetPropertyBlock(self.CurrMaterialProperty)
end
end
if e==EBattleHeroTargetType.PET or e==EBattleHeroTargetType.All then
if(self.CurrPetMaterialProperty~=nil and self.CurrPetMeshRenderer~=nil)then
self.CurrPetMaterialProperty:SetColor(self.propertyTintColor,t)
self.CurrPetMeshRenderer:SetPropertyBlock(self.CurrPetMaterialProperty)
end
end
end
function HeroCtrl:ChangeDarkColor(t,e)
ttargetType=e or EBattleHeroTargetType.All
if e==EBattleHeroTargetType.HERO or e==EBattleHeroTargetType.All then
if(self.CurrMaterialProperty~=nil and self.CurrMeshRenderer~=nil)then
self.CurrMaterialProperty:SetColor(self.propertyDarkColor,t)
self.CurrMeshRenderer:SetPropertyBlock(self.CurrMaterialProperty)
end
end
if e==EBattleHeroTargetType.PET or e==EBattleHeroTargetType.All then
if(self.CurrPetMaterialProperty~=nil and self.CurrPetMeshRenderer~=nil)then
self.CurrPetMaterialProperty:SetColor(self.propertyTintColor,t)
self.CurrPetMeshRenderer:SetPropertyBlock(self.CurrPetMaterialProperty)
end
end
end
function HeroCtrl:ChangeShadowAlpha(t,e)
e=e or EBattleHeroTargetType.All
if e==EBattleHeroTargetType.HERO or e==EBattleHeroTargetType.All then
if(self.shadowRenderer~=nil)then
self.shadowRenderer.material:SetColor("_BaseColor",Color(1,1,1,t))
end
end
end
function HeroCtrl:ChangeHeadBarAlpha(t,e)
e=e or EBattleHeroTargetType.All
if e==EBattleHeroTargetType.HERO or e==EBattleHeroTargetType.All then
if(self.CurrHeadBarView and self.CurrHeadBarView:Lock(8))then
self.CurrHeadBarView:ChangeAlpha(t)
end
end
end
function HeroCtrl:ChangeHeadBarAlphaUnlock(e)
e=e or EBattleHeroTargetType.All
if e==EBattleHeroTargetType.HERO or e==EBattleHeroTargetType.All then
if(self.CurrHeadBarView and self.CurrHeadBarView:Lock(8))then
self.CurrHeadBarView:UnLock()
end
end
end
function HeroCtrl:SetSpineInvisible(t,e)
if GameInit.IsClient then
if self.isShowHeroCtrl==false then
return
end
e=e or EBattleHeroTargetType.All
if e==EBattleHeroTargetType.HERO or e==EBattleHeroTargetType.All then
self:ShowOrHideHeroExtraEffect(t==false)
if BuildPatchMgr:CompareVersion(GameEntry.AppVer,"1.0.22")>=0 then
if(not IsNil(self.spineboy))then
self.spineboy.invisible=t
end
end
end
if e==EBattleHeroTargetType.PET or e==EBattleHeroTargetType.All then
self:ShowOrHidePetExtraEffect(t==false)
if BuildPatchMgr:CompareVersion(GameEntry.AppVer,"1.0.22")>=0 then
if(not IsNil(self.spinePet))then
self.spinePet.invisible=t
end
end
end
end
end
function HeroCtrl:SetEffectBeforeAttack()
self:ShowOrHideHeadBarView(false)
self:ShowOrHideBuffEffect(false)
end
function HeroCtrl:SetEffectAfterAttack()
self:RestoreHeadBarView()
self:ShowOrHideBuffEffect(true)
end
function HeroCtrl:ResetColor()
self:ChangeColor(ModulesInit.ProcedureNormalBattle.GetBattleHeroInitColor())
self:ChangeShadowAlpha(1)
self:SetSpineInvisible(false)
if self.CurrHeadBarView then
self.CurrHeadBarView:ChangeAlpha(1)
end
end
function HeroCtrl:ShowOrHideHeadBarView(e)
if(self.CurrHeadBarView and self.CurrHeadBarView:Lock(12))then
self.CurrHeadBarView:ChangeAlphaTween(e and 1 or 0)
end
end
function HeroCtrl:RestoreHeadBarView()
if self.CurrHeadBarView then
self.CurrHeadBarView:ChangeAlphaTween(1)
self.CurrHeadBarView:UnLock()
end
end
function HeroCtrl:PlaySpineAnim(o,a,e,t)
if(ModulesInit.ProcedureNormalBattle.CurrAttackHeroId~=self.HeroId)then
if(self:IsSuperArmor())then
return
end
end
if self:CheckCanSetSpineAnim()==false then
return
end
local t=self:SetSpineAnimation(0,o,a,t)
if(t~=nil)then
local a=t.Animation.Duration
local t=Time.time+a
if(t>ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime)then
ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime=t
end
e=e==nil and false or e
if(e)then
self:ChangeToIdleAfterPlaySpineAnim(a)
end
end
end
function HeroCtrl:PlaySpineAnims(i,a,e,s,r,h)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
return
end
if self.spineboy==nil then
return
end
if IsNil(self.spineboy)then
return
end
if(e)then
if(self:IsDeathState()
or self:IsNotUsualState()
)
then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return
end
else
if(ModulesInit.ProcedureNormalBattle.CurrAttackHeroId~=self.HeroId)then
if(self:IsSuperArmor())then
return
end
end
if(self:IsDeathState()
or self.CurrIsBlocking
or self:IsNotUsualState()
)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return
end
end
if(self.HeroBattleInfo:HasControlFlyBuff())then
return
end
local t=0
if(s)then
t=#i
else
t=i.Length
end
local o=0
local e=0
local n=false
self.spineboy.AnimationState:SetEmptyAnimations(0)
for a=0,t-1 do
if(s)then
e=a+1
if(e==t)then
n=true
end
else
e=a
if(e==t-1)then
n=true
end
end
local a
local i=i[e]
if(n and r)then
a=self:AddSpineAnimation(0,i,true,0,h)
else
a=self:AddSpineAnimation(0,i,false,0,h)
end
if(a~=nil)then
local a=a.Animation.Duration
if e~=t or i~="stand"then
if(a>0)then
o=o+a
end
end
end
end
local e=Time.time+o
if(e>ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime)then
ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime=e
end
a=a==nil and false or a
if(a)then
self:ChangeToIdleAfterPlaySpineAnim(o)
end
end
function HeroCtrl:ChangeToIdleAfterPlaySpineAnim(t)
local e=(require"Common/cs_coroutine")
e.start(
function()
coroutine.yield(CS.UnityEngine.WaitForSeconds(t))
if(self.CurrFsm==nil)then
return
end
local e=self.HeroBattleInfo:PlayControlFlyBuff()
if(not e)then
if(self:IsUsualState()and self.CurrFsm.curStateEnum~=HeroState.Defense and self.HeroBattleInfo:HasReposeControlBuff()==false and self:IsHeroSpecialState()==false)then
if(self.IsBigSkillAttacking)then
self.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.FightIdle
self:SetHeroPoseType(HeroPoseType.none)
self:ChangeState(HeroState.Idle)
else
self.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.NormalIdle
self:SetHeroPoseType(HeroPoseType.none)
self:ChangeState(HeroState.Idle)
end
end
end
end
)
end
function HeroCtrl:IsOnAttack()
if self.CurrBattleTeam==nil then
return false
end
if ModulesInit.ProcedureNormalBattle.IsAttackTeam(self.CurrBattleTeam.TeamId)then
return true
end
return false
end
function HeroCtrl:IsOnDefend()
if self.CurrBattleTeam==nil then
return false
end
if ModulesInit.ProcedureNormalBattle.IsAttackTeam(self.CurrBattleTeam.teamId)==false
and self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.defencePos)>0 then
return true
end
return false
end
function HeroCtrl:IsMusActiveSmallSkill()
if self.HeroBattleInfo==nil then
return false
end
if self.mLastTiggerSkillSmall==false then
if self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.mustSmallSkillByLastFail)>0 then
return true
end
end
if self:IsFullFury()==false
and self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.mustSmallSkillWithNotFullFury)>0 then
return true
end
if self.MustSmallSkill==true then
return true
end
return false
end
function HeroCtrl:GetSpineAnimName(e)
if self:IsOnDefend()then
if e=="stand"then
e="defence"
elseif e=="strike"then
e="strike2"
elseif e=="change"then
e="change2"
elseif e=="getup"then
e="getup2"
end
end
return e
end
function HeroCtrl:CheckCanSetSpineAnim(e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
return
end
if self.spineboy==nil then
return false
end
if IsNil(self.spineboy)then
return false
end
if(self:IsDeathState()
or self.willNotUsualStateInTimeLine
or self.CurrIsBlocking
or self:IsNotUsualState()
or self:IsHeroSpecialState()
or self.isRunningToBattle)
then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
if e~=true then
if(self.HeroBattleInfo:HasControlFlyBuff())then
return false
end
end
return true
end
function HeroCtrl:CheckAndSetSpineAnim(t,e,o,a,i)
if self:CheckCanSetSpineAnim(i)==false then
return
end
self:SetSpineAnimation(t,e,o,a)
end
function HeroCtrl:SetSpineAnimation(a,t,o,e)
if t=="stand"then
local e=0
end
e=e or EBattleHeroTargetType.All
local i=self:GetSpineAnimName(t)
local n=nil
if e==EBattleHeroTargetType.HERO or e==EBattleHeroTargetType.All then
if self.spineboy and self.spineboy.AnimationState then
local e=self.spineboy.invisible
self.spineboy.invisible=false
n=self.spineboy.AnimationState:SetAnimation(a,i,o)
self.spineboy:Update(0)
self.spineboy.invisible=e
self:ChangeSpineAnim(t)
end
end
if e==EBattleHeroTargetType.PET or e==EBattleHeroTargetType.All then
if self.spinePet and self.spinePet.AnimationState then
local e=self.spinePet.invisible
self.spinePet.invisible=false
self.spinePet.AnimationState:SetAnimation(a,i,o)
self.spinePet:Update(0)
self.spinePet.invisible=e
end
end
return n
end
function HeroCtrl:AddSpineAnimation(t,a,i,o,e)
e=e or EBattleHeroTargetType.All
local a=self:GetSpineAnimName(a)
local n=nil
if e==EBattleHeroTargetType.HERO or e==EBattleHeroTargetType.All then
if self.spineboy and self.spineboy.AnimationState then
n=self.spineboy.AnimationState:AddAnimation(t,a,i,o)
end
end
if e==EBattleHeroTargetType.PET or e==EBattleHeroTargetType.All then
if self.spinePet and self.spinePet.AnimationState then
self.spinePet.AnimationState:AddAnimation(t,a,i,o)
end
end
return n
end
function HeroCtrl:ChangeSpineAnim(e)
self.mOpenUpdateHud=true
self.mUpdateHudLeftTime=120
self:RefreshHeroHud()
self.mCurSpineAnim=e
end
function HeroCtrl:GetBonePos(e)
local e=self.spineboy.skeleton:FindBone(e)
if(e~=nil)then
return e:GetWorldPosition(self.spineboy.transform)
end
return nil
end
function HeroCtrl:InitState()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.CurrFsm=d:New()
local e=j:New(self)
self.CurrFsm:AddState(e)
local e=q:New(self)
self.CurrFsm:AddState(e)
local e=z:New(self)
self.CurrFsm:AddState(e)
local e=E:New(self)
self.CurrFsm:AddState(e)
local e=_:New(self)
self.CurrFsm:AddState(e)
local e=T:New(self)
self.CurrFsm:AddState(e)
local e=k:New(self)
self.CurrFsm:AddState(e)
local e=x:New(self)
self.CurrFsm:AddState(e)
local e=g:New(self)
self.CurrFsm:AddState(e)
local e=v:New(self)
self.CurrFsm:AddState(e)
local e=p:New(self)
self.CurrFsm:AddState(e)
local e=y:New(self)
self.CurrFsm:AddState(e)
local e=l:New(self)
self.CurrFsm:AddState(e)
end
function HeroCtrl:GetHeadPointPos()
if(self.spineboy==nil)then
return
end
if(not IsNil(self.topBone))then
return self.topBone:GetWorldPosition(self.spineboy.transform)+Vector3(self.DTmodelRow.headOffsetX,self.DTmodelRow.headOffsetY,0)
else
return self.spineboy.transform.position+Vector3(self.DTmodelRow.headOffsetX,self.DTmodelRow.headOffsetY,0)
end
end
function HeroCtrl:GetStandHeadPointPos()
if(self.spineboy==nil)then
return
end
if(not IsNil(self.topBone))then
return self.topBone:GetWorldPosition(self.spineboy.transform)+Vector3(self.DTmodelRow.standHeadOffsetX,self.DTmodelRow.standHeadOffsetY,0)
else
return self.spineboy.transform.position+Vector3(self.DTmodelRow.standHeadOffsetX,self.DTmodelRow.standHeadOffsetY,0)
end
end
function HeroCtrl:GetDefenseHeadPointPos()
if(self.spineboy==nil)then
return
end
if(not IsNil(self.topBone))then
return self.topBone:GetWorldPosition(self.spineboy.transform)+Vector3(self.DTmodelRow.defenseHeadOffsetX,self.DTmodelRow.defenseHeadOffsetY,0)
else
return self.spineboy.transform.position+Vector3(self.DTmodelRow.defenseHeadOffsetX,self.DTmodelRow.defenseHeadOffsetY,0)
end
end
function HeroCtrl:GetHearBarFollowPos()
if(self.HeroPoseType==HeroPoseType.stand or self.HeroPoseType==HeroPoseType.none or self.HeroPoseType==HeroPoseType.freezeIdle)then
return self:GetStandHeadPointPos()
elseif(self.HeroPoseType==HeroPoseType.fight)then
return self:GetHeadPointPos()
elseif(self.HeroPoseType==HeroPoseType.defense)then
return self:GetDefenseHeadPointPos()
end
end
function HeroCtrl:GetHeadPointLocalPos()
if(self.spineboy==nil)then
return
end
if(not IsNil(self.topBone))then
local e=self.topBone:GetLocalPosition()
return Vector3(e.x,e.y,0)+Vector3(self.DTmodelRow.headOffsetX,self.DTmodelRow.headOffsetY,0)
else
return self.spineboy.transform.localPosition+Vector3(self.DTmodelRow.headOffsetX,self.DTmodelRow.headOffsetY,0)
end
end
function HeroCtrl:GetStandHeadPointLocalPos()
if(self.spineboy==nil)then
return
end
if(not IsNil(self.topBone))then
local e=self.topBone:GetLocalPosition()
return Vector3(e.x,e.y,0)+Vector3(self.DTmodelRow.standHeadOffsetX,self.DTmodelRow.standHeadOffsetY,0)
else
return self.spineboy.transform.localPosition+Vector3(self.DTmodelRow.standHeadOffsetX,self.DTmodelRow.standHeadOffsetY,0)
end
end
function HeroCtrl:GetDefenseHeadPointLocalPos()
if(self.spineboy==nil)then
return
end
if(not IsNil(self.topBone))then
local e=self.topBone:GetLocalPosition()
return Vector3(e.x,e.y,0)+Vector3(self.DTmodelRow.defenseHeadOffsetX,self.DTmodelRow.defenseHeadOffsetY,0)
else
return self.spineboy.transform.localPosition+Vector3(self.DTmodelRow.defenseHeadOffsetX,self.DTmodelRow.defenseHeadOffsetY,0)
end
end
function HeroCtrl:GetHearBarFollowLocalPos()
if(self.HeroPoseType==HeroPoseType.stand or self.HeroPoseType==HeroPoseType.none or self.HeroPoseType==HeroPoseType.freezeIdle)then
return self:GetStandHeadPointLocalPos()
elseif(self.HeroPoseType==HeroPoseType.fight)then
return self:GetHeadPointLocalPos()
elseif(self.HeroPoseType==HeroPoseType.defense)then
return self:GetDefenseHeadPointLocalPos()
end
end
function HeroCtrl:GetReferHeadPointPos()
if(self.spineboy==nil)then
return
end
if(not IsNil(self.topBone))then
return self.topBone:GetWorldPosition(self.spineboy.transform)
else
return self.spineboy.transform.position+Vector3(self.DTmodelRow.headReferX,self.DTmodelRow.headReferY,0)
end
end
function HeroCtrl:GetMiddlePointPos()
if(IsNil(self.spineboy))then
return
end
if(ModulesInit.ProcedureNormalBattle.IsBattleTest)then
self.DTmodelRow=UIUtil.GetHeroModelCfgData(self.heroDid)
end
if(not IsNil(self.pointBone))then
return self.pointBone:GetWorldPosition(self.spineboy.transform)
else
return self.spineboy.transform.position+Vector3(self.DTmodelRow.middleOffsetX,self.DTmodelRow.middleOffsetY,0)
end
end
function HeroCtrl:GetReferMiddlePointPos()
if(IsNil(self.spineboy))then
return
end
if(not IsNil(self.pointBone))then
return self.pointBone:GetWorldPosition(self.spineboy.transform)
else
return self.spineboy.transform.position+Vector3(self.DTmodelRow.middleReferX,self.DTmodelRow.middleReferY,0)
end
end
function HeroCtrl:GetLegPointPos()
if(IsNil(self.spineboy))then
return
end
if(ModulesInit.ProcedureNormalBattle.IsBattleTest)then
self.DTmodelRow=UIUtil.GetHeroModelCfgData(self.heroDid)
end
return self.spineboy.transform.position+Vector3(self.DTmodelRow.legOffsetX,self.DTmodelRow.legOffsetY,0)
end
function HeroCtrl:GetFootPointPos()
if(IsNil(self.spineboy))then
return
end
return self.spineboy.transform.position
end
function HeroCtrl:GetReferFootPointPos()
if(IsNil(self.spineboy))then
return
end
return self.spineboy.transform.position
end
function HeroCtrl:GetPointPosWithType(t)
if(t==HeroPointType.HeadPoint)then
return self:GetStandHeadPointPos()
elseif(t==HeroPointType.ReferHeadPoint)then
return self:GetReferHeadPointPos()
elseif(t==HeroPointType.MiddlePoint)then
return self:GetMiddlePointPos()
elseif(t==HeroPointType.ReferMiddlePoint)then
return self:GetReferMiddlePointPos()
elseif(t==HeroPointType.LegPoint)then
return self:GetLegPointPos()
elseif(t==HeroPointType.FootPoint)then
return self:GetFootPointPos()
elseif(t==HeroPointType.OurTeamCenter)then
local t=self:GetTeamId()
return e:GetTeamCenterPos(t,true)
elseif(t==HeroPointType.EnemyTeamCenter)then
local t=self:GetTeamId()
return e:GetTeamCenterPos(t,false)
elseif(t==HeroPointType.HeroRootFootPoint)then
return self:GetFootPointPos()
end
end
function HeroCtrl:OnUpdate()
if(self.Ready==false)then
return
end
if(self.CurrFsm==nil)then
return
end
self.CurrFsm:OnUpdate()
if self.mHpShowData then
self:DoPlayHpHealth()
end
local e=Time.realtimeSinceStartup-self.treatureTipShowStartTime
if self.CurrTreasureContainer and e<1 then
local e=self:GetMiddlePointPos()
if e then
local e=Vector3(e.x,e.y+0.5,e.z)
GameEntry.Lua:FollowTarget(e,ModulesInit.UIGlobalManager.HurtNumContainer,self.CurrTreasureContainer.transform)
end
end
if(not IsNil(self.HudController))then
return
end
if self.mOpenUpdateHud then
self.mUpdateHudLeftTime=self.mUpdateHudLeftTime-1
if self.mUpdateHudLeftTime<=0 then
self:RefreshHeroHud()
self.mUpdateHudLeftTime=60
local e=UIUtil.GetCurAnimName(self.spineboy,0)
if e=="stand"or e=="wait"or e=="death2"or e=="fight"then
self.mOpenUpdateHud=false
end
end
end
end
function HeroCtrl:RefreshHeroHud()
if(not IsNil(self.HudController))then
return
end
if(self.Ready==false)then
return
end
if(self.CurrHurtNum==nil or self.CurrHpHealthNum==nil or self.CurrHeadBarView==nil or IsNil(self.CurrHeadBarView.transform))then
return
end
if(ModulesInit.ProcedureNormalBattle.CameraIsShake)then
return
end
if(self.battleStationRow==2)then
GameEntry.Lua:FollowHeadBarAndHud(
self:GetHearBarFollowPos(),
ModulesInit.UIGlobalManager.HeadBarContainer,
self.CurrHeadBarView.transform,
self:GetLegPointPos(),
ModulesInit.UIGlobalManager.HurtNumContainer,
self.CurrHurtNum.transform,
self:GetLegPointPos(),
ModulesInit.UIGlobalManager.HurtNumContainer,
self.CurrHpHealthNum.transform,
Vector3(0,50*CurrScreenHeightRatio,0),
self:GetMiddlePointPos(),
ModulesInit.UIGlobalManager.HurtNumContainer,
self.CurrHud.transform,
Vector3(0,-50*CurrScreenHeightRatio,0)
)
else
GameEntry.Lua:FollowHeadBarAndHud(
self:GetHearBarFollowPos(),
ModulesInit.UIGlobalManager.HeadBarContainer,
self.CurrHeadBarView.transform,
self:GetLegPointPos(),
ModulesInit.UIGlobalManager.HurtNumContainer,
self.CurrHurtNum.transform,
self:GetLegPointPos(),
ModulesInit.UIGlobalManager.HurtNumContainer,
self.CurrHpHealthNum.transform,
Vector3(0,50*CurrScreenHeightRatio,0),
self:GetMiddlePointPos(),
ModulesInit.UIGlobalManager.HurtNumContainer,
self.CurrHud.transform,
Vector3(0,-50*CurrScreenHeightRatio,0)
)
end
end
function HeroCtrl:ChangeState(e,t)
if(self.CurrFsm~=nil)then
if(self:IsDeathState()or self.willNotUsualStateInTimeLine==true)then
return
end
if e==HeroState.Death or e==HeroState.DeathWait then
if self:IsNotUsualState()and self.NotUsualType~=HeroState.Leave then
return
end
else
if self:IsNothingToDoState()then
return
end
if self.CurrFsm.curStateEnum==HeroState.Leave then
if t~=true then
return
end
elseif self:IsNotUsualState()then
return
end
end
if e==HeroState.Freeze or e==HeroState.DyingState then
EventSystem.SendEvent(CommonEventId.OnBattleHeroFakeDeath,self.HeroId)
end
self.CurrFsm:ChangeState(e)
end
end
function HeroCtrl:IsDeathState()
return self:IsState(HeroState.Death)
end
function HeroCtrl:ChangeDeathState()
self:ChangeState(HeroState.Death)
end
function HeroCtrl:DieImmediate()
if self.HeroBattleInfo then
self.HeroBattleInfo:SetHp(0,true)
end
self:ChangeDeathWaitState()
end
function HeroCtrl:IsState(e)
if self.CurrFsm.curStateEnum==e then
return true
end
return false
end
function HeroCtrl:ChangeStateUnCheckState(e)
if(self.CurrFsm~=nil)then
self.CurrFsm:ChangeState(e)
if e==HeroState.Idle then
self.NotUsualType=HeroState.Idle
end
end
end
function HeroCtrl:CheckDoAction(e)
if self.HeroBattleInfo==nil then
return false
end
return self.HeroBattleInfo:CheckDoAction(e)
end
function HeroCtrl:ResetBeforeAction(e)
if self.HeroBattleInfo==nil then
return false
end
return self.HeroBattleInfo:ResetBeforeAction(e)
end
function HeroCtrl:DoActionBeforeSkill(t,a)
if t then
local t=e:GetSkillActData(t)
if t and e:IsDependAtkType(t.atkType)then
return false,false,false
end
end
local t,e=b.DoAllLimitAction(self,t,a)
return t,e
end
function HeroCtrl:BigAttack(e,t)
self.attackTask=e
self.mBigAttackCallback=t
self.skillHurtRateAdd=nil
local e=self.attackTask.skillData
if e then
self.skillHurtRateAdd=e.skillHurtRateAdd
end
self:BeginBigAttack()
end
function HeroCtrl:BigAttackManual()
if(ModulesInit.ProcedureNormalBattle.IsAutoMode)then
return
end
if(not ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.BigSkillAttacking))then
return
end
if(not ModulesInit.ProcedureNormalBattle.GetIsOurTeamAttack())then
return
end
if(ModulesInit.ProcedureNormalBattle.CurrIsAttacking)then
return
end
if(self.CurrRoundIsBigSkillAttack)then
return
end
if(not self:GetCanBigAttack())then
return
end
self.mBigAttackCallback=nil
local e={
heroId=self.HeroId,
fireHeroId=nil,
actionType=1
}
self.CurrBattleTeam:SetBigAttackManualTask(e)
ModulesInit.ProcedureNormalBattle.StartAttackTask()
if GameInit.IsClient then
GameTools:PlayAudioLua(414)
end
end
function HeroCtrl:BeginBigAttack()
self:CheckRestoreSkinShow()
ModulesInit.ProcedureNormalBattle.SetCurrAttackHeroId(self.HeroId)
ModulesInit.ProcedureNormalBattle.CurrIsAttacking=true
ModulesInit.ProcedureNormalBattle.HideFireEffect()
self.IsBigSkillAttacking=true
ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime=0
self:ChangeState(HeroState.Attack)
self:BigAttackCoroutine()
if self.CurrRoundIsBigSkillAttack==true then
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.IsOurHero)then
if(self.HeroHeadItem~=nil)then
self.HeroHeadItem:ShowHeadMask(false)
end
end
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.CurrHeadBarView and self.CurrHeadBarView:Lock(10))then
self.CurrHeadBarView:ChangeAlphaTween(0)
end
self:ShowOrHideBuffEffect(false)
end
end
EventSystem.SendEvent(CommonEventId.OnEventNextGuide,{event="BIG_SKILL_PULL"})
if self.IsOurHero then
EventSystem.SendEvent(CommonEventId.OnEventNextGuide,{event="OUR_BIG_SKILL_PULL"})
end
end
function HeroCtrl:GetHeroFlag()
return string.format("HeroId %s heroDid %s pos %s",self.HeroId,self.heroDid,self.battleStationIndex+1)
end
function HeroCtrl:BigAttackCoroutine()
local r=true
local a=0
local t=nil
local l=nil
local s=nil
local n=ETriggerSkillAtkType.Normal
if(self.NextBigSkillId>0)then
a=self.NextBigSkillId
t=self.NextBigSkillBeAttackHeroCtrls
l=self.NextBigSkillParam
s=self.NextBigSkillChangeCfgData
self.NextBigSkillId=0
self.NextBigSkillCheckFunc=nil
self.NextBigSkillBeAttackHeroCtrls=nil
self.NextBigSkillParam=nil
self.NextBigSkillChangeCfgData=nil
r=false
local t=nil
if a then
t=e:GetSkillActData(a)
if t then
n=t.atkType
end
end
elseif self.attackTask then
local o=self.attackTask.skillDid
t=self.attackTask.skillData
if t then
s=t.skillChangeCfgData
if t.disableAttackFuryhealth~=nil then
self:SetDisableAttackFuryhealthInCurAttack(t.disableAttackFuryhealth)
end
if t.disableDefFuryhealth~=nil then
e:SetAllEnemyDisableDefFuryhealthInCurAttack(self,t.disableDefFuryhealth)
end
end
local t=nil
if o then
a=o
r=false
t=e:GetSkillActData(o)
end
if self.attackTask.triggerSkillAtkType then
n=self.attackTask.triggerSkillAtkType
elseif t then
n=t.atkType
end
self.attackTask=nil
end
if a==0 then
a=self.BigSkillId
end
if a==self.BigSkillId and n==ETriggerSkillAtkType.Normal then
if self:IsEnablePowerBeans()and self.HeroBattleInfo:HasBeans()then
a=self.ExBigSkillId
end
end
if n==ETriggerSkillAtkType.Normal then
self.CurrRoundIsBigSkillAttack=true
end
ModulesInit.ProcedureNormalBattle.ResetHpHealthInTimeLine()
local o=i.GetEntity(a)
if(o==nil)then

FightDataReportMgr:SetErrorCode(ServerErrorCode.SkillIdNoExists,string.format("技能Id不存在 heroDid %s HeroId %s BigSkillId %s",self.heroDid,self.HeroId,a))
self:OnBigAttackComplete()
return
end
if s then
setmetatable(s,{__index=o})
o=s
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
ModulesInit.ProcedureNormalBattle.ResetAttrValuesInCurAttack()
ModulesInit.ProcedureNormalBattle.ResetBuffInCurAttack()
if n~=ETriggerSkillAtkType.FightBack then
self.mLastIsBigSkillTotalSmallRound=ModulesInit.ProcedureNormalBattle.GetTotalSmallRound()
end
if e:IsDependAtkType(n)==false then
ModulesInit.ProcedureNormalBattle.AddSkillFireCount()
local e={
triggerSkillAtkType=n,
triggerSkillType=o.type,
isPetTrigger=false,
skillId=a
}
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.skillPlay,self,nil,e)
end
EventSystem.SendEvent(CommonEventId.OnHeroBigSkillAttack,{heroId=self.HeroId,triggerSkillAtkType=n,skillId=a})
ModulesInit.ProcedureNormalBattle.CurrAttackCauseHeroDie=false
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local d=ModulesInit.BattleSkillMgr.GetSkillScript(a)
local t=d.DoAction(self,o,t,l)
if(ModulesInit.ProcedureNormalBattle.FightPlayData==nil)then
if r then
FightDataReportMgr:AddBattleAction(self.HeroId,ModulesInit.ProcedureNormalBattle.GetSelectFireHeroId(),1)
end
end
self.BigSkillCompleteFunc=nil
if t then
self.BigSkillCompleteFunc=t.completeCheckFunc
end
if(t~=nil and t.SkillChangeType~=nil)then
if(t.SkillChangeType==SkillChangeType.Sequence)then
self.NextBigSkillId=t.SkillId
self.NextBigSkillCheckFunc=t.checkFunc
self.NextBigSkillBeAttackHeroCtrls=t.beAttackHeroCtrls
self.NextBigSkillParam=t.skillParam
self.NextBigSkillChangeCfgData=s
else
a=t.SkillId
if a==self.BigSkillId then
if self:IsEnablePowerBeans()and self.HeroBattleInfo:HasBeans()then
a=self.ExBigSkillId
end
end
o=i.GetEntity(a)
local e=t.beAttackHeroCtrls
if(o==nil)then
GameInit.LogError("BigSkillId 技能Id不存在",a)
FightDataReportMgr:SetErrorCode(ServerErrorCode.SkillIdNoExists,string.format("技能Id不存在 heroDid %s HeroId %s BigSkillId %s",self.heroDid,self.HeroId,a))
self:OnBigAttackComplete()
return
end
if s then
setmetatable(s,{__index=o})
o=s
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.ProcedureNormalBattle.ResetAttrValuesInCurAttack()
ModulesInit.ProcedureNormalBattle.ResetBuffInCurAttack()
d=ModulesInit.BattleSkillMgr.GetSkillScript(a)
local a=t.skillParam
t=d.DoAction(self,o,e,a)
self.BigSkillCompleteFunc=nil
if t then
self.BigSkillCompleteFunc=t.completeCheckFunc
end
if(t~=nil and t.SkillChangeType~=nil)then
if(t.SkillChangeType==SkillChangeType.Sequence)then
self.NextBigSkillId=t.SkillId
self.NextBigSkillCheckFunc=t.checkFunc
self.NextBigSkillBeAttackHeroCtrls=t.beAttackHeroCtrls
self.NextBigSkillParam=t.skillParam
self.NextBigSkillChangeCfgData=s
end
end
end
end
self:AddSkillUseCount(o.id)
local a=t and t.replacePrefabIndex
if a==nil and self.CurrPetTransform then
a=2
end
local o=o
local t=t and t.replacePrefabSkillId
if t then
o=i.GetEntity(t)
end
local e=e:GetSkillPrefabId(o,a,self.symphonyDid,self.PrefabId)
if(e==0)then
GameInit.LogError("BigSkillId 技能Id 对应预设不存在 %d",o.id)
return
end
self:SetDragonWarBigSkillId()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
self.IsBigSkillAttacking=false
if(self.HasBeenBigSkill==false)then
self.HasBeenBigSkill=true
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.firstBigSkillEnd)
end
ModulesInit.ProcedureNormalBattle.CheckHpHealth()
self:BigAttackCoroutine_AfterAndCheckHurtValue(nil,n)
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.ProcedureNormalBattle.isTimeLine=true
function BigAttack()
GameTools:PoolGameObjectSpawn(
e,
nil,
function(t,a,a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.BattleSkillEffectManager.CurrTimelineEffect=t:GetComponent(typeof(CS.YouYou.TimelineEffect))
if ModulesInit.BattleSkillEffectManager.CurrTimelineEffect==nil then
GameInit.LogErrorAndUpdate("battle NormalAttak CurrTimelineEffect == nil heroDid = "..tostring(self.heroDid)..", skillPrefabId = "..tostring(e))
end
BuildPatchMgr:PlayTimeLine(ModulesInit.BattleSkillEffectManager.CurrTimelineEffect)
h:PreloadMp4(e,function()
EventSystem.SendEvent(CommonEventId.OnHeroPlayBigSkillBegin)
ModulesInit.ProcedureNormalBattle.ShowOrHideSpecialEffect(false)
ModulesInit.GlobalBattleEffectMgr.ShowAllEffect(false)
ModulesInit.ProcedureNormalBattle.CurrTimelineEffectAttackPointCount=ModulesInit.BattleSkillEffectManager.CurrTimelineEffect.AttackPointCount
OpenOrCloseBloom(true)
ModulesInit.BattleSkillEffectManager.CurrTimelineEffect.OnStopped=function()
if GameTools:CheckRestartGameState()then
return
end
self:CheckPlayEffectBuffAfterTimeline()
ModulesInit.BattleSkillEffectManager:StopCurVideo()
OpenOrCloseBloom(false)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.ProcedureNormalBattle.isTimeLine=false
ModulesInit.ProcedureNormalBattle.RestoreAllHeroAfterTimeLine()
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
EventSystem.SendEvent(CommonEventId.OnHeroPlayBigSkillEnd)
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="BIG_SKILL_DONE"})
return
else
if(ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime>Time.time)then
local e=ModulesInit.TimeActionMgr.CreateTimeAction()
self:AddTimer(e)
e:Init(
0,
ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime-Time.time,
1,
nil,
nil,
function()
self:RemoveTimer(e)
EventSystem.SendEvent(CommonEventId.OnHeroPlayBigSkillEnd)
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="BIG_SKILL_DONE"})
self:BigAttackCoroutine_After(t,n)
end
):Run()
else
EventSystem.SendEvent(CommonEventId.OnHeroPlayBigSkillEnd)
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="BIG_SKILL_DONE"})
self:BigAttackCoroutine_After(t,n)
end
end
end
end)
end
)
end
local t=CS.DG.Tweening.DOTween.Sequence()
self:AddCommonTweener("BigAttackSequence",t)
t:AppendInterval(0)
t:AppendCallback(function()
ModulesInit.ProcedureNormalBattle.BackupAllHeroBeforeTimeLine()
ModulesInit.BattleSkillEffectManager.ResetStateOnStart()
end)
t:AppendInterval(0)
t:AppendCallback(function()
if GameInit.IsClient then
h:PlaySkillPrefabAndRemoveAsyncPreload(e,BigAttack)
end
self:RemoveCommonTweener("BigAttackSequence")
end)
end
end
function HeroCtrl:BigSkillAttackLogicEnd(e)
if self.HeroBattleInfo then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.skillPlayEnd,self,nil,{triggerSkillAtkType=e})
end
local e={
heroId=self.HeroId,
triggerSkillAtkType=e,
triggerSkillType=AttackType.BigSkill,
teamId=self:GetTeamId(),
isPetTrigger=false,
}
EventSystem.SendEvent(CommonEventId.OnHeroSkillAttackComplete,e)
end
function HeroCtrl:CheckCanExcuteNextBigSkill()
if(self.NextBigSkillId>0
and(self.NextBigSkillCheckFunc==nil or self.NextBigSkillCheckFunc())
and not ModulesInit.ProcedureNormalBattle.CheckBattleEnd()
and self:GetCanBigAttack(true,false))then
return true
end
return false
end
function HeroCtrl:CheckPlayEffectBuffAfterTimeline()
if self.HeroBattleInfo and self.effectBuffIdAfterTimeline~=nil and self.effectBuffIdAfterTimeline>0 then
self.HeroBattleInfo:PlayBattleEffectWithBuffId(self.effectBuffIdAfterTimeline)
self.effectBuffIdAfterTimeline=0
end
end
function HeroCtrl:SetEffectBuffIdAfterTimeline(e)
self.effectBuffIdAfterTimeline=e
end
function HeroCtrl:BackupBeforeTimeLine()
self.HeroBattleInfo.BeforeTimeLineHP=self.HeroBattleInfo.CurrHP
self.HeroBattleInfo.BeforeTimeLineFury=self.HeroBattleInfo.CurrFury
self.HeroBattleInfo.BeforeTimeLineBeansStatFury=self.HeroBattleInfo.BeansStatFury
self.HeroBattleInfo.BeforeTimeLineOverdrawFury=self.HeroBattleInfo.OverdrawFury
self.HeroBattleInfo.BeforeTimeLineBuffValueDic=table.deepCopy(self.HeroBattleInfo.BuffValueDic)
self.BeforeTimeLineWillBeHpHealth=self.willBeHpHealth
self.BeforeTimeLineWillBeHpHealthCrt=self.willBeHpHealthCrt
self.BeforeTimeLineHurtBeforeHP=self.hurtBeforeHP
self.BeforeTimeLineWillHealthFuryValueWithSkipBattle=self.WillHealthFuryValueWithSkipBattle
self.BeforeTimeLineNeedHurtValue=self.needHurtValue
self.BeforeTimeLineHurtBeforeArmor=self.hurtBeforeArmor
self.BeforeTimeLineNeedHurtArmorValue=self.needHurtArmorValue
self.BeforeTimeLineHurtBeforeSepsisHP=self.hurtBeforeSepsisHP
self.BeforeTimeLineHurtBeforeCurrMaxHP=self.hurtBeforeCurrMaxHP
self.BeforeTimeLineHurtBeforeCurrSepsisHp=self.hurtBeforeCurrSepsisHp
self.BeforeTimeLineNeedChangeSepsisHP=self.needChangeSepsisHP
self.BeforeTimeLineWillThornHurtValueQueue=table.deepCopy(self.WillThornHurtValueQueue)
self.BeforeTimeLineHurtWeightCount=self.hurtWeightCount
self.BeforeTimeLineAttackNeedHealthFury=self.AttackNeedHealthFury
self.BeforeTimeLineWillAddFuryWithSkill=self.WillAddFuryWithSkill
self.BeforeTimeLineWillReduceFuryWithSkill=self.WillReduceFuryWithSkill
self.BeforeTimeLineWillBloodValueQueue=table.deepCopy(self.WillBloodValueQueue)
self.BeforeTimeLinePrevHurtCategory=self.PrevHurtCategory
self.BeforeTimeLinePrevTotalHurtValue=self.PrevTotalHurtValue
self.BeforeTimeLineWillHurtValueDic=table.deepCopy(self.WillHurtValueDic)
self.BeforeTimeLineWillHealthFuryDic=table.deepCopy(self.WillHealthFuryDic)
end
function HeroCtrl:RestoreAfterTimeLine()
self.HeroBattleInfo.CurrHP=self.HeroBattleInfo.BeforeTimeLineHP
self.HeroBattleInfo.CurrFury=self.HeroBattleInfo.BeforeTimeLineFury
self.HeroBattleInfo.BeansStatFury=self.HeroBattleInfo.BeforeTimeLineBeansStatFury
self.HeroBattleInfo.OverdrawFury=self.HeroBattleInfo.BeforeTimeLineOverdrawFury
self.HeroBattleInfo.BuffValueDic=self.HeroBattleInfo.BeforeTimeLineBuffValueDic
self.willBeHpHealth=self.BeforeTimeLineWillBeHpHealth
self.willBeHpHealthCrt=self.BeforeTimeLineWillBeHpHealthCrt
self.hurtBeforeHP=self.BeforeTimeLineHurtBeforeHP
self.WillHealthFuryValueWithSkipBattle=self.BeforeTimeLineWillHealthFuryValueWithSkipBattle
self.needHurtValue=self.BeforeTimeLineNeedHurtValue
self.hurtBeforeArmor=self.BeforeTimeLineHurtBeforeArmor
self.needHurtArmorValue=self.BeforeTimeLineNeedHurtArmorValue
self.hurtBeforeSepsisHP=self.BeforeTimeLineHurtBeforeSepsisHP
self.hurtBeforeCurrMaxHP=self.BeforeTimeLineHurtBeforeCurrMaxHP
self.hurtBeforeCurrSepsisHp=self.BeforeTimeLineHurtBeforeCurrSepsisHp
self.needChangeSepsisHP=self.BeforeTimeLineNeedChangeSepsisHP
self.WillThornHurtValueQueue=self.BeforeTimeLineWillThornHurtValueQueue
self.hurtWeightCount=self.BeforeTimeLineHurtWeightCount
self.AttackNeedHealthFury=self.BeforeTimeLineAttackNeedHealthFury
self.WillAddFuryWithSkill=self.BeforeTimeLineWillAddFuryWithSkill
self.WillReduceFuryWithSkill=self.BeforeTimeLineWillReduceFuryWithSkill
self.WillBloodValueQueue=self.BeforeTimeLineWillBloodValueQueue
self.PrevHurtCategory=self.BeforeTimeLinePrevHurtCategory
self.PrevTotalHurtValue=self.BeforeTimeLinePrevTotalHurtValue
self.WillHurtValueDic=self.BeforeTimeLineWillHurtValueDic
self.WillHealthFuryDic=self.BeforeTimeLineWillHealthFuryDic
end
function HeroCtrl:SynHpHealthInTimeLine(e,t)
self.hpHealthInTimeLine=self.hpHealthInTimeLine+e
self.hpHealthCrtInTimeLine=t
end
function HeroCtrl:SynHpHealthForbidInTimeLine(e)
self.hpHealthForbidInTimeLine=e
end
function HeroCtrl:SynHpHealthAbsorptInTimeLine(e)
self.hpHealthAbsorptInTimeLine=e
end
function HeroCtrl:SynHpHealthThornInTimeLine(e)
self.hpHealthThornInTimeLine=e
end
function HeroCtrl:ResetHpHealthInTimeLine()
self.hpHealthInTimeLine=0
self.hpHealthCrtInTimeLine=false
self.hpHealthForbidInTimeLine=false
self.hpHealthAbsorptInTimeLine=0
self.hpHealthThornInTimeLine=0
self.suckBloodInTimeLine=0
self.suckBloodCrtInTimeLine=false
end
function HeroCtrl:AddBuffValue(e,a,t)
if(self.HeroBattleInfo~=nil)then
self.HeroBattleInfo:AddBuffValue(e,a,t)
end
end
function HeroCtrl:CheckAddBuffValue(a,e,t)
if(self.HeroBattleInfo~=nil)then
self.HeroBattleInfo:CheckAddBuffValue(a,e,t)
end
end
function HeroCtrl:ResetAttrValuesInBattle()
if(self.HeroBattleInfo~=nil)then
self.HeroBattleInfo:ResetAttrValuesInBattle()
end
end
function HeroCtrl:AddAttrValueArrInBattle(e)
if(self.HeroBattleInfo~=nil)then
self.HeroBattleInfo:AddAttrValueArrInBattle(e)
end
end
function HeroCtrl:AddAttrValueInBattle(e)
if(self.HeroBattleInfo~=nil)then
self.HeroBattleInfo:AddAttrValueInBattle(e)
end
end
function HeroCtrl:ResetAttrValuesInCurAttack()
if(self.HeroBattleInfo~=nil)then
self.HeroBattleInfo:ResetAttrValuesInCurAttack()
end
end
function HeroCtrl:AddAttrValueArrInCurAttack(e)
if(self.HeroBattleInfo~=nil)then
self.HeroBattleInfo:AddAttrValueArrInCurAttack(e)
end
end
function HeroCtrl:AddAttrValueInCurAttack(e)
if(self.HeroBattleInfo~=nil)then
self.HeroBattleInfo:AddAttrValueInCurAttack(e)
end
end
function HeroCtrl:RemoveAttrValueInCurAttack(e)
if(self.HeroBattleInfo~=nil)then
self.HeroBattleInfo:RemoveAttrValueInCurAttack(e)
end
end
function HeroCtrl:SynSuckBloodInTimeLine(t,e)
self.suckBloodInTimeLine=self.suckBloodInTimeLine+t
self.suckBloodCrtInTimeLine=e
end
function HeroCtrl:BigAttackCoroutine_After(e,t)
if ModulesInit.StoryManager.isAllowPlaySkillAudio then
if ModulesInit.ProcedureNormalBattle.IsPlayHeroDyingAudio==false then
GameEntry.Audio:PausedAllAudio(true)
end
end
EventSystem.SendEvent(CommonEventId.Skill_BattleUI_Reset)
if(self.HeroBattleInfo==nil)then
self:OnBigAttackComplete()
return
end
ModulesInit.ProcedureNormalBattle.ShowOrHideSpecialEffect(true)
ModulesInit.GlobalBattleEffectMgr.ShowAllEffect(true)
ModulesInit.ProcedureNormalBattle.ShowFireEffect(false)
ModulesInit.ProcedureNormalBattle.HeroResetPos()
if self.CurrHeadBarView then
self.CurrHeadBarView:ChangeAlphaTween(1)
self.CurrHeadBarView:UnLock()
end
self:ShowOrHideBuffEffect(true)
GameEntry.Pool:GameObjectDespawn(e)
ModulesInit.BattleSkillEffectManager.DespawnAllTrans()
ModulesInit.BattleSkillEffectManager.CameraControlReset()
ModulesInit.BattleSkillEffectManager.KillTweener()
self.IsBigSkillAttacking=false
if(self.HeroBattleInfo==nil)then
self:OnBigAttackComplete()
return
end
if(self.HasBeenBigSkill==false)then
self.HasBeenBigSkill=true
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.firstBigSkillEnd)
end
ModulesInit.ProcedureNormalBattle.CheckHpHealth()
self:BigAttackCoroutine_AfterAndCheckHurtValue(e,t)
end
function HeroCtrl:BigAttackCoroutine_AfterAndCheckHurtValue(t,e)
ModulesInit.ProcedureNormalBattle.CheckHurtValue(function()
self:BigAttackCoroutine_AfterAndCheckHeroDie(t,e)
end)
end
function HeroCtrl:BigAttackCoroutine_AfterAndCheckHeroDie(t,e)
ModulesInit.ProcedureNormalBattle.CheckHeroDie(function()
self:BigAttackCoroutine_AfterAndEnd(t,e)
end)
end
function HeroCtrl:BigAttackCoroutine_AfterAndEnd(t,a)
self:SetHeroPlayAttackLimit(EBattleAttackLimitType.None)
if(GameInit.IsClient)then
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="BIG_SKILL_DONE_AFTER"})
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
else
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
self:BigAttackCoroutine_AfterAndComplete(t,a)
else
local o=ModulesInit.ProcedureNormalBattle.CurrAttackCauseHeroDie and 0.5 or 0
local e=ModulesInit.TimeActionMgr.CreateTimeAction()
self:AddTimer(e)
e:Init(
0,
o,
1,
nil,
nil,
function()
self:RemoveTimer(e)
self:BigAttackCoroutine_AfterAndComplete(t,a)
end
):Run()
end
end
end
function HeroCtrl:BigAttackCoroutine_AfterAndComplete(t,e)
ModulesInit.ProcedureNormalBattle.CurrIsAttacking=false
self:OnSingleBigSkillComplete(e)
local t=self:CheckTriggerSkillComplete(self.NextBigSkillId,AttackType.BigSkill,e)
if self:CheckCanExcuteNextBigSkill()then
local t,e=self:DoActionBeforeSkill(self.NextBigSkillId)
if t then
if self:CheckCanExcuteNextBigSkill()==false or e==true then
self:HandleBigAttackComplete()
return
end
end
self:BeginBigAttack()
else
if t==false then
self:CheckTriggerSkillComplete(0,AttackType.BigSkill,e)
end
self:HandleBigAttackComplete()
end
end
function HeroCtrl:OnSingleBigSkillComplete(t)
self:BigSkillAttackLogicEnd(t)
self:SetDisableAttackFuryhealthInCurAttack(false)
e:SetAllEnemyDisableDefFuryhealthInCurAttack(self,false)
if self.BigSkillCompleteFunc then
self.BigSkillCompleteFunc()
self.BigSkillCompleteFunc=nil
end
end
function HeroCtrl:HandleBigAttackComplete()
self.NextBigSkillId=0
ModulesInit.ProcedureNormalBattle.SetCurrAttackHeroId(0)
if(self.mBigAttackCallback)then
self:OnBigAttackComplete()
else
if(self.CurrBattleTeam~=nil)then
self.CurrBattleTeam:CheckBattleEndWhenBigAttackManual()
end
end
end
function HeroCtrl:OnBigAttackComplete()
ModulesInit.ProcedureNormalBattle.ResetBuffInCurAttack()
ModulesInit.ProcedureNormalBattle.SetCurrAttackHeroId(0)
self.skillHurtRateAdd=nil
if self.mBigAttackCallback then
self.mBigAttackCallback()
end
end
function HeroCtrl:CheckTriggerSkillComplete(a,o,i)
local t=e:GetSkillActData(a)
if self.HeroBattleInfo~=nil then
if t==nil or e:IsDependAtkType(t.atkType)==false then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.skillAttackComplete,self,nil,{skillDid=a,attackType=o,triggerSkillAtkType=i})
return true
end
end
return false
end
function HeroCtrl:NormalAttack(t,e)
self.attackTask=t
self.mNormalAttackCallback=e
self.skillHurtRateAdd=nil
local e=self.attackTask.skillData
if e then
self.skillHurtRateAdd=e.skillHurtRateAdd
end
self:BeginNormalAttack(true,true)
end
function HeroCtrl:GetCanNormalAttackManual()
if(ModulesInit.ProcedureNormalBattle.IsAutoMode)then
return false
end
if ModulesInit.ProcedureNormalBattle.IsHeroSkillAttackState()==false then
return false
end
if(not ModulesInit.ProcedureNormalBattle.GetIsOurTeamAttack())then
return false
end
if(self.CurrRoundIsNormalSkillAttack)then
return false
end
if(not self:GetCanNormalAttack(true))then
return false
end
return true
end
function HeroCtrl:NormalAttackManual()
if(not self:GetCanNormalAttackManual())then
return
end
EventSystem.SendEvent(CommonEventId.OnEventNextGuide,{event="NORMAL_ATTACK_CLICK"})
self.mNormalAttackCallback=nil
if(self.IsOurHero)then
if(self.HeroHeadItem~=nil)then
self.HeroHeadItem:ShowHeadMask(true)
end
end
List.PushBack(self.CurrBattleTeam.SmallSkillAttackQueue,self)
ModulesInit.ProcedureNormalBattle.EnterBattleRoundNormalSkill()
if GameInit.IsClient then
GameTools:PlayAudioLua(415)
end
if(ModulesInit.ProcedureNormalBattle.CurrIsAttacking==false)then
ModulesInit.ProcedureNormalBattle.StartAttackTask()
return
end
end
function HeroCtrl:BeginNormalAttack(t,o)
self:CheckRestoreSkinShow()
ModulesInit.ProcedureNormalBattle.SetCurrAttackHeroId(self.HeroId)
ModulesInit.ProcedureNormalBattle.CurrIsAttacking=true
ModulesInit.ProcedureNormalBattle.HideFireEffect()
self.IsNormalAttacking=true
local t=0
if self.attackTask then
local a=self.attackTask.skillDid
local e=e:GetSkillActData(a)
if self.attackTask.triggerSkillAtkType then
t=self.attackTask.triggerSkillAtkType
elseif e then
t=e.atkType
end
end
if t==ETriggerSkillAtkType.Normal then
self.CurrRoundIsNormalSkillAttack=true
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.IsOurHero)then
if(self.HeroHeadItem~=nil)then
self.HeroHeadItem:ShowHeadMask(true)
end
end
end
if o then
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.IsOurHero)then
if(self.HeroHeadItem~=nil)then
if(self.HeroHeadItem.OnShowClickEffect)then
self.HeroHeadItem.OnShowClickEffect(self.HeroHeadItem.heroItemTrans)
end
end
end
end
end
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if self.CurrHeadBarView then
if(self.CurrHeadBarView:Lock(10))then
self.CurrHeadBarView:ChangeAlphaTween(0)
end
self.CurrHeadBarView.lock=true
end
self:ShowOrHideBuffEffect(false)
end
ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime=0
self:ChangeState(HeroState.Attack)
self:NormalAttackCoroutine()
if self.IsOurHero then
EventSystem.SendEvent(CommonEventId.OnEventNextGuide,{event="OUR_NORMAL_ATTACK_CLICK"})
end
end
function HeroCtrl:SetCurrRoundCanTriggerSmallSkill()
if(self.SmallSkillId>0)then
local t=i.GetEntity(self.SmallSkillId)
if(t==nil)then
GameInit.LogError(" 技能Id不存在 heroDid %s HeroId %s SmallSkillId %s",tostring(self.heroDid),tostring(self.HeroId),tostring(self.SmallSkillId))
FightDataReportMgr:SetErrorCode(ServerErrorCode.SkillIdNoExists,string.format("技能Id不存在 heroDid %s HeroId %s SmallSkillId %s",self.heroDid,self.HeroId,self.SmallSkillId))
return
end
local e=RandomMgr:GetBattleRandom()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
if(self.CertainlyTriggerSmallSkillRound==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound)then
e=0
end
local a=self:IsMusActiveSmallSkill()
if(self.ForbidSmallSkill)then
e=RandomForbidValue
a=false
end
local o=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.skillTriggerRateAdd)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then




end
if(a or(t.skillRate+self.HeroBattleInfo.SkillTriggerRate+o)>=e)then
self.mLastTiggerSkillSmall=true
self.CurrRoundCanTriggerSmallSkill=true
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
else
self.CurrRoundCanTriggerSmallSkill=false
self.mLastTiggerSkillSmall=false
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
else
self.CurrRoundCanTriggerSmallSkill=false
self.mLastTiggerSkillSmall=false
end
end
function HeroCtrl:NormalAttackCoroutine()
ModulesInit.ProcedureNormalBattle.ResetHpHealthInTimeLine()
local o=nil
local r=self.NormalSkillId
local d=self.SmallSkillId
local u=true
local n=nil
local s=self.CurrRoundCanTriggerSmallSkill
local a=nil
local l={}
if(self.NextNormalOrSmallSkillId>0)then
l=self.NextNormalOrSamllSkillParam
if self.NextSkillType==EBattleSkillType.SkillSmall then
s=true
d=self.NextNormalOrSmallSkillId
else
s=false
r=self.NextNormalOrSmallSkillId
end
n=self.NextNormalOrSamllSkillChangeCfgData
self.NextNormalOrSmallSkillId=0
self.NextNormalOrSmallSkillCheckFunc=nil
self.NextNormalOrSamllSkillParam=nil
self.NextNormalOrSamllSkillChangeCfgData=nil
u=false
elseif self.attackTask then
local h=self.attackTask.skillDid
o=self.attackTask.skillData
if o then
n=o.skillChangeCfgData
if o.disableAttackFuryhealth~=nil then
self:SetDisableAttackFuryhealthInCurAttack(o.disableAttackFuryhealth)
end
if o.disableDefFuryhealth~=nil then
e:SetAllEnemyDisableDefFuryhealthInCurAttack(self,o.disableDefFuryhealth)
end
end
local t=nil
if h then
t=i.GetEntity(h)
if t then
u=false
if t.type==1 then
r=h
s=false
elseif t.type==2 then
s=true
d=h
end
end
t=e:GetSkillActData(h)
end
if self.attackTask.triggerSkillAtkType then
a=self.attackTask.triggerSkillAtkType
elseif t then
a=t.atkType
end
self.attackTask=nil
end
local c=r
local t
if s then
c=d
t=i.GetEntity(d)
if a==nil then
a=t.atkType
end
if a~=ETriggerSkillAtkType.FightBack then
self.mLastIsSmallSkillTotalSamllRound=ModulesInit.ProcedureNormalBattle.GetTotalSmallRound()
end
self.IsSmallSkillAttacking=true
EventSystem.SendEvent(CommonEventId.OnHeroSmallSkillAttack,{heroId=self.HeroId,triggerSkillAtkType=a})
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
else
c=r
t=i.GetEntity(r)
if a==nil then
a=t.atkType
end
if a~=ETriggerSkillAtkType.FightBack then
self.mLastIsNormalSkillTotalSmallRound=ModulesInit.ProcedureNormalBattle.GetTotalSmallRound()
end
EventSystem.SendEvent(CommonEventId.OnHeroNormalAttack,{heroId=self.HeroId,triggerSkillAtkType=a})
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(t==nil)then
GameInit.LogError(" 技能Id不存在")
FightDataReportMgr:SetErrorCode(ServerErrorCode.SkillIdNoExists,string.format("技能Id不存在 heroDid %s HeroId %s NormalSkillId %s",self.heroDid,self.HeroId,self.NormalSkillId))
return
end
if n then
setmetatable(n,{__index=t})
t=n
end
ModulesInit.ProcedureNormalBattle.CurrAttackCauseHeroDie=false
local r=ModulesInit.BattleSkillMgr.GetSkillScript(t.id)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(ModulesInit.ProcedureNormalBattle.FightPlayData==nil)then
if u then
FightDataReportMgr:AddBattleAction(self.HeroId,ModulesInit.ProcedureNormalBattle.GetSelectFireHeroId(),2)
end
end
ModulesInit.ProcedureNormalBattle.ResetAttrValuesInCurAttack()
ModulesInit.ProcedureNormalBattle.ResetBuffInCurAttack()
if e:IsDependAtkType(a)==false then
ModulesInit.ProcedureNormalBattle.AddSkillFireCount()
local e={
triggerSkillAtkType=a,
triggerSkillType=t.type,
isPetTrigger=false,
skillId=c
}
if s==true then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.skill2Play,self,nil,e)
else
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.skill3Play,self,nil,e)
end
end
l=l or{}
l.isFristAction=u
local o=r.DoAction(self,t,o,l)
if(o~=nil and o.SkillChangeType~=nil)then
if(o.SkillChangeType==SkillChangeType.Sequence)then
self.NextNormalOrSmallSkillId=o.SkillId
self.NextNormalOrSmallSkillCheckFunc=o.checkFunc
self.NextNormalOrSamllSkillParam=o.skillParam
self.NextSkillType=o.skillType
self.NextNormalOrSamllSkillChangeCfgData=n
else
local e=o.SkillId
t=i.GetEntity(e)
local a=o.beAttackHeroCtrls
if(t==nil)then
GameInit.LogError("Normal or Small SkillId 技能Id不存在",e)
FightDataReportMgr:SetErrorCode(ServerErrorCode.SkillIdNoExists,string.format("技能Id不存在 heroDid %s HeroId %s BigSkillId %s",self.heroDid,self.HeroId,e))
self:OnNormalAttackComplete()
return
end
if n then
setmetatable(n,{__index=t})
t=n
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.ProcedureNormalBattle.ResetAttrValuesInCurAttack()
ModulesInit.ProcedureNormalBattle.ResetBuffInCurAttack()
r=ModulesInit.BattleSkillMgr.GetSkillScript(e)
r.DoAction(self,t,a)
end
end
self:AddSkillUseCount(t.id)
local o=o and o.replacePrefabIndex
if o==nil and self.CurrPetTransform then
o=2
end
local e=e:GetSkillPrefabId(t,o,self.symphonyDid)
if(e==0)then
GameInit.LogError("drSkillAtc 技能Id 对应预设不存在 %s",t.id)
return
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
local e=AttackType.Normal
if(self.IsSmallSkillAttacking)then
e=AttackType.SmallSkill
end
self.IsNormalAttacking=false
self.IsSmallSkillAttacking=false
if(self.CurrFsm~=nil)then
self.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.NormalIdle
self:ChangeState(HeroState.Idle)
end
ModulesInit.ProcedureNormalBattle.CheckHpHealth()
self:NormalAttackCoroutine_AfterAndCheckHurtValue(nil,a,e)
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.ProcedureNormalBattle.isTimeLine=true
function NormalAttak()
ModulesInit.BattleSkillEffectManager.ResetStateOnStart()
GameTools:PoolGameObjectSpawn(
e,
nil,
function(t,o,o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.BattleSkillEffectManager.CurrTimelineEffect=t:GetComponent(typeof(CS.YouYou.TimelineEffect))
if ModulesInit.BattleSkillEffectManager.CurrTimelineEffect==nil then
GameInit.LogErrorAndUpdate("battle NormalAttak CurrTimelineEffect == nil heroDid = "..tostring(self.heroDid)..", skillPrefabId = "..tostring(e))
end
BuildPatchMgr:PlayTimeLine(ModulesInit.BattleSkillEffectManager.CurrTimelineEffect)
ModulesInit.ProcedureNormalBattle.CurrTimelineEffectAttackPointCount=ModulesInit.BattleSkillEffectManager.CurrTimelineEffect.AttackPointCount
h:PreloadMp4(e,function()
OpenOrCloseBloom(true)
ModulesInit.BattleSkillEffectManager.CurrTimelineEffect.OnStopped=function()
if GameTools:CheckRestartGameState()then
return
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:CheckPlayEffectBuffAfterTimeline()
OpenOrCloseBloom(false)
ModulesInit.ProcedureNormalBattle.isTimeLine=false
ModulesInit.ProcedureNormalBattle.RestoreAllHeroAfterTimeLine()
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
else
if(ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime>Time.time)then
local e=ModulesInit.TimeActionMgr.CreateTimeAction()
self:AddTimer(e)
e:Init(
0,
ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime-Time.time,
1,
nil,
nil,
function()
self:RemoveTimer(e)
self:NormalAttackCoroutine_After(t,a)
end
):Run()
else
self:NormalAttackCoroutine_After(t,a)
end
end
end
end)
end
)
end
local t=CS.DG.Tweening.DOTween.Sequence()
self:AddCommonTweener("NormalAttackSequence",t)
t:AppendInterval(0)
t:AppendCallback(function()
ModulesInit.ProcedureNormalBattle.BackupAllHeroBeforeTimeLine()
end)
t:AppendInterval(0)
t:AppendCallback(function()
if GameInit.IsClient then
h:PlaySkillPrefabAndRemoveAsyncPreload(e,NormalAttak)
end
self:RemoveCommonTweener("NormalAttackSequence")
end)
end
end
function HeroCtrl:NormalAttackCoroutine_After(t,a)
if ModulesInit.StoryManager.isAllowPlaySkillAudio then
GameEntry.Audio:PausedAllAudio(true)
end
EventSystem.SendEvent(CommonEventId.Skill_BattleUI_Reset)
if(self.HeroBattleInfo==nil)then
self:OnNormalAttackComplete()
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="NORMAL_ATTACK_DONE"})
return
end
ModulesInit.ProcedureNormalBattle.ShowFireEffect(false)
ModulesInit.ProcedureNormalBattle.HeroResetPos()
local e=AttackType.Normal
if(self.IsSmallSkillAttacking)then
e=AttackType.SmallSkill
end
self.IsNormalAttacking=false
self.IsSmallSkillAttacking=false
if self.CurrHeadBarView then
self.CurrHeadBarView:ChangeAlphaTween(1)
self.CurrHeadBarView:UnLock()
end
self:ShowOrHideBuffEffect(true)
if(self.CurrFsm~=nil)then
if self.HeroBattleInfo and self.HeroBattleInfo:HasStrongControlBuff()then
self.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.EmptyAnim
else
self.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.NormalIdle
end
self:ChangeState(HeroState.Idle)
end
GameEntry.Pool:GameObjectDespawn(t)
ModulesInit.BattleSkillEffectManager.DespawnAllTrans()
ModulesInit.BattleSkillEffectManager.CameraControlReset()
ModulesInit.BattleSkillEffectManager.KillTweener()
ModulesInit.ProcedureNormalBattle.CheckHpHealth()
self:NormalAttackCoroutine_AfterAndCheckHurtValue(t,a,e)
end
function HeroCtrl:NormalAttackCoroutine_AfterAndCheckHurtValue(a,e,t)
ModulesInit.ProcedureNormalBattle.CheckHurtValue(function()
self:NormalAttackCoroutine_AfterAndCheckHeroDie(a,e,t)
end)
end
function HeroCtrl:NormalAttackCoroutine_AfterAndCheckHeroDie(a,t,e)
ModulesInit.ProcedureNormalBattle.CheckHeroDie(function()
self:NormalAttackCoroutine_AfterAndEnd(a,t,e)
end)
end
function HeroCtrl:NormalAttackCoroutine_AfterAndEnd(e,t,a)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
else
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
ModulesInit.ProcedureNormalBattle.CurrIsAttacking=false
self:HandleNormalAttackCoroutineComplete(a,t)
else
local o=ModulesInit.ProcedureNormalBattle.CurrAttackCauseHeroDie and 0.5 or 0
local e=ModulesInit.TimeActionMgr.CreateTimeAction()
self:AddTimer(e)
e:Init(
0,
o,
1,
nil,
nil,
function()
self:RemoveTimer(e)
ModulesInit.ProcedureNormalBattle.CurrIsAttacking=false
self:HandleNormalAttackCoroutineComplete(a,t)
end
):Run()
end
end
end
function HeroCtrl:HandleNormalAttackCoroutineComplete(e,t)
self:NormalSkillAttackLogicEnd(e,t)
local a=self:CheckTriggerSkillComplete(self.NextNormalOrSmallSkillId,e,t)
if self:CheckCanExcuteNextNormalSkill()then
local e,t=self:DoActionBeforeSkill(self.NextNormalOrSmallSkillId)
if e then
if self:CheckCanExcuteNextNormalSkill()==false or t==true then
self:HandleNormalAttackComplete()
return
end
end
self:BeginNormalAttack()
else
if a==false then
self:CheckTriggerSkillComplete(0,e,t)
end
self:HandleNormalAttackComplete()
end
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="NORMAL_ATTACK_DONE"})
end
function HeroCtrl:CheckCanExcuteNextNormalSkill()
if(self.NextNormalOrSmallSkillId>0
and(self.NextNormalOrSmallSkillCheckFunc==nil or self.NextNormalOrSmallSkillCheckFunc())
and not ModulesInit.ProcedureNormalBattle.CheckBattleEnd()
and self:GetCanNormalAttack(false,true))then
return true
end
return false
end
function HeroCtrl:NormalSkillAttackLogicEnd(t,e)
if t==AttackType.SmallSkill then
if self.HeroBattleInfo then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.skill2PlayEnd,self,nil,{triggerSkillAtkType=e})
end
else
if self.HeroBattleInfo then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.skill3PlayEnd,self,nil,{triggerSkillAtkType=e})
end
end
end
function HeroCtrl:NormalSkillAttackLogicEnd(a,t)
self:SetDisableAttackFuryhealthInCurAttack(false)
e:SetAllEnemyDisableDefFuryhealthInCurAttack(self,false)
if a==AttackType.SmallSkill then
if self.HeroBattleInfo then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.skill2PlayEnd,self,nil,{triggerSkillAtkType=t})
end
else
if self.HeroBattleInfo then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.skill3PlayEnd,self,nil,{triggerSkillAtkType=t})
end
end
local e={
heroId=self.HeroId,
triggerSkillAtkType=t,
triggerSkillType=a,
teamId=self:GetTeamId(),
isPetTrigger=false,
}
EventSystem.SendEvent(CommonEventId.OnHeroSkillAttackComplete,e)
end
function HeroCtrl:HandleNormalAttackComplete()
self.NextNormalOrSmallSkillId=0
self:OnNormalAttackComplete()
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="NORMAL_ATTACK_DONE"})
end
function HeroCtrl:OnNormalAttackComplete()
ModulesInit.ProcedureNormalBattle.ResetBuffInCurAttack()
ModulesInit.ProcedureNormalBattle.SetCurrAttackHeroId(0)
self.skillHurtRateAdd=nil
if self.mNormalAttackCallback then
self.mNormalAttackCallback()
end
end
function HeroCtrl:CheckCanExcuteNextNormalSkill()
if(self.NextNormalOrSmallSkillId>0
and(self.NextNormalOrSmallSkillCheckFunc==nil or self.NextNormalOrSmallSkillCheckFunc())
and not ModulesInit.ProcedureNormalBattle.CheckBattleEnd()
and self:GetCanNormalAttack(false,true))then
return true
end
return false
end
function HeroCtrl:PetFightAttack(t,e)
self.attackTask=t
self.mPetFightAttackCallback=e
self.skillHurtRateAdd=nil
local e=self.attackTask.skillData
if e then
self.skillHurtRateAdd=e.skillHurtRateAdd
end
self:PetFightBigAttack()
end
function HeroCtrl:PetFightBigAttack()
self:CheckRestoreSkinShow()
ModulesInit.ProcedureNormalBattle.SetCurrAttackHeroId(self.HeroId)
ModulesInit.ProcedureNormalBattle.CurrIsAttacking=true
ModulesInit.ProcedureNormalBattle.HideFireEffect()
self.IsPetSkillAttacking=true
ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime=0
self:ChangeState(HeroState.Attack)
self:PetFightAttackCoroutine()
if self.CurrRoundIsPetFightSkillAttack==true then
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
self:ShowOrHideBuffEffect(false)
end
end
end
function HeroCtrl:PetFightAttackCoroutine()
local r=true
local o=0
local t=nil
local d=nil
local n=nil
local s=ETriggerSkillAtkType.Normal
if(self.NextPetFightSkillId>0)then
o=self.NextPetFightSkillId
t=self.NextPetFightSkillBeAttackHeroCtrls
d=self.NextPetFightSkillParam
n=self.NextPetFightSkillChangeCfgData
self.NextPetFightSkillId=0
self.NextPetFightSkillCheckFunc=nil
self.NextPetFightSkillBeAttackHeroCtrls=nil
self.NextPetFightSkillParam=nil
self.NextPetFightSkillChangeCfgData=nil
r=false
local t=nil
if o then
t=e:GetSkillActData(o)
if t then
s=t.atkType
end
end
elseif self.attackTask then
local a=self.attackTask.skillDid
t=self.attackTask.skillData
if t then
n=t.skillChangeCfgData
if t.disableAttackFuryhealth~=nil then
self:SetDisableAttackFuryhealthInCurAttack(t.disableAttackFuryhealth)
end
if t.disableDefFuryhealth~=nil then
e:SetAllEnemyDisableDefFuryhealthInCurAttack(self,t.disableDefFuryhealth)
end
end
local t=nil
if a then
o=a
r=false
t=e:GetSkillActData(a)
end
if self.attackTask.triggerSkillAtkType then
s=self.attackTask.triggerSkillAtkType
elseif t then
s=t.atkType
end
self.attackTask=nil
end
if o==0 then
o=self.PetFightSkillId
end
if s==ETriggerSkillAtkType.Normal then
self.CurrRoundIsPetFightSkillAttack=true
end
ModulesInit.ProcedureNormalBattle.ResetHpHealthInTimeLine()
local a=i.GetEntity(o)
if(a==nil)then

FightDataReportMgr:SetErrorCode(ServerErrorCode.SkillIdNoExists,string.format("技能Id不存在 heroDid %s HeroId %s PetFightSkillId %s",self.heroDid,self.HeroId,o))
self:OnPetFightAttackComplete()
return
end
if n then
setmetatable(n,{__index=a})
a=n
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.ProcedureNormalBattle.ResetAttrValuesInCurAttack()
ModulesInit.ProcedureNormalBattle.ResetBuffInCurAttack()
if e:IsDependAtkType(s)==false then
ModulesInit.ProcedureNormalBattle.AddSkillFireCount()
end
EventSystem.SendEvent(CommonEventId.OnPetFightSkillAttack,{heroId=self.HeroId,triggerSkillAtkType=s,triggerSkillType=a.type})
ModulesInit.ProcedureNormalBattle.CurrAttackCauseHeroDie=false
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local r=ModulesInit.BattleSkillMgr.GetSkillScript(a.scriptId)
local t=r.DoAction(self,a,t,d)
self.PetFightSkillCompleteFunc=nil
if t then
self.PetFightSkillCompleteFunc=t.completeCheckFunc
end
if(t~=nil and t.SkillChangeType~=nil)then
if(t.SkillChangeType==SkillChangeType.Sequence)then
self.PetFightBigSkillId=t.SkillId
self.NextPetFightSkillCheckFunc=t.checkFunc
self.NextPetFightSkillBeAttackHeroCtrls=t.beAttackHeroCtrls
self.NextPetFightSkillParam=t.skillParam
self.NextPetFightSkillChangeCfgData=n
else
o=t.SkillId
a=i.GetEntity(o)
local e=t.beAttackHeroCtrls
if(a==nil)then
GameInit.LogError("PetFightSkillId 技能Id不存在",o)
FightDataReportMgr:SetErrorCode(ServerErrorCode.SkillIdNoExists,string.format("技能Id不存在 heroDid %s HeroId %s PetFightSkillId %s",self.heroDid,self.HeroId,o))
self:OnPetFightAttackComplete()
return
end
if n then
setmetatable(n,{__index=a})
a=n
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.ProcedureNormalBattle.ResetAttrValuesInCurAttack()
ModulesInit.ProcedureNormalBattle.ResetBuffInCurAttack()
r=ModulesInit.BattleSkillMgr.GetSkillScript(a.scriptId)
t=r.DoAction(self,a,e)
self.PetFightSkillCompleteFunc=nil
if t then
self.PetFightSkillCompleteFunc=t.completeCheckFunc
end
if(t~=nil and t.SkillChangeType~=nil)then
if(t.SkillChangeType==SkillChangeType.Sequence)then
self.NextPetFightSkillId=t.SkillId
self.NextPetFightSkillCheckFunc=t.checkFunc
self.NextPetFightSkillBeAttackHeroCtrls=t.beAttackHeroCtrls
self.NextPetFightSkillParam=t.skillParam
self.NextPetFightSkillChangeCfgData=n
end
end
end
end
self:AddSkillUseCount(a.id)
local n=t and t.replacePrefabIndex
if n==nil and self.CurrPetTransform then
n=2
end
local o=a
local t=t and t.replacePrefabSkillId
if t then
o=i.GetEntity(t)
end
local t=e:GetSkillPrefabId(o,n,self.symphonyDid)
if(t==0)then
GameInit.LogError("BigSkillId 技能Id 对应预设不存在 %d",o.id)
return
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
self.IsPetSkillAttacking=false
ModulesInit.ProcedureNormalBattle.CheckHpHealth()
self:PetFightAttackCoroutine_AfterAndCheckHurtValue(nil,s,a.type)
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.ProcedureNormalBattle.isTimeLine=true
function PetFightAttack()
GameEntry.Pool:GameObjectSpawn(
t,
nil,
function(e,o,o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.BattleSkillEffectManager.CurrTimelineEffect=e:GetComponent(typeof(CS.YouYou.TimelineEffect))
if ModulesInit.BattleSkillEffectManager.CurrTimelineEffect==nil then
GameInit.LogErrorAndUpdate("battle NormalAttak CurrTimelineEffect == nil heroDid = "..tostring(self.heroDid)..", skillPrefabId = "..tostring(t))
end
BuildPatchMgr:PlayTimeLine(ModulesInit.BattleSkillEffectManager.CurrTimelineEffect)
h:PreloadMp4(t,function()
ModulesInit.ProcedureNormalBattle.ShowOrHideSpecialEffect(false)
ModulesInit.GlobalBattleEffectMgr.ShowAllEffect(false)
ModulesInit.ProcedureNormalBattle.CurrTimelineEffectAttackPointCount=ModulesInit.BattleSkillEffectManager.CurrTimelineEffect.AttackPointCount
OpenOrCloseBloom(true)
ModulesInit.BattleSkillEffectManager.CurrTimelineEffect.OnStopped=function()
if GameTools:CheckRestartGameState()then
return
end
self:CheckPlayEffectBuffAfterTimeline()
ModulesInit.BattleSkillEffectManager:StopCurVideo()
OpenOrCloseBloom(false)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
ModulesInit.ProcedureNormalBattle.isTimeLine=false
ModulesInit.ProcedureNormalBattle.RestoreAllHeroAfterTimeLine()
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
else
if(ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime>Time.time)then
local t=ModulesInit.TimeActionMgr.CreateTimeAction()
self:AddTimer(t)
t:Init(
0,
ModulesInit.ProcedureNormalBattle.CurrSkillMinStopTime-Time.time,
1,
nil,
nil,
function()
self:RemoveTimer(t)
self:PetFightAttackCoroutine_After(e,s,a.type)
end
):Run()
else
self:PetFightAttackCoroutine_After(e,s,a.type)
end
end
end
end)
end
)
end
local e=CS.DG.Tweening.DOTween.Sequence()
self:AddCommonTweener("PetAttackSequence",e)
e:AppendInterval(0)
e:AppendCallback(function()
ModulesInit.ProcedureNormalBattle.BackupAllHeroBeforeTimeLine()
ModulesInit.BattleSkillEffectManager.ResetStateOnStart()
end)
e:AppendInterval(0)
e:AppendCallback(function()
if GameInit.IsClient then
h:PlaySkillPrefabAndRemoveAsyncPreload(t,PetFightAttack)
end
self:RemoveCommonTweener("PetAttackSequence")
end)
end
end
function HeroCtrl:PetFightSkillAttackLogicEnd(t,a)
self:SetDisableAttackFuryhealthInCurAttack(false)
e:SetAllEnemyDisableDefFuryhealthInCurAttack(self,false)
local e={
heroId=self.HeroId,
triggerSkillAtkType=t,
triggerSkillType=a,
teamId=self:GetTeamId(),
isPetTrigger=true,
}
EventSystem.SendEvent(CommonEventId.OnHeroSkillAttackComplete,e)
end
function HeroCtrl:CheckCanExcuteNextPetFightSkill()
if(self.NextPetFightSkillId>0
and(self.NextPetFightSkillCheckFunc==nil or self.NextPetFightSkillCheckFunc())
and not ModulesInit.ProcedureNormalBattle.CheckBattleEnd()
and self:GetCanPetFightAttack(self.NextPetFightSkillId))then
return true
end
return false
end
function HeroCtrl:PetFightAttackCoroutine_After(e,t,a)
if ModulesInit.StoryManager.isAllowPlaySkillAudio then
if ModulesInit.ProcedureNormalBattle.IsPlayHeroDyingAudio==false then
GameEntry.Audio:PausedAllAudio(true)
end
end
EventSystem.SendEvent(CommonEventId.Skill_BattleUI_Reset)
if(self.HeroBattleInfo==nil)then
self:OnPetFightAttackComplete()
return
end
ModulesInit.ProcedureNormalBattle.ShowOrHideSpecialEffect(true)
ModulesInit.GlobalBattleEffectMgr.ShowAllEffect(true)
ModulesInit.ProcedureNormalBattle.ShowFireEffect(false)
ModulesInit.ProcedureNormalBattle.HeroResetPos()
self:ShowOrHideBuffEffect(true)
GameEntry.Pool:GameObjectDespawn(e)
ModulesInit.BattleSkillEffectManager.DespawnAllTrans()
ModulesInit.BattleSkillEffectManager.CameraControlReset()
ModulesInit.BattleSkillEffectManager.KillTweener()
self.IsPetSkillAttacking=false
if(self.HeroBattleInfo==nil)then
self:OnPetFightAttackComplete()
return
end
ModulesInit.ProcedureNormalBattle.CheckHpHealth()
self:PetFightAttackCoroutine_AfterAndCheckHurtValue(e,t,a)
end
function HeroCtrl:PetFightAttackCoroutine_AfterAndCheckHurtValue(a,t,e)
ModulesInit.ProcedureNormalBattle.CheckHurtValue(function()
self:PetFightAttackCoroutine_AfterAndCheckHeroDie(a,t,e)
end)
end
function HeroCtrl:PetFightAttackCoroutine_AfterAndCheckHeroDie(t,e,a)
ModulesInit.ProcedureNormalBattle.CheckHeroDie(function()
self:PetFightAttackCoroutine_AfterAndEnd(t,e,a)
end)
end
function HeroCtrl:PetFightAttackCoroutine_AfterAndEnd(a,t,o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
else
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
self:PetFightAttackCoroutine_AfterAndComplete(a,t,o)
else
local i=ModulesInit.ProcedureNormalBattle.CurrAttackCauseHeroDie and 0.5 or 0
local e=ModulesInit.TimeActionMgr.CreateTimeAction()
self:AddTimer(e)
e:Init(
0,
i,
1,
nil,
nil,
function()
self:RemoveTimer(e)
self:PetFightAttackCoroutine_AfterAndComplete(a,t,o)
end
):Run()
end
end
end
function HeroCtrl:PetFightAttackCoroutine_AfterAndComplete(a,t,e)
ModulesInit.ProcedureNormalBattle.CurrIsAttacking=false
self:OnSinglePetFightSkillComplete(t,e)
local a=self:CheckTriggerSkillComplete(self.NextPetFightSkillId,e,t)
if self:CheckCanExcuteNextPetFightSkill()then
local e,t=self:DoActionBeforeSkill(self.NextBigSkillId)
if e then
if self:CheckCanExcuteNextPetFightSkill()==false or t==true then
self:HandlePetFightAttackComplete()
return
end
end
self:PetFightBigAttack()
else
if a==false then
self:CheckTriggerSkillComplete(0,e,t)
end
self:HandlePetFightAttackComplete()
end
end
function HeroCtrl:OnSinglePetFightSkillComplete(e,t)
self:PetFightSkillAttackLogicEnd(e,t)
if self.PetFightSkillCompleteFunc then
self.PetFightSkillCompleteFunc()
self.PetFightSkillCompleteFunc=nil
end
end
function HeroCtrl:HandlePetFightAttackComplete()
self.NextPetFightSkillId=0
if(self.mPetFightAttackCallback)then
self:OnPetFightAttackComplete()
end
end
function HeroCtrl:OnPetFightAttackComplete()
self.skillHurtRateAdd=nil
ModulesInit.ProcedureNormalBattle.SetCurrAttackHeroId(0)
if self.mPetFightAttackCallback then
self.mPetFightAttackCallback()
end
end
function HeroCtrl:Hurt(a,i,n,e,o)
if(self.HeroBattleInfo==nil)then
return
end
local t=self:GetArmor()
self.hurtBeforeArmor=t
self.needHurtArmorValue=0
self.hurtBeforeHP=self.HeroBattleInfo.CurrHP
self.needHurtValue=0
self.currTotalHurt=0
self.hurtBeforeSepsisHP=self.HeroBattleInfo.SepsisHp
self.hurtBeforeCurrMaxHP=self.HeroBattleInfo.CurrMaxHP
self.hurtBeforeCurrSepsisHp=self.HeroBattleInfo.CurrSepsisHp
self.needChangeSepsisHP=0
self.beAttackType=e
self:ChangeState(HeroState.BeAttackState)
self.PrevTotalHurtValue=0
local e=a
if o then
self.mBattleHurtType=EBattleHurtType.HurtArmor
e=math.min(e,t)
self.hurtBeforeArmor=t
self.needHurtArmorValue=e
else
self.mBattleHurtType=EBattleHurtType.HurtHp
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.sufferDmg,self,self,a)
if(self.hurtLimit>0)then
if(a>self.hurtLimit)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
a=self.hurtLimit
self.hurtLimit=0
end
end
e=a
self.hurtBeforeHP=self.HeroBattleInfo.CurrHP
self.needHurtValue=a
if(self.beAttackType==AttackType.SmallSkill or self.beAttackType==AttackType.Normal)then
if(self.ImmuneNormalAndSmallSkill)then
self.needHurtValue=0
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
if self.immuneDamageWithConsume then
self.needHurtValue=0
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if self.resistFatalDamage then
self.needHurtValue=0
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
self.currTotalHurt=self.needHurtValue
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
self.willHurtQueue=self.WillHurtValueDic[i]
if(self.willHurtQueue==nil)then
self.willHurtQueue=List.New()
self.WillHurtValueDic[i]=self.willHurtQueue
else
List.Clear(self.willHurtQueue)
end
local t=self.WillHealthFuryValueDic[i]
local o=self.WillHealthFuryDic[i]
if(o==nil)then
o=List.New()
self.WillHealthFuryDic[i]=o
else
List.Clear(o)
end
local s=n[i+1]
if(s~=nil)then
self.hurtWeightCount=#s
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(self.hurtWeightCount==1)then
List.PushBack(self.willHurtQueue,e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e=0
if(t)then
List.PushBack(o,t)
t=0
self.WillHealthFuryValueDic[i]=0
end
else
if e<=0 then
List.PushBack(self.willHurtQueue,0)
if(t)then
List.PushBack(o,0)
end
else
local n=1
while(e>0)do
if(n<self.hurtWeightCount)then
if self.mBattleHurtType==EBattleHurtType.HurtArmor then
n=n+1
List.PushBack(self.willHurtQueue,0)
if(t)then
List.PushBack(o,0)
end
else
local i=tonumber(s[n])
n=n+1
local a=math.floor(a*i*0.01)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
List.PushBack(self.willHurtQueue,a)
e=e-a
if(t)then
local e=math.floor(t*i*0.01)
List.PushBack(o,e)
t=t-e
end
end
else
List.PushBack(self.willHurtQueue,e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e=0
if(t)then
List.PushBack(o,t)
t=0
self.WillHealthFuryValueDic[i]=0
end
end
end
end
end
else
List.PushBack(self.willHurtQueue,e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e=0
self.hurtWeightCount=1
if(t)then
List.PushBack(o,t)
self.WillHealthFuryValueDic[i]=0
end
end
if(not self.disableDefRage)then
if self:IsStakeFightOpenNewFury()==false then
self:AddFuryWithSoul(SoulAddFuryType.defRage)
end
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
function HeroCtrl:PlayHurt(t)
if(self.PrevHurtCategory~=t)then
self.PrevTotalHurtValue=0
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.willHurtQueue=self.WillHurtValueDic[t]
if(self.willHurtQueue==nil)then
return
end
local e=List.PopFront(self.willHurtQueue)
if(e==nil)then
return
end
local t=List.PopFront(self.WillHealthFuryDic[t])
if(t~=nil)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.HeroBattleInfo:AddFury(t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:RefreshFury()
end
self.PrevTotalHurtValue=self.PrevTotalHurtValue+e
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.skillPreview then
self:RealHurtInpreview(e,self.PrevTotalHurtValue,HeroHurtType.hurtPoint)
else
self:RealHurt(e,self.PrevTotalHurtValue,HeroHurtType.hurtPoint)
end
self:PlayHpHealthOnHurt()
end
function HeroCtrl:CalcSkillRealHurt()
local e=0
if(self.PrevHurtCategory~=e)then
self.PrevTotalHurtValue=0
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.willHurtQueue=self.WillHurtValueDic[e]
if(self.willHurtQueue==nil)then
return
end
local t=List.PopFront(self.willHurtQueue)
local e=0
while t~=nil do
e=e+t
t=List.PopFront(self.willHurtQueue)
end
if(e<=0)then
return
end
self.PrevTotalHurtValue=self.PrevTotalHurtValue+e
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local e=self:RealHurtInLogic(e,self.PrevTotalHurtValue,HeroHurtType.hurtPoint)
if self:GetArmor()<=0 then
self.needHurtValue=e.realHurtRet
end
return e
end
function HeroCtrl:RealHurtOnlyShow(e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.CurrHurtNum and self.HurtNumType~=nil)then
self.HurtNumType=EBattleHurtNumType.ChangeGui
self.CurrHurtNum.SetText(self.HurtNumType,tostring(e))
end
end
end
function HeroCtrl:RealHurt(o,t,a,e,i)
local t=self:RealHurtInLogic(o,t,a,e,i)
self:RealHurtShow(t,a,e)
return t
end
function HeroCtrl:RealHurtShow(e,a,i)
local t=e.originalHurtValue
local o=e.needReduceShield
local n=e.needReduceEnergy
local o=e.shield
local o=e.realHurtRet
if(self.beAttackType==AttackType.SmallSkill or self.beAttackType==AttackType.Normal)then
if(self.ImmuneNormalAndSmallSkill and a~=HeroHurtType.thorn and a~=HeroHurtType.healThorn)then
if(self.CurrHurtNum and self.HurtNumType~=nil)then
self.HurtNumType=EBattleHurtNumType.HurtTips
self.CurrHurtNum.SetText(self.HurtNumType,HurtTipsType.ImmuneNormalAndSmallSkill)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
local o=false
if i==true
or(i==nil and self.immuneDamageWithConsume)then
o=true
end
if(o==true)then
if(self.CurrHurtNum and self.HurtNumType~=nil)then
self.HurtNumType=EBattleHurtNumType.HurtTips
self.CurrHurtNum.SetText(self.HurtNumType,HurtTipsType.ImmuneNormalAndSmallSkill)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
elseif(self.resistFatalDamage==true)then
if(self.CurrHurtNum and self.HurtNumType~=nil)then
self.HurtNumType=EBattleHurtNumType.ResistFatalDamage
self.CurrHurtNum.SetText(self.HurtNumType,HurtTipsType.ResistFatalDamage)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
elseif(self.spelicalHurtNumType==EBattleHurtNumType.Evade)then
if e.hurtValue<=0 then
if(self.CurrHurtNum and self.HurtNumType~=nil)then
self.HurtNumType=EBattleHurtNumType.Evade
self.CurrHurtNum.SetText(self.HurtNumType,HurtTipsType.Evade)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
elseif(self.spelicalHurtNumType==EBattleHurtNumType.ResistFatalDamage)then
if e.hurtValue<=0 then
if(self.CurrHurtNum and self.HurtNumType~=nil)then
self.HurtNumType=EBattleHurtNumType.ResistFatalDamage
self.CurrHurtNum.SetText(self.HurtNumType,HurtTipsType.ResistFatalDamage)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
if(self.beAttackType==AttackType.SmallSkill or self.beAttackType==AttackType.Normal or self.beAttackType==AttackType.BigSkill)then
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self:IsSuperArmor())then
self:PlaySpineAnims({"bati","stand"},false,true,true,true)
self:SetHeroPoseType(HeroPoseType.stand)
elseif(self.CurrIsBlocking)then
self:PlaySpineAnims({"gedang","stand"},false,true,true,true)
self:SetHeroPoseType(HeroPoseType.stand)
local e=self:GetFootPointPos()
GameEntry.Effect:ShowEffectPro(SysEffectId.GeDang,EffectKeepType.AutoRelease,e.x,e.y,e.z,ModulesInit.ProcedureNormalBattle.mirrorScaleX*(self.IsOurHero and 1 or-1),1,1)
elseif(n>0)then
local e=self:GetFootPointPos()
GameEntry.Effect:ShowEffectPro(SysEffectId.energy,EffectKeepType.AutoRelease,e.x,e.y,e.z,ModulesInit.ProcedureNormalBattle.mirrorScaleX*(self.IsOurHero and 1 or-1),1,1)
end
end
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if ModulesInit.ProcedureNormalBattle.isTimeLine
or ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.None)then
self:PlayBuffEffectOnDamagePoint()
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.CurrHurtNum and self.HurtNumType~=nil)then
if(e.showHurtValue~=nil and e.showHurtValue>0)then
self.CurrHurtNum.SetText(self.HurtNumType,tostring(e.showHurtValue))
else
if(a==HeroHurtType.thorn)then
if(t>100)then
self.CurrHurtNum.SetText(self.HurtNumType,tostring(t))
if self.CurrThornShowBuffId>0 then
local e=self.HeroBattleInfo:GetBuff(self.CurrThornShowBuffId)
if e then
e:PlayBuffPrefabEffect(EBuffEffectType.custom)
end
end
end
else
if(t>0)then
self.CurrHurtNum.SetText(self.HurtNumType,tostring(t))
end
end
end
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:RefreshArmor()
self:RefreshHP()
end
function HeroCtrl:RealHurtInLogic(e,t,a,i,o)
if self.mBattleHurtType==EBattleHurtType.HurtHp then
return self:RealHurtInLogicWithHp(e,t,a,i,o)
elseif self.mBattleHurtType==EBattleHurtType.HurtArmor then
return self:RealHurtInLogicWithArmor(e,t,a)
end
end
function HeroCtrl:RealHurtInLogicWithArmor(e,i,o)
local a=0
local t=0
local n=e
local h=e
local s=self.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.shield)
if(e>0)then
self.HeroBattleInfo.curArmor=self.HeroBattleInfo.curArmor-e
end
if(self.HeroBattleInfo.curArmor<0)then
self.HeroBattleInfo.curArmor=0
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(o==HeroHurtType.hurtPoint)then
self.hurtWeightCount=self.hurtWeightCount-1
end
local e={
hurtValue=e,
showHurtValue=i,
originalHurtValue=h,
needReduceShield=a,
needReduceEnergy=t,
shield=s,
realHurtRet=n,
}
return e
end
function HeroCtrl:RealHurtInLogicWithHp(t,h,a,l,o)
local n=0
local s=0
local d=0
local r=0
if o then
r=o.releaseHeroId or 0
end
if(self.beAttackType==AttackType.SmallSkill or self.beAttackType==AttackType.Normal)then
if(self.ImmuneNormalAndSmallSkill and a~=HeroHurtType.thorn and a~=HeroHurtType.healThorn)then
t=0
h=nil
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
local i=false
if l==true
or(l==nil and self.immuneDamageWithConsume)then
i=true
end
if(i==true)then
t=0
h=nil
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(self.resistFatalDamage==true)then
t=0
h=nil
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
local l=t
local i=self.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.shield)
if(i>0 and self.ignoreShildByDamage~=true)then
local e=t
n=e<i and e or i
self.HeroBattleInfo:ReduceShield(n,r)
t=t-n
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
end
t=e:GetReduceDamageByResData(self,t,a,false,self.beAttackType)
t=e:GetReduceDamageByRes(self,t)
local r=self.HeroBattleInfo:GetLimitBuffAndTempBuffValue(HeroAttrId.reduceHpMaxRate,nil,true)
if r~=nil and r>0 then
local e=math.floor(self.HeroBattleInfo.MaxHP*r*MillionCoe)
t=math.min(e,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if a==HeroHurtType.buff then
t=e:GetReduceDamageByHpChain(self,t,a)
end
if o then
if o.minHpPercent and o.minHpPercent>0 then
local e=self:CurrHPPer()
if e<=o.minHpPercent*MillionCoe then
t=0
else
local e=self:GetHPByPercent(o.minHpPercent*MillionCoe)
local e=self.HeroBattleInfo.CurrHP-e
t=math.min(t,e)
end
end
end
if t>0 and self.energyConsumeCond>0 then
local a=self.HeroBattleInfo.MaxHP*self.energyConsumeCond
local e=0
local a=self.HeroBattleInfo.CurrHP-a
if a>0 then
if t>a then
e=t-a
else
end
else
e=t
end
if e>0 then
local a=self.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.energy)
if(a>0)then
s=e<a and e or a
self.HeroBattleInfo:ReduceEnergy(s)
t=t-s
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
end
end
end
if(t>0)then
if t>self.HeroBattleInfo.CurrHP then
t=self.HeroBattleInfo.CurrHP
end
self.HeroBattleInfo:ReducedHp(t,a)
if(a==HeroHurtType.thorn or a==HeroHurtType.healThorn or(a==HeroHurtType.hpChain and(o==nil or o.isShareDead~=true)))then
if(self.HeroBattleInfo.CurrHP<=0)then
self.HeroBattleInfo:SetHp(1,true)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
d=t
if(self.HeroBattleInfo.CurrHP<0)then
self.HeroBattleInfo:SetHp(0,true)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(a==HeroHurtType.hurtPoint)then
if(self.hurtWeightCount==1)then
if(self.currTotalHurt>0)then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.lastHurtPoint,self,self,self.currTotalHurt)
end
end
self.hurtWeightCount=self.hurtWeightCount-1
end
local e={
hurtValue=t,
showHurtValue=h,
originalHurtValue=l,
needReduceShield=n,
needReduceEnergy=s,
shield=i,
realHurtRet=d,
}
return e
end
function HeroCtrl:GetRealHurtWithHpInLogic(i,r,a,n)
local o=0
local s=0
local t=i
local d=t
if(r==AttackType.SmallSkill or r==AttackType.Normal)then
if(self.ImmuneNormalAndSmallSkill and a~=HeroHurtType.thorn and a~=HeroHurtType.healThorn)then
t=0
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
if(self.immuneDamageWithConsume)then
t=0
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
local h=i
local h=self.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.shield)
if(h>0 and self.ignoreShildByDamage~=true)then
local e=i
o=e<h and e or h
t=t-o
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
end
d=t
t=e:GetReduceDamageByResData(self,t,a,true,r)
t=e:GetReduceDamageByRes(self,t)
local h=self.HeroBattleInfo:GetLimitBuffAndTempBuffValue(HeroAttrId.reduceHpMaxRate,nil,true)
if h~=nil and h>0 then
local e=math.floor(self.HeroBattleInfo.MaxHP*h*MillionCoe)
t=math.min(e,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if a==HeroHurtType.hurtPoint then
local e=self:GetReduceHpMaxRateInSkillAct()
if e then
local a=e.buffId
local a=math.floor(self.HeroBattleInfo.MaxHP*e.hpMaxRate*MillionCoe)
if t>a then
e.count=e.count-1
if e.count<=0 then
self.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
end
t=math.min(a,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
if(t>0)then
if(a==HeroHurtType.thorn or a==HeroHurtType.healThorn or(a==HeroHurtType.hpChain and(n==nil or n.isShareDead~=true)))then
if(self.HeroBattleInfo.CurrHP<=t)then
t=self.HeroBattleInfo.CurrHP-1
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
t=math.max(0,t)
if a~=HeroHurtType.hpChain then
t=e:GetReduceDamageByHpChain(self,t,a)
end
if n then
if n.minHpPercent and n.minHpPercent>0 then
local e=self:CurrHPPer()
if e<=n.minHpPercent*MillionCoe then
t=0
else
local e=self:GetHPByPercent(n.minHpPercent*MillionCoe)
local e=self.HeroBattleInfo.CurrHP-e
t=math.min(t,e)
end
end
end
local a=t+o
e:CheckExcuteResistFatalDamage(self,t,a)
if(self.resistFatalDamage)then
t=0
o=0
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if t>0 and self.energyConsumeCond>0 then
local a=self.HeroBattleInfo.MaxHP*self.energyConsumeCond
local e=0
local a=self.HeroBattleInfo.CurrHP-a
if a>0 then
if t>a then
e=t-a
else
end
else
e=t
end
if e>0 then
local a=self.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.energy)
if(a>0)then
s=e<a and e or a
t=t-s
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
end
end
end
local a=t
local h=t
if t>self.HeroBattleInfo.CurrHP then
a=self.HeroBattleInfo.CurrHP
end
local n=self:GetHeroMustDie()
if n or self:IsHeroEmptyHp()then
i=self.HeroBattleInfo.MaxHP*9
t=i
end
t=e:GetConvertDamageByResData(self,t)
local e={
needReduceShield=o,
needReduceEnergy=s,
reduceHpValue=a,
reduceHpValueBeforeReduceLimit=d,
reduceHpValueBeforeCurrHPLimit=h,
hurtValue=t+o+s,
originHurtValue=i
}
return e
end
function HeroCtrl:ReduceHPSimple(e)
if self.HeroBattleInfo then
self.HeroBattleInfo:ReducedHp(e)
end
self:RefreshHP()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.CurrHurtNum)then
if(e>0)then
self.CurrHurtNum.SetText(EBattleHurtNumType.ChangeGui,tostring(e))
end
end
end
end
function HeroCtrl:ResumeAfterRemoveCtlBuff(t)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
return
end
if(self.CurrFsm==nil)then
return
end
if self:IsDeathOrWaitState()
or self.willNotUsualStateInTimeLine
or self.CurrIsBlocking
or e:IsCtlBuff(t)==false
then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return
end
if(self.HeroBattleInfo:HasStrongControlBuff())then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
local e=self:GetCanBigAttack()
local t=self:GetCanNormalAttack()
if self.CurrBattleTeam.TeamId==1 then
self:CheckBattleRoundBigAndSmallSkillStatus()
if ModulesInit.ProcedureNormalBattle.BattleRounding==true then
if e or t or ModulesInit.ProcedureNormalBattle.Explosiveing==true then
if self.HeroHeadItem then
self.HeroHeadItem:HideHeadMask()
end
ModulesInit.ProcedureNormalBattle:CheckSetReadyHeadIconTipScale()
end
end
end
if ModulesInit.ProcedureNormalBattle.BattleRounding and(e or t)then
self.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.ChangeToFightIdle
self:SetHeroPoseType(HeroPoseType.none)
self:ChangeState(HeroState.Idle)
else
self.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.NormalIdle
self:SetHeroPoseType(HeroPoseType.none)
self:ChangeState(HeroState.Idle)
end
end
function HeroCtrl:SetDisableDefRage(e)
self.disableDefRage=e
end
function HeroCtrl:CheckAttackNeedHealthFury()
if(self.AttackNeedHealthFury>0)then
self.HeroBattleInfo:AddFury(self.AttackNeedHealthFury)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.AttackNeedHealthFury=0
self:RefreshFury()
end
end
function HeroCtrl:ClearHurtQueue()
self.hurtBeforeHP=0
self.needHurtValue=0
self.AttackNeedHealthFury=0
self.hurtBeforeArmor=0
self.needHurtArmorValue=0
self.hurtBeforeSepsisHP=0
self.hurtBeforeCurrMaxHP=0
self.hurtBeforeCurrSepsisHp=0
self.needChangeSepsisHP=0
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function HeroCtrl:CheckHurtValue()
local e=self:CalcSkillRealHurt()
self.ignoreShildByDamage=false
self:CheckAttackNeedHealthFury()
self:PlayAddFuryWithSkill()
self:PlayThornInLogic()
self:PlayBloodInLogic()
if(self.WillEndImmuneNormalAndSmallSkill)then
self.ImmuneNormalAndSmallSkill=false
self.WillEndImmuneNormalAndSmallSkill=false
end
if self.immuneDamageWithConsume then
self:SetImmuneDamageWithConsume(false)
end
if self.resistFatalDamage then
self:SetResistFatalDamage(false)
end
self.spelicalHurtNumType=nil
f.CheckRemoveBuff(self)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if self.HeroBattleInfo then
self.HeroBattleInfo:PlayBattleAllBuffEffect()
end
end
if self.isTriggerSkillEndBuffForEver==true or self.isTriggerSkillEndBuff==true then
self.isTriggerSkillEndBuff=false
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.skillEndBuff)
end
self:HandleUndead()
if self.hurtBeforeHP==0 then
return
end
if self.mustBeDie==true or self:IsHeroEmptyHp()then
self.mustBeDie=false
self:SetHeroEmptyHp(false)
if self.WillNotUsual==false and self:IsUsualState()then
self.HeroBattleInfo.CurrHP=0
end
end
if self.needChangeSepsisHP~=0 then
self.HeroBattleInfo:SetSepsisHP(self.hurtBeforeSepsisHP+self.needChangeSepsisHP)
end
if self.HeroBattleInfo.CurrHP>0 then
self.HeroBattleInfo:SetHp(self.hurtBeforeHP-self.needHurtValue)
end
EventSystem.SendEvent(CommonEventId.OnAnyHeroAfterSufferDmg,{actionType="skill",heroId=self.HeroId,hurtValue=self.needHurtValue})
if(self.HeroBattleInfo.CurrHP<=0)then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.skillComplete)
if(self.HeroBattleInfo.CurrHP<=0)then
if(self:IsDeathOrWaitState()==false and self:IsSuperUnUsualState()==false)then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.fatalDmgBefore)
self:CheckExcuteWillHeroSpecialState(BuffTriggerTime.fatalDmgBefore)
EventSystem.SendEvent(CommonEventId.OnBattleHeroFatalDmgBefore,self.HeroId)
end
self:HandleUndead()
if self.HeroBattleInfo.CurrHP<=0 then
self:ResetHurtBeforeData()
return
end
end
else
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.skillComplete)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then









end
if(self.HeroBattleInfo.CurrHP<0)then
self.HeroBattleInfo:SetHp(0,true)
end
self.HeroBattleInfo.curArmor=self.hurtBeforeArmor-self.needHurtArmorValue
if(self.HeroBattleInfo.curArmor<0)then
self.HeroBattleInfo.curArmor=0
end
self:RefreshArmor()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.lastHurtPoint,self,self,self.currTotalHurt)
self:RefreshHP()
if(self.WillHealthFuryValueWithSkipBattle>0)then
self.HeroBattleInfo:AddFury(self.WillHealthFuryValueWithSkipBattle)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.WillHealthFuryValueWithSkipBattle=0
end
if self.HeroBattleInfo.CurrHP>0 then
if self.needHurtValue>0 then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.hpDown)
self.HeroBattleInfo:CheckBuff(BuffCheckTime.BeAtkEnd)
end
if self.needHurtArmorValue>0 then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.armorDown)
end
self:HandleLeave()
end
if self.HeroBattleInfo then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.afterSufferDmg,self,self,{actionType="skill",hurtValue=self.needHurtValue,hurtData=e})
end
self:PlayReduceFuryWithSkill()
self:RefreshFury()
if(self.CurrHeadBarView)then
self.CurrHeadBarView:ChangeAlpha(1)
end
self:ResetHurtBeforeData()
end
function HeroCtrl:ResetHurtBeforeData()
self.hurtBeforeHP=0
self.hurtBeforeArmor=0
self.hurtBeforeSepsisHP=0
self.hurtBeforeCurrMaxHP=0
self.hurtBeforeCurrSepsisHp=0
self.needChangeSepsisHP=0
end
function HeroCtrl:HandleUndead()
if(self.WillNotUsual==true and self.NotUsualType==HeroState.UnDead)then
self.WillNotUsual=false
self.willNotUsualStateInTimeLine=false
self:ChangeState(HeroState.UnDead)
ModulesInit.ProcedureNormalBattle.SelectFireHero=nil
ModulesInit.ProcedureNormalBattle.HideFireEffect()
ModulesInit.ProcedureNormalBattle.AutoSelectFireHero()
end
end
function HeroCtrl:HandleLeave()
if(self.WillNotUsual==true and self.NotUsualType==HeroState.Leave)then
self.WillNotUsual=false
self.willNotUsualStateInTimeLine=false
self:ChangeState(HeroState.Leave)
if ModulesInit.ProcedureNormalBattle.SelectFireHero~=nil then
if self.HeroId==ModulesInit.ProcedureNormalBattle.SelectFireHero.HeroId then
ModulesInit.ProcedureNormalBattle.SelectFireHero=nil
ModulesInit.ProcedureNormalBattle.HideFireEffect()
ModulesInit.ProcedureNormalBattle.AutoSelectFireHero()
end
end
self:SetHeroLeave()
end
end
function HeroCtrl:ShowHeroRoot(e)
if not IsNil(self.transform)then
LuaUtils.SetActive(self.transform,e)
end
end
function HeroCtrl:SetHeroLeave()
if self.transform then
LuaUtils.SetLocalPos(self.transform,0,0,-15)
end
self:HideHero()
end
function HeroCtrl:HideHero()
self:SetHeroShowCtrl(true)
self:ShowHero(false)
self:SetHeroShowCtrl(false)
end
function HeroCtrl:RealHurtWithTestEditor()
local e=math.random(1,7)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(e==1)then
self.CurrHurtNum.SetText(EBattleHurtNumType.BaoJi,999999)
elseif(e==2)then
self.CurrHurtNum.SetText(EBattleHurtNumType.KeZhi_BaoJi,999999)
elseif(e==3)then
self.CurrHurtNum.SetText(EBattleHurtNumType.BeiKeZhi_BaoJi,999999)
elseif(e==4)then
self.CurrHurtNum.SetText(EBattleHurtNumType.GeDang,999999)
elseif(e==5)then
self.CurrHurtNum.SetText(EBattleHurtNumType.KeZhi_GeDang,999999)
elseif(e==6)then
self.CurrHurtNum.SetText(EBattleHurtNumType.BeiKeZhi_GeDang,999999)
elseif(e==7)then
self.CurrHurtNum.SetText(EBattleHurtNumType.ChangeGui,999999)
end
end
function HeroCtrl:ConvertbuffPositionToLua(e)
if CS.MyCommonEnum.ETestBuffPosType.Head==e then
return 1
elseif CS.MyCommonEnum.ETestBuffPosType.Chest==e then
return 3
elseif CS.MyCommonEnum.ETestBuffPosType.Foot==e then
return 6
end
return 3
end
function HeroCtrl:AddBuffEffectInEditor(e,t,o,a)
if not IsNil(e)then
self:DestroyTestBuffEffectTrans()
local e=LuaUtils.Instantiate(e.transform)
self.testBuffEffectTrans=e
local t=self:ConvertbuffPositionToLua(t)
local t=self:GetPointPosWithType(t)+Vector3(0,0,-0.5)
LuaUtils.SetPos(e,t.x,t.y,t.z)
e:SetParent(self.spineboyTransform)
if(o==1)then
local t=false
if ModulesInit.ProcedureNormalBattle:GetMirrorScaleX()==-1 then
if(self.IsOurHero)then
t=true
end
else
if(not self.IsOurHero)then
t=true
end
end
if t==true then
local t=e.localScale
t.x=t.x*-1
e.localScale=t
end
end
if a then
a()
end
end
end
function HeroCtrl:DestroyTestBuffEffectTrans()
if self.testBuffEffectTrans then
GameObject.Destroy(self.testBuffEffectTrans.gameObject)
self.testBuffEffectTrans=nil
end
end
function HeroCtrl:GetCanBigAttack(e,a,t)
if ModulesInit.ProcedureNormalBattle.ForbidAttack(self:GetTeamId())then
return false
end
if e~=true then
if(not ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.BigSkillAttacking))then
return false
end
if(self.CurrRoundIsBigSkillAttack)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
else
if ModulesInit.ProcedureNormalBattle.IsHeroSkillAttackState()==false then
return false
end
end
if(self.HeroBattleInfo==nil)then
return false
end
if(self.HeroBattleInfo.CurrHP<=0)then
return false
end
if(self:IsNothingToDoState())then
return false
end
if(self.BigSkillId==0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
if t~=true then
if(self.FreezeBigSkill)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
if(self.HeroBattleInfo:HasStrongControlBuff())then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
end
if(self:IsNotUsualState())then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
local e=i.GetEntity(self.BigSkillId)
if(e==nil)then
return false
end
if a~=false then
local e=self:GetEffectiveFuryCost(e.costMp)
if(self.HeroBattleInfo.CurrFury<e)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
end
if(self.CurrBattleTeam.OpponentTeam:IsAllFreeze())then
return false
end
return true
end
function HeroCtrl:GetBigAttackWaiting()
if self.CurrBattleTeam==nil then
return false
end
return self.CurrBattleTeam:GetBigAttackWaiting()
end
function HeroCtrl:GetCanNormalAttack(e,a,t)
if ModulesInit.ProcedureNormalBattle.ForbidAttack(self:GetTeamId())then
return false
end
if e==nil then
e=true
end
if a~=true then
if(self.CurrRoundIsNormalSkillAttack)then
return false
end
end
if ModulesInit.ProcedureNormalBattle.IsHeroSkillAttackState()==false then
return false
end
if(self.HeroBattleInfo==nil)then
return
end
if(self.HeroBattleInfo.CurrHP<=0)then
return false
end
if(self:IsNothingToDoState())then
return false
end
if t~=true then
if(self.HeroBattleInfo:HasStrongControlBuff())then
return false
end
end
if(self:IsNotUsualState())then
return false
end
if(self.CurrBattleTeam.OpponentTeam:IsAllFreeze())then
return false
end
if e and self:CheckInAttackCommandQueue()then
return false
end
return true
end
function HeroCtrl:GetCanPetFightAttack(o,a,t)
if(self.HeroBattleInfo==nil)then
return false
end
if t~=true then
if(self.CurrRoundIsPetFightSkillAttack)then
return false
end
end
local e=e:GetSkillActData(o)
if e==nil then
return false
end
if e.skilltype==EBattleSkillSpecialityType.AttackEnemy then
if(self.CurrBattleTeam.OpponentTeam:IsAllFreeze())then
return false
end
end
if(self:IsNothingToDoState())then
return false
end
local t=ModulesInit.BattleSkillMgr.GetSkillScript(e.scriptId)
if(t and e)then
if a then
if t.GetCanTriggerSkill and t.GetCanTriggerSkill(a)==false then
return false
end
end
end
return true
end
function HeroCtrl:CheckInAttackCommandQueue()
local e=self.CurrBattleTeam.SmallSkillAttackQueue
local a=e.first
local t=e.last
for t=a,t do
local e=e[t]
if e and e.HeroId==self.HeroId then
return true
end
end
return false
end
function HeroCtrl:GetShowTreasures(a)
local e=self.HeroBattleInfo.treasures
local t={}
for o=1,#e do
local e=e[o]
if(a==nil or a==e.treasureDid)and self:IsShowTreasure(e.treasureDid)then
table.insert(t,e)
end
end
return t
end
function HeroCtrl:IsShowTreasure(t)
local a=e:GetTreasureCfgData(t)
if a then
local e=e:GetTreasureSkillCfgData(a.skill)
if e.type==EtreasureSkillType.teamAll then
if self.CurrBattleTeam:CheckTeamTreasure(self.HeroId,t)then
return true
end
else
return true
end
end
return false
end
function HeroCtrl:ShowTreasureById(e)
if ModulesInit.ProcedureNormalBattle.IsSkipBattle==false then
local e=self:GetShowTreasures(e)
self:ShowTreatureText(e)
end
end
function HeroCtrl:AddTreasure()
local o=false
if self.addTreasurefDone then
return o
end
self.addTreasurefDone=true
local t={}
local a=self.CurrBattleTeam:GetTeamTreasures()
for e=1,#a do
table.insert(t,a[e].treasure)
end
local a=self.HeroBattleInfo.treasures
for i=1,#a do
local o=a[i]
local o=e:GetTreasureCfgData(o.treasureDid)
if o then
local e=e:GetTreasureSkillCfgData(o.skill)
if e.type~=EtreasureSkillType.teamAll then
table.insert(t,a[i])
end
end
end
for a=1,#t do
local a=t[a]
local t=e:GetTreasureCfgData(a.treasureDid)
if t then
local t=e:GetTreasureSkillCfgData(t.skill)
if(t.profession==0 or t.profession==self.profession)
and(t.camp==0 or t.camp==self.camp)then
local i=e:GetTreasureStrengCfgData(a.treasureDid,a.level,a.breakLevel)
local o=t.buffId
local t=string.split(t.para,":")
local e={}
for a=1,#t do
if t[a]=="x"then
table.insert(e,i.skillPara)
else
table.insert(e,tonumber(t[a]))
end
end
table.insert(e,a.treasureDid)
self:AddBuff(self,o,-1,e)
end
end
end
if ModulesInit.ProcedureNormalBattle.IsSkipBattle==false then
local e=self:GetShowTreasures()
self:ShowTreasure(e)
o=#e>0
end
return o
end
function HeroCtrl:ShowTreasure(a)
local t=self.IsOurHero==true==-1 or 1
local e=ModulesInit.TimeActionMgr.CreateTimeAction()
self:AddTimer(e)
e:Init(
0,
0.5+self.battleStationIndex*t*0.01,
1,
nil,
nil,
function()
self:RemoveTimer(e)
self:ShowTreatureText(a)
end
):Run()
end
function HeroCtrl:BattleRoundBeginAddFrontBuff()
if(self.HeroBattleInfo.CurrHP<=0)then
return
end
if ModulesInit.ProcedureNormalBattle.ForbidAttack(self:GetTeamId())then
return false
end
if self.addFrontBuffDone then
return
end
self.addFrontBuffDone=true
if(self.enterBuffs and#self.enterBuffs>0)then
for t,e in ipairs(self.enterBuffs)do
local t=1
if type(e.overlap)=="number"then
t=math.max(t,e.overlap)
end
self.HeroBattleInfo:AddBuff(self,e.buffId,e.round,e.args,t)
end
end
if(self.HeroServerData and self.HeroServerData.enterBuffs)then
for t,e in ipairs(self.HeroServerData.enterBuffs)do
local t=1
if type(e.overlap)=="number"then
t=math.max(t,e.overlap)
end
self.HeroBattleInfo:AddBuff(self,e.buffId,e.round,e.args,t)
end
end
local e=self.HeroBattleInfo:GetSkillWithType(SkillType.Pas)
local t=#e
local o=0
local a={}
for t=1,t do
local t=e[t].SkillDid
if(t>0)then
local e=m.GetEntity(t)
if(e)then
if e.exBigSkillId>0 then
self.ExBigSkillId=e.exBigSkillId
end
if(e.isCombat==1 and e.trigger==SkillPasTrigger.Begin)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
a[#a+1]=e.id
elseif(e.isCombat==2)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local e=self:JudgeSkillPassPreView(e)
local t=#e
if(t==3)then
self:AddBuff(self,e[1],e[2],{e[3]})
elseif(t==6)then
self:AddBuff(self,e[1],e[2],{e[3]})
self:AddBuff(self,e[4],e[5],{e[6]})
elseif(t==9)then
self:AddBuff(self,e[1],e[2],{e[3]})
self:AddBuff(self,e[4],e[5],{e[6]})
self:AddBuff(self,e[7],e[8],{e[9]})
end
end
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
o=#a
local e=0
if(o~=0)then
for e=1,o do
local t=a[e]
local a=m.GetEntity(t)
local e=ModulesInit.BattleSkillMgr.GetSkillScript(t)
if(e and a)then
e.DoAction(self,a)
if e.DoAfterAction then
local a=1
if e.GetAfterActionType then
a=e.GetAfterActionType()
end
local e={
skillId=t,
skillActionType=a,
success=false,
}
table.insert(self.SkillAfterActions,e)
end
else
GameInit.LogError("被动技能还未实现 请联系策划检查 skillId"..t)
FightDataReportMgr:SetErrorCode(ServerErrorCode.SkillIdNoExists,string.format("技能Id不存在 heroDid %s HeroId %s doSkillPasResult %s",self.heroDid,self.HeroId,self.skillId))
end
end
end
self:BattleRoundBeginAddFrontUnderwearBuff()
self:InitHeroPow()
self:RefreshHeroPow()
end
function HeroCtrl:BattleRoundBeginAddFrontUnderwearBuff()
local t={}
for e,o in ipairs(self.HeroBattleInfo.underWearSuits)do
local e=a:GetUnderwearSuitCfg(o.suitDid)
if(e)then
if(e.passBuff>0)then
local a=e["passArgs"..tostring(o.star)]
self:AddBuff(self,e.passBuff,-1,table.deepCopy(a))
table.insert(t,e)
end
end
end
table.sort(t,function(e,t)
if e.suitNum~=t.suitNum then
return e.suitNum<t.suitNum
end
return e.id<t.id
end)
local e=#t
if(e~=0)then
for e=1,e do
local e=t[e]
local t=ModulesInit.BattleBuffMgr.GetBuffScript(e.passBuff)
if(t)then
local e=self.HeroBattleInfo:GetBuff(e.passBuff)
if e then
if e:GetCanTrigger(BuffTriggerTime.after)then
e:DoAction(BuffTriggerTime.after)
end
end
end
end
end
end
function HeroCtrl:InitHeroPow()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=self:IsEnablePowerBeans()
if self.CurrHeadBarView then
self.CurrHeadBarView:ShowBeans(e)
end
if(self.OnShowBeans~=nil)then
self.OnShowBeans(e)
end
end
end
function HeroCtrl:RefreshHeroPow()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false and self:IsEnablePowerBeans())then
if self.CurrHeadBarView then
self.CurrHeadBarView:SetBeansFury(self.HeroBattleInfo.BeansStatFury,const_need_stat_fury_one_beans)
end
if(self.OnBeansStatFuryChange~=nil)then
self.OnBeansStatFuryChange(self.HeroBattleInfo.BeansStatFury,const_need_stat_fury_one_beans)
end
end
end
function HeroCtrl:BattleRoundBeginAddPetFrontBuff()
if self.addFrontBuffDone then
return
end
self.addFrontBuffDone=true
if(self.HeroServerData and self.HeroServerData.enterBuffs)then
for t,e in ipairs(self.HeroServerData.enterBuffs)do
local t=1
if type(e.overlap)=="number"then
t=math.max(t,e.overlap)
end
self.HeroBattleInfo:AddBuff(self,e.buffId,e.round,e.args,t)
end
end
local e=self.HeroBattleInfo:GetAllSkills()
local t=#e
local a=0
local a={}
for t=1,t do
local t=e[t].SkillDid
if(t>0)then
local e=i.GetEntity(t)
if(e)then
local t=ModulesInit.BattleSkillMgr.GetSkillScript(e.scriptId)
if(t.DoPassiveAction)then
t.DoPassiveAction(self,e)
end
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
end
function HeroCtrl:BattleRoundBeginAddAfterBuff()
if(self.HeroBattleInfo.CurrHP<=0 or ModulesInit.ProcedureNormalBattle.ForbidAttack(self:GetTeamId()))then
self.IsBattleRoundBeginAddBuffing=false
if(self.OnBattleRoundBeginAddBuffComplete~=nil)then
self.OnBattleRoundBeginAddBuffComplete()
end
return
end
local e=0
local t=#self.SkillAfterActions
if(t==0)then
self.IsBattleRoundBeginAddBuffing=false
if(self.OnBattleRoundBeginAddBuffComplete~=nil)then
self.OnBattleRoundBeginAddBuffComplete()
end
else
for t=1,t do
local a=self.SkillAfterActions[t]
if a.success==false then
local o=a.skillId
local i=m.GetEntity(o)
local t=ModulesInit.BattleSkillMgr.GetSkillScript(o)
if(t and i)then
if t.DoAfterAction then
local t=t.DoAfterAction(self,i)
if(t)then
a.success=t.success
if(t.duration>e)then
e=t.duration
end
end
end
else
GameInit.LogError("被动技能还未实现 请联系策划检查 skillId"..o)
FightDataReportMgr:SetErrorCode(ServerErrorCode.SkillIdNoExists,string.format("技能Id不存在 heroDid %s HeroId %s doSkillPasResult %s",self.heroDid,self.HeroId,self.skillId))
end
end
end
if(e==0)then
self.IsBattleRoundBeginAddBuffing=false
if(self.OnBattleRoundBeginAddBuffComplete~=nil)then
self.OnBattleRoundBeginAddBuffComplete()
end
else
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.CurrHeadBarView and self.CurrHeadBarView:Lock(10))then
self.CurrHeadBarView:ChangeAlphaTween(0)
end
local t=ModulesInit.TimeActionMgr.CreateTimeAction()
self:AddTimer(t)
t:Init(
0,
1,
e/1000,
nil,
nil,
function()
self:RemoveTimer(t)
self.IsBattleRoundBeginAddBuffing=false
if(self.CurrHeadBarView and self.CurrHeadBarView:Lock(10))then
self.CurrHeadBarView:ChangeAlphaTween(1)
end
if(self.OnBattleRoundBeginAddBuffComplete~=nil)then
self.OnBattleRoundBeginAddBuffComplete()
end
end
):Run()
else
self.IsBattleRoundBeginAddBuffing=false
if(self.OnBattleRoundBeginAddBuffComplete~=nil)then
self.OnBattleRoundBeginAddBuffComplete()
end
end
end
end
end
function HeroCtrl:RealHurtWithBuff(o,i,n,r,h,l,t)
if self:GetArmor()>0 then
return
end
if self:IsPet()then
return
end
r=r or 1
if(self.HeroBattleInfo.CurrHP<=0)then
return
end
o=math.floor(o)
local d=nil
local s=HeroHurtType.buff
if h==EBattleHurtNumType.HealThorn then
s=HeroHurtType.healThorn
d=o
end
t=t or{}
t.releaseHeroId=i.releaseHeroId
if t then
if t.hurtType then
s=t.hurtType
end
end
if s==HeroHurtType.buff then
local e=a.GetBattleAttrCoe(HeroAttrId.realInjureResRateAdd,a.BattleAttrClamp(HeroAttrId.realInjureResRateAdd,self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.realInjureResRateAdd)))
o=math.max(0,o*(1-e))
end
local n=n==nil and false or n
if(not n)then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.sufferDmg,self,self,o)
end
if(self.hurtLimit>0)then
if(o>self.hurtLimit)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
o=self.hurtLimit
self.hurtLimit=0
end
end
if(not n)then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.realHurtWithBuff,self,self,o)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
i.hurtValue=o
i.hurtType=s
if(GameInit.IsClient)then
if h==EBattleHurtNumType.HealThorn then
self.HurtNumType=EBattleHurtNumType.HealThorn
else
self.HurtNumType=EBattleHurtNumType.ChangeGui
end
end
local h=false
if t==nil or t.ignoreImmuneDamage==false then
h=self:CheckConsumeImmuneDamageCount()
end
local n
if t then
t.realHurt=o
end
if l==true then
n=self:RealHurtInLogic(o,d,s,h,t)
else
n=self:RealHurt(o,d,s,h,t)
end
local d=n.hurtValue+n.needReduceShield+n.needReduceEnergy
ModulesInit.ProcedureNormalBattle.RecordBuffDamage(i.releaseHeroId,i.buffId,d)
self:SetLastAttackHeroId(i.releaseHeroId)
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.buffDamageComplete,self,self,{hurtValue=o,hurtType=s})
self:HandleUndead()
i.hurtValue=n.hurtValue
if s==HeroHurtType.healThorn or(s==HeroHurtType.hpChain and(t==nil or t.isShareDead~=true))or(t and t.notDead)then
if self.HeroBattleInfo.CurrHP<=0 then
self.HeroBattleInfo:SetHp(1,true)
end
end
e:AddSepsisHpByHurt(nil,self,n.hurtValue,true,true)
if(self.HeroBattleInfo.CurrHP<=0)then
local e=nil
if t and t.canDieInBattleRounding then
e=t.canDieInBattleRounding
end
if(self:IsDeathOrWaitState()==false and self:IsSuperUnUsualState()==false)then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.fatalDmgBefore)
self:CheckExcuteWillHeroSpecialState(BuffTriggerTime.fatalDmgBefore)
EventSystem.SendEvent(CommonEventId.OnBattleHeroFatalDmgBefore,self.HeroId)
end
if self.HeroBattleInfo==nil then
return
end
self:HandleUndead()
end
if self.HeroBattleInfo.CurrHP<=0 then
if self:IsNotUsualState()and self.NotUsualType~=HeroState.Leave then
self.HeroBattleInfo.CurrHP=1
end
end
if(self.HeroBattleInfo.CurrHP<=0)then
if ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.None)then
if ModulesInit.ProcedureNormalBattle.IsSkipBattle==false then
self.CurrBattleTeam:DoHeroDieInTimeLine(self)
self.willNotUsualStateInTimeLine=false
end
end
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.fatalDmg)
self:CheckExcuteWillHeroSpecialState(BuffTriggerTime.fatalDmg)
if self.HeroBattleInfo.CurrHP<=0 then
if(self.WillNotUsual==true and self:IsLeaveType()==false and self:IsNothingToDoState()==false)then
self.WillNotUsual=false
if(self.NotUsualType==HeroState.Freeze)then
self:ChangeState(HeroState.Freeze)
elseif(self.NotUsualType==HeroState.DyingState)then
self:ChangeState(HeroState.DyingState)
end
else
if self:IsImmortalState()==true then
if self.HeroBattleInfo.CurrHP<=0 then
self.HeroBattleInfo:SetHp(1)
end
self:PlayStandAnimInTimeLine()
else
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.HeroDeadBefore)
self:HandleUndead()
self:CheckExcuteWillHeroSpecialState(BuffTriggerTime.HeroDeadBefore)
if self.HeroBattleInfo.CurrHP<=0 then
ModulesInit.ProcedureNormalBattle.KillHeroWithBuff(i.releaseHeroId)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:ChangeDeathWaitState()
end
end
end
end
else
local e=a:GetBuffCfg(i.buffId)
if(e and e.buffIfFury==1 and r==1)then
if self:IsStakeFightOpenNewFury()==false then
local e=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.furyRate)
local t=self:GetSoulValue(SoulAddFuryType.defRage)
local e=(Constant.battle_fury_defense+t+(o/self.HeroBattleInfo.MaxHP)*self.HeroBattleInfo.Fury)*(1+e*MillionCoe)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.HeroBattleInfo:AddFury(math.floor(e))
self:RefreshFury()
end
end
end
if self.HeroBattleInfo then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.afterSufferDmg,self,self,{actionType="buff",hurtValue=n.hurtValue,hurtData=n})
end
EventSystem.SendEvent(CommonEventId.OnAnyHeroAfterSufferDmg,{actionType="buff",heroId=self.HeroId,hurtValue=n.hurtValue})
return n,s,h
end
function HeroCtrl:SetHpAndRefreshUI(e)
e=math.max(0,e)
self.HeroBattleInfo:SetHp(e,true)
self:RefreshHP()
end
function HeroCtrl:ImmediatelyDeath()
self.HeroBattleInfo:SetHp(0,true)
self:RefreshHP()
end
function HeroCtrl:ReduceMaxFury()
self:ReduceFury(self.HeroBattleInfo.Fury)
end
function HeroCtrl:ReduceFury(e)
local t=self:GetEffectiveFuryCost(e)
local t=self.HeroBattleInfo:ReduceFury(t)
self:ConsumeFuryCostReduceEntry()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
self:RefreshFury()
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.DoReduceFuryWithFireSkill,nil,nil,{reduceFuryValue=t})
end
function HeroCtrl:FuryHealth(i,n,o,a)
a=a or{}
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.recoverFury)
local t=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.furyRate)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(i==FuryHealthType.Attack)then
if self:GetDisableAttackFuryhealthInCurAttack()then
return
end
if self:IsStakeFightOpenNewFury()==false then
self.AttackNeedHealthFury=Constant.battle_fury_attack*(1+t*MillionCoe)
else
local e=a.beAttackHeroCtrl
if e and o and o>0 then
local i=ModulesInit.ProcedureNormalBattle.GetStakeFightParam(EFakeBattleParamType.test_scale)
local a=ModulesInit.ProcedureNormalBattle.GetStakeFightParam(EFakeBattleParamType.test_fury_kill)
local o=math.min(o,e.HeroBattleInfo.CurrHP)
local o=math.floor(i*o/e.HeroBattleInfo.MaxHP)
local e=ModulesInit.ProcedureNormalBattle.GetSoulFuryValueInFakeFight(self.soulId,SoulAddFuryType.killRage)
local e=a+e
self.AttackNeedHealthFury=o*e*(1+t*MillionCoe)
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
elseif(i==FuryHealthType.BeAttack)then
if self:GetDisableDefFuryhealthInCurAttack()then
return
end
if self.disableDefRage==false then
local e=0
if self:IsStakeFightOpenNewFury()==false then
e=(Constant.battle_fury_defense+(o/self.HeroBattleInfo.MaxHP)*self.HeroBattleInfo.Fury)*(1+t*MillionCoe)
e=math.floor(math.min(self.HeroBattleInfo.Fury,e))
if a.reduceDefRage then
e=math.max(0,e-a.reduceDefRage)
end
end
self.WillHealthFuryValueWithSkipBattle=e
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
if(GameInit.IsClient==false or ModulesInit.ProcedureNormalBattle.IsSkipBattle)then
else
self.WillHealthFuryValueDic[n]=e
end
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
else
if self:GetDisableAttackFuryhealthInCurAttack()then
return
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
if self:IsStakeFightOpenNewFury()==false then
self.HeroBattleInfo:AddFury(Constant.battle_fury_kill*(1+t*MillionCoe))
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
self.HeroBattleInfo:AddBattleEffectNormal(BattleEffectType.AddFury,ModulesInit.ProcedureNormalBattle.CurrBattleBigRound)
end
end
self:RefreshFury()
end
function HeroCtrl:AddMaxFuryWithSkill()
self:AddFuryWithSkill(self.HeroBattleInfo.Fury)
end
function HeroCtrl:AddFuryWithSkill(e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
self.WillAddFuryWithSkill=self.WillAddFuryWithSkill+e
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
self.HeroBattleInfo:AddBattleEffectNormal(BattleEffectType.AddFury,ModulesInit.ProcedureNormalBattle.CurrBattleBigRound)
end
self:PlayAddFuryWithSkill()
end
function HeroCtrl:AddFuryWithSkillAndEffect(e)
self:AddFuryWithSkill(e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if self.HeroBattleInfo then
self.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
end
end
end
function HeroCtrl:PlayAddFuryWithSkill()
if(self.WillAddFuryWithSkill>0)then
self.HeroBattleInfo:AddFury(self.WillAddFuryWithSkill)
self.WillAddFuryWithSkill=0
self:RefreshFury()
end
end
function HeroCtrl:ReduceFuryWithSkill(e,i,o,a,t)
local t=t and t.ignoreImmune or false
if t~=true then
if(self.ImmuneReduceFury)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return 0
end
if(#self.immuneActiveAtkReduceFuryWithCountArr>0)then
self:reduceActiveAtkReduceFuryWithCount()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
self.WillReduceFuryWithSkill=self.WillReduceFuryWithSkill+e
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
self.HeroBattleInfo:AddBattleEffectNormal(BattleEffectType.ReduceFury,ModulesInit.ProcedureNormalBattle.CurrBattleBigRound)
end
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.ReduceFury,i,self,{furyValue=e,operSrcType=o,isDirect=a})
return e
end
function HeroCtrl:ReduceFuryWithSkillImmediately(e,t,o,a)
self:ReduceFuryWithSkill(e,t,o,a)
self:PlayReduceFuryEffect()
self:PlayReduceFuryWithSkill()
end
function HeroCtrl:PlayReduceFuryWithSkill()
if(self.WillReduceFuryWithSkill>0)then
local e=self.HeroBattleInfo:ReduceFury(self.WillReduceFuryWithSkill)
self.WillReduceFuryWithSkill=0
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:RefreshFury()
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.DoReduceFury,nil,nil,{reduceFuryValue=e})
end
end
function HeroCtrl:AddImmuneReduceFury(e)
self.HeroBattleInfo:AddBuffValue(e,HeroAttrId.ImmuneReduceFury,10000)
self:RefreshImmuneReduceFury()
end
function HeroCtrl:RemoveImmuneReduceFury(e)
self.HeroBattleInfo:RemoveBuffValue(e,HeroAttrId.ImmuneReduceFury)
self:RefreshImmuneReduceFury()
end
function HeroCtrl:RefreshImmuneReduceFury()
local e=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.ImmuneReduceFury)
if e>0 then
self.ImmuneReduceFury=true
else
self.ImmuneReduceFury=false
end
end
function HeroCtrl:ResetImmuneActiveAtkReduceFuryWithCount(t,e)
self:RemoveImmuneActiveAtkReduceFuryWithCount(t)
if e>0 then
local e={
buffId=t,
count=e,
leftCount=e
}
table.insert(self.immuneActiveAtkReduceFuryWithCountArr,e)
end
end
function HeroCtrl:RemoveImmuneActiveAtkReduceFuryWithCount(t)
for e=1,#self.immuneActiveAtkReduceFuryWithCountArr do
if self.immuneActiveAtkReduceFuryWithCountArr[e].buffId==t then
table.remove(self.immuneActiveAtkReduceFuryWithCountArr,e)
break
end
end
end
function HeroCtrl:reduceActiveAtkReduceFuryWithCount()
local e=self.immuneActiveAtkReduceFuryWithCountArr[1]
if e then
e.leftCount=e.leftCount-1
if e.leftCount<=0 then
table.remove(self.immuneActiveAtkReduceFuryWithCountArr,1)
end
end
end
function HeroCtrl:AddImmuneDebuff(e)
self.HeroBattleInfo:AddBuffValue(e,HeroAttrId.ImmuneDebuff,10000)
self:RefreshImmuneDebuff()
end
function HeroCtrl:RefreshImmuneDebuff()
local e=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.ImmuneDebuff)
if e>0 then
self.ImmuneDeBuff=true
else
self.ImmuneDeBuff=false
end
end
function HeroCtrl:AddImmuneDebuffWithBuffList(e)
table.insert(self.ImmuneDeBuffWithBuffList,e)
end
function HeroCtrl:RemoveImmuneDebuffWithBuffList(t)
for e=1,#self.ImmuneDeBuffWithBuffList do
if self.ImmuneDeBuffWithBuffList[e]==t then
table.remove(self.ImmuneDeBuffWithBuffList,e)
break
end
end
end
function HeroCtrl:AddImmuneBuffWithBuffList(e)
table.insert(self.ImmuneBuffWithBuffList,e)
end
function HeroCtrl:RemoveImmuneBuffWithBuffList(t)
for e=1,#self.ImmuneBuffWithBuffList do
if self.ImmuneBuffWithBuffList[e]==t then
table.remove(self.ImmuneBuffWithBuffList,e)
break
end
end
end
function HeroCtrl:AddImmuneAfterDamage(e)
table.insert(self.ImmuneAfterDamageBuffList,e)
end
function HeroCtrl:RemoveImmuneAfterDamage(t)
for e=1,#self.ImmuneAfterDamageBuffList do
if self.ImmuneAfterDamageBuffList[e]==t then
table.remove(self.ImmuneAfterDamageBuffList,e)
break
end
end
end
function HeroCtrl:CheckAndExcuteImmuneAfterDamage(o,a)
if#self.ImmuneAfterDamageBuffList>0 then
for e=1,#self.ImmuneAfterDamageBuffList do
local e=self.ImmuneAfterDamageBuffList[e]
local t=self.HeroBattleInfo:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
if e and e.ImmuneAfterDamage then
local e=e.ImmuneAfterDamage(t,o,a)
if e then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return true
end
end
end
end
end
return false
end
function HeroCtrl:AddConvertTarget(e,t)
self:RemoveConvertTarget(e,t)
local e={
buffId=e,
heroId=t,
}
table.insert(self.ConvertTargetBuffList,e)
end
function HeroCtrl:RemoveConvertTarget(t,e)
for e=1,#self.ConvertTargetBuffList do
if self.ConvertTargetBuffList[e].buffId==t then
table.remove(self.ConvertTargetBuffList,e)
break
end
end
end
function HeroCtrl:GetConvertTarget()
for t=1,#self.ConvertTargetBuffList do
local t=self.ConvertTargetBuffList[t]
local a=t.heroId
local e=e:GetTargetHeroCtrl(a)
if e then
return e,t
end
end
return nil
end
function HeroCtrl:AddAttrMinValue(a,e,t)
if self.mAttrMinValueBuffMap[e]==nil then
self.mAttrMinValueBuffMap[e]={}
end
self.mAttrMinValueBuffMap[e][a]=t
self:RefreshAttrMinValue(e)
end
function HeroCtrl:RemoveAttrMinValue(t,e)
if self.mAttrMinValueBuffMap[e]and self.mAttrMinValueBuffMap[e][t]then
self.mAttrMinValueBuffMap[e][t]=nil
end
self:RefreshAttrMinValue(e)
end
function HeroCtrl:RefreshAttrMinValue(t)
if self.mAttrMinValueBuffMap[t]then
local a=self.mAttrMinValueBuffMap[t]
local e=nil
for a,t in pairs(a)do
if e==nil or t>e then
e=t
end
end
self.mAttrMinValueMap[t]=e
end
end
function HeroCtrl:GetAttrMinValue(e)
if self.mAttrMinValueMap[e]then
return self.mAttrMinValueMap[e]
end
end
function HeroCtrl:AddReduceHpMaxRateInSkillActList(e)
table.insert(self.reduceHpMaxRateInSkillActList,e)
if#self.reduceHpMaxRateInSkillActList>=2 then
table.sort(self.reduceHpMaxRateInSkillActList,function(e,t)
if e.hpMaxRate~=e.hpMaxRate then
return e.hpMaxRate<e.hpMaxRate
end
return e.buffId<e.buffId
end)
end
end
function HeroCtrl:RemoveReduceHpMaxRateInSkillActList(t)
for e=1,#self.reduceHpMaxRateInSkillActList do
if self.reduceHpMaxRateInSkillActList[e].buffId==t then
table.remove(self.reduceHpMaxRateInSkillActList,e)
break
end
end
end
function HeroCtrl:GetReduceHpMaxRateInSkillAct()
local e=self.reduceHpMaxRateInSkillActList[1]
return e
end
function HeroCtrl:AddDisableDefRageInExSkill(e)
self.HeroBattleInfo:AddBuffValue(e,HeroAttrId.DisableDefRageInExSkill,10000)
self:RefreshDisableDefRageInExSkill()
end
function HeroCtrl:RefreshDisableDefRageInExSkill()
local e=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.DisableDefRageInExSkill)
if e>0 then
self.DisableDefRageInExSkill=true
else
self.DisableDefRageInExSkill=false
end
end
function HeroCtrl:AddImmuneControlBuff(e)
self.HeroBattleInfo:RemoveControlBuff()
self.HeroBattleInfo:AddBuffValue(e,HeroAttrId.ImmuneControlBuff,10000)
self:RefreshImmuneControlBuff()
end
function HeroCtrl:RefreshImmuneControlBuff()
local e=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.ImmuneControlBuff)
if e>0 then
self.ImmuneControlBuff=true
else
self.ImmuneControlBuff=false
end
end
function HeroCtrl:AddDisableBlock(e)
self.HeroBattleInfo:AddBuffValue(e,HeroAttrId.disableBlock,10000)
self:RefreshDisableBlock()
end
function HeroCtrl:RefreshDisableBlock()
local e=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.disableBlock)
if e>0 then
self.disableBlock=true
else
self.disableBlock=false
end
end
function HeroCtrl:AddDisableOtherHeal(e)
self.HeroBattleInfo:AddBuffValue(e,HeroAttrId.disableOtherHeal,10000)
self:RefreshDisableOtherHeal()
end
function HeroCtrl:RefreshDisableOtherHeal()
local e=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.disableOtherHeal)
if e>0 then
self.disableOtherHeal=true
else
self.disableOtherHeal=false
end
end
function HeroCtrl:AddDisableOtherShield(e)
self.HeroBattleInfo:AddBuffValue(e,HeroAttrId.disableOtherShield,10000)
self:RefreshDisableOtherShield()
end
function HeroCtrl:RefreshDisableOtherShield()
local e=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.disableOtherShield)
if e>0 then
self.disableOtherShield=true
else
self.disableOtherShield=false
end
end
function HeroCtrl:AddImmuneResurgence(t,e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if not e then
e=EBuffTriggerlLevel.One
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.ImmuneResurgenceMap[t]=e
self:RefreshImmuneResurgence()
end
function HeroCtrl:RemoveImmuneResurgence(e)
self.ImmuneResurgenceMap[e]=nil
self:RefreshImmuneResurgence()
end
function HeroCtrl:RefreshImmuneResurgence()
local e=0
for a,t in pairs(self.ImmuneResurgenceMap)do
if t>e then
e=t
end
end
self.ImmuneResurgence=e
end
function HeroCtrl:AddImmuneAvoidDeath(t,e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if not e then
e=EBuffTriggerlLevel.One
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.ImmuneAvoidDeathMap[t]=e
self:RefreshImmuneAvoidDeath()
end
function HeroCtrl:RemoveImmuneAvoidDeath(e)
self.ImmuneAvoidDeathMap[e]=nil
self:RefreshImmuneAvoidDeath()
end
function HeroCtrl:RefreshImmuneAvoidDeath()
local e=0
for a,t in pairs(self.ImmuneAvoidDeathMap)do
if t>e then
e=t
end
end
self.ImmuneAvoidDeath=e
end
function HeroCtrl:AddForbidExtraAttack(e)
self.ForbidExtraAttackMap[e]=true
self:RefreshForbidExtraAttack()
end
function HeroCtrl:RemoveForbidExtraAttack(e)
self.ForbidExtraAttackMap[e]=nil
self:RefreshForbidExtraAttack()
end
function HeroCtrl:RefreshForbidExtraAttack()
self.ForbidExtraAttack=false
for e,e in pairs(self.ForbidExtraAttackMap)do
self.ForbidExtraAttack=true
break
end
end
function HeroCtrl:AddForbidEvade(e)
self.ForbidEvadeMap[e]=true
self:RefreshForbidEvade()
end
function HeroCtrl:RemoveForbidEvade(e)
self.ForbidEvadeMap[e]=nil
self:RefreshForbidEvade()
end
function HeroCtrl:RefreshForbidEvade()
self.ForbidEvade=false
for e,e in pairs(self.ForbidEvadeMap)do
self.ForbidEvade=true
break
end
end
function HeroCtrl:AddForbidImmuneDamage(e)
self.ForbidImmuneDamageMap[e]=true
self:RefreshForbidImmuneDamage()
end
function HeroCtrl:RemoveForbidImmuneDamage(e)
self.ForbidImmuneDamageMap[e]=nil
self:RefreshForbidImmuneDamage()
end
function HeroCtrl:RefreshForbidImmuneDamage()
self.ForbidImmuneDamage=false
for e,e in pairs(self.ForbidImmuneDamageMap)do
self.ForbidImmuneDamage=true
break
end
end
function HeroCtrl:AddDamageToSepsissRate(e,t)
self.DamageToSepsissRateMap[e]=t
self:RefreshDamageToSepsissRate()
end
function HeroCtrl:RemoveDamageToSepsissRate(e)
self.DamageToSepsissRateMap[e]=nil
self:RefreshDamageToSepsissRate()
end
function HeroCtrl:RefreshDamageToSepsissRate()
self.DamageToSepsissRate=0
for t,e in pairs(self.DamageToSepsissRateMap)do
self.DamageToSepsissRate=self.DamageToSepsissRate+e
end
end
function HeroCtrl:AddImmuneLockHp(t,e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if not e then
e=EBuffTriggerlLevel.One
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.ImmuneLockHpMap[t]=e
self:RefreshImmuneLockHp()
end
function HeroCtrl:RemoveImmuneLockHp(e)
self.ImmuneLockHpMap[e]=nil
self:RefreshImmuneLockHp()
end
function HeroCtrl:RefreshImmuneLockHp()
local e=0
local a=0
for o,t in pairs(self.ImmuneLockHpMap)do
if t>e then
e=t
a=o
end
end
self.ImmuneLockHp=e
self.buffIdImmuneLockHp=a
end
function HeroCtrl:AddTargetLevel(e,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.TargetLevelMap[e]=t
self:RefreshTargetLevel()
end
function HeroCtrl:RemoveTargetLevel(e)
self.TargetLevelMap[e]=nil
self:RefreshTargetLevel()
end
function HeroCtrl:RefreshTargetLevel()
local e=0
for a,t in pairs(self.TargetLevelMap)do
if t>e then
e=t
end
end
self.TargetLevel=e
if self.CurrBattleTeam then
self.CurrBattleTeam:RefreshNeedTargetLevel()
end
end
function HeroCtrl:AddTargetLevel(t,e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.TargetLevelMap[t]=e
self:RefreshTargetLevel()
end
function HeroCtrl:RemoveTargetLevel(e)
self.TargetLevelMap[e]=nil
self:RefreshTargetLevel()
end
function HeroCtrl:RefreshTargetLevel()
local e=0
for a,t in pairs(self.TargetLevelMap)do
if t>e then
e=t
end
end
self.TargetLevel=e
if self.CurrBattleTeam then
self.CurrBattleTeam:RefreshNeedTargetLevel()
end
end
function HeroCtrl:AddImmuneSepsisHp(e,t,a)
local e={
buffId=e,
effectPrefabId=t or 0,
maxHealHp=a or 0
}
table.insert(self.ImmuneSepsisHpList,e)
self:RefreshImmuneSepsisHp()
end
function HeroCtrl:ReduceImmuneSepsisHp(t)
for e=1,#self.ImmuneSepsisHpList do
if self.ImmuneSepsisHpList[e].buffId==t then
table.remove(self.ImmuneSepsisHpList,e)
break
end
end
self:RefreshImmuneSepsisHp()
end
function HeroCtrl:RefreshImmuneSepsisHp()
if#self.ImmuneSepsisHpList>0 then
local t=self.ImmuneSepsisHpList[1]
local a=0
for e=1,#self.ImmuneSepsisHpList do
if self.ImmuneSepsisHpList[e].effectPrefabId>0 then
a=self.ImmuneSepsisHpList[e].effectPrefabId
end
if self.ImmuneSepsisHpList[e].maxHealHp>t.maxHealHp then
t=self.ImmuneSepsisHpList[e]
end
end
self.ImmuneSepsisHpBuffData=t
self.ImmuneSepsisHpEffectPrefabId=a
else
self.ImmuneSepsisHpBuffData=nil
self.ImmuneSepsisHpEffectPrefabId=0
end
end
function HeroCtrl:CheckRemoveImmuneSepsisHpBuff(e)
if e then
local t=e.buffId
local e=self.HeroBattleInfo:GetBuff(e.buffId)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(t)
if a.OnImmuneSepsisHp then
local e=a.OnImmuneSepsisHp(e)
if e then
self.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
end
end
end
end
function HeroCtrl:AddSepsisHp(e)
if e then
if self.ImmuneSepsisHpBuffData then
self:SetImmnuneSepsisHpPrefabId(self.ImmuneSepsisHpEffectPrefabId)
if self.ImmuneSepsisHpBuffData.maxHealHp>0 then
local e=math.min(e,self.ImmuneSepsisHpBuffData.maxHealHp)
if e>0 then
self:HpHealthWithDirect(e,EBattleSrcType.SepsisHp)
end
end
self:CheckRemoveImmuneSepsisHpBuff(self.ImmuneSepsisHpBuffData)
if self.HeroBattleInfo then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.ImmuneSepsisHp)
end
return false
else
self.needChangeSepsisHP=self.needChangeSepsisHP+e
return true
end
end
return false
end
function HeroCtrl:ReduceSepsisHp(e)
self.needChangeSepsisHP=self.needChangeSepsisHP-e
end
function HeroCtrl:ClearSepsisHpDirect(e)
self.HeroBattleInfo:ClearSepsisHP(e)
end
function HeroCtrl:AddSepsisHpDirect(e,t)
if e>0 then
if self.ImmuneSepsisHpBuffData then
self:SetImmnuneSepsisHpPrefabId(self.ImmuneSepsisHpEffectPrefabId)
if self.ImmuneSepsisHpBuffData.maxHealHp>0 then
local e=math.min(e,self.ImmuneSepsisHpBuffData.maxHealHp)
if e>0 then
self:HpHealthWithDirect(e,EBattleSrcType.SepsisHp)
end
end
self:CheckRemoveImmuneSepsisHpBuff(self.ImmuneSepsisHpBuffData)
if self.HeroBattleInfo then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.ImmuneSepsisHp)
end
if t then
self:CheckShowImmuneSepsisHpEffect()
end
return false
else
self.HeroBattleInfo:AddSepsisHP(e,t)
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.SepsisHpChangeDirect)
if t then
self:CheckShowSepsisHpEffect()
end
return true
end
end
return false
end
function HeroCtrl:ReduceSepsisHpDirect(e,t)
if e>0 then
self.HeroBattleInfo:ReduceSepsisHP(e,t)
end
end
function HeroCtrl:ShowTimeLineSepsisHp()
if ModulesInit.ProcedureNormalBattle.isTimeLine then
self:CheckShowSepsisHpEffect()
self.HeroBattleInfo:SetSepsisHP(self.hurtBeforeSepsisHP+self.needChangeSepsisHP)
end
end
function HeroCtrl:SetImmnuneSepsisHpPrefabId(e)
self.CurImmnuneSepsisHpPrefabId=e or 0
end
function HeroCtrl:CheckShowImmuneSepsisHpEffect()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.CurImmnuneSepsisHpPrefabId>0)then
local e=self:GetFootPointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(self.CurImmnuneSepsisHpPrefabId,e.x,e.y,e.z,3,0,false,function()
end)
self:SetImmnuneSepsisHpPrefabId(0)
end
end
end
function HeroCtrl:CheckShowSepsisHpEffect()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=self:GetMiddlePointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.SepsisHpEffect,e.x,e.y,e.z,3,0,false,function()
end)
end
end
function HeroCtrl:CheckShowAddMaxHpEffect()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=self:GetFootPointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.BattleAddMaxHpEffect,e.x,e.y,e.z,3,0,false,function()
end)
end
end
function HeroCtrl:AddMustSmallSkill(e)
self.HeroBattleInfo:AddBuffValue(e,HeroAttrId.mustSmallSkill,10000)
self:RefreshMustSmallSkill()
end
function HeroCtrl:RefreshMustSmallSkill()
local e=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.mustSmallSkill)
if e>0 then
self.MustSmallSkill=true
else
self.MustSmallSkill=false
end
end
function HeroCtrl:SetMustSmallSkill()
self.MustSmallSkill=true
self:SetCurrRoundCanTriggerSmallSkill()
self:RefreshMustSmallSkill()
self:CheckBattleRoundBigAndSmallSkillStatus()
end
function HeroCtrl:AddImmuneThorn(e)
self.HeroBattleInfo:AddBuffValue(e,HeroAttrId.ImmuneThorn,10000)
self:RefreshImmuneThorn()
end
function HeroCtrl:RefreshImmuneThorn()
local e=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.ImmuneThorn)
if e>0 then
self.ImmuneThorn=true
else
self.ImmuneThorn=false
end
end
function HeroCtrl:AddImmuneResumeFury(e)
self.HeroBattleInfo:AddBuffValue(e,HeroAttrId.ImmuneResumeFury,10000)
self:RefreshImmuneResumeFury()
end
function HeroCtrl:RefreshImmuneResumeFury()
local e=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.ImmuneResumeFury)
if e>0 then
self.ImmuneResumeFury=true
else
self.ImmuneResumeFury=false
end
end
function HeroCtrl:AddForbidHeal(e)
self.HeroBattleInfo:AddBuffValue(e,HeroAttrId.forbidHeal,10000)
self:RefreshForbidHeal()
end
function HeroCtrl:RefreshForbidHeal()
local e=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.forbidHeal)
if e>0 then
self.forbidHeal=true
else
self.forbidHeal=false
end
end
function HeroCtrl:AddForbidSpecialHeal(e)
table.insert(self.forbidSpecialHealList,e)
end
function HeroCtrl:RemoveForbidSpecialHeal(t)
for e=1,#self.forbidSpecialHealList do
if self.forbidSpecialHealList[e]==t then
table.remove(self.forbidSpecialHealList,e)
break
end
end
end
function HeroCtrl:AddAbsorptionHeal(e)
table.insert(self.absorptionHealList,e)
end
function HeroCtrl:RemoveAbsorptionHeal(t)
for e=1,#self.absorptionHealList do
if self.absorptionHealList[e]==t then
table.remove(self.absorptionHealList,e)
break
end
end
end
function HeroCtrl:AddForbidBlood(e)
self.HeroBattleInfo:AddBuffValue(e,HeroAttrId.forbidBlood,10000)
self:RefreshForbidBlood()
end
function HeroCtrl:RefreshForbidBlood()
local e=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.forbidBlood)
if e>0 then
self.forbidBlood=true
else
self.forbidBlood=false
end
end
function HeroCtrl:AddReduceSepsisRate(t,e)
local e={
buffId=t,
sepsisReduceRate=e*MillionCoe
}
table.insert(self.sepsisReduceRateBuffList,e)
self:RefreshSepsisReduceRate()
end
function HeroCtrl:RemoveSepsisReduceRate(t)
for e=1,#self.sepsisReduceRateBuffList do
if self.sepsisReduceRateBuffList[e].buffId==t then
table.remove(self.sepsisReduceRateBuffList,e)
break
end
end
self:RefreshSepsisReduceRate()
end
function HeroCtrl:RefreshSepsisReduceRate()
local t=1
for e=1,#self.sepsisReduceRateBuffList do
local e=1-self.sepsisReduceRateBuffList[e].sepsisReduceRate
e=math.min(1,e)
e=math.max(0,e)
t=t*e
end
self.sepsisRate=t
end
function HeroCtrl:GetSepsisRate()
return self.sepsisRate
end
function HeroCtrl:AddIgnoreHealThrons(e)
table.insert(self.ignoreHealThronsBuffList,e)
self:RefreshIgnoreHealThrons()
end
function HeroCtrl:RemoveIgnoreHealThrons(t)
for e=1,#self.ignoreHealThronsBuffList do
if self.ignoreHealThronsBuffList[e]==t then
table.remove(self.ignoreHealThronsBuffList,e)
break
end
end
self:RefreshIgnoreHealThrons()
end
function HeroCtrl:RefreshIgnoreHealThrons()
if#self.ignoreHealThronsBuffList>0 then
self.ignoreHealThrons=true
else
self.ignoreHealThrons=false
end
end
function HeroCtrl:IsIgnoreHealThrons()
return self.ignoreHealThrons
end
function HeroCtrl:AddIgnoreForbidHeal(e)
table.insert(self.ignoreForbidHealBuffList,e)
self:RefreshIgnoreForbidHeal()
end
function HeroCtrl:RemoveIgnoreForbidHeal(t)
for e=1,#self.ignoreForbidHealBuffList do
if self.ignoreForbidHealBuffList[e]==t then
table.remove(self.ignoreForbidHealBuffList,e)
break
end
end
self:RefreshIgnoreForbidHeal()
end
function HeroCtrl:RefreshIgnoreForbidHeal()
if#self.ignoreForbidHealBuffList>0 then
self.ignoreForbidHeal=true
else
self.ignoreForbidHeal=false
end
end
function HeroCtrl:IsIgnoreForbidHeal()
return self.ignoreForbidHeal
end
function HeroCtrl:AddImmortal(e)
table.insert(self.ImmortalBuffList,e)
self:RefreshImmortal()
end
function HeroCtrl:RemoveImmortal(t)
for e=1,#self.ImmortalBuffList do
if self.ImmortalBuffList[e]==t then
table.remove(self.ImmortalBuffList,e)
break
end
end
self:RefreshImmortal()
end
function HeroCtrl:RefreshImmortal()
if#self.ImmortalBuffList>0 then
self.Immortal=true
else
self.Immortal=false
end
end
function HeroCtrl:IsImmortalState()
return self.Immortal
end
function HeroCtrl:AddAttackInvalid(e)
table.insert(self.AttackInvalidBuffList,e)
self:RefreshAttackInvalid()
end
function HeroCtrl:RemoveAttackInvalid(t)
for e=1,#self.AttackInvalidBuffList do
if self.AttackInvalidBuffList[e]==t then
table.remove(self.AttackInvalidBuffList,e)
break
end
end
self:RefreshAttackInvalid()
end
function HeroCtrl:RefreshAttackInvalid()
if#self.AttackInvalidBuffList>0 then
self.AttackInvalid=true
else
self.AttackInvalid=false
end
end
function HeroCtrl:IsAttackInvalidState()
return self.AttackInvalid
end
function HeroCtrl:AddDispelDisturb(e)
table.insert(self.DispelDisturbBuffList,e)
end
function HeroCtrl:RemoveDispelDisturb(t)
for e=1,#self.DispelDisturbBuffList do
if self.DispelDisturbBuffList[e]==t then
table.remove(self.DispelDisturbBuffList,e)
break
end
end
end
function HeroCtrl:TriggerDispelDisturb(o)
if#self.DispelDisturbBuffList>0 then
local e=table.lightCopyList(self.DispelDisturbBuffList)
for t=1,#e do
local e=e[t]
local t=self.HeroBattleInfo:GetBuff(e)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(e)
local a,t=a.OnTriggerDispelDisturb(t,o)
if t then
self.HeroBattleInfo:RemoveBuffWithId(e,BuffRemoveType.Expire)
end
if a then
return true
end
end
end
end
return false
end
function HeroCtrl:AddFuryCostReduceEntry(e,a,t)
self:RemoveFuryCostReduceEntryData(e)
table.insert(self.furyCostReduceList,{
buffId=e,
reduceRateWan=a,
remainCount=t,
})
end
function HeroCtrl:RemoveFuryCostReduceEntry(e)
self:RemoveFuryCostReduceEntryData(e)
end
function HeroCtrl:RemoveFuryCostReduceEntryData(t)
for e=#self.furyCostReduceList,1,-1 do
if self.furyCostReduceList[e].buffId==t then
table.remove(self.furyCostReduceList,e)
end
end
end
function HeroCtrl:GetEffectiveFuryCost(e)
local t=self.furyCostReduceList[1]
if t==nil then
return e
end
local t=1-t.reduceRateWan*MillionCoe
return math.max(0,math.floor(e*t))
end
function HeroCtrl:ConsumeFuryCostReduceEntry()
local e=self.furyCostReduceList[1]
if e==nil then
return
end
if e.remainCount==-1 then
return
end
e.remainCount=e.remainCount-1
if e.remainCount<=0 then
local e=table.remove(self.furyCostReduceList,1)
local t=self.HeroBattleInfo:GetBuff(e.buffId)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e.buffId)
if e.OnRemoveFuryCostReduceE then
e.OnRemoveFuryCostReduceE(t)
end
end
end
end
function HeroCtrl:AddHealToSepsissRate(e,t)
self:RemoveHealToSepsissRateData(e)
local e={
buffId=e,
rate=t,
}
table.insert(self.healToSepsissRateList,e)
self:RefreshHealToSepsissRate()
end
function HeroCtrl:RemoveHealToSepsissRate(e)
self:RemoveHealToSepsissRateData(e)
self:RefreshHealToSepsissRate()
end
function HeroCtrl:RemoveHealToSepsissRateData(t)
for e=1,#self.healToSepsissRateList do
if self.healToSepsissRateList[e].buffId==t then
table.remove(self.healToSepsissRateList,e)
break
end
end
end
function HeroCtrl:RefreshHealToSepsissRate()
local e=0
for t=1,#self.healToSepsissRateList do
if self.healToSepsissRateList[t].buffId then
e=e+self.healToSepsissRateList[t].rate
end
end
self.healToSepsissRate=e
end
function HeroCtrl:AddMustCritValue(e)
self.HeroBattleInfo:AddBuffValue(e,HeroAttrId.mustCrit,10000)
self:RefreshMustCrit()
end
function HeroCtrl:AddMustCritValueInCurAttack()
local e={
attrId=HeroAttrId.mustCrit,
value=10000,
}
self:AddAttrValueInCurAttack(e)
self:RefreshMustCrit()
end
function HeroCtrl:RemoveMustCritValueInCurAttack()
self:RemoveAttrValueInCurAttack(HeroAttrId.mustCrit)
self:RefreshMustCrit()
end
function HeroCtrl:RefreshMustCrit()
local e=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.mustCrit)
if e>0 then
self.IsMustCrit=true
else
self.IsMustCrit=false
end
end
function HeroCtrl:AddLockFury(e,t)
local e={
buffId=e,
lockFury=t
}
table.insert(self.mLockFuryBuffList,e)
end
function HeroCtrl:RemoveLockFury(t)
for e=1,#self.mLockFuryBuffList do
if self.mLockFuryBuffList[e].buffId==t then
table.remove(self.mLockFuryBuffList,e)
break
end
end
end
function HeroCtrl:GetAttackForceTotalRestraintType()
local e=self:CompareForceRestraintType(self.attackForceRestraintType,self.attackForceRestraintTypeInCurAttack)
return e
end
function HeroCtrl:GetDefForceTotalRestraintType()
local e=self:CompareForceRestraintType(self.defForceRestraintType,self.defForceRestraintTypeInCurAttack)
return e
end
function HeroCtrl:AddForceRestraintTypeInCurAttack(t,e,a)
if e then
self.attackForceRestraintTypeInCurAttack=self:CompareForceRestraintType(self.attackForceRestraintTypeInCurAttack,t)
end
if e then
self.defForceRestraintTypeInCurAttack=self:CompareForceRestraintType(self.defForceRestraintTypeInCurAttack,t)
end
end
function HeroCtrl:ClearForceRestraintTypeInCurAttack()
self.attackForceRestraintTypeInCurAttack=EForceRestraintType.None
self.defForceRestraintTypeInCurAttack=EForceRestraintType.None
end
function HeroCtrl:AddForceRestraintType(e,o,t,a)
local e={
buffId=e,
restraintType=o,
enableAttack=t,
enableDef=a,
}
table.insert(self.forceRestraintTypeList,e)
self:RefreshForceRestraintType()
end
function HeroCtrl:RemoveForceRestraintType(t)
for e=1,#self.forceRestraintTypeList do
if self.forceRestraintTypeList[e].buffId==t then
table.remove(self.forceRestraintTypeList,e)
break
end
end
self:RefreshForceRestraintType()
end
function HeroCtrl:RefreshForceRestraintType()
local e=EForceRestraintType.None
local a=EForceRestraintType.None
for t=1,#self.forceRestraintTypeList do
local t=self.forceRestraintTypeList[t]
if t.enableAttack then
e=self:CompareForceRestraintType(t.restraintType,e)
end
if t.enableDef then
a=self:CompareForceRestraintType(t.restraintType,a)
end
end
self.attackForceRestraintType=e
self.defForceRestraintType=e
end
function HeroCtrl:CompareForceRestraintType(t,e)
if t>e then
return t
else
return e
end
end
function HeroCtrl:AddFuryWithBuff(e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
self.HeroBattleInfo:AddFury(e)
self:RefreshFury()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
self.HeroBattleInfo:AddBattleEffectNormal(BattleEffectType.AddFury,ModulesInit.ProcedureNormalBattle.CurrBattleBigRound)
end
end
function HeroCtrl:AddFuryWithBuffImmediately(e)
self:AddFuryWithBuff(e)
if self.HeroBattleInfo then
self.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
end
end
function HeroCtrl:ResetMaxFuryWithBuff()
self:ResetFuryWithBuff(self.HeroBattleInfo.Fury)
end
function HeroCtrl:ResetFuryWithBuff(e)
self.HeroBattleInfo:ResetFury(e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:RefreshFury()
end
function HeroCtrl:ReduceFuryWithBuff(e)
if(self.ImmuneReduceFury)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
local e=self.HeroBattleInfo:ReduceFury(e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if self.CurrHeadBarView then
self.CurrHeadBarView:SetFury(self.HeroBattleInfo.CurrFury,self.HeroBattleInfo.Fury)
end
end
self:RefreshFury()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
self.HeroBattleInfo:AddBattleEffectNormal(BattleEffectType.ReduceFury,ModulesInit.ProcedureNormalBattle.CurrBattleBigRound)
end
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.DoReduceFury,nil,nil,{reduceFuryValue=e})
end
function HeroCtrl:SetRageBar(t,e)
if self.CurrHeadBarView then
self.CurrHeadBarView:SetRage(t,e)
end
end
function HeroCtrl:GetShowBuffIconList()
if self.CurrHeadBarView then
return self.CurrHeadBarView.buffIconViews
end
return{}
end
function HeroCtrl:ShowRageBar(e,t)
if self.CurrHeadBarView then
self.CurrHeadBarView:ShowRage(e,t)
end
end
function HeroCtrl:ReduceFuryWithBuffImmediately(e)
self:ReduceFuryWithBuff(e)
self:PlayReduceFuryEffect()
end
function HeroCtrl:SetOverdrawFury(e)
if self.HeroBattleInfo then
self.HeroBattleInfo:SetOverdrawFury(e)
end
self:RefreshShowOverdrawFury()
end
function HeroCtrl:GetOverdrawFury()
if self.HeroBattleInfo then
return self.HeroBattleInfo:GetOverdrawFury()
end
return 0
end
function HeroCtrl:AddOverdrawFury(e)
if self.HeroBattleInfo then
self.HeroBattleInfo:AddOverdrawFury(e)
end
self:RefreshShowOverdrawFury()
end
function HeroCtrl:ReduceOverdrawFury(e)
if self.HeroBattleInfo then
self.HeroBattleInfo:ReduceOverdrawFury(e)
end
self:RefreshShowOverdrawFury()
end
function HeroCtrl:RefreshShowOverdrawFury()
if ModulesInit.ProcedureNormalBattle.IsSkipBattle==false then
if self.HeroBattleInfo then
if self.HeroBattleInfo.OverdrawFury>0 then
self:AddBuff(self,3130,-1,0)
else
self.HeroBattleInfo:RemoveBuffWithId(3130,BuffRemoveType.Expire)
end
end
end
end
function HeroCtrl:RemoveExtraSoulWithId(t)
for e,a in pairs(self.extraSoulMap)do
if a.buffId==t then
self.extraSoulMap[e]=nil
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return
end
end
end
function HeroCtrl:AddExtraSoulMap(e,t)
if e==nil then
return
end
t=t or 0
if e~=self.soulId then
local a=c.GetEntity(e)
if a then
if self.extraSoulMap[e]==nil then
self.extraSoulMap[e]={soulRow=a,buffId=t}
end
local o=self.extraSoulMap[e]
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if self:IsStakeFightOpenNewFury()==false then
self:AddFuryWithSoulAndSoulData(a,SoulAddFuryType.startRage)
end
end
end
end
function HeroCtrl:AddFuryWithSoul(e)
self:AddFuryWithBaseSoul(e)
self:AddFuryWithExtraSoul(e)
end
function HeroCtrl:AddFuryWithBaseSoul(e)
self:AddFuryWithSoulAndSoulData(self.soulRow,e)
end
function HeroCtrl:GetSoulValue(e)
local a=self:GetSoulValueBySoulData(self.soulRow,e)
for o,t in pairs(self.extraSoulMap)do
local e=self:GetSoulValueBySoulData(t.soulRow,e)
a=a+e
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then
if t.soulRow and e>0 then

end
end
end
return a
end
function HeroCtrl:GetSoulValueBySoulData(e,t)
if(e==nil)then
return 0
end
if(t==SoulAddFuryType.startRage)then
return e.startRage
elseif(t==SoulAddFuryType.roundRage)then
return e.roundRage
elseif(t==SoulAddFuryType.defRage)then
return e.defRage
elseif(t==SoulAddFuryType.atkRage)then
return e.atkRage
elseif(t==SoulAddFuryType.deadRage)then
return e.deadRage
elseif(t==SoulAddFuryType.killRage)then
return e.killRage
end
return 0
end
function HeroCtrl:AddFuryWithExtraSoul(t)
for a,e in pairs(self.extraSoulMap)do
self:AddFuryWithSoulAndSoulData(e.soulRow,t)
end
end
function HeroCtrl:AddFuryWithSoulAndSoulData(e,t)
if(e==nil)then
return
end
if(t==SoulAddFuryType.startRage)then
if(e.startRage>0 and self.HeroBattleInfo.CurrHP>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.HeroBattleInfo:AddFuryWithSoul(e.startRage)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
elseif(t==SoulAddFuryType.roundRage)then
if(e.roundRage>0 and self.HeroBattleInfo.CurrHP>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.HeroBattleInfo:AddFuryWithSoul(e.roundRage)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
elseif(t==SoulAddFuryType.defRage)then
if(e.defRage>0 and self.HeroBattleInfo.CurrHP>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.HeroBattleInfo:AddFuryWithSoul(e.defRage)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
elseif(t==SoulAddFuryType.atkRage)then
if(e.atkRage>0 and self.HeroBattleInfo.CurrHP>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.HeroBattleInfo:AddFuryWithSoul(e.atkRage)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
elseif(t==SoulAddFuryType.deadRage)then
if(e.deadRage>0 and self.HeroBattleInfo.CurrHP>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.HeroBattleInfo:AddFuryWithSoul(e.deadRage)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
elseif(t==SoulAddFuryType.killRage)then
if(e.killRage>0 and self.HeroBattleInfo.CurrHP>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.HeroBattleInfo:AddFuryWithSoul(e.killRage)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
function HeroCtrl:AddFuryWithSoulInStakeFight(e)
local t=ModulesInit.ProcedureNormalBattle.GetSoulFuryValueInFakeFight(self.soulId,e)
if(t>0 and self.HeroBattleInfo.CurrHP>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.HeroBattleInfo:AddFuryWithSoul(t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
function HeroCtrl:AddFuryWithFakeFightParam(e)
local t=ModulesInit.ProcedureNormalBattle.GetStakeFightParam(e)
if(t>0 and self.HeroBattleInfo.CurrHP>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.HeroBattleInfo:AddFuryWithSoul(t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
function HeroCtrl:IsStakeFightOpenNewFury()
return ModulesInit.ProcedureNormalBattle.IsStakeFightOpenNewFury(self.IsOurHero)
end
function HeroCtrl:RefreshFury()
if self.CurrHeadBarView then
self.CurrHeadBarView:SetFury(self.HeroBattleInfo.CurrFury,self.HeroBattleInfo.Fury)
end
if(self.OnFuryChange~=nil)then
self.OnFuryChange()
end
end
function HeroCtrl:GetFinalHealRate()
local t=a.GetBattleAttrCoe(HeroAttrId.heal,self.HeroBattleInfo.Heal)
local e=a.GetBattleAttrCoe(HeroAttrId.healRateAdd,self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.healRateAdd))
local o=a.GetBattleAttrCoe(HeroAttrId.healResRate,self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.healResRate))
local e=1+t+e-o
local e=a.BattleAttrClamp(HeroAttrId.finalHealRate,e*OneMillion)*MillionCoe
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then




end
return e
end
function HeroCtrl:HpHealthWithNormalSkill(t,o,a,i)
local e=self:GetFinalHealRate()
local e=o*e
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
if(a)then
local t=u:CalculateHeroCriticalValue(t)
e=e*t
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
end
e=math.floor(e)
self:SynHpHealthData(e,a,i,t.HeroId,0)
if(t)then
t:AddTotalTreatment(self.willBeHpHealth)
end
self:CheckHpHealth()
end
function HeroCtrl:HpHealthWithBigSkill(e,o,n,i,h,s,r)
local t=self:GetFinalHealRate()
if s then
t=1
end
local d=a.GetBattleAttrCoe(HeroAttrId.eXSkillINjure,e.HeroBattleInfo.eXSkillINjure)
local s=a.GetBattleAttrCoe(HeroAttrId.eXSkillINjureRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.eXSkillINjureRateAdd))
local a=a.BattleAttrClamp(HeroAttrId.finaleXSkillINjureRate,(d+s)*OneMillion)*MillionCoe
local t=o*(n+a)*t
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then







end
if(i)then
local e=u:CalculateHeroCriticalValue(e)
t=t*e
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
end
t=math.floor(t)
local a=self:SynHpHealthData(t,i,h,e.HeroId,0,r)
a.originHealValue=t
if(e)then
e:AddTotalTreatment(self.willBeHpHealth)
end
self:CheckHpHealth()
return a
end
function HeroCtrl:HpHealthWithPet(t,e,o,a,i,n)
self:HpHealthSimple(t,e,o,a,i,n)
end
function HeroCtrl:HpHealthSimple(t,e,i,n,a,o)
e=math.floor(e)
local a=self:SynHpHealthData(e,false,i,t.HeroId,n,a,o)
a.originHealValue=e
if(t)then
t:AddTotalTreatment(self.willBeHpHealth)
end
self:CheckHpHealth()
return a
end
function HeroCtrl:HpHealthSimpleImmediately(o,a,t,e,i,i)
self:HpHealthSimple(o,a,t,e)
self:PlayHpHealth()
end
function HeroCtrl:SynHpHealthData(a,h,o,i,n,r,t)
local s,d=self:CheckHealState(o,i,n)
if t and t.healResultLimit and t.healResultLimit~=s then
return{
resultType=EHealResultType.NoMatchResultType,
value=0,
}
end
if s==EHealResultType.Heal then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=a
if self.healToSepsissRate>0 then
local a=math.floor(t*self.healToSepsissRate*MillionCoe)
t=math.max(0,t-a)
e:AddSepsisHp(self,self,a,true,true)
end
if r and self.HeroBattleInfo.CurrHP+self.willBeHpHealth+t>self.HeroBattleInfo.CurrMaxHP then
t=math.max(0,self.HeroBattleInfo.CurrMaxHP-self.HeroBattleInfo.CurrHP-self.willBeHpHealth)
end
if self:IsNormalSrcType(o)then
local e=0
for a=1,#self.absorptionHealList do
local a=self.absorptionHealList[a]
local o=self.HeroBattleInfo:GetBuff(a)
if o then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
if a and a.ExcuteAbsorptionHeal then
local a=a.ExcuteAbsorptionHeal(o,t)
t=t-a
e=e+a
if t<=0 then
self:SynHpHealthAbsorptInTimeLine(e)
return{
resultType=EHealResultType.HealAbsorpt,
value=e,
}
end
end
end
end
end
self.willBeHpHealth=self.willBeHpHealth+t
self.willBeHpHealthCrt=h
self:SynHpHealthInTimeLine(t,h)
return{
resultType=EHealResultType.Heal,
value=t,
}
elseif s==EHealResultType.HealForbid then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:SynHpHealthForbidInTimeLine(true)
return{
resultType=EHealResultType.HealForbid,
value=0,
}
elseif s==EHealResultType.HealThrons then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local e=self.HeroBattleInfo:GetBuff(d)
local t=false
if self:IsSkillAttacking()then
t=true
end
local e=self:RealHurtWithBuff(a,e,nil,nil,EBattleHurtNumType.HealThorn,t)
if e and t==true then
local t=e.originalHurtValue
local t=e.needReduceShield
local a=e.needReduceEnergy
local o=e.shield
local o=e.realHurtRet
local o=e.showHurtValue
local e=e.hurtValue+t+a
if e>0 then
self:SynHpHealthThornInTimeLine(e)
return{
resultType=EHealResultType.HealThrons,
value=e,
}
end
end
return{
resultType=EHealResultType.HealThrons,
value=0,
}
elseif s==EHealResultType.NoHeal then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return{
resultType=EHealResultType.NoHeal,
value=0,
}
end
end
function HeroCtrl:CheckHealState(t,e,a)
if self:CheckCanHeal(e)then
local a,o=self:IsHealThrons(t,a,e)
if a then
return EHealResultType.HealThrons,o
else
if self:IsHealForbid(t,e)then
return EHealResultType.HealForbid
else
return EHealResultType.Heal
end
end
else
return EHealResultType.NoHeal
end
end
function HeroCtrl:IsNormalSrcType(e)
if e==EBattleSrcType.SkillBig
or e==EBattleSrcType.SkillSmall
or e==EBattleSrcType.SkillPass
or e==EBattleSrcType.Buff
or e==EBattleSrcType.PetFightSkill
or e==EBattleSrcType.PetHelpSkill
or e==EBattleSrcType.DeathImmune
or e==EBattleSrcType.LockHp then
return true
end
return false
end
function HeroCtrl:IsHealForbid(e,t)
if self:IsIgnoreForbidHeal()then
return false
end
if self.HeroId~=t and self.disableOtherHeal then
return true
end
if self.forbidHeal then
if self:IsNormalSrcType(e)
or e==EBattleSrcType.DeathImmune
or e==EBattleSrcType.LockHp then
return true
end
end
if#self.forbidSpecialHealList>0 then
if e==EBattleSrcType.Resurgence
or e==EBattleSrcType.DeathImmune
or e==EBattleSrcType.LockHp then
local t=self.forbidSpecialHealList[1]
local a=self.HeroBattleInfo:GetBuff(t)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
if e and e.ExcuteAndCheckRemove and e.ExcuteAndCheckRemove(a)then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(self,BattleHeroType.ourAll,nil,nil,nil,nil,{isContainUsualState=true})
for a=1,#e do
local e=e[a]
e.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
end
end
return true
end
end
return false
end
function HeroCtrl:IsForbidBlood()
return self.forbidBlood
end
function HeroCtrl:IsHealThrons(o,e,t)
if o==EBattleSrcType.Resurgence then
return false
end
if self:IsIgnoreHealThrons()then
return false
end
if self.HeroBattleInfo:GetBuff(302102901)then
if self.HeroId==t then
return true,302102901
end
elseif e and e>0 and self.HeroBattleInfo:GetBuff(3098)then
local a=a:GetBuffCfg(e)
if self.HeroId==t and a and a.canPoisonousAddBlood==1 then
return true,e
end
elseif self.HeroBattleInfo:GetBuff(30106503)then
return true,30106503
end
return false
end
function HeroCtrl:CheckCanHeal(e)
if self.HeroBattleInfo:GetBuff(3100)then
if self.HeroId==e then
return true
end
elseif self:IsHeroForbidSpecialState()==false then
return true
end
return false
end
function HeroCtrl:HpHealth(s,i,h,a,o,n,t)
local e=1
if t==nil or t.fobidHealRate~=true then
e=self:GetFinalHealRate()
end
local e=math.floor(s*e)
e=math.max(1,e)
local s=nil
if h==true then
self:SynBloodData(e,i,a,o,n,nil,t)
else
s=self:SynHpHealthData(e,i,a,o,n,nil,t)
end
self:CheckHpHealth()
return s
end
function HeroCtrl:SynBloodData(e,t,a,a,a,a,a)
if self:IsForbidBlood()then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.willBeHpHealth=self.willBeHpHealth+e
self.willBeHpHealthCrt=t
self:SynSuckBloodInTimeLine(e,t)
end
end
function HeroCtrl:PlayMonsterEffect()
if(self.IsOurHero==false)then
local e=false
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.skillPreview then
local t=ModulesInit.ProcedureNormalBattle.MapId
if ModulesInit.BattlePreviewMgr:IsEffectMonster(t,self.heroDid)then
e=true
end
else
if(ModulesInit.ProcedureNormalBattle.IsEffectMonster(self.battleStationIndex))then
e=true
end
end
if e then
local e=self:GetFootPointPos()
GameEntry.Effect:ShowBuffEffect(
SysPrefabId.MonsterEffect,
EffectKeepType.UnAutoRelease,
3,
e.x,
e.y,
e.z,
nil,
function(t,e,t)
e:SetParent(self.spineboyTransform)
e.localPosition=Vector3.zero
self:AddBuffAboutEffects(e)
end
)
end
end
end
function HeroCtrl:LoadHaloEffect(e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
local t=self:GetPointPosWithType(HeroPointType.FootPoint)
GameEntry.Pool:GameObjectSpawn(
e,
nil,
function(e,a,a)
e:SetParent(self.spineboyTransform)
LuaUtils.SetPos(e,t.x,t.y,t.z)
LuaUtils.SetLocalScale(e,1,1,1)
self:AddBuffAboutEffects(e)
end
)
end
function HeroCtrl:PlayAutoReleaseEffect(a,o,e,t)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
t=t or HeroPointType.MiddlePoint
if e==nil then
e=self:GetPointPosWithType(t)
end
GameEntry.Effect:ShowBuffEffect(
a,
1,
o,
e.x,
e.y,
e.z,
nil,
function(t,e,t)
if(self.CurrHeroCtrl)then
e:SetParent(self.spineboyTransform)
e.localPosition=Vector3.zero
end
end
)
end
function HeroCtrl:PlayReduceFuryEffect()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
local e=self:GetFootPointPos()
GameEntry.Effect:ShowBuffEffect(
Constant.Fury_Reduce_Effect_PrefabId,
1,
Constant.Fury_Reduce_Effect_KeepTime,
e.x,
e.y,
e.z,
nil,
function(t,e,t)
if(self.spineboyTransform)then
e:SetParent(self.spineboyTransform)
e.localPosition=Vector3.zero
end
end
)
end
function HeroCtrl:PlayHpHealthEffect()
local e=self:GetFootPointPos()
GameEntry.Effect:ShowBuffEffect(
SysPrefabId.HpHealthEffect,
1,
3,
e.x,
e.y,
e.z,
nil,
function(t,e,t)
e:SetParent(self.spineboyTransform)
e.localPosition=Vector3.zero
end
)
end
function HeroCtrl:PlayHpHealthOnHurt()
self:PlayHpHealth()
end
function HeroCtrl:PlayHpHealth()
if(self.HeroBattleInfo.CurrHP<=0)then
return
end
if self:IsPet()then
return
end
self.mHpShowData={
hpHealthInTimeLine=self.hpHealthInTimeLine,
hpHealthCrtInTimeLine=self.hpHealthCrtInTimeLine,
hpHealthForbidInTimeLine=self.hpHealthForbidInTimeLine,
hpHealthAbsorptInTimeLine=self.hpHealthAbsorptInTimeLine,
hpHealthThornInTimeLine=self.hpHealthThornInTimeLine,
}
self.hpHealthInTimeLine=0
self.hpHealthCrtInTimeLine=false
self.hpHealthForbidInTimeLine=false
self.hpHealthAbsorptInTimeLine=0
self.hpHealthThornInTimeLine=0
end
function HeroCtrl:DoPlayHpHealth()
if self.mHpShowData.hpHealthForbidInTimeLine then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.CurrHpHealthNum)then
self.CurrHpHealthNum.SetText(EBattleHurtNumType.HealForBid,HurtTipsType.HealForBid)
end
end
elseif self.mHpShowData.hpHealthAbsorptInTimeLine>0 then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.CurrHpHealthNum)then
self.CurrHpHealthNum.SetText(EBattleHurtNumType.HealAbsorpt,self.mHpShowData.hpHealthAbsorptInTimeLine)
end
end
end
if self.mHpShowData.hpHealthThornInTimeLine>0 then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.CurrHpHealthNum)then
self.CurrHpHealthNum.SetText(EBattleHurtNumType.HealThorn,tostring(self.mHpShowData.hpHealthThornInTimeLine))
end
self:PlayHpHealthEffect()
end
end
if self.mHpShowData.hpHealthInTimeLine>0 then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.CurrHpHealthNum)then
if(self.mHpShowData.hpHealthCrtInTimeLine)then
self.CurrHpHealthNum.SetText(EBattleHurtNumType.ShengMing_Baoji,tostring(self.mHpShowData.hpHealthInTimeLine))
else
self.CurrHpHealthNum.SetText(EBattleHurtNumType.ShengMing,tostring(self.mHpShowData.hpHealthInTimeLine))
end
end
self:PlayHpHealthEffect()
end
end
self:RefreshHP()
self.mHpShowData=nil
end
function HeroCtrl:PlayHpHealthWithBlood()
if(self.suckBloodInTimeLine<=0 or self.HeroBattleInfo.CurrHP<=0)then
return
end
if self:IsPet()then
return
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.suckBloodInTimeLine>100)then
if(self.CurrHpHealthNum)then
if(self.suckBloodCrtInTimeLine)then
self.CurrHpHealthNum.SetText(EBattleHurtNumType.ShengMing_Baoji,tostring(self.suckBloodInTimeLine))
else
self.CurrHpHealthNum.SetText(EBattleHurtNumType.ShengMing,tostring(self.suckBloodInTimeLine))
end
end
self:PlayHpHealthEffect()
end
end
self:RefreshHP()
self.suckBloodInTimeLine=0
self.suckBloodCrtInTimeLine=false
end
function HeroCtrl:RefreshArmor()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(self.OnArmorChange~=nil)then
self.OnArmorChange()
end
end
function HeroCtrl:RefreshHP()
if self.CurrHeadBarView then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.CurrHeadBarView:SetHP(self.HeroBattleInfo.CurrHP,self.HeroBattleInfo.CurrMaxHP,self.HeroBattleInfo.MaxHP)
end
if(self.OnHPChange~=nil)then
self.OnHPChange()
end
end
function HeroCtrl:RefreshTeamMaxHP()
if self.CurrBattleTeam then
self.CurrBattleTeam:RefreshMaxHp()
end
end
function HeroCtrl:GetTeamMaxHP()
if self.CurrBattleTeam then
return self.CurrBattleTeam.TotalMaxHP
end
return 0
end
function HeroCtrl:GetEnemyTeamMaxHP()
if self.CurrBattleTeam and self.CurrBattleTeam.OpponentTeam then
return self.CurrBattleTeam.OpponentTeam.TotalMaxHP
end
return 0
end
function HeroCtrl:CheckHpHealth()
if(self.willBeHpHealth<=0 or self.HeroBattleInfo.CurrHP<=0)then
return
end
local t=self.HeroBattleInfo.CurrHP
local e=self.HeroBattleInfo.CurrHP+self.willBeHpHealth
e=math.min(e,self.HeroBattleInfo.CurrMaxHP)
local t=e-t
self:SetAddHpInBigRound(t)
self.HeroBattleInfo:SetHp(e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:RefreshHP()
self.willBeHpHealth=0
self.willBeHpHealthCrt=false
end
function HeroCtrl:HpHealthWithBuff(e,a,t,o)
self:HpHealth(e,false,false,a,t,o)
end
function HeroCtrl:HpHealthWithBuffImmediately(t,o,n,i,e,a)
if e==true then
if self.HeroBattleInfo.CurrHP<=0 then
self.HeroBattleInfo:SetHp(1)
end
end
local e=self:HpHealth(t,false,false,o,n,i,a)
self:PlayHpHealth()
return e
end
function HeroCtrl:HpHealthWithBuffRemedyPoint(a,t,e,o)
self:HpHealth(a,false,false,t,e,o)
self:PlayHpHealth()
end
function HeroCtrl:HpHealthWithBlood(e)
self:HpHealthWithBloodInLogic(e)
self:PlayHpHealthWithBlood()
end
function HeroCtrl:HpHealthWithBloodInLogic(e)
self:HpHealth(e,false,true,EBattleSrcType.SuckBlood,self.HeroId,0)
end
function HeroCtrl:HpHealthWithResurgence(e)
if self:IsHealForbid(EBattleSrcType.Resurgence,self.HeroId)then
if self.HeroBattleInfo.CurrHP<=0 then
self.HeroBattleInfo:SetHp(1)
end
return
end
self:HpHealthWithDirect(e)
end
function HeroCtrl:HpHealthWithDirect(e,o,a,t)
local e=math.floor(e)
e=math.min(e,self.HeroBattleInfo.CurrMaxHP-self.HeroBattleInfo.CurrHP)
e=math.max(1,e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.CurrHpHealthNum)then
self.CurrHpHealthNum.SetText(EBattleHurtNumType.ShengMing,tostring(e))
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local e=self.HeroBattleInfo.CurrHP+e
self.HeroBattleInfo:SetHp(e,true)
self:RefreshHP()
end
function HeroCtrl:HpHealthReset(e,t,a,o)
if e<self.HeroBattleInfo.CurrHP then
return
end
local e=e-self.HeroBattleInfo.CurrHP
self:HpHealthWithDirect(e,t,a,o)
end
function HeroCtrl:HpHealthImmediately(e,o,t,a)
e=math.floor(e)
self:SynHpHealthData(e,false,o,t,a)
self:CheckHpHealth()
end
function HeroCtrl:HpReduceImmediately(e)
self.HeroBattleInfo:ReducedHp(e)
self:RefreshHP()
end
function HeroCtrl:CurrHPPer()
if(self.HeroBattleInfo.MaxHP==0)then
return 0
end
return self.HeroBattleInfo.CurrHP/self.HeroBattleInfo.MaxHP
end
function HeroCtrl:CurrSepsisHPPer()
if(self.HeroBattleInfo==nil or self.HeroBattleInfo.MaxHP==0)then
return 0
end
return self.HeroBattleInfo.CurrSepsisHp/self.HeroBattleInfo.MaxHP
end
function HeroCtrl:GetHPPerByHp(e)
if type(e)~="number"then
return 0
end
if self.HeroBattleInfo==nil or self.HeroBattleInfo.MaxHP==0 then
return 0
end
local e=e/self.HeroBattleInfo.MaxHP
e=math.max(0,e)
e=math.min(1,e)
return e
end
function HeroCtrl:GetHPByPercent(e)
if type(e)~="number"then
return 0
end
if self.HeroBattleInfo==nil or self.HeroBattleInfo.MaxHP==0 then
return 0
end
local e=e*self.HeroBattleInfo.MaxHP
e=math.max(0,e)
return e
end
function HeroCtrl:HpHealthToMax()
local e=self.HeroBattleInfo.MaxHP
self.HeroBattleInfo:SetHp(e,true)
self:RefreshHP()
end
function HeroCtrl:CurrFuryPer()
if self.HeroBattleInfo.Fury>0 then
return self.HeroBattleInfo.CurrFury/self.HeroBattleInfo.Fury
end
return 0
end
function HeroCtrl:GetArmor()
if self.HeroBattleInfo then
return self.HeroBattleInfo.curArmor
end
return 0
end
function HeroCtrl:CheckAddBuff(o,e,t,n,h,i,s)
local a=false
if e:IsPet()then
if w:CalculateCtrlSuccess(t,o,e,self)then
a=true
end
else
if u:CalculateCtrlSuccess(t,o,e,self)then
a=true
end
end
if a==true then
if s then
local e=self:AddBuffWithMaxFloor(e,t,n,h,i,s)
return e
else
local e=self:AddBuff(e,t,n,h,i)
return e
end
end
return false
end
function HeroCtrl:AddBuffWithMaxFloor(o,a,n,i,s,h)
local e=self.HeroBattleInfo:GetBuff(a)
local t=0
if e then
t=e:GetFloors()
end
local e=h-t
local e=math.min(s,e)
return self:AddBuff(o,a,n,i,e)
end
function HeroCtrl:AddBuffWithFinalFloor(i,o,s,n,e,h)
local a=self.HeroBattleInfo:GetBuff(o)
if a then
if e<=0 then
self.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
else
local t=a:GetFloors()
if e>t then
a:AddFloors(e-t)
elseif e<t and h~=true then
a:ReduceFloors(t-e)
end
end
else
if e>0 then
self:AddBuff(i,o,s,n,e)
end
end
end
function HeroCtrl:AddBuffWithFloorNotRefreshRound(i,a,o,n,t)
local e=self.HeroBattleInfo:GetBuff(a)
if e then
e:AddFloors(t)
else
self:AddBuff(i,a,o,n,t)
end
end
function HeroCtrl:ModifyBuffWithFinalFloor(e,t)
if e then
if t<=0 then
self.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
else
local a=e:GetFloors()
if t>a then
e:AddFloors(t-a)
elseif t<a then
e:ReduceFloors(a-t)
end
end
end
end
function HeroCtrl:AddBuffAfterRemove(n,e,i,o,a)
local t=self.HeroBattleInfo:GetBuff(e)
if t then
self.HeroBattleInfo:RemoveBuffWithId(e,BuffRemoveType.Expire)
end
self:AddBuff(n,e,i,o,a)
end
function HeroCtrl:AddBuff(e,a,i,o,n,t)
if(self.HeroBattleInfo==nil)then
return false
end
if(e==nil)then
e=self
end
local e=self.HeroBattleInfo:AddBuff(e,a,i,o,n,t)
return e
end
function HeroCtrl:AddTeamBuff(t,o,n,i,a,e)
if(self.CurrBattleTeam==nil)then
return false
end
if(t==nil)then
t=self
end
e=e or{}
if self:IsDeathState()then
e.battleStationIndex=1000
else
e.battleStationIndex=t.battleStationIndex
end
local e=self.CurrBattleTeam:AddTeamBuff(t.HeroId,o,n,i,a,e)
return e
end
function HeroCtrl:GetTeamBuff(e)
if(self.CurrBattleTeam==nil)then
return
end
return self.CurrBattleTeam:GetCurTeamBuff(e)
end
function HeroCtrl:AddOpponentTeamBuff(t,a,i,n,o,e)
if(self.CurrBattleTeam==nil or self.CurrBattleTeam.OpponentTeam==nil)then
return false
end
if(t==nil)then
t=self
end
e=e or{}
if self:IsDeathState()then
e.battleStationIndex=1000
else
e.battleStationIndex=t.battleStationIndex
end
local e=self.CurrBattleTeam.OpponentTeam:AddTeamBuff(t.HeroId,a,i,n,o,e)
return e
end
function HeroCtrl:GetAllTeamPet()
if(self.CurrBattleTeam==nil)then
return{}
end
return self.CurrBattleTeam:GetAllTeamPet()
end
function HeroCtrl:CheckBuff(t,e)
return self.HeroBattleInfo:CheckBuff(t,e)
end
function HeroCtrl:CheckSpecialBuffRound(e)
return self.HeroBattleInfo:CheckSpecialBuffRound(e)
end
function HeroCtrl:ShowOrHideBuffEffect(e,t)
if t~=true then
if self.isShowHeroCtrl==false then
return
end
end
for a,t in ipairs(self.BuffAboutEffects)do
if(not IsNil(t))then
LuaUtils.SetActive(t,e)
end
end
self.HeroBattleInfo:ShowOrHideBuffEffect(e)
end
function HeroCtrl:ShowOrHideBuffIndependEffect(e)
if self.isShowHeroCtrl==false then
return
end
self.HeroBattleInfo:ShowOrHideBuffEffect(e,true)
end
function HeroCtrl:ShowOrHideHeroExtraEffect(e)
if self.isShowHeroCtrl==false then
return
end
if not IsNil(self.heroExtraEffect)then
LuaUtils.SetActive(self.heroExtraEffect.transform,e)
end
end
function HeroCtrl:ShowOrHidePetExtraEffect(e)
if self.isShowHeroCtrl==false then
return
end
if not IsNil(self.petExtraEffect)then
LuaUtils.SetActive(self.petExtraEffect.transform,e)
end
end
function HeroCtrl:GetFinalAtk()
if self:IsPet()then
local e=w:CalculateHeroFinalAtk(self,false)
return e
else
local e=(self.HeroBattleInfo.Atk+self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.atkAdd))
*(1+a.GetBattleAttrCoe(HeroAttrId.atkRate,self.HeroBattleInfo.atkRate+a.BattleAttrClamp(HeroAttrId.atkRate,self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.atkRate))))
return e
end
end
function HeroCtrl:GetFinalDef()
if self:IsPet()then
return 0
else
local e=(self.HeroBattleInfo.Def+self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.defAdd))
*(1+a.GetBattleAttrCoe(HeroAttrId.defRate,self.HeroBattleInfo.defRate+a.BattleAttrClamp(HeroAttrId.defRate,self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.defRate))))
return e
end
end
function HeroCtrl:GetHurtValue(e,o,n,i,s,a,t)
if e:IsPet()then
return w:GetHurtValue(e,o,n,i,self,s,a,t)
else
return u:GetHurtValue(e,o,n,i,self,s,a,t)
end
end
function HeroCtrl:AddThorn(e)
if self.ImmuneThorn then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return
end
e=math.floor(e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
List.PushBack(self.WillThornHurtValueQueue,e)
end
function HeroCtrl:PlayThorn()
if(GameInit.IsClient and List.HasData(self.WillThornHurtValueQueue))then
self.HurtNumType=EBattleHurtNumType.ChangeGui
end
local e=0
while(List.HasData(self.WillThornHurtValueQueue))do
local t=List.PopFront(self.WillThornHurtValueQueue)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e=e+t
end
if e>0 then
self:RealHurt(e,nil,HeroHurtType.thorn)
end
end
function HeroCtrl:PlayThornInLogic()
if(GameInit.IsClient and List.HasData(self.WillThornHurtValueQueue))then
self.HurtNumType=EBattleHurtNumType.ChangeGui
end
local e=0
while(List.HasData(self.WillThornHurtValueQueue))do
local t=List.PopFront(self.WillThornHurtValueQueue)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e=e+t
end
if e>0 then
local t=self:CheckConsumeImmuneDamageCount()
self:RealHurtInLogic(e,nil,HeroHurtType.thorn,t)
end
end
function HeroCtrl:CheckConsumeImmuneDamageCount()
local e=false
if self.hasImmuneDamageBuff then
if f.CheckConsumeImmuneDamageCount(self)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e=true
end
end
return e
end
function HeroCtrl:AddBlood(e)
e=math.floor(e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
List.PushBack(self.WillBloodValueQueue,e)
end
function HeroCtrl:PlayBlood()
local e=self:PopTotalBlood()
if e>0 then
self:HpHealthWithBlood(e)
end
end
function HeroCtrl:PlayBloodInLogic()
local e=self:PopTotalBlood()
if e>0 then
self:HpHealthWithBloodInLogic(e)
end
self:ResetHpHealthInTimeLine()
end
function HeroCtrl:PopTotalBlood()
local e=0
while(List.HasData(self.WillBloodValueQueue))do
local t=List.PopFront(self.WillBloodValueQueue)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e=e+t
end
return e
end
function HeroCtrl:GetIsCrtRemedy()
local e=u:CalculateHeroAttackCriticalRate(self)
local n=e.attackCritical
local h=e.attackCriticalRateAddBattleBefore
local i=e.attackCriticalRateAddBattleBeforeWithHero
local r=e.attackCriticalRateAdd
local s=e.attackCriticalRateAddFinalValue
local o=e.attackCriticalRate
local e=a.BattleAttrClamp(HeroAttrId.finalCriticalRate,o*OneMillion)
local t=RandomMgr:GetBattleRandom()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then






end
if(e>t)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return true
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
function HeroCtrl:OnHeroBigSkillAttackCallBack(e)
local a=e.heroId
local t=ModulesInit.ProcedureNormalBattle.HeroDic[a]
if t then
local o={
buffTriggerTime=BuffTriggerTime.allSkillAttack
}
local a=e.triggerSkillAtkType
local e={
triggerSkillAtkType=a,
triggerSkillType=AttackType.BigSkill,
isPetTrigger=false,
skillId=e.skillId,
}
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.allSkillAttack,t,self,e,o)
end
if(a==self.HeroId)then
else
if(t==nil)then
GameInit.LogError("技能释放者 不存在 heroId %s",a)
return
end
if(t.IsOurHero==self.IsOurHero)then
local a={
buffTriggerTime=BuffTriggerTime.allSkillAttack
}
local o=e.triggerSkillAtkType
local e={
triggerSkillAtkType=o,
triggerSkillType=AttackType.BigSkill,
isPetTrigger=false,
skillId=e.skillId,
}
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.mateSkillAttack,t,self,e,a)
else
end
end
end
function HeroCtrl:OnHeroSmallSkillAttackCallBack(a)
local t=a.heroId
local e=ModulesInit.ProcedureNormalBattle.HeroDic[t]
if e then
local t=a.triggerSkillAtkType
local t={
triggerSkillAtkType=t,
triggerSkillType=AttackType.SmallSkill,
isPetTrigger=false,
skillId=a.skillId,
}
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.allSmallSkilAttack,e,self,t)
end
if(t==self.HeroId)then
else
if(e==nil)then
GameInit.LogError("技能释放者 不存在 heroId %s",t)
return
end
if(e.IsOurHero==self.IsOurHero)then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.mateSmallSkilAttack,e,self)
else
end
end
end
function HeroCtrl:OnHeroNormalAttackCallBack(e)
local t=e.heroId
local t=ModulesInit.ProcedureNormalBattle.HeroDic[t]
if t then
local a=e.triggerSkillAtkType
local e={
triggerSkillAtkType=a,
triggerSkillType=AttackType.Normal,
isPetTrigger=false,
skillId=e.skillId,
}
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.allNormalSkilAttack,t,self,e)
end
end
function HeroCtrl:OnPetFightSkillAttackCallBack(e)
local t=e.heroId
local t=ModulesInit.ProcedureNormalBattle.HeroDic[t]
if t then
local a=e.triggerSkillAtkType
local e={
triggerSkillAtkType=a,
triggerSkillType=e.triggerSkillType,
isPetTrigger=true,
skillId=e.skillId,
}
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.allPetFightSkillAttack,t,self,e)
end
end
function HeroCtrl:OnHeroSkillAttackCompleteCallBack(t)
if self.isTriggerAllSkillAttackCompleteBuffForEver then
local e=t.heroId
local e=ModulesInit.ProcedureNormalBattle.HeroDic[e]
if e then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.allHeroSkillAttackComplete,e,self,t)
end
end
end
function HeroCtrl:OnHeroBeanStatCountChangeCallBack(t)
local e=t.heroId
local e=ModulesInit.ProcedureNormalBattle.HeroDic[e]
if e then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.allHeroBeanStatCountChange,e,self,t)
end
end
function HeroCtrl:OnAnyHeroAfterSufferDmgCallBack(t)
if self.isTriggerAllSkillAttackCompleteBuffForEver then
local e=t.heroId
local e=ModulesInit.ProcedureNormalBattle.HeroDic[e]
if e then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.allHeroAfterSufferDmg,e,self,t)
end
end
end
function HeroCtrl:OnShowSpeedLineCallBack(e)
end
function HeroCtrl:OnAnyHeroSkillBeAttackCallBack(e)
local a=ModulesInit.ProcedureNormalBattle.HeroDic[e.attackHeroId]
local t=ModulesInit.ProcedureNormalBattle.HeroDic[e.beAttackHeroId]
if a and t then
local e=e
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.anyHeroSkillBeAttack,a,t,e)
end
end
function HeroCtrl:OnCameraCtrlMoveingCallBack(e)
if(not IsNil(self.HudController))then
return
end
if(IsNil(self.CurrHeadBarView)or IsNil(self.CurrHeadBarView.transform)or IsNil(self.CurrHurtNum)or IsNil(self.CurrHurtNum.transform)or IsNil(self.CurrHpHealthNum)or IsNil(self.CurrHpHealthNum.transform))then
return
end
if(e)then
if(self.battleStationRow==2)then
GameEntry.Lua:FollowHeadBarAndHud(
self:GetHearBarFollowPos(),
ModulesInit.UIGlobalManager.HeadBarContainer,
self.CurrHeadBarView.transform,
self:GetMiddlePointPos(),
ModulesInit.UIGlobalManager.HurtNumContainer,
self.CurrHurtNum.transform,
self:GetMiddlePointPos(),
ModulesInit.UIGlobalManager.HurtNumContainer,
self.CurrHpHealthNum.transform,
Vector3(0,50*CurrScreenHeightRatio,0),
self:GetMiddlePointPos(),
ModulesInit.UIGlobalManager.HurtNumContainer,
self.CurrHud.transform,
Vector3(0,-50*CurrScreenHeightRatio,0)
)
else
GameEntry.Lua:FollowHeadBarAndHud(
self:GetHearBarFollowPos(),
ModulesInit.UIGlobalManager.HeadBarContainer,
self.CurrHeadBarView.transform,
self:GetLegPointPos(),
ModulesInit.UIGlobalManager.HurtNumContainer,
self.CurrHurtNum.transform,
self:GetLegPointPos(),
ModulesInit.UIGlobalManager.HurtNumContainer,
self.CurrHpHealthNum.transform,
Vector3(0,50*CurrScreenHeightRatio,0),
self:GetMiddlePointPos(),
ModulesInit.UIGlobalManager.HurtNumContainer,
self.CurrHud.transform,
Vector3(0,-50*CurrScreenHeightRatio,0)
)
end
end
end
function HeroCtrl:ShowHudText(e,t)
if(self.CurrHud)then
self.CurrHud:ShowText(e,GameTools.GetLocalize(t,LanguageCategory.LangBattle))
end
end
function HeroCtrl:ShowTreatureText(t)
if(self.CurrTreasureContainer)then
local e=self:GetMiddlePointPos()
if e then
local e=Vector3(e.x,e.y+0.5,e.z)
GameEntry.Lua:FollowTarget(e,ModulesInit.UIGlobalManager.HurtNumContainer,self.CurrTreasureContainer.transform)
self.CurrTreasureContainer:Refresh(t)
self.treatureTipShowStartTime=Time.realtimeSinceStartup
end
end
end
function HeroCtrl:CheckBattleRoundBigAndSmallSkillStatus()
if ModulesInit.ProcedureNormalBattle.IsSkipBattle==true then
return
end
if(not ModulesInit.ProcedureNormalBattle.GetIsOurTeamAttack())then
return
end
if(self.HeroHeadItem==nil)then
return
end
if ModulesInit.ProcedureNormalBattle.BattleRounding==false then
self.HeroHeadItem:HideAllEffectStatusAndShowMask()
return
end
local t=self:GetCanBigAttack()
local e=self:GetCanNormalAttack(false)
if(not t and not e)then
self.HeroHeadItem:HideAllEffectStatusAndShowMask()
return
end
if(t and self.CurrRoundCanTriggerSmallSkill)then
self.HeroHeadItem:SetEffectStatus(HeroHeadItemTriggerEffectType.All)
elseif(t)then
self.HeroHeadItem:SetEffectStatus(HeroHeadItemTriggerEffectType.BigSkill)
elseif(e and self.CurrRoundCanTriggerSmallSkill)then
self.HeroHeadItem:SetEffectStatus(HeroHeadItemTriggerEffectType.SmallSkill)
elseif(e)then
self.HeroHeadItem:SetEffectStatus(HeroHeadItemTriggerEffectType.NormalSkill)
end
end
function HeroCtrl:SetHeadIconTipScale(e)
if(self.HeroHeadItem==nil)then
return
end
self.HeroHeadItem:SetHeadIconTipScale(e)
end
function HeroCtrl:OnBattleHeroDeath(e)
if(self.FirstAtkSelfHeroId==e)then
self.FirstAtkSelfHeroId=0
end
if(self.HeroId==e)then
return
end
local e=ModulesInit.ProcedureNormalBattle.HeroDic[e]
if(e~=nil)then
if(self.CurrBattleTeam and e.CurrBattleTeam)then
if(self.CurrBattleTeam.TeamId==e.CurrBattleTeam.TeamId)then
if self:IsStakeFightOpenNewFury()==false then
self:AddFuryWithSoul(SoulAddFuryType.deadRage)
end
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.teamHeroDead,self,e,e)
else
if self:IsStakeFightOpenNewFury()==false then
self:AddFuryWithSoul(SoulAddFuryType.killRage)
end
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.enemyTeamHeroDead,self,e,e)
end
end
end
end
function HeroCtrl:OnBattleHeroFakeDeath(e)
local e=ModulesInit.ProcedureNormalBattle.HeroDic[e]
if(e~=nil)then
if(self.CurrBattleTeam and e.CurrBattleTeam)then
if(self.CurrBattleTeam.TeamId==e.CurrBattleTeam.TeamId)then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.teamHeroFakeDead,self,e,e)
else
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.enemyTeamHeroFakeDead,self,e,e)
end
end
end
end
function HeroCtrl:OnBattleHeroFatalDmgBefore(e)
local e=ModulesInit.ProcedureNormalBattle.HeroDic[e]
if(e~=nil)then
if(self.CurrBattleTeam and e.CurrBattleTeam)then
if(self.CurrBattleTeam.TeamId==e.CurrBattleTeam.TeamId)then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.teamHeroFatalDmgBefore,self,e,e)
else
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.enemyTeamHeroFatalDmgBefore,self,e,e)
end
end
end
end
function HeroCtrl:OnBattleHeroLockHp(e)
if self.isTriggerAllHeroLockHpForEver then
local e=ModulesInit.ProcedureNormalBattle.HeroDic[e]
if(e~=nil)then
if(self.CurrBattleTeam and e.CurrBattleTeam)then
if(self.CurrBattleTeam.TeamId==e.CurrBattleTeam.TeamId)then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.teamHeroLockHp,self,e,e)
else
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.enemyTeamHeroLockHp,self,e,e)
end
end
end
end
end
function HeroCtrl:OnBattleHeroAddBuff(e)
local a=ModulesInit.ProcedureNormalBattle.HeroDic[e.releaseHeroId]
local t=ModulesInit.ProcedureNormalBattle.HeroDic[e.buffHeroId]
if a and t then
self.HeroBattleInfo:TriggerBuff(BuffTriggerTime.addBuff,a,t,e)
end
end
function HeroCtrl:AddFirstAtkOtherHeroEffect()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
local e=self:GetPointPosWithType(HeroPointType.HeadPoint)
GameEntry.Effect:ShowBuffEffect(
SysPrefabId.FirstAtkOtherHeroEffect,
0,
0,
e.x,
e.y,
e.z,
nil,
function(t,e,t)
self.FirstAtkOtherHeroEffect=e
self.FirstAtkOtherHeroEffect:SetParent(self.spineboyTransform)
end
)
end
function HeroCtrl:RemoveFirstAtkOtherHeroEffect()
if(not IsNil(self.FirstAtkOtherHeroEffect))then
GameEntry.Pool:GameObjectDespawn(self.FirstAtkOtherHeroEffect)
self.FirstAtkOtherHeroEffect=nil
end
end
function HeroCtrl:CanExplosiveHero()
if(self.HasBeenExplosive)then
return false
end
for t,e in ipairs(self.HeroBattleInfo.underWearSuits)do
local e=a:GetUnderwearSuitCfg(e.suitDid)
if(e)then
local t=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound%2==1 and 1 or 2
if(e.liberateType==t)then
return true
end
end
end
if(List.HasData(self.SaveExplosiveData))then
return true
end
return false
end
function HeroCtrl:Explosive(e)
if(self.HasBeenExplosive)then
return
end
if self.HeroHeadItem then
self.HeroHeadItem:ShowExplosiveEffect()
end
local t=self:GetFootPointPos()
self.canExplosiveSuit=false
self.needExplosiveSuit={}
for e,o in ipairs(self.HeroBattleInfo.underWearSuits)do
local e=a:GetUnderwearSuitCfg(o.suitDid)
if(e)then
local a=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound%2==1 and 1 or 2
if(e.liberateType==a)then
self.canExplosiveSuit=true
if(e.buff>0)then
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local a=SysPrefabId.ExplosiveHeroEffect
if(e.explosive_prefabId>0)then
a=e.explosive_prefabId
end
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(a,t.x,t.y,t.z,3,0,false,function()
end)
end
local t=3096
if(e.explosive_buff>0)then
t=e.explosive_buff
end
self:AddBuff(self,t,1,nil)
local t=e["args"..tostring(o.star)]
self:AddBuff(self,e.buff,1,table.deepCopy(t))
table.insert(self.needExplosiveSuit,e)
end
end
end
end
table.sort(self.needExplosiveSuit,function(t,e)
if t.suitNum~=e.suitNum then
return t.suitNum<e.suitNum
end
return t.id<e.id
end)
end
function HeroCtrl:ExplosiveAfter(e)
if(self.HasBeenExplosive)then
return
end
local e=#self.needExplosiveSuit
if(e~=0)then
for e=1,e do
local e=self.needExplosiveSuit[e]
local t=ModulesInit.BattleBuffMgr.GetBuffScript(e.buff)
if(t)then
local e=self.HeroBattleInfo:GetBuff(e.buff)
if e then
if(e.isExec==false)then
if e:GetCanTrigger(BuffTriggerTime.after)then
e:DoAction(BuffTriggerTime.after)
end
end
end
end
end
end
end
function HeroCtrl:ExplosiveAfter2(o)
if(self.HasBeenExplosive)then
return
end
local e=#self.needExplosiveSuit
if(e~=0)then
for e=1,e do
local e=self.needExplosiveSuit[e]
local t=ModulesInit.BattleBuffMgr.GetBuffScript(e.buff)
if(t)then
local e=self.HeroBattleInfo:GetBuff(e.buff)
if e then
if(e.isExec==false)then
if e:GetCanTrigger(BuffTriggerTime.after2)then
e:DoAction(BuffTriggerTime.after2)
end
end
end
end
end
end
if(not self.canExplosiveSuit)then
local e=List.PopFront(self.SaveExplosiveData)
if(e)then
for e,t in ipairs(e)do
local e=a:GetUnderwearSuitCfg(t.suitDid)
self.canExplosiveSuit=true
if(e.buff>0)then
self:AddBuff(self,3096,1,nil)
local t=e["args"..tostring(t.star)]
self:AddBuff(self,e.buff,1,t)
end
end
end
end
if(self.canExplosiveSuit)then
self.HasBeenExplosive=true
if(ModulesInit.ProcedureNormalBattle.FightPlayData==nil)then
FightDataReportMgr:AddBattleAction(self.HeroId,0,3)
end
if(o)then
if(not ModulesInit.ProcedureNormalBattle.CurrAttackTeam:CheckHasCanExplosiveHero())then
local e=ModulesInit.TimeActionMgr.CreateTimeAction()
self:AddTimer(e)
e:Init(
0,
1,
1,
nil,
nil,
function()
self:RemoveTimer(e)
ModulesInit.ProcedureNormalBattle.BattleRoundExplosiveComplete()
end
):Run()
end
end
end
end
function HeroCtrl:CancelExplosive()
if(self.HasBeenExplosive)then
return
end
local t=false
for o,e in ipairs(self.HeroBattleInfo.underWearSuits)do
local e=a:GetUnderwearSuitCfg(e.suitDid)
if(e)then
local a=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound%2==1 and 1 or 2
if(e.liberateType==a)then
t=true
end
end
end
if(t)then
if(ModulesInit.ProcedureNormalBattle.FightPlayData==nil)then
FightDataReportMgr:AddBattleAction(self.HeroId,0,4)
end
List.PushBack(self.SaveExplosiveData,self.HeroBattleInfo.underWearSuits)
end
end
function HeroCtrl:IsFirstRowHero()
if(self.CurrBattleTeam:HasFirstRowHero()==false)then
return true
end
return self.battleStationRow==1
end
function HeroCtrl:IsLastRowHero()
if(self.CurrBattleTeam:HasLastRowHero()==false)then
return true
end
return self.battleStationRow==2
end
function HeroCtrl:IsRealFirstRowHero()
return self.battleStationRow==1
end
function HeroCtrl:IsRealLastRowHero()
return self.battleStationRow==2
end
function HeroCtrl:ShowOrHideSpecialEffect(e)
if self.isShowHeroCtrl==false then
return
end
if(not IsNil(self.FirstAtkOtherHeroEffect))then
LuaUtils.SetActive(self.FirstAtkOtherHeroEffect,e)
end
end
function HeroCtrl:ShowOrHideHurtNUm(e)
if self.isShowHeroCtrl==false then
return
end
if(not IsNil(self.CurrHurtNum))then
LuaUtils.SetActive(self.CurrHurtNum.transform,e)
end
end
function HeroCtrl:ShowOrHideHpHealthNUm(e)
if self.isShowHeroCtrl==false then
return
end
if(not IsNil(self.CurrHpHealthNum))then
LuaUtils.SetActive(self.CurrHpHealthNum.transform,e)
end
end
function HeroCtrl:AddTotalDamage(e)
if(e and e>0)then
self.TotalDamage=self.TotalDamage+e
self:SetTotalDamageInBigRound(e)
end
end
function HeroCtrl:AddTotalBear(e)
if(e and e>0)then
self.TotalBear=self.TotalBear+e
end
end
function HeroCtrl:AddTotalTreatment(e)
if(e and e>0)then
self.TotalTreatment=self.TotalTreatment+e
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
function HeroCtrl:AddControllRate(e)
if(e and e>0)then
self.TotalControllRate=self.TotalControllRate+e
end
end
function HeroCtrl:AddBuffAboutEffects(e)
table.add(self.BuffAboutEffects,e)
end
function HeroCtrl:DisposeBuffAboutEffects()
for t,e in ipairs(self.BuffAboutEffects)do
if not IsNil(e)then
GameEntry.Pool:GameObjectDespawn(e)
end
end
self.BuffAboutEffects={}
end
function HeroCtrl:IsUsualStateWithCheckKill()
return self.CurrFsm.curStateEnum~=HeroState.Freeze
and self.CurrFsm.curStateEnum~=HeroState.DyingState
and self.CurrFsm.curStateEnum~=HeroState.UnDead
and self.ImmuneNormalAndSmallSkill==false
and(self.WillNotUsual==false)
and self.immuneDamageWithConsume==false
and self.resistFatalDamage==false
end
function HeroCtrl:IsUsualState()
if(self:IsSuperUnUsualState()or self.CurrFsm.curStateEnum==HeroState.Leave)then
return false
end
return true
end
function HeroCtrl:IsSuperUnUsualState()
if(self.CurrFsm.curStateEnum==HeroState.Freeze or self.CurrFsm.curStateEnum==HeroState.DyingState
or self.CurrFsm.curStateEnum==HeroState.UnDead)then
return true
end
return false
end
function HeroCtrl:IsLeaveStateOrType()
if(self.CurrFsm.curStateEnum==HeroState.Leave or self.NotUsualType==HeroState.Leave)then
return true
end
return false
end
function HeroCtrl:IsLeaveState()
if(self.CurrFsm.curStateEnum==HeroState.Leave)then
return true
end
return false
end
function HeroCtrl:IsLeaveType()
if(self.NotUsualType==HeroState.Leave)then
return true
end
return false
end
function HeroCtrl:IsNothingToDoState()
if self:IsDeathOrWaitState()or self:IsHeroSpecialState()then
return true
end
return false
end
function HeroCtrl:IsDeathOrWaitState()
if self:IsDeathWaitState()or self:IsDeathState()then
return true
end
return false
end
function HeroCtrl:IsDeathWaitState()
if(self.CurrFsm.curStateEnum==HeroState.DeathWait)then
return true
end
return false
end
function HeroCtrl:ChangeDeathWaitState()
self:ChangeStateUnCheckState(HeroState.DeathWait)
end
function HeroCtrl:IsNotUsualState()
return self.CurrFsm.curStateEnum==HeroState.Freeze or self.CurrFsm.curStateEnum==HeroState.DyingState or self.CurrFsm.curStateEnum==HeroState.UnDead or self.CurrFsm.curStateEnum==HeroState.Leave
end
function HeroCtrl:IsNotUsualType()
return self.NotUsualType==HeroState.Freeze or self.NotUsualType==HeroState.DyingState or self.NotUsualType==HeroState.UnDead or self.NotUsualType==HeroState.Leave
end
function HeroCtrl:IsNotUsualStateOrType()
return self:IsNotUsualState()or self:IsNotUsualType()
end
function HeroCtrl:GetIsRunningToBattle()
return self.isRunningToBattle
end
function HeroCtrl:AddImmuneBuff(e)
table.add(self.ImmuneBuffList,e)
end
function HeroCtrl:IsImmuneBuff(t)
for a,e in ipairs(self.ImmuneBuffList)do
if(e==t)then
return true
end
end
return false
end
function HeroCtrl:RemoveImmuneBuff(e)
for t,a in ipairs(self.ImmuneBuffList)do
if(a==e)then
table.remove(self.ImmuneBuffList,t)
return
end
end
end
function HeroCtrl:JudgeSkillPreView(e)
local t=nil
if ModulesInit.ProcedureNormalBattle.IsPVE()then
t=e.args
if self.DTMonsterRow and e.monsterType and e.monsterArgs then
for a=1,#e.monsterType do
if e.monsterType[a]==ModulesInit.ProcedureNormalBattle.BattleType then
t=e.monsterArgs
break
end
end
end
else
t=e.argsPvp
end
return t
end
function HeroCtrl:JudgeSkillPassPreView(e)
return e.args
end
function HeroCtrl:ShowHeroIconBigSkillState()
if self.HeroHeadItem then
self.HeroHeadItem:LongPress()
end
end
function HeroCtrl:HideHeadMask()
if self.HeroHeadItem then
self.HeroHeadItem:HideHeadMask()
end
end
function HeroCtrl:SetHeroPlayAttackLimit(e)
if self.HeroHeadItem then
self.HeroHeadItem:SetHeroPlayAttackLimit(e)
end
end
function HeroCtrl:SetRoundCanTriggerSmallSkill(e)
self.CurrRoundCanTriggerSmallSkill=e
self:CheckBattleRoundBigAndSmallSkillStatus()
end
function HeroCtrl:SetTriggerSmallSkillStatus(e)
if e~=0 then
self.ForbidSmallSkill=false
self.CertainlyTriggerSmallSkillRound=e
else
self.ForbidSmallSkill=true
end
end
function HeroCtrl:SetChaChaSureSmallSkill(e)
self.CurrRoundCanTriggerSmallSkill=e
self:CheckBattleRoundBigAndSmallSkillStatus()
end
function HeroCtrl:SetAlwaysHide(e)
if self.isShowHeroCtrl==false then
return
end
if self.CurrHeadBarView then
self.CurrHeadBarView:AlwaysHide(e)
end
end
function HeroCtrl:PlayDyingAnimInTimeLine(e)
if(IsNil(self.spineboy))then
return
end
if e==nil then
e=true
end
self:RestoreSkinShow()
if ModulesInit.ProcedureNormalBattle.IsPlayHeroDyingAudio==true then
local e=self:GetHeroPreviewDeadState()
if e==ModulesInit.BattlePreviewMgr.EHeroDeadState.KneelOnDieAndAudio then
local e=self:GetHeroModelId()
UIUtil.PlayHeroDeadVoice(e)
end
end
if ModulesInit.ProcedureNormalBattle.IsHideHeadBarOnDying==true then
self:SetAlwaysHide(true)
end
local e=self:SetSpineAnimation(0,"wait",e)
if(e)then
local e=e.Animation.Duration
local e=Time.time+e
if(e>ModulesInit.ProcedureNormalBattle.DyingStateHeroLastTime)then
ModulesInit.ProcedureNormalBattle.DyingStateHeroLastTime=e
end
end
end
function HeroCtrl:ShowHeroAndEffectAndHideOther()
if(IsNil(self.spineboy))then
return
end
self:SetHeroShowCtrlFlag(false)
self:ShowHero(false)
self:SetHeroShowCtrl(false)
end
function HeroCtrl:CheckPlayUndeadAnimInTimeLine(e,t)
if e==true then
self:PlayDyingAnimInTimeLine(t)
else
self:PlayUndeadAnimInTimeLine()
end
end
function HeroCtrl:PlayUndeadAnimInTimeLine()
if(IsNil(self.spineboy))then
return
end
self:RestoreSkinShow()
self:ShowHeroEffect(false)
self:SetHeroShowCtrlFlag(false)
local e=self:SetSpineAnimation(0,"disappear",false)
if(e)then
local t=e.Animation.Duration
local e=Time.time+t
if(e>ModulesInit.ProcedureNormalBattle.DyingStateHeroLastTime)then
ModulesInit.ProcedureNormalBattle.DyingStateHeroLastTime=e
end
local e=ModulesInit.TimeActionMgr.CreateTimeAction()
self:AddTimer(e)
e:Init(
0,
t,
1,
nil,
nil,
function()
self:RemoveTimer(e)
if self.NotUsualType==HeroState.UnDead or self.CurrFsm.curStateEnum==HeroState.UnDead then
self:SetHeroShowCtrl(true)
self:ShowHero(false)
self:SetHeroShowCtrl(false)
end
end
):Run()
end
end
function HeroCtrl:CheckPlayUndead2AnimInTimeLine(e,t)
if e==true then
self:PlayDyingAnimInTimeLine(t)
else
self:PlayUndead2AnimInTimeLine()
end
end
function HeroCtrl:PlayUndead2AnimInTimeLine()
if(IsNil(self.spineboy))then
return
end
self:RestoreSkinShow()
self:ShowHeroEffect(false)
self:ShowOrHideHeroExtraEffect(false)
self:SetHeroShowCtrlFlag(false)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=self:GetMiddlePointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.BattleJejmsOutEffect,e.x,e.y,50,3,0,false,function()
end)
end
local e=self:SetSpineAnimation(0,"disappear",true)
end
function HeroCtrl:CheckPlayFreezeAnimInTimeLine(e,t)
if e==true then
self:PlayDyingAnimInTimeLine(t)
else
self:PlayFreezeAnimInTimeLine()
end
end
function HeroCtrl:PlayFreezeAnimInTimeLine()
if(IsNil(self.spineboy))then
return
end
self:RestoreSkinShow()
local e=self:SetSpineAnimation(0,"death2",true,EBattleHeroTargetType.HERO)
local e=self:SetSpineAnimation(0,"death2",false,EBattleHeroTargetType.PET)
if(e)then
local e=e.Animation.Duration
local e=Time.time+e
if(e>ModulesInit.ProcedureNormalBattle.DyingStateHeroLastTime)then
ModulesInit.ProcedureNormalBattle.DyingStateHeroLastTime=e
end
end
end
function HeroCtrl:CheckPlayStandAnimInTimeLine(e,t)
if e==true then
self:PlayDyingAnimInTimeLine(t)
else
self:PlayStandAnimInTimeLine()
end
end
function HeroCtrl:PlayStandAnimInTimeLine()
if(IsNil(self.spineboy))then
return
end
self:SetSpineAnimation(0,"stand",true)
end
function HeroCtrl:CheckPlayDeadAnimInTimeLine(e,t)
if e==true then
self:PlayDyingAnimInTimeLine(t)
else
self:PlayDeadAnimInTimeLine(false)
end
end
function HeroCtrl:PlayIceAnimInTimeLine()
if(IsNil(self.spineboy))then
return
end
self:RestoreSkinShow()
self:HideHero()
self:SetHeroShowCtrlFlag(true)
local e=self.HeroBattleInfo:GetBuff(self.mPreviewHeroSpecialStateBuffId)
if e then
e:PlayBuffPrefabEffect(EBuffEffectType.custom)
end
self:SetAlwaysHide(false)
self:RestoreHeadBarView()
self:ShowOrHideBuffIndependEffect(true)
self:SetHeroShowCtrlFlag(false)
end
function HeroCtrl:PlayDeadAnimInTimeLine(i)
if self:IsIceSpecialState()then
return
end
local o=self.AnimLenDic["death"]
self.heroDeadTime=Time.time+o
if(self.CurrHeadBarView)then
self.CurrHeadBarView:ChangeAlpha(0)
self:SetAlwaysHide(true)
end
if(IsNil(self.spineboy))then
return
end
self:RestoreSkinShow()
if self.HeroBattleInfo:HasControlFlyBuff()==false then
self:SetSpineAnimation(0,"death",false)
end
self:StopDelaySequence()
local t=CS.DG.Tweening.DOTween.Sequence()
t:AppendInterval(o/2)
t:AppendCallback(function()
local t=self:GetFootPointPos()
local a=self:GetDeathEffectScale()or 1
if t~=nil then
local e=e:GetHeroDeathEffect(self.heroDid)
if e>0 then
GameEntry.Effect:ShowEffectPro(e,EffectKeepType.AutoRelease,t.x,t.y,t.z,a,a,a)
end
end
if i~=false then
EventSystem.SendEvent(CommonEventId.OnBattleHeroDeathTimeline,self.HeroId)
end
end)
t:AppendInterval(o/2)
t:AppendCallback(function()
LuaUtils.SetActive(self.CurrSkinTransform,false)
self.IsDeadInAnim=true
self:SetShowShadow(false)
end)
self.mDelaySequence=t
end
function HeroCtrl:StopDelaySequence()
if self.mDelaySequence~=nil then
self.mDelaySequence:Kill()
self.mDelaySequence=nil
end
end
function HeroCtrl:DelayPlayBuffEffect(t,a)
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(t)
e:AppendCallback(function()
self.HeroBattleInfo:PlayBattleEffectWithBuffId(a)
end)
self:AddTweener(e)
end
function HeroCtrl:AddTweener(e)
table.insert(self.mDelayPlayBuffEffectSequenceArr,e)
end
function HeroCtrl:KillAllTweener()
for t,e in pairs(self.mDelayPlayBuffEffectSequenceArr)do
if(e)then
e:Kill()
end
end
self.mDelayPlayBuffEffectSequenceArr={}
end
function HeroCtrl:CheckHpHealthByDispelBuff(t)
if self.HeroBattleInfo==nil then
return
end
local e=self.HeroBattleInfo:GetBuff(30103301)
if(e and t>0)then
local a=e:GetBuffData()
local o=a[1]*MillionCoe
local t=self.HeroBattleInfo.MaxHP*o*t
self:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
local e=a[2]
if e and e>0 then
self:AddFuryWithBuff(e)
end
end
end
function HeroCtrl:GetBigAttack()
local e=0
if(self.NextBigSkillId>0)then
e=self.NextBigSkillId
elseif self.attackTask then
local t=self.attackTask.skillDid
if t then
e=t
end
end
if e==0 then
e=self.BigSkillId
end
return e
end
function HeroCtrl:GetBuffEffectData(e)
local e=self.mBuffEffectMap[e]
return e
end
function HeroCtrl:GetOrCreateBuffEffectData(t)
local e=self:GetBuffEffectData(t)
if e==nil then
e={
prefabId=t,
buffMap={},
buffEffectTrans=nil,
delayRemoveEffectSequenceMap={},
}
self:SetBuffEffectData(t,e)
end
return e
end
function HeroCtrl:SetBuffEffectData(t,e)
self.mBuffEffectMap[t]=e
end
function HeroCtrl:RemoveBuffEffectByBuffId(a,e)
local t=self:GetBuffEffectData(e)
if t then
local t=t.buffMap
t[a]=nil
if#table.keys(t)<=0 then
self:RemoveBuffEffectByPrefabId(e)
end
end
end
function HeroCtrl:RemoveAllBuffEffectTrans()
for e,t in pairs(self.mBuffEffectMap)do
self:RemoveBuffEffectByPrefabId(e)
end
self.mBuffEffectMap={}
self:DestroyTestBuffEffectTrans()
end
function HeroCtrl:RemoveBuffEffectByPrefabId(t)
local e=self:GetBuffEffectData(t)
if e then
if IsNil(e.buffEffectTrans)==false then
GameEntry.Pool:GameObjectDespawn(e.buffEffectTrans,false)
LuaUtils.SetLocalPos(e.buffEffectTrans,0,0,0)
LuaUtils.SetLocalEulerAngles(e.buffEffectTrans,0,0,0)
LuaUtils.SetLocalScale(e.buffEffectTrans,1,1,1)
self:DoSpecialBuffEffect(e.buffEffectTrans,"Dispose")
e.buffEffectTrans=nil
end
self:StopAllDelayRemoveEffectSequence(e)
self.mBuffEffectMap[t]=nil
end
end
function HeroCtrl:AddImmunneBuffId(e)
if self.HeroBattleInfo then
self.HeroBattleInfo:AddImmunneBuffId(e)
end
end
function HeroCtrl:ReduceImmunneBuffId(e)
if self.HeroBattleInfo then
self.HeroBattleInfo:ReduceImmunneBuffId(e)
end
end
function HeroCtrl:CheckAddBuffEffect(n,e,t,o)
if(e>0)then
local a=e
local e=self:GetOrCreateBuffEffectData(a)
e.buffMap[n]=true
if IsNil(e.buffEffectTrans)==false then
self:AfterAddBuffEffect(n,e,t)
if o then
o()
end
else
local i=self:GetPointPosWithType(t.buffPosition)+Vector3(t.buffOffsetX,t.buffOffsetY,-0.5)
self.effectType=t.effectType
GameTools:PoolGameObjectSpawn(
a,
nil,
function(s,e,e)
local e=self:GetOrCreateBuffEffectData(a)
if e then
local t=e.buffEffectTrans
if IsNil(e.buffEffectTrans)==false then
GameEntry.Pool:GameObjectDespawn(t,false)
e.buffEffectTrans=nil
t=nil
end
end
if(self.heroId==0 or self.heroDid==0 or self.spineboyTransform==nil)then
return
end
e.buffEffectId=a
e.buffEffectTrans=s
if t.buffPosition==HeroPointType.OurTeamCenter
or t.buffPosition==HeroPointType.EnemyTeamCenter then
elseif t.buffPosition==HeroPointType.HeroRootFootPoint then
e.buffEffectTrans:SetParent(self.HeroRoot.transform)
else
e.buffEffectTrans:SetParent(self.spineboyTransform)
end
LuaUtils.SetPos(e.buffEffectTrans,i.x,i.y,i.z)
if(t.mirror==1)then
local t=false
if ModulesInit.ProcedureNormalBattle:GetMirrorScaleX()==-1 then
if(self.IsOurHero)then
t=true
end
else
if(not self.IsOurHero)then
t=true
end
end
if t==true then
local t=e.buffEffectTrans.localScale
t.x=t.x*-1
e.buffEffectTrans.localScale=t
end
end
self:AfterAddBuffEffect(n,e,t)
if o then
o()
end
end
)
end
end
end
function HeroCtrl:DoSpecialBuffEffectWithPrefabId(e,a,t)
local e=self:GetBuffEffectData(e)
if e and IsNil(e.buffEffectTrans)==false then
self:DoSpecialBuffEffect(e.buffEffectTrans,a,t)
end
end
function HeroCtrl:DoSpecialBuffEffect(e,a,t)
if e==nil then
return
end
local e=e:GetComponent(typeof(CS.YouYou.LuaSprite))
if not IsNil(e)then
e:DoAction(a,t)
end
end
function HeroCtrl:AfterAddBuffEffect(t,e,o)
if(o.keepType==1)then
self:StopDelayRemoveEffectSequence(e,t)
local a=CS.DG.Tweening.DOTween.Sequence()
a:AppendInterval(o.keepTime)
a:AppendCallback(function()
e.delayRemoveEffectSequenceMap[t]=nil
self:RemoveBuffEffectByBuffId(t,e.prefabId)
end)
e.delayRemoveEffectSequenceMap[t]=a
end
end
function HeroCtrl:StopDelayRemoveEffectSequence(e,t)
if e and e.delayRemoveEffectSequenceMap[t]~=nil then
e.delayRemoveEffectSequenceMap[t]:Kill()
e.delayRemoveEffectSequenceMap[t]=nil
end
end
function HeroCtrl:StopAllDelayRemoveEffectSequence(e)
if e and e.delayRemoveEffectSequenceMap then
for a,t in pairs(e.delayRemoveEffectSequenceMap)do
t:Kill()
t=nil
end
e.delayRemoveEffectSequenceMap={}
end
end
function HeroCtrl:IsSkillAfterActionRunning(t)
for e=1,#self.SkillAfterActions do
local e=self.SkillAfterActions[e]
if e.skillActionType==t and e.success==true then
return true
end
end
return false
end
function HeroCtrl:AddSkillUseCount(e)
if type(e)~="number"then
return
end
local t=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
if self.skillUseRecordMap[t]==nil then
self.skillUseRecordMap[t]={}
end
table.insert(self.skillUseRecordMap[t],e)
if self.skillUseCountMap[e]==nil then
self.skillUseCountMap[e]=1
else
self.skillUseCountMap[e]=self.skillUseCountMap[e]+1
end
end
function HeroCtrl:GetSkillUseCount(e)
return self.skillUseCountMap[e]or 0
end
function HeroCtrl:GetAllSkillUseCountExludeAttachSkill()
local n=0
local i=0
local o=0
local a=0
for t,s in pairs(self.skillUseCountMap)do
local t=e:GetSkillActData(t)
if t then
if e:IsDependAtkType(t.atkType)==false then
if t.type==AttackType.BigSkill then
i=i+1
elseif t.type==AttackType.SmallSkill then
o=o+1
elseif t.type==AttackType.Normal then
a=a+1
end
n=n+s
end
end
end
return n,i,o,a
end
function HeroCtrl:ForceShowHero()
self:SetHeroShowCtrl(true)
self:ShowHero(true)
self:RefreshHP()
self:RefreshFury()
self:RefreshHeroHud()
end
function HeroCtrl:SetHeroShowCtrl(e)
self.isShowHeroCtrl=e
if GameInit.IsClient then
if not IsNil(self.CurrSkinTransform)then
LuaUtils.SetActive(self.CurrSkinTransform,e)
end
if not IsNil(self.CurrPetTransform)then
LuaUtils.SetActive(self.CurrPetTransform,self.isShowHeroCtrl and self.isShowHeroPetCtrl)
end
end
end
function HeroCtrl:SetHeroShowCtrlFlag(e)
self.isShowHeroCtrl=e
end
function HeroCtrl:SetHeroPetShowCtrl(e)
self.isShowHeroPetCtrl=e
if GameInit.IsClient then
if not IsNil(self.CurrPetTransform)then
LuaUtils.SetActive(self.CurrPetTransform,self.isShowHeroCtrl and self.isShowHeroPetCtrl)
end
end
end
function HeroCtrl:SetHeroHeadBarShowCtrl(e)
self.isShowHeroHeadBar=e
self:CheckShowHeadBar()
end
function HeroCtrl:ShowHero(e)
self:SetSpineInvisible(e==false)
self:ShowHeroEffect(e)
end
function HeroCtrl:ShowHeroEffect(e)
if GameInit.IsClient then
if e then
self:CheckShowShadow()
self:CheckShowHeadBar()
self:ShowOrHideBuffEffect(true)
self:ShowOrHideSpecialEffect(true)
self:ShowOrHideHurtNUm(true)
self:ShowOrHideHpHealthNUm(true)
else
self:SetShowShadow(false)
self:SetAlwaysHide(true)
self:ShowOrHideBuffEffect(false)
self:ShowOrHideSpecialEffect(false)
self:ShowOrHideHurtNUm(false)
self:ShowOrHideHpHealthNUm(false)
end
end
end
function HeroCtrl:CheckShowShadow()
if not self.hideShadow then
self:SetShowShadow(true)
else
self:SetShowShadow(false)
end
end
function HeroCtrl:SetShowShadow(e)
if self.isShowHeroCtrl==false then
return
end
if not IsNil(self.shadowRenderer)then
LuaUtils.SetActive(self.shadowRenderer.transform,e)
end
end
function HeroCtrl:CheckShowHeadBar()
if self.isShowHeroHeadBar==false or self.hideBar or ModulesInit.ProcedureNormalBattle.showHeadBar==false then
self:SetAlwaysHide(true)
else
self:SetAlwaysHide(false)
end
end
function HeroCtrl:SetAllHeroWeaponShow()
if self.isShowHeroCtrl==false then
return
end
if GameInit.IsClient then
if not IsNil(CS.MyCommonEnum.WeaponFollow)then
self:SetHeroWeaponShow(CS.MyCommonEnum.WeaponFollow.weapon_follow_1,false)
self:SetHeroWeaponShow(CS.MyCommonEnum.WeaponFollow.weapon_follow_2,false)
self:SetHeroWeaponShow(CS.MyCommonEnum.WeaponFollow.weapon_follow_3,false)
self:SetHeroWeaponShow(CS.MyCommonEnum.WeaponFollow.weapon_follow_4,false)
self:SetHeroWeaponShow(CS.MyCommonEnum.WeaponFollow.weapon_follow_5,false)
end
end
end
function HeroCtrl:SetHeroWeaponShow(t,a,e)
if self.isShowHeroCtrl==false then
return
end
e=e or EBattleHeroTargetType.All
if e==EBattleHeroTargetType.HERO or e==EBattleHeroTargetType.All then
local e=self:GetHeroWeapon(t)
if not IsNil(e)then
LuaUtils.SetActive(e.transform,a)
end
end
if e==EBattleHeroTargetType.PET or e==EBattleHeroTargetType.All then
local e=self:GetHeroPetWeapon(t)
if not IsNil(e)then
LuaUtils.SetActive(e.transform,a)
end
end
end
function HeroCtrl:GetHeroWeapon(e)
if GameInit.IsClient then
if not IsNil(CS.MyCommonEnum.WeaponFollow)then
if e==CS.MyCommonEnum.WeaponFollow.weapon_follow_1 then
return self.weaponTrans_1
elseif e==CS.MyCommonEnum.WeaponFollow.weapon_follow_2 then
return self.weaponTrans_2
elseif e==CS.MyCommonEnum.WeaponFollow.weapon_follow_3 then
return self.weaponTrans_3
elseif e==CS.MyCommonEnum.WeaponFollow.weapon_follow_4 then
return self.weaponTrans_4
elseif e==CS.MyCommonEnum.WeaponFollow.weapon_follow_5 then
return self.weaponTrans_5
end
end
end
return nil
end
function HeroCtrl:GetHeroPetWeapon(e)
if GameInit.IsClient then
if not IsNil(CS.MyCommonEnum.WeaponFollow)then
if e==CS.MyCommonEnum.WeaponFollow.weapon_follow_1 then
return self.pet_weaponTrans_1
elseif e==CS.MyCommonEnum.WeaponFollow.weapon_follow_2 then
return self.pet_weaponTrans_2
elseif e==CS.MyCommonEnum.WeaponFollow.weapon_follow_3 then
return self.pet_weaponTrans_3
elseif e==CS.MyCommonEnum.WeaponFollow.weapon_follow_4 then
return self.pet_weaponTrans_4
elseif e==CS.MyCommonEnum.WeaponFollow.weapon_follow_5 then
return self.pet_weaponTrans_5
end
end
end
return nil
end
function HeroCtrl:SetForceAttackHeroId(e,t)
self.forceAttackHeroId=e
end
function HeroCtrl:GetForceAttackHeroId()
return self.forceAttackHeroId
end
function HeroCtrl:SetLastAttackHeroId(e)
self.mLastAttackHeroId=e
end
function HeroCtrl:GetLastAttackHeroId()
return self.mLastAttackHeroId
end
function HeroCtrl:IsLiveAgainState()
if self.WillNotUsual==true then
if self.NotUsualType==HeroState.DyingState
or self.NotUsualType==HeroState.Freeze
or self.NotUsualType==HeroState.UnDead then
return true
end
elseif self.CurrFsm.curStateEnum==HeroState.Freeze
or self.CurrFsm.curStateEnum==HeroState.DyingState
or self.CurrFsm.curStateEnum==HeroState.UnDead then
return true
end
return false
end
function HeroCtrl:SetImmuneDamageWithConsume(e)
self.immuneDamageWithConsume=e
end
function HeroCtrl:SetResistFatalDamage(e)
self.resistFatalDamage=e
end
function HeroCtrl:AddImmuneDamage(e)
self.HeroBattleInfo:AddBuffValue(e,HeroAttrId.ImmuneDamage,10000)
self:RefreshImmuneDamage()
end
function HeroCtrl:RefreshImmuneDamage()
local e=self.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.ImmuneDamage)
if e>0 then
self.ImmuneDamage=true
else
self.ImmuneDamage=false
end
end
function HeroCtrl:AddHasImmuneDamageBuff()
self.hasImmuneDamageBuff=true
end
function HeroCtrl:reduceHasImmuneDamageBuff()
self:refreshHasImmuneDamageBuff()
end
function HeroCtrl:refreshHasImmuneDamageBuff()
if f.CheckImmuneDamage(self)then
self.hasImmuneDamageBuff=true
else
self.hasImmuneDamageBuff=false
end
end
function HeroCtrl:PlayBuffEffectOnDamagePoint()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==true)then
return
end
if(self.HeroBattleInfo==nil)then
return
end
for e,t in pairs(self.mOnDamagePointBuffIdEffectMap)do
local e=self.HeroBattleInfo:GetBuff(e)
if e then
e:PlayBuffPrefabEffect(EBuffEffectType.damagePointTrigger)
end
end
end
function HeroCtrl:AddBuffIdEffectOnDamagePoint(e)
self.mOnDamagePointBuffIdEffectMap[e]=true
end
function HeroCtrl:RemoveBuffIdEffectOnDamagePoint(e)
self.mOnDamagePointBuffIdEffectMap[e]=nil
end
function HeroCtrl:SetHpChainData(e)
self:ClearHpChainData(e)
table.insert(self.mHpChainData,e)
end
function HeroCtrl:GetAllHpChainData()
local e={}
for t=1,#self.mHpChainData do
table.insert(e,self.mHpChainData[t])
end
for t=1,#self.mHpChainDataInCurAttack do
table.insert(e,self.mHpChainDataInCurAttack[t])
end
return e
end
function HeroCtrl:CheckClearHpChainData()
self:CheckClearHpChainDataByList(self.mHpChainData)
self:CheckClearHpChainDataByList(self.mHpChainDataInCurAttack)
end
function HeroCtrl:CheckClearHpChainDataByList(e)
for t=#e,1,-1 do
local a=e[t]
if self:CheckChainCondition(a)==false then
table.remove(e,t)
end
end
end
function HeroCtrl:CheckChainCondition(t)
local a=t.defHeroId
if a>0 and t.defBuffId~=0 then
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a)
if a==nil then
return false
else
local t=a.HeroBattleInfo:GetBuff(t.defBuffId)
if e:CheckChainDefBuffValid(t,self.HeroId)==false then
return false
end
end
end
return true
end
function HeroCtrl:GetHpChainData()
return self.mHpChainData
end
function HeroCtrl:ClearHpChainData(t)
for e=1,#self.mHpChainData do
if self.mHpChainData[e].defHeroId==t.defHeroId and self.mHpChainData[e].defBuffId==t.defBuffId then
table.remove(self.mHpChainData,e)
break
end
end
end
function HeroCtrl:SetHpChainDataInCurAttack(e)
table.insert(self.mHpChainDataInCurAttack,e)
end
function HeroCtrl:GetHpChainDataInCurAttack()
return self.mHpChainDataInCurAttack
end
function HeroCtrl:ClearHpChainDataInCurAttack(t)
for e=1,#self.mHpChainDataInCurAttack do
if self.mHpChainDataInCurAttack[e].defHeroId==t.defHeroId and self.mHpChainDataInCurAttack[e].defBuffId==t.defBuffId then
table.remove(self.mHpChainDataInCurAttack,e)
break
end
end
end
function HeroCtrl:ClearAllHpChainDataInCurAttack()
self.mHpChainDataInCurAttack={}
end
function HeroCtrl:AddDamageResData(e)
table.insert(self.mDamageResList,e)
end
function HeroCtrl:GetDamageResListLightCopy()
local e={}
table.appendList(e,self.mDamageResList)
return e
end
function HeroCtrl:ClearDamageResData(t)
for e=#self.mDamageResList,1,-1 do
if self.mDamageResList[e].buffId==t then
table.remove(self.mDamageResList,e)
break
end
end
end
function HeroCtrl:AddDamageConvertData(e)
table.insert(self.mDamageConvertList,e)
end
function HeroCtrl:GetDamageConvertListLightCopy()
local e={}
table.appendList(e,self.mDamageConvertList)
return e
end
function HeroCtrl:ClearDamageConvertData(t)
for e=#self.mDamageConvertList,1,-1 do
if self.mDamageConvertList[e].buffId==t then
table.remove(self.mDamageConvertList,e)
break
end
end
end
function HeroCtrl:IsEnableDamageConvert()
if#self.mDamageConvertList>0 then
return true
end
return false
end
function HeroCtrl:IsUseSkillByRoundAndSkillType(t,a)
local t=self.skillUseRecordMap[t]
if t then
for o=1,#t do
local t=t[o]
local e=e:GetSkillActData(t)
if e and e.type==a then
return true
end
end
end
return false
end
function HeroCtrl:IsUseSkillLastRoundSkillType(o)
local t=self.skillUseRecordMap[ModulesInit.ProcedureNormalBattle.CurrBattleBigRound]
if t==nil then
t=self.skillUseRecordMap[ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-1]
end
if t then
for a=1,#t do
local t=t[a]
local e=e:GetSkillActData(t)
if e and e.type==o then
return true
end
end
end
return false
end
function HeroCtrl:GetCurIsSmallSkill()
if self.mLastIsSmallSkillTotalSamllRound==0 then
return false
end
local e=ModulesInit.ProcedureNormalBattle.GetTotalSmallRound()
if e<=2 then
return false
end
local e=e-self.mLastIsSmallSkillTotalSamllRound
if e<0 or e>=2 then
return false
end
return true
end
function HeroCtrl:GetLastIsSmallSkill()
if self.mLastIsSmallSkillTotalSamllRound==0 then
return false
end
local e=ModulesInit.ProcedureNormalBattle.GetTotalSmallRound()
if e<=2 then
return false
end
local e=e-self.mLastIsSmallSkillTotalSamllRound
if e<=0 or e>=3 then
return false
end
return true
end
function HeroCtrl:GetLastIsBigSkill()
if self.mLastIsBigSkillTotalSmallRound==0 then
return false
end
local e=ModulesInit.ProcedureNormalBattle.GetTotalSmallRound()
if e<=2 then
return false
end
local e=e-self.mLastIsBigSkillTotalSmallRound
if e<=0 or e>=3 then
return false
end
return true
end
function HeroCtrl:GetLastIsNormalSkill()
if self.mLastIsNormalSkillTotalSmallRound==0 then
return false
end
local e=ModulesInit.ProcedureNormalBattle.GetTotalSmallRound()
if e<=2 then
return false
end
local e=e-self.mLastIsNormalSkillTotalSmallRound
if e<=0 or e>=3 then
return false
end
return true
end
function HeroCtrl:IsAttackInCurSmallRound()
local e=ModulesInit.ProcedureNormalBattle.GetTotalSmallRound()
if e>0 then
if self.mLastIsSmallSkillTotalSamllRound==e
or self.mLastIsBigSkillTotalSmallRound==e
or self.mLastIsNormalSkillTotalSmallRound==e then
return true
end
end
return false
end
function HeroCtrl:IsCanUseSmallSkill()
return self.ForbidSmallSkill==false
end
function HeroCtrl:CheckCanUseSkillById(e)
local e=i.GetEntity(e)
if e.type==AttackType.SmallSkill and self:IsCanUseSmallSkill()==false then
return false
end
return
end
function HeroCtrl:GetPetRoot()
return self.PetRoot
end
function HeroCtrl:GetHeroRoot()
return self.HeroRoot
end
function HeroCtrl:IsOurTeamAttack()
if(self.CurrBattleTeam and self.CurrBattleTeam.TeamId==1)then
return true
end
return false
end
function HeroCtrl:AddBuffTeamStatCount(e,t,a)
if self.CurrBattleTeam then
self.CurrBattleTeam:AddBuffTeamStatCount(e,t,a)
end
end
function HeroCtrl:GetBuffTeamStatCount(e,t)
if self.CurrBattleTeam then
return self.CurrBattleTeam:GetBuffTeamStatCount(e,t)
end
return 0
end
function HeroCtrl:GetAllBuffTeamStatCount(e)
if self.CurrBattleTeam then
return self.CurrBattleTeam:GetAllBuffTeamStatCount(e)
end
return{}
end
function HeroCtrl:ResetBuffTeamStatCount(e,t)
if self.CurrBattleTeam then
self.CurrBattleTeam:ResetBuffTeamStatCount(e,t)
end
end
function HeroCtrl:ResetAllBuffTeamStatCount(e)
if self.CurrBattleTeam then
self.CurrBattleTeam:ResetAllBuffTeamStatCount(e)
end
end
function HeroCtrl:IsCounterAttack()
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.campaign and ModulesInit.ProcedureNormalBattle.IsInLevelTestMode==false then
if self.heroDid>=1680000 then
if self.DTMonsterRow then
if self.DTMonsterRow.modelID<2000 or self.DTMonsterRow.modelID>20000 then
return true
end
end
end
end
return false
end
function HeroCtrl:RealHurtInLogicWithHpInPreview(t,s,e,a,o)
local r=0
local h=0
local a=0
local i=t
local n=0
a=t
if(t>0)then
self.HeroBattleInfo:ReducedHp(t,e)
if(e==HeroHurtType.thorn or e==HeroHurtType.healThorn or(e==HeroHurtType.hpChain and(o==nil or o.isShareDead~=true)))then
if(self.HeroBattleInfo.CurrHP<=0)then
self.HeroBattleInfo:SetHp(1,true)
end
end
end
if(self.HeroBattleInfo.CurrHP<0)then
self.HeroBattleInfo:SetHp(0,true)
end
if(e==HeroHurtType.hurtPoint)then
self.hurtWeightCount=self.hurtWeightCount-1
end
local e={
hurtValue=t,
showHurtValue=s,
originalHurtValue=i,
needReduceShield=r,
needReduceEnergy=h,
shield=n,
realHurtRet=a,
}
return e
end
function HeroCtrl:RealHurtInpreview(a,e,t,o,i)
local t=self:RealHurtInLogicWithHpInPreview(a,e,t,o,i)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.CurrHurtNum and self.HurtNumType~=nil)then
self.CurrHurtNum.SetText(self.HurtNumType,tostring(e))
end
end
self:RefreshArmor()
self:RefreshHP()
return t
end
function HeroCtrl:HpHealthInPreview(e,a,t,t,t,t,t)
if e<1 then
return
end
local e=e
local t=self.HeroBattleInfo.CurrHP+e
t=math.min(t,self.HeroBattleInfo.CurrMaxHP)
self.HeroBattleInfo:SetHp(t)
if(a)then
self.CurrHpHealthNum.SetText(EBattleHurtNumType.ShengMing_Baoji,tostring(e))
else
self.CurrHpHealthNum.SetText(EBattleHurtNumType.ShengMing,tostring(e))
end
self:RefreshHP()
self:PlayHpHealthEffect()
return e
end
function HeroCtrl:ChangePreviewState(e)
if e==ModulesInit.BattlePreviewMgr.EHeroState.MustDie then
self:PlayDeadAnimInTimeLine()
self:ChangeDeathState()
elseif e==ModulesInit.BattlePreviewMgr.EHeroState.Kneel then
self:PlayDyingAnimInTimeLine()
self.NotUsualType=HeroState.DyingState
self:ChangeState(HeroState.DyingState)
end
end
function HeroCtrl:SetHeroPreviewDeadState(e)
self.previewHeroDeadState=e
end
function HeroCtrl:GetHeroPreviewDeadState()
return self.previewHeroDeadState
end
function HeroCtrl:ChangePreviewDeadState(e)
if e==ModulesInit.BattlePreviewMgr.EHeroDeadState.KneelOnDie
or e==ModulesInit.BattlePreviewMgr.EHeroDeadState.KneelOnDieAndAudio then
self:ChangePreviewState(ModulesInit.BattlePreviewMgr.EHeroState.Kneel)
end
end
function HeroCtrl:SetHeroMustDie()
self.HeroBattleInfo:ClearAllBuff()
self.mustBeDie=true
end
function HeroCtrl:GetHeroMustDie()
if self:IsImmortalState()==true then
return false
end
return self.mustBeDie
end
function HeroCtrl:SetHeroEmptyHp(e)
self.mIsHeroEmptyHp=e
end
function HeroCtrl:IsHeroEmptyHp()
if self:IsImmortalState()==true then
return false
end
return self.mIsHeroEmptyHp
end
function HeroCtrl:GetTotalDamageInBigRound(e)
if self.totalDamageInBigRoundMap[e]then
return self.totalDamageInBigRoundMap[e]
end
return 0
end
function HeroCtrl:SetTotalDamageInBigRound(t)
if t>0 then
local e=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
if self.totalDamageInBigRoundMap[e]==nil then
self.totalDamageInBigRoundMap[e]=0
end
self.totalDamageInBigRoundMap[e]=self.totalDamageInBigRoundMap[e]+t
end
end
function HeroCtrl:GetAddHpInBigRound(e)
if self.addHpInBigRoundMap[e]then
return self.addHpInBigRoundMap[e]
end
return 0
end
function HeroCtrl:SetAddHpInBigRound(t)
if t>0 then
local e=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
if self.addHpInBigRoundMap[e]==nil then
self.addHpInBigRoundMap[e]=0
end
self.addHpInBigRoundMap[e]=self.addHpInBigRoundMap[e]+t
end
end
function HeroCtrl:GetTeamId()
if self.CurrBattleTeam then
return self.CurrBattleTeam.TeamId
end
return 0
end
function HeroCtrl:AddTimer(e)
table.insert(self.timerList,e)
end
function HeroCtrl:RemoveTimer(a)
for e=#self.timerList,1,-1 do
local t=self.timerList[e]
if(t.Id==a.Id)then
table.remove(self.timerList,e)
break
end
end
end
function HeroCtrl:StopAllTimer()
if(GameInit.IsClient)then
for t,e in pairs(self.timerList)do
e:Stop()
end
self.timerList={}
end
end
function HeroCtrl:AddCommonTweener(e,t)
self:RemoveCommonTweener(e)
self.mCommonTweenerMap[e]=t
end
function HeroCtrl:RemoveCommonTweener(e)
if self.mCommonTweenerMap[e]then
self.mCommonTweenerMap[e]:Kill()
self.mCommonTweenerMap[e]=nil
end
end
function HeroCtrl:KillAllCommonTweener()
for t,e in pairs(self.mCommonTweenerMap)do
if(e)then
e:Kill()
end
end
self.mCommonTweenerMap={}
end
function HeroCtrl:GetLastBigSkillTargetHeroIds()
return self.lastBigSkillTargetHeroIds
end
function HeroCtrl:SetLastBigSkillTargetHeroIds(e)
self.lastBigSkillTargetHeroIds=e
end
function HeroCtrl:SetUnderControlTransferSkin(e,t)
self.isUnderControlTransferSkin=e
if e==true then
self.mRecordTransferSkinPrefabId=t
else
self.mRecordTransferSkinPrefabId=0
end
end
function HeroCtrl:GetUnderControlTransferSkin()
return self.isUnderControlTransferSkin
end
function HeroCtrl:CheckCanAddUnderControlTransferSkinBuff(t)
local e=a:GetBuffCfg(t)
if(e==nil)then
GameInit.LogError("对应的Buff不存在 buffId %s",t)
return false
end
if e.transferPrefabId<=0 then
return false
end
if self:CheckHeroCanUnderControlTransferSkin()==false then
return false
end
if self:GetUnderControlTransferSkin()==true then
if self.mRecordTransferSkinPrefabId==e.transferPrefabId then
return false
end
end
return true
end
function HeroCtrl:CheckHeroCanDoAction()
if self.HeroBattleInfo==nil then
return false
end
if self.HeroBattleInfo.CurrHP<=0 then
return false
end
if self:IsNotUsualStateOrType()then
return false
end
if self:IsNothingToDoState()then
return false
end
return true
end
function HeroCtrl:CheckHeroCanUnderControlTransferSkin()
return self:CheckHeroCanDoAction()
end
function HeroCtrl:CheckRestoreUnderControlTransferSkin()
if self.mRecordTransferSkinPrefabId~=0 then
self:CheckUnderControlTransferSkin(self.mRecordTransferSkinPrefabId)
end
end
function HeroCtrl:CheckUnderControlTransferSkin(e)
if ModulesInit.ProcedureNormalBattle.IsSkipBattle==true then
return
end
if self:GetUnderControlTransferSkin()==false then
return
end
if self:CheckHeroCanUnderControlTransferSkin()==false then
return
end
if self.mCurTransferSkinPrefabId==e then
return
end
self:ChangeSkin(e)
end
function HeroCtrl:ChangeSkin(e)
self.mCurTransferSkinPrefabId=e
self:LoadSkin(self.mCurTransferSkinPrefabId,false)
self:UnLoadPet()
end
function HeroCtrl:RestoreSkin()
self:SetUnderControlTransferSkin(false)
self:RestoreSkinShow()
end
function HeroCtrl:CheckRestoreSkinShow()
self:RestoreSkinShow()
end
function HeroCtrl:RestoreSkinShow()
if ModulesInit.ProcedureNormalBattle.IsSkipBattle==true then
return
end
if self.mCurTransferSkinPrefabId==0 then
return
end
if self:IsDeathOrWaitState()then
return
end
if self.Ready==false then
return
end
self.mCurTransferSkinPrefabId=0
self:LoadSkin(self.PrefabId,false)
if self.heroPet>0 and self.petPrefabId>0 then
self:LoadPet()
end
end
function HeroCtrl:AddTeamStatOverdrowFury(e)
if self.CurrBattleTeam then
self.CurrBattleTeam:AddTeamStatOverdrowFury(e)
end
end
function HeroCtrl:ReduceTeamStatOverdrowFury(e)
if self.CurrBattleTeam then
self.CurrBattleTeam:ReduceTeamStatOverdrowFury(e)
end
end
function HeroCtrl:AddTeamStatFury(e)
if self.CurrBattleTeam then
self.CurrBattleTeam:AddTeamStatFury(e)
end
end
function HeroCtrl:ReduceTeamStatFury(e)
if self.CurrBattleTeam then
self.CurrBattleTeam:ReduceTeamStatFury(e)
end
end
function HeroCtrl:GetTeamStatFuryChangeInCurBigRound()
if self.CurrBattleTeam then
return self.CurrBattleTeam:GetTeamStatFuryChangeInCurBigRound()
end
return 0
end
function HeroCtrl:GetTeamTotalStatFuryAdd()
if self.CurrBattleTeam then
return self.CurrBattleTeam:GetTeamTotalStatFuryAdd()
end
return 0
end
function HeroCtrl:SetEnergyConsumeCond(e)
self.energyConsumeCond=e
end
function HeroCtrl:IsPet()
return self.mIsPet
end
function HeroCtrl:IsMonsterRole()
return self.mIsPet==false and self.HeroId<0
end
function HeroCtrl:IsFightPet()
return self.mIsFightPet
end
function HeroCtrl:SetHasOneAttackBuff(e)
self.mOneAttackbuff=e
end
function HeroCtrl:CheckClearOnAttackBuff()
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
if self.mOneAttackbuff then
self.HeroBattleInfo:ClearOnAttackBuff()
self:SetHasOneAttackBuff(false)
end
end
function HeroCtrl:SetPreviewHeroSpecialState(e,t)
if self:IsNothingToDoState()then
return
end
if self:IsImmortalState()==true then
return false
end
self.mPreviewHeroSpecialState=e
self.mPreviewHeroSpecialStateBuffId=t or 0
end
function HeroCtrl:GetPreviewHeroSpecialState()
return self.mPreviewHeroSpecialState
end
function HeroCtrl:SetWillHeroSpecialState(e)
if self:IsNothingToDoState()then
return
end
if self:IsImmortalState()==true then
return
end
self.mWillHeroSpecialState=e
end
function HeroCtrl:SetHeroSpecialState(e)
if self:IsNothingToDoState()then
return
end
if self:IsImmortalState()==true then
return false
end
self.mHeroSpecialState=e
end
function HeroCtrl:IsHeroSpecialState()
return self.mHeroSpecialState~=HeroSpecialState.None
end
function HeroCtrl:IsHeroForbidSpecialState()
if self.mHeroSpecialState>=HeroSpecialState.Ice then
return true
end
if self:IsDeathOrWaitState()then
return true
end
return false
end
function HeroCtrl:IsTombSpecialState()
return self.mHeroSpecialState==HeroSpecialState.Tomb
end
function HeroCtrl:IsIceSpecialState()
return self.mHeroSpecialState==HeroSpecialState.Ice
end
function HeroCtrl:IsMuteSpecialState()
return self.mHeroSpecialState==HeroSpecialState.Mute
end
function HeroCtrl:CheckExcuteWillHeroSpecialState(e)
if self:IsNothingToDoState()then
return
end
if self:IsImmortalState()==true then
return false
end
if e==BuffTriggerTime.HeroDeadBefore then
self:CheckExcuteWillSpecialStateOnHeroDeadBefore()
else
self:CheckExcuteWillTombSpecialState()
end
end
function HeroCtrl:CheckExcuteWillTombSpecialState()
if self.mWillHeroSpecialState==HeroSpecialState.Tomb then
self:SetWillHeroSpecialState(HeroSpecialState.None)
self:SetHeroSpecialState(HeroSpecialState.Tomb)
self:PlayDyingAnimInTimeLine()
end
end
function HeroCtrl:CheckExcuteWillSpecialStateOnHeroDeadBefore()
if self.mWillHeroSpecialState==HeroSpecialState.Ice then
self:SetWillHeroSpecialState(HeroSpecialState.None)
self:SetHeroSpecialState(HeroSpecialState.Ice)
self:PlayIceAnimInTimeLine()
elseif self.mWillHeroSpecialState==HeroSpecialState.Mute then
self:SetWillHeroSpecialState(HeroSpecialState.None)
self:SetHeroSpecialState(HeroSpecialState.Mute)
if self.HeroBattleInfo.CurrHP<=0 then
self.HeroBattleInfo:SetHp(1)
end
self:PlayDyingAnimInTimeLine()
end
end
function HeroCtrl:IsFullFury()
if self.HeroBattleInfo.CurrFury>=self.HeroBattleInfo.Fury then
return true
end
return false
end
function HeroCtrl:IsFullFuryWithFury(e)
if e>=self.HeroBattleInfo.Fury then
return true
end
return false
end
function HeroCtrl:GetLostHp()
local e=self.HeroBattleInfo.CurrHP
local e=self.HeroBattleInfo.MaxHP-e
return e
end
function HeroCtrl:SetThornShowBuffId(e)
self.CurrThornShowBuffId=e
end
function HeroCtrl:GetCurrHPInStatics()
local e=self.HeroBattleInfo:GetCurrHP()
if e==0 and(self:IsNotUsualState()or self.WillNotUsual)then
e=1
end
return e
end
function HeroCtrl:IsSkillAttacking()
if self.IsNormalAttacking
or self.IsSmallSkillAttacking
or self.IsBigSkillAttacking
or self.IsPetSkillAttacking then
return true
end
return false
end
function HeroCtrl:EnsureUndead()
if(self.HeroBattleInfo.CurrHP<=0)then
self.HeroBattleInfo:SetHp(1,true)
end
end
function HeroCtrl:IsEnablePowerBeans()
return self.ExBigSkillId>0
end
function HeroCtrl:RemoveOneBeans()
if self.HeroBattleInfo then
self.HeroBattleInfo:RemoveOneBeans()
end
end
function HeroCtrl:SetMustBeCritOnce(e)
self.IsBeMustCritOnce=e
end
function HeroCtrl:GetMustBeCritOnce()
return self.IsBeMustCritOnce
end
function HeroCtrl:SetDisableAttackFuryhealthInCurAttack(e)
self.isDisableAttackFuryhealthInCurAttack=e
end
function HeroCtrl:GetDisableAttackFuryhealthInCurAttack()
return self.isDisableAttackFuryhealthInCurAttack
end
function HeroCtrl:SetDisableDefFuryhealthInCurAttack(e)
self.isDisableDefFuryhealthInCurAttack=e
end
function HeroCtrl:GetDisableDefFuryhealthInCurAttack()
return self.isDisableDefFuryhealthInCurAttack
end
function HeroCtrl:GetCurFightSkillId()
return self.PetFightSkillId
end

