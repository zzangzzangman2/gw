local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for o=3,16 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local i=e[17]
local o=e[18]
local a={}
for t=19,24 do
table.insert(a,e[t])
end
table.insert(a,0)
t:AddBuff(t,i,o,a)
return nil
end
return s

