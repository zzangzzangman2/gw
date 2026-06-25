local i=require("Modules/Battle/BattleUtil")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,n,o,n)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.IsOurHero~=e.CurrHeroCtrl.IsOurHero then
local a=o.skillId
local a=i:GetSkillActData(a)
if a then
local a=a.costMp
if a>=t[3]then
t[4]=t[4]+1
end
if t[4]>=t[2]then
local a=e.CurrHeroCtrl.HeroId
local t=t[1]
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
}
local n=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if n==nil then
i:AddTriggerAttackTask(a,t,e,o)
end
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.allSkillAttack)then
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

