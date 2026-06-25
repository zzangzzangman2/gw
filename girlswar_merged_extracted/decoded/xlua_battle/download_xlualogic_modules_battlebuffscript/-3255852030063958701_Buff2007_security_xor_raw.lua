local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(o,a,t,e)
if(t==nil or e==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local t={}
local e=HeroBuffValueInfo:New()
e.buffId=o.buffId
e.attrId=HeroAttrId.criticalResRateAdd
e.value=a[1]*-1
t[#t+1]=e
e=HeroBuffValueInfo:New()
e.buffId=o.buffId
e.attrId=HeroAttrId.blockRateAdd
e.value=a[2]*-1
t[#t+1]=e
return t
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return i

