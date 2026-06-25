local e={
}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t)
local a=t[1]
if(a>0)then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.atkRate,a*-1)
end
local t=t[2]
if(t>0)then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.defRate,t*-1)
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
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return o 
