local e={
}
local n=e
function e.DoAction(e,t)
local t=e:JudgeSkillPreView(t)
local n=t[1]
local i=t[2]
local a={}
for o=3,23 do
table.insert(a,t[o])
end
e:AddBuff(e,n,i,a)
local i=t[10]
local o=t[11]
local a=0
e:AddBuff(e,i,o,a)
local o=t[24]
local i=t[25]
local a={}
for e=26,35 do
table.insert(a,t[e])
end
table.insert(a,0)
table.insert(a,0)
e:AddBuff(e,o,i,a)
local t=302108426
local a=-1
local o=0
e:AddBuff(e,t,a,o)
return nil
end
return n 
