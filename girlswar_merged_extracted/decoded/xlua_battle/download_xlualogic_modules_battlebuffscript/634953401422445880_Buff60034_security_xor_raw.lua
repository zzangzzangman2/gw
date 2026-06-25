local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a)
local t=ModulesInit.ProcedureNormalBattle.OurTeam:GetMaxProfessionCount(ProfessionType.Tank)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(t>0)then
local t=a[1]*t
if(t>0)then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.blockRateAdd,t)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return a

