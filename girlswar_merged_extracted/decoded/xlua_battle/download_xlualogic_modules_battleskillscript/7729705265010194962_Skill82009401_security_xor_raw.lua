local e=require("Modules/Battle/BattleUtil")
local t={
}
local i=t
function t.DoAction(t,a,e)
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
function t.GetCanTriggerSkill(e)
return false
end
function t.DoPassiveAction(t,a)
local e=t:JudgeSkillPreView(a)
local o=e[1]
local i=e[2]
local e={a.id,e[3],0}
t:AddBuff(t,o,i,e)
return nil
end
return i 
