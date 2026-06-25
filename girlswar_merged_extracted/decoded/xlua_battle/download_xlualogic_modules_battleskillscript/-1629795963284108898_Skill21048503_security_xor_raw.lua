local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for o=3,24 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local i=e[7]
local a=e[8]
local o={}
t:AddBuff(t,i,a,o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.selfColumn)
for o=1,#a do
local i=e[9]
local n=e[10]
local e={e[11],e[12]}
a[o]:AddBuff(t,i,n,e)
end
return nil
end
return n

