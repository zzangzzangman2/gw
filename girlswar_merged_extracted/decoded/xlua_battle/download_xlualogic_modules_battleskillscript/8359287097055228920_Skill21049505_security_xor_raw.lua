local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for o=3,10 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local n=e[11]
local i=e[12]
local a={}
for o=13,14 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local o=e[15]
local i=e[16]
local a={}
for t=17,29 do
table.insert(a,e[t])
end
table.insert(a,0)
table.insert(a,0)
t:AddBuff(t,o,i,a)
return nil
end
return n

