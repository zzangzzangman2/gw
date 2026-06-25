local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,a)
local t=t[1]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Suit,e.releaseHeroId,e.buffId)
e.PrevRound=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e.isExec=true
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.beCritical)then
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

