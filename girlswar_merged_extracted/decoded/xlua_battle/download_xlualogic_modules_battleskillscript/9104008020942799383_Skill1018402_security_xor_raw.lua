local e={}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3]}
t:AddBuff(t,i,o,a)
local i=e[4]
local a=e[5]
local o={e[6]}
t:AddBuff(t,i,a,o)
local a=e[7]
local o=e[8]
local e={e[9]}
t:AddBuff(t,a,o,e)
return nil
end
return n

