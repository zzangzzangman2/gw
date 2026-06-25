local e={
}
local o=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={}
for o=3,10 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
end
return o

