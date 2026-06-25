local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t)
local o=t[1]*MillionCoe
local a=t[3]*MillionCoe
if(e.CurrHeroCtrl:CurrHPPer()<o and e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0)then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.healRateAdd,t[2])
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Suit,e.releaseHeroId,e.buffId)
e.isExec=true
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.hpDown)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]+e.buffWeight[3]*t[3]
end
return o

