local o={}
local n=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,o,i,n,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.attack then
if(e[1]>=RandomMgr:GetBattleRandom())then
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[2]
a.value=e[3]
o.HeroBattleInfo:AddTempBuffValue(a)
end
if e[9]==0 then
e[9]=1
local o=e[4]
local a=e[5]
local e={e[6],e[7]}
i:AddBuff(t.CurrHeroCtrl,o,a,e)
end
elseif a.buffTriggerTime==BuffTriggerTime.skill3Play
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skillPlay then
e[9]=0
e[10]=0
elseif a.buffTriggerTime==BuffTriggerTime.afterAttacked then
local t=t.CurrHeroCtrl.HeroId
if t==o.HeroId then
local a=n.reduceHpValue
local t=92474
local t=i.HeroBattleInfo:GetBuff(t)
if t then
local t=math.floor(a*e[8]*MillionCoe)
e[10]=e[10]+t
end
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
hpHealth=e[10]
e[10]=0
if hpHealth>0 then
t.CurrHeroCtrl:HpHealthWithBuffImmediately(hpHealth,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.attack
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return n

