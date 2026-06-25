local e=require("Modules/Battle/BattleUtil")
local e={}
local w=e
function e.DoAction(t,r)
local e=t:JudgeSkillPreView(r)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(r.costMp)
local f=e[1]
local o={}
local l={}
local c=e[3]
local n=e[4]
local s=e[5]
local u={e[6],e[7],e[8]}
local d={}
local h={}
local m=t.HeroBattleInfo:GetBuff(303101511)
local o=0
local i=#a
for e=1,i do
local e=a[e]
local t=e.HeroBattleInfo:GetBuff(n)
if t then
h[e.HeroId]=true
end
end
for e=1,i do
local e=a[e]
table.insert(l,e)
local t=e:CheckAddBuff(c,t,n,s,u)
if t then
if m then
local t=e.HeroBattleInfo:GetBuff(303101501)
if t then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fHollow)
for t=1,#e do
local e=e[t]
d[e.HeroId]=true
end
end
end
if h[e.HeroId]==true then
o=o+1
end
end
end
for e=1,i do
local e=a[e]
if d[e.HeroId]then
local t=e:AddBuff(t,n,s,u)
if t then
if h[e.HeroId]==true then
o=o+1
end
end
end
end
if o>0 then
local e=303101513
local e=t.HeroBattleInfo:GetBuff(e)
if(e)then
local a=e:GetBuffData()
s=a[10]
local i=t.HeroBattleInfo.MaxHP
local a=math.floor(i*a[10]*o*MillionCoe)
t:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
local s=e[10]
local o=e[11]
local n={e[12],e[13]}
local e=RandomTableWithSeed(l,e[9])
for a=1,#e do
local e=e[a]
e:AddBuff(t,s,o,n)
end
for e=1,i do
local e=a[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,r,f)
end
return nil
end
return w

