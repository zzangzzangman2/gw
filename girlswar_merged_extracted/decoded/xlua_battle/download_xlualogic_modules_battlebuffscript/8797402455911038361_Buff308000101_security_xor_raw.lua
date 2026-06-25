local n=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,a,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if t.IsOurHero==e.CurrHeroCtrl.IsOurHero and t:IsFightPet()then
local a=e.CurrHeroCtrl.HeroId
local t=e.CurrHeroCtrl.PetFightSkillId
local i={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if e==nil then
n:AddTriggerAttackTask(a,t,i,o)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.allPetFightSkillAttack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

