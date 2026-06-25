local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t)
local o=e.CurrHeroCtrl:CurrHPPer()
local a=t[1]*MillionCoe
if(o>a)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local a=1
if(e.CurrHeroCtrl.HeroBattleInfo:GetBuff(60076)~=nil)then
a=2
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
local t=t[2]*a
if(e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0)then
e.CurrHeroCtrl:AddFuryWithBuff(t)
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

