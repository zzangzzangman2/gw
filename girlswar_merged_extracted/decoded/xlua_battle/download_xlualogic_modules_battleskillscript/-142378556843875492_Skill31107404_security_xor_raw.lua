local e={
}
local n=e
function e.DoAction(a,e)
local t=a:JudgeSkillPreView(e)
local i=t[1]
local o=t[2]
local e={}
for a=3,13 do
table.insert(e,t[a])
end
for a=20,47 do
table.insert(e,t[a])
end
table.insert(e,{})
table.insert(e,0)
table.insert(e,0)
table.insert(e,0)
table.insert(e,0)
table.insert(e,0)
a:AddBuff(a,i,o,e)
local o=t[14]
local i=t[15]
local e={}
for o=16,19 do
table.insert(e,t[o])
end
a:AddBuff(a,o,i,e)
return nil
end
return n 
