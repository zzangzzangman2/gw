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
function e.GetDamageCount(e,t)
local e=e:GetBuffData()
if e[2]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[2]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[1]={}
end
local e=e[1]
if e[t]~=nil then
return e[t]
end
return 0
end
function e.AddDamageCount(e,t,a)
local e=e:GetBuffData()
if e[2]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[2]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[1]={}
end
local e=e[1]
if e[t]~=nil then
e[t]=e[t]+a
else
e[t]=a
end
end
return o

