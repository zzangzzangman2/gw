local i=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(t,a)
local o=t:JudgeSkillPreView(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
local e=i:FindMostBigAtk(e)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
local o=o[1]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,o)
return nil
end
return n 
