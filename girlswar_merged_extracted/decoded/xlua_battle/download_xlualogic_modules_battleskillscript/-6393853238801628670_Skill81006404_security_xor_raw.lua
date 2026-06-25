local e=require("Modules/Battle/BattleUtil")
local t={
}
local n=t
function t.DoAction(t,a,e)
local o=t:JudgeSkillPreView(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local i=o[4]
local o=#e
for o=1,o do
local o=e[o]
local e=0
ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,a,i,0,e)
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
return n 
