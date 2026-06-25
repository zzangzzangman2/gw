local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnRemoveSelf(e,e)
end
function e.DoAction(e,t,a,a,a)
for a,t in ipairs(t)do
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t.id,t.value)
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
function e.Dispose(e)
end
return a 
