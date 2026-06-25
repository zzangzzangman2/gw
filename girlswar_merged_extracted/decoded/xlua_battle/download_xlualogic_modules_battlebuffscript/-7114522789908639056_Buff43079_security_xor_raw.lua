local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,e,e,e)
return nil
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]
end
return a

