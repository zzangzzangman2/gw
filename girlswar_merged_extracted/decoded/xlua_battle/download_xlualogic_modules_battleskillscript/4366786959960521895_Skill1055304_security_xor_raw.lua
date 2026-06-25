local e=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.DoAction(a,t,o,e)
local o=a:JudgeSkillPreView(t)
local n=e.skillHurtRate
local i=e.realHurt
local o=e.defHeroIds
local e=nil
if o then
local t=o[1]
e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
end
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,t,n,nil,i)
return nil
end
return s

