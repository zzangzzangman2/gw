local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,e)
end
function e.DoAction(e,t,i,a,o)
local o=o
if(o==1)then
local i=t[1]
local o=t[2]
local e={t[3]}
a:AddBuff(a,i,o,e)
else
local o=t[5]
e.currTimes=e.currTimes==nil and 1 or e.currTimes
if(e.currTimes>o)then
e.currTimes=1
return nil
end
a:AddFuryWithBuff(t[4])
e.currTimes=e.currTimes+1
end
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
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return n

