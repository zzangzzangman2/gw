local e=require("Modules/Battle/BattleUtil")
local a={
}
local n=a
function a.DoAction(a,i)
local o=a:JudgeSkillPreView(i)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
local t=table.lightCopyList(e)
t=RandomTableWithSeed(t,o[2])
if(t==nil)then
return nil
end
local o=o[1]
e=t
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local t=#e
for t=1,t do
local e=e[t]
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,i,o,0,0)
end
return nil
end
function a.DoPassiveAction(t,e)
local e=t:JudgeSkillPreView(e)
return nil
end
return n 
