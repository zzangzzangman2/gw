local e=require("Modules/Battle/BattleUtil")
local t={
}
local n=t
function t.DoAction(a,e,t)
local e=a:JudgeSkillPreView(e)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.ourAll)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
local o=RandomTableWithSeed(t,e[4])
local n=e[1]
local i=e[2]
local t={e[3]}
if#e>=6 then
table.insert(t,e[5])
table.insert(t,e[6])
end
for e=1,#o do
o[e]:AddBuff(a,n,i,t)
end
return nil
end
function t.GetCanTriggerSkill(e)
if e==BuffTriggerTime.battleBeginPetHelpSkill then
return true
end
return false
end
function t.DoPassiveAction(e,t)
local e=e:JudgeSkillPreView(t)
return nil
end
return n 
