local e={}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4],e[5],e[6],e[7],e[8],e[9]}
t:AddBuff(t,i,o,a)
local n=e[11]
local i=e[12]
local o={e[13],0}
if ModulesInit.ProcedureNormalBattle.is1v1(t)then
table.insert(a,e[10])
table.insert(o,1)
else
table.insert(a,0)
table.insert(o,0)
end
t:AddBuff(t,n,i,o)
return nil
end
return s

