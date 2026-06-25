local e={
}
local o=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=false
for o,t in pairs(ModulesInit.ProcedureNormalBattle.HeroDic)do
if(t:GetHeroModelId()==e[1])then
a=true
break
end
end
if(a)then
local a=e[2]
local e=e[3]
t:AddBuff(t,a,e,0)
end
return nil
end
return o 
