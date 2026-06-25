local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
if t[1]>0 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if t[1]>0 then
if ModulesInit.ProcedureNormalBattle.CurrBattleBigRound>e.CurrHeroCtrl.appearBattleBigRound then
local a=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-e.CurrHeroCtrl.appearBattleBigRound
local a=math.max(t[2]-t[3]*a,t[4])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],a)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

