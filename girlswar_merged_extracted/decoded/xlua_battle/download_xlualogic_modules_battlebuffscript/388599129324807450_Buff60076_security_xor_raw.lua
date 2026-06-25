local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t)
local o=e.CurrHeroCtrl:CurrFuryPer()
local a=t[1]*MillionCoe
if(o>a)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local a=1
if(e.CurrHeroCtrl.HeroBattleInfo:GetBuff(60077)~=nil)then
a=2
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
local t=t[2]*MillionCoe*a
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
t=math.floor(t)
if(e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0)then
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Relic,e.releaseHeroId,e.buffId)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
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
return i

