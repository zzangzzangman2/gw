local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isOpenAttrFloor=false
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.RefreshAction(e)
local t=e:GetBuffData()
local a=e:GetFloors()
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffValueWithId(e.buffId)
if a>=t[1]then
e.CurrHeroCtrl:AddBuffValue(e.buffId,t[2],t[3])
end
if a>=t[4]then
e.CurrHeroCtrl:AddBuffValue(e.buffId,t[5],t[6])
end
if a>=t[7]then
e.CurrHeroCtrl:AddBuffValue(e.buffId,t[8],t[9])
end
if a>=t[10]then
e.CurrHeroCtrl:AddBuffValue(e.buffId,t[11],t[12])
end
end
return o

