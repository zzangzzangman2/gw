local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddHasImmuneDamageBuff()
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:reduceHasImmuneDamageBuff()
end
function e.GetImmuneDamageCount(t,e)
local t=0
if#e>=3 then
t=e[2]-e[3]
end
return t
end
function e.CheckConsumeOne(t,e)
if e[3]<e[2]then
e[3]=e[3]+1
return true
end
return false
end
function e.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.immuneDamageConsume then
if e.CurrHeroCtrl.immuneDamageWithConsume==false then
if t[3]<t[2]then
t[3]=t[3]+1
e.CurrHeroCtrl:SetImmuneDamageWithConsume(true)
end
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.immuneDamageConsume)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return o

