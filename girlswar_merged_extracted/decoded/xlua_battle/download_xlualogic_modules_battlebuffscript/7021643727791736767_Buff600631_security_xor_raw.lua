local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t)
local t=t[1]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
t=math.floor(t)
if(e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0)then
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Relic,e.releaseHeroId,e.buffId)
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return a

