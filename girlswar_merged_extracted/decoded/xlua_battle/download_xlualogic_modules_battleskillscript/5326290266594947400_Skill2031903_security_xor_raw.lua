local e={}
local o=e
function e.DoAction(t,e)
if(not ModulesInit.ProcedureNormalBattle.IsPVE())then
local o=e.args[1]
local a=e.args[2]
local e={e.args[3]}
t:AddBuff(t,o,a,e)
end
end
return o

