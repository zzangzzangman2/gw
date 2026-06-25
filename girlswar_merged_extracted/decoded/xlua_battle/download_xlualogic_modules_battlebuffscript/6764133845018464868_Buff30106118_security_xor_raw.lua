local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.OnRemoveSelf(e,e)
end
function e.DoAction(t,e,a,a,a)
local i=e[1]
local n=e[2]
local a={}
for o=3,8 do
table.insert(a,e[o])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,n,a)
local a=e[9]
local o=e[10]
local e={e[11]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.resurgence)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
function e.Dispose(e)
end
return s

