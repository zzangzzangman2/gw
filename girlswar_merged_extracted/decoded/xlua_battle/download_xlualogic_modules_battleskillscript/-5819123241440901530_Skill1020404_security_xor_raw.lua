local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4],e[5],e[6],e[7],e[8],e[9],e[10],e[11],e[12],e[13]}
t:AddBuff(t,i,o,a)
local a=e[14]
local o=e[15]
local e={e[16],e[17],e[18],e[19],e[20]}
t:AddBuff(t,a,o,e)
return nil
end
return n 
