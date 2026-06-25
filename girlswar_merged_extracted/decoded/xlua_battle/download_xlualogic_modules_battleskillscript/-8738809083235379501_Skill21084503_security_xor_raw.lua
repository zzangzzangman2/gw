local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for o=3,22 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local i=e[23]
local o=e[24]
local a={}
for o=25,32 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
return nil
end
return s

