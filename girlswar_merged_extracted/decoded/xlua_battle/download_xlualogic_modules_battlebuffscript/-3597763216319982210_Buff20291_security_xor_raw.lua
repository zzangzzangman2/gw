local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,e,i,o,t)
local a=e[1]
local t=e[2]
local e={e[3],e[4]}
i:AddBuff(o,a,t,e)
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.beCriticalOrBlocked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return n

