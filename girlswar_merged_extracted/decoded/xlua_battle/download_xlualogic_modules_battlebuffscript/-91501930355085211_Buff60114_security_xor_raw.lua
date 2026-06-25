local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t)
local t=t[1]
if(t>0)then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.injureRateAdd,t)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.realKill)then
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

