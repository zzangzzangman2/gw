local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=a[1]*MillionCoe
local t=0
t=a[3]*o
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CompareBuffWeight(a,a,a,e,a,t)
return t[2]>=e[2]
end
return i

