local e=require("Modules/Battle/Formula")
local t=require("DataNode/DataManager/DataMgr/DataUtil")
local o={}
local n=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(e,a,o,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local i=t.GetBattleAttrCoe(HeroAttrId.injure,e.CurrHeroCtrl.HeroBattleInfo.Injure)
local o=t.GetBattleAttrCoe(HeroAttrId.injureRes,e.CurrHeroCtrl.HeroBattleInfo.InjureRes)
if i>o then
local t=(i-o)*a[1]
t=math.max(t,a[2])
t=math.min(t,a[3])
t=math.floor(t)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.injureResRateAdd,t)
else
local t=(o-i)*a[1]
t=math.max(t,a[2])
t=math.min(t,a[3])
t=math.floor(t)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.injureRateAdd,t)
end
e.isExec=true
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return n

