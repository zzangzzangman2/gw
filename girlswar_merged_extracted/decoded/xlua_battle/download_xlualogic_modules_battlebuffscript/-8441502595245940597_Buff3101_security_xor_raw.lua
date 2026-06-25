local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneDebuff(e.buffId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RefreshImmuneDebuff()
end
function e.DoAction(e,e,e,e)
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
return t

