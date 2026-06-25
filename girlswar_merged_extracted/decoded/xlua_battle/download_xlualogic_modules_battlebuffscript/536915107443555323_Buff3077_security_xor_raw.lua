local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.injureRateAdd,t[1])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.injureResRateAdd,t[2])
end
function e.OnRemoveSelf(e,e)
end
function e.DoAction(e,t,a,o,i)
local i=i
if(i==1)then
local n=t[3]
local i=t[4]
local e={t[5]}
a:AddBuff(o,n,i,e)
else
local o=t[7]
e.currTimes=e.currTimes==nil and 1 or e.currTimes
if(e.currTimes>o)then
return nil
end
a:ReduceFuryWithBuff(t[6])
e.currTimes=e.currTimes+1
end
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.beCriticalOrBlocked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]+e.buffWeight[3]*t[3]+e.buffWeight[4]*t[4]+e.buffWeight[5]*t[5]+e.buffWeight[6]*t[6]+e.buffWeight[7]*t[7]
end
return n

