local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,n,i,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
elseif a.buffTriggerTime==BuffTriggerTime.attack then
local o=i:CurrHPPer()
if o<t[5]*MillionCoe then
if(t[6]>RandomMgr:GetBattleRandom())then
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=t[7]
a.value=t[8]
e.CurrHeroCtrl.HeroBattleInfo:AddTempBuffValue(a)
end
end
if o<t[9]*MillionCoe then
if(t[10]>RandomMgr:GetBattleRandom())then
local a=i.HeroBattleInfo.MaxHP
local a=a*t[11]*MillionCoe
local o=e.CurrHeroCtrl:GetFinalAtk()
a=math.min(a,o*t[12]*MillionCoe)
a=math.floor(a)
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=HeroAttrId.trueDmg
t.value=a
n.HeroBattleInfo:AddTempBuffValue(t)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

