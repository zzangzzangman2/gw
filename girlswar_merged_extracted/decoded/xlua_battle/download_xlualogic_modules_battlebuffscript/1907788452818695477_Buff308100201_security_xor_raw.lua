local a=require("Modules/Battle/BattleUtil")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,i,t,o,n,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if t.IsOurHero==e.CurrHeroCtrl.IsOurHero and t:IsFightPet()then
local o=e.CurrHeroCtrl.HeroId
local t=i[1]
local i={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,o)
if e==nil then
a:AddTriggerAttackTask(o,t,i,n)
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
function t.HandleOnDoAction(t,e)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAll)
local o=#t
local t=a:GetHeroWithProfession(t,e[2])
if#t<o*e[3]*MillionCoe then
return false
end
return true
end
return n

