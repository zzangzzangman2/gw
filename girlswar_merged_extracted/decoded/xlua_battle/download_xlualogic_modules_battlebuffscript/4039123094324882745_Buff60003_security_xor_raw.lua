local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(a,t)
local e=ModulesInit.ProcedureNormalBattle.fightWinNumber
if(e>0)then
local o=t[1]
local e=o*e
e=math.max(e,t[2])
a.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(e*MillionCoe)
end
a.isExec=true
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

