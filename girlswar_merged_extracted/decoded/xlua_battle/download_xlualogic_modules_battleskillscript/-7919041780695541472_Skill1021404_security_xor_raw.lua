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
t:ResetFuryWithBuff(e[2])
end
local i=e[3]
local o=e[4]
local a={e[5]}
t:AddBuff(t,i,o,a)
local a=e[6]
local o=e[7]
local e={e[8],e[9]}
t:AddBuff(t,a,o,e)
return nil
end
return n 
