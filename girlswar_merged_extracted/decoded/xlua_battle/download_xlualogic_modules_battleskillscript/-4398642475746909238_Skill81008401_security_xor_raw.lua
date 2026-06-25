local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(t,a,e)
local o=t:JudgeSkillPreView(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local i=o[4]
local o=#e
for o=1,o do
local e=e[o]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,i)
end
return nil
end
function e.GetCanTriggerSkill(e)
if e==BuffTriggerTime.battleBeginPetHelpSkill then
return true
end
return false
end
function e.DoPassiveAction(t,o)
local a=t:JudgeSkillPreView(o)
local i=a[1]
local n=a[2]
local e={}
table.insert(e,o.id)
table.insert(e,a[3])
table.insert(e,0)
t:AddBuff(t,i,n,e)
return nil
end
return s 
