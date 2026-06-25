local e={}
local o=e
function e.GetCanAdd(t,e)
if(e:IsImmuneBuff(2043))then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return false
end
return true
end
function e.DoAction(e,t)
local a=t[1]
local t=t[2]
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.eXSkillINjureRateAdd,a*-1)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.injureResRateAdd,t*-1)
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
return o

