local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
local t=t[1]*MillionCoe*e.floors
e.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(t)
end
function e.OnRemoveSelf(e,t)
local t=t[1]*MillionCoe*e.floors
e.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHPPer(t)
end
function e.DoAction(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[2],t[3])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[4],t[5])
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
return a 
