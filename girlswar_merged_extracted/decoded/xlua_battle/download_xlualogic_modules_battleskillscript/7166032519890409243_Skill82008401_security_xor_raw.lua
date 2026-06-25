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
function t.DoPassiveAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=t[1]
local i=t[2]
local t={a.id,t[3],0}
table.insert(t,0)
table.insert(t,0)
e:AddBuff(e,o,i,t)
e.isTriggerAllSkillAttackCompleteBuffForEver=true
return nil
end
return i 
