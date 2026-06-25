local e=require("Modules/Battle/BattleUtil")
local l=require('Modules/BattleBuffScript/BuffPairTools')
local e={
}
local d=e
function e.DoAction(e,n,t,t)
local a=e:JudgeSkillPreView(n)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
e:ReduceFury(n.costMp)
local d=a[1]
local i=a[3]
local r=a[4]
local s=nil
local t={}
local h=#o
for e=1,h do
local e=o[e]
local a=e.HeroBattleInfo:GetBuff(i)
if a then
s=e
a:SetRound(r)
t={}
break
else
table.insert(t,e)
end
end
if s==nil then
local t=RandomTableWithSeed(t,1)
local o=t[1]
if o then
s=o
local n={a[5],a[6]}
local t=303111210
local t=e.HeroBattleInfo:GetBuff(t)
if(t)then
local t=t:GetBuffData()
for e=5,7 do
table.insert(n,t[e])
end
local a=math.floor(e.HeroBattleInfo.MaxHP*t[8]*MillionCoe)
local e=e:GetFinalAtk()
local e=math.floor(e*t[9]*MillionCoe)
local e=math.min(a,e)
table.insert(n,e)
end
o:AddBuff(e,i,r,n)
local s=303111220
local n=-1
local t=l.GetDefaultHpChainData()
t.assumedamagePercent=a[7]
t.reduceDamagePercent=0
t.minHpPercent=0
t.defHeroId=o.HeroId
t.defBuffId=i
local t={t}
e:AddBuff(e,s,n,t)
end
end
for t=1,h do
local t=o[t]
local a=0
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,n,d,0,a)
end
return nil
end
return d 
