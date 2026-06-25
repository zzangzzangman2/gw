local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={}
for t=3,12 do
table.insert(a,e[t])
end
table.insert(a,e[19])
table.insert(a,0)
t:AddBuff(t,i,o,a)
local i=e[13]
local o=e[14]
local a={}
for o=15,18 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
return nil
end
return n

