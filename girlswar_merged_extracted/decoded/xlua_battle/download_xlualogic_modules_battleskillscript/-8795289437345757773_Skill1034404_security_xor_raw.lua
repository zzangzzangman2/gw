local e={}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4],e[5],e[6]}
t:AddBuff(t,i,o,a)
local i=e[7]
local a=e[8]
local o={e[9],e[10]}
t:AddBuff(t,i,a,o)
local a=e[11]
local o=e[12]
local e={e[13],e[14]}
t:AddBuff(t,a,o,e)
return nil
end
return n

