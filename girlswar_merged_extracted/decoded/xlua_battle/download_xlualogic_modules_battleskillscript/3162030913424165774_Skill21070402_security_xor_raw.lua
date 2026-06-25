local e=require("Modules/Battle/BattleUtil")
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
local i=e[15]
local n=e[16]
local a={}
for o=17,24 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
local o=e[25]
local i=e[26]
local a={}
for o=27,28 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
local n=e[29]
local i=e[30]
local a={}
for o=31,41 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
return nil
end
return s

