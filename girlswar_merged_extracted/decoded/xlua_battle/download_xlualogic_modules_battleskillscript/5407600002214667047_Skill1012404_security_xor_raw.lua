local e={}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4],e[5],e[6],e[7],e[8],e[9]}
t:AddBuff(t,i,o,a)
local a=e[10]
local o=e[11]
local e={e[12]}
t:AddBuff(t,a,o,e)
return nil
end
return n

