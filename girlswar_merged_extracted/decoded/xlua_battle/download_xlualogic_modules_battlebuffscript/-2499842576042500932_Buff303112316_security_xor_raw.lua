local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,o,i,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=e.CurrHeroCtrl
if t.buffTriggerTime==BuffTriggerTime.now then
o.HeroBattleInfo:CheckAddBuffValue(e.buffId,a[1],a[2])
elseif t.buffTriggerTime==BuffTriggerTime.attack then
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=a[3]
t.value=-a[4]
i.HeroBattleInfo:AddTempBuffValue(t)
end
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.attack then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

