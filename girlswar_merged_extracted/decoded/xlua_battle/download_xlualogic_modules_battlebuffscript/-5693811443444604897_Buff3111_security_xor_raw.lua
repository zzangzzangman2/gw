local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneThorn(e.buffId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RefreshImmuneThorn()
end
function e.DoAction(e,e)
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,t,t)
return e.buffWeight[1]
end
return t

