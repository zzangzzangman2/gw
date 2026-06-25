local e={}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[1]
local i=e[2]
local a={e[3],e[4]}
t:AddBuff(t,o,i,a)
local o=e[5]
local i=e[6]
local a=e[9]
local e={e[7],e[8],a,0,{},0,0,-1,{},0}
t:AddBuff(t,o,i,e,a)
end
return n

