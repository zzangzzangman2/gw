local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a)
local t=ModulesInit.ProcedureNormalBattle.fightWinNumber
if(t>0)then
local o=a[1]
local t=o*t
t=math.max(t,a[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.defAdd,t)
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
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return i

