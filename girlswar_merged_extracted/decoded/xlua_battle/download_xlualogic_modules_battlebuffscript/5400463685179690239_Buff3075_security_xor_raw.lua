local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.injureRateAdd,t[1])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.injureResRateAdd,t[2])
end
function t.OnRemoveSelf(e,e)
end
function t.DoAction(e,i,t,t)
local a=i[4]
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(3076)
local o=0
if(t~=nil)then
a=t.buffData[2]
o=t.buffData[1]
end
e.currTimes=e.currTimes==nil and 1 or e.currTimes
if(e.currTimes>a)then
return nil
end
local t=(i[3]+o)*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t)
e.currTimes=e.currTimes+1
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.afterSufferDmg)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]+e.buffWeight[3]*t[3]+e.buffWeight[4]*t[4]
end
return n

