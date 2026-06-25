local e={}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[1]
local i=e[2]
local o={e[3],e[4]}
t:AddBuff(t,a,i,o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHerosByHeroModelId(t,BattleHeroType.ourAll,e[5])
local i=e[6]
local n=e[7]
local o={e[8],e[9]}
if a then
for e=1,#a do
a[e]:AddBuff(t,i,n,o)
end
end
local a=e[10]
local o=e[11]
local i={e[12],e[13],t.rankLevel,0,0}
t:AddBuff(t,a,o,i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHerosByHeroModelId(t,BattleHeroType.all,e[14])
if#a>0 then
t:ResetFuryWithBuff(e[15])
end
t:AddImmunneBuffId(e[16])
t:AddImmunneBuffId(e[17])
local a=e[18]
local o=e[19]
local e={e[20],e[21],e[22]}
t:AddBuff(t,a,o,e)
end
return n

