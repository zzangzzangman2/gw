local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[5],t[6])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[7],t[8])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[9],t[10])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[11],t[12])
o.GainTaskHalo(e,t[13])
end
elseif a.buffTriggerTime==BuffTriggerTime.resurgence then
o.GainTaskHalo(e,t[13])
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
o.GainTaskHalo(e,t[20])
end
elseif a.buffTriggerTime==BuffTriggerTime.critical then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
o.GainTaskHalo(e,t[21])
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.resurgence
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.critical)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GainTaskHalo(t,o)
local e=t:GetBuffData()
local a=e[14]
local i=e[15]
local n={e[16],e[17],e[18],e[19]}
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
e:AddFloors(o)
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.ResetTaskHalo(e)
else
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,i,n,o)
end
end
function a.GainTeamTaskHalo(t,i,o)
local e=t:GetBuffData()
local a=e[14]
local n=e[15]
local o=math.floor(e[19]*o)
local e={e[16],e[17],e[18],o}
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
t.CurrHeroCtrl:AddTeamBuff(t.CurrHeroCtrl,a,n,e,i)
end
function a.reduceTaskHaloFloor(a,o)
local e=a:GetBuffData()
local t=e[14]
local e=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local i=e:GetFloors()
e:ReduceFloors(o)
if i<=o then
a.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
else
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.ResetTaskHalo(e)
end
end
end
function a.GetTaskHaloFloor(e)
local t=e:GetBuffData()
local t=t[14]
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
local t=0
if e then
t=e:GetFloors()
end
return t
end
return o

