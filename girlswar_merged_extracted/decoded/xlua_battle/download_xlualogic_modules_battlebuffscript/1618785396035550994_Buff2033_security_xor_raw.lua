local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t)
local t=t[1]*MillionCoe
e.CurrHeroCtrl:RealHurtWithBuff(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t,e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
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

