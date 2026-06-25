local a=require("DataNode/DataManager/DataMgr/DataUtil")
local u=require("Modules/Battle/BattleUtil")
local c=require("Modules/Battle/Formula")
local o={
atkHero_Final_Atk=0,
atkHero_IgnoreDef_Temp=0,
atkHero_Final_IgnoreDef=0,
beAtkHero_Final_Def=0,
finalDmgRate=0,
baseHurtValue=0,
criticalOrBlock=0,
finalCriticalOrBlock=0,
criticalValue=0,
blockValue=0,
finalCritical=0,
finalBlock=0,
triggerCritical=0,
triggerBlock=0,
random_triggerCritical=0,
random=0,
finalProfValue=0,
profType=0,
drProfRes=nil,
final_Hurt_Value=0,
BigSkillValue=0,
SmallSkillValue=0,
final_Thorn=0,
final_Blood=0
}
function o:Reset()
self.atkHero_Final_Atk=0
self.atkHero_IgnoreDef_Temp=0
self.atkHero_Final_IgnoreDef=0
self.beAtkHero_Final_Def=0
self.finalDmgRate=0
self.baseHurtValue=0
self.criticalOrBlock=0
self.finalCriticalOrBlock=0
self.criticalValue=0
self.blockValue=0
self.finalCritical=0
self.finalBlock=0
self.triggerCritical=0
self.triggerBlock=0
self.random_triggerCritical=0
self.random=0
self.finalProfValue=0
self.profType=0
self.drProfRes=nil
self.final_Hurt_Value=0
self.BigSkillValue=0
self.SmallSkillValue=0
self.final_Thorn=0
self.final_Blood=0
end
function o:GetHeroAttrValue(t,e)
return a.GetBattleAttrCoe(e,a.BattleAttrClamp(e,t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(e)))
end
function o:GetHurtValue(t,s,l,j,e,d,n,i)
self:Reset()
i=i or{}
if(t==nil)then
GameInit.LogError("GetHurtValue attackHeroCtrl is nil")
FightDataReportMgr:SetErrorCode(ServerErrorCode.attackHeroCtrlNoExists)
return
end
if(e.HeroBattleInfo==nil)then
return
end
if t.skillHurtRateAdd then
l=math.floor(l*t.skillHurtRateAdd*MillionCoe)
end
t.HeroBattleInfo:RestTempBuffValues()
e.HeroBattleInfo:RestTempBuffValues()
local f=i and i.triggerSkillAtkType or d.atkType
local h={
triggerSkillAtkType=f,
triggerSkillType=d.type,
isPetTrigger=true,
}
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.attack,t,e,h)
if(s==AttackType.PetFightSkill)then
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.petFightAttack,t,e)
elseif(s==AttackType.PetHelpSkill)then
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.petHelpAttack,t,e)
end
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.attacked,t,e,h)
if s==AttackType.PetFightSkill then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.petFightAttacked,t,e)
elseif(s==AttackType.PetHelpSkill)then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.petHelpAttacked,t,e)
end
self.atkHero_Final_Atk=o:CalculateHeroFinalAtk(t,true)
self.atkHero_IgnoreDef_Temp=t.HeroBattleInfo.IgnoreDefRate+t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.IgnoreDefRate)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
self.atkHero_Final_IgnoreDef=1-a.GetBattleAttrCoe(HeroAttrId.IgnoreDefRate,a.BattleAttrClamp(HeroAttrId.IgnoreDefRate,self.atkHero_IgnoreDef_Temp))
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local k=a.GetBattleAttrCoe(HeroAttrId.petDefFactor,e.HeroBattleInfo.petDefFactor)
local g=a.GetBattleAttrCoe(HeroAttrId.petAtkFactor,t.HeroBattleInfo.petAtkFactor)
local x=math.max(Constant.petAtkFactorMin,1-(k-g))
local r=o:GetInjureData(t)
local p=r.attackRate
local v=r.attackAddRate
local b=r.attackInjureRateAddFinalValue
local q=r.attackFinalInjureRate
local r=o:GetInjureResData(e)
local y=r.deffendRate
local w=r.deffendAddRate
local m=r.defInjureResRateAddFinalValue
local r=r.defFinalInjureResRate
if t.IgnoreInjureRes then
r=math.min(0,r)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
self.finalDmgRate=1+q-r
self.finalDmgRate=a.BattleAttrClamp(HeroAttrId.finalInjureRate,self.finalDmgRate*OneMillion)*MillionCoe
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then







