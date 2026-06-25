local a=require("Modules/BattleSkillScript/21088/Skill21088Util")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t[3]>0 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[3])
else
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
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
function t.ResetAttrValue(t,a)
local e=t:GetBuffData()
e[3]=a
if e[3]>0 then
t.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(t.buffId,e[1],e[3])
end
end
return o

