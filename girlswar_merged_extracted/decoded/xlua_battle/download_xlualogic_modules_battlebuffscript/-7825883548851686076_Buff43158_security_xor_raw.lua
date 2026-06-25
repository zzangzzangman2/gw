local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,i,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
elseif a.buffTriggerTime==BuffTriggerTime.attacked then
if(t[5]>=RandomMgr:GetBattleRandom())then
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=t[6]
a.value=t[7]
i.HeroBattleInfo:AddTempBuffValue(a)
local t=43161
local a=1
local i={}
o:AddBuff(e.CurrHeroCtrl,t,a,i)
o:SetThornShowBuffId(t)
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