end
self.baseHurtValue=(self.atkHero_Final_Atk*x)*self.finalDmgRate
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if ModulesInit.ProcedureNormalBattle.IsPVE()==false then
local i=e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.tenacityRate)
local n=e.HeroBattleInfo.tenacityRate+i
local n=a.GetBattleAttrCoe(HeroAttrId.tenacityRate,a.BattleAttrClamp(HeroAttrId.tenacityRate,n))
local o=o:GetHeroAttrValue(e,HeroAttrId.tenacityRateAddFinal)
local s=n*math.max(0,1+o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then





end
local e=t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.tenacityResRate)
local o=t.HeroBattleInfo.tenacityResRate+e
local o=a.GetBattleAttrCoe(HeroAttrId.tenacityResRate,a.BattleAttrClamp(HeroAttrId.tenacityResRate,o))
local a=c:GetHeroAttrValue(t,HeroAttrId.tenacityResRateAddFinal)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then





end
local e=o*math.max(0,1+a)
local e=math.max(g_minBattledTenacityRate,s-e)
e=math.min(g_maxBattledTenacityRate,e)
self.baseHurtValue=self.baseHurtValue*(1-e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(self.baseHurtValue<=0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.baseHurtValue=Constant.battle_lowest_ratio*t.HeroBattleInfo.Level*RandomMgr:GetBattleRandomWithRange(Constant.battle_lowest_min,Constant.battle_lowest_max)*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.criticalOrBlock=0
self.finalCriticalOrBlock=1
self.criticalValue=0
self.blockValue=0
local r=o:CalculateHeroAttackCriticalRate(t,e)
local b=r.attackCritical
local g=r.attackCriticalRateAdd
local p=r.attackCriticalRateAddFinalValue
local v=r.attackCriticalRate
local r=o:CalculateHeroAttackCriticalResRate(e)
local y=r.defCriticalRes
local w=r.defCriticalResRateAdd
local m=r.defCriticalResRateAddFinalValue
local r=r.defFinalCriticalResRate
self.finalCritical=a.BattleAttrClamp(
HeroAttrId.finalCriticalRate,
(v-r)*OneMillion)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local r,m=u:GetCritRateWithType(ModulesInit.ProcedureNormalBattle.BattleType,t:GetHeroId())
if r then
local t=a.GetBattleAttrCoe(HeroAttrId.petCriticalRateAdd,a.BattleAttrClamp(HeroAttrId.petCriticalRateAdd,m))
self.finalCritical=t
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
local y=a.GetBattleAttrCoe(HeroAttrId.block,e.HeroBattleInfo.Block)
local w=a.GetBattleAttrCoe(HeroAttrId.blockRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.blockRateAdd))
local m=a.GetBattleAttrCoe(HeroAttrId.blockRes,t.HeroBattleInfo.BlockRes)
local r=a.GetBattleAttrCoe(HeroAttrId.blockResRateAdd,t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.blockResRateAdd))
self.finalBlock=a.BattleAttrClamp(HeroAttrId.finalBlockRate,((y+w)-(m+r))*OneMillion)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then






