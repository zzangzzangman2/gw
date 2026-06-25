local e={}
local o=e
function e.DoAction(e,t)
local t=e:JudgeSkillPreView(t)
local a=t[1]
local t=t[2]
local o={}
e:AddBuff(e,a,t,o)
return nil
end
return o

