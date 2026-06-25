local e={
}
local i=e
function e.DoAction(e,a)
local o=e:JudgeSkillPreView(a)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local o=o[1]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return i 
