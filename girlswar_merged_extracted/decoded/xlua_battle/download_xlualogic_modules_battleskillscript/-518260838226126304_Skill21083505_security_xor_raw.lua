local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for t=3,10 do
table.insert(a,e[t])
end
for o=21,28 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local o=e[11]
local i=e[12]
local a={}
for o=13,20 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
return nil
end
return s

