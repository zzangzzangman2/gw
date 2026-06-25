local e={
}
local h=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
local s=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local o=e[3]
if#s>=e[4]then
o=e[5]
end
table.insert(a,o)
for t=6,8 do
table.insert(a,e[t])
end
table.insert(a,o)
table.insert(a,0)
t:AddBuff(t,n,i,a)
local o=e[9]
local i=e[10]
local a={}
for o=11,14 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
return nil
end
return h

