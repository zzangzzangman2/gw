local e={
}
local o=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local o=t[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o)
return nil
end
return o 
