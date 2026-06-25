local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local n=e[1]
local i=e[2]
local a={}
for o=3,11 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local a=e[12]
local e=e[13]
t:AddBuff(t,a,e)
return nil
end
return s 
