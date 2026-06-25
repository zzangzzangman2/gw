local e={}
local t=e
function e.OnAdd(e,t)
e.CurrHeroCtrl.ForbidSmallSkill=true
e.CurrHeroCtrl.FreezeBigSkill=true
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl.ForbidSmallSkill=false
e.CurrHeroCtrl.FreezeBigSkill=false
end
function e.OnOverlap(e,e)
end
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,t,t)
return e.buffWeight[1]
end
return t

