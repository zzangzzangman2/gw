local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(e,t)
local t=e:JudgeSkillPreView(t)
local n=t[1]
local i=t[2]
local a={}
for o=3,23 do
table.insert(a,t[o])
end
e:AddBuff(e,n,i,a)
local i=t[10]
local o=t[11]
local a=0
e:AddBuff(e,i,o,a)
local i=t[24]
local o=t[25]
local a={}
for e=26,35 do
table.insert(a,t[e])
end
table.insert(a,0)
table.insert(a,0)
e:AddBuff(e,i,o,a)
local a=302108426
local o=-1
local t=0
e:AddBuff(e,a,o,t)
return nil
end
return n 
