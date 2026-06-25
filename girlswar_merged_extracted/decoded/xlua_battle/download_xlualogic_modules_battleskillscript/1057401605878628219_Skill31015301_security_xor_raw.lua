local e=require("Modules/Battle/BattleUtil")
local e={}
local c=e
function e.DoAction(e,h)
local t=e:JudgeSkillPreView(h)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
e:ReduceFury(h.costMp)
local u=t[1]
local o={}
local l={}
local c=t[3]
local i=t[4]
local n=t[5]
local d={t[6],t[7],t[8]}
local r={}
local s={}
local m=e.HeroBattleInfo:GetBuff(303101511)
local t=0
local o=#a
for e=1,o do
local e=a[e]
local t=e.HeroBattleInfo:GetBuff(i)
if t then
s[e.HeroId]=true
end
end
for o=1,o do
local a=a[o]
table.insert(l,a)
local e=a:CheckAddBuff(c,e,i,n,d)
if e then
if m then
local e=a.HeroBattleInfo:GetBuff(303101501)
if e then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
for t=1,#e do
local e=e[t]
r[e.HeroId]=true
end
end
end
if s[a.HeroId]==true then
t=t+1
end
end
end
for o=1,o do
local a=a[o]
if r[a.HeroId]then
local e=a:AddBuff(e,i,n,d)
if e then
if s[a.HeroId]==true then
t=t+1
end
end
end
end
if t>0 then
local a=303101513
local a=e.HeroBattleInfo:GetBuff(a)
if(a)then
local o=a:GetBuffData()
n=o[10]
local i=e.HeroBattleInfo.MaxHP
local t=math.floor(i*o[10]*t*MillionCoe)
e:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,a.releaseHeroId,a.buffId)
end
end
for t=1,o do
local t=a[t]
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,h,u)
end
return nil
end
return c

