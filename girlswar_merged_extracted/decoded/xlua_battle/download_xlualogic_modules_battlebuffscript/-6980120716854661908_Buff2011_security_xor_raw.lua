local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,a)
local a=t[1]*MillionCoe
local t=ModulesInit.ProcedureNormalBattle.HeroDic[e.releaseHeroId]
if(t)then
e.CurrHeroCtrl:RealHurtWithBuff(t:GetFinalAtk()*a,e)
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
return o

