local e=require("Modules/Battle/BattleUtil")
local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetEnemyBuffData(e)
local e=e:GetBuffData()
local e=e[1]
if e.bigRound~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e.bigRound=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e.buffFloors=0
e.triggerCount=0
end
return e
end
return t

