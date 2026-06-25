local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for o=3,11 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local n=e[12]
local i=e[13]
local a={}
for o=14,16 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local o=e[17]
local i=e[18]
local a={}
for o=19,22 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
return nil
end
return n

