local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for o=3,6 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
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
local i=e[17]
local o=e[18]
local a={}
for o=19,26 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
return nil
end
return n

