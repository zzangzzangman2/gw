local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a)
local t=ModulesInit.ProcedureNormalBattle.OurTeam:GetMaxProfessionCount(ProfessionType.Mage)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(t>0)then
local a=a[1]
local t=a*t
if(t>0)then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.eXSkillINjureRateAdd,t)
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
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return o

