local a=require("Modules/BattleSkillScript/21088/Skill21088Util")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.IsMusicHero(e.CurrHeroCtrl)then
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle~=true)then
e:PlayBuffPrefabEffect(EBuffEffectType.custom)
end
end
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

