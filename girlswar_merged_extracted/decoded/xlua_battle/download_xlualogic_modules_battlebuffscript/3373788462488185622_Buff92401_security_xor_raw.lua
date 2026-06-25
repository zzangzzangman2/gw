local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneSepsisHp(e.buffId,900191401)
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
e.CurrHeroCtrl:ReduceImmuneSepsisHp(e.buffId)
end
function e.DoAction(e,t,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.OnImmuneSepsisHp(t)
local e=92400
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e)
if e then
local e=e:GetBuffData()
e[8]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
end
return true
end
return a

