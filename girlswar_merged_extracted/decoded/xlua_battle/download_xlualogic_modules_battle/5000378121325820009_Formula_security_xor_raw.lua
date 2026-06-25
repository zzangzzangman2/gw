local a=require("DataNode/DataManager/DataMgr/DataUtil")
local r=require("Modules/Battle/BattleUtil")
local m={
[EForceRestraintType.None]={
[EForceRestraintType.None]=EForceRestraintResult.None,
[EForceRestraintType.BeRestraint]=EForceRestraintResult.Restraint,
[EForceRestraintType.ImmuneRestraint]=EForceRestraintResult.UnableRestraint,
[EForceRestraintType.Restraint]=EForceRestraintResult.BeRestraint,
},
[EForceRestraintType.BeRestraint]={
[EForceRestraintType.None]=EForceRestraintResult.BeRestraint,
[EForceRestraintType.BeRestraint]=EForceRestraintResult.BeRestraint,
[EForceRestraintType.ImmuneRestraint]=EForceRestraintResult.BeRestraint,
[EForceRestraintType.Restraint]=EForceRestraintResult.BeRestraint,
},
[EForceRestraintType.ImmuneRestraint]={
[EForceRestraintType.None]=EForceRestraintResult.ImmuneRestraint,
[EForceRestraintType.BeRestraint]=EForceRestraintResult.Restraint,
[EForceRestraintType.ImmuneRestraint]=EForceRestraintResult.Draw,
[EForceRestraintType.Restraint]=EForceRestraintResult.Draw,
},
[EForceRestraintType.Restraint]={
[EForceRestraintType.None]=EForceRestraintResult.Restraint,
[EForceRestraintType.BeRestraint]=EForceRestraintResult.Restraint,
[EForceRestraintType.ImmuneRestraint]=EForceRestraintResult.Draw,
[EForceRestraintType.Restraint]=EForceRestraintResult.Draw,
}
}
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
function o:GetHurtValue(t,h,d,f,e,u,s,i)
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
d=math.floor(d*t.skillHurtRateAdd*MillionCoe)
end
t.HeroBattleInfo:RestTempBuffValues()
e.HeroBattleInfo:RestTempBuffValues()
e:SetLastAttackHeroId(t.HeroId)
local c=i and i.triggerSkillAtkType or u.atkType
local n={
triggerSkillAtkType=c,
triggerSkillType=u.type,
isPetTrigger=false,
}
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.attack,t,e,n)
if(h==AttackType.Normal)then
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.normalAttack,t,e,n)
elseif(h==AttackType.SmallSkill)then
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.skill2Attack,t,e,n)
elseif(h==AttackType.BigSkill)then
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.skillAttack,t,e,n)
end
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.attacked,t,e,n)
if(h==AttackType.Normal or h==AttackType.SmallSkill)then
if(h==AttackType.Normal)then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.normalAttacked,t,e,n)
else
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.smallSkillAttacked,t,e,n)
end
e.normalOrSmallSkillAttackedTimes=e.normalOrSmallSkillAttackedTimes+1
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.normalOrSmallSkillAttacked,t,e,n)
else
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.sufferSkillDmg,t,e,n)
end
self.atkHero_Final_Atk=o:CalculateHeroFinalAtk(t)
self.atkHero_IgnoreDef_Temp=t.HeroBattleInfo.IgnoreDefRate+t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.IgnoreDefRate)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
self.atkHero_Final_IgnoreDef=1-a.GetBattleAttrCoe(HeroAttrId.IgnoreDefRate,a.BattleAttrClamp(HeroAttrId.IgnoreDefRate,self.atkHero_IgnoreDef_Temp))
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local l=o:GetHeroAttrValue(e,HeroAttrId.defRateAddFinal)
self.beAtkHero_Final_Def=(e.HeroBattleInfo.Def+e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.defAdd))/2.5*
(1+a.GetBattleAttrCoe(HeroAttrId.defRate,a.BattleAttrClamp(HeroAttrId.defRate,e.HeroBattleInfo.defRate+e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.defRate))))*
self.atkHero_Final_IgnoreDef*math.max(0,1+l)
if i.IgnoreDef==true then
self.beAtkHero_Final_Def=0
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then






end
local l=o:GetInjureData(t)
local p=l.attackRate
local y=l.attackAddRate
local m=l.attackInjureRateAddFinalValue
local v=l.attackFinalInjureRate
local l=o:GetInjureResData(e)
local g=l.deffendRate
local b=l.deffendAddRate
local w=l.defInjureResRateAddFinalValue
local l=l.defFinalInjureResRate
if t.IgnoreInjureRes then
l=math.min(0,l)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
self.finalDmgRate=1+v-l
self.finalDmgRate=a.BattleAttrClamp(HeroAttrId.finalInjureRate,self.finalDmgRate*OneMillion)*MillionCoe
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then







