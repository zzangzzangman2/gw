local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(o,a,e,t,t)
if(e.CurrBattleTeam:GetAllHerosCount()>a[1])then
local t={}
local e=HeroBuffValueInfo:New()
e.buffId=o.buffId
e.attrId=HeroAttrId.injureRateAdd
e.value=a[2]
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
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]
end
return o

