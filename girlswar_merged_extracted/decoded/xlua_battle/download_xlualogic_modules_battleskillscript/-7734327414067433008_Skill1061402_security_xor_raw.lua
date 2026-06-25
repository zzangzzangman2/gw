local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local a=e[2]
local o={e[3]}
t:AddBuff(t,i,a,o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFront)
for o=1,#a do
local a=a[o]
local o=e[4]
local n=e[5]
local i={e[6],e[7]}
a:AddBuff(t,o,n,i)
local o=e[8]
local i=e[9]
local e={e[10],e[11]}
a:AddBuff(t,o,i,e)
end
local i=e[12]
local o=e[13]
local a={}
for o=14,22 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if#a<=e[23]then
local o=e[24]
local a=e[25]
local e={e[26],e[27]}
t:AddBuff(t,o,a,e)
end
local o=e[28]
local i=e[29]
local a={}
for o=30,43 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
local i=e[44]
local o=e[45]
local a={}
for o=46,49 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
local i=e[50]
local o=e[51]
local a={}
for t=52,59 do
table.insert(a,e[t])
end
for o=1,3 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
return nil
end
return n

