local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[1]
local i=e[2]
local a={e[3],e[4]}
t:AddBuff(t,o,i,a)
local i=e[5]
local a=e[6]
local o={e[7],e[8]}
t:AddBuff(t,i,a,o)
local i=e[9]
local o=e[10]
local a={}
for t=11,19 do
table.insert(a,e[t])
end
table.insert(a,0)
t:AddBuff(t,i,o,a)
return nil
end
return n

