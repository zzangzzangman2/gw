local e={}
local n=e
function e.DoAction(o,a,e,t)
local i=o:JudgeSkillPreView(a)
local i=t.realhurt
local t=e
local e=nil
if t then
e=t[1]
end
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(o,e,a,0,nil,i)
return nil
end
return n

