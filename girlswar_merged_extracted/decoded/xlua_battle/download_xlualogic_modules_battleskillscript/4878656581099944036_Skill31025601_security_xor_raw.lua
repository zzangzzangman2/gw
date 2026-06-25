local e={
}
local o=e
function e.DoAction(a,e)
local t=a:JudgeSkillPreView(e)
local i=t[1]
local o=t[2]
local e={}
for a=3,23 do
table.insert(e,t[a])
end
table.insert(e,{})
table.insert(e,{})
table.insert(e,{})
a:AddBuff(a,i,o,e)
return nil
end
return o

