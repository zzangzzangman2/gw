local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=e.CurrHeroCtrl.CurrBattleTeam:GetAllHerosCountInBattle()
local t=e.CurrHeroCtrl.CurrBattleTeam:GetAllEnemyHerosCountInBattle()
local a=a+t
local t=e.CurrHeroCtrl:GetFinalAtk()
local a=math.floor(t*o[1]*a*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.fHollow)
local o=a*o[2]*MillionCoe
for a=1,#t do
local t=t[a]
t:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

