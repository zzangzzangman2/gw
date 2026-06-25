local e={}
local o=e
function e.DoAction(a,e)
local e=a:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local t={e[3],e[4],e[5],e[6],e[7],e[8],e[9]}
a:AddBuff(a,i,o,t)
local o=e[10]
local i=e[11]
local t={e[12],e[13]}
if a.BigSkillId==e[14]then
table.insert(t,e[15])
table.insert(t,e[16])
table.insert(t,e[17])
elseif a.BigSkillId==e[18]then
table.insert(t,e[19])
table.insert(t,e[20])
table.insert(t,e[21])
elseif a.BigSkillId==e[22]then
table.insert(t,e[23])
table.insert(t,e[24])
table.insert(t,e[25])
end
a:AddBuff(a,o,i,t)
end
return o

