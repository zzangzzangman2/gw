local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(e,a)
local o=e:JudgeSkillPreView(a)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eBackMinHpPercentWithCount)
local t=t[1]
if(t==nil)then
return nil
end
local i=o[4]
local o=nil
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,i,0,0,o)
return nil
end
function e.GetCanTriggerSkill(e)
return false
end
function e.DoPassiveAction(t,a)
local e=t:JudgeSkillPreView(a)
local o=e[1]
local i=e[2]
local e={a.id,e[3]}
t:AddBuff(t,o,i,e)
return nil
end
return n 
