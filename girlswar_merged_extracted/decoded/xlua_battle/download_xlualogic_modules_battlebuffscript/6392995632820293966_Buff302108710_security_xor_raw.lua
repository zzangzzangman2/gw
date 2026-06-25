local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,a)
local t=e:GetFloors()
e.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHPPer(a[1]*t*MillionCoe)
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return o

