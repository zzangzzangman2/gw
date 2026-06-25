local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,o,o)
if(a.HeroBattleInfo:GetBuff(t[1]))then
e.CurrHeroCtrl:CheckAddBuffValue(e.buffId,HeroAttrId.skillTriggerRateAdd,t[2])
end
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.smallSkillAttacked)then
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

