local e={}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3]}
t:AddBuff(t,i,o,a)
local i=e[4]
local o=e[5]
local a={e[6]}
t:AddBuff(t,i,o,a)
local o=e[7]
local i=e[8]
local a={e[9]}
t:AddBuff(t,o,i,a)
local a=e[10]
local o=e[11]
local e={e[12],e[13]}
t:AddBuff(t,a,o,e)
return nil
end
return n

