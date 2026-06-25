local e=require("Modules/Battle/BattleUtil")
local t={
}
local n=t
function t.DoAction(t,a,e)
local o=t:JudgeSkillPreView(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e==nil or#e<=0)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local i=o[5]
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
local o=t[1]
local i=t[2]
local e={e.id}
for a=3,4 do
if t[a]then
table.insert(e,t[a])
else
table.insert(e,0)
end
end
table.insert(e,0)
a:AddBuff(a,o,i,e)
return nil
end
return n 
