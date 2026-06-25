local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for o=3,10 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
t:AddImmunneBuffId(e[11])
local n=e[12]
local i=e[13]
local a={}
for o=14,26 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local i=e[27]
local n=e[28]
local a={}
for o=29,34 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
local o=e[35]
local i=e[36]
local a={}
for o=37,44 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
return nil
end
return s 
