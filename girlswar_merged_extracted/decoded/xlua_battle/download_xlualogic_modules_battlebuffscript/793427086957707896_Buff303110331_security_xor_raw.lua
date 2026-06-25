local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneDebuff(e.buffId)
e.CurrHeroCtrl:AddImmuneDamage(e.buffId)
e.CurrHeroCtrl:AddImmuneReduceFury(e.buffId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RefreshImmuneDebuff()
e.CurrHeroCtrl:RefreshImmuneDamage()
e.CurrHeroCtrl:RefreshImmuneReduceFury()
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return t

