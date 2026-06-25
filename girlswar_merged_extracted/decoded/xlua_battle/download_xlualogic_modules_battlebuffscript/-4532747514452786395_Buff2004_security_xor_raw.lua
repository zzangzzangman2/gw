local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t)
local a=t[1]*MillionCoe
local t=e.atk
e.CurrHeroCtrl:RealHurtWithBuff(t*a,e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function e.SetLogicData(e,t)
e.atk=t:GetFinalAtk()
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return o

