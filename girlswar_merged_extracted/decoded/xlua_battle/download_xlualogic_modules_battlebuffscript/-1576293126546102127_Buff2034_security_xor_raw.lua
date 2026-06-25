local e={}
local s=e
function e.OnAdd(e,t)
e.CurrHeroCtrl.ForbidSmallSkill=true
e.CurrHeroCtrl.ForbidCritical=true
end
function e.OnRemoveSelf(e,t,a)
e.CurrHeroCtrl.ForbidSmallSkill=false
e.CurrHeroCtrl.ForbidCritical=false
if(a==BuffRemoveType.Dispel and type(t)=="table")then
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
function e.GetCanAdd(t,e)
if(e:IsImmuneBuff(2034))then
return false
end
return true
end
function e.DoAction(e,e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return s

