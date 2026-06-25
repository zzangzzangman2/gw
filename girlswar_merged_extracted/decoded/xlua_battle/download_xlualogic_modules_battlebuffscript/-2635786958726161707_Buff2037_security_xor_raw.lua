local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t)
if(ModulesInit.ProcedureNormalBattle.CurrBattleBigRound==t[1]
or ModulesInit.ProcedureNormalBattle.CurrBattleBigRound==t[2]
or ModulesInit.ProcedureNormalBattle.CurrBattleBigRound==t[3]
)then
e.CurrHeroCtrl:AddFuryWithBuff(t[4])
local t=t[5]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
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
return a

