local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,e)
end
function a.OnRemoveSelf(e,e)
end
function a.DoAction(t,e,a,i,a,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.attack then
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[5]
a.value=e[6]
i.HeroBattleInfo:AddTempBuffValue(a)
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[7]
a.value=e[8]
i.HeroBattleInfo:AddTempBuffValue(a)
elseif o.buffTriggerTime==BuffTriggerTime.now then
if#e>=2 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
end
if#e>=4 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attack or e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

