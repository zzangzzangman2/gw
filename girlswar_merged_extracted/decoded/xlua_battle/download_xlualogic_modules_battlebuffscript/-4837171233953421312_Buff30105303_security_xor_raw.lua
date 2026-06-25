local i=require("DataNode/DataManager/DataMgr/DataUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,o,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffHeroId==e.CurrHeroCtrl.HeroId then
local t=t.addBuffId
local t=i:GetBuffCfg(t)
if(t.isGran==0)then
e.CurrHeroCtrl:AddFuryWithBuff(a[1])
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

