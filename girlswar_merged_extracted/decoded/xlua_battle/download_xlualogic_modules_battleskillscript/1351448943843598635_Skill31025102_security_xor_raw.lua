local e=require("Modules/Battle/BattleUtil")
local e={
}
local o=e
function e.DoAction(t,a,e)
local o=t:JudgeSkillPreView(a)
local o=e.realhurt
local e=e.targetHeroId
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,0,0,o)
return nil
end
return o 
