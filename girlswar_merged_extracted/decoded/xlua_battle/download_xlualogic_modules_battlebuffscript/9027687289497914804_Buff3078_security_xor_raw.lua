local e={}
local i=e
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
local o=t[1]
local e=t[2]
local t={t[3]}
i:AddBuff(a,o,e,t)
else
local o=t[5]
e.currTimes=e.currTimes==nil and 1 or e.currTimes
if(e.currTimes>o)then
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
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]+e.buffWeight[3]*t[3]+e.buffWeight[4]*t[4]+e.buffWeight[5]*t[5]+e.buffWeight[6]*t[6]+e.buffWeight[7]*t[7]
end
return i

