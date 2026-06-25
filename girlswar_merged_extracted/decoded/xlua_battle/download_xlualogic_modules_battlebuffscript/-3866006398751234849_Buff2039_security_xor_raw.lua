local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(o,a,t,e)
if(t==nil or e==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
if(e.profession==a[1])then
local e=HeroBuffValueInfo:New()
e.buffId=o.buffId
e.attrId=HeroAttrId.injureRateAdd
e.value=a[2]
t.HeroBattleInfo:AddTempBuffValue(e)
end
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
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return i

