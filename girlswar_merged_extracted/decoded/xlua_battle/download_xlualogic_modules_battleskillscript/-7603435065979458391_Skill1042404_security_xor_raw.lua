local e={}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[1]
local i=e[2]
local o={e[4]}
t:AddBuff(t,a,i,o,e[3])
local i=e[5]
local o=e[6]
local a={e[7],e[8]}
t:AddBuff(t,i,o,a)
local i=e[9]
local o=e[10]
local a={e[11]}
t:AddBuff(t,i,o,a)
local a=e[12]
local o=e[13]
local i={e[14]}
t:AddBuff(t,a,o,i)
local a=e[15]
local o=e[16]
local e={e[17],e[18]}
t:AddBuff(t,a,o,e)
return nil
end
return n

