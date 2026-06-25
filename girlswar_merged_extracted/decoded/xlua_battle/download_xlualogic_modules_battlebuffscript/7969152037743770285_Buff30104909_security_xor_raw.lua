local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:AddHasImmuneDamageBuff()
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl:reduceHasImmuneDamageBuff()
end
function t.GetImmuneDamageCount(t,e)
local t=0
if#e>=4 then
t=e[3]-e[4]
end
return t
end
function t.CheckConsumeOne(t,e)
if e[4]<e[3]then
e[4]=e[4]+1
return true
end
return false
end
function t.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl:AddFuryWithBuff(t[1])
local t=t[2]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
elseif a.buffTriggerTime==BuffTriggerTime.immuneDamageConsume then
if e.CurrHeroCtrl.immuneDamageWithConsume==false then
if t[4]<t[3]then
t[4]=t[4]+1
e.CurrHeroCtrl:SetImmuneDamageWithConsume(true)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.immuneDamageConsume)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

