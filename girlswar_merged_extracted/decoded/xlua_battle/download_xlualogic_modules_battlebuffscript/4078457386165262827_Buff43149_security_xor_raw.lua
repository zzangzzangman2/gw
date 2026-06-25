local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,i,n,a,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
elseif o.buffTriggerTime==BuffTriggerTime.critical then
if(e[5]>=RandomMgr:GetBattleRandom())then
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=HeroAttrId.tureDmgAfterCritical
local t=n.HeroBattleInfo.MaxHP*e[6]*MillionCoe
local o=i:GetFinalAtk()
t=math.min(t,o*e[7]*MillionCoe)
t=math.floor(t)
a.value=t
i.HeroBattleInfo:AddTempBuffValue(a)
end
elseif o.buffTriggerTime==BuffTriggerTime.attacked then
local o=e[8]
local n=e[9]
local s=e[10]
local a={}
local e=e[11]
i:CheckAddBuff(o,t.CurrHeroCtrl,n,s,a,e)
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.critical
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

