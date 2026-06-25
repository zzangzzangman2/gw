local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(t,e)
t.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHP(e[1])
end
function e.OnRemoveSelf(t,e)
t.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHP(e[1])
end
function e.DoAction(e,t)
local t=t[1]
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.hpAdd,t)
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

