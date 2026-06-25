local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,e)
return e[1]
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.hpHealthWithSkill)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return a

