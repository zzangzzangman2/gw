local e={}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[1]
local i=e[2]
local o={e[3],e[4],e[5],e[6],e[7],e[8],e[9]}
t:AddBuff(t,a,i,o)
local i=e[10]
local o=e[11]
local a={e[12],e[13]}
if t.BigSkillId==e[14]then
table.insert(a,e[15])
table.insert(a,e[16])
table.insert(a,e[17])
elseif t.BigSkillId==e[18]then
table.insert(a,e[19])
table.insert(a,e[20])
table.insert(a,e[21])
elseif t.BigSkillId==e[22]then
table.insert(a,e[23])
table.insert(a,e[24])
table.insert(a,e[25])
end
t:AddBuff(t,i,o,a)
if ModulesInit.ProcedureNormalBattle.IsEveryTeamHasOneHero()then
if t.rankLevel>=e[26]then
local o=e[27]
local a=e[28]
local e={e[29],e[30]}
t:AddBuff(t,o,a,e)
end
local a=e[31]
local o=e[32]
local e={e[33]}
t:AddBuff(t,a,o,e)
end
local a=e[34]
local o=e[35]
local e={e[36]}
t:AddBuff(t,a,o,e)
end
return n

