local e=require("Modules/Battle/BattleUtil")
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
local i=e[9]
local n=e[10]
local a={}
for o=11,19 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
local o=e[20]
local i=e[21]
local a={}
for o=22,24 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
local a=e[25]
local o=e[26]
local e={e[27]}
t:AddBuff(t,a,o,e)
return nil
end
return n

