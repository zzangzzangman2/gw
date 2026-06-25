local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=2 then
local t=t[1]*MillionCoe*t[2]
e.CurrHeroCtrl:ReduceFuryWithSkillImmediately(t,ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId),EBattleSrcType.Buff,false)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return a

