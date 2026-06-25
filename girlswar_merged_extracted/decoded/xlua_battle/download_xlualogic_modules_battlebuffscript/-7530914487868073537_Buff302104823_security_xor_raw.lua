local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddHasImmuneDamageBuff()
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
e.CurrHeroCtrl:reduceHasImmuneDamageBuff()
e.CurrHeroCtrl:SetHeroMustDie()
end
function e.GetImmuneDamageCount(e,e)
return 1
end
function e.CheckConsumeOne(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl:SetImmuneDamageWithConsume(true)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.immuneDamageConsume)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return t

