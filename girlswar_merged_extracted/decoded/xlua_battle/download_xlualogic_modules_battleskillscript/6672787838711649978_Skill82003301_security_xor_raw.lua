local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(t,a)
local o=t:JudgeSkillPreView(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local i=o[1]
local o=#e
for o=1,o do
local o=e[o]
local e=0
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,a,i,0,e)
end
return nil
end
return n 
