local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,o,i,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if(o[1]>=RandomMgr:GetBattleRandom())then
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=HeroAttrId.tureDmgAfterCritical
local t=t.HeroBattleInfo.MaxHP*o[2]*MillionCoe
local e=e.CurrHeroCtrl:GetFinalAtk()
local e=math.floor(e*o[3]*MillionCoe)
t=math.min(t,e)
t=math.floor(t)
a.value=t
i.HeroBattleInfo:AddTempBuffValue(a)
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.critical)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

