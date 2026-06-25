local e={
}
local i=e
function e.DoAction(e,t)
local t=e:JudgeSkillPreView(t)
local o=t[1]
local a=t[2]
local t={t[3],t[4]}
e:AddBuff(e,o,a,t)
local t=303107329
local a=1
local o={}
e:AddBuff(e,t,a,o)
return nil
end
return i

