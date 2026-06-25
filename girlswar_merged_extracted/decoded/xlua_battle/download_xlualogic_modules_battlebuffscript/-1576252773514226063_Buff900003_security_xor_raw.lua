local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t,t)
if e.CurrHeroCtrl then
e.CurrHeroCtrl:AddMaxFuryWithSkill()
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return t

