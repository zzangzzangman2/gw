local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(o,a,t,i)
if(t==nil or i==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local e=HeroBuffValueInfo:New()
e.buffId=o.buffId
e.attrId=HeroAttrId.injureRateAdd
e.value=a[1]
t.HeroBattleInfo:AddTempBuffValue(e)
e=HeroBuffValueInfo:New()
e.buffId=o.buffId
e.attrId=HeroAttrId.injureResRateAdd
e.value=a[2]
t.HeroBattleInfo:AddTempBuffValue(e)
e=HeroBuffValueInfo:New()
e.buffId=o.buffId
e.attrId=HeroAttrId.injureResRateAdd
e.value=a[3]*-1
i.HeroBattleInfo:AddTempBuffValue(e)
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

