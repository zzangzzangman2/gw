local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(o,a,t,e)
if(t==nil or e==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local e=HeroBuffValueInfo:New()
e.buffId=o.buffId
e.attrId=HeroAttrId.criticalRateAdd
e.value=a[1]
t.HeroBattleInfo:AddTempBuffValue(e)
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return o

