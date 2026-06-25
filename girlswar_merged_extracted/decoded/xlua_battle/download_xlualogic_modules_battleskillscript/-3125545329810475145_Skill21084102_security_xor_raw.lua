local e={
}
local s=e
function e.DoAction(t,a,i,e)
local e=t:JudgeSkillPreView(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
local o=0
local n=i.realhurt
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local i=#e
for i=1,i do
local e=e[i]
local i={
openAddFury=false
}
e:SetDisableDefRage(true)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,o,0,n)
e:SetDisableDefRage(false)
end
return nil
end
return s 
