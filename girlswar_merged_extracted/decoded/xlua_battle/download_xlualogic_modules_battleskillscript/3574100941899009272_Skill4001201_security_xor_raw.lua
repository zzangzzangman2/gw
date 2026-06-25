local e={
}
local o=e
function e.DoAction(t,a)
local o=a.args[1]
t:FuryHealth(FuryHealthType.Attack)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(e==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,o)
return nil
end
return o 
