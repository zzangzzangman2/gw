local e={}
local t=require("DataNode/DataManager/DataMgr/DataUtil")
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(o,i,e,e,e)
local t=o.CurrHeroCtrl.HeroBattleInfo:GetBuff(2030)
if(t and t.floors>0)then
local a={}
local e=HeroBuffValueInfo:New()
e.buffId=o.buffId
e.attrId=HeroAttrId.injureResRateAdd
e.value=i[1]*-1*t.floors
a[#a+1]=e
return a
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
return i

