local e={}
local o=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[1]
local o=e[2]
local e={e[3],e[4]}
t:AddBuff(t,a,o,e)
end
return o

