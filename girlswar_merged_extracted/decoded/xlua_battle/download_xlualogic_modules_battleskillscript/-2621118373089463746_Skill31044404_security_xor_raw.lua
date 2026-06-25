local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local n=e[2]
local a={}
for t=3,6 do
table.insert(a,e[t])
end
for o=27,36 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
local i=e[7]
local n=e[8]
local a={}
for o=9,13 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
t:AddImmunneBuffId(e[14])
local o=e[15]
local a=e[16]
local i={e[3]}
t:AddBuff(t,o,a,i)
local o=e[17]
local i=e[18]
local a={}
for o=19,26 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
return nil
end
return n

