local e=require("Modules/Battle/BattleUtil")
local a={
}
local n=a
function a.DoAction(a,e)
local e=a:JudgeSkillPreView(e)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local o=#t
for o=1,o do
local o=t[o]
local i=e[5]
local t=e[6]
local e={e[7],e[8]}
o:AddBuff(a,i,t,e)
end
return nil
end
function a.GetCanTriggerSkill(e)
return false
end
function a.DoPassiveAction(t,a)
local e=t:JudgeSkillPreView(a)
local o=e[1]
local i=e[2]
local e={a.id,e[3],e[4]}
t:AddBuff(t,o,i,e)
return nil
end
return n 
