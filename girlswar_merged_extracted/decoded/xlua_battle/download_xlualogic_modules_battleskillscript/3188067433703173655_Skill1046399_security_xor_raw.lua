local e={
}
local n=e
function e.DoAction(t,a,e)
local o=t:JudgeSkillPreView(a)
local n=0
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
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,n,0,i)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
