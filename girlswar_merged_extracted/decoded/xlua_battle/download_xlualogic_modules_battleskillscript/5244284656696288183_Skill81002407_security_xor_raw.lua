local e=require("Modules/Battle/BattleUtil")
local o={
}
local n=o
function o.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local o=#a
for o=1,o do
local a=a[o]
local i=e[5]
local n=e[6]
local o={e[7],e[8]}
a:AddBuff(t,i,n,o)
local n=e[9]
local i=e[10]
local o={e[11],e[12]}
a:AddBuff(t,n,i,o)
local o=e[13]
local i=e[14]
local e={e[15],e[16]}
a:AddBuff(t,o,i,e)
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
