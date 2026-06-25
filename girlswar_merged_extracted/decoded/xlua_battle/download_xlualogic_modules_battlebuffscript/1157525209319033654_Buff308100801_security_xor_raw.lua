local o=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,i,i,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.IsOurHero==e.CurrHeroCtrl.IsOurHero then
t[3]=t[3]+1
if t[3]>=t[2]then
t[3]=0
local a=e.CurrHeroCtrl.HeroId
local t=t[1]
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if i==nil then
o:AddTriggerAttackTask(a,t,e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
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
function t.HandleOnDoAction(t,e,t)
e[3]=0
return true
end
return i

