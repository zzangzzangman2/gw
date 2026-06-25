local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.injureRateAdd,t[1])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.injureResRateAdd,t[2])
end
function e.OnRemoveSelf(e,e)
end
function e.DoAction(e,t,a,i,a)
local o=t[3]
local a=e.CurrHeroCtrl.CurrBattleTeam.OpponentTeam:GetAllHerosCount()
local a=6-a
local t=t[4]*a
local t=(o+t)*MillionCoe
local t=i.HeroBattleInfo.MaxHP*t
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Suit,e.releaseHeroId,e.buffId)
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]+e.buffWeight[3]*t[3]+e.buffWeight[4]*t[4]
end
return a

