local e={
}
local o=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4],e[5],e[6],e[7],e[8],e[9]}
t:AddBuff(t,i,o,a)
t:AddImmunneBuffId(e[10])
t:AddImmunneBuffId(e[11])
local a=e[12]
local e=e[13]
t:AddBuff(t,a,e,0)
return nil
end
return o 
