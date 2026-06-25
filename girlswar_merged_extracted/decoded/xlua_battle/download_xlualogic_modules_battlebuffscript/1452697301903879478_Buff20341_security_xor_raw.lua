local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.OnRemoveSelf(e,t,a)
if(a==BuffRemoveType.Dispel)then
local a=ModulesInit.ProcedureNormalBattle.HeroDic[e.releaseHeroId]
if(a)then
local n=t[1]*MillionCoe
local o=t[2]*MillionCoe
local i=t[3]
local t=e.CurrHeroCtrl.HeroBattleInfo.CurrHP*n
local o=a.HeroBattleInfo.MaxHP*o
t=math.min(t,o)
e.CurrHeroCtrl:RealHurtWithBuff(t,e)
a:AddFuryWithBuff(i)
end
end
end
function e.DoAction(e,e,e,e,e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.removeBuff)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return n

