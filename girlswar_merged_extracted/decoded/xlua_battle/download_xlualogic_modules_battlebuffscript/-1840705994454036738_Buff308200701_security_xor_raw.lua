local n=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if ModulesInit.ProcedureNormalBattle.CurrBattleBigRound<t[2]then
return
end
local a=e.CurrHeroCtrl.HeroId
local t=t[1]
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if o==nil then
local o={
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
}
n:AddTriggerAttackTask(a,t,e,o)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

