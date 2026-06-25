local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for t=3,6 do
table.insert(a,e[t])
end
for o=17,26 do
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
local a=e[15]
local o=e[16]
local e={e[3]}
t:AddBuff(t,a,o,e)
return nil
end
return s

