local e=require("Modules/Battle/BattleUtil")
local t={
}
local s=t
function t.DoAction(t,a,e)
local o=t:JudgeSkillPreView(a)
local e=e.triggerType
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local i=o[6]
local o=#e
for o=1,o do
local e=e[o]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,i)
end
return nil
end
function t.GetCanTriggerSkill(e)
return false
end
function t.DoPassiveAction(a,e)
local t=a:JudgeSkillPreView(e)
local i=t[1]
local n=t[2]
local e={e.id}
table.insert(e,0)
table.insert(e,0)
for o=3,5 do
table.insert(e,t[o])
end
a:AddBuff(a,i,n,e)
return nil
end
return s 
