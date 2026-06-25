local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneAvoidDeath(e.buffId,EBuffTriggerlLevel.Ten)
e.CurrHeroCtrl:AddImmuneResurgence(e.buffId,EBuffTriggerlLevel.Ten)
e.CurrHeroCtrl:AddImmuneLockHp(e.buffId,EBuffTriggerlLevel.Ten)
end
function t.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
e.CurrHeroCtrl:RemoveImmuneAvoidDeath(e.buffId)
e.CurrHeroCtrl:RemoveImmuneResurgence(e.buffId)
e.CurrHeroCtrl:RemoveImmuneLockHp(e.buffId)
end
function t.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.now then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return a

