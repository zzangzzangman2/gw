local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,h,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local s=t[2]
local n=t[3]
local i={}
if o.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl:AddBuffWithFinalFloor(e.CurrHeroCtrl,s,n,i,t[1])
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t[2])
if a then
local a=a:GetFloors()
if a>0 then
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[4],t[5])
else
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffValueWithId(e.buffId)
end
end
elseif o.buffTriggerTime==BuffTriggerTime.afterAttacked then
local a=e.CurrHeroCtrl.HeroId
if a==h.HeroId then
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t[2])
if a then
local a=a:GetFloors()
a=a-1
if a>0 then
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[4],t[5])
else
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffValueWithId(e.buffId)
end
e.CurrHeroCtrl:AddBuffWithFinalFloor(e.CurrHeroCtrl,s,n,i,a)
end
end
elseif o.buffTriggerTime==BuffTriggerTime.resurgence then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffValueWithId(e.buffId)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.resurgence)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

