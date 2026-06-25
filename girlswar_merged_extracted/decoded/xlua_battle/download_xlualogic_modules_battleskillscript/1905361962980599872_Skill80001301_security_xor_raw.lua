local e=require("Modules/Battle/BattleUtil")
local e={
}
local i=e
function e.DoAction(e,a)
local o=e:JudgeSkillPreView(a)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eFrontMinHpPercentWithCount)
local t=t[1]
if(t==nil)then
return nil
end
local o=o[1]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o)
return nil
end
return i 
