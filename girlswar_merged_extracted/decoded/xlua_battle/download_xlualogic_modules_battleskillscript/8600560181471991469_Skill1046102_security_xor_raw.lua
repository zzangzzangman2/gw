local e={
}
local i=e
function e.DoAction(t,o,e)
local a=t:JudgeSkillPreView(o)
local i=e.skillHurtRate
local a=e.defHeroIds
local e=nil
if a then
local t=a[1]
e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
end
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,i)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return i 
