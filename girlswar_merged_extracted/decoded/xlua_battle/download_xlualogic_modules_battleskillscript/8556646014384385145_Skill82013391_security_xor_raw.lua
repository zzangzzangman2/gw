local e={
}
local n=e
function e.DoAction(t,i,e,a)
local o=e.chaseSkillHurtRate
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if e==nil or#e==0 then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local a=#e
for a=1,a do
local e=e[a]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,o)
end
return nil
end
return n

