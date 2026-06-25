local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[1]
local o=e[2]
local i={e[3],e[4]}
t:AddBuff(t,a,o,i)
local a=e[5]
local o=e[6]
t:AddBuff(t,a,o,0)
local n=e[7]
local i=e[8]
local a={}
for o=9,16 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local o=e[17]
local i=e[18]
local a={}
for o=19,27 do
table.insert(a,e[o])
end
t:AddBuff(t,o,i,a)
local i=e[28]
local o=e[29]
local a={}
for o=30,41 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
local a=e[42]
local e=e[43]
t:AddBuff(t,a,e,0)
return nil
end
return s

