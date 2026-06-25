local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4]}
t:AddBuff(t,i,o,a)
local i=e[5]
local o=e[6]
local a={e[7],e[8]}
t:AddBuff(t,i,o,a)
local o=e[9]
local i=e[10]
local a={}
for o=11,18 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
local a=e[19]
local o=e[20]
local e={e[21],e[22]}
t:AddBuff(t,a,o,e)
return nil
end
return n

