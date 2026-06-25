local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a,o,o,t)
if(t==nil or#t<=0)then
return
end
local t=t[1]
if(t==2028)then
local t=a[1]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.removeBuff)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return o

