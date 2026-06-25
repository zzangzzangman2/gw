local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4]}
t:AddBuff(t,i,o,a)
local a=e[5]
local o=e[6]
local e={e[7],e[8]}
t:AddBuff(t,a,o,e)
return nil
end
return n

