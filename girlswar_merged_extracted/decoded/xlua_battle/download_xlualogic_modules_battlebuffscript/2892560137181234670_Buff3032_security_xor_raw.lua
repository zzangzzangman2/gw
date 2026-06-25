local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(t,e)
e[3]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
end
function e.OnRemoveSelf(e,e)
end
function e.DoAction(t,e,a,a,a)
if e[3]==nil then
return
end
if(ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-e[3]+1<e[1])then
return
end
local a=t.CurrHeroCtrl.CurrBattleTeam.OpponentTeam:GetAllHerosCount()
if(a>0)then
t.CurrHeroCtrl:AddFuryWithBuff(e[2]*a)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
function e.Dispose(e)
end
return o 
