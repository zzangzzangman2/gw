local e={
}
local n=e
function e.DoAction(t,e)
local a=t:JudgeSkillPreView(e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={}
for t=3,5 do
table.insert(a,e[t])
end
for t=14,25 do
table.insert(a,e[t])
end
table.insert(a,0)
t:AddBuff(t,i,o,a)
local i=e[6]
local o=e[7]
local a=0
t:AddBuff(t,i,o,a)
local i=e[8]
local o=e[9]
local a=0
t:AddBuff(t,i,o,a)
local o=e[10]
local a=e[11]
local e={e[12],e[13],a}
t:AddBuff(t,o,a,e)
return nil
end
return n 
