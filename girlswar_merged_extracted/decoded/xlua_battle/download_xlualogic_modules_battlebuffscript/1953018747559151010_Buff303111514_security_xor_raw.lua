local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddForceRestraintType(e.buffId,EForceRestraintType.Restraint,true,true)
end
function e.OnRemoveSelf(e,t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
e.CurrHeroCtrl:RemoveForceRestraintType(e.buffId)
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
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
return a

