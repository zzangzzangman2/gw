local e={}
local n=e
function e.DoAction(t,a,e)
local o=t:JudgeSkillPreView(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local i=o[1]
if(e~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local o=#e
for o=1,o do
local e=e[o]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,i)
end
end
return nil
end
return n

