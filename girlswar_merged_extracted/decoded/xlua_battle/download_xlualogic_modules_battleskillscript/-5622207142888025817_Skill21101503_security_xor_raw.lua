local e={
}
local i=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={}
for o=3,12 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
local n=e[13]
local i=e[14]
local a={}
for t=15,23 do
table.insert(a,e[t])
end
local o=e[24]
local s=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if#s<=e[25]then
o=e[26]
end
table.insert(a,o)
table.insert(a,0)
t:AddBuff(t,n,i,a)
return nil
end
return i

