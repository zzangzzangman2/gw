local e=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(i.costMp)
local l=e[1]
local u=e[3]
local o=e[4]
local n=e[5]
local s={e[6],e[7],e[8]}
local h={}
local d=t.HeroBattleInfo:GetBuff(302101511)
local r=#a
for e=1,r do
local e=a[e]
local t=e:CheckAddBuff(u,t,o,n,s)
if t then
if d then
local t=e.HeroBattleInfo:GetBuff(302101501)
if t then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fHollow)
for t=1,#e do
local e=e[t]
h[e.HeroId]=true
end
end
end
end
end
for e=1,r do
local e=a[e]
if h[e.HeroId]then
local a=e.HeroBattleInfo:GetBuff(o)
if a==nil then
e:AddBuff(t,o,n,s)
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,l)
end
return nil
end
return l

