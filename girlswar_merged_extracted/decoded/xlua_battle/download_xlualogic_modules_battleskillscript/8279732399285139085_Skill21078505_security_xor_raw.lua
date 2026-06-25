local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={}
for t=3,6 do
table.insert(a,e[t])
end
table.insert(a,e[10])
t:AddBuff(t,i,o,a)
local a=e[7]
local o=e[8]
local e={e[9]}
t:AddBuff(t,a,o,e)
return nil
end
return n

