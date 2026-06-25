local e={
}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={}
for t=11,28 do
table.insert(a,e[t])
end
table.insert(a,0)
t:AddBuff(t,i,o,a)
if t.battleStationRow==1 then
local i=e[3]
local o=e[4]
local a={}
for o=5,10 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
end
return nil
end
return n 
