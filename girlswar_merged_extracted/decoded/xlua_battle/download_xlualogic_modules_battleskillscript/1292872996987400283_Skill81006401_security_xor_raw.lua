local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(t,a,e)
local o=t:JudgeSkillPreView(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(e==nil)then
return nil
end
local e={e}
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
function e.GetCanTriggerSkill(e)
return false
end
function e.DoPassiveAction(t,a)
local e=t:JudgeSkillPreView(a)
local o=e[1]
local i=e[2]
local e={a.id,e[3],0}
t:AddBuff(t,o,i,e)
return nil
end
return n 
