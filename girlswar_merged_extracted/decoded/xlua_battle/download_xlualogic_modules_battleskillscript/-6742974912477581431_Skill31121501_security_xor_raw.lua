local e={
}
local o=e
function e.DoAction(a,e)
local e=a:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local t={}
for a=3,22 do
table.insert(t,e[a])
end
table.insert(t,{})
a:AddBuff(a,i,o,t)
return nil
end
return o

