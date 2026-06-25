local a=require("Modules/Battle/BattleUtil")
local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,o,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t[3]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
t[3]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
t[2]=0
end
t[2]=t[2]+1
a:ReduceHeroBuffFloor(e.CurrHeroCtrl,303110331,1)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.skillComplete)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.CheckTriggerBuff(e)
local e=e:GetBuffData()
if e[3]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[3]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[2]=0
end
if e[2]<e[1]then
return true
end
return false
end
return o

