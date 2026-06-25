local e=require("Modules/Battle/BattleUtil")
local e={}
local m=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local c=e[1]
local l={}
local d={}
local u=e[3]
local i=e[4]
local s=e[5]
local r={e[6],e[7],e[8]}
local h={}
local m=t.HeroBattleInfo:GetBuff(302101511)
local n=#a
for e=1,n do
local e=a[e]
table.insert(d,e)
local t=e:CheckAddBuff(u,t,i,s,r)
if t then
if m then
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
for e=1,n do
local e=a[e]
if h[e.HeroId]then
local a=e.HeroBattleInfo:GetBuff(i)
if a==nil then
e:AddBuff(t,i,s,r)
end
end
end
local r=e[10]
local h=e[11]
local s={e[12],e[13]}
local i=RandomTableWithSeed(d,e[9])
for e=1,#i do
local e=i[e]
e:AddBuff(t,r,h,s)
end
local i=e[14]
local h=e[16]
local s=e[17]
local r={e[18],e[19]}
local e=RandomTableWithSeed(l,e[15])
for a=1,#e do
local e=e[a]
e:CheckAddBuff(i,t,h,s,r)
end
for e=1,n do
local e=a[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,c)
end
return nil
end
return m

