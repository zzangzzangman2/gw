local n=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,e,a,a,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
e[3]=e[3]+1
if e[3]>=e[2]then
local a=t.CurrHeroCtrl.HeroId
local e=e[1]
local o={
buffId=t.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,a)
if t==nil then
n:AddTriggerAttackTask(a,e,o,i)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.mateSkillAttack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.HandleOnDoAction(t,e)
if e[3]<e[2]then
return false
end
e[3]=0
return true
end
return s

