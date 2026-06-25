local n=require("Modules/Battle/BattleUtil")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,o,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.HeroId~=e.CurrHeroCtrl.HeroId and a.IsOurHero==e.CurrHeroCtrl.IsOurHero then
t[4]=t[4]+1
if t[4]>=t[2]then
local a=e.CurrHeroCtrl.HeroId
local o=t[1]
local t={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
skillHurtRate=t[3]
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(o,a)
if e==nil then
n:AddTriggerAttackTask(a,o,t,i)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.allNormalSkilAttack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.HandleOnDoAction(t,e)
if e[4]<e[2]then
return false
end
e[4]=0
return true
end
return s

