local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnRemoveSelf(e,e)
end
function e.DoAction(e,t,a,a)
if e.CurrHeroCtrl then
e.CurrHeroCtrl:CheckAddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl:CheckAddBuffValue(e.buffId,t[3],t[4])
end
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return a

