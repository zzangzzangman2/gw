local n=require("Modules/Battle/Formula")
local s=require("Modules/Battle/BattleUtil")
local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,h,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
elseif a.buffTriggerTime==BuffTriggerTime.addBuff then
if o.buffHeroId==e.CurrHeroCtrl.HeroId then
local a=o.addBuffId
if s:IsCtlBuff(a)then
e.CurrHeroCtrl:AddFuryWithBuff(t[3])
local a=n:GetHeroControlResRate(i)
local a=a.defFinalControlResRate
local a=math.floor(a*t[6])
local o=t[4]
local n=t[5]
local s={HeroAttrId.controlResRateAdd,a}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,n,s)
local o=t[7]
local n=t[8]
local t={HeroAttrId.controlResRateAdd,-a}
i:AddBuff(e.CurrHeroCtrl,o,n,t)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

