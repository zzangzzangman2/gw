local n=require("Modules/Battle/BattleUtil")
local e={
}
local i=e
function e.DoAction(a,t,e,o)
local o=a:JudgeSkillPreView(t)
local o=e.realhurt
local e=e.defHeroId
local e=n:GetTargetHeroCtrl(e)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,t,0,0,o)
return nil
end
return i 
