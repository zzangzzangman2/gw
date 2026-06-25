local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,a,a)
if e.CurrHeroCtrl then
e.CurrHeroCtrl:CheckAddBuffValue(e.buffId,HeroAttrId.ProfResRateAdd,t[1])
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return a

