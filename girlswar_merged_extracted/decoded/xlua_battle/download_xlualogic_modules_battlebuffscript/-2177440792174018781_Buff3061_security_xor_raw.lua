local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(a,o,e,e,e)
if(a.CurrHeroCtrl.HeroBattleInfo:HasGranOrUnGran(true))then
local t={}
local e=HeroBuffValueInfo:New()
e.buffId=a.buffId
e.attrId=HeroAttrId.criticalResRateAdd
e.value=o[1]
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