end
self.baseHurtValue=(self.atkHero_Final_Atk-self.beAtkHero_Final_Def)*self.finalDmgRate
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if ModulesInit.ProcedureNormalBattle.IsPVE()==false then
local s=e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.tenacityRate)
local i=e.HeroBattleInfo.tenacityRate+s
local n=a.GetBattleAttrCoe(HeroAttrId.tenacityRate,a.BattleAttrClamp(HeroAttrId.tenacityRate,i))
local i=o:GetHeroAttrValue(e,HeroAttrId.tenacityRateAddFinal)
local h=n*math.max(0,1+i)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then





end
local i=t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.tenacityResRate)
local e=t.HeroBattleInfo.tenacityResRate+i
local a=a.GetBattleAttrCoe(HeroAttrId.tenacityResRate,a.BattleAttrClamp(HeroAttrId.tenacityResRate,e))
local e=o:GetHeroAttrValue(t,HeroAttrId.tenacityResRateAddFinal)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then





end
local e=a*math.max(0,1+e)
local e=math.max(g_minBattledTenacityRate,h-e)
e=math.min(g_maxBattledTenacityRate,e)
self.baseHurtValue=self.baseHurtValue*(1-e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(self.baseHurtValue<=0)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if ModulesInit.ProcedureNormalBattle.BattleType==BattleType.WarOfAttrition then
self.baseHurtValue=1
else
self.baseHurtValue=Constant.battle_lowest_ratio*t.HeroBattleInfo.Level*RandomMgr:GetBattleRandomWithRange(Constant.battle_lowest_min,Constant.battle_lowest_max)*MillionCoe
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.criticalOrBlock=0
self.finalCriticalOrBlock=1
self.criticalValue=0
self.blockValue=0
local l=o:CalculateHeroAttackCriticalRate(t,e)
local v=l.attackCritical
local p=l.attackCriticalRateAddBattleBefore
local m=l.attackCriticalRateAddBattleBeforeWithHero
local w=l.attackCriticalRateAdd
local y=l.attackCriticalRateAddFinalValue
local q=l.attackCriticalRate
local l=o:CalculateHeroAttackCriticalResRate(e)
local k=l.defCriticalRes
local g=l.defCriticalResRateAdd
local b=l.defCriticalResRateAddFinalValue
local l=l.defFinalCriticalResRate
self.finalCritical=a.BattleAttrClamp(
HeroAttrId.finalCriticalRate,
(q-l)*OneMillion)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local l,m=r:GetCritRateWithType(ModulesInit.ProcedureNormalBattle.BattleType,t:GetHeroId())
if l then
local t=a.GetBattleAttrCoe(HeroAttrId.criticalRateAdd,a.BattleAttrClamp(HeroAttrId.criticalRateAdd,m))
self.finalCritical=t
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
local y=a.GetBattleAttrCoe(HeroAttrId.block,e.HeroBattleInfo.Block)
local l=a.GetBattleAttrCoe(HeroAttrId.blockRateAddBattleBefore,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.blockRateAddBattleBefore))
local w=a.GetBattleAttrCoe(HeroAttrId.blockRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.blockRateAdd))
local m=a.GetBattleAttrCoe(HeroAttrId.blockRes,t.HeroBattleInfo.BlockRes)
local p=a.GetBattleAttrCoe(HeroAttrId.blockResRateAdd,t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.blockResRateAdd))
self.finalBlock=a.BattleAttrClamp(HeroAttrId.finalBlockRate,((y*(1+l)+w)-(m+p))*OneMillion)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then






end
if((self.finalCritical+self.finalBlock)==0 and t.IsMustCrit~=true and e:GetMustBeCritOnce()~=true)then
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
if(t.IsMustCrit==true or e:GetMustBeCritOnce()or self.triggerCritical*OneMillion>=self.random_triggerCritical)then
self.random=RandomMgr:GetBattleRandom()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(t.ForbidCritical or t.ForbidCriticalInCurAttack)then
t.ForbidCriticalInCurAttack=false
self.random=RandomForbidValue
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(t.IsMustCrit==true or e:GetMustBeCritOnce()or self.finalCritical>=self.random)then
self.criticalValue=o:CalculateHeroCriticalValue(t,e)
self.finalCriticalOrBlock=self.criticalValue
self.criticalOrBlock=1
end
else
self.random=RandomMgr:GetBattleRandom()
if(t.IgnoreBlock or e.disableBlock)then
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
self.finalProfValue=0
self.profType=0
local m,l=o:CalculateProfRestain(t,e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
if(m==ProfResType.None)then
self.finalProfValue=MillionCoe*l
elseif(m==ProfResType.Restrain)then
self.profType=1
local s=a.GetBattleAttrCoe(HeroAttrId.ProfRes,t.HeroBattleInfo.ProfRes)
local o=a.GetBattleAttrCoe(HeroAttrId.ProfResRateAdd,t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.ProfResRateAdd))
local i=a.GetBattleAttrCoe(HeroAttrId.ProfResed,e.HeroBattleInfo.ProfResed)
local n=a.GetBattleAttrCoe(HeroAttrId.ProfResedRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.ProfResedRateAdd))
self.finalProfValue=MillionCoe*
(l+a.BattleAttrClamp(HeroAttrId.finalProfResRate,OneMillion*(s+o-(i+n))))
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then




