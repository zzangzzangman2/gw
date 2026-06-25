local e=require("Modules/Battle/BattleUtil")
local e={}
local u=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(n.costMp)
local l=e[1]
local o={}
local d={}
local u=e[3]
local o=e[4]
local s=e[5]
local h={e[6],e[7],e[8]}
local r={}
local c=t.HeroBattleInfo:GetBuff(302101511)
local i=#a
for e=1,i do
local e=a[e]
table.insert(d,e)
local t=e:CheckAddBuff(u,t,o,s,h)
if t then
if c then
local t=e.HeroBattleInfo:GetBuff(302101501)
if t then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fHollow)
for t=1,#e do
local e=e[t]
r[e.HeroId]=true
end
end
end
end
end
for e=1,i do
local e=a[e]
if r[e.HeroId]then
local a=e.HeroBattleInfo:GetBuff(o)
if a==nil then
e:AddBuff(t,o,s,h)
end
end
end
local o=e[10]
local s=e[11]
local h={e[12],e[13]}
local e=RandomTableWithSeed(d,e[9])
for a=1,#e do
local e=e[a]
e:AddBuff(t,o,s,h)
end
for e=1,i do
local e=a[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,l)
end
return nil
end
return u

