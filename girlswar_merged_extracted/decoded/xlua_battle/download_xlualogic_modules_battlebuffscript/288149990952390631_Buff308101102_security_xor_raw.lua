local h=require("Modules/Battle/BattleUtil")
local t={}
local r=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:AddAbsorptionHeal(e.buffId)
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveAbsorptionHeal(e.buffId)
end
function t.OnOverlap(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local a=e:GetFloors()
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],t[2]*a)
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[3],t[4]*a)
end
function t.DoAction(e,t,o,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.isOpenAttrFloor=false
local a=e:GetFloors()
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],t[2]*a)
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[3],t[4]*a)
elseif a.buffTriggerTime==BuffTriggerTime.normalAttack
or a.buffTriggerTime==BuffTriggerTime.skill2Attack then
if(t[6]>0 and t[6]>=RandomMgr:GetBattleRandom())then
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=t[7]
a.value=t[8]
o.HeroBattleInfo:AddTempBuffValue(a)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.normalAttack
or e==BuffTriggerTime.skill2Attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.ExcuteAbsorptionHeal(e,a)
local t=e:GetBuffData()
local s=e:GetFloors()
local o=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local n=o*t[5]*MillionCoe
local o=t[9]
local i=0
local s=n*s-o
if a<=s then
local s=a+o
local o=math.floor(s/n)
t[9]=s-n*o
i=a
if o>0 then
h:ReduceHeroBuffFloor(e.CurrHeroCtrl,e.buffId,o)
end
else
i=s
t[9]=0
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
end
return i
end
return r

