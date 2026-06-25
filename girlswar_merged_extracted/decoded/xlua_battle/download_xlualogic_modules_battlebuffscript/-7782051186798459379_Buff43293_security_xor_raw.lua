local t={}
local h=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
if e==nil or t==nil then
return
end
end
function t.OnRemoveSelf(e,t)
if e==nil or t==nil then
return
end
end
function t.DoAction(e,t,n,o,s,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.attack then
if t[1]>0 then
if o.HeroId~=e.releaseHeroId then
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=t[1]
a.value=t[2]
n.HeroBattleInfo:AddTempBuffValue(a)
end
end
elseif i.buffTriggerTime==BuffTriggerTime.afterAttacked then
if t[3]>0 then
if n.HeroId~=e.CurrHeroCtrl.HeroId then
return
end
if o.HeroId==e.releaseHeroId then
local t=math.floor(s.reduceHpValue*t[3]*MillionCoe)
if t>0 then
e.CurrHeroCtrl:RealHurtWithBuff(t,e)
end
end
end
end
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.attack
or e==BuffTriggerTime.afterAttacked then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return h

