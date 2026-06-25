local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,o,t,t,t)
local a={}
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=HeroAttrId.injureRateAdd
t.value=o[1]
a[#a+1]=t
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return a
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
return i

