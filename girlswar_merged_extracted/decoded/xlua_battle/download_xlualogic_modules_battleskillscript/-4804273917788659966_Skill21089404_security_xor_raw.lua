local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for o=3,25 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local i=e[26]
local o=e[27]
local a={}
for t=28,32 do
table.insert(a,e[t])
end
table.insert(a,0)
t:AddBuff(t,i,o,a)
return nil
end
return s 
