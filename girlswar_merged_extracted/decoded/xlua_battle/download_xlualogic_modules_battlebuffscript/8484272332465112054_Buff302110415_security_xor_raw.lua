local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneControlBuff(e.buffId)
end
function a.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RefreshImmuneControlBuff()
end
function a.DoAction(e,t,i,a,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
local o=302110405
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local a=o.GetWineFumeBuffData(a)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,a[1],a[2]*t[3])
end
elseif o.buffTriggerTime==BuffTriggerTime.attacked then
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=HeroAttrId.zeroHurt
a.value=t[4]
i.HeroBattleInfo:AddTempBuffValue(a)
elseif o.buffTriggerTime==BuffTriggerTime.attack then
if(t[5]>=RandomMgr:GetBattleRandom())then
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=t[6]
a.value=t[7]
i.HeroBattleInfo:AddTempBuffValue(a)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attacked
or e==BuffTriggerTime.attack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

