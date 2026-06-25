local e={
}
local i=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=t[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eRandom,t[2])
if(t~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
for i,t in ipairs(t)do
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o)
end
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return i 
