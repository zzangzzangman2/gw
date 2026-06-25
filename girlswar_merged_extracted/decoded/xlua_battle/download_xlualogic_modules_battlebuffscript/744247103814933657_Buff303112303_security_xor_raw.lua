local n=require("Modules/Battle/BattleUtil")
local e={}
local o=e
local i=31123
local a=31111
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,i,s,n,t,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local t=e.CurrHeroCtrl
local e=e.buffId
if a.buffTriggerTime==BuffTriggerTime.teamHeroDead then
if s~=nil and o.IsLiuBangOrXiangYuHeroDid(n.heroDid)then
if o.ShouldRemoveHeBingFromCarrier(t)then
t.HeroBattleInfo:RemoveBuffWithId(e,BuffRemoveType.Expire)
end
end
return
elseif a.buffTriggerTime==BuffTriggerTime.HeroDead then
t.HeroBattleInfo:RemoveBuffWithId(e,BuffRemoveType.Expire)
return
end
if t.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.HeroBattleInfo:CheckAddBuffValue(e,i[1],i[2])
end
end
function e.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.teamHeroDead
or e==BuffTriggerTime.HeroDead then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.IsLiuBangOrXiangYuHeroDid(e)
return e==i or e==a
end
function e.ShouldRemoveHeBingFromCarrier(e)
if e.heroDid==i then
if n.HasOnFieldHeroDid(e,BattleHeroType.ourAll,a)then
return false
end
return true
elseif e.heroDid==a then
if n.HasOnFieldHeroDid(e,BattleHeroType.ourAll,i)then
return false
end
return true
end
return false
end
return o

