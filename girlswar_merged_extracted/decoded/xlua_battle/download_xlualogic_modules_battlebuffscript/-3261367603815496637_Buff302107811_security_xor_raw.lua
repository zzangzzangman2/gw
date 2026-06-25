local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,i,i,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
a.AddHorse(e,t,t[3])
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
a.AddHorse(e,t,t[5])
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddHorse(t,e,a)
local n=e[1]
local i=e[2]
local o=0
local e=e[4]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,n,i,o,a,e)
end
function e.reduceHorseFloor(t,e,a)
local o=e[1]
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if e then
local i=e:GetFloors()
e:ReduceFloors(a)
if i<=a then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
end
end
function e.RemoveAllHorse(t,e)
local e=e[1]
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e,BuffRemoveType.Expire)
end
function e.AddHorseByBigSkill(o,e,t)
if e[6]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[6]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
a.AddHorse(o,e,t)
end
end
function e.GetHorseFloor(e,t)
local t=t[1]
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
local e=0
if t then
e=t:GetFloors()
end
return e
end
function e.IsMaxHorseFloor(o,e)
local t=e[1]
local a=e[4]
local e=o.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
local t=0
if e then
t=e:GetFloors()
end
if t>=a then
return true
end
return false
end
return a

