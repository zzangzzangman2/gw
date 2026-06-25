local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
t.ActiveDamage(e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.ActiveDamage(e)
local t=e:GetBuffData()
local a=e:GetFloors()
e.CurrHeroCtrl:RealHurtWithBuff(t[1]*a,e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle~=true)then
e:PlayBuffPrefabEffect(EBuffEffectType.custom)
end
end
return t

