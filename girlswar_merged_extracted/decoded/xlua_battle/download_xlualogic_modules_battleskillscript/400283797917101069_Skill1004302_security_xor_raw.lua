local e={
}
local h=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local i=t[1]*MillionCoe
local n=e:GetFinalAtk()
local s=e:GetIsCrtRemedy()
local t=0
if(a.skilltype and a.skilltype==1)then
local a=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(a)then
t=a*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
e:HpHealthWithBigSkill(e,n*(1+t),i,s,EBattleSrcType.SkillBig)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy,EBattleSrcType.SkillBig)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(o)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fAttrLow,1,HeroAttrId.hpPer)
if(o~=nil and#o>0)then
local o=o[1]
t=0
if(a.skilltype and a.skilltype==1)then
local a=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(a)then
t=a*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(o.HeroId==e.HeroId)then
o:HpHealthWithBigSkill(e,n*(1+t),i,s,EBattleSrcType.SkillBig)
else
o:HpHealthWithBigSkill(e,n*(1+t),i,s,EBattleSrcType.SkillBig)
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.hpHealthWith1004,e,o)
end
end
return nil
end
return h 
