local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
if e==nil or e.CurrHeroCtrl==nil or t==nil then
return
end
local t={
buffId=e.buffId,
reduceHpMinHpPercent=0,
reduceHpResRate=t[1],
damageResHeroId=e.CurrHeroCtrl.HeroId
}
e.CurrHeroCtrl:AddDamageResData(t)
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil then
return
end
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
end
function e.DoAction(e,h,o,n,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.afterAttacked then
local t=e.CurrHeroCtrl.HeroId
if t==o.HeroId then
local t=i.reduceHpValue
a.OnAttack(e,t)
end
elseif t.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local n=e.CurrHeroCtrl
local s=n:GetTeamId()
local i=43245
local o=0
local t=0
local r=ModulesInit.ProcedureNormalBattle.GetBattleHeros(n,BattleHeroType.ourAll)
for e=1,#r do
local n=r[e]
local e=n.HeroBattleInfo:GetBuff(i)
if e then
local a,e=a.DoSeedBlossom(e)
if a then
t=t+1
o=o+e
n.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
end
end
if o>0 then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(s,BattleHeroType.enemyAll,nil,nil,true)
if(t)then
for a=1,#t do
local t=t[a]
t:RealHurtWithBuff(o,e)
end
end
end
if t>0 then
local o={}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(s,BattleHeroType.ourAll,nil,nil,true)
for t=1,#a do
local t=a[t]
local e=t.HeroBattleInfo:GetBuff(e.buffId)
if e==nil then
table.insert(o,t)
end
end
local t=RandomTableWithSeed(o,h[6]*t)
for a=1,#t do
local o=i
local i=-1
local e={}
for t=1,6 do
table.insert(e,h[t])
end
table.insert(e,0)
t[a]:AddBuff(n,o,i,e)
end
end
end
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.OnReduceHpRes(e,t)
local o=e:GetBuffData()
return a.OnReduceHpResOnce(e,t)
end
function e.OnReduceHpResOnce(e,t)
local o=e:GetBuffData()
local o=math.floor(t*o[1]*MillionCoe)
return a.AbsorptionDamage(e,t,o)
end
function e.OnAttack(o,t)
local e=o:GetBuffData()
if#e>=6 then
local e=math.floor(t*e[4]*MillionCoe)
return a.AbsorptionDamage(o,t,e)
end
end
function e.AbsorptionDamage(a,o,e)
local t=a:GetBuffData()
local a=math.floor(a.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[2]*MillionCoe)
local a=a-t[7]
if e>=a then
e=a
end
t[7]=t[7]+e
local e=o-e
local e={
isSeparately=true,
realHurtValue=e
}
return e
end
function e.DoSeedBlossom(t)
local e=t:GetBuffData()
local a=math.floor(t.CurrHeroCtrl.HeroBattleInfo.MaxHP*e[2]*MillionCoe)
if e[7]>=a then
t.CurrHeroCtrl.HeroBattleInfo:DispelGranBuff(false,1,false,true)
local a=e[7]*e[3]*MillionCoe
t.CurrHeroCtrl:HpHealthWithDirect(a,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
local a=0
if#e>=6 then
a=e[7]*e[5]*MillionCoe
e[7]=0
t.isExec=true
end
return true,a
end
return false
end
return a