end
if((self.finalCritical+self.finalBlock)==0 and t.IsMustCrit~=true)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
else
self.triggerCritical=self.finalCritical/(self.finalCritical+self.finalBlock)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.triggerBlock=self.finalBlock/(self.finalCritical+self.finalBlock)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.random_triggerCritical=RandomMgr:GetBattleRandom()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(t.IsMustCrit==true or self.triggerCritical*OneMillion>=self.random_triggerCritical)then
self.random=RandomMgr:GetBattleRandom()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(t.ForbidCritical)then
self.random=RandomForbidValue
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(t.IsMustCrit==true or self.finalCritical>=self.random)then
self.criticalValue=o:CalculateHeroCriticalValue(t,e)
self.finalCriticalOrBlock=self.criticalValue
self.criticalOrBlock=1
end
else
self.random=RandomMgr:GetBattleRandom()
if(t.IgnoreBlock)then
self.random=RandomForbidValue
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(self.finalBlock>=self.random)then
self.blockValue=1-
(MillionCoe*Constant.battle_block_rate+
MillionCoe*a.BattleAttrClamp(HeroAttrId.finalBlockStrengthRate,
(a.GetBattleAttrCoe(HeroAttrId.blockStrength,e.HeroBattleInfo.BlockStrength)+a.GetBattleAttrCoe(HeroAttrId.blockStrengthRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.blockStrengthRateAdd)))
*OneMillion
))
self.finalCriticalOrBlock=self.blockValue
self.criticalOrBlock=2
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.beBlocked,t,e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
if(not e.HeroBattleInfo:HasStrongControlBuff())then
e.CurrIsBlocking=true
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
end
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.final_Hurt_Value=0
if(s==AttackType.PetFightSkill or s==AttackType.PetHelpSkill)then
self.final_Hurt_Value=self.baseHurtValue*self.finalCriticalOrBlock*(l*MillionCoe)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
end
if(GameInit.IsClient)then
if(self.criticalOrBlock==1)then
e.HurtNumType=EBattleHurtNumType.BaoJi
elseif(self.criticalOrBlock==2)then
e.HurtNumType=EBattleHurtNumType.GeDang
else
e.HurtNumType=EBattleHurtNumType.ChangeGui
end
end
local r=t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.trueDmg)
self.final_Hurt_Value=self.final_Hurt_Value+r
if(self.criticalOrBlock==1 or self.criticalOrBlock==2)then
if(self.criticalOrBlock==1)then
local a=t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.tureDmgAfterCritical)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.beCritical,t,e)
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.critical,t,e)
self.final_Hurt_Value=self.final_Hurt_Value+a
end
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.beCriticalOrBlocked,t,e,self.criticalOrBlock)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local r=e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.takeDamagePercent)*MillionCoe
self.final_Hurt_Value=self.final_Hurt_Value*(1+r)
self.final_Hurt_Value=math.floor(self.final_Hurt_Value)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local r=1
if i then
if i.totalDamageRate then
r=i.totalDamageRate*MillionCoe
end
end
self.final_Hurt_Value=math.floor(self.final_Hurt_Value*r)
if self.criticalOrBlock==1 and i and i.realHurtInCrit then
n=n+i.realHurtInCrit
end
if(n>0)then
local o=n
local t=a.GetBattleAttrCoe(HeroAttrId.realInjureResRateAdd,a.BattleAttrClamp(HeroAttrId.realInjureResRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.realInjureResRateAdd)))
n=math.max(0,n*(1-t))
self.final_Hurt_Value=self.final_Hurt_Value+n
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
end
if i and i.damageRate then
self.final_Hurt_Value=math.floor(self.final_Hurt_Value*i.damageRate*MillionCoe)
end
local l=o:GetHeroAttrValue(t,HeroAttrId.damageAddFinal)
local r=o:GetHeroAttrValue(e,HeroAttrId.damageResAddFinal)
local a=self.final_Hurt_Value
self.final_Hurt_Value=self.final_Hurt_Value*math.max(0,1+l)*math.max(0,1-r)
local o=math.max(0,math.floor(a-self.final_Hurt_Value))
local a=t.HeroBattleInfo:GetLimitBuffAndTempBuffValue(HeroAttrId.zeroHurt,nil,false)
if(a~=nil and a>=RandomMgr:GetBattleRandom())then
self.final_Hurt_Value=0
n=0
if i then
i.realHurt=n
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
e.spelicalHurtNumType=nil
if e.ForbidImmuneDamage==false and e.ImmuneDamage then
self.final_Hurt_Value=0
n=0
o=0
e.spelicalHurtNumType=EBattleHurtNumType.ResistFatalDamage
elseif e.ForbidEvade==false and c:GetFinalAvadeRate(t,e)*OneMillion>=RandomMgr:GetBattleRandom()then
self.final_Hurt_Value=0
n=0
o=0
e.spelicalHurtNumType=EBattleHurtNumType.Evade
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.evadeed,t,e,h)
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.evade,t,e,h)
elseif t:IsAttackInvalidState()then
h.hurtValue=self.final_Hurt_Value
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.attackInvalid,t,e,h)
self.final_Hurt_Value=0
n=0
o=0
e.spelicalHurtNumType=EBattleHurtNumType.ResistFatalDamage
end
if self.final_Hurt_Value>0 then
if e.ForbidImmuneDamage==false and e.hasImmuneDamageBuff then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.immuneDamageConsume,t,e,h)
if e.immuneDamageWithConsume then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
if self.final_Hurt_Value<=0 then
if e.spelicalHurtNumType==nil then
e.spelicalHurtNumType=EBattleHurtNumType.ResistFatalDamage
end
end
if i then
i.realHurt=n
end
local a=e:GetRealHurtWithHpInLogic(self.final_Hurt_Value,d.type,HeroHurtType.hurtPoint)
if e.ForbidImmuneDamage==false and e:CheckAndExcuteImmuneAfterDamage(a,t)then
self.final_Hurt_Value=0
n=0
o=0
e.spelicalHurtNumType=EBattleHurtNumType.ResistFatalDamage
c:ResetHurtDataImmuneAfterDamage(a)
end
a.isArmor=false
if e:GetArmor()>0 then
local t=u:GetArmorDamageWithType(ModulesInit.ProcedureNormalBattle.BattleType,false)
if(GameInit.IsClient)then
e.HurtNumType=EBattleHurtNumType.Armor
end
a.isArmor=true
a.hurtValue=t
a.reduceHpValue=0
a.reduceHpValueBeforeReduceLimit=0
a.reduceHpValueBeforeCurrHPLimit=0
end
local r=a.reduceHpValueBeforeReduceLimit
local n=a.reduceHpValueBeforeCurrHPLimit
local h=a.reduceHpValue
self.final_Hurt_Value=a.hurtValue
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local n={
hurtValue=self.final_Hurt_Value,
reduceHpValue=h,
reduceHpValueBeforeReduceLimit=r,
reduceHpValueBeforeCurrHPLimit=n,
triggerSkillAtkType=f,
criticalOrBlock=self.criticalOrBlock,
attackHeroId=t.HeroId,
beAttackHeroId=e.HeroId,
triggerSkillType=d.type,
isPetTrigger=true,
attackType=s,
damageResAddFinalHurt=o,
hurtData=a
}
a.criticalOrBlock=self.criticalOrBlock
a.hurtValue=self.final_Hurt_Value
a.attackType=s
a.damageResAddFinalHurt=o
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.afterAttacked,t,e,n)
EventSystem.SendEvent(CommonEventId.OnAnyHeroSkillBeAttack,n)
if i.openAddFury~=false and e:GetDisableDefFuryhealthInCurAttack()==false then
e:FuryHealth(FuryHealthType.BeAttack,j,h)
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
return a
end
function o:CalculateCtrlSuccess(i,n,t,e)
local s=a:GetBuffCfg(i)
if(s==nil)then
GameInit.LogError("计算控制类buff成功率 对应的Buff不存在 buffId %s",i)
return false
end
if(n==nil)then
GameInit.LogError("计算控制类buff成功率 baseRateOrigin 不存在 buffId %s",i)
return false
end
if t==nil or t.HeroBattleInfo==nil or e==nil or e.HeroBattleInfo==nil then
GameInit.LogError("计算控制类buff成功率  攻击者 防御者 不存在 buffId %s",i)
return false
end
if(s.isControl<1)then
if(n>=RandomMgr:GetBattleRandom())then
return true
end
return false
end
if e.ImmuneControlBuff==true then
return false
end
local s=n*MillionCoe
local h=o:GetHeroControlRate(t)
local h=h.attackFinalControlRate
local o=o:GetHeroControlResRate(e,i)
local o=o.defFinalControlResRate
local o=s*(1+h-o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
local i,n=u:GetControlBuffSuccessRateWithType(ModulesInit.ProcedureNormalBattle.BattleType,e:GetHeroId())
if i then
local t=a.GetBattleAttrCoe(HeroAttrId.petControlRateAdd,a.BattleAttrClamp(HeroAttrId.petControlRateAdd,n))
o=t
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(o*OneMillion>=RandomMgr:GetBattleRandom())then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return true
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
function o:GetHeroControlRate(e)
local t=e.HeroBattleInfo.petControl
local n=a.GetBattleAttrCoe(HeroAttrId.petControl,t)
local i=e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.petControlRateAdd)
local s=a.GetBattleAttrCoe(HeroAttrId.petControlRateAdd,i)
local a=o:GetHeroAttrValue(e,HeroAttrId.controlRateAddFinal)
local o=math.max(0,n+s)*math.max(0,1+a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
return{
attackFinalControlRate=o
}
end
function o:GetHeroControlResRate(e,t)
local t=e.HeroBattleInfo.petControlRes
local s=a.GetBattleAttrCoe(HeroAttrId.petControlRes,t)
local i=e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.petControlResRateAdd)
local n=a.GetBattleAttrCoe(HeroAttrId.petControlResRateAdd,i)
local a=o:GetHeroAttrValue(e,HeroAttrId.controlResRateAddFinal)
local o=math.max(0,s+n)*math.max(0,1+a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then




end
return{
defFinalControlResRate=o,
}
end
function o:GetControlResRateAddAttr(e)
if e==3003 then
return HeroAttrId.numbnessControlResRateAdd
end
end
function o:CalculateHeroFinalAtk(e,r)
local i=e.HeroBattleInfo.petAtk
local n=e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.petAtkAdd)
local h=e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.petAtkRate)
local s=a.GetBattleAttrCoe(HeroAttrId.petAtkRate,a.BattleAttrClamp(HeroAttrId.petAtkRate,h))
local t=o:GetHeroAttrValue(e,HeroAttrId.atkRateAddFinal)
local a=(i+n)*(1+s)*math.max(0,1+t)
if r then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then





