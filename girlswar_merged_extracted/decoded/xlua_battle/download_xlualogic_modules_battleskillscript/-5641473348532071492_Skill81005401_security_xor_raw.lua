local e=require("Modules/Battle/BattleUtil")
local t={
}
local i=t
function t.DoAction(t,a,e)
local o=t:JudgeSkillPreView(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFront)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local n=o[3]
local i=#e
for i=1,i do
local e=e[i]
e.HeroBattleInfo:DispelGranBuff(true,o[4])
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,n)
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
return i 
