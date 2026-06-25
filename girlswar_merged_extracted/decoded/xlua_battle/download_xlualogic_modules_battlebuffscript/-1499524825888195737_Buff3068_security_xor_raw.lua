local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(o,a,t,e,t)
if(e.HeroBattleInfo:HasControlBuff())then
local t={}
local e=HeroBuffValueInfo:New()
e.buffId=o.buffId
e.attrId=HeroAttrId.criticalRateAdd
e.value=a[1]
t[#t+1]=e
return t
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return o

