local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
table.insert(a,e[3])
for o=8,13 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local i=e[4]
local o=e[5]
local a={}
for o=6,7 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
return nil
end
return s

