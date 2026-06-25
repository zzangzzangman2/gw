local i=require("Modules/Battle/BattleUtil")
local a={
}
local s=a
function a.DoAction(t,o,e)
local a=t:JudgeSkillPreView(o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local n=a[4]
if a[5]==1 then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local e=RandomTableWithSeed(e,1)
local e=e[1]
if e then
local t=e.HeroId
local e=e.BigSkillId
local o={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
costMp=false,
}
local a=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if a==nil then
local a={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
i:AddTriggerAttackTask(t,e,o,a)
end
end
end
local a=#e
for a=1,a do
local e=e[a]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,n)
end
return nil
end
function a.GetCanTriggerSkill(e)
return false
end
function a.DoPassiveAction(e,o)
local a=e:JudgeSkillPreView(o)
local n=a[1]
local i=a[2]
local t={}
table.insert(t,o.id)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
table.insert(t,a[3]*#o)
table.insert(t,0)
e:AddBuff(e,n,i,t)
e.isTriggerAllSkillAttackCompleteBuffForEver=true
return nil
end
return s 
