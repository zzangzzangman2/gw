local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[1]
local i=e[2]
local a={}
for o=3,8 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
local a=e[9]
local o=e[10]
if a>0 then
t:AddBuff(t,a,o,0)
end
local o=e[11]
local i=e[12]
local a={}
for t=13,14 do
table.insert(a,e[t])
end
table.insert(a,0)
table.insert(a,0)
table.insert(a,0)
t:AddBuff(t,o,i,a)
local o=e[15]
local i=e[16]
local a=math.floor(t.HeroBattleInfo.OriginalHP*e[18]*MillionCoe)
local a={e[17],a}
for t=19,31 do
table.insert(a,e[t])
end
table.insert(a,0)
table.insert(a,0)
t:AddBuff(t,o,i,a)
return nil
end
return n 
