local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
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
local o=e[10]
local a={}
for o=11,19 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
local n=e[20]
local i=e[21]
local a={}
for o=22,24 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local i=e[25]
local a=e[26]
local o={e[27]}
t:AddBuff(t,i,a,o)
if t.battleStationRow==2 then
local a=e[28]
local o=e[29]
local e={e[30],e[31],e[32]}
t:AddBuff(t,a,o,e)
end
return nil
end
return s 
