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
t:AddImmunneBuffId(e[11])
local o=e[12]
local i=e[13]
local a={}
for o=14,26 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
local o=e[27]
local i=e[28]
local a={}
for o=29,34 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
local i=e[35]
local n=e[36]
local a={}
for o=37,44 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if#a==1 or t.battleStationRow==2 then
local i=e[45]
local o=e[46]
local a={}
for t=47,64 do
table.insert(a,e[t])
end
table.insert(a,0)
table.insert(a,0)
table.insert(a,0)
table.insert(a,0)
for o=70,74 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
end
local i=e[65]
local o=e[66]
local a={}
for t=67,69 do
table.insert(a,e[t])
end
table.insert(a,0)
table.insert(a,0)
table.insert(a,0)
t:AddBuff(t,i,o,a)
return nil
end
return n 
