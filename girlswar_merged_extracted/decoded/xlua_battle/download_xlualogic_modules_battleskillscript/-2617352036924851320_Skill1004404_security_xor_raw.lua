local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3]}
t:AddBuff(t,i,o,a)
local a=e[4]
local o=e[5]
local e={e[6],e[7],e[8],e[9]}
t:AddBuff(t,a,o,e)
return nil
end
return n 
