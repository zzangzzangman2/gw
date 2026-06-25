local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
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
function e.CheckConditionExcute(t)
local e=t:GetBuffData()
if e[4]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[4]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[3]=0
end
if e[3]<e[2]then
local a=303111504
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if(t)then
local a=t:GetFloors()
if a>=e[1]then
t:ReduceFloors(e[1])
e[3]=e[3]+1
return true
end
end
end
return false
end
return o