end
elseif(m==ProfResType.BeRestrain)then
self.profType=2
self.finalProfValue=MillionCoe*
(l+a.BattleAttrClamp(HeroAttrId.finalProfResedRate,OneMillion*(a.GetBattleAttrCoe(HeroAttrId.ProfResed,t.HeroBattleInfo.ProfResed)+a.GetBattleAttrCoe(HeroAttrId.ProfResedRateAdd,t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.ProfResedRateAdd))-(a.GetBattleAttrCoe(HeroAttrId.ProfRes,e.HeroBattleInfo.ProfRes)+a.GetBattleAttrCoe(HeroAttrId.ProfResRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.ProfResRateAdd))))))
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then




end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local l=o:CalculateAmuletAdd(t,e)
self.final_Hurt_Value=0
if d>0 then
if(h==AttackType.BigSkill)then
local i=o:GetEXSkillINjureData(t)
local o=o:GetEXSkillINjureResData(e)
self.BigSkillValue=i-o
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.BigSkillValue=a.BattleAttrClamp(HeroAttrId.finaleXSkillINjureRate,self.BigSkillValue*OneMillion)*MillionCoe
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then






end
self.final_Hurt_Value=self.baseHurtValue*self.finalCriticalOrBlock*(d*MillionCoe+self.BigSkillValue)*self.finalProfValue*l
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
elseif(h==AttackType.SmallSkill)then
self.SmallSkillValue=(a.GetBattleAttrCoe(HeroAttrId.skillInjure,t.HeroBattleInfo.SkillInjure)+a.GetBattleAttrCoe(HeroAttrId.skillInjureRateAdd,t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.skillInjureRateAdd)))-
(a.GetBattleAttrCoe(HeroAttrId.skillInjureRes,e.HeroBattleInfo.SkillInjureRes)+a.GetBattleAttrCoe(HeroAttrId.skillInjureResRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.skillInjureResRateAdd)))
self.SmallSkillValue=a.BattleAttrClamp(HeroAttrId.finalSkillInjureRate,self.SmallSkillValue*OneMillion)*MillionCoe
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then






