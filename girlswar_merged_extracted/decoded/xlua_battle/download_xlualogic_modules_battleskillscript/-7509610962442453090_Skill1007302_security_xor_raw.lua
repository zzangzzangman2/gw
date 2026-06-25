local e={
}
local n=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local i=t[1]
local n=t[3]
local o=t[4]
local s=t[5]
local t={t[6]}
e:AddBuff(e,o,s,t)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eRandom,3)
if(t~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
for t,o in ipairs(t)do
local t=i
if(o.profession==ProfessionType.Warrior)then
t=t+n
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,a,t)
end
end
return nil
end
return n 
