local a=require("Modules/Battle/BattleUtil")
local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoLimitAction(t,a,a,e)
local a=t:GetBuffData()
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle~=true)then
t:PlayBuffPrefabEffect(EBuffEffectType.custom)
end
local e=e.triggerSkillAtkType
if e==nil then
e=ETriggerSkillAtkType.Normal
end
o.AddAttackTaskNormalSkill(t,{triggerSkillAtkType=e})
return true,true
end
function e.AddAttackTaskNormalSkill(e,i)
local t=e:GetBuffData()
local t=e.releaseHeroId
local t=a:GetTargetHeroCtrl(t)
if t then
local o=t.HeroId
local t=t.NormalSkillId
if t>0 then
local e={
defHeroIds={e.CurrHeroCtrl.HeroId},
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local n=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,o)
if n==nil then
a:AddTriggerAttackTask(o,t,e,i)
end
end
end
end
return o

