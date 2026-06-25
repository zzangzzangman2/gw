local e={
}
local n=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
e:ReduceFury(o.costMp)
local i=t[1]
local a=e.HeroBattleInfo.CurrHP*t[3]*MillionCoe
e:HpReduceImmediately(a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for n,a in ipairs(a)do
local t=e.HeroBattleInfo.MaxHP*t[4]*MillionCoe
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,i,0,t)
end
end
return nil
end
return n 
