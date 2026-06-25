local e={
}
local i=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[1]
local i=e[2]
local a={}
for o=3,11 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
local n=e[12]
local i=e[13]
local a={}
for o=14,23 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local a=e[24]
local o=e[25]
local e={e[26],e[27],e[28]}
t:AddBuff(t,a,o,e)
return nil
end
return i

