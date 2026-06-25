local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[1]
local n=e[2]
local a={}
for t=3,15 do
table.insert(a,e[t])
end
table.insert(a,math.floor(t.HeroBattleInfo.MaxHP*e[5]*MillionCoe))
table.insert(a,0)
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
local i=e[3]+#i*e[4]
table.insert(a,i)
t:AddBuff(t,o,n,a)
if t:IsRealFirstRowHero()then
local o=e[16]
local i=e[17]
local a={}
for o=18,22 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
end
return nil
end
return n

