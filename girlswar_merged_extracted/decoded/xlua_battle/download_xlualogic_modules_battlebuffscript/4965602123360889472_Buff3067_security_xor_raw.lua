local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(o,a,t,e,i)
if(e:CurrHPPer()>t:CurrHPPer())then
local t={}
local e=HeroBuffValueInfo:New()
e.buffId=o.buffId
e.attrId=HeroAttrId.injureResRateAdd
e.value=a[1]
t[#t+1]=e
return t
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return i

