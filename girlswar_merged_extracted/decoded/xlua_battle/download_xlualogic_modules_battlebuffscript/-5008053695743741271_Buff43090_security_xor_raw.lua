local i=require("Modules/Battle/Formula")
local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,n,s,a,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
if#e>=2 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
end
elseif o.buffTriggerTime==BuffTriggerTime.attack then
if#e>=4 then
if i:GetDefBlock(n)<i:GetDefBlock(s)then
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[3]
a.value=e[4]
n.HeroBattleInfo:AddTempBuffValue(a)
end
end
elseif o.buffTriggerTime==BuffTriggerTime.beBlocked then
if#e>=10 then
local o=e[5]
local a=e[6]
local e={e[7],e[8],e[9],e[10]}
s:AddBuff(t.CurrHeroCtrl,o,a,e)
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.attack or e==BuffTriggerTime.beBlocked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

