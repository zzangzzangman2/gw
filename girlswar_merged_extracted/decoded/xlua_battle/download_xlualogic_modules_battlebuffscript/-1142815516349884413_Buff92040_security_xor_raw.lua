local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(t,e)
t.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(e[1]*MillionCoe)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHPPer(t[1]*MillionCoe)
end
function e.DoAction(e,t,t,t)
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
return a

