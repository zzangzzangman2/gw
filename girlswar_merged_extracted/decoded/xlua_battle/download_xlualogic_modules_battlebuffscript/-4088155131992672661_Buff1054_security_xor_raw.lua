local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(t,e)
t.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(e[1]*MillionCoe)
end
function e.OnRemoveSelf(t,e)
t.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHPPer(e[1]*MillionCoe)
end
function e.DoAction(e,t)
local t=t[1]
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.hpRate,t)
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
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return a

