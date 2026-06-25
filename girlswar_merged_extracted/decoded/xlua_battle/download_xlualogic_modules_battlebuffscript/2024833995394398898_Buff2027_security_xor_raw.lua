local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,e)
end
function e.DoAction(a,t,e,a,a)
e:AddFuryWithBuff(t[1])
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.critical)then
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

