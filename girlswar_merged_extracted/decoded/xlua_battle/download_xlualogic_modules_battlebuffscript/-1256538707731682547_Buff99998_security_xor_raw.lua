local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,e)
end
function e.DoAction(t,a)
local o=#a
for e=1,o,2 do
if e+1<=o then
local o=a[e]
local e=a[e+1]
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,o,e)
end
end
t.isExec=true
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
return i

