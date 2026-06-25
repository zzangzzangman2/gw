local n=require("Modules/Battle/BattleUtil")
local a={}
local r=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddImmunneCtrlBuffId(e.buffId)
end
function a.OnRemoveSelf(e,t)
e.CurrHeroCtrl.HeroBattleInfo:RemoveImmunneCtrlBuffId(e.buffId)
end
function a.DoAction(t,e,h,i,s,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
elseif o.buffTriggerTime==BuffTriggerTime.attack then
local a=false
local o=303111501
local o=i.HeroBattleInfo:GetBuff(o)
if(o)then
a=true
else
local e=303111502
local e=i.HeroBattleInfo:GetBuff(303111502)
if(e)then
a=true
end
end
if a==true then
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[5]
a.value=e[6]
h.HeroBattleInfo:AddTempBuffValue(a)
end
elseif o.buffTriggerTime==BuffTriggerTime.addBuffCheckCtrl then
local a=s[1]
if n:IsStrongCtlBuff(a)then
if e[10]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[10]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[9]=0
end
if e[9]<e[8]then
local a=303111504
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if(t)then
local a=t:GetFloors()
if a>=e[7]then
t:ReduceFloors(e[7])
e[9]=e[9]+1
return{
ret=true,
}
end
end
end
end
return{
ret=false
}
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attack
or e==BuffTriggerTime.addBuffCheckCtrl)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return r

