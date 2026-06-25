local e={}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4],e[5],e[6]}
t:AddBuff(t,i,o,a)
local a=e[7]
local o=e[8]
local e={e[9],e[10]}
t:AddBuff(t,a,o,e)
return nil
end
return n

