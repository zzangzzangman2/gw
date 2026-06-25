local e=require("Modules/Battle/BattleUtil")
local t={
}
local i=t
function t.DoAction(t,e,a)
local e=t:JudgeSkillPreView(e)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
for n=1,#a do
local o=e[3]
local i=e[4]
local e={e[5],e[6],e[7],e[8]}
a[n]:AddBuff(t,o,i,e)
end
return nil
end
function t.GetCanTriggerSkill(e)
if e==BuffTriggerTime.battleBeginPetHelpSkill then
return true
end
return false
end
function t.DoPassiveAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[1]
local o=e[2]
local e={82001491,e[9],e[10],0}
t:AddBuff(t,a,o,e)
return nil
end
return i 
