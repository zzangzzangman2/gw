local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(t,a)
local o=t:JudgeSkillPreView(a)
local e=BattleHeroType.eFront
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,e)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local i=o[1]
local o=#e
for o=1,o do
local e=e[o]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,i)
end
return nil
end
return n 
