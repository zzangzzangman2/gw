local i=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(t,e,n)
local e=t:JudgeSkillPreView(e)
local e=t
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
if#a>0 then
if n.isSmall==true then
local t=RandomTableWithSeed(a,1)
e=t[1]
else
e=i:FindMostBigAtk(a)
end
end
local o=false
local a=303111114
local t=t.HeroBattleInfo:GetBuff(a)
if(t)then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.DoBeansActionSmallSkill(t,e)
o=true
end
local a=e.HeroId
local t=e.BigSkillId
if n.isSmall==true then
t=e.SmallSkillId
end
if t>0 then
local e={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
disableAttackFuryhealth=true,
disableDefFuryhealth=o,
costMp=false,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if o==nil then
i:AddTriggerAttackTask(a,t,e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
return nil
end
return s 
