local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4],e[5],e[6],e[7],e[8],e[9],e[10]}
t:AddBuff(t,i,o,a)
local i=e[11]
local a=e[12]
local o={e[13],e[14],e[15],e[16],e[17],e[18],e[19],e[20],e[21],0}
t:AddBuff(t,i,a,o)
local a=e[22]
local o=e[23]
local e={e[24],e[25],e[26],e[27],e[28],e[29],e[30],e[31]}
t:AddBuff(t,a,o,e)
return nil
end
return n

