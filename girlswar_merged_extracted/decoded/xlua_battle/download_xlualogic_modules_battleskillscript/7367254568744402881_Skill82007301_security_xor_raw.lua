local e=require("Modules/Battle/BattleUtil")
local e={
}
local i=e
function e.DoAction(t,a)
local o=t:JudgeSkillPreView(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eOneBack)
if(e==nil)then
return
end
local i=o[1]
local o=0
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,i,0,o)
return nil
end
return i 
