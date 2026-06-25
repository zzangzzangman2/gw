local e=require("Modules/Battle/BattleUtil")
local e={
}
local o=e
function e.DoAction(t,a)
local e=t:JudgeSkillPreView(a)
local o=e[1]
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,o)
return nil
end
return o 
