local e={
}
local n=e
function e.DoAction(a,e)
local e=a:JudgeSkillPreView(e)
local o=e[1]
local i=e[2]
local t={e[3],e[4],e[5],e[6],e[7],e[8],e[9],e[10]}
a:AddBuff(a,o,i,t)
local o=e[11]
local i=e[12]
local t={}
for a=13,27 do
table.insert(t,e[a])
end
table.insert(t,1)
table.insert(t,0)
table.insert(t,1)
table.insert(t,0)
a:AddBuff(a,o,i,t)
return nil
end
return n