end
self.final_Hurt_Value=self.baseHurtValue*self.finalCriticalOrBlock*(d*MillionCoe+self.SmallSkillValue)*self.finalProfValue*l
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
elseif(h==AttackType.Normal)then
self.final_Hurt_Value=self.baseHurtValue*self.finalCriticalOrBlock*(d*MillionCoe)*self.finalProfValue*l
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
end
else
self.criticalOrBlock=0
end
if(GameInit.IsClient)then
if(self.criticalOrBlock==1)then
if(self.profType==0)then
e.HurtNumType=EBattleHurtNumType.BaoJi
elseif(self.profType==1)then
e.HurtNumType=EBattleHurtNumType.KeZhi_BaoJi
elseif(self.profType==2)then
e.HurtNumType=EBattleHurtNumType.BeiKeZhi_BaoJi
end
elseif(self.criticalOrBlock==2)then
if(self.profType==0)then
e.HurtNumType=EBattleHurtNumType.GeDang
elseif(self.profType==1)then
e.HurtNumType=EBattleHurtNumType.KeZhi_GeDang
elseif(self.profType==2)then
e.HurtNumType=EBattleHurtNumType.BeiKeZhi_GeDang
end
else
if(self.profType==0)then
e.HurtNumType=EBattleHurtNumType.ChangeGui
elseif(self.profType==1)then
e.HurtNumType=EBattleHurtNumType.KeZhi
elseif(self.profType==2)then
e.HurtNumType=EBattleHurtNumType.BeiKeZhi
end
end
end
self.final_Hurt_Value=self.final_Hurt_Value+t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.trueDmg)
if(self.criticalOrBlock==1 or self.criticalOrBlock==2)then
if(self.criticalOrBlock==1)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.beCritical,t,e)
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.critical,t,e)
self.final_Hurt_Value=self.final_Hurt_Value+t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.tureDmgAfterCritical)
end
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.beCriticalOrBlocked,t,e,self.criticalOrBlock)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.final_Hurt_Value=self.final_Hurt_Value*(1+e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.takeDamagePercent)*MillionCoe)
self.final_Hurt_Value=math.floor(self.final_Hurt_Value)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local d=1
if i then
if i.totalDamageRate then
d=i.totalDamageRate*MillionCoe
end
end
self.final_Hurt_Value=math.floor(self.final_Hurt_Value*d)
if self.criticalOrBlock==1 and i and i.realHurtInCrit then
s=s+i.realHurtInCrit
end
if(s>0)then
local o=s
local t=a.GetBattleAttrCoe(HeroAttrId.realInjureResRateAdd,a.BattleAttrClamp(HeroAttrId.realInjureResRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.realInjureResRateAdd)))
s=math.max(0,s*(1-t))
self.final_Hurt_Value=self.final_Hurt_Value+s
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
end
if i and i.damageRate then
self.final_Hurt_Value=math.floor(self.final_Hurt_Value*i.damageRate*MillionCoe)
end
local l=o:GetHeroAttrValue(t,HeroAttrId.damageAddFinal)
local a=o:GetHeroAttrValue(e,HeroAttrId.damageResAddFinal)
local d=self.final_Hurt_Value
self.final_Hurt_Value=self.final_Hurt_Value*math.max(0,1+l)*math.max(0,1-a)
local d=math.max(0,math.floor(d-self.final_Hurt_Value))
local m=t.HeroBattleInfo:GetLimitBuffAndTempBuffValue(HeroAttrId.zeroHurt,nil,false)
if(m~=nil and m>=RandomMgr:GetBattleRandom())then
self.final_Hurt_Value=0
s=0
d=0
end
e.spelicalHurtNumType=nil
if e.ForbidImmuneDamage==false and e.ImmuneDamage then
self.final_Hurt_Value=0
s=0
d=0
e.spelicalHurtNumType=EBattleHurtNumType.ResistFatalDamage
elseif e.ForbidEvade==false and o:GetFinalAvadeRate(t,e)*OneMillion>=RandomMgr:GetBattleRandom()then
self.final_Hurt_Value=0
s=0
d=0
e.spelicalHurtNumType=EBattleHurtNumType.Evade
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.evadeed,t,e,n)
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.evade,t,e,n)
elseif t:IsAttackInvalidState()then
n.hurtValue=self.final_Hurt_Value
t.HeroBattleInfo:TriggerBuff(BuffTriggerTime.attackInvalid,t,e,n)
self.final_Hurt_Value=0
s=0
d=0
e.spelicalHurtNumType=EBattleHurtNumType.ResistFatalDamage
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
if self.final_Hurt_Value>0 then
if e.ForbidImmuneDamage==false and e.hasImmuneDamageBuff then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.immuneDamageConsume,t,e,n)
if e.immuneDamageWithConsume then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
if i then
i.realHurt=s
end
local a=e:GetRealHurtWithHpInLogic(self.final_Hurt_Value,u.type,HeroHurtType.hurtPoint)
if e.ForbidImmuneDamage==false and e:CheckAndExcuteImmuneAfterDamage(a,t)then
self.final_Hurt_Value=0
s=0
d=0
e.spelicalHurtNumType=EBattleHurtNumType.ResistFatalDamage
o:ResetHurtDataImmuneAfterDamage(a)
end
a.isArmor=false
if e:GetArmor()>0 then
local t,o=o:CalculateProfRestain(t,e)
local t=r:GetArmorDamageWithType(ModulesInit.ProcedureNormalBattle.BattleType,t==ProfResType.Restrain)
if(GameInit.IsClient)then
e.HurtNumType=EBattleHurtNumType.Armor
end
a.isArmor=true
a.hurtValue=t
a.reduceHpValue=0
a.reduceHpValueBeforeReduceLimit=0
a.reduceHpValueBeforeCurrHPLimit=0
end
local l=a.reduceHpValueBeforeReduceLimit
local s=a.reduceHpValueBeforeCurrHPLimit
local n=a.reduceHpValue
self.final_Hurt_Value=a.hurtValue
if self.final_Hurt_Value<=0 then
if e.spelicalHurtNumType==nil then
e.spelicalHurtNumType=EBattleHurtNumType.ResistFatalDamage
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
self.final_Thorn=o:GetFinalThorn(e)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if r:CheckCanThornWithBattleType(ModulesInit.ProcedureNormalBattle.BattleType,t:GetHeroId())==false then
self.final_Thorn=0
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(self.final_Thorn>0 and i.ignoreThorn~=true)then
t:AddThorn(n*self.final_Thorn)
end
self.final_Blood=o:GetFinalBlood(t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if r:CheckCanAddBloodWithBattleType(ModulesInit.ProcedureNormalBattle.BattleType,t:GetHeroId())==false then
self.final_Blood=0
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(self.final_Blood>0)then
local e=t:GetFinalHealRate()
if e>0 then
t:AddBlood(math.min(n*self.final_Blood*e))
end
end
local o={
hurtValue=self.final_Hurt_Value,
reduceHpValue=n,
reduceHpValueBeforeReduceLimit=l,
reduceHpValueBeforeCurrHPLimit=s,
triggerSkillAtkType=c,
criticalOrBlock=self.criticalOrBlock,
attackHeroId=t.HeroId,
beAttackHeroId=e.HeroId,
triggerSkillType=u.type,
isPetTrigger=false,
attackType=h,
damageResAddFinalHurt=d,
hurtData=a,
}
a.criticalOrBlock=self.criticalOrBlock
a.hurtValue=self.final_Hurt_Value
a.attackType=h
a.triggerSkillType=u.type
a.triggerSkillAtkType=c
a.damageResAddFinalHurt=d
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.afterAttacked,t,e,o)
EventSystem.SendEvent(CommonEventId.OnAnyHeroSkillBeAttack,o)
if i.openAddFury~=false and e:GetDisableDefFuryhealthInCurAttack()==false then
e:FuryHealth(FuryHealthType.BeAttack,f,n,i)
if ModulesInit.ProcedureNormalBattle.IsStakeFight()then
i.beAttackHeroCtrl=e
t:FuryHealth(FuryHealthType.Attack,f,n,i)
end
else
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
e:SetMustBeCritOnce(false)
t:ClearForceRestraintTypeInCurAttack()
e:ClearForceRestraintTypeInCurAttack()
return a
end
function o:GetTeamHurtValue(s,h,h,h,e,n,i,t)
self:Reset()
t=t or{}
if(s==nil)then
GameInit.LogError("GetHurtValue team is nil")
return
end
if(e.HeroBattleInfo==nil)then
return
end
e.HeroBattleInfo:RestTempBuffValues()
local h=t and t.triggerSkillAtkType or n.atkType
local s={
triggerSkillAtkType=h,
triggerSkillType=n.type,
isPetTrigger=false,
isTeamAttack=true,
teamId=s.TeamId
}
self.final_Hurt_Value=0
if(GameInit.IsClient)then
e.HurtNumType=EBattleHurtNumType.ChangeGui
end
if(i>0)then
local o=i
local t=a.GetBattleAttrCoe(HeroAttrId.realInjureResRateAdd,a.BattleAttrClamp(HeroAttrId.realInjureResRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.realInjureResRateAdd)))
i=math.max(0,i*(1-t))
self.final_Hurt_Value=self.final_Hurt_Value+i
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
end
local s=0
local h=o:GetHeroAttrValue(e,HeroAttrId.damageResAddFinal)
local a=self.final_Hurt_Value
self.final_Hurt_Value=self.final_Hurt_Value*math.max(0,1+s)*math.max(0,1-h)
local s=math.max(0,math.floor(a-self.final_Hurt_Value))
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.spelicalHurtNumType=nil
if e.ForbidImmuneDamage==false and e.ImmuneDamage then
self.final_Hurt_Value=0
i=0
a=0
e.spelicalHurtNumType=EBattleHurtNumType.ResistFatalDamage
elseif e.ForbidEvade==false and o:GetFinalAvadeRate(nil,e)*OneMillion>=RandomMgr:GetBattleRandom()then
self.final_Hurt_Value=0
i=0
a=0
e.spelicalHurtNumType=EBattleHurtNumType.Evade
end
if self.final_Hurt_Value>0 then
if e.ForbidImmuneDamage==false and e.hasImmuneDamageBuff then
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.immuneDamageConsume)
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
if t then
t.realHurt=i
end
local t=e:GetRealHurtWithHpInLogic(self.final_Hurt_Value,n.type,HeroHurtType.hurtPoint)
if e.ForbidImmuneDamage==false and e:CheckAndExcuteImmuneAfterDamage(t)then
self.final_Hurt_Value=0
i=0
s=0
e.spelicalHurtNumType=EBattleHurtNumType.ResistFatalDamage
o:ResetHurtDataImmuneAfterDamage(t)
end
t.isArmor=false
if e:GetArmor()>0 then
local a=r:GetArmorDamageWithType(ModulesInit.ProcedureNormalBattle.BattleType,false)
if(GameInit.IsClient)then
e.HurtNumType=EBattleHurtNumType.Armor
end
t.isArmor=true
t.hurtValue=a
t.reduceHpValue=0
t.reduceHpValueBeforeReduceLimit=0
t.reduceHpValueBeforeCurrHPLimit=0
end
local a=t.reduceHpValueBeforeReduceLimit
local a=t.reduceHpValue
self.final_Hurt_Value=t.hurtValue
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
t.criticalOrBlock=self.criticalOrBlock
t.hurtValue=self.final_Hurt_Value
t.damageResAddFinalHurt=s
return t
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
local h=n*MillionCoe
local s=o:GetHeroControlRate(t)
local s=s.attackFinalControlRate
local o=o:GetHeroControlResRate(e,i)
local o=o.defFinalControlResRate
local o=h*(1+s-o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
local i,n=r:GetControlBuffSuccessRateWithType(ModulesInit.ProcedureNormalBattle.BattleType,e:GetHeroId())
if i then
local t=a.GetBattleAttrCoe(HeroAttrId.controlRateAdd,a.BattleAttrClamp(HeroAttrId.controlRateAdd,n))
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
function o:GetFinalAvadeRate(e,t)
local t=o:GetHeroAvadeData(t)
local a=t.defFinalEvadeRate
local t=0
if e then
local e=o:GetHeroAvadeResData(e)
t=e.attackFinalEvadeRes
end
local e=a-t
return e
end
function o:GetHeroAvadeResData(e)
local o=a.GetBattleAttrCoe(HeroAttrId.evadeRes,e.HeroBattleInfo.evadeRes)
local t=a.GetBattleAttrCoe(HeroAttrId.evadeResRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.evadeResRateAdd))
local a=o+t
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
return{
attackEvadeRes=o,
attackEvadeResRateAdd=t,
attackFinalEvadeRes=a,
}
end
function o:GetHeroAvadeData(e)
local o=a.GetBattleAttrCoe(HeroAttrId.evade,e.HeroBattleInfo.evade)
local t=a.GetBattleAttrCoe(HeroAttrId.evadeRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.evadeRateAdd))
local a=o+t
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
return{
defBeforeEvade=o,
defBuffEvadeRateAdd=t,
defFinalEvadeRate=a,
}
end
function o:GetHeroControlRate(e)
local i=e.HeroBattleInfo:GetAttrValue(HeroAttrId.control)
local s=a.GetBattleAttrCoe(HeroAttrId.control,i)
local t=e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.controlRateAdd)
local n=a.GetBattleAttrCoe(HeroAttrId.controlRateAdd,t)
local a=o:GetHeroAttrValue(e,HeroAttrId.controlRateAddFinal)
local o=math.max(0,s+n)*math.max(0,1+a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
return{
attackFinalControlRate=o
}
end
function o:GetHeroControlResRate(e,t)
local r=e.HeroBattleInfo:GetAttrValue(HeroAttrId.controlRes)
local l=a.GetBattleAttrCoe(HeroAttrId.controlRes,r)
local s=e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.controlResRateAdd)
local d=a.GetBattleAttrCoe(HeroAttrId.controlResRateAdd,s)
local n=o:GetHeroAttrValue(e,HeroAttrId.controlResRateAddFinal)
local h=0
local i=0
local t=o:GetControlResRateAddAttr(t)
if t then
i=e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(t)
h=a.GetBattleAttrCoe(HeroAttrId.controlResRateAdd,i)
end
local a=math.max(0,l+d+h)*math.max(0,1+n)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then




