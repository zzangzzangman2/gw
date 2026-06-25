local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(t,o,e)
local a=t:JudgeSkillPreView(o)
local i=e.hurtValue
local e=nil
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
if#a<=0 then
e=t
else
local t=RandomTableWithSeed(a,1)
e=t[1]
end
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,0,0,i)
return nil
end
return n 
