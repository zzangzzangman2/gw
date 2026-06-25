local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneResurgence(e.buffId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveImmuneResurgence(e.buffId)
end
function e.DoAction(e,e,e,e)
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