end
return{
defFinalControlResRate=a,
}
end
function o:GetControlResRateAddAttr(e)
if e==3003 then
return HeroAttrId.numbnessControlResRateAdd
end
end
function o:CalculateChangeAttrValue(a,o,e,i,t,n)
if e==nil or e.HeroBattleInfo==nil or a==nil or a.HeroBattleInfo==nil then
return 0
end
local a=a.HeroBattleInfo:GetAttrValue(t)
local e=e.HeroBattleInfo:GetAttrValue(t)
local e=math.min(a*o,e*i)
local e=r.ChangeBattleAttr(t,n,e)
return e
end
function o:GetForceProfRestainResult(e,t)
if m[e]and m[e][t]then
local e=m[e][t]
return e
end
return EForceRestraintResult.None
end
function o:CalculateProfRestain(i,n)
local h=i:GetAttackForceTotalRestraintType()
local s=n:GetDefForceTotalRestraintType()
local t,e=o:CalculateProfRestainByCfg(i,n)
local a=o:GetForceProfRestainResult(h,s)
local t=t.resDam
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then




end
if a==EForceRestraintResult.None then
elseif a==EForceRestraintResult.BeRestraint then
e=ProfResType.BeRestrain
t=G_BeRestraintDam
elseif a==EForceRestraintResult.UnableRestraint then
if e==ProfResType.Restrain then
e=ProfResType.None
t=G_RestraintDrawDam
end
elseif a==EForceRestraintResult.ImmuneRestraint then
if e==ProfResType.BeRestrain then
e=ProfResType.None
t=G_RestraintDrawDam
end
elseif a==EForceRestraintResult.Draw then
e=ProfResType.None
t=G_RestraintDrawDam
elseif a==EForceRestraintResult.Restraint then
e=ProfResType.Restrain
t=G_RestraintDam
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return e,t
end
function o:CalculateProfRestainByCfg(e,i)
local t=a.GetProfRes(e.profession,i.profession)
local o=t.resType
if o==ProfResType.Restrain then
if e.profession==ProfessionType.Tank and i.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.notBeRestrainByTank)>0 then
o=ProfResType.None
t=a.GetProfRes(e.profession,e.profession)
end
end
return t,o
end
function o:CalculateHeroFinalAtk(e)
local h=e.HeroBattleInfo.Atk
local i=e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.atkAdd)
local s=e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.atkRate)
local n=a.GetBattleAttrCoe(HeroAttrId.atkRate,a.BattleAttrClamp(HeroAttrId.atkRate,e.HeroBattleInfo.atkRate+s))
local a=o:GetHeroAttrValue(e,HeroAttrId.atkRateAddFinal)
local t=(h+i)*(1+n)*math.max(0,1+a)
if e.minFinalAtk>0 then
t=math.max(t,e.minFinalAtk)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then






