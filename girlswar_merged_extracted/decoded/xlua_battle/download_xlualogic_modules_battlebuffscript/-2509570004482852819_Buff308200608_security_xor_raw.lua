local n=require("DataNode/DataManager/DataMgr/DataUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,i,i,a,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,o[1],o[2])
elseif t.buffTriggerTime==BuffTriggerTime.addBuff then
if a.teamId~=e.CurrHeroCtrl:GetTeamId()then
local t=a.addBuffId
local t=n:GetBuffCfg(t)
if t.isGran==0 then
e:AddFloors(1)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

