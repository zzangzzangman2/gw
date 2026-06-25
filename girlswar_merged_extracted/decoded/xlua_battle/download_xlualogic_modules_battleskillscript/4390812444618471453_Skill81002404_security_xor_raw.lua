local e=require("Modules/Battle/BattleUtil")
local o={
}
local n=o
function o.DoAction(a,e)
local e=a:JudgeSkillPreView(e)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local o=#t
for o=1,o do
local t=t[o]
local n=e[5]
local o=e[6]
local i={e[7],e[8]}
t:AddBuff(a,n,o,i)
local i=e[9]
local o=e[10]
local e={e[11],e[12]}
t:AddBuff(a,i,o,e)
end
return nil
end
function o.GetCanTriggerSkill(e)
return false
end
function o.DoPassiveAction(t,a)
local e=t:JudgeSkillPreView(a)
local o=e[1]
local i=e[2]
local e={a.id,e[3],e[4]}
t:AddBuff(t,o,i,e)
return nil
end
return n 
