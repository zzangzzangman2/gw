local s=require("Modules/Battle/BattleUtil")
local i={
}
local r=i
function i.DoAction(t,n,e)
local e=t:JudgeSkillPreView(n)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local h=e[4]
if e[5]==1 then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local a=RandomTableWithSeed(a,1)
local a=a[1]
if a then
local o=a.HeroId
local i=a.BigSkillId
local n={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
costMp=false,
}
local h=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(i,o)
if h==nil then
local e={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
s:AddTriggerAttackTask(o,i,n,e)
end
a:AddFuryWithBuff(e[6])
local i=e[8]
local n=e[9]
local o={}
for t=10,15 do
table.insert(o,e[t])
end
local e=e[7]
a:AddBuff(t,i,n,o,e)
end
end
local e=#o
for e=1,e do
local e=o[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,h)
end
return nil
end
function i.GetCanTriggerSkill(e)
return false
end
function i.DoPassiveAction(e,o)
local a=e:JudgeSkillPreView(o)
local i=a[1]
local n=a[2]
local t={}
table.insert(t,o.id)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
table.insert(t,a[3]*#o)
table.insert(t,0)
e:AddBuff(e,i,n,t)
e.isTriggerAllSkillAttackCompleteBuffForEver=true
return nil
end
return r 
