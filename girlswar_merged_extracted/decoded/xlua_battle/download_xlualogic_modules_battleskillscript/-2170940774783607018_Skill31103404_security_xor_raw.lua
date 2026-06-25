local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local s=e[1]
local n=e[2]
local a={}
for t=3,44 do
table.insert(a,e[t])
end
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local o=e[34]
if#i<=e[35]then
o=e[36]
end
table.insert(a,o)
table.insert(a,0)
t:AddBuff(t,s,n,a)
return nil
end
return n 
