local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a,n,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local i=t[1]
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if t then
local a=t:GetFloors()
local o=math.ceil(a/2)
t:ReduceFloors(o)
if a<=o then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
end
elseif i.buffTriggerTime==BuffTriggerTime.beCriticalOrBlocked then
local a=n
if(a==2)then
local a=t[1]
local o=t[2]
local i={t[3],t[4]}
local t=t[5]
e.CurrHeroCtrl:AddBuffWithMaxFloor(e.CurrHeroCtrl,a,o,i,1,t)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.beCriticalOrBlocked or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

