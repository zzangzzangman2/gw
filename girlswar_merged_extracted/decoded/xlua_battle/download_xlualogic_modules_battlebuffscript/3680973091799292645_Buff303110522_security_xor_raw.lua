local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneSepsisHp(e.buffId,0)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:ReduceImmuneSepsisHp(e.buffId)
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
function e.OnImmuneSepsisHp(e)
local t=303110520
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local e=e:GetBuffData()
e[31]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
end
return true
end
return a

