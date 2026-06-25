local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for o=3,14 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
if t:IsRealLastRowHero()then
local i=e[15]
local o=e[16]
local a={}
for o=17,21 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
end
return nil
end
return s

