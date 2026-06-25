local e={}
local o=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
if(not ModulesInit.ProcedureNormalBattle.IsPVE())then
local a=e[1]
local o=e[2]
local e={e[3]}
t:AddBuff(t,a,o,e)
end
end
return o

