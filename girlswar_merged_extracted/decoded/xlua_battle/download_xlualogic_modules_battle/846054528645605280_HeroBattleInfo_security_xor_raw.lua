local e=require("DataNode/DataTable/Create/constant/DTBattleAttrDBModel")
local t=require("DataNode/DataManager/DataMgr/DataUtil")
local s=require("Modules/Battle/BattleUtil")
local o=require("Modules/Battle/Formula")
local a=-0.9999
HeroBattleInfo={}
function HeroBattleInfo:New(e)
local e={
CurrHeroCtrl=e,
Level=0,
HP=0,
CurrHP=0,
BeforeTimeLineHP=0,
OriginalHP=0,
MaxHP=0,
MaxHpAddRate=0,
MaxHpAddValue=0,
SepsisHp=0,
CurrSepsisHp=0,
CurrMaxHP=0,
Fury=Constant.battle_fury_max,
OriginalFury=0,
CurrFury=0,
BeforeTimeLineFury=0,
OverdrawFury=0,
BeforeTimeLineOverdrawFury=0,
Atk=0,
Def=0,
Critical=0,
CriticalRes=0,
CriticalStrength=0,
Block=0,
BlockRes=0,
BlockStrength=0,
Injure=0,
InjureRes=0,
Control=0,
ControlRes=0,
Blood=0,
Thorn=0,
Heal=0,
ProfRes=0,
ProfResed=0,
eXSkillINjure=0,
eXSkillINjureRes=0,
beforeEnergy=0,
SkillInjure=0,
SkillInjureRes=0,
SkillTriggerRate=0,
First=0,
IgnoreDefRate=0,
atkRate=0,
defRate=0,
tenacityRate=0,
armor=0,
criticalStrengthRes=0,
evade=0,
evadeRes=0,
tenacityResRate=0,
petAtk=0,
petCritical=0,
petCriticalRes=0,
petCriticalStrength=0,
petInjure=0,
petInjureRes=0,
petControl=0,
petControlRes=0,
petCriticalStrengthRes=0,
petDefFactor=0,
petAtkFactor=0,
curArmor=0,
BuffDic={},
BuffValueDic={},
TempBuffValueDic={},
Skills={},
battleEffects={},
skillHurtRateAdd={},
underWearSuits={},
BeforeTimeLineBuffValueDic={},
attrValueDicInBattle={},
attrValueDicInCurAttack={},
immuneBuffMap={},
mCtrlBuffImmuneMap={},
treasures={},
BeansStatFury=0,
BeforeTimeLineBeansStatFury=0,
BeansStatCount=0
}
setmetatable(e,self)
self.__index=self
return e
end
function HeroBattleInfo:DisposeBuff()
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:DisposeBuff() When isTimeLine!")
return
end
local e=self:GetBuffSortArr()
for t=1,#e do
local e=e[t]
self:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
end
self.BuffDic={}
self.BuffValueDic={}
self.TempBuffValueDic={}
self.attrValueDicInBattle={}
self.attrValueDicInCurAttack={}
DoTableDispose(self.battleEffects)
self.battleEffects={}
end
function HeroBattleInfo:Dispose()
self.Level=0
self.HP=0
self.CurrHP=0
self.MaxHP=0
self.OriginalHP=0
self.MaxHpAddRate=0
self.MaxHpAddValue=0
self.SepsisHp=0
self.CurrSepsisHp=0
self.CurrMaxHP=0
self.Fury=Constant.battle_fury_max
self.OriginalFury=0
self.CurrFury=0
self.OverdrawFury=0
self.Atk=0
self.Def=0
self.Critical=0
self.CriticalRes=0
self.CriticalStrength=0
self.Block=0
self.BlockRes=0
self.BlockStrength=0
self.Injure=0
self.InjureRes=0
self.Control=0
self.ControlRes=0
self.Blood=0
self.Thorn=0
self.Heal=0
self.ProfRes=0
self.ProfResed=0
self.eXSkillINjure=0
self.eXSkillINjureRes=0
self.beforeEnergy=0
self.SkillInjure=0
self.SkillInjureRes=0
self.SkillTriggerRate=0
self.First=0
self.IgnoreDefRate=0
self.atkRate=0
self.defRate=0
self.tenacityRate=0
self.armor=0
self.criticalStrengthRes=0
self.evade=0
self.evadeRes=0
self.tenacityResRate=0
self.petAtk=0
self.petCritical=0
self.petCriticalRes=0
self.petCriticalStrength=0
self.petInjure=0
self.petInjureRes=0
self.petControl=0
self.petControlRes=0
self.petCriticalStrengthRes=0
self.petDefFactor=0
self.petAtkFactor=0
self.Skills={}
self.underWearSuits={}
self.treasures={}
local e=self:GetBuffSortArr()
for t=1,#e do
local e=e[t]
self:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
end
self.CurrHeroCtrl=nil
self.BuffDic={}
self.BuffValueDic={}
self.TempBuffValueDic={}
self.attrValueDicInBattle={}
self.attrValueDicInCurAttack={}
DoTableDispose(self.battleEffects)
self.battleEffects={}
self.skillHurtRateAdd={}
self.immuneBuffMap={}
self.mCtrlBuffImmuneMap={}
self.BeansStatFury=0
self.BeansStatCount=0
end
function HeroBattleInfo:ResetHpAndSepsis()
self.CurrSepsisHp=0
self.SepsisHp=0
self.CurrHP=self.MaxHP
self.CurrMaxHP=self.MaxHP
end
function HeroBattleInfo:SetHpEmptyWhenDeath()
self.CurrHP=0
end
function HeroBattleInfo:SetHp(e,t,o,a)
if t~=true then
if self.curArmor>0 and self.CurrHP>=e then
return
end
end
if self.CurrHeroCtrl then
if self.CurrHeroCtrl:IsDeathOrWaitState()then
return
end
end
local t=self.CurrHP
self.CurrHP=math.max(0,math.floor(e))
self.CurrHP=math.min(self.CurrMaxHP,self.CurrHP)
if ModulesInit.ProcedureNormalBattle.IsStakeFightUndead()then
if self.CurrHP<=0 then
self:ResetHpAndSepsis()
end
end
if ModulesInit.ProcedureNormalBattle.CurrAttackHeroId==self.CurrHeroCtrl.HeroId then
if self.CurrHP<=0 then
self.CurrHP=1
end
end
if e~=t then
local e={
oldHP=t,
currHP=self.CurrHP,
hpchangeType=o or EBattleHpChangeType.None,
heroHurtType=a,
}
self:TriggerBuff(BuffTriggerTime.hpChange,self.CurrHeroCtrl,self.CurrHeroCtrl,e)
end
end
function HeroBattleInfo:ResetHp(t,e)
self:SetHp(t,e,EBattleHpChangeType.ResetHp)
end
function HeroBattleInfo:IsFullHp()
return self.CurrHP>=self.MaxHP
end
function HeroBattleInfo:AddHp(e,t)
local e=self.CurrHP+e
self:SetHp(e,t,EBattleHpChangeType.AddHp)
end
function HeroBattleInfo:ReducedHp(e,t)
local e=self.CurrHP-e
self:SetHp(e,nil,EBattleHpChangeType.ReduceHp,t)
end
function HeroBattleInfo:AddMaxHpAddValue(e)
self.MaxHpAddValue=math.max(1-self.MaxHP,self.MaxHpAddValue+e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function HeroBattleInfo:RemoveMaxHpAddValue(e)
self.MaxHpAddValue=math.max(1-self.MaxHP,self.MaxHpAddValue-e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function HeroBattleInfo:AddMaxHpAddRate(e)
self.MaxHpAddRate=math.max(a,self.MaxHpAddRate+e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function HeroBattleInfo:RemoveMaxHpAddRate(e)
self.MaxHpAddRate=math.max(a,self.MaxHpAddRate-e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function HeroBattleInfo:SetSepsisHPValue(e)
self.SepsisHp=math.max(0,e)
self.CurrMaxHP=math.max(1,self.MaxHP-self.SepsisHp)
self.CurrSepsisHp=self.MaxHP-self.CurrMaxHP
self:RefreshCurrHpValue()
end
function HeroBattleInfo:ResetHPAndMaxHP(t)
local a=self.MaxHP
local e=o:CalculateMaxHp(self)
local a=e-a
self.HP=e
self.MaxHP=e
self.CurrMaxHP=math.max(1,self.MaxHP-self.SepsisHp)
self.CurrSepsisHp=self.MaxHP-self.CurrMaxHP
local e=math.max(1,self.CurrHP+a)
self:SetHp(e,true,t)
end
function HeroBattleInfo:ResetMaxHP()
local e=self.MaxHP
local e=o:CalculateMaxHp(self)
self.HP=e
self.MaxHP=e
self.CurrMaxHP=math.max(1,self.MaxHP-self.SepsisHp)
self.CurrSepsisHp=self.MaxHP-self.CurrMaxHP
self:RefreshCurrHpValue()
end
function HeroBattleInfo:RefreshCurrHpValue()
local t=math.min(self.CurrHP,self.CurrMaxHP)
local e=EBattleHpChangeType.ReduceHp
if t>self.CurrHP then
e=EBattleHpChangeType.AddHp
end
self:SetHp(t,true,e)
end
function HeroBattleInfo:AddHPAndMaxHP(e)
self:AddMaxHpAddValue(e)
self:ResetHPAndMaxHP(EBattleHpChangeType.AddHp)
if(self.CurrHeroCtrl)then
self.CurrHeroCtrl:RefreshTeamMaxHP()
self.CurrHeroCtrl:RefreshHP()
end
end
function HeroBattleInfo:ReduceHPAndMaxHP(e)
self:RemoveMaxHpAddValue(e)
self:ResetMaxHP()
if(self.CurrHeroCtrl)then
self.CurrHeroCtrl:RefreshTeamMaxHP()
self.CurrHeroCtrl:RefreshHP()
end
end
function HeroBattleInfo:AddHPAndMaxHPPer(e)
if(self.CurrHeroCtrl)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:AddMaxHpAddRate(e)
self:ResetHPAndMaxHP(EBattleHpChangeType.AddHp)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.CurrHeroCtrl:RefreshTeamMaxHP()
self.CurrHeroCtrl:RefreshHP()
self.CurrHeroCtrl:CheckShowAddMaxHpEffect()
end
end
function HeroBattleInfo:ReduceHPAndMaxHPPer(e)
self:RemoveMaxHpAddRate(e)
self:ResetMaxHP()
if(self.CurrHeroCtrl)then
self.CurrHeroCtrl:RefreshTeamMaxHP()
self.CurrHeroCtrl:RefreshHP()
end
end
function HeroBattleInfo:ReduceHPAndMaxHPPerWithHPLimit(e)
self:RemoveMaxHpAddRate(e)
self:ResetMaxHP()
if(self.CurrHeroCtrl)then
self.CurrHeroCtrl:RefreshTeamMaxHP()
self.CurrHeroCtrl:RefreshHP()
end
end
function HeroBattleInfo:AddMaxHPPer(e)
self:AddMaxHpAddRate(e)
self:ResetMaxHP()
if(self.CurrHeroCtrl)then
self.CurrHeroCtrl:RefreshTeamMaxHP()
self.CurrHeroCtrl:RefreshHP()
end
end
function HeroBattleInfo:ClearSepsisHP(e)
self:SetSepsisHP(0,e)
end
function HeroBattleInfo:AddSepsisHP(e,t)
local e=self.SepsisHp+e
self:SetSepsisHP(e,t)
end
function HeroBattleInfo:ReduceSepsisHP(e,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local e=self.SepsisHp-e
self:SetSepsisHP(e,t)
end
function HeroBattleInfo:SetSepsisHP(t,a)
if(self.CurrHeroCtrl)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local e=self.SepsisHp
self:SetSepsisHPValue(t)
self:TriggerBuff(BuffTriggerTime.sepsissChange,nil,nil,{oldSepsisHp=e,SepsisHp=self.SepsisHp})
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if a~=false then
self.CurrHeroCtrl:RefreshHP()
end
end
end
function HeroBattleInfo:AddFuryWithSoul(e)
if(self.CurrHeroCtrl)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=self:GetTotalBuffAndTempBuffValue(HeroAttrId.furyRate)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e=math.floor(e*(1+t*MillionCoe))
self:AddFury(e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.CurrHeroCtrl:RefreshFury()
end
end
function HeroBattleInfo:SetMaxFury(e)
self.Fury=e
if self.CurrFury>self.Fury then
self.CurrFury=self.Fury
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.CurrHeroCtrl:RefreshFury()
end
function HeroBattleInfo:AddFury(e)
if self.CurrHeroCtrl.ImmuneResumeFury==true then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return
end
if ModulesInit.ProcedureNormalBattle.isTimeLine==false then
if#self.CurrHeroCtrl.mLockFuryBuffList>0 then
local t=self.CurrHeroCtrl.mLockFuryBuffList
local a={}
for o=1,#t do
local t=t[o]
if e>=t.lockFury then
local o=t.lockFury
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e=e-o
t.lockFury=0
table.insert(a,t.buffId)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if e==0 then
break
end
else
local a=e
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e=0
t.lockFury=t.lockFury-a
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
break
end
end
for e=#a,1,-1 do
self:RemoveBuffWithId(a[e])
end
if e<=0 then
return
end
end
if self.OverdrawFury>0 then
if e<=self.OverdrawFury then
self.CurrHeroCtrl:ReduceOverdrawFury(e)
return
else
self.CurrHeroCtrl:ReduceOverdrawFury(self.OverdrawFury)
e=e-self.OverdrawFury
end
end
self:AddStatBeansFury(e)
end
local o=self.CurrFury
local a=self.CurrFury+e
local t=e
if a<=self.Fury then
if self.CurrHeroCtrl then
self.CurrHeroCtrl:AddTeamStatFury(e)
end
self.CurrFury=a
else
if self.CurrHeroCtrl then
self.CurrHeroCtrl:AddTeamStatFury(self.Fury-self.CurrFury)
end
t=self.Fury-self.CurrFury
self.CurrFury=self.Fury
end
self:TriggerBuff(BuffTriggerTime.DoAddFury,nil,nil,{addFuryValue=t,oldFury=o,CurrFury=self.CurrFury,addFuryValueIncludingOverflow=e})
end
function HeroBattleInfo:ReduceFury(e)
local t=self.CurrFury-e
local a=e
if t>=0 then
if self.CurrHeroCtrl then
self.CurrHeroCtrl:ReduceTeamStatFury(e)
end
self.CurrFury=t
else
if self.CurrHeroCtrl then
self.CurrHeroCtrl:ReduceTeamStatFury(self.CurrFury)
end
a=self.CurrFury
self.CurrFury=0
end
return a
end
function HeroBattleInfo:ResetFury(e)
local a=self.CurrFury
if e>self.CurrFury then
if self.CurrHeroCtrl then
local t=e-self.CurrFury
self.CurrHeroCtrl:AddTeamStatFury(t)
self:AddStatBeansFury(t)
self.CurrFury=math.floor(e)
self:TriggerBuff(BuffTriggerTime.DoAddFuryWithReset,nil,nil,{addFuryValue=t,oldFury=a,CurrFury=self.CurrFury,addFuryValueIncludingOverflow=t})
end
else
if self.CurrHeroCtrl then
local t=self.CurrFury-e
self.CurrHeroCtrl:ReduceTeamStatFury(self.CurrFury-e)
self.CurrFury=math.floor(e)
self:TriggerBuff(BuffTriggerTime.DoReduceFuryWithReset,nil,nil,{reduceFuryValue=t,oldFury=a,CurrFury=self.CurrFury})
end
end
self:SetOverdrawFury(0)
end
function HeroBattleInfo:SetOverdrawFury(e)
if e>self.OverdrawFury then
if self.CurrHeroCtrl then
self.CurrHeroCtrl:AddTeamStatOverdrowFury(e-self.OverdrawFury)
end
else
if self.CurrHeroCtrl then
self.CurrHeroCtrl:ReduceTeamStatOverdrowFury(self.OverdrawFury-e)
end
end
self.OverdrawFury=e
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function HeroBattleInfo:GetOverdrawFury()
return self.OverdrawFury
end
function HeroBattleInfo:AddOverdrawFury(e)
self.OverdrawFury=self.OverdrawFury+e
if self.CurrHeroCtrl then
self.CurrHeroCtrl:AddTeamStatOverdrowFury(e)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function HeroBattleInfo:ReduceOverdrawFury(e)
self.OverdrawFury=self.OverdrawFury-e
if self.CurrHeroCtrl then
self.CurrHeroCtrl:ReduceTeamStatOverdrowFury(e)
end
self.OverdrawFury=math.max(self.OverdrawFury,0)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function HeroBattleInfo:AddStatBeansFury(e)
if self.CurrHeroCtrl:IsEnablePowerBeans()==false then
return
end
local t=self.BeansStatFury
self.BeansStatFury=self.BeansStatFury+e
if self.BeansStatFury>=const_need_stat_fury_one_beans then
self.BeansStatFury=const_need_stat_fury_one_beans
if ModulesInit.ProcedureNormalBattle.isTimeLine==false and self.CurrHeroCtrl:IsEnablePowerBeans()then
if t<const_need_stat_fury_one_beans or self.BeansStatCount==0 then
self.BeansStatCount=self.BeansStatCount+1
if self.CurrHeroCtrl and self.CurrHeroCtrl:IsPet()==false then
local e={
heroId=self.CurrHeroCtrl.HeroId,
teamId=self.CurrHeroCtrl:GetTeamId(),
IsOurHero=self.CurrHeroCtrl.IsOurHero,
}
EventSystem.SendEvent(CommonEventId.OnHeroBeanStatCountChange,e)
end
end
end
end
self.CurrHeroCtrl:RefreshHeroPow()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function HeroBattleInfo:ClearAllBeansFury()
self.BeansStatFury=0
self.CurrHeroCtrl:RefreshHeroPow()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function HeroBattleInfo:HasBeans()
if self.BeansStatFury>=const_need_stat_fury_one_beans then
return true
end
return false
end
function HeroBattleInfo:RemoveOneBeans()
self:ClearAllBeansFury()
end
function HeroBattleInfo:SetMonsterData(e)
self.HP=e.hp
self.CurrHP=e.hp
self.MaxHP=e.hp
self.CurrMaxHP=e.hp
self.OriginalHP=e.hp
self.Fury=Constant.battle_fury_max
self.OriginalFury=e.fury
self.CurrFury=e.fury
self.BeansStatFury=e.fury
if(self.CurrHeroCtrl)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
self.Atk=e.atk
self.Def=e.def
self.Critical=e.critical
self.CriticalRes=e.criticalRes
self.CriticalStrength=e.criticalStrength
self.Block=e.block
self.BlockRes=e.blockRes
self.BlockStrength=e.blockStrength
self.Injure=e.injure
self.InjureRes=e.injureRes
self.Control=e.control
self.ControlRes=e.controlRes
self.Blood=e.blood
self.Thorn=e.thorn
self.Heal=e.heal
self.ProfRes=e.ProfRes
self.ProfResed=e.ProfResed
self.eXSkillINjure=e.eXSkillINjure
self.eXSkillINjureRes=e.eXSkillINjureRes
self.First=e.first
self.armor=e.armor
self.criticalStrengthRes=e.criticalStrengthRes
self.evade=e.evade or 0
self.evadeRes=e.evadeRes or 0
end
function HeroBattleInfo:SetMonsterSkill(e)
if(not self.CurrHeroCtrl)then
return
end
self.CurrHeroCtrl.SkillMode=e.skillMode
if(e.skillMode==SkillMode.Normal)then
self.CurrHeroCtrl.BigSkillId=e.monSkill3
self.CurrHeroCtrl.SmallSkillId=e.monSkill2
self.CurrHeroCtrl.NormalSkillId=e.monSkill1
local e
if(self.CurrHeroCtrl.NormalSkillId>0)then
e=HeroSkillInfo:New()
e.SkillType=1
e.SkillDid=self.CurrHeroCtrl.NormalSkillId
table.add(self.Skills,e)
end
if(self.CurrHeroCtrl.SmallSkillId>0)then
e=HeroSkillInfo:New()
e.SkillType=1
e.SkillDid=self.CurrHeroCtrl.SmallSkillId
table.add(self.Skills,e)
end
if(self.CurrHeroCtrl.BigSkillId>0)then
e=HeroSkillInfo:New()
e.SkillType=1
e.SkillDid=self.CurrHeroCtrl.BigSkillId
table.add(self.Skills,e)
end
elseif(e.skillMode==SkillMode.DragonWar)then
self.CurrHeroCtrl.NormalSkillId=e.monSkill1
table.add(self.CurrHeroCtrl.DragonWarBigSkillList,e.monSkill2)
table.add(self.CurrHeroCtrl.DragonWarBigSkillList,e.monSkill3)
table.add(self.CurrHeroCtrl.DragonWarBigSkillList,e.monSkill4)
local t
if(e.monSkill1>0)then
t=HeroSkillInfo:New()
t.SkillType=1
t.SkillDid=e.monSkill1
table.add(self.Skills,t)
end
if(e.monSkill2>0)then
t=HeroSkillInfo:New()
t.SkillType=1
t.SkillDid=e.monSkill2
table.add(self.Skills,t)
end
if(e.monSkill3>0)then
t=HeroSkillInfo:New()
t.SkillType=1
t.SkillDid=e.monSkill3
table.add(self.Skills,t)
end
if(e.monSkill4>0)then
t=HeroSkillInfo:New()
t.SkillType=1
t.SkillDid=e.monSkill4
table.add(self.Skills,t)
end
end
local t=#e.monSkillPas
for t=1,t do
local t=e.monSkillPas[t]
if(t>0)then
local e=HeroSkillInfo:New()
e.SkillType=2
e.SkillDid=t
table.add(self.Skills,e)
end
end
end
function HeroBattleInfo:IsExistsSkill(t)
for a,e in ipairs(self.Skills)do
if(e.SkillDid==t)then
return true
end
end
return false
end
function HeroBattleInfo:SetHeroData(e)
local t=#e
for t=1,t do
local e=e[t]
if(e.id==HeroAttrId.hp)then
self.HP=e.value
self.CurrHP=e.value
self.MaxHP=e.value
self.CurrMaxHP=e.value
self.OriginalHP=e.value
elseif(e.id==HeroAttrId.fury)then
self.OriginalFury=e.value
self.CurrFury=e.value
self.BeansStatFury=e.value
elseif(e.id==HeroAttrId.atk)then
self.Atk=e.value
elseif(e.id==HeroAttrId.def)then
self.Def=e.value
elseif(e.id==HeroAttrId.critical)then
self.Critical=e.value
elseif(e.id==HeroAttrId.criticalRes)then
self.CriticalRes=e.value
elseif(e.id==HeroAttrId.criticalStrength)then
self.CriticalStrength=e.value
elseif(e.id==HeroAttrId.block)then
self.Block=e.value
elseif(e.id==HeroAttrId.blockRes)then
self.BlockRes=e.value
elseif(e.id==HeroAttrId.blockStrength)then
self.BlockStrength=e.value
elseif(e.id==HeroAttrId.injure)then
self.Injure=e.value
elseif(e.id==HeroAttrId.injureRes)then
self.InjureRes=e.value
elseif(e.id==HeroAttrId.control)then
self.Control=e.value
elseif(e.id==HeroAttrId.controlRes)then
self.ControlRes=e.value
elseif(e.id==HeroAttrId.blood)then
self.Blood=e.value
elseif(e.id==HeroAttrId.thorn)then
self.Thorn=e.value
elseif(e.id==HeroAttrId.heal)then
self.Heal=e.value
elseif(e.id==HeroAttrId.ProfRes)then
self.ProfRes=e.value
elseif(e.id==HeroAttrId.ProfResed)then
self.ProfResed=e.value
elseif(e.id==HeroAttrId.eXSkillINjure)then
self.eXSkillINjure=e.value
elseif(e.id==HeroAttrId.eXSkillINjureRes)then
self.eXSkillINjureRes=e.value
elseif(e.id==HeroAttrId.beforeEnergy)then
self.beforeEnergy=e.value
elseif(e.id==HeroAttrId.skillInjure)then
self.SkillInjure=e.value
elseif(e.id==HeroAttrId.skillInjureRes)then
self.SkillInjureRes=e.value
elseif(e.id==HeroAttrId.skillTriggerRate)then
self.SkillTriggerRate=e.value
elseif(e.id==HeroAttrId.first)then
self.First=e.value
elseif(e.id==HeroAttrId.first)then
self.First=e.value
elseif(e.id==HeroAttrId.IgnoreDefRate)then
self.IgnoreDefRate=e.value
elseif(e.id==HeroAttrId.atkRate)then
self.atkRate=e.value
elseif(e.id==HeroAttrId.defRate)then
self.defRate=e.value
elseif(e.id==HeroAttrId.tenacityRate)then
self.tenacityRate=e.value
elseif(e.id==HeroAttrId.armor)then
self.armor=e.value
elseif(e.id==HeroAttrId.criticalStrengthRes)then
self.criticalStrengthRes=e.value
elseif(e.id==HeroAttrId.evade)then
self.evade=e.value
elseif(e.id==HeroAttrId.evadeRes)then
self.evadeRes=e.value
elseif(e.id==HeroAttrId.tenacityResRate)then
self.tenacityResRate=e.value
elseif(e.id==HeroAttrId.petAtk)then
self.petAtk=e.value
elseif(e.id==HeroAttrId.petCritical)then
self.petCritical=e.value
elseif(e.id==HeroAttrId.petCriticalRes)then
self.petCriticalRes=e.value
elseif(e.id==HeroAttrId.petCriticalStrength)then
self.petCriticalStrength=e.value
elseif(e.id==HeroAttrId.petInjure)then
self.petInjure=e.value
elseif(e.id==HeroAttrId.petInjureRes)then
self.petInjureRes=e.value
elseif(e.id==HeroAttrId.petControl)then
self.petControl=e.value
elseif(e.id==HeroAttrId.petControlRes)then
self.petControlRes=e.value
elseif(e.id==HeroAttrId.petCriticalStrengthRes)then
self.petCriticalStrengthRes=e.value
elseif(e.id==HeroAttrId.petDefFactor)then
self.petDefFactor=e.value
elseif(e.id==HeroAttrId.petAtkFactor)then
self.petAtkFactor=e.value
end
end
end
function HeroBattleInfo:GetAttribute()
local e={}
table.add(e,{id=HeroAttrId.hp,value=self.HP})
table.add(e,{id=HeroAttrId.fury,value=self.OriginalFury})
table.add(e,{id=HeroAttrId.atk,value=self.Atk})
table.add(e,{id=HeroAttrId.def,value=self.Def})
table.add(e,{id=HeroAttrId.critical,value=self.Critical})
table.add(e,{id=HeroAttrId.criticalRes,value=self.CriticalRes})
table.add(e,{id=HeroAttrId.criticalStrength,value=self.CriticalStrength})
table.add(e,{id=HeroAttrId.block,value=self.Block})
table.add(e,{id=HeroAttrId.blockRes,value=self.BlockRes})
table.add(e,{id=HeroAttrId.blockStrength,value=self.BlockStrength})
table.add(e,{id=HeroAttrId.injure,value=self.Injure})
table.add(e,{id=HeroAttrId.injureRes,value=self.InjureRes})
table.add(e,{id=HeroAttrId.control,value=self.Control})
table.add(e,{id=HeroAttrId.controlRes,value=self.ControlRes})
table.add(e,{id=HeroAttrId.blood,value=self.Blood})
table.add(e,{id=HeroAttrId.thorn,value=self.Thorn})
table.add(e,{id=HeroAttrId.heal,value=self.Heal})
table.add(e,{id=HeroAttrId.ProfRes,value=self.ProfRes})
table.add(e,{id=HeroAttrId.ProfResed,value=self.ProfResed})
table.add(e,{id=HeroAttrId.eXSkillINjure,value=self.eXSkillINjure})
table.add(e,{id=HeroAttrId.eXSkillINjureRes,value=self.eXSkillINjureRes})
table.add(e,{id=HeroAttrId.beforeEnergy,value=self.beforeEnergy})
table.add(e,{id=HeroAttrId.skillInjure,value=self.SkillInjure})
table.add(e,{id=HeroAttrId.skillInjureRes,value=self.SkillInjureRes})
table.add(e,{id=HeroAttrId.skillTriggerRate,value=self.SkillTriggerRate})
table.add(e,{id=HeroAttrId.first,value=self.First})
table.add(e,{id=HeroAttrId.IgnoreDefRate,value=self.IgnoreDefRate})
table.add(e,{id=HeroAttrId.atkRate,value=self.atkRate})
table.add(e,{id=HeroAttrId.defRate,value=self.defRate})
table.add(e,{id=HeroAttrId.tenacityRate,value=self.tenacityRate})
table.add(e,{id=HeroAttrId.armor,value=self.armor})
table.add(e,{id=HeroAttrId.criticalStrengthRes,value=self.criticalStrengthRes})
table.add(e,{id=HeroAttrId.evade,value=self.evade})
table.add(e,{id=HeroAttrId.evadeRes,value=self.evadeRes})
table.add(e,{id=HeroAttrId.tenacityResRate,value=self.tenacityResRate})
table.add(e,{id=HeroAttrId.petAtk,value=self.petAtk})
table.add(e,{id=HeroAttrId.petCritical,value=self.petCritical})
table.add(e,{id=HeroAttrId.petCriticalRes,value=self.petCriticalRes})
table.add(e,{id=HeroAttrId.petCriticalStrength,value=self.petCriticalStrength})
table.add(e,{id=HeroAttrId.petInjure,value=self.petInjure})
table.add(e,{id=HeroAttrId.petInjureRes,value=self.petInjureRes})
table.add(e,{id=HeroAttrId.petControl,value=self.petControl})
table.add(e,{id=HeroAttrId.petControlRes,value=self.petControlRes})
table.add(e,{id=HeroAttrId.petCriticalStrengthRes,value=self.petCriticalStrengthRes})
table.add(e,{id=HeroAttrId.petDefFactor,value=self.petDefFactor})
table.add(e,{id=HeroAttrId.petAtkFactor,value=self.petAtkFactor})
return e
end
function HeroBattleInfo:SetHeroSkill(e)
if(not self.CurrHeroCtrl)then
return
end
local t=e.skills
self.CurrHeroCtrl.SkillMode=e.skillMode
if(e.skillMode==SkillMode.DragonWar)then
local e=#t
for e=1,e do
local t=t[e]
local a=HeroSkillInfo:New()
a:SetSkill(t)
local t=t.skillDid==nil and 0 or t.skillDid
if(e==1)then
self.CurrHeroCtrl.NormalSkillId=t
elseif(e>=2 and e<=4)then
table.add(self.CurrHeroCtrl.DragonWarBigSkillList,t)
end
if(t>0)then
table.add(self.Skills,a)
end
end
else
local e=#t
for e=1,e do
local t=t[e]
local a=HeroSkillInfo:New()
a:SetSkill(t)
local t=t.skillDid==nil and 0 or t.skillDid
if(e==1)then
self.CurrHeroCtrl.NormalSkillId=t
elseif(e==2)then
self.CurrHeroCtrl.SmallSkillId=t
elseif(e==3)then
self.CurrHeroCtrl.BigSkillId=t
end
if(t>0)then
table.add(self.Skills,a)
end
end
end
if(e.underwearSuits)then
for t,e in ipairs(e.underwearSuits)do
local e={suitDid=e.suitDid,star=e.star}
table.add(self.underWearSuits,e)
end
end
if(e.treasures)then
for t,e in ipairs(e.treasures)do
local e={treasureDid=e.treasureDid,level=e.level,breakLevel=e.breakLevel}
table.add(self.treasures,e)
end
end
end
function HeroBattleInfo:SetPetSkill(e)
if(not self.CurrHeroCtrl)then
return
end
local t=e.skills
self.CurrHeroCtrl.SkillMode=e.skillMode
local e=#t
for a=1,e do
local e=t[a]
local t=HeroSkillInfo:New()
t:SetSkill(e)
local e=e.skillDid==nil and 0 or e.skillDid
if(a==1)then
self.CurrHeroCtrl.PetFightSkillId=e
end
if(e>0)then
table.add(self.Skills,t)
end
end
end
function HeroBattleInfo:GetSkillWithType(a)
local e={}
local t=#self.Skills
for t=1,t do
local t=self.Skills[t]
if(t.SkillType==a)then
e[#e+1]=t
end
end
return e
end
function HeroBattleInfo:GetAllSkills()
local e={}
local t=#self.Skills
for t=1,t do
local t=self.Skills[t]
e[#e+1]=t
end
return e
end
function HeroBattleInfo:GetSkills()
local e={}
for t=1,#self.Skills do
local t=self.Skills[t]
local t={skillDid=t.SkillDid,skillType=t.SkillType}
table.add(e,t)
end
return e
end
function HeroBattleInfo:GetAttrValue(e)
if(e==HeroAttrId.hp)then
return self.CurrHP
elseif(e==HeroAttrId.fury)then
return self.CurrFury
elseif(e==HeroAttrId.atk)then
return self.Atk
elseif(e==HeroAttrId.def)then
return self.Def
elseif(e==HeroAttrId.critical)then
return self.Critical
elseif(e==HeroAttrId.criticalRes)then
return self.CriticalRes
elseif(e==HeroAttrId.criticalStrength)then
return self.CriticalStrength
elseif(e==HeroAttrId.block)then
return self.Block
elseif(e==HeroAttrId.blockRes)then
return self.BlockRes
elseif(e==HeroAttrId.blockStrength)then
return self.BlockStrength
elseif(e==HeroAttrId.injure)then
return self.Injure
elseif(e==HeroAttrId.injureRes)then
return self.InjureRes
elseif(e==HeroAttrId.control)then
return self.Control
elseif(e==HeroAttrId.controlRes)then
return self.ControlRes
elseif(e==HeroAttrId.blood)then
return self.Blood
elseif(e==HeroAttrId.thorn)then
return self.Thorn
elseif(e==HeroAttrId.heal)then
return self.Heal
elseif(e==HeroAttrId.ProfRes)then
return self.ProfRes
elseif(e==HeroAttrId.ProfResed)then
return self.ProfResed
elseif(e==HeroAttrId.eXSkillINjure)then
return self.eXSkillINjure
elseif(e==HeroAttrId.eXSkillINjureRes)then
return self.eXSkillINjureRes
elseif(e==HeroAttrId.beforeEnergy)then
return self.beforeEnergy
elseif(e==HeroAttrId.skillInjure)then
return self.SkillInjure
elseif(e==HeroAttrId.skillInjureRes)then
return self.SkillInjureRes
elseif(e==HeroAttrId.skillTriggerRate)then
return self.SkillTriggerRate
elseif(e==HeroAttrId.first)then
return self.First
elseif(e==HeroAttrId.IgnoreDefRate)then
return self.IgnoreDefRate
elseif(e==HeroAttrId.atkRate)then
return self.atkRate
elseif(e==HeroAttrId.defRate)then
return self.defRate
elseif(e==HeroAttrId.tenacityRate)then
return self.tenacityRate
elseif(e==HeroAttrId.armor)then
return self.armor
elseif(e==HeroAttrId.criticalStrengthRes)then
return self.criticalStrengthRes
elseif(e==HeroAttrId.evade)then
return self.evade
elseif(e==HeroAttrId.evadeRes)then
return self.evadeRes
elseif(e==HeroAttrId.tenacityResRate)then
return self.tenacityResRate
elseif(e==HeroAttrId.petAtk)then
return self.petAtk
elseif(e==HeroAttrId.petCritical)then
return self.petCritical
elseif(e==HeroAttrId.petCriticalRes)then
return self.petCriticalRes
elseif(e==HeroAttrId.petCriticalStrength)then
return self.petCriticalStrength
elseif(e==HeroAttrId.petInjure)then
return self.petInjure
elseif(e==HeroAttrId.petInjureRes)then
return self.petInjureRes
elseif(e==HeroAttrId.petControl)then
return self.petControl
elseif(e==HeroAttrId.petControlRes)then
return self.petControlRes
elseif(e==HeroAttrId.petCriticalStrengthRes)then
return self.petCriticalStrengthRes
elseif(e==HeroAttrId.petDefFactor)then
return self.petDefFactor
elseif(e==HeroAttrId.petAtkFactor)then
return self.petAtkFactor
else
GameInit.LogError("获取 英雄属性异常 请检查 attrId %s",e)
end
end
function HeroBattleInfo:GetFighting()
local e=self:GetAttribute()
local e=s:GetFighting(e)
return e
end
function HeroBattleInfo:CheckDoAction(t)
if t==nil then
return false
end
if t.skillDid==nil then
return true
end
local e=t.skillData
if e==nil then
return true
end
if e.triggerSkillAtkType~=nil then
if self.CurrHeroCtrl.ForbidExtraAttack==true and s:CheckCanTriggerAttackTask(e.triggerSkillAtkType)==false then
return false
end
end
local a=e.buffId
if a==nil then
return true
end
local o=self:GetBuff(a)
if o==nil then
return false
end
if self.CurrHeroCtrl:CheckCanUseSkillById(t.skillDid)==false then
return false
end
local i=ModulesInit.BattleBuffMgr.GetBuffScript(a)
if(i==nil)then
GameInit.LogError("对应的Buff脚本不存在 buffId %s",a)
return false
end
if i.HandleOnDoAction==nil then
return true
end
local a,t=i.HandleOnDoAction(o,o.buffData,t)
if t then
e=t
end
return a,e
end
function HeroBattleInfo:ResetBeforeAction(e)
if e==nil then
return
end
if e.skillDid==nil then
return
end
local t=e.skillData
if t==nil then
return
end
local t=t.buffId
if t==nil then
return
end
local a=self:GetBuff(t)
if a==nil then
return
end
local o=ModulesInit.BattleBuffMgr.GetBuffScript(t)
if(o==nil)then
GameInit.LogError("对应的Buff脚本不存在 buffId %s",t)
return
end
if o.HandleOnBeforeAction==nil then
return
end
local e=o.HandleOnBeforeAction(a,a.buffData,e)
return e
end
function HeroBattleInfo:AddImmunneBuffId(e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=self.immuneBuffMap[e]
if t==nil then
self.immuneBuffMap[e]=1
else
self.immuneBuffMap[e]=t+1
end
end
function HeroBattleInfo:ReduceImmunneBuffId(e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local t=self.immuneBuffMap[e]
if t~=nil then
self.immuneBuffMap[e]=t-1
if self.immuneBuffMap[e]<=0 then
self.immuneBuffMap[e]=nil
end
end
end
function HeroBattleInfo:CheckHasImmunneBuffId(e)
local e=self.immuneBuffMap[e]
if e~=nil and e>0 then
return true
end
return false
end
function HeroBattleInfo:AddImmunneCtrlBuffId(e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.mCtrlBuffImmuneMap[e]=true
end
function HeroBattleInfo:RemoveImmunneCtrlBuffId(e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.mCtrlBuffImmuneMap[e]=nil
end
function HeroBattleInfo:AddBuff(i,a,n,r,o,h)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return false
end
local l=EBuffAddType.Normal
if h then
if h.buffAddType~=nil then
l=h.buffAddType
end
if h.buffTriggerAddType==EBuffAddType.FightBack then
return false
end
end
if self.CurrHeroCtrl:IsHeroForbidSpecialState()then
return false
end
local u=false
local d=ETriggerSkillAtkType.Normal
if h then
u=h.isForce or false
d=ETriggerSkillAtkType.FightBack
end
if(not self.CurrHeroCtrl)then
return false
end
if(a==nil)then
GameInit.LogError("对应的Buff不存在 buffId 异常")
return false
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local e=t:GetBuffCfg(a)
if(e==nil)then
GameInit.LogError("对应的Buff不存在 buffId %s",a)
return false
end
if self:CheckHasImmunneBuffId(a)and e.ignoreImmune==0 then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
local c=ModulesInit.BattleBuffMgr.GetBuffScript(a)
if(c==nil)then
GameInit.LogError("对应的Buff脚本不存在 buffId %s",a)
return false
end
if(c.GetCanAdd(i,self.CurrHeroCtrl)==false)then
return false
end
if s:CheckCanAddBuffWithBattleType(ModulesInit.ProcedureNormalBattle.BattleType,self.CurrHeroCtrl.HeroId,e)==false then
return false
end
if e.isControl>=1 then
if self.CurrHeroCtrl:IsPet()then
return false
end
if(e.ignoreImmune==0 and u==false)then
if(self.CurrHeroCtrl.ImmuneControlBuff)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
for t,e in pairs(self.mCtrlBuffImmuneMap)do
local e=self:GetBuff(t)
if e then
local s=ModulesInit.BattleBuffMgr.GetBuffScript(t)
if(e.isExec==false)then
local o={
buffId=a,
round=n,
buffData=r,
floors=o,
param=h,
buffAddType=l
}
local o={
buffTriggerTime=BuffTriggerTime.addBuffCheckCtrl,
buffCopy=o,
}
local e=e:DoBuffAction(i,self.CurrHeroCtrl,{a},o)
if type(e)=="table"and e.ret==true then
if e.remove==true then
self:RemoveBuffWithId(t)
end
return false
end
end
end
end
end
end
if(o)then
if e.layerLimit>=0 then
o=math.min(o,e.layerLimit)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(e.isGran==0 and e.ignoreImmune==0 and u==false)then
if self.CurrHeroCtrl.ImmuneDeBuff then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
elseif#self.CurrHeroCtrl.ImmuneDeBuffWithBuffList>0 then
for e=1,#self.CurrHeroCtrl.ImmuneDeBuffWithBuffList do
local e=self.CurrHeroCtrl.ImmuneDeBuffWithBuffList[e]
local t=self:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
if e and e.ImmuneDebuff then
local a={
buffId=a,
round=n,
buffData=r,
floors=o,
param=h,
buffAddType=l
}
local e=e.ImmuneDebuff(t,a,i)
if e then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
end
end
end
end
elseif(e.isGran==1 and e.ignoreImmune==0 and u==false)then
local e=self.CurrHeroCtrl.ImmuneBuffWithBuffList
if#e>0 then
for t=1,#e do
local e=e[t]
local t=self:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
if e and e.ImmuneBuff then
local a={
buffId=a,
round=n,
buffData=r,
floors=o,
param=h,
buffAddType=l
}
local e=e.ImmuneBuff(t,a,i)
if e then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
end
end
end
end
end
if e.speciality==EBuffSpeciality.Shield then
if i.HeroId~=self.CurrHeroCtrl.HeroId and self.CurrHeroCtrl.disableOtherShield then
return false
end
local e=self:GetShieldBuff()
if(e)then
self:RemoveBuffWithId(e.buffId,BuffRemoveType.Replace)
end
elseif e.speciality==EBuffSpeciality.Energy then
local e=self:GetEnergyBuff()
if(e)then
self:RemoveBuffWithId(e.buffId,BuffRemoveType.Replace)
end
end
if(e.isControl>=1)then
local a=self:GetControlBuff(e.isControl)
if(a~=nil)then
local t=t:GetBuffCfg(a.buffId)
if(e.controlGrade>t.controlGrade)then
self:RemoveBuffWithId(a.buffId,BuffRemoveType.Replace)
i:AddControllRate(1)
elseif(e.controlGrade==t.controlGrade)then
if(n>a.round)then
self:RemoveBuffWithId(a.buffId,BuffRemoveType.Replace)
i:AddControllRate(1)
else
return true
end
else
return true
end
end
end
if e.isGran==EBattleBuffType.OneAttack then
if self.CurrHeroCtrl then
self.CurrHeroCtrl:SetHasOneAttackBuff(true)
end
end
local t=self:GetBuff(a)
if(e.canOverlap==EBuffOverlapType.None)then
if(t~=nil)then
local e=s:CompareBuffWeight(c,e,t,t.round,t.buffData,n,r)
if(e==EBuffWeightResult.Big)then
self:RemoveBuffWithId(t.buffId,BuffRemoveType.Expire)
else
if(e==EBuffWeightResult.Same and n>t.round)then
self:RemoveBuffWithId(t.buffId,BuffRemoveType.Expire)
else
if(t.isExec==false)then
if t:GetCanTrigger(BuffTriggerTime.now)then
t:DoAction(BuffTriggerTime.now)
end
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="HERO_SUPPORT_ENTER_FINISH"})
if self.CurrHeroCtrl then
local e={
releaseHeroId=i.HeroId,
buffHeroId=self.CurrHeroCtrl.HeroId,
addBuffId=a,
triggerSkillAtkType=d,
teamId=self.CurrHeroCtrl:GetTeamId()
}
EventSystem.SendEvent(CommonEventId.OnBattleHeroAddBuff,e)
end
end
return true
end
end
end
local t=HeroBuffInfo:New(self.CurrHeroCtrl)
t.buffId=a
t.releaseHeroId=i.HeroId
t.round=n
t.originRound=n
t.floors=(o==nil and 1 or o)
t.isGran=e.isGran
t.teamId=self.CurrHeroCtrl:GetTeamId()
t.addType=e.isGran
t:AddBuffData(r)
t:OnAdd()
t:SetLogicData(i)
t:CheckPlayBuffEffect()
self.BuffDic[a]=t
if(t.isExec==false)then
if t:GetCanTrigger(BuffTriggerTime.now)then
t:DoAction(BuffTriggerTime.now)
end
if self.CurrHeroCtrl then
local e={
releaseHeroId=i.HeroId,
buffHeroId=self.CurrHeroCtrl.HeroId,
addBuffId=a,
triggerSkillAtkType=d,
teamId=self.CurrHeroCtrl:GetTeamId()
}
EventSystem.SendEvent(CommonEventId.OnBattleHeroAddBuff,e)
end
end
else
if(t~=nil)then
t.round=n
if(t.floors<e.layerLimit or e.layerLimit<0)then
if e.canOverlap==EBuffOverlapType.MultiRoundOverlap then
s:HandleMultiRoundOverlapBuff(t,o,n,e.layerLimit)
else
local e=(o==nil and 1 or o)
t.floors=t.floors+e
end
if e.layerLimit>=0 then
t.floors=math.min(t.floors,e.layerLimit)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
t:OnOverlap()
if self.CurrHeroCtrl then
local e={
releaseHeroId=i.HeroId,
buffHeroId=self.CurrHeroCtrl.HeroId,
addBuffId=a,
triggerSkillAtkType=d,
teamId=self.CurrHeroCtrl:GetTeamId()
}
EventSystem.SendEvent(CommonEventId.OnBattleHeroAddBuff,e)
end
end
else
local t=HeroBuffInfo:New(self.CurrHeroCtrl)
t.buffId=a
t.releaseHeroId=i.HeroId
t.round=n
t.originRound=n
if e.canOverlap==EBuffOverlapType.MultiRoundOverlap then
s:HandleMultiRoundOverlapBuff(t,o,n,e.layerLimit)
else
t.floors=(o==nil and 1 or o)
end
t.isGran=e.isGran
t.teamId=self.CurrHeroCtrl:GetTeamId()
t:AddBuffData(r)
t:OnAdd()
t:SetLogicData(i)
t:CheckPlayBuffEffect()
self.BuffDic[a]=t
if(t.isExec==false)then
if t:GetCanTrigger(BuffTriggerTime.now)then
t:DoAction(BuffTriggerTime.now)
end
if self.CurrHeroCtrl then
local e={
releaseHeroId=i.HeroId,
buffHeroId=self.CurrHeroCtrl.HeroId,
addBuffId=a,
triggerSkillAtkType=d,
teamId=self.CurrHeroCtrl:GetTeamId()
}
EventSystem.SendEvent(CommonEventId.OnBattleHeroAddBuff,e)
end
end
end
end
return true
end
function HeroBattleInfo:CheckAddBuffValue(o,a,e,i)
local t=self:GetBuffValue(o,a,e)
if t==nil then
self:AddBuffValue(o,a,e,i)
else
t.value=e
end
end
function HeroBattleInfo:ReduceBuffValue(i,o,n,s,e)
local a=self:GetBuffValue(i,o)
if a==nil then
local t=n
if e then
t=math.max(t,e)
end
if t~=0 then
self:AddBuffValue(i,o,t,s)
end
else
local t=a.value-n
if e then
a.value=math.max(t,e)
end
if a.value==0 then
self:RemoveBuffValue(i,o)
end
end
end
function HeroBattleInfo:CheckOverlapBuffValue(t,a,o,i)
local e=self:GetBuffValue(t,a)
if e==nil then
self:AddBuffValue(t,a,o,i)
else
e.value=e.value+o
end
end
function HeroBattleInfo:GetBuffValue(a,e,t)
local e=self.BuffValueDic[e]
if e then
for t=1,#e do
local e=e[t]
if e.buffId==a then
return e
end
end
end
end
function HeroBattleInfo:RemoveBuffValue(a,e)
local e=self.BuffValueDic[e]
if e then
for t=1,#e do
local o=e[t]
if o.buffId==a then
table.remove(e,t)
break
end
end
end
end
function HeroBattleInfo:AddBuffValue(t,a,i,o)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:AddBuffValue When isTimeLine!")
return
end
local e=HeroBuffValueInfo:New()
e.buffId=t
e.attrId=a
e.value=i
e.heroId=o
local t=self.BuffValueDic[a]
if(t)then
table.add(t,e)
else
t={}
table.add(t,e)
self.BuffValueDic[a]=t
end
end
function HeroBattleInfo:ReduceShield(a,t)
if(not self.CurrHeroCtrl)then
return
end
local e=self.BuffValueDic[HeroAttrId.shield]
if(e)then
local e=e[1]
if(e)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local o=e.value
e.value=e.value-a
local o=o-e.value
if ModulesInit.ProcedureNormalBattle.isTimeLine==false then
local a=self:GetBuff(e.buffId)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e.buffId)
if e.HandleShieldReduce then
if t==nil or t==0 then
t=ModulesInit.ProcedureNormalBattle.CurrAttackHeroId
end
e.HandleShieldReduce(a,o,t)
end
end
end
if(e.value<=0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if ModulesInit.ProcedureNormalBattle.isTimeLine==false then
local a=self:GetBuff(e.buffId)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e.buffId)
if e.HandleShieldRemoveBefore then
if ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.None)==false then
if t==nil or t==0 then
t=ModulesInit.ProcedureNormalBattle.CurrAttackHeroId
end
end
e.HandleShieldRemoveBefore(a,t)
end
end
end
self:RemoveBuffWithId(e.buffId,BuffRemoveType.Rout)
end
end
end
end
function HeroBattleInfo:ReduceEnergy(t)
if(not self.CurrHeroCtrl)then
return
end
local e=self.BuffValueDic[HeroAttrId.energy]
if(e)then
local e=e[1]
if(e)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.value=e.value-t
local a=self:GetBuff(e.buffId)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e.buffId)
if e.RefreshEnergyBar then
e.RefreshEnergyBar(a)
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(e.value<=0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:RemoveBuffWithId(e.buffId,BuffRemoveType.Rout)
end
end
end
end
function HeroBattleInfo:RemoveBuffValueWithId(o)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:RemoveBuffValueWithId When isTimeLine!")
return
end
local a={}
for i,e in pairs(self.BuffValueDic)do
if(e)then
for t=#e,1,-1 do
local a=e[t]
if(a.buffId==o)then
table.remove(e,t)
end
end
if(#e==0)then
table.add(a,i)
end
end
end
for t,e in ipairs(a)do
self.BuffValueDic[e]=nil
end
end
function HeroBattleInfo:RemoveBuffWithId(o,a,i)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return false
end
if(not self.CurrHeroCtrl)then
return false
end
local e=self.BuffDic[o]
if e==nil then
return false
end
if e.isRemoved==true then
return false
end
local t=t:GetBuffCfg(o)
if(a==BuffRemoveType.Dispel)then
if(t.canDispel<=0)then
return false
elseif(t.canDispel==2)then
local t=e:GetFloors()
if t>1 then
e:ReduceFloors(1)
return false
end
end
elseif(a==BuffRemoveType.BeStolen)then
if s:IsCanStealBuff(t)==false then
return false
end
elseif(a==BuffRemoveType.Dying)then
if(t.canDispel<0)then
return false
end
end
e.isRemoved=true
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self:TriggerBuff(BuffTriggerTime.removeBuff,self.CurrHeroCtrl,self.CurrHeroCtrl,{e.buffId,a,i})
e:RemoveBuffEffect()
self:RemoveBuffValueWithId(e.buffId)
if self.CurrHeroCtrl then
self.CurrHeroCtrl:RemoveExtraSoulWithId(o)
end
e:OnRemoveSelf(a)
e:Dispose()
self.BuffDic[o]=nil
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(self.CurrHeroCtrl)then
self.CurrHeroCtrl:ResumeAfterRemoveCtlBuff(o)
end
if(a==BuffRemoveType.Dispel)then
if self.CurrHeroCtrl then
self.CurrHeroCtrl:PlayAutoReleaseEffect(SysPrefabId.BattleDispelBuff,3,nil,HeroPointType.FootPoint)
end
elseif(a==BuffRemoveType.Purify)then
if self.CurrHeroCtrl then
self.CurrHeroCtrl:PlayAutoReleaseEffect(SysPrefabId.BattlePurifyBuff,3,nil,HeroPointType.FootPoint)
end
end
end
return true
end
function HeroBattleInfo:RemoveBuffWithHeroId(a)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local e={}
for o,t in pairs(self.BuffDic)do
if(t.releaseHeroId==a)then
table.add(e,t.buffId)
end
end
table.sort(e,function(t,e)
return t<e
end)
for t,e in ipairs(e)do
self:RemoveBuffWithId(e,BuffRemoveType.Expire)
end
end
function HeroBattleInfo:GetBuff(e)
return self.BuffDic[e]
end
function HeroBattleInfo:GetBuffSortArr()
local e=table.getValueArr(self.BuffDic)
table.sort(e,function(t,e)
return t.buffId<e.buffId
end)
return e
end
function HeroBattleInfo:GetShieldBuff()
local e=self:GetBuffSortArr()
for a=1,#e do
local e=e[a]
local a=e.buffId
local t=t:GetBuffCfg(a)
if(t.speciality==EBuffSpeciality.Shield)then
return e
end
end
return nil
end
function HeroBattleInfo:GetEnergyBuff()
local e=self:GetBuffSortArr()
for a=1,#e do
local e=e[a]
local a=e.buffId
local t=t:GetBuffCfg(a)
if(t.speciality==EBuffSpeciality.Energy)then
return e
end
end
return nil
end
function HeroBattleInfo:ClearAllBuffWhenDying()
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local e=self:GetGranBuff(true)
for a,t in ipairs(e)do
self:RemoveBuffWithId(t.buffId,BuffRemoveType.Dying)
end
e=self:GetGranBuff(false)
for t,e in ipairs(e)do
self:RemoveBuffWithId(e.buffId,BuffRemoveType.Dying)
end
end
function HeroBattleInfo:ClearAllBuffWhenTomb()
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local e=self:GetBuffSortArr()
for a=1,#e do
local e=e[a]
local a=e.buffId
local t=t:GetBuffCfg(a)
if t.isGran~=EBattleBuffType.Debuff and t.isGran~=EBattleBuffType.OneAttack then
self:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
end
end
end
function HeroBattleInfo:ClearAllBuff()
local e=self:GetBuffSortArr()
for t=1,#e do
local e=e[t]
self:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
end
end
function HeroBattleInfo:ClearOnAttackBuff()
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local e=self:GetBuffSortArr()
for a=1,#e do
local e=e[a]
local a=e.buffId
local t=t:GetBuffCfg(a)
if t.isGran==EBattleBuffType.OneAttack then
self:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
end
end
end
function HeroBattleInfo:RemoveAllGranBuff(e,t)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local e=self:GetGranBuff(e)
for a,e in ipairs(e)do
self:RemoveBuffWithId(e.buffId,BuffRemoveType.Dispel,t)
end
end
function HeroBattleInfo:ClearAllGranBuff(t,e)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local t=self:GetGranBuff(t)
for a,t in ipairs(t)do
self:RemoveBuffWithId(t.buffId,BuffRemoveType.Dispel,e)
end
end
function HeroBattleInfo:DispelAllGranBuff(e,a,o)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local t={}
if self.CurrHeroCtrl:TriggerDispelDisturb(e)then
return t
end
local e=self:GetGranBuff(e,true,a)
for a,e in ipairs(e)do
local a={
buffId=e.buffId,
round=e.round,
buffData=e.buffData,
}
local e=self:RemoveBuffWithId(e.buffId,BuffRemoveType.Dispel,o)
if e then
table.insert(t,a)
end
end
return t
end
function HeroBattleInfo:DispelGranBuffLayers(e,o,t,i)
if e==nil or e.isRemoved==true then
return false
end
if t==nil or t<1 then
t=1
end
local n={
buffId=e.buffId,
round=e:GetRound(),
buffData=e:GetBuffData(),
}
local a=self.CurrHeroCtrl
local e=s:ReduceHeroBuffFloor(a,e.buffId,t,BuffRemoveType.Dispel,o)
if e then
table.insert(i,n)
return true
end
return false
end
function HeroBattleInfo:DispelGranBuffById(a,i,o)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return{}
end
local e={}
local t=t:GetBuffCfg(a)
if t==nil then
return{}
end
local t=t.isGran==1
if self.CurrHeroCtrl:TriggerDispelDisturb(t)then
return e
end
local t=self.BuffDic[a]
self:DispelGranBuffLayers(t,i,o,e)
return e
end
function HeroBattleInfo:DispelGranBuff(a,e,o,n,i)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return{}
end
local t={}
if self.CurrHeroCtrl:TriggerDispelDisturb(a)then
return t
end
if a==false and o then
t=self:DispelControlBuff(e,i)
if e then
e=e-#t
end
end
if e<=0 then
return t
end
if a==false and n then
local a=self:DispelHealResBuff(e,i)
if e then
e=e-#a
end
table.appendList(t,a)
end
if e<=0 then
return t
end
local a=self:GetGranBuff(a,true)
if(a)then
if e==nil then
e=#a
end
local o={}
if(#a<=e)then
o=a
else
o=RandomTableWithSeed(a,e)
end
for a,e in ipairs(o)do
self:DispelGranBuffLayers(e,i,1,t)
end
end
return t
end
function HeroBattleInfo:DispelControlBuff(t,i)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local o={}
local e=false
if self.CurrHeroCtrl:TriggerDispelDisturb(e)then
return
end
local e=self:GetAllControlBuff()
if(e)then
if t==nil then
t=#e
end
local a={}
if(#e<=t)then
a=e
else
local t=math.min(t,#e)
for t=1,t do
table.insert(a,e[t])
end
end
for t,e in ipairs(a)do
local t={
buffId=e.buffId,
round=e.round,
buffData=e.buffData,
}
local e=self:RemoveBuffWithId(e.buffId,BuffRemoveType.Dispel,i)
if e then
table.insert(o,t)
end
end
end
return o
end
function HeroBattleInfo:DispelHealResBuff(t,i)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local o={}
local e=false
if self.CurrHeroCtrl:TriggerDispelDisturb(e)then
return
end
local e=self:GetAllHealResBuff()
if(e)then
if t==nil then
t=#e
end
local a={}
if(#e<=t)then
a=e
else
local t=math.min(t,#e)
for t=1,t do
table.insert(a,e[t])
end
end
for t,e in ipairs(a)do
local t={
buffId=e.buffId,
round=e.round,
buffData=e.buffData,
}
local e=self:RemoveBuffWithId(e.buffId,BuffRemoveType.Dispel,i)
if e then
table.insert(o,t)
end
end
end
return o
end
function HeroBattleInfo:GetGranBuff(n,i,o)
local a=self:GetBuffSortArr()
local e={}
for s=1,#a do
local a=a[s]
local s=a.buffId
local t=t:GetBuffCfg(s)
if(t.isGran==(n and 1 or 0)and(i==nil or i==(t.canDispel>0)))then
if o==nil then
e[#e+1]=a
else
if(o==true and t.isControl>=1)
or(o==false and t.isControl<=0)then
e[#e+1]=a
end
end
end
end
return e
end
function HeroBattleInfo:GetGranBuffCanSteal(i,o)
local a=self:GetBuffSortArr()
local e={}
for n=1,#a do
local a=a[n]
local n=a.buffId
local t=t:GetBuffCfg(n)
if(t.isGran==(i and 1 or 0)and s:IsCanStealBuff(t))==o then
e[#e+1]=a
end
end
return e
end
function HeroBattleInfo:GetGranBuffSort(e,a)
local a=self:GetGranBuff(e,a)
local e={}
for o=1,#a do
local i=a[o].buffId
local t={
cfgData=t:GetBuffCfg(i),
buffData=a[o]
}
table.insert(e,t)
end
table.sort(e,function(e,a)
local t=e.cfgData
local e=a.cfgData
if t.isControl~=e.isControl then
return t.isControl>e.isControl
end
return t.id<e.id
end)
return e
end
function HeroBattleInfo:HasGranOrUnGran(o,a)
local e=self:GetBuffSortArr()
for i=1,#e do
local e=e[i]
local e=e.buffId
local e=t:GetBuffCfg(e)
if(e.isGran==(o and 1 or 0))then
if a==nil then
return true
elseif a==true then
if e.canDispel>0 then
return true
end
elseif a==false then
if e.canDispel<=0 then
return true
end
end
end
end
return false
end
function HeroBattleInfo:HasControlFlyBuff()
for a,e in pairs(self.BuffDic)do
if(e)then
local e=e.buffId
local e=t:GetBuffCfg(e)
if(e.controlFly==1)then
return true
end
end
end
return false
end
function HeroBattleInfo:PlayControlFlyBuff()
for a,e in pairs(self.BuffDic)do
if(e)then
local a=e.buffId
local t=t:GetBuffCfg(a)
if(t.controlPose~=""and t.controlFly==0)then
e:PlayAnim()
return true
end
end
end
return false
end
function HeroBattleInfo:HasStrongControlBuff()
for t,e in pairs(self.BuffDic)do
if(e)then
local e=e.buffId
if s:IsStrongCtlBuff(e)then
return true
end
end
end
return false
end
function HeroBattleInfo:HasControlBuff()
for t,e in pairs(self.BuffDic)do
if(e)then
local e=e.buffId
if s:IsCtlBuff(e)then
return true
end
end
end
return false
end
function HeroBattleInfo:HasControlAndStealBuff()
for t,e in pairs(self.BuffDic)do
if(e)then
local e=e.buffId
if s:IsCtlAndStealBuff(e)then
return true
end
end
end
return false
end
function HeroBattleInfo:HasReposeControlBuff()
if(not self.CurrHeroCtrl)then
return false
end
for t,e in pairs(self.BuffDic)do
if(e)then
local e=e.buffId
if s:IsStrongCtlPosBuff(e)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return true
end
end
end
return false
end
function HeroBattleInfo:GetControlBuff(n)
local a=self:GetBuffSortArr()
table.sort(a,function(i,o)
local a=t:GetBuffCfg(i.buffId)
local e=t:GetBuffCfg(o.buffId)
if a~=nil and e~=nil then
if a.isControl~=e.isControl then
return a.isControl>e.isControl
end
end
return i.buffId<o.buffId
end)
for e=1,#a do
local e=a[e]
local a=e.buffId
local t=t:GetBuffCfg(a)
if n==nil then
if(t.isControl>=1)then
return e
end
else
if(t.isControl==n)then
return e
end
end
end
return nil
end
function HeroBattleInfo:ReplayControlState()
local e=self:GetAllControlBuff()
for t=1,#e do
local e=e[t]
e:PlayAnim()
e:PlayBuffPrefabEffect()
end
end
function HeroBattleInfo:GetAllControlBuff()
local a={}
for o,e in pairs(self.BuffDic)do
local o=e.buffId
local t=t:GetBuffCfg(o)
if(t.isControl>=1)then
table.insert(a,e)
end
end
table.sort(a,function(o,i)
local a=t:GetBuffCfg(o.buffId)
local e=t:GetBuffCfg(i.buffId)
if a~=nil and e~=nil then
if a.isControl~=e.isControl then
return a.isControl>e.isControl
end
end
return o.buffId<i.buffId
end)
return a
end
function HeroBattleInfo:GetAllHealResBuff()
local e={}
for o,a in pairs(self.BuffDic)do
local o=a.buffId
local t=t:GetBuffCfg(o)
if(t.healResLevel>0)then
table.insert(e,a)
end
end
table.sort(e,function(a,o)
local e=t:GetBuffCfg(a.buffId)
local t=t:GetBuffCfg(o.buffId)
if e~=nil and t~=nil then
if e.healResLevel~=t.healResLevel then
return e.healResLevel>t.healResLevel
end
end
return a.buffId<o.buffId
end)
return e
end
function HeroBattleInfo:RemoveControlBuff()
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local e=self:GetAllControlBuff()
if(e)then
for t=1,#e do
local e=e[t]
self:RemoveBuffWithId(e.buffId,BuffRemoveType.Dispel)
end
end
end
function HeroBattleInfo:ClearAllControlBuff()
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local e=self:GetAllControlBuff()
if(e)then
for t=1,#e do
local e=e[t]
self:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
end
end
end
function HeroBattleInfo:CheckBuffExist(e)
if e~=nil and e~=0 and self.BuffDic[e]~=nil then
return true
end
return false
end
function HeroBattleInfo:CheckBuff(o,s)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:CheckBuff When isTimeLine!")
return
end
if(self.CurrHeroCtrl==nil)then
return
end
local i=0
local h=0
local a=0
local n=self:GetBuffSortArr()
for e=1,#n do
local e=n[e]
local n=e.buffId
if(s~=nil and self:CheckBuffExist(n))then
if(e.isExec==false and e:GetCanTrigger(s))then
e.hurtValue=0
local t=e:DoAction(s)
if type(t)=="table"then
if t.duration then
a=math.max(t.duration,a)
else
a=math.max(1,a)
end
if t.isOper==true then
if t.remove==true then
self:RemoveBuffWithId(n,BuffRemoveType.Expire)
end
end
else
a=math.max(1,a)
end
if(o==BuffCheckTime.RoundBegin or o==BuffCheckTime.RoundEnd)then
if e.hurtType==HeroHurtType.healThorn then
h=h+e.hurtValue
else
i=i+e.hurtValue
end
end
if(self.CurrHeroCtrl==nil)then
return
end
end
end
end
for e=1,#n do
local e=n[e]
local a=e.buffId
if(e.round>0)then
local t=t:GetBuffCfg(a)
if(t.checkTime==o or t.checkTime==BuffCheckTime.RoundBeginOrEnd)then
e.round=e.round-1
e:OnRoundChange()
if(e.round==0)then
self:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
end
end
end
if(self.CurrHeroCtrl==nil)then
return
end
if(o==BuffCheckTime.RoundBegin or o==BuffCheckTime.RoundEnd)then
if(i>0 or h>0)then
if i>0 then
self.CurrHeroCtrl:RealHurtOnlyShow(i)
end
if(self.CurrHP>0)then
self.CurrHeroCtrl:ChangeState(HeroState.Hurt)
end
end
end
if(self:HasReposeControlBuff())then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(self:HasReposeControlBuff()==false and self.CurrHeroCtrl:IsUsualState()and self.CurrHeroCtrl:IsHeroSpecialState()==false)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.CurrHeroCtrl.CurrFsm.ParamDic["changeToIdleType"]=ChangeToIdleType.NormalIdle
self.CurrHeroCtrl:ChangeState(HeroState.Idle)
end
return a
end
function HeroBattleInfo:CheckSpecialBuffRound(a)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:CheckSpecialBuffRound When isTimeLine!")
return
end
if(self.CurrHeroCtrl==nil)then
return
end
local e=self:GetBuffSortArr()
for o=1,#e do
local e=e[o]
local o=e.buffId
if(e.round>0)then
local t=t:GetBuffCfg(o)
if(t.checkTime==a)then
e.round=e.round-1
if t.canOverlap==EBuffOverlapType.MultiRoundOverlap then
local t=e.roundArr
local a=#t
for e=a,1,-1 do
t[e]=t[e]-1
if t[e]<=0 then
table.remove(t,e)
end
end
local t=#t
e.floors=t
e.floors=math.max(e.floors,0)
local a=a-t
if a>0 then
e:ReduceFloorsWithView(a)
end
if t<=0 then
e.round=0
end
end
e:OnRoundChange()
if(e.round==0)then
self:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
end
end
end
end
function HeroBattleInfo:HeroPoseTypeChange(a)
local e=self:GetBuffSortArr()
for t=1,#e do
local e=e[t]
e:HeroPoseTypeChange(a)
end
end
function HeroBattleInfo:GetTotalBuffValue(i,a)
if(not self.CurrHeroCtrl)then
return 0
end
local t=0
local e=self.BuffValueDic[i]
if(e)then
for o,e in ipairs(e)do
if a==nil or e.heroId==nil or a==e.heroId then
local o=self:GetBuff(e.buffId)
local a=1
if(o and o.isOpenAttrFloor)then
a=o.floors
if(o.isGran==7)then
a=1
end
end
t=t+e.value*a
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
if(t>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
return t
end
function HeroBattleInfo:RestTempBuffValues()
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:RestTempBuffValues When isTimeLine!")
return
end
self.TempBuffValueDic={}
end
function HeroBattleInfo:AddTempBuffValues(e)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:AddTempBuffValues When isTimeLine!")
return
end
if(e==nil)then
return
end
for t,e in ipairs(e)do
self:AddTempBuffValue(e)
end
end
function HeroBattleInfo:AddTempBuffValue(t)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:AddTempBuffValues When isTimeLine!")
return
end
local e=self.TempBuffValueDic[t.attrId]
if(e)then
table.add(e,t)
else
e={}
table.add(e,t)
self.TempBuffValueDic[t.attrId]=e
end
end
function HeroBattleInfo:GetTotalBuffTempValue(i,a)
if(not self.CurrHeroCtrl)then
return 0
end
local t=0
local e=self.TempBuffValueDic[i]
if(e)then
for o,e in ipairs(e)do
if a==nil or e.heroId==nil or a==e.heroId then
local o=self:GetBuff(e.buffId)
local a=1
if(o and o.isOpenAttrFloor)then
a=o.floors
if(o.isGran==7)then
a=1
end
end
t=t+e.value*a
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
if(t>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
return t
end
function HeroBattleInfo:ResetAttrValuesInBattle()
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:ResetAttrValuesInBattle When isTimeLine!")
return
end
self.attrValueDicInBattle={}
end
function HeroBattleInfo:AddAttrValueArrInBattle(e)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:AddAttrValueArrInBattle When isTimeLine!")
return
end
if(e==nil)then
return
end
for t,e in ipairs(e)do
self:AddAttrValue(e)
end
end
function HeroBattleInfo:AddAttrValueInBattle(t)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:AddAttrValueInBattle When isTimeLine!")
return
end
local e=self.attrValueDicInBattle[t.attrId]
if(e)then
table.add(e,t)
else
e={}
table.add(e,t)
self.attrValueDicInBattle[t.attrId]=e
end
end
function HeroBattleInfo:GetAttrValueInBattle(i,a)
if(not self.CurrHeroCtrl)then
return 0
end
local t=0
local e=self.attrValueDicInBattle[i]
if(e)then
for o,e in ipairs(e)do
if a==nil or e.heroId==nil or a==e.heroId then
local o=self:GetBuff(e.buffId)
local a=1
if(o and o.isOpenAttrFloor)then
a=o.floors
if(o.isGran==7)then
a=1
end
end
t=t+e.value*a
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
if(t>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
return t
end
function HeroBattleInfo:ResetAttrValuesInCurAttack()
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:ResetAttrValuesInCurAttack When isTimeLine!")
return
end
self.attrValueDicInCurAttack={}
end
function HeroBattleInfo:AddAttrValueArrInCurAttack(e)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:AddAttrValueArrInCurAttack When isTimeLine!")
return
end
if(e==nil)then
return
end
for t,e in ipairs(e)do
self:AddAttrValueInCurAttack(e)
end
end
function HeroBattleInfo:AddAttrValueInCurAttack(t)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:AddAttrValueInCurAttack When isTimeLine!")
return
end
local e=self.attrValueDicInCurAttack[t.attrId]
if(e)then
table.add(e,t)
else
e={}
table.add(e,t)
self.attrValueDicInCurAttack[t.attrId]=e
end
end
function HeroBattleInfo:RemoveAttrValueInCurAttack(e)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
GameInit.LogError("Call HeroBattleInfo:RemoveAttrValueInCurAttack When isTimeLine!")
return
end
self.attrValueDicInCurAttack[e]=nil
end
function HeroBattleInfo:GetAttrValueInCurAttack(i,a)
if(not self.CurrHeroCtrl)then
return 0
end
local e=0
local t=self.attrValueDicInCurAttack[i]
if(t)then
for o,t in ipairs(t)do
if a==nil or t.heroId==nil or a==t.heroId then
local a=self:GetBuff(t.buffId)
local o=1
if(a and a.isOpenAttrFloor)then
o=a.floors
if(a.isGran==7)then
o=1
end
end
e=e+t.value*o
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
if(e>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
return e
end
function HeroBattleInfo:TriggerBuff(o,n,s,h)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return
end
local e=self:GetBuffSortArr()
for a=1,#e do
local a=e[a]
local e=a.buffId
if self.CurrHeroCtrl==nil then
break
end
if self:CheckBuffExist(e)then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(e)
if(a.isExec==false and i.GetCanTrigger(o))then
local i=true
if o==BuffTriggerTime.fatalDmg then
local e=t:GetBuffCfg(e)
if self.CurrHeroCtrl.ImmuneResurgence>e.triggleLevel then
i=false
end
elseif o==BuffTriggerTime.fatalDmgBefore then
local e=t:GetBuffCfg(e)
if self.CurrHeroCtrl.ImmuneAvoidDeath>e.triggleLevel then
i=false
end
end
if i then
local t={
buffTriggerTime=o
}
local t=a:DoBuffAction(n,s,h,t)
if type(t)=="table"then
if t.isOper==true then
if t.isRemoveFloor~=nil then
a:ReduceFloors(t.isRemoveFloor)
if a:GetFloors()<=0 then
self:RemoveBuffWithId(e,BuffRemoveType.Expire)
end
elseif t.remove==true then
self:RemoveBuffWithId(e,BuffRemoveType.Expire)
end
else
self:AddTempBuffValues(t)
end
end
end
end
end
end
end
function HeroBattleInfo:TriggerBuffAndReturnValue(a,s,n,i)
if ModulesInit.ProcedureNormalBattle.isTimeLine then
return 0
end
local t=0
local e=self:GetBuffSortArr()
for o=1,#e do
local e=e[o]
local o=e.buffId
if self:CheckBuffExist(o)then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
if(e.isExec==false and o.GetCanTrigger(a))then
local a={
buffTriggerTime=a
}
local e=e:DoBuffAction(s,n,i,a)
if type(e)=="number"then
t=t+e
end
end
end
end
return t
end
function HeroBattleInfo:GetTotalBuffAndTempBuffValue(t,a)
local e=self:GetTotalBuffValue(t,a)
e=e+self:GetTotalBuffTempValue(t,a)
e=e+self:GetAttrValueInBattle(t,a)
e=e+self:GetAttrValueInCurAttack(t,a)
if self.CurrHeroCtrl then
local t=self.CurrHeroCtrl:GetAttrMinValue(t)
if t and e<t then
e=t
end
end
return e
end
function HeroBattleInfo:GetLimitBuffAndTempBuffValue(t,e,a)
local o=self:GetLimitTotalBuffValue(t,e,a)
local i=self:GetLimitTotalBuffTempValue(t,e,a)
local n=self:GetLimitAttrValueInBattle(t,e,a)
local t=self:GetLimitAttrValueInCurAttack(t,e,a)
local e={}
if o~=nil then
table.insert(e,o)
end
if i~=nil then
table.insert(e,i)
end
if n~=nil then
table.insert(e,n)
end
if t~=nil then
table.insert(e,t)
end
local t=nil
if a then
for a=1,#e do
if t==nil then
t=e[a]
else
t=math.min(t,e[a])
end
end
else
for a=1,#e do
if t==nil then
t=e[a]
else
t=math.max(t,e[a])
end
end
end
return t
end
function HeroBattleInfo:GetLimitTotalBuffValue(i,a,n)
if(not self.CurrHeroCtrl)then
return 0
end
local e=nil
local t=self.BuffValueDic[i]
if(t)then
for o,t in ipairs(t)do
if a==nil or t.heroId==nil or a==t.heroId then
local o=self:GetBuff(t.buffId)
local a=1
if(o and o.isOpenAttrFloor)then
a=o.floors
if(o.isGran==7)then
a=1
end
end
if e==nil then
e=t.value*a
else
if n==true then
e=math.min(e,t.value*a)
elseif n==false then
e=math.max(e,t.value*a)
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
if(e and e>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
return e
end
function HeroBattleInfo:GetLimitTotalBuffTempValue(i,a,n)
if(not self.CurrHeroCtrl)then
return 0
end
local e=nil
local t=self.TempBuffValueDic[i]
if(t)then
for o,t in ipairs(t)do
if a==nil or t.heroId==nil or a==t.heroId then
local o=self:GetBuff(t.buffId)
local a=1
if(o and o.isOpenAttrFloor)then
a=o.floors
if(o.isGran==7)then
a=1
end
end
if e==nil then
e=t.value*a
else
if n==true then
e=math.min(e,t.value*a)
elseif n==false then
e=math.max(e,t.value*a)
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
if(e and e>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
return e
end
function HeroBattleInfo:GetLimitAttrValueInBattle(i,a,n)
if(not self.CurrHeroCtrl)then
return 0
end
local e=nil
local t=self.attrValueDicInBattle[i]
if(t)then
for o,t in ipairs(t)do
if a==nil or t.heroId==nil or a==t.heroId then
local o=self:GetBuff(t.buffId)
local a=1
if(o and o.isOpenAttrFloor)then
a=o.floors
if(o.isGran==7)then
a=1
end
end
if e==nil then
e=t.value*a
else
if n==true then
e=math.min(e,t.value*a)
elseif n==false then
e=math.max(e,t.value*a)
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
if(e and e>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
return e
end
function HeroBattleInfo:GetLimitAttrValueInCurAttack(i,a,n)
if(not self.CurrHeroCtrl)then
return 0
end
local e=nil
local t=self.attrValueDicInCurAttack[i]
if(t)then
for o,t in ipairs(t)do
if a==nil or t.heroId==nil or a==t.heroId then
local o=self:GetBuff(t.buffId)
local a=1
if(o and o.isOpenAttrFloor)then
a=o.floors
if(o.isGran==7)then
a=1
end
end
if e==nil then
e=t.value*a
else
if n==true then
e=math.min(e,t.value*a)
elseif n==false then
e=math.max(e,t.value*a)
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
if(e and e>0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
return e
end
function HeroBattleInfo:ShowOrHideBuffEffect(e,a)
if(not self.CurrHeroCtrl)then
return
end
for o,t in pairs(self.BuffDic)do
if(t)then
t:ShowOrHideBuffEffect(e,a)
end
end
if a~=true then
if(not ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.BigSkillAttacking))then
self.CurrHeroCtrl:ShowOrHideSpecialEffect(e)
end
end
end
function HeroBattleInfo:GetCurrHP()
return math.floor(self.CurrHP)
end
function HeroBattleInfo:GetMaxHP()
return math.floor(self.MaxHP)
end
function HeroBattleInfo:GetCurrFury()
return math.floor(self.CurrFury)
end
function HeroBattleInfo:GetCurrArmor()
return math.floor(self.curArmor)
end
function HeroBattleInfo:GetCanRecoveryHp()
return math.floor(self.CurrMaxHP-self.CurrHP)
end
function HeroBattleInfo:CheckBattleEffectNormalExists(a,t)
local e=#self.battleEffects
for e=1,e do
local e=self.battleEffects[e]
if(e.battleEffectType==a and e.round==t)then
return true
end
end
return false
end
function HeroBattleInfo:AddBattleEffectNormal(t,a)
if(self:CheckBattleEffectNormalExists(t,a))then
return
end
local e=BattleEffectInfo:New()
e.battleEffectType=t
e.round=a
self.battleEffects[#self.battleEffects+1]=e
end
function HeroBattleInfo:AddBattleEffectWithBuff(t,a)
local e=BattleEffectInfo:New()
e.battleEffectType=BattleEffectType.Buff
e.round=a
e.buffId=t.buffId
e.heroBuffInfo=t
self.battleEffects[#self.battleEffects+1]=e
end
function HeroBattleInfo:PlayBattleEffectWithBuffId(t)
for a=#self.battleEffects,1,-1 do
local e=self.battleEffects[a]
if(e.battleEffectType==BattleEffectType.Buff)then
if(e.buffId==t and e.round==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.heroBuffInfo:PlayBuffEffect()
e:Dispose()
table.remove(self.battleEffects,a)
end
end
end
end
function HeroBattleInfo:PlayBattleAllBuffEffect()
for t=#self.battleEffects,1,-1 do
local e=self.battleEffects[t]
if(e.battleEffectType==BattleEffectType.Buff)then
if e.round==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.heroBuffInfo:PlayBuffEffect()
e:Dispose()
table.remove(self.battleEffects,t)
end
end
end
end
function HeroBattleInfo:PlayBattleAllBuffAddEffect(t)
local e=self:GetBuffSortArr()
for a=1,#e do
local e=e[a]
e:ExcuteAddEffect(t)
end
end
function HeroBattleInfo:PlayBattleEffectWithType(t)
if(not self.CurrHeroCtrl)then
return
end
for a=#self.battleEffects,1,-1 do
local e=self.battleEffects[a]
if(e.battleEffectType==t and e.round==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound)then
self:ExcuteBattleEffectWithTypeWhithoutCheck(t)
e:Dispose()
table.remove(self.battleEffects,a)
end
end
end
function HeroBattleInfo:ExcuteBattleEffectWithTypeWhithoutCheck(e)
if(not self.CurrHeroCtrl)then
return
end
if self.CurrHeroCtrl:IsPet()then
return
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(e==BattleEffectType.AddFury)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.CurrHeroCtrl:PlayAddFuryWithSkill()
local e=self.CurrHeroCtrl:GetFootPointPos()
GameEntry.Effect:ShowBuffEffect(
Constant.Fury_Add_Effect_PrefabId,
1,
Constant.Fury_Add_Effect_KeepTime,
e.x,
e.y,
e.z,
nil,
function(t,e,t)
if(self.CurrHeroCtrl)then
e:SetParent(self.CurrHeroCtrl.spineboyTransform)
e.localPosition=Vector3.zero
end
end
)
elseif(e==BattleEffectType.ReduceFury)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.CurrHeroCtrl:PlayReduceFuryWithSkill()
self.CurrHeroCtrl:PlayReduceFuryEffect()
elseif(e==BattleEffectType.HpHealth)then
if(self.CurrHeroCtrl)then
self.CurrHeroCtrl:PlayHpHealthEffect()
end
end
end
end

