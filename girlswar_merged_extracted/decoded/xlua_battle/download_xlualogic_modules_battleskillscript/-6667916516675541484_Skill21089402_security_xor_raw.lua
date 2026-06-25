local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local n=e[2]
local a={}
for o=3,25 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
local o=e[26]
local i=e[27]
local a={}
for t=28,32 do
table.insert(a,e[t])
end
table.insert(a,0)
t:AddBuff(t,o,i,a)
return nil
end
return s 
