local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[1]
local i=e[2]
local a={}
for t=3,7 do
table.insert(a,e[t])
end
table.insert(a,e[35])
t:AddBuff(t,o,i,a)
local n=e[8]
local i=e[9]
local a={}
for o=10,27 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local n=e[28]
local i=e[29]
local a={}
for o=30,32 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local i=e[33]
local o=e[34]
local a={}
for o=35,43 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
local i=e[44]
local o=e[45]
local a={}
for o=46,52 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
return nil
end
return n

