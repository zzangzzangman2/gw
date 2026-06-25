local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for o=3,5 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local i=e[6]
local o=e[7]
local a={}
for o=8,12 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
end
return s

