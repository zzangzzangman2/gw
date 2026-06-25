local e={
}
local s=e
function e.DoAction(e,t)
local a=e:JudgeSkillPreView(t)
e:ReduceFury(t.costMp)
local n=a[1]
local i=a[3]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eRandom,3)
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for a,o in ipairs(a)do
local a=n
if(o.profession==ProfessionType.Warrior)then
a=a+i
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,t,a)
end
end
return nil
end
return s 
