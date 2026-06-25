local e={}
local h=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={e[3]}
local o=e[4]
local s=e[5]
local e={e[6]}
t:AddBuff(t,n,i,a)
t:AddBuff(t,o,s,e)
return nil
end
return h

