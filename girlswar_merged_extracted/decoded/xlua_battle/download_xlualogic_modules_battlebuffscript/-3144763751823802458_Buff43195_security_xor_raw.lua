local n=require("Modules/Battle/BattleUtil")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddImmunneCtrlBuffId(e.buffId)
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl.HeroBattleInfo:RemoveImmunneCtrlBuffId(e.buffId)
end
function t.DoAction(t,e,s,i,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.addBuffCheckCtrl then
local t=o[1]
if n:IsStrongCtlBuff(t)then
if e[5]<e[1]then
e[5]=e[5]+1
return{
ret=true,
remove=true
}
end
end
return{
ret=false
}
elseif a.buffTriggerTime==BuffTriggerTime.attack then
local a=i.HeroBattleInfo:GetGranBuff(true)
local o=#a
o=math.min(o,e[4])
if o>0 then
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[2]
a.value=e[3]*o
t.CurrHeroCtrl.HeroBattleInfo:AddTempBuffValue(a)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.addBuffCheckCtrl
or e==BuffTriggerTime.attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return s

