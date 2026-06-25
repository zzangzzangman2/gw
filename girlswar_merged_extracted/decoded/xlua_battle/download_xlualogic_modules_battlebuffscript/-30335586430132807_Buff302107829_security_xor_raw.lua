local a=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,o,t,t,n)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return nil
end
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.fRandom,1)
local e=e[1]
if e then
local t=e.HeroId
local e=e.BigSkillId
if e>0 then
local o={
triggerSkillAtkType=ETriggerSkillAtkType.AsistAttack,
costMp=false,
ignoreControl=true,
skillHurtRateAdd=o[1],
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if i==nil then
a:AddTriggerAttackTask(t,e,o,n)
end
end
end
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.skillPlay)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.CheckCondition(e,e)
return true
end
return s

