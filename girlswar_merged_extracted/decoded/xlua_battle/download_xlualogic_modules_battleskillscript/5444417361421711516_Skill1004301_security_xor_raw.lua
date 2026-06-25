local e={
}
local h=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local s=t[1]*MillionCoe
local n=e:GetFinalAtk()
local i=e:GetIsCrtRemedy()
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fAttrLow,1,HeroAttrId.hpPer)
if(t~=nil and#t>0)then
local o=t[1]
local t=0
if(a.skilltype and a.skilltype==1)then
local a=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(a)then
t=a*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
if(o.HeroId==e.HeroId)then
o:HpHealthWithBigSkill(e,n*(1+t),s,i,EBattleSrcType.SkillBig)
else
o:HpHealthWithBigSkill(e,n*(1+t),s,i,EBattleSrcType.SkillBig)
e.HeroBattleInfo:TriggerBuff(BuffTriggerTime.hpHealthWith1004,e,o)
end
end
return nil
end
return h 