end
return t
end
function o:CalculateHeroAttackCriticalRate(e,i)
local s=a.GetBattleAttrCoe(HeroAttrId.critical,e.HeroBattleInfo.Critical)
local n=a.GetBattleAttrCoe(HeroAttrId.criticalRateAddBattleBefore,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.criticalRateAddBattleBefore))
local t=0
local h=0
if i then
t=a.GetBattleAttrCoe(HeroAttrId.criticalRateAddBattleBeforeWithHero,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.criticalRateAddBattleBeforeWithHero,i.HeroId))
h=i:GetHeroId()
end
local i=a.GetBattleAttrCoe(HeroAttrId.criticalRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.criticalRateAdd))
local a=o:GetHeroAttrValue(e,HeroAttrId.criticalRateAddFinal)
local o=s*(1+n+t)+i
local o=math.max(0,o)*math.max(0,1+a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then





end
return{
attackCritical=s,
attackCriticalRateAddBattleBefore=n,
attackCriticalRateAddBattleBeforeWithHero=t,
attackCriticalRateAdd=i,
attackCriticalRateAddFinalValue=a,
attackCriticalRate=o
}
end
function o:CalculateHeroAttackCriticalResRate(e)
local i=a.GetBattleAttrCoe(HeroAttrId.criticalRes,e.HeroBattleInfo.CriticalRes)
local a=a.GetBattleAttrCoe(HeroAttrId.criticalResRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.criticalResRateAdd))
local t=o:GetHeroAttrValue(e,HeroAttrId.criticalResRateAddFinal)
local o=math.max(0,i+a)*math.max(0,1+t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
return{
defCriticalRes=i,
defCriticalResRateAdd=a,
defCriticalResRateAddFinalValue=t,
defFinalCriticalResRate=o
}
end
function o:CalculateHeroCriticalValue(e,t)
local h=a.GetBattleAttrCoe(HeroAttrId.criticalStrength,e.HeroBattleInfo.CriticalStrength)
local r=a.GetBattleAttrCoe(HeroAttrId.criticalStrengthAddBattleBefore,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.criticalStrengthAddBattleBefore))
local s=a.GetBattleAttrCoe(HeroAttrId.criticalStrengthRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.criticalStrengthRateAdd))
local n=o:GetHeroAttrValue(e,HeroAttrId.criticalStrengthRateAddFinal)
local o=h*(1+r)+s
local d=a.BattleAttrClamp(
HeroAttrId.finalCriticalStrengthRate,
math.max(0,o)*math.max(0,1+n)*OneMillion
)
local o=0
local i=0
if t then
o=a.GetBattleAttrCoe(HeroAttrId.criticalStrengthRes,t.HeroBattleInfo.criticalStrengthRes)
i=a.GetBattleAttrCoe(HeroAttrId.criticalStrengthResAdd,t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.criticalStrengthResAdd))
end
local a=(o+i)*OneMillion
local a=1+MillionCoe*(Constant.battle_critical_rate+d-a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



if t then


end

end
return a
end
function o:GetDefBattleBefore(e)
local e=(e.HeroBattleInfo.Def+e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.defAdd))
return e
end
function o:GetDefBlock(e)
local t=a.GetBattleAttrCoe(HeroAttrId.block,e.HeroBattleInfo.Block)
local o=a.GetBattleAttrCoe(HeroAttrId.blockRateAddBattleBefore,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.blockRateAddBattleBefore))
local e=a.GetBattleAttrCoe(HeroAttrId.blockRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.blockRateAdd))
local e=t*(1+o)+e
return e
end
function o:CalculateAmuletAdd(e,t)
local n=r:GetAmuletRateAddByCamp(t.camp)
local i=r:GetAmuletResRateAddByCamp(e.camp)
local o=1
if n~=nil and i~=nil then
local h=a.GetBattleAttrCoe(n,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(n))
local s=a.GetBattleAttrCoe(i,t.HeroBattleInfo:GetTotalBuffAndTempBuffValue(i))
o=1+h-s
o=MillionCoe*a.BattleAttrClamp(HeroAttrId.amuletFinalRateAdd,OneMillion*o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then



end
end
return o
end
function o:GetInjureData(e)
local t=a.GetBattleAttrCoe(HeroAttrId.injure,e.HeroBattleInfo.Injure)
local a=a.GetBattleAttrCoe(HeroAttrId.injureRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.injureRateAdd))
local e=o:GetHeroAttrValue(e,HeroAttrId.injureRateAddFinal)
local o=math.max(0,t+a)*math.max(0,1+e)
return{
attackRate=t,
attackAddRate=a,
attackInjureRateAddFinalValue=e,
attackFinalInjureRate=o,
}
end
function o:GetEXSkillINjureData(e)
local e=a.GetBattleAttrCoe(HeroAttrId.eXSkillINjure,e.HeroBattleInfo.eXSkillINjure)+a.GetBattleAttrCoe(HeroAttrId.eXSkillINjureRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.eXSkillINjureRateAdd))
return e
end
function o:GetEXSkillINjureResData(e)
local e=a.GetBattleAttrCoe(HeroAttrId.eXSkillINjureRes,e.HeroBattleInfo.eXSkillINjureRes)+a.GetBattleAttrCoe(HeroAttrId.eXSkillINjureResRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.eXSkillINjureResRateAdd))
return e
end
function o:GetInjureResData(e)
local t=a.GetBattleAttrCoe(HeroAttrId.injureRes,e.HeroBattleInfo.InjureRes)
local a=a.GetBattleAttrCoe(HeroAttrId.injureResRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.injureResRateAdd))
local e=o:GetHeroAttrValue(e,HeroAttrId.injureResRateAddFinal)
local o=math.max(0,t+a)*math.max(0,1+e)
return{
deffendRate=t,
deffendAddRate=a,
defInjureResRateAddFinalValue=e,
defFinalInjureResRate=o,
}
end
function o:GetFinalThorn(e)
local t=a.GetBattleAttrCoe(HeroAttrId.thorn,e.HeroBattleInfo.Thorn)
local e=a.GetBattleAttrCoe(HeroAttrId.thornRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.thornRateAdd))
local e=t+e
return e
end
function o:GetFinalBlood(e)
local t=a.GetBattleAttrCoe(HeroAttrId.blood,e.HeroBattleInfo.Blood)
local e=a.GetBattleAttrCoe(HeroAttrId.bloodRateAdd,e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.bloodRateAdd))
local e=t+e
return e
end
function o:GetBattleBeforeAtk(e)
local e=(e.HeroBattleInfo.Atk+e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.atkAdd))
return e
end
function o:AddAtkToHero(e,t)
local e=o:GetBattleBeforeAtk(e)
if e>0 then
return t/e
else
return 0
end
end
function o:CalculateMaxHp(e)
local e=(e.OriginalHP*(1+e.MaxHpAddRate)+e.MaxHpAddValue)
e=math.floor(math.max(1,e))
return e
end
function o:ResetHurtDataImmuneAfterDamage(e)
e.needReduceShield=0
e.needReduceEnergy=0
e.reduceHpValue=0
e.reduceHpValueBeforeReduceLimit=0
e.reduceHpValueBeforeCurrHPLimit=0
e.hurtValue=0
e.originHurtValue=0
return e
end
function o:GetSmallSkillRate(e)
local t=0
if(e.SmallSkillId>0)then
local e=r:GetSkillActData(e.SmallSkillId)
if e then
t=e.skillRate
end
end
local a=e.HeroBattleInfo:GetTotalBuffAndTempBuffValue(HeroAttrId.skillTriggerRateAdd)
local e=t+e.HeroBattleInfo.SkillTriggerRate+a
return e
end
return o 
