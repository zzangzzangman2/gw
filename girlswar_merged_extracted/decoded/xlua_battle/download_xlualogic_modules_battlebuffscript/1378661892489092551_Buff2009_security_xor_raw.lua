local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a,t,t,t)
local o=a[1]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=t*o
local o=ModulesInit.ProcedureNormalBattle.HeroDic[e.releaseHeroId]
if(o)then
t=math.min(t,o.HeroBattleInfo.MaxHP*a[2]*MillionCoe)
e.CurrHeroCtrl:RealHurtWithBuff(t,e)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd)then
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

