local e={
}
local o=e
function e.DoAction(e,t)
local a=e:JudgeSkillPreView(t)
local t=false
for o,e in pairs(ModulesInit.ProcedureNormalBattle.HeroDic)do
if(e:GetHeroModelId()==a[1])then
t=true
break
end
end
if(t)then
e:ResetFuryWithBuff(a[2])
end
return nil
end
return o 
