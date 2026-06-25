local e={}
local o=require("DataNode/DataManager/DataMgr/DataUtil")
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,a,i,i,e)
if(e==nil)then
return
end
if e.buffHeroId==t.CurrHeroCtrl.HeroId then
local e=e.addBuffId
local e=o:GetBuffCfg(e)
if(e.isGran==1)then
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(2030)
if(e)then
e:ReduceFloors(a[1])
end
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return a

