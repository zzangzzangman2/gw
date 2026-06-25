local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for o=3,8 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local i=e[9]
local o=e[10]
local a={}
for o=11,14 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
return nil
end
return s

