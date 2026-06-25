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
local w=e[1]
local u={}
local c={}
local f=e[3]
local n=e[4]
local h=e[5]
local d={e[6],e[7],e[8]}
local l={}
local s={}
local m=t.HeroBattleInfo:GetBuff(303101511)
local o=0
local i=#a
for e=1,i do
local e=a[e]
local t=e.HeroBattleInfo:GetBuff(n)
if t then
s[e.HeroId]=true
end
end
for e=1,i do
local e=a[e]
table.insert(c,e)
local t=e:CheckAddBuff(f,t,n,h,d)
if t then
if m then
local t=e.HeroBattleInfo:GetBuff(303101501)
if t then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fHollow)
for t=1,#e do
local e=e[t]
l[e.HeroId]=true
end
end
end
if s[e.HeroId]==true then
o=o+1
end
end
end
for e=1,i do
local e=a[e]
if l[e.HeroId]then
local t=e:AddBuff(t,n,h,d)
if t then
if s[e.HeroId]==true then
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
h=a[10]
local i=t.HeroBattleInfo.MaxHP
local a=math.floor(i*a[10]*o*MillionCoe)
t:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
local d=e[10]
local h=e[11]
local s={e[12],e[13]}
local o=RandomTableWithSeed(c,e[9])
for e=1,#o do
local e=o[e]
e:AddBuff(t,d,h,s)
end
local o=e[14]
local h=e[16]
local s=e[17]
local d={e[18],e[19]}
for e=1,i do
local e=a[e]
local t=e.HeroBattleInfo:GetBuff(n)
if t==nil then
table.insert(u,e)
end
end
local e=RandomTableWithSeed(u,e[15])
for a=1,#e do
local e=e[a]
e:CheckAddBuff(o,t,h,s,d)
end
for e=1,i do
local e=a[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,r,w)
end
return nil
end
return w

