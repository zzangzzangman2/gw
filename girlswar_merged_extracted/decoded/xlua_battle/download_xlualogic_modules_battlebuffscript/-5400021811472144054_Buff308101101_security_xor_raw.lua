local a=require("Modules/Battle/BattleUtil")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,o,o,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.IsBigRoundStart(t.buffTriggerTime,e.CurrHeroCtrl)then
local t=e.CurrHeroCtrl.HeroId
local o=e.CurrHeroCtrl.PetFightSkillId
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(o,t)
if i==nil then
a:AddTriggerAttackTask(t,o,e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.enemyRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n 
