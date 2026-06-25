local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for t=3,7 do
table.insert(a,e[t])
end
for o=10,11 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local a=e[8]
local e=e[9]
local o={}
t:AddBuff(t,a,e,o)
return nil
end
return s

