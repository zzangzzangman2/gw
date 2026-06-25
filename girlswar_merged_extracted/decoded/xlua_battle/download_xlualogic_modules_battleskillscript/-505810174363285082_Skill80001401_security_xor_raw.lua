local e=require("Modules/Battle/BattleUtil")
local t={
}
local n=t
function t.DoAction(t,a)
local o=t:JudgeSkillPreView(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local i=o[3]
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
function t.DoPassiveAction(e,t)
local a=e:JudgeSkillPreView(t)
local o=a[1]
local a=a[2]
local t={t.id}
e:AddBuff(e,o,a,t)
return nil
end
return n 
