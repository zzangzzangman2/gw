local e={
}
local h=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[1]
local i=e[2]
local a={}
for t=3,21 do
table.insert(a,e[t])
end
table.insert(a,e[30])
table.insert(a,0)
local n=t.HeroBattleInfo.MaxHP
local n=math.floor(n*e[15]*MillionCoe)
table.insert(a,n)
t:AddBuff(t,o,i,a)
local i=e[22]
local n=e[23]
local a={}
for o=24,29 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
local o=e[31]
local n=e[32]
local a={}
for t=33,60 do
table.insert(a,e[t])
end
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local s=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if#i==1 and#s==1 then
table.insert(a,e[62])
else
table.insert(a,e[61])
end
table.insert(a,0)
table.insert(a,e[63])
t:AddBuff(t,o,n,a)
local a=e[64]
local e=e[65]
local o=0
t:AddBuff(t,a,e,o)
t:ShowRageBar(true)
return nil
end
return h 
