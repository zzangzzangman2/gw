local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={}
for t=3,16 do
table.insert(a,e[t])
end
table.insert(a,0)
table.insert(a,0)
t:AddBuff(t,i,o,a)
if t:IsRealFirstRowHero()==false then
local i=e[17]
local o=e[18]
local a={}
for o=19,36 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
end
return nil
end
return n 
