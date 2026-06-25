local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t)
local a=false
if(e.isAddValue~=nil)then
a=e.isAddValue
end
if(not a)then
e.isAddValue=true
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.injureResRateAdd,t[1])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[2],t[3])
end
e.CurrHeroCtrl:ChangeState(HeroState.Defense)
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.enemyRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return o

