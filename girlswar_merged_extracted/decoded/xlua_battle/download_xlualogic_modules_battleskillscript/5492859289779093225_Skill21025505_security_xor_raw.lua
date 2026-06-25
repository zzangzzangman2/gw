local e={
}
local s=e
function e.DoAction(e,t)
local t=e:JudgeSkillPreView(t)
local n=t[1]
local i=t[2]
local a={}
for o=3,10 do
table.insert(a,t[o])
end
e:AddBuff(e,n,i,a)
local t=302102513
local a=-1
local o={}
e:AddBuff(e,t,a,o)
return nil
end
return s

