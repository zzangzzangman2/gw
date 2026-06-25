local e=require("Modules/Battle/BattleUtil")
local e={
}
local o=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=t[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return o 
