local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(a,o,t,i)
if(t==nil or i==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local e=HeroBuffValueInfo:New()
e.buffId=a.buffId
e.attrId=HeroAttrId.injureRateAdd
e.value=o[1]
t.HeroBattleInfo:AddTempBuffValue(e)
e=HeroBuffValueInfo:New()
e.buffId=a.buffId
e.attrId=HeroAttrId.injureResRateAdd
e.value=o[2]
t.HeroBattleInfo:AddTempBuffValue(e)
e=HeroBuffValueInfo:New()
e.buffId=a.buffId
e.attrId=HeroAttrId.tureDmgAfterCritical
local a=t.HeroBattleInfo.MaxHP*o[3]*MillionCoe
a=math.min(a,i.HeroBattleInfo.MaxHP*o[4]*MillionCoe)
a=math.floor(a)
e.value=a
t.HeroBattleInfo:AddTempBuffValue(e)
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]+e.buffWeight[3]*t[3]
end
return n

