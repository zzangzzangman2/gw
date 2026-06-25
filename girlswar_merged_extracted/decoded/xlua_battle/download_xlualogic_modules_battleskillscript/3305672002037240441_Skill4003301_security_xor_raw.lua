local e={
}
local i=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local o=t[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
for i,t in ipairs(t)do
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o)
end
end
return nil
end
return i 
