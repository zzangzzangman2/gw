local e={
}
local o=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[1]
local i=e[2]
local n={e[3]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if(a)then
for a,e in ipairs(a)do
e:AddBuff(t,o,i,n)
end
end
local o=e[4]
local a=e[5]
local i={e[6],e[7]}
t:AddBuff(t,o,a,i)
local a=e[8]
local o=e[9]
local i={e[10],e[11]}
t:AddBuff(t,a,o,i)
t:AddImmuneBuff(e[12])
return nil
end
return o 
