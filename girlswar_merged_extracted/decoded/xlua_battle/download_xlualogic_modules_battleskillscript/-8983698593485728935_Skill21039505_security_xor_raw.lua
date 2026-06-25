local e={
}
local o=e
function e.DoAction(t,e)
local a=t:JudgeSkillPreView(e)
local i=a[1]
local o=a[2]
local e={}
for t=3,23 do
table.insert(e,a[t])
end
table.insert(e,0)
table.insert(e,0)
if ModulesInit.ProcedureNormalBattle.is1v1(t)then
table.insert(e,1)
else
table.insert(e,0)
end
table.insert(e,0)
t:AddBuff(t,i,o,e)
return nil
end
return o

