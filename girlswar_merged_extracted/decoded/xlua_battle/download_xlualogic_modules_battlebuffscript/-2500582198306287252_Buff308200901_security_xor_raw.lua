local i=require("Modules/Battle/BattleUtil")
local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,i,i,a,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.IsOurHero==e.CurrHeroCtrl.IsOurHero then
t[3]=t[3]+1
if t[3]>=t[2]then
t[3]=0
o.AddAttackTask(e)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.allHeroBeanStatCountChange)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddAttackTask(e,t)
local a=e:GetBuffData()
local t=e.CurrHeroCtrl.HeroId
local a=a[1]
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if o==nil then
i:AddTriggerAttackTask(t,a,e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
return o

