local e={
}
local n=e
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
local a=e[4]
local i=e[5]
local o={e[6]}
t:AddBuff(t,a,i,o)
local a=e[7]
local o=e[8]
local e={e[9],e[10]}
t:AddBuff(t,a,o,e)
return nil
end
return n 
