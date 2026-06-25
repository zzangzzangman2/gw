local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t)
local a=t[1]
local t=t[2]
if(a>0)then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.atkAdd,a)
end
if(t>0)then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.defAdd,t)
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
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]
end
return o