end
end
return a
end
function o:CalculateHeroAttackCriticalRate(e)
local t=a.GetBattleAttrCoe(HeroAttrId.petCritical,e.HeroBattleInfo.petCritical)
local a=a.GetBattleAttrCoe(HeroAttrId.petCriticalRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.petCriticalRateAdd))
local o=o:GetHeroAttrValue(e,HeroAttrId.criticalRateAddFinal)
local i=t+a
local i=math.max(0,i)*math.max(0,1+o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
return{
attackCritical=t,
attackCriticalRateAdd=a,
attackCriticalRateAddFinalValue=o,
attackCriticalRate=i
}
end
function o:CalculateHeroAttackCriticalResRate(e)
local i=a.GetBattleAttrCoe(HeroAttrId.petCriticalRes,e.HeroBattleInfo.petCriticalRes)
local t=a.GetBattleAttrCoe(HeroAttrId.petCriticalResRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.petCriticalResRateAdd))
local a=o:GetHeroAttrValue(e,HeroAttrId.criticalResRateAddFinal)
local o=math.max(0,i+t)*math.max(0,1+a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
return{
defCriticalRes=i,
defCriticalResRateAdd=t,
defCriticalResRateAddFinalValue=a,
defFinalCriticalResRate=o
}
end
function o:CalculateHeroCriticalValue(e,t)
local h=a.GetBattleAttrCoe(HeroAttrId.petCriticalStrength,e.HeroBattleInfo.petCriticalStrength)
local s=a.GetBattleAttrCoe(HeroAttrId.petCriticalStrengthRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.petCriticalStrengthRateAdd))
local n=o:GetHeroAttrValue(e,HeroAttrId.criticalStrengthRateAddFinal)
local o=h+s
local r=a.BattleAttrClamp(
HeroAttrId.finalCriticalStrengthRate,
math.max(0,o)*math.max(0,1+n)*OneMillion
)
local o=0
local i=0
if t then
o=a.GetBattleAttrCoe(HeroAttrId.petCriticalStrengthRes,t.HeroBattleInfo.petCriticalStrengthRes)
i=a.GetBattleAttrCoe(HeroAttrId.petCriticalStrengthResAdd,t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.petCriticalStrengthResAdd))
end
local a=(o+i)*OneMillion
local a=1+MillionCoe*(Constant.battle_critical_rate+r-a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



if t then


end

end
return a
end
function o:GetInjureData(e)
local t=a.GetBattleAttrCoe(HeroAttrId.petInjure,e.HeroBattleInfo.petInjure)
local a=a.GetBattleAttrCoe(HeroAttrId.petInjureRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.petInjureRateAdd))
local e=o:GetHeroAttrValue(e,HeroAttrId.injureRateAddFinal)
local o=math.max(0,t+a)*math.max(0,1+e)
return{
attackRate=t,
attackAddRate=a,
attackInjureRateAddFinalValue=e,
attackFinalInjureRate=o,
}
end
function o:GetInjureResData(e)
local t=a.GetBattleAttrCoe(HeroAttrId.petInjureRes,e.HeroBattleInfo.petInjureRes)
local a=a.GetBattleAttrCoe(HeroAttrId.petInjureResRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.petInjureResRateAdd))
local e=o:GetHeroAttrValue(e,HeroAttrId.injureResRateAddFinal)
local o=math.max(0,t+a)*math.max(0,1+e)
return{
deffendRate=t,
deffendAddRate=a,
defInjureResRateAddFinalValue=e,
defFinalInjureResRate=o,
}
end
return o 
