local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for o=9,15 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local i=e[3]
local o=e[4]
local a={}
for o=5,14 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
return nil
end
return s

