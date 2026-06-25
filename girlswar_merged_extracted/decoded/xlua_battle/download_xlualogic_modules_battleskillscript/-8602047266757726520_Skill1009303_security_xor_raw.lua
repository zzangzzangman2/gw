local e={
}
local d=e
function e.DoAction(t,a)
local e=t:JudgeSkillPreView(a)
t:ReduceFury(a.costMp)
local i=e[1]
local o=e[3]
local s=e[4]
local n={e[5]}
t:AddBuff(t,o,s,n)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(o~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
for o,e in ipairs(o)do
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,i)
end
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if(a)then
local r=e[6]
local o=e[7]
local i={e[8]}
local h=e[9]
local s=e[10]
local n={e[11]}
for a,e in ipairs(a)do
e:AddBuff(t,r,o,i)
e:AddBuff(t,h,s,n)
end
end
local a=e[12]
local o=e[13]
local e={e[14]}
t:AddBuff(t,a,o,e)
return nil
end
return d 
