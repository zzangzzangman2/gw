local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a)
local t=ModulesInit.ProcedureNormalBattle.GetFightWinNumber(a[3])
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(t>0)then
local o=a[1]
local t=o*t
t=math.min(t,a[2])
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.atkRate,t)
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

