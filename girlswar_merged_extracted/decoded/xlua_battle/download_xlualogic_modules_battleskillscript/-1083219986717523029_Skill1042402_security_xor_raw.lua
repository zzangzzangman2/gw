local e={}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[4]}
t:AddBuff(t,i,o,a,e[3])
local i=e[5]
local a=e[6]
local o={e[7],e[8]}
t:AddBuff(t,i,a,o)
local a=e[9]
local o=e[10]
local e={e[11],e[12]}
t:AddBuff(t,a,o,e)
return nil
end
return n

