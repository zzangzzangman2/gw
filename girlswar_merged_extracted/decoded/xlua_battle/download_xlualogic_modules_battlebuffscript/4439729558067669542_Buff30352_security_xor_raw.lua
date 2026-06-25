local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,a)
if(e.CurrHeroCtrl.HeroBattleInfo:HasControlBuff())then
if(t[1]>=RandomMgr:GetBattleRandom())then
e.CurrHeroCtrl.HeroBattleInfo:RemoveControlBuff()
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return a

