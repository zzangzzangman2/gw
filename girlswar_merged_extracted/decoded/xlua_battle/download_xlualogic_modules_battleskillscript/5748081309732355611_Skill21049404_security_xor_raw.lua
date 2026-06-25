local e={
}
local n=e
function e.DoAction(e,t)
local a=e:JudgeSkillPreView(t)
local t=e:JudgeSkillPreView(t)
local i=t[1]
local o=t[2]
local a={}
for o=3,14 do
table.insert(a,t[o])
end
e:AddBuff(e,i,o,a)
return nil
end
return n 
