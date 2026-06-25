local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,n,o,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[5],t[6])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[7],t[8])
elseif a.buffTriggerTime==BuffTriggerTime.afterAttacked then
if e.CurrHeroCtrl.HeroId==o.HeroId then
local e=i.damageResAddFinalHurt or 0
t[9]=t[9]+e
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

