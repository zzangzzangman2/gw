local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,a)
local t=e:GetFloors()
e.CurrHeroCtrl:AddFuryWithBuff(a[3]*t)
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
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

