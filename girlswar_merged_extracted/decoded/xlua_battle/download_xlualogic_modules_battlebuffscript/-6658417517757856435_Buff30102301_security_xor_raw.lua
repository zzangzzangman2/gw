local e=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.CurrBattleTeam==nil or e.CurrHeroCtrl.CurrBattleTeam.OpponentTeam==nil then
return
end
local t=e.CurrHeroCtrl.CurrBattleTeam.OpponentTeam:GetFrontOrBackHeros(false)
for o=1,#t do
local t=t[o]
t:ReduceFuryWithSkillImmediately(a[1],ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId),EBattleSrcType.Buff,false)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return a

