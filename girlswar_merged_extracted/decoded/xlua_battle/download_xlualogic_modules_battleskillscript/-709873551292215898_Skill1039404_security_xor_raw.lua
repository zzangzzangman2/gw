local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4],e[5],e[6],e[7],e[8],e[9],e[10]}
t:AddBuff(t,i,o,a)
if t.BigSkillId==e[11]then
local a=e[12]
local o=e[13]
local e={e[14],e[15],e[16],e[17]}
t:AddBuff(t,a,o,e)
end
return nil
end
return n 
