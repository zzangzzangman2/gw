local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(a,o,e,t)
if(e==nil or t==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
if(e.profession==ProfessionType.Warrior)then
local t={}
local e=HeroBuffValueInfo:New()
e.buffId=a.buffId
e.attrId=HeroAttrId.injureResRateAdd
e.value=o[1]
t[#t+1]=e
return t
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
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

