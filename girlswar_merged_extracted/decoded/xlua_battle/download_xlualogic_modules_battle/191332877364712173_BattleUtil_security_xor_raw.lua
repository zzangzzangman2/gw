local w=require("DataNode/DataTable/Create/skillAct/DTSkillActDBModel")
local a=require("DataNode/DataManager/DataMgr/DataUtil")
local y=require("DataNode/DataTable/Create/maps/DTEliteMapsDBModel")
local d=require("DataNode/DataTable/Create/maps/DTEliteMapsWaveDBModel")
local p=require("DataNode/DataTable/Create/hero/DTHeroDBModel")
local n=require('DataNode/DataTable/Create/activity/DTWatermelonCfgDBModel')
local c=require("DataNode/DataTable/Create/officer/DTOfficerDBModel")
local l=require("DataNode/DataTable/Create/constant/DTBattleAttrDBModel")
local r=require("DataNode/DataTable/Create/treasure/DTTreasureDBModel")
local u=require("DataNode/DataTable/Create/treasure/DTTreasureSkillDBModel")
local s=require("DataNode/DataTable/Create/treasure/DTTreasureStrengDBModel")
local e={
treasureStrengMap=nil,
skillIdMap=nil,
}
local f={
[31110]=0
}
local m={
92221,
303111216,
}
function e:CheckCanTriggerAttackTask(e)
if e==ETriggerSkillAtkType.Normal
or e==ETriggerSkillAtkType.PursuitComboAttack then
return true
end
return false
end
function e:IsNormalSkillAtkType(e)
if e==ETriggerSkillAtkType.Normal then
return true
end
return false
end
function e:IsPreventSkillAtkType(e)
if e~=ETriggerSkillAtkType.Normal
and e~=ETriggerSkillAtkType.PursuitAttackMate then
return true
end
return false
end
function e:AddTriggerAttackTask(s,i,t,n)
if s==nil then
GameInit.LogError("BattleUtil:AddAttackTask atkHeroCtrl is nil ")
return
end
if i==nil then
GameInit.LogError("BattleUtil:AddAttackTask skillDid is nil ")
return
end
if n==nil then
GameInit.LogError("BattleUtil:AddAttackTask triggerData is nil ")
return
end
if self.ForbidExtraAttack==true then
return
end
local o=EBattleActionType.NormalOrSmallSkill
local a=e:GetSkillActData(i)
if a==nil then
GameInit.LogError("BattleUtil:AddAttackTask drSkillData is nil skillDid = %s ",i)
return
end
local h=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(s)
if h==nil then
return
end
if h:IsPet()==false then
if ModulesInit.ProcedureNormalBattle.IsHeroSkillAttackState()==false then
return
end
end
if e:CheckCanTriggerAttackTask(n.triggerSkillAtkType)==false then
return
end
if n.isPetTrigger then
if h:IsPet()==false then
return false
end
end
if a then
if a.type==1 then
o=EBattleActionType.NormalOrSmallSkill
elseif a.type==2 then
o=EBattleActionType.NormalOrSmallSkill
elseif a.type==3 then
o=EBattleActionType.BigSkill
elseif a.type==AttackType.PetFightSkill then
o=EBattleActionType.PetFightSkill
elseif a.type==AttackType.PetHelpSkill then
o=EBattleActionType.PetFightSkill
end
end
if t then
t.skillChangeCfgData=t.skillChangeCfgData or{}
if t.costMp==false then
t.skillChangeCfgData.costMp=0
end
if t.triggerSkillAtkType then
t.skillChangeCfgData.atkType=t.triggerSkillAtkType
end
end
local e={
heroId=s,
fireHeroId=nil,
actionType=o,
skillDid=i,
skillData=t,
triggerSkillAtkType=t.triggerSkillAtkType,
insertLevel=t.insertLevel,
}
ModulesInit.ProcedureNormalBattle.AddAttackTask(e)
end
function e:AddFightPetAttackTask(t,n,i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fFightPet)
if t then
local a=t.HeroId
local t=t.PetFightSkillId
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if o==nil then
e:AddTriggerAttackTask(a,t,n,i)
end
end
end
function e:AddTriggerTeamAttackTask(o,t,a,i)
if o==nil then
GameInit.LogError("BattleUtil:AddAttackTask teamId is nil ")
return
end
if t==nil then
GameInit.LogError("BattleUtil:AddAttackTask skillDid is nil ")
return
end
if i==nil then
GameInit.LogError("BattleUtil:AddAttackTask triggerData is nil ")
return
end
local e=e:GetSkillActData(t)
if e==nil then
GameInit.LogError("BattleUtil:AddAttackTask drSkillData is nil skillDid = %s ",t)
return
end
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndTeamId(t,o)
if e then
return
end
local e=EBattleActionType.teamAttack
local e={
heroId=0,
teamId=o,
fireHeroId=nil,
actionType=e,
skillDid=t,
skillData=a,
triggerSkillAtkType=a.triggerSkillAtkType,
insertLevel=a.insertLevel or ETriggerSkillInsertLevel.OtherAttack,
}
ModulesInit.ProcedureNormalBattle.AddAttackTask(e)
end
function e:ResetTriggerAttackTaskSkillDid(o,t)
if t==nil then
GameInit.LogError("BattleUtil:AddAttackTask skillDid is nil ")
return
end
local a=EBattleActionType.NormalOrSmallSkill
local e=e:GetSkillActData(t)
if e==nil then
GameInit.LogError("BattleUtil:AddAttackTask drSkillData is nil skillDid = %s ",t)
return
end
if e then
if e.type==1 then
a=EBattleActionType.NormalOrSmallSkill
elseif e.type==2 then
a=EBattleActionType.NormalOrSmallSkill
elseif e.type==3 then
a=EBattleActionType.BigSkill
end
end
o.skillDid=t
o.actionType=a
return o
end
function e:GetSkillActData(e)
local e=w.GetEntity(e)
return e
end
function e:GetEliteMapData(e)
local e=y.GetEntity(e)
return e
end
function e.GetEliteMapAllWave(a)
local e
e=d.Get_MapId(a)
local o=#e
local t={}
for o=1,o do
local e=e[o]
if(e.mapId==a)then
t[#t+1]=e
end
end
return t
end
function e.GetEliteMapsWaveData(t,a)
local e
e=d.Get_MapIdWave(t,a)
local o=#e
for o=1,o do
local e=e[o]
if(e.mapId==t and e.wave==a)then
return e
end
end
end
function e.CheckOpenOfficerInBattle()
return ModulesInit.ProcedureNormalBattle.IsPVE()==false
end
function e.GetOfficerAddFirstValue(e)
local e=c.GetEntity(e)
if e then
return e.addFirstValue
end
return 0
end
function e:GetTreasureCfgData(e)
return r.GetEntity(e)
end
function e:GetTreasureBattleBg(e)
return"UIBattle/treasure_bg_"..tostring(e)
end
function e:GetTreasureCfgList()
return r.GetList()
end
function e:GetTreasureSkillCfgData(e)
return u.GetEntity(e)
end
function e:GetTreasureStrengCfgDataByDid(e)
return s.GetEntity(e)
end
function e:GetTreasureStrengCfgData(a,i,o)
if e.treasureStrengMap==nil then
e.treasureStrengMap={}
end
if e.treasureStrengMap[a]==nil then
local t
if GameInit.IsClient then
t=s.Get_TreasureId(a)
else
t=s.GetList()
end
for a=1,#t do
local t=t[a]
if e.treasureStrengMap[t.treasureId]==nil then
e.treasureStrengMap[t.treasureId]={}
end
if e.treasureStrengMap[t.treasureId][t.level]==nil then
e.treasureStrengMap[t.treasureId][t.level]={}
end
e.treasureStrengMap[t.treasureId][t.level][t.breakLevel]=t
if e.treasureStrengMap[t.treasureId][t.level]["maxBreakLevel"]==nil
or e.treasureStrengMap[t.treasureId][t.level]["maxBreakLevel"]>t.breakLevel then
e.treasureStrengMap[t.treasureId][t.level]["maxBreakLevel"]=t.breakLevel
end
end
end
if o==nil then
o=e.treasureStrengMap[a][i]["maxBreakLevel"]
end
if e.treasureStrengMap[a][i]~=nil then
return e.treasureStrengMap[a][i][o]
end
return nil
end
function e:IsCtlBuff(e)
local e=a:GetBuffCfg(e)
if(e and e.isControl>=1)then
return true
end
return false
end
function e:IsDispelDeBuff(e)
local e=a:GetBuffCfg(e)
if(e and e.canDispel>=1 and e.isGran==0)then
return true
end
return false
end
function e:IsCtlAndStealBuff(t)
local t=a:GetBuffCfg(t)
if(t and t.isControl>=1 and e:IsCanStealBuff(t))then
return true
end
return false
end
function e:IsCanStealBuff(e)
if(e and e.canDispel>0 and e.canSteal>0)then
return true
end
return false
end
function e:IsCanStealBuffById(t)
local t=a:GetBuffCfg(t)
return e:IsCanStealBuff(t)
end
function e:IsCtlBuffWithResponse(e)
local e=a:GetBuffCfg(e)
if(e and e.isControl>=1 and e.controlRepose==0)then
return true
end
return false
end
function e:IsStrongCtlBuff(e)
local e=a:GetBuffCfg(e)
if(e and e.isControl>=BattleStrongBuffLevel)then
return true
end
return false
end
function e:IsStrongCtlPosBuff(e)
local e=a:GetBuffCfg(e)
if(e and e.isControl>=BattleStrongBuffLevel and e.controlPose~="")then
return true
end
return false
end
function e:GetHeroHeadInfo(i)
local n=ModulesInit.ProcedureNormalBattle.GetMonsterCfgData()
local e=p.GetEntity(i)
local a=""
local t=0
local o=1
if e then
a=GameTools.GetLocalize(e.heroName,LanguageCategory.LangBattle)or""
t=e.modelID
else
local e=n.GetEntity(i)
if e then
a=GameTools.GetLocalize(e.monName,LanguageCategory.LangBattle)or""
t=e.modelID
end
end
local e=UIUtil.GetPlayerHead(t)
if e then
o=e.id
end
return{
name=a,
headId=o
}
end
function e:CompareBuffPriority(n,i,t,s,s,a,o)
if t then
local e=e:CompareBuffWeight(n,i,t,t.round,t.buffData,a,o)
if e==EBuffWeightResult.Same then
if a==t.round then
return EBuffPriorityResult.Same
elseif a>t.round then
return EBuffPriorityResult.Better
else
return EBuffPriorityResult.Worse
end
elseif e==EBuffWeightResult.Big then
return EBuffPriorityResult.Better
else
return EBuffPriorityResult.Worse
end
else
return EBuffPriorityResult.Better
end
end
function e:CompareBuffWeight(t,a,h,o,i,s,n)
if t.CompareBuffWeight then
local e=t.CompareBuffWeight(a,h,o,i,s,n)
if e==true then
return EBuffWeightResult.Big
elseif e==false then
return EBuffWeightResult.Small
else
return EBuffWeightResult.Same
end
else
local o=e:GetBuffWeight(t,a,o,i)
local e=e:GetBuffWeight(t,a,s,n)
if e>o then
return EBuffWeightResult.Big
elseif e<o then
return EBuffWeightResult.Small
else
return EBuffWeightResult.Same
end
end
end
function e:GetBuffWeight(e,a,o,t)
if e==nil or a==nil then
return 0
end
if e.GetWeight then
return e.GetWeight(a,o,t)
end
if type(t)~="table"then
return 0
end
local i=a.buffWeight
local a=0
for o=1,#i do
local e=t[o]
if e==nil then
break
elseif type(e)=="number"then
a=a+i[o]*e
end
end
return a
end
function e:GetTeamSoulCategoryCount(e)
local t={}
for a=1,#e do
local e=e[a]
local e=e.soulRow
if e then
t[e.soulClass]=true
end
end
local e=0
for t,t in pairs(t)do
e=e+1
end
return e
end
function e:GetTotalCountPerTeamSoulCategory(e)
local t={}
for a=1,#e do
local e=e[a]
local e=e.soulRow
if e then
if t[e.id]==nil then
t[e.id]=1
else
t[e.id]=1+t[e.id]
end
end
end
return t
end
function e.ChangeBattleAttr(o,e,t)
local t=a.GetBattleAttrCoe(o,t)
local e=a.GetBattleAttrCoeReverse(e,t)
return e
end
function e:GetArmorDamageWithType(e,t)
if e==BattleType.waterMelon then
local e=n.GetEntity(1)
if t then
return RandomMgr:GetBattleRandomWithRange(e.breakPoint[1],e.breakPoint[2])
else
return RandomMgr:GetBattleRandomWithRange(e.breakPoint[1],e.breakPoint[2])
end
end
return 0
end
function e:CheckCanAddBuffWithBattleType(a,t,e)
if a==BattleType.waterMelon then
if t<0 and e.isGran==0 and e.isControl<BattleStrongBuffLevel then
return false
end
end
return true
end
function e:GetControlBuffSuccessRateWithType(t,e)
if t==BattleType.waterMelon then
if e<0 then
local e=n.GetEntity(1)
return true,e.bossContrlRate
end
end
return false,0
end
function e:GetCritRateWithType(t,e)
if t==BattleType.waterMelon then
if e>0 then
local e=n.GetEntity(1)
return true,e.critRate
end
end
return false,0
end
function e:CheckCanThornWithBattleType(t,e)
if t==BattleType.waterMelon then
if e<0 then
return false
end
end
return true
end
function e:CheckCanAddBloodWithBattleType(e,t)
if e==BattleType.waterMelon then
if t<0 then
return false
end
end
return true
end
function e:GetFightingWithHeros(a)
local t=0
for o=1,#a do
local a=a[o].attribute
if a then
t=t+e:GetFighting(a)
end
end
return t
end
function e:GetFighting(e)
local t={}
for a=1,#e do
local o=e[a].id
t[o]=e[a].value
end
local e=0
for t,a in pairs(t)do
if t<100 then
local t=l.GetEntity(t)
e=e+(a*t.score)
end
end
e=math.floor(e*0.001)
return e
end
function e:Handler(t,e)
return function(...)
return e(t,...)
end
end
function e:HpHealthWithBigSkillAndParam(e,o,r,s,h,n,a)
if a==nil then
a=e
end
local i=e:GetIsCrtRemedy()
local t=0
if(o and o==1)then
local a=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(a)then
t=a*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
return a:HpHealthWithBigSkill(e,r*(1+t),s,i,EBattleSrcType.SkillBig,h,n)
end
function e:HpHealthWithSmallSkillAndParam(e,o,i,a)
if a==nil then
a=e
end
local t=0
if(o and o==1)then
local a=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(a)then
t=a*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
a:HpHealthWithNormalSkill(e,i*(1+t),false,EBattleSrcType.SkillSmall)
end
function e:GetHeroWithProfession(e,o)
local a={}
for t=1,#e do
if e[t].profession==o then
table.insert(a,e[t])
end
end
return a
end
function e:CheckCanMustDie(e,t)
if ModulesInit.ProcedureNormalBattle.IsPVE()then
return false
end
if e.hasImmuneDamageBuff then
return false
end
if e:GetArmor()>0 then
return false
end
if t==AttackType.Normal or t==AttackType.SmallSkill then
if e.ImmuneNormalAndSmallSkill then
return false
end
end
return true
end
function e:GetRealHurtMustDie(e)
local a=e.HeroBattleInfo:GetMaxHP()
local t=e.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.shield)
local e=e.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.energy)
local e=(a+t+e)*10
return e
end
function e:GetReduceDamageByRes(a,t)
local e=a.HeroBattleInfo:GetLimitBuffAndTempBuffValue(HeroAttrId.reduceHpResRate,nil,false)
if e~=nil and e>0 then
t=math.floor(t*(1-e*MillionCoe))
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
return t
end
function e:OnImmuneLockHp(e)
local t=e.HeroBattleInfo:GetBuff(e.buffIdImmuneLockHp)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e.buffIdImmuneLockHp)
if e and e.OnImmuneLockHp then
e.OnImmuneLockHp(t)
end
end
end
function e:CheckImmuneLockHp(t,e)
local e=a:GetBuffCfg(e)
if t.ImmuneLockHp>e.triggleLevel then
return true
end
return false
end
function e:GetReduceDamageByResData(a,h,s,o,m)
local t=false
if o==true or s==HeroHurtType.buff or s==HeroHurtType.hpChain then
t=true
end
if t==false then
return h
end
local t=h
local o=a:GetDamageResListLightCopy()
for i=1,#o do
local i=o[i]
local r=i.reduceHpResRate*MillionCoe
local d=i.resBeAttackType
local f=i.reduceHpMinHpPercent*MillionCoe
local c=i.minHpLockPercent or 0
local o=i.buffId
local n=i.damageResHeroId
local w=i.isNeedCheck
local u=i.maxDamgeCurHpPercent
local l=i.damgeMaxHpPercent
if a and(d==nil or d==m)then
if w~=true or e:CheckCondHpLock(o,n)then
local i=e:CheckImmuneLockHp(a,o)
local d=false
if c>0 then
local e=a.HeroBattleInfo.CurrHP-math.floor(a.HeroBattleInfo.MaxHP*c*MillionCoe)
e=math.max(e,0)
if t>e then
if i==true then
d=true
else
t=e
EventSystem.SendEvent(CommonEventId.OnBattleHeroLockHp,a.HeroId)
if o and n then
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(n)
if e and e.HeroBattleInfo then
local t=e.HeroBattleInfo:GetBuff(o)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
if e and e.OnDamageRes then
e.OnDamageRes(t,s)
end
end
end
end
end
end
end
if r>0 then
if t>a.HeroBattleInfo.MaxHP*f then
local i=false
if o and n then
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(n)
if e and e.HeroBattleInfo then
local a=e.HeroBattleInfo:GetBuff(o)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
if e and e.OnReduceHpRes then
local e=e.OnReduceHpRes(a,t,s)
i=e.isSeparately
t=e.realHurtValue
end
end
end
end
if i==false then
t=math.floor(t*(1-r))
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
if u~=nil then
local e=math.floor(a.HeroBattleInfo:GetCurrHP()*u*MillionCoe)
if t>e then
t=e
end
end
if l~=nil then
local e=math.floor(a.HeroBattleInfo.MaxHP*l*MillionCoe)
if t>e then
t=e
end
end
if d==true then
e:OnImmuneLockHp(a)
if o and n then
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(n)
if e and e.HeroBattleInfo then
local t=e.HeroBattleInfo:GetBuff(o)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
if e and e.OnHpLockConsume then
e.OnHpLockConsume(t)
end
end
end
end
end
end
end
end
return t
end
function e:GetConvertDamageByResData(e,t)
local t=t
if e:IsEnableDamageConvert()then
local e=e:GetDamageConvertListLightCopy()
for a=1,#e do
local e=e[a]
local n=e.reduceHpConvertRate*MillionCoe
local a=e.buffId
local o=e.damageResHeroId
local i=e.maxConvertValue
local s=e.atkHeroId
local e=t*n
if i then
e=math.min(e,i)
end
t=t-e
if a and o then
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(o)
if t and t.HeroBattleInfo then
local o=t.HeroBattleInfo:GetBuff(a)
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
if t and t.OnDamageConvert then
t.OnDamageConvert(o,e,s)
end
end
end
end
end
end
return t
end
function e:CheckCondHpLock(t,e)
if t and e then
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e and e.HeroBattleInfo then
local a=e.HeroBattleInfo:GetBuff(t)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
if e and e.CheckCondHpLock then
return e.CheckCondHpLock(a)
end
end
end
end
return false
end
function e:GetReduceDamageByHpChain(r,t,o)
local a=t
local t=r:GetAllHpChainData()
r:ClearAllHpChainDataInCurAttack()
local m=false
for i=1,#t do
local t=t[i]
local h=t.defHeroId
local f=t.defBuffId
if t.notTriggerHurtType~=o then
local i=t.assumedamagePercent*MillionCoe
local u=t.reduceDamagePercent*MillionCoe
local o=t.maxDamageHpPercent
local w=t.minHpPercent
local i=i*(1-u)
local i=a*i
if o then
local e=r.HeroBattleInfo:GetMaxHP()
i=(a-e*o*MillionCoe)
if i<0 then
i=0
end
end
local s
local n
if t.holderBuffId and t.holderBuffId>0 then
s=r.HeroBattleInfo:GetBuff(t.holderBuffId)
if s then
n=ModulesInit.BattleBuffMgr.GetBuffScript(t.holderBuffId)
end
end
local o=nil
local d=nil
if h and h~=0 then
d=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(h)
end
local l=nil
if n and n.GetDefHero then
l=n.GetDefHero(s)
end
if d then
o=d
elseif l then
o=l
end
local c=true
local h
if d then
h=d.HeroBattleInfo:GetBuff(f)
if e:CheckChainDefBuffValid(h,r.HeroId)==false then
c=false
m=true
end
end
if o and i>0 and c==true then
if o:CurrHPPer()>w*MillionCoe then
local d
if h then
d=h
else
d=s
end
if d then
local t={
hurtType=HeroHurtType.hpChain,
minHpPercent=w,
isShareDead=t.isShareDead
}
local r=0
local c=true
if ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.None)then
c=false
end
local t,d,m=o:RealHurtWithBuff(i,d,nil,nil,nil,c,t)
local d=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(o.HeroId)
if d then
if d:IsDeathOrWaitState()then
a=a-i
else
if t then
r=t.hurtValue+t.needReduceShield+t.needReduceEnergy
if r>0 then
if(1-u)>0 then
a=a-r/(1-u)
else
a=0
end
end
if c then
e:AddDamageBuffAtSkillComplete(o,t,HeroHurtType.hpChain,m)
end
if h then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(f)
if e and e.OnShareDamge then
e.OnShareDamge(h,r)
end
end
if s and n and n.OnHpChainShared then
n.OnHpChainShared(s,l,r)
end
end
end
else
a=a-i
end
end
local e=t.defAddfury
if e>0 then
o:AddFuryWithBuff(e)
end
end
end
end
end
if m then
r:CheckClearHpChainData()
end
return a
end
function e:CheckChainDefBuffValid(e,t)
if e==nil then
return false
else
local e=e.defBuffPairData
if e then
if e.atkMgrHeroId~=t then
return false
end
end
end
return true
end
function e:HasChainBuff(e,t)
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local e=e:GetBuffData()
local e=e[1]
if e and e.defHeroId then
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.defHeroId)
if e and e:IsDeathOrWaitState()==false then
return true
end
end
end
return false
end
function e:AddDamageBuffAtSkillComplete(t,e,n,s)
local a=e.hurtValue+e.needReduceShield+e.needReduceEnergy
if a>0 then
local i=3131
local a=t.HeroBattleInfo:GetBuff(i)
if a then
local o=a:GetBuffData()
local a=o[1]
if a then
for t,o in pairs(a)do
if e[t]~=nil then
a[t]=a[t]+e[t]
end
end
else
o[1]=e
end
o[2]=n
o[3]=s
else
t:AddBuff(t,i,1,{e,n,s})
end
t.isTriggerSkillEndBuff=true
end
end
function e:CheckExcuteResistFatalDamage(e,t,i)
if t>=e.HeroBattleInfo.CurrHP then
for a=1,#m do
local a=m[a]
local o=e.HeroBattleInfo:GetBuff(a)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
if e and e.CheckExcuteResistFatalDamage then
return e.CheckExcuteResistFatalDamage(o,t,i)
end
end
end
end
return false
end
function e:GetHeroArrWithBuff(e,i,a,o)
local t={}
for o=1,#e do
local e=e[o]
local a=e.HeroBattleInfo:GetGranBuff(i,true,a)
if#a>0 then
table.insert(t,e)
end
end
local e=RandomTableWithSeed(t,o)
return e
end
function e:GetSkillPrefabId(a,n,o,i)
local t=0
if o>0 then
if n==2 then
if ModulesInit.ProcedureNormalBattle.CheckDoGameFastSkillPlayFirstAnim(i)==false then
if ModulesInit.ProcedureNormalBattle.GameFastSkill==true then
t=e:SearchSymphonyPrefabId(a.symphonyFastPrefabIds2,o)
end
end
if t<=0 then
t=e:SearchSymphonyPrefabId(a.symphonyPrefabIds2,o)
end
end
if t<=0 then
if ModulesInit.ProcedureNormalBattle.CheckDoGameFastSkillPlayFirstAnim(i)==false then
if ModulesInit.ProcedureNormalBattle.GameFastSkill==true then
t=e:SearchSymphonyPrefabId(a.symphonyFastPrefabIds,o)
end
end
if t<=0 then
t=e:SearchSymphonyPrefabId(a.symphonyPrefabIds,o)
end
end
end
if t<=0 then
if n==2 then
t=a.prefabId2
if ModulesInit.ProcedureNormalBattle.CheckDoGameFastSkillPlayFirstAnim(i)==false then
if ModulesInit.ProcedureNormalBattle.GameFastSkill==true and a.fastPrefabId2>0 then
t=a.fastPrefabId2
end
end
end
if t<=0 then
t=a.prefabId
if ModulesInit.ProcedureNormalBattle.CheckDoGameFastSkillPlayFirstAnim(i)==false then
if ModulesInit.ProcedureNormalBattle.GameFastSkill==true and a.fastPrefabId>0 then
t=a.fastPrefabId
end
end
end
end
return t
end
function e:GetBuffPrefabIdByReleaseHeroId(o,t)
local a=0
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if t then
a=t.symphonyDid
end
local e=e:GetBuffPrefabIdBySymphonyDid(o,a)
return e
end
function e:GetBuffPrefabIdBySymphonyDid(o,a)
local t=0
if a>0 then
local o=o.symphonyPrefabIds
t=e:SearchSymphonyPrefabId(o,a)
end
if t==nil or t==0 then
t=o.prefabId
end
return t
end
function e:SearchSymphonyPrefabId(e,t)
for a=1,#e do
local e=e[a]
if e[1]==9999 or t==e[1]then
return e[2]
end
end
return 0
end
function e:GetAmuletRateAddByCamp(e)
if e==ECampType.Wind then
return HeroAttrId.amuletWindRateAdd
elseif e==ECampType.Flower then
return HeroAttrId.amuletFlowerRateAdd
elseif e==ECampType.Snow then
return HeroAttrId.amuletSnowRateAdd
elseif e==ECampType.Moon then
return HeroAttrId.amuletMoonRateAdd
end
return nil
end
function e:GetAmuletResRateAddByCamp(e)
if e==ECampType.Wind then
return HeroAttrId.amuletWindResRateAdd
elseif e==ECampType.Flower then
return HeroAttrId.amuletFlowerResRateAdd
elseif e==ECampType.Snow then
return HeroAttrId.amuletSnowResRateAdd
elseif e==ECampType.Moon then
return HeroAttrId.amuletMoonResRateAdd
end
return nil
end
function e:GetMinHpPercentHeroArr(e,o)
if#e<=0 then
return e
end
table.sort(e,function(e,t)
local a=e:CurrHPPer()
local o=t:CurrHPPer()
if a~=o then
return a<o
end
return e.HeroId<t.HeroId
end)
local t={}
local a=#e
if o~=nil then
a=math.min(o,#e)
end
local o=e[a]
if o then
local n={}
local i=o:CurrHPPer()
for a=1,#e do
local o=e[a]:CurrHPPer()
if o<i then
table.insert(t,e[a])
elseif o==i then
table.insert(n,e[a])
end
end
if#t<a then
local e=RandomTableWithSeed(n,a-#t)
table.appendList(t,e)
end
end
return t
end
function e:GetMaxHpPercentHeroArrByHeroArr(e,t)
table.sort(e,function(e,a)
local t=e:CurrHPPer()
local o=a:CurrHPPer()
if t~=o then
return t>o
end
return e.HeroId<a.HeroId
end)
local o={}
local a=#e
if t~=nil then
a=math.min(t,#e)
end
for t=1,a do
table.insert(o,e[t])
end
return o
end
function e:GetMaxSepsisHpPercentHeroArrByHeroArr(e,i)
table.sort(e,function(o,t)
local e=o:CurrSepsisHPPer()
local a=t:CurrSepsisHPPer()
if e~=a then
return e>a
end
return o.HeroId<t.HeroId
end)
local a={}
local t=#e
if i~=nil then
t=math.min(i,#e)
end
for t=1,t do
table.insert(a,e[t])
end
return a
end
function e:GetMaxFuryHeroArrByHeroArr(e,o)
table.sort(e,function(o,a)
local t=o.HeroBattleInfo.CurrFury
local e=a.HeroBattleInfo.CurrFury
if t~=e then
return t>e
end
return o.HeroId<a.HeroId
end)
local a={}
local t=#e
if o~=nil then
t=math.min(o,#e)
end
for t=1,t do
table.insert(a,e[t])
end
return a
end
function e:AddSepsisHpByHurt(n,t,i,a,o)
if t.DamageToSepsissRate>0 then
local i=math.floor(i*t.DamageToSepsissRate*MillionCoe)
e:AddSepsisHp(n,t,i,a,o)
end
end
function e:AddSepsisHp(a,e,t,i,o)
local a=false
if e and e.HeroBattleInfo then
t=t*e:GetSepsisRate()
if i==true then
a=e:AddSepsisHpDirect(t,o)
else
a=e:AddSepsisHp(t)
end
end
return a
end
function e:ReducePercentSepsisHp(h,t,i,s,n,o,a)
if t.HeroBattleInfo.SepsisHp>0 then
local i=math.floor(t.HeroBattleInfo.SepsisHp*i*MillionCoe)
e:ReduceSepsisHp(h,t,i,s,n,o,a)
end
end
function e:ReduceSepsisHp(i,e,t,n,o,a,s)
if e and e.HeroBattleInfo then
a=a or 0
t=math.min(t,e.HeroBattleInfo.SepsisHp)
if t>0 then
if n==true then
e:ReduceSepsisHpDirect(t,o)
e:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,i.HeroId,a,s)
else
e:ReduceSepsisHpDirect(t,o)
e:HpHealthWithBuff(t,EBattleSrcType.Buff,i.HeroId,a)
end
end
end
end
function e:ReduceSepsisHpPercent(h,t,i,a,o,n,s)
if t and t.HeroBattleInfo then
local s=t.HeroBattleInfo.SepsisHp
local i=math.floor(s*i*MillionCoe)
e:ReduceSepsisHp(h,t,i,a,o,n,forc)
end
end
function e:GetNotFullFuryHero(e,o)
local a={}
for t=1,#e do
if e[t]:IsFullFury()==false then
table.insert(a,e[t])
end
end
local e=RandomTableWithSeed(a,o)
return e
end
function e:GetHeroListByProfession(e,o)
local a={}
for t=1,#e do
if e[t].profession==o then
table.insert(a,e[t])
end
end
return a
end
function e:IsDependAtkType(e)
if e==ETriggerSkillAtkType.AttachAttack or e==ETriggerSkillAtkType.AsistAttachAttack then
return true
end
return false
end
function e:GetEnemySepsisCount(t)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local e=e.GetSepsisCount(t)
return e
end
function e.GetSepsisCount(t)
local e=0
for a=1,#t do
local t=t[a]
if t.HeroBattleInfo.CurrSepsisHp>0 then
e=e+1
end
end
return e
end
function e.GetOtherHeroInSameColumn(t)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.selfColumn)
if#e>1 then
for a=1,#e do
if e[a].HeroId~=t.HeroId then
return e[a]
end
end
end
return nil
end
function e:HandleMultiRoundOverlapBuff(e,a,o,t)
local a=a or 1
for t=1,a do
table.insert(e.roundArr,o)
end
local a=#e.roundArr
if a>t and t>=0 then
for t=a-t,1 do
table.remove(e.roundArr,t)
end
end
e.floors=#e.roundArr
end
function e:ReduceHeroBuffFloor(s,t,n,e,h)
local o=s.HeroBattleInfo:GetBuff(t)
if o then
local i=o:GetFloors()
if i>0 then
if e==nil then
e=BuffRemoveType.Expire
end
if e==BuffRemoveType.Dispel then
local e=a:GetBuffCfg(t)
if e.canDispel<=0 then
return false,0
end
end
o:ReduceFloors(n)
local a=i-n
if a<=0 then
s.HeroBattleInfo:RemoveBuffWithId(t,e,h)
end
return true,a
end
end
return false,0
end
function e:GetHeroBuffFloor(t,e)
local e=t.HeroBattleInfo:GetBuff(e)
if e then
local e=e:GetFloors()
return e
end
return 0
end
function e:GetUnderControlTransferSkinEnemyList(i,a,o)
local t={}
local e=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroIdTable()
if(e)then
for n=1,#e do
local e=e[n]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e:GetTeamId()~=i:GetTeamId()then
if e:CheckCanAddUnderControlTransferSkinBuff(a)then
if o then
if e.HeroBattleInfo:HasStrongControlBuff()==false then
table.insert(t,e)
end
else
table.insert(t,e)
end
end
end
end
end
return t
end
function e:GetUnderControlTransferSkinAllEnemyList(e,i,a)
local t={}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(e)then
for o=1,#e do
local e=e[o]
if e:CheckCanAddUnderControlTransferSkinBuff(i)then
if a then
if e.HeroBattleInfo:HasStrongControlBuff()==false then
table.insert(t,e)
end
else
table.insert(t,e)
end
end
end
end
return t
end
function e:SetUnderControlTransferSkinState(e,o)
if e==nil then
return false
end
local t=a:GetBuffCfg(o)
if(t==nil)then
GameInit.LogError("对应的Buff不存在 buffId %s",o)
return false
end
if t.transferPrefabId<=0 then
return false
end
e:SetUnderControlTransferSkin(true,t.transferPrefabId)
e:CheckRestoreUnderControlTransferSkin()
return true
end
function e:GetCurEnemyList(o)
local t={}
local e=ModulesInit.ProcedureNormalBattle.GetBeAttackHeroIdTable()
if(e)then
for a=1,#e do
local e=e[a]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e:GetTeamId()~=o:GetTeamId()then
if e:CheckHeroCanDoAction()then
table.insert(t,e)
end
end
end
end
return t
end
function e:GetYByXInAntilinea(t,o,i,e,a)
if e<=0 then
return 0
elseif e<a then
local i=(o-i)/(a-e)
local o=o-i*a
if t<e then
t=e
end
if t>a then
t=a
end
local e=i*t+o
return e
else
return buffData[1]
end
end
function e:GetHeroListByHeroAndProfession(a,t)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.ourAll)
return e:GetHeroListByProfession(a,t)
end
function e:GetHeroByFinalHighAtk(a)
local e=nil
local t=0
for o=1,#a do
local a=a[o]
local o=a:GetFinalAtk()
if e==nil then
e=a
t=o
else
if o>t then
e=a
t=o
end
end
end
return e
end
function e:SortHeroByFinalHighAtk(t)
local e={}
for a=1,#t do
local t=t[a]
local a=t:GetFinalAtk()
local t={
heroCtrl=t,
finalAtk=a,
heroId=t.HeroId
}
table.insert(e,t)
end
table.sort(e,function(e,t)
if e.finalAtk~=t.finalAtk then
return e.finalAtk>t.finalAtk
end
return e.heroId>t.heroId
end)
local t={}
for a=1,#e do
table.insert(t,e[a].heroCtrl)
end
return t
end
function e:FindMostBigAtk(t)
local a=0
local e=nil
for i=1,#t do
local o=t[i]:GetFinalAtk()
if e==nil then
e=t[i]
a=o
elseif o>a then
e=t[i]
a=o
end
end
return e,a
end
function e:FindMostBigDef(e)
local t=0
local a=nil
for i=1,#e do
local o=e[i]:GetFinalDef()
if a==nil then
a=e[i]
t=o
elseif o>t then
a=e[i]
t=o
end
end
return a,t
end
function e:FindMostSmallDef(e)
local t=0
local a=nil
for o=1,#e do
local i=e[o]:GetFinalDef()
if a==nil then
a=e[o]
t=i
elseif i<t then
a=e[o]
t=i
end
end
return a,t
end
function e:FindMostBigInjureRateAdd(e)
local a=0
local t=nil
local o=require("Modules/Battle/Formula")
for i=1,#e do
local o=o:GetInjureData(e[i])
local o=o.attackFinalInjureRate
if t==nil then
t=e[i]
a=o
elseif o>a then
t=e[i]
a=o
end
end
return t,a
end
function e:FindHighTreatment(a)
local e=0
local t=nil
for o=1,#a do
local i=a[o].TotalTreatment
if t==nil then
t=a[o]
e=e
elseif i>e then
t=a[o]
e=i
end
end
return t,e
end
function e:AddImmuneDebuffDizzy(e)
e:AddImmunneBuffId(3001)
e:AddImmunneBuffId(3021)
end
function e:ReduceImmuneDebuffDizzy(e)
e:ReduceImmunneBuffId(3001)
e:ReduceImmunneBuffId(3021)
end
function e:GetConCtrlHeroInTeam(t,i,o)
if t==nil or t.CurrBattleTeam==nil then
return{}
end
local e={}
local t=t.CurrBattleTeam:GetAllHeros()
for a=1,#t do
if t[a].HeroBattleInfo:HasControlBuff()then
if o~=false then
table.insert(e,t[a])
end
else
if o==false then
table.insert(e,t[a])
end
end
end
if#e>0 and i then
local e=RandomTableWithSeed(e,i)
return e
end
return e
end
function e:GetStealHeroInTeam(t,a,o)
if t==nil or t.CurrBattleTeam==nil then
return{}
end
return e:GetStealHeroByTeam(t.CurrBattleTeam,a,o)
end
function e:GetStealEnemyHeroInTeam(t,o,a)
if t==nil or t.CurrBattleTeam==nil or t.CurrBattleTeam.OpponentTeam==nil then
return{}
end
return e:GetStealHeroByTeam(t.CurrBattleTeam.OpponentTeam,o,a)
end
function e:GetStealHeroByTeam(t,o,a)
if t==nil then
return{}
end
local e={}
local t=t:GetAllHeros()
for a=1,#t do
local o=t[a].HeroBattleInfo:GetGranBuffCanSteal(o,true)
if#o>0 then
table.insert(e,t[a])
end
end
if#e>0 and a then
local e=RandomTableWithSeed(e,a)
return e
end
return e
end
function e:IsGranOrFalseBuff(e)
local e=a:GetBuffCfg(e)
if e.isGran==1 or e.isGran==0 then
return true
end
return false
end
function e:GetConCtrlAndStealHeroInTeam(t,o)
if t==nil or t.CurrBattleTeam==nil then
return{}
end
local e={}
local t=t.CurrBattleTeam:GetAllHeros()
for a=1,#t do
if t[a].HeroBattleInfo:HasControlAndStealBuff()then
table.insert(e,t[a])
end
end
if#e>0 and o then
local e=RandomTableWithSeed(e,o)
return e
end
return e
end
function e:GetbuffMaxFloorsInTeam(t,i)
local e=0
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local o=nil
for a=1,#t do
local a=t[a]
local t=a.HeroBattleInfo:GetBuff(i)
if t then
local t=t:GetFloors()
if t>e then
e=t
o=a
end
end
end
return e,o
end
function e:ShowCampionEffect(t,n,s,i,o,a,h)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
i=i or 0.4
a=a or 2
if o==nil then
o=true
end
if o then
t.CurrHeroCtrl:ChangeState(HeroState.Attack)
t.CurrHeroCtrl:PlaySpineAnim("special",false,true)
end
if n then
local e={}
if h then
e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
else
e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
end
for t=1,#e do
local e=e[t]
e:DelayPlayBuffEffect(a,n)
end
end
local a=t:GetPrefabIdInCfg()
ModulesInit.GlobalBattleEffectMgr.HideEffect(a,0,false)
local t,e=e:GetPosOffset(t,s)
ModulesInit.GlobalBattleEffectMgr.ShowEffect(a,t,e,50,i,0,false,function()
end)
end
end
function e:HideCampionEffect(e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=e:GetPrefabIdInCfg()
ModulesInit.GlobalBattleEffectMgr.HideEffect(e,0,false)
end
end
function e:GetPosOffset(t,o)
local e=0
local a=0
if o==EBattleCampionPosType.OurTeamCenter then
e=4
a=-2
if t.CurrHeroCtrl.CurrBattleTeam and t.CurrHeroCtrl.CurrBattleTeam.TeamId==1 then
e=-4
end
elseif o==EBattleCampionPosType.EnemyTeamCenter then
e=-4
a=-2
if t.CurrHeroCtrl.CurrBattleTeam and t.CurrHeroCtrl.CurrBattleTeam.TeamId==1 then
e=4
end
else
local t=t.CurrHeroCtrl:GetFootPointPos()
e=t.x
a=t.y
end
return e,a
end
function e:GetTeamCenterPos(t,a)
local e=4
if t==1 then
e=-4
end
if a==false then
e=-e
end
return Vector3(e,-2.5,0)
end
function e:ShowBgEffectByBuff(e,t)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
t=t or{}
local i=t.isEnvironmentEffect
local o=t.isPlayAnim
local a=t.delay or 0.5
if o~=false then
e.CurrHeroCtrl:ChangeState(HeroState.Attack)
e.CurrHeroCtrl:PlaySpineAnim("special",false,true)
end
local t=e:GetPrefabIdInCfg()
local e={
TeamId=e.CurrHeroCtrl:GetTeamId(),
battleStationIndex=e.CurrHeroCtrl.battleStationIndex,
HeroId=e.releaseHeroId,
buffId=e.buffId,
prefabId=t,
targetPosX=0,
targetPosY=0,
targetPosZ=90,
delay=a,
fadeIn=0.5,
bShowSpeed=false,
onComplete=function()
end,
isEnvironmentEffect=i,
}
ModulesInit.ProcedureNormalBattle.ShowBgEffect(e)
end
end
function e:RemoveBgEffectByBuff(e)
if GameInit.IsClient then
local t=e:GetPrefabIdInCfg()
local e={
HeroId=e.releaseHeroId,
buffId=e.buffId,
prefabId=t,
fadeOut=0.5,
bShowSpeed=false,
}
ModulesInit.ProcedureNormalBattle.HideBgEffect(e)
end
end
function e:isFlipByMirror(a,t)
local e=false
if(a==1)then
if ModulesInit.ProcedureNormalBattle:GetMirrorScaleX()==-1 then
if(t)then
e=true
end
else
if(not t)then
e=true
end
end
end
return e
end
function e:CheckCanTriggerFatalDmgBefore(t)
if e:CheckCanTriggerFatalDmgBeforeBaseCond(t)==false then
return false
end
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.fatalDmgBeforeCheckSuccess)
if e:CheckCanTriggerFatalDmgBeforeBaseCond(t)==false then
return false
end
return true
end
function e:CheckCanTriggerFatalDmgBeforeBaseCond(e)
if e:IsNothingToDoState()then
return false
end
if e:IsLiveAgainState()then
return false
end
if e.HeroBattleInfo.CurrHP>0 then
return false
end
return true
end
function e:GetEnemysWithBuff(e,a,t)
if e and e.CurrBattleTeam and e.CurrBattleTeam.OpponentTeam then
local e=e.CurrBattleTeam.OpponentTeam:GetAllHeroWithBuff(a,t)
return e
end
return{}
end
function e:GetEnemysWithBuffSortMost(t,a,o)
local e=e:GetEnemysWithBuff(t,a,o)
for e=1,#e do
end
end
function e:GetMatesWithBuff(e,t,a)
if e and e.CurrBattleTeam then
local e=e.CurrBattleTeam:GetAllHeroWithBuff(t,a)
return e
end
return{}
end
function e:GetNewTable(t)
local e={}
for a=1,#t do
table.insert(e,t[a])
end
return e
end
function e:GetHeroCountByFormation(e)
local t=0
if e then
for a=1,#e do
local e=e[a]
if e.heroId~=0 then
t=t+1
end
end
end
return t
end
function e:GetDataByWeight(e)
local t=0
for a=1,#e,2 do
t=t+e[a+1]
end
if t>0 then
local o=RandomMgr:GetBattleRandomWithRange(1,t)
local t=0
for a=1,#e,2 do
t=t+e[a+1]
if o<=t then
return e[a]
end
end
end
return nil
end
function e:GetRandomWeightData(a,o)
local t={}
for o=1,o do
if#a>0 then
local e=e:GetOneRandomWeightData(a)
table.insert(t,e)
end
end
return t
end
function e:GetOneRandomWeightData(e)
local t=0
for a=1,#e do
t=t+e[a].weight
end
if t>0 then
local o=RandomMgr:GetBattleRandomWithRange(1,t)
local t=0
for a=1,#e do
t=t+e[a].weight
if o<=t then
local e=table.remove(e,a)
return e
end
end
end
return nil
end
function e:CheckHasOneBuff(a,e)
for t=1,#e do
local e=e[t]
local e=a.HeroBattleInfo:GetBuff(e)
if e then
return true
end
end
return false
end
function e.GetShieldCanAdd(i,s,a,n,e)
local o=math.floor(a*e*MillionCoe)
local t=0
local e=i.HeroBattleInfo:GetBuffValue(s,HeroAttrId.shield)
if e then
t=e.value
end
local e=n*MillionCoe
local e=math.floor(a*e)
e=math.min(t+e,o)
return e
end
function e.GetSkillIdListByHeroId(o)
if e.skillIdMap==nil then
e.skillIdMap={}
local t=w.GetList()
for a=1,#t do
local t=t[a]
if e.skillIdMap[t.heroId]==nil then
e.skillIdMap[t.heroId]={}
end
table.insert(e.skillIdMap[t.heroId],t.id)
end
end
local e=e.skillIdMap[o]or{}
return e
end
function e.SetHeroHead(t,e)
local t=LuaUtils.GetLuaComBinder(t.transform)
local t=t:GetComponents()
LuaUtils.SetImageSprite(t["im_touxiang"],"UIHeroHead/"..e.DTmodelRow.head,false)
if e:IsMonsterRole()then
LuaUtils.SetImageSprite(t["im_quality"],string.format("UICommonOther/%s",CardQuailtyFont[e.DTMonsterRow.star]),true)
else
LuaUtils.SetImageSprite(t["im_quality"],string.format("UICommonOther/%s",CardQuailtyFont[e.DTHeroRow.star]),true)
end
local a=BreakCardQuailtyBgs[e.lockLevel]
if a==nil then
a=BreakCardQuailtyBgs[1]
end
LuaUtils.SetImageSprite(t["im_frame"],string.format("UICommonOther/%s",a),true)
LuaUtils.SetImageSprite(t["im_occupation"],string.format("UICommonOther/%s",ProfessionIcons[e.profession]),true)
local a=e.rankLevel
local t=t["starts"]
local e=LuaUtils.GetChildrenCount(t)
for e=1,e do
local t=UIUtil.GetChild(t,e-1)
if e<=a then
LuaUtils.SetActive(t,true)
else
LuaUtils.SetActive(t,false)
end
end
end
function e.RefreshBuffIcon(o,t,e)
UIUtil.RefreshGridItemInfo(o.transform,e,function()
local e=LuaUtils.Instantiate(t.transform)
LuaUtils.SetActive(e,true)
return e
end,function(e,t)
local e=LuaUtils.GetLuaComBinder(e.transform)
local e=e:GetComponents()
local a=a:GetBuffCfg(t.buffId)
LuaUtils.SetImageSprite(e["buff_icon"],string.format("UIBuffIcon/%s",a.buffIcon),false)
local a=t.textCount.gameObject.activeSelf
if a then
LuaUtils.SetActive(e['text_huihe'].transform,true)
local t=t.textCount.text
LuaUtils.SetTextMeshText(e['text_huihe'],t)
else
LuaUtils.SetActive(e['text_huihe'].transform,false)
end
end)
end
function e.RefreshBossBuffIcon(t,e,o)
UIUtil.RefreshGridItemInfo(t.transform,o,function()
local e=LuaUtils.Instantiate(e.transform)
LuaUtils.SetActive(e,true)
return e
end,function(t,e)
local t=LuaUtils.GetLuaComBinder(t.transform)
local t=t:GetComponents()
local a=a:GetBuffCfg(e.buffId)
local a=a.buffIcon
LuaUtils.SetImageSprite(t["buff_icon"],string.format("UIBuffIcon/%s",a),false)
if(e.round>1 or e.floors>1)then
if(e.floors>1)then
LuaUtils.SetTextMeshText(t["text_huihe"],e.floors)
else
LuaUtils.SetTextMeshText(t["text_huihe"],e.round)
end
LuaUtils.SetActive(t["text_huihe"].transform,true)
else
LuaUtils.SetActive(t["text_huihe"].transform,false)
end
end)
end
function e.GetHeroDeadHurtValue(e)
if e and e.HeroBattleInfo then
return e.HeroBattleInfo.MaxHP*99+99999999
end
return 99999999
end
function e.IsBigRoundStart(e,t)
if t==nil then
return false
end
if ModulesInit.ProcedureNormalBattle.OurTeamFirstAttack==t.IsOurHero then
if e==BuffTriggerTime.eachRoundStart then
return true
end
else
if e==BuffTriggerTime.enemyRoundStart then
return true
end
end
return false
end
function e:GetTargetHeroCtrl(e)
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e and e:CheckHeroCanDoAction()then
return e
end
return nil
end
function e:AddHPAndMaxHP(t,a)
if t==nil then
return
end
local e=t.HeroBattleInfo
if e==nil then
return
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e:AddHPAndMaxHP(a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function e:CheckHasEnemyHpPerNotEnough(e,a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(e)then
for t=1,#e do
local e=e[t]
if e:CurrHPPer()<a*MillionCoe then
return true
end
end
end
return false
end
function e:StealMultiEnemyBuff(t,o,a)
local a=e:GetStealEnemyHeroInTeam(t,o,a)
for i=1,#a do
e:StealEnemyAllBuff(t,a[i],o)
end
return false
end
function e:StealEnemyAllBuff(t,o,e)
local e=o.HeroBattleInfo:GetGranBuffCanSteal(e,true)
for a=1,#e do
local e=e[a]
local a=e.buffId
local n=e:GetRound()
local i=e:GetBuffData()
local s=e:GetFloors()
local e=o.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.BeStolen)
if e then
if t.HeroBattleInfo then
t:AddBuff(t,a,n,i,s)
if t.HeroBattleInfo then
t.HeroBattleInfo:PlayBattleEffectWithBuffId(a)
end
end
end
end
return false
end
function e:IsNormalHurtType(e)
if e==HeroHurtType.thorn or e==HeroHurtType.healThorn or e==HeroHurtType.hpChain then
return false
end
return true
end
function e:GetHeroDeathEffect(e)
if f[e]then
return f[e]
else
return SysEffectId.Hero_Death
end
end
function e:SetAllEnemyDisableDefFuryhealthInCurAttack(e,a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll,nil,nil,nil,nil,{isContainUsualState=true})
if(e~=nil)then
local t=#e
for t=1,t do
local e=e[t]
e:SetDisableDefFuryhealthInCurAttack(a)
end
end
end
function e:GetHeroNoBuff(e,a,o,i)
local t={}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
for o=1,#e do
local e=e[o]
local a=e.HeroBattleInfo:GetBuff(a)
if a==nil then
table.insert(t,e)
end
end
local a={}
if#t>0 then
a=RandomTableWithSeed(t,o)
elseif#e>0 and i~=true then
a=RandomTableWithSeed(e,o)
end
return a
end
function e:GetHeroNoBuffByType(n,s,i,a,t)
local e={}
local o={}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(n,s,nil,nil,nil,nil,{isContainUsualState=t})
for a=1,#t do
local t=t[a]
local a=t.HeroBattleInfo:GetBuff(i)
if a==nil then
table.insert(e,t)
else
table.insert(o,t)
end
end
local t={}
if a~=nil then
if#e>0 then
t=RandomTableWithSeed(e,a)
end
else
t=e
end
return t,o
end
function e:AddBuffWithBuffInfo(a,e)
local o=e.buffId
local i=e:GetRound()
local t={}
table.appendList(t,e:GetBuffData())
local e=a:AddBuff(e.CurrHeroCtrl,o,i,t)
return e
end
function e:AddBuffWithBuffCopy(s,n,e,t)
t=t or{}
local a=EBuffAddType.Normal
if e.buffAddType==EBuffAddType.FightBack then
a=EBuffAddType.FightBack
end
t.buffTriggerAddType=a
local a=e.buffId
local o=e.round
local i=e.buffData
local e=e.floors
local e=s:AddBuff(n,a,o,i,e,t)
return e
end
function e:AddBuffByBuffInfo(s,i,t,e)
e=e or{}
e.buffTriggerAddType=EBuffAddType.Normal
local n=t.buffId
local a=t:GetRound()
local o=t:GetBuffData()
local t=t:GetFloors()
local e=s:AddBuff(i,n,a,o,t,e)
return e
end
function e:GetHeroMostBuffFloor(t,a,o)
local e=e:GetHeroListBuffFloorBaseData(t,a,o,true)
local e=e[1]
if e then
local e=RandomTableWithSeed(e,1)
local e=e[1]
if e then
return e.enemy,e.floors
end
end
return nil
end
function e:GetHeroListBuffFloor(o,n,i,s,a)
local t={}
local e=e:GetHeroListBuffFloorBaseData(o,n,i,s)
if a==nil then
for a=1,#e do
local e=e[a]
table.appendList(t,e)
end
else
for o=1,#e do
local e=e[o]
if e then
local a=a-#t
if a<=0 then
break
end
if#e<=a then
table.appendList(t,e)
else
local e=RandomTableWithSeed(e,a)
table.appendList(t,e)
break
end
end
end
end
return t
end
function e:GetHeroListBuffFloorBaseData(e,o,i,a)
if a==nil then
a=true
end
local t=0
local t=nil
local t={}
local n={}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,o)
for a=1,#e do
local o=e[a]
local a=o.HeroBattleInfo:GetBuff(i)
local e=0
if a then
e=a:GetFloors()
end
if t[e]==nil then
t[e]={floors=e}
end
local a={
enemy=o,
floors=e,
}
table.insert(t[e],a)
end
local e=table.mapToList(t)
if a then
table.sort(e,function(t,e)
return t.floors>e.floors
end)
else
table.sort(e,function(t,e)
return t.floors<e.floors
end)
end
return e
end
function e:GetHeroListByGran(t,a,o,i)
local e={}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,a)
for a=1,#t do
local t=t[a]
local a=t.HeroBattleInfo:HasGranOrUnGran(o,i)
if a then
table.insert(e,t)
end
end
return e
end
function e.HasOnFieldHeroDid(a,e,t)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,e)
for a=1,#e do
if e[a].heroDid==t then
return true
end
end
return false
end
return e 
